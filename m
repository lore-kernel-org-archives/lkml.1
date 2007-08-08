Return-Path: <linux-kernel-owner+w=401wt.eu-S937621AbXHHSov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937621AbXHHSov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 14:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760974AbXHHSol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 14:44:41 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47280 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757829AbXHHSok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 14:44:40 -0400
From: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, openib-general@openib.org
Subject: [PATCH 7/7] IB/ehca: Prevent overwriting QP init attributes given by caller
Date: Wed, 8 Aug 2007 20:44:37 +0200
User-Agent: KMail/1.8.2
Cc: raisch@de.ibm.com, fenkes@de.ibm.com,
       "\"Hoang-Nam Nguyen\" @dyn-9-152-249-53" 
	<Hoang-Nam.Nguyen@d01av04.pok.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708082044.38247.ossrosch@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Roscher <stefan.roscher@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_qp.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index d8c1c22..6efda3d 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -709,12 +709,12 @@ static struct ehca_qp *internal_create_qp(
 		my_qp->ib_qp.event_handler = init_attr->event_handler;
 	}
 
-	init_attr->cap.max_inline_data = 0; /* not supported yet */
-	init_attr->cap.max_recv_sge = parms.rqueue.act_nr_sges;
-	init_attr->cap.max_recv_wr = parms.rqueue.act_nr_wqes;
-	init_attr->cap.max_send_sge = parms.squeue.act_nr_sges;
-	init_attr->cap.max_send_wr = parms.squeue.act_nr_wqes;
 	my_qp->init_attr = *init_attr;
+	my_qp->init_attr.cap.max_inline_data = 0; /* not supported yet */
+	my_qp->init_attr.cap.max_recv_sge = parms.rqueue.act_nr_sges;
+	my_qp->init_attr.cap.max_recv_wr = parms.rqueue.act_nr_wqes;
+	my_qp->init_attr.cap.max_send_sge = parms.squeue.act_nr_sges;
+	my_qp->init_attr.cap.max_send_wr = parms.squeue.act_nr_wqes;
 
 	/* NOTE: define_apq0() not supported yet */
 	if (qp_type == IB_QPT_GSI) {
@@ -825,10 +825,6 @@ struct ib_srq *ehca_create_srq(struct ib_pd *pd,
 	if (IS_ERR(my_qp))
 		return (struct ib_srq *)my_qp;
 
-	/* copy back return values */
-	srq_init_attr->attr.max_wr = qp_init_attr.cap.max_recv_wr;
-	srq_init_attr->attr.max_sge = qp_init_attr.cap.max_recv_sge;
-
 	/* drive SRQ into RTR state */
 	mqpcb = ehca_alloc_fw_ctrlblock(GFP_KERNEL);
 	if (!mqpcb) {
-- 
1.5.2


