Return-Path: <linux-kernel-owner+w=401wt.eu-S932412AbXJPPb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412AbXJPPb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 11:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932401AbXJPPbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 11:31:19 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:11051 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932419AbXJPPbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 11:31:17 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 4/5] IB/ehca: Change meaning of hca_cap_mr_pgsize
User-Agent: KMail/1.9.1
Cc: Roland Dreier <rolandd@cisco.com>, "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200710161722.29144.fenkes@de.ibm.com>
In-Reply-To: <200710161722.29144.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1982
Date: Tue, 16 Oct 2007 17:31:14 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200710161731.14577.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ehca_shca.hca_cap_mr_pgsize now contains all supported page sizes ORed
together. This makes some checks easier to code and understand, plus we can
return this value verbatim in query_hca(), fixing a problem with SRP
(reported by Anton Blanchard -- thanks!).

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_classes.h |    1 -
 drivers/infiniband/hw/ehca/ehca_hca.c     |    1 +
 drivers/infiniband/hw/ehca/ehca_main.c    |   18 ++++++++++++-
 drivers/infiniband/hw/ehca/ehca_mrmw.c    |   38 ++++++++++++++--------------
 4 files changed, 36 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 0f7a55d..365bc5d 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -323,7 +323,6 @@ extern int ehca_static_rate;
 extern int ehca_port_act_time;
 extern int ehca_use_hp_mr;
 extern int ehca_scaling_code;
-extern int ehca_mr_largepage;
 
 struct ipzu_queue_resp {
 	u32 qe_size;      /* queue entry size */
diff --git a/drivers/infiniband/hw/ehca/ehca_hca.c b/drivers/infiniband/hw/ehca/ehca_hca.c
index 4aa3ffa..15806d1 100644
--- a/drivers/infiniband/hw/ehca/ehca_hca.c
+++ b/drivers/infiniband/hw/ehca/ehca_hca.c
@@ -77,6 +77,7 @@ int ehca_query_device(struct ib_device *ibdev, struct ib_device_attr *props)
 	}
 
 	memset(props, 0, sizeof(struct ib_device_attr));
+	props->page_size_cap   = shca->hca_cap_mr_pgsize;
 	props->fw_ver          = rblock->hw_ver;
 	props->max_mr_size     = rblock->max_mr_size;
 	props->vendor_id       = rblock->vendor_id >> 8;
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 403467f..d477dc3 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -260,13 +260,20 @@ static struct cap_descr {
 	{ HCA_CAP_MINI_QP, "HCA_CAP_MINI_QP" },
 };
 
