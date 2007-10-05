Return-Path: <linux-kernel-owner+w=401wt.eu-S1760452AbXJEKoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760452AbXJEKoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 06:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbXJEKny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 06:43:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:1580 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbXJEKnx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 06:43:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=R3ULDSSysRJL/G+dzTaJZB2nywgsMbrm7u+X7dF5+xz2vUbIZdF/LjmqHkljaSxTKxqTX1hCxR2wzpsE+nvKkCEH5x1vQAzlzB/TFtYQVTfKztTMCTGhTgKwUVlXYvrsX7+jD7pUiejQQjgYVgLegXGQtzH/udv1on89v0Z+i3w=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Add more info to /proc/$pid/smaps
Date: Fri, 5 Oct 2007 12:43:43 +0200
User-Agent: KMail/1.9.6
References: <200710051242.41867.maximlevitsky@gmail.com>
In-Reply-To: <200710051242.41867.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200710051243.43222.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 145247b8e776b32c9930018ab65bb6c5401e28ef Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Fri, 5 Oct 2007 08:04:03 +0200
Subject: [PATCH] Add more statistics to /proc/$pid/smaps

Add amount of swapped memory and amount of anonymous memory
to /proc/$pid/smaps

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 fs/proc/task_mmu.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index c24d81a..1c16a7e 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -122,6 +122,9 @@ struct mem_size_stats
 	unsigned long private_clean;
 	unsigned long private_dirty;
 	unsigned long referenced;
+	unsigned long swapped;
+	unsigned long anon;
+
 };
 
 struct pmd_walker {
@@ -195,6 +198,8 @@ static int show_map_internal(struct seq_file *m, void *v, struct mem_size_stats
 		seq_printf(m,
 			   "Size:           %8lu kB\n"
 			   "Rss:            %8lu kB\n"
+			   "Swapped:        %8lu kB\n"
+			   "Anonymous:      %8lu kB\n"
 			   "Shared_Clean:   %8lu kB\n"
 			   "Shared_Dirty:   %8lu kB\n"
 			   "Private_Clean:  %8lu kB\n"
@@ -202,6 +207,8 @@ static int show_map_internal(struct seq_file *m, void *v, struct mem_size_stats
 			   "Referenced:     %8lu kB\n",
 			   (vma->vm_end - vma->vm_start) >> 10,
 			   mss->resident >> 10,
+			   mss->swapped >> 10,
+			   mss->anon >> 10,
 			   mss->shared_clean  >> 10,
 			   mss->shared_dirty  >> 10,
 			   mss->private_clean >> 10,
@@ -230,15 +237,22 @@ static void smaps_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
 		ptent = *pte;
-		if (!pte_present(ptent))
-			continue;
+		if (!pte_present(ptent)) {
 
+			if(pte_none(ptent) || pte_file(ptent))
+				continue;
+			mss->swapped += PAGE_SIZE;
+			continue;
+		}
 		mss->resident += PAGE_SIZE;
 
 		page = vm_normal_page(vma, addr, ptent);
 		if (!page)
 			continue;
 
+		if(PageAnon(page))
+			mss->anon += PAGE_SIZE;
+
 		/* Accumulate the size in pages that have been accessed. */
 		if (pte_young(ptent) || PageReferenced(page))
 			mss->referenced += PAGE_SIZE;
-- 
1.5.2.5

