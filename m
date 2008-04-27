Return-Path: <linux-kernel-owner+w=401wt.eu-S1762257AbYD0QBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762257AbYD0QBI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 12:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758116AbYD0QAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 12:00:16 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:50110 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756088AbYD0QAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 12:00:08 -0400
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2.6.26 1/3] RDMA/cxgb3: Correctly serialize peer abort path.
Date: Sun, 27 Apr 2008 11:00:06 -0500
To: rdreier@cisco.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       general@lists.openfabrics.org, divy@chelsio.com, felix@chelsio.com
Message-Id: <20080427160006.31018.66715.stgit@dell3.ogc.int>
In-Reply-To: <20080427155456.31018.22282.stgit@dell3.ogc.int>
References: <20080427155456.31018.22282.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


OpenMPI and other stress testing exposed a few bad bugs in handling
aborts in the middle of a normal close.

- serialize abort reply and peer abort processing with
disconnect processing

- warn (and ignore) if ep timer is stopped when it wasn't running

- cleaned up disconnect path to correctly deal with aborting and dead
endpoints

- in iwch_modify_qp(), add a ref to the ep before releasing the qp lock if
iwch_ep_disconnect() will be called.  The dref after calling disconnect.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb3/iwch_cm.c |   98 ++++++++++++++++++++++-----------
 drivers/infiniband/hw/cxgb3/iwch_cm.h |    1 
 drivers/infiniband/hw/cxgb3/iwch_qp.c |    6 ++
 3 files changed, 71 insertions(+), 34 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index 99f2f2a..1627bff 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -125,6 +125,12 @@ static void start_ep_timer(struct iwch_ep *ep)
 static void stop_ep_timer(struct iwch_ep *ep)
 {
 	PDBG("%s ep %p\n", __FUNCTION__, ep);
+	if (!timer_pending(&ep->timer)) {
+		printk(KERN_ERR "%s timer stopped when its not running!  ep %p state %u\n",
+			__FUNCTION__, ep, ep->com.state);
+		WARN_ON(1);
+		return;
+	}
 	del_timer_sync(&ep->timer);
 	put_ep(&ep->com);
 }
