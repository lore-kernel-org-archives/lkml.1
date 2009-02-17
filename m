Return-Path: <linux-kernel-owner+w=401wt.eu-S1752972AbZBQMTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbZBQMTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 07:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbZBQMTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 07:19:21 -0500
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:48366 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340AbZBQMTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 07:19:21 -0500
Subject: [PATCH] staging/wlan-ng: block ioctls until card fully initialised
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Karl Relton <karllinuxtest.relton@ntlworld.com>, greg <greg@kroah.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       wlan-devel <linux-wlan-devel@lists.linux-wlan.com>
Content-Type: text/plain
Date: Tue, 17 Feb 2009 12:19:18 +0000
Message-Id: <1234873158.2891.29.camel@localhost.localdomain>
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
This has only had basic testing, & I haven't tried loading the firmware
yet.  
regards
Richard


diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
index 59e5ad1..f6cc298 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -623,6 +623,7 @@ static int p80211knetdev_do_ioctl(netdevice_t *dev, struct ifreq *ifr, int cmd)
 
 	WLAN_LOG_DEBUG(2, "rx'd ioctl, cmd=%d, len=%d\n", cmd, req->len);
 
+	mutex_lock(&wlandev->ioctl_lock);
 #ifdef SIOCETHTOOL
 	if (cmd == SIOCETHTOOL) {
 		result = p80211netdev_ethtool(wlandev, (void __user *) ifr->ifr_data);
@@ -662,6 +663,7 @@ static int p80211knetdev_do_ioctl(netdevice_t *dev, struct ifreq *ifr, int cmd)
 		result = -ENOMEM;
 	}
 bail:
+	mutex_unlock(&wlandev->ioctl_lock);
 	DBFEXIT;
 
 	return result; /* If allocate,copyfrom or copyto fails, return errno */
@@ -823,6 +825,13 @@ int wlan_setup(wlandevice_t *wlandev)
 		dev->ml_priv = wlandev;
 		dev->hard_start_xmit =	p80211knetdev_hard_start_xmit;
 		dev->get_stats =	p80211knetdev_get_stats;
+
+		mutex_init(&wlandev->ioctl_lock);
+		/* block ioctls until fully initialised. Don't forget to call
+		   allow_ioctls at some point!*/
+		mutex_lock(&wlandev->ioctl_lock);
+
+
 #ifdef HAVE_PRIVATE_IOCTL
 		dev->do_ioctl = 	p80211knetdev_do_ioctl;
 #endif
@@ -1207,3 +1216,8 @@ static void p80211knetdev_tx_timeout( netdevice_t *netdev)
 
 	DBFEXIT;
 }
+
+
+void p80211_allow_ioctls(wlandevice_t *wlandev) {
+	mutex_unlock(&wlandev->ioctl_lock);
+}
diff --git a/drivers/staging/wlan-ng/p80211netdev.h b/drivers/staging/wlan-ng/p80211netdev.h
index 940146f..da49552 100644
--- a/drivers/staging/wlan-ng/p80211netdev.h
+++ b/drivers/staging/wlan-ng/p80211netdev.h
@@ -235,6 +235,8 @@ typedef struct wlandevice
         u8			spy_number;
         char			spy_address[IW_MAX_SPY][ETH_ALEN];
         struct iw_quality       spy_stat[IW_MAX_SPY];
+
+	struct mutex ioctl_lock;
 } wlandevice_t;
 
 /* WEP stuff */
@@ -251,4 +253,7 @@ int	unregister_wlandev(wlandevice_t *wlandev);
 void	p80211netdev_rx(wlandevice_t *wlandev, struct sk_buff *skb);
 void	p80211netdev_hwremoved(wlandevice_t *wlandev);
 
+void p80211_allow_ioctls(wlandevice_t *wlandev);
+
+
 #endif
diff --git a/drivers/staging/wlan-ng/prism2usb.c b/drivers/staging/wlan-ng/prism2usb.c
index 8f7b1f2..78c7504 100644
--- a/drivers/staging/wlan-ng/prism2usb.c
+++ b/drivers/staging/wlan-ng/prism2usb.c
@@ -149,7 +149,7 @@ static int prism2sta_probe_usb(
 
  done:
 	DBFEXIT;
-
+	p80211_allow_ioctls(wlandev);
 	usb_set_intfdata(interface, wlandev);
 	return result;
 }


