Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbYBLWJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbYBLWJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbYBLWJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:09:31 -0500
Received: from 209-198-142-2-host.prismnet.net ([209.198.142.2]:45119 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752172AbYBLWJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:09:30 -0500
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2.6.25] RDMA/cxgb3: Fail loopback connections.
Date: Tue, 12 Feb 2008 16:09:29 -0600
To: rdreier@cisco.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Message-Id: <20080212220929.24442.76874.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


RDMA/cxgb3: Fail loopback connections.

The cxgb3 HW and driver don't support loopback RDMA connections.  So fail
any connection attempt where the destination address is local.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb3/iwch_cm.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index e9a08fa..5d82723 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -1784,6 +1784,17 @@ err:
 	return err;
 }
 
+static void is_loopback_dst(struct iw_cm_id *cm_id)
+{
+	struct net_device *dev;
+	
+	dev = ip_dev_find(&init_net, cm_id->remote_addr.sin_addr.s_addr);
+	if (!dev)
+		return 0;
+	dev_put(dev);
+	return 1;
+}
+
 int iwch_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 {
 	int err = 0;
@@ -1791,6 +1802,11 @@ int iwch_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	struct iwch_ep *ep;
 	struct rtable *rt;
 
+	if (is_loopback_dst(cm_id)) {
+		err = -ENOSYS;
+		goto out;
+	}
+
 	ep = alloc_ep(sizeof(*ep), GFP_KERNEL);
 	if (!ep) {
 		printk(KERN_ERR MOD "%s - cannot alloc ep.\n", __FUNCTION__);
