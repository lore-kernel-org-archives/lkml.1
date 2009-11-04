Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbZKDRdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbZKDRdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757458AbZKDRde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:33:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:41096 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423AbZKDRdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:33:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ZyRgv+QX63L5e+kKGS21PWWzloTnEKOkmBLPejvqv4xq5Jvw5mvwtGDCZaeHsa72HU
         UuJLl05coVMKhjuQgAcajEwr7XUVieSQ6DuXhB1KQKQZkVn4xiR4isrLO27yFenTxSNT
         EXAa2e5WAnFhKB56EDGLaClkUwYYXqeH6tjCw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:33:05 +0100
Message-Id: <20091104173305.28463.69600.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 09/41] rt2800usb: add rt2800_register_[read,write]() wrappers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800usb: add rt2800_register_[read,write]() wrappers

Part of preparations for later code unification.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |  384 ++++++++++++++++----------------
 drivers/net/wireless/rt2x00/rt2800usb.h |   21 +
 2 files changed, 213 insertions(+), 192 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800usb.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -46,7 +46,7 @@ MODULE_PARM_DESC(nohwcrypt, "Disable har
 /*
  * Register access.
  * All access to the CSR registers will go through the methods
- * rt2x00usb_register_read and rt2x00usb_register_write.
+ * rt2800_register_read and rt2800_register_write.
  * BBP and RF register require indirect register access,
  * and use the CSR registers BBPCSR and RFCSR to achieve this.
  * These indirect registers work with busy bits,
@@ -85,7 +85,7 @@ static void rt2800usb_bbp_write(struct r
 		rt2x00_set_field32(&reg, BBP_CSR_CFG_BUSY, 1);
 		rt2x00_set_field32(&reg, BBP_CSR_CFG_READ_CONTROL, 0);
 
-		rt2x00usb_register_write_lock(rt2x00dev, BBP_CSR_CFG, reg);
+		rt2800_register_write_lock(rt2x00dev, BBP_CSR_CFG, reg);
 	}
 
 	mutex_unlock(&rt2x00dev->csr_mutex);
@@ -112,7 +112,7 @@ static void rt2800usb_bbp_read(struct rt
 		rt2x00_set_field32(&reg, BBP_CSR_CFG_BUSY, 1);
 		rt2x00_set_field32(&reg, BBP_CSR_CFG_READ_CONTROL, 1);
 
-		rt2x00usb_register_write_lock(rt2x00dev, BBP_CSR_CFG, reg);
+		rt2800_register_write_lock(rt2x00dev, BBP_CSR_CFG, reg);
 
 		WAIT_FOR_BBP(rt2x00dev, &reg);
 	}
@@ -140,7 +140,7 @@ static void rt2800usb_rfcsr_write(struct
 		rt2x00_set_field32(&reg, RF_CSR_CFG_WRITE, 1);
 		rt2x00_set_field32(&reg, RF_CSR_CFG_BUSY, 1);
 
-		rt2x00usb_register_write_lock(rt2x00dev, RF_CSR_CFG, reg);
+		rt2800_register_write_lock(rt2x00dev, RF_CSR_CFG, reg);
 	}
 
 	mutex_unlock(&rt2x00dev->csr_mutex);
@@ -167,7 +167,7 @@ static void rt2800usb_rfcsr_read(struct 
 		rt2x00_set_field32(&reg, RF_CSR_CFG_WRITE, 0);
 		rt2x00_set_field32(&reg, RF_CSR_CFG_BUSY, 1);
 
-		rt2x00usb_register_write_lock(rt2x00dev, RF_CSR_CFG, reg);
+		rt2800_register_write_lock(rt2x00dev, RF_CSR_CFG, reg);
 
 		WAIT_FOR_RFCSR(rt2x00dev, &reg);
 	}
@@ -195,7 +195,7 @@ static void rt2800usb_rf_write(struct rt
 		rt2x00_set_field32(&reg, RF_CSR_CFG0_SEL, 0);
 		rt2x00_set_field32(&reg, RF_CSR_CFG0_BUSY, 1);
 
-		rt2x00usb_register_write_lock(rt2x00dev, RF_CSR_CFG0, reg);
+		rt2800_register_write_lock(rt2x00dev, RF_CSR_CFG0, reg);
 		rt2x00_rf_write(rt2x00dev, word, value);
 	}
 
@@ -219,11 +219,11 @@ static void rt2800usb_mcu_request(struct
 		rt2x00_set_field32(&reg, H2M_MAILBOX_CSR_CMD_TOKEN, token);
 		rt2x00_set_field32(&reg, H2M_MAILBOX_CSR_ARG0, arg0);
 		rt2x00_set_field32(&reg, H2M_MAILBOX_CSR_ARG1, arg1);
-		rt2x00usb_register_write_lock(rt2x00dev, H2M_MAILBOX_CSR, reg);
+		rt2800_register_write_lock(rt2x00dev, H2M_MAILBOX_CSR, reg);
 
 		reg = 0;
 		rt2x00_set_field32(&reg, HOST_CMD_CSR_HOST_COMMAND, command);
-		rt2x00usb_register_write_lock(rt2x00dev, HOST_CMD_CSR, reg);
+		rt2800_register_write_lock(rt2x00dev, HOST_CMD_CSR, reg);
 	}
 
 	mutex_unlock(&rt2x00dev->csr_mutex);
@@ -233,8 +233,8 @@ static void rt2800usb_mcu_request(struct
 static const struct rt2x00debug rt2800usb_rt2x00debug = {
 	.owner	= THIS_MODULE,
 	.csr	= {
-		.read		= rt2x00usb_register_read,
-		.write		= rt2x00usb_register_write,
+		.read		= rt2800_register_read,
+		.write		= rt2800_register_write,
 		.flags		= RT2X00DEBUGFS_OFFSET,
 		.word_base	= CSR_REG_BASE,
 		.word_size	= sizeof(u32),
@@ -268,7 +268,7 @@ static int rt2800usb_rfkill_poll(struct 
 {
 	u32 reg;
 
-	rt2x00usb_register_read(rt2x00dev, GPIO_CTRL_CFG, &reg);
+	rt2800_register_read(rt2x00dev, GPIO_CTRL_CFG, &reg);
 	return rt2x00_get_field32(reg, GPIO_CTRL_CFG_BIT2);
 }
 
@@ -317,7 +317,7 @@ static int rt2800usb_blink_set(struct le
 	    container_of(led_cdev, struct rt2x00_led, led_dev);
 	u32 reg;
 
-	rt2x00usb_register_read(led->rt2x00dev, LED_CFG, &reg);
+	rt2800_register_read(led->rt2x00dev, LED_CFG, &reg);
 	rt2x00_set_field32(&reg, LED_CFG_ON_PERIOD, *delay_on);
 	rt2x00_set_field32(&reg, LED_CFG_OFF_PERIOD, *delay_off);
 	rt2x00_set_field32(&reg, LED_CFG_SLOW_BLINK_PERIOD, 3);
@@ -325,7 +325,7 @@ static int rt2800usb_blink_set(struct le
 	rt2x00_set_field32(&reg, LED_CFG_G_LED_MODE, 12);
 	rt2x00_set_field32(&reg, LED_CFG_Y_LED_MODE, 3);
 	rt2x00_set_field32(&reg, LED_CFG_LED_POLAR, 1);
-	rt2x00usb_register_write(led->rt2x00dev, LED_CFG, reg);
+	rt2800_register_write(led->rt2x00dev, LED_CFG, reg);
 
 	return 0;
 }
@@ -356,7 +356,7 @@ static void rt2800usb_config_wcid_attr(s
 
 	offset = MAC_WCID_ATTR_ENTRY(key->hw_key_idx);
 
-	rt2x00usb_register_read(rt2x00dev, offset, &reg);
+	rt2800_register_read(rt2x00dev, offset, &reg);
 	rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_KEYTAB,
 			   !!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE));
 	rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_CIPHER,
@@ -364,7 +364,7 @@ static void rt2800usb_config_wcid_attr(s
 	rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_BSS_IDX,
 			   (crypto->cmd == SET_KEY) * crypto->bssidx);
 	rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_RX_WIUDF, crypto->cipher);
-	rt2x00usb_register_write(rt2x00dev, offset, reg);
+	rt2800_register_write(rt2x00dev, offset, reg);
 
 	offset = MAC_IVEIV_ENTRY(key->hw_key_idx);
 
@@ -427,10 +427,10 @@ static int rt2800usb_config_shared_key(s
 
 	offset = SHARED_KEY_MODE_ENTRY(key->hw_key_idx / 8);
 
-	rt2x00usb_register_read(rt2x00dev, offset, &reg);
+	rt2800_register_read(rt2x00dev, offset, &reg);
 	rt2x00_set_field32(&reg, field,
 			   (crypto->cmd == SET_KEY) * crypto->cipher);
-	rt2x00usb_register_write(rt2x00dev, offset, reg);
+	rt2800_register_write(rt2x00dev, offset, reg);
 
 	/*
 	 * Update WCID information
@@ -494,7 +494,7 @@ static void rt2800usb_config_filter(stru
 	 * and broadcast frames will always be accepted since
 	 * there is no filter for it at this time.
 	 */
-	rt2x00usb_register_read(rt2x00dev, RX_FILTER_CFG, &reg);
+	rt2800_register_read(rt2x00dev, RX_FILTER_CFG, &reg);
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_CRC_ERROR,
 			   !(filter_flags & FIF_FCSFAIL));
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_PHY_ERROR,
@@ -523,7 +523,7 @@ static void rt2800usb_config_filter(stru
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BAR, 0);
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_CNTL,
 			   !(filter_flags & FIF_CONTROL));
