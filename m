Return-Path: <linux-kernel-owner+w=401wt.eu-S1763666AbZDHISc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763666AbZDHISc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762987AbZDHIO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:14:29 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:47893 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762590AbZDHIOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:14:19 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 08/11] w35und: inline hal_set_phy_type() to wb35_hw_init()
Date: Wed,  8 Apr 2009 11:14:03 +0300
Message-Id: <1239178446-12893-8-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239178446-12893-1-git-send-email-penberg@cs.helsinki.fi>
References: <1239178446-12893-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

The hal_set_phy_type() is called in wb35_hw_init() only so inline the
function there. Also remove a redundant assignment of ->phy_type to
RF_WB_242_1.

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/wbhal.c   |    5 -----
 drivers/staging/winbond/wbhal_f.h |    1 -
 drivers/staging/winbond/wbusb.c   |    8 +++-----
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/winbond/wbhal.c b/drivers/staging/winbond/wbhal.c
index 6f1964c..14253f0 100644
--- a/drivers/staging/winbond/wbhal.c
+++ b/drivers/staging/winbond/wbhal.c
@@ -145,11 +145,6 @@ unsigned char hal_idle(struct hw_data * pHwData)
 
 	return true;
 }
-//---------------------------------------------------------------------------------------------------
-void hal_set_phy_type(  struct hw_data * pHwData,  u8 PhyType )
-{
-	pHwData->phy_type = PhyType;
-}
 
 void hal_set_radio_mode( struct hw_data * pHwData,  unsigned char radio_off)
 {
diff --git a/drivers/staging/winbond/wbhal_f.h b/drivers/staging/winbond/wbhal_f.h
index d51709f..bdea22f 100644
--- a/drivers/staging/winbond/wbhal_f.h
+++ b/drivers/staging/winbond/wbhal_f.h
@@ -42,7 +42,6 @@ void hal_set_accept_multicast(  struct hw_data * pHwData,  u8 enable );
 void hal_set_accept_beacon(  struct hw_data * pHwData,  u8 enable );
 void hal_stop(  struct hw_data * pHwData );
 void hal_start_tx0(  struct hw_data * pHwData );
-void hal_set_phy_type(  struct hw_data * pHwData,  u8 PhyType );
 #define hal_get_cwmin( _A ) ( (_A)->cwmin )
 void hal_set_cwmax(  struct hw_data * pHwData,  u16 cwin_max );
 #define hal_get_cwmax( _A ) ( (_A)->cwmax )
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index fad3b99..742bf7d 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -504,7 +504,7 @@ error_reg_destroy:
 static int wb35_hw_init(struct ieee80211_hw *hw)
 {
 	struct wbsoft_priv *priv = hw->priv;
-	struct hw_data *	pHwData;
+	struct hw_data *	pHwData = &priv->sHwData;
 	u8		*pMacAddr;
 	u8		*pMacAddr2;
 	u8		EEPROM_region;
@@ -516,18 +516,16 @@ static int wb35_hw_init(struct ieee80211_hw *hw)
 	priv->sLocalPara.bMacOperationMode = MODE_802_11_BG;
 	priv->Mds.TxRTSThreshold = DEFAULT_RTSThreshold;
 	priv->Mds.TxFragmentThreshold = DEFAULT_FRAGMENT_THRESHOLD;
-	hal_set_phy_type( &priv->sHwData, RF_WB_242_1 );
 	priv->sLocalPara.MTUsize = MAX_ETHERNET_PACKET_SIZE;
 	priv->sLocalPara.bPreambleMode = AUTO_MODE;
 	priv->sLocalPara.RadioOffStatus.boSwRadioOff = false;
-	pHwData = &priv->sHwData;
-	hal_set_phy_type( pHwData, RF_DECIDE_BY_INF );
+
+	pHwData->phy_type = RF_DECIDE_BY_INF;
 
 	priv->sLocalPara.bWepKeyError= false;
 	priv->sLocalPara.bToSelfPacketReceived = false;
 	priv->sLocalPara.WepKeyDetectTimerCount= 2 * 100; /* 2 seconds */
 
-	pHwData = &priv->sHwData;
 	err = hal_init_hardware(hw);
 	if (err)
 		goto error;
-- 
1.5.6.3