-int ehca_sense_attributes(struct ehca_shca *shca)
+static int ehca_sense_attributes(struct ehca_shca *shca)
 {
 	int i, ret = 0;
 	u64 h_ret;
 	struct hipz_query_hca *rblock;
 	struct hipz_query_port *port;
 
+	static const u32 pgsize_map[] = {
+		HCA_CAP_MR_PGSIZE_4K,  0x1000,
+		HCA_CAP_MR_PGSIZE_64K, 0x10000,
+		HCA_CAP_MR_PGSIZE_1M,  0x100000,
+		HCA_CAP_MR_PGSIZE_16M, 0x1000000,
+	};
+
 	rblock = ehca_alloc_fw_ctrlblock(GFP_KERNEL);
 	if (!rblock) {
 		ehca_gen_err("Cannot allocate rblock memory.");
@@ -329,8 +336,15 @@ int ehca_sense_attributes(struct ehca_shca *shca)
 		if (EHCA_BMASK_GET(hca_cap_descr[i].mask, shca->hca_cap))
 			ehca_gen_dbg("   %s", hca_cap_descr[i].descr);
 
-	shca->hca_cap_mr_pgsize = rblock->memory_page_size_supported;
+	/* translate supported MR page sizes; always support 4K */
+	shca->hca_cap_mr_pgsize = EHCA_PAGESIZE;
+	if (ehca_mr_largepage) { /* support extra sizes only if enabled */
+		for (i = 0; i < ARRAY_SIZE(pgsize_map); i += 2)
+			if (rblock->memory_page_size_supported & pgsize_map[i])
+				shca->hca_cap_mr_pgsize |= pgsize_map[i + 1];
+	}
 
+	/* query max MTU from first port -- it's the same for all ports */
 	port = (struct hipz_query_port *)rblock;
 	h_ret = hipz_h_query_port(shca->ipz_hca_handle, 1, port);
 	if (h_ret != H_SUCCESS) {
diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index b9a788c..bb97915 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -79,9 +79,7 @@ static u32 ehca_encode_hwpage_size(u32 pgsize)
 
 static u64 ehca_get_max_hwpage_size(struct ehca_shca *shca)
 {
-	if (shca->hca_cap_mr_pgsize & HCA_CAP_MR_PGSIZE_16M)
-		return EHCA_MR_PGSIZE16M;
-	return EHCA_MR_PGSIZE4K;
+	return 1UL << ilog2(shca->hca_cap_mr_pgsize);
 }
 
 static struct ehca_mr *ehca_mr_new(void)
@@ -288,7 +286,7 @@ struct ib_mr *ehca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		container_of(pd->device, struct ehca_shca, ib_device);
 	struct ehca_pd *e_pd = container_of(pd, struct ehca_pd, ib_pd);
 	struct ehca_mr_pginfo pginfo;
-	int ret;
+	int ret, page_shift;
 	u32 num_kpages;
 	u32 num_hwpages;
 	u64 hwpage_size;
@@ -343,19 +341,20 @@ struct ib_mr *ehca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	/* determine number of MR pages */
 	num_kpages = NUM_CHUNKS((virt % PAGE_SIZE) + length, PAGE_SIZE);
 	/* select proper hw_pgsize */
-	if (ehca_mr_largepage &&
-	    (shca->hca_cap_mr_pgsize & HCA_CAP_MR_PGSIZE_16M)) {
-		int page_shift = PAGE_SHIFT;
-		if (e_mr->umem->hugetlb) {
-			/* determine page_shift, clamp between 4K and 16M */
-			page_shift = (fls64(length - 1) + 3) & ~3;
-			page_shift = min(max(page_shift, EHCA_MR_PGSHIFT4K),
-					 EHCA_MR_PGSHIFT16M);
-		}
-		hwpage_size = 1UL << page_shift;
-	} else
-		hwpage_size = EHCA_MR_PGSIZE4K; /* ehca1 only supports 4k */
-	ehca_dbg(pd->device, "hwpage_size=%lx", hwpage_size);
+	page_shift = PAGE_SHIFT;
+	if (e_mr->umem->hugetlb) {
+		/* determine page_shift, clamp between 4K and 16M */
+		page_shift = (fls64(length - 1) + 3) & ~3;
+		page_shift = min(max(page_shift, EHCA_MR_PGSHIFT4K),
+				 EHCA_MR_PGSHIFT16M);
+	}
+	hwpage_size = 1UL << page_shift;
+
+	/* now that we have the desired page size, shift until it's
+	 * supported, too. 4K is always supported, so this terminates.
+	 */
+	while (!(hwpage_size & shca->hca_cap_mr_pgsize))
+		hwpage_size >>= 4;
 
 reg_user_mr_fallback:
 	num_hwpages = NUM_CHUNKS((virt % hwpage_size) + length, hwpage_size);
@@ -801,8 +800,9 @@ struct ib_fmr *ehca_alloc_fmr(struct ib_pd *pd,
 		ib_fmr = ERR_PTR(-EINVAL);
 		goto alloc_fmr_exit0;
 	}
-	hw_pgsize = ehca_get_max_hwpage_size(shca);
-	if ((1 << fmr_attr->page_shift) != hw_pgsize) {
+
+	hw_pgsize = 1 << fmr_attr->page_shift;
+	if (!(hw_pgsize & shca->hca_cap_mr_pgsize)) {
 		ehca_err(pd->device, "unsupported fmr_attr->page_shift=%x",
 			 fmr_attr->page_shift);
 		ib_fmr = ERR_PTR(-EINVAL);
-- 
1.5.2


