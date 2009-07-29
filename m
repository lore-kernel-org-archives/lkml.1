Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbZG2UqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbZG2UqG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 16:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbZG2UqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 16:46:05 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37776 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045AbZG2UqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 16:46:01 -0400
Date: Wed, 29 Jul 2009 16:30:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: pull request: wireless-2.6 2009-07-29
Message-ID: <20090729203007.GB10056@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

Here is a small collection of fixes intended for 2.6.31.  Several of
them are small fixes dug-out by the usual static analysis suspects.
There are also a couple of iwlwifi fixes that the Intel team thinks are
important -- they look reasonably safe to me and they should only effect
their drivers.  Their are also some small fixes from Luis and Johannes.

Please let me know if there are problems!

Thanks,

John

---

Individual patches are available here:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/

---

The following changes since commit 8bae1b2b13beb4cf4c0f119f97640503c2b74b0f:
  Don Skidmore (1):
        ixgbe: fix for 82599 errata marking UDP checksum errors

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git master

Dan Carpenter (1):
      wireless: ERR_PTR vs null

Johannes Berg (2):
      iwlwifi: fix TX queue race
      mac80211: fix suspend

Luis R. Rodriguez (1):
      mac80211: do not queue work after suspend in the dynamic ps timer

Roel Kluin (5):
      airo: Buffer overflow
      ath9k: Read outside array bounds
      iwlwifi: Read outside array bounds
      libertas: Read outside array bounds
      libertas: Read buffer overflow

