Return-Path: <linux-kernel-owner+w=401wt.eu-S1759902AbYJVWYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759902AbYJVWYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 18:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132AbYJVWX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 18:23:56 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41915 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbYJVWXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 18:23:55 -0400
Date: Wed, 22 Oct 2008 18:23:08 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: pull request: wireless-2.6 2008-10-22
Message-ID: <20081022222308.GN15808@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

Another few fixes intended for 2.6.27...  The orinoco one corrects
a problem running with 4k stacks.  The other two fix oopses.

Please let me know if there are problems!

Thanks,

John

---

Individual patches are available here:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/

---

The following changes since commit 75e3d8db531b462b875c1adb13eeb6b0be7374c0:
  Ilpo Järvinen (1):
        tcp: should use number of sack blocks instead of -1

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git master

Andrey Borzenkov (1):
      orinoco: reduce stack usage in firmware download path

Bob Copeland (1):
      ath5k: fix suspend-related oops on rmmod

Christian Lamparter (1):
      p54: enable 2.4/5GHz spectrum by eeprom bits.

 drivers/net/wireless/ath5k/base.c    |   27 +++++++++++++++------
 drivers/net/wireless/ath5k/base.h    |    3 +-
 drivers/net/wireless/orinoco.c       |   42 +++++++++++++++++++++++----------
 drivers/net/wireless/p54/p54common.c |   28 ++++++++--------------
 4 files changed, 60 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 9b95c40..0f1d6bd 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -340,9 +340,9 @@ static inline u64 ath5k_extend_tsf(struct ath5k_hw *ah, u32 rstamp)
 }
 
 /* Interrupt handling */
-static int 	ath5k_init(struct ath5k_softc *sc);
+static int 	ath5k_init(struct ath5k_softc *sc, bool is_resume);
 static int 	ath5k_stop_locked(struct ath5k_softc *sc);
-static int 	ath5k_stop_hw(struct ath5k_softc *sc);
+static int 	ath5k_stop_hw(struct ath5k_softc *sc, bool is_suspend);
 static irqreturn_t ath5k_intr(int irq, void *dev_id);
 static void 	ath5k_tasklet_reset(unsigned long data);
 
@@ -646,7 +646,7 @@ ath5k_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	ath5k_led_off(sc);
 
-	ath5k_stop_hw(sc);
+	ath5k_stop_hw(sc, true);
 
 	free_irq(pdev->irq, sc);
 	pci_save_state(pdev);
@@ -683,7 +683,7 @@ ath5k_pci_resume(struct pci_dev *pdev)
 		goto err_no_irq;
 	}
 
-	err = ath5k_init(sc);
+	err = ath5k_init(sc, true);
 	if (err)
 		goto err_irq;
 	ath5k_led_enable(sc);
@@ -2200,12 +2200,17 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 \********************/
 
 static int
-ath5k_init(struct ath5k_softc *sc)
+ath5k_init(struct ath5k_softc *sc, bool is_resume)
 {
 	int ret;
 
 	mutex_lock(&sc->lock);
 
+	if (is_resume && !test_bit(ATH_STAT_STARTED, sc->status))
+		goto out_ok;
+
+	__clear_bit(ATH_STAT_STARTED, sc->status);
+
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "mode %d\n", sc->opmode);
 
 	/*
@@ -2230,12 +2235,15 @@ ath5k_init(struct ath5k_softc *sc)
 	if (ret)
 		goto done;
 
+	__set_bit(ATH_STAT_STARTED, sc->status);
+
 	/* Set ack to be sent at low bit-rates */
 	ath5k_hw_set_ack_bitrate_high(sc->ah, false);
 
 	mod_timer(&sc->calib_tim, round_jiffies(jiffies +
 			msecs_to_jiffies(ath5k_calinterval * 1000)));
 
+out_ok:
 	ret = 0;
 done:
 	mmiowb();
@@ -2290,7 +2298,7 @@ ath5k_stop_locked(struct ath5k_softc *sc)
  * stop is preempted).
  */
 static int
-ath5k_stop_hw(struct ath5k_softc *sc)
+ath5k_stop_hw(struct ath5k_softc *sc, bool is_suspend)
 {
 	int ret;
 
@@ -2321,6 +2329,9 @@ ath5k_stop_hw(struct ath5k_softc *sc)
 		}
 	}
 	ath5k_txbuf_free(sc, sc->bbuf);
