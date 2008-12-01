Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbYLAMXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbYLAMXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbYLAMXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:23:42 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56118 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbYLAMXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:23:41 -0500
From: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
To: Roland Dreier <rolandd@cisco.com>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH] IB/ehca: fix problem with flush work completions
Date: Mon, 1 Dec 2008 13:21:14 +0100
User-Agent: KMail/1.9.9
Cc: fenkes@de.ibm.com, hnguyen@de.ibm.com, alexschm@de.ibm.com,
       raisch@de.ibm.com, stefan.roscher@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011321.16599.ossrosch@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix enables ehca device driver to generate flush workcompletions even if
the application don't request work completions for all work requests. The
current implementation of ehca will generate flush work completions for 
the wrong work requests if an application uses non signaled work completions.

Signed-off-by: root <stefan.roscher@de.ibm.com>
---
The patch will cleanly apply on top of 2.6.28-rc6.
Roland, please apply this for 2.6.28 if possible.
regards Stefan

 drivers/infiniband/hw/ehca/ehca_classes.h |    4 ++-
 drivers/infiniband/hw/ehca/ehca_qp.c      |   26 +++++++++++---
 drivers/infiniband/hw/ehca/ehca_reqs.c    |   51 +++++++++++++++++------------
 3 files changed, 53 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 4df887a..7fc35cf 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -163,7 +163,8 @@ struct ehca_mod_qp_parm {
 /* struct for tracking if cqes have been reported to the application */
 struct ehca_qmap_entry {
 	u16 app_wr_id;
-	u16 reported;
+	u8 reported;
+	u8 cqe_req;
 };
 
 struct ehca_queue_map {
@@ -171,6 +172,7 @@ struct ehca_queue_map {
 	unsigned int entries;
 	unsigned int tail;
 	unsigned int left_to_poll;
+	unsigned int next_wqe_idx;   /* Idx to first wqe to be flushed */
 };
 
 struct ehca_qp {
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index 9e05ee2..cadbf0c 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -435,9 +435,13 @@ static void reset_queue_map(struct ehca_queue_map *qmap)
 {
 	int i;
 
-	qmap->tail = 0;
-	for (i = 0; i < qmap->entries; i++)
+	qmap->tail = qmap->entries - 1;
+	qmap->left_to_poll = 0;
+	qmap->next_wqe_idx = 0;
+	for (i = 0; i < qmap->entries; i++) {
 		qmap->map[i].reported = 1;
+		qmap->map[i].cqe_req = 0;
+	}
 }
 
 /*
@@ -1121,6 +1125,7 @@ static int calc_left_cqes(u64 wqe_p, struct ipz_queue *ipz_queue,
 	void *wqe_v;
 	u64 q_ofs;
 	u32 wqe_idx;
+	unsigned int tail_idx;
 
 	/* convert real to abs address */
 	wqe_p = wqe_p & (~(1UL << 63));
@@ -1133,12 +1138,17 @@ static int calc_left_cqes(u64 wqe_p, struct ipz_queue *ipz_queue,
 		return -EFAULT;
 	}
 
+	tail_idx = (qmap->tail + 1) % qmap->entries;
 	wqe_idx = q_ofs / ipz_queue->qe_size;
-	if (wqe_idx < qmap->tail)
-		qmap->left_to_poll = (qmap->entries - qmap->tail) + wqe_idx;
-	else
-		qmap->left_to_poll = wqe_idx - qmap->tail;
 
+	/* check all processed wqes, whether a cqe is requested or not */
+	while (tail_idx != wqe_idx) {
+		if (qmap->map[tail_idx].cqe_req)
+			qmap->left_to_poll++;
+		tail_idx = (tail_idx + 1) % qmap->entries;
+	}
+	/* save index in queue, where we have to start flushing */
+	qmap->next_wqe_idx = wqe_idx;
 	return 0;
 }
 
@@ -1185,10 +1195,14 @@ static int check_for_left_cqes(struct ehca_qp *my_qp, struct ehca_shca *shca)
 	} else {
 		spin_lock_irqsave(&my_qp->send_cq->spinlock, flags);
 		my_qp->sq_map.left_to_poll = 0;
+		my_qp->sq_map.next_wqe_idx = (my_qp->sq_map.tail + 1) %
+						my_qp->sq_map.entries;
 		spin_unlock_irqrestore(&my_qp->send_cq->spinlock, flags);
 
 		spin_lock_irqsave(&my_qp->recv_cq->spinlock, flags);
 		my_qp->rq_map.left_to_poll = 0;
+		my_qp->rq_map.next_wqe_idx = (my_qp->rq_map.tail + 1) %
+						my_qp->rq_map.entries;
 		spin_unlock_irqrestore(&my_qp->recv_cq->spinlock, flags);
 	}
 
diff --git a/drivers/infiniband/hw/ehca/ehca_reqs.c b/drivers/infiniband/hw/ehca/ehca_reqs.c
index 6492807..00a648f 100644
--- a/drivers/infiniband/hw/ehca/ehca_reqs.c
+++ b/drivers/infiniband/hw/ehca/ehca_reqs.c
@@ -179,6 +179,7 @@ static inline int ehca_write_swqe(struct ehca_qp *qp,
 
 	qmap_entry->app_wr_id = get_app_wr_id(send_wr->wr_id);
 	qmap_entry->reported = 0;
+	qmap_entry->cqe_req = 0;
 
 	switch (send_wr->opcode) {
 	case IB_WR_SEND:
@@ -203,8 +204,10 @@ static inline int ehca_write_swqe(struct ehca_qp *qp,
 
 	if ((send_wr->send_flags & IB_SEND_SIGNALED ||
 	    qp->init_attr.sq_sig_type == IB_SIGNAL_ALL_WR)
-	    && !hidden)
+	    && !hidden) {
 		wqe_p->wr_flag |= WQE_WRFLAG_REQ_SIGNAL_COM;
+		qmap_entry->cqe_req = 1;
+	}
 
 	if (send_wr->opcode == IB_WR_SEND_WITH_IMM ||
 	    send_wr->opcode == IB_WR_RDMA_WRITE_WITH_IMM) {
@@ -569,6 +572,7 @@ static int internal_post_recv(struct ehca_qp *my_qp,
 		qmap_entry = &my_qp->rq_map.map[rq_map_idx];
 		qmap_entry->app_wr_id = get_app_wr_id(cur_recv_wr->wr_id);
 		qmap_entry->reported = 0;
+		qmap_entry->cqe_req = 1;
 
 		wqe_cnt++;
 	} /* eof for cur_recv_wr */
@@ -706,27 +710,34 @@ repoll:
 		goto repoll;
 	wc->qp = &my_qp->ib_qp;
 
+	qmap_tail_idx = get_app_wr_id(cqe->work_request_id);
+	if (!(cqe->w_completion_flags & WC_SEND_RECEIVE_BIT))
+		/* We got a send completion. */
+		qmap = &my_qp->sq_map;
+	else
+		/* We got a receive completion. */
+		qmap = &my_qp->rq_map;
+
+	/* advance the tail pointer */
+	qmap->tail = qmap_tail_idx;
+
 	if (is_error) {
 		/*
 		 * set left_to_poll to 0 because in error state, we will not
 		 * get any additional CQEs
 		 */
-		ehca_add_to_err_list(my_qp, 1);
+		my_qp->sq_map.next_wqe_idx = (my_qp->sq_map.tail + 1) %
+						my_qp->sq_map.entries;
 		my_qp->sq_map.left_to_poll = 0;
+		ehca_add_to_err_list(my_qp, 1);
 
+		my_qp->rq_map.next_wqe_idx = (my_qp->rq_map.tail + 1) %
+						my_qp->rq_map.entries;
+		my_qp->rq_map.left_to_poll = 0;
 		if (HAS_RQ(my_qp))
 			ehca_add_to_err_list(my_qp, 0);
-		my_qp->rq_map.left_to_poll = 0;
 	}
 
-	qmap_tail_idx = get_app_wr_id(cqe->work_request_id);
-	if (!(cqe->w_completion_flags & WC_SEND_RECEIVE_BIT))
-		/* We got a send completion. */
-		qmap = &my_qp->sq_map;
-	else
-		/* We got a receive completion. */
-		qmap = &my_qp->rq_map;
-
 	qmap_entry = &qmap->map[qmap_tail_idx];
 	if (qmap_entry->reported) {
 		ehca_warn(cq->device, "Double cqe on qp_num=%#x",
@@ -738,10 +749,6 @@ repoll:
 	wc->wr_id = replace_wr_id(cqe->work_request_id, qmap_entry->app_wr_id);
 	qmap_entry->reported = 1;
 
-	/* this is a proper completion, we need to advance the tail pointer */
-	if (++qmap->tail == qmap->entries)
-		qmap->tail = 0;
-
 	/* if left_to_poll is decremented to 0, add the QP to the error list */
 	if (qmap->left_to_poll > 0) {
 		qmap->left_to_poll--;
@@ -805,13 +812,14 @@ static int generate_flush_cqes(struct ehca_qp *my_qp, struct ib_cq *cq,
 	else
 		qmap = &my_qp->rq_map;
 
-	qmap_entry = &qmap->map[qmap->tail];
+	qmap_entry = &qmap->map[qmap->next_wqe_idx];
 
 	while ((nr < num_entries) && (qmap_entry->reported == 0)) {
 		/* generate flush CQE */
+
 		memset(wc, 0, sizeof(*wc));
 
-		offset = qmap->tail * ipz_queue->qe_size;
+		offset = qmap->next_wqe_idx * ipz_queue->qe_size;
 		wqe = (struct ehca_wqe *)ipz_qeit_calc(ipz_queue, offset);
 		if (!wqe) {
 			ehca_err(cq->device, "Invalid wqe offset=%#lx on "
@@ -850,11 +858,12 @@ static int generate_flush_cqes(struct ehca_qp *my_qp, struct ib_cq *cq,
 
 		wc->qp = &my_qp->ib_qp;
 
-		/* mark as reported and advance tail pointer */
+		/* mark as reported and advance next_wqe pointer */
 		qmap_entry->reported = 1;
-		if (++qmap->tail == qmap->entries)
-			qmap->tail = 0;
-		qmap_entry = &qmap->map[qmap->tail];
+		qmap->next_wqe_idx++;
+		if (qmap->next_wqe_idx == qmap->entries)
+			qmap->next_wqe_idx = 0;
+		qmap_entry = &qmap->map[qmap->next_wqe_idx];
 
 		wc++; nr++;
 	}
-- 
1.5.5

