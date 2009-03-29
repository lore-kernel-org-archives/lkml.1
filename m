Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbZC2P1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbZC2P1l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 11:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757645AbZC2P12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 11:27:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:8993 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbZC2P11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 11:27:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=hPca6XPVMD2REjMIF3ak0IlzimAbA1Z/5WdViZvVddMHmqTZpR18U7kHrs37QiMeYY
         yQJboN/RmOdD1d8RcKQYnd1wsnYhQnHs/PHKyMlWPmjRcMPlgReNwTQunCsWJNyaLzSm
         yRU09aHA7oExiRURDdpU/RVB9iCZpINgdxg/k=
Date: Sun, 29 Mar 2009 19:27:21 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 5/10] Staging: rt2860: convert to netdev_ops
Message-ID: <20090329152721.GE11056@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/staging/rt2860/rt_main_dev.c |   25 +++++++++++++++----------
 1 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rt2860/rt_main_dev.c b/drivers/staging/rt2860/rt_main_dev.c
index cf17bcd..6c4396f 100644
--- a/drivers/staging/rt2860/rt_main_dev.c
+++ b/drivers/staging/rt2860/rt_main_dev.c
@@ -722,6 +722,20 @@ err:
 	return (-1);
 } /* End of rt28xx_open */
 
+static const struct net_device_ops rt2860_netdev_ops = {
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
@@ -733,11 +747,6 @@ static NDIS_STATUS rt_ieee80211_if_setup(struct net_device *dev, PRTMP_ADAPTER p
 
 
 	//ether_setup(dev);
-	dev->hard_start_xmit = rt28xx_send_packets;
-
-#ifdef IKANOS_VX_1X0
-	dev->hard_start_xmit = IKANOS_DataFramesTx;
-#endif // IKANOS_VX_1X0 //
 
 #ifdef CONFIG_STA_SUPPORT
 #if WIRELESS_EXT >= 12
@@ -760,12 +769,8 @@ static NDIS_STATUS rt_ieee80211_if_setup(struct net_device *dev, PRTMP_ADAPTER p
 #if WIRELESS_EXT < 21
 		dev->get_wireless_stats = rt28xx_get_wireless_stats;
 #endif
-	dev->get_stats = RT28xx_get_ether_stats;
-	dev->open = MainVirtualIF_open; //rt28xx_open;
-	dev->stop = MainVirtualIF_close; //rt28xx_close;
 	dev->priv_flags = INT_MAIN;
-	dev->do_ioctl = rt28xx_ioctl;
-	dev->validate_addr = NULL;
+	dev->netdev_ops = &rt2860_netdev_ops;
 	// find available device name
 	for (i = 0; i < 8; i++)
 	{
