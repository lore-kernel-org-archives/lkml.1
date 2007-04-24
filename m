Return-Path: <linux-kernel-owner+w=401wt.eu-S1161627AbXDXFdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161627AbXDXFdj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 01:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161629AbXDXFdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 01:33:38 -0400
Received: from ozlabs.org ([203.10.76.45]:35012 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161612AbXDXFdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 01:33:37 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 24 Apr 2007 15:33:34 +1000
Subject: [PATCH 1/12] get_unmapped_area handles MAP_FIXED on powerpc
In-Reply-To: <1177392813.924664.32930750763.qpush@grosgo>
Message-Id: <20070424053336.C23A6DDF06@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Handle MAP_FIXED in powerpc's arch_get_unmapped_area() in all 3
implementations of it.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: William Irwin <bill.irwin@oracle.com>

 arch/powerpc/mm/hugetlbpage.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

Index: linux-cell/arch/powerpc/mm/hugetlbpage.c
===================================================================
--- linux-cell.orig/arch/powerpc/mm/hugetlbpage.c	2007-04-24 15:10:17.000000000 +1000
+++ linux-cell/arch/powerpc/mm/hugetlbpage.c	2007-04-24 15:28:11.000000000 +1000
@@ -566,6 +566,13 @@ unsigned long arch_get_unmapped_area(str
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
@@ -641,6 +648,13 @@ arch_get_unmapped_area_topdown(struct fi
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
@@ -823,6 +837,13 @@ unsigned long hugetlb_get_unmapped_area(
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
 
