Return-Path: <linux-kernel-owner+w=401wt.eu-S1756765AbZGMRzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbZGMRzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 13:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbZGMRzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 13:55:05 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:60894 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851AbZGMRzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 13:55:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=okFjMGvF9MoZKTggc5o6dMZ5e881PIvpusmXBLVW5WONUXl1Xr7fQbDRE+vjL0xLzN
         vPpfaRj2Nb03cppdOS21m+TRox4BvHD+HHCoqcBLjYxwM2Z3aRB7OFBat/m5U2IEeK25
         osc0uzH8VMzGWhtk1N0w5qnLXwBhThMb3UwrU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 13 Jul 2009 20:01:38 +0200
Message-Id: <20090713180138.15985.3351.sendpatchset@localhost.localdomain>
In-Reply-To: <20090713180112.15985.88819.sendpatchset@localhost.localdomain>
References: <20090713180112.15985.88819.sendpatchset@localhost.localdomain>
Subject: [PATCH 04/10] Staging: rtl8187se: remove ENABLE_IPS ifdefs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rtl8187se: remove ENABLE_IPS ifdefs

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8187se/Makefile                      |    2 
 drivers/staging/rtl8187se/TODO                          |    1 
 drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c |   38 ----------------
 drivers/staging/rtl8187se/r8180_core.c                  |    4 -
 drivers/staging/rtl8187se/r8180_wx.c                    |    6 --
 drivers/staging/rtl8187se/r8185b_init.c                 |    2 
 6 files changed, 53 deletions(-)

Index: b/drivers/staging/rtl8187se/Makefile
===================================================================
--- a/drivers/staging/rtl8187se/Makefile
+++ b/drivers/staging/rtl8187se/Makefile
@@ -4,8 +4,6 @@
 #EXTRA_CFLAGS += -O2
 #CC            = gcc
 
-#added for EeePC testing
-EXTRA_CFLAGS += -DENABLE_IPS
 EXTRA_CFLAGS += -DSW_ANTE
 EXTRA_CFLAGS += -DTX_TRACK
 EXTRA_CFLAGS += -DHIGH_POWER
Index: b/drivers/staging/rtl8187se/TODO
===================================================================
--- a/drivers/staging/rtl8187se/TODO
+++ b/drivers/staging/rtl8187se/TODO
@@ -1,6 +1,5 @@
 TODO:
 - prepare private ieee80211 stack for merge with rtl8192su's version:
-  - remove ENABLE_IPS ifdefs
   - rename struct ieee80211_hdr to struct ieee80211_hdr_4addr
   - rename struct ieee80211_hdr_3addr_QOS to struct ieee80211_hdr_3addrqos
   - rename struct ieee80211_hdr_QOS to struct ieee80211_hdr_4addrqos
Index: b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
===================================================================
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
@@ -574,7 +574,6 @@ out:
 		DOT11D_ScanComplete(ieee);
 }
 
-#ifdef ENABLE_IPS
 void ieee80211_softmac_scan_wq(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
@@ -617,43 +616,6 @@ out:
 		DOT11D_ScanComplete(ieee);
 	return;
 }
