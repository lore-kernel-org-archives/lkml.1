Return-Path: <linux-kernel-owner+w=401wt.eu-S1757567AbZKDRm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbZKDRm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:42:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932086AbZKDRmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:42:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:5665 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197AbZKDReJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:34:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=MjM8EWYE0X3tL54+CyP4GUL5/ZQkpRcmGFjUXkJ8y0uxOb0xUYV+120LdmEc54QdKe
         sAT3WD2xYTPaJqlVDN7/dQqMEJfP3NgKPAVgaBnmGzJ0I4cROSb/dV0SaC1WTm3WwoJ+
         Y+rbgOVa5GmxhR/84ArQSQCWPqvBV7QNOCWk4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:33:50 +0100
Message-Id: <20091104173350.28463.25405.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 15/41] rt2800usb: add rt2800_bbp_[read,write]() wrappers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800usb: add rt2800_bbp_[read,write]() wrappers

Part of preparations for later code unification.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |  138 +++++++++++++++++---------------
 1 file changed, 75 insertions(+), 63 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800usb.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -122,6 +122,18 @@ static void rt2800usb_bbp_read(struct rt
 	mutex_unlock(&rt2x00dev->csr_mutex);
 }
 
+static inline void rt2800_bbp_write(struct rt2x00_dev *rt2x00dev,
+				    const unsigned int word, const u8 value)
+{
+	rt2800usb_bbp_write(rt2x00dev, word, value);
+}
+
+static inline void rt2800_bbp_read(struct rt2x00_dev *rt2x00dev,
+				   const unsigned int word, u8 *value)
+{
+	rt2800usb_bbp_read(rt2x00dev, word, value);
+}
+
 static void rt2800usb_rfcsr_write(struct rt2x00_dev *rt2x00dev,
 				  const unsigned int word, const u8 value)
 {
@@ -248,8 +260,8 @@ static const struct rt2x00debug rt2800us
 		.word_count	= EEPROM_SIZE / sizeof(u16),
 	},
 	.bbp	= {
-		.read		= rt2800usb_bbp_read,
-		.write		= rt2800usb_bbp_write,
+		.read		= rt2800_bbp_read,
+		.write		= rt2800_bbp_write,
 		.word_base	= BBP_BASE,
 		.word_size	= sizeof(u8),
 		.word_count	= BBP_SIZE / sizeof(u8),
@@ -614,8 +626,8 @@ static void rt2800usb_config_ant(struct 
 	u8 r1;
 	u8 r3;
 
-	rt2800usb_bbp_read(rt2x00dev, 1, &r1);
-	rt2800usb_bbp_read(rt2x00dev, 3, &r3);
+	rt2800_bbp_read(rt2x00dev, 1, &r1);
+	rt2800_bbp_read(rt2x00dev, 3, &r3);
 
 	/*
 	 * Configure the TX antenna.
@@ -647,8 +659,8 @@ static void rt2800usb_config_ant(struct 
 		break;
 	}
 
-	rt2800usb_bbp_write(rt2x00dev, 3, r3);
-	rt2800usb_bbp_write(rt2x00dev, 1, r1);
+	rt2800_bbp_write(rt2x00dev, 3, r3);
+	rt2800_bbp_write(rt2x00dev, 1, r1);
 }
 
 static void rt2800usb_config_lna_gain(struct rt2x00_dev *rt2x00dev,
@@ -791,26 +803,26 @@ static void rt2800usb_config_channel(str
 	/*
 	 * Change BBP settings
 	 */
-	rt2800usb_bbp_write(rt2x00dev, 62, 0x37 - rt2x00dev->lna_gain);
-	rt2800usb_bbp_write(rt2x00dev, 63, 0x37 - rt2x00dev->lna_gain);
-	rt2800usb_bbp_write(rt2x00dev, 64, 0x37 - rt2x00dev->lna_gain);
-	rt2800usb_bbp_write(rt2x00dev, 86, 0);
+	rt2800_bbp_write(rt2x00dev, 62, 0x37 - rt2x00dev->lna_gain);
+	rt2800_bbp_write(rt2x00dev, 63, 0x37 - rt2x00dev->lna_gain);
+	rt2800_bbp_write(rt2x00dev, 64, 0x37 - rt2x00dev->lna_gain);
+	rt2800_bbp_write(rt2x00dev, 86, 0);
 
 	if (rf->channel <= 14) {
 		if (test_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags)) {
-			rt2800usb_bbp_write(rt2x00dev, 82, 0x62);
-			rt2800usb_bbp_write(rt2x00dev, 75, 0x46);
+			rt2800_bbp_write(rt2x00dev, 82, 0x62);
+			rt2800_bbp_write(rt2x00dev, 75, 0x46);
 		} else {
-			rt2800usb_bbp_write(rt2x00dev, 82, 0x84);
-			rt2800usb_bbp_write(rt2x00dev, 75, 0x50);
+			rt2800_bbp_write(rt2x00dev, 82, 0x84);
+			rt2800_bbp_write(rt2x00dev, 75, 0x50);
 		}
 	} else {
-		rt2800usb_bbp_write(rt2x00dev, 82, 0xf2);
+		rt2800_bbp_write(rt2x00dev, 82, 0xf2);
 
 		if (test_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags))
-			rt2800usb_bbp_write(rt2x00dev, 75, 0x46);
+			rt2800_bbp_write(rt2x00dev, 75, 0x46);
 		else
-			rt2800usb_bbp_write(rt2x00dev, 75, 0x50);
+			rt2800_bbp_write(rt2x00dev, 75, 0x50);
 	}
 
 	rt2800_register_read(rt2x00dev, TX_BAND_CFG, &reg);
