Return-Path: <linux-kernel-owner+w=401wt.eu-S932536AbZKDRhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536AbZKDRhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932525AbZKDRhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:37:32 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:57630 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522AbZKDRhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:37:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=gvz+WGj8CYnBDhtPlDKODf5qAjrAtU/qbVz2LXXXnFomwGYer9+XdA4RNzrCcxEs8Q
         ocANmVcI4OvYROrN0oKNSqfBSj/E2XLwCJNAj7+mGoQdScaRqVJ9iBfn7101NE467bL3
         GoAKCemUNFxhv8jfuIF2FdqPKSQngMBI/pvbI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:37:05 +0100
Message-Id: <20091104173705.28463.81484.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 41/41] rt2800: add rt2800lib (part four)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800: add rt2800lib (part four)

Code unification.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |  157 +++++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800lib.h |    2 
 drivers/net/wireless/rt2x00/rt2800pci.c |  157 -------------------------------
 drivers/net/wireless/rt2x00/rt2800usb.c |  158 --------------------------------
 4 files changed, 161 insertions(+), 313 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800lib.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1658,3 +1658,160 @@ int rt2800_init_rfcsr(struct rt2x00_dev 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2800_init_rfcsr);
+
+/*
+ * IEEE80211 stack callback functions.
+ */
+static void rt2800_get_tkip_seq(struct ieee80211_hw *hw, u8 hw_key_idx,
+				u32 *iv32, u16 *iv16)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct mac_iveiv_entry iveiv_entry;
+	u32 offset;
+
+	offset = MAC_IVEIV_ENTRY(hw_key_idx);
+	rt2800_register_multiread(rt2x00dev, offset,
+				      &iveiv_entry, sizeof(iveiv_entry));
+
+	memcpy(&iveiv_entry.iv[0], iv16, sizeof(iv16));
+	memcpy(&iveiv_entry.iv[4], iv32, sizeof(iv32));
+}
+
+static int rt2800_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	u32 reg;
+	bool enabled = (value < IEEE80211_MAX_RTS_THRESHOLD);
+
+	rt2800_register_read(rt2x00dev, TX_RTS_CFG, &reg);
+	rt2x00_set_field32(&reg, TX_RTS_CFG_RTS_THRES, value);
+	rt2800_register_write(rt2x00dev, TX_RTS_CFG, reg);
+
+	rt2800_register_read(rt2x00dev, CCK_PROT_CFG, &reg);
+	rt2x00_set_field32(&reg, CCK_PROT_CFG_RTS_TH_EN, enabled);
+	rt2800_register_write(rt2x00dev, CCK_PROT_CFG, reg);
+
+	rt2800_register_read(rt2x00dev, OFDM_PROT_CFG, &reg);
+	rt2x00_set_field32(&reg, OFDM_PROT_CFG_RTS_TH_EN, enabled);
+	rt2800_register_write(rt2x00dev, OFDM_PROT_CFG, reg);
+
+	rt2800_register_read(rt2x00dev, MM20_PROT_CFG, &reg);
+	rt2x00_set_field32(&reg, MM20_PROT_CFG_RTS_TH_EN, enabled);
+	rt2800_register_write(rt2x00dev, MM20_PROT_CFG, reg);
+
+	rt2800_register_read(rt2x00dev, MM40_PROT_CFG, &reg);
+	rt2x00_set_field32(&reg, MM40_PROT_CFG_RTS_TH_EN, enabled);
+	rt2800_register_write(rt2x00dev, MM40_PROT_CFG, reg);
+
+	rt2800_register_read(rt2x00dev, GF20_PROT_CFG, &reg);
+	rt2x00_set_field32(&reg, GF20_PROT_CFG_RTS_TH_EN, enabled);
+	rt2800_register_write(rt2x00dev, GF20_PROT_CFG, reg);
+
+	rt2800_register_read(rt2x00dev, GF40_PROT_CFG, &reg);
+	rt2x00_set_field32(&reg, GF40_PROT_CFG_RTS_TH_EN, enabled);
+	rt2800_register_write(rt2x00dev, GF40_PROT_CFG, reg);
+
+	return 0;
+}
+
+static int rt2800_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
+			  const struct ieee80211_tx_queue_params *params)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct data_queue *queue;
+	struct rt2x00_field32 field;
+	int retval;
+	u32 reg;
+	u32 offset;
+
+	/*
+	 * First pass the configuration through rt2x00lib, that will
+	 * update the queue settings and validate the input. After that
+	 * we are free to update the registers based on the value
+	 * in the queue parameter.
+	 */
+	retval = rt2x00mac_conf_tx(hw, queue_idx, params);
+	if (retval)
+		return retval;
+
+	/*
+	 * We only need to perform additional register initialization
+	 * for WMM queues/
+	 */
+	if (queue_idx >= 4)
+		return 0;
+
+	queue = rt2x00queue_get_queue(rt2x00dev, queue_idx);
+
+	/* Update WMM TXOP register */
+	offset = WMM_TXOP0_CFG + (sizeof(u32) * (!!(queue_idx & 2)));
+	field.bit_offset = (queue_idx & 1) * 16;
+	field.bit_mask = 0xffff << field.bit_offset;
+
+	rt2800_register_read(rt2x00dev, offset, &reg);
+	rt2x00_set_field32(&reg, field, queue->txop);
+	rt2800_register_write(rt2x00dev, offset, reg);
+
+	/* Update WMM registers */
+	field.bit_offset = queue_idx * 4;
+	field.bit_mask = 0xf << field.bit_offset;
+
+	rt2800_register_read(rt2x00dev, WMM_AIFSN_CFG, &reg);
+	rt2x00_set_field32(&reg, field, queue->aifs);
+	rt2800_register_write(rt2x00dev, WMM_AIFSN_CFG, reg);
+
+	rt2800_register_read(rt2x00dev, WMM_CWMIN_CFG, &reg);
+	rt2x00_set_field32(&reg, field, queue->cw_min);
+	rt2800_register_write(rt2x00dev, WMM_CWMIN_CFG, reg);
+
+	rt2800_register_read(rt2x00dev, WMM_CWMAX_CFG, &reg);
+	rt2x00_set_field32(&reg, field, queue->cw_max);
+	rt2800_register_write(rt2x00dev, WMM_CWMAX_CFG, reg);
+
+	/* Update EDCA registers */
+	offset = EDCA_AC0_CFG + (sizeof(u32) * queue_idx);
+
+	rt2800_register_read(rt2x00dev, offset, &reg);
+	rt2x00_set_field32(&reg, EDCA_AC0_CFG_TX_OP, queue->txop);
+	rt2x00_set_field32(&reg, EDCA_AC0_CFG_AIFSN, queue->aifs);
+	rt2x00_set_field32(&reg, EDCA_AC0_CFG_CWMIN, queue->cw_min);
+	rt2x00_set_field32(&reg, EDCA_AC0_CFG_CWMAX, queue->cw_max);
+	rt2800_register_write(rt2x00dev, offset, reg);
+
+	return 0;
+}
+
+static u64 rt2800_get_tsf(struct ieee80211_hw *hw)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	u64 tsf;
+	u32 reg;
+
+	rt2800_register_read(rt2x00dev, TSF_TIMER_DW1, &reg);
+	tsf = (u64) rt2x00_get_field32(reg, TSF_TIMER_DW1_HIGH_WORD) << 32;
+	rt2800_register_read(rt2x00dev, TSF_TIMER_DW0, &reg);
+	tsf |= rt2x00_get_field32(reg, TSF_TIMER_DW0_LOW_WORD);
+
+	return tsf;
+}
+
+const struct ieee80211_ops rt2800_mac80211_ops = {
+	.tx			= rt2x00mac_tx,
+	.start			= rt2x00mac_start,
+	.stop			= rt2x00mac_stop,
+	.add_interface		= rt2x00mac_add_interface,
+	.remove_interface	= rt2x00mac_remove_interface,
+	.config			= rt2x00mac_config,
+	.configure_filter	= rt2x00mac_configure_filter,
+	.set_tim		= rt2x00mac_set_tim,
+	.set_key		= rt2x00mac_set_key,
+	.get_stats		= rt2x00mac_get_stats,
+	.get_tkip_seq		= rt2800_get_tkip_seq,
+	.set_rts_threshold	= rt2800_set_rts_threshold,
+	.bss_info_changed	= rt2x00mac_bss_info_changed,
+	.conf_tx		= rt2800_conf_tx,
+	.get_tx_stats		= rt2x00mac_get_tx_stats,
+	.get_tsf		= rt2800_get_tsf,
+	.rfkill_poll		= rt2x00mac_rfkill_poll,
+};
+EXPORT_SYMBOL_GPL(rt2800_mac80211_ops);
Index: b/drivers/net/wireless/rt2x00/rt2800lib.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -129,4 +129,6 @@ int rt2800_init_registers(struct rt2x00_
 int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev);
 int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev);
 
