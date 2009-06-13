Return-Path: <linux-kernel-owner+w=401wt.eu-S1763996AbZFMQeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763996AbZFMQeU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 12:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762883AbZFMQdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 12:33:33 -0400
Received: from mail-fx0-f206.google.com ([209.85.220.206]:65246 "EHLO
	mail-fx0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761287AbZFMQdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 12:33:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=C140yimKxS6lKKW1W3Hd29IexQWea3CFr6p+2juR+kK2Nf+BmXI1rakuiS9H35BLW5
         3lB1Kc+eYk+mqDIUErrfzJzoldTck/PVyKTpAZrE7Jd5AjZJwB5p1SZyLJvPMSiYTg2v
         eE/gQr066+3QZ+ouPdFPfgwjmoJpp4950mNIk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Greg KH <gregkh@suse.de>
Subject: [PATCH 2/6] Staging: rtl8187se: remove support for older wireless extensions
Date: Sat, 13 Jun 2009 18:31:18 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090612-07181-g84f26e4; KDE/4.2.3; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906131831.18488.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8187se/ieee80211/ieee80211.h            |    9 ----
 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c |   26 -------------
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c         |    5 --
 drivers/staging/rtl8187se/r8180_core.c                     |   16 --------
 drivers/staging/rtl8187se/r8180_wx.c                       |    5 --
 5 files changed, 1 insertion(+), 60 deletions(-)

Index: b/drivers/staging/rtl8187se/ieee80211/ieee80211.h
===================================================================
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211.h
@@ -188,15 +188,6 @@ typedef struct ieee_param {
 }ieee_param;
 
 
-#if WIRELESS_EXT < 17
-#define IW_QUAL_QUAL_INVALID   0x10
-#define IW_QUAL_LEVEL_INVALID  0x20
-#define IW_QUAL_NOISE_INVALID  0x40
-#define IW_QUAL_QUAL_UPDATED   0x1
-#define IW_QUAL_LEVEL_UPDATED  0x2
-#define IW_QUAL_NOISE_UPDATED  0x4
-#endif
-
 #define MSECS(t) msecs_to_jiffies(t)
 #define msleep_interruptible_rtl  msleep_interruptible
 
Index: b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
===================================================================
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
@@ -605,8 +605,6 @@ static int ieee80211_michael_mic_add(str
 	return 0;
 }
 
-
-#if WIRELESS_EXT >= 18
 static void ieee80211_michael_mic_failure(struct net_device *dev,
 				       struct ieee80211_hdr *hdr,
 				       int keyidx)
@@ -627,30 +625,6 @@ static void ieee80211_michael_mic_failur
 	wrqu.data.length = sizeof(ev);
 	wireless_send_event(dev, IWEVMICHAELMICFAILURE, &wrqu, (char *) &ev);
 }
-#elif WIRELESS_EXT >= 15
-static void ieee80211_michael_mic_failure(struct net_device *dev,
-				       struct ieee80211_hdr *hdr,
-				       int keyidx)
-{
-	union iwreq_data wrqu;
-	char buf[128];
-
-	/* TODO: needed parameters: count, keyid, key type, TSC */
-	sprintf(buf, "MLME-MICHAELMICFAILURE.indication(keyid=%d %scast addr="
-		MAC_FMT ")", keyidx, hdr->addr1[0] & 0x01 ? "broad" : "uni",
-		MAC_ARG(hdr->addr2));
-	memset(&wrqu, 0, sizeof(wrqu));
-	wrqu.data.length = strlen(buf);
-	wireless_send_event(dev, IWEVCUSTOM, &wrqu, buf);
-}
-#else /* WIRELESS_EXT >= 15 */
-static inline void ieee80211_michael_mic_failure(struct net_device *dev,
-					      struct ieee80211_hdr *hdr,
-					      int keyidx)
-{
-}
-#endif /* WIRELESS_EXT >= 15 */
-
 
 static int ieee80211_michael_mic_verify(struct sk_buff *skb, int keyidx,
 				     int hdr_len, void *priv)
