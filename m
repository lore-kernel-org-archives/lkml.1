Return-Path: <linux-kernel-owner+w=401wt.eu-S1758864AbXF0Pw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864AbXF0Pw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 11:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760940AbXF0Pvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 11:51:35 -0400
Received: from rrcs-71-42-183-126.sw.biz.rr.com ([71.42.183.126]:39352 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760850AbXF0Pve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 11:51:34 -0400
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 3/6] iw_cxgb3: Don't count neg_adv abort_req_rss messages as real aborts.
Date: Wed, 27 Jun 2007 10:51:35 -0500
To: rdreier@cisco.com
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, divy@chelsio.com
Message-Id: <20070627155135.24944.44327.stgit@dell3.ogc.int>
In-Reply-To: <20070627155119.24944.44172.stgit@dell3.ogc.int>
References: <20070627155119.24944.44172.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


iw_cxgb3: Don't count neg_adv abort_req_rss messages as real aborts.

negative advice messages should _not_ count toward the 2 abort requests
needed to indicate an abort request.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb3/iwch_cm.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index 7b8d5aa..4d7c277 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -1465,6 +1465,13 @@ static int peer_abort(struct t3cdev *tde
 	int ret;
 	int state;
 
+	if (is_neg_adv_abort(req->status)) {
+		PDBG("%s neg_adv_abort ep %p tid %d\n", __FUNCTION__, ep,
+		     ep->hwtid);
+		t3_l2t_send_event(ep->com.tdev, ep->l2t);
+		return CPL_RET_BUF_DONE;
+	}
+
 	/*
 	 * We get 2 peer aborts from the HW.  The first one must
 	 * be ignored except for scribbling that we need one more.
@@ -1474,13 +1481,6 @@ static int peer_abort(struct t3cdev *tde
 		return CPL_RET_BUF_DONE;
 	}
 
-	if (is_neg_adv_abort(req->status)) {
-		PDBG("%s neg_adv_abort ep %p tid %d\n", __FUNCTION__, ep,
-		     ep->hwtid);
-		t3_l2t_send_event(ep->com.tdev, ep->l2t);
-		return CPL_RET_BUF_DONE;
-	}
-
 	state = state_read(&ep->com);
 	PDBG("%s ep %p state %u\n", __FUNCTION__, ep, state);
 	switch (state) {
