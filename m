Return-Path: <linux-kernel-owner+w=401wt.eu-S932475AbZKDRgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475AbZKDRgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932376AbZKDRgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:36:44 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:57630 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432AbZKDRgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:36:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=M0fX0WLCR9J3I/UEGkwwSi8JRybE4AxVPr1bEC5JwD40ylsV6cC4jz4Gb0HWcNYwPB
         EFdYWLyqq7I/aUaA002OfUt7geIV7m//Wmaq4mtic4AAZD9qN856oU70vGWn7CDSq/od
         NgtmQBZSwbVgortpVWXfyjYtc7i5ZXo87Cw2I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:36:17 +0100
Message-Id: <20091104173617.28463.6733.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 35/41] rt2800: prepare for rt2800lib addition
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800: prepare for rt2800lib addition

Part of preparations for later code unification.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |  103 +++++++++++++-----------
 drivers/net/wireless/rt2x00/rt2800usb.c |  134 +++++++++++++++++---------------
 2 files changed, 133 insertions(+), 104 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800pci.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -97,7 +97,8 @@ static void rt2800pci_bbp_write(struct r
 		rt2x00_set_field32(&reg, BBP_CSR_CFG_REGNUM, word);
 		rt2x00_set_field32(&reg, BBP_CSR_CFG_BUSY, 1);
 		rt2x00_set_field32(&reg, BBP_CSR_CFG_READ_CONTROL, 0);
-		rt2x00_set_field32(&reg, BBP_CSR_CFG_BBP_RW_MODE, 1);
+		if (rt2x00_intf_is_pci(rt2x00dev))
+			rt2x00_set_field32(&reg, BBP_CSR_CFG_BBP_RW_MODE, 1);
 
 		rt2800_register_write_lock(rt2x00dev, BBP_CSR_CFG, reg);
 	}
