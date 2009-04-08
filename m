Return-Path: <linux-kernel-owner+w=401wt.eu-S1763534AbZDHIRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763534AbZDHIRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762889AbZDHIOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:14:25 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:47633 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762071AbZDHIOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:14:10 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 04/11] w35und: simplify hal_init_hardware() error handling
Date: Wed,  8 Apr 2009 11:13:59 +0300
Message-Id: <1239178446-12893-4-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239178446-12893-1-git-send-email-penberg@cs.helsinki.fi>
References: <1239178446-12893-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Use gotos to simplify the deep if-statement nesting in
hal_init_hardware().

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/wbusb.c |   66 ++++++++++++++++++++------------------
 1 files changed, 35 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 1943ff0..65d443a 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -487,38 +487,42 @@ static int hal_init_hardware(struct ieee80211_hw *hw)
 	pHwData->FragmentThreshold = DEFAULT_FRAGMENT_THRESHOLD; // Setting default fragment threshold
 
 	pHwData->InitialResource = 1;
-	if( Wb35Reg_initial(pHwData)) {
-		pHwData->InitialResource = 2;
-		if (Wb35Tx_initial(pHwData)) {
-			pHwData->InitialResource = 3;
-			if (Wb35Rx_initial(pHwData)) {
-				pHwData->InitialResource = 4;
-				init_timer(&pHwData->LEDTimer);
-				pHwData->LEDTimer.function = hal_led_control;
-				pHwData->LEDTimer.data = (unsigned long) priv;
-				pHwData->LEDTimer.expires = jiffies + msecs_to_jiffies(1000);
-				add_timer(&pHwData->LEDTimer);
-
-				//
-				// For restrict to vendor's hardware
-				//
-				SoftwareSet = hal_software_set( pHwData );
-
-				#ifdef Vendor2
-				// Try to make sure the EEPROM contain
-				SoftwareSet >>= 8;
-				if( SoftwareSet != 0x82 )
-					return false;
-				#endif
-
-				Wb35Rx_start(hw);
-				Wb35Tx_EP2VM_start(priv);
-
-				return 0;
-			}
-		}
-	}
+	if (!Wb35Reg_initial(pHwData))
+		goto error;
+
+	pHwData->InitialResource = 2;
+	if (!Wb35Tx_initial(pHwData))
+		goto error;
+
+	pHwData->InitialResource = 3;
+	if (!Wb35Rx_initial(pHwData))
+		goto error;
+
+	pHwData->InitialResource = 4;
+	init_timer(&pHwData->LEDTimer);
+	pHwData->LEDTimer.function = hal_led_control;
+	pHwData->LEDTimer.data = (unsigned long) priv;
+	pHwData->LEDTimer.expires = jiffies + msecs_to_jiffies(1000);
+	add_timer(&pHwData->LEDTimer);
+
+	//
+	// For restrict to vendor's hardware
+	//
+	SoftwareSet = hal_software_set( pHwData );
+
+	#ifdef Vendor2
+	// Try to make sure the EEPROM contain
+	SoftwareSet >>= 8;
+	if( SoftwareSet != 0x82 )
+		return false;
+	#endif
 
+	Wb35Rx_start(hw);
+	Wb35Tx_EP2VM_start(priv);
+
+	return 0;
+
+error:
 	pHwData->SurpriseRemove = 1;
 	return -EINVAL;
 }
-- 
1.5.6.3

