Return-Path: <linux-kernel-owner+w=401wt.eu-S1759857AbZDHITf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759857AbZDHITf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762817AbZDHIOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:14:31 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:47899 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761794AbZDHIOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:14:19 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 11/11] w35und: make led lookup tables static
Date: Wed,  8 Apr 2009 11:14:06 +0300
Message-Id: <1239178446-12893-11-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239178446-12893-1-git-send-email-penberg@cs.helsinki.fi>
References: <1239178446-12893-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

No need to keep read-only data on the stack.

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/wbusb.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index cffd732..dc7cc08 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -171,14 +171,21 @@ static const struct ieee80211_ops wbsoft_ops = {
 	.get_tsf		= wbsoft_get_tsf,
 };
 
+static u8 LED_GRAY[20] = {
+	0, 3, 4, 6, 8, 10, 11, 12, 13, 14, 15, 14, 13, 12, 11, 10, 8, 6, 4, 2
+};
+
+static u8 LED_GRAY2[30] = {
+	7, 8, 9, 10, 11, 12, 13, 14, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, 15, 14, 13, 12, 11, 10, 9, 8
+};
+
 static void hal_led_control(unsigned long data)
 {
 	struct wbsoft_priv *adapter = (struct wbsoft_priv *)data;
 	struct hw_data *pHwData = &adapter->sHwData;
 	struct wb35_reg *reg = &pHwData->reg;
 	u32 LEDSet = (pHwData->SoftwareSet & HAL_LED_SET_MASK) >> HAL_LED_SET_SHIFT;
-	u8 LEDgray[20] = { 0, 3, 4, 6, 8, 10, 11, 12, 13, 14, 15, 14, 13, 12, 11, 10, 8, 6, 4, 2 };
-	u8 LEDgray2[30] = { 7, 8, 9, 10, 11, 12, 13, 14, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 15, 14, 13, 12, 11, 10, 9, 8 };
 	u32 TimeInterval = 500, ltmp, ltmp2;
 	ltmp = 0;
 
@@ -287,10 +294,10 @@ static void hal_led_control(unsigned long data)
 					// 20060901 Gray blinking if in disconnect state and not scanning
 					ltmp = reg->U1BC_LEDConfigure;
 					reg->U1BC_LEDConfigure &= ~0x1f;
-					if (LEDgray2[(pHwData->LED_Blinking % 30)]) {
+					if (LED_GRAY2[(pHwData->LED_Blinking % 30)]) {
 						reg->U1BC_LEDConfigure |= 0x10;
 						reg->U1BC_LEDConfigure |=
-						    LEDgray2[(pHwData->LED_Blinking % 30)];
+						    LED_GRAY2[(pHwData->LED_Blinking % 30)];
 					}
 					pHwData->LED_Blinking++;
 					if (reg->U1BC_LEDConfigure != ltmp)
@@ -376,7 +383,7 @@ static void hal_led_control(unsigned long data)
 				reg->U1BC_LEDConfigure &= ~0x0f;
 				reg->U1BC_LEDConfigure |= 0x10;
 				reg->U1BC_LEDConfigure |=
-				    LEDgray[(pHwData->LED_Blinking - 1) % 20];
+				    LED_GRAY[(pHwData->LED_Blinking - 1) % 20];
 				Wb35Reg_Write(pHwData, 0x03bc,
 					      reg->U1BC_LEDConfigure);
 
-- 
1.5.6.3

