Return-Path: <linux-kernel-owner+w=401wt.eu-S933921AbXCOWVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933921AbXCOWVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422640AbXCOWTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:19:36 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33713 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398AbXCOWP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:28 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 09 of 33] IB/ipath - fix QP error completion queue entries
X-Mercurial-Node: ec38d8f91d79a765cf53aaa7e8a59622418f2c9f
Message-Id: <ec38d8f91d79a765cf53.1173995093@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:44:53 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Ralph Campbell <ralph.campbell@qlogic.com>
# Date 1173994464 25200
# Node ID ec38d8f91d79a765cf53aaa7e8a59622418f2c9f
# Parent  187ff5af5e5dd2b1f2ca48ba6ad0056ce7fc7403
IB/ipath - fix QP error completion queue entries

When switching to the QP error state, the completion queue entries
(error or flush) were not being generated correctly.

Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r 187ff5af5e5d -r ec38d8f91d79 drivers/infiniband/hw/ipath/ipath_qp.c
--- a/drivers/infiniband/hw/ipath/ipath_qp.c	Thu Mar 15 14:34:24 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_qp.c	Thu Mar 15 14:34:24 2007 -0700
@@ -361,7 +361,7 @@ static void ipath_reset_qp(struct ipath_
  * @err: the receive completion error to signal if a RWQE is active
  *
  * Flushes both send and receive work queues.
- * QP s_lock should be held and interrupts disabled.
+ * The QP s_lock should be held and interrupts disabled.
  */
 
 void ipath_error_qp(struct ipath_qp *qp, enum ib_wc_status err)
@@ -393,6 +393,8 @@ void ipath_error_qp(struct ipath_qp *qp,
 	wc.port_num = 0;
 	if (qp->r_wrid_valid) {
 		qp->r_wrid_valid = 0;
+		wc.wr_id = qp->r_wr_id;
+		wc.opcode = IB_WC_RECV;
 		wc.status = err;
 		ipath_cq_enter(to_icq(qp->ibqp.send_cq), &wc, 1);
 	}
@@ -972,7 +974,7 @@ bail:
  * @wc: the WC responsible for putting the QP in this state
  *
  * Flushes the send work queue.
- * The QP s_lock should be held.
+ * The QP s_lock should be held and interrupts disabled.
  */
 
 void ipath_sqerror_qp(struct ipath_qp *qp, struct ib_wc *wc)
@@ -998,12 +1000,12 @@ void ipath_sqerror_qp(struct ipath_qp *q
 	wc->status = IB_WC_WR_FLUSH_ERR;
 
 	while (qp->s_last != qp->s_head) {
+		wqe = get_swqe_ptr(qp, qp->s_last);
 		wc->wr_id = wqe->wr.wr_id;
 		wc->opcode = ib_ipath_wc_opcode[wqe->wr.opcode];
 		ipath_cq_enter(to_icq(qp->ibqp.send_cq), wc, 1);
 		if (++qp->s_last >= qp->s_size)
 			qp->s_last = 0;
-		wqe = get_swqe_ptr(qp, qp->s_last);
 	}
 	qp->s_cur = qp->s_tail = qp->s_head;
 	qp->state = IB_QPS_SQE;
diff -r 187ff5af5e5d -r ec38d8f91d79 drivers/infiniband/hw/ipath/ipath_rc.c
--- a/drivers/infiniband/hw/ipath/ipath_rc.c	Thu Mar 15 14:34:24 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_rc.c	Thu Mar 15 14:34:24 2007 -0700
@@ -895,8 +895,10 @@ static int do_rc_ack(struct ipath_qp *qp
 			wc.opcode = ib_ipath_wc_opcode[wqe->wr.opcode];
 			wc.vendor_err = 0;
 			wc.byte_len = wqe->length;
+			wc.imm_data = 0;
 			wc.qp = &qp->ibqp;
 			wc.src_qp = qp->remote_qpn;
+			wc.wc_flags = 0;
 			wc.pkey_index = 0;
 			wc.slid = qp->remote_ah_attr.dlid;
 			wc.sl = qp->remote_ah_attr.sl;
