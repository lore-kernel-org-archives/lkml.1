Return-Path: <linux-kernel-owner+w=401wt.eu-S1758415AbZC2P2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415AbZC2P2c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 11:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758037AbZC2P2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 11:28:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:49792 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757880AbZC2P2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 11:28:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=KFaUzVwfX+JcZt3fchyuB5/v+8lCZ3BxD/ytC9IMc1gMSeDq9bnAW1Z27Di3fVOe4i
         NJgtCuWZZEn+kCw3oPu2gazyOnx4aor7IO7PEytWHe70iEJLyBCGw0RU6lVZpnSJ7QrL
         b19fEkntwQ+FL/LT5g5wD78RJ0CzbG4jD57BE=
Date: Sun, 29 Mar 2009 19:28:11 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 6/10] Staging: rt2870: convert to netdev_ops
Message-ID: <20090329152811.GF11056@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/staging/rt2870/rt_main_dev.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/rt2870/rt_main_dev.c b/drivers/staging/rt2870/rt_main_dev.c
index 313ecea..48ad411 100644
--- a/drivers/staging/rt2870/rt_main_dev.c
+++ b/drivers/staging/rt2870/rt_main_dev.c
@@ -855,6 +855,20 @@ err:
 	return (-1);
 } /* End of rt28xx_open */
 
+static const struct net_device_ops rt2870_netdev_ops = {
+	.ndo_open		= MainVirtualIF_open,
+	.ndo_stop		= MainVirtualIF_close,
+	.ndo_do_ioctl		= rt28xx_ioctl,
+	.ndo_get_stats		= RT28xx_get_ether_stats,
+	.ndo_validate_addr	= NULL,
+	.ndo_set_mac_address	= eth_mac_addr,
+	.ndo_change_mtu		= eth_change_mtu,
+#ifdef IKANOS_VX_1X0
+	.ndo_start_xmit		= IKANOS_DataFramesTx,
+#else
+	.ndo_start_xmit		= rt28xx_send_packets,
+#endif
+};
 
 /* Must not be called for mdev and apdev */
 static NDIS_STATUS rt_ieee80211_if_setup(struct net_device *dev, PRTMP_ADAPTER pAd)
@@ -866,12 +880,6 @@ static NDIS_STATUS rt_ieee80211_if_setup(struct net_device *dev, PRTMP_ADAPTER p
 
 
 	//ether_setup(dev);
-	dev->hard_start_xmit = rt28xx_send_packets;
-
-#ifdef IKANOS_VX_1X0
-	dev->hard_start_xmit = IKANOS_DataFramesTx;
-#endif // IKANOS_VX_1X0 //
-
 //	dev->set_multicast_list = ieee80211_set_multicast_list;
 //	dev->change_mtu = ieee80211_change_mtu;
 #ifdef CONFIG_STA_SUPPORT
@@ -895,16 +903,10 @@ static NDIS_STATUS rt_ieee80211_if_setup(struct net_device *dev, PRTMP_ADAPTER p
 #if WIRELESS_EXT < 21
 		dev->get_wireless_stats = rt28xx_get_wireless_stats;
 #endif
-	dev->get_stats = RT28xx_get_ether_stats;
-	dev->open = MainVirtualIF_open; //rt28xx_open;
-	dev->stop = MainVirtualIF_close; //rt28xx_close;
 //	dev->uninit = ieee80211_if_reinit;
 //	dev->destructor = ieee80211_if_free;
 	dev->priv_flags = INT_MAIN;
-	dev->do_ioctl = rt28xx_ioctl;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24)
-    dev->validate_addr = NULL;
-#endif
+	dev->netdev_ops = &rt2870_netdev_ops;
 	// find available device name
 	for (i = 0; i < 8; i++)
 	{