-	rt2x00usb_register_write(rt2x00dev, RX_FILTER_CFG, reg);
+	rt2800_register_write(rt2x00dev, RX_FILTER_CFG, reg);
 }
 
 static void rt2800usb_config_intf(struct rt2x00_dev *rt2x00dev,
@@ -542,16 +542,16 @@ static void rt2800usb_config_intf(struct
 		 * bits which (when set to 0) will invalidate the entire beacon.
 		 */
 		beacon_base = HW_BEACON_OFFSET(intf->beacon->entry_idx);
-		rt2x00usb_register_write(rt2x00dev, beacon_base, 0);
+		rt2800_register_write(rt2x00dev, beacon_base, 0);
 
 		/*
 		 * Enable synchronisation.
 		 */
-		rt2x00usb_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+		rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 1);
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_SYNC, conf->sync);
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 1);
-		rt2x00usb_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 	}
 
 	if (flags & CONFIG_UPDATE_MAC) {
@@ -579,43 +579,43 @@ static void rt2800usb_config_erp(struct 
 {
 	u32 reg;
 
-	rt2x00usb_register_read(rt2x00dev, TX_TIMEOUT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, TX_TIMEOUT_CFG, &reg);
 	rt2x00_set_field32(&reg, TX_TIMEOUT_CFG_RX_ACK_TIMEOUT, 0x20);
-	rt2x00usb_register_write(rt2x00dev, TX_TIMEOUT_CFG, reg);
+	rt2800_register_write(rt2x00dev, TX_TIMEOUT_CFG, reg);
 
-	rt2x00usb_register_read(rt2x00dev, AUTO_RSP_CFG, &reg);
+	rt2800_register_read(rt2x00dev, AUTO_RSP_CFG, &reg);
 	rt2x00_set_field32(&reg, AUTO_RSP_CFG_BAC_ACK_POLICY,
 			   !!erp->short_preamble);
 	rt2x00_set_field32(&reg, AUTO_RSP_CFG_AR_PREAMBLE,
 			   !!erp->short_preamble);
-	rt2x00usb_register_write(rt2x00dev, AUTO_RSP_CFG, reg);
+	rt2800_register_write(rt2x00dev, AUTO_RSP_CFG, reg);
 
-	rt2x00usb_register_read(rt2x00dev, OFDM_PROT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, OFDM_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, OFDM_PROT_CFG_PROTECT_CTRL,
 			   erp->cts_protection ? 2 : 0);
-	rt2x00usb_register_write(rt2x00dev, OFDM_PROT_CFG, reg);
+	rt2800_register_write(rt2x00dev, OFDM_PROT_CFG, reg);
 
-	rt2x00usb_register_write(rt2x00dev, LEGACY_BASIC_RATE,
+	rt2800_register_write(rt2x00dev, LEGACY_BASIC_RATE,
 				 erp->basic_rates);
-	rt2x00usb_register_write(rt2x00dev, HT_BASIC_RATE, 0x00008003);
+	rt2800_register_write(rt2x00dev, HT_BASIC_RATE, 0x00008003);
 
-	rt2x00usb_register_read(rt2x00dev, BKOFF_SLOT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, BKOFF_SLOT_CFG, &reg);
 	rt2x00_set_field32(&reg, BKOFF_SLOT_CFG_SLOT_TIME, erp->slot_time);
 	rt2x00_set_field32(&reg, BKOFF_SLOT_CFG_CC_DELAY_TIME, 2);
-	rt2x00usb_register_write(rt2x00dev, BKOFF_SLOT_CFG, reg);
+	rt2800_register_write(rt2x00dev, BKOFF_SLOT_CFG, reg);
 
-	rt2x00usb_register_read(rt2x00dev, XIFS_TIME_CFG, &reg);
+	rt2800_register_read(rt2x00dev, XIFS_TIME_CFG, &reg);
 	rt2x00_set_field32(&reg, XIFS_TIME_CFG_CCKM_SIFS_TIME, erp->sifs);
 	rt2x00_set_field32(&reg, XIFS_TIME_CFG_OFDM_SIFS_TIME, erp->sifs);
 	rt2x00_set_field32(&reg, XIFS_TIME_CFG_OFDM_XIFS_TIME, 4);
 	rt2x00_set_field32(&reg, XIFS_TIME_CFG_EIFS, erp->eifs);
 	rt2x00_set_field32(&reg, XIFS_TIME_CFG_BB_RXEND_ENABLE, 1);
-	rt2x00usb_register_write(rt2x00dev, XIFS_TIME_CFG, reg);
+	rt2800_register_write(rt2x00dev, XIFS_TIME_CFG, reg);
 
-	rt2x00usb_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+	rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
 	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_INTERVAL,
 			   erp->beacon_int * 16);
-	rt2x00usb_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 }
 
 static void rt2800usb_config_ant(struct rt2x00_dev *rt2x00dev,
@@ -823,11 +823,11 @@ static void rt2800usb_config_channel(str
 			rt2800usb_bbp_write(rt2x00dev, 75, 0x50);
 	}
 
-	rt2x00usb_register_read(rt2x00dev, TX_BAND_CFG, &reg);
+	rt2800_register_read(rt2x00dev, TX_BAND_CFG, &reg);
 	rt2x00_set_field32(&reg, TX_BAND_CFG_HT40_PLUS, conf_is_ht40_plus(conf));
 	rt2x00_set_field32(&reg, TX_BAND_CFG_A, rf->channel > 14);
 	rt2x00_set_field32(&reg, TX_BAND_CFG_BG, rf->channel <= 14);
-	rt2x00usb_register_write(rt2x00dev, TX_BAND_CFG, reg);
+	rt2800_register_write(rt2x00dev, TX_BAND_CFG, reg);
 
 	tx_pin = 0;
 
@@ -850,7 +850,7 @@ static void rt2800usb_config_channel(str
 	rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G0_EN, rf->channel <= 14);
 	rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A0_EN, rf->channel > 14);
 
-	rt2x00usb_register_write(rt2x00dev, TX_PIN_CFG, tx_pin);
+	rt2800_register_write(rt2x00dev, TX_PIN_CFG, tx_pin);
 
 	rt2800usb_bbp_read(rt2x00dev, 4, &bbp);
 	rt2x00_set_field8(&bbp, BBP4_BANDWIDTH, 2 * conf_is_ht40(conf));
@@ -886,7 +886,7 @@ static void rt2800usb_config_txpower(str
 	rt2x00_set_field8(&reg, BBP1_TX_POWER, 0);
 	rt2800usb_bbp_write(rt2x00dev, 1, r1);
 
-	rt2x00usb_register_read(rt2x00dev, TX_PWR_CFG_0, &reg);
+	rt2800_register_read(rt2x00dev, TX_PWR_CFG_0, &reg);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_0_1MBS, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_0_2MBS, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_0_55MBS, value);
@@ -895,9 +895,9 @@ static void rt2800usb_config_txpower(str
 	rt2x00_set_field32(&reg, TX_PWR_CFG_0_9MBS, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_0_12MBS, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_0_18MBS, value);
-	rt2x00usb_register_write(rt2x00dev, TX_PWR_CFG_0, reg);
+	rt2800_register_write(rt2x00dev, TX_PWR_CFG_0, reg);
 
-	rt2x00usb_register_read(rt2x00dev, TX_PWR_CFG_1, &reg);
+	rt2800_register_read(rt2x00dev, TX_PWR_CFG_1, &reg);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_1_24MBS, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_1_36MBS, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_1_48MBS, value);
@@ -906,9 +906,9 @@ static void rt2800usb_config_txpower(str
 	rt2x00_set_field32(&reg, TX_PWR_CFG_1_MCS1, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_1_MCS2, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_1_MCS3, value);
-	rt2x00usb_register_write(rt2x00dev, TX_PWR_CFG_1, reg);
+	rt2800_register_write(rt2x00dev, TX_PWR_CFG_1, reg);
 
-	rt2x00usb_register_read(rt2x00dev, TX_PWR_CFG_2, &reg);
+	rt2800_register_read(rt2x00dev, TX_PWR_CFG_2, &reg);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_2_MCS4, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_2_MCS5, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_2_MCS6, value);
@@ -917,9 +917,9 @@ static void rt2800usb_config_txpower(str
 	rt2x00_set_field32(&reg, TX_PWR_CFG_2_MCS9, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_2_MCS10, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_2_MCS11, value);
-	rt2x00usb_register_write(rt2x00dev, TX_PWR_CFG_2, reg);
+	rt2800_register_write(rt2x00dev, TX_PWR_CFG_2, reg);
 
-	rt2x00usb_register_read(rt2x00dev, TX_PWR_CFG_3, &reg);
+	rt2800_register_read(rt2x00dev, TX_PWR_CFG_3, &reg);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_3_MCS12, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_3_MCS13, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_3_MCS14, value);
@@ -928,14 +928,14 @@ static void rt2800usb_config_txpower(str
 	rt2x00_set_field32(&reg, TX_PWR_CFG_3_UKNOWN2, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_3_UKNOWN3, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_3_UKNOWN4, value);
-	rt2x00usb_register_write(rt2x00dev, TX_PWR_CFG_3, reg);
+	rt2800_register_write(rt2x00dev, TX_PWR_CFG_3, reg);
 
-	rt2x00usb_register_read(rt2x00dev, TX_PWR_CFG_4, &reg);
+	rt2800_register_read(rt2x00dev, TX_PWR_CFG_4, &reg);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_4_UKNOWN5, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_4_UKNOWN6, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_4_UKNOWN7, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_4_UKNOWN8, value);
-	rt2x00usb_register_write(rt2x00dev, TX_PWR_CFG_4, reg);
+	rt2800_register_write(rt2x00dev, TX_PWR_CFG_4, reg);
 }
 
 static void rt2800usb_config_retry_limit(struct rt2x00_dev *rt2x00dev,
@@ -943,7 +943,7 @@ static void rt2800usb_config_retry_limit
 {
 	u32 reg;
 
-	rt2x00usb_register_read(rt2x00dev, TX_RTY_CFG, &reg);
+	rt2800_register_read(rt2x00dev, TX_RTY_CFG, &reg);
 	rt2x00_set_field32(&reg, TX_RTY_CFG_SHORT_RTY_LIMIT,
 			   libconf->conf->short_frame_max_tx_count);
 	rt2x00_set_field32(&reg, TX_RTY_CFG_LONG_RTY_LIMIT,
@@ -952,7 +952,7 @@ static void rt2800usb_config_retry_limit
 	rt2x00_set_field32(&reg, TX_RTY_CFG_NON_AGG_RTY_MODE, 0);
 	rt2x00_set_field32(&reg, TX_RTY_CFG_AGG_RTY_MODE, 0);
 	rt2x00_set_field32(&reg, TX_RTY_CFG_TX_AUTO_FB_ENABLE, 1);
-	rt2x00usb_register_write(rt2x00dev, TX_RTY_CFG, reg);
+	rt2800_register_write(rt2x00dev, TX_RTY_CFG, reg);
 }
 
 static void rt2800usb_config_ps(struct rt2x00_dev *rt2x00dev,
@@ -964,24 +964,24 @@ static void rt2800usb_config_ps(struct r
 	u32 reg;
 
 	if (state == STATE_SLEEP) {
-		rt2x00usb_register_write(rt2x00dev, AUTOWAKEUP_CFG, 0);
+		rt2800_register_write(rt2x00dev, AUTOWAKEUP_CFG, 0);
 
-		rt2x00usb_register_read(rt2x00dev, AUTOWAKEUP_CFG, &reg);
+		rt2800_register_read(rt2x00dev, AUTOWAKEUP_CFG, &reg);
 		rt2x00_set_field32(&reg, AUTOWAKEUP_CFG_AUTO_LEAD_TIME, 5);
 		rt2x00_set_field32(&reg, AUTOWAKEUP_CFG_TBCN_BEFORE_WAKE,
 				   libconf->conf->listen_interval - 1);
 		rt2x00_set_field32(&reg, AUTOWAKEUP_CFG_AUTOWAKE, 1);
-		rt2x00usb_register_write(rt2x00dev, AUTOWAKEUP_CFG, reg);
+		rt2800_register_write(rt2x00dev, AUTOWAKEUP_CFG, reg);
 
 		rt2x00dev->ops->lib->set_device_state(rt2x00dev, state);
 	} else {
 		rt2x00dev->ops->lib->set_device_state(rt2x00dev, state);
 
-		rt2x00usb_register_read(rt2x00dev, AUTOWAKEUP_CFG, &reg);
+		rt2800_register_read(rt2x00dev, AUTOWAKEUP_CFG, &reg);
 		rt2x00_set_field32(&reg, AUTOWAKEUP_CFG_AUTO_LEAD_TIME, 0);
 		rt2x00_set_field32(&reg, AUTOWAKEUP_CFG_TBCN_BEFORE_WAKE, 0);
 		rt2x00_set_field32(&reg, AUTOWAKEUP_CFG_AUTOWAKE, 0);
-		rt2x00usb_register_write(rt2x00dev, AUTOWAKEUP_CFG, reg);
+		rt2800_register_write(rt2x00dev, AUTOWAKEUP_CFG, reg);
 	}
 }
 
@@ -1014,7 +1014,7 @@ static void rt2800usb_link_stats(struct 
 	/*
 	 * Update FCS error count from register.
 	 */
-	rt2x00usb_register_read(rt2x00dev, RX_STA_CNT0, &reg);
+	rt2800_register_read(rt2x00dev, RX_STA_CNT0, &reg);
 	qual->rx_failed = rt2x00_get_field32(reg, RX_STA_CNT0_CRC_ERR);
 }
 
@@ -1172,7 +1172,7 @@ static int rt2800usb_load_firmware(struc
 	 * Wait for stable hardware.
 	 */
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt2x00usb_register_read(rt2x00dev, MAC_CSR0, &reg);
+		rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
 		if (reg && reg != ~0)
 			break;
 		msleep(1);
@@ -1192,8 +1192,8 @@ static int rt2800usb_load_firmware(struc
 					    data + offset, length,
 					    REGISTER_TIMEOUT32(length));
 
-	rt2x00usb_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
-	rt2x00usb_register_write(rt2x00dev, H2M_MAILBOX_STATUS, ~0);
+	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
+	rt2800_register_write(rt2x00dev, H2M_MAILBOX_STATUS, ~0);
 
 	/*
 	 * Send firmware request to device to load firmware,
@@ -1208,7 +1208,7 @@ static int rt2800usb_load_firmware(struc
 	}
 
 	msleep(10);
-	rt2x00usb_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
+	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
 
 	/*
 	 * Send signal to firmware during boot time.
@@ -1227,7 +1227,7 @@ static int rt2800usb_load_firmware(struc
 	 * Wait for device to stabilize.
 	 */
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt2x00usb_register_read(rt2x00dev, PBF_SYS_CTRL, &reg);
+		rt2800_register_read(rt2x00dev, PBF_SYS_CTRL, &reg);
 		if (rt2x00_get_field32(reg, PBF_SYS_CTRL_READY))
 			break;
 		msleep(1);
@@ -1241,8 +1241,8 @@ static int rt2800usb_load_firmware(struc
 	/*
 	 * Initialize firmware.
 	 */
-	rt2x00usb_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
-	rt2x00usb_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
+	rt2800_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
+	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
 	msleep(1);
 
 	return 0;
@@ -1260,7 +1260,7 @@ static int rt2800usb_init_registers(stru
 	 * Wait untill BBP and RF are ready.
 	 */
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt2x00usb_register_read(rt2x00dev, MAC_CSR0, &reg);
+		rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
 		if (reg && reg != ~0)
 			break;
 		msleep(1);
@@ -1271,59 +1271,59 @@ static int rt2800usb_init_registers(stru
 		return -EBUSY;
 	}
 
-	rt2x00usb_register_read(rt2x00dev, PBF_SYS_CTRL, &reg);
-	rt2x00usb_register_write(rt2x00dev, PBF_SYS_CTRL, reg & ~0x00002000);
+	rt2800_register_read(rt2x00dev, PBF_SYS_CTRL, &reg);
+	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, reg & ~0x00002000);
 
-	rt2x00usb_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
+	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_CSR, 1);
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_BBP, 1);
-	rt2x00usb_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
 
-	rt2x00usb_register_write(rt2x00dev, USB_DMA_CFG, 0x00000000);
+	rt2800_register_write(rt2x00dev, USB_DMA_CFG, 0x00000000);
 
 	rt2x00usb_vendor_request_sw(rt2x00dev, USB_DEVICE_MODE, 0,
 				    USB_MODE_RESET, REGISTER_TIMEOUT);
 
-	rt2x00usb_register_write(rt2x00dev, MAC_SYS_CTRL, 0x00000000);
+	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, 0x00000000);
 
-	rt2x00usb_register_read(rt2x00dev, BCN_OFFSET0, &reg);
+	rt2800_register_read(rt2x00dev, BCN_OFFSET0, &reg);
 	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN0, 0xe0); /* 0x3800 */
 	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN1, 0xe8); /* 0x3a00 */
 	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN2, 0xf0); /* 0x3c00 */
 	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN3, 0xf8); /* 0x3e00 */
