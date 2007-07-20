Return-Path: <linux-kernel-owner+w=401wt.eu-S1762063AbXGTNvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762063AbXGTNvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 09:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759716AbXGTNvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 09:51:14 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:41958 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759115AbXGTNvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 09:51:12 -0400
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, openib-general@openib.org
Subject: [PATCH 2/5] ehca: Generate event when SRQ limit reached
Date: Fri, 20 Jul 2007 16:02:18 +0200
User-Agent: KMail/1.8.2
Cc: raisch@de.ibm.com, stefan.roscher@de.ibm.com, fenkes@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707201602.19142.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joachim Fenkes <fenkes@de.ibm.com>
Date: Thu, 19 Jul 2007 20:51:43 +0200
Subject: [PATCH 2/5] IB/ehca: Generate event when SRQ limit reached

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_irq.c |   42 ++++++++++++++++++++++-----------
 1 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index 4fb01fc..71c0799 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -175,9 +175,8 @@ error_data1:
 
 }
 
-static void qp_event_callback(struct ehca_shca *shca,
-			      u64 eqe,
-			      enum ib_event_type event_type)
+static void qp_event_callback(struct ehca_shca *shca, u64 eqe,
+			      enum ib_event_type event_type, int fatal)
 {
 	struct ib_event event;
 	struct ehca_qp *qp;
@@ -191,16 +190,26 @@ static void qp_event_callback(struct ehca_shca *shca,
 	if (!qp)
 		return;
 
-	ehca_error_data(shca, qp, qp->ipz_qp_handle.handle);
+	if (fatal)
+		ehca_error_data(shca, qp, qp->ipz_qp_handle.handle);
 
-	if (!qp->ib_qp.event_handler)
-		return;
+	event.device = &shca->ib_device;
 
-	event.device     = &shca->ib_device;
-	event.event      = event_type;
-	event.element.qp = &qp->ib_qp;
+	if (qp->ext_type == EQPT_SRQ) {
+		if (!qp->ib_srq.event_handler)
+			return;
 
-	qp->ib_qp.event_handler(&event, qp->ib_qp.qp_context);
+		event.event = fatal ? IB_EVENT_SRQ_ERR : event_type;
+		event.element.srq = &qp->ib_srq;
+		qp->ib_srq.event_handler(&event, qp->ib_srq.srq_context);
+	} else {
+		if (!qp->ib_qp.event_handler)
+			return;
+
+		event.event = event_type;
+		event.element.qp = &qp->ib_qp;
+		qp->ib_qp.event_handler(&event, qp->ib_qp.qp_context);
+	}
 
 	return;
 }
@@ -234,17 +243,17 @@ static void parse_identifier(struct ehca_shca *shca, u64 eqe)
 
 	switch (identifier) {
 	case 0x02: /* path migrated */
-		qp_event_callback(shca, eqe, IB_EVENT_PATH_MIG);
+		qp_event_callback(shca, eqe, IB_EVENT_PATH_MIG, 0);
 		break;
 	case 0x03: /* communication established */
-		qp_event_callback(shca, eqe, IB_EVENT_COMM_EST);
+		qp_event_callback(shca, eqe, IB_EVENT_COMM_EST, 0);
 		break;
 	case 0x04: /* send queue drained */
-		qp_event_callback(shca, eqe, IB_EVENT_SQ_DRAINED);
+		qp_event_callback(shca, eqe, IB_EVENT_SQ_DRAINED, 0);
 		break;
 	case 0x05: /* QP error */
 	case 0x06: /* QP error */
-		qp_event_callback(shca, eqe, IB_EVENT_QP_FATAL);
+		qp_event_callback(shca, eqe, IB_EVENT_QP_FATAL, 1);
 		break;
 	case 0x07: /* CQ error */
 	case 0x08: /* CQ error */
@@ -278,6 +287,11 @@ static void parse_identifier(struct ehca_shca *shca, u64 eqe)
 		ehca_err(&shca->ib_device, "Interface trace stopped.");
 		break;
 	case 0x14: /* first error capture info available */
+		ehca_info(&shca->ib_device, "First error capture available");
+		break;
+	case 0x15: /* SRQ limit reached */
+		qp_event_callback(shca, eqe, IB_EVENT_SRQ_LIMIT_REACHED, 0);
+		break;
 	default:
 		ehca_err(&shca->ib_device, "Unknown identifier: %x on %s.",
 			 identifier, shca->ib_device.name);
-- 
1.5.2


