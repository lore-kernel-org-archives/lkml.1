Return-Path: <linux-kernel-owner+w=401wt.eu-S1758241AbZC2P0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241AbZC2P0r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 11:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757783AbZC2P0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 11:26:33 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:46969 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199AbZC2P0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 11:26:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=eslZTRl6jtKc8M3u4HH66LKHVLX3DR2ih4eioeAdq7J6xi+qAQRxUor7DRjW3+aswW
         oPX7zld143Q0fTP8Td+3D/jsYjik3zOiZ2hys0UY/lak3NQwFVJakc/zfzvJGazmEqX/
         AxaGfQMW6ibYconWUdw/A53r2SZS2wYNYqSDs=
Date: Sun, 29 Mar 2009 19:26:25 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 4/10] Staging: otus: convert to netdev_ops
Message-ID: <20090329152625.GD11056@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/staging/otus/usbdrv.c |   47 +++++++++++++++++++++++++---------------
 1 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/otus/usbdrv.c b/drivers/staging/otus/usbdrv.c
index 565a839..540cbbb 100644
--- a/drivers/staging/otus/usbdrv.c
+++ b/drivers/staging/otus/usbdrv.c
@@ -822,6 +822,21 @@ int zfLnxVapXmitFrame(struct sk_buff *skb, struct net_device *dev)
     return 0;
 }
 
+static const struct net_device_ops vap_netdev_ops = {
+	.ndo_open		= zfLnxVapOpen,
+	.ndo_stop		= zfLnxVapClose,
+	.ndo_start_xmit		= zfLnxVapXmitFrame,
+	.ndo_get_stats		= usbdrv_get_stats,
+	.ndo_change_mtu		= usbdrv_change_mtu,
+	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_set_mac_address	= eth_mac_addr,
+#ifdef ZM_HOSTAPD_SUPPORT
+	.ndo_do_ioctl		= usbdrv_ioctl,
+#else
+	.ndo_do_ioctl		= NULL,
+#endif
+};
+
 int zfLnxRegisterVapDev(struct net_device* parentDev, u16_t vapId)
 {
     /* Allocate net device structure */
@@ -846,16 +861,7 @@ int zfLnxRegisterVapDev(struct net_device* parentDev, u16_t vapId)
     vap[vapId].dev->ml_priv = parentDev->ml_priv;
 
     //dev->hard_start_xmit = &zd1212_wds_xmit_frame;
-    vap[vapId].dev->hard_start_xmit = &zfLnxVapXmitFrame;
-    vap[vapId].dev->open = &zfLnxVapOpen;
-    vap[vapId].dev->stop = &zfLnxVapClose;
-    vap[vapId].dev->get_stats = &usbdrv_get_stats;
-    vap[vapId].dev->change_mtu = &usbdrv_change_mtu;
-#ifdef ZM_HOSTAPD_SUPPORT
-    vap[vapId].dev->do_ioctl = usbdrv_ioctl;
-#else
-    vap[vapId].dev->do_ioctl = NULL;
-#endif
+    vap[vapId].dev->netdev_ops = &vap_netdev_ops;
     vap[vapId].dev->destructor = free_netdev;
 
     vap[vapId].dev->tx_queue_len = 0;
@@ -1068,6 +1074,18 @@ void zfLnxUnlinkAllUrbs(struct usbdrv_private *macp)
     usb_unlink_urb(macp->RegInUrb);
 }
 
+static const struct net_device_ops otus_netdev_ops = {
+	.ndo_open		= usbdrv_open,
+	.ndo_stop		= usbdrv_close,
+	.ndo_start_xmit		= usbdrv_xmit_frame,
+	.ndo_change_mtu		= usbdrv_change_mtu,
+	.ndo_get_stats		= usbdrv_get_stats,
+	.ndo_set_multicast_list	= usbdrv_set_multi,
+	.ndo_set_mac_address	= usbdrv_set_mac,
+	.ndo_do_ioctl		= usbdrv_ioctl,
+	.ndo_validate_addr	= eth_validate_addr,
+};
+
 u8_t zfLnxInitSetup(struct net_device *dev, struct usbdrv_private *macp)
 {
     //unsigned char addr[6];
@@ -1092,14 +1110,7 @@ u8_t zfLnxInitSetup(struct net_device *dev, struct usbdrv_private *macp)
     dev->wireless_handlers = (struct iw_handler_def *)&p80211wext_handler_def;
 #endif
 
-    dev->open = usbdrv_open;
-    dev->hard_start_xmit = usbdrv_xmit_frame;
-    dev->stop = usbdrv_close;
-    dev->change_mtu = &usbdrv_change_mtu;
-    dev->get_stats = usbdrv_get_stats;
-    dev->set_multicast_list = usbdrv_set_multi;
-    dev->set_mac_address = usbdrv_set_mac;
-    dev->do_ioctl = usbdrv_ioctl;
+    dev->netdev_ops = &otus_netdev_ops;
 
     dev->flags |= IFF_MULTICAST;
 