-	rt2x00usb_register_write(rt2x00dev, BCN_OFFSET0, reg);
+	rt2800_register_write(rt2x00dev, BCN_OFFSET0, reg);
 
-	rt2x00usb_register_read(rt2x00dev, BCN_OFFSET1, &reg);
+	rt2800_register_read(rt2x00dev, BCN_OFFSET1, &reg);
 	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN4, 0xc8); /* 0x3200 */
 	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN5, 0xd0); /* 0x3400 */
 	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN6, 0x77); /* 0x1dc0 */
 	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN7, 0x6f); /* 0x1bc0 */
-	rt2x00usb_register_write(rt2x00dev, BCN_OFFSET1, reg);
+	rt2800_register_write(rt2x00dev, BCN_OFFSET1, reg);
 
-	rt2x00usb_register_write(rt2x00dev, LEGACY_BASIC_RATE, 0x0000013f);
-	rt2x00usb_register_write(rt2x00dev, HT_BASIC_RATE, 0x00008003);
+	rt2800_register_write(rt2x00dev, LEGACY_BASIC_RATE, 0x0000013f);
+	rt2800_register_write(rt2x00dev, HT_BASIC_RATE, 0x00008003);
 
-	rt2x00usb_register_write(rt2x00dev, MAC_SYS_CTRL, 0x00000000);
+	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, 0x00000000);
 