+extern const struct ieee80211_ops rt2800_mac80211_ops;
+
 #endif /* RT2800LIB_H */
Index: b/drivers/net/wireless/rt2x00/rt2800pci.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1513,161 +1513,6 @@ static int rt2800pci_probe_hw(struct rt2
 	return 0;
 }
 
-/*
- * IEEE80211 stack callback functions.
- */
-static void rt2800pci_get_tkip_seq(struct ieee80211_hw *hw, u8 hw_key_idx,
-				   u32 *iv32, u16 *iv16)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct mac_iveiv_entry iveiv_entry;
-	u32 offset;
-
-	offset = MAC_IVEIV_ENTRY(hw_key_idx);
-	rt2800_register_multiread(rt2x00dev, offset,
-				      &iveiv_entry, sizeof(iveiv_entry));
-
-	memcpy(&iveiv_entry.iv[0], iv16, sizeof(iv16));
-	memcpy(&iveiv_entry.iv[4], iv32, sizeof(iv32));
-}
-
-static int rt2800pci_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	u32 reg;
-	bool enabled = (value < IEEE80211_MAX_RTS_THRESHOLD);
-
-	rt2800_register_read(rt2x00dev, TX_RTS_CFG, &reg);
-	rt2x00_set_field32(&reg, TX_RTS_CFG_RTS_THRES, value);
-	rt2800_register_write(rt2x00dev, TX_RTS_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, CCK_PROT_CFG, &reg);
-	rt2x00_set_field32(&reg, CCK_PROT_CFG_RTS_TH_EN, enabled);
-	rt2800_register_write(rt2x00dev, CCK_PROT_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, OFDM_PROT_CFG, &reg);
-	rt2x00_set_field32(&reg, OFDM_PROT_CFG_RTS_TH_EN, enabled);
-	rt2800_register_write(rt2x00dev, OFDM_PROT_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, MM20_PROT_CFG, &reg);
-	rt2x00_set_field32(&reg, MM20_PROT_CFG_RTS_TH_EN, enabled);
-	rt2800_register_write(rt2x00dev, MM20_PROT_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, MM40_PROT_CFG, &reg);
-	rt2x00_set_field32(&reg, MM40_PROT_CFG_RTS_TH_EN, enabled);
-	rt2800_register_write(rt2x00dev, MM40_PROT_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, GF20_PROT_CFG, &reg);
-	rt2x00_set_field32(&reg, GF20_PROT_CFG_RTS_TH_EN, enabled);
-	rt2800_register_write(rt2x00dev, GF20_PROT_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, GF40_PROT_CFG, &reg);
-	rt2x00_set_field32(&reg, GF40_PROT_CFG_RTS_TH_EN, enabled);
-	rt2800_register_write(rt2x00dev, GF40_PROT_CFG, reg);
-
-	return 0;
-}
-
-static int rt2800pci_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
-			     const struct ieee80211_tx_queue_params *params)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct data_queue *queue;
-	struct rt2x00_field32 field;
-	int retval;
-	u32 reg;
-	u32 offset;
-
-	/*
-	 * First pass the configuration through rt2x00lib, that will
-	 * update the queue settings and validate the input. After that
-	 * we are free to update the registers based on the value
-	 * in the queue parameter.
-	 */
-	retval = rt2x00mac_conf_tx(hw, queue_idx, params);
-	if (retval)
-		return retval;
-
-	/*
-	 * We only need to perform additional register initialization
-	 * for WMM queues/
-	 */
-	if (queue_idx >= 4)
-		return 0;
-
-	queue = rt2x00queue_get_queue(rt2x00dev, queue_idx);
-
-	/* Update WMM TXOP register */
-	offset = WMM_TXOP0_CFG + (sizeof(u32) * (!!(queue_idx & 2)));
-	field.bit_offset = (queue_idx & 1) * 16;
-	field.bit_mask = 0xffff << field.bit_offset;
-
-	rt2800_register_read(rt2x00dev, offset, &reg);
-	rt2x00_set_field32(&reg, field, queue->txop);
-	rt2800_register_write(rt2x00dev, offset, reg);
-
-	/* Update WMM registers */
-	field.bit_offset = queue_idx * 4;
-	field.bit_mask = 0xf << field.bit_offset;
-
-	rt2800_register_read(rt2x00dev, WMM_AIFSN_CFG, &reg);
-	rt2x00_set_field32(&reg, field, queue->aifs);
-	rt2800_register_write(rt2x00dev, WMM_AIFSN_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, WMM_CWMIN_CFG, &reg);
-	rt2x00_set_field32(&reg, field, queue->cw_min);
-	rt2800_register_write(rt2x00dev, WMM_CWMIN_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, WMM_CWMAX_CFG, &reg);
-	rt2x00_set_field32(&reg, field, queue->cw_max);
-	rt2800_register_write(rt2x00dev, WMM_CWMAX_CFG, reg);
-
-	/* Update EDCA registers */
-	offset = EDCA_AC0_CFG + (sizeof(u32) * queue_idx);
-
-	rt2800_register_read(rt2x00dev, offset, &reg);
-	rt2x00_set_field32(&reg, EDCA_AC0_CFG_TX_OP, queue->txop);
-	rt2x00_set_field32(&reg, EDCA_AC0_CFG_AIFSN, queue->aifs);
-	rt2x00_set_field32(&reg, EDCA_AC0_CFG_CWMIN, queue->cw_min);
-	rt2x00_set_field32(&reg, EDCA_AC0_CFG_CWMAX, queue->cw_max);
-	rt2800_register_write(rt2x00dev, offset, reg);
-
-	return 0;
-}
-
-static u64 rt2800pci_get_tsf(struct ieee80211_hw *hw)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	u64 tsf;
-	u32 reg;
-
-	rt2800_register_read(rt2x00dev, TSF_TIMER_DW1, &reg);
-	tsf = (u64) rt2x00_get_field32(reg, TSF_TIMER_DW1_HIGH_WORD) << 32;
-	rt2800_register_read(rt2x00dev, TSF_TIMER_DW0, &reg);
-	tsf |= rt2x00_get_field32(reg, TSF_TIMER_DW0_LOW_WORD);
-
-	return tsf;
-}
-
-static const struct ieee80211_ops rt2800pci_mac80211_ops = {
-	.tx			= rt2x00mac_tx,
-	.start			= rt2x00mac_start,
-	.stop			= rt2x00mac_stop,
-	.add_interface		= rt2x00mac_add_interface,
-	.remove_interface	= rt2x00mac_remove_interface,
-	.config			= rt2x00mac_config,
-	.configure_filter	= rt2x00mac_configure_filter,
-	.set_key		= rt2x00mac_set_key,
-	.get_stats		= rt2x00mac_get_stats,
-	.get_tkip_seq		= rt2800pci_get_tkip_seq,
-	.set_rts_threshold	= rt2800pci_set_rts_threshold,
-	.bss_info_changed	= rt2x00mac_bss_info_changed,
-	.conf_tx		= rt2800pci_conf_tx,
-	.get_tx_stats		= rt2x00mac_get_tx_stats,
-	.get_tsf		= rt2800pci_get_tsf,
-	.rfkill_poll		= rt2x00mac_rfkill_poll,
-};
-
 static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.irq_handler		= rt2800pci_interrupt,
 	.probe_hw		= rt2800pci_probe_hw,
