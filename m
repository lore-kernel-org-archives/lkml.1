Return-Path: <linux-kernel-owner+w=401wt.eu-S1756972AbYD0QAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972AbYD0QAr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 12:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757502AbYD0QAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 12:00:12 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:50115 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755896AbYD0QAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 12:00:08 -0400
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2.6.26 2/3] RDMA/cxgb3: Correctly set the max_mr_size device attribute.
Date: Sun, 27 Apr 2008 11:00:08 -0500
To: rdreier@cisco.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       general@lists.openfabrics.org, divy@chelsio.com, felix@chelsio.com
Message-Id: <20080427160008.31018.15516.stgit@dell3.ogc.int>
In-Reply-To: <20080427155456.31018.22282.stgit@dell3.ogc.int>
References: <20080427155456.31018.22282.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cxgb3 only supports 4GB memory regions.  The lustre RDMA code uses this
attribute and currently has to code around our bad setting.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb3/cxio_hal.h      |    1 +
 drivers/infiniband/hw/cxgb3/iwch.c          |    1 +
 drivers/infiniband/hw/cxgb3/iwch.h          |    1 +
 drivers/infiniband/hw/cxgb3/iwch_provider.c |    2 +-
 4 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.h b/drivers/infiniband/hw/cxgb3/cxio_hal.h
index 99543d6..2bcff7f 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.h
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.h
@@ -53,6 +53,7 @@
 #define T3_MAX_PBL_SIZE 256
 #define T3_MAX_RQ_SIZE 1024
 #define T3_MAX_NUM_STAG (1<<15)
+#define T3_MAX_MR_SIZE 0x100000000ULL
 
 #define T3_STAG_UNSET 0xffffffff
 
diff --git a/drivers/infiniband/hw/cxgb3/iwch.c b/drivers/infiniband/hw/cxgb3/iwch.c
index 0315c9d..98a768f 100644
--- a/drivers/infiniband/hw/cxgb3/iwch.c
+++ b/drivers/infiniband/hw/cxgb3/iwch.c
@@ -83,6 +83,7 @@ static void rnic_init(struct iwch_dev *rnicp)
 	rnicp->attr.max_phys_buf_entries = T3_MAX_PBL_SIZE;
 	rnicp->attr.max_pds = T3_MAX_NUM_PD - 1;
 	rnicp->attr.mem_pgsizes_bitmask = 0x7FFF;	/* 4KB-128MB */
+	rnicp->attr.max_mr_size = T3_MAX_MR_SIZE;
 	rnicp->attr.can_resize_wq = 0;
 	rnicp->attr.max_rdma_reads_per_qp = 8;
 	rnicp->attr.max_rdma_read_resources =
diff --git a/drivers/infiniband/hw/cxgb3/iwch.h b/drivers/infiniband/hw/cxgb3/iwch.h
index caf4e60..238c103 100644
--- a/drivers/infiniband/hw/cxgb3/iwch.h
+++ b/drivers/infiniband/hw/cxgb3/iwch.h
@@ -66,6 +66,7 @@ struct iwch_rnic_attributes {
 	 * size (4k)^i.  Phys block list mode unsupported.
 	 */
 	u32 mem_pgsizes_bitmask;
+	u64 max_mr_size;
 	u8 can_resize_wq;
 
 	/*
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index b2ea921..f7df213 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -998,7 +998,7 @@ static int iwch_query_device(struct ib_device *ibdev,
 	props->device_cap_flags = dev->device_cap_flags;
 	props->vendor_id = (u32)dev->rdev.rnic_info.pdev->vendor;
 	props->vendor_part_id = (u32)dev->rdev.rnic_info.pdev->device;
-	props->max_mr_size = ~0ull;
+	props->max_mr_size = dev->attr.max_mr_size;
 	props->max_qp = dev->attr.max_qps;
 	props->max_qp_wr = dev->attr.max_wrs;
 	props->max_sge = dev->attr.max_sge_per_wr;
