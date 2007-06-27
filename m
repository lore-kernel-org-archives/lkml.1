Return-Path: <linux-kernel-owner+w=401wt.eu-S1761453AbXF0Pvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761453AbXF0Pvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 11:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759006AbXF0Pv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 11:51:26 -0400
Received: from rrcs-71-42-183-126.sw.biz.rr.com ([71.42.183.126]:39337 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757467AbXF0PvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 11:51:23 -0400
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 1/6] iw_cxgb3: Streaming -> RDMA mode transition fixes.
Date: Wed, 27 Jun 2007 10:51:25 -0500
To: rdreier@cisco.com
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, divy@chelsio.com
Message-Id: <20070627155124.24944.26940.stgit@dell3.ogc.int>
In-Reply-To: <20070627155119.24944.44172.stgit@dell3.ogc.int>
References: <20070627155119.24944.44172.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


iw_cxgb3: Streaming -> RDMA mode transition fixes.

Due to a HW issue, our current scheme to transition the connection from
streaming to rdma mode is broken on the passive side.  The firmware
and driver now support a new transition scheme for the passive side:

- driver posts rdma_init_wr (now including the initial receive seqno)

- driver posts last streaming message via TX_DATA message (MPA start
response)

- uP atomically sends the last streaming message and transitions the
tcb to rdma mode.

- driver waits for wr_ack indicating the last streaming message was ACKed.

NOTE: This change also bumps the required firmware version to 4.3.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb3/cxio_hal.c |    2 -
 drivers/infiniband/hw/cxgb3/cxio_wr.h  |    3 +
 drivers/infiniband/hw/cxgb3/iwch_cm.c  |   82 ++++++++++++--------------------
 drivers/infiniband/hw/cxgb3/iwch_cm.h  |    1 
 drivers/infiniband/hw/cxgb3/iwch_qp.c  |    1 
 drivers/net/cxgb3/version.h            |    2 -
 6 files changed, 38 insertions(+), 53 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infiniband/hw/cxgb3/cxio_hal.c
index 76049af..215bbe5 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
@@ -833,7 +833,7 @@ int cxio_rdma_init(struct cxio_rdev *rde
 	wqe->ird = cpu_to_be32(attr->ird);
 	wqe->qp_dma_addr = cpu_to_be64(attr->qp_dma_addr);
 	wqe->qp_dma_size = cpu_to_be32(attr->qp_dma_size);
-	wqe->rsvd = 0;
+	wqe->irs = cpu_to_be32(attr->irs);
 	skb->priority = 0;	/* 0=>ToeQ; 1=>CtrlQ */
 	return (cxgb3_ofld_send(rdev_p->t3cdev_p, skb));
 }
