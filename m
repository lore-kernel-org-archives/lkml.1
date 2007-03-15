Return-Path: <linux-kernel-owner+w=401wt.eu-S933940AbXCOW2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933940AbXCOW2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933927AbXCOW2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:28:40 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33696 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbXCOWP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:26 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 07 of 33] IB/ipath - support larger IB_QP_MAX_DEST_RD_ATOMIC
	and IB_QP_MAX_QP_RD_ATOMIC
X-Mercurial-Node: 02b57b02578b7ffb189de66f7886214e9d5f2045
Message-Id: <02b57b02578b7ffb189d.1173995091@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:44:51 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Ralph Campbell <ralph.campbell@qlogic.com>
# Date 1173994464 25200
# Node ID 02b57b02578b7ffb189de66f7886214e9d5f2045
# Parent  78ae7bddbd5e205adc12993ad2956e0402ca01d7
IB/ipath - support larger IB_QP_MAX_DEST_RD_ATOMIC and IB_QP_MAX_QP_RD_ATOMIC

This patch adds support for multiple RDMA reads and atomics to be
sent before an ACK is required to be seen by the requester.

Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r 78ae7bddbd5e -r 02b57b02578b drivers/infiniband/hw/ipath/ipath_qp.c
--- a/drivers/infiniband/hw/ipath/ipath_qp.c	Thu Mar 15 14:34:24 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_qp.c	Thu Mar 15 14:34:24 2007 -0700
@@ -320,7 +320,8 @@ static void ipath_reset_qp(struct ipath_
 	qp->remote_qpn = 0;
 	qp->qkey = 0;
 	qp->qp_access_flags = 0;
-	clear_bit(IPATH_S_BUSY, &qp->s_flags);
+	qp->s_busy = 0;
+	qp->s_flags &= ~IPATH_S_SIGNAL_REQ_WR;
 	qp->s_hdrwords = 0;
 	qp->s_psn = 0;
 	qp->r_psn = 0;
@@ -333,7 +334,6 @@ static void ipath_reset_qp(struct ipath_
 		qp->r_state = IB_OPCODE_UC_SEND_LAST;
 	}
 	qp->s_ack_state = IB_OPCODE_RC_ACKNOWLEDGE;
-	qp->r_ack_state = IB_OPCODE_RC_ACKNOWLEDGE;
 	qp->r_nak_state = 0;
 	qp->r_wrid_valid = 0;
 	qp->s_rnr_timeout = 0;
@@ -344,6 +344,10 @@ static void ipath_reset_qp(struct ipath_
 	qp->s_ssn = 1;
 	qp->s_lsn = 0;
 	qp->s_wait_credit = 0;
+	memset(qp->s_ack_queue, 0, sizeof(qp->s_ack_queue));
+	qp->r_head_ack_queue = 0;
+	qp->s_tail_ack_queue = 0;
+	qp->s_num_rd_atomic = 0;
 	if (qp->r_rq.wq) {
 		qp->r_rq.wq->head = 0;
 		qp->r_rq.wq->tail = 0;
@@ -503,6 +507,10 @@ int ipath_modify_qp(struct ib_qp *ibqp, 
 		    attr->path_mig_state != IB_MIG_REARM)
 			goto inval;
 
+	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC)
+		if (attr->max_dest_rd_atomic > IPATH_MAX_RDMA_ATOMIC)
+			goto inval;
+
 	switch (new_state) {
 	case IB_QPS_RESET:
 		ipath_reset_qp(qp);
@@ -558,6 +566,12 @@ int ipath_modify_qp(struct ib_qp *ibqp, 
 
 	if (attr_mask & IB_QP_QKEY)
 		qp->qkey = attr->qkey;
+
+	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC)
+		qp->r_max_rd_atomic = attr->max_dest_rd_atomic;
+
+	if (attr_mask & IB_QP_MAX_QP_RD_ATOMIC)
+		qp->s_max_rd_atomic = attr->max_rd_atomic;
 
 	qp->state = new_state;
 	spin_unlock_irqrestore(&qp->s_lock, flags);
@@ -598,8 +612,8 @@ int ipath_query_qp(struct ib_qp *ibqp, s
 	attr->alt_pkey_index = 0;
 	attr->en_sqd_async_notify = 0;
 	attr->sq_draining = 0;
-	attr->max_rd_atomic = 1;
-	attr->max_dest_rd_atomic = 1;
+	attr->max_rd_atomic = qp->s_max_rd_atomic;
+	attr->max_dest_rd_atomic = qp->r_max_rd_atomic;
 	attr->min_rnr_timer = qp->r_min_rnr_timer;
 	attr->port_num = 1;
 	attr->timeout = qp->timeout;
@@ -614,7 +628,7 @@ int ipath_query_qp(struct ib_qp *ibqp, s
 	init_attr->recv_cq = qp->ibqp.recv_cq;
 	init_attr->srq = qp->ibqp.srq;
 	init_attr->cap = attr->cap;
-	if (qp->s_flags & (1 << IPATH_S_SIGNAL_REQ_WR))
+	if (qp->s_flags & IPATH_S_SIGNAL_REQ_WR)
 		init_attr->sq_sig_type = IB_SIGNAL_REQ_WR;
 	else
 		init_attr->sq_sig_type = IB_SIGNAL_ALL_WR;
@@ -786,7 +800,7 @@ struct ib_qp *ipath_create_qp(struct ib_
 		qp->s_size = init_attr->cap.max_send_wr + 1;
 		qp->s_max_sge = init_attr->cap.max_send_sge;
 		if (init_attr->sq_sig_type == IB_SIGNAL_REQ_WR)
-			qp->s_flags = 1 << IPATH_S_SIGNAL_REQ_WR;
+			qp->s_flags = IPATH_S_SIGNAL_REQ_WR;
 		else
 			qp->s_flags = 0;
 		dev = to_idev(ibpd->device);
diff -r 78ae7bddbd5e -r 02b57b02578b drivers/infiniband/hw/ipath/ipath_rc.c
--- a/drivers/infiniband/hw/ipath/ipath_rc.c	Thu Mar 15 14:34:24 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_rc.c	Thu Mar 15 14:34:24 2007 -0700
@@ -37,6 +37,19 @@
 /* cut down ridiculously long IB macro names */
 #define OP(x) IB_OPCODE_RC_##x
 
+static u32 restart_sge(struct ipath_sge_state *ss, struct ipath_swqe *wqe,
+		       u32 psn, u32 pmtu)
+{
+	u32 len;
+
+	len = ((psn - wqe->psn) & IPATH_PSN_MASK) * pmtu;
+	ss->sge = wqe->sg_list[0];
+	ss->sg_list = wqe->sg_list + 1;
+	ss->num_sge = wqe->wr.num_sge;
+	ipath_skip_sge(ss, len);
+	return wqe->length - len;
+}
+
 /**
  * ipath_init_restart- initialize the qp->s_sge after a restart
  * @qp: the QP who's SGE we're restarting
@@ -47,15 +60,9 @@ static void ipath_init_restart(struct ip
 static void ipath_init_restart(struct ipath_qp *qp, struct ipath_swqe *wqe)
 {
 	struct ipath_ibdev *dev;
-	u32 len;
-
-	len = ((qp->s_psn - wqe->psn) & IPATH_PSN_MASK) *
-		ib_mtu_enum_to_int(qp->path_mtu);
-	qp->s_sge.sge = wqe->sg_list[0];
-	qp->s_sge.sg_list = wqe->sg_list + 1;
-	qp->s_sge.num_sge = wqe->wr.num_sge;
-	ipath_skip_sge(&qp->s_sge, len);
-	qp->s_len = wqe->length - len;
+
+	qp->s_len = restart_sge(&qp->s_sge, wqe, qp->s_psn,
+				ib_mtu_enum_to_int(qp->path_mtu));
 	dev = to_idev(qp->ibqp.device);
 	spin_lock(&dev->pending_lock);
 	if (list_empty(&qp->timerwait))
@@ -70,107 +77,123 @@ static void ipath_init_restart(struct ip
  * @ohdr: a pointer to the IB header being constructed
  * @pmtu: the path MTU
  *
- * Return bth0 if constructed; otherwise, return 0.
+ * Return 1 if constructed; otherwise, return 0.
+ * Note that we are in the responder's side of the QP context.
  * Note the QP s_lock must be held.
  */
-u32 ipath_make_rc_ack(struct ipath_qp *qp,
-		      struct ipath_other_headers *ohdr,
-		      u32 pmtu)
+static int ipath_make_rc_ack(struct ipath_qp *qp,
+			     struct ipath_other_headers *ohdr,
+			     u32 pmtu, u32 *bth0p, u32 *bth2p)
 {
+	struct ipath_ack_entry *e;
 	u32 hwords;
 	u32 len;
 	u32 bth0;
+	u32 bth2;
 
 	/* header size in 32-bit words LRH+BTH = (8+12)/4. */
 	hwords = 5;
 
-	/*
-	 * Send a response.  Note that we are in the responder's
-	 * side of the QP context.
-	 */
 	switch (qp->s_ack_state) {
-	case OP(RDMA_READ_REQUEST):
-		qp->s_cur_sge = &qp->s_rdma_sge;
-		len = qp->s_rdma_len;
-		if (len > pmtu) {
-			len = pmtu;
-			qp->s_ack_state = OP(RDMA_READ_RESPONSE_FIRST);
-		} else
-			qp->s_ack_state = OP(RDMA_READ_RESPONSE_ONLY);
-		qp->s_rdma_len -= len;
+	case OP(RDMA_READ_RESPONSE_LAST):
+	case OP(RDMA_READ_RESPONSE_ONLY):
+	case OP(ATOMIC_ACKNOWLEDGE):
+		qp->s_ack_state = OP(ACKNOWLEDGE);
+		/* FALLTHROUGH */
+	case OP(ACKNOWLEDGE):
+		/* Check for no next entry in the queue. */
+		if (qp->r_head_ack_queue == qp->s_tail_ack_queue) {
+			if (qp->s_flags & IPATH_S_ACK_PENDING)
+				goto normal;
+			goto bail;
+		}
+
+		e = &qp->s_ack_queue[qp->s_tail_ack_queue];
+		if (e->opcode == OP(RDMA_READ_REQUEST)) {
+			/* Copy SGE state in case we need to resend */
+			qp->s_ack_rdma_sge = e->rdma_sge;
+			qp->s_cur_sge = &qp->s_ack_rdma_sge;
+			len = e->rdma_sge.sge.sge_length;
+			if (len > pmtu) {
+				len = pmtu;
+				qp->s_ack_state = OP(RDMA_READ_RESPONSE_FIRST);
+			} else {
+				qp->s_ack_state = OP(RDMA_READ_RESPONSE_ONLY);
+				if (++qp->s_tail_ack_queue >
+				    IPATH_MAX_RDMA_ATOMIC)
+					qp->s_tail_ack_queue = 0;
+			}
+			ohdr->u.aeth = ipath_compute_aeth(qp);
+			hwords++;
+			qp->s_ack_rdma_psn = e->psn;
+			bth2 = qp->s_ack_rdma_psn++ & IPATH_PSN_MASK;
+		} else {
+			/* COMPARE_SWAP or FETCH_ADD */
+			qp->s_cur_sge = NULL;
+			len = 0;
+			qp->s_ack_state = OP(ATOMIC_ACKNOWLEDGE);
+			ohdr->u.at.aeth = ipath_compute_aeth(qp);
+			ohdr->u.at.atomic_ack_eth[0] =
+				cpu_to_be32(e->atomic_data >> 32);
+			ohdr->u.at.atomic_ack_eth[1] =
+				cpu_to_be32(e->atomic_data);
+			hwords += sizeof(ohdr->u.at) / sizeof(u32);
+			bth2 = e->psn;
+			if (++qp->s_tail_ack_queue > IPATH_MAX_RDMA_ATOMIC)
+				qp->s_tail_ack_queue = 0;
+		}
 		bth0 = qp->s_ack_state << 24;
-		ohdr->u.aeth = ipath_compute_aeth(qp);
-		hwords++;
 		break;
 
 	case OP(RDMA_READ_RESPONSE_FIRST):
 		qp->s_ack_state = OP(RDMA_READ_RESPONSE_MIDDLE);
 		/* FALLTHROUGH */
 	case OP(RDMA_READ_RESPONSE_MIDDLE):
-		qp->s_cur_sge = &qp->s_rdma_sge;
-		len = qp->s_rdma_len;
+		len = qp->s_ack_rdma_sge.sge.sge_length;
 		if (len > pmtu)
 			len = pmtu;
 		else {
 			ohdr->u.aeth = ipath_compute_aeth(qp);
 			hwords++;
 			qp->s_ack_state = OP(RDMA_READ_RESPONSE_LAST);
-		}
-		qp->s_rdma_len -= len;
+			if (++qp->s_tail_ack_queue > IPATH_MAX_RDMA_ATOMIC)
+				qp->s_tail_ack_queue = 0;
+		}
 		bth0 = qp->s_ack_state << 24;
+		bth2 = qp->s_ack_rdma_psn++ & IPATH_PSN_MASK;
 		break;
 
-	case OP(RDMA_READ_RESPONSE_LAST):
-	case OP(RDMA_READ_RESPONSE_ONLY):
-		/*
-		 * We have to prevent new requests from changing
-		 * the r_sge state while a ipath_verbs_send()
-		 * is in progress.
-		 */
-		qp->s_ack_state = OP(ACKNOWLEDGE);
-		bth0 = 0;
-		goto bail;
-
-	case OP(COMPARE_SWAP):
-	case OP(FETCH_ADD):
+	default:
+	normal:
+		/*
+		 * Send a regular ACK.
+		 * Set the s_ack_state so we wait until after sending
+		 * the ACK before setting s_ack_state to ACKNOWLEDGE
+		 * (see above).
+		 */
+		qp->s_ack_state = OP(ATOMIC_ACKNOWLEDGE);
+		qp->s_flags &= ~IPATH_S_ACK_PENDING;
 		qp->s_cur_sge = NULL;
-		len = 0;
-		/*
-		 * Set the s_ack_state so the receive interrupt handler
-		 * won't try to send an ACK (out of order) until this one
-		 * is actually sent.
-		 */
-		qp->s_ack_state = OP(RDMA_READ_RESPONSE_LAST);
-		bth0 = OP(ATOMIC_ACKNOWLEDGE) << 24;
-		ohdr->u.at.aeth = ipath_compute_aeth(qp);
-		ohdr->u.at.atomic_ack_eth = cpu_to_be64(qp->r_atomic_data);
-		hwords += sizeof(ohdr->u.at) / 4;
-		break;
-
-	default:
-		/* Send a regular ACK. */
-		qp->s_cur_sge = NULL;
-		len = 0;
-		/*
-		 * Set the s_ack_state so the receive interrupt handler
-		 * won't try to send an ACK (out of order) until this one
-		 * is actually sent.
-		 */
-		qp->s_ack_state = OP(RDMA_READ_RESPONSE_LAST);
-		bth0 = OP(ACKNOWLEDGE) << 24;
 		if (qp->s_nak_state)
-			ohdr->u.aeth = cpu_to_be32((qp->r_msn & IPATH_MSN_MASK) |
-						    (qp->s_nak_state <<
-						     IPATH_AETH_CREDIT_SHIFT));
+			ohdr->u.aeth =
+				cpu_to_be32((qp->r_msn & IPATH_MSN_MASK) |
+					    (qp->s_nak_state <<
+					     IPATH_AETH_CREDIT_SHIFT));
 		else
 			ohdr->u.aeth = ipath_compute_aeth(qp);
 		hwords++;
+		len = 0;
+		bth0 = OP(ACKNOWLEDGE) << 24;
+		bth2 = qp->s_ack_psn & IPATH_PSN_MASK;
 	}
 	qp->s_hdrwords = hwords;
 	qp->s_cur_size = len;
+	*bth0p = bth0;
+	*bth2p = bth2;
+	return 1;
 
 bail:
-	return bth0;
+	return 0;
 }
 
 /**
@@ -197,9 +220,16 @@ int ipath_make_rc_req(struct ipath_qp *q
 	u32 bth2;
 	char newreq;
 
+	/* Sending responses has higher priority over sending requests. */
+	if ((qp->r_head_ack_queue != qp->s_tail_ack_queue ||
+	     (qp->s_flags & IPATH_S_ACK_PENDING) ||
+	     qp->s_ack_state != IB_OPCODE_RC_ACKNOWLEDGE) &&
+	    ipath_make_rc_ack(qp, ohdr, pmtu, bth0p, bth2p))
+		goto done;
+
 	if (!(ib_ipath_state_ops[qp->state] & IPATH_PROCESS_SEND_OK) ||
 	    qp->s_rnr_timeout)
-		goto done;
+		goto bail;
 
 	/* Limit the number of packets sent without an ACK. */
 	if (ipath_cmp24(qp->s_psn, qp->s_last_psn + IPATH_PSN_CREDIT) > 0) {
@@ -210,7 +240,7 @@ int ipath_make_rc_req(struct ipath_qp *q
 			list_add_tail(&qp->timerwait,
 				      &dev->pending[dev->pending_index]);
 		spin_unlock(&dev->pending_lock);
-		goto done;
+		goto bail;
 	}
 
 	/* header size in 32-bit words LRH+BTH = (8+12)/4. */
@@ -232,7 +262,16 @@ int ipath_make_rc_req(struct ipath_qp *q
 		if (qp->s_cur == qp->s_tail) {
 			/* Check if send work queue is empty. */
 			if (qp->s_tail == qp->s_head)
-				goto done;
+				goto bail;
+			/*
+			 * If a fence is requested, wait for previous
+			 * RDMA read and atomic operations to finish.
+			 */
+			if ((wqe->wr.send_flags & IB_SEND_FENCE) &&
+			    qp->s_num_rd_atomic) {
+				qp->s_flags |= IPATH_S_FENCE_PENDING;
+				goto bail;
+			}
 			wqe->psn = qp->s_next_psn;
 			newreq = 1;
 		}
@@ -250,7 +289,7 @@ int ipath_make_rc_req(struct ipath_qp *q
 			/* If no credit, return. */
 			if (qp->s_lsn != (u32) -1 &&
 			    ipath_cmp24(wqe->ssn, qp->s_lsn + 1) > 0)
-				goto done;
+				goto bail;
 			wqe->lpsn = wqe->psn;
 			if (len > pmtu) {
 				wqe->lpsn += (len - 1) / pmtu;
@@ -281,13 +320,13 @@ int ipath_make_rc_req(struct ipath_qp *q
 			/* If no credit, return. */
 			if (qp->s_lsn != (u32) -1 &&
 			    ipath_cmp24(wqe->ssn, qp->s_lsn + 1) > 0)
-				goto done;
+				goto bail;
 			ohdr->u.rc.reth.vaddr =
 				cpu_to_be64(wqe->wr.wr.rdma.remote_addr);
 			ohdr->u.rc.reth.rkey =
 				cpu_to_be32(wqe->wr.wr.rdma.rkey);
 			ohdr->u.rc.reth.length = cpu_to_be32(len);
-			hwords += sizeof(struct ib_reth) / 4;
+			hwords += sizeof(struct ib_reth) / sizeof(u32);
 			wqe->lpsn = wqe->psn;
 			if (len > pmtu) {
 				wqe->lpsn += (len - 1) / pmtu;
@@ -312,14 +351,17 @@ int ipath_make_rc_req(struct ipath_qp *q
 			break;
 
 		case IB_WR_RDMA_READ:
-			ohdr->u.rc.reth.vaddr =
-				cpu_to_be64(wqe->wr.wr.rdma.remote_addr);
-			ohdr->u.rc.reth.rkey =
-				cpu_to_be32(wqe->wr.wr.rdma.rkey);
-			ohdr->u.rc.reth.length = cpu_to_be32(len);
-			qp->s_state = OP(RDMA_READ_REQUEST);
-			hwords += sizeof(ohdr->u.rc.reth) / 4;
+			/*
+			 * Don't allow more operations to be started
+			 * than the QP limits allow.
+			 */
 			if (newreq) {
+				if (qp->s_num_rd_atomic >=
+				    qp->s_max_rd_atomic) {
+					qp->s_flags |= IPATH_S_RDMAR_PENDING;
+					goto bail;
+				}
+				qp->s_num_rd_atomic++;
 				if (qp->s_lsn != (u32) -1)
 					qp->s_lsn++;
 				/*
@@ -330,6 +372,13 @@ int ipath_make_rc_req(struct ipath_qp *q
 					qp->s_next_psn += (len - 1) / pmtu;
 				wqe->lpsn = qp->s_next_psn++;
 			}
+			ohdr->u.rc.reth.vaddr =
+				cpu_to_be64(wqe->wr.wr.rdma.remote_addr);
+			ohdr->u.rc.reth.rkey =
+				cpu_to_be32(wqe->wr.wr.rdma.rkey);
+			ohdr->u.rc.reth.length = cpu_to_be32(len);
+			qp->s_state = OP(RDMA_READ_REQUEST);
+			hwords += sizeof(ohdr->u.rc.reth) / sizeof(u32);
 			ss = NULL;
 			len = 0;
 			if (++qp->s_cur == qp->s_size)
@@ -338,32 +387,48 @@ int ipath_make_rc_req(struct ipath_qp *q
 
 		case IB_WR_ATOMIC_CMP_AND_SWP:
 		case IB_WR_ATOMIC_FETCH_AND_ADD:
-			if (wqe->wr.opcode == IB_WR_ATOMIC_CMP_AND_SWP)
-				qp->s_state = OP(COMPARE_SWAP);
-			else
-				qp->s_state = OP(FETCH_ADD);
-			ohdr->u.atomic_eth.vaddr = cpu_to_be64(
-				wqe->wr.wr.atomic.remote_addr);
-			ohdr->u.atomic_eth.rkey = cpu_to_be32(
-				wqe->wr.wr.atomic.rkey);
-			ohdr->u.atomic_eth.swap_data = cpu_to_be64(
-				wqe->wr.wr.atomic.swap);
-			ohdr->u.atomic_eth.compare_data = cpu_to_be64(
-				wqe->wr.wr.atomic.compare_add);
-			hwords += sizeof(struct ib_atomic_eth) / 4;
+			/*
+			 * Don't allow more operations to be started
+			 * than the QP limits allow.
+			 */
 			if (newreq) {
+				if (qp->s_num_rd_atomic >=
+				    qp->s_max_rd_atomic) {
+					qp->s_flags |= IPATH_S_RDMAR_PENDING;
+					goto bail;
+				}
+				qp->s_num_rd_atomic++;
 				if (qp->s_lsn != (u32) -1)
 					qp->s_lsn++;
 				wqe->lpsn = wqe->psn;
 			}
+			if (wqe->wr.opcode == IB_WR_ATOMIC_CMP_AND_SWP) {
+				qp->s_state = OP(COMPARE_SWAP);
+				ohdr->u.atomic_eth.swap_data = cpu_to_be64(
+					wqe->wr.wr.atomic.swap);
+				ohdr->u.atomic_eth.compare_data = cpu_to_be64(
+					wqe->wr.wr.atomic.compare_add);
+			} else {
+				qp->s_state = OP(FETCH_ADD);
+				ohdr->u.atomic_eth.swap_data = cpu_to_be64(
+					wqe->wr.wr.atomic.compare_add);
+				ohdr->u.atomic_eth.compare_data = 0;
+			}
+			ohdr->u.atomic_eth.vaddr[0] = cpu_to_be32(
+				wqe->wr.wr.atomic.remote_addr >> 32);
+			ohdr->u.atomic_eth.vaddr[1] = cpu_to_be32(
+				wqe->wr.wr.atomic.remote_addr);
+			ohdr->u.atomic_eth.rkey = cpu_to_be32(
+				wqe->wr.wr.atomic.rkey);
+			hwords += sizeof(struct ib_atomic_eth) / sizeof(u32);
+			ss = NULL;
+			len = 0;
 			if (++qp->s_cur == qp->s_size)
 				qp->s_cur = 0;
-			ss = NULL;
-			len = 0;
 			break;
 
 		default:
-			goto done;
+			goto bail;
 		}
 		qp->s_sge.sge = wqe->sg_list[0];
 		qp->s_sge.sg_list = wqe->sg_list + 1;
@@ -479,7 +544,7 @@ int ipath_make_rc_req(struct ipath_qp *q
 			cpu_to_be32(wqe->wr.wr.rdma.rkey);
 		ohdr->u.rc.reth.length = cpu_to_be32(qp->s_len);
 		qp->s_state = OP(RDMA_READ_REQUEST);
-		hwords += sizeof(ohdr->u.rc.reth) / 4;
+		hwords += sizeof(ohdr->u.rc.reth) / sizeof(u32);
 		bth2 = qp->s_psn++ & IPATH_PSN_MASK;
 		if ((int)(qp->s_psn - qp->s_next_psn) > 0)
 			qp->s_next_psn = qp->s_psn;
@@ -489,20 +554,6 @@ int ipath_make_rc_req(struct ipath_qp *q
 		if (qp->s_cur == qp->s_size)
 			qp->s_cur = 0;
 		break;
-
-	case OP(RDMA_READ_REQUEST):
-	case OP(COMPARE_SWAP):
-	case OP(FETCH_ADD):
-		/*
-		 * We shouldn't start anything new until this request is
-		 * finished.  The ACK will handle rescheduling us.  XXX The
-		 * number of outstanding ones is negotiated at connection
-		 * setup time (see pg. 258,289)?  XXX Also, if we support
-		 * multiple outstanding requests, we need to check the WQE
-		 * IB_SEND_FENCE flag and not send a new request if a RDMA
-		 * read or atomic is pending.
-		 */
-		goto done;
 	}
 	if (ipath_cmp24(qp->s_psn, qp->s_last_psn + IPATH_PSN_CREDIT - 1) >= 0)
 		bth2 |= 1 << 31;	/* Request ACK. */
@@ -512,9 +563,10 @@ int ipath_make_rc_req(struct ipath_qp *q
 	qp->s_cur_size = len;
 	*bth0p = bth0 | (qp->s_state << 24);
 	*bth2p = bth2;
+done:
 	return 1;
 
-done:
+bail:
 	return 0;
 }
 
@@ -524,7 +576,8 @@ done:
  *
  * This is called from ipath_rc_rcv() and only uses the receive
  * side QP state.
- * Note that RDMA reads are handled in the send side QP state and tasklet.
+ * Note that RDMA reads and atomics are handled in the
+ * send side QP state and tasklet.
  */
 static void send_rc_ack(struct ipath_qp *qp)
 {
@@ -534,6 +587,10 @@ static void send_rc_ack(struct ipath_qp 
 	u32 hwords;
 	struct ipath_ib_header hdr;
 	struct ipath_other_headers *ohdr;
+
+	/* Don't send ACK or NAK if a RDMA read or atomic is pending. */
+	if (qp->r_head_ack_queue != qp->s_tail_ack_queue)
+		goto queue_ack;
 
 	/* Construct the header. */
 	ohdr = &hdr.u.oth;
@@ -548,19 +605,14 @@ static void send_rc_ack(struct ipath_qp 
 		lrh0 = IPATH_LRH_GRH;
 	}
 	/* read pkey_index w/o lock (its atomic) */
-	bth0 = ipath_get_pkey(dev->dd, qp->s_pkey_index);
+	bth0 = ipath_get_pkey(dev->dd, qp->s_pkey_index) |
+		OP(ACKNOWLEDGE) << 24;
 	if (qp->r_nak_state)
 		ohdr->u.aeth = cpu_to_be32((qp->r_msn & IPATH_MSN_MASK) |
 					    (qp->r_nak_state <<
 					     IPATH_AETH_CREDIT_SHIFT));
 	else
 		ohdr->u.aeth = ipath_compute_aeth(qp);
-	if (qp->r_ack_state >= OP(COMPARE_SWAP)) {
-		bth0 |= OP(ATOMIC_ACKNOWLEDGE) << 24;
-		ohdr->u.at.atomic_ack_eth = cpu_to_be64(qp->r_atomic_data);
-		hwords += sizeof(ohdr->u.at.atomic_ack_eth) / 4;
-	} else
-		bth0 |= OP(ACKNOWLEDGE) << 24;
 	lrh0 |= qp->remote_ah_attr.sl << 4;
 	hdr.lrh[0] = cpu_to_be16(lrh0);
 	hdr.lrh[1] = cpu_to_be16(qp->remote_ah_attr.dlid);
@@ -574,31 +626,31 @@ static void send_rc_ack(struct ipath_qp 
 	 * If we can send the ACK, clear the ACK state.
 	 */
 	if (ipath_verbs_send(dev->dd, hwords, (u32 *) &hdr, 0, NULL) == 0) {
-		qp->r_ack_state = OP(ACKNOWLEDGE);
 		dev->n_unicast_xmit++;
-	} else {
-		/*
-		 * We are out of PIO buffers at the moment.
-		 * Pass responsibility for sending the ACK to the
-		 * send tasklet so that when a PIO buffer becomes
-		 * available, the ACK is sent ahead of other outgoing
-		 * packets.
-		 */
-		dev->n_rc_qacks++;
-		spin_lock_irq(&qp->s_lock);
-		/* Don't coalesce if a RDMA read or atomic is pending. */
-		if (qp->s_ack_state == OP(ACKNOWLEDGE) ||
-		    qp->s_ack_state < OP(RDMA_READ_REQUEST)) {
-			qp->s_ack_state = qp->r_ack_state;
-			qp->s_nak_state = qp->r_nak_state;
-			qp->s_ack_psn = qp->r_ack_psn;
-			qp->r_ack_state = OP(ACKNOWLEDGE);
-		}
-		spin_unlock_irq(&qp->s_lock);
-
-		/* Call ipath_do_rc_send() in another thread. */
-		tasklet_hi_schedule(&qp->s_task);
-	}
+		goto done;
+	}
+
+	/*
+	 * We are out of PIO buffers at the moment.
+	 * Pass responsibility for sending the ACK to the
+	 * send tasklet so that when a PIO buffer becomes
+	 * available, the ACK is sent ahead of other outgoing
+	 * packets.
+	 */
+	dev->n_rc_qacks++;
+
+queue_ack:
+	spin_lock_irq(&qp->s_lock);
+	qp->s_flags |= IPATH_S_ACK_PENDING;
+	qp->s_nak_state = qp->r_nak_state;
+	qp->s_ack_psn = qp->r_ack_psn;
+	spin_unlock_irq(&qp->s_lock);
+
+	/* Call ipath_do_rc_send() in another thread. */
+	tasklet_hi_schedule(&qp->s_task);
+
+done:
+	return;
 }
 
 /**
@@ -775,10 +827,6 @@ static int do_rc_ack(struct ipath_qp *qp
 		list_del_init(&qp->timerwait);
 	spin_unlock(&dev->pending_lock);
 
-	/* Nothing is pending to ACK/NAK. */
-	if (unlikely(qp->s_last == qp->s_tail))
-		goto bail;
-
 	/*
 	 * Note that NAKs implicitly ACK outstanding SEND and RDMA write
 	 * requests and implicitly NAK RDMA read and atomic requests issued
@@ -806,7 +854,7 @@ static int do_rc_ack(struct ipath_qp *qp
 		 */
 		if ((wqe->wr.opcode == IB_WR_RDMA_READ &&
 		     (opcode != OP(RDMA_READ_RESPONSE_LAST) ||
-		       ipath_cmp24(ack_psn, wqe->lpsn) != 0)) ||
+		      ipath_cmp24(ack_psn, wqe->lpsn) != 0)) ||
 		    ((wqe->wr.opcode == IB_WR_ATOMIC_CMP_AND_SWP ||
 		      wqe->wr.opcode == IB_WR_ATOMIC_FETCH_AND_ADD) &&
 		     (opcode != OP(ATOMIC_ACKNOWLEDGE) ||
@@ -824,12 +872,23 @@ static int do_rc_ack(struct ipath_qp *qp
 			 */
 			goto bail;
 		}
-		if (wqe->wr.opcode == IB_WR_RDMA_READ ||
-		    wqe->wr.opcode == IB_WR_ATOMIC_CMP_AND_SWP ||
-		    wqe->wr.opcode == IB_WR_ATOMIC_FETCH_AND_ADD)
-			tasklet_hi_schedule(&qp->s_task);
+		if (qp->s_num_rd_atomic &&
+		    (wqe->wr.opcode == IB_WR_RDMA_READ ||
+		     wqe->wr.opcode == IB_WR_ATOMIC_CMP_AND_SWP ||
+		     wqe->wr.opcode == IB_WR_ATOMIC_FETCH_AND_ADD)) {
+			qp->s_num_rd_atomic--;
+			/* Restart sending task if fence is complete */
+			if ((qp->s_flags & IPATH_S_FENCE_PENDING) &&
+			    !qp->s_num_rd_atomic) {
+				qp->s_flags &= ~IPATH_S_FENCE_PENDING;
+				tasklet_hi_schedule(&qp->s_task);
+			} else if (qp->s_flags & IPATH_S_RDMAR_PENDING) {
+				qp->s_flags &= ~IPATH_S_RDMAR_PENDING;
+				tasklet_hi_schedule(&qp->s_task);
+			}
+		}
 		/* Post a send completion queue entry if requested. */
-		if (!test_bit(IPATH_S_SIGNAL_REQ_WR, &qp->s_flags) ||
+		if (!(qp->s_flags & IPATH_S_SIGNAL_REQ_WR) ||
 		    (wqe->wr.send_flags & IB_SEND_SIGNALED)) {
 			wc.wr_id = wqe->wr.wr_id;
 			wc.status = IB_WC_SUCCESS;
@@ -1003,6 +1062,7 @@ static inline void ipath_rc_rcv_resp(str
 				     u32 psn, u32 hdrsize, u32 pmtu,
 				     int header_in_data)
 {
+	struct ipath_swqe *wqe;
 	unsigned long flags;
 	struct ib_wc wc;
 	int diff;
@@ -1032,6 +1092,10 @@ static inline void ipath_rc_rcv_resp(str
 		goto ack_done;
 	}
 
+	if (unlikely(qp->s_last == qp->s_tail))
+		goto ack_done;
+	wqe = get_swqe_ptr(qp, qp->s_last);
+
 	switch (opcode) {
 	case OP(ACKNOWLEDGE):
 	case OP(ATOMIC_ACKNOWLEDGE):
@@ -1042,38 +1106,49 @@ static inline void ipath_rc_rcv_resp(str
 			aeth = be32_to_cpu(((__be32 *) data)[0]);
 			data += sizeof(__be32);
 		}
-		if (opcode == OP(ATOMIC_ACKNOWLEDGE))
-			*(u64 *) qp->s_sge.sge.vaddr = *(u64 *) data;
+		if (opcode == OP(ATOMIC_ACKNOWLEDGE)) {
+			u64 val;
+
+			if (!header_in_data) {
+				__be32 *p = ohdr->u.at.atomic_ack_eth;
+
+				val = ((u64) be32_to_cpu(p[0]) << 32) |
+					be32_to_cpu(p[1]);
+			} else
+				val = be64_to_cpu(((__be64 *) data)[0]);
+			*(u64 *) wqe->sg_list[0].vaddr = val;
+		}
 		if (!do_rc_ack(qp, aeth, psn, opcode) ||
 		    opcode != OP(RDMA_READ_RESPONSE_FIRST))
 			goto ack_done;
 		hdrsize += 4;
-		/*
-		 * do_rc_ack() has already checked the PSN so skip
-		 * the sequence check.
-		 */
-		goto rdma_read;
+		if (unlikely(wqe->wr.opcode != IB_WR_RDMA_READ))
+			goto ack_done;
+		/*
+		 * If this is a response to a resent RDMA read, we
+		 * have to be careful to copy the data to the right
+		 * location.
+		 */
+		qp->s_rdma_read_len = restart_sge(&qp->s_rdma_read_sge,
+						  wqe, psn, pmtu);
+		goto read_middle;
 
 	case OP(RDMA_READ_RESPONSE_MIDDLE):
 		/* no AETH, no ACK */
 		if (unlikely(ipath_cmp24(psn, qp->s_last_psn + 1))) {
 			dev->n_rdma_seq++;
-			if (qp->s_last != qp->s_tail)
-				ipath_restart_rc(qp, qp->s_last_psn + 1, &wc);
+			ipath_restart_rc(qp, qp->s_last_psn + 1, &wc);
 			goto ack_done;
 		}
-	rdma_read:
-		if (unlikely(qp->s_state != OP(RDMA_READ_REQUEST)))
+		if (unlikely(wqe->wr.opcode != IB_WR_RDMA_READ))
 			goto ack_done;
+	read_middle:
 		if (unlikely(tlen != (hdrsize + pmtu + 4)))
 			goto ack_done;
-		if (unlikely(pmtu >= qp->s_len))
+		if (unlikely(pmtu >= qp->s_rdma_read_len))
 			goto ack_done;
+
 		/* We got a response so update the timeout. */
-		if (unlikely(qp->s_last == qp->s_tail ||
-			     get_swqe_ptr(qp, qp->s_last)->wr.opcode !=
-			     IB_WR_RDMA_READ))
-			goto ack_done;
 		spin_lock(&dev->pending_lock);
 		if (qp->s_rnr_timeout == 0 && !list_empty(&qp->timerwait))
 			list_move_tail(&qp->timerwait,
@@ -1082,27 +1157,41 @@ static inline void ipath_rc_rcv_resp(str
 		/*
 		 * Update the RDMA receive state but do the copy w/o
 		 * holding the locks and blocking interrupts.
-		 * XXX Yet another place that affects relaxed RDMA order
-		 * since we don't want s_sge modified.
-		 */
-		qp->s_len -= pmtu;
+		 */
+		qp->s_rdma_read_len -= pmtu;
 		update_last_psn(qp, psn);
 		spin_unlock_irqrestore(&qp->s_lock, flags);
-		ipath_copy_sge(&qp->s_sge, data, pmtu);
+		ipath_copy_sge(&qp->s_rdma_read_sge, data, pmtu);
 		goto bail;
+
+	case OP(RDMA_READ_RESPONSE_ONLY):
+		if (unlikely(ipath_cmp24(psn, qp->s_last_psn + 1))) {
+			dev->n_rdma_seq++;
+			ipath_restart_rc(qp, qp->s_last_psn + 1, &wc);
+			goto ack_done;
+		}
+		if (unlikely(wqe->wr.opcode != IB_WR_RDMA_READ))
+			goto ack_done;
+		/*
+		 * If this is a response to a resent RDMA read, we
+		 * have to be careful to copy the data to the right
+		 * location.
+		 * XXX should check PSN and wqe opcode first.
+		 */
+		qp->s_rdma_read_len = restart_sge(&qp->s_rdma_read_sge,
+						  wqe, psn, pmtu);
+		goto read_last;
 
 	case OP(RDMA_READ_RESPONSE_LAST):
 		/* ACKs READ req. */
 		if (unlikely(ipath_cmp24(psn, qp->s_last_psn + 1))) {
 			dev->n_rdma_seq++;
-			if (qp->s_last != qp->s_tail)
-				ipath_restart_rc(qp, qp->s_last_psn + 1, &wc);
+			ipath_restart_rc(qp, qp->s_last_psn + 1, &wc);
 			goto ack_done;
 		}
-		/* FALLTHROUGH */
-	case OP(RDMA_READ_RESPONSE_ONLY):
-		if (unlikely(qp->s_state != OP(RDMA_READ_REQUEST)))
+		if (unlikely(wqe->wr.opcode != IB_WR_RDMA_READ))
 			goto ack_done;
+	read_last:
 		/*
 		 * Get the number of bytes the message was padded by.
 		 */
@@ -1117,7 +1206,7 @@ static inline void ipath_rc_rcv_resp(str
 			goto ack_done;
 		}
 		tlen -= hdrsize + pad + 8;
-		if (unlikely(tlen != qp->s_len)) {
+		if (unlikely(tlen != qp->s_rdma_read_len)) {
 			/* XXX Need to generate an error CQ entry. */
 			goto ack_done;
 		}
@@ -1127,17 +1216,8 @@ static inline void ipath_rc_rcv_resp(str
 			aeth = be32_to_cpu(((__be32 *) data)[0]);
 			data += sizeof(__be32);
 		}
-		ipath_copy_sge(&qp->s_sge, data, tlen);
-		if (do_rc_ack(qp, aeth, psn, OP(RDMA_READ_RESPONSE_LAST))) {
-			/*
-			 * Change the state so we contimue
-			 * processing new requests and wake up the
-			 * tasklet if there are posted sends.
-			 */
-			qp->s_state = OP(SEND_LAST);
-			if (qp->s_tail != qp->s_head)
-				tasklet_hi_schedule(&qp->s_task);
-		}
+		ipath_copy_sge(&qp->s_rdma_read_sge, data, tlen);
+		(void) do_rc_ack(qp, aeth, psn, OP(RDMA_READ_RESPONSE_LAST));
 		goto ack_done;
 	}
 
@@ -1162,7 +1242,7 @@ bail:
  * incoming RC packet for the given QP.
  * Called at interrupt level.
  * Return 1 if no more processing is needed; otherwise return 0 to
- * schedule a response to be sent and the s_lock unlocked.
+ * schedule a response to be sent.
  */
 static inline int ipath_rc_rcv_error(struct ipath_ibdev *dev,
 				     struct ipath_other_headers *ohdr,
@@ -1173,25 +1253,23 @@ static inline int ipath_rc_rcv_error(str
 				     int diff,
 				     int header_in_data)
 {
-	struct ib_reth *reth;
+	struct ipath_ack_entry *e;
+	u8 i, prev;
+	int old_req;
 
 	if (diff > 0) {
 		/*
 		 * Packet sequence error.
 		 * A NAK will ACK earlier sends and RDMA writes.
-		 * Don't queue the NAK if a RDMA read, atomic, or
-		 * NAK is pending though.
-		 */
-		if (qp->s_ack_state != OP(ACKNOWLEDGE) ||
-		    qp->r_nak_state != 0)
-			goto done;
-		if (qp->r_ack_state < OP(COMPARE_SWAP)) {
-			qp->r_ack_state = OP(SEND_ONLY);
+		 * Don't queue the NAK if we already sent one.
+		 */
+		if (!qp->r_nak_state) {
 			qp->r_nak_state = IB_NAK_PSN_ERROR;
 			/* Use the expected PSN. */
 			qp->r_ack_psn = qp->r_psn;
-		}
-		goto send_ack;
+			goto send_ack;
+		}
+		goto done;
 	}
 
 	/*
@@ -1204,8 +1282,46 @@ static inline int ipath_rc_rcv_error(str
 	 * can coalesce an outstanding duplicate ACK.  We have to
 	 * send the earliest so that RDMA reads can be restarted at
 	 * the requester's expected PSN.
+	 *
+	 * First, find where this duplicate PSN falls within the
+	 * ACKs previously sent.
 	 */
-	if (opcode == OP(RDMA_READ_REQUEST)) {
+	psn &= IPATH_PSN_MASK;
+	e = NULL;
+	old_req = 1;
+	spin_lock_irq(&qp->s_lock);
+	for (i = qp->r_head_ack_queue; ; i = prev) {
+		if (i == qp->s_tail_ack_queue)
+			old_req = 0;
+		if (i)
+			prev = i - 1;
+		else
+			prev = IPATH_MAX_RDMA_ATOMIC;
+		if (prev == qp->r_head_ack_queue) {
+			e = NULL;
+			break;
+		}
+		e = &qp->s_ack_queue[prev];
+		if (!e->opcode) {
+			e = NULL;
+			break;
+		}
+		if (ipath_cmp24(psn, e->psn) >= 0)
+			break;
+	}
+	switch (opcode) {
+	case OP(RDMA_READ_REQUEST): {
+		struct ib_reth *reth;
+		u32 offset;
+		u32 len;
+
+		/*
+		 * If we didn't find the RDMA read request in the ack queue,
+		 * or the send tasklet is already backed up to send an
+		 * earlier entry, we can ignore this request.
+		 */
+		if (!e || e->opcode != OP(RDMA_READ_REQUEST) || old_req)
+			goto unlock_done;
 		/* RETH comes after BTH */
 		if (!header_in_data)
 			reth = &ohdr->u.rc.reth;
@@ -1214,88 +1330,87 @@ static inline int ipath_rc_rcv_error(str
 			data += sizeof(*reth);
 		}
 		/*
-		 * If we receive a duplicate RDMA request, it means the
-		 * requester saw a sequence error and needs to restart
-		 * from an earlier point.  We can abort the current
-		 * RDMA read send in that case.
-		 */
-		spin_lock_irq(&qp->s_lock);
-		if (qp->s_ack_state != OP(ACKNOWLEDGE) &&
-		    (qp->s_hdrwords || ipath_cmp24(psn, qp->s_ack_psn) >= 0)) {
-			/*
-			 * We are already sending earlier requested data.
-			 * Don't abort it to send later out of sequence data.
-			 */
-			spin_unlock_irq(&qp->s_lock);
-			goto done;
-		}
-		qp->s_rdma_len = be32_to_cpu(reth->length);
-		if (qp->s_rdma_len != 0) {
+		 * Address range must be a subset of the original
+		 * request and start on pmtu boundaries.
+		 * We reuse the old ack_queue slot since the requester
+		 * should not back up and request an earlier PSN for the
+		 * same request.
+		 */
+		offset = ((psn - e->psn) & IPATH_PSN_MASK) *
+			ib_mtu_enum_to_int(qp->path_mtu);
+		len = be32_to_cpu(reth->length);
+		if (unlikely(offset + len > e->rdma_sge.sge.sge_length))
+			goto unlock_done;
+		if (len != 0) {
 			u32 rkey = be32_to_cpu(reth->rkey);
 			u64 vaddr = be64_to_cpu(reth->vaddr);
 			int ok;
 
-			/*
-			 * Address range must be a subset of the original
-			 * request and start on pmtu boundaries.
-			 */
-			ok = ipath_rkey_ok(qp, &qp->s_rdma_sge,
-					   qp->s_rdma_len, vaddr, rkey,
+			ok = ipath_rkey_ok(qp, &e->rdma_sge,
+					   len, vaddr, rkey,
 					   IB_ACCESS_REMOTE_READ);
-			if (unlikely(!ok)) {
-				spin_unlock_irq(&qp->s_lock);
-				goto done;
-			}
+			if (unlikely(!ok))
+				goto unlock_done;
 		} else {
-			qp->s_rdma_sge.sg_list = NULL;
-			qp->s_rdma_sge.num_sge = 0;
-			qp->s_rdma_sge.sge.mr = NULL;
-			qp->s_rdma_sge.sge.vaddr = NULL;
-			qp->s_rdma_sge.sge.length = 0;
-			qp->s_rdma_sge.sge.sge_length = 0;
-		}
-		qp->s_ack_state = opcode;
-		qp->s_ack_psn = psn;
-		spin_unlock_irq(&qp->s_lock);
-		tasklet_hi_schedule(&qp->s_task);
-		goto send_ack;
-	}
-
-	/*
-	 * A pending RDMA read will ACK anything before it so
-	 * ignore earlier duplicate requests.
-	 */
-	if (qp->s_ack_state != OP(ACKNOWLEDGE))
-		goto done;
-
-	/*
-	 * If an ACK is pending, don't replace the pending ACK
-	 * with an earlier one since the later one will ACK the earlier.
-	 * Also, if we already have a pending atomic, send it.
-	 */
-	if (qp->r_ack_state != OP(ACKNOWLEDGE) &&
-	    (ipath_cmp24(psn, qp->r_ack_psn) <= 0 ||
-	     qp->r_ack_state >= OP(COMPARE_SWAP)))
-		goto send_ack;
-	switch (opcode) {
+			e->rdma_sge.sg_list = NULL;
+			e->rdma_sge.num_sge = 0;
+			e->rdma_sge.sge.mr = NULL;
+			e->rdma_sge.sge.vaddr = NULL;
+			e->rdma_sge.sge.length = 0;
+			e->rdma_sge.sge.sge_length = 0;
+		}
+		e->psn = psn;
+		qp->s_ack_state = OP(ACKNOWLEDGE);
+		qp->s_tail_ack_queue = prev;
+		break;
+	}
+
 	case OP(COMPARE_SWAP):
-	case OP(FETCH_ADD):
-		/*
-		 * Check for the PSN of the last atomic operation
-		 * performed and resend the result if found.
-		 */
-		if ((psn & IPATH_PSN_MASK) != qp->r_atomic_psn)
-			goto done;
+	case OP(FETCH_ADD): {
+		/*
+		 * If we didn't find the atomic request in the ack queue
+		 * or the send tasklet is already backed up to send an
+		 * earlier entry, we can ignore this request.
+		 */
+		if (!e || e->opcode != (u8) opcode || old_req)
+			goto unlock_done;
+		qp->s_ack_state = OP(ACKNOWLEDGE);
+		qp->s_tail_ack_queue = prev;
 		break;
 	}
-	qp->r_ack_state = opcode;
+
+	default:
+		if (old_req)
+			goto unlock_done;
+		/*
+		 * Resend the most recent ACK if this request is
+		 * after all the previous RDMA reads and atomics.
+		 */
+		if (i == qp->r_head_ack_queue) {
+			spin_unlock_irq(&qp->s_lock);
+			qp->r_nak_state = 0;
+			qp->r_ack_psn = qp->r_psn - 1;
+			goto send_ack;
+		}
+		/*
+		 * Resend the RDMA read or atomic op which
+		 * ACKs this duplicate request.
+		 */
+		qp->s_ack_state = OP(ACKNOWLEDGE);
+		qp->s_tail_ack_queue = i;
+		break;
+	}
 	qp->r_nak_state = 0;
-	qp->r_ack_psn = psn;
+	spin_unlock_irq(&qp->s_lock);
+	tasklet_hi_schedule(&qp->s_task);
+
+unlock_done:
+	spin_unlock_irq(&qp->s_lock);
+done:
+	return 1;
+
 send_ack:
 	return 0;
-
-done:
-	return 1;
 }
 
 static void ipath_rc_error(struct ipath_qp *qp, enum ib_wc_status err)
@@ -1391,15 +1506,7 @@ void ipath_rc_rcv(struct ipath_ibdev *de
 		    opcode == OP(SEND_LAST_WITH_IMMEDIATE))
 			break;
 	nack_inv:
-		/*
-		 * A NAK will ACK earlier sends and RDMA writes.
-		 * Don't queue the NAK if a RDMA read, atomic, or NAK
-		 * is pending though.
-		 */
-		if (qp->r_ack_state >= OP(COMPARE_SWAP))
-			goto send_ack;
 		ipath_rc_error(qp, IB_WC_REM_INV_REQ_ERR);
-		qp->r_ack_state = OP(SEND_ONLY);
 		qp->r_nak_state = IB_NAK_INVALID_REQUEST;
 		qp->r_ack_psn = qp->r_psn;
 		goto send_ack;
@@ -1441,9 +1548,8 @@ void ipath_rc_rcv(struct ipath_ibdev *de
 			 * Don't queue the NAK if a RDMA read or atomic
 			 * is pending though.
 			 */
-			if (qp->r_ack_state >= OP(COMPARE_SWAP))
-				goto send_ack;
-			qp->r_ack_state = OP(SEND_ONLY);
+			if (qp->r_nak_state)
+				goto done;
 			qp->r_nak_state = IB_RNR_NAK | qp->r_min_rnr_timer;
 			qp->r_ack_psn = qp->r_psn;
 			goto send_ack;
@@ -1567,7 +1673,19 @@ void ipath_rc_rcv(struct ipath_ibdev *de
 			goto rnr_nak;
 		goto send_last_imm;
 
-	case OP(RDMA_READ_REQUEST):
+	case OP(RDMA_READ_REQUEST): {
+		struct ipath_ack_entry *e;
+		u32 len;
+		u8 next;
+
+		if (unlikely(!(qp->qp_access_flags & IB_ACCESS_REMOTE_READ)))
+			goto nack_acc;
+		next = qp->r_head_ack_queue + 1;
+		if (next > IPATH_MAX_RDMA_ATOMIC)
+			next = 0;
+		if (unlikely(next == qp->s_tail_ack_queue))
+			goto nack_inv;
+		e = &qp->s_ack_queue[qp->r_head_ack_queue];
 		/* RETH comes after BTH */
 		if (!header_in_data)
 			reth = &ohdr->u.rc.reth;
@@ -1575,72 +1693,75 @@ void ipath_rc_rcv(struct ipath_ibdev *de
 			reth = (struct ib_reth *)data;
 			data += sizeof(*reth);
 		}
-		if (unlikely(!(qp->qp_access_flags &
-			       IB_ACCESS_REMOTE_READ)))
-			goto nack_acc;
-		spin_lock_irq(&qp->s_lock);
-		qp->s_rdma_len = be32_to_cpu(reth->length);
-		if (qp->s_rdma_len != 0) {
+		len = be32_to_cpu(reth->length);
+		if (len) {
 			u32 rkey = be32_to_cpu(reth->rkey);
 			u64 vaddr = be64_to_cpu(reth->vaddr);
 			int ok;
 
 			/* Check rkey & NAK */
-			ok = ipath_rkey_ok(qp, &qp->s_rdma_sge,
-					   qp->s_rdma_len, vaddr, rkey,
-					   IB_ACCESS_REMOTE_READ);
-			if (unlikely(!ok)) {
-				spin_unlock_irq(&qp->s_lock);
+			ok = ipath_rkey_ok(qp, &e->rdma_sge, len, vaddr,
+					   rkey, IB_ACCESS_REMOTE_READ);
+			if (unlikely(!ok))
 				goto nack_acc;
-			}
 			/*
 			 * Update the next expected PSN.  We add 1 later
 			 * below, so only add the remainder here.
 			 */
-			if (qp->s_rdma_len > pmtu)
-				qp->r_psn += (qp->s_rdma_len - 1) / pmtu;
+			if (len > pmtu)
+				qp->r_psn += (len - 1) / pmtu;
 		} else {
-			qp->s_rdma_sge.sg_list = NULL;
-			qp->s_rdma_sge.num_sge = 0;
-			qp->s_rdma_sge.sge.mr = NULL;
-			qp->s_rdma_sge.sge.vaddr = NULL;
-			qp->s_rdma_sge.sge.length = 0;
-			qp->s_rdma_sge.sge.sge_length = 0;
-		}
+			e->rdma_sge.sg_list = NULL;
+			e->rdma_sge.num_sge = 0;
+			e->rdma_sge.sge.mr = NULL;
+			e->rdma_sge.sge.vaddr = NULL;
+			e->rdma_sge.sge.length = 0;
+			e->rdma_sge.sge.sge_length = 0;
+		}
+		e->opcode = opcode;
+		e->psn = psn;
 		/*
 		 * We need to increment the MSN here instead of when we
 		 * finish sending the result since a duplicate request would
 		 * increment it more than once.
 		 */
 		qp->r_msn++;
-
-		qp->s_ack_state = opcode;
-		qp->s_ack_psn = psn;
-		spin_unlock_irq(&qp->s_lock);
-
 		qp->r_psn++;
 		qp->r_state = opcode;
 		qp->r_nak_state = 0;
+		barrier();
+		qp->r_head_ack_queue = next;
 
 		/* Call ipath_do_rc_send() in another thread. */
 		tasklet_hi_schedule(&qp->s_task);
 
 		goto done;
+	}
 
 	case OP(COMPARE_SWAP):
 	case OP(FETCH_ADD): {
 		struct ib_atomic_eth *ateth;
+		struct ipath_ack_entry *e;
 		u64 vaddr;
+		atomic64_t *maddr;
 		u64 sdata;
 		u32 rkey;
-
+		u8 next;
+
+		if (unlikely(!(qp->qp_access_flags &
+			       IB_ACCESS_REMOTE_ATOMIC)))
+			goto nack_acc;
+		next = qp->r_head_ack_queue + 1;
+		if (next > IPATH_MAX_RDMA_ATOMIC)
+			next = 0;
+		if (unlikely(next == qp->s_tail_ack_queue))
+			goto nack_inv;
 		if (!header_in_data)
 			ateth = &ohdr->u.atomic_eth;
-		else {
+		else
 			ateth = (struct ib_atomic_eth *)data;
-			data += sizeof(*ateth);
-		}
-		vaddr = be64_to_cpu(ateth->vaddr);
+		vaddr = ((u64) be32_to_cpu(ateth->vaddr[0]) << 32) |
+			be32_to_cpu(ateth->vaddr[1]);
 		if (unlikely(vaddr & (sizeof(u64) - 1)))
 			goto nack_inv;
 		rkey = be32_to_cpu(ateth->rkey);
@@ -1649,63 +1770,50 @@ void ipath_rc_rcv(struct ipath_ibdev *de
 					    sizeof(u64), vaddr, rkey,
 					    IB_ACCESS_REMOTE_ATOMIC)))
 			goto nack_acc;
-		if (unlikely(!(qp->qp_access_flags &
-			       IB_ACCESS_REMOTE_ATOMIC)))
-			goto nack_acc;
 		/* Perform atomic OP and save result. */
+		maddr = (atomic64_t *) qp->r_sge.sge.vaddr;
 		sdata = be64_to_cpu(ateth->swap_data);
-		spin_lock_irq(&dev->pending_lock);
-		qp->r_atomic_data = *(u64 *) qp->r_sge.sge.vaddr;
-		if (opcode == OP(FETCH_ADD))
-			*(u64 *) qp->r_sge.sge.vaddr =
-				qp->r_atomic_data + sdata;
-		else if (qp->r_atomic_data ==
-			 be64_to_cpu(ateth->compare_data))
-			*(u64 *) qp->r_sge.sge.vaddr = sdata;
-		spin_unlock_irq(&dev->pending_lock);
+		e = &qp->s_ack_queue[qp->r_head_ack_queue];
+		e->atomic_data = (opcode == OP(FETCH_ADD)) ?
+			(u64) atomic64_add_return(sdata, maddr) - sdata :
+			(u64) cmpxchg((u64 *) qp->r_sge.sge.vaddr,
+				      be64_to_cpu(ateth->compare_data),
+				      sdata);
+		e->opcode = opcode;
+		e->psn = psn & IPATH_PSN_MASK;
 		qp->r_msn++;
-		qp->r_atomic_psn = psn & IPATH_PSN_MASK;
-		psn |= 1 << 31;
-		break;
+		qp->r_psn++;
+		qp->r_state = opcode;
+		qp->r_nak_state = 0;
+		barrier();
+		qp->r_head_ack_queue = next;
+
+		/* Call ipath_do_rc_send() in another thread. */
+		tasklet_hi_schedule(&qp->s_task);
+
+		goto done;
 	}
 
 	default:
-		/* Drop packet for unknown opcodes. */
-		goto done;
+		/* NAK unknown opcodes. */
+		goto nack_inv;
 	}
 	qp->r_psn++;
 	qp->r_state = opcode;
+	qp->r_ack_psn = psn;
 	qp->r_nak_state = 0;
 	/* Send an ACK if requested or required. */
-	if (psn & (1 << 31)) {
-		/*
-		 * Coalesce ACKs unless there is a RDMA READ or
-		 * ATOMIC pending.
-		 */
-		if (qp->r_ack_state < OP(COMPARE_SWAP)) {
-			qp->r_ack_state = opcode;
-			qp->r_ack_psn = psn;
-		}
+	if (psn & (1 << 31))
 		goto send_ack;
-	}
 	goto done;
 
 nack_acc:
-	/*
-	 * A NAK will ACK earlier sends and RDMA writes.
-	 * Don't queue the NAK if a RDMA read, atomic, or NAK
-	 * is pending though.
-	 */
-	if (qp->r_ack_state < OP(COMPARE_SWAP)) {
-		ipath_rc_error(qp, IB_WC_REM_ACCESS_ERR);
-		qp->r_ack_state = OP(RDMA_WRITE_ONLY);
-		qp->r_nak_state = IB_NAK_REMOTE_ACCESS_ERROR;
-		qp->r_ack_psn = qp->r_psn;
-	}
+	ipath_rc_error(qp, IB_WC_REM_ACCESS_ERR);
+	qp->r_nak_state = IB_NAK_REMOTE_ACCESS_ERROR;
+	qp->r_ack_psn = qp->r_psn;
+
 send_ack:
-	/* Send ACK right away unless the send tasklet has a pending ACK. */
-	if (qp->s_ack_state == OP(ACKNOWLEDGE))
-		send_rc_ack(qp);
+	send_rc_ack(qp);
 
 done:
 	return;
diff -r 78ae7bddbd5e -r 02b57b02578b drivers/infiniband/hw/ipath/ipath_ruc.c
--- a/drivers/infiniband/hw/ipath/ipath_ruc.c	Thu Mar 15 14:34:24 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_ruc.c	Thu Mar 15 14:34:24 2007 -0700
@@ -255,6 +255,7 @@ static void ipath_ruc_loopback(struct ip
 	unsigned long flags;
 	struct ib_wc wc;
 	u64 sdata;
+	atomic64_t *maddr;
 
 	qp = ipath_lookup_qpn(&dev->qp_table, sqp->remote_qpn);
 	if (!qp) {
@@ -311,7 +312,7 @@ again:
 				sqp->s_rnr_retry--;
 			dev->n_rnr_naks++;
 			sqp->s_rnr_timeout =
-				ib_ipath_rnr_table[sqp->r_min_rnr_timer];
+				ib_ipath_rnr_table[qp->r_min_rnr_timer];
 			ipath_insert_rnr_queue(sqp);
 			goto done;
 		}
@@ -344,20 +345,22 @@ again:
 			wc.sl = sqp->remote_ah_attr.sl;
 			wc.dlid_path_bits = 0;
 			wc.port_num = 0;
+			spin_lock_irqsave(&sqp->s_lock, flags);
 			ipath_sqerror_qp(sqp, &wc);
+			spin_unlock_irqrestore(&sqp->s_lock, flags);
 			goto done;
 		}
 		break;
 
 	case IB_WR_RDMA_READ:
+		if (unlikely(!(qp->qp_access_flags &
+			       IB_ACCESS_REMOTE_READ)))
+			goto acc_err;
 		if (unlikely(!ipath_rkey_ok(qp, &sqp->s_sge, wqe->length,
 					    wqe->wr.wr.rdma.remote_addr,
 					    wqe->wr.wr.rdma.rkey,
 					    IB_ACCESS_REMOTE_READ)))
 			goto acc_err;
-		if (unlikely(!(qp->qp_access_flags &
-			       IB_ACCESS_REMOTE_READ)))
-			goto acc_err;
 		qp->r_sge.sge = wqe->sg_list[0];
 		qp->r_sge.sg_list = wqe->sg_list + 1;
 		qp->r_sge.num_sge = wqe->wr.num_sge;
@@ -365,22 +368,22 @@ again:
 
 	case IB_WR_ATOMIC_CMP_AND_SWP:
 	case IB_WR_ATOMIC_FETCH_AND_ADD:
+		if (unlikely(!(qp->qp_access_flags &
+			       IB_ACCESS_REMOTE_ATOMIC)))
+			goto acc_err;
 		if (unlikely(!ipath_rkey_ok(qp, &qp->r_sge, sizeof(u64),
-					    wqe->wr.wr.rdma.remote_addr,
-					    wqe->wr.wr.rdma.rkey,
+					    wqe->wr.wr.atomic.remote_addr,
+					    wqe->wr.wr.atomic.rkey,
 					    IB_ACCESS_REMOTE_ATOMIC)))
 			goto acc_err;
 		/* Perform atomic OP and save result. */
-		sdata = wqe->wr.wr.atomic.swap;
-		spin_lock_irqsave(&dev->pending_lock, flags);
-		qp->r_atomic_data = *(u64 *) qp->r_sge.sge.vaddr;
-		if (wqe->wr.opcode == IB_WR_ATOMIC_FETCH_AND_ADD)
-			*(u64 *) qp->r_sge.sge.vaddr =
-				qp->r_atomic_data + sdata;
-		else if (qp->r_atomic_data == wqe->wr.wr.atomic.compare_add)
-			*(u64 *) qp->r_sge.sge.vaddr = sdata;
-		spin_unlock_irqrestore(&dev->pending_lock, flags);
-		*(u64 *) sqp->s_sge.sge.vaddr = qp->r_atomic_data;
+		maddr = (atomic64_t *) qp->r_sge.sge.vaddr;
+		sdata = wqe->wr.wr.atomic.compare_add;
+		*(u64 *) sqp->s_sge.sge.vaddr =
+			(wqe->wr.opcode == IB_WR_ATOMIC_FETCH_AND_ADD) ?
+			(u64) atomic64_add_return(sdata, maddr) - sdata :
+			(u64) cmpxchg((u64 *) qp->r_sge.sge.vaddr,
+				      sdata, wqe->wr.wr.atomic.swap);
 		goto send_comp;
 
 	default:
@@ -441,7 +444,7 @@ send_comp:
 send_comp:
 	sqp->s_rnr_retry = sqp->s_rnr_retry_cnt;
 
-	if (!test_bit(IPATH_S_SIGNAL_REQ_WR, &sqp->s_flags) ||
+	if (!(sqp->s_flags & IPATH_S_SIGNAL_REQ_WR) ||
 	    (wqe->wr.send_flags & IB_SEND_SIGNALED)) {
 		wc.wr_id = wqe->wr.wr_id;
 		wc.status = IB_WC_SUCCESS;
@@ -503,7 +506,7 @@ void ipath_no_bufs_available(struct ipat
 	 * We clear the tasklet flag now since we are committing to return
 	 * from the tasklet function.
 	 */
-	clear_bit(IPATH_S_BUSY, &qp->s_flags);
+	clear_bit(IPATH_S_BUSY, &qp->s_busy);
 	tasklet_unlock(&qp->s_task);
 	want_buffer(dev->dd);
 	dev->n_piowait++;
@@ -540,6 +543,9 @@ int ipath_post_ruc_send(struct ipath_qp 
 		   (wr->num_sge == 0 ||
 		    wr->sg_list[0].length < sizeof(u64) ||
 		    wr->sg_list[0].addr & (sizeof(u64) - 1))) {
+		ret = -EINVAL;
+		goto bail;
+	} else if (wr->opcode >= IB_WR_RDMA_READ && !qp->s_max_rd_atomic) {
 		ret = -EINVAL;
 		goto bail;
 	}
@@ -648,7 +654,7 @@ void ipath_do_ruc_send(unsigned long dat
 	u32 pmtu = ib_mtu_enum_to_int(qp->path_mtu);
 	struct ipath_other_headers *ohdr;
 
-	if (test_and_set_bit(IPATH_S_BUSY, &qp->s_flags))
+	if (test_and_set_bit(IPATH_S_BUSY, &qp->s_busy))
 		goto bail;
 
 	if (unlikely(qp->remote_ah_attr.dlid == dev->dd->ipath_lid)) {
@@ -684,19 +690,15 @@ again:
 	 */
 	spin_lock_irqsave(&qp->s_lock, flags);
 
-	/* Sending responses has higher priority over sending requests. */
-	if (qp->s_ack_state != IB_OPCODE_RC_ACKNOWLEDGE &&
-	    (bth0 = ipath_make_rc_ack(qp, ohdr, pmtu)) != 0)
-		bth2 = qp->s_ack_psn++ & IPATH_PSN_MASK;
-	else if (!((qp->ibqp.qp_type == IB_QPT_RC) ?
-		   ipath_make_rc_req(qp, ohdr, pmtu, &bth0, &bth2) :
-		   ipath_make_uc_req(qp, ohdr, pmtu, &bth0, &bth2))) {
+	if (!((qp->ibqp.qp_type == IB_QPT_RC) ?
+	       ipath_make_rc_req(qp, ohdr, pmtu, &bth0, &bth2) :
+	       ipath_make_uc_req(qp, ohdr, pmtu, &bth0, &bth2))) {
 		/*
 		 * Clear the busy bit before unlocking to avoid races with
 		 * adding new work queue items and then failing to process
 		 * them.
 		 */
-		clear_bit(IPATH_S_BUSY, &qp->s_flags);
+		clear_bit(IPATH_S_BUSY, &qp->s_busy);
 		spin_unlock_irqrestore(&qp->s_lock, flags);
 		goto bail;
 	}
@@ -729,7 +731,7 @@ again:
 	goto again;
 
 clear:
-	clear_bit(IPATH_S_BUSY, &qp->s_flags);
+	clear_bit(IPATH_S_BUSY, &qp->s_busy);
 bail:
 	return;
 }
diff -r 78ae7bddbd5e -r 02b57b02578b drivers/infiniband/hw/ipath/ipath_uc.c
--- a/drivers/infiniband/hw/ipath/ipath_uc.c	Thu Mar 15 14:34:24 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_uc.c	Thu Mar 15 14:34:24 2007 -0700
@@ -42,7 +42,7 @@ static void complete_last_send(struct ip
 {
 	if (++qp->s_last == qp->s_size)
 		qp->s_last = 0;
-	if (!test_bit(IPATH_S_SIGNAL_REQ_WR, &qp->s_flags) ||
+	if (!(qp->s_flags & IPATH_S_SIGNAL_REQ_WR) ||
 	    (wqe->wr.send_flags & IB_SEND_SIGNALED)) {
 		wc->wr_id = wqe->wr.wr_id;
 		wc->status = IB_WC_SUCCESS;
@@ -344,13 +344,13 @@ void ipath_uc_rcv(struct ipath_ibdev *de
 	send_first:
 		if (qp->r_reuse_sge) {
 			qp->r_reuse_sge = 0;
-			qp->r_sge = qp->s_rdma_sge;
+			qp->r_sge = qp->s_rdma_read_sge;
 		} else if (!ipath_get_rwqe(qp, 0)) {
 			dev->n_pkt_drops++;
 			goto done;
 		}
 		/* Save the WQE so we can reuse it in case of an error. */
-		qp->s_rdma_sge = qp->r_sge;
+		qp->s_rdma_read_sge = qp->r_sge;
 		qp->r_rcv_len = 0;
 		if (opcode == OP(SEND_ONLY))
 			goto send_last;
diff -r 78ae7bddbd5e -r 02b57b02578b drivers/infiniband/hw/ipath/ipath_ud.c
--- a/drivers/infiniband/hw/ipath/ipath_ud.c	Thu Mar 15 14:34:24 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_ud.c	Thu Mar 15 14:34:24 2007 -0700
@@ -467,7 +467,7 @@ int ipath_post_ud_send(struct ipath_qp *
 
 done:
 	/* Queue the completion status entry. */
-	if (!test_bit(IPATH_S_SIGNAL_REQ_WR, &qp->s_flags) ||
+	if (!(qp->s_flags & IPATH_S_SIGNAL_REQ_WR) ||
 	    (wr->send_flags & IB_SEND_SIGNALED)) {
 		wc.wr_id = wr->wr_id;
 		wc.status = IB_WC_SUCCESS;
diff -r 78ae7bddbd5e -r 02b57b02578b drivers/infiniband/hw/ipath/ipath_verbs.c
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c	Thu Mar 15 14:34:24 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c	Thu Mar 15 14:34:24 2007 -0700
@@ -773,7 +773,6 @@ int ipath_verbs_send(struct ipath_devdat
 	/* +1 is for the qword padding of pbc */
 	plen = hdrwords + ((len + 3) >> 2) + 1;
 	if (unlikely((plen << 2) > dd->ipath_ibmaxlen)) {
-		ipath_dbg("packet len 0x%x too long, failing\n", plen);
 		ret = -EINVAL;
 		goto bail;
 	}
@@ -980,14 +979,14 @@ static int ipath_query_device(struct ib_
 	props->max_cqe = ib_ipath_max_cqes;
 	props->max_mr = dev->lk_table.max;
 	props->max_pd = ib_ipath_max_pds;
-	props->max_qp_rd_atom = 1;
-	props->max_qp_init_rd_atom = 1;
+	props->max_qp_rd_atom = IPATH_MAX_RDMA_ATOMIC;
+	props->max_qp_init_rd_atom = 255;
 	/* props->max_res_rd_atom */
 	props->max_srq = ib_ipath_max_srqs;
 	props->max_srq_wr = ib_ipath_max_srq_wrs;
 	props->max_srq_sge = ib_ipath_max_srq_sges;
 	/* props->local_ca_ack_delay */
-	props->atomic_cap = IB_ATOMIC_HCA;
+	props->atomic_cap = IB_ATOMIC_GLOB;
 	props->max_pkeys = ipath_get_npkeys(dev->dd);
 	props->max_mcast_grp = ib_ipath_max_mcast_grps;
 	props->max_mcast_qp_attach = ib_ipath_max_mcast_qp_attached;
diff -r 78ae7bddbd5e -r 02b57b02578b drivers/infiniband/hw/ipath/ipath_verbs.h
--- a/drivers/infiniband/hw/ipath/ipath_verbs.h	Thu Mar 15 14:34:24 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.h	Thu Mar 15 14:34:24 2007 -0700
@@ -43,6 +43,8 @@
 
 #include "ipath_layer.h"
 
+#define IPATH_MAX_RDMA_ATOMIC	4
+
 #define QPN_MAX                 (1 << 24)
 #define QPNMAP_ENTRIES          (QPN_MAX / PAGE_SIZE / BITS_PER_BYTE)
 
@@ -89,7 +91,7 @@ struct ib_reth {
 } __attribute__ ((packed));
 
 struct ib_atomic_eth {
-	__be64 vaddr;
+	__be32 vaddr[2];	/* unaligned so access as 2 32-bit words */
 	__be32 rkey;
 	__be64 swap_data;
 	__be64 compare_data;
@@ -108,7 +110,7 @@ struct ipath_other_headers {
 		} rc;
 		struct {
 			__be32 aeth;
-			__be64 atomic_ack_eth;
+			__be32 atomic_ack_eth[2];
 		} at;
 		__be32 imm_data;
 		__be32 aeth;
@@ -309,6 +311,19 @@ struct ipath_sge_state {
 	struct ipath_sge *sg_list;      /* next SGE to be used if any */
 	struct ipath_sge sge;   /* progress state for the current SGE */
 	u8 num_sge;
+};
+
+/*
+ * This structure holds the information that the send tasklet needs
+ * to send a RDMA read response or atomic operation.
+ */
+struct ipath_ack_entry {
+	u8 opcode;
+	u32 psn;
+	union {
+		struct ipath_sge_state rdma_sge;
+		u64 atomic_data;
+	};
 };
 
 /*
@@ -333,24 +348,24 @@ struct ipath_qp {
 	struct ipath_mmap_info *ip;
 	struct ipath_sge_state *s_cur_sge;
 	struct ipath_sge_state s_sge;	/* current send request data */
-	/* current RDMA read send data */
-	struct ipath_sge_state s_rdma_sge;
+	struct ipath_ack_entry s_ack_queue[IPATH_MAX_RDMA_ATOMIC + 1];
+	struct ipath_sge_state s_ack_rdma_sge;
+	struct ipath_sge_state s_rdma_read_sge;
 	struct ipath_sge_state r_sge;	/* current receive data */
 	spinlock_t s_lock;
-	unsigned long s_flags;
+	unsigned long s_busy;
 	u32 s_hdrwords;		/* size of s_hdr in 32 bit words */
 	u32 s_cur_size;		/* size of send packet in bytes */
 	u32 s_len;		/* total length of s_sge */
-	u32 s_rdma_len;		/* total length of s_rdma_sge */
+	u32 s_rdma_read_len;	/* total length of s_rdma_read_sge */
 	u32 s_next_psn;		/* PSN for next request */
 	u32 s_last_psn;		/* last response PSN processed */
 	u32 s_psn;		/* current packet sequence number */
-	u32 s_ack_psn;		/* PSN for RDMA_READ */
+	u32 s_ack_rdma_psn;	/* PSN for sending RDMA read responses */
+	u32 s_ack_psn;		/* PSN for acking sends and RDMA writes */
 	u32 s_rnr_timeout;	/* number of milliseconds for RNR timeout */
 	u32 r_ack_psn;		/* PSN for next ACK or atomic ACK */
 	u64 r_wr_id;		/* ID for current receive WQE */
-	u64 r_atomic_data;	/* data for last atomic op */
-	u32 r_atomic_psn;	/* PSN of last atomic op */
 	u32 r_len;		/* total length of r_sge */
 	u32 r_rcv_len;		/* receive data len processed */
 	u32 r_psn;		/* expected rcv packet sequence number */
@@ -360,12 +375,13 @@ struct ipath_qp {
 	u8 s_ack_state;		/* opcode of packet to ACK */
 	u8 s_nak_state;		/* non-zero if NAK is pending */
 	u8 r_state;		/* opcode of last packet received */
-	u8 r_ack_state;		/* opcode of packet to ACK */
 	u8 r_nak_state;		/* non-zero if NAK is pending */
 	u8 r_min_rnr_timer;	/* retry timeout value for RNR NAKs */
 	u8 r_reuse_sge;		/* for UC receive errors */
 	u8 r_sge_inx;		/* current index into sg_list */
 	u8 r_wrid_valid;	/* r_wrid set but CQ entry not yet made */
+	u8 r_max_rd_atomic;	/* max number of RDMA read/atomic to receive */
+	u8 r_head_ack_queue;	/* index into s_ack_queue[] */
 	u8 qp_access_flags;
 	u8 s_max_sge;		/* size of s_wq->sg_list */
 	u8 s_retry_cnt;		/* number of times to retry */
@@ -374,6 +390,10 @@ struct ipath_qp {
 	u8 s_rnr_retry;		/* requester RNR retry counter */
 	u8 s_wait_credit;	/* limit number of unacked packets sent */
 	u8 s_pkey_index;	/* PKEY index to use */
+	u8 s_max_rd_atomic;	/* max number of RDMA read/atomic to send */
+	u8 s_num_rd_atomic;	/* number of RDMA read/atomic pending */
+	u8 s_tail_ack_queue;	/* index into s_ack_queue[] */
+	u8 s_flags;
 	u8 timeout;		/* Timeout for this QP */
 	enum ib_mtu path_mtu;
 	u32 remote_qpn;
@@ -390,11 +410,16 @@ struct ipath_qp {
 	struct ipath_sge r_sg_list[0];	/* verified SGEs */
 };
 
+/* Bit definition for s_busy. */
+#define IPATH_S_BUSY		0
+
 /*
  * Bit definitions for s_flags.
  */
-#define IPATH_S_BUSY		0
-#define IPATH_S_SIGNAL_REQ_WR	1
+#define IPATH_S_SIGNAL_REQ_WR	0x01
+#define IPATH_S_FENCE_PENDING	0x02
+#define IPATH_S_RDMAR_PENDING	0x04
+#define IPATH_S_ACK_PENDING	0x08
 
 #define IPATH_PSN_CREDIT	2048
 
@@ -757,9 +782,6 @@ u32 ipath_make_grh(struct ipath_ibdev *d
 
 void ipath_do_ruc_send(unsigned long data);
 
-u32 ipath_make_rc_ack(struct ipath_qp *qp, struct ipath_other_headers *ohdr,
-		      u32 pmtu);
-
 int ipath_make_rc_req(struct ipath_qp *qp, struct ipath_other_headers *ohdr,
 		      u32 pmtu, u32 *bth0p, u32 *bth2p);
 
