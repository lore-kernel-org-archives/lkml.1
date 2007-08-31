Return-Path: <linux-kernel-owner+w=401wt.eu-S965817AbXHaVBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965817AbXHaVBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 17:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932985AbXHaVBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 17:01:01 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:37890 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932900AbXHaVBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 17:01:00 -0400
X-IronPort-AV: i="4.20,194,1186383600"; 
   d="scan'208"; a="9285202:sNHT27259362"
To: torvalds@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git for-linus branch
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 31 Aug 2007 14:00:58 -0700
Message-ID: <adair6vwh9x.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 31 Aug 2007 21:00:58.0959 (UTC) FILETIME=[07E875F0:01C7EC12]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get fixes for two fairly bad ehca bugs introduced in 2.6.23:

Joachim Fenkes (1):
      IB/ehca: SRQ fixes to enable IPoIB CM

Stefan Roscher (1):
      IB/ehca: Fix Small QP regressions

 drivers/infiniband/hw/ehca/ehca_hca.c  |   10 ++++--
 drivers/infiniband/hw/ehca/ehca_irq.c  |   48 ++++++++++++++++++++-----------
 drivers/infiniband/hw/ehca/ehca_qp.c   |   10 ++++--
 drivers/infiniband/hw/ehca/ipz_pt_fn.c |    2 +-
 4 files changed, 45 insertions(+), 25 deletions(-)


diff --git a/drivers/infiniband/hw/ehca/ehca_hca.c b/drivers/infiniband/hw/ehca/ehca_hca.c
index fc19ef9..cf22472 100644
--- a/drivers/infiniband/hw/ehca/ehca_hca.c
+++ b/drivers/infiniband/hw/ehca/ehca_hca.c
@@ -93,9 +93,13 @@ int ehca_query_device(struct ib_device *ibdev, struct ib_device_attr *props)
 	props->max_pd          = min_t(int, rblock->max_pd, INT_MAX);
 	props->max_ah          = min_t(int, rblock->max_ah, INT_MAX);
 	props->max_fmr         = min_t(int, rblock->max_mr, INT_MAX);
-	props->max_srq         = 0;
-	props->max_srq_wr      = 0;
-	props->max_srq_sge     = 0;
+
+	if (EHCA_BMASK_GET(HCA_CAP_SRQ, shca->hca_cap)) {
+		props->max_srq         = props->max_qp;
+		props->max_srq_wr      = props->max_qp_wr;
+		props->max_srq_sge     = 3;
+	}
+
 	props->max_pkeys       = 16;
 	props->local_ca_ack_delay
 		= rblock->local_ca_ack_delay;
diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index ee06d8b..a925ea5 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -175,41 +175,55 @@ error_data1:
 
 }
 
-static void qp_event_callback(struct ehca_shca *shca, u64 eqe,
-			      enum ib_event_type event_type, int fatal)
+static void dispatch_qp_event(struct ehca_shca *shca, struct ehca_qp *qp,
+			      enum ib_event_type event_type)
 {
 	struct ib_event event;
-	struct ehca_qp *qp;
-	u32 token = EHCA_BMASK_GET(EQE_QP_TOKEN, eqe);
-
-	read_lock(&ehca_qp_idr_lock);
-	qp = idr_find(&ehca_qp_idr, token);
-	read_unlock(&ehca_qp_idr_lock);
-
-
-	if (!qp)
-		return;
-
-	if (fatal)
-		ehca_error_data(shca, qp, qp->ipz_qp_handle.handle);
 
 	event.device = &shca->ib_device;
+	event.event = event_type;
 
 	if (qp->ext_type == EQPT_SRQ) {
 		if (!qp->ib_srq.event_handler)
 			return;
 
-		event.event = fatal ? IB_EVENT_SRQ_ERR : event_type;
 		event.element.srq = &qp->ib_srq;
 		qp->ib_srq.event_handler(&event, qp->ib_srq.srq_context);
 	} else {
 		if (!qp->ib_qp.event_handler)
 			return;
 
-		event.event = event_type;
 		event.element.qp = &qp->ib_qp;
 		qp->ib_qp.event_handler(&event, qp->ib_qp.qp_context);
 	}
+}
+
+static void qp_event_callback(struct ehca_shca *shca, u64 eqe,
+			      enum ib_event_type event_type, int fatal)
+{
+	struct ehca_qp *qp;
+	u32 token = EHCA_BMASK_GET(EQE_QP_TOKEN, eqe);
+
+	read_lock(&ehca_qp_idr_lock);
+	qp = idr_find(&ehca_qp_idr, token);
+	read_unlock(&ehca_qp_idr_lock);
+
+	if (!qp)
+		return;
+
+	if (fatal)
+		ehca_error_data(shca, qp, qp->ipz_qp_handle.handle);
+
+	dispatch_qp_event(shca, qp, fatal && qp->ext_type == EQPT_SRQ ?
+			  IB_EVENT_SRQ_ERR : event_type);
+
+	/*
+	 * eHCA only processes one WQE at a time for SRQ base QPs,
+	 * so the last WQE has been processed as soon as the QP enters
+	 * error state.
+	 */
+	if (fatal && qp->ext_type == EQPT_SRQBASE)
+		dispatch_qp_event(shca, qp, IB_EVENT_QP_LAST_WQE_REACHED);
 
 	return;
 }
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index b178cba..84d435a 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -600,10 +600,12 @@ static struct ehca_qp *internal_create_qp(
 
 	if (EHCA_BMASK_GET(HCA_CAP_MINI_QP, shca->hca_cap)
 	    && !(context && udata)) { /* no small QP support in userspace ATM */
-		ehca_determine_small_queue(
-			&parms.squeue, max_send_sge, is_llqp);
-		ehca_determine_small_queue(
-			&parms.rqueue, max_recv_sge, is_llqp);
+		if (HAS_SQ(my_qp))
+			ehca_determine_small_queue(
+				&parms.squeue, max_send_sge, is_llqp);
+		if (HAS_RQ(my_qp))
+			ehca_determine_small_queue(
+				&parms.rqueue, max_recv_sge, is_llqp);
 		parms.qp_storage =
 			(parms.squeue.is_small || parms.rqueue.is_small);
 	}
diff --git a/drivers/infiniband/hw/ehca/ipz_pt_fn.c b/drivers/infiniband/hw/ehca/ipz_pt_fn.c
index a090c67..29bd476 100644
--- a/drivers/infiniband/hw/ehca/ipz_pt_fn.c
+++ b/drivers/infiniband/hw/ehca/ipz_pt_fn.c
@@ -172,7 +172,7 @@ static void free_small_queue_page(struct ipz_queue *queue, struct ehca_pd *pd)
 	unsigned long bit;
 	int free_page = 0;
 
-	bit = ((unsigned long)queue->queue_pages[0] & PAGE_MASK)
+	bit = ((unsigned long)queue->queue_pages[0] & ~PAGE_MASK)
 		>> (order + 9);
 
 	mutex_lock(&pd->lock);
