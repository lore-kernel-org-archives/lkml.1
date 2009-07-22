Return-Path: <linux-kernel-owner+w=401wt.eu-S1751865AbZGVSBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbZGVSBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 14:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbZGVSA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 14:00:59 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48263 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbZGVSA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 14:00:57 -0400
Date: Wed, 22 Jul 2009 13:47:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: pull request: wireless-2.6 2009-07-22
Message-ID: <20090722174756.GI5276@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

Here is a collection of fixes intended for 2.6.31.  I think they mostly
speak for themselves and are uncontroversial.

Please let me know if there are problems!

Thanks,

John

---

Individual patches are available here:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/

---

The following changes since commit 1b0d92244ff2434a98272f6d2525da32fc230f19:
  Wolfgang Grandegger (1):
        can: switch carrier on if device was stopped while in bus-off state

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git master

Alan Jenkins (3):
      rfkill: fix rfkill_set_states() to set the hw state
      rfkill: remove too-strict __must_check
      acer-wmi: fix rfkill conversion

Andy Whitcroft (1):
      rt2x00: Fix chipset detection for rt2500usb

Bob Copeland (1):
      ath5k: temporarily disable crypto for AP mode

Christian Lamparter (1):
      cfg80211: double free in __cfg80211_scan_done

Dan Carpenter (1):
      p54spi: fix potential null deref in p54spi.c

Javier Cardona (1):
      mac80211: use correct address for mesh Path Error

Johannes Berg (4):
      mac80211: disable mesh
      rfkill: allow toggling soft state in sysfs again
      mac80211_hwsim: fix unregistration
      mac80211_hwsim: fix use after free

Larry Finger (1):
      rtl8187: Fix for kernel oops when unloading with LEDs enabled

Luis R. Rodriguez (2):
      ath9k: Tune ANI function processing on AP mode during ANI reset
      ath: add support for special 0x8000 regulatory domain

Marek Vasut (1):
      libertas: Fix problem with broken V4 firmware on CF8381

Niko Jokinen (1):
      nl80211: Memory leak fixed

Pavel Roskin (1):
      mac80211: fix injection in monitor mode

Reinette Chatre (2):
      iwlwifi: only show active power level via sysfs
      iwlwifi: only update byte count table during aggregation

Zhu Yi (1):
      iwmc3200wifi: fix NULL pointer dereference in iwm_if_free

 drivers/net/wireless/ath/ath5k/base.c       |    3 ++
 drivers/net/wireless/ath/ath9k/ani.c        |   12 ++++++++++
 drivers/net/wireless/ath/regd.c             |   17 ++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    4 +--
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    3 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 +--
 drivers/net/wireless/iwmc3200wifi/netdev.c  |    2 +-
 drivers/net/wireless/libertas/cmd.c         |    8 ++++++-
 drivers/net/wireless/libertas/defs.h        |    2 +
 drivers/net/wireless/mac80211_hwsim.c       |    6 ++--
 drivers/net/wireless/p54/p54spi.c           |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.c     |    4 ++-
 drivers/net/wireless/rtl818x/rtl8187_leds.c |    3 +-
 drivers/platform/x86/acer-wmi.c             |    2 +-
 include/linux/rfkill.h                      |    2 +-
 net/mac80211/Kconfig                        |    1 +
 net/mac80211/mesh_pathtbl.c                 |   11 +++++++--
 net/mac80211/tx.c                           |    2 +-
 net/rfkill/core.c                           |   31 ++++++++++++++++++++-------
 net/wireless/nl80211.c                      |    5 ++-
 net/wireless/scan.c                         |    3 +-
 21 files changed, 94 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index ea04515..029c1bc 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2970,6 +2970,9 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	if (modparam_nohwcrypt)
 		return -EOPNOTSUPP;
 
+	if (sc->opmode == NL80211_IFTYPE_AP)
+		return -EOPNOTSUPP;
+
 	switch (key->alg) {
 	case ALG_WEP:
 	case ALG_TKIP:
diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 1aeafb5..aad259b 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -478,6 +478,18 @@ void ath9k_ani_reset(struct ath_hw *ah)
 			"Reset ANI state opmode %u\n", ah->opmode);
 		ah->stats.ast_ani_reset++;
 
