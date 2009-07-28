Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbZG1Xwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbZG1Xwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932159AbZG1Xwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:52:40 -0400
Received: from kroah.org ([198.145.64.141]:35977 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754987AbZG1Xud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:33 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:42:01 2009
Message-Id: <20090728234201.598624669@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ben Hutchings <ben@decadent.org.uk>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 65/71] netdev: restore MAC address set and validate operations
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=netdev-restore-mac-address-set-and-validate-operations.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 240c102d9c54fee7fdc87a4ef2fabc7eb539e00a upstream.

alloc_etherdev() used to install default implementations of these
operations, but they must now be explicitly installed in struct
net_device_ops.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/arm/ixp4xx_eth.c        |    3 ++-
 drivers/net/ehea/ehea_main.c        |    1 +
 drivers/net/gianfar.c               |    2 ++
 drivers/net/plip.c                  |    2 ++
 drivers/net/ps3_gelic_net.c         |    1 +
 drivers/net/ps3_gelic_wireless.c    |    1 +
 drivers/net/sunvnet.c               |    1 +
 drivers/net/usb/kaweth.c            |    2 ++
 drivers/net/usb/pegasus.c           |    2 ++
 drivers/net/wireless/orinoco/main.c |    3 ++-
 10 files changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/net/arm/ixp4xx_eth.c
+++ b/drivers/net/arm/ixp4xx_eth.c
@@ -1140,7 +1140,8 @@ static const struct net_device_ops ixp4x
 	.ndo_start_xmit = eth_xmit,
 	.ndo_set_multicast_list = eth_set_mcast_list,
 	.ndo_do_ioctl = eth_ioctl,
-
+	.ndo_set_mac_address = eth_mac_addr,
+	.ndo_validate_addr = eth_validate_addr,
 };
 
 static int __devinit eth_init_one(struct platform_device *pdev)
--- a/drivers/net/ehea/ehea_main.c
+++ b/drivers/net/ehea/ehea_main.c
@@ -3081,6 +3081,7 @@ static const struct net_device_ops ehea_
 #endif
 	.ndo_get_stats		= ehea_get_stats,
 	.ndo_set_mac_address	= ehea_set_mac_addr,
+	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_multicast_list	= ehea_set_multicast_list,
 	.ndo_change_mtu		= ehea_change_mtu,
 	.ndo_vlan_rx_register	= ehea_vlan_rx_register,
--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -155,6 +155,8 @@ static const struct net_device_ops gfar_
 	.ndo_tx_timeout = gfar_timeout,
 	.ndo_do_ioctl = gfar_ioctl,
 	.ndo_vlan_rx_register = gfar_vlan_rx_register,
+	.ndo_set_mac_address = eth_mac_addr,
+	.ndo_validate_addr = eth_validate_addr,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller = gfar_netpoll,
 #endif
--- a/drivers/net/plip.c
+++ b/drivers/net/plip.c
@@ -270,6 +270,8 @@ static const struct net_device_ops plip_
 	.ndo_stop		 = plip_close,
 	.ndo_start_xmit		 = plip_tx_packet,
 	.ndo_do_ioctl		 = plip_ioctl,
+	.ndo_set_mac_address	 = eth_mac_addr,
+	.ndo_validate_addr	 = eth_validate_addr,
 };
 
 /* Entry point of PLIP driver.
--- a/drivers/net/ps3_gelic_net.c
+++ b/drivers/net/ps3_gelic_net.c
@@ -1410,6 +1410,7 @@ static const struct net_device_ops gelic
 	.ndo_set_multicast_list = gelic_net_set_multi,
 	.ndo_change_mtu = gelic_net_change_mtu,
 	.ndo_tx_timeout = gelic_net_tx_timeout,
+	.ndo_set_mac_address = eth_mac_addr,
 	.ndo_validate_addr = eth_validate_addr,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller = gelic_net_poll_controller,
--- a/drivers/net/ps3_gelic_wireless.c
+++ b/drivers/net/ps3_gelic_wireless.c
@@ -2707,6 +2707,7 @@ static const struct net_device_ops gelic
 	.ndo_set_multicast_list = gelic_net_set_multi,
 	.ndo_change_mtu = gelic_net_change_mtu,
 	.ndo_tx_timeout = gelic_net_tx_timeout,
+	.ndo_set_mac_address = eth_mac_addr,
 	.ndo_validate_addr = eth_validate_addr,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller = gelic_net_poll_controller,
--- a/drivers/net/sunvnet.c
+++ b/drivers/net/sunvnet.c
@@ -1017,6 +1017,7 @@ static const struct net_device_ops vnet_
 	.ndo_stop		= vnet_close,
 	.ndo_set_multicast_list	= vnet_set_rx_mode,
 	.ndo_set_mac_address	= vnet_set_mac_addr,
+	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_tx_timeout		= vnet_tx_timeout,
 	.ndo_change_mtu		= vnet_change_mtu,
 	.ndo_start_xmit		= vnet_start_xmit,
--- a/drivers/net/usb/kaweth.c
+++ b/drivers/net/usb/kaweth.c
@@ -982,6 +982,8 @@ static const struct net_device_ops kawet
 	.ndo_tx_timeout =		kaweth_tx_timeout,
 	.ndo_set_multicast_list =	kaweth_set_rx_mode,
 	.ndo_get_stats =		kaweth_netdev_stats,
+	.ndo_set_mac_address =		eth_mac_addr,
+	.ndo_validate_addr =		eth_validate_addr,
 };
 
 static int kaweth_probe(
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -1493,6 +1493,8 @@ static const struct net_device_ops pegas
 	.ndo_set_multicast_list =	pegasus_set_multicast,
 	.ndo_get_stats =		pegasus_netdev_stats,
 	.ndo_tx_timeout =		pegasus_tx_timeout,
+	.ndo_set_mac_address =		eth_mac_addr,
+	.ndo_validate_addr =		eth_validate_addr,
 };
 
 static struct usb_driver pegasus_driver = {
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -2521,6 +2521,8 @@ static const struct net_device_ops orino
 	.ndo_start_xmit		= orinoco_xmit,
 	.ndo_set_multicast_list	= orinoco_set_multicast_list,
 	.ndo_change_mtu		= orinoco_change_mtu,
+	.ndo_set_mac_address	= eth_mac_addr,
+	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_tx_timeout		= orinoco_tx_timeout,
 	.ndo_get_stats		= orinoco_get_stats,
 };
@@ -2555,7 +2557,6 @@ struct net_device
 	priv->wireless_data.spy_data = &priv->spy_data;
 	dev->wireless_data = &priv->wireless_data;
 #endif
-	/* we use the default eth_mac_addr for setting the MAC addr */
 
 	/* Reserve space in skb for the SNAP header */
 	dev->hard_header_len += ENCAPS_OVERHEAD;