@@ -125,7 +126,8 @@ static void rt2800pci_bbp_read(struct rt
 		rt2x00_set_field32(&reg, BBP_CSR_CFG_REGNUM, word);
 		rt2x00_set_field32(&reg, BBP_CSR_CFG_BUSY, 1);
 		rt2x00_set_field32(&reg, BBP_CSR_CFG_READ_CONTROL, 1);
-		rt2x00_set_field32(&reg, BBP_CSR_CFG_BBP_RW_MODE, 1);
+		if (rt2x00_intf_is_pci(rt2x00dev))
+			rt2x00_set_field32(&reg, BBP_CSR_CFG_BBP_RW_MODE, 1);
 
 		rt2800_register_write_lock(rt2x00dev, BBP_CSR_CFG, reg);
 
@@ -253,12 +255,14 @@ static void rt2800pci_mcu_request(struct
 {
 	u32 reg;
 
-	/*
-	 * RT2880 and RT3052 don't support MCU requests.
-	 */
-	if (rt2x00_rt(&rt2x00dev->chip, RT2880) ||
-	    rt2x00_rt(&rt2x00dev->chip, RT3052))
-		return;
+	if (rt2x00_intf_is_pci(rt2x00dev)) {
+		/*
+		* RT2880 and RT3052 don't support MCU requests.
+		*/
+		if (rt2x00_rt(&rt2x00dev->chip, RT2880) ||
+		    rt2x00_rt(&rt2x00dev->chip, RT3052))
+			return;
+	}
 
 	mutex_lock(&rt2x00dev->csr_mutex);
 
@@ -814,7 +818,8 @@ static void rt2800pci_config_ant(struct 
 	switch ((int)ant->tx) {
 	case 1:
 		rt2x00_set_field8(&r1, BBP1_TX_ANTENNA, 0);
-		rt2x00_set_field8(&r3, BBP3_RX_ANTENNA, 0);
+		if (rt2x00_intf_is_pci(rt2x00dev))
+			rt2x00_set_field8(&r3, BBP3_RX_ANTENNA, 0);
 		break;
 	case 2:
 		rt2x00_set_field8(&r1, BBP1_TX_ANTENNA, 2);
@@ -1480,7 +1485,8 @@ static int rt2800pci_init_registers(stru
 	u32 reg;
 	unsigned int i;
 
-	rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
+	if (rt2x00_intf_is_pci(rt2x00dev))
+		rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
 
 	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_CSR, 1);
@@ -1803,7 +1809,8 @@ static int rt2800pci_init_bbp(struct rt2
 	if (rt2x00_rev(&rt2x00dev->chip) > RT2860D_VERSION)
 		rt2800_bbp_write(rt2x00dev, 84, 0x19);
 
-	if (rt2x00_rt(&rt2x00dev->chip, RT3052)) {
+	if (rt2x00_intf_is_pci(rt2x00dev) &&
+	    rt2x00_rt(&rt2x00dev->chip, RT3052)) {
 		rt2800_bbp_write(rt2x00dev, 31, 0x08);
 		rt2800_bbp_write(rt2x00dev, 78, 0x0e);
 		rt2800_bbp_write(rt2x00dev, 80, 0x08);
@@ -1887,10 +1894,12 @@ static int rt2800pci_init_rfcsr(struct r
 	u8 rfcsr;
 	u8 bbp;
 
-	if (!rt2x00_rf(&rt2x00dev->chip, RF3020) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF3021) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF3022))
-		return 0;
+	if (rt2x00_intf_is_pci(rt2x00dev)) {
+		if (!rt2x00_rf(&rt2x00dev->chip, RF3020) &&
+		    !rt2x00_rf(&rt2x00dev->chip, RF3021) &&
+		    !rt2x00_rf(&rt2x00dev->chip, RF3022))
+			return 0;
+	}
 
 	/*
 	 * Init RF calibration.
@@ -1902,36 +1911,38 @@ static int rt2800pci_init_rfcsr(struct r
 	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 0);
 	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
 
-	rt2800_rfcsr_write(rt2x00dev, 0, 0x50);
-	rt2800_rfcsr_write(rt2x00dev, 1, 0x01);
-	rt2800_rfcsr_write(rt2x00dev, 2, 0xf7);
-	rt2800_rfcsr_write(rt2x00dev, 3, 0x75);
-	rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
-	rt2800_rfcsr_write(rt2x00dev, 5, 0x03);
-	rt2800_rfcsr_write(rt2x00dev, 6, 0x02);
-	rt2800_rfcsr_write(rt2x00dev, 7, 0x50);
-	rt2800_rfcsr_write(rt2x00dev, 8, 0x39);
-	rt2800_rfcsr_write(rt2x00dev, 9, 0x0f);
-	rt2800_rfcsr_write(rt2x00dev, 10, 0x60);
-	rt2800_rfcsr_write(rt2x00dev, 11, 0x21);
-	rt2800_rfcsr_write(rt2x00dev, 12, 0x75);
-	rt2800_rfcsr_write(rt2x00dev, 13, 0x75);
-	rt2800_rfcsr_write(rt2x00dev, 14, 0x90);
-	rt2800_rfcsr_write(rt2x00dev, 15, 0x58);
-	rt2800_rfcsr_write(rt2x00dev, 16, 0xb3);
-	rt2800_rfcsr_write(rt2x00dev, 17, 0x92);
-	rt2800_rfcsr_write(rt2x00dev, 18, 0x2c);
-	rt2800_rfcsr_write(rt2x00dev, 19, 0x02);
-	rt2800_rfcsr_write(rt2x00dev, 20, 0xba);
-	rt2800_rfcsr_write(rt2x00dev, 21, 0xdb);
-	rt2800_rfcsr_write(rt2x00dev, 22, 0x00);
-	rt2800_rfcsr_write(rt2x00dev, 23, 0x31);
-	rt2800_rfcsr_write(rt2x00dev, 24, 0x08);
-	rt2800_rfcsr_write(rt2x00dev, 25, 0x01);
-	rt2800_rfcsr_write(rt2x00dev, 26, 0x25);
-	rt2800_rfcsr_write(rt2x00dev, 27, 0x23);
-	rt2800_rfcsr_write(rt2x00dev, 28, 0x13);
-	rt2800_rfcsr_write(rt2x00dev, 29, 0x83);
+	if (rt2x00_intf_is_pci(rt2x00dev)) {
+		rt2800_rfcsr_write(rt2x00dev, 0, 0x50);
+		rt2800_rfcsr_write(rt2x00dev, 1, 0x01);
+		rt2800_rfcsr_write(rt2x00dev, 2, 0xf7);
+		rt2800_rfcsr_write(rt2x00dev, 3, 0x75);
+		rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
+		rt2800_rfcsr_write(rt2x00dev, 5, 0x03);
+		rt2800_rfcsr_write(rt2x00dev, 6, 0x02);
+		rt2800_rfcsr_write(rt2x00dev, 7, 0x50);
+		rt2800_rfcsr_write(rt2x00dev, 8, 0x39);
+		rt2800_rfcsr_write(rt2x00dev, 9, 0x0f);
+		rt2800_rfcsr_write(rt2x00dev, 10, 0x60);
+		rt2800_rfcsr_write(rt2x00dev, 11, 0x21);
+		rt2800_rfcsr_write(rt2x00dev, 12, 0x75);
+		rt2800_rfcsr_write(rt2x00dev, 13, 0x75);
+		rt2800_rfcsr_write(rt2x00dev, 14, 0x90);
+		rt2800_rfcsr_write(rt2x00dev, 15, 0x58);
+		rt2800_rfcsr_write(rt2x00dev, 16, 0xb3);
+		rt2800_rfcsr_write(rt2x00dev, 17, 0x92);
+		rt2800_rfcsr_write(rt2x00dev, 18, 0x2c);
+		rt2800_rfcsr_write(rt2x00dev, 19, 0x02);
+		rt2800_rfcsr_write(rt2x00dev, 20, 0xba);
+		rt2800_rfcsr_write(rt2x00dev, 21, 0xdb);
+		rt2800_rfcsr_write(rt2x00dev, 22, 0x00);
+		rt2800_rfcsr_write(rt2x00dev, 23, 0x31);
+		rt2800_rfcsr_write(rt2x00dev, 24, 0x08);
+		rt2800_rfcsr_write(rt2x00dev, 25, 0x01);
+		rt2800_rfcsr_write(rt2x00dev, 26, 0x25);
+		rt2800_rfcsr_write(rt2x00dev, 27, 0x23);
+		rt2800_rfcsr_write(rt2x00dev, 28, 0x13);
+		rt2800_rfcsr_write(rt2x00dev, 29, 0x83);
+	}
 
 	/*
 	 * Set RX Filter calibration for 20MHz and 40MHz
@@ -3005,6 +3016,8 @@ static int rt2800pci_probe_hw(struct rt2
 {
 	int retval;
 
+	rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_PCI);
+
 	rt2x00dev->priv = (void *)&rt2800pci_rt2800_ops;
 
 	/*
Index: b/drivers/net/wireless/rt2x00/rt2800usb.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1050,7 +1050,8 @@ static void rt2800usb_link_stats(struct 
 static u8 rt2800usb_get_default_vgc(struct rt2x00_dev *rt2x00dev)
 {
 	if (rt2x00dev->curr_band == IEEE80211_BAND_2GHZ) {
-		if (rt2x00_rev(&rt2x00dev->chip) == RT3070_VERSION)
+		if (rt2x00_intf_is_usb(rt2x00dev) &&
+		    rt2x00_rev(&rt2x00dev->chip) == RT3070_VERSION)
 			return 0x1c + (2 * rt2x00dev->lna_gain);
 		else
 			return 0x2e + rt2x00dev->lna_gain;
@@ -1285,33 +1286,38 @@ static int rt2800usb_init_registers(stru
 	u32 reg;
 	unsigned int i;
 
-	/*
-	 * Wait untill BBP and RF are ready.
-	 */
-	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
-		if (reg && reg != ~0)
-			break;
-		msleep(1);
-	}
+	if (rt2x00_intf_is_usb(rt2x00dev)) {
+		/*
+		 * Wait untill BBP and RF are ready.
+		 */
+		for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
+			rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
+			if (reg && reg != ~0)
+				break;
+			msleep(1);
+		}
 
-	if (i == REGISTER_BUSY_COUNT) {
-		ERROR(rt2x00dev, "Unstable hardware.\n");
-		return -EBUSY;
-	}
+		if (i == REGISTER_BUSY_COUNT) {
+			ERROR(rt2x00dev, "Unstable hardware.\n");
+			return -EBUSY;
+		}
 
-	rt2800_register_read(rt2x00dev, PBF_SYS_CTRL, &reg);
-	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, reg & ~0x00002000);
+		rt2800_register_read(rt2x00dev, PBF_SYS_CTRL, &reg);
+		rt2800_register_write(rt2x00dev, PBF_SYS_CTRL,
+				      reg & ~0x00002000);
+	}
 
 	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_CSR, 1);
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_BBP, 1);
 	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
 
-	rt2800_register_write(rt2x00dev, USB_DMA_CFG, 0x00000000);
+	if (rt2x00_intf_is_usb(rt2x00dev)) {
+		rt2800_register_write(rt2x00dev, USB_DMA_CFG, 0x00000000);
 
-	rt2x00usb_vendor_request_sw(rt2x00dev, USB_DEVICE_MODE, 0,
-				    USB_MODE_RESET, REGISTER_TIMEOUT);
+		rt2x00usb_vendor_request_sw(rt2x00dev, USB_DEVICE_MODE, 0,
+					    USB_MODE_RESET, REGISTER_TIMEOUT);
+	}
 
 	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, 0x00000000);
 
@@ -1343,7 +1349,8 @@ static int rt2800usb_init_registers(stru
 	rt2x00_set_field32(&reg, BCN_TIME_CFG_TX_TIME_COMPENSATE, 0);
 	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 
-	if (rt2x00_rev(&rt2x00dev->chip) == RT3070_VERSION) {
+	if (rt2x00_intf_is_usb(rt2x00dev) &&
+	    rt2x00_rev(&rt2x00dev->chip) == RT3070_VERSION) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
@@ -1461,19 +1468,21 @@ static int rt2800usb_init_registers(stru
 	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_GF40, 1);
 	rt2800_register_write(rt2x00dev, GF40_PROT_CFG, reg);
 
-	rt2800_register_write(rt2x00dev, PBF_CFG, 0xf40006);
+	if (rt2x00_intf_is_usb(rt2x00dev)) {
+		rt2800_register_write(rt2x00dev, PBF_CFG, 0xf40006);
 
-	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_DMA_BUSY, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_RX_DMA_BUSY, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_WP_DMA_BURST_SIZE, 3);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_WRITEBACK_DONE, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_BIG_ENDIAN, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_RX_HDR_SCATTER, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_HDR_SEG_LEN, 0);
-	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
+		rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
+		rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
+		rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_DMA_BUSY, 0);
+		rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
+		rt2x00_set_field32(&reg, WPDMA_GLO_CFG_RX_DMA_BUSY, 0);
+		rt2x00_set_field32(&reg, WPDMA_GLO_CFG_WP_DMA_BURST_SIZE, 3);
+		rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_WRITEBACK_DONE, 0);
+		rt2x00_set_field32(&reg, WPDMA_GLO_CFG_BIG_ENDIAN, 0);
+		rt2x00_set_field32(&reg, WPDMA_GLO_CFG_RX_HDR_SCATTER, 0);
+		rt2x00_set_field32(&reg, WPDMA_GLO_CFG_HDR_SEG_LEN, 0);
+		rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
+	}
 
 	rt2800_register_write(rt2x00dev, TXOP_CTRL_CFG, 0x0000583f);
 	rt2800_register_write(rt2x00dev, TXOP_HLDR_ET, 0x00000002);
