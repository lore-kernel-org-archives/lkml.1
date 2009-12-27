Return-Path: <linux-kernel-owner+w=401wt.eu-S1751218AbZL0HMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218AbZL0HMc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 02:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbZL0HMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 02:12:31 -0500
Received: from stargate.chelsio.com ([67.207.112.58]:27140 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbZL0HMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 02:12:30 -0500
Date: Sun, 27 Dec 2009 12:41:58 +0530 (IST)
From: Rakesh Ranjan <rakesh@chelsio.com>
X-X-Sender: rakesh@rakeshpc.asicdesigner.com
To: LNDML <netdev@vger.kernel.org>, LSCSIML <linux-scsi@vger.kernel.org>,
       OISCSIML <open-iscsi@googlegroups.com>
cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
       Mike Christie <michaelc@cs.wisc.edu>,
       James Bottomley <james.bottomley@hansenpartnership.com>,
       Karen Xie <kxie@chelsio.com>, Rakesh Ranjan <rakesh@chelsio.com>
Subject: [RESEND PATCH 1/1]cxgb3i: Fix a login over vlan issue
Message-ID: <alpine.LFD.2.00.0912271235370.12420@rakeshpc.asicdesigner.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 27 Dec 2009 07:14:42.0109 (UTC) FILETIME=[42833ED0:01CA86C4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rakesh Ranjan <rakesh@chelsio.com>
Date: Sun, 27 Dec 2009 12:33:08 +0530
Fix a target login issue, when parent interface is vlan and we are using cxgb3i sepecific
private ip address in '/etc/iscsi/ifaces/' iface file.

Acked-by: Karen Xie <kxie@chelsio.com>
Signed-off-by: Rakesh Ranjan <rakesh@chelsio.com>
---
 drivers/scsi/cxgb3i/cxgb3i_offload.c |   34 +++++++++++++++++++++++++++++++++-
 1 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.c b/drivers/scsi/cxgb3i/cxgb3i_offload.c
index c1d5be4..4b8a513 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.c
@@ -1440,6 +1440,10 @@ void cxgb3i_c3cn_release(struct s3_conn *c3cn)
 static int is_cxgb3_dev(struct net_device *dev)
 {
 	struct cxgb3i_sdev_data *cdata;
+	struct net_device *ndev = dev;
+
+	if (dev->priv_flags && IFF_802_1Q_VLAN)
+		ndev = vlan_dev_real_dev(dev);
 
 	write_lock(&cdata_rwlock);
 	list_for_each_entry(cdata, &cdata_list, list) {
@@ -1447,7 +1451,7 @@ static int is_cxgb3_dev(struct net_device *dev)
 		int i;
 
 		for (i = 0; i < ports->nports; i++)
-			if (dev == ports->lldevs[i]) {
+			if (ndev == ports->lldevs[i]) {
 				write_unlock(&cdata_rwlock);
 				return 1;
 			}
@@ -1566,6 +1570,26 @@ out_err:
 	return -1;
 }
 
+/* *
+ * cxgb3i_find_dev - find the interface associated with the given address
+ * @ipaddr: ip address
+ */
+static struct net_device *
+cxgb3i_find_dev(struct net_device *dev, __be32 ipaddr)
+{
+	struct flowi fl;
+	int err;
+	struct rtable *rt;
+
+	memset(&fl, 0, sizeof(fl));
+	fl.nl_u.ip4_u.daddr = ipaddr;
+
+	err = ip_route_output_key(dev ? dev_net(dev) : &init_net, &rt, &fl);
+	if (!err)
+		return (&rt->u.dst)->dev;
+
+	return NULL;
+}
 
 /**
  * cxgb3i_c3cn_connect - initiates an iscsi tcp connection to a given address
@@ -1581,6 +1605,7 @@ int cxgb3i_c3cn_connect(struct net_device *dev, struct s3_conn *c3cn,
 	struct cxgb3i_sdev_data *cdata;
 	struct t3cdev *cdev;
 	__be32 sipv4;
+	struct net_device *dstdev;
 	int err;
 
 	c3cn_conn_debug("c3cn 0x%p, dev 0x%p.\n", c3cn, dev);
@@ -1591,6 +1616,13 @@ int cxgb3i_c3cn_connect(struct net_device *dev, struct s3_conn *c3cn,
 	c3cn->daddr.sin_port = usin->sin_port;
 	c3cn->daddr.sin_addr.s_addr = usin->sin_addr.s_addr;
 
+	dstdev = cxgb3i_find_dev(dev, usin->sin_addr.s_addr);
+	if (!dstdev || !is_cxgb3_dev(dstdev))
+		return -ENETUNREACH;
+
+	if (dstdev->priv_flags & IFF_802_1Q_VLAN)
+		dev = dstdev;
+
 	rt = find_route(dev, c3cn->saddr.sin_addr.s_addr,
 			c3cn->daddr.sin_addr.s_addr,
 			c3cn->saddr.sin_port,
-- 
1.6.0.6

