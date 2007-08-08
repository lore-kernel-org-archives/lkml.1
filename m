Return-Path: <linux-kernel-owner+w=401wt.eu-S938262AbXHHSn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938262AbXHHSn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 14:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761235AbXHHSnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 14:43:50 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44199 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760709AbXHHSnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 14:43:49 -0400
From: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, openib-general@openib.org
Subject: [PATCH 6/7] IB/ehca: Generate last WQE reached, when base QP for SRQ has entered error state
Date: Wed, 8 Aug 2007 20:43:46 +0200
User-Agent: KMail/1.8.2
Cc: raisch@de.ibm.com, fenkes@de.ibm.com,
       "\"Hoang-Nam Nguyen\" @dyn-9-152-249-53" 
	<Hoang-Nam.Nguyen@d01av04.pok.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708082043.47353.ossrosch@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joachim Fenkes <fenkes@de.ibm.com>
Date: Wed, 8 Aug 2007 19:51:30 +0200

Signed-off-by: Stefan Roscher <stefan.roscher@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_irq.c |   48 +++++++++++++++++++++-----------
 1 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index ee06d8b..941816a 100644
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



