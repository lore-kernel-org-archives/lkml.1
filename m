Return-Path: <linux-kernel-owner+w=401wt.eu-S1757528AbZKDRdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbZKDRdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbZKDRdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:33:39 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:5665 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757455AbZKDRdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:33:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=u9C/geWYbrn83TueEQ/f+b9w40cH5G9e3P1GzAqerEqzRzvYQctiadw+PflPi09Po7
         R/bZz/MILoZYsW8/sliJpuWevvP5xtk2BwtoTr1bh8zKoM6oS6kkg5mODTEK+Vm/+OTH
         mDSwi47j3liL51yI32ai569PEx+JBf4YYmUKs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:33:13 +0100
Message-Id: <20091104173313.28463.67108.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 10/41] rt2800pci: add rt2800_register_[read,write]() wrappers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800pci: add rt2800_register_[read,write]() wrappers

Part of preparations for later code unification.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |  479 ++++++++++++++++----------------
 drivers/net/wireless/rt2x00/rt2800pci.h |   21 +
 2 files changed, 261 insertions(+), 239 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800pci.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -57,7 +57,7 @@ MODULE_PARM_DESC(nohwcrypt, "Disable har
 /*
  * Register access.
  * All access to the CSR registers will go through the methods
- * rt2x00pci_register_read and rt2x00pci_register_write.
+ * rt2800_register_read and rt2800_register_write.
  * BBP and RF register require indirect register access,
  * and use the CSR registers BBPCSR and RFCSR to achieve this.
  * These indirect registers work with busy bits,
@@ -66,6 +66,7 @@ MODULE_PARM_DESC(nohwcrypt, "Disable har
  * between each attampt. When the busy bit is still set at that time,
  * the access attempt is considered to have failed,
  * and we will print an error.
+ * The _lock versions must be used if you already hold the csr_mutex
  */
 #define WAIT_FOR_BBP(__dev, __reg) \
 	rt2x00pci_regbusy_read((__dev), BBP_CSR_CFG, BBP_CSR_CFG_BUSY, (__reg))
@@ -96,7 +97,7 @@ static void rt2800pci_bbp_write(struct r
 		rt2x00_set_field32(&reg, BBP_CSR_CFG_READ_CONTROL, 0);
 		rt2x00_set_field32(&reg, BBP_CSR_CFG_BBP_RW_MODE, 1);
 
-		rt2x00pci_register_write(rt2x00dev, BBP_CSR_CFG, reg);
+		rt2800_register_write_lock(rt2x00dev, BBP_CSR_CFG, reg);
 	}
 
 	mutex_unlock(&rt2x00dev->csr_mutex);
@@ -124,7 +125,7 @@ static void rt2800pci_bbp_read(struct rt
 		rt2x00_set_field32(&reg, BBP_CSR_CFG_READ_CONTROL, 1);
 		rt2x00_set_field32(&reg, BBP_CSR_CFG_BBP_RW_MODE, 1);
 
-		rt2x00pci_register_write(rt2x00dev, BBP_CSR_CFG, reg);
+		rt2800_register_write_lock(rt2x00dev, BBP_CSR_CFG, reg);
 
 		WAIT_FOR_BBP(rt2x00dev, &reg);
 	}
@@ -152,7 +153,7 @@ static void rt2800pci_rfcsr_write(struct
 		rt2x00_set_field32(&reg, RF_CSR_CFG_WRITE, 1);
 		rt2x00_set_field32(&reg, RF_CSR_CFG_BUSY, 1);
 
-		rt2x00pci_register_write(rt2x00dev, RF_CSR_CFG, reg);
+		rt2800_register_write_lock(rt2x00dev, RF_CSR_CFG, reg);
 	}
 
 	mutex_unlock(&rt2x00dev->csr_mutex);
@@ -179,7 +180,7 @@ static void rt2800pci_rfcsr_read(struct 
 		rt2x00_set_field32(&reg, RF_CSR_CFG_WRITE, 0);
 		rt2x00_set_field32(&reg, RF_CSR_CFG_BUSY, 1);
 
-		rt2x00pci_register_write(rt2x00dev, RF_CSR_CFG, reg);
+		rt2800_register_write_lock(rt2x00dev, RF_CSR_CFG, reg);
 
 		WAIT_FOR_RFCSR(rt2x00dev, &reg);
 	}
@@ -207,7 +208,7 @@ static void rt2800pci_rf_write(struct rt
 		rt2x00_set_field32(&reg, RF_CSR_CFG0_SEL, 0);
 		rt2x00_set_field32(&reg, RF_CSR_CFG0_BUSY, 1);
 
-		rt2x00pci_register_write(rt2x00dev, RF_CSR_CFG0, reg);
+		rt2800_register_write_lock(rt2x00dev, RF_CSR_CFG0, reg);
 		rt2x00_rf_write(rt2x00dev, word, value);
 	}
 
@@ -238,11 +239,11 @@ static void rt2800pci_mcu_request(struct
 		rt2x00_set_field32(&reg, H2M_MAILBOX_CSR_CMD_TOKEN, token);
 		rt2x00_set_field32(&reg, H2M_MAILBOX_CSR_ARG0, arg0);
 		rt2x00_set_field32(&reg, H2M_MAILBOX_CSR_ARG1, arg1);
-		rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_CSR, reg);
+		rt2800_register_write_lock(rt2x00dev, H2M_MAILBOX_CSR, reg);
 
 		reg = 0;
 		rt2x00_set_field32(&reg, HOST_CMD_CSR_HOST_COMMAND, command);
-		rt2x00pci_register_write(rt2x00dev, HOST_CMD_CSR, reg);
+		rt2800_register_write_lock(rt2x00dev, HOST_CMD_CSR, reg);
 	}
 
 	mutex_unlock(&rt2x00dev->csr_mutex);
@@ -254,7 +255,7 @@ static void rt2800pci_mcu_status(struct 
 	u32 reg;
 
 	for (i = 0; i < 200; i++) {
-		rt2x00pci_register_read(rt2x00dev, H2M_MAILBOX_CID, &reg);
+		rt2800_register_read(rt2x00dev, H2M_MAILBOX_CID, &reg);
 
 		if ((rt2x00_get_field32(reg, H2M_MAILBOX_CID_CMD0) == token) ||
 		    (rt2x00_get_field32(reg, H2M_MAILBOX_CID_CMD1) == token) ||
@@ -268,8 +269,8 @@ static void rt2800pci_mcu_status(struct 
 	if (i == 200)
 		ERROR(rt2x00dev, "MCU request failed, no response from hardware\n");
 
-	rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_STATUS, ~0);
-	rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
+	rt2800_register_write(rt2x00dev, H2M_MAILBOX_STATUS, ~0);
+	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
 }
 
 #ifdef CONFIG_RT2800PCI_WISOC
@@ -291,7 +292,7 @@ static void rt2800pci_eepromregister_rea
 	struct rt2x00_dev *rt2x00dev = eeprom->data;
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, E2PROM_CSR, &reg);
+	rt2800_register_read(rt2x00dev, E2PROM_CSR, &reg);
 
 	eeprom->reg_data_in = !!rt2x00_get_field32(reg, E2PROM_CSR_DATA_IN);
 	eeprom->reg_data_out = !!rt2x00_get_field32(reg, E2PROM_CSR_DATA_OUT);
@@ -313,7 +314,7 @@ static void rt2800pci_eepromregister_wri
 	rt2x00_set_field32(&reg, E2PROM_CSR_CHIP_SELECT,
 			   !!eeprom->reg_chip_select);
 
-	rt2x00pci_register_write(rt2x00dev, E2PROM_CSR, reg);
+	rt2800_register_write(rt2x00dev, E2PROM_CSR, reg);
 }
 
 static void rt2800pci_read_eeprom_pci(struct rt2x00_dev *rt2x00dev)
@@ -321,7 +322,7 @@ static void rt2800pci_read_eeprom_pci(st
 	struct eeprom_93cx6 eeprom;
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, E2PROM_CSR, &reg);
+	rt2800_register_read(rt2x00dev, E2PROM_CSR, &reg);
 
 	eeprom.data = rt2x00dev;
 	eeprom.register_read = rt2800pci_eepromregister_read;
