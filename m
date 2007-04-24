Return-Path: <linux-kernel-owner+w=401wt.eu-S1161580AbXDXFe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161580AbXDXFe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 01:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161632AbXDXFeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 01:34:37 -0400
Received: from ozlabs.org ([203.10.76.45]:35021 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161580AbXDXFdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 01:33:41 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 24 Apr 2007 15:33:39 +1000
Subject: [PATCH 10/12] get_unmapped_area handles MAP_FIXED in hugetlbfs
In-Reply-To: <1177392813.924664.32930750763.qpush@grosgo>
Message-Id: <20070424053341.68E67DDF10@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Generic hugetlb_get_unmapped_area() now handles MAP_FIXED by just
calling prepare_hugepage_range()

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: William Irwin <bill.irwin@oracle.com>

 fs/hugetlbfs/inode.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-cell/fs/hugetlbfs/inode.c
===================================================================
--- linux-cell.orig/fs/hugetlbfs/inode.c	2007-03-22 16:12:56.000000000 +1100
+++ linux-cell/fs/hugetlbfs/inode.c	2007-03-22 16:16:02.000000000 +1100
@@ -115,6 +115,12 @@ hugetlb_get_unmapped_area(struct file *f
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
