Return-Path: <linux-kernel-owner+w=401wt.eu-S932549AbZKDRhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549AbZKDRhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932539AbZKDRhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:37:41 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:57630 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932496AbZKDRhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:37:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=m/E12MmxOJtybBbx33WNOio8++2SAD2MTou+uSs2PZgko31D6uHFwooixSP+NL5z4V
         MeDBHO6kZPLB5rtME2exDvxNgc9zPHHCxjhTyEFza/ORNITA9aFQZjU1ABmVL08jWvql
         V+ZlrswmADmonFRIIxEOmFWlLfLhXR0kVT6bk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:36:57 +0100
Message-Id: <20091104173657.28463.90918.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 40/41] rt2800: add rt2800lib (part three)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800: add rt2800lib (part three)

Code unification.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |  614 +++++++++++++++++++++++++++++++-
 drivers/net/wireless/rt2x00/rt2800lib.h |   14 
 drivers/net/wireless/rt2x00/rt2800pci.c |  497 -------------------------
 drivers/net/wireless/rt2x00/rt2800usb.c |  541 ----------------------------
 4 files changed, 609 insertions(+), 1057 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800lib.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -31,8 +31,12 @@
 #include <linux/module.h>
 
 #include "rt2x00.h"
+#ifdef CONFIG_RT2800USB
+#include "rt2x00usb.h"
+#endif
 #include "rt2800lib.h"
 #include "rt2800.h"
+#include "rt2800usb.h"
 
 MODULE_AUTHOR("Bartlomiej Zolnierkiewicz");
 MODULE_DESCRIPTION("rt2800 library");
@@ -62,8 +66,8 @@ MODULE_LICENSE("GPL");
 	rt2800_regbusy_read((__dev), H2M_MAILBOX_CSR, \
 			    H2M_MAILBOX_CSR_OWNER, (__reg))
 
