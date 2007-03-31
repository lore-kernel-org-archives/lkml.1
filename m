Return-Path: <linux-kernel-owner+w=401wt.eu-S1750888AbXCaHXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750888AbXCaHXR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 03:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751044AbXCaHXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 03:23:17 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:9865 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbXCaHXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 03:23:16 -0400
From: divy@chelsio.com
Subject: [PATCH 2.6.21 1/4] cxgb3 - Safeguard TCAM size usage
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Date: Sat, 31 Mar 2007 00:23:13 -0700
Message-ID: <20070331072313.4694.92549.stgit@localhost.localdomain>
User-Agent: StGIT/0.12
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

Ensure that the TCAM active region size is at least 16.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/common.h        |    3 +++
 drivers/net/cxgb3/cxgb3_main.c    |    7 +++++--
 drivers/net/cxgb3/cxgb3_offload.c |    4 +++-
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/cxgb3/common.h b/drivers/net/cxgb3/common.h
index 85e5543..38a0565 100644
--- a/drivers/net/cxgb3/common.h
+++ b/drivers/net/cxgb3/common.h
@@ -358,6 +358,9 @@ enum {
 	MC5_MODE_72_BIT = 2
 };
 
+/* MC5 min active region size */
+enum { MC5_MIN_TIDS = 16 };
+
 struct vpd_params {
 	unsigned int cclk;
 	unsigned int mclk;
diff --git a/drivers/net/cxgb3/cxgb3_main.c b/drivers/net/cxgb3/cxgb3_main.c
index d553836..b82544e 100644
--- a/drivers/net/cxgb3/cxgb3_main.c
+++ b/drivers/net/cxgb3/cxgb3_main.c
@@ -485,12 +485,14 @@ static ssize_t show_##name(struct device
 static ssize_t set_nfilters(struct net_device *dev, unsigned int val)
 {
 	struct adapter *adap = dev->priv;
+	int min_tids = is_offload(adap) ? MC5_MIN_TIDS : 0;
 
 	if (adap->flags & FULL_INIT_DONE)
 		return -EBUSY;
 	if (val && adap->params.rev == 0)
 		return -EINVAL;
-	if (val > t3_mc5_size(&adap->mc5) - adap->params.mc5.nservers)
+	if (val > t3_mc5_size(&adap->mc5) - adap->params.mc5.nservers -
+	    min_tids)
 		return -EINVAL;
 	adap->params.mc5.nfilters = val;
 	return 0;
@@ -508,7 +510,8 @@ static ssize_t set_nservers(struct net_d
 
 	if (adap->flags & FULL_INIT_DONE)
 		return -EBUSY;
-	if (val > t3_mc5_size(&adap->mc5) - adap->params.mc5.nfilters)
+	if (val > t3_mc5_size(&adap->mc5) - adap->params.mc5.nfilters -
+	    MC5_MIN_TIDS)
 		return -EINVAL;
 	adap->params.mc5.nservers = val;
 	return 0;
diff --git a/drivers/net/cxgb3/cxgb3_offload.c b/drivers/net/cxgb3/cxgb3_offload.c
index f6ed033..eed7a48 100644
--- a/drivers/net/cxgb3/cxgb3_offload.c
+++ b/drivers/net/cxgb3/cxgb3_offload.c
@@ -553,7 +553,9 @@ int cxgb3_alloc_atid(struct t3cdev *tdev
 	struct tid_info *t = &(T3C_DATA(tdev))->tid_maps;
 
 	spin_lock_bh(&t->atid_lock);
-	if (t->afree) {
+	if (t->afree &&
+	    t->atids_in_use + atomic_read(&t->tids_in_use) + MC5_MIN_TIDS <=
+	    t->ntids) {
 		union active_open_entry *p = t->afree;
 
 		atid = (p - t->atid_tab) + t->atid_base;