@@ -342,23 +343,23 @@ static void rt2800pci_efuse_read(struct 
 {
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, EFUSE_CTRL, &reg);
+	rt2800_register_read(rt2x00dev, EFUSE_CTRL, &reg);
 	rt2x00_set_field32(&reg, EFUSE_CTRL_ADDRESS_IN, i);
 	rt2x00_set_field32(&reg, EFUSE_CTRL_MODE, 0);
 	rt2x00_set_field32(&reg, EFUSE_CTRL_KICK, 1);
-	rt2x00pci_register_write(rt2x00dev, EFUSE_CTRL, reg);
+	rt2800_register_write(rt2x00dev, EFUSE_CTRL, reg);
 
 	/* Wait until the EEPROM has been loaded */
 	rt2x00pci_regbusy_read(rt2x00dev, EFUSE_CTRL, EFUSE_CTRL_KICK, &reg);
 
 	/* Apparently the data is read from end to start */
-	rt2x00pci_register_read(rt2x00dev, EFUSE_DATA3,
+	rt2800_register_read(rt2x00dev, EFUSE_DATA3,
 				(u32 *)&rt2x00dev->eeprom[i]);
-	rt2x00pci_register_read(rt2x00dev, EFUSE_DATA2,
+	rt2800_register_read(rt2x00dev, EFUSE_DATA2,
 				(u32 *)&rt2x00dev->eeprom[i + 2]);
-	rt2x00pci_register_read(rt2x00dev, EFUSE_DATA1,
+	rt2800_register_read(rt2x00dev, EFUSE_DATA1,
 				(u32 *)&rt2x00dev->eeprom[i + 4]);
-	rt2x00pci_register_read(rt2x00dev, EFUSE_DATA0,
+	rt2800_register_read(rt2x00dev, EFUSE_DATA0,
 				(u32 *)&rt2x00dev->eeprom[i + 6]);
 }
 
@@ -383,8 +384,8 @@ static inline void rt2800pci_read_eeprom
 static const struct rt2x00debug rt2800pci_rt2x00debug = {
 	.owner	= THIS_MODULE,
 	.csr	= {
-		.read		= rt2x00pci_register_read,
-		.write		= rt2x00pci_register_write,
+		.read		= rt2800_register_read,
+		.write		= rt2800_register_write,
 		.flags		= RT2X00DEBUGFS_OFFSET,
 		.word_base	= CSR_REG_BASE,
 		.word_size	= sizeof(u32),
@@ -418,7 +419,7 @@ static int rt2800pci_rfkill_poll(struct 
 {
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, GPIO_CTRL_CFG, &reg);
+	rt2800_register_read(rt2x00dev, GPIO_CTRL_CFG, &reg);
 	return rt2x00_get_field32(reg, GPIO_CTRL_CFG_BIT2);
 }
 
@@ -467,7 +468,7 @@ static int rt2800pci_blink_set(struct le
 	    container_of(led_cdev, struct rt2x00_led, led_dev);
 	u32 reg;
 
-	rt2x00pci_register_read(led->rt2x00dev, LED_CFG, &reg);
+	rt2800_register_read(led->rt2x00dev, LED_CFG, &reg);
 	rt2x00_set_field32(&reg, LED_CFG_ON_PERIOD, *delay_on);
 	rt2x00_set_field32(&reg, LED_CFG_OFF_PERIOD, *delay_off);
 	rt2x00_set_field32(&reg, LED_CFG_SLOW_BLINK_PERIOD, 3);
@@ -475,7 +476,7 @@ static int rt2800pci_blink_set(struct le
 	rt2x00_set_field32(&reg, LED_CFG_G_LED_MODE, 12);
 	rt2x00_set_field32(&reg, LED_CFG_Y_LED_MODE, 3);
 	rt2x00_set_field32(&reg, LED_CFG_LED_POLAR, 1);
-	rt2x00pci_register_write(led->rt2x00dev, LED_CFG, reg);
+	rt2800_register_write(led->rt2x00dev, LED_CFG, reg);
 
 	return 0;
 }
@@ -506,7 +507,7 @@ static void rt2800pci_config_wcid_attr(s
 
 	offset = MAC_WCID_ATTR_ENTRY(key->hw_key_idx);
 
-	rt2x00pci_register_read(rt2x00dev, offset, &reg);
+	rt2800_register_read(rt2x00dev, offset, &reg);
 	rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_KEYTAB,
 			   !!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE));
 	rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_CIPHER,
@@ -514,7 +515,7 @@ static void rt2800pci_config_wcid_attr(s
 	rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_BSS_IDX,
 			   (crypto->cmd == SET_KEY) * crypto->bssidx);
 	rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_RX_WIUDF, crypto->cipher);
-	rt2x00pci_register_write(rt2x00dev, offset, reg);
+	rt2800_register_write(rt2x00dev, offset, reg);
 
 	offset = MAC_IVEIV_ENTRY(key->hw_key_idx);
 
@@ -572,10 +573,10 @@ static int rt2800pci_config_shared_key(s
 
 	offset = SHARED_KEY_MODE_ENTRY(key->hw_key_idx / 8);
 
-	rt2x00pci_register_read(rt2x00dev, offset, &reg);
+	rt2800_register_read(rt2x00dev, offset, &reg);
 	rt2x00_set_field32(&reg, field,
 			   (crypto->cmd == SET_KEY) * crypto->cipher);
-	rt2x00pci_register_write(rt2x00dev, offset, reg);
+	rt2800_register_write(rt2x00dev, offset, reg);
 
 	/*
 	 * Update WCID information
@@ -635,7 +636,7 @@ static void rt2800pci_config_filter(stru
 	 * and broadcast frames will always be accepted since
 	 * there is no filter for it at this time.
 	 */
-	rt2x00pci_register_read(rt2x00dev, RX_FILTER_CFG, &reg);
+	rt2800_register_read(rt2x00dev, RX_FILTER_CFG, &reg);
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_CRC_ERROR,
 			   !(filter_flags & FIF_FCSFAIL));
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_PHY_ERROR,
@@ -664,7 +665,7 @@ static void rt2800pci_config_filter(stru
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BAR, 0);
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_CNTL,
 			   !(filter_flags & FIF_CONTROL));
-	rt2x00pci_register_write(rt2x00dev, RX_FILTER_CFG, reg);
+	rt2800_register_write(rt2x00dev, RX_FILTER_CFG, reg);
 }
 
 static void rt2800pci_config_intf(struct rt2x00_dev *rt2x00dev,
@@ -683,16 +684,16 @@ static void rt2800pci_config_intf(struct
 		 * bits which (when set to 0) will invalidate the entire beacon.
 		 */
 		beacon_base = HW_BEACON_OFFSET(intf->beacon->entry_idx);
-		rt2x00pci_register_write(rt2x00dev, beacon_base, 0);
+		rt2800_register_write(rt2x00dev, beacon_base, 0);
 
 		/*
 		 * Enable synchronisation.
 		 */
-		rt2x00pci_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+		rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 1);
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_SYNC, conf->sync);
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 1);
-		rt2x00pci_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 	}
 
 	if (flags & CONFIG_UPDATE_MAC) {
@@ -720,43 +721,43 @@ static void rt2800pci_config_erp(struct 
 {
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, TX_TIMEOUT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, TX_TIMEOUT_CFG, &reg);
 	rt2x00_set_field32(&reg, TX_TIMEOUT_CFG_RX_ACK_TIMEOUT, 0x20);
-	rt2x00pci_register_write(rt2x00dev, TX_TIMEOUT_CFG, reg);
+	rt2800_register_write(rt2x00dev, TX_TIMEOUT_CFG, reg);
 
-	rt2x00pci_register_read(rt2x00dev, AUTO_RSP_CFG, &reg);
+	rt2800_register_read(rt2x00dev, AUTO_RSP_CFG, &reg);
 	rt2x00_set_field32(&reg, AUTO_RSP_CFG_BAC_ACK_POLICY,
 			   !!erp->short_preamble);
 	rt2x00_set_field32(&reg, AUTO_RSP_CFG_AR_PREAMBLE,
 			   !!erp->short_preamble);
-	rt2x00pci_register_write(rt2x00dev, AUTO_RSP_CFG, reg);
+	rt2800_register_write(rt2x00dev, AUTO_RSP_CFG, reg);
 
-	rt2x00pci_register_read(rt2x00dev, OFDM_PROT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, OFDM_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, OFDM_PROT_CFG_PROTECT_CTRL,
 			   erp->cts_protection ? 2 : 0);
-	rt2x00pci_register_write(rt2x00dev, OFDM_PROT_CFG, reg);
+	rt2800_register_write(rt2x00dev, OFDM_PROT_CFG, reg);
 
-	rt2x00pci_register_write(rt2x00dev, LEGACY_BASIC_RATE,
+	rt2800_register_write(rt2x00dev, LEGACY_BASIC_RATE,
 				 erp->basic_rates);
-	rt2x00pci_register_write(rt2x00dev, HT_BASIC_RATE, 0x00008003);
+	rt2800_register_write(rt2x00dev, HT_BASIC_RATE, 0x00008003);
 
-	rt2x00pci_register_read(rt2x00dev, BKOFF_SLOT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, BKOFF_SLOT_CFG, &reg);
 	rt2x00_set_field32(&reg, BKOFF_SLOT_CFG_SLOT_TIME, erp->slot_time);
 	rt2x00_set_field32(&reg, BKOFF_SLOT_CFG_CC_DELAY_TIME, 2);
-	rt2x00pci_register_write(rt2x00dev, BKOFF_SLOT_CFG, reg);
+	rt2800_register_write(rt2x00dev, BKOFF_SLOT_CFG, reg);
 
-	rt2x00pci_register_read(rt2x00dev, XIFS_TIME_CFG, &reg);
+	rt2800_register_read(rt2x00dev, XIFS_TIME_CFG, &reg);
 	rt2x00_set_field32(&reg, XIFS_TIME_CFG_CCKM_SIFS_TIME, erp->sifs);
 	rt2x00_set_field32(&reg, XIFS_TIME_CFG_OFDM_SIFS_TIME, erp->sifs);
 	rt2x00_set_field32(&reg, XIFS_TIME_CFG_OFDM_XIFS_TIME, 4);
 	rt2x00_set_field32(&reg, XIFS_TIME_CFG_EIFS, erp->eifs);
 	rt2x00_set_field32(&reg, XIFS_TIME_CFG_BB_RXEND_ENABLE, 1);
-	rt2x00pci_register_write(rt2x00dev, XIFS_TIME_CFG, reg);
+	rt2800_register_write(rt2x00dev, XIFS_TIME_CFG, reg);
 
-	rt2x00pci_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+	rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
 	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_INTERVAL,
 			   erp->beacon_int * 16);
-	rt2x00pci_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 }
 
 static void rt2800pci_config_ant(struct rt2x00_dev *rt2x00dev,
@@ -965,11 +966,11 @@ static void rt2800pci_config_channel(str
 			rt2800pci_bbp_write(rt2x00dev, 75, 0x50);
 	}
 
-	rt2x00pci_register_read(rt2x00dev, TX_BAND_CFG, &reg);
+	rt2800_register_read(rt2x00dev, TX_BAND_CFG, &reg);
 	rt2x00_set_field32(&reg, TX_BAND_CFG_HT40_PLUS, conf_is_ht40_plus(conf));
 	rt2x00_set_field32(&reg, TX_BAND_CFG_A, rf->channel > 14);
 	rt2x00_set_field32(&reg, TX_BAND_CFG_BG, rf->channel <= 14);
-	rt2x00pci_register_write(rt2x00dev, TX_BAND_CFG, reg);
+	rt2800_register_write(rt2x00dev, TX_BAND_CFG, reg);
 
 	tx_pin = 0;
 
@@ -992,7 +993,7 @@ static void rt2800pci_config_channel(str
 	rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G0_EN, rf->channel <= 14);
 	rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A0_EN, rf->channel > 14);
 
-	rt2x00pci_register_write(rt2x00dev, TX_PIN_CFG, tx_pin);
+	rt2800_register_write(rt2x00dev, TX_PIN_CFG, tx_pin);
 
 	rt2800pci_bbp_read(rt2x00dev, 4, &bbp);
 	rt2x00_set_field8(&bbp, BBP4_BANDWIDTH, 2 * conf_is_ht40(conf));
@@ -1028,7 +1029,7 @@ static void rt2800pci_config_txpower(str
 	rt2x00_set_field8(&reg, BBP1_TX_POWER, 0);
 	rt2800pci_bbp_write(rt2x00dev, 1, r1);
 
-	rt2x00pci_register_read(rt2x00dev, TX_PWR_CFG_0, &reg);
+	rt2800_register_read(rt2x00dev, TX_PWR_CFG_0, &reg);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_0_1MBS, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_0_2MBS, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_0_55MBS, value);
@@ -1037,9 +1038,9 @@ static void rt2800pci_config_txpower(str
 	rt2x00_set_field32(&reg, TX_PWR_CFG_0_9MBS, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_0_12MBS, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_0_18MBS, value);
-	rt2x00pci_register_write(rt2x00dev, TX_PWR_CFG_0, reg);
+	rt2800_register_write(rt2x00dev, TX_PWR_CFG_0, reg);
 
-	rt2x00pci_register_read(rt2x00dev, TX_PWR_CFG_1, &reg);
+	rt2800_register_read(rt2x00dev, TX_PWR_CFG_1, &reg);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_1_24MBS, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_1_36MBS, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_1_48MBS, value);
@@ -1048,9 +1049,9 @@ static void rt2800pci_config_txpower(str
 	rt2x00_set_field32(&reg, TX_PWR_CFG_1_MCS1, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_1_MCS2, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_1_MCS3, value);
-	rt2x00pci_register_write(rt2x00dev, TX_PWR_CFG_1, reg);
+	rt2800_register_write(rt2x00dev, TX_PWR_CFG_1, reg);
 
-	rt2x00pci_register_read(rt2x00dev, TX_PWR_CFG_2, &reg);
+	rt2800_register_read(rt2x00dev, TX_PWR_CFG_2, &reg);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_2_MCS4, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_2_MCS5, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_2_MCS6, value);
@@ -1059,9 +1060,9 @@ static void rt2800pci_config_txpower(str
 	rt2x00_set_field32(&reg, TX_PWR_CFG_2_MCS9, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_2_MCS10, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_2_MCS11, value);
-	rt2x00pci_register_write(rt2x00dev, TX_PWR_CFG_2, reg);
+	rt2800_register_write(rt2x00dev, TX_PWR_CFG_2, reg);
 
-	rt2x00pci_register_read(rt2x00dev, TX_PWR_CFG_3, &reg);
+	rt2800_register_read(rt2x00dev, TX_PWR_CFG_3, &reg);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_3_MCS12, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_3_MCS13, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_3_MCS14, value);
@@ -1070,14 +1071,14 @@ static void rt2800pci_config_txpower(str
 	rt2x00_set_field32(&reg, TX_PWR_CFG_3_UKNOWN2, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_3_UKNOWN3, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_3_UKNOWN4, value);
-	rt2x00pci_register_write(rt2x00dev, TX_PWR_CFG_3, reg);
+	rt2800_register_write(rt2x00dev, TX_PWR_CFG_3, reg);
 
-	rt2x00pci_register_read(rt2x00dev, TX_PWR_CFG_4, &reg);
+	rt2800_register_read(rt2x00dev, TX_PWR_CFG_4, &reg);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_4_UKNOWN5, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_4_UKNOWN6, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_4_UKNOWN7, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_4_UKNOWN8, value);
-	rt2x00pci_register_write(rt2x00dev, TX_PWR_CFG_4, reg);
+	rt2800_register_write(rt2x00dev, TX_PWR_CFG_4, reg);
 }
 
 static void rt2800pci_config_retry_limit(struct rt2x00_dev *rt2x00dev,
@@ -1085,7 +1086,7 @@ static void rt2800pci_config_retry_limit
 {
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, TX_RTY_CFG, &reg);
+	rt2800_register_read(rt2x00dev, TX_RTY_CFG, &reg);
 	rt2x00_set_field32(&reg, TX_RTY_CFG_SHORT_RTY_LIMIT,
 			   libconf->conf->short_frame_max_tx_count);
 	rt2x00_set_field32(&reg, TX_RTY_CFG_LONG_RTY_LIMIT,
@@ -1094,7 +1095,7 @@ static void rt2800pci_config_retry_limit
 	rt2x00_set_field32(&reg, TX_RTY_CFG_NON_AGG_RTY_MODE, 0);
 	rt2x00_set_field32(&reg, TX_RTY_CFG_AGG_RTY_MODE, 0);
 	rt2x00_set_field32(&reg, TX_RTY_CFG_TX_AUTO_FB_ENABLE, 1);
-	rt2x00pci_register_write(rt2x00dev, TX_RTY_CFG, reg);
+	rt2800_register_write(rt2x00dev, TX_RTY_CFG, reg);
 }
 
 static void rt2800pci_config_ps(struct rt2x00_dev *rt2x00dev,
@@ -1106,24 +1107,24 @@ static void rt2800pci_config_ps(struct r
 	u32 reg;
 
 	if (state == STATE_SLEEP) {
-		rt2x00pci_register_write(rt2x00dev, AUTOWAKEUP_CFG, 0);
+		rt2800_register_write(rt2x00dev, AUTOWAKEUP_CFG, 0);
 
-		rt2x00pci_register_read(rt2x00dev, AUTOWAKEUP_CFG, &reg);
+		rt2800_register_read(rt2x00dev, AUTOWAKEUP_CFG, &reg);
 		rt2x00_set_field32(&reg, AUTOWAKEUP_CFG_AUTO_LEAD_TIME, 5);
 		rt2x00_set_field32(&reg, AUTOWAKEUP_CFG_TBCN_BEFORE_WAKE,
 				   libconf->conf->listen_interval - 1);
 		rt2x00_set_field32(&reg, AUTOWAKEUP_CFG_AUTOWAKE, 1);
-		rt2x00pci_register_write(rt2x00dev, AUTOWAKEUP_CFG, reg);
+		rt2800_register_write(rt2x00dev, AUTOWAKEUP_CFG, reg);
 
 		rt2x00dev->ops->lib->set_device_state(rt2x00dev, state);
 	} else {
 		rt2x00dev->ops->lib->set_device_state(rt2x00dev, state);
 
-		rt2x00pci_register_read(rt2x00dev, AUTOWAKEUP_CFG, &reg);
+		rt2800_register_read(rt2x00dev, AUTOWAKEUP_CFG, &reg);
 		rt2x00_set_field32(&reg, AUTOWAKEUP_CFG_AUTO_LEAD_TIME, 0);
 		rt2x00_set_field32(&reg, AUTOWAKEUP_CFG_TBCN_BEFORE_WAKE, 0);
 		rt2x00_set_field32(&reg, AUTOWAKEUP_CFG_AUTOWAKE, 0);
-		rt2x00pci_register_write(rt2x00dev, AUTOWAKEUP_CFG, reg);
+		rt2800_register_write(rt2x00dev, AUTOWAKEUP_CFG, reg);
 	}
 }
 
@@ -1156,7 +1157,7 @@ static void rt2800pci_link_stats(struct 
 	/*
 	 * Update FCS error count from register.
 	 */
-	rt2x00pci_register_read(rt2x00dev, RX_STA_CNT0, &reg);
+	rt2800_register_read(rt2x00dev, RX_STA_CNT0, &reg);
 	qual->rx_failed = rt2x00_get_field32(reg, RX_STA_CNT0_CRC_ERR);
 }
 
@@ -1259,7 +1260,7 @@ static int rt2800pci_load_firmware(struc
 	 * Wait for stable hardware.
 	 */
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt2x00pci_register_read(rt2x00dev, MAC_CSR0, &reg);
+		rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
 		if (reg && reg != ~0)
 			break;
 		msleep(1);
@@ -1270,27 +1271,27 @@ static int rt2800pci_load_firmware(struc
 		return -EBUSY;
 	}
 
-	rt2x00pci_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000002);
-	rt2x00pci_register_write(rt2x00dev, AUTOWAKEUP_CFG, 0x00000000);
+	rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000002);
+	rt2800_register_write(rt2x00dev, AUTOWAKEUP_CFG, 0x00000000);
 
 	/*
 	 * Disable DMA, will be reenabled later when enabling
 	 * the radio.
 	 */
-	rt2x00pci_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
+	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_DMA_BUSY, 0);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_RX_DMA_BUSY, 0);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_WRITEBACK_DONE, 1);
-	rt2x00pci_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
+	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
 
 	/*
 	 * enable Host program ram write selection
 	 */
 	reg = 0;
 	rt2x00_set_field32(&reg, PBF_SYS_CTRL_HOST_RAM_WRITE, 1);
