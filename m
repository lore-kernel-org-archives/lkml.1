Return-Path: <linux-kernel-owner+w=401wt.eu-S1763477AbZD2Wqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763477AbZD2Wqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763454AbZD2WqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:46:07 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57147 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763450AbZD2WqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:46:03 -0400
Date: Wed, 29 Apr 2009 18:31:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: pull request: wireless-2.6 2009-04-29
Message-ID: <20090429223111.GA17013@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

Another round intended for 2.6.30.  I think most of the fixes are
self-explanatory (at least with their changelogs) this time (for a
change)...please let me know if there are problems!

Thanks,

John

---

Individual patches are available here:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/

---

The following changes since commit bf368e4e70cd4e0f880923c44e95a4273d725ab4:
  Eric Dumazet (1):
        net: Avoid extra wakeups of threads blocked in wait_for_packet()

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git master

Alan Jenkins (1):
      mac80211: fix modprobe deadlock by not calling wep_init under rtnl_lock

Bob Copeland (1):
      ath5k: fix buffer overrun in rate debug code

Johannes Berg (2):
      iwlwifi: notify on scan completion even when shutting down
      mac80211: default to automatic power control

Jussi Kivilinna (1):
      rndis_wlan: fix initialization order for workqueue&workers

Stephen Rothwell (1):
      wireless: remove unneeded EXPORT_SYMBOL the tickles a powerpc compiler bug

 drivers/net/wireless/ath5k/debug.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 -
 drivers/net/wireless/rndis_wlan.c           |   14 ++++++++++----
 net/mac80211/main.c                         |   20 ++++++++++----------
 5 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath5k/debug.c b/drivers/net/wireless/ath5k/debug.c
index 9770bb3..4904a07 100644
--- a/drivers/net/wireless/ath5k/debug.c
+++ b/drivers/net/wireless/ath5k/debug.c
@@ -424,7 +424,7 @@ ath5k_debug_dump_bands(struct ath5k_softc *sc)
 
 	for (b = 0; b < IEEE80211_NUM_BANDS; b++) {
 		struct ieee80211_supported_band *band = &sc->sbands[b];
-		char bname[5];
+		char bname[6];
 		switch (band->band) {
 		case IEEE80211_BAND_2GHZ:
 			strcpy(bname, "2 GHz");
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 23644cf..e7c65c4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -925,11 +925,11 @@ void iwl_bg_scan_completed(struct work_struct *work)
 
 	IWL_DEBUG_SCAN(priv, "SCAN complete scan\n");
 
+	ieee80211_scan_completed(priv->hw, false);
+
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	ieee80211_scan_completed(priv->hw, false);
-
 	/* Since setting the TXPOWER may have been deferred while
 	 * performing the scan, fire one off */
 	mutex_lock(&priv->mutex);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 617c423..70a00c8 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1694,7 +1694,6 @@ void iwl3945_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 	rxq->free_count = 0;
 	spin_unlock_irqrestore(&rxq->lock, flags);
 }
-EXPORT_SYMBOL(iwl3945_rx_queue_reset);
 
 /*
  * this should be called while priv->lock is locked
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index db91db7..bebf735 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2558,6 +2558,11 @@ static int rndis_wext_bind(struct usbnet *usbdev, struct usb_interface *intf)
 	mutex_init(&priv->command_lock);
 	spin_lock_init(&priv->stats_lock);
 
+	/* because rndis_command() sleeps we need to use workqueue */
+	priv->workqueue = create_singlethread_workqueue("rndis_wlan");
+	INIT_WORK(&priv->work, rndis_wext_worker);
+	INIT_DELAYED_WORK(&priv->stats_work, rndis_update_wireless_stats);
+
 	/* try bind rndis_host */
 	retval = generic_rndis_bind(usbdev, intf, FLAG_RNDIS_PHYM_WIRELESS);
 	if (retval < 0)
@@ -2603,16 +2608,17 @@ static int rndis_wext_bind(struct usbnet *usbdev, struct usb_interface *intf)
 	disassociate(usbdev, 1);
 	netif_carrier_off(usbdev->net);
 
-	/* because rndis_command() sleeps we need to use workqueue */
-	priv->workqueue = create_singlethread_workqueue("rndis_wlan");
-	INIT_DELAYED_WORK(&priv->stats_work, rndis_update_wireless_stats);
 	queue_delayed_work(priv->workqueue, &priv->stats_work,
 		round_jiffies_relative(STATS_UPDATE_JIFFIES));
-	INIT_WORK(&priv->work, rndis_wext_worker);
 
 	return 0;
 
 fail:
+	cancel_delayed_work_sync(&priv->stats_work);
+	cancel_work_sync(&priv->work);
+	flush_workqueue(priv->workqueue);
+	destroy_workqueue(priv->workqueue);
+
 	kfree(priv);
 	return retval;
 }
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index fbcbed6..1413419 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -757,6 +757,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	local->hw.conf.long_frame_max_tx_count = 4;
 	local->hw.conf.short_frame_max_tx_count = 7;
 	local->hw.conf.radio_enabled = true;
+	local->user_power_level = -1;
 
 	INIT_LIST_HEAD(&local->interfaces);
 	mutex_init(&local->iflist_mtx);
@@ -909,6 +910,13 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (result < 0)
 		goto fail_sta_info;
 
+	result = ieee80211_wep_init(local);
+	if (result < 0) {
+		printk(KERN_DEBUG "%s: Failed to initialize wep: %d\n",
+		       wiphy_name(local->hw.wiphy), result);
+		goto fail_wep;
+	}
+
 	rtnl_lock();
 	result = dev_alloc_name(local->mdev, local->mdev->name);
 	if (result < 0)
@@ -930,14 +938,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		goto fail_rate;
 	}
 
-	result = ieee80211_wep_init(local);
-
-	if (result < 0) {
-		printk(KERN_DEBUG "%s: Failed to initialize wep: %d\n",
-		       wiphy_name(local->hw.wiphy), result);
-		goto fail_wep;
-	}
-
 	/* add one default STA interface if supported */
 	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_STATION)) {
 		result = ieee80211_if_add(local, "wlan%d", NULL,
@@ -967,13 +967,13 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	return 0;
 
-fail_wep:
-	rate_control_deinitialize(local);
 fail_rate:
 	unregister_netdevice(local->mdev);
 	local->mdev = NULL;
 fail_dev:
 	rtnl_unlock();
+	ieee80211_wep_free(local);
+fail_wep:
 	sta_info_stop(local);
 fail_sta_info:
 	debugfs_hw_del(local);
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
