Return-Path: <linux-kernel-owner+w=401wt.eu-S1422998AbXCOWUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422998AbXCOWUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422963AbXCOWTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:19:39 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33710 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933846AbXCOWP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:28 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 10 of 33] IB/ipath - fix PSN update for RC retries
X-Mercurial-Node: 4050989280f08d81d06642e3d6cf5c3ea4397107
Message-Id: <4050989280f08d81d066.1173995094@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:44:54 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Ralph Campbell <ralph.campbell@qlogic.com>
# Date 1173994464 25200
# Node ID 4050989280f08d81d06642e3d6cf5c3ea4397107
# Parent  ec38d8f91d79a765cf53aaa7e8a59622418f2c9f
IB/ipath - fix PSN update for RC retries

This patch fixes a number of bugs with updating the PSN for retries of
RC requests.

Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r ec38d8f91d79 -r 4050989280f0 drivers/infiniband/hw/ipath/ipath_rc.c
--- a/drivers/infiniband/hw/ipath/ipath_rc.c	Thu Mar 15 14:34:24 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_rc.c	Thu Mar 15 14:34:24 2007 -0700
@@ -444,7 +444,7 @@ int ipath_make_rc_req(struct ipath_qp *q
 			qp->s_psn = wqe->lpsn + 1;
 		else {
 			qp->s_psn++;
-			if ((int)(qp->s_psn - qp->s_next_psn) > 0)
+			if (ipath_cmp24(qp->s_psn, qp->s_next_psn) > 0)
 				qp->s_next_psn = qp->s_psn;
 		}
 		/*
@@ -471,7 +471,7 @@ int ipath_make_rc_req(struct ipath_qp *q
 		/* FALLTHROUGH */
 	case OP(SEND_MIDDLE):
 		bth2 = qp->s_psn++ & IPATH_PSN_MASK;
-		if ((int)(qp->s_psn - qp->s_next_psn) > 0)
+		if (ipath_cmp24(qp->s_psn, qp->s_next_psn) > 0)
 			qp->s_next_psn = qp->s_psn;
 		ss = &qp->s_sge;
 		len = qp->s_len;
@@ -507,7 +507,7 @@ int ipath_make_rc_req(struct ipath_qp *q
 		/* FALLTHROUGH */
 	case OP(RDMA_WRITE_MIDDLE):
 		bth2 = qp->s_psn++ & IPATH_PSN_MASK;
-		if ((int)(qp->s_psn - qp->s_next_psn) > 0)
+		if (ipath_cmp24(qp->s_psn, qp->s_next_psn) > 0)
 			qp->s_next_psn = qp->s_psn;
 		ss = &qp->s_sge;
 		len = qp->s_len;
@@ -546,7 +546,7 @@ int ipath_make_rc_req(struct ipath_qp *q
 		qp->s_state = OP(RDMA_READ_REQUEST);
 		hwords += sizeof(ohdr->u.rc.reth) / sizeof(u32);
 		bth2 = qp->s_psn++ & IPATH_PSN_MASK;
-		if ((int)(qp->s_psn - qp->s_next_psn) > 0)
+		if (ipath_cmp24(qp->s_psn, qp->s_next_psn) > 0)
 			qp->s_next_psn = qp->s_psn;
 		ss = NULL;
 		len = 0;
@@ -779,7 +779,7 @@ void ipath_restart_rc(struct ipath_qp *q
 	if (wqe->wr.opcode == IB_WR_RDMA_READ)
 		dev->n_rc_resends++;
 	else
-		dev->n_rc_resends += (int)qp->s_psn - (int)psn;
+		dev->n_rc_resends += (qp->s_psn - psn) & IPATH_PSN_MASK;
 
 	reset_psn(qp, psn);
 	tasklet_hi_schedule(&qp->s_task);
@@ -915,15 +915,19 @@ static int do_rc_ack(struct ipath_qp *qp
 		if (qp->s_last == qp->s_cur) {
 			if (++qp->s_cur >= qp->s_size)
 				qp->s_cur = 0;
+			qp->s_last = qp->s_cur;
+			if (qp->s_last == qp->s_tail)
+				break;
 			wqe = get_swqe_ptr(qp, qp->s_cur);
 			qp->s_state = OP(SEND_LAST);
 			qp->s_psn = wqe->psn;
-		}
-		if (++qp->s_last >= qp->s_size)
-			qp->s_last = 0;
-		wqe = get_swqe_ptr(qp, qp->s_last);
-		if (qp->s_last == qp->s_tail)
-			break;
+		} else {
+			if (++qp->s_last >= qp->s_size)
+				qp->s_last = 0;
+			if (qp->s_last == qp->s_tail)
+				break;
+			wqe = get_swqe_ptr(qp, qp->s_last);
+		}
 	}
 
 	switch (aeth >> 29) {
@@ -935,6 +939,18 @@ static int do_rc_ack(struct ipath_qp *qp
 			list_add_tail(&qp->timerwait,
 				      &dev->pending[dev->pending_index]);
 			spin_unlock(&dev->pending_lock);
+			/*
+			 * If we get a partial ACK for a resent operation,
+			 * we can stop resending the earlier packets and
+			 * continue with the next packet the receiver wants.
+			 */
+			if (ipath_cmp24(qp->s_psn, psn) <= 0) {
+				reset_psn(qp, psn + 1);
+				tasklet_hi_schedule(&qp->s_task);
+			}
+		} else if (ipath_cmp24(qp->s_psn, psn) <= 0) {
+			qp->s_state = OP(SEND_LAST);
+			qp->s_psn = psn + 1;
 		}
 		ipath_get_credit(qp, aeth);
 		qp->s_rnr_retry = qp->s_rnr_retry_cnt;
@@ -945,22 +961,23 @@ static int do_rc_ack(struct ipath_qp *qp
 
 	case 1:		/* RNR NAK */
 		dev->n_rnr_naks++;
+		if (qp->s_last == qp->s_tail)
+			goto bail;
 		if (qp->s_rnr_retry == 0) {
-			if (qp->s_last == qp->s_tail)
-				goto bail;
-
 			wc.status = IB_WC_RNR_RETRY_EXC_ERR;
 			goto class_b;
 		}
 		if (qp->s_rnr_retry_cnt < 7)
 			qp->s_rnr_retry--;
-		if (qp->s_last == qp->s_tail)
-			goto bail;
 
 		/* The last valid PSN is the previous PSN. */
 		update_last_psn(qp, psn - 1);
 
-		dev->n_rc_resends += (int)qp->s_psn - (int)psn;
+		if (wqe->wr.opcode == IB_WR_RDMA_READ)
+			dev->n_rc_resends++;
+		else
+			dev->n_rc_resends +=
+				(qp->s_psn - psn) & IPATH_PSN_MASK;
 
 		reset_psn(qp, psn);
 
@@ -971,26 +988,20 @@ static int do_rc_ack(struct ipath_qp *qp
 		goto bail;
 
 	case 3:		/* NAK */
-		/* The last valid PSN seen is the previous request's. */
-		if (qp->s_last != qp->s_tail)
-			update_last_psn(qp, wqe->psn - 1);
+		if (qp->s_last == qp->s_tail)
+			goto bail;
+		/* The last valid PSN is the previous PSN. */
+		update_last_psn(qp, psn - 1);
 		switch ((aeth >> IPATH_AETH_CREDIT_SHIFT) &
 			IPATH_AETH_CREDIT_MASK) {
 		case 0:	/* PSN sequence error */
 			dev->n_seq_naks++;
 			/*
-			 * Back up to the responder's expected PSN.  XXX
+			 * Back up to the responder's expected PSN.
 			 * Note that we might get a NAK in the middle of an
 			 * RDMA READ response which terminates the RDMA
 			 * READ.
 			 */
-			if (qp->s_last == qp->s_tail)
-				break;
-
-			if (ipath_cmp24(psn, wqe->psn) < 0)
-				break;
-
-			/* Retry the request. */
 			ipath_restart_rc(qp, psn, &wc);
 			break;
 