-void rt2800_bbp_write(struct rt2x00_dev *rt2x00dev,
-		      const unsigned int word, const u8 value)
+static void rt2800_bbp_write(struct rt2x00_dev *rt2x00dev,
+			     const unsigned int word, const u8 value)
 {
 	u32 reg;
 
@@ -87,10 +91,9 @@ void rt2800_bbp_write(struct rt2x00_dev 
 
 	mutex_unlock(&rt2x00dev->csr_mutex);
 }
-EXPORT_SYMBOL_GPL(rt2800_bbp_write);
 
-void rt2800_bbp_read(struct rt2x00_dev *rt2x00dev,
-		     const unsigned int word, u8 *value)
+static void rt2800_bbp_read(struct rt2x00_dev *rt2x00dev,
+			    const unsigned int word, u8 *value)
 {
 	u32 reg;
 
@@ -121,10 +124,9 @@ void rt2800_bbp_read(struct rt2x00_dev *
 
 	mutex_unlock(&rt2x00dev->csr_mutex);
 }
-EXPORT_SYMBOL_GPL(rt2800_bbp_read);
 
-void rt2800_rfcsr_write(struct rt2x00_dev *rt2x00dev,
-			const unsigned int word, const u8 value)
+static void rt2800_rfcsr_write(struct rt2x00_dev *rt2x00dev,
+			       const unsigned int word, const u8 value)
 {
 	u32 reg;
 
@@ -146,10 +148,9 @@ void rt2800_rfcsr_write(struct rt2x00_de
 
 	mutex_unlock(&rt2x00dev->csr_mutex);
 }
-EXPORT_SYMBOL_GPL(rt2800_rfcsr_write);
 
-void rt2800_rfcsr_read(struct rt2x00_dev *rt2x00dev,
-		       const unsigned int word, u8 *value)
+static void rt2800_rfcsr_read(struct rt2x00_dev *rt2x00dev,
+			      const unsigned int word, u8 *value)
 {
 	u32 reg;
 
@@ -178,10 +179,9 @@ void rt2800_rfcsr_read(struct rt2x00_dev
 
 	mutex_unlock(&rt2x00dev->csr_mutex);
 }
-EXPORT_SYMBOL_GPL(rt2800_rfcsr_read);
 
-void rt2800_rf_write(struct rt2x00_dev *rt2x00dev,
-		     const unsigned int word, const u32 value)
+static void rt2800_rf_write(struct rt2x00_dev *rt2x00dev,
+			    const unsigned int word, const u32 value)
 {
 	u32 reg;
 
@@ -204,7 +204,6 @@ void rt2800_rf_write(struct rt2x00_dev *
 
 	mutex_unlock(&rt2x00dev->csr_mutex);
 }
-EXPORT_SYMBOL_GPL(rt2800_rf_write);
 
 void rt2800_mcu_request(struct rt2x00_dev *rt2x00dev,
 			const u8 command, const u8 token,
@@ -1074,3 +1073,588 @@ void rt2800_link_tuner(struct rt2x00_dev
 		       ((qual->rssi > -80) * 0x10));
 }
 EXPORT_SYMBOL_GPL(rt2800_link_tuner);
+
+/*
+ * Initialization functions.
+ */
+int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
+{
+	u32 reg;
+	unsigned int i;
+
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
+
+		if (i == REGISTER_BUSY_COUNT) {
+			ERROR(rt2x00dev, "Unstable hardware.\n");
+			return -EBUSY;
+		}
+
+		rt2800_register_read(rt2x00dev, PBF_SYS_CTRL, &reg);
+		rt2800_register_write(rt2x00dev, PBF_SYS_CTRL,
+				      reg & ~0x00002000);
+	} else if (rt2x00_intf_is_pci(rt2x00dev))
+		rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
+
+	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
+	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_CSR, 1);
+	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_BBP, 1);
+	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+
+	if (rt2x00_intf_is_usb(rt2x00dev)) {
+		rt2800_register_write(rt2x00dev, USB_DMA_CFG, 0x00000000);
+#ifdef CONFIG_RT2800USB
+		rt2x00usb_vendor_request_sw(rt2x00dev, USB_DEVICE_MODE, 0,
+					    USB_MODE_RESET, REGISTER_TIMEOUT);
+#endif
+	}
+
+	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, 0x00000000);
+
+	rt2800_register_read(rt2x00dev, BCN_OFFSET0, &reg);
+	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN0, 0xe0); /* 0x3800 */
+	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN1, 0xe8); /* 0x3a00 */
+	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN2, 0xf0); /* 0x3c00 */
+	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN3, 0xf8); /* 0x3e00 */
+	rt2800_register_write(rt2x00dev, BCN_OFFSET0, reg);
+
+	rt2800_register_read(rt2x00dev, BCN_OFFSET1, &reg);
+	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN4, 0xc8); /* 0x3200 */
+	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN5, 0xd0); /* 0x3400 */
+	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN6, 0x77); /* 0x1dc0 */
+	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN7, 0x6f); /* 0x1bc0 */
+	rt2800_register_write(rt2x00dev, BCN_OFFSET1, reg);
+
+	rt2800_register_write(rt2x00dev, LEGACY_BASIC_RATE, 0x0000013f);
+	rt2800_register_write(rt2x00dev, HT_BASIC_RATE, 0x00008003);
+
+	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, 0x00000000);
+
+	rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_INTERVAL, 0);
+	rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 0);
+	rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_SYNC, 0);
+	rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 0);
+	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 0);
+	rt2x00_set_field32(&reg, BCN_TIME_CFG_TX_TIME_COMPENSATE, 0);
+	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+
+	if (rt2x00_intf_is_usb(rt2x00dev) &&
+	    rt2x00_rev(&rt2x00dev->chip) == RT3070_VERSION) {
+		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
+		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
+		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
+	} else {
+		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000000);
+		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
+	}
+
+	rt2800_register_read(rt2x00dev, TX_LINK_CFG, &reg);
+	rt2x00_set_field32(&reg, TX_LINK_CFG_REMOTE_MFB_LIFETIME, 32);
+	rt2x00_set_field32(&reg, TX_LINK_CFG_MFB_ENABLE, 0);
+	rt2x00_set_field32(&reg, TX_LINK_CFG_REMOTE_UMFS_ENABLE, 0);
+	rt2x00_set_field32(&reg, TX_LINK_CFG_TX_MRQ_EN, 0);
+	rt2x00_set_field32(&reg, TX_LINK_CFG_TX_RDG_EN, 0);
+	rt2x00_set_field32(&reg, TX_LINK_CFG_TX_CF_ACK_EN, 1);
+	rt2x00_set_field32(&reg, TX_LINK_CFG_REMOTE_MFB, 0);
+	rt2x00_set_field32(&reg, TX_LINK_CFG_REMOTE_MFS, 0);
+	rt2800_register_write(rt2x00dev, TX_LINK_CFG, reg);
+
+	rt2800_register_read(rt2x00dev, TX_TIMEOUT_CFG, &reg);
+	rt2x00_set_field32(&reg, TX_TIMEOUT_CFG_MPDU_LIFETIME, 9);
+	rt2x00_set_field32(&reg, TX_TIMEOUT_CFG_TX_OP_TIMEOUT, 10);
+	rt2800_register_write(rt2x00dev, TX_TIMEOUT_CFG, reg);
+
+	rt2800_register_read(rt2x00dev, MAX_LEN_CFG, &reg);
+	rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_MPDU, AGGREGATION_SIZE);
+	if (rt2x00_rev(&rt2x00dev->chip) >= RT2880E_VERSION &&
+	    rt2x00_rev(&rt2x00dev->chip) < RT3070_VERSION)
+		rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 2);
+	else
+		rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 1);
+	rt2x00_set_field32(&reg, MAX_LEN_CFG_MIN_PSDU, 0);
+	rt2x00_set_field32(&reg, MAX_LEN_CFG_MIN_MPDU, 0);
+	rt2800_register_write(rt2x00dev, MAX_LEN_CFG, reg);
+
+	rt2800_register_write(rt2x00dev, PBF_MAX_PCNT, 0x1f3fbf9f);
+
+	rt2800_register_read(rt2x00dev, AUTO_RSP_CFG, &reg);
+	rt2x00_set_field32(&reg, AUTO_RSP_CFG_AUTORESPONDER, 1);
+	rt2x00_set_field32(&reg, AUTO_RSP_CFG_CTS_40_MMODE, 0);
+	rt2x00_set_field32(&reg, AUTO_RSP_CFG_CTS_40_MREF, 0);
+	rt2x00_set_field32(&reg, AUTO_RSP_CFG_DUAL_CTS_EN, 0);
+	rt2x00_set_field32(&reg, AUTO_RSP_CFG_ACK_CTS_PSM_BIT, 0);
+	rt2800_register_write(rt2x00dev, AUTO_RSP_CFG, reg);
+
+	rt2800_register_read(rt2x00dev, CCK_PROT_CFG, &reg);
+	rt2x00_set_field32(&reg, CCK_PROT_CFG_PROTECT_RATE, 8);
+	rt2x00_set_field32(&reg, CCK_PROT_CFG_PROTECT_CTRL, 0);
+	rt2x00_set_field32(&reg, CCK_PROT_CFG_PROTECT_NAV, 1);
+	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_CCK, 1);
+	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
+	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_MM20, 1);
+	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_MM40, 1);
+	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_GF20, 1);
+	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_GF40, 1);
+	rt2800_register_write(rt2x00dev, CCK_PROT_CFG, reg);
+
+	rt2800_register_read(rt2x00dev, OFDM_PROT_CFG, &reg);
+	rt2x00_set_field32(&reg, OFDM_PROT_CFG_PROTECT_RATE, 8);
+	rt2x00_set_field32(&reg, OFDM_PROT_CFG_PROTECT_CTRL, 0);
+	rt2x00_set_field32(&reg, OFDM_PROT_CFG_PROTECT_NAV, 1);
+	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_CCK, 1);
+	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
+	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_MM20, 1);
+	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_MM40, 1);
+	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_GF20, 1);
+	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_GF40, 1);
+	rt2800_register_write(rt2x00dev, OFDM_PROT_CFG, reg);
+
+	rt2800_register_read(rt2x00dev, MM20_PROT_CFG, &reg);
+	rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_RATE, 0x4004);
+	rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_CTRL, 0);
+	rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_NAV, 1);
+	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_CCK, 1);
+	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
+	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_MM20, 1);
+	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_MM40, 0);
+	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_GF20, 1);
+	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_GF40, 0);
+	rt2800_register_write(rt2x00dev, MM20_PROT_CFG, reg);
+
+	rt2800_register_read(rt2x00dev, MM40_PROT_CFG, &reg);
+	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_RATE, 0x4084);
+	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_CTRL, 0);
+	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_NAV, 1);
+	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_CCK, 1);
+	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
+	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_MM20, 1);
+	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_MM40, 1);
+	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_GF20, 1);
+	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_GF40, 1);
+	rt2800_register_write(rt2x00dev, MM40_PROT_CFG, reg);
+
+	rt2800_register_read(rt2x00dev, GF20_PROT_CFG, &reg);
+	rt2x00_set_field32(&reg, GF20_PROT_CFG_PROTECT_RATE, 0x4004);
+	rt2x00_set_field32(&reg, GF20_PROT_CFG_PROTECT_CTRL, 0);
+	rt2x00_set_field32(&reg, GF20_PROT_CFG_PROTECT_NAV, 1);
+	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_CCK, 1);
+	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
+	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_MM20, 1);
+	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_MM40, 0);
+	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_GF20, 1);
+	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_GF40, 0);
+	rt2800_register_write(rt2x00dev, GF20_PROT_CFG, reg);
+
+	rt2800_register_read(rt2x00dev, GF40_PROT_CFG, &reg);
+	rt2x00_set_field32(&reg, GF40_PROT_CFG_PROTECT_RATE, 0x4084);
+	rt2x00_set_field32(&reg, GF40_PROT_CFG_PROTECT_CTRL, 0);
+	rt2x00_set_field32(&reg, GF40_PROT_CFG_PROTECT_NAV, 1);
+	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_CCK, 1);
+	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
+	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_MM20, 1);
+	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_MM40, 1);
+	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_GF20, 1);
+	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_GF40, 1);
+	rt2800_register_write(rt2x00dev, GF40_PROT_CFG, reg);
+
+	if (rt2x00_intf_is_usb(rt2x00dev)) {
+		rt2800_register_write(rt2x00dev, PBF_CFG, 0xf40006);
+
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
+
+	rt2800_register_write(rt2x00dev, TXOP_CTRL_CFG, 0x0000583f);
+	rt2800_register_write(rt2x00dev, TXOP_HLDR_ET, 0x00000002);
+
+	rt2800_register_read(rt2x00dev, TX_RTS_CFG, &reg);
+	rt2x00_set_field32(&reg, TX_RTS_CFG_AUTO_RTS_RETRY_LIMIT, 32);
+	rt2x00_set_field32(&reg, TX_RTS_CFG_RTS_THRES,
+			   IEEE80211_MAX_RTS_THRESHOLD);
+	rt2x00_set_field32(&reg, TX_RTS_CFG_RTS_FBK_EN, 0);
+	rt2800_register_write(rt2x00dev, TX_RTS_CFG, reg);
+
+	rt2800_register_write(rt2x00dev, EXP_ACK_TIME, 0x002400ca);
+	rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
+
+	/*
+	 * ASIC will keep garbage value after boot, clear encryption keys.
+	 */
+	for (i = 0; i < 4; i++)
+		rt2800_register_write(rt2x00dev,
+					 SHARED_KEY_MODE_ENTRY(i), 0);
+
+	for (i = 0; i < 256; i++) {
+		u32 wcid[2] = { 0xffffffff, 0x00ffffff };
+		rt2800_register_multiwrite(rt2x00dev, MAC_WCID_ENTRY(i),
+					      wcid, sizeof(wcid));
+
+		rt2800_register_write(rt2x00dev, MAC_WCID_ATTR_ENTRY(i), 1);
+		rt2800_register_write(rt2x00dev, MAC_IVEIV_ENTRY(i), 0);
+	}
+
+	/*
+	 * Clear all beacons
+	 * For the Beacon base registers we only need to clear
+	 * the first byte since that byte contains the VALID and OWNER
+	 * bits which (when set to 0) will invalidate the entire beacon.
+	 */
+	rt2800_register_write(rt2x00dev, HW_BEACON_BASE0, 0);
+	rt2800_register_write(rt2x00dev, HW_BEACON_BASE1, 0);
+	rt2800_register_write(rt2x00dev, HW_BEACON_BASE2, 0);
+	rt2800_register_write(rt2x00dev, HW_BEACON_BASE3, 0);
+	rt2800_register_write(rt2x00dev, HW_BEACON_BASE4, 0);
+	rt2800_register_write(rt2x00dev, HW_BEACON_BASE5, 0);
+	rt2800_register_write(rt2x00dev, HW_BEACON_BASE6, 0);
+	rt2800_register_write(rt2x00dev, HW_BEACON_BASE7, 0);
+
+	if (rt2x00_intf_is_usb(rt2x00dev)) {
+		rt2800_register_read(rt2x00dev, USB_CYC_CFG, &reg);
+		rt2x00_set_field32(&reg, USB_CYC_CFG_CLOCK_CYCLE, 30);
+		rt2800_register_write(rt2x00dev, USB_CYC_CFG, reg);
+	}
+
+	rt2800_register_read(rt2x00dev, HT_FBK_CFG0, &reg);
+	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS0FBK, 0);
+	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS1FBK, 0);
+	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS2FBK, 1);
+	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS3FBK, 2);
+	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS4FBK, 3);
+	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS5FBK, 4);
+	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS6FBK, 5);
+	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS7FBK, 6);
+	rt2800_register_write(rt2x00dev, HT_FBK_CFG0, reg);
+
+	rt2800_register_read(rt2x00dev, HT_FBK_CFG1, &reg);
+	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS8FBK, 8);
+	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS9FBK, 8);
+	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS10FBK, 9);
+	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS11FBK, 10);
+	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS12FBK, 11);
+	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS13FBK, 12);
+	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS14FBK, 13);
+	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS15FBK, 14);
+	rt2800_register_write(rt2x00dev, HT_FBK_CFG1, reg);
+
+	rt2800_register_read(rt2x00dev, LG_FBK_CFG0, &reg);
+	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS0FBK, 8);
+	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS1FBK, 8);
+	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS2FBK, 9);
+	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS3FBK, 10);
+	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS4FBK, 11);
+	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS5FBK, 12);
+	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS6FBK, 13);
+	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS7FBK, 14);
+	rt2800_register_write(rt2x00dev, LG_FBK_CFG0, reg);
+
+	rt2800_register_read(rt2x00dev, LG_FBK_CFG1, &reg);
+	rt2x00_set_field32(&reg, LG_FBK_CFG0_CCKMCS0FBK, 0);
+	rt2x00_set_field32(&reg, LG_FBK_CFG0_CCKMCS1FBK, 0);
+	rt2x00_set_field32(&reg, LG_FBK_CFG0_CCKMCS2FBK, 1);
+	rt2x00_set_field32(&reg, LG_FBK_CFG0_CCKMCS3FBK, 2);
+	rt2800_register_write(rt2x00dev, LG_FBK_CFG1, reg);
+
+	/*
+	 * We must clear the error counters.
+	 * These registers are cleared on read,
+	 * so we may pass a useless variable to store the value.
+	 */
+	rt2800_register_read(rt2x00dev, RX_STA_CNT0, &reg);
+	rt2800_register_read(rt2x00dev, RX_STA_CNT1, &reg);
+	rt2800_register_read(rt2x00dev, RX_STA_CNT2, &reg);
+	rt2800_register_read(rt2x00dev, TX_STA_CNT0, &reg);
+	rt2800_register_read(rt2x00dev, TX_STA_CNT1, &reg);
+	rt2800_register_read(rt2x00dev, TX_STA_CNT2, &reg);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2800_init_registers);
+
+static int rt2800_wait_bbp_rf_ready(struct rt2x00_dev *rt2x00dev)
+{
+	unsigned int i;
+	u32 reg;
+
+	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
+		rt2800_register_read(rt2x00dev, MAC_STATUS_CFG, &reg);
+		if (!rt2x00_get_field32(reg, MAC_STATUS_CFG_BBP_RF_BUSY))
+			return 0;
+
+		udelay(REGISTER_BUSY_DELAY);
+	}
+
+	ERROR(rt2x00dev, "BBP/RF register access failed, aborting.\n");
+	return -EACCES;
+}
+
+static int rt2800_wait_bbp_ready(struct rt2x00_dev *rt2x00dev)
+{
+	unsigned int i;
+	u8 value;
+
+	/*
+	 * BBP was enabled after firmware was loaded,
+	 * but we need to reactivate it now.
+	 */
+	rt2800_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
+	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
+	msleep(1);
+
+	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
+		rt2800_bbp_read(rt2x00dev, 0, &value);
+		if ((value != 0xff) && (value != 0x00))
+			return 0;
+		udelay(REGISTER_BUSY_DELAY);
+	}
+
+	ERROR(rt2x00dev, "BBP register access failed, aborting.\n");
+	return -EACCES;
+}
+
+int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
+{
+	unsigned int i;
+	u16 eeprom;
+	u8 reg_id;
+	u8 value;
+
+	if (unlikely(rt2800_wait_bbp_rf_ready(rt2x00dev) ||
+		     rt2800_wait_bbp_ready(rt2x00dev)))
+		return -EACCES;
+
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
+
+	if (rt2x00_rev(&rt2x00dev->chip) == RT2860C_VERSION) {
+		rt2800_bbp_write(rt2x00dev, 69, 0x16);
+		rt2800_bbp_write(rt2x00dev, 73, 0x12);
+	}
+
+	if (rt2x00_rev(&rt2x00dev->chip) > RT2860D_VERSION)
+		rt2800_bbp_write(rt2x00dev, 84, 0x19);
+
+	if (rt2x00_intf_is_usb(rt2x00dev) &&
+	    rt2x00_rev(&rt2x00dev->chip) == RT3070_VERSION) {
+		rt2800_bbp_write(rt2x00dev, 70, 0x0a);
+		rt2800_bbp_write(rt2x00dev, 84, 0x99);
+		rt2800_bbp_write(rt2x00dev, 105, 0x05);
+	}
+
+	if (rt2x00_intf_is_pci(rt2x00dev) &&
+	    rt2x00_rt(&rt2x00dev->chip, RT3052)) {
+		rt2800_bbp_write(rt2x00dev, 31, 0x08);
+		rt2800_bbp_write(rt2x00dev, 78, 0x0e);
+		rt2800_bbp_write(rt2x00dev, 80, 0x08);
+	}
+
+	for (i = 0; i < EEPROM_BBP_SIZE; i++) {
+		rt2x00_eeprom_read(rt2x00dev, EEPROM_BBP_START + i, &eeprom);
+
+		if (eeprom != 0xffff && eeprom != 0x0000) {
+			reg_id = rt2x00_get_field16(eeprom, EEPROM_BBP_REG_ID);
+			value = rt2x00_get_field16(eeprom, EEPROM_BBP_VALUE);
+			rt2800_bbp_write(rt2x00dev, reg_id, value);
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2800_init_bbp);
+
+static u8 rt2800_init_rx_filter(struct rt2x00_dev *rt2x00dev,
+				bool bw40, u8 rfcsr24, u8 filter_target)
+{
+	unsigned int i;
+	u8 bbp;
+	u8 rfcsr;
+	u8 passband;
+	u8 stopband;
+	u8 overtuned = 0;
+
+	rt2800_rfcsr_write(rt2x00dev, 24, rfcsr24);
+
+	rt2800_bbp_read(rt2x00dev, 4, &bbp);
+	rt2x00_set_field8(&bbp, BBP4_BANDWIDTH, 2 * bw40);
+	rt2800_bbp_write(rt2x00dev, 4, bbp);
+
+	rt2800_rfcsr_read(rt2x00dev, 22, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR22_BASEBAND_LOOPBACK, 1);
+	rt2800_rfcsr_write(rt2x00dev, 22, rfcsr);
+
+	/*
+	 * Set power & frequency of passband test tone
+	 */
+	rt2800_bbp_write(rt2x00dev, 24, 0);
+
+	for (i = 0; i < 100; i++) {
+		rt2800_bbp_write(rt2x00dev, 25, 0x90);
+		msleep(1);
+
+		rt2800_bbp_read(rt2x00dev, 55, &passband);
+		if (passband)
+			break;
+	}
+
+	/*
+	 * Set power & frequency of stopband test tone
+	 */
+	rt2800_bbp_write(rt2x00dev, 24, 0x06);
+
+	for (i = 0; i < 100; i++) {
+		rt2800_bbp_write(rt2x00dev, 25, 0x90);
+		msleep(1);
+
+		rt2800_bbp_read(rt2x00dev, 55, &stopband);
+
+		if ((passband - stopband) <= filter_target) {
+			rfcsr24++;
+			overtuned += ((passband - stopband) == filter_target);
+		} else
+			break;
+
+		rt2800_rfcsr_write(rt2x00dev, 24, rfcsr24);
+	}
+
+	rfcsr24 -= !!overtuned;
+
+	rt2800_rfcsr_write(rt2x00dev, 24, rfcsr24);
+	return rfcsr24;
+}
+
+int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
+{
+	u8 rfcsr;
+	u8 bbp;
+
+	if (rt2x00_intf_is_usb(rt2x00dev) &&
+	    rt2x00_rev(&rt2x00dev->chip) != RT3070_VERSION)
+		return 0;
+
+	if (rt2x00_intf_is_pci(rt2x00dev)) {
+		if (!rt2x00_rf(&rt2x00dev->chip, RF3020) &&
+		    !rt2x00_rf(&rt2x00dev->chip, RF3021) &&
+		    !rt2x00_rf(&rt2x00dev->chip, RF3022))
+			return 0;
+	}
+
+	/*
+	 * Init RF calibration.
+	 */
+	rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
+	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
+	msleep(1);
+	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 0);
+	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
+
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
+	} else if (rt2x00_intf_is_pci(rt2x00dev)) {
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
+
+	/*
+	 * Set RX Filter calibration for 20MHz and 40MHz
+	 */
+	rt2x00dev->calibration[0] =
+	    rt2800_init_rx_filter(rt2x00dev, false, 0x07, 0x16);
+	rt2x00dev->calibration[1] =
+	    rt2800_init_rx_filter(rt2x00dev, true, 0x27, 0x19);
+
+	/*
+	 * Set back to initial state
+	 */
+	rt2800_bbp_write(rt2x00dev, 24, 0);
+
+	rt2800_rfcsr_read(rt2x00dev, 22, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR22_BASEBAND_LOOPBACK, 0);
+	rt2800_rfcsr_write(rt2x00dev, 22, rfcsr);
+
+	/*
+	 * set BBP back to BW20
+	 */
+	rt2800_bbp_read(rt2x00dev, 4, &bbp);
+	rt2x00_set_field8(&bbp, BBP4_BANDWIDTH, 0);
+	rt2800_bbp_write(rt2x00dev, 4, bbp);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2800_init_rfcsr);
Index: b/drivers/net/wireless/rt2x00/rt2800lib.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -96,16 +96,6 @@ static inline int rt2800_regbusy_read(st
 	return rt2800ops->regbusy_read(rt2x00dev, offset, field, reg);
 }
 
-void rt2800_bbp_write(struct rt2x00_dev *rt2x00dev,
-		      const unsigned int word, const u8 value);
-void rt2800_bbp_read(struct rt2x00_dev *rt2x00dev,
-		     const unsigned int word, u8 *value);
-void rt2800_rfcsr_write(struct rt2x00_dev *rt2x00dev,
-			const unsigned int word, const u8 value);
-void rt2800_rfcsr_read(struct rt2x00_dev *rt2x00dev,
-		       const unsigned int word, u8 *value);
-void rt2800_rf_write(struct rt2x00_dev *rt2x00dev,
-		     const unsigned int word, const u32 value);
 void rt2800_mcu_request(struct rt2x00_dev *rt2x00dev,
 			const u8 command, const u8 token,
 			const u8 arg0, const u8 arg1);
@@ -135,4 +125,8 @@ void rt2800_reset_tuner(struct rt2x00_de
 void rt2800_link_tuner(struct rt2x00_dev *rt2x00dev, struct link_qual *qual,
 		       const u32 count);
 
+int rt2800_init_registers(struct rt2x00_dev *rt2x00dev);
+int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev);
+int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev);
+
 #endif /* RT2800LIB_H */