reinette chatre (1):
      iwlagn: fix minimum number of queues setting

 drivers/net/wireless/airo.c                 |   13 ++++++-------
 drivers/net/wireless/ath/ath9k/eeprom.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    6 ++++--
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   14 ++++++++------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++--
 drivers/net/wireless/iwmc3200wifi/netdev.c  |    6 ++----
 drivers/net/wireless/libertas/assoc.c       |   18 ++++++++----------
 drivers/net/wireless/libertas/scan.c        |    3 ++-
 net/mac80211/mlme.c                         |    2 +-
 net/mac80211/pm.c                           |   24 +++++++++++++++---------
 net/mac80211/rx.c                           |   12 ++++++++++++
 12 files changed, 63 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index c70604f..8ce5e4c 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -5918,20 +5918,19 @@ static int airo_set_essid(struct net_device *dev,
 	readSsidRid(local, &SSID_rid);
 
 	/* Check if we asked for `any' */
-	if(dwrq->flags == 0) {
+	if (dwrq->flags == 0) {
 		/* Just send an empty SSID list */
 		memset(&SSID_rid, 0, sizeof(SSID_rid));
 	} else {
-		int	index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
+		unsigned index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
 
 		/* Check the size of the string */
-		if(dwrq->length > IW_ESSID_MAX_SIZE) {
+		if (dwrq->length > IW_ESSID_MAX_SIZE)
 			return -E2BIG ;
-		}
+
 		/* Check if index is valid */
-		if((index < 0) || (index >= 4)) {
+		if (index >= ARRAY_SIZE(SSID_rid.ssids))
 			return -EINVAL;
-		}
 
 		/* Set the SSID */
 		memset(SSID_rid.ssids[index].ssid, 0,
@@ -6819,7 +6818,7 @@ static int airo_set_txpow(struct net_device *dev,
 		return -EINVAL;
 	}
 	clear_bit (FLAG_RADIO_OFF, &local->flags);
-	for (i = 0; cap_rid.txPowerLevels[i] && (i < 8); i++)
+	for (i = 0; i < 8 && cap_rid.txPowerLevels[i]; i++)
 		if (v == cap_rid.txPowerLevels[i]) {
 			readConfigRid(local, 1);
 			local->config.txPower = v;
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index a2fda70..ce0e86c 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -460,7 +460,7 @@ static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 		integer = swab32(eep->modalHeader.antCtrlCommon);
 		eep->modalHeader.antCtrlCommon = integer;
 
-		for (i = 0; i < AR5416_MAX_CHAINS; i++) {
+		for (i = 0; i < AR5416_EEP4K_MAX_CHAINS; i++) {
 			integer = swab32(eep->modalHeader.antCtrlChain[i]);
 			eep->modalHeader.antCtrlChain[i] = integer;
 		}
@@ -914,7 +914,7 @@ static void ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 			ctlMode, numCtlModes, isHt40CtlMode,
 			(pCtlMode[ctlMode] & EXT_ADDITIVE));
 
-		for (i = 0; (i < AR5416_NUM_CTLS) &&
+		for (i = 0; (i < AR5416_EEP4K_NUM_CTLS) &&
 				pEepData->ctlIndex[i]; i++) {
 			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 				"  LOOP-Ctlidx %d: cfgCtl 0x%2.2x "
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index fbb3a57..2de6471 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -112,7 +112,7 @@ enum iwl3945_antenna {
 #define IWL_TX_FIFO_NONE	7
 
 /* Minimum number of queues. MAX_NUM is defined in hw specific files */
-#define IWL_MIN_NUM_QUEUES	4
+#define IWL39_MIN_NUM_QUEUES	4
 
 #define IEEE80211_DATA_LEN              2304
 #define IEEE80211_4ADDR_LEN             30
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index e2d620f..650e20a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -258,8 +258,10 @@ struct iwl_channel_info {
 #define IWL_TX_FIFO_HCCA_2	6
 #define IWL_TX_FIFO_NONE	7
 
-/* Minimum number of queues. MAX_NUM is defined in hw specific files */
-#define IWL_MIN_NUM_QUEUES	4
+/* Minimum number of queues. MAX_NUM is defined in hw specific files.
+ * Set the minimum to accommodate the 4 standard TX queues, 1 command
+ * queue, 2 (unused) HCCA queues, and 4 HT queues (one for each AC) */
+#define IWL_MIN_NUM_QUEUES	10
 
 /* Power management (not Tx power) structures */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 9bbeec9..2e89040 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -720,8 +720,6 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		goto drop_unlock;
 	}
 
-	spin_unlock_irqrestore(&priv->lock, flags);
-
 	hdr_len = ieee80211_hdrlen(fc);
 
 	/* Find (or create) index into station table for destination station */
@@ -729,7 +727,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
 			       hdr->addr1);
-		goto drop;
+		goto drop_unlock;
 	}
 
 	IWL_DEBUG_TX(priv, "station Id %d\n", sta_id);
@@ -750,14 +748,17 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 			txq_id = priv->stations[sta_id].tid[tid].agg.txq_id;
 			swq_id = iwl_virtual_agg_queue_num(swq_id, txq_id);
 		}
-		priv->stations[sta_id].tid[tid].tfds_in_queue++;
 	}
 
 	txq = &priv->txq[txq_id];
 	q = &txq->q;
 	txq->swq_id = swq_id;
 
-	spin_lock_irqsave(&priv->lock, flags);
+	if (unlikely(iwl_queue_space(q) < q->high_mark))
+		goto drop_unlock;
+
+	if (ieee80211_is_data_qos(fc))
+		priv->stations[sta_id].tid[tid].tfds_in_queue++;
 
 	/* Set up driver data for this TFD */
 	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl_tx_info));
@@ -902,7 +903,6 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 drop_unlock:
 	spin_unlock_irqrestore(&priv->lock, flags);
-drop:
 	return -1;
 }
 EXPORT_SYMBOL(iwl_tx_skb);
@@ -1171,6 +1171,8 @@ int iwl_tx_agg_start(struct iwl_priv *priv, const u8 *ra, u16 tid, u16 *ssn)
 		IWL_ERR(priv, "Start AGG on invalid station\n");
 		return -ENXIO;
 	}