-	rt2x00usb_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+	rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
 	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_INTERVAL, 0);
 	rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 0);
 	rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_SYNC, 0);
 	rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 0);
 	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 0);
 	rt2x00_set_field32(&reg, BCN_TIME_CFG_TX_TIME_COMPENSATE, 0);
-	rt2x00usb_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 
 	if (rt2x00_rev(&rt2x00dev->chip) == RT3070_VERSION) {
-		rt2x00usb_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
-		rt2x00usb_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
-		rt2x00usb_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
+		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
+		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
+		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
 	} else {
-		rt2x00usb_register_write(rt2x00dev, TX_SW_CFG0, 0x00000000);
-		rt2x00usb_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
+		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000000);
+		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
 	}
 
-	rt2x00usb_register_read(rt2x00dev, TX_LINK_CFG, &reg);
+	rt2800_register_read(rt2x00dev, TX_LINK_CFG, &reg);
 	rt2x00_set_field32(&reg, TX_LINK_CFG_REMOTE_MFB_LIFETIME, 32);
 	rt2x00_set_field32(&reg, TX_LINK_CFG_MFB_ENABLE, 0);
 	rt2x00_set_field32(&reg, TX_LINK_CFG_REMOTE_UMFS_ENABLE, 0);
@@ -1332,14 +1332,14 @@ static int rt2800usb_init_registers(stru
 	rt2x00_set_field32(&reg, TX_LINK_CFG_TX_CF_ACK_EN, 1);
 	rt2x00_set_field32(&reg, TX_LINK_CFG_REMOTE_MFB, 0);
 	rt2x00_set_field32(&reg, TX_LINK_CFG_REMOTE_MFS, 0);
-	rt2x00usb_register_write(rt2x00dev, TX_LINK_CFG, reg);
+	rt2800_register_write(rt2x00dev, TX_LINK_CFG, reg);
 
-	rt2x00usb_register_read(rt2x00dev, TX_TIMEOUT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, TX_TIMEOUT_CFG, &reg);
 	rt2x00_set_field32(&reg, TX_TIMEOUT_CFG_MPDU_LIFETIME, 9);
 	rt2x00_set_field32(&reg, TX_TIMEOUT_CFG_TX_OP_TIMEOUT, 10);
-	rt2x00usb_register_write(rt2x00dev, TX_TIMEOUT_CFG, reg);
+	rt2800_register_write(rt2x00dev, TX_TIMEOUT_CFG, reg);
 
-	rt2x00usb_register_read(rt2x00dev, MAX_LEN_CFG, &reg);
+	rt2800_register_read(rt2x00dev, MAX_LEN_CFG, &reg);
 	rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_MPDU, AGGREGATION_SIZE);
 	if (rt2x00_rev(&rt2x00dev->chip) >= RT2880E_VERSION &&
 	    rt2x00_rev(&rt2x00dev->chip) < RT3070_VERSION)