@@ -842,23 +854,23 @@ static void rt2800usb_config_channel(str
 
 	rt2800_register_write(rt2x00dev, TX_PIN_CFG, tx_pin);
 
-	rt2800usb_bbp_read(rt2x00dev, 4, &bbp);
+	rt2800_bbp_read(rt2x00dev, 4, &bbp);
 	rt2x00_set_field8(&bbp, BBP4_BANDWIDTH, 2 * conf_is_ht40(conf));
-	rt2800usb_bbp_write(rt2x00dev, 4, bbp);
+	rt2800_bbp_write(rt2x00dev, 4, bbp);
 
-	rt2800usb_bbp_read(rt2x00dev, 3, &bbp);
+	rt2800_bbp_read(rt2x00dev, 3, &bbp);
 	rt2x00_set_field8(&bbp, BBP3_HT40_PLUS, conf_is_ht40_plus(conf));
-	rt2800usb_bbp_write(rt2x00dev, 3, bbp);
+	rt2800_bbp_write(rt2x00dev, 3, bbp);
 
 	if (rt2x00_rev(&rt2x00dev->chip) == RT2860C_VERSION) {
 		if (conf_is_ht40(conf)) {
-			rt2800usb_bbp_write(rt2x00dev, 69, 0x1a);
-			rt2800usb_bbp_write(rt2x00dev, 70, 0x0a);
-			rt2800usb_bbp_write(rt2x00dev, 73, 0x16);
+			rt2800_bbp_write(rt2x00dev, 69, 0x1a);
+			rt2800_bbp_write(rt2x00dev, 70, 0x0a);
+			rt2800_bbp_write(rt2x00dev, 73, 0x16);
 		} else {
-			rt2800usb_bbp_write(rt2x00dev, 69, 0x16);
-			rt2800usb_bbp_write(rt2x00dev, 70, 0x08);
-			rt2800usb_bbp_write(rt2x00dev, 73, 0x11);
+			rt2800_bbp_write(rt2x00dev, 69, 0x16);
+			rt2800_bbp_write(rt2x00dev, 70, 0x08);
+			rt2800_bbp_write(rt2x00dev, 73, 0x11);
 		}
 	}
 
@@ -872,9 +884,9 @@ static void rt2800usb_config_txpower(str
 	u32 value = TXPOWER_G_TO_DEV(txpower);
 	u8 r1;
 
-	rt2800usb_bbp_read(rt2x00dev, 1, &r1);
+	rt2800_bbp_read(rt2x00dev, 1, &r1);
 	rt2x00_set_field8(&reg, BBP1_TX_POWER, 0);
-	rt2800usb_bbp_write(rt2x00dev, 1, r1);
+	rt2800_bbp_write(rt2x00dev, 1, r1);
 
 	rt2800_register_read(rt2x00dev, TX_PWR_CFG_0, &reg);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_0_1MBS, value);
@@ -1027,7 +1039,7 @@ static inline void rt2800usb_set_vgc(str
 				     struct link_qual *qual, u8 vgc_level)
 {
 	if (qual->vgc_level != vgc_level) {
-		rt2800usb_bbp_write(rt2x00dev, 66, vgc_level);
+		rt2800_bbp_write(rt2x00dev, 66, vgc_level);
 		qual->vgc_level = vgc_level;
 		qual->vgc_level_reg = vgc_level;
 	}
@@ -1570,7 +1582,7 @@ static int rt2800usb_wait_bbp_ready(stru
 	msleep(1);
 
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt2800usb_bbp_read(rt2x00dev, 0, &value);
+		rt2800_bbp_read(rt2x00dev, 0, &value);
 		if ((value != 0xff) && (value != 0x00))
 			return 0;
 		udelay(REGISTER_BUSY_DELAY);
@@ -1591,34 +1603,34 @@ static int rt2800usb_init_bbp(struct rt2
 		     rt2800usb_wait_bbp_ready(rt2x00dev)))
 		return -EACCES;
 
-	rt2800usb_bbp_write(rt2x00dev, 65, 0x2c);
-	rt2800usb_bbp_write(rt2x00dev, 66, 0x38);
-	rt2800usb_bbp_write(rt2x00dev, 69, 0x12);
-	rt2800usb_bbp_write(rt2x00dev, 70, 0x0a);
-	rt2800usb_bbp_write(rt2x00dev, 73, 0x10);
-	rt2800usb_bbp_write(rt2x00dev, 81, 0x37);
-	rt2800usb_bbp_write(rt2x00dev, 82, 0x62);
-	rt2800usb_bbp_write(rt2x00dev, 83, 0x6a);
-	rt2800usb_bbp_write(rt2x00dev, 84, 0x99);
-	rt2800usb_bbp_write(rt2x00dev, 86, 0x00);
-	rt2800usb_bbp_write(rt2x00dev, 91, 0x04);
-	rt2800usb_bbp_write(rt2x00dev, 92, 0x00);
-	rt2800usb_bbp_write(rt2x00dev, 103, 0x00);
-	rt2800usb_bbp_write(rt2x00dev, 105, 0x05);
+	rt2800_bbp_write(rt2x00dev, 65, 0x2c);
+	rt2800_bbp_write(rt2x00dev, 66, 0x38);
+	rt2800_bbp_write(rt2x00dev, 69, 0x12);
+	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
+	rt2800_bbp_write(rt2x00dev, 73, 0x10);
+	rt2800_bbp_write(rt2x00dev, 81, 0x37);
+	rt2800_bbp_write(rt2x00dev, 82, 0x62);
+	rt2800_bbp_write(rt2x00dev, 83, 0x6a);
+	rt2800_bbp_write(rt2x00dev, 84, 0x99);
+	rt2800_bbp_write(rt2x00dev, 86, 0x00);
+	rt2800_bbp_write(rt2x00dev, 91, 0x04);
+	rt2800_bbp_write(rt2x00dev, 92, 0x00);
+	rt2800_bbp_write(rt2x00dev, 103, 0x00);
+	rt2800_bbp_write(rt2x00dev, 105, 0x05);
 
 	if (rt2x00_rev(&rt2x00dev->chip) == RT2860C_VERSION) {
-		rt2800usb_bbp_write(rt2x00dev, 69, 0x16);
-		rt2800usb_bbp_write(rt2x00dev, 73, 0x12);
+		rt2800_bbp_write(rt2x00dev, 69, 0x16);
+		rt2800_bbp_write(rt2x00dev, 73, 0x12);
 	}
 
 	if (rt2x00_rev(&rt2x00dev->chip) > RT2860D_VERSION) {
-		rt2800usb_bbp_write(rt2x00dev, 84, 0x19);
+		rt2800_bbp_write(rt2x00dev, 84, 0x19);
 	}
 
 	if (rt2x00_rev(&rt2x00dev->chip) == RT3070_VERSION) {
-		rt2800usb_bbp_write(rt2x00dev, 70, 0x0a);
-		rt2800usb_bbp_write(rt2x00dev, 84, 0x99);
-		rt2800usb_bbp_write(rt2x00dev, 105, 0x05);
+		rt2800_bbp_write(rt2x00dev, 70, 0x0a);
+		rt2800_bbp_write(rt2x00dev, 84, 0x99);
+		rt2800_bbp_write(rt2x00dev, 105, 0x05);
 	}
 
 	for (i = 0; i < EEPROM_BBP_SIZE; i++) {
@@ -1627,7 +1639,7 @@ static int rt2800usb_init_bbp(struct rt2
 		if (eeprom != 0xffff && eeprom != 0x0000) {
 			reg_id = rt2x00_get_field16(eeprom, EEPROM_BBP_REG_ID);
 			value = rt2x00_get_field16(eeprom, EEPROM_BBP_VALUE);
-			rt2800usb_bbp_write(rt2x00dev, reg_id, value);
+			rt2800_bbp_write(rt2x00dev, reg_id, value);
 		}
 	}
 
@@ -1646,9 +1658,9 @@ static u8 rt2800usb_init_rx_filter(struc
 
 	rt2800usb_rfcsr_write(rt2x00dev, 24, rfcsr24);
 
-	rt2800usb_bbp_read(rt2x00dev, 4, &bbp);
+	rt2800_bbp_read(rt2x00dev, 4, &bbp);
 	rt2x00_set_field8(&bbp, BBP4_BANDWIDTH, 2 * bw40);
-	rt2800usb_bbp_write(rt2x00dev, 4, bbp);
+	rt2800_bbp_write(rt2x00dev, 4, bbp);
 
 	rt2800usb_rfcsr_read(rt2x00dev, 22, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR22_BASEBAND_LOOPBACK, 1);
@@ -1657,13 +1669,13 @@ static u8 rt2800usb_init_rx_filter(struc
 	/*
 	 * Set power & frequency of passband test tone
 	 */
-	rt2800usb_bbp_write(rt2x00dev, 24, 0);
+	rt2800_bbp_write(rt2x00dev, 24, 0);
 
 	for (i = 0; i < 100; i++) {
-		rt2800usb_bbp_write(rt2x00dev, 25, 0x90);
+		rt2800_bbp_write(rt2x00dev, 25, 0x90);
 		msleep(1);
 
-		rt2800usb_bbp_read(rt2x00dev, 55, &passband);
+		rt2800_bbp_read(rt2x00dev, 55, &passband);
 		if (passband)
 			break;
 	}
@@ -1671,13 +1683,13 @@ static u8 rt2800usb_init_rx_filter(struc
 	/*
 	 * Set power & frequency of stopband test tone
 	 */
-	rt2800usb_bbp_write(rt2x00dev, 24, 0x06);
+	rt2800_bbp_write(rt2x00dev, 24, 0x06);
 
 	for (i = 0; i < 100; i++) {
-		rt2800usb_bbp_write(rt2x00dev, 25, 0x90);
+		rt2800_bbp_write(rt2x00dev, 25, 0x90);
 		msleep(1);
 
-		rt2800usb_bbp_read(rt2x00dev, 55, &stopband);
+		rt2800_bbp_read(rt2x00dev, 55, &stopband);
 
 		if ((passband - stopband) <= filter_target) {
 			rfcsr24++;
@@ -1744,7 +1756,7 @@ static int rt2800usb_init_rfcsr(struct r
 	/*
 	 * Set back to initial state
 	 */
-	rt2800usb_bbp_write(rt2x00dev, 24, 0);
+	rt2800_bbp_write(rt2x00dev, 24, 0);
 
 	rt2800usb_rfcsr_read(rt2x00dev, 22, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR22_BASEBAND_LOOPBACK, 0);
@@ -1753,9 +1765,9 @@ static int rt2800usb_init_rfcsr(struct r
 	/*
 	 * set BBP back to BW20
 	 */
-	rt2800usb_bbp_read(rt2x00dev, 4, &bbp);
+	rt2800_bbp_read(rt2x00dev, 4, &bbp);
 	rt2x00_set_field8(&bbp, BBP4_BANDWIDTH, 0);
-	rt2800usb_bbp_write(rt2x00dev, 4, bbp);
+	rt2800_bbp_write(rt2x00dev, 4, bbp);
 
 	return 0;
 }