+	if (!is_suspend)
+		__clear_bit(ATH_STAT_STARTED, sc->status);
+
 	mmiowb();
 	mutex_unlock(&sc->lock);
 
@@ -2718,12 +2729,12 @@ ath5k_reset_wake(struct ath5k_softc *sc)
 
 static int ath5k_start(struct ieee80211_hw *hw)
 {
-	return ath5k_init(hw->priv);
+	return ath5k_init(hw->priv, false);
 }
 
 static void ath5k_stop(struct ieee80211_hw *hw)
 {
-	ath5k_stop_hw(hw->priv);
+	ath5k_stop_hw(hw->priv, false);
 }
 
 static int ath5k_add_interface(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath5k/base.h
index 9d0b728..06d1054 100644
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -128,11 +128,12 @@ struct ath5k_softc {
 	size_t			desc_len;	/* size of TX/RX descriptors */
 	u16			cachelsz;	/* cache line size */
 
-	DECLARE_BITMAP(status, 4);
+	DECLARE_BITMAP(status, 5);
 #define ATH_STAT_INVALID	0		/* disable hardware accesses */
 #define ATH_STAT_MRRETRY	1		/* multi-rate retry support */
 #define ATH_STAT_PROMISC	2
 #define ATH_STAT_LEDSOFT	3		/* enable LED gpio status */
+#define ATH_STAT_STARTED	4		/* opened & irqs enabled */
 
 	unsigned int		filter_flags;	/* HW flags, AR5K_RX_FILTER_* */
 	unsigned int		curmode;	/* current phy mode */
diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 5090477..e0512e4 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -433,7 +433,7 @@ struct fw_info {
 const static struct fw_info orinoco_fw[] = {
 	{ "", "agere_sta_fw.bin", "agere_ap_fw.bin", 0x00390000, 1000 },
 	{ "", "prism_sta_fw.bin", "prism_ap_fw.bin", 0, 1024 },
-	{ "symbol_sp24t_prim_fw", "symbol_sp24t_sec_fw", "", 0x00003100, 0x100 }
+	{ "symbol_sp24t_prim_fw", "symbol_sp24t_sec_fw", "", 0x00003100, 512 }
 };
 
 /* Structure used to access fields in FW
@@ -458,7 +458,7 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 		    int ap)
 {
 	/* Plug Data Area (PDA) */
-	__le16 pda[512] = { 0 };
+	__le16 *pda;
 
 	hermes_t *hw = &priv->hw;
 	const struct firmware *fw_entry;
@@ -467,7 +467,11 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 	const unsigned char *end;
 	const char *firmware;
 	struct net_device *dev = priv->ndev;
-	int err;
+	int err = 0;
+
+	pda = kzalloc(fw->pda_size, GFP_KERNEL);
+	if (!pda)
+		return -ENOMEM;
 
 	if (ap)
 		firmware = fw->ap_fw;
@@ -478,17 +482,17 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 	       dev->name, firmware);
 
 	/* Read current plug data */
-	err = hermes_read_pda(hw, pda, fw->pda_addr,
-			      min_t(u16, fw->pda_size, sizeof(pda)), 0);
+	err = hermes_read_pda(hw, pda, fw->pda_addr, fw->pda_size, 0);
 	printk(KERN_DEBUG "%s: Read PDA returned %d\n", dev->name, err);
 	if (err)
-		return err;
+		goto free;
 
 	err = request_firmware(&fw_entry, firmware, priv->dev);
 	if (err) {
 		printk(KERN_ERR "%s: Cannot find firmware %s\n",
 		       dev->name, firmware);
-		return -ENOENT;
+		err = -ENOENT;
+		goto free;
 	}
 
 	hdr = (const struct orinoco_fw_header *) fw_entry->data;
@@ -532,6 +536,9 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 
 abort:
 	release_firmware(fw_entry);
+
+free:
+	kfree(pda);
 	return err;
 }
 
@@ -549,12 +556,12 @@ symbol_dl_image(struct orinoco_private *priv, const struct fw_info *fw,
 		int secondary)
 {
 	hermes_t *hw = &priv->hw;
-	int ret;
+	int ret = 0;
 	const unsigned char *ptr;
 	const unsigned char *first_block;
 
 	/* Plug Data Area (PDA) */
-	__le16 pda[256];
+	__le16 *pda = NULL;
 
 	/* Binary block begins after the 0x1A marker */
 	ptr = image;
@@ -563,28 +570,33 @@ symbol_dl_image(struct orinoco_private *priv, const struct fw_info *fw,
 
 	/* Read the PDA from EEPROM */
 	if (secondary) {
-		ret = hermes_read_pda(hw, pda, fw->pda_addr, sizeof(pda), 1);
+		pda = kzalloc(fw->pda_size, GFP_KERNEL);
+		if (!pda)
+			return -ENOMEM;
+
+		ret = hermes_read_pda(hw, pda, fw->pda_addr, fw->pda_size, 1);
 		if (ret)
-			return ret;
+			goto free;
 	}
 
 	/* Stop the firmware, so that it can be safely rewritten */
 	if (priv->stop_fw) {
 		ret = priv->stop_fw(priv, 1);
 		if (ret)
-			return ret;
+			goto free;
 	}
 
 	/* Program the adapter with new firmware */
 	ret = hermes_program(hw, first_block, end);
 	if (ret)
-		return ret;
+		goto free;
 
 	/* Write the PDA to the adapter */
 	if (secondary) {
 		size_t len = hermes_blocks_length(first_block);
 		ptr = first_block + len;
 		ret = hermes_apply_pda(hw, ptr, pda);
+		kfree(pda);
 		if (ret)
 			return ret;
 	}
@@ -608,6 +620,10 @@ symbol_dl_image(struct orinoco_private *priv, const struct fw_info *fw,
 		return -ENODEV;
 
 	return 0;
+
+free:
+	kfree(pda);
+	return ret;
 }
 
 
diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index 117c7d3..2d022f8 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -306,8 +306,8 @@ static int p54_convert_rev1(struct ieee80211_hw *dev,
 	return 0;
 }
 
-static const char *p54_rf_chips[] = { "NULL", "Indigo?", "Duette",
-                              "Frisbee", "Xbow", "Longbow" };
+static const char *p54_rf_chips[] = { "NULL", "Duette3", "Duette2",
+                              "Frisbee", "Xbow", "Longbow", "NULL", "NULL" };
 static int p54_init_xbow_synth(struct ieee80211_hw *dev);
 
 static int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
@@ -319,6 +319,7 @@ static int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 	void *tmp;
 	int err;
 	u8 *end = (u8 *)eeprom + len;
+	u16 synth;
 	DECLARE_MAC_BUF(mac);
 
 	wrap = (struct eeprom_pda_wrap *) eeprom;
@@ -400,8 +401,8 @@ static int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 			tmp = entry->data;
 			while ((u8 *)tmp < entry->data + data_len) {
 				struct bootrec_exp_if *exp_if = tmp;
-				if (le16_to_cpu(exp_if->if_id) == 0xF)
-					priv->rxhw = le16_to_cpu(exp_if->variant) & 0x07;
+				if (le16_to_cpu(exp_if->if_id) == 0xf)
+					synth = le16_to_cpu(exp_if->variant);
 				tmp += sizeof(struct bootrec_exp_if);
 			}
 			break;
@@ -427,22 +428,13 @@ static int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 		goto err;
 	}
 
-	switch (priv->rxhw) {
-	case 4: /* XBow */
+	priv->rxhw = synth & 0x07;
+	if (priv->rxhw == 4)
 		p54_init_xbow_synth(dev);
-	case 1: /* Indigo? */
-	case 2: /* Duette */
-		dev->wiphy->bands[IEEE80211_BAND_5GHZ] = &band_5GHz;
-	case 3: /* Frisbee */
-	case 5: /* Longbow */
+	if (!(synth & 0x40))
 		dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &band_2GHz;
-		break;
-	default:
-		printk(KERN_ERR "%s: unsupported RF-Chip\n",
-			wiphy_name(dev->wiphy));
-		err = -EINVAL;
-		goto err;
-	}
+	if (!(synth & 0x80))
+		dev->wiphy->bands[IEEE80211_BAND_5GHZ] = &band_5GHz;
 
 	if (!is_valid_ether_addr(dev->wiphy->perm_addr)) {
 		u8 perm_addr[ETH_ALEN];
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
