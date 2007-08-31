Return-Path: <linux-kernel-owner+w=401wt.eu-S965864AbXHaOEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965864AbXHaOEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 10:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965768AbXHaODm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 10:03:42 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:36374 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965762AbXHaODl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 10:03:41 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 2/2] IB/ehca: SRQ fixes to enable IPoIB CM
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200708311601.42220.fenkes@de.ibm.com>
In-Reply-To: <200708311601.42220.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2672
Date: Fri, 31 Aug 2007 16:03:37 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708311603.38822.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

a) Report max_srq > 0 if SRQ is supported
b) Report "last wqe reached" event when base QP dies

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_hca.c |   10 +++++--
 drivers/infiniband/hw/ehca/ehca_irq.c |   48 +++++++++++++++++++++-----------
 2 files changed, 38 insertions(+), 20 deletions(-)

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
-- 
1.5.2