@@ -1519,9 +1528,11 @@ static int rt2800usb_init_registers(stru
 	rt2800_register_write(rt2x00dev, HW_BEACON_BASE6, 0);
 	rt2800_register_write(rt2x00dev, HW_BEACON_BASE7, 0);
 
-	rt2800_register_read(rt2x00dev, USB_CYC_CFG, &reg);
-	rt2x00_set_field32(&reg, USB_CYC_CFG_CLOCK_CYCLE, 30);
-	rt2800_register_write(rt2x00dev, USB_CYC_CFG, reg);
+	if (rt2x00_intf_is_usb(rt2x00dev)) {
+		rt2800_register_read(rt2x00dev, USB_CYC_CFG, &reg);
+		rt2x00_set_field32(&reg, USB_CYC_CFG_CLOCK_CYCLE, 30);
+		rt2800_register_write(rt2x00dev, USB_CYC_CFG, reg);
+	}
 
 	rt2800_register_read(rt2x00dev, HT_FBK_CFG0, &reg);
 	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS0FBK, 0);
@@ -1650,11 +1661,11 @@ static int rt2800usb_init_bbp(struct rt2
 		rt2800_bbp_write(rt2x00dev, 73, 0x12);
 	}
 
-	if (rt2x00_rev(&rt2x00dev->chip) > RT2860D_VERSION) {
+	if (rt2x00_rev(&rt2x00dev->chip) > RT2860D_VERSION)
 		rt2800_bbp_write(rt2x00dev, 84, 0x19);
-	}
 
