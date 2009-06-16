Return-Path: <linux-kernel-owner+w=401wt.eu-S936051AbZFPGAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936051AbZFPGAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935902AbZFPFv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:29 -0400
Received: from kroah.org ([198.145.64.141]:48409 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935872AbZFPFv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:26 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux1394-devel@lists.sourceforge.net,
       Ben Collins <ben.collins@ubuntu.com>
Subject: [PATCH 40/64] ieee1394: remove driver_data direct access of struct device
Date: Mon, 15 Jun 2009 22:46:29 -0700
Message-Id: <1245131213-24168-40-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the near future, the driver core is going to not allow direct access
to the driver_data pointer in struct device.  Instead, the functions
dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
have been around since the beginning, so are backwards compatible with
all older kernel versions.

Cc: linux1394-devel@lists.sourceforge.net
Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Ben Collins <ben.collins@ubuntu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/ieee1394/eth1394.c |   16 +++++++---------
 drivers/ieee1394/sbp2.c    |    8 ++++----
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/ieee1394/eth1394.c b/drivers/ieee1394/eth1394.c
index 4ca1035..f5c586c 100644
--- a/drivers/ieee1394/eth1394.c
+++ b/drivers/ieee1394/eth1394.c
@@ -361,7 +361,7 @@ static int eth1394_new_node(struct eth1394_host_info *hi,
 	node_info->pdg.sz = 0;
 	node_info->fifo = CSR1212_INVALID_ADDR_SPACE;
 
-	ud->device.driver_data = node_info;
+	dev_set_drvdata(&ud->device, node_info);
 	new_node->ud = ud;
 
 	priv = netdev_priv(hi->dev);
@@ -406,7 +406,7 @@ static int eth1394_remove(struct device *dev)
 	list_del(&old_node->list);
 	kfree(old_node);
 
-	node_info = (struct eth1394_node_info*)ud->device.driver_data;
+	node_info = dev_get_drvdata(&ud->device);
 
 	spin_lock_irqsave(&node_info->pdg.lock, flags);
 	/* The partial datagram list should be empty, but we'll just
@@ -416,7 +416,7 @@ static int eth1394_remove(struct device *dev)
 	spin_unlock_irqrestore(&node_info->pdg.lock, flags);
 
 	kfree(node_info);
-	ud->device.driver_data = NULL;
+	dev_set_drvdata(&ud->device, NULL);
 	return 0;
 }
 
@@ -688,7 +688,7 @@ static void ether1394_host_reset(struct hpsb_host *host)
 	ether1394_reset_priv(dev, 0);
 
 	list_for_each_entry(node, &priv->ip_node_list, list) {
-		node_info = node->ud->device.driver_data;
+		node_info = dev_get_drvdata(&node->ud->device);
 
 		spin_lock_irqsave(&node_info->pdg.lock, flags);
 
@@ -872,8 +872,7 @@ static __be16 ether1394_parse_encap(struct sk_buff *skb, struct net_device *dev,
 		if (!node)
 			return cpu_to_be16(0);
 
-		node_info =
-		    (struct eth1394_node_info *)node->ud->device.driver_data;
+		node_info = dev_get_drvdata(&node->ud->device);
 
 		/* Update our speed/payload/fifo_offset table */
 		node_info->maxpayload =	maxpayload;
@@ -1080,7 +1079,7 @@ static int ether1394_data_handler(struct net_device *dev, int srcid, int destid,
 		priv->ud_list[NODEID_TO_NODE(srcid)] = ud;
 	}
 
-	node_info = (struct eth1394_node_info *)ud->device.driver_data;
+	node_info = dev_get_drvdata(&ud->device);
 
 	/* First, did we receive a fragmented or unfragmented datagram? */
 	hdr->words.word1 = ntohs(hdr->words.word1);
@@ -1617,8 +1616,7 @@ static int ether1394_tx(struct sk_buff *skb, struct net_device *dev)
 		if (!node)
 			goto fail;
 
-		node_info =
-		    (struct eth1394_node_info *)node->ud->device.driver_data;
+		node_info = dev_get_drvdata(&node->ud->device);
 		if (node_info->fifo == CSR1212_INVALID_ADDR_SPACE)
 			goto fail;
 
diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index a51ab23..83b734a 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -718,7 +718,7 @@ static int sbp2_remove(struct device *dev)
 	struct scsi_device *sdev;
 
 	ud = container_of(dev, struct unit_directory, device);
-	lu = ud->device.driver_data;
+	lu = dev_get_drvdata(&ud->device);
 	if (!lu)
 		return 0;
 
@@ -746,7 +746,7 @@ static int sbp2_remove(struct device *dev)
 
 static int sbp2_update(struct unit_directory *ud)
 {
-	struct sbp2_lu *lu = ud->device.driver_data;
+	struct sbp2_lu *lu = dev_get_drvdata(&ud->device);
 
 	if (sbp2_reconnect_device(lu) != 0) {
 		/*
@@ -815,7 +815,7 @@ static struct sbp2_lu *sbp2_alloc_device(struct unit_directory *ud)
 	atomic_set(&lu->state, SBP2LU_STATE_RUNNING);
 	INIT_WORK(&lu->protocol_work, NULL);
 
-	ud->device.driver_data = lu;
+	dev_set_drvdata(&ud->device, lu);
 
 	hi = hpsb_get_hostinfo(&sbp2_highlevel, ud->ne->host);
 	if (!hi) {
@@ -1051,7 +1051,7 @@ static void sbp2_remove_device(struct sbp2_lu *lu)
 		hpsb_unregister_addrspace(&sbp2_highlevel, hi->host,
 					  lu->status_fifo_addr);
 
-	lu->ud->device.driver_data = NULL;
+	dev_set_drvdata(&lu->ud->device, NULL);
 
 	module_put(hi->host->driver->owner);
 no_hi:
-- 
1.6.3.2