-	rt2x00pci_register_write(rt2x00dev, PBF_SYS_CTRL, reg);
+	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, reg);
 
 	/*
 	 * Write firmware to device.
@@ -1298,14 +1299,14 @@ static int rt2800pci_load_firmware(struc
 	rt2x00pci_register_multiwrite(rt2x00dev, FIRMWARE_IMAGE_BASE,
 				      data, len);
 
-	rt2x00pci_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000);
-	rt2x00pci_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00001);
+	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000);
+	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00001);
 
 	/*
 	 * Wait for device to stabilize.
 	 */
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt2x00pci_register_read(rt2x00dev, PBF_SYS_CTRL, &reg);
+		rt2800_register_read(rt2x00dev, PBF_SYS_CTRL, &reg);
 		if (rt2x00_get_field32(reg, PBF_SYS_CTRL_READY))
 			break;
 		msleep(1);
@@ -1324,8 +1325,8 @@ static int rt2800pci_load_firmware(struc
 	/*
 	 * Initialize BBP R/W access agent
 	 */
-	rt2x00pci_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
-	rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
+	rt2800_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
+	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
 
 	return 0;
 }
@@ -1375,7 +1376,7 @@ static int rt2800pci_init_queues(struct 
 	struct queue_entry_priv_pci *entry_priv;
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, WPDMA_RST_IDX, &reg);
+	rt2800_register_read(rt2x00dev, WPDMA_RST_IDX, &reg);
 	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX0, 1);
 	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX1, 1);
 	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX2, 1);