@@ -1730,7 +1575,7 @@ static const struct rt2x00_ops rt2800pci
 	.tx		= &rt2800pci_queue_tx,
 	.bcn		= &rt2800pci_queue_bcn,
 	.lib		= &rt2800pci_rt2x00_ops,
-	.hw		= &rt2800pci_mac80211_ops,
+	.hw		= &rt2800_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 	.debugfs	= &rt2800_rt2x00debug,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
Index: b/drivers/net/wireless/rt2x00/rt2800usb.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1119,162 +1119,6 @@ static int rt2800usb_probe_hw(struct rt2
 	return 0;
 }
 
-/*
- * IEEE80211 stack callback functions.
- */
-static void rt2800usb_get_tkip_seq(struct ieee80211_hw *hw, u8 hw_key_idx,
-				   u32 *iv32, u16 *iv16)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct mac_iveiv_entry iveiv_entry;
-	u32 offset;
-
-	offset = MAC_IVEIV_ENTRY(hw_key_idx);
-	rt2800_register_multiread(rt2x00dev, offset,
-				      &iveiv_entry, sizeof(iveiv_entry));
-
-	memcpy(&iveiv_entry.iv[0], iv16, sizeof(iv16));
-	memcpy(&iveiv_entry.iv[4], iv32, sizeof(iv32));
-}
-
-static int rt2800usb_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	u32 reg;
-	bool enabled = (value < IEEE80211_MAX_RTS_THRESHOLD);
-
-	rt2800_register_read(rt2x00dev, TX_RTS_CFG, &reg);
-	rt2x00_set_field32(&reg, TX_RTS_CFG_RTS_THRES, value);
-	rt2800_register_write(rt2x00dev, TX_RTS_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, CCK_PROT_CFG, &reg);
-	rt2x00_set_field32(&reg, CCK_PROT_CFG_RTS_TH_EN, enabled);
-	rt2800_register_write(rt2x00dev, CCK_PROT_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, OFDM_PROT_CFG, &reg);
-	rt2x00_set_field32(&reg, OFDM_PROT_CFG_RTS_TH_EN, enabled);
-	rt2800_register_write(rt2x00dev, OFDM_PROT_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, MM20_PROT_CFG, &reg);
-	rt2x00_set_field32(&reg, MM20_PROT_CFG_RTS_TH_EN, enabled);
-	rt2800_register_write(rt2x00dev, MM20_PROT_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, MM40_PROT_CFG, &reg);
-	rt2x00_set_field32(&reg, MM40_PROT_CFG_RTS_TH_EN, enabled);
-	rt2800_register_write(rt2x00dev, MM40_PROT_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, GF20_PROT_CFG, &reg);
-	rt2x00_set_field32(&reg, GF20_PROT_CFG_RTS_TH_EN, enabled);
-	rt2800_register_write(rt2x00dev, GF20_PROT_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, GF40_PROT_CFG, &reg);
-	rt2x00_set_field32(&reg, GF40_PROT_CFG_RTS_TH_EN, enabled);
-	rt2800_register_write(rt2x00dev, GF40_PROT_CFG, reg);
-
-	return 0;
-}
-
-static int rt2800usb_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
-			     const struct ieee80211_tx_queue_params *params)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct data_queue *queue;
-	struct rt2x00_field32 field;
-	int retval;
-	u32 reg;
-	u32 offset;
-
-	/*
-	 * First pass the configuration through rt2x00lib, that will
-	 * update the queue settings and validate the input. After that
-	 * we are free to update the registers based on the value
-	 * in the queue parameter.
-	 */
-	retval = rt2x00mac_conf_tx(hw, queue_idx, params);
-	if (retval)
-		return retval;
-
-	/*
-	 * We only need to perform additional register initialization
-	 * for WMM queues/
-	 */
-	if (queue_idx >= 4)
-		return 0;
-
-	queue = rt2x00queue_get_queue(rt2x00dev, queue_idx);
-
-	/* Update WMM TXOP register */
-	offset = WMM_TXOP0_CFG + (sizeof(u32) * (!!(queue_idx & 2)));
-	field.bit_offset = (queue_idx & 1) * 16;
-	field.bit_mask = 0xffff << field.bit_offset;
-
-	rt2800_register_read(rt2x00dev, offset, &reg);
-	rt2x00_set_field32(&reg, field, queue->txop);
-	rt2800_register_write(rt2x00dev, offset, reg);
-
-	/* Update WMM registers */
-	field.bit_offset = queue_idx * 4;
-	field.bit_mask = 0xf << field.bit_offset;
-
-	rt2800_register_read(rt2x00dev, WMM_AIFSN_CFG, &reg);
-	rt2x00_set_field32(&reg, field, queue->aifs);
-	rt2800_register_write(rt2x00dev, WMM_AIFSN_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, WMM_CWMIN_CFG, &reg);
-	rt2x00_set_field32(&reg, field, queue->cw_min);
-	rt2800_register_write(rt2x00dev, WMM_CWMIN_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, WMM_CWMAX_CFG, &reg);
-	rt2x00_set_field32(&reg, field, queue->cw_max);
-	rt2800_register_write(rt2x00dev, WMM_CWMAX_CFG, reg);
-
-	/* Update EDCA registers */
-	offset = EDCA_AC0_CFG + (sizeof(u32) * queue_idx);
-
-	rt2800_register_read(rt2x00dev, offset, &reg);
-	rt2x00_set_field32(&reg, EDCA_AC0_CFG_TX_OP, queue->txop);
-	rt2x00_set_field32(&reg, EDCA_AC0_CFG_AIFSN, queue->aifs);
-	rt2x00_set_field32(&reg, EDCA_AC0_CFG_CWMIN, queue->cw_min);
-	rt2x00_set_field32(&reg, EDCA_AC0_CFG_CWMAX, queue->cw_max);
-	rt2800_register_write(rt2x00dev, offset, reg);
-
-	return 0;
-}
-
-static u64 rt2800usb_get_tsf(struct ieee80211_hw *hw)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	u64 tsf;
-	u32 reg;
-
-	rt2800_register_read(rt2x00dev, TSF_TIMER_DW1, &reg);
-	tsf = (u64) rt2x00_get_field32(reg, TSF_TIMER_DW1_HIGH_WORD) << 32;
-	rt2800_register_read(rt2x00dev, TSF_TIMER_DW0, &reg);
-	tsf |= rt2x00_get_field32(reg, TSF_TIMER_DW0_LOW_WORD);
-
-	return tsf;
-}
-
-static const struct ieee80211_ops rt2800usb_mac80211_ops = {
-	.tx			= rt2x00mac_tx,
-	.start			= rt2x00mac_start,
-	.stop			= rt2x00mac_stop,
-	.add_interface		= rt2x00mac_add_interface,
-	.remove_interface	= rt2x00mac_remove_interface,
-	.config			= rt2x00mac_config,
-	.configure_filter	= rt2x00mac_configure_filter,
-	.set_tim		= rt2x00mac_set_tim,
-	.set_key		= rt2x00mac_set_key,
-	.get_stats		= rt2x00mac_get_stats,
-	.get_tkip_seq		= rt2800usb_get_tkip_seq,
-	.set_rts_threshold	= rt2800usb_set_rts_threshold,
-	.bss_info_changed	= rt2x00mac_bss_info_changed,
-	.conf_tx		= rt2800usb_conf_tx,
-	.get_tx_stats		= rt2x00mac_get_tx_stats,
-	.get_tsf		= rt2800usb_get_tsf,
-	.rfkill_poll		= rt2x00mac_rfkill_poll,
-};
-
 static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
 	.probe_hw		= rt2800usb_probe_hw,
 	.get_firmware_name	= rt2800usb_get_firmware_name,
@@ -1336,7 +1180,7 @@ static const struct rt2x00_ops rt2800usb
 	.tx		= &rt2800usb_queue_tx,
 	.bcn		= &rt2800usb_queue_bcn,
 	.lib		= &rt2800usb_rt2x00_ops,
-	.hw		= &rt2800usb_mac80211_ops,
+	.hw		= &rt2800_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 	.debugfs	= &rt2800_rt2x00debug,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
