Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbXIMLro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbXIMLro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 07:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbXIMLrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 07:47:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42693 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751291AbXIMLrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 07:47:36 -0400
Date: Thu, 13 Sep 2007 04:47:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-mm@kvack.org,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc4-mm1: deadlock while mmaping video device
Message-Id: <20070913044726.1aa48f45.akpm@linux-foundation.org>
In-Reply-To: <46E9226F.9010700@gmail.com>
References: <46E9226F.9010700@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007 13:43:43 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:

> Hi,
> 
> I have this circular lock dependency on 2.6.23-rc4-mm1 when opening
> /dev/video0 and mmaping it. the v4l driver is stk11xx:
> http://www.fi.muni.cz/~xslaby/sklad/panics/mm-deadlock.png
> 
> Using slub on x86_64 if that matters.
> 
> For now, I'm unable to set up a netconsole, so only the picture linked above
> is the best I have.
> 

oop, I think you'll want this:

--- a/mm/memory.c~memory-controller-memory-accounting-v7-fix
+++ a/mm/memory.c
@@ -1135,7 +1135,7 @@ static int insert_page(struct mm_struct 
 {
 	int retval;
 	pte_t *pte;
-	spinlock_t *ptl;  
+	spinlock_t *ptl;
 
 	retval = mem_container_charge(page, mm);
 	if (retval)
@@ -1160,6 +1160,7 @@ static int insert_page(struct mm_struct 
 	set_pte_at(mm, addr, pte, mk_pte(page, prot));
 
 	retval = 0;
+	pte_unmap_unlock(pte, ptl);
 	return retval;
 out_unlock:
 	pte_unmap_unlock(pte, ptl);
@@ -2184,8 +2185,8 @@ static int do_anonymous_page(struct mm_s
 	if (!page)
 		goto oom;
 
-		if (mem_container_charge(page, mm))
-			goto oom_free_page;
+	if (mem_container_charge(page, mm))
+		goto oom_free_page;
 
 	entry = mk_pte(page, vma->vm_page_prot);
 	entry = maybe_mkwrite(pte_mkdirty(entry), vma);
_