diff --git a/drivers/infiniband/hw/cxgb3/cxio_wr.h b/drivers/infiniband/hw/cxgb3/cxio_wr.h
index ff7290e..c84d4ac 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_wr.h
+++ b/drivers/infiniband/hw/cxgb3/cxio_wr.h
@@ -294,6 +294,7 @@ struct t3_rdma_init_attr {
 	u64 qp_dma_addr;
 	u32 qp_dma_size;
 	u32 flags;
+	u32 irs;
 };
 
 struct t3_rdma_init_wr {
@@ -314,7 +315,7 @@ struct t3_rdma_init_wr {
 	__be32 ird;
 	__be64 qp_dma_addr;	/* 7 */
 	__be32 qp_dma_size;	/* 8 */
-	u32 rsvd;
+	u32 irs;
 };
 
 struct t3_genbit {
diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index b2faff5..7b8d5aa 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -515,7 +515,7 @@ static void send_mpa_req(struct iwch_ep 
 	req->len = htonl(len);
 	req->param = htonl(V_TX_PORT(ep->l2t->smt_idx) |
 			   V_TX_SNDBUF(snd_win>>15));
-	req->flags = htonl(F_TX_IMM_ACK|F_TX_INIT);
+	req->flags = htonl(F_TX_INIT);
 	req->sndseq = htonl(ep->snd_seq);
 	BUG_ON(ep->mpa_skb);
 	ep->mpa_skb = skb;
@@ -566,7 +566,7 @@ static int send_mpa_reject(struct iwch_e
 	req->len = htonl(mpalen);
 	req->param = htonl(V_TX_PORT(ep->l2t->smt_idx) |
 			   V_TX_SNDBUF(snd_win>>15));
-	req->flags = htonl(F_TX_IMM_ACK|F_TX_INIT);
+	req->flags = htonl(F_TX_INIT);
 	req->sndseq = htonl(ep->snd_seq);
 	BUG_ON(ep->mpa_skb);
 	ep->mpa_skb = skb;
@@ -618,7 +618,7 @@ static int send_mpa_reply(struct iwch_ep
 	req->len = htonl(len);
 	req->param = htonl(V_TX_PORT(ep->l2t->smt_idx) |
 			   V_TX_SNDBUF(snd_win>>15));
-	req->flags = htonl(F_TX_MORE | F_TX_IMM_ACK | F_TX_INIT);
+	req->flags = htonl(F_TX_INIT);
 	req->sndseq = htonl(ep->snd_seq);
 	ep->mpa_skb = skb;
 	state_set(&ep->com, MPA_REP_SENT);
@@ -641,6 +641,7 @@ static int act_establish(struct t3cdev *
 	cxgb3_insert_tid(ep->com.tdev, &t3c_client, ep, tid);
 
 	ep->snd_seq = ntohl(req->snd_isn);
+	ep->rcv_seq = ntohl(req->rcv_isn);
 
 	set_emss(ep, ntohs(req->tcp_opt));
 
@@ -1023,6 +1024,9 @@ static int rx_data(struct t3cdev *tdev, 
 	skb_pull(skb, sizeof(*hdr));
 	skb_trim(skb, dlen);
 
+	ep->rcv_seq += dlen;
+	BUG_ON(ep->rcv_seq != (ntohl(hdr->seq) + dlen));
+
 	switch (state_read(&ep->com)) {
 	case MPA_REQ_SENT:
 		process_mpa_reply(ep, skb);
@@ -1060,7 +1064,6 @@ static int tx_ack(struct t3cdev *tdev, s
 	struct iwch_ep *ep = ctx;
 	struct cpl_wr_ack *hdr = cplhdr(skb);
 	unsigned int credits = ntohs(hdr->credits);
-	enum iwch_qp_attr_mask  mask;
 
 	PDBG("%s ep %p credits %u\n", __FUNCTION__, ep, credits);
 
@@ -1072,30 +1075,6 @@ static int tx_ack(struct t3cdev *tdev, s
 	ep->mpa_skb = NULL;
 	dst_confirm(ep->dst);
 	if (state_read(&ep->com) == MPA_REP_SENT) {
-		struct iwch_qp_attributes attrs;
-
-		/* bind QP to EP and move to RTS */
-		attrs.mpa_attr = ep->mpa_attr;
-		attrs.max_ird = ep->ord;
-		attrs.max_ord = ep->ord;
-		attrs.llp_stream_handle = ep;
-		attrs.next_state = IWCH_QP_STATE_RTS;
-
-		/* bind QP and TID with INIT_WR */
-		mask = IWCH_QP_ATTR_NEXT_STATE |
-				     IWCH_QP_ATTR_LLP_STREAM_HANDLE |
-				     IWCH_QP_ATTR_MPA_ATTR |
-				     IWCH_QP_ATTR_MAX_IRD |
-				     IWCH_QP_ATTR_MAX_ORD;
-
-		ep->com.rpl_err = iwch_modify_qp(ep->com.qp->rhp,
-				     ep->com.qp, mask, &attrs, 1);
-
-		if (!ep->com.rpl_err) {
-			state_set(&ep->com, FPDU_MODE);
-			established_upcall(ep);
-		}
-
 		ep->com.rpl_done = 1;
 		PDBG("waking up ep %p\n", ep);
 		wake_up(&ep->com.waitq);
@@ -1378,6 +1357,7 @@ static int pass_establish(struct t3cdev 
 
 	PDBG("%s ep %p\n", __FUNCTION__, ep);
 	ep->snd_seq = ntohl(req->snd_isn);
+	ep->rcv_seq = ntohl(req->rcv_isn);
 
 	set_emss(ep, ntohs(req->tcp_opt));
 
@@ -1732,10 +1712,8 @@ int iwch_accept_cr(struct iw_cm_id *cm_i
 	struct iwch_qp *qp = get_qhp(h, conn_param->qpn);
 
 	PDBG("%s ep %p tid %u\n", __FUNCTION__, ep, ep->hwtid);
-	if (state_read(&ep->com) == DEAD) {
-		put_ep(&ep->com);
+	if (state_read(&ep->com) == DEAD)
 		return -ECONNRESET;
-	}
 
 	BUG_ON(state_read(&ep->com) != MPA_REQ_RCVD);
 	BUG_ON(!qp);
@@ -1755,17 +1733,8 @@ int iwch_accept_cr(struct iw_cm_id *cm_i
 	ep->ird = conn_param->ird;
 	ep->ord = conn_param->ord;
 	PDBG("%s %d ird %d ord %d\n", __FUNCTION__, __LINE__, ep->ird, ep->ord);
+
 	get_ep(&ep->com);
-	err = send_mpa_reply(ep, conn_param->private_data,
-			     conn_param->private_data_len);
-	if (err) {
-		ep->com.cm_id = NULL;
-		ep->com.qp = NULL;
-		cm_id->rem_ref(cm_id);
-		abort_connection(ep, NULL, GFP_KERNEL);
-		put_ep(&ep->com);
-		return err;
-	}
 
 	/* bind QP to EP and move to RTS */
 	attrs.mpa_attr = ep->mpa_attr;
@@ -1783,16 +1752,29 @@ int iwch_accept_cr(struct iw_cm_id *cm_i
 
 	err = iwch_modify_qp(ep->com.qp->rhp,
 			     ep->com.qp, mask, &attrs, 1);
+	if (err)
+		goto err;
 
-	if (err) {
-		ep->com.cm_id = NULL;
-		ep->com.qp = NULL;
-		cm_id->rem_ref(cm_id);
-		abort_connection(ep, NULL, GFP_KERNEL);
-	} else {
-		state_set(&ep->com, FPDU_MODE);
-		established_upcall(ep);
-	}
+	err = send_mpa_reply(ep, conn_param->private_data,
+			     conn_param->private_data_len);
+	if (err)
+		goto err;
+
+	/* wait for wr_ack */
+	wait_event(ep->com.waitq, ep->com.rpl_done);
+	err = ep->com.rpl_err;
+	if (err)
+		goto err;
+
+	state_set(&ep->com, FPDU_MODE);
+	established_upcall(ep);
+	put_ep(&ep->com);
+	return 0;
+err:
+	ep->com.cm_id = NULL;
+	ep->com.qp = NULL;
+	cm_id->rem_ref(cm_id);
+	abort_connection(ep, NULL, GFP_KERNEL);
 	put_ep(&ep->com);
 	return err;
 }
diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.h b/drivers/infiniband/hw/cxgb3/iwch_cm.h
index 21a388c..6107e7c 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.h
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.h
@@ -175,6 +175,7 @@ struct iwch_ep {
 	unsigned int atid;
 	u32 hwtid;
 	u32 snd_seq;
+	u32 rcv_seq;
 	struct l2t_entry *l2t;
 	struct dst_entry *dst;
 	struct sk_buff *mpa_skb;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_qp.c b/drivers/infiniband/hw/cxgb3/iwch_qp.c
index 714dddb..679b7c1 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_qp.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c
@@ -732,6 +732,7 @@ #endif
 	init_attr.qp_dma_addr = qhp->wq.dma_addr;
 	init_attr.qp_dma_size = (1UL << qhp->wq.size_log2);
 	init_attr.flags = rqes_posted(qhp) ? RECVS_POSTED : 0;
+	init_attr.irs = qhp->ep->rcv_seq;
 	PDBG("%s init_attr.rq_addr 0x%x init_attr.rq_size = %d "
 	     "flags 0x%x qpcaps 0x%x\n", __FUNCTION__,
 	     init_attr.rq_addr, init_attr.rq_size,
diff --git a/drivers/net/cxgb3/version.h b/drivers/net/cxgb3/version.h
index b112317..eb508bf 100644
--- a/drivers/net/cxgb3/version.h
+++ b/drivers/net/cxgb3/version.h
@@ -39,6 +39,6 @@ #define DRV_VERSION "1.0-ko"
 
 /* Firmware version */
 #define FW_VERSION_MAJOR 4
-#define FW_VERSION_MINOR 0
+#define FW_VERSION_MINOR 3
 #define FW_VERSION_MICRO 0
 #endif				/* __CHELSIO_VERSION_H */
