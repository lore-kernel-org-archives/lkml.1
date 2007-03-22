Return-Path: <linux-kernel-owner+w=401wt.eu-S965780AbXCVGFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965780AbXCVGFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 02:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965820AbXCVGE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 02:04:56 -0400
Received: from ozlabs.org ([203.10.76.45]:57968 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965824AbXCVGEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 02:04:07 -0400
To: Linux Memory Management <linux-mm@kvack.org>
CC: <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 22 Mar 2007 17:01:30 +1100
Subject: [RFC/PATCH 14/15] get_unmapped_area handles MAP_FIXED in generic code 
In-Reply-To: <1174543217.531981.572863804039.qpush@grosgo>
Message-Id: <20070322060304.296A2DDF86@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 mm/mmap.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

Index: linux-cell/mm/mmap.c
===================================================================
--- linux-cell.orig/mm/mmap.c	2007-03-22 16:29:22.000000000 +1100
+++ linux-cell/mm/mmap.c	2007-03-22 16:30:06.000000000 +1100
@@ -1199,6 +1199,9 @@ arch_get_unmapped_area(struct file *filp
 	if (len > TASK_SIZE)
 		return -ENOMEM;
 
+	if (flags & MAP_FIXED)
+		return addr;
+
 	if (addr) {
 		addr = PAGE_ALIGN(addr);
 		vma = find_vma(mm, addr);
@@ -1272,6 +1275,9 @@ arch_get_unmapped_area_topdown(struct fi
 	if (len > TASK_SIZE)
 		return -ENOMEM;
 
+	if (flags & MAP_FIXED)
+		return addr;
+
 	/* requesting a specific address */
 	if (addr) {
 		addr = PAGE_ALIGN(addr);
@@ -1360,22 +1366,21 @@ get_unmapped_area(struct file *file, uns
 		unsigned long pgoff, unsigned long flags)
 {
 	unsigned long ret;
+	unsigned long (*get_area)(struct file *, unsigned long,
+				  unsigned long, unsigned long, unsigned long);
 
-	if (!(flags & MAP_FIXED)) {
-		unsigned long (*get_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
-
-		get_area = current->mm->get_unmapped_area;
-		if (file && file->f_op && file->f_op->get_unmapped_area)
-			get_area = file->f_op->get_unmapped_area;
-		addr = get_area(file, addr, len, pgoff, flags);
-		if (IS_ERR_VALUE(addr))
-			return addr;
-	}
+	get_area = current->mm->get_unmapped_area;
+	if (file && file->f_op && file->f_op->get_unmapped_area)
+		get_area = file->f_op->get_unmapped_area;
+	addr = get_area(file, addr, len, pgoff, flags);
+	if (IS_ERR_VALUE(addr))
+		return addr;
 
 	if (addr > TASK_SIZE - len)
 		return -ENOMEM;
 	if (addr & ~PAGE_MASK)
 		return -EINVAL;
+
 	if (file && is_file_hugepages(file))  {
 		/*
 		 * Check if the given range is hugepage aligned, and