-	if (rt2x00_rev(&rt2x00dev->chip) == RT3070_VERSION) {
+	if (rt2x00_intf_is_usb(rt2x00dev) &&
+	    rt2x00_rev(&rt2x00dev->chip) == RT3070_VERSION) {
 		rt2800_bbp_write(rt2x00dev, 70, 0x0a);
 		rt2800_bbp_write(rt2x00dev, 84, 0x99);
 		rt2800_bbp_write(rt2x00dev, 105, 0x05);
@@ -1738,7 +1749,8 @@ static int rt2800usb_init_rfcsr(struct r
 	u8 rfcsr;
 	u8 bbp;
 
-	if (rt2x00_rev(&rt2x00dev->chip) != RT3070_VERSION)
+	if (rt2x00_intf_is_usb(rt2x00dev) &&
+	    rt2x00_rev(&rt2x00dev->chip) != RT3070_VERSION)
 		return 0;
 
 	/*
@@ -1751,26 +1763,28 @@ static int rt2800usb_init_rfcsr(struct r
 	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 0);
 	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
 
-	rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
-	rt2800_rfcsr_write(rt2x00dev, 5, 0x03);
-	rt2800_rfcsr_write(rt2x00dev, 6, 0x02);
-	rt2800_rfcsr_write(rt2x00dev, 7, 0x70);
-	rt2800_rfcsr_write(rt2x00dev, 9, 0x0f);
-	rt2800_rfcsr_write(rt2x00dev, 10, 0x71);
-	rt2800_rfcsr_write(rt2x00dev, 11, 0x21);
-	rt2800_rfcsr_write(rt2x00dev, 12, 0x7b);
-	rt2800_rfcsr_write(rt2x00dev, 14, 0x90);
-	rt2800_rfcsr_write(rt2x00dev, 15, 0x58);
-	rt2800_rfcsr_write(rt2x00dev, 16, 0xb3);
-	rt2800_rfcsr_write(rt2x00dev, 17, 0x92);
-	rt2800_rfcsr_write(rt2x00dev, 18, 0x2c);
-	rt2800_rfcsr_write(rt2x00dev, 19, 0x02);
-	rt2800_rfcsr_write(rt2x00dev, 20, 0xba);
-	rt2800_rfcsr_write(rt2x00dev, 21, 0xdb);
-	rt2800_rfcsr_write(rt2x00dev, 24, 0x16);
-	rt2800_rfcsr_write(rt2x00dev, 25, 0x01);
-	rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
-	rt2800_rfcsr_write(rt2x00dev, 29, 0x1f);
+	if (rt2x00_intf_is_usb(rt2x00dev)) {
+		rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
+		rt2800_rfcsr_write(rt2x00dev, 5, 0x03);
+		rt2800_rfcsr_write(rt2x00dev, 6, 0x02);
+		rt2800_rfcsr_write(rt2x00dev, 7, 0x70);
+		rt2800_rfcsr_write(rt2x00dev, 9, 0x0f);
+		rt2800_rfcsr_write(rt2x00dev, 10, 0x71);
+		rt2800_rfcsr_write(rt2x00dev, 11, 0x21);
+		rt2800_rfcsr_write(rt2x00dev, 12, 0x7b);
+		rt2800_rfcsr_write(rt2x00dev, 14, 0x90);
+		rt2800_rfcsr_write(rt2x00dev, 15, 0x58);
+		rt2800_rfcsr_write(rt2x00dev, 16, 0xb3);
+		rt2800_rfcsr_write(rt2x00dev, 17, 0x92);
+		rt2800_rfcsr_write(rt2x00dev, 18, 0x2c);
+		rt2800_rfcsr_write(rt2x00dev, 19, 0x02);
+		rt2800_rfcsr_write(rt2x00dev, 20, 0xba);
+		rt2800_rfcsr_write(rt2x00dev, 21, 0xdb);
+		rt2800_rfcsr_write(rt2x00dev, 24, 0x16);
+		rt2800_rfcsr_write(rt2x00dev, 25, 0x01);
+		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
+		rt2800_rfcsr_write(rt2x00dev, 29, 0x1f);
+	}
 
 	/*
 	 * Set RX Filter calibration for 20MHz and 40MHz
@@ -2644,6 +2658,8 @@ static int rt2800usb_probe_hw(struct rt2
 {
 	int retval;
 
+	rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_USB);
+
 	rt2x00dev->priv = (void *)&rt2800usb_rt2800_ops;
 
 	/*