Index: b/drivers/net/wireless/rt2x00/rt2800pci.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -420,497 +420,6 @@ static int rt2800pci_init_queues(struct 
 	return 0;
 }
 
-static int rt2800pci_init_registers(struct rt2x00_dev *rt2x00dev)
-{
-	u32 reg;
-	unsigned int i;
-
-	if (rt2x00_intf_is_pci(rt2x00dev))
-		rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
-
-	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
-	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_CSR, 1);
-	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_BBP, 1);
-	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
-
-	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, 0x00000000);
-
-	rt2800_register_read(rt2x00dev, BCN_OFFSET0, &reg);
-	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN0, 0xe0); /* 0x3800 */
-	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN1, 0xe8); /* 0x3a00 */
-	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN2, 0xf0); /* 0x3c00 */
-	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN3, 0xf8); /* 0x3e00 */
-	rt2800_register_write(rt2x00dev, BCN_OFFSET0, reg);
-
-	rt2800_register_read(rt2x00dev, BCN_OFFSET1, &reg);
-	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN4, 0xc8); /* 0x3200 */
-	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN5, 0xd0); /* 0x3400 */
-	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN6, 0x77); /* 0x1dc0 */
-	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN7, 0x6f); /* 0x1bc0 */
-	rt2800_register_write(rt2x00dev, BCN_OFFSET1, reg);
-
-	rt2800_register_write(rt2x00dev, LEGACY_BASIC_RATE, 0x0000013f);
-	rt2800_register_write(rt2x00dev, HT_BASIC_RATE, 0x00008003);
-
-	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, 0x00000000);
-
-	rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_INTERVAL, 0);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 0);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_SYNC, 0);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 0);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 0);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_TX_TIME_COMPENSATE, 0);
-	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
-
-	rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000000);
-	rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
-
-	rt2800_register_read(rt2x00dev, TX_LINK_CFG, &reg);
-	rt2x00_set_field32(&reg, TX_LINK_CFG_REMOTE_MFB_LIFETIME, 32);
-	rt2x00_set_field32(&reg, TX_LINK_CFG_MFB_ENABLE, 0);
-	rt2x00_set_field32(&reg, TX_LINK_CFG_REMOTE_UMFS_ENABLE, 0);
-	rt2x00_set_field32(&reg, TX_LINK_CFG_TX_MRQ_EN, 0);
-	rt2x00_set_field32(&reg, TX_LINK_CFG_TX_RDG_EN, 0);
-	rt2x00_set_field32(&reg, TX_LINK_CFG_TX_CF_ACK_EN, 1);
-	rt2x00_set_field32(&reg, TX_LINK_CFG_REMOTE_MFB, 0);
-	rt2x00_set_field32(&reg, TX_LINK_CFG_REMOTE_MFS, 0);
-	rt2800_register_write(rt2x00dev, TX_LINK_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, TX_TIMEOUT_CFG, &reg);
-	rt2x00_set_field32(&reg, TX_TIMEOUT_CFG_MPDU_LIFETIME, 9);
-	rt2x00_set_field32(&reg, TX_TIMEOUT_CFG_TX_OP_TIMEOUT, 10);
-	rt2800_register_write(rt2x00dev, TX_TIMEOUT_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, MAX_LEN_CFG, &reg);
-	rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_MPDU, AGGREGATION_SIZE);
-	if (rt2x00_rev(&rt2x00dev->chip) >= RT2880E_VERSION &&
-	    rt2x00_rev(&rt2x00dev->chip) < RT3070_VERSION)
-		rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 2);
-	else
-		rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 1);
-	rt2x00_set_field32(&reg, MAX_LEN_CFG_MIN_PSDU, 0);
-	rt2x00_set_field32(&reg, MAX_LEN_CFG_MIN_MPDU, 0);
-	rt2800_register_write(rt2x00dev, MAX_LEN_CFG, reg);
-
-	rt2800_register_write(rt2x00dev, PBF_MAX_PCNT, 0x1f3fbf9f);
-
-	rt2800_register_read(rt2x00dev, AUTO_RSP_CFG, &reg);
-	rt2x00_set_field32(&reg, AUTO_RSP_CFG_AUTORESPONDER, 1);
-	rt2x00_set_field32(&reg, AUTO_RSP_CFG_CTS_40_MMODE, 0);
-	rt2x00_set_field32(&reg, AUTO_RSP_CFG_CTS_40_MREF, 0);
-	rt2x00_set_field32(&reg, AUTO_RSP_CFG_DUAL_CTS_EN, 0);
-	rt2x00_set_field32(&reg, AUTO_RSP_CFG_ACK_CTS_PSM_BIT, 0);
-	rt2800_register_write(rt2x00dev, AUTO_RSP_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, CCK_PROT_CFG, &reg);
-	rt2x00_set_field32(&reg, CCK_PROT_CFG_PROTECT_RATE, 8);
-	rt2x00_set_field32(&reg, CCK_PROT_CFG_PROTECT_CTRL, 0);
-	rt2x00_set_field32(&reg, CCK_PROT_CFG_PROTECT_NAV, 1);
-	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_CCK, 1);
-	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
-	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_MM20, 1);
-	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_MM40, 1);
-	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_GF20, 1);
-	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_GF40, 1);
-	rt2800_register_write(rt2x00dev, CCK_PROT_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, OFDM_PROT_CFG, &reg);
-	rt2x00_set_field32(&reg, OFDM_PROT_CFG_PROTECT_RATE, 8);
-	rt2x00_set_field32(&reg, OFDM_PROT_CFG_PROTECT_CTRL, 0);
-	rt2x00_set_field32(&reg, OFDM_PROT_CFG_PROTECT_NAV, 1);
-	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_CCK, 1);
-	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
-	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_MM20, 1);
-	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_MM40, 1);
-	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_GF20, 1);
-	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_GF40, 1);
-	rt2800_register_write(rt2x00dev, OFDM_PROT_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, MM20_PROT_CFG, &reg);
-	rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_RATE, 0x4004);
-	rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_CTRL, 0);
-	rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_NAV, 1);
-	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_CCK, 1);
-	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
-	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_MM20, 1);
-	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_MM40, 0);
-	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_GF20, 1);
-	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_GF40, 0);
-	rt2800_register_write(rt2x00dev, MM20_PROT_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, MM40_PROT_CFG, &reg);
-	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_RATE, 0x4084);
-	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_CTRL, 0);
-	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_NAV, 1);
-	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_CCK, 1);
-	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
-	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_MM20, 1);
-	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_MM40, 1);
-	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_GF20, 1);
-	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_GF40, 1);
-	rt2800_register_write(rt2x00dev, MM40_PROT_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, GF20_PROT_CFG, &reg);
-	rt2x00_set_field32(&reg, GF20_PROT_CFG_PROTECT_RATE, 0x4004);
-	rt2x00_set_field32(&reg, GF20_PROT_CFG_PROTECT_CTRL, 0);
-	rt2x00_set_field32(&reg, GF20_PROT_CFG_PROTECT_NAV, 1);
-	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_CCK, 1);
-	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
-	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_MM20, 1);
-	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_MM40, 0);
-	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_GF20, 1);
-	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_GF40, 0);
-	rt2800_register_write(rt2x00dev, GF20_PROT_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, GF40_PROT_CFG, &reg);
-	rt2x00_set_field32(&reg, GF40_PROT_CFG_PROTECT_RATE, 0x4084);
-	rt2x00_set_field32(&reg, GF40_PROT_CFG_PROTECT_CTRL, 0);
-	rt2x00_set_field32(&reg, GF40_PROT_CFG_PROTECT_NAV, 1);
-	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_CCK, 1);
-	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
-	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_MM20, 1);
-	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_MM40, 1);
-	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_GF20, 1);
-	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_GF40, 1);
-	rt2800_register_write(rt2x00dev, GF40_PROT_CFG, reg);
-
-	rt2800_register_write(rt2x00dev, TXOP_CTRL_CFG, 0x0000583f);
-	rt2800_register_write(rt2x00dev, TXOP_HLDR_ET, 0x00000002);
-
-	rt2800_register_read(rt2x00dev, TX_RTS_CFG, &reg);
-	rt2x00_set_field32(&reg, TX_RTS_CFG_AUTO_RTS_RETRY_LIMIT, 32);
-	rt2x00_set_field32(&reg, TX_RTS_CFG_RTS_THRES,
-			   IEEE80211_MAX_RTS_THRESHOLD);
-	rt2x00_set_field32(&reg, TX_RTS_CFG_RTS_FBK_EN, 0);
-	rt2800_register_write(rt2x00dev, TX_RTS_CFG, reg);
-
-	rt2800_register_write(rt2x00dev, EXP_ACK_TIME, 0x002400ca);
-	rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
-
-	/*
-	 * ASIC will keep garbage value after boot, clear encryption keys.
-	 */
-	for (i = 0; i < 4; i++)
-		rt2800_register_write(rt2x00dev,
-					 SHARED_KEY_MODE_ENTRY(i), 0);
-
-	for (i = 0; i < 256; i++) {
-		u32 wcid[2] = { 0xffffffff, 0x00ffffff };
-		rt2800_register_multiwrite(rt2x00dev, MAC_WCID_ENTRY(i),
-					      wcid, sizeof(wcid));
-
-		rt2800_register_write(rt2x00dev, MAC_WCID_ATTR_ENTRY(i), 1);
-		rt2800_register_write(rt2x00dev, MAC_IVEIV_ENTRY(i), 0);
-	}
-
-	/*
-	 * Clear all beacons
-	 * For the Beacon base registers we only need to clear
-	 * the first byte since that byte contains the VALID and OWNER
-	 * bits which (when set to 0) will invalidate the entire beacon.
-	 */
-	rt2800_register_write(rt2x00dev, HW_BEACON_BASE0, 0);
-	rt2800_register_write(rt2x00dev, HW_BEACON_BASE1, 0);
-	rt2800_register_write(rt2x00dev, HW_BEACON_BASE2, 0);
-	rt2800_register_write(rt2x00dev, HW_BEACON_BASE3, 0);
-	rt2800_register_write(rt2x00dev, HW_BEACON_BASE4, 0);
-	rt2800_register_write(rt2x00dev, HW_BEACON_BASE5, 0);
-	rt2800_register_write(rt2x00dev, HW_BEACON_BASE6, 0);
-	rt2800_register_write(rt2x00dev, HW_BEACON_BASE7, 0);
-
-	rt2800_register_read(rt2x00dev, HT_FBK_CFG0, &reg);
-	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS0FBK, 0);
-	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS1FBK, 0);
-	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS2FBK, 1);
-	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS3FBK, 2);
-	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS4FBK, 3);
-	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS5FBK, 4);
-	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS6FBK, 5);
-	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS7FBK, 6);
-	rt2800_register_write(rt2x00dev, HT_FBK_CFG0, reg);
-
-	rt2800_register_read(rt2x00dev, HT_FBK_CFG1, &reg);
-	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS8FBK, 8);
-	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS9FBK, 8);
-	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS10FBK, 9);
-	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS11FBK, 10);
-	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS12FBK, 11);
-	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS13FBK, 12);
-	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS14FBK, 13);
-	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS15FBK, 14);
-	rt2800_register_write(rt2x00dev, HT_FBK_CFG1, reg);
-
-	rt2800_register_read(rt2x00dev, LG_FBK_CFG0, &reg);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS0FBK, 8);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS1FBK, 8);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS2FBK, 9);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS3FBK, 10);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS4FBK, 11);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS5FBK, 12);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS6FBK, 13);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS7FBK, 14);
-	rt2800_register_write(rt2x00dev, LG_FBK_CFG0, reg);
-
-	rt2800_register_read(rt2x00dev, LG_FBK_CFG1, &reg);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_CCKMCS0FBK, 0);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_CCKMCS1FBK, 0);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_CCKMCS2FBK, 1);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_CCKMCS3FBK, 2);
-	rt2800_register_write(rt2x00dev, LG_FBK_CFG1, reg);
-
-	/*
-	 * We must clear the error counters.
-	 * These registers are cleared on read,
-	 * so we may pass a useless variable to store the value.
-	 */
-	rt2800_register_read(rt2x00dev, RX_STA_CNT0, &reg);
-	rt2800_register_read(rt2x00dev, RX_STA_CNT1, &reg);
-	rt2800_register_read(rt2x00dev, RX_STA_CNT2, &reg);
-	rt2800_register_read(rt2x00dev, TX_STA_CNT0, &reg);
-	rt2800_register_read(rt2x00dev, TX_STA_CNT1, &reg);
-	rt2800_register_read(rt2x00dev, TX_STA_CNT2, &reg);
-
-	return 0;
-}
-
-static int rt2800pci_wait_bbp_rf_ready(struct rt2x00_dev *rt2x00dev)
-{
-	unsigned int i;
-	u32 reg;
-
-	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt2800_register_read(rt2x00dev, MAC_STATUS_CFG, &reg);
-		if (!rt2x00_get_field32(reg, MAC_STATUS_CFG_BBP_RF_BUSY))
-			return 0;
-
-		udelay(REGISTER_BUSY_DELAY);
-	}
-
-	ERROR(rt2x00dev, "BBP/RF register access failed, aborting.\n");
-	return -EACCES;
-}
-
-static int rt2800pci_wait_bbp_ready(struct rt2x00_dev *rt2x00dev)
-{
-	unsigned int i;
-	u8 value;
-
-	/*
-	 * BBP was enabled after firmware was loaded,
-	 * but we need to reactivate it now.
-	 */
-	rt2800_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
-	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
-	msleep(1);
-
-	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt2800_bbp_read(rt2x00dev, 0, &value);
-		if ((value != 0xff) && (value != 0x00))
-			return 0;
-		udelay(REGISTER_BUSY_DELAY);
-	}
-
-	ERROR(rt2x00dev, "BBP register access failed, aborting.\n");
-	return -EACCES;
-}
-
-static int rt2800pci_init_bbp(struct rt2x00_dev *rt2x00dev)
-{
-	unsigned int i;
-	u16 eeprom;
-	u8 reg_id;
-	u8 value;
-
-	if (unlikely(rt2800pci_wait_bbp_rf_ready(rt2x00dev) ||
-		     rt2800pci_wait_bbp_ready(rt2x00dev)))
-		return -EACCES;
-
-	rt2800_bbp_write(rt2x00dev, 65, 0x2c);
-	rt2800_bbp_write(rt2x00dev, 66, 0x38);
-	rt2800_bbp_write(rt2x00dev, 69, 0x12);
-	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
-	rt2800_bbp_write(rt2x00dev, 73, 0x10);
-	rt2800_bbp_write(rt2x00dev, 81, 0x37);
-	rt2800_bbp_write(rt2x00dev, 82, 0x62);
-	rt2800_bbp_write(rt2x00dev, 83, 0x6a);
-	rt2800_bbp_write(rt2x00dev, 84, 0x99);
-	rt2800_bbp_write(rt2x00dev, 86, 0x00);
-	rt2800_bbp_write(rt2x00dev, 91, 0x04);
-	rt2800_bbp_write(rt2x00dev, 92, 0x00);
-	rt2800_bbp_write(rt2x00dev, 103, 0x00);
-	rt2800_bbp_write(rt2x00dev, 105, 0x05);
-
-	if (rt2x00_rev(&rt2x00dev->chip) == RT2860C_VERSION) {
-		rt2800_bbp_write(rt2x00dev, 69, 0x16);
-		rt2800_bbp_write(rt2x00dev, 73, 0x12);
-	}
-
-	if (rt2x00_rev(&rt2x00dev->chip) > RT2860D_VERSION)
-		rt2800_bbp_write(rt2x00dev, 84, 0x19);
-
-	if (rt2x00_intf_is_pci(rt2x00dev) &&
-	    rt2x00_rt(&rt2x00dev->chip, RT3052)) {
-		rt2800_bbp_write(rt2x00dev, 31, 0x08);
-		rt2800_bbp_write(rt2x00dev, 78, 0x0e);
-		rt2800_bbp_write(rt2x00dev, 80, 0x08);
-	}
-
-	for (i = 0; i < EEPROM_BBP_SIZE; i++) {
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_BBP_START + i, &eeprom);
-
-		if (eeprom != 0xffff && eeprom != 0x0000) {
-			reg_id = rt2x00_get_field16(eeprom, EEPROM_BBP_REG_ID);
-			value = rt2x00_get_field16(eeprom, EEPROM_BBP_VALUE);
-			rt2800_bbp_write(rt2x00dev, reg_id, value);
-		}
-	}
-
-	return 0;
-}
-
-static u8 rt2800pci_init_rx_filter(struct rt2x00_dev *rt2x00dev,
-				   bool bw40, u8 rfcsr24, u8 filter_target)
-{
-	unsigned int i;
-	u8 bbp;
-	u8 rfcsr;
-	u8 passband;
-	u8 stopband;
-	u8 overtuned = 0;
-
-	rt2800_rfcsr_write(rt2x00dev, 24, rfcsr24);
-
-	rt2800_bbp_read(rt2x00dev, 4, &bbp);
-	rt2x00_set_field8(&bbp, BBP4_BANDWIDTH, 2 * bw40);
-	rt2800_bbp_write(rt2x00dev, 4, bbp);
-
-	rt2800_rfcsr_read(rt2x00dev, 22, &rfcsr);
-	rt2x00_set_field8(&rfcsr, RFCSR22_BASEBAND_LOOPBACK, 1);
-	rt2800_rfcsr_write(rt2x00dev, 22, rfcsr);
-
-	/*
-	 * Set power & frequency of passband test tone
-	 */
-	rt2800_bbp_write(rt2x00dev, 24, 0);
-
-	for (i = 0; i < 100; i++) {
-		rt2800_bbp_write(rt2x00dev, 25, 0x90);
-		msleep(1);
-
-		rt2800_bbp_read(rt2x00dev, 55, &passband);
-		if (passband)
-			break;
-	}
-
-	/*
-	 * Set power & frequency of stopband test tone
-	 */
-	rt2800_bbp_write(rt2x00dev, 24, 0x06);
-
-	for (i = 0; i < 100; i++) {
-		rt2800_bbp_write(rt2x00dev, 25, 0x90);
-		msleep(1);
-
-		rt2800_bbp_read(rt2x00dev, 55, &stopband);
-
-		if ((passband - stopband) <= filter_target) {
-			rfcsr24++;
-			overtuned += ((passband - stopband) == filter_target);
-		} else
-			break;
-
-		rt2800_rfcsr_write(rt2x00dev, 24, rfcsr24);
-	}
-
-	rfcsr24 -= !!overtuned;
-
-	rt2800_rfcsr_write(rt2x00dev, 24, rfcsr24);
-	return rfcsr24;
-}
-
-static int rt2800pci_init_rfcsr(struct rt2x00_dev *rt2x00dev)
-{
-	u8 rfcsr;
-	u8 bbp;
-
-	if (rt2x00_intf_is_pci(rt2x00dev)) {
-		if (!rt2x00_rf(&rt2x00dev->chip, RF3020) &&
-		    !rt2x00_rf(&rt2x00dev->chip, RF3021) &&
-		    !rt2x00_rf(&rt2x00dev->chip, RF3022))
-			return 0;
-	}
-
-	/*
-	 * Init RF calibration.
-	 */
-	rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
-	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
-	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
-	msleep(1);
-	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 0);
-	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
-
-	if (rt2x00_intf_is_pci(rt2x00dev)) {
-		rt2800_rfcsr_write(rt2x00dev, 0, 0x50);
-		rt2800_rfcsr_write(rt2x00dev, 1, 0x01);
-		rt2800_rfcsr_write(rt2x00dev, 2, 0xf7);
-		rt2800_rfcsr_write(rt2x00dev, 3, 0x75);
-		rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
-		rt2800_rfcsr_write(rt2x00dev, 5, 0x03);
-		rt2800_rfcsr_write(rt2x00dev, 6, 0x02);
-		rt2800_rfcsr_write(rt2x00dev, 7, 0x50);
-		rt2800_rfcsr_write(rt2x00dev, 8, 0x39);
-		rt2800_rfcsr_write(rt2x00dev, 9, 0x0f);
-		rt2800_rfcsr_write(rt2x00dev, 10, 0x60);
-		rt2800_rfcsr_write(rt2x00dev, 11, 0x21);
-		rt2800_rfcsr_write(rt2x00dev, 12, 0x75);
-		rt2800_rfcsr_write(rt2x00dev, 13, 0x75);
-		rt2800_rfcsr_write(rt2x00dev, 14, 0x90);
-		rt2800_rfcsr_write(rt2x00dev, 15, 0x58);
-		rt2800_rfcsr_write(rt2x00dev, 16, 0xb3);
-		rt2800_rfcsr_write(rt2x00dev, 17, 0x92);
-		rt2800_rfcsr_write(rt2x00dev, 18, 0x2c);
-		rt2800_rfcsr_write(rt2x00dev, 19, 0x02);
-		rt2800_rfcsr_write(rt2x00dev, 20, 0xba);
-		rt2800_rfcsr_write(rt2x00dev, 21, 0xdb);
-		rt2800_rfcsr_write(rt2x00dev, 22, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 23, 0x31);
-		rt2800_rfcsr_write(rt2x00dev, 24, 0x08);
-		rt2800_rfcsr_write(rt2x00dev, 25, 0x01);
-		rt2800_rfcsr_write(rt2x00dev, 26, 0x25);
-		rt2800_rfcsr_write(rt2x00dev, 27, 0x23);
-		rt2800_rfcsr_write(rt2x00dev, 28, 0x13);
-		rt2800_rfcsr_write(rt2x00dev, 29, 0x83);
-	}
-
-	/*
-	 * Set RX Filter calibration for 20MHz and 40MHz
-	 */
-	rt2x00dev->calibration[0] =
-	    rt2800pci_init_rx_filter(rt2x00dev, false, 0x07, 0x16);
-	rt2x00dev->calibration[1] =
-	    rt2800pci_init_rx_filter(rt2x00dev, true, 0x27, 0x19);
-
-	/*
-	 * Set back to initial state
-	 */
-	rt2800_bbp_write(rt2x00dev, 24, 0);
-
-	rt2800_rfcsr_read(rt2x00dev, 22, &rfcsr);
-	rt2x00_set_field8(&rfcsr, RFCSR22_BASEBAND_LOOPBACK, 0);
-	rt2800_rfcsr_write(rt2x00dev, 22, rfcsr);
-
-	/*
-	 * set BBP back to BW20
-	 */
-	rt2800_bbp_read(rt2x00dev, 4, &bbp);
-	rt2x00_set_field8(&bbp, BBP4_BANDWIDTH, 0);
-	rt2800_bbp_write(rt2x00dev, 4, bbp);
-
-	return 0;
-}
-
 /*
  * Device state switch handlers.
  */
