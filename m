Return-Path: <linux-kernel-owner+w=401wt.eu-S932285AbZKDRe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285AbZKDRe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932272AbZKDRez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:34:55 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:5665 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244AbZKDRev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:34:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=rA3UyKQDWk8m08bpghC+DA0Cu+jSws9oTyvQcfzPtBLtsrXu3nKJ1i/LwmpPumB1qg
         oS2+RS2Ah8q1uM6yJRUJvxUXoiBxmhJH2aIKYZX1qmVLC2KV/DNrmrXRGJFiCRYYfO0d
         KChE9duH0QgN7q+u8yMQyvfdTWmq+bN7EInmY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:34:32 +0100
Message-Id: <20091104173432.28463.51210.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 21/41] rt2800usb: add rt2800_mcu_request() wrapper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800usb: add rt2800_mcu_request() wrapper

Part of preparations for later code unification.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800usb.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -259,6 +259,13 @@ static void rt2800usb_mcu_request(struct
 	mutex_unlock(&rt2x00dev->csr_mutex);
 }
 
+static inline void rt2800_mcu_request(struct rt2x00_dev *rt2x00dev,
+				      const u8 command, const u8 token,
+				      const u8 arg0, const u8 arg1)
+{
+	rt2800usb_mcu_request(rt2x00dev, command, token, arg0, arg1);
+}
+
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 static const struct rt2x00debug rt2800usb_rt2x00debug = {
 	.owner	= THIS_MODULE,
@@ -319,10 +326,10 @@ static void rt2800usb_brightness_set(str
 				   EEPROM_FREQ_LED_MODE);
 
 	if (led->type == LED_TYPE_RADIO) {
-		rt2800usb_mcu_request(led->rt2x00dev, MCU_LED, 0xff, ledmode,
+		rt2800_mcu_request(led->rt2x00dev, MCU_LED, 0xff, ledmode,
 				      enabled ? 0x20 : 0);
 	} else if (led->type == LED_TYPE_ASSOC) {
-		rt2800usb_mcu_request(led->rt2x00dev, MCU_LED, 0xff, ledmode,
+		rt2800_mcu_request(led->rt2x00dev, MCU_LED, 0xff, ledmode,
 				      enabled ? (bg_mode ? 0x60 : 0xa0) : 0x20);
 	} else if (led->type == LED_TYPE_QUALITY) {
 		/*
@@ -333,7 +340,7 @@ static void rt2800usb_brightness_set(str
 		 * work with bitshifting:
 		 *	(1 << level) - 1
 		 */
-		rt2800usb_mcu_request(led->rt2x00dev, MCU_LED_STRENGTH, 0xff,
+		rt2800_mcu_request(led->rt2x00dev, MCU_LED_STRENGTH, 0xff,
 				      (1 << brightness / (LED_FULL / 6)) - 1,
 				      polarity);
 	}
@@ -1243,13 +1250,13 @@ static int rt2800usb_load_firmware(struc
 	/*
 	 * Send signal to firmware during boot time.
 	 */
-	rt2800usb_mcu_request(rt2x00dev, MCU_BOOT_SIGNAL, 0xff, 0, 0);
+	rt2800_mcu_request(rt2x00dev, MCU_BOOT_SIGNAL, 0xff, 0, 0);
 
 	if ((chipset == 0x3070) ||
 	    (chipset == 0x3071) ||
 	    (chipset == 0x3572)) {
 		udelay(200);
-		rt2800usb_mcu_request(rt2x00dev, MCU_CURRENT, 0, 0, 0);
+		rt2800_mcu_request(rt2x00dev, MCU_CURRENT, 0, 0, 0);
 		udelay(10);
 	}
 
@@ -1885,15 +1892,15 @@ static int rt2800usb_enable_radio(struct
 	 * Initialize LED control
 	 */
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED1, &word);
-	rt2800usb_mcu_request(rt2x00dev, MCU_LED_1, 0xff,
+	rt2800_mcu_request(rt2x00dev, MCU_LED_1, 0xff,
 			      word & 0xff, (word >> 8) & 0xff);
 
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED2, &word);
-	rt2800usb_mcu_request(rt2x00dev, MCU_LED_2, 0xff,
+	rt2800_mcu_request(rt2x00dev, MCU_LED_2, 0xff,
 			      word & 0xff, (word >> 8) & 0xff);
 
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED3, &word);
-	rt2800usb_mcu_request(rt2x00dev, MCU_LED_3, 0xff,
+	rt2800_mcu_request(rt2x00dev, MCU_LED_3, 0xff,
 			      word & 0xff, (word >> 8) & 0xff);
 
 	return 0;
@@ -1922,9 +1929,9 @@ static int rt2800usb_set_state(struct rt
 			       enum dev_state state)
 {
 	if (state == STATE_AWAKE)
-		rt2800usb_mcu_request(rt2x00dev, MCU_WAKEUP, 0xff, 0, 0);
+		rt2800_mcu_request(rt2x00dev, MCU_WAKEUP, 0xff, 0, 0);
 	else
-		rt2800usb_mcu_request(rt2x00dev, MCU_SLEEP, 0xff, 0, 2);
+		rt2800_mcu_request(rt2x00dev, MCU_SLEEP, 0xff, 0, 2);
 
 	return 0;
 }