Index: b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
===================================================================
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
@@ -640,7 +640,6 @@ int ieee80211_rx(struct ieee80211_device
 	hdrlen = ieee80211_get_hdrlen(fc);
 
 #ifdef NOT_YET
-#if WIRELESS_EXT > 15
 	/* Put this code here so that we avoid duplicating it in all
 	 * Rx paths. - Jean II */
 #ifdef IW_WIRELESS_SPY		/* defined in iw_handler.h */
@@ -654,18 +653,16 @@ int ieee80211_rx(struct ieee80211_device
 		wireless_spy_update(dev, hdr->addr2, &wstats);
 	}
 #endif /* IW_WIRELESS_SPY */
-#endif /* WIRELESS_EXT > 15 */
 	hostap_update_rx_stats(local->ap, hdr, rx_stats);
 #endif
 
-#if WIRELESS_EXT > 15
 	if (ieee->iw_mode == IW_MODE_MONITOR) {
 		ieee80211_monitor_rx(ieee, skb, rx_stats);
 		stats->rx_packets++;
 		stats->rx_bytes += skb->len;
 		return 1;
 	}
-#endif
+
 	if (ieee->host_decrypt) {
 		int idx = 0;
 		if (skb->len >= hdrlen + 3)
Index: b/drivers/staging/rtl8187se/r8180_core.c
===================================================================
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -584,15 +584,6 @@ static int proc_get_stats_tx(char *page,
 	return len;
 }
 
-
-#if WIRELESS_EXT < 17
-static struct iw_statistics *r8180_get_wireless_stats(struct net_device *dev)
-{
-       struct r8180_priv *priv = ieee80211_priv(dev);
-
-       return &priv->wstats;
-}
-#endif
 void rtl8180_proc_module_init(void)
 {
 	DMESG("Initializing proc filesystem");
@@ -5857,13 +5848,6 @@ static int __devinit rtl8180_pci_probe(s
 	dev->netdev_ops = &rtl8180_netdev_ops;
 	dev->wireless_handlers = &r8180_wx_handlers_def;
 
-#if WIRELESS_EXT >= 12
-#if WIRELESS_EXT < 17
-	dev->get_wireless_stats = r8180_get_wireless_stats;
-#endif
-	dev->wireless_handlers = (struct iw_handler_def *) &r8180_wx_handlers_def;
-#endif
-
 	dev->type=ARPHRD_ETHER;
 	dev->watchdog_timeo = HZ*3; //added by david woo, 2007.12.13
 
Index: b/drivers/staging/rtl8187se/r8180_wx.c
===================================================================
--- a/drivers/staging/rtl8187se/r8180_wx.c
+++ b/drivers/staging/rtl8187se/r8180_wx.c
@@ -1543,7 +1543,6 @@ static iw_handler r8180_private_handler[
 	r8180_wx_set_forcerate,
 };
 
-#if WIRELESS_EXT >= 17
 static inline int is_same_network(struct ieee80211_network *src,
                                   struct ieee80211_network *dst,
 				  struct ieee80211_device *ieee)
@@ -1626,8 +1625,6 @@ static struct iw_statistics *r8180_get_w
 	wstats->qual.updated = IW_QUAL_ALL_UPDATED| IW_QUAL_DBM;
 	return wstats;
 }
-#endif
-
 
 struct iw_handler_def  r8180_wx_handlers_def={
 	.standard = r8180_wx_handlers,
@@ -1635,9 +1632,7 @@ struct iw_handler_def  r8180_wx_handlers
 	.private = r8180_private_handler,
 	.num_private = sizeof(r8180_private_handler) / sizeof(iw_handler),
  	.num_private_args = sizeof(r8180_private_args) / sizeof(struct iw_priv_args),
-#if WIRELESS_EXT >= 17
 	.get_wireless_stats = r8180_get_wireless_stats,
-#endif
 	.private_args = (struct iw_priv_args *)r8180_private_args,
 };
 