+		if (ah->opmode == NL80211_IFTYPE_AP) {
+			/*
+			 * ath9k_hw_ani_control() will only process items set on
+			 * ah->ani_function
+			 */
+			if (IS_CHAN_2GHZ(chan))
+				ah->ani_function = (ATH9K_ANI_SPUR_IMMUNITY_LEVEL |
+						    ATH9K_ANI_FIRSTEP_LEVEL);
+			else
+				ah->ani_function = 0;
+		}
+
 		ath9k_hw_ani_control(ah, ATH9K_ANI_NOISE_IMMUNITY_LEVEL, 0);
 		ath9k_hw_ani_control(ah, ATH9K_ANI_SPUR_IMMUNITY_LEVEL, 0);
 		ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL, 0);
diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index eef370b..bf3d25b 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -474,6 +474,21 @@ ath_regd_init_wiphy(struct ath_regulatory *reg,
 	return 0;
 }
 
+/*
+ * Some users have reported their EEPROM programmed with
+ * 0x8000 set, this is not a supported regulatory domain
+ * but since we have more than one user with it we need
+ * a solution for them. We default to 0x64, which is the
+ * default Atheros world regulatory domain.
+ */
+static void ath_regd_sanitize(struct ath_regulatory *reg)
+{
+	if (reg->current_rd != COUNTRY_ERD_FLAG)
+		return;
+	printk(KERN_DEBUG "ath: EEPROM regdomain sanitized\n");
+	reg->current_rd = 0x64;
+}
+
 int
 ath_regd_init(struct ath_regulatory *reg,
 	      struct wiphy *wiphy,
@@ -486,6 +501,8 @@ ath_regd_init(struct ath_regulatory *reg,
 	if (!reg)
 		return -EINVAL;
 
+	ath_regd_sanitize(reg);
+
 	printk(KERN_DEBUG "ath: EEPROM regdomain: 0x%0x\n", reg->current_rd);
 
 	if (!ath_regd_is_eeprom_valid(reg)) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 6d1519e..355f50e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2675,12 +2675,10 @@ static ssize_t show_power_level(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
 	struct iwl_priv *priv = dev_get_drvdata(d);
-	int mode = priv->power_data.user_power_setting;
 	int level = priv->power_data.power_mode;
 	char *p = buf;
 
-	p += sprintf(p, "INDEX:%d\t", level);
-	p += sprintf(p, "USER:%d\n", mode);
+	p += sprintf(p, "%d\n", level);
 	return p - buf + 1;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 85ae7a6..9bbeec9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -872,7 +872,8 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd->hdr, hdr_len);
 
 	/* Set up entry for this TFD in Tx byte-count array */
-	priv->cfg->ops->lib->txq_update_byte_cnt_tbl(priv, txq,
+	if (info->flags & IEEE80211_TX_CTL_AMPDU)
+		priv->cfg->ops->lib->txq_update_byte_cnt_tbl(priv, txq,
 						     le16_to_cpu(tx_cmd->len));
 
 	pci_dma_sync_single_for_device(priv->pci_dev, txcmd_phys,
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index cb9bd4c..956798f 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3643,12 +3643,10 @@ static ssize_t show_power_level(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
 	struct iwl_priv *priv = dev_get_drvdata(d);
-	int mode = priv->power_data.user_power_setting;
 	int level = priv->power_data.power_mode;
 	char *p = buf;
 
-	p += sprintf(p, "INDEX:%d\t", level);
-	p += sprintf(p, "USER:%d\n", mode);
+	p += sprintf(p, "%d\n", level);
 	return p - buf + 1;
 }
 
diff --git a/drivers/net/wireless/iwmc3200wifi/netdev.c b/drivers/net/wireless/iwmc3200wifi/netdev.c
index aaa20c6..aea5ccf 100644
--- a/drivers/net/wireless/iwmc3200wifi/netdev.c
+++ b/drivers/net/wireless/iwmc3200wifi/netdev.c
@@ -151,8 +151,8 @@ void iwm_if_free(struct iwm_priv *iwm)
 		return;
 
 	free_netdev(iwm_to_ndev(iwm));
-	iwm_wdev_free(iwm);
 	iwm_priv_deinit(iwm);
+	iwm_wdev_free(iwm);
 }
 
 int iwm_if_add(struct iwm_priv *iwm)
diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 01db705..6850981 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -135,8 +135,14 @@ int lbs_update_hw_spec(struct lbs_private *priv)
 	/* Clamp region code to 8-bit since FW spec indicates that it should
 	 * only ever be 8-bit, even though the field size is 16-bit.  Some firmware
 	 * returns non-zero high 8 bits here.
+	 *
+	 * Firmware version 4.0.102 used in CF8381 has region code shifted.  We
+	 * need to check for this problem and handle it properly.
 	 */
-	priv->regioncode = le16_to_cpu(cmd.regioncode) & 0xFF;
+	if (MRVL_FW_MAJOR_REV(priv->fwrelease) == MRVL_FW_V4)
+		priv->regioncode = (le16_to_cpu(cmd.regioncode) >> 8) & 0xFF;
+	else
+		priv->regioncode = le16_to_cpu(cmd.regioncode) & 0xFF;
 
 	for (i = 0; i < MRVDRV_MAX_REGION_CODE; i++) {
 		/* use the region code to search for the index */
diff --git a/drivers/net/wireless/libertas/defs.h b/drivers/net/wireless/libertas/defs.h
index 48da157..72f3479 100644
--- a/drivers/net/wireless/libertas/defs.h
+++ b/drivers/net/wireless/libertas/defs.h
@@ -234,6 +234,8 @@ static inline void lbs_deb_hex(unsigned int grp, const char *prompt, u8 *buf, in
 /** Mesh enable bit in FW capability */
 #define MESH_CAPINFO_ENABLE_MASK			(1<<16)
 
+/** FW definition from Marvell v4 */
+#define MRVL_FW_V4					(0x04)
 /** FW definition from Marvell v5 */
 #define MRVL_FW_V5					(0x05)
 /** FW definition from Marvell v10 */
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index a111bda..7916ca3 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -709,7 +709,7 @@ static const struct ieee80211_ops mac80211_hwsim_ops =
 static void mac80211_hwsim_free(void)
 {
 	struct list_head tmplist, *i, *tmp;
-	struct mac80211_hwsim_data *data;
+	struct mac80211_hwsim_data *data, *tmpdata;
 
 	INIT_LIST_HEAD(&tmplist);
 
@@ -718,7 +718,7 @@ static void mac80211_hwsim_free(void)
 		list_move(i, &tmplist);
 	spin_unlock_bh(&hwsim_radio_lock);
 
-	list_for_each_entry(data, &tmplist, list) {
+	list_for_each_entry_safe(data, tmpdata, &tmplist, list) {
 		debugfs_remove(data->debugfs_group);
 		debugfs_remove(data->debugfs_ps);
 		debugfs_remove(data->debugfs);
@@ -1167,8 +1167,8 @@ static void __exit exit_mac80211_hwsim(void)
 {
 	printk(KERN_DEBUG "mac80211_hwsim: unregister radios\n");
 
-	unregister_netdev(hwsim_mon);
 	mac80211_hwsim_free();
+	unregister_netdev(hwsim_mon);
 }
 
 
diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index 83116ba..72c7dbd 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -635,7 +635,7 @@ static int __devinit p54spi_probe(struct spi_device *spi)
 
 	hw = p54_init_common(sizeof(*priv));
 	if (!hw) {
-		dev_err(&priv->spi->dev, "could not alloc ieee80211_hw");
+		dev_err(&spi->dev, "could not alloc ieee80211_hw");
 		return -ENOMEM;
 	}
 
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 66daf68..ce75426 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1550,7 +1550,9 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2500usb_register_read(rt2x00dev, MAC_CSR0, &reg);
 	rt2x00_set_chip(rt2x00dev, RT2570, value, reg);
 
-	if (!rt2x00_check_rev(&rt2x00dev->chip, 0x000ffff0, 0)) {
+	if (!rt2x00_check_rev(&rt2x00dev->chip, 0x000ffff0, 0) ||
+	    rt2x00_check_rev(&rt2x00dev->chip, 0x0000000f, 0)) {
+
 		ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
 		return -ENODEV;
 	}
diff --git a/drivers/net/wireless/rtl818x/rtl8187_leds.c b/drivers/net/wireless/rtl818x/rtl8187_leds.c
index b442535..cf9f899 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_leds.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_leds.c
@@ -208,11 +208,12 @@ void rtl8187_leds_exit(struct ieee80211_hw *dev)
 {
 	struct rtl8187_priv *priv = dev->priv;
 
-	rtl8187_unregister_led(&priv->led_tx);
 	/* turn the LED off before exiting */
 	queue_delayed_work(dev->workqueue, &priv->led_off, 0);
 	cancel_delayed_work_sync(&priv->led_off);
+	cancel_delayed_work_sync(&priv->led_on);
 	rtl8187_unregister_led(&priv->led_rx);
+	rtl8187_unregister_led(&priv->led_tx);
 }
 #endif /* def CONFIG_RTL8187_LED */
 
diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index be2fd6f..fb45f5e 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -973,7 +973,7 @@ static int acer_rfkill_set(void *data, bool blocked)
 {
 	acpi_status status;
 	u32 cap = (unsigned long)data;
-	status = set_u32(!!blocked, cap);
+	status = set_u32(!blocked, cap);
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
 	return 0;
diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index 2ce2983..278777f 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -224,7 +224,7 @@ void rfkill_destroy(struct rfkill *rfkill);
  * should be blocked) so that drivers need not keep track of the soft
  * block state -- which they might not be able to.
  */
-bool __must_check rfkill_set_hw_state(struct rfkill *rfkill, bool blocked);
+bool rfkill_set_hw_state(struct rfkill *rfkill, bool blocked);
 
 /**
  * rfkill_set_sw_state - Set the internal rfkill software block state
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index ba2643a..7836ee9 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -83,6 +83,7 @@ endmenu
 config MAC80211_MESH
 	bool "Enable mac80211 mesh networking (pre-802.11s) support"
 	depends on MAC80211 && EXPERIMENTAL
+	depends on BROKEN
 	---help---
 	 This options enables support of Draft 802.11s mesh networking.
 	 The implementation is based on Draft 1.08 of the Mesh Networking
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 3c72557..479597e 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -175,6 +175,8 @@ int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata)
 	int err = 0;
 	u32 hash_idx;
 
+	might_sleep();
+
 	if (memcmp(dst, sdata->dev->dev_addr, ETH_ALEN) == 0)
 		/* never add ourselves as neighbours */
 		return -ENOTSUPP;
@@ -265,6 +267,7 @@ int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata)
 	int err = 0;
 	u32 hash_idx;
 
+	might_sleep();
 
 	if (memcmp(dst, sdata->dev->dev_addr, ETH_ALEN) == 0)
 		/* never add ourselves as neighbours */
@@ -491,8 +494,10 @@ void mesh_path_tx_pending(struct mesh_path *mpath)
  * @skb: frame to discard
  * @sdata: network subif the frame was to be sent through
  *
- * If the frame was beign forwarded from another MP, a PERR frame will be sent
- * to the precursor.
+ * If the frame was being forwarded from another MP, a PERR frame will be sent
+ * to the precursor.  The precursor's address (i.e. the previous hop) was saved
+ * in addr1 of the frame-to-be-forwarded, and would only be overwritten once
+ * the destination is successfully resolved.
  *
  * Locking: the function must me called within a rcu_read_lock region
  */
@@ -507,7 +512,7 @@ void mesh_path_discard_frame(struct sk_buff *skb,
 		u8 *ra, *da;
 
 		da = hdr->addr3;
-		ra = hdr->addr2;
+		ra = hdr->addr1;
 		mpath = mesh_path_lookup(da, sdata);
 		if (mpath)
 			dsn = ++mpath->dsn;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index d238a89..3a8922c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1455,7 +1455,7 @@ int ieee80211_master_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		monitor_iface = UNKNOWN_ADDRESS;
 
 		len_rthdr = ieee80211_get_radiotap_len(skb->data);
-		hdr = (struct ieee80211_hdr *)skb->data + len_rthdr;
+		hdr = (struct ieee80211_hdr *)(skb->data + len_rthdr);
 		hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
 		/* check the header is complete in the frame */
diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 79693fe..2fc4a17 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -549,6 +549,10 @@ void rfkill_set_states(struct rfkill *rfkill, bool sw, bool hw)
 	swprev = !!(rfkill->state & RFKILL_BLOCK_SW);
 	hwprev = !!(rfkill->state & RFKILL_BLOCK_HW);
 	__rfkill_set_sw_state(rfkill, sw);
+	if (hw)
+		rfkill->state |= RFKILL_BLOCK_HW;
+	else
+		rfkill->state &= ~RFKILL_BLOCK_HW;
 
 	spin_unlock_irqrestore(&rfkill->lock, flags);
 
@@ -648,15 +652,26 @@ static ssize_t rfkill_state_store(struct device *dev,
 				  struct device_attribute *attr,
 				  const char *buf, size_t count)
 {
-	/*
-	 * The intention was that userspace can only take control over
-	 * a given device when/if rfkill-input doesn't control it due
-	 * to user_claim. Since user_claim is currently unsupported,
-	 * we never support changing the state from userspace -- this
-	 * can be implemented again later.
-	 */
+	struct rfkill *rfkill = to_rfkill(dev);
+	unsigned long state;
+	int err;
+
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	err = strict_strtoul(buf, 0, &state);
+	if (err)
+		return err;
+
+	if (state != RFKILL_USER_STATE_SOFT_BLOCKED &&
+	    state != RFKILL_USER_STATE_UNBLOCKED)
+		return -EINVAL;
+
+	mutex_lock(&rfkill_global_mutex);
+	rfkill_set_block(rfkill, state == RFKILL_USER_STATE_SOFT_BLOCKED);
+	mutex_unlock(&rfkill_global_mutex);
 
-	return -EPERM;
+	return err ?: count;
 }
 
 static ssize_t rfkill_claim_show(struct device *dev,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 43bdb13..634496b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -997,7 +997,7 @@ static int nl80211_get_key(struct sk_buff *skb, struct genl_info *info)
 
 	if (IS_ERR(hdr)) {
 		err = PTR_ERR(hdr);
-		goto out;
+		goto free_msg;
 	}
 
 	cookie.msg = msg;
@@ -1011,7 +1011,7 @@ static int nl80211_get_key(struct sk_buff *skb, struct genl_info *info)
 				&cookie, get_key_callback);
 
 	if (err)
-		goto out;
+		goto free_msg;
 
 	if (cookie.error)
 		goto nla_put_failure;
@@ -1022,6 +1022,7 @@ static int nl80211_get_key(struct sk_buff *skb, struct genl_info *info)
 
  nla_put_failure:
 	err = -ENOBUFS;
+ free_msg:
 	nlmsg_free(msg);
  out:
 	cfg80211_put_dev(drv);
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index f8e71b3..9271118 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -35,8 +35,6 @@ void cfg80211_scan_done(struct cfg80211_scan_request *request, bool aborted)
 	else
 		nl80211_send_scan_done(wiphy_to_dev(request->wiphy), dev);
 
-	wiphy_to_dev(request->wiphy)->scan_req = NULL;
-
 #ifdef CONFIG_WIRELESS_EXT
 	if (!aborted) {
 		memset(&wrqu, 0, sizeof(wrqu));
@@ -48,6 +46,7 @@ void cfg80211_scan_done(struct cfg80211_scan_request *request, bool aborted)
 	dev_put(dev);
 
  out:
+	wiphy_to_dev(request->wiphy)->scan_req = NULL;
 	kfree(request);
 }
 EXPORT_SYMBOL(cfg80211_scan_done);
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
