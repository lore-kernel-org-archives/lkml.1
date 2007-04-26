Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318AbXDZUVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbXDZUVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755007AbXDZUVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:21:33 -0400
Received: from rrcs-71-42-183-126.sw.biz.rr.com ([71.42.183.126]:52554 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755002AbXDZUVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:21:21 -0400
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2.6.22 4/5] iw_cxgb3: Support for new abort logic.
Date: Thu, 26 Apr 2007 15:21:20 -0500
To: rdreier@cisco.com, jeff@garzik.org
Cc: divy@chelsio.com, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Message-Id: <20070426202120.24234.62250.stgit@dell3.ogc.int>
In-Reply-To: <20070426202057.24234.56383.stgit@dell3.ogc.int>
References: <20070426202057.24234.56383.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Support for new abort logic.

The HW now posts 2 ABORT_RPL and/or PEER_ABORT_REQ messages.  We need
to handle them by silenty dropping the 1st but mark that we're ready
for the final message.  This plugs some close races between the uP and HW.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb3/iwch_cm.c |   18 ++++++++++++++++++
 drivers/infiniband/hw/cxgb3/iwch_cm.h |    6 ++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index a990423..3a46a97 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -1107,6 +1107,15 @@ static int abort_rpl(struct t3cdev *tdev
 
 	PDBG("%s ep %p\n", __FUNCTION__, ep);
 
+	/*
+ 	 * We get 2 abort replies from the HW.  The first one must
+	 * be ignored except for scribbling that we need one more.
+	 */
+	if (!(ep->flags & ABORT_REQ_IN_PROGRESS)) {
+		ep->flags |= ABORT_REQ_IN_PROGRESS;
+		return CPL_RET_BUF_DONE;
+	}
+
 	close_complete_upcall(ep);
 	state_set(&ep->com, DEAD);
 	release_ep_resources(ep);
@@ -1474,6 +1483,15 @@ static int peer_abort(struct t3cdev *tde
 	int ret;
 	int state;
 
+	/*
+ 	 * We get 2 peer aborts from the HW.  The first one must
+	 * be ignored except for scribbling that we need one more.
+	 */
+	if (!(ep->flags & PEER_ABORT_IN_PROGRESS)) {
+		ep->flags |= PEER_ABORT_IN_PROGRESS;
+		return CPL_RET_BUF_DONE;
+	}
+
 	if (is_neg_adv_abort(req->status)) {
 		PDBG("%s neg_adv_abort ep %p tid %d\n", __FUNCTION__, ep,
 		     ep->hwtid);
diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.h b/drivers/infiniband/hw/cxgb3/iwch_cm.h
index 0c6f281..21a388c 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.h
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.h
@@ -143,6 +143,11 @@ enum iwch_ep_state {
 	DEAD,
 };
 
+enum iwch_ep_flags {
+	PEER_ABORT_IN_PROGRESS	= (1 << 0),
+	ABORT_REQ_IN_PROGRESS	= (1 << 1),
+};
+
 struct iwch_ep_common {
 	struct iw_cm_id *cm_id;
 	struct iwch_qp *qp;
@@ -181,6 +186,7 @@ struct iwch_ep {
 	u16 plen;
 	u32 ird;
 	u32 ord;
+	u32 flags;
 };
 
 static inline struct iwch_ep *to_ep(struct iw_cm_id *cm_id)