@@ -1083,8 +1089,11 @@ static int tx_ack(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 static int abort_rpl(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 {
 	struct iwch_ep *ep = ctx;
+	unsigned long flags;
+	int release = 0;
 
 	PDBG("%s ep %p\n", __FUNCTION__, ep);
+	BUG_ON(!ep);
 
 	/*
 	 * We get 2 abort replies from the HW.  The first one must
@@ -1095,9 +1104,22 @@ static int abort_rpl(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 		return CPL_RET_BUF_DONE;
 	}
 
-	close_complete_upcall(ep);
-	state_set(&ep->com, DEAD);
-	release_ep_resources(ep);
+	spin_lock_irqsave(&ep->com.lock, flags);
+	switch (ep->com.state) {
+	case ABORTING:
+		close_complete_upcall(ep);
+		__state_set(&ep->com, DEAD);
+		release = 1;
+		break;
+	default:
+		printk(KERN_ERR "%s ep %p state %d\n",
+		     __FUNCTION__, ep, ep->com.state);
+		break;
+	}
+	spin_unlock_irqrestore(&ep->com.lock, flags);
+
+	if (release)
+		release_ep_resources(ep);
 	return CPL_RET_BUF_DONE;
 }
 
@@ -1470,7 +1492,8 @@ static int peer_abort(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 	struct sk_buff *rpl_skb;
 	struct iwch_qp_attributes attrs;
 	int ret;
-	int state;
+	int release = 0;
+	unsigned long flags;
 
 	if (is_neg_adv_abort(req->status)) {
 		PDBG("%s neg_adv_abort ep %p tid %d\n", __FUNCTION__, ep,
@@ -1488,9 +1511,9 @@ static int peer_abort(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 		return CPL_RET_BUF_DONE;
 	}
 
-	state = state_read(&ep->com);
-	PDBG("%s ep %p state %u\n", __FUNCTION__, ep, state);
-	switch (state) {
+	spin_lock_irqsave(&ep->com.lock, flags);
+	PDBG("%s ep %p state %u\n", __FUNCTION__, ep, ep->com.state);
+	switch (ep->com.state) {
 	case CONNECTING:
 		break;
 	case MPA_REQ_WAIT:
@@ -1536,21 +1559,25 @@ static int peer_abort(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 		break;
 	case DEAD:
 		PDBG("%s PEER_ABORT IN DEAD STATE!!!!\n", __FUNCTION__);
+		spin_unlock_irqrestore(&ep->com.lock, flags);
 		return CPL_RET_BUF_DONE;
 	default:
 		BUG_ON(1);
 		break;
 	}
 	dst_confirm(ep->dst);
+	if (ep->com.state != ABORTING) {
+		__state_set(&ep->com, DEAD);
+		release = 1;
+	}
+	spin_unlock_irqrestore(&ep->com.lock, flags);
 
 	rpl_skb = get_skb(skb, sizeof(*rpl), GFP_KERNEL);
 	if (!rpl_skb) {
 		printk(KERN_ERR MOD "%s - cannot allocate skb!\n",
 		       __FUNCTION__);
-		dst_release(ep->dst);
-		l2t_release(L2DATA(ep->com.tdev), ep->l2t);
-		put_ep(&ep->com);
-		return CPL_RET_BUF_DONE;
+		release = 1;
+		goto out;
 	}
 	rpl_skb->priority = CPL_PRIORITY_DATA;
 	rpl = (struct cpl_abort_rpl *) skb_put(rpl_skb, sizeof(*rpl));
@@ -1559,10 +1586,9 @@ static int peer_abort(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 	OPCODE_TID(rpl) = htonl(MK_OPCODE_TID(CPL_ABORT_RPL, ep->hwtid));
 	rpl->cmd = CPL_ABORT_NO_RST;
 	cxgb3_ofld_send(ep->com.tdev, rpl_skb);
-	if (state != ABORTING) {
-		state_set(&ep->com, DEAD);
+out:
+	if (release)
 		release_ep_resources(ep);
-	}
 	return CPL_RET_BUF_DONE;
 }
 
@@ -1661,15 +1687,18 @@ static void ep_timeout(unsigned long arg)
 	struct iwch_ep *ep = (struct iwch_ep *)arg;
 	struct iwch_qp_attributes attrs;
 	unsigned long flags;
+	int abort=1;
 
 	spin_lock_irqsave(&ep->com.lock, flags);
 	PDBG("%s ep %p tid %u state %d\n", __FUNCTION__, ep, ep->hwtid,
 	     ep->com.state);
 	switch (ep->com.state) {
 	case MPA_REQ_SENT:
+		__state_set(&ep->com, ABORTING);
 		connect_reply_upcall(ep, -ETIMEDOUT);
 		break;
 	case MPA_REQ_WAIT:
+		__state_set(&ep->com, ABORTING);
 		break;
 	case CLOSING:
 	case MORIBUND:
@@ -1679,13 +1708,17 @@ static void ep_timeout(unsigned long arg)
 				     ep->com.qp, IWCH_QP_ATTR_NEXT_STATE,
 				     &attrs, 1);
 		}
+		__state_set(&ep->com, ABORTING);
 		break;
 	default:
-		BUG();
+		printk(KERN_ERR "%s unexpected state ep %p state %u\n",
+			__FUNCTION__, ep, ep->com.state);
+		WARN_ON(1);
+		abort=0;
 	}
-	__state_set(&ep->com, CLOSING);
 	spin_unlock_irqrestore(&ep->com.lock, flags);
-	abort_connection(ep, NULL, GFP_ATOMIC);
+	if (abort)
+		abort_connection(ep, NULL, GFP_ATOMIC);
 	put_ep(&ep->com);
 }
 
@@ -1968,34 +2001,33 @@ int iwch_ep_disconnect(struct iwch_ep *ep, int abrupt, gfp_t gfp)
 	PDBG("%s ep %p state %s, abrupt %d\n", __FUNCTION__, ep,
 	     states[ep->com.state], abrupt);
 
-	if (ep->com.state == DEAD) {
-		PDBG("%s already dead ep %p\n", __FUNCTION__, ep);
-		goto out;
-	}
-
-	if (abrupt) {
-		if (ep->com.state != ABORTING) {
-			ep->com.state = ABORTING;
-			close = 1;
-		}
-		goto out;
-	}
-
 	switch (ep->com.state) {
 	case MPA_REQ_WAIT:
 	case MPA_REQ_SENT:
 	case MPA_REQ_RCVD:
 	case MPA_REP_SENT:
 	case FPDU_MODE:
-		start_ep_timer(ep);
-		ep->com.state = CLOSING;
 		close = 1;
+		if (abrupt)
+			ep->com.state = ABORTING;
+		else {
+			ep->com.state = CLOSING;
+			start_ep_timer(ep);
+		}
 		break;
 	case CLOSING:
-		ep->com.state = MORIBUND;
 		close = 1;
+		if (abrupt) {
+			stop_ep_timer(ep);
+			ep->com.state = ABORTING;
+		} else
+			ep->com.state = MORIBUND;
 		break;
 	case MORIBUND:
+	case ABORTING:
+	case DEAD:
+		PDBG("%s ignoring disconnect ep %p state %u\n",
+		     __FUNCTION__, ep, ep->com.state);
 		break;
 	default:
 		BUG();
diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.h b/drivers/infiniband/hw/cxgb3/iwch_cm.h
index 6107e7c..a3fb959 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.h
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.h
@@ -56,6 +56,7 @@
 #define put_ep(ep) { \
 	PDBG("put_ep (via %s:%u) ep %p refcnt %d\n", __FUNCTION__, __LINE__,  \
 	     ep, atomic_read(&((ep)->kref.refcount))); \
+	WARN_ON(atomic_read(&((ep)->kref.refcount)) < 1); \
 	kref_put(&((ep)->kref), __free_ep); \
 }
 
diff --git a/drivers/infiniband/hw/cxgb3/iwch_qp.c b/drivers/infiniband/hw/cxgb3/iwch_qp.c
index ea2cdd7..c02bb94 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_qp.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c
@@ -832,6 +832,7 @@ int iwch_modify_qp(struct iwch_dev *rhp, struct iwch_qp *qhp,
 				abort=0;
 				disconnect = 1;
 				ep = qhp->ep;
+				get_ep(&ep->com);
 			}
 			flush_qp(qhp, &flag);
 			break;
@@ -848,6 +849,7 @@ int iwch_modify_qp(struct iwch_dev *rhp, struct iwch_qp *qhp,
 				abort=1;
 				disconnect = 1;
 				ep = qhp->ep;
+				get_ep(&ep->com);
 			}
 			goto err;
 			break;
@@ -929,8 +931,10 @@ out:
 	 * on the EP.  This can be a normal close (RTS->CLOSING) or
 	 * an abnormal close (RTS/CLOSING->ERROR).
 	 */
-	if (disconnect)
+	if (disconnect) {
 		iwch_ep_disconnect(ep, abort, GFP_KERNEL);
+		put_ep(&ep->com);
+	}
 
 	/*
 	 * If free is 1, then we've disassociated the EP from the QP
