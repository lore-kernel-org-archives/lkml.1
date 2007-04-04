Return-Path: <linux-kernel-owner+w=401wt.eu-S2992564AbXDDEJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992564AbXDDEJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 00:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934061AbXDDEBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 00:01:41 -0400
Received: from ozlabs.org ([203.10.76.45]:49607 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934057AbXDDEBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 00:01:38 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-arch@vger.kernel.org>, Linux Memory Management <linux-mm@kvack.org>,
       <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Wed, 04 Apr 2007 14:01:26 +1000
Subject: [PATCH 1/14] get_unmapped_area handles MAP_FIXED on powerpc
In-Reply-To: <1175659285.929428.835270667964.qpush@grosgo>
Message-Id: <20070404040137.85313DDE3B@ozlabs.org>
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
 