@@ -1383,54 +1384,54 @@ static int rt2800pci_init_queues(struct 
 	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX4, 1);
 	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX5, 1);
 	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DRX_IDX0, 1);
-	rt2x00pci_register_write(rt2x00dev, WPDMA_RST_IDX, reg);
+	rt2800_register_write(rt2x00dev, WPDMA_RST_IDX, reg);
 
-	rt2x00pci_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e1f);
-	rt2x00pci_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e00);
+	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e1f);
+	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e00);
 
 	/*
 	 * Initialize registers.
 	 */
 	entry_priv = rt2x00dev->tx[0].entries[0].priv_data;
-	rt2x00pci_register_write(rt2x00dev, TX_BASE_PTR0, entry_priv->desc_dma);
-	rt2x00pci_register_write(rt2x00dev, TX_MAX_CNT0, rt2x00dev->tx[0].limit);
-	rt2x00pci_register_write(rt2x00dev, TX_CTX_IDX0, 0);
-	rt2x00pci_register_write(rt2x00dev, TX_DTX_IDX0, 0);
+	rt2800_register_write(rt2x00dev, TX_BASE_PTR0, entry_priv->desc_dma);
+	rt2800_register_write(rt2x00dev, TX_MAX_CNT0, rt2x00dev->tx[0].limit);
+	rt2800_register_write(rt2x00dev, TX_CTX_IDX0, 0);
+	rt2800_register_write(rt2x00dev, TX_DTX_IDX0, 0);
 
 	entry_priv = rt2x00dev->tx[1].entries[0].priv_data;
-	rt2x00pci_register_write(rt2x00dev, TX_BASE_PTR1, entry_priv->desc_dma);
-	rt2x00pci_register_write(rt2x00dev, TX_MAX_CNT1, rt2x00dev->tx[1].limit);
-	rt2x00pci_register_write(rt2x00dev, TX_CTX_IDX1, 0);
-	rt2x00pci_register_write(rt2x00dev, TX_DTX_IDX1, 0);
+	rt2800_register_write(rt2x00dev, TX_BASE_PTR1, entry_priv->desc_dma);
+	rt2800_register_write(rt2x00dev, TX_MAX_CNT1, rt2x00dev->tx[1].limit);
+	rt2800_register_write(rt2x00dev, TX_CTX_IDX1, 0);
+	rt2800_register_write(rt2x00dev, TX_DTX_IDX1, 0);
 
 	entry_priv = rt2x00dev->tx[2].entries[0].priv_data;
-	rt2x00pci_register_write(rt2x00dev, TX_BASE_PTR2, entry_priv->desc_dma);
-	rt2x00pci_register_write(rt2x00dev, TX_MAX_CNT2, rt2x00dev->tx[2].limit);
-	rt2x00pci_register_write(rt2x00dev, TX_CTX_IDX2, 0);
-	rt2x00pci_register_write(rt2x00dev, TX_DTX_IDX2, 0);
+	rt2800_register_write(rt2x00dev, TX_BASE_PTR2, entry_priv->desc_dma);
+	rt2800_register_write(rt2x00dev, TX_MAX_CNT2, rt2x00dev->tx[2].limit);
+	rt2800_register_write(rt2x00dev, TX_CTX_IDX2, 0);
+	rt2800_register_write(rt2x00dev, TX_DTX_IDX2, 0);
 
 	entry_priv = rt2x00dev->tx[3].entries[0].priv_data;
-	rt2x00pci_register_write(rt2x00dev, TX_BASE_PTR3, entry_priv->desc_dma);
-	rt2x00pci_register_write(rt2x00dev, TX_MAX_CNT3, rt2x00dev->tx[3].limit);
-	rt2x00pci_register_write(rt2x00dev, TX_CTX_IDX3, 0);
-	rt2x00pci_register_write(rt2x00dev, TX_DTX_IDX3, 0);
+	rt2800_register_write(rt2x00dev, TX_BASE_PTR3, entry_priv->desc_dma);
+	rt2800_register_write(rt2x00dev, TX_MAX_CNT3, rt2x00dev->tx[3].limit);
+	rt2800_register_write(rt2x00dev, TX_CTX_IDX3, 0);
+	rt2800_register_write(rt2x00dev, TX_DTX_IDX3, 0);
 
 	entry_priv = rt2x00dev->rx->entries[0].priv_data;
-	rt2x00pci_register_write(rt2x00dev, RX_BASE_PTR, entry_priv->desc_dma);
-	rt2x00pci_register_write(rt2x00dev, RX_MAX_CNT, rt2x00dev->rx[0].limit);
-	rt2x00pci_register_write(rt2x00dev, RX_CRX_IDX, rt2x00dev->rx[0].limit - 1);
-	rt2x00pci_register_write(rt2x00dev, RX_DRX_IDX, 0);
+	rt2800_register_write(rt2x00dev, RX_BASE_PTR, entry_priv->desc_dma);
+	rt2800_register_write(rt2x00dev, RX_MAX_CNT, rt2x00dev->rx[0].limit);
+	rt2800_register_write(rt2x00dev, RX_CRX_IDX, rt2x00dev->rx[0].limit - 1);
+	rt2800_register_write(rt2x00dev, RX_DRX_IDX, 0);
 
 	/*
 	 * Enable global DMA configuration
 	 */
