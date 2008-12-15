Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbYLOXHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbYLOXHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 18:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbYLOXHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 18:07:03 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42674
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751456AbYLOXHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 18:07:01 -0500
Date: Mon, 15 Dec 2008 15:07:02 -0800 (PST)
Message-Id: <20081215.150702.187335926.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       shemminger@vyatta.com, alan@lxorguk.ukuu.org.uk
Subject: Re: linux-next: Tree for December 12 (netdev ops)
From: David Miller <davem@davemloft.net>
In-Reply-To: <494498ED.7080903@oracle.com>
References: <20081212185654.0af8b4a1.sfr@canb.auug.org.au>
	<494498ED.7080903@oracle.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Sat, 13 Dec 2008 21:26:05 -0800

> If hplan is built-in, this build error can happen:
> 
> build-r7084.out:8390p.c:(.text+0xfd9aa): undefined reference to `ei_start_xmit'
> build-r7084.out:8390p.c:(.text+0xfd9b6): undefined reference to `ei_get_stats'
> build-r7084.out:8390p.c:(.text+0xfd9c6): undefined reference to `ei_set_multicast_list'
> 
> since hplan uses 8390p.c, which uses lib8390.c, but the latter always uses:
> 
> #ifdef CONFIG_COMPAT_NET_DEV_OPS
> 	dev->hard_start_xmit = ei_start_xmit;
> 	dev->get_stats	= ei_get_stats;
> 	dev->set_multicast_list = ei_set_multicast_list;
> 	dev->tx_timeout = __ei_tx_timeout;
> #endif
> 
> However, those ei_* functions should be eip_* in this case.
> How to do that??

Thanks for your report Randy, I'll try to fix this.

These assignments need to be pushed into the 8390.c and
8390p.c code.

The fix will look something like the following.  I'll
do some sanity builds and commit this to net-next-2.6

diff --git a/drivers/net/8390.c b/drivers/net/8390.c
index 029ad08..fbe609a 100644
--- a/drivers/net/8390.c
+++ b/drivers/net/8390.c
@@ -72,7 +72,16 @@ EXPORT_SYMBOL(ei_netdev_ops);
 
 struct net_device *__alloc_ei_netdev(int size)
 {
-	return ____alloc_ei_netdev(size);
+	struct net_device *dev = ____alloc_ei_netdev(size);
+#ifdef CONFIG_COMPAT_NET_DEV_OPS
+	if (dev) {
+		dev->hard_start_xmit = ei_start_xmit;
+		dev->get_stats	= ei_get_stats;
+		dev->set_multicast_list = ei_set_multicast_list;
+		dev->tx_timeout = ei_tx_timeout;
+	}
+#endif
+	return dev;
 }
 EXPORT_SYMBOL(__alloc_ei_netdev);
 
diff --git a/drivers/net/8390p.c b/drivers/net/8390p.c
index 9c916d4..ee70b35 100644
--- a/drivers/net/8390p.c
+++ b/drivers/net/8390p.c
@@ -77,7 +77,16 @@ EXPORT_SYMBOL(eip_netdev_ops);
 
 struct net_device *__alloc_eip_netdev(int size)
 {
-	return ____alloc_ei_netdev(size);
+	struct net_device *dev = ____alloc_ei_netdev(size);
+#ifdef CONFIG_COMPAT_NET_DEV_OPS
+	if (dev) {
+		dev->hard_start_xmit = eip_start_xmit;
+		dev->get_stats	= eip_get_stats;
+		dev->set_multicast_list = eip_set_multicast_list;
+		dev->tx_timeout = eip_tx_timeout;
+	}
+#endif
+	return dev;
 }
 EXPORT_SYMBOL(__alloc_eip_netdev);
 
diff --git a/drivers/net/lib8390.c b/drivers/net/lib8390.c
index 1d36ca4..789b6cb 100644
--- a/drivers/net/lib8390.c
+++ b/drivers/net/lib8390.c
@@ -1010,12 +1010,6 @@ static void ethdev_setup(struct net_device *dev)
 	if (ei_debug > 1)
 		printk(version);
 
-#ifdef CONFIG_COMPAT_NET_DEV_OPS
-	dev->hard_start_xmit = ei_start_xmit;
-	dev->get_stats	= ei_get_stats;
-	dev->set_multicast_list = ei_set_multicast_list;
-	dev->tx_timeout = __ei_tx_timeout;
-#endif
 	ether_setup(dev);
 
 	spin_lock_init(&ei_local->page_lock);