-#else
-void ieee80211_softmac_scan_wq(struct work_struct *work)
-{
-	struct delayed_work *dwork = to_delayed_work(work);
-        struct ieee80211_device *ieee = container_of(work, struct ieee80211_device, softmac_scan_wq);
-        short watchdog = 0;
-	u8 channel_map[MAX_CHANNEL_NUMBER+1];
-	memcpy(channel_map, GET_DOT11D_INFO(ieee)->channel_map, MAX_CHANNEL_NUMBER+1);
-//      printk("enter scan wq,watchdog is %d\n",watchdog);
-        down(&ieee->scan_sem);
-
-        do{
-                ieee->current_network.channel =
-                        (ieee->current_network.channel + 1) % MAX_CHANNEL_NUMBER;
-                if (watchdog++ > MAX_CHANNEL_NUMBER)
-                                goto out; /* no good chans */
-
-        }while(!channel_map[ieee->current_network.channel]);
-
-//      printk("current_network.channel:%d\n", ieee->current_network.channel);
-        if (ieee->scanning == 0 )
-        {
-                printk("error out, scanning = 0\n");
-                goto out;
-        }
-        ieee->set_chan(ieee->dev, ieee->current_network.channel);
-	if(channel_map[ieee->current_network.channel] == 1)
-		ieee80211_send_probe_requests(ieee);
-
-	queue_delayed_work(ieee->wq, &ieee->softmac_scan_wq, IEEE80211_SOFTMAC_SCAN_TIME);
-out:
-	up(&ieee->scan_sem);
-	if(IS_DOT11D_ENABLE(ieee))
-		DOT11D_ScanComplete(ieee);
-}
-
-#endif
 
 void ieee80211_beacons_start(struct ieee80211_device *ieee)
 {
Index: b/drivers/staging/rtl8187se/r8180_core.c
===================================================================
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -3598,13 +3598,11 @@ void rtl8180_watch_dog(struct net_device
 	u32 TotalRxNum = 0;
 	u16 SlotIndex = 0;
 	u16 i = 0;
-#ifdef ENABLE_IPS
 	if(priv->ieee80211->actscanning == false){
 		if((priv->ieee80211->iw_mode != IW_MODE_ADHOC) && (priv->ieee80211->state == IEEE80211_NOLINK) && (priv->ieee80211->beinretry == false) && (priv->eRFPowerState == eRfOn)){
 			IPSEnter(dev);
 		}
 	}
-#endif
 	//YJ,add,080828,for link state check
 	if((priv->ieee80211->state == IEEE80211_LINKED) && (priv->ieee80211->iw_mode == IW_MODE_INFRA)){
 		SlotIndex = (priv->link_detect.SlotIndex++) % priv->link_detect.SlotNum;
@@ -3667,12 +3665,10 @@ int _rtl8180_up(struct net_device *dev)
 	rtl8185b_adapter_start(dev);
 	rtl8185b_rx_enable(dev);
 	rtl8185b_tx_enable(dev);
-#ifdef ENABLE_IPS
 	if(priv->bInactivePs){
 		if(priv->ieee80211->iw_mode == IW_MODE_ADHOC)
 			IPSLeave(dev);
 	}
-#endif
 #ifdef RATE_ADAPT
        timer_rate_adaptive((unsigned long)dev);
 #endif
Index: b/drivers/staging/rtl8187se/r8180_wx.c
===================================================================
--- a/drivers/staging/rtl8187se/r8180_wx.c
+++ b/drivers/staging/rtl8187se/r8180_wx.c
@@ -194,13 +194,11 @@ static int r8180_wx_set_mode(struct net_
 		return 0;
 
 	down(&priv->wx_sem);
-#ifdef ENABLE_IPS
 //	printk("set mode ENABLE_IPS\n");
 	if(priv->bInactivePs){
 		if(wrqu->mode == IW_MODE_ADHOC)
 			IPSLeave(dev);
 	}
-#endif
 	ret = ieee80211_wx_set_mode(priv->ieee80211,a,wrqu,b);
 
 	//rtl8180_commit(dev);
@@ -363,7 +361,6 @@ static int r8180_wx_set_scan(struct net_
 
 	down(&priv->wx_sem);
 	if(priv->up){
-#ifdef ENABLE_IPS
 //		printk("set scan ENABLE_IPS\n");
 		priv->ieee80211->actscanning = true;
 		if(priv->bInactivePs && (priv->ieee80211->state != IEEE80211_LINKED)){
@@ -386,7 +383,6 @@ static int r8180_wx_set_scan(struct net_
 			ret = 0;
 		}
 		else
-#endif
 		{
 			//YJ,add,080828, prevent scan in BusyTraffic
 			//FIXME: Need to consider last scan time
@@ -439,11 +435,9 @@ static int r8180_wx_set_essid(struct net
 		return 0;
 
 	down(&priv->wx_sem);
-#ifdef ENABLE_IPS
 	//printk("set essid ENABLE_IPS\n");
 	if(priv->bInactivePs)
 		IPSLeave(dev);
-#endif
 //	printk("haha:set essid %s essid_len = %d essid_flgs = %d\n",b,  wrqu->essid.length, wrqu->essid.flags);
 
 	ret = ieee80211_wx_set_essid(priv->ieee80211,a,wrqu,b);
Index: b/drivers/staging/rtl8187se/r8185b_init.c
===================================================================
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -2546,7 +2546,6 @@ void rtl8185b_adapter_start(struct net_d
 		InitWirelessMode = ieee->mode;
 	}
 //by amy for power save
-#ifdef ENABLE_IPS
 //	printk("initialize ENABLE_IPS\n");
 	priv->eRFPowerState = eRfOff;
 	priv->RfOffReason = 0;
@@ -2571,7 +2570,6 @@ void rtl8185b_adapter_start(struct net_d
 	//	printk("rf off cost jiffies:%lx\n", (tmp2-tmp)*1000/HZ);
 
 	}
-#endif
 //	IPSEnter(dev);
 //by amy for power save
 #ifdef TODO