-	rt2x00pci_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
+	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_WRITEBACK_DONE, 1);
-	rt2x00pci_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
+	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
 
-	rt2x00pci_register_write(rt2x00dev, DELAY_INT_CFG, 0);
+	rt2800_register_write(rt2x00dev, DELAY_INT_CFG, 0);
 
 	return 0;
 }
@@ -1440,47 +1441,47 @@ static int rt2800pci_init_registers(stru
 	u32 reg;
 	unsigned int i;
 
-	rt2x00pci_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
+	rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
 
-	rt2x00pci_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
+	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_CSR, 1);
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_BBP, 1);
-	rt2x00pci_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
 
-	rt2x00pci_register_write(rt2x00dev, MAC_SYS_CTRL, 0x00000000);
+	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, 0x00000000);
 
-	rt2x00pci_register_read(rt2x00dev, BCN_OFFSET0, &reg);
+	rt2800_register_read(rt2x00dev, BCN_OFFSET0, &reg);
 	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN0, 0xe0); /* 0x3800 */
 	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN1, 0xe8); /* 0x3a00 */
 	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN2, 0xf0); /* 0x3c00 */
 	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN3, 0xf8); /* 0x3e00 */
-	rt2x00pci_register_write(rt2x00dev, BCN_OFFSET0, reg);
+	rt2800_register_write(rt2x00dev, BCN_OFFSET0, reg);
 
-	rt2x00pci_register_read(rt2x00dev, BCN_OFFSET1, &reg);
+	rt2800_register_read(rt2x00dev, BCN_OFFSET1, &reg);
 	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN4, 0xc8); /* 0x3200 */
 	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN5, 0xd0); /* 0x3400 */
 	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN6, 0x77); /* 0x1dc0 */
 	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN7, 0x6f); /* 0x1bc0 */
-	rt2x00pci_register_write(rt2x00dev, BCN_OFFSET1, reg);
+	rt2800_register_write(rt2x00dev, BCN_OFFSET1, reg);
 
-	rt2x00pci_register_write(rt2x00dev, LEGACY_BASIC_RATE, 0x0000013f);
-	rt2x00pci_register_write(rt2x00dev, HT_BASIC_RATE, 0x00008003);
+	rt2800_register_write(rt2x00dev, LEGACY_BASIC_RATE, 0x0000013f);
+	rt2800_register_write(rt2x00dev, HT_BASIC_RATE, 0x00008003);
 
-	rt2x00pci_register_write(rt2x00dev, MAC_SYS_CTRL, 0x00000000);
+	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, 0x00000000);
 
-	rt2x00pci_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+	rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
 	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_INTERVAL, 0);
 	rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 0);
 	rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_SYNC, 0);
 	rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 0);
 	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 0);
 	rt2x00_set_field32(&reg, BCN_TIME_CFG_TX_TIME_COMPENSATE, 0);
-	rt2x00pci_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 
-	rt2x00pci_register_write(rt2x00dev, TX_SW_CFG0, 0x00000000);
-	rt2x00pci_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
+	rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000000);
+	rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
 
-	rt2x00pci_register_read(rt2x00dev, TX_LINK_CFG, &reg);
+	rt2800_register_read(rt2x00dev, TX_LINK_CFG, &reg);
 	rt2x00_set_field32(&reg, TX_LINK_CFG_REMOTE_MFB_LIFETIME, 32);
 	rt2x00_set_field32(&reg, TX_LINK_CFG_MFB_ENABLE, 0);
 	rt2x00_set_field32(&reg, TX_LINK_CFG_REMOTE_UMFS_ENABLE, 0);
@@ -1489,14 +1490,14 @@ static int rt2800pci_init_registers(stru
 	rt2x00_set_field32(&reg, TX_LINK_CFG_TX_CF_ACK_EN, 1);
 	rt2x00_set_field32(&reg, TX_LINK_CFG_REMOTE_MFB, 0);
 	rt2x00_set_field32(&reg, TX_LINK_CFG_REMOTE_MFS, 0);
-	rt2x00pci_register_write(rt2x00dev, TX_LINK_CFG, reg);
+	rt2800_register_write(rt2x00dev, TX_LINK_CFG, reg);
 
-	rt2x00pci_register_read(rt2x00dev, TX_TIMEOUT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, TX_TIMEOUT_CFG, &reg);
 	rt2x00_set_field32(&reg, TX_TIMEOUT_CFG_MPDU_LIFETIME, 9);
 	rt2x00_set_field32(&reg, TX_TIMEOUT_CFG_TX_OP_TIMEOUT, 10);
-	rt2x00pci_register_write(rt2x00dev, TX_TIMEOUT_CFG, reg);
+	rt2800_register_write(rt2x00dev, TX_TIMEOUT_CFG, reg);
 
-	rt2x00pci_register_read(rt2x00dev, MAX_LEN_CFG, &reg);
+	rt2800_register_read(rt2x00dev, MAX_LEN_CFG, &reg);
 	rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_MPDU, AGGREGATION_SIZE);
 	if (rt2x00_rev(&rt2x00dev->chip) >= RT2880E_VERSION &&
 	    rt2x00_rev(&rt2x00dev->chip) < RT3070_VERSION)
@@ -1505,19 +1506,19 @@ static int rt2800pci_init_registers(stru
 		rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 1);
 	rt2x00_set_field32(&reg, MAX_LEN_CFG_MIN_PSDU, 0);
 	rt2x00_set_field32(&reg, MAX_LEN_CFG_MIN_MPDU, 0);
-	rt2x00pci_register_write(rt2x00dev, MAX_LEN_CFG, reg);
+	rt2800_register_write(rt2x00dev, MAX_LEN_CFG, reg);
 
-	rt2x00pci_register_write(rt2x00dev, PBF_MAX_PCNT, 0x1f3fbf9f);
+	rt2800_register_write(rt2x00dev, PBF_MAX_PCNT, 0x1f3fbf9f);
 
-	rt2x00pci_register_read(rt2x00dev, AUTO_RSP_CFG, &reg);
+	rt2800_register_read(rt2x00dev, AUTO_RSP_CFG, &reg);
 	rt2x00_set_field32(&reg, AUTO_RSP_CFG_AUTORESPONDER, 1);
 	rt2x00_set_field32(&reg, AUTO_RSP_CFG_CTS_40_MMODE, 0);
 	rt2x00_set_field32(&reg, AUTO_RSP_CFG_CTS_40_MREF, 0);
 	rt2x00_set_field32(&reg, AUTO_RSP_CFG_DUAL_CTS_EN, 0);
 	rt2x00_set_field32(&reg, AUTO_RSP_CFG_ACK_CTS_PSM_BIT, 0);
-	rt2x00pci_register_write(rt2x00dev, AUTO_RSP_CFG, reg);
+	rt2800_register_write(rt2x00dev, AUTO_RSP_CFG, reg);
 
-	rt2x00pci_register_read(rt2x00dev, CCK_PROT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, CCK_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, CCK_PROT_CFG_PROTECT_RATE, 8);
 	rt2x00_set_field32(&reg, CCK_PROT_CFG_PROTECT_CTRL, 0);
 	rt2x00_set_field32(&reg, CCK_PROT_CFG_PROTECT_NAV, 1);
@@ -1527,9 +1528,9 @@ static int rt2800pci_init_registers(stru
 	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_MM40, 1);
 	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_GF20, 1);
 	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_GF40, 1);
-	rt2x00pci_register_write(rt2x00dev, CCK_PROT_CFG, reg);
+	rt2800_register_write(rt2x00dev, CCK_PROT_CFG, reg);
 
-	rt2x00pci_register_read(rt2x00dev, OFDM_PROT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, OFDM_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, OFDM_PROT_CFG_PROTECT_RATE, 8);
 	rt2x00_set_field32(&reg, OFDM_PROT_CFG_PROTECT_CTRL, 0);
 	rt2x00_set_field32(&reg, OFDM_PROT_CFG_PROTECT_NAV, 1);
@@ -1539,9 +1540,9 @@ static int rt2800pci_init_registers(stru
 	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_MM40, 1);
 	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_GF20, 1);
 	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_GF40, 1);
-	rt2x00pci_register_write(rt2x00dev, OFDM_PROT_CFG, reg);
+	rt2800_register_write(rt2x00dev, OFDM_PROT_CFG, reg);
 
-	rt2x00pci_register_read(rt2x00dev, MM20_PROT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, MM20_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_RATE, 0x4004);
 	rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_CTRL, 0);
 	rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_NAV, 1);
