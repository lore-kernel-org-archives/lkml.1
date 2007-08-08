Return-Path: <linux-kernel-owner+w=401wt.eu-S937354AbXHHSiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937354AbXHHSiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 14:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbXHHSiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 14:38:05 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48711 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936503AbXHHSiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 14:38:03 -0400
From: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, openib-general@openib.org
Subject: [PATCH 1/7] IB/ehca: Small QP userspace support and fixes
Date: Wed, 8 Aug 2007 20:37:59 +0200
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <Hoang-Nam.Nguyen@dyn-9-152-249-53>, raisch@de.ibm.com,
       fenkes@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708082038.00127.ossrosch@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Roscher <stefan.roscher@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_qp.c   |    7 +++----
 drivers/infiniband/hw/ehca/ipz_pt_fn.c |    3 ++-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index b178cba..cfa83fa 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -273,6 +273,7 @@ static inline void queue2resp(struct ipzu_queue_resp *resp,
 	resp->queue_length = queue->queue_length;
 	resp->pagesize = queue->pagesize;
 	resp->toggle_state = queue->toggle_state;
+	resp->offset = queue->offset;
 }
 
 /*
@@ -598,8 +599,7 @@ static struct ehca_qp *internal_create_qp(
 	parms.squeue.max_sge = max_send_sge;
 	parms.rqueue.max_sge = max_recv_sge;
 
-	if (EHCA_BMASK_GET(HCA_CAP_MINI_QP, shca->hca_cap)
-	    && !(context && udata)) { /* no small QP support in userspace ATM */
+	if (EHCA_BMASK_GET(HCA_CAP_MINI_QP, shca->hca_cap)) {
 		ehca_determine_small_queue(
 			&parms.squeue, max_send_sge, is_llqp);
 		ehca_determine_small_queue(
@@ -739,8 +739,7 @@ static struct ehca_qp *internal_create_qp(
 		resp.ext_type = my_qp->ext_type;
 		resp.qkey = my_qp->qkey;
 		resp.real_qp_num = my_qp->real_qp_num;
-		resp.ipz_rqueue.offset = my_qp->ipz_rqueue.offset;
-		resp.ipz_squeue.offset = my_qp->ipz_squeue.offset;
+
 		if (HAS_SQ(my_qp))
 			queue2resp(&resp.ipz_squeue, &my_qp->ipz_squeue);
 		if (HAS_RQ(my_qp))
diff --git a/drivers/infiniband/hw/ehca/ipz_pt_fn.c b/drivers/infiniband/hw/ehca/ipz_pt_fn.c
index a090c67..661f8db 100644
--- a/drivers/infiniband/hw/ehca/ipz_pt_fn.c
+++ b/drivers/infiniband/hw/ehca/ipz_pt_fn.c
@@ -158,6 +158,7 @@ static int alloc_small_queue_page(struct ipz_queue *queue, struct ehca_pd *pd)
 
 	queue->queue_pages[0] = (void *)(page->page | (bit << (order + 9)));
 	queue->small_page = page;
+	queue->offset = bit << (order + 9);
 	return 1;
 
 out:
@@ -172,7 +173,7 @@ static void free_small_queue_page(struct ipz_queue *queue, struct ehca_pd *pd)
 	unsigned long bit;
 	int free_page = 0;
 
-	bit = ((unsigned long)queue->queue_pages[0] & PAGE_MASK)
+	bit = ((unsigned long)queue->queue_pages[0] & ~PAGE_MASK)
 		>> (order + 9);
 
 	mutex_lock(&pd->lock);
-- 
1.5.2



