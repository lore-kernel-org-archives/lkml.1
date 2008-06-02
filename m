Return-Path: <linux-kernel-owner+w=401wt.eu-S1755772AbYFBXp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbYFBXp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 19:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbYFBXpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 19:45:16 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:46892 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbYFBXpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 19:45:14 -0400
Date: Tue, 3 Jun 2008 00:44:38 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Arjan van de Ven <arjan@linux.intel.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: Top kernel oopses/warnings for the week of May 30th 2008
In-Reply-To: <Pine.LNX.4.64.0805302017580.16427@blonde.site>
Message-ID: <Pine.LNX.4.64.0806030000110.9919@blonde.site>
References: <48402DAA.60202@linux.intel.com> <Pine.LNX.4.64.0805302017580.16427@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2008, Hugh Dickins wrote:
> On Fri, 30 May 2008, Arjan van de Ven wrote:
> > 
> > Rank 7: set_page_address (oops)
> > 	Reported 53 times (65 total reports)
> > 	crash coming from flush_all_zero_pkmaps; was this fixed by Hugh the
> > 	other day?
> 
> No, not at all.  But I'll have a little ponder over it.
> 
> > 	This oops was last seen in version 2.6.25.3, and first seen in 2.6.25.
> > 	More info:
> > 	http://www.kerneloops.org/searchweek.php?search=set_page_address

Though I've spent quite a while poring over it, I regret to say I
haven't got much beyond the obvious with this BUG_ON(!PageHighMem)
in set_page_address() called from flush_all_zero_pkmaps().

It appears to be a corruption of the start of the pkmap_page_table,
but not a random corruption: entries of the form 0x378xxxxx through
0x37Bxxxxxx where they need to be 0x38xxxxxx or more to be highmem.
(I say appears because the compiler is reusing %eax a lot, there's
no trace on the stack or in registers of what pte was actually read.)

In every case except the 17141 nfsd one, it's found at the start of
the table, when flush_all_zero_pkmaps() is called for the very first
time (I'm guessing that from the fact that they're all failing on the
second entry, which preincrementation of the index made the first one
used).  Whereas 17141 nfsd finds a 0x00000xxx some way into the page
table, quite possibly later on: may have a very different cause.

Do we have any idea whether all or most of these come from a single
machine?  That would of course be a very different (less interesting)
story from if they're spread out over lots of machines.

I didn't notice anything suspicious in the Fedora patches to 2.6.25,
but I haven't heard (Google hasn't shown) any such problem outside
of these kerneloops from Fedora 9.  Is it showing up on Rawhide at
all?  If so, then we could devise some debug to include in coming
kernels to help shed more light on it.

Veering off at a tangent away from the oops: I was rather sobered
to see all those traces of execve using kmap, I thought we were
avoiding kmap like BKL in common paths these days (though it is
convenient for symlinks).  Would a patch something like that
below, copying the filemap.c trick, be welcome?

Hugh

--- 2.6.26-rc4/fs/exec.c	2008-05-26 20:00:39.000000000 +0100
+++ linux/fs/exec.c	2008-06-02 11:18:32.000000000 +0100
@@ -33,6 +33,7 @@
 #include <linux/string.h>
 #include <linux/init.h>
 #include <linux/pagemap.h>
+#include <linux/hardirq.h>
 #include <linux/highmem.h>
 #include <linux/spinlock.h>
 #include <linux/key.h>
@@ -396,7 +397,7 @@ static int copy_strings(int argc, char _
 {
 	struct page *kmapped_page = NULL;
 	char *kaddr = NULL;
-	unsigned long kpos = 0;
+	unsigned long kpos = ~PAGE_MASK;
 	int ret;
 
 	while (argc-- > 0) {
@@ -436,28 +437,38 @@ static int copy_strings(int argc, char _
 			str -= bytes_to_copy;
 			len -= bytes_to_copy;
 
-			if (!kmapped_page || kpos != (pos & PAGE_MASK)) {
-				struct page *page;
-
-				page = get_arg_page(bprm, pos, 1);
-				if (!page) {
-					ret = -E2BIG;
-					goto out;
-				}
-
+			if (kpos != (pos & PAGE_MASK)) {
 				if (kmapped_page) {
 					flush_kernel_dcache_page(kmapped_page);
-					kunmap(kmapped_page);
+					if (in_atomic())
+						kunmap_atomic(kaddr, KM_USER0);
+					else
+						kunmap(kmapped_page);
 					put_arg_page(kmapped_page);
 				}
-				kmapped_page = page;
-				kaddr = kmap(kmapped_page);
+				kmapped_page = get_arg_page(bprm, pos, 1);
+				if (!kmapped_page) {
+					ret = -E2BIG;
+					goto out;
+				}
+				kaddr = kmap_atomic(kmapped_page, KM_USER0);
 				kpos = pos & PAGE_MASK;
 				flush_arg_page(bprm, kpos, kmapped_page);
 			}
-			if (copy_from_user(kaddr+offset, str, bytes_to_copy)) {
-				ret = -EFAULT;
-				goto out;
+			if (in_atomic()) {
+				if (need_resched() ||
+				    __copy_from_user_inatomic(kaddr + offset,
+							str, bytes_to_copy)) {
+					kunmap_atomic(kaddr, KM_USER0);
+					kaddr = kmap(kmapped_page);
+				}
+			}
+			if (!in_atomic()) {
+				if (copy_from_user(kaddr + offset,
+							str, bytes_to_copy)) {
+					ret = -EFAULT;
+					goto out;
+				}
 			}
 		}
 	}
@@ -465,7 +476,10 @@ static int copy_strings(int argc, char _
 out:
 	if (kmapped_page) {
 		flush_kernel_dcache_page(kmapped_page);
-		kunmap(kmapped_page);
+		if (in_atomic())
+			kunmap_atomic(kaddr, KM_USER0);
+		else
+			kunmap(kmapped_page);
 		put_arg_page(kmapped_page);
 	}
 	return ret;
