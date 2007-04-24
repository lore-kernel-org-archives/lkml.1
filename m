Return-Path: <linux-kernel-owner+w=401wt.eu-S1161642AbXDXFh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161642AbXDXFh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 01:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161640AbXDXFeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 01:34:31 -0400
Received: from ozlabs.org ([203.10.76.45]:35023 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161629AbXDXFdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 01:33:39 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 24 Apr 2007 15:33:36 +1000
Subject: [PATCH 5/12] get_unmapped_area handles MAP_FIXED on i386
In-Reply-To: <1177392813.924664.32930750763.qpush@grosgo>
Message-Id: <20070424053338.CEB28DDF0B@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Handle MAP_FIXED in i386 hugetlb_get_unmapped_area(), just call
prepare_hugepage_range.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: William Irwin <bill.irwin@oracle.com>

 arch/i386/mm/hugetlbpage.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-cell/arch/i386/mm/hugetlbpage.c
===================================================================
--- linux-cell.orig/arch/i386/mm/hugetlbpage.c	2007-03-22 16:08:12.000000000 +1100
+++ linux-cell/arch/i386/mm/hugetlbpage.c	2007-03-22 16:14:19.000000000 +1100
@@ -367,6 +367,12 @@ hugetlb_get_unmapped_area(struct file *f
 	if (len > TASK_SIZE)
 		return -ENOMEM;
 
+	if (flags & MAP_FIXED) {
+		if (prepare_hugepage_range(addr, len, pgoff))
+			return -EINVAL;
+		return addr;
+	}
+
 	if (addr) {
 		addr = ALIGN(addr, HPAGE_SIZE);
 		vma = find_vma(mm, addr);
