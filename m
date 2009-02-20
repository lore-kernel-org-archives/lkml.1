Return-Path: <linux-kernel-owner+w=401wt.eu-S1756915AbZBTMJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbZBTMJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 07:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbZBTMJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 07:09:16 -0500
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:65143 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752095AbZBTMJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 07:09:15 -0500
Subject: [PATCH] linux-next/staging/wlan-ng: block ioctls until card fully
 initialised
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Greg KH <greg@kroah.com>
Cc: Karl Relton <karllinuxtest.relton@ntlworld.com>,
       lkml <linux-kernel@vger.kernel.org>,
       wlan-devel <linux-wlan-devel@lists.linux-wlan.com>
In-Reply-To: <20090218022117.GB32325@kroah.com>
References: <1234213202.6875.70.camel@dellpc>
	 <20090209211700.GA10742@kroah.com> <1234478293.17792.1.camel@dellpc>
	 <1234873158.2891.29.camel@localhost.localdomain>
	 <20090218022117.GB32325@kroah.com>
Content-Type: text/plain
Date: Fri, 20 Feb 2009 12:09:12 +0000
Message-Id: <1235131752.2822.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a mutex to block ioctls before the card is fully initialised and
only allow one ioctl at a time.
This stops udev trying to load the firmware before to card is fully up.

patch ported from wlan-ng-devel
    
Karl Relton <karllinuxtest.relton@ntlworld.com> spotted that this was
missing from the staging version,
http://lists.linux-wlan.com/pipermail/linux-wlan-devel/2009-February/003890.html

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
Hi Greg,

patch against linux-next-20090219.
booted & working on my laptop.

sorry about the delay, it's taken me a while to get linux-next running
on my laptop. 

regards
Richard


diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
index 50fa8d6..b2a606a 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -567,6 +567,8 @@ static int p80211knetdev_do_ioctl(netdevice_t *dev, struct ifreq *ifr, int cmd)
 
 	pr_debug("rx'd ioctl, cmd=%d, len=%d\n", cmd, req->len);
 
+	mutex_lock(&wlandev->ioctl_lock);
+
 #ifdef SIOCETHTOOL
 	if (cmd == SIOCETHTOOL) {
 		result =
@@ -607,6 +609,8 @@ static int p80211knetdev_do_ioctl(netdevice_t *dev, struct ifreq *ifr, int cmd)
 		result = -ENOMEM;
 	}
 bail:
+	mutex_unlock(&wlandev->ioctl_lock);
+
 	return result;		/* If allocate,copyfrom or copyto fails, return errno */
 }
 
@@ -758,6 +762,11 @@ int wlan_setup(wlandevice_t *wlandev)
 		dev->open = p80211knetdev_open;
 		dev->stop = p80211knetdev_stop;
 
+		mutex_init(&wlandev->ioctl_lock);
+		/* block ioctls until fully initialised. Don't forget to call
+		   allow_ioctls at some point!*/
+		mutex_lock(&wlandev->ioctl_lock);
+
 #if (WIRELESS_EXT < 21)
 		dev->get_wireless_stats = p80211wext_get_wireless_stats;
 #endif
@@ -1098,3 +1107,8 @@ static void p80211knetdev_tx_timeout(netdevice_t *netdev)
 		netif_wake_queue(wlandev->netdev);
 	}
 }
+
+void p80211_allow_ioctls(wlandevice_t *wlandev)
+{
+	mutex_unlock(&wlandev->ioctl_lock);
+}
diff --git a/drivers/staging/wlan-ng/p80211netdev.h b/drivers/staging/wlan-ng/p80211netdev.h
index 42e3b92..b96090d 100644
--- a/drivers/staging/wlan-ng/p80211netdev.h
+++ b/drivers/staging/wlan-ng/p80211netdev.h
@@ -227,6 +227,8 @@ typedef struct wlandevice {
 	u8 spy_number;
 	char spy_address[IW_MAX_SPY][ETH_ALEN];
 	struct iw_quality spy_stat[IW_MAX_SPY];
+
+	struct mutex ioctl_lock;
 } wlandevice_t;
 
 /* WEP stuff */
@@ -242,5 +244,5 @@ int register_wlandev(wlandevice_t *wlandev);
 int unregister_wlandev(wlandevice_t *wlandev);
 void p80211netdev_rx(wlandevice_t *wlandev, struct sk_buff *skb);
 void p80211netdev_hwremoved(wlandevice_t *wlandev);
-
+void p80211_allow_ioctls(wlandevice_t *wlandev);
 #endif
diff --git a/drivers/staging/wlan-ng/prism2usb.c b/drivers/staging/wlan-ng/prism2usb.c
index 252312e..d8a1298 100644
--- a/drivers/staging/wlan-ng/prism2usb.c
+++ b/drivers/staging/wlan-ng/prism2usb.c
@@ -170,6 +170,7 @@ failed:
 	wlandev = NULL;
 
 done:
+	p80211_allow_ioctls(wlandev);
 	usb_set_intfdata(interface, wlandev);
 	return result;
 }


