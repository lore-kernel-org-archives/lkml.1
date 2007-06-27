Return-Path: <linux-kernel-owner+w=401wt.eu-S1762139AbXF0Pw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762139AbXF0Pw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 11:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761246AbXF0Pvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 11:51:46 -0400
Received: from rrcs-71-42-183-126.sw.biz.rr.com ([71.42.183.126]:39362 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761237AbXF0Pvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 11:51:44 -0400
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 5/6] iw_cxgb3: Don't post TID_RELEASE message.
Date: Wed, 27 Jun 2007 10:51:45 -0500
To: rdreier@cisco.com
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, divy@chelsio.com
Message-Id: <20070627155145.24944.64064.stgit@dell3.ogc.int>
In-Reply-To: <20070627155119.24944.44172.stgit@dell3.ogc.int>
References: <20070627155119.24944.44172.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


iw_cxgb3: Don't post TID_RELEASE message.

The LLD does this for us in cxgb3_remove_tid().

Also fixed active open failure cases where we shouldn't
be releasing the TID as well.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb3/iwch_cm.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index 4d7c277..228721f 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -254,8 +254,6 @@ static void release_ep_resources(struct 
 	cxgb3_remove_tid(ep->com.tdev, (void *)ep, ep->hwtid);
 	dst_release(ep->dst);
 	l2t_release(L2DATA(ep->com.tdev), ep->l2t);
-	if (ep->com.tdev->type == T3B)
-		release_tid(ep->com.tdev, ep->hwtid, NULL);
 	put_ep(&ep->com);
 }
 
@@ -1103,6 +1101,15 @@ static int abort_rpl(struct t3cdev *tdev
 	return CPL_RET_BUF_DONE;
 }
 
+/*
+ * Return whether a failed active open has allocated a TID
+ */
+static inline int act_open_has_tid(int status)
+{
+	return status != CPL_ERR_TCAM_FULL && status != CPL_ERR_CONN_EXIST &&
+	       status != CPL_ERR_ARP_MISS;
+}
+
 static int act_open_rpl(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 {
 	struct iwch_ep *ep = ctx;
@@ -1112,7 +1119,7 @@ static int act_open_rpl(struct t3cdev *t
 	     status2errno(rpl->status));
 	connect_reply_upcall(ep, status2errno(rpl->status));
 	state_set(&ep->com, DEAD);
-	if (ep->com.tdev->type == T3B)
+	if (ep->com.tdev->type == T3B && act_open_has_tid(rpl->status))
 		release_tid(ep->com.tdev, GET_TID(rpl), NULL);
 	cxgb3_free_atid(ep->com.tdev, ep->atid);
 	dst_release(ep->dst);
