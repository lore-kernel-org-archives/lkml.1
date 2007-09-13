Return-Path: <linux-kernel-owner+w=401wt.eu-S1765610AbXIMQSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765610AbXIMQSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 12:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765257AbXIMQQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 12:16:57 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:54113 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763056AbXIMQQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 12:16:55 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 3/3] IB/ehca: Make sure user pages are from hugetlb before using MR large pages
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200709131814.13937.fenkes@de.ibm.com>
In-Reply-To: <200709131814.13937.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1866
Date: Thu, 13 Sep 2007 18:16:20 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200709131816.21162.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

...because, on virtualized hardware like System p, we can't be sure that the
physical pages behind them are contiguous.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_mrmw.c |   25 +++++++++++++++----------
 1 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index 4c8f3b3..4ba8b7c 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -51,6 +51,7 @@
 
 #define NUM_CHUNKS(length, chunk_size) \
 	(((length) + (chunk_size - 1)) / (chunk_size))
+
 /* max number of rpages (per hcall register_rpages) */
 #define MAX_RPAGES 512
 
@@ -64,6 +65,11 @@ enum ehca_mr_pgsize {
 	EHCA_MR_PGSIZE16M = 0x1000000L
 };
 
+#define EHCA_MR_PGSHIFT4K  12
+#define EHCA_MR_PGSHIFT64K 16
+#define EHCA_MR_PGSHIFT1M  20
+#define EHCA_MR_PGSHIFT16M 24
+
 static u32 ehca_encode_hwpage_size(u32 pgsize)
 {
 	u32 idx = 0;
@@ -347,17 +353,16 @@ struct ib_mr *ehca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	/* select proper hw_pgsize */
 	if (ehca_mr_largepage &&
 	    (shca->hca_cap_mr_pgsize & HCA_CAP_MR_PGSIZE_16M)) {
-		if (length <= EHCA_MR_PGSIZE4K
-		    && PAGE_SIZE == EHCA_MR_PGSIZE4K)
-			hwpage_size = EHCA_MR_PGSIZE4K;
-		else if (length <= EHCA_MR_PGSIZE64K)
-			hwpage_size = EHCA_MR_PGSIZE64K;
-		else if (length <= EHCA_MR_PGSIZE1M)
-			hwpage_size = EHCA_MR_PGSIZE1M;
-		else
-			hwpage_size = EHCA_MR_PGSIZE16M;
+		int page_shift = PAGE_SHIFT;
+		if (e_mr->umem->hugetlb) {
+			/* determine page_shift, clamp between 4K and 16M */
+			page_shift = (fls64(length - 1) + 3) & ~3;
+			page_shift = min(max(page_shift, EHCA_MR_PGSHIFT4K),
+					 EHCA_MR_PGSHIFT16M);
+		}
+		hwpage_size = 1UL << page_shift;
 	} else
-		hwpage_size = EHCA_MR_PGSIZE4K;
+		hwpage_size = EHCA_MR_PGSIZE4K; /* ehca1 only supports 4k */
 	ehca_dbg(pd->device, "hwpage_size=%lx", hwpage_size);
 
 reg_user_mr_fallback:
-- 
1.5.2


