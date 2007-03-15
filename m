Return-Path: <linux-kernel-owner+w=401wt.eu-S933931AbXCOWSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933931AbXCOWSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933862AbXCOWPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:15:30 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33686 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403AbXCOWPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:25 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 16 of 33] IB/ipath - fix RDMA reads of length zero and error
	handling
X-Mercurial-Node: 4d22cec2265b606cecee72d5abca4436bb1e6cb7
Message-Id: <4d22cec2265b606cecee.1173995100@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:45:00 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Ralph Campbell <ralph.campbell@qlogic.com>
# Date 1173994465 25200
# Node ID 4d22cec2265b606cecee72d5abca4436bb1e6cb7
# Parent  5ff8f23d0e61169f598ab1d93aa6324d88c17921
IB/ipath - fix RDMA reads of length zero and error handling

Fix RDMA read response length checking for RDMA_READ_RESPONSE_ONLY
to allow a zero length response.
RDMA read responses which don't match the expected length or occur
in response to some other operation should generate a completion
queue error (see table 56, ch. 9.9.2.3).

Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r 5ff8f23d0e61 -r 4d22cec2265b drivers/infiniband/hw/ipath/ipath_rc.c
--- a/drivers/infiniband/hw/ipath/ipath_rc.c	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_rc.c	Thu Mar 15 14:34:25 2007 -0700
@@ -1136,7 +1136,7 @@ static inline void ipath_rc_rcv_resp(str
 			goto ack_done;
 		hdrsize += 4;
 		if (unlikely(wqe->wr.opcode != IB_WR_RDMA_READ))
-			goto ack_done;
+			goto ack_op_err;
 		/*
 		 * If this is a response to a resent RDMA read, we
 		 * have to be careful to copy the data to the right
@@ -1154,12 +1154,12 @@ static inline void ipath_rc_rcv_resp(str
 			goto ack_done;
 		}
 		if (unlikely(wqe->wr.opcode != IB_WR_RDMA_READ))
-			goto ack_done;
+			goto ack_op_err;
 	read_middle:
 		if (unlikely(tlen != (hdrsize + pmtu + 4)))
-			goto ack_done;
+			goto ack_len_err;
 		if (unlikely(pmtu >= qp->s_rdma_read_len))
-			goto ack_done;
+			goto ack_len_err;
 
 		/* We got a response so update the timeout. */
 		spin_lock(&dev->pending_lock);
@@ -1184,12 +1184,20 @@ static inline void ipath_rc_rcv_resp(str
 			goto ack_done;
 		}
 		if (unlikely(wqe->wr.opcode != IB_WR_RDMA_READ))
-			goto ack_done;
+			goto ack_op_err;
+		/* Get the number of bytes the message was padded by. */
+		pad = (be32_to_cpu(ohdr->bth[0]) >> 20) & 3;
+		/*
+		 * Check that the data size is >= 0 && <= pmtu.
+		 * Remember to account for the AETH header (4) and
+		 * ICRC (4).
+		 */
+		if (unlikely(tlen < (hdrsize + pad + 8)))
+			goto ack_len_err;
 		/*
 		 * If this is a response to a resent RDMA read, we
 		 * have to be careful to copy the data to the right
 		 * location.
-		 * XXX should check PSN and wqe opcode first.
 		 */
 		qp->s_rdma_read_len = restart_sge(&qp->s_rdma_read_sge,
 						  wqe, psn, pmtu);
@@ -1203,26 +1211,20 @@ static inline void ipath_rc_rcv_resp(str
 			goto ack_done;
 		}
 		if (unlikely(wqe->wr.opcode != IB_WR_RDMA_READ))
-			goto ack_done;
-	read_last:
-		/*
-		 * Get the number of bytes the message was padded by.
-		 */
+			goto ack_op_err;
+		/* Get the number of bytes the message was padded by. */
 		pad = (be32_to_cpu(ohdr->bth[0]) >> 20) & 3;
 		/*
 		 * Check that the data size is >= 1 && <= pmtu.
 		 * Remember to account for the AETH header (4) and
 		 * ICRC (4).
 		 */
-		if (unlikely(tlen <= (hdrsize + pad + 8))) {
-			/* XXX Need to generate an error CQ entry. */
-			goto ack_done;
-		}
+		if (unlikely(tlen <= (hdrsize + pad + 8)))
+			goto ack_len_err;
+	read_last:
 		tlen -= hdrsize + pad + 8;
-		if (unlikely(tlen != qp->s_rdma_read_len)) {
-			/* XXX Need to generate an error CQ entry. */
-			goto ack_done;
-		}
+		if (unlikely(tlen != qp->s_rdma_read_len))
+			goto ack_len_err;
 		if (!header_in_data)
 			aeth = be32_to_cpu(ohdr->u.aeth);
 		else {
@@ -1236,6 +1238,29 @@ static inline void ipath_rc_rcv_resp(str
 
 ack_done:
 	spin_unlock_irqrestore(&qp->s_lock, flags);
+	goto bail;
+
+ack_op_err:
+	wc.status = IB_WC_LOC_QP_OP_ERR;
+	goto ack_err;
+
+ack_len_err:
+	wc.status = IB_WC_LOC_LEN_ERR;
+ack_err:
+	wc.wr_id = wqe->wr.wr_id;
+	wc.opcode = ib_ipath_wc_opcode[wqe->wr.opcode];
+	wc.vendor_err = 0;
+	wc.byte_len = 0;
+	wc.imm_data = 0;
+	wc.qp = &qp->ibqp;
+	wc.src_qp = qp->remote_qpn;
+	wc.wc_flags = 0;
+	wc.pkey_index = 0;
+	wc.slid = qp->remote_ah_attr.dlid;
+	wc.sl = qp->remote_ah_attr.sl;
+	wc.dlid_path_bits = 0;
+	wc.port_num = 0;
+	ipath_sqerror_qp(qp, &wc);
 bail:
 	return;
 }
