Return-Path: <linux-kernel-owner+w=401wt.eu-S934515AbXEHHmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934515AbXEHHmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 03:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934134AbXEHHmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 03:42:22 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:41656 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934414AbXEHHmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 03:42:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type;
  b=BGtlQ/sSMmf6wmYCc98EkQIuaamGVbKEhcUf2MsbpRK0BfPfRSjKdO5hSZ/k2D17xSOxo4PvxC0WcEj8K+IFldaoZvg+/L61FmAxURa3mDSYVSejHAdM5sZvB7o3iqPBOvC+HBYH3tuVxSubcGNBzI3o2HAb/PMQuHOVRn5AHMw=  ;
X-YMail-OSG: VsSEvIwVM1l2FEhP3dhqoi8mbQt8tJRLIQltWkV0z7hTH10oVti1ToomrMJB._h5zxFKp2nrLg--
Message-ID: <464029C2.1020003@yahoo.com.au>
Date: Tue, 08 May 2007 17:41:54 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: get_user_pages vs mmap MAP_FIXED bug
References: <1178434876.12284.175.camel@localhost.localdomain>	<1178501204.7731.35.camel@localhost.localdomain> <20070506202225.ba6476b6.akpm@linux-foundation.org>
In-Reply-To: <20070506202225.ba6476b6.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------020304050300010008000406"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020304050300010008000406
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Andrew Morton wrote:
> On Mon, 07 May 2007 11:26:44 +1000 Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> 
>>On Sun, 2007-05-06 at 17:01 +1000, Rusty Russell wrote:
>>
>>>This bug is in 2.6.21-rc7-mm2, but not 2.6.21.  Haven't tested
>>>2.6.21-mm1 yet.
>>
>>OK, 2.6.21-mm1 fails too.  2.6.21-git6 ... is fine.
>>
>>Here's a standalone test using ptrace.  No kernel module req'd.
>>
>>	rusty@debussy:~/linux-2.6.21-mm1$ ../examiner 
>>	ptrace says 0, child says 0x464c457f
> 
> 
> thanks.
> 
> 
>>Any clues Andrew?  Or should I take your patches and do a binary search?
> 
> 
> I've been assuming that Nick's vm_operations.fault changes have broken
> get_user_pages()'s manual faulting.  The next step is to wait for Nick to
> turn up.

Fancy that! Thanks for catching it Rusty, does the following work for
you?

-- 
SUSE Labs, Novell Inc.

--------------020304050300010008000406
Content-Type: text/plain;
 name="mm-fix-for-fault.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mm-fix-for-fault.patch"

Fix a couple of places that should be testing fault as well as nopage.

Signed-off-by: Nick Piggin <npiggin@suse.de>

Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c	2007-04-24 15:02:51.000000000 +1000
+++ linux-2.6/mm/memory.c	2007-05-08 15:23:55.000000000 +1000
@@ -1049,7 +1049,8 @@
 		if (pages)
 			foll_flags |= FOLL_GET;
 		if (!write && !(vma->vm_flags & VM_LOCKED) &&
-		    (!vma->vm_ops || !vma->vm_ops->nopage))
+		    (!vma->vm_ops || (!vma->vm_ops->nopage &&
+					!vma->vm_ops->fault)))
 			foll_flags |= FOLL_ANON;
 
 		do {
Index: linux-2.6/mm/rmap.c
===================================================================
--- linux-2.6.orig/mm/rmap.c	2007-04-24 08:53:50.000000000 +1000
+++ linux-2.6/mm/rmap.c	2007-05-08 15:24:27.000000000 +1000
@@ -640,8 +640,10 @@
 			printk (KERN_EMERG "  page->count = %x\n", page_count(page));
 			printk (KERN_EMERG "  page->mapping = %p\n", page->mapping);
 			print_symbol (KERN_EMERG "  vma->vm_ops = %s\n", (unsigned long)vma->vm_ops);
-			if (vma->vm_ops)
+			if (vma->vm_ops) {
 				print_symbol (KERN_EMERG "  vma->vm_ops->nopage = %s\n", (unsigned long)vma->vm_ops->nopage);
+				print_symbol (KERN_EMERG "  vma->vm_ops->fault = %s\n", (unsigned long)vma->vm_ops->fault);
+			}
 			if (vma->vm_file && vma->vm_file->f_op)
 				print_symbol (KERN_EMERG "  vma->vm_file->f_op->mmap = %s\n", (unsigned long)vma->vm_file->f_op->mmap);
 			BUG();

--------------020304050300010008000406--
