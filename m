Return-Path: <linux-kernel-owner+w=401wt.eu-S965778AbXCVGCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965778AbXCVGCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 02:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965780AbXCVGCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 02:02:00 -0400
Received: from ozlabs.org ([203.10.76.45]:41765 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965778AbXCVGB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 02:01:59 -0400
To: Linux Memory Management <linux-mm@kvack.org>
CC: <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 22 Mar 2007 17:00:21 +1100
Subject: [RFC/PATCH 1/15] get_unmapped_area handles MAP_FIXED on powerpc
In-Reply-To: <1174543217.531981.572863804039.qpush@grosgo>
Message-Id: <20070322060158.B383FDDF2F@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 arch/powerpc/mm/hugetlbpage.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

Index: linux-cell/arch/powerpc/mm/hugetlbpage.c
===================================================================
--- linux-cell.orig/arch/powerpc/mm/hugetlbpage.c	2007-03-22 14:52:07.000000000 +1100
+++ linux-cell/arch/powerpc/mm/hugetlbpage.c	2007-03-22 14:57:40.000000000 +1100
@@ -572,6 +572,13 @@ unsigned long arch_get_unmapped_area(str
 	if (len > TASK_SIZE)
 		return -ENOMEM;
 
+	/* handle fixed mapping: prevent overlap with huge pages */
+	if (flags & MAP_FIXED) {
+		if (is_hugepage_only_range(mm, addr, len))
+			return -EINVAL;
+		return addr;
+	}
+
 	if (addr) {
 		addr = PAGE_ALIGN(addr);
 		vma = find_vma(mm, addr);
@@ -647,6 +654,13 @@ arch_get_unmapped_area_topdown(struct fi
 	if (len > TASK_SIZE)
 		return -ENOMEM;
 
+	/* handle fixed mapping: prevent overlap with huge pages */
+	if (flags & MAP_FIXED) {
+		if (is_hugepage_only_range(mm, addr, len))
+			return -EINVAL;
+		return addr;
+	}
+
 	/* dont allow allocations above current base */
 	if (mm->free_area_cache > base)
 		mm->free_area_cache = base;
@@ -829,6 +843,13 @@ unsigned long hugetlb_get_unmapped_area(
 	/* Paranoia, caller should have dealt with this */
 	BUG_ON((addr + len)  < addr);
 
+	/* Handle MAP_FIXED */
+	if (flags & MAP_FIXED) {
+		if (prepare_hugepage_range(addr, len, pgoff))
+			return -EINVAL;
+		return addr;
+	}
+
 	if (test_thread_flag(TIF_32BIT)) {
 		curareas = current->mm->context.low_htlb_areas;
 