+	if (unlikely(tid >= MAX_TID_COUNT))
+		return -EINVAL;
 
 	if (priv->stations[sta_id].tid[tid].agg.state != IWL_AGG_OFF) {
 		IWL_ERR(priv, "Start AGG when state is not IWL_AGG_OFF !\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 956798f..2f50ab6 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4018,10 +4018,10 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 
 	if ((iwl3945_mod_params.num_of_queues > IWL39_MAX_NUM_QUEUES) ||
-	     (iwl3945_mod_params.num_of_queues < IWL_MIN_NUM_QUEUES)) {
+	     (iwl3945_mod_params.num_of_queues < IWL39_MIN_NUM_QUEUES)) {
 		IWL_ERR(priv,
 			"invalid queues_num, should be between %d and %d\n",
-			IWL_MIN_NUM_QUEUES, IWL39_MAX_NUM_QUEUES);
+			IWL39_MIN_NUM_QUEUES, IWL39_MAX_NUM_QUEUES);
 		err = -EINVAL;
 		goto out_ieee80211_free_hw;
 	}
diff --git a/drivers/net/wireless/iwmc3200wifi/netdev.c b/drivers/net/wireless/iwmc3200wifi/netdev.c
index aea5ccf..bf294e4 100644
--- a/drivers/net/wireless/iwmc3200wifi/netdev.c
+++ b/drivers/net/wireless/iwmc3200wifi/netdev.c
@@ -106,10 +106,8 @@ void *iwm_if_alloc(int sizeof_bus, struct device *dev,
 	int ret = 0;
 
 	wdev = iwm_wdev_alloc(sizeof_bus, dev);
-	if (!wdev) {
-		dev_err(dev, "no memory for wireless device instance\n");
-		return ERR_PTR(-ENOMEM);
-	}
+	if (IS_ERR(wdev))
+		return wdev;
 
 	iwm = wdev_to_iwm(wdev);
 	iwm->bus_ops = if_ops;
diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index b9b3741..d699737 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -1,6 +1,7 @@
 /* Copyright (C) 2006, Red Hat, Inc. */
 
 #include <linux/types.h>
+#include <linux/kernel.h>
 #include <linux/etherdevice.h>
 #include <linux/ieee80211.h>
 #include <linux/if_arp.h>
@@ -43,21 +44,21 @@ static int get_common_rates(struct lbs_private *priv,
 	u16 *rates_size)
 {
 	u8 *card_rates = lbs_bg_rates;
-	size_t num_card_rates = sizeof(lbs_bg_rates);
 	int ret = 0, i, j;
-	u8 tmp[30];
+	u8 tmp[(ARRAY_SIZE(lbs_bg_rates) - 1) * (*rates_size - 1)];
 	size_t tmp_size = 0;
 
 	/* For each rate in card_rates that exists in rate1, copy to tmp */
-	for (i = 0; card_rates[i] && (i < num_card_rates); i++) {
-		for (j = 0; rates[j] && (j < *rates_size); j++) {
+	for (i = 0; i < ARRAY_SIZE(lbs_bg_rates) && card_rates[i]; i++) {
+		for (j = 0; j < *rates_size && rates[j]; j++) {
 			if (rates[j] == card_rates[i])
 				tmp[tmp_size++] = card_rates[i];
 		}
 	}
 
 	lbs_deb_hex(LBS_DEB_JOIN, "AP rates    ", rates, *rates_size);
-	lbs_deb_hex(LBS_DEB_JOIN, "card rates  ", card_rates, num_card_rates);
+	lbs_deb_hex(LBS_DEB_JOIN, "card rates  ", card_rates,
+			ARRAY_SIZE(lbs_bg_rates));
 	lbs_deb_hex(LBS_DEB_JOIN, "common rates", tmp, tmp_size);
 	lbs_deb_join("TX data rate 0x%02x\n", priv->cur_rate);
 
@@ -69,10 +70,7 @@ static int get_common_rates(struct lbs_private *priv,
 		lbs_pr_alert("Previously set fixed data rate %#x isn't "
 		       "compatible with the network.\n", priv->cur_rate);
 		ret = -1;
-		goto done;
 	}
-	ret = 0;
-
 done:
 	memset(rates, 0, *rates_size);
 	*rates_size = min_t(int, tmp_size, *rates_size);
@@ -322,7 +320,7 @@ static int lbs_associate(struct lbs_private *priv,
 	rates = (struct mrvl_ie_rates_param_set *) pos;
 	rates->header.type = cpu_to_le16(TLV_TYPE_RATES);
 	memcpy(&rates->rates, &bss->rates, MAX_RATES);
-	tmplen = MAX_RATES;
+	tmplen = min_t(u16, ARRAY_SIZE(rates->rates), MAX_RATES);
 	if (get_common_rates(priv, rates->rates, &tmplen)) {
 		ret = -1;
 		goto done;
@@ -598,7 +596,7 @@ static int lbs_adhoc_join(struct lbs_private *priv,
 
 	/* Copy Data rates from the rates recorded in scan response */
 	memset(cmd.bss.rates, 0, sizeof(cmd.bss.rates));
-	ratesize = min_t(u16, sizeof(cmd.bss.rates), MAX_RATES);
+	ratesize = min_t(u16, ARRAY_SIZE(cmd.bss.rates), MAX_RATES);
 	memcpy(cmd.bss.rates, bss->rates, ratesize);
 	if (get_common_rates(priv, cmd.bss.rates, &ratesize)) {
 		lbs_deb_join("ADHOC_JOIN: get_common_rates returned error.\n");
diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index 601b542..6c95af3 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -5,6 +5,7 @@
   *  for sending scan commands to the firmware.
   */
 #include <linux/types.h>
+#include <linux/kernel.h>
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 #include <asm/unaligned.h>
@@ -876,7 +877,7 @@ static inline char *lbs_translate_scan(struct lbs_private *priv,
 	iwe.u.bitrate.disabled = 0;
 	iwe.u.bitrate.value = 0;
 
-	for (j = 0; bss->rates[j] && (j < sizeof(bss->rates)); j++) {
+	for (j = 0; j < ARRAY_SIZE(bss->rates) && bss->rates[j]; j++) {
 		/* Bit rate given in 500 kb/s units */
 		iwe.u.bitrate.value = bss->rates[j] * 500000;
 		current_val = iwe_stream_add_value(info, start, current_val,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index aca22b0..07e7e41 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -721,7 +721,7 @@ void ieee80211_dynamic_ps_timer(unsigned long data)
 {
 	struct ieee80211_local *local = (void *) data;
 
-	if (local->quiescing)
+	if (local->quiescing || local->suspended)
 		return;
 
 	queue_work(local->hw.workqueue, &local->dynamic_ps_enable_work);
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 7a549f9..5e3d476 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -55,15 +55,6 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
 
 	rcu_read_unlock();
 
-	/* flush again, in case driver queued work */
-	flush_workqueue(local->hw.workqueue);
-
-	/* stop hardware - this must stop RX */
-	if (local->open_count) {
-		ieee80211_led_radio(local, false);
-		drv_stop(local);
-	}
-
 	/* remove STAs */
 	spin_lock_irqsave(&local->sta_lock, flags);
 	list_for_each_entry(sta, &local->sta_list, list) {
@@ -111,7 +102,22 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
 		drv_remove_interface(local, &conf);
 	}
 
+	/* stop hardware - this must stop RX */
+	if (local->open_count) {
+		ieee80211_led_radio(local, false);
+		drv_stop(local);
+	}
+
+	/*
+	 * flush again, in case driver queued work -- it
+	 * shouldn't be doing (or cancel everything in the
+	 * stop callback) that but better safe than sorry.
+	 */
+	flush_workqueue(local->hw.workqueue);
+
 	local->suspended = true;
+	/* need suspended to be visible before quiescing is false */
+	barrier();
 	local->quiescing = false;
 
 	return 0;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index de5bba7..0936fc2 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2453,6 +2453,18 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		return;
 	}
 
+	/*
+	 * If we're suspending, it is possible although not too likely
+	 * that we'd be receiving frames after having already partially
+	 * quiesced the stack. We can't process such frames then since
+	 * that might, for example, cause stations to be added or other
+	 * driver callbacks be invoked.
+	 */
+	if (unlikely(local->quiescing || local->suspended)) {
+		kfree_skb(skb);
+		return;
+	}
+
 	if (status->flag & RX_FLAG_HT) {
 		/* rate_idx is MCS index */
 		if (WARN_ON(status->rate_idx < 0 ||
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
