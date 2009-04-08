Return-Path: <linux-kernel-owner+w=401wt.eu-S1763132AbZDHIPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763132AbZDHIPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762331AbZDHIOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:14:17 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:47590 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761156AbZDHIOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:14:09 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 01/11] w35und: replace switch error handling with gotos in wb35_hw_init()
Date: Wed,  8 Apr 2009 11:13:56 +0300
Message-Id: <1239178446-12893-1-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

This patch replaces the switch-based error handling in wb35_hw_init()
with regular gotos.

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/wbusb.c |   36 ++++++++++--------------------------
 1 files changed, 10 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 12934a3..1c6e0c4 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -178,15 +178,15 @@ static const struct ieee80211_ops wbsoft_ops = {
 // conf_tx: hal_set_cwmin()/hal_set_cwmax;
 };
 
-static unsigned char wb35_hw_init(struct ieee80211_hw *hw)
+static int wb35_hw_init(struct ieee80211_hw *hw)
 {
 	struct wbsoft_priv *priv = hw->priv;
 	struct hw_data *	pHwData;
 	u8		*pMacAddr;
 	u8		*pMacAddr2;
-	u32		InitStep = 0;
 	u8		EEPROM_region;
 	u8		HwRadioOff;
+	int err;
 
 	//
 	// Setting default value for Linux
@@ -209,10 +209,11 @@ static unsigned char wb35_hw_init(struct ieee80211_hw *hw)
 	priv->sLocalPara.WepKeyDetectTimerCount= 2 * 100; /// 2 seconds
 
 	// Initial USB hal
-	InitStep = 1;
 	pHwData = &priv->sHwData;
-	if (!hal_init_hardware(hw))
+	if (!hal_init_hardware(hw)) {
+		err = -EINVAL;
 		goto error;
+	}
 
 	EEPROM_region = hal_get_region_from_EEPROM( pHwData );
 	if (EEPROM_region != REGION_AUTO)
@@ -229,21 +230,12 @@ static unsigned char wb35_hw_init(struct ieee80211_hw *hw)
 	if (hal_software_set(pHwData) & 0x00000001)
 		priv->sLocalPara.boAntennaDiversity = true;
 
-	//
-	// For TS module
-	//
-	InitStep = 2;
-
 	// For MDS module
-	InitStep = 3;
 	Mds_initial(priv);
 
 	//=======================================
 	// Initialize the SME, SCAN, MLME, ROAM
 	//=======================================
-	InitStep = 4;
-	InitStep = 5;
-	InitStep = 6;
 
 	// If no user-defined address in the registry, use the addresss "burned" on the NIC instead.
 	pMacAddr = priv->sLocalPara.ThisMacAddress;
@@ -277,19 +269,12 @@ static unsigned char wb35_hw_init(struct ieee80211_hw *hw)
 	hal_driver_init_OK(pHwData) = 1; // Notify hal that the driver is ready now.
 	//set a tx power for reference.....
 //	sme_set_tx_power_level(priv, 12);	FIXME?
-	return true;
+	return 0;
 
 error:
-	switch (InitStep) {
-	case 5:
-	case 4:
-	case 3: Mds_Destroy( priv );
-	case 2:
-	case 1: hal_halt( pHwData, NULL );
-	case 0: break;
-	}
+	hal_halt(pHwData, NULL);
 
-	return false;
+	return err;
 }
 
 static int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id_table)
@@ -341,10 +326,9 @@ static int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id
 		pWbUsb->IsUsb20 = 1;
 	}
 
-	if (!wb35_hw_init(dev)) {
-		err = -EINVAL;
+	err = wb35_hw_init(dev);
+	if (err)
 		goto error_free_hw;
-	}
 
 	SET_IEEE80211_DEV(dev, &udev->dev);
 	{
-- 
1.5.6.3