@@ -1348,19 +1348,19 @@ static int rt2800usb_init_registers(stru
 		rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 1);
 	rt2x00_set_field32(&reg, MAX_LEN_CFG_MIN_PSDU, 0);
 	rt2x00_set_field32(&reg, MAX_LEN_CFG_MIN_MPDU, 0);
-	rt2x00usb_register_write(rt2x00dev, MAX_LEN_CFG, reg);
+	rt2800_register_write(rt2x00dev, MAX_LEN_CFG, reg);
 
-	rt2x00usb_register_write(rt2x00dev, PBF_MAX_PCNT, 0x1f3fbf9f);
+	rt2800_register_write(rt2x00dev, PBF_MAX_PCNT, 0x1f3fbf9f);
 
-	rt2x00usb_register_read(rt2x00dev, AUTO_RSP_CFG, &reg);
+	rt2800_register_read(rt2x00dev, AUTO_RSP_CFG, &reg);
 	rt2x00_set_field32(&reg, AUTO_RSP_CFG_AUTORESPONDER, 1);
 	rt2x00_set_field32(&reg, AUTO_RSP_CFG_CTS_40_MMODE, 0);
 	rt2x00_set_field32(&reg, AUTO_RSP_CFG_CTS_40_MREF, 0);
 	rt2x00_set_field32(&reg, AUTO_RSP_CFG_DUAL_CTS_EN, 0);
 	rt2x00_set_field32(&reg, AUTO_RSP_CFG_ACK_CTS_PSM_BIT, 0);
-	rt2x00usb_register_write(rt2x00dev, AUTO_RSP_CFG, reg);
+	rt2800_register_write(rt2x00dev, AUTO_RSP_CFG, reg);
 
-	rt2x00usb_register_read(rt2x00dev, CCK_PROT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, CCK_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, CCK_PROT_CFG_PROTECT_RATE, 8);
 	rt2x00_set_field32(&reg, CCK_PROT_CFG_PROTECT_CTRL, 0);
 	rt2x00_set_field32(&reg, CCK_PROT_CFG_PROTECT_NAV, 1);
@@ -1370,9 +1370,9 @@ static int rt2800usb_init_registers(stru
 	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_MM40, 1);
 	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_GF20, 1);
 	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_GF40, 1);
-	rt2x00usb_register_write(rt2x00dev, CCK_PROT_CFG, reg);
+	rt2800_register_write(rt2x00dev, CCK_PROT_CFG, reg);
 
-	rt2x00usb_register_read(rt2x00dev, OFDM_PROT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, OFDM_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, OFDM_PROT_CFG_PROTECT_RATE, 8);
 	rt2x00_set_field32(&reg, OFDM_PROT_CFG_PROTECT_CTRL, 0);
 	rt2x00_set_field32(&reg, OFDM_PROT_CFG_PROTECT_NAV, 1);
@@ -1382,9 +1382,9 @@ static int rt2800usb_init_registers(stru
 	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_MM40, 1);
 	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_GF20, 1);
 	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_GF40, 1);
-	rt2x00usb_register_write(rt2x00dev, OFDM_PROT_CFG, reg);
+	rt2800_register_write(rt2x00dev, OFDM_PROT_CFG, reg);
 
-	rt2x00usb_register_read(rt2x00dev, MM20_PROT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, MM20_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_RATE, 0x4004);
 	rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_CTRL, 0);
 	rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_NAV, 1);
@@ -1394,9 +1394,9 @@ static int rt2800usb_init_registers(stru
 	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_MM40, 0);
 	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_GF20, 1);
 	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_GF40, 0);
-	rt2x00usb_register_write(rt2x00dev, MM20_PROT_CFG, reg);
+	rt2800_register_write(rt2x00dev, MM20_PROT_CFG, reg);
 
-	rt2x00usb_register_read(rt2x00dev, MM40_PROT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, MM40_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_RATE, 0x4084);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_CTRL, 0);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_NAV, 1);
@@ -1406,9 +1406,9 @@ static int rt2800usb_init_registers(stru
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_MM40, 1);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_GF20, 1);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_GF40, 1);
-	rt2x00usb_register_write(rt2x00dev, MM40_PROT_CFG, reg);
+	rt2800_register_write(rt2x00dev, MM40_PROT_CFG, reg);
 
-	rt2x00usb_register_read(rt2x00dev, GF20_PROT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, GF20_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, GF20_PROT_CFG_PROTECT_RATE, 0x4004);
 	rt2x00_set_field32(&reg, GF20_PROT_CFG_PROTECT_CTRL, 0);
 	rt2x00_set_field32(&reg, GF20_PROT_CFG_PROTECT_NAV, 1);
@@ -1418,9 +1418,9 @@ static int rt2800usb_init_registers(stru
 	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_MM40, 0);
 	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_GF20, 1);
 	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_GF40, 0);
-	rt2x00usb_register_write(rt2x00dev, GF20_PROT_CFG, reg);
+	rt2800_register_write(rt2x00dev, GF20_PROT_CFG, reg);
 
-	rt2x00usb_register_read(rt2x00dev, GF40_PROT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, GF40_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, GF40_PROT_CFG_PROTECT_RATE, 0x4084);
 	rt2x00_set_field32(&reg, GF40_PROT_CFG_PROTECT_CTRL, 0);
 	rt2x00_set_field32(&reg, GF40_PROT_CFG_PROTECT_NAV, 1);
@@ -1430,11 +1430,11 @@ static int rt2800usb_init_registers(stru
 	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_MM40, 1);
 	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_GF20, 1);
 	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_GF40, 1);
