Return-Path: <linux-kernel-owner+w=401wt.eu-S2992642AbXDDEN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992642AbXDDEN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 00:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992656AbXDDEN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 00:13:26 -0400
Received: from ozlabs.org ([203.10.76.45]:49621 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934054AbXDDEBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 00:01:41 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-arch@vger.kernel.org>, Linux Memory Management <linux-mm@kvack.org>,
       <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Wed, 04 Apr 2007 14:01:29 +1000
Subject: [PATCH 6/14] get_unmapped_area handles MAP_FIXED on ia64
In-Reply-To: <1175659285.929428.835270667964.qpush@grosgo>
Message-Id: <20070404040140.33683DDE47@ozlabs.org>
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
 
