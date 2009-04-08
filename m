Return-Path: <linux-kernel-owner+w=401wt.eu-S1763628AbZDHISI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763628AbZDHISI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760602AbZDHIO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:14:28 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:47890 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762514AbZDHIOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:14:18 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 06/11] w35und: simplify hal_init_hardware() and hal_halt()
Date: Wed,  8 Apr 2009 11:14:01 +0300
Message-Id: <1239178446-12893-6-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239178446-12893-1-git-send-email-penberg@cs.helsinki.fi>
References: <1239178446-12893-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Now that hal_halt() is called from wb35_hw_halt() only where
->InitialResource is always set to 4, we can simplify
hal_init_hardware() and hal_halt().

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/wbhal_s.h |    1 -
 drivers/staging/winbond/wbusb.c   |   29 +++++++++++------------------
 2 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/winbond/wbhal_s.h b/drivers/staging/winbond/wbhal_s.h
index acfebf0..16d0e6f 100644
--- a/drivers/staging/winbond/wbhal_s.h
+++ b/drivers/staging/winbond/wbhal_s.h
@@ -401,7 +401,6 @@ struct hw_data {
 
 	// For surprise remove
 	u32	SurpriseRemove; // 0: Normal 1: Surprise remove
-	u8	InitialResource;
 	u8	IsKeyPreSet;
 	u8	CalOneTime; // 20060630.1
 
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index b1ef30a..5dc1ba6 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -178,19 +178,6 @@ static const struct ieee80211_ops wbsoft_ops = {
 // conf_tx: hal_set_cwmin()/hal_set_cwmax;
 };
 
-static void hal_halt(struct hw_data *pHwData, void *ppa_data)
-{
-	switch( pHwData->InitialResource )
-	{
-		case 4:
-		case 3: del_timer_sync(&pHwData->LEDTimer);
-			msleep(100); // Wait for Timer DPC exit 940623.2
-			Wb35Rx_destroy( pHwData ); // Release the Rx
-		case 2: Wb35Tx_destroy( pHwData ); // Release the Tx
-		case 1: Wb35Reg_destroy( pHwData ); // Release the Wb35 Regisster resources
-	}
-}
-
 static void hal_led_control(unsigned long data)
 {
 	struct wbsoft_priv *adapter = (struct wbsoft_priv *) data;
@@ -486,19 +473,15 @@ static int hal_init_hardware(struct ieee80211_hw *hw)
 	pHwData->MaxReceiveLifeTime = DEFAULT_MSDU_LIFE_TIME; // Setting Rx maximum MSDU life time
 	pHwData->FragmentThreshold = DEFAULT_FRAGMENT_THRESHOLD; // Setting default fragment threshold
 
-	pHwData->InitialResource = 1;
 	if (!Wb35Reg_initial(pHwData))
 		goto error_reg_destroy;
 
-	pHwData->InitialResource = 2;
 	if (!Wb35Tx_initial(pHwData))
 		goto error_tx_destroy;
 
-	pHwData->InitialResource = 3;
 	if (!Wb35Rx_initial(pHwData))
 		goto error_rx_destroy;
 
-	pHwData->InitialResource = 4;
 	init_timer(&pHwData->LEDTimer);
 	pHwData->LEDTimer.function = hal_led_control;
 	pHwData->LEDTimer.data = (unsigned long) priv;
@@ -714,6 +697,16 @@ error:
 	return err;
 }
 
+static void hal_halt(struct hw_data *pHwData)
+{
+	del_timer_sync(&pHwData->LEDTimer);
+	/* XXX: Wait for Timer DPC exit. */
+	msleep(100);
+	Wb35Rx_destroy(pHwData);
+	Wb35Tx_destroy(pHwData);
+	Wb35Reg_destroy(pHwData);
+}
+
 static void wb35_hw_halt(struct wbsoft_priv *adapter)
 {
 	Mds_Destroy( adapter );
@@ -726,7 +719,7 @@ static void wb35_hw_halt(struct wbsoft_priv *adapter)
 	msleep(100);// Waiting Irp completed
 
 	// Halt the HAL
-	hal_halt(&adapter->sHwData, NULL);
+	hal_halt(&adapter->sHwData);
 }
 
 
-- 
1.5.6.3

