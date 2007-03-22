Return-Path: <linux-kernel-owner+w=401wt.eu-S965801AbXCVGD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965801AbXCVGD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 02:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965819AbXCVGDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 02:03:12 -0400
Received: from ozlabs.org ([203.10.76.45]:56978 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965805AbXCVGC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 02:02:56 -0400
To: Linux Memory Management <linux-mm@kvack.org>
CC: <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 22 Mar 2007 17:00:56 +1100
Subject: [RFC/PATCH 6/15] get_unmapped_area handles MAP_FIXED on ia64
In-Reply-To: <1174543217.531981.572863804039.qpush@grosgo>
Message-Id: <20070322060239.BC328DE131@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 arch/ia64/kernel/sys_ia64.c |    7 +++++++
 arch/ia64/mm/hugetlbpage.c  |    8 ++++++++
 2 files changed, 15 insertions(+)

Index: linux-cell/arch/ia64/kernel/sys_ia64.c
===================================================================
--- linux-cell.orig/arch/ia64/kernel/sys_ia64.c	2007-03-22 15:10:45.000000000 +1100
+++ linux-cell/arch/ia64/kernel/sys_ia64.c	2007-03-22 15:10:47.000000000 +1100
@@ -33,6 +33,13 @@ arch_get_unmapped_area (struct file *fil
 	if (len > RGN_MAP_LIMIT)
 		return -ENOMEM;
 
+	/* handle fixed mapping: prevent overlap with huge pages */
+	if (flags & MAP_FIXED) {
+		if (is_hugepage_only_range(mm, addr, len))
+			return -EINVAL;
+		return addr;
+	}
+
 #ifdef CONFIG_HUGETLB_PAGE
 	if (REGION_NUMBER(addr) == RGN_HPAGE)
 		addr = 0;
Index: linux-cell/arch/ia64/mm/hugetlbpage.c
===================================================================
--- linux-cell.orig/arch/ia64/mm/hugetlbpage.c	2007-03-22 15:12:32.000000000 +1100
+++ linux-cell/arch/ia64/mm/hugetlbpage.c	2007-03-22 15:12:39.000000000 +1100
@@ -148,6 +148,14 @@ unsigned long hugetlb_get_unmapped_area(
 		return -ENOMEM;
 	if (len & ~HPAGE_MASK)
 		return -EINVAL;
+
+	/* Handle MAP_FIXED */
+	if (flags & MAP_FIXED) {
+		if (prepare_hugepage_range(addr, len, pgoff))
+			return -EINVAL;
+		return addr;
+	}
+
 	/* This code assumes that RGN_HPAGE != 0. */
 	if ((REGION_NUMBER(addr) != RGN_HPAGE) || (addr & (HPAGE_SIZE - 1)))
 		addr = HPAGE_REGION_BASE;
 
