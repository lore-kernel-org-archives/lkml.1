Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbYLBPen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbYLBPen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 10:34:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750956AbYLBPee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 10:34:34 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:41579 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbYLBPed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 10:34:33 -0500
From: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>,
       LKML <linux-kernel@vger.kernel.org>, Roland Dreier <rolandd@cisco.com>
Subject: [PATCH] IB/ehca: replace modulus operations in flush error completion path
Date: Tue, 2 Dec 2008 16:31:56 +0100
User-Agent: KMail/1.9.9
Cc: raisch@de.ibm.com, hnguyen@de.ibm.com, fenkes@de.ibm.com,
       alexschm@de.ibm.com, stefan.roscher@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812021631.58810.ossrosch@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the latest flush error completion patch we introduced modulus operation
to calculate the next index within a qmap. Based on comments from other
mailing lists we decided to optimize this operation by using an addition and
an if-statement instead of modulus, even though this is in error path.

Signed-off-by: Stefan Roscher <stefan.roscher@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_classes.h |    7 +++++++
 drivers/infiniband/hw/ehca/ehca_qp.c      |   12 ++++++------
 drivers/infiniband/hw/ehca/ehca_reqs.c    |   13 ++++++-------
 3 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 7fc35cf..c825142 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -175,6 +175,13 @@ struct ehca_queue_map {
 	unsigned int next_wqe_idx;   /* Idx to first wqe to be flushed */
 };
 
+/* function to calculate the next index for the qmap */
+static inline unsigned int next_index(unsigned int cur_index, unsigned int limit)
+{
+	unsigned int temp = cur_index + 1;
+	return (temp == limit) ? 0 : temp;
+}
+
 struct ehca_qp {
 	union {
 		struct ib_qp ib_qp;
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index cadbf0c..f161cf1 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -1138,14 +1138,14 @@ static int calc_left_cqes(u64 wqe_p, struct ipz_queue *ipz_queue,
 		return -EFAULT;
 	}
 
-	tail_idx = (qmap->tail + 1) % qmap->entries;
+	tail_idx = next_index(qmap->tail, qmap->entries);
 	wqe_idx = q_ofs / ipz_queue->qe_size;
 
 	/* check all processed wqes, whether a cqe is requested or not */
 	while (tail_idx != wqe_idx) {
 		if (qmap->map[tail_idx].cqe_req)
 			qmap->left_to_poll++;
-		tail_idx = (tail_idx + 1) % qmap->entries;
+		tail_idx = next_index(tail_idx, qmap->entries);
 	}
 	/* save index in queue, where we have to start flushing */
 	qmap->next_wqe_idx = wqe_idx;
@@ -1195,14 +1195,14 @@ static int check_for_left_cqes(struct ehca_qp *my_qp, struct ehca_shca *shca)
 	} else {
 		spin_lock_irqsave(&my_qp->send_cq->spinlock, flags);
 		my_qp->sq_map.left_to_poll = 0;
-		my_qp->sq_map.next_wqe_idx = (my_qp->sq_map.tail + 1) %
-						my_qp->sq_map.entries;
+		my_qp->sq_map.next_wqe_idx = next_index(my_qp->sq_map.tail,
+							my_qp->sq_map.entries);
 		spin_unlock_irqrestore(&my_qp->send_cq->spinlock, flags);
 
 		spin_lock_irqsave(&my_qp->recv_cq->spinlock, flags);
 		my_qp->rq_map.left_to_poll = 0;
-		my_qp->rq_map.next_wqe_idx = (my_qp->rq_map.tail + 1) %
-						my_qp->rq_map.entries;
+		my_qp->rq_map.next_wqe_idx = next_index(my_qp->rq_map.tail,
+							my_qp->rq_map.entries);
 		spin_unlock_irqrestore(&my_qp->recv_cq->spinlock, flags);
 	}
 
diff --git a/drivers/infiniband/hw/ehca/ehca_reqs.c b/drivers/infiniband/hw/ehca/ehca_reqs.c
index 00a648f..c711268 100644
--- a/drivers/infiniband/hw/ehca/ehca_reqs.c
+++ b/drivers/infiniband/hw/ehca/ehca_reqs.c
@@ -726,13 +726,13 @@ repoll:
 		 * set left_to_poll to 0 because in error state, we will not
 		 * get any additional CQEs
 		 */
-		my_qp->sq_map.next_wqe_idx = (my_qp->sq_map.tail + 1) %
-						my_qp->sq_map.entries;
+		my_qp->sq_map.next_wqe_idx = next_index(my_qp->sq_map.tail,
+							my_qp->sq_map.entries);
 		my_qp->sq_map.left_to_poll = 0;
 		ehca_add_to_err_list(my_qp, 1);
 
-		my_qp->rq_map.next_wqe_idx = (my_qp->rq_map.tail + 1) %
-						my_qp->rq_map.entries;
+		my_qp->rq_map.next_wqe_idx = next_index(my_qp->rq_map.tail,
+							my_qp->rq_map.entries);
 		my_qp->rq_map.left_to_poll = 0;
 		if (HAS_RQ(my_qp))
 			ehca_add_to_err_list(my_qp, 0);
@@ -860,9 +860,8 @@ static int generate_flush_cqes(struct ehca_qp *my_qp, struct ib_cq *cq,
 
 		/* mark as reported and advance next_wqe pointer */
 		qmap_entry->reported = 1;
-		qmap->next_wqe_idx++;
-		if (qmap->next_wqe_idx == qmap->entries)
-			qmap->next_wqe_idx = 0;
+		qmap->next_wqe_idx = next_index(qmap->next_wqe_idx,
+						qmap->entries);
 		qmap_entry = &qmap->map[qmap->next_wqe_idx];
 
 		wc++; nr++;
-- 
1.5.5