-	rt2x00usb_register_write(rt2x00dev, GF40_PROT_CFG, reg);
+	rt2800_register_write(rt2x00dev, GF40_PROT_CFG, reg);
 
-	rt2x00usb_register_write(rt2x00dev, PBF_CFG, 0xf40006);
+	rt2800_register_write(rt2x00dev, PBF_CFG, 0xf40006);
 
-	rt2x00usb_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
+	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_DMA_BUSY, 0);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
@@ -1444,26 +1444,26 @@ static int rt2800usb_init_registers(stru
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_BIG_ENDIAN, 0);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_RX_HDR_SCATTER, 0);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_HDR_SEG_LEN, 0);
-	rt2x00usb_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
+	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
 
-	rt2x00usb_register_write(rt2x00dev, TXOP_CTRL_CFG, 0x0000583f);
-	rt2x00usb_register_write(rt2x00dev, TXOP_HLDR_ET, 0x00000002);
+	rt2800_register_write(rt2x00dev, TXOP_CTRL_CFG, 0x0000583f);
+	rt2800_register_write(rt2x00dev, TXOP_HLDR_ET, 0x00000002);
 
-	rt2x00usb_register_read(rt2x00dev, TX_RTS_CFG, &reg);
+	rt2800_register_read(rt2x00dev, TX_RTS_CFG, &reg);
 	rt2x00_set_field32(&reg, TX_RTS_CFG_AUTO_RTS_RETRY_LIMIT, 32);
 	rt2x00_set_field32(&reg, TX_RTS_CFG_RTS_THRES,
 			   IEEE80211_MAX_RTS_THRESHOLD);
 	rt2x00_set_field32(&reg, TX_RTS_CFG_RTS_FBK_EN, 0);
-	rt2x00usb_register_write(rt2x00dev, TX_RTS_CFG, reg);
+	rt2800_register_write(rt2x00dev, TX_RTS_CFG, reg);
 
-	rt2x00usb_register_write(rt2x00dev, EXP_ACK_TIME, 0x002400ca);
-	rt2x00usb_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
+	rt2800_register_write(rt2x00dev, EXP_ACK_TIME, 0x002400ca);
+	rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
 
 	/*
 	 * ASIC will keep garbage value after boot, clear encryption keys.
 	 */
 	for (i = 0; i < 4; i++)
-		rt2x00usb_register_write(rt2x00dev,
+		rt2800_register_write(rt2x00dev,
 					 SHARED_KEY_MODE_ENTRY(i), 0);
 
 	for (i = 0; i < 256; i++) {
@@ -1471,8 +1471,8 @@ static int rt2800usb_init_registers(stru
 		rt2x00usb_register_multiwrite(rt2x00dev, MAC_WCID_ENTRY(i),
 					      wcid, sizeof(wcid));
 
-		rt2x00usb_register_write(rt2x00dev, MAC_WCID_ATTR_ENTRY(i), 1);
-		rt2x00usb_register_write(rt2x00dev, MAC_IVEIV_ENTRY(i), 0);
+		rt2800_register_write(rt2x00dev, MAC_WCID_ATTR_ENTRY(i), 1);
+		rt2800_register_write(rt2x00dev, MAC_IVEIV_ENTRY(i), 0);
 	}
 
 	/*
@@ -1481,20 +1481,20 @@ static int rt2800usb_init_registers(stru
 	 * the first byte since that byte contains the VALID and OWNER
 	 * bits which (when set to 0) will invalidate the entire beacon.
 	 */
-	rt2x00usb_register_write(rt2x00dev, HW_BEACON_BASE0, 0);
-	rt2x00usb_register_write(rt2x00dev, HW_BEACON_BASE1, 0);
-	rt2x00usb_register_write(rt2x00dev, HW_BEACON_BASE2, 0);
-	rt2x00usb_register_write(rt2x00dev, HW_BEACON_BASE3, 0);
-	rt2x00usb_register_write(rt2x00dev, HW_BEACON_BASE4, 0);
-	rt2x00usb_register_write(rt2x00dev, HW_BEACON_BASE5, 0);
-	rt2x00usb_register_write(rt2x00dev, HW_BEACON_BASE6, 0);
-	rt2x00usb_register_write(rt2x00dev, HW_BEACON_BASE7, 0);
+	rt2800_register_write(rt2x00dev, HW_BEACON_BASE0, 0);
+	rt2800_register_write(rt2x00dev, HW_BEACON_BASE1, 0);
+	rt2800_register_write(rt2x00dev, HW_BEACON_BASE2, 0);
+	rt2800_register_write(rt2x00dev, HW_BEACON_BASE3, 0);
+	rt2800_register_write(rt2x00dev, HW_BEACON_BASE4, 0);
+	rt2800_register_write(rt2x00dev, HW_BEACON_BASE5, 0);
+	rt2800_register_write(rt2x00dev, HW_BEACON_BASE6, 0);
+	rt2800_register_write(rt2x00dev, HW_BEACON_BASE7, 0);
 
-	rt2x00usb_register_read(rt2x00dev, USB_CYC_CFG, &reg);
+	rt2800_register_read(rt2x00dev, USB_CYC_CFG, &reg);
 	rt2x00_set_field32(&reg, USB_CYC_CFG_CLOCK_CYCLE, 30);
-	rt2x00usb_register_write(rt2x00dev, USB_CYC_CFG, reg);
+	rt2800_register_write(rt2x00dev, USB_CYC_CFG, reg);
 
-	rt2x00usb_register_read(rt2x00dev, HT_FBK_CFG0, &reg);
+	rt2800_register_read(rt2x00dev, HT_FBK_CFG0, &reg);
 	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS0FBK, 0);
 	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS1FBK, 0);
 	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS2FBK, 1);
@@ -1503,9 +1503,9 @@ static int rt2800usb_init_registers(stru
 	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS5FBK, 4);
 	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS6FBK, 5);
 	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS7FBK, 6);
-	rt2x00usb_register_write(rt2x00dev, HT_FBK_CFG0, reg);
+	rt2800_register_write(rt2x00dev, HT_FBK_CFG0, reg);
 
-	rt2x00usb_register_read(rt2x00dev, HT_FBK_CFG1, &reg);
+	rt2800_register_read(rt2x00dev, HT_FBK_CFG1, &reg);
 	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS8FBK, 8);
 	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS9FBK, 8);
 	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS10FBK, 9);
@@ -1514,9 +1514,9 @@ static int rt2800usb_init_registers(stru
 	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS13FBK, 12);
 	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS14FBK, 13);
 	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS15FBK, 14);
-	rt2x00usb_register_write(rt2x00dev, HT_FBK_CFG1, reg);
+	rt2800_register_write(rt2x00dev, HT_FBK_CFG1, reg);
 
-	rt2x00usb_register_read(rt2x00dev, LG_FBK_CFG0, &reg);
+	rt2800_register_read(rt2x00dev, LG_FBK_CFG0, &reg);
 	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS0FBK, 8);
 	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS1FBK, 8);
 	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS2FBK, 9);
@@ -1525,26 +1525,26 @@ static int rt2800usb_init_registers(stru
 	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS5FBK, 12);
 	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS6FBK, 13);
 	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS7FBK, 14);
