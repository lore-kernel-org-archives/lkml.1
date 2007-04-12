Return-Path: <linux-kernel-owner+w=401wt.eu-S1161484AbXDLCVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161484AbXDLCVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 22:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161481AbXDLCVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 22:21:12 -0400
Received: from ozlabs.org ([203.10.76.45]:55493 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161487AbXDLCUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 22:20:34 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Memory Management <linux-mm@kvack.org>,
       <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 12 Apr 2007 12:20:32 +1000
Subject: [PATCH 10/12] get_unmapped_area handles MAP_FIXED in hugetlbfs
In-Reply-To: <1176344427.242579.337989891532.qpush@grosgo>
Message-Id: <20070412022034.4A229DDF30@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Generic hugetlb_get_unmapped_area() now handles MAP_FIXED by just
calling prepare_hugepage_range()

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

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
