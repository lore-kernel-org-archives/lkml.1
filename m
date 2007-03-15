Return-Path: <linux-kernel-owner+w=401wt.eu-S1422971AbXCOW1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422971AbXCOW1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933930AbXCOWXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:23:21 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33707 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932684AbXCOWP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:28 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 02 of 33] IB/ipath - fix user memory region creation when
	IOMMU present
X-Mercurial-Node: 3337d450afeebc553a09fe5c18ed0b2444547c24
Message-Id: <3337d450afeebc553a09.1173995086@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:44:46 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Bryan O'Sullivan <bos@pathscale.com>
# Date 1173994464 25200
# Node ID 3337d450afeebc553a09fe5c18ed0b2444547c24
# Parent  b1d05f3486f8bba1dd3c5cbca39f06a5e1b3d6fb
IB/ipath - fix user memory region creation when IOMMU present

The loop which initializes the user memory region from an array
of pages was using the wrong limit for the array.  This worked
OK when dma_map_sg() returned the same number as the number of pages.
This patch fixes the problem.

Signed-off-by: Ralph Campbell <ralph.campbell@qlogic.com>
Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r b1d05f3486f8 -r 3337d450afee drivers/infiniband/hw/ipath/ipath_mr.c
--- a/drivers/infiniband/hw/ipath/ipath_mr.c	Thu Mar 15 14:34:24 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_mr.c	Thu Mar 15 14:34:24 2007 -0700
@@ -210,9 +210,15 @@ struct ib_mr *ipath_reg_user_mr(struct i
 	m = 0;
 	n = 0;
 	list_for_each_entry(chunk, &region->chunk_list, list) {
-		for (i = 0; i < chunk->nmap; i++) {
-			mr->mr.map[m]->segs[n].vaddr =
-				page_address(chunk->page_list[i].page);
+		for (i = 0; i < chunk->nents; i++) {
+			void *vaddr;
+
+			vaddr = page_address(chunk->page_list[i].page);
+			if (!vaddr) {
+				ret = ERR_PTR(-EINVAL);
+				goto bail;
+			}
+			mr->mr.map[m]->segs[n].vaddr = vaddr;
 			mr->mr.map[m]->segs[n].length = region->page_size;
 			n++;
 			if (n == IPATH_SEGSZ) {
