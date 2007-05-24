Return-Path: <linux-kernel-owner+w=401wt.eu-S1750965AbXEXOvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750965AbXEXOvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 10:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbXEXOvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 10:51:15 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:61690 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbXEXOvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 10:51:12 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH] IB/ehca: Refactor "maybe missed event" code
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       "Christoph Raisch" <raisch@de.ibm.com>,
       "Stefan Roscher" <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 6092
Date: Thu, 24 May 2007 16:51:05 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200705241651.05860.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Refactored Roland's patch so the queue arithmetic is done in a little less
lines. Also, moved the spinlock inside the block it's used in.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_reqs.c |    2 +-
 drivers/infiniband/hw/ehca/ipz_pt_fn.h |   28 ++++++++++------------------
 2 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_reqs.c b/drivers/infiniband/hw/ehca/ehca_reqs.c
index caec9de..56c4527 100644
--- a/drivers/infiniband/hw/ehca/ehca_reqs.c
+++ b/drivers/infiniband/hw/ehca/ehca_reqs.c
@@ -637,7 +637,6 @@ poll_cq_exit0:
 int ehca_req_notify_cq(struct ib_cq *cq, enum ib_cq_notify_flags notify_flags)
 {
 	struct ehca_cq *my_cq = container_of(cq, struct ehca_cq, ib_cq);
-	unsigned long spl_flags;
 	int ret = 0;
 
 	switch (notify_flags & IB_CQ_SOLICITED_MASK) {
@@ -652,6 +651,7 @@ int ehca_req_notify_cq(struct ib_cq *cq, enum ib_cq_notify_flags notify_flags)
 	}
 
 	if (notify_flags & IB_CQ_REPORT_MISSED_EVENTS) {
+		unsigned long spl_flags;
 		spin_lock_irqsave(&my_cq->spinlock, spl_flags);
 		ret = ipz_qeit_is_valid(&my_cq->ipz_queue);
 		spin_unlock_irqrestore(&my_cq->spinlock, spl_flags);
diff --git a/drivers/infiniband/hw/ehca/ipz_pt_fn.h b/drivers/infiniband/hw/ehca/ipz_pt_fn.h
index 57f141a..007f088 100644
--- a/drivers/infiniband/hw/ehca/ipz_pt_fn.h
+++ b/drivers/infiniband/hw/ehca/ipz_pt_fn.h
@@ -105,7 +105,6 @@ void *ipz_qpageit_get_inc(struct ipz_queue *queue);
  * step in struct ipz_queue, will wrap in ringbuffer
  * returns address (kv) of Queue Entry BEFORE increment
  * warning don't use in parallel with ipz_qpageit_get_inc()
- * warning unpredictable results may occur if steps>act_nr_of_queue_entries
  */
 static inline void *ipz_qeit_get_inc(struct ipz_queue *queue)
 {
@@ -121,31 +120,24 @@ static inline void *ipz_qeit_get_inc(struct ipz_queue *queue)
 }
 
 /*
+ * return a bool indicating whether current Queue Entry is valid
+ */
+static inline int ipz_qeit_is_valid(struct ipz_queue *queue)
+{
+	struct ehca_cqe *cqe = ipz_qeit_get(queue);
+	return ((cqe->cqe_flags >> 7) == (queue->toggle_state & 1));
+}
+
+/*
  * return current Queue Entry, increment Queue Entry iterator by one
  * step in struct ipz_queue, will wrap in ringbuffer
  * returns address (kv) of Queue Entry BEFORE increment
  * returns 0 and does not increment, if wrong valid state
  * warning don't use in parallel with ipz_qpageit_get_inc()
- * warning unpredictable results may occur if steps>act_nr_of_queue_entries
  */
 static inline void *ipz_qeit_get_inc_valid(struct ipz_queue *queue)
 {
-	struct ehca_cqe *cqe = ipz_qeit_get(queue);
-	u32 cqe_flags = cqe->cqe_flags;
-
-	if ((cqe_flags >> 7) != (queue->toggle_state & 1))
-		return NULL;
-
-	ipz_qeit_get_inc(queue);
-	return cqe;
-}
-
-static inline int ipz_qeit_is_valid(struct ipz_queue *queue)
-{
-	struct ehca_cqe *cqe = ipz_qeit_get(queue);
-	u32 cqe_flags = cqe->cqe_flags;
-
-	return cqe_flags >> 7 == (queue->toggle_state & 1);
+	return ipz_qeit_is_valid(queue) ? ipz_qeit_get_inc(queue) : NULL;
 }
 
 /*
-- 
1.5.2