@@ -1551,9 +1552,9 @@ static int rt2800pci_init_registers(stru
 	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_MM40, 0);
 	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_GF20, 1);
 	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_GF40, 0);
-	rt2x00pci_register_write(rt2x00dev, MM20_PROT_CFG, reg);
+	rt2800_register_write(rt2x00dev, MM20_PROT_CFG, reg);
 
-	rt2x00pci_register_read(rt2x00dev, MM40_PROT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, MM40_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_RATE, 0x4084);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_CTRL, 0);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_NAV, 1);
@@ -1563,9 +1564,9 @@ static int rt2800pci_init_registers(stru
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_MM40, 1);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_GF20, 1);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_GF40, 1);
-	rt2x00pci_register_write(rt2x00dev, MM40_PROT_CFG, reg);
+	rt2800_register_write(rt2x00dev, MM40_PROT_CFG, reg);
 
-	rt2x00pci_register_read(rt2x00dev, GF20_PROT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, GF20_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, GF20_PROT_CFG_PROTECT_RATE, 0x4004);
 	rt2x00_set_field32(&reg, GF20_PROT_CFG_PROTECT_CTRL, 0);
 	rt2x00_set_field32(&reg, GF20_PROT_CFG_PROTECT_NAV, 1);
@@ -1575,9 +1576,9 @@ static int rt2800pci_init_registers(stru
 	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_MM40, 0);
 	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_GF20, 1);
 	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_GF40, 0);
-	rt2x00pci_register_write(rt2x00dev, GF20_PROT_CFG, reg);
+	rt2800_register_write(rt2x00dev, GF20_PROT_CFG, reg);
 
-	rt2x00pci_register_read(rt2x00dev, GF40_PROT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, GF40_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, GF40_PROT_CFG_PROTECT_RATE, 0x4084);
 	rt2x00_set_field32(&reg, GF40_PROT_CFG_PROTECT_CTRL, 0);
 	rt2x00_set_field32(&reg, GF40_PROT_CFG_PROTECT_NAV, 1);
@@ -1587,26 +1588,26 @@ static int rt2800pci_init_registers(stru
 	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_MM40, 1);
 	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_GF20, 1);
 	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_GF40, 1);
-	rt2x00pci_register_write(rt2x00dev, GF40_PROT_CFG, reg);
+	rt2800_register_write(rt2x00dev, GF40_PROT_CFG, reg);
 
-	rt2x00pci_register_write(rt2x00dev, TXOP_CTRL_CFG, 0x0000583f);
-	rt2x00pci_register_write(rt2x00dev, TXOP_HLDR_ET, 0x00000002);
+	rt2800_register_write(rt2x00dev, TXOP_CTRL_CFG, 0x0000583f);
+	rt2800_register_write(rt2x00dev, TXOP_HLDR_ET, 0x00000002);
 
-	rt2x00pci_register_read(rt2x00dev, TX_RTS_CFG, &reg);
+	rt2800_register_read(rt2x00dev, TX_RTS_CFG, &reg);
 	rt2x00_set_field32(&reg, TX_RTS_CFG_AUTO_RTS_RETRY_LIMIT, 32);
 	rt2x00_set_field32(&reg, TX_RTS_CFG_RTS_THRES,
 			   IEEE80211_MAX_RTS_THRESHOLD);
 	rt2x00_set_field32(&reg, TX_RTS_CFG_RTS_FBK_EN, 0);
-	rt2x00pci_register_write(rt2x00dev, TX_RTS_CFG, reg);
+	rt2800_register_write(rt2x00dev, TX_RTS_CFG, reg);
 
-	rt2x00pci_register_write(rt2x00dev, EXP_ACK_TIME, 0x002400ca);
-	rt2x00pci_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
+	rt2800_register_write(rt2x00dev, EXP_ACK_TIME, 0x002400ca);
+	rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
 
 	/*
 	 * ASIC will keep garbage value after boot, clear encryption keys.
 	 */
 	for (i = 0; i < 4; i++)
-		rt2x00pci_register_write(rt2x00dev,
+		rt2800_register_write(rt2x00dev,
 					 SHARED_KEY_MODE_ENTRY(i), 0);
 
 	for (i = 0; i < 256; i++) {
@@ -1614,8 +1615,8 @@ static int rt2800pci_init_registers(stru
 		rt2x00pci_register_multiwrite(rt2x00dev, MAC_WCID_ENTRY(i),
 					      wcid, sizeof(wcid));
 
-		rt2x00pci_register_write(rt2x00dev, MAC_WCID_ATTR_ENTRY(i), 1);
-		rt2x00pci_register_write(rt2x00dev, MAC_IVEIV_ENTRY(i), 0);
+		rt2800_register_write(rt2x00dev, MAC_WCID_ATTR_ENTRY(i), 1);
+		rt2800_register_write(rt2x00dev, MAC_IVEIV_ENTRY(i), 0);
 	}
 
 	/*
@@ -1624,16 +1625,16 @@ static int rt2800pci_init_registers(stru
 	 * the first byte since that byte contains the VALID and OWNER
 	 * bits which (when set to 0) will invalidate the entire beacon.
 	 */
-	rt2x00pci_register_write(rt2x00dev, HW_BEACON_BASE0, 0);
-	rt2x00pci_register_write(rt2x00dev, HW_BEACON_BASE1, 0);
-	rt2x00pci_register_write(rt2x00dev, HW_BEACON_BASE2, 0);
-	rt2x00pci_register_write(rt2x00dev, HW_BEACON_BASE3, 0);
-	rt2x00pci_register_write(rt2x00dev, HW_BEACON_BASE4, 0);
-	rt2x00pci_register_write(rt2x00dev, HW_BEACON_BASE5, 0);
-	rt2x00pci_register_write(rt2x00dev, HW_BEACON_BASE6, 0);
-	rt2x00pci_register_write(rt2x00dev, HW_BEACON_BASE7, 0);
+	rt2800_register_write(rt2x00dev, HW_BEACON_BASE0, 0);
+	rt2800_register_write(rt2x00dev, HW_BEACON_BASE1, 0);
+	rt2800_register_write(rt2x00dev, HW_BEACON_BASE2, 0);
+	rt2800_register_write(rt2x00dev, HW_BEACON_BASE3, 0);
+	rt2800_register_write(rt2x00dev, HW_BEACON_BASE4, 0);
+	rt2800_register_write(rt2x00dev, HW_BEACON_BASE5, 0);
+	rt2800_register_write(rt2x00dev, HW_BEACON_BASE6, 0);
+	rt2800_register_write(rt2x00dev, HW_BEACON_BASE7, 0);
 
-	rt2x00pci_register_read(rt2x00dev, HT_FBK_CFG0, &reg);
+	rt2800_register_read(rt2x00dev, HT_FBK_CFG0, &reg);
 	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS0FBK, 0);
 	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS1FBK, 0);
 	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS2FBK, 1);
@@ -1642,9 +1643,9 @@ static int rt2800pci_init_registers(stru
 	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS5FBK, 4);
 	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS6FBK, 5);
 	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS7FBK, 6);
-	rt2x00pci_register_write(rt2x00dev, HT_FBK_CFG0, reg);
+	rt2800_register_write(rt2x00dev, HT_FBK_CFG0, reg);
 
-	rt2x00pci_register_read(rt2x00dev, HT_FBK_CFG1, &reg);
+	rt2800_register_read(rt2x00dev, HT_FBK_CFG1, &reg);
 	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS8FBK, 8);
 	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS9FBK, 8);
 	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS10FBK, 9);
@@ -1653,9 +1654,9 @@ static int rt2800pci_init_registers(stru
 	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS13FBK, 12);
 	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS14FBK, 13);
 	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS15FBK, 14);
-	rt2x00pci_register_write(rt2x00dev, HT_FBK_CFG1, reg);
+	rt2800_register_write(rt2x00dev, HT_FBK_CFG1, reg);
 
-	rt2x00pci_register_read(rt2x00dev, LG_FBK_CFG0, &reg);
+	rt2800_register_read(rt2x00dev, LG_FBK_CFG0, &reg);
 	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS0FBK, 8);
 	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS1FBK, 8);
 	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS2FBK, 9);
@@ -1664,26 +1665,26 @@ static int rt2800pci_init_registers(stru
 	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS5FBK, 12);
 	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS6FBK, 13);
 	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS7FBK, 14);
-	rt2x00pci_register_write(rt2x00dev, LG_FBK_CFG0, reg);
+	rt2800_register_write(rt2x00dev, LG_FBK_CFG0, reg);
 
-	rt2x00pci_register_read(rt2x00dev, LG_FBK_CFG1, &reg);
+	rt2800_register_read(rt2x00dev, LG_FBK_CFG1, &reg);
 	rt2x00_set_field32(&reg, LG_FBK_CFG0_CCKMCS0FBK, 0);
 	rt2x00_set_field32(&reg, LG_FBK_CFG0_CCKMCS1FBK, 0);
 	rt2x00_set_field32(&reg, LG_FBK_CFG0_CCKMCS2FBK, 1);
 	rt2x00_set_field32(&reg, LG_FBK_CFG0_CCKMCS3FBK, 2);
