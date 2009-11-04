Return-Path: <linux-kernel-owner+w=401wt.eu-S932364AbZKDRlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364AbZKDRlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932289AbZKDRfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:35:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:41096 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275AbZKDRe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:34:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=kjZ/rSrTPVwywyTq425NyT3W5oweFS7ak8z3bhNDeOFCo7a3NSRn9KJuiaNsl/e9HJ
         BUue4EKU1MLm/vwLCJgBJtgjJad5DTuPAZhGN/ZpYBR86LQXmUpvjsdNJ4xcu+MsX+gw
         86N/THnglyThWC79ZdMv+1z9+nF9wdkpQgdUM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:34:39 +0100
Message-Id: <20091104173439.28463.20951.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 22/41] rt2800pci: add rt2800_mcu_request() wrapper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800pci: add rt2800_mcu_request() wrapper

Part of preparations for later code unification.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800pci.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -276,6 +276,13 @@ static void rt2800pci_mcu_request(struct
 	mutex_unlock(&rt2x00dev->csr_mutex);
 }
 
+static inline void rt2800_mcu_request(struct rt2x00_dev *rt2x00dev,
+				      const u8 command, const u8 token,
+				      const u8 arg0, const u8 arg1)
+{
+	rt2800pci_mcu_request(rt2x00dev, command, token, arg0, arg1);
+}
+
 static void rt2800pci_mcu_status(struct rt2x00_dev *rt2x00dev, const u8 token)
 {
 	unsigned int i;
@@ -467,10 +474,10 @@ static void rt2800pci_brightness_set(str
 				   EEPROM_FREQ_LED_MODE);
 
 	if (led->type == LED_TYPE_RADIO) {
-		rt2800pci_mcu_request(led->rt2x00dev, MCU_LED, 0xff, ledmode,
+		rt2800_mcu_request(led->rt2x00dev, MCU_LED, 0xff, ledmode,
 				      enabled ? 0x20 : 0);
 	} else if (led->type == LED_TYPE_ASSOC) {
-		rt2800pci_mcu_request(led->rt2x00dev, MCU_LED, 0xff, ledmode,
+		rt2800_mcu_request(led->rt2x00dev, MCU_LED, 0xff, ledmode,
 				      enabled ? (bg_mode ? 0x60 : 0xa0) : 0x20);
 	} else if (led->type == LED_TYPE_QUALITY) {
 		/*
@@ -481,7 +488,7 @@ static void rt2800pci_brightness_set(str
 		 * work with bitshifting:
 		 *	(1 << level) - 1
 		 */
-		rt2800pci_mcu_request(led->rt2x00dev, MCU_LED_STRENGTH, 0xff,
+		rt2800_mcu_request(led->rt2x00dev, MCU_LED_STRENGTH, 0xff,
 				      (1 << brightness / (LED_FULL / 6)) - 1,
 				      polarity);
 	}
@@ -2037,7 +2044,7 @@ static int rt2800pci_enable_radio(struct
 	/*
 	 * Send signal to firmware during boot time.
 	 */
-	rt2800pci_mcu_request(rt2x00dev, MCU_BOOT_SIGNAL, 0xff, 0, 0);
+	rt2800_mcu_request(rt2x00dev, MCU_BOOT_SIGNAL, 0xff, 0, 0);
 
 	/*
 	 * Enable RX.
@@ -2063,15 +2070,15 @@ static int rt2800pci_enable_radio(struct
 	 * Initialize LED control
 	 */
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED1, &word);
-	rt2800pci_mcu_request(rt2x00dev, MCU_LED_1, 0xff,
+	rt2800_mcu_request(rt2x00dev, MCU_LED_1, 0xff,
 			      word & 0xff, (word >> 8) & 0xff);
 
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED2, &word);
-	rt2800pci_mcu_request(rt2x00dev, MCU_LED_2, 0xff,
+	rt2800_mcu_request(rt2x00dev, MCU_LED_2, 0xff,
 			      word & 0xff, (word >> 8) & 0xff);
 
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED3, &word);
-	rt2800pci_mcu_request(rt2x00dev, MCU_LED_3, 0xff,
+	rt2800_mcu_request(rt2x00dev, MCU_LED_3, 0xff,
 			      word & 0xff, (word >> 8) & 0xff);
 
 	return 0;
@@ -2120,10 +2127,10 @@ static int rt2800pci_set_state(struct rt
 	 * if the device is booting and wasn't asleep it will return
 	 * failure when attempting to wakeup.
 	 */
-	rt2800pci_mcu_request(rt2x00dev, MCU_SLEEP, 0xff, 0, 2);
+	rt2800_mcu_request(rt2x00dev, MCU_SLEEP, 0xff, 0, 2);
 
 	if (state == STATE_AWAKE) {
-		rt2800pci_mcu_request(rt2x00dev, MCU_WAKEUP, TOKEN_WAKUP, 0, 0);
+		rt2800_mcu_request(rt2x00dev, MCU_WAKEUP, TOKEN_WAKUP, 0, 0);
 		rt2800pci_mcu_status(rt2x00dev, TOKEN_WAKUP);
 	}
 
