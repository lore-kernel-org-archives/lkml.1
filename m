Return-Path: <linux-kernel-owner+w=401wt.eu-S1756586AbYAXWac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbYAXWac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbYAXWaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:30:19 -0500
Received: from 209-198-142-2-host.prismnet.net ([209.198.142.2]:56794 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379AbYAXWaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:30:17 -0500
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2.6.25] RDMA/cxgb3: Fix the T3A workaround checks.
Date: Thu, 24 Jan 2008 16:30:16 -0600
To: rdreier@cisco.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Message-Id: <20080124223016.772.18293.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


RDMA/cxgb3: Fix the T3A workaround checks.

Correctly work around T3A issues by checking "hwtype != T3A" instead of
"hwtype == T3B".  Needed for new hw types.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb3/cxio_hal.c      |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c       |    4 ++--
 drivers/infiniband/hw/cxgb3/iwch_provider.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infiniband/hw/cxgb3/cxio_hal.c
index eec6a30..e220b44 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
@@ -179,7 +179,7 @@ int cxio_create_cq(struct cxio_rdev *rdev_p, struct t3_cq *cq)
 	setup.size = 1UL << cq->size_log2;
 	setup.credits = 65535;
 	setup.credit_thres = 1;
-	if (rdev_p->t3cdev_p->type == T3B)
+	if (rdev_p->t3cdev_p->type != T3A)
 		setup.ovfl_mode = 0;
 	else
 		setup.ovfl_mode = 1;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index 20ba372..f8cb0fe 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -1118,7 +1118,7 @@ static int act_open_rpl(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 	     status2errno(rpl->status));
 	connect_reply_upcall(ep, status2errno(rpl->status));
 	state_set(&ep->com, DEAD);
-	if (ep->com.tdev->type == T3B && act_open_has_tid(rpl->status))
+	if (ep->com.tdev->type != T3A && act_open_has_tid(rpl->status))
 		release_tid(ep->com.tdev, GET_TID(rpl), NULL);
 	cxgb3_free_atid(ep->com.tdev, ep->atid);
 	dst_release(ep->dst);
@@ -1249,7 +1249,7 @@ static void reject_cr(struct t3cdev *tdev, u32 hwtid, __be32 peer_ip,
 	skb_trim(skb, sizeof(struct cpl_tid_release));
 	skb_get(skb);
 
-	if (tdev->type == T3B)
+	if (tdev->type != T3A)
 		release_tid(tdev, hwtid, skb);
 	else {
 		struct cpl_pass_accept_rpl *rpl;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 69b1204..df1838f 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -646,7 +646,7 @@ static struct ib_mr *iwch_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	if (err)
 		goto err;
 
-	if (udata && t3b_device(rhp)) {
+	if (udata && !t3a_device(rhp)) {
 		uresp.pbl_addr = (mhp->attr.pbl_addr -
 	                         rhp->rdev.rnic_info.pbl_base) >> 3;
 		PDBG("%s user resp pbl_addr 0x%x\n", __FUNCTION__,
