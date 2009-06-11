Return-Path: <linux-kernel-owner+w=401wt.eu-S1758328AbZFKSpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328AbZFKSpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756284AbZFKSpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:45:22 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:33450 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbZFKSpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:45:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=S04v8E7TK17UtiNxawc9QRK+hwipDE7QVFQkN4NodKFi5wQa5pmcTfMJ0v6m2yxeI6
         L/WLkmDVknhPV/yCgAqB0XGPs9PeSLnzmnow1DtXOQJH3S1mqqydvVZaNelByIz8wji2
         NKOYBv+BGnidGMwEGLM8Vqq6gEihzOZo5/7C4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Greg KH <gregkh@suse.de>
Subject: [PATCH staging] Staging: rtl8192su: convert to net_device_ops
Date: Thu, 11 Jun 2009 20:49:07 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090611-07944-gc1b019d-dirty; KDE/4.2.3; i686; ; )
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906112049.08607.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit e3804cbebb67887879102925961d41b503f7fbe3 removed
COMPAT_NET_DEV_OPS so this change is needed to make rtl8192su
buildable again.

Loosely based on Alexander's patch for rtl8187se, untested.

Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
against next-20090611

 drivers/staging/rtl8192su/Kconfig                      |    2 -
 drivers/staging/rtl8192su/ieee80211/ieee80211_module.c |    1 
 drivers/staging/rtl8192su/r8192U_core.c                |   23 ++++++++++-------
 drivers/staging/rtl8192su/r8192U_pm.c                  |    8 ++++-
 4 files changed, 21 insertions(+), 13 deletions(-)

Index: b/drivers/staging/rtl8192su/Kconfig
===================================================================
--- a/drivers/staging/rtl8192su/Kconfig
+++ b/drivers/staging/rtl8192su/Kconfig
@@ -1,6 +1,6 @@
 config RTL8192SU
 	tristate "RealTek RTL8192SU Wireless LAN NIC driver"
 	depends on PCI
-	depends on WIRELESS_EXT && COMPAT_NET_DEV_OPS
+	depends on WIRELESS_EXT
 	default N
 	---help---
Index: b/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c
===================================================================
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c
@@ -118,7 +118,6 @@ struct net_device *alloc_ieee80211(int s
 #else
 	ieee = (struct ieee80211_device *)dev->priv;
 #endif
-	dev->hard_start_xmit = ieee80211_xmit;
 
 	memset(ieee, 0, sizeof(struct ieee80211_device)+sizeof_priv);
 	ieee->dev = dev;
Index: b/drivers/staging/rtl8192su/r8192U_core.c
===================================================================
--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -12132,6 +12132,19 @@ static void HalUsbSetQueuePipeMapping819
 }
 #endif
 
+static const struct net_device_ops rtl8192_netdev_ops = {
+	.ndo_open		= rtl8192_open,
+	.ndo_stop		= rtl8192_close,
+	.ndo_get_stats		= rtl8192_stats,
+	.ndo_tx_timeout		= tx_timeout,
+	.ndo_do_ioctl		= rtl8192_ioctl,
+	.ndo_set_multicast_list	= r8192_set_multicast,
+	.ndo_set_mac_address	= r8192_set_mac_adr,
+	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_change_mtu		= eth_change_mtu,
+	.ndo_start_xmit		= ieee80211_xmit,
+};
+
 #if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 static int __devinit rtl8192_usb_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
@@ -12186,15 +12199,7 @@ static void * __devinit rtl8192_usb_prob
 	priv->ops = &rtl8192u_ops;
 #endif
 
-	dev->open = rtl8192_open;
-	dev->stop = rtl8192_close;
-	//dev->hard_start_xmit = rtl8192_8023_hard_start_xmit;
-	dev->tx_timeout = tx_timeout;
-	//dev->wireless_handlers = &r8192_wx_handlers_def;
-	dev->do_ioctl = rtl8192_ioctl;
-	dev->set_multicast_list = r8192_set_multicast;
-	dev->set_mac_address = r8192_set_mac_adr;
-	dev->get_stats = rtl8192_stats;
+	dev->netdev_ops = &rtl8192_netdev_ops;
 
          //DMESG("Oops: i'm coming\n");
 #if WIRELESS_EXT >= 12
Index: b/drivers/staging/rtl8192su/r8192U_pm.c
===================================================================
--- a/drivers/staging/rtl8192su/r8192U_pm.c
+++ b/drivers/staging/rtl8192su/r8192U_pm.c
@@ -35,7 +35,9 @@ int rtl8192U_suspend(struct usb_interfac
 		      return 0;
 		 }
 
-		dev->stop(dev);
+		if (dev->netdev_ops->ndo_stop)
+			dev->netdev_ops->ndo_stop(dev);
+
 		mdelay(10);
 
 		netif_device_detach(dev);
@@ -61,7 +63,9 @@ int rtl8192U_resume (struct usb_interfac
 		}
 
 		netif_device_attach(dev);
-		dev->open(dev);
+
+		if (dev->netdev_ops->ndo_open)
+			dev->netdev_ops->ndo_open(dev);
 	}
 
         return 0;
