Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbZIOSSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbZIOSSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 14:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbZIOSSC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 14:18:02 -0400
Received: from mailhost14.gawab.com ([66.220.20.14]:49433 "HELO
	info88.gawab.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755252AbZIOSRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 14:17:18 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Sep 2009 14:17:18 EDT
Message-ID: <20090915181039.303.qmail@info88.gawab.com>
From: "Justin Madru" <jdm64@gawab.com>
To: linux-kernel@vger.kernel.org, johannes@sipsolutions.net,
       linville@tuxdriver.com
Subject: WARNING: at net/wireless/core.c:613 wdev_cleanup_work+0xb7/0xe0
Date: Tue, 15 Sep 2009 18:10:14 GMT
Content-Type: text/plain ; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [137.151.175.24]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently testing 2.6.32-rc0. I'm getting the following warning upon every
boot.
Are there any consequences of this warning? What does it mean?

WARNING: at net/wireless/core.c:613 wdev_cleanup_work+0xb7/0xe0
[cfg80211]()
Hardware name: MM061                           
Modules linked in: cpufreq_stats aes_generic binfmt_misc ipv6 container sbs
sbshc ext3 jbd mbcache snd_hda_codec_idt arc4 ecb cryptomgr crypto_hash
aead pcompress crypto_blkcipher crypto_algapi snd_hda_intel snd_hda_codec
snd_hwdep snd_pcm_oss snd_mixer_oss iwl3945 iwlcore dell_laptop snd_pcm
mac80211 dcdbas ac psmouse button battery evdev ricoh_mmc sdhci_pci sdhci
mmc_core processor rtc_cmos rtc_core rtc_lib snd_page_alloc cfg80211 rfkill
reiserfs sr_mod cdrom sg ata_piix ehci_hcd uhci_hcd usbcore nls_base
thermal fan fuse fbcon font bitblit softcursor i915 fb cfbcopyarea video
backlight output cfbimgblt cfbfillrect intel_agp
Pid: 9, comm: events/0 Not tainted 2.6.32-rc0-git #1
Call Trace:
 [<f8c85fc7>] ? wdev_cleanup_work+0xb7/0xe0 [cfg80211]
 [<f8c85fc7>] ? wdev_cleanup_work+0xb7/0xe0 [cfg80211]
 [<c0142810>] warn_slowpath_common+0x70/0x100
 [<f8c85fc7>] ? wdev_cleanup_work+0xb7/0xe0 [cfg80211]
 [<c01428b5>] warn_slowpath_null+0x15/0x20
 [<f8c85fc7>] wdev_cleanup_work+0xb7/0xe0 [cfg80211]
 [<c0157894>] worker_thread+0x114/0x1f0
 [<f8c85f10>] ? wdev_cleanup_work+0x0/0xe0 [cfg80211]
 [<c015c6c0>] ? autoremove_wake_function+0x0/0x50
 [<c0157780>] ? worker_thread+0x0/0x1f0
 [<c015c434>] kthread+0x74/0x80
 [<c015c3c0>] ? kthread+0x0/0x80
 [<c0103fcf>] kernel_thread_helper+0x7/0x18
---[ end trace 90f5bf1285e60504 ]---

git blame shows core.c:613 was last modified by:

commit ad002395fd230528281083f4be71855ed7e35b04
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Tue Aug 18 19:51:57 2009 +0200

    cfg80211: fix dangling scan request checking
    
    My patch "cfg80211: fix deadlock" broke the code it
    was supposed to fix, the scan request checking. But
    it's not trivial to put it back the way it was, since
    the original patch had a deadlock.
    
    Now do it in a completely new way: queue the check
    off to a work struct, where we can freely lock. But
    that has some more complications, like needing to
    wait for it to be done before the wiphy/rdev can be
    destroyed, so some code is required to handle that.
    
    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0b146bb..3d874c6 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1325,6 +1325,8 @@ struct wireless_dev {
 
 	struct mutex mtx;
 
+	struct work_struct cleanup_work;
+
 	/* currently used for IBSS and SME - might be rearranged later */
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	u8 ssid_len;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 69a185b..c150071 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -430,6 +430,8 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops,
int sizeof_priv)
 	INIT_WORK(&rdev->conn_work, cfg80211_conn_work);
 	INIT_WORK(&rdev->event_work, cfg80211_event_work);
 
+	init_waitqueue_head(&rdev->dev_wait);
+
 	/*
 	 * Initialize wiphy parameters to IEEE 802.11 MIB default values.
 	 * Fragmentation and RTS threshold are disabled by default with the
@@ -574,7 +576,23 @@ void wiphy_unregister(struct wiphy *wiphy)
 	/* protect the device list */
 	mutex_lock(&cfg80211_mutex);
 
+	wait_event(rdev->dev_wait, ({
+		int __count;
+		mutex_lock(&rdev->devlist_mtx);
+		__count = rdev->opencount;
+		mutex_unlock(&rdev->devlist_mtx);
+		__count == 0;}));
+
+	mutex_lock(&rdev->devlist_mtx);
 	BUG_ON(!list_empty(&rdev->netdev_list));
+	mutex_unlock(&rdev->devlist_mtx);
+
+	/*
+	 * First remove the hardware from everywhere, this makes
+	 * it impossible to find from userspace.
+	 */
+	cfg80211_debugfs_rdev_del(rdev);
+	list_del(&rdev->list);
 
 	/*
 	 * Try to grab rdev->mtx. If a command is still in progress,
@@ -582,26 +600,18 @@ void wiphy_unregister(struct wiphy *wiphy)
 	 * down the device already. We wait for this command to complete
 	 * before unlinking the item from the list.
 	 * Note: as codified by the BUG_ON above we cannot get here if
-	 * a virtual interface is still associated. Hence, we can only
-	 * get to lock contention here if userspace issues a command
-	 * that identified the hardware by wiphy index.
+	 * a virtual interface is still present. Hence, we can only get
+	 * to lock contention here if userspace issues a command that
+	 * identified the hardware by wiphy index.
 	 */
 	cfg80211_lock_rdev(rdev);
-
-	if (WARN_ON(rdev->scan_req)) {
-		rdev->scan_req->aborted = true;
-		___cfg80211_scan_done(rdev);
-	}
-
+	/* nothing */
 	cfg80211_unlock_rdev(rdev);
 
-	cfg80211_debugfs_rdev_del(rdev);
-
 	/* If this device got a regulatory hint tell core its
 	 * free to listen now to a new shiny device regulatory hint */
 	reg_device_remove(wiphy);
 
-	list_del(&rdev->list);
 	cfg80211_rdev_list_generation++;
 	device_del(&rdev->wiphy.dev);
 	debugfs_remove(rdev->wiphy.debugfsdir);
@@ -640,6 +650,31 @@ void wiphy_rfkill_set_hw_state(struct wiphy *wiphy,
bool blocked)
 }
 EXPORT_SYMBOL(wiphy_rfkill_set_hw_state);
 
