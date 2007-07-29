Return-Path: <linux-kernel-owner+w=401wt.eu-S934443AbXG2UM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934443AbXG2UM4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 16:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934463AbXG2UMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 16:12:32 -0400
Received: from rrcs-71-42-183-126.sw.biz.rr.com ([71.42.183.126]:46278 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933892AbXG2UMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 16:12:30 -0400
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2.6.23 2/2] iw_cxgb3: Always call low level send function via cxgb3_ofld_send().
Date: Sun, 29 Jul 2007 15:12:29 -0500
To: rdreier@cisco.com
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Message-Id: <20070729201228.31659.26300.stgit@dell3.ogc.int>
In-Reply-To: <20070729201226.31659.85900.stgit@dell3.ogc.int>
References: <20070729201226.31659.85900.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


iw_cxgb3: Always call low level send function via cxgb3_ofld_send().

Avoids deadlocks.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb3/iwch_cm.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index fa95dce..20ba372 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -139,7 +139,7 @@ static void release_tid(struct t3cdev *t
 	req->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_FORWARD));
 	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_TID_RELEASE, hwtid));
 	skb->priority = CPL_PRIORITY_SETUP;
-	tdev->send(tdev, skb);
+	cxgb3_ofld_send(tdev, skb);
 	return;
 }
 
@@ -161,7 +161,7 @@ int iwch_quiesce_tid(struct iwch_ep *ep)
 	req->val = cpu_to_be64(1 << S_TCB_RX_QUIESCE);
 
 	skb->priority = CPL_PRIORITY_DATA;
-	ep->com.tdev->send(ep->com.tdev, skb);
+	cxgb3_ofld_send(ep->com.tdev, skb);
 	return 0;
 }
 
@@ -183,7 +183,7 @@ int iwch_resume_tid(struct iwch_ep *ep)
 	req->val = 0;
 
 	skb->priority = CPL_PRIORITY_DATA;
-	ep->com.tdev->send(ep->com.tdev, skb);
+	cxgb3_ofld_send(ep->com.tdev, skb);
 	return 0;
 }
 
@@ -784,7 +784,7 @@ static int update_rx_credits(struct iwch
 	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_RX_DATA_ACK, ep->hwtid));
 	req->credit_dack = htonl(V_RX_CREDITS(credits) | V_RX_FORCE_ACK(1));
 	skb->priority = CPL_PRIORITY_ACK;
-	ep->com.tdev->send(ep->com.tdev, skb);
+	cxgb3_ofld_send(ep->com.tdev, skb);
 	return credits;
 }
 
@@ -1152,7 +1152,7 @@ static int listen_start(struct iwch_list
 	req->opt1 = htonl(V_CONN_POLICY(CPL_CONN_POLICY_ASK));
 
 	skb->priority = 1;
-	ep->com.tdev->send(ep->com.tdev, skb);
+	cxgb3_ofld_send(ep->com.tdev, skb);
 	return 0;
 }
 
@@ -1186,7 +1186,7 @@ static int listen_stop(struct iwch_liste
 	req->cpu_idx = 0;
 	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_CLOSE_LISTSRV_REQ, ep->stid));
 	skb->priority = 1;
-	ep->com.tdev->send(ep->com.tdev, skb);
+	cxgb3_ofld_send(ep->com.tdev, skb);
 	return 0;
 }
 
@@ -1264,7 +1264,7 @@ static void reject_cr(struct t3cdev *tde
 		rpl->opt0l_status = htonl(CPL_PASS_OPEN_REJECT);
 		rpl->opt2 = 0;
 		rpl->rsvd = rpl->opt2;
-		tdev->send(tdev, skb);
+		cxgb3_ofld_send(tdev, skb);
 	}
 }
 
@@ -1557,7 +1557,7 @@ static int peer_abort(struct t3cdev *tde
 	rpl->wr.wr_lo = htonl(V_WR_TID(ep->hwtid));
 	OPCODE_TID(rpl) = htonl(MK_OPCODE_TID(CPL_ABORT_RPL, ep->hwtid));
 	rpl->cmd = CPL_ABORT_NO_RST;
-	ep->com.tdev->send(ep->com.tdev, rpl_skb);
+	cxgb3_ofld_send(ep->com.tdev, rpl_skb);
 	if (state != ABORTING) {
 		state_set(&ep->com, DEAD);
 		release_ep_resources(ep);