-	rt2x00usb_register_write(rt2x00dev, LG_FBK_CFG0, reg);
+	rt2800_register_write(rt2x00dev, LG_FBK_CFG0, reg);
 
-	rt2x00usb_register_read(rt2x00dev, LG_FBK_CFG1, &reg);
+	rt2800_register_read(rt2x00dev, LG_FBK_CFG1, &reg);
 	rt2x00_set_field32(&reg, LG_FBK_CFG0_CCKMCS0FBK, 0);
 	rt2x00_set_field32(&reg, LG_FBK_CFG0_CCKMCS1FBK, 0);
 	rt2x00_set_field32(&reg, LG_FBK_CFG0_CCKMCS2FBK, 1);
 	rt2x00_set_field32(&reg, LG_FBK_CFG0_CCKMCS3FBK, 2);
-	rt2x00usb_register_write(rt2x00dev, LG_FBK_CFG1, reg);
+	rt2800_register_write(rt2x00dev, LG_FBK_CFG1, reg);
 
 	/*
 	 * We must clear the error counters.
 	 * These registers are cleared on read,
 	 * so we may pass a useless variable to store the value.
 	 */
-	rt2x00usb_register_read(rt2x00dev, RX_STA_CNT0, &reg);
-	rt2x00usb_register_read(rt2x00dev, RX_STA_CNT1, &reg);
-	rt2x00usb_register_read(rt2x00dev, RX_STA_CNT2, &reg);
-	rt2x00usb_register_read(rt2x00dev, TX_STA_CNT0, &reg);
-	rt2x00usb_register_read(rt2x00dev, TX_STA_CNT1, &reg);
-	rt2x00usb_register_read(rt2x00dev, TX_STA_CNT2, &reg);
+	rt2800_register_read(rt2x00dev, RX_STA_CNT0, &reg);
+	rt2800_register_read(rt2x00dev, RX_STA_CNT1, &reg);
+	rt2800_register_read(rt2x00dev, RX_STA_CNT2, &reg);
+	rt2800_register_read(rt2x00dev, TX_STA_CNT0, &reg);
+	rt2800_register_read(rt2x00dev, TX_STA_CNT1, &reg);
+	rt2800_register_read(rt2x00dev, TX_STA_CNT2, &reg);
 
 	return 0;
 }
@@ -1555,7 +1555,7 @@ static int rt2800usb_wait_bbp_rf_ready(s
 	u32 reg;
 
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt2x00usb_register_read(rt2x00dev, MAC_STATUS_CFG, &reg);
+		rt2800_register_read(rt2x00dev, MAC_STATUS_CFG, &reg);
 		if (!rt2x00_get_field32(reg, MAC_STATUS_CFG_BBP_RF_BUSY))
 			return 0;
 
@@ -1575,8 +1575,8 @@ static int rt2800usb_wait_bbp_ready(stru
 	 * BBP was enabled after firmware was loaded,
 	 * but we need to reactivate it now.
 	 */
-	rt2x00usb_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
-	rt2x00usb_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
+	rt2800_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
+	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
 	msleep(1);
 
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
@@ -1778,11 +1778,11 @@ static void rt2800usb_toggle_rx(struct r
 {
 	u32 reg;
 
-	rt2x00usb_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
+	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX,
 			   (state == STATE_RADIO_RX_ON) ||
 			   (state == STATE_RADIO_RX_ON_LINK));
-	rt2x00usb_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
 }
 
 static int rt2800usb_wait_wpdma_ready(struct rt2x00_dev *rt2x00dev)
@@ -1791,7 +1791,7 @@ static int rt2800usb_wait_wpdma_ready(st
 	u32 reg;
 
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt2x00usb_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
+		rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
 		if (!rt2x00_get_field32(reg, WPDMA_GLO_CFG_TX_DMA_BUSY) &&
 		    !rt2x00_get_field32(reg, WPDMA_GLO_CFG_RX_DMA_BUSY))
 			return 0;
@@ -1817,20 +1817,20 @@ static int rt2800usb_enable_radio(struct
 		     rt2800usb_init_rfcsr(rt2x00dev)))
 		return -EIO;
 
-	rt2x00usb_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
+	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_TX, 1);
-	rt2x00usb_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
 
 	udelay(50);
 
-	rt2x00usb_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
+	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_WRITEBACK_DONE, 1);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 1);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 1);
-	rt2x00usb_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
+	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
 
 
-	rt2x00usb_register_read(rt2x00dev, USB_DMA_CFG, &reg);
+	rt2800_register_read(rt2x00dev, USB_DMA_CFG, &reg);
 	rt2x00_set_field32(&reg, USB_DMA_CFG_PHY_CLEAR, 0);
 	/* Don't use bulk in aggregation when working with USB 1.1 */
 	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_EN,
@@ -1844,12 +1844,12 @@ static int rt2800usb_enable_radio(struct
 			   ((RX_ENTRIES * DATA_FRAME_SIZE) / 1024) - 3);
 	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_EN, 1);
 	rt2x00_set_field32(&reg, USB_DMA_CFG_TX_BULK_EN, 1);
-	rt2x00usb_register_write(rt2x00dev, USB_DMA_CFG, reg);
+	rt2800_register_write(rt2x00dev, USB_DMA_CFG, reg);
 
-	rt2x00usb_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
+	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_TX, 1);
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX, 1);
-	rt2x00usb_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
 
 	/*
 	 * Initialize LED control
@@ -1873,14 +1873,14 @@ static void rt2800usb_disable_radio(stru
 {
 	u32 reg;
 
-	rt2x00usb_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
+	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
-	rt2x00usb_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
+	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
 
-	rt2x00usb_register_write(rt2x00dev, MAC_SYS_CTRL, 0);
-	rt2x00usb_register_write(rt2x00dev, PWR_PIN_CFG, 0);
-	rt2x00usb_register_write(rt2x00dev, TX_PIN_CFG, 0);
+	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, 0);
+	rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0);
+	rt2800_register_write(rt2x00dev, TX_PIN_CFG, 0);
 
 	/* Wait for DMA, ignore error */
 	rt2800usb_wait_wpdma_ready(rt2x00dev);
@@ -2048,9 +2048,9 @@ static void rt2800usb_write_beacon(struc
 	 * Disable beaconing while we are reloading the beacon data,
 	 * otherwise we might be sending out invalid data.
 	 */
-	rt2x00usb_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+	rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
 	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 0);