+static void wdev_cleanup_work(struct work_struct *work)
+{
+	struct wireless_dev *wdev;
+	struct cfg80211_registered_device *rdev;
+
+	wdev = container_of(work, struct wireless_dev, cleanup_work);
+	rdev = wiphy_to_dev(wdev->wiphy);
+
+	cfg80211_lock_rdev(rdev);
+
+	if (WARN_ON(rdev->scan_req && rdev->scan_req->dev == wdev->netdev)) {
+		rdev->scan_req->aborted = true;
+		___cfg80211_scan_done(rdev);
+	}
+
+	cfg80211_unlock_rdev(rdev);
+
+	mutex_lock(&rdev->devlist_mtx);
+	rdev->opencount--;
+	mutex_unlock(&rdev->devlist_mtx);
+	wake_up(&rdev->dev_wait);
+
+	dev_put(wdev->netdev);
+}
+
 static int cfg80211_netdev_notifier_call(struct notifier_block * nb,
 					 unsigned long state,
 					 void *ndev)
@@ -663,6 +698,7 @@ static int cfg80211_netdev_notifier_call(struct
notifier_block * nb,
 		 * are added with nl80211.
 		 */
 		mutex_init(&wdev->mtx);
+		INIT_WORK(&wdev->cleanup_work, wdev_cleanup_work);
 		INIT_LIST_HEAD(&wdev->event_list);
 		spin_lock_init(&wdev->event_lock);
 		mutex_lock(&rdev->devlist_mtx);
@@ -717,8 +753,22 @@ static int cfg80211_netdev_notifier_call(struct
notifier_block * nb,
 		default:
 			break;
 		}
+		dev_hold(dev);
+		schedule_work(&wdev->cleanup_work);
 		break;
 	case NETDEV_UP:
+		/*
+		 * If we have a really quick DOWN/UP succession we may
+		 * have this work still pending ... cancel it and see
+		 * if it was pending, in which case we need to account
+		 * for some of the work it would have done.
+		 */
+		if (cancel_work_sync(&wdev->cleanup_work)) {
+			mutex_lock(&rdev->devlist_mtx);
+			rdev->opencount--;
+			mutex_unlock(&rdev->devlist_mtx);
+			dev_put(dev);
+		}
 #ifdef CONFIG_WIRELESS_EXT
 		cfg80211_lock_rdev(rdev);
 		mutex_lock(&rdev->devlist_mtx);
@@ -734,6 +784,7 @@ static int cfg80211_netdev_notifier_call(struct
notifier_block * nb,
 			break;
 		}
 		wdev_unlock(wdev);
+		rdev->opencount++;
 		mutex_unlock(&rdev->devlist_mtx);
 		cfg80211_unlock_rdev(rdev);
 #endif
@@ -756,7 +807,6 @@ static int cfg80211_netdev_notifier_call(struct
notifier_block * nb,
 			sysfs_remove_link(&dev->dev.kobj, "phy80211");
 			list_del_init(&wdev->list);
 			rdev->devlist_generation++;
-			mutex_destroy(&wdev->mtx);
 #ifdef CONFIG_WIRELESS_EXT
 			kfree(wdev->wext.keys);
 #endif
diff --git a/net/wireless/core.h b/net/wireless/core.h
index c603f52..f565432 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -50,6 +50,8 @@ struct cfg80211_registered_device {
 	struct mutex devlist_mtx;
 	struct list_head netdev_list;
 	int devlist_generation;
+	int opencount; /* also protected by devlist_mtx */
+	wait_queue_head_t dev_wait;
 
 	/* BSSes/scanning */
 	spinlock_t bss_lock;


Justin Madru

-----------------------------------------------------------------------------------------------------------------------
Send big files for free. Simple steps. No registration.
Visit now http://www.nawelny.com