@@ -991,10 +500,10 @@ static int rt2800pci_enable_radio(struct
 	 */
 	if (unlikely(rt2800pci_wait_wpdma_ready(rt2x00dev) ||
 		     rt2800pci_init_queues(rt2x00dev) ||
-		     rt2800pci_init_registers(rt2x00dev) ||
+		     rt2800_init_registers(rt2x00dev) ||
 		     rt2800pci_wait_wpdma_ready(rt2x00dev) ||
-		     rt2800pci_init_bbp(rt2x00dev) ||
-		     rt2800pci_init_rfcsr(rt2x00dev)))
+		     rt2800_init_bbp(rt2x00dev) ||
+		     rt2800_init_rfcsr(rt2x00dev)))
 		return -EIO;
 
 	/*
Index: b/drivers/net/wireless/rt2x00/rt2800usb.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -230,541 +230,6 @@ static int rt2800usb_load_firmware(struc
 }
 
 /*
- * Initialization functions.
- */
-static int rt2800usb_init_registers(struct rt2x00_dev *rt2x00dev)
-{
-	u32 reg;
-	unsigned int i;
-
-	if (rt2x00_intf_is_usb(rt2x00dev)) {
-		/*
-		 * Wait untill BBP and RF are ready.
-		 */
-		for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-			rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
-			if (reg && reg != ~0)
-				break;
-			msleep(1);
-		}
-
-		if (i == REGISTER_BUSY_COUNT) {
-			ERROR(rt2x00dev, "Unstable hardware.\n");
-			return -EBUSY;
-		}
-
-		rt2800_register_read(rt2x00dev, PBF_SYS_CTRL, &reg);
-		rt2800_register_write(rt2x00dev, PBF_SYS_CTRL,
-				      reg & ~0x00002000);
-	}
-
-	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
-	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_CSR, 1);
-	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_BBP, 1);
-	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
-
-	if (rt2x00_intf_is_usb(rt2x00dev)) {
-		rt2800_register_write(rt2x00dev, USB_DMA_CFG, 0x00000000);
-
-		rt2x00usb_vendor_request_sw(rt2x00dev, USB_DEVICE_MODE, 0,
-					    USB_MODE_RESET, REGISTER_TIMEOUT);
-	}
-
-	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, 0x00000000);
-
-	rt2800_register_read(rt2x00dev, BCN_OFFSET0, &reg);
-	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN0, 0xe0); /* 0x3800 */
-	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN1, 0xe8); /* 0x3a00 */
-	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN2, 0xf0); /* 0x3c00 */
-	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN3, 0xf8); /* 0x3e00 */
-	rt2800_register_write(rt2x00dev, BCN_OFFSET0, reg);
-
-	rt2800_register_read(rt2x00dev, BCN_OFFSET1, &reg);
-	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN4, 0xc8); /* 0x3200 */
-	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN5, 0xd0); /* 0x3400 */
-	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN6, 0x77); /* 0x1dc0 */
-	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN7, 0x6f); /* 0x1bc0 */
-	rt2800_register_write(rt2x00dev, BCN_OFFSET1, reg);
-
-	rt2800_register_write(rt2x00dev, LEGACY_BASIC_RATE, 0x0000013f);
-	rt2800_register_write(rt2x00dev, HT_BASIC_RATE, 0x00008003);
-
-	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, 0x00000000);
-
-	rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_INTERVAL, 0);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 0);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_SYNC, 0);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 0);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 0);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_TX_TIME_COMPENSATE, 0);
-	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
-
-	if (rt2x00_intf_is_usb(rt2x00dev) &&
-	    rt2x00_rev(&rt2x00dev->chip) == RT3070_VERSION) {
-		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
-		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
-		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
-	} else {
-		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000000);
-		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
-	}
-
-	rt2800_register_read(rt2x00dev, TX_LINK_CFG, &reg);
-	rt2x00_set_field32(&reg, TX_LINK_CFG_REMOTE_MFB_LIFETIME, 32);
-	rt2x00_set_field32(&reg, TX_LINK_CFG_MFB_ENABLE, 0);
-	rt2x00_set_field32(&reg, TX_LINK_CFG_REMOTE_UMFS_ENABLE, 0);
-	rt2x00_set_field32(&reg, TX_LINK_CFG_TX_MRQ_EN, 0);
-	rt2x00_set_field32(&reg, TX_LINK_CFG_TX_RDG_EN, 0);
-	rt2x00_set_field32(&reg, TX_LINK_CFG_TX_CF_ACK_EN, 1);
-	rt2x00_set_field32(&reg, TX_LINK_CFG_REMOTE_MFB, 0);
-	rt2x00_set_field32(&reg, TX_LINK_CFG_REMOTE_MFS, 0);
-	rt2800_register_write(rt2x00dev, TX_LINK_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, TX_TIMEOUT_CFG, &reg);
-	rt2x00_set_field32(&reg, TX_TIMEOUT_CFG_MPDU_LIFETIME, 9);
-	rt2x00_set_field32(&reg, TX_TIMEOUT_CFG_TX_OP_TIMEOUT, 10);
-	rt2800_register_write(rt2x00dev, TX_TIMEOUT_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, MAX_LEN_CFG, &reg);
-	rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_MPDU, AGGREGATION_SIZE);
-	if (rt2x00_rev(&rt2x00dev->chip) >= RT2880E_VERSION &&
-	    rt2x00_rev(&rt2x00dev->chip) < RT3070_VERSION)
-		rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 2);
-	else
-		rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 1);
-	rt2x00_set_field32(&reg, MAX_LEN_CFG_MIN_PSDU, 0);
-	rt2x00_set_field32(&reg, MAX_LEN_CFG_MIN_MPDU, 0);
-	rt2800_register_write(rt2x00dev, MAX_LEN_CFG, reg);
-
-	rt2800_register_write(rt2x00dev, PBF_MAX_PCNT, 0x1f3fbf9f);
-
-	rt2800_register_read(rt2x00dev, AUTO_RSP_CFG, &reg);
-	rt2x00_set_field32(&reg, AUTO_RSP_CFG_AUTORESPONDER, 1);
-	rt2x00_set_field32(&reg, AUTO_RSP_CFG_CTS_40_MMODE, 0);
-	rt2x00_set_field32(&reg, AUTO_RSP_CFG_CTS_40_MREF, 0);
-	rt2x00_set_field32(&reg, AUTO_RSP_CFG_DUAL_CTS_EN, 0);
-	rt2x00_set_field32(&reg, AUTO_RSP_CFG_ACK_CTS_PSM_BIT, 0);
-	rt2800_register_write(rt2x00dev, AUTO_RSP_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, CCK_PROT_CFG, &reg);
-	rt2x00_set_field32(&reg, CCK_PROT_CFG_PROTECT_RATE, 8);
-	rt2x00_set_field32(&reg, CCK_PROT_CFG_PROTECT_CTRL, 0);
-	rt2x00_set_field32(&reg, CCK_PROT_CFG_PROTECT_NAV, 1);
-	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_CCK, 1);
-	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
-	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_MM20, 1);
-	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_MM40, 1);
-	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_GF20, 1);
-	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_GF40, 1);
-	rt2800_register_write(rt2x00dev, CCK_PROT_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, OFDM_PROT_CFG, &reg);
-	rt2x00_set_field32(&reg, OFDM_PROT_CFG_PROTECT_RATE, 8);
-	rt2x00_set_field32(&reg, OFDM_PROT_CFG_PROTECT_CTRL, 0);
-	rt2x00_set_field32(&reg, OFDM_PROT_CFG_PROTECT_NAV, 1);
-	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_CCK, 1);
-	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
-	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_MM20, 1);
-	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_MM40, 1);
-	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_GF20, 1);
-	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_GF40, 1);
-	rt2800_register_write(rt2x00dev, OFDM_PROT_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, MM20_PROT_CFG, &reg);
-	rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_RATE, 0x4004);
-	rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_CTRL, 0);
-	rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_NAV, 1);
-	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_CCK, 1);
-	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
-	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_MM20, 1);
-	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_MM40, 0);
-	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_GF20, 1);
-	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_GF40, 0);
-	rt2800_register_write(rt2x00dev, MM20_PROT_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, MM40_PROT_CFG, &reg);
-	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_RATE, 0x4084);
-	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_CTRL, 0);
-	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_NAV, 1);
-	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_CCK, 1);
-	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
-	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_MM20, 1);
-	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_MM40, 1);
-	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_GF20, 1);
-	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_GF40, 1);
-	rt2800_register_write(rt2x00dev, MM40_PROT_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, GF20_PROT_CFG, &reg);
-	rt2x00_set_field32(&reg, GF20_PROT_CFG_PROTECT_RATE, 0x4004);
-	rt2x00_set_field32(&reg, GF20_PROT_CFG_PROTECT_CTRL, 0);
-	rt2x00_set_field32(&reg, GF20_PROT_CFG_PROTECT_NAV, 1);
-	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_CCK, 1);
-	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
-	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_MM20, 1);
-	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_MM40, 0);
-	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_GF20, 1);
-	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_GF40, 0);
-	rt2800_register_write(rt2x00dev, GF20_PROT_CFG, reg);
-
-	rt2800_register_read(rt2x00dev, GF40_PROT_CFG, &reg);
-	rt2x00_set_field32(&reg, GF40_PROT_CFG_PROTECT_RATE, 0x4084);
-	rt2x00_set_field32(&reg, GF40_PROT_CFG_PROTECT_CTRL, 0);
-	rt2x00_set_field32(&reg, GF40_PROT_CFG_PROTECT_NAV, 1);
-	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_CCK, 1);
-	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
-	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_MM20, 1);
-	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_MM40, 1);
-	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_GF20, 1);
-	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_GF40, 1);
-	rt2800_register_write(rt2x00dev, GF40_PROT_CFG, reg);
-
-	if (rt2x00_intf_is_usb(rt2x00dev)) {
-		rt2800_register_write(rt2x00dev, PBF_CFG, 0xf40006);
-
-		rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
-		rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
-		rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_DMA_BUSY, 0);
-		rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
-		rt2x00_set_field32(&reg, WPDMA_GLO_CFG_RX_DMA_BUSY, 0);
-		rt2x00_set_field32(&reg, WPDMA_GLO_CFG_WP_DMA_BURST_SIZE, 3);
-		rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_WRITEBACK_DONE, 0);
-		rt2x00_set_field32(&reg, WPDMA_GLO_CFG_BIG_ENDIAN, 0);
-		rt2x00_set_field32(&reg, WPDMA_GLO_CFG_RX_HDR_SCATTER, 0);
-		rt2x00_set_field32(&reg, WPDMA_GLO_CFG_HDR_SEG_LEN, 0);
-		rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
-	}
-
-	rt2800_register_write(rt2x00dev, TXOP_CTRL_CFG, 0x0000583f);
-	rt2800_register_write(rt2x00dev, TXOP_HLDR_ET, 0x00000002);
-
-	rt2800_register_read(rt2x00dev, TX_RTS_CFG, &reg);
-	rt2x00_set_field32(&reg, TX_RTS_CFG_AUTO_RTS_RETRY_LIMIT, 32);
-	rt2x00_set_field32(&reg, TX_RTS_CFG_RTS_THRES,
-			   IEEE80211_MAX_RTS_THRESHOLD);
-	rt2x00_set_field32(&reg, TX_RTS_CFG_RTS_FBK_EN, 0);
-	rt2800_register_write(rt2x00dev, TX_RTS_CFG, reg);
-
-	rt2800_register_write(rt2x00dev, EXP_ACK_TIME, 0x002400ca);
-	rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
-
-	/*
-	 * ASIC will keep garbage value after boot, clear encryption keys.
-	 */
-	for (i = 0; i < 4; i++)
-		rt2800_register_write(rt2x00dev,
-					 SHARED_KEY_MODE_ENTRY(i), 0);
-
-	for (i = 0; i < 256; i++) {
-		u32 wcid[2] = { 0xffffffff, 0x00ffffff };
-		rt2800_register_multiwrite(rt2x00dev, MAC_WCID_ENTRY(i),
-					      wcid, sizeof(wcid));
-
-		rt2800_register_write(rt2x00dev, MAC_WCID_ATTR_ENTRY(i), 1);
-		rt2800_register_write(rt2x00dev, MAC_IVEIV_ENTRY(i), 0);
-	}
-
-	/*
-	 * Clear all beacons
-	 * For the Beacon base registers we only need to clear
-	 * the first byte since that byte contains the VALID and OWNER
-	 * bits which (when set to 0) will invalidate the entire beacon.
-	 */
-	rt2800_register_write(rt2x00dev, HW_BEACON_BASE0, 0);
-	rt2800_register_write(rt2x00dev, HW_BEACON_BASE1, 0);
-	rt2800_register_write(rt2x00dev, HW_BEACON_BASE2, 0);
-	rt2800_register_write(rt2x00dev, HW_BEACON_BASE3, 0);
-	rt2800_register_write(rt2x00dev, HW_BEACON_BASE4, 0);
-	rt2800_register_write(rt2x00dev, HW_BEACON_BASE5, 0);
-	rt2800_register_write(rt2x00dev, HW_BEACON_BASE6, 0);
-	rt2800_register_write(rt2x00dev, HW_BEACON_BASE7, 0);
-
-	if (rt2x00_intf_is_usb(rt2x00dev)) {
-		rt2800_register_read(rt2x00dev, USB_CYC_CFG, &reg);
-		rt2x00_set_field32(&reg, USB_CYC_CFG_CLOCK_CYCLE, 30);
-		rt2800_register_write(rt2x00dev, USB_CYC_CFG, reg);
-	}
-
-	rt2800_register_read(rt2x00dev, HT_FBK_CFG0, &reg);
-	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS0FBK, 0);
-	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS1FBK, 0);
-	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS2FBK, 1);
-	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS3FBK, 2);
-	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS4FBK, 3);
-	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS5FBK, 4);
-	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS6FBK, 5);
-	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS7FBK, 6);
-	rt2800_register_write(rt2x00dev, HT_FBK_CFG0, reg);
-
-	rt2800_register_read(rt2x00dev, HT_FBK_CFG1, &reg);
-	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS8FBK, 8);
-	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS9FBK, 8);
-	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS10FBK, 9);
-	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS11FBK, 10);
-	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS12FBK, 11);
-	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS13FBK, 12);
-	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS14FBK, 13);
-	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS15FBK, 14);
-	rt2800_register_write(rt2x00dev, HT_FBK_CFG1, reg);
-
-	rt2800_register_read(rt2x00dev, LG_FBK_CFG0, &reg);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS0FBK, 8);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS1FBK, 8);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS2FBK, 9);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS3FBK, 10);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS4FBK, 11);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS5FBK, 12);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS6FBK, 13);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS7FBK, 14);
-	rt2800_register_write(rt2x00dev, LG_FBK_CFG0, reg);
-
-	rt2800_register_read(rt2x00dev, LG_FBK_CFG1, &reg);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_CCKMCS0FBK, 0);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_CCKMCS1FBK, 0);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_CCKMCS2FBK, 1);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_CCKMCS3FBK, 2);
-	rt2800_register_write(rt2x00dev, LG_FBK_CFG1, reg);
-
-	/*
-	 * We must clear the error counters.
-	 * These registers are cleared on read,
-	 * so we may pass a useless variable to store the value.
-	 */
-	rt2800_register_read(rt2x00dev, RX_STA_CNT0, &reg);
-	rt2800_register_read(rt2x00dev, RX_STA_CNT1, &reg);
-	rt2800_register_read(rt2x00dev, RX_STA_CNT2, &reg);
-	rt2800_register_read(rt2x00dev, TX_STA_CNT0, &reg);
-	rt2800_register_read(rt2x00dev, TX_STA_CNT1, &reg);
-	rt2800_register_read(rt2x00dev, TX_STA_CNT2, &reg);
-
-	return 0;
-}
-
-static int rt2800usb_wait_bbp_rf_ready(struct rt2x00_dev *rt2x00dev)
-{
-	unsigned int i;
-	u32 reg;
-
-	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt2800_register_read(rt2x00dev, MAC_STATUS_CFG, &reg);
-		if (!rt2x00_get_field32(reg, MAC_STATUS_CFG_BBP_RF_BUSY))
-			return 0;
-
-		udelay(REGISTER_BUSY_DELAY);
-	}
-
-	ERROR(rt2x00dev, "BBP/RF register access failed, aborting.\n");
-	return -EACCES;
-}
-
-static int rt2800usb_wait_bbp_ready(struct rt2x00_dev *rt2x00dev)
-{
-	unsigned int i;
-	u8 value;
-
-	/*
-	 * BBP was enabled after firmware was loaded,
-	 * but we need to reactivate it now.
-	 */
-	rt2800_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
-	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
-	msleep(1);
-
-	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt2800_bbp_read(rt2x00dev, 0, &value);
-		if ((value != 0xff) && (value != 0x00))
-			return 0;
-		udelay(REGISTER_BUSY_DELAY);
-	}
-
-	ERROR(rt2x00dev, "BBP register access failed, aborting.\n");
-	return -EACCES;
-}
-
-static int rt2800usb_init_bbp(struct rt2x00_dev *rt2x00dev)
-{
-	unsigned int i;
-	u16 eeprom;
-	u8 reg_id;
-	u8 value;
-
-	if (unlikely(rt2800usb_wait_bbp_rf_ready(rt2x00dev) ||
-		     rt2800usb_wait_bbp_ready(rt2x00dev)))
-		return -EACCES;
-
-	rt2800_bbp_write(rt2x00dev, 65, 0x2c);
-	rt2800_bbp_write(rt2x00dev, 66, 0x38);
-	rt2800_bbp_write(rt2x00dev, 69, 0x12);
-	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
-	rt2800_bbp_write(rt2x00dev, 73, 0x10);
-	rt2800_bbp_write(rt2x00dev, 81, 0x37);
-	rt2800_bbp_write(rt2x00dev, 82, 0x62);
-	rt2800_bbp_write(rt2x00dev, 83, 0x6a);
-	rt2800_bbp_write(rt2x00dev, 84, 0x99);
-	rt2800_bbp_write(rt2x00dev, 86, 0x00);
-	rt2800_bbp_write(rt2x00dev, 91, 0x04);
-	rt2800_bbp_write(rt2x00dev, 92, 0x00);
-	rt2800_bbp_write(rt2x00dev, 103, 0x00);
-	rt2800_bbp_write(rt2x00dev, 105, 0x05);
-
-	if (rt2x00_rev(&rt2x00dev->chip) == RT2860C_VERSION) {
-		rt2800_bbp_write(rt2x00dev, 69, 0x16);
-		rt2800_bbp_write(rt2x00dev, 73, 0x12);
-	}
-
-	if (rt2x00_rev(&rt2x00dev->chip) > RT2860D_VERSION)
-		rt2800_bbp_write(rt2x00dev, 84, 0x19);
-
-	if (rt2x00_intf_is_usb(rt2x00dev) &&
-	    rt2x00_rev(&rt2x00dev->chip) == RT3070_VERSION) {
-		rt2800_bbp_write(rt2x00dev, 70, 0x0a);
-		rt2800_bbp_write(rt2x00dev, 84, 0x99);
-		rt2800_bbp_write(rt2x00dev, 105, 0x05);
-	}
-
-	for (i = 0; i < EEPROM_BBP_SIZE; i++) {
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_BBP_START + i, &eeprom);
-
-		if (eeprom != 0xffff && eeprom != 0x0000) {
-			reg_id = rt2x00_get_field16(eeprom, EEPROM_BBP_REG_ID);
-			value = rt2x00_get_field16(eeprom, EEPROM_BBP_VALUE);
-			rt2800_bbp_write(rt2x00dev, reg_id, value);
-		}
-	}
-
-	return 0;
-}
-
-static u8 rt2800usb_init_rx_filter(struct rt2x00_dev *rt2x00dev,
-				   bool bw40, u8 rfcsr24, u8 filter_target)
-{
-	unsigned int i;
-	u8 bbp;
-	u8 rfcsr;
-	u8 passband;
-	u8 stopband;
-	u8 overtuned = 0;
-
-	rt2800_rfcsr_write(rt2x00dev, 24, rfcsr24);
-
-	rt2800_bbp_read(rt2x00dev, 4, &bbp);
-	rt2x00_set_field8(&bbp, BBP4_BANDWIDTH, 2 * bw40);
-	rt2800_bbp_write(rt2x00dev, 4, bbp);
-
-	rt2800_rfcsr_read(rt2x00dev, 22, &rfcsr);
-	rt2x00_set_field8(&rfcsr, RFCSR22_BASEBAND_LOOPBACK, 1);
-	rt2800_rfcsr_write(rt2x00dev, 22, rfcsr);
-
-	/*
-	 * Set power & frequency of passband test tone
-	 */
-	rt2800_bbp_write(rt2x00dev, 24, 0);
-
-	for (i = 0; i < 100; i++) {
-		rt2800_bbp_write(rt2x00dev, 25, 0x90);
-		msleep(1);
-
-		rt2800_bbp_read(rt2x00dev, 55, &passband);
-		if (passband)
-			break;
-	}
-
-	/*
-	 * Set power & frequency of stopband test tone
-	 */
-	rt2800_bbp_write(rt2x00dev, 24, 0x06);
-
-	for (i = 0; i < 100; i++) {
-		rt2800_bbp_write(rt2x00dev, 25, 0x90);
-		msleep(1);
-
-		rt2800_bbp_read(rt2x00dev, 55, &stopband);
-
-		if ((passband - stopband) <= filter_target) {
-			rfcsr24++;
-			overtuned += ((passband - stopband) == filter_target);
-		} else
-			break;
-
-		rt2800_rfcsr_write(rt2x00dev, 24, rfcsr24);
-	}
-
-	rfcsr24 -= !!overtuned;
-
-	rt2800_rfcsr_write(rt2x00dev, 24, rfcsr24);
-	return rfcsr24;
-}
-
-static int rt2800usb_init_rfcsr(struct rt2x00_dev *rt2x00dev)
-{
-	u8 rfcsr;
-	u8 bbp;
-
-	if (rt2x00_intf_is_usb(rt2x00dev) &&
-	    rt2x00_rev(&rt2x00dev->chip) != RT3070_VERSION)
-		return 0;
-
-	/*
-	 * Init RF calibration.
-	 */
-	rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
-	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
-	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
-	msleep(1);
-	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 0);
-	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
-
-	if (rt2x00_intf_is_usb(rt2x00dev)) {
-		rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
-		rt2800_rfcsr_write(rt2x00dev, 5, 0x03);
-		rt2800_rfcsr_write(rt2x00dev, 6, 0x02);
-		rt2800_rfcsr_write(rt2x00dev, 7, 0x70);
-		rt2800_rfcsr_write(rt2x00dev, 9, 0x0f);
-		rt2800_rfcsr_write(rt2x00dev, 10, 0x71);
-		rt2800_rfcsr_write(rt2x00dev, 11, 0x21);
-		rt2800_rfcsr_write(rt2x00dev, 12, 0x7b);
-		rt2800_rfcsr_write(rt2x00dev, 14, 0x90);
-		rt2800_rfcsr_write(rt2x00dev, 15, 0x58);
-		rt2800_rfcsr_write(rt2x00dev, 16, 0xb3);
-		rt2800_rfcsr_write(rt2x00dev, 17, 0x92);
-		rt2800_rfcsr_write(rt2x00dev, 18, 0x2c);
-		rt2800_rfcsr_write(rt2x00dev, 19, 0x02);
-		rt2800_rfcsr_write(rt2x00dev, 20, 0xba);
-		rt2800_rfcsr_write(rt2x00dev, 21, 0xdb);
-		rt2800_rfcsr_write(rt2x00dev, 24, 0x16);
-		rt2800_rfcsr_write(rt2x00dev, 25, 0x01);
-		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
-		rt2800_rfcsr_write(rt2x00dev, 29, 0x1f);
-	}
-
-	/*
-	 * Set RX Filter calibration for 20MHz and 40MHz
-	 */
-	rt2x00dev->calibration[0] =
-	    rt2800usb_init_rx_filter(rt2x00dev, false, 0x07, 0x16);
-	rt2x00dev->calibration[1] =
-	    rt2800usb_init_rx_filter(rt2x00dev, true, 0x27, 0x19);
-
-	/*
-	 * Set back to initial state
-	 */
-	rt2800_bbp_write(rt2x00dev, 24, 0);
-
-	rt2800_rfcsr_read(rt2x00dev, 22, &rfcsr);
-	rt2x00_set_field8(&rfcsr, RFCSR22_BASEBAND_LOOPBACK, 0);
-	rt2800_rfcsr_write(rt2x00dev, 22, rfcsr);
-
-	/*
-	 * set BBP back to BW20
-	 */
-	rt2800_bbp_read(rt2x00dev, 4, &bbp);
-	rt2x00_set_field8(&bbp, BBP4_BANDWIDTH, 0);
-	rt2800_bbp_write(rt2x00dev, 4, bbp);
-
-	return 0;
-}
-
-/*
  * Device state switch handlers.
  */
 static void rt2800usb_toggle_rx(struct rt2x00_dev *rt2x00dev,
@@ -806,9 +271,9 @@ static int rt2800usb_enable_radio(struct
 	 * Initialize all registers.
 	 */
 	if (unlikely(rt2800usb_wait_wpdma_ready(rt2x00dev) ||
-		     rt2800usb_init_registers(rt2x00dev) ||
-		     rt2800usb_init_bbp(rt2x00dev) ||
-		     rt2800usb_init_rfcsr(rt2x00dev)))
+		     rt2800_init_registers(rt2x00dev) ||
+		     rt2800_init_bbp(rt2x00dev) ||
+		     rt2800_init_rfcsr(rt2x00dev)))
 		return -EIO;
 
 	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