-	rt2x00pci_register_write(rt2x00dev, LG_FBK_CFG1, reg);
+	rt2800_register_write(rt2x00dev, LG_FBK_CFG1, reg);
 
 	/*
 	 * We must clear the error counters.
 	 * These registers are cleared on read,
 	 * so we may pass a useless variable to store the value.
 	 */
-	rt2x00pci_register_read(rt2x00dev, RX_STA_CNT0, &reg);
-	rt2x00pci_register_read(rt2x00dev, RX_STA_CNT1, &reg);
-	rt2x00pci_register_read(rt2x00dev, RX_STA_CNT2, &reg);
-	rt2x00pci_register_read(rt2x00dev, TX_STA_CNT0, &reg);
-	rt2x00pci_register_read(rt2x00dev, TX_STA_CNT1, &reg);
-	rt2x00pci_register_read(rt2x00dev, TX_STA_CNT2, &reg);
+	rt2800_register_read(rt2x00dev, RX_STA_CNT0, &reg);
+	rt2800_register_read(rt2x00dev, RX_STA_CNT1, &reg);
+	rt2800_register_read(rt2x00dev, RX_STA_CNT2, &reg);
+	rt2800_register_read(rt2x00dev, TX_STA_CNT0, &reg);
+	rt2800_register_read(rt2x00dev, TX_STA_CNT1, &reg);
+	rt2800_register_read(rt2x00dev, TX_STA_CNT2, &reg);
 
 	return 0;
 }
@@ -1694,7 +1695,7 @@ static int rt2800pci_wait_bbp_rf_ready(s
 	u32 reg;
 
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt2x00pci_register_read(rt2x00dev, MAC_STATUS_CFG, &reg);
+		rt2800_register_read(rt2x00dev, MAC_STATUS_CFG, &reg);
 		if (!rt2x00_get_field32(reg, MAC_STATUS_CFG_BBP_RF_BUSY))
 			return 0;
 
@@ -1714,8 +1715,8 @@ static int rt2800pci_wait_bbp_ready(stru
 	 * BBP was enabled after firmware was loaded,
 	 * but we need to reactivate it now.
 	 */
-	rt2x00pci_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
-	rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
+	rt2800_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
+	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
 	msleep(1);
 
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
@@ -1928,11 +1929,11 @@ static void rt2800pci_toggle_rx(struct r
 {
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
+	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX,
 			   (state == STATE_RADIO_RX_ON) ||
 			   (state == STATE_RADIO_RX_ON_LINK));
-	rt2x00pci_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
 }
 
 static void rt2800pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
@@ -1946,11 +1947,11 @@ static void rt2800pci_toggle_irq(struct 
 	 * should clear the register to assure a clean state.
 	 */
 	if (state == STATE_RADIO_IRQ_ON) {
-		rt2x00pci_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
-		rt2x00pci_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
+		rt2800_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
+		rt2800_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
 	}
 
-	rt2x00pci_register_read(rt2x00dev, INT_MASK_CSR, &reg);
+	rt2800_register_read(rt2x00dev, INT_MASK_CSR, &reg);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_RXDELAYINT, mask);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_TXDELAYINT, mask);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_RX_DONE, mask);
@@ -1969,7 +1970,7 @@ static void rt2800pci_toggle_irq(struct 
 	rt2x00_set_field32(&reg, INT_MASK_CSR_GPTIMER, mask);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_RX_COHERENT, mask);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_TX_COHERENT, mask);
-	rt2x00pci_register_write(rt2x00dev, INT_MASK_CSR, reg);
+	rt2800_register_write(rt2x00dev, INT_MASK_CSR, reg);
 }
 
 static int rt2800pci_wait_wpdma_ready(struct rt2x00_dev *rt2x00dev)
@@ -1978,7 +1979,7 @@ static int rt2800pci_wait_wpdma_ready(st
 	u32 reg;
 
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt2x00pci_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
+		rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
 		if (!rt2x00_get_field32(reg, WPDMA_GLO_CFG_TX_DMA_BUSY) &&
 		    !rt2x00_get_field32(reg, WPDMA_GLO_CFG_RX_DMA_BUSY))
 			return 0;
@@ -2014,22 +2015,22 @@ static int rt2800pci_enable_radio(struct
 	/*
 	 * Enable RX.
 	 */
-	rt2x00pci_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
+	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_TX, 1);
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX, 0);
-	rt2x00pci_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
 
-	rt2x00pci_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
+	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 1);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 1);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_WP_DMA_BURST_SIZE, 2);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_WRITEBACK_DONE, 1);
-	rt2x00pci_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
+	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
 
-	rt2x00pci_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
+	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_TX, 1);
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX, 1);
-	rt2x00pci_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
 
 	/*
 	 * Initialize LED control
@@ -2053,21 +2054,21 @@ static void rt2800pci_disable_radio(stru
 {
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
+	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_DMA_BUSY, 0);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_RX_DMA_BUSY, 0);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_WRITEBACK_DONE, 1);
-	rt2x00pci_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
+	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
 
-	rt2x00pci_register_write(rt2x00dev, MAC_SYS_CTRL, 0);
-	rt2x00pci_register_write(rt2x00dev, PWR_PIN_CFG, 0);
-	rt2x00pci_register_write(rt2x00dev, TX_PIN_CFG, 0);
+	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, 0);
+	rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0);
+	rt2800_register_write(rt2x00dev, TX_PIN_CFG, 0);
 
-	rt2x00pci_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00001280);
+	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00001280);
 
-	rt2x00pci_register_read(rt2x00dev, WPDMA_RST_IDX, &reg);
+	rt2800_register_read(rt2x00dev, WPDMA_RST_IDX, &reg);
 	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX0, 1);
 	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX1, 1);
 	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX2, 1);
@@ -2075,10 +2076,10 @@ static void rt2800pci_disable_radio(stru
 	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX4, 1);
 	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX5, 1);
 	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DRX_IDX0, 1);
-	rt2x00pci_register_write(rt2x00dev, WPDMA_RST_IDX, reg);
+	rt2800_register_write(rt2x00dev, WPDMA_RST_IDX, reg);
 
-	rt2x00pci_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e1f);
-	rt2x00pci_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e00);
+	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e1f);
+	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e00);
 
 	/* Wait for DMA, ignore error */
 	rt2800pci_wait_wpdma_ready(rt2x00dev);
@@ -2267,9 +2268,9 @@ static void rt2800pci_write_beacon(struc
 	 * Disable beaconing while we are reloading the beacon data,
 	 * otherwise we might be sending out invalid data.
 	 */
-	rt2x00pci_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+	rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
 	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 0);
-	rt2x00pci_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 
 	/*
 	 * Write entire beacon with descriptor to register.
@@ -2297,12 +2298,12 @@ static void rt2800pci_kick_tx_queue(stru
 	u32 reg;
 
 	if (queue_idx == QID_BEACON) {
-		rt2x00pci_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+		rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
 		if (!rt2x00_get_field32(reg, BCN_TIME_CFG_BEACON_GEN)) {
 			rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 1);
 			rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 1);
 			rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 1);
-			rt2x00pci_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+			rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 		}
 		return;
 	}
@@ -2318,7 +2319,7 @@ static void rt2800pci_kick_tx_queue(stru
 	else
 		qidx = queue_idx;
 
-	rt2x00pci_register_write(rt2x00dev, TX_CTX_IDX(qidx), idx);
+	rt2800_register_write(rt2x00dev, TX_CTX_IDX(qidx), idx);
 }
 
 static void rt2800pci_kill_tx_queue(struct rt2x00_dev *rt2x00dev,
@@ -2327,16 +2328,16 @@ static void rt2800pci_kill_tx_queue(stru
 	u32 reg;
 
 	if (qid == QID_BEACON) {
-		rt2x00pci_register_write(rt2x00dev, BCN_TIME_CFG, 0);
+		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, 0);
 		return;
 	}
 
-	rt2x00pci_register_read(rt2x00dev, WPDMA_RST_IDX, &reg);
+	rt2800_register_read(rt2x00dev, WPDMA_RST_IDX, &reg);
 	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX0, (qid == QID_AC_BE));
 	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX1, (qid == QID_AC_BK));
 	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX2, (qid == QID_AC_VI));
 	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX3, (qid == QID_AC_VO));
-	rt2x00pci_register_write(rt2x00dev, WPDMA_RST_IDX, reg);
+	rt2800_register_write(rt2x00dev, WPDMA_RST_IDX, reg);
 }
 
 /*
@@ -2432,7 +2433,7 @@ static void rt2800pci_fill_rxdone(struct
 	 * Set RX IDX in register to inform hardware that we have handled
 	 * this entry and it is available for reuse again.
 	 */