-	rt2x00usb_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 
 	/*
 	 * Write entire beacon with descriptor to register.
@@ -2093,12 +2093,12 @@ static void rt2800usb_kick_tx_queue(stru
 		return;
 	}
 
-	rt2x00usb_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+	rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
 	if (!rt2x00_get_field32(reg, BCN_TIME_CFG_BEACON_GEN)) {
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 1);
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 1);
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 1);
-		rt2x00usb_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 	}
 }
 
@@ -2326,7 +2326,7 @@ static int rt2800usb_init_eeprom(struct 
 	 * Identify RF chipset.
 	 */
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
-	rt2x00usb_register_read(rt2x00dev, MAC_CSR0, &reg);
+	rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
 	rt2x00_set_chip(rt2x00dev, RT2870, value, reg);
 
 	/*
@@ -2669,33 +2669,33 @@ static int rt2800usb_set_rts_threshold(s
 	u32 reg;
 	bool enabled = (value < IEEE80211_MAX_RTS_THRESHOLD);
 
-	rt2x00usb_register_read(rt2x00dev, TX_RTS_CFG, &reg);
+	rt2800_register_read(rt2x00dev, TX_RTS_CFG, &reg);
 	rt2x00_set_field32(&reg, TX_RTS_CFG_RTS_THRES, value);
-	rt2x00usb_register_write(rt2x00dev, TX_RTS_CFG, reg);
+	rt2800_register_write(rt2x00dev, TX_RTS_CFG, reg);
 
-	rt2x00usb_register_read(rt2x00dev, CCK_PROT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, CCK_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, CCK_PROT_CFG_RTS_TH_EN, enabled);
-	rt2x00usb_register_write(rt2x00dev, CCK_PROT_CFG, reg);
+	rt2800_register_write(rt2x00dev, CCK_PROT_CFG, reg);
 
-	rt2x00usb_register_read(rt2x00dev, OFDM_PROT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, OFDM_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, OFDM_PROT_CFG_RTS_TH_EN, enabled);
-	rt2x00usb_register_write(rt2x00dev, OFDM_PROT_CFG, reg);
+	rt2800_register_write(rt2x00dev, OFDM_PROT_CFG, reg);
 
-	rt2x00usb_register_read(rt2x00dev, MM20_PROT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, MM20_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, MM20_PROT_CFG_RTS_TH_EN, enabled);
-	rt2x00usb_register_write(rt2x00dev, MM20_PROT_CFG, reg);
+	rt2800_register_write(rt2x00dev, MM20_PROT_CFG, reg);
 
-	rt2x00usb_register_read(rt2x00dev, MM40_PROT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, MM40_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_RTS_TH_EN, enabled);
-	rt2x00usb_register_write(rt2x00dev, MM40_PROT_CFG, reg);
+	rt2800_register_write(rt2x00dev, MM40_PROT_CFG, reg);
 
-	rt2x00usb_register_read(rt2x00dev, GF20_PROT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, GF20_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, GF20_PROT_CFG_RTS_TH_EN, enabled);
-	rt2x00usb_register_write(rt2x00dev, GF20_PROT_CFG, reg);
+	rt2800_register_write(rt2x00dev, GF20_PROT_CFG, reg);
 
-	rt2x00usb_register_read(rt2x00dev, GF40_PROT_CFG, &reg);
+	rt2800_register_read(rt2x00dev, GF40_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, GF40_PROT_CFG_RTS_TH_EN, enabled);
-	rt2x00usb_register_write(rt2x00dev, GF40_PROT_CFG, reg);
+	rt2800_register_write(rt2x00dev, GF40_PROT_CFG, reg);
 
 	return 0;
 }
@@ -2734,35 +2734,35 @@ static int rt2800usb_conf_tx(struct ieee
 	field.bit_offset = (queue_idx & 1) * 16;
 	field.bit_mask = 0xffff << field.bit_offset;
 
-	rt2x00usb_register_read(rt2x00dev, offset, &reg);
+	rt2800_register_read(rt2x00dev, offset, &reg);
 	rt2x00_set_field32(&reg, field, queue->txop);
-	rt2x00usb_register_write(rt2x00dev, offset, reg);
+	rt2800_register_write(rt2x00dev, offset, reg);
 
 	/* Update WMM registers */
 	field.bit_offset = queue_idx * 4;
 	field.bit_mask = 0xf << field.bit_offset;
 
-	rt2x00usb_register_read(rt2x00dev, WMM_AIFSN_CFG, &reg);
+	rt2800_register_read(rt2x00dev, WMM_AIFSN_CFG, &reg);
 	rt2x00_set_field32(&reg, field, queue->aifs);
-	rt2x00usb_register_write(rt2x00dev, WMM_AIFSN_CFG, reg);
+	rt2800_register_write(rt2x00dev, WMM_AIFSN_CFG, reg);
 
-	rt2x00usb_register_read(rt2x00dev, WMM_CWMIN_CFG, &reg);
+	rt2800_register_read(rt2x00dev, WMM_CWMIN_CFG, &reg);
 	rt2x00_set_field32(&reg, field, queue->cw_min);
-	rt2x00usb_register_write(rt2x00dev, WMM_CWMIN_CFG, reg);
+	rt2800_register_write(rt2x00dev, WMM_CWMIN_CFG, reg);
 
-	rt2x00usb_register_read(rt2x00dev, WMM_CWMAX_CFG, &reg);
+	rt2800_register_read(rt2x00dev, WMM_CWMAX_CFG, &reg);
 	rt2x00_set_field32(&reg, field, queue->cw_max);
-	rt2x00usb_register_write(rt2x00dev, WMM_CWMAX_CFG, reg);
+	rt2800_register_write(rt2x00dev, WMM_CWMAX_CFG, reg);
 
 	/* Update EDCA registers */
 	offset = EDCA_AC0_CFG + (sizeof(u32) * queue_idx);
 
-	rt2x00usb_register_read(rt2x00dev, offset, &reg);
+	rt2800_register_read(rt2x00dev, offset, &reg);
 	rt2x00_set_field32(&reg, EDCA_AC0_CFG_TX_OP, queue->txop);
 	rt2x00_set_field32(&reg, EDCA_AC0_CFG_AIFSN, queue->aifs);
 	rt2x00_set_field32(&reg, EDCA_AC0_CFG_CWMIN, queue->cw_min);
 	rt2x00_set_field32(&reg, EDCA_AC0_CFG_CWMAX, queue->cw_max);
-	rt2x00usb_register_write(rt2x00dev, offset, reg);
+	rt2800_register_write(rt2x00dev, offset, reg);
 
 	return 0;
 }
@@ -2773,9 +2773,9 @@ static u64 rt2800usb_get_tsf(struct ieee
 	u64 tsf;
 	u32 reg;
 
-	rt2x00usb_register_read(rt2x00dev, TSF_TIMER_DW1, &reg);
+	rt2800_register_read(rt2x00dev, TSF_TIMER_DW1, &reg);
 	tsf = (u64) rt2x00_get_field32(reg, TSF_TIMER_DW1_HIGH_WORD) << 32;
-	rt2x00usb_register_read(rt2x00dev, TSF_TIMER_DW0, &reg);
+	rt2800_register_read(rt2x00dev, TSF_TIMER_DW0, &reg);
 	tsf |= rt2x00_get_field32(reg, TSF_TIMER_DW0_LOW_WORD);
 
 	return tsf;
Index: b/drivers/net/wireless/rt2x00/rt2800usb.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800usb.h
+++ b/drivers/net/wireless/rt2x00/rt2800usb.h
@@ -27,6 +27,27 @@
 #ifndef RT2800USB_H
 #define RT2800USB_H
 
+static inline void rt2800_register_read(struct rt2x00_dev *rt2x00dev,
+					const unsigned int offset,
+					u32 *value)
+{
+	rt2x00usb_register_read(rt2x00dev, offset, value);
+}
+
+static inline void rt2800_register_write(struct rt2x00_dev *rt2x00dev,
+					 const unsigned int offset,
+					 u32 value)
+{
+	rt2x00usb_register_write(rt2x00dev, offset, value);
+}
+
+static inline void rt2800_register_write_lock(struct rt2x00_dev *rt2x00dev,
+					      const unsigned int offset,
+					      u32 value)
+{
+	rt2x00usb_register_write_lock(rt2x00dev, offset, value);
+}
+
 /*
  * RF chip defines.
  *
