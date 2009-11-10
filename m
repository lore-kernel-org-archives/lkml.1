Return-Path: <linux-kernel-owner+w=401wt.eu-S932111AbZKJW2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbZKJW2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758492AbZKJW2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:28:16 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:49342 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758483AbZKJW2O (ORCPT
	<rfc822;groupwise-PMullaney@novell.com;0:0>);
	Tue, 10 Nov 2009 17:28:14 -0500
From: Patrick Mullaney <pmullaney@novell.com>
Subject: [PATCH 3/4] venetdev: support common venet netdev routines
To: alacrityvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, kaber@trash.net, arnd@arndb.de,
       bridge@lists.linux-foundation.org, evb@yahoogroups.com,
       netdev@vger.kernel.org
Date: Tue, 10 Nov 2009 17:28:05 -0500
Message-ID: <20091110222805.24100.59528.stgit@mimic.site>
In-Reply-To: <20091110222632.24100.14884.stgit@mimic.site>
References: <20091110222632.24100.14884.stgit@mimic.site>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch breaks out common netdev routines that allow
a device to pass venetdev pointer as opposed to assuming
it is the priv member of the netdevice.

Signed-off-by: Patrick Mullaney <pmullaney@novell.com>
---

 kernel/vbus/devices/venet/device.c      |   43 ++++++++++++++++++++++++++-----
 kernel/vbus/devices/venet/venetdevice.h |    5 ++++
 2 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/kernel/vbus/devices/venet/device.c b/kernel/vbus/devices/venet/device.c
index d49ba7f..9fd94ca 100644
--- a/kernel/vbus/devices/venet/device.c
+++ b/kernel/vbus/devices/venet/device.c
@@ -228,9 +228,8 @@ venetdev_txq_notify_dec(struct venetdev *priv)
  */
 
 int
-venetdev_netdev_open(struct net_device *dev)
+venetdev_open(struct venetdev *priv)
 {
-	struct venetdev *priv = netdev_priv(dev);
 	unsigned long flags;
 
 	BUG_ON(priv->netif.link);
@@ -260,7 +259,7 @@ venetdev_netdev_open(struct net_device *dev)
 	priv->netif.link = true;
 
 	if (!priv->vbus.link)
-		netif_carrier_off(dev);
+		netif_carrier_off(priv->netif.dev);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -268,9 +267,16 @@ venetdev_netdev_open(struct net_device *dev)
 }
 
 int
-venetdev_netdev_stop(struct net_device *dev)
+venetdev_netdev_open(struct net_device *dev)
 {
 	struct venetdev *priv = netdev_priv(dev);
+
+	return venetdev_open(priv);
+}
+
+int
+venetdev_stop(struct venetdev *priv)
+{
 	unsigned long flags;
 	int needs_stop = false;
 
@@ -296,6 +302,14 @@ venetdev_netdev_stop(struct net_device *dev)
 	return 0;
 }
 
+int
+venetdev_netdev_stop(struct net_device *dev)
+{
+	struct venetdev *priv = netdev_priv(dev);
+
+	return venetdev_stop(priv);
+}
+
 /*
  * Configuration changes (passed on by ifconfig)
  */
@@ -1541,10 +1555,10 @@ venetdev_apply_backpressure(struct venetdev *priv)
  * the netif flow control is still managed by the actual consumer,
  * thereby avoiding the creation of an extra servo-loop to the equation.
  */
+
 int
-venetdev_netdev_tx(struct sk_buff *skb, struct net_device *dev)
+venetdev_xmit(struct sk_buff *skb, struct venetdev *priv)
 {
-	struct venetdev *priv = netdev_priv(dev);
 	struct ioq      *ioq = NULL;
 	unsigned long    flags;
 
@@ -1585,6 +1599,15 @@ flowcontrol:
 	return NETDEV_TX_BUSY;
 }
 
+int
+venetdev_netdev_tx(struct sk_buff *skb, struct net_device *dev)
+{
+	struct venetdev *priv = netdev_priv(dev);
+
+	return venetdev_xmit(skb, priv);
+}
+
+
 /*
  * Ioctl commands
  */
@@ -1599,10 +1622,16 @@ venetdev_netdev_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
  * Return statistics to the caller
  */
 struct net_device_stats *
+venetdev_get_stats(struct venetdev *priv)
+{
+	return &priv->netif.stats;
+}
+
+struct net_device_stats *
 venetdev_netdev_stats(struct net_device *dev)
 {
 	struct venetdev *priv = netdev_priv(dev);
-	return &priv->netif.stats;
+	return venetdev_get_stats(priv);
 }
 
 /*
diff --git a/kernel/vbus/devices/venet/venetdevice.h b/kernel/vbus/devices/venet/venetdevice.h
index 9a60a2e..71c9f0f 100644
--- a/kernel/vbus/devices/venet/venetdevice.h
+++ b/kernel/vbus/devices/venet/venetdevice.h
@@ -142,6 +142,11 @@ int venetdev_netdev_ioctl(struct net_device *dev, struct ifreq *rq,
 						   int cmd);
 struct net_device_stats *venetdev_netdev_stats(struct net_device *dev);
 
+int venetdev_open(struct venetdev *dev);
+int venetdev_stop(struct venetdev *dev);
+int venetdev_xmit(struct sk_buff *skb, struct venetdev *dev);
+struct net_device_stats *venetdev_get_stats(struct venetdev *dev);
+
 static inline void venetdev_netdev_unregister(struct venetdev *priv)
 {
 	if (priv->netif.enabled) {