-	rt2x00pci_register_write(rt2x00dev, RX_CRX_IDX, entry->entry_idx);
+	rt2800_register_write(rt2x00dev, RX_CRX_IDX, entry->entry_idx);
 
 	/*
 	 * Remove TXWI descriptor from start of buffer.
@@ -2469,7 +2470,7 @@ static void rt2800pci_txdone(struct rt2x
 	old_reg = 0;
 
 	while (1) {
-		rt2x00pci_register_read(rt2x00dev, TX_STA_FIFO, &reg);
+		rt2800_register_read(rt2x00dev, TX_STA_FIFO, &reg);
 		if (!rt2x00_get_field32(reg, TX_STA_FIFO_VALID))
 			break;
 
@@ -2553,8 +2554,8 @@ static irqreturn_t rt2800pci_interrupt(i
 	u32 reg;
 
 	/* Read status and ACK all interrupts */
-	rt2x00pci_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
-	rt2x00pci_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
+	rt2800_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
+	rt2800_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
 
 	if (!reg)
 		return IRQ_NONE;
@@ -2711,7 +2712,7 @@ static int rt2800pci_init_eeprom(struct 
 	 * Identify RF chipset.
 	 */
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
-	rt2x00pci_register_read(rt2x00dev, MAC_CSR0, &reg);
+	rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
 	rt2x00_set_chip_rf(rt2x00dev, value, reg);
 
 	if (!rt2x00_rf(&rt2x00dev->chip, RF2820) &&
@@ -3022,33 +3023,33 @@ static int rt2800pci_set_rts_threshold(s
 	u32 reg;
 	bool enabled = (value < IEEE80211_MAX_RTS_THRESHOLD);
 
-	rt2x00pci_register_read(rt2x00dev, TX_RTS_CFG, &reg);
+	rt2800_register_read(rt2x00dev, TX_RTS_CFG, &reg);
 	rt2x00_set_field32(&reg, TX_RTS_CFG_RTS_THRES, value);
-	rt2x00pci_register_write(rt2x00dev, TX_RTS_CFG, reg);
+	rt2800_register_write(rt2x00dev, TX_RTS_CFG, reg);
 
-	rt2x00pci_register_read(rt2x00dev, CCK_PROT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, CCK_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, CCK_PROT_CFG_RTS_TH_EN, enabled);
-	rt2x00pci_register_write(rt2x00dev, CCK_PROT_CFG, reg);
+	rt2800_register_write(rt2x00dev, CCK_PROT_CFG, reg);
 
-	rt2x00pci_register_read(rt2x00dev, OFDM_PROT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, OFDM_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, OFDM_PROT_CFG_RTS_TH_EN, enabled);
-	rt2x00pci_register_write(rt2x00dev, OFDM_PROT_CFG, reg);
+	rt2800_register_write(rt2x00dev, OFDM_PROT_CFG, reg);
 
-	rt2x00pci_register_read(rt2x00dev, MM20_PROT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, MM20_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, MM20_PROT_CFG_RTS_TH_EN, enabled);
-	rt2x00pci_register_write(rt2x00dev, MM20_PROT_CFG, reg);
+	rt2800_register_write(rt2x00dev, MM20_PROT_CFG, reg);
 
-	rt2x00pci_register_read(rt2x00dev, MM40_PROT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, MM40_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_RTS_TH_EN, enabled);
-	rt2x00pci_register_write(rt2x00dev, MM40_PROT_CFG, reg);
+	rt2800_register_write(rt2x00dev, MM40_PROT_CFG, reg);
 
-	rt2x00pci_register_read(rt2x00dev, GF20_PROT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, GF20_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, GF20_PROT_CFG_RTS_TH_EN, enabled);
-	rt2x00pci_register_write(rt2x00dev, GF20_PROT_CFG, reg);
+	rt2800_register_write(rt2x00dev, GF20_PROT_CFG, reg);
 
-	rt2x00pci_register_read(rt2x00dev, GF40_PROT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, GF40_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, GF40_PROT_CFG_RTS_TH_EN, enabled);
-	rt2x00pci_register_write(rt2x00dev, GF40_PROT_CFG, reg);
+	rt2800_register_write(rt2x00dev, GF40_PROT_CFG, reg);
 
 	return 0;
 }
@@ -3087,35 +3088,35 @@ static int rt2800pci_conf_tx(struct ieee
 	field.bit_offset = (queue_idx & 1) * 16;
 	field.bit_mask = 0xffff << field.bit_offset;
 
-	rt2x00pci_register_read(rt2x00dev, offset, &reg);
+	rt2800_register_read(rt2x00dev, offset, &reg);
 	rt2x00_set_field32(&reg, field, queue->txop);
-	rt2x00pci_register_write(rt2x00dev, offset, reg);
+	rt2800_register_write(rt2x00dev, offset, reg);
 
 	/* Update WMM registers */
 	field.bit_offset = queue_idx * 4;
 	field.bit_mask = 0xf << field.bit_offset;
 
-	rt2x00pci_register_read(rt2x00dev, WMM_AIFSN_CFG, &reg);
+	rt2800_register_read(rt2x00dev, WMM_AIFSN_CFG, &reg);
 	rt2x00_set_field32(&reg, field, queue->aifs);
-	rt2x00pci_register_write(rt2x00dev, WMM_AIFSN_CFG, reg);
+	rt2800_register_write(rt2x00dev, WMM_AIFSN_CFG, reg);
 
-	rt2x00pci_register_read(rt2x00dev, WMM_CWMIN_CFG, &reg);
+	rt2800_register_read(rt2x00dev, WMM_CWMIN_CFG, &reg);
 	rt2x00_set_field32(&reg, field, queue->cw_min);
-	rt2x00pci_register_write(rt2x00dev, WMM_CWMIN_CFG, reg);
+	rt2800_register_write(rt2x00dev, WMM_CWMIN_CFG, reg);
 
-	rt2x00pci_register_read(rt2x00dev, WMM_CWMAX_CFG, &reg);
+	rt2800_register_read(rt2x00dev, WMM_CWMAX_CFG, &reg);
 	rt2x00_set_field32(&reg, field, queue->cw_max);
-	rt2x00pci_register_write(rt2x00dev, WMM_CWMAX_CFG, reg);
+	rt2800_register_write(rt2x00dev, WMM_CWMAX_CFG, reg);
 
 	/* Update EDCA registers */
 	offset = EDCA_AC0_CFG + (sizeof(u32) * queue_idx);
 
-	rt2x00pci_register_read(rt2x00dev, offset, &reg);
+	rt2800_register_read(rt2x00dev, offset, &reg);
 	rt2x00_set_field32(&reg, EDCA_AC0_CFG_TX_OP, queue->txop);
 	rt2x00_set_field32(&reg, EDCA_AC0_CFG_AIFSN, queue->aifs);
 	rt2x00_set_field32(&reg, EDCA_AC0_CFG_CWMIN, queue->cw_min);
 	rt2x00_set_field32(&reg, EDCA_AC0_CFG_CWMAX, queue->cw_max);
-	rt2x00pci_register_write(rt2x00dev, offset, reg);
+	rt2800_register_write(rt2x00dev, offset, reg);
 
 	return 0;
 }
@@ -3126,9 +3127,9 @@ static u64 rt2800pci_get_tsf(struct ieee
 	u64 tsf;
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, TSF_TIMER_DW1, &reg);
+	rt2800_register_read(rt2x00dev, TSF_TIMER_DW1, &reg);
 	tsf = (u64) rt2x00_get_field32(reg, TSF_TIMER_DW1_HIGH_WORD) << 32;
-	rt2x00pci_register_read(rt2x00dev, TSF_TIMER_DW0, &reg);
+	rt2800_register_read(rt2x00dev, TSF_TIMER_DW0, &reg);
 	tsf |= rt2x00_get_field32(reg, TSF_TIMER_DW0_LOW_WORD);
 
 	return tsf;
Index: b/drivers/net/wireless/rt2x00/rt2800pci.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800pci.h
+++ b/drivers/net/wireless/rt2x00/rt2800pci.h
@@ -27,6 +27,27 @@
 #ifndef RT2800PCI_H
 #define RT2800PCI_H
 
+static inline void rt2800_register_read(struct rt2x00_dev *rt2x00dev,
+					const unsigned int offset,
+					u32 *value)
+{
+	rt2x00pci_register_read(rt2x00dev, offset, value);
+}
+
+static inline void rt2800_register_write(struct rt2x00_dev *rt2x00dev,
+					 const unsigned int offset,
+					 u32 value)
+{
+	rt2x00pci_register_write(rt2x00dev, offset, value);
+}
+
+static inline void rt2800_register_write_lock(struct rt2x00_dev *rt2x00dev,
+					      const unsigned int offset,
+					      u32 value)
+{
+	rt2x00pci_register_write(rt2x00dev, offset, value);
+}
+
 /*
  * RF chip defines.
  *
