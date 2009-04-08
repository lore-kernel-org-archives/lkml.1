Return-Path: <linux-kernel-owner+w=401wt.eu-S1763552AbZDHIxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763552AbZDHIxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762499AbZDHIvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:51:42 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:60960 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762169AbZDHIv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:51:27 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 2/4] w35und: merge wbhal.c to wbusb.c
Date: Wed,  8 Apr 2009 11:51:20 +0300
Message-Id: <1239180682-22860-2-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239180682-22860-1-git-send-email-penberg@cs.helsinki.fi>
References: <1239180682-22860-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

This patch moves all the functions in wbhal.c that are used only in
wbusb.c to the latter file.

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/wbhal.c   |  206 -------------------------------------
 drivers/staging/winbond/wbhal_f.h |   13 ---
 drivers/staging/winbond/wbusb.c   |  202 ++++++++++++++++++++++++++++++++++++
 3 files changed, 202 insertions(+), 219 deletions(-)

diff --git a/drivers/staging/winbond/wbhal.c b/drivers/staging/winbond/wbhal.c
index e40fdca..01626a1 100644
--- a/drivers/staging/winbond/wbhal.c
+++ b/drivers/staging/winbond/wbhal.c
@@ -2,212 +2,6 @@
 #include "wbhal_f.h"
 #include "wblinux_f.h"
 
-void hal_set_ethernet_address(struct hw_data *pHwData, u8 * current_address)
-{
-	u32 ltmp[2];
-
-	if (pHwData->SurpriseRemove)
-		return;
-
-	memcpy(pHwData->CurrentMacAddress, current_address, ETH_ALEN);
-
-	ltmp[0] = cpu_to_le32(*(u32 *) pHwData->CurrentMacAddress);
-	ltmp[1] =
-	    cpu_to_le32(*(u32 *) (pHwData->CurrentMacAddress + 4)) & 0xffff;
-
-	Wb35Reg_BurstWrite(pHwData, 0x03e8, ltmp, 2, AUTO_INCREMENT);
-}
-
-void hal_get_permanent_address(struct hw_data *pHwData, u8 * pethernet_address)
-{
-	if (pHwData->SurpriseRemove)
-		return;
-
-	memcpy(pethernet_address, pHwData->PermanentMacAddress, 6);
-}
-
-//---------------------------------------------------------------------------------------------------
-void hal_set_beacon_period(struct hw_data *pHwData, u16 beacon_period)
-{
-	u32 tmp;
-
-	if (pHwData->SurpriseRemove)
-		return;
-
-	pHwData->BeaconPeriod = beacon_period;
-	tmp = pHwData->BeaconPeriod << 16;
-	tmp |= pHwData->ProbeDelay;
-	Wb35Reg_Write(pHwData, 0x0848, tmp);
-}
-
-static void hal_set_current_channel_ex(struct hw_data *pHwData,
-				       ChanInfo channel)
-{
-	struct wb35_reg *reg = &pHwData->reg;
-
-	if (pHwData->SurpriseRemove)
-		return;
-
-	printk("Going to channel: %d/%d\n", channel.band, channel.ChanNo);
-
-	RFSynthesizer_SwitchingChannel(pHwData, channel);	// Switch channel
-	pHwData->Channel = channel.ChanNo;
-	pHwData->band = channel.band;
-#ifdef _PE_STATE_DUMP_
-	printk("Set channel is %d, band =%d\n", pHwData->Channel,
-	       pHwData->band);
-#endif
-	reg->M28_MacControl &= ~0xff;	// Clean channel information field
-	reg->M28_MacControl |= channel.ChanNo;
-	Wb35Reg_WriteWithCallbackValue(pHwData, 0x0828, reg->M28_MacControl,
-				       (s8 *) & channel, sizeof(ChanInfo));
-}
-
-//---------------------------------------------------------------------------------------------------
-void hal_set_current_channel(struct hw_data *pHwData, ChanInfo channel)
-{
-	hal_set_current_channel_ex(pHwData, channel);
-}
-
-//---------------------------------------------------------------------------------------------------
-void hal_set_accept_broadcast(struct hw_data *pHwData, u8 enable)
-{
-	struct wb35_reg *reg = &pHwData->reg;
-
-	if (pHwData->SurpriseRemove)
-		return;
-
-	reg->M00_MacControl &= ~0x02000000;	//The HW value
-
-	if (enable)
-		reg->M00_MacControl |= 0x02000000;	//The HW value
-
-	Wb35Reg_Write(pHwData, 0x0800, reg->M00_MacControl);
-}
-
-//for wep key error detection, we need to accept broadcast packets to be received temporary.
-void hal_set_accept_promiscuous(struct hw_data *pHwData, u8 enable)
-{
-	struct wb35_reg *reg = &pHwData->reg;
-
-	if (pHwData->SurpriseRemove)
-		return;
-	if (enable) {
-		reg->M00_MacControl |= 0x00400000;
-		Wb35Reg_Write(pHwData, 0x0800, reg->M00_MacControl);
-	} else {
-		reg->M00_MacControl &= ~0x00400000;
-		Wb35Reg_Write(pHwData, 0x0800, reg->M00_MacControl);
-	}
-}
-
-void hal_set_accept_multicast(struct hw_data *pHwData, u8 enable)
-{
-	struct wb35_reg *reg = &pHwData->reg;
-
-	if (pHwData->SurpriseRemove)
-		return;
-
-	reg->M00_MacControl &= ~0x01000000;	//The HW value
-	if (enable)
-		reg->M00_MacControl |= 0x01000000;	//The HW value
-	Wb35Reg_Write(pHwData, 0x0800, reg->M00_MacControl);
-}
-
-void hal_set_accept_beacon(struct hw_data *pHwData, u8 enable)
-{
-	struct wb35_reg *reg = &pHwData->reg;
-
-	if (pHwData->SurpriseRemove)
-		return;
-
-	// 20040108 debug
-	if (!enable)		//Due to SME and MLME are not suitable for 35
-		return;
-
-	reg->M00_MacControl &= ~0x04000000;	//The HW value
-	if (enable)
-		reg->M00_MacControl |= 0x04000000;	//The HW value
-
-	Wb35Reg_Write(pHwData, 0x0800, reg->M00_MacControl);
-}
-
-//---------------------------------------------------------------------------------------------------
-
-void hal_stop(struct hw_data *pHwData)
-{
-	struct wb35_reg *reg = &pHwData->reg;
-
-	pHwData->Wb35Rx.rx_halt = 1;
-	Wb35Rx_stop(pHwData);
-
-	pHwData->Wb35Tx.tx_halt = 1;
-	Wb35Tx_stop(pHwData);
-
-	reg->D00_DmaControl &= ~0xc0000000;	//Tx Off, Rx Off
-	Wb35Reg_Write(pHwData, 0x0400, reg->D00_DmaControl);
-}
-
-unsigned char hal_idle(struct hw_data *pHwData)
-{
-	struct wb35_reg *reg = &pHwData->reg;
-	struct wb_usb *pWbUsb = &pHwData->WbUsb;
-
-	if (!pHwData->SurpriseRemove
-	    && (pWbUsb->DetectCount || reg->EP0vm_state != VM_STOP))
-		return false;
-
-	return true;
-}
-
-void hal_set_radio_mode(struct hw_data *pHwData, unsigned char radio_off)
-{
-	struct wb35_reg *reg = &pHwData->reg;
-
-	if (pHwData->SurpriseRemove)
-		return;
-
-	if (radio_off)		//disable Baseband receive off
-	{
-		pHwData->CurrentRadioSw = 1;	// off
-		reg->M24_MacControl &= 0xffffffbf;
-	} else {
-		pHwData->CurrentRadioSw = 0;	// on
-		reg->M24_MacControl |= 0x00000040;
-	}
-	Wb35Reg_Write(pHwData, 0x0824, reg->M24_MacControl);
-}
-
-u8 hal_get_antenna_number(struct hw_data *pHwData)
-{
-	struct wb35_reg *reg = &pHwData->reg;
-
-	if ((reg->BB2C & BIT(11)) == 0)
-		return 0;
-	else
-		return 1;
-}
-
-//----------------------------------------------------------------------------------------------------
-//0 : radio on; 1: radio off
-u8 hal_get_hw_radio_off(struct hw_data * pHwData)
-{
-	struct wb35_reg *reg = &pHwData->reg;
-
-	if (pHwData->SurpriseRemove)
-		return 1;
-
-	//read the bit16 of register U1B0
-	Wb35Reg_Read(pHwData, 0x3b0, &reg->U1B0);
-	if ((reg->U1B0 & 0x00010000)) {
-		pHwData->CurrentRadioHw = 1;
-		return 1;
-	} else {
-		pHwData->CurrentRadioHw = 0;
-		return 0;
-	}
-}
-
 unsigned char hal_get_dxx_reg(struct hw_data *pHwData, u16 number, u32 * pValue)
 {
 	if (number < 0x1000)
diff --git a/drivers/staging/winbond/wbhal_f.h b/drivers/staging/winbond/wbhal_f.h
index bdea22f..c4934cb 100644
--- a/drivers/staging/winbond/wbhal_f.h
+++ b/drivers/staging/winbond/wbhal_f.h
@@ -18,9 +18,6 @@ void hal_clear_all_default_key(  struct hw_data * pHwData );
 void hal_clear_all_group_key(  struct hw_data * pHwData );
 void hal_clear_all_mapping_key(  struct hw_data * pHwData );
 void hal_clear_all_key(  struct hw_data * pHwData );
-void hal_get_ethernet_address(  struct hw_data * pHwData,  u8 *current_address );
-void hal_set_ethernet_address(  struct hw_data * pHwData,  u8 *current_address );
-void hal_get_permanent_address(  struct hw_data * pHwData,  u8 *pethernet_address );
 void hal_set_power_save_mode(  struct hw_data * pHwData,  unsigned char power_save,  unsigned char wakeup,  unsigned char dtim );
 void hal_get_power_save_mode(  struct hw_data * pHwData,   u8 *pin_pwr_save );
 void hal_set_slot_time(  struct hw_data * pHwData,  u8 type );
@@ -32,15 +29,9 @@ void hal_resume_sync_bss(  struct hw_data * pHwData);
 void hal_set_aid(  struct hw_data * pHwData,  u16 aid );
 void hal_set_bssid(  struct hw_data * pHwData,  u8 *pbssid );
 void hal_get_bssid(  struct hw_data * pHwData,  u8 *pbssid );
-void hal_set_beacon_period(  struct hw_data * pHwData,  u16 beacon_period );
 void hal_set_listen_interval(  struct hw_data * pHwData,  u16 listen_interval );
 void hal_set_cap_info(  struct hw_data * pHwData,  u16 capability_info );
 void hal_set_ssid(  struct hw_data * pHwData,  u8 *pssid,  u8 ssid_len );
-void hal_set_current_channel(  struct hw_data * pHwData,  ChanInfo channel );
-void hal_set_accept_broadcast(  struct hw_data * pHwData,  u8 enable );
-void hal_set_accept_multicast(  struct hw_data * pHwData,  u8 enable );
-void hal_set_accept_beacon(  struct hw_data * pHwData,  u8 enable );
-void hal_stop(  struct hw_data * pHwData );
 void hal_start_tx0(  struct hw_data * pHwData );
 #define hal_get_cwmin( _A ) ( (_A)->cwmin )
 void hal_set_cwmax(  struct hw_data * pHwData,  u16 cwin_max );
@@ -49,14 +40,11 @@ void hal_set_rsn_wpa(  struct hw_data * pHwData,  u32 * RSN_IE_Bitmap , u32 * RS
 void hal_set_connect_info(  struct hw_data * pHwData,  unsigned char boConnect );
 u8 hal_get_est_sq3(  struct hw_data * pHwData,  u8 Count );
 void hal_set_rf_power(  struct hw_data * pHwData,  u8 PowerIndex ); // 20060621 Modify
-void hal_set_radio_mode(  struct hw_data * pHwData,  unsigned char boValue);
 void hal_descriptor_indicate(  struct hw_data * pHwData,  PDESCRIPTOR pDes );
 u8 hal_get_antenna_number(  struct hw_data * pHwData );
 u32 hal_get_bss_pk_cnt(  struct hw_data * pHwData );
 #define hal_get_region_from_EEPROM( _A ) ( (_A)->reg.EEPROMRegion )
-void hal_set_accept_promiscuous		(  struct hw_data * pHwData,  u8 enable);
 #define hal_get_tx_buffer( _A, _B ) Wb35Tx_get_tx_buffer( _A, _B )
-u8 hal_get_hw_radio_off			(  struct hw_data * pHwData );
 #define hal_software_set( _A )		(_A->SoftwareSet)
 #define hal_driver_init_OK( _A )	(_A->IsInitOK)
 #define hal_rssi_boundary_high( _A ) (_A->RSSI_high)
@@ -79,7 +67,6 @@ unsigned char hal_set_dxx_reg(  struct hw_data * pHwData,  u16 number,  u32 valu
 #define hal_get_clear_interrupt(_A)
 #define hal_ibss_disconnect(_A) hal_stop_sync_bss(_A)
 #define hal_join_request_stop(_A)
-unsigned char	hal_idle(  struct hw_data * pHwData );
 #define hw_get_cxx_reg( _A, _B, _C )
 #define hw_set_cxx_reg( _A, _B, _C )
 #define hw_get_dxx_reg( _A, _B, _C )	hal_get_dxx_reg( _A, _B, (u32 *)_C )
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index dc7cc08..36d8c33 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -120,6 +120,127 @@ static int wbsoft_start(struct ieee80211_hw *dev)
 	return 0;
 }
 
+static void hal_set_radio_mode(struct hw_data *pHwData, unsigned char radio_off)
+{
+	struct wb35_reg *reg = &pHwData->reg;
+
+	if (pHwData->SurpriseRemove)
+		return;
+
+	if (radio_off)		//disable Baseband receive off
+	{
+		pHwData->CurrentRadioSw = 1;	// off
+		reg->M24_MacControl &= 0xffffffbf;
+	} else {
+		pHwData->CurrentRadioSw = 0;	// on
+		reg->M24_MacControl |= 0x00000040;
+	}
+	Wb35Reg_Write(pHwData, 0x0824, reg->M24_MacControl);
+}
+
+static void hal_set_beacon_period(struct hw_data *pHwData, u16 beacon_period)
+{
+	u32 tmp;
+
+	if (pHwData->SurpriseRemove)
+		return;
+
+	pHwData->BeaconPeriod = beacon_period;
+	tmp = pHwData->BeaconPeriod << 16;
+	tmp |= pHwData->ProbeDelay;
+	Wb35Reg_Write(pHwData, 0x0848, tmp);
+}
+
+static void
+hal_set_current_channel_ex(struct hw_data *pHwData, ChanInfo channel)
+{
+	struct wb35_reg *reg = &pHwData->reg;
+
+	if (pHwData->SurpriseRemove)
+		return;
+
+	printk("Going to channel: %d/%d\n", channel.band, channel.ChanNo);
+
+	RFSynthesizer_SwitchingChannel(pHwData, channel);	// Switch channel
+	pHwData->Channel = channel.ChanNo;
+	pHwData->band = channel.band;
+#ifdef _PE_STATE_DUMP_
+	printk("Set channel is %d, band =%d\n", pHwData->Channel,
+	       pHwData->band);
+#endif
+	reg->M28_MacControl &= ~0xff;	// Clean channel information field
+	reg->M28_MacControl |= channel.ChanNo;
+	Wb35Reg_WriteWithCallbackValue(pHwData, 0x0828, reg->M28_MacControl,
+				       (s8 *) & channel, sizeof(ChanInfo));
+}
+
+static void hal_set_current_channel(struct hw_data *pHwData, ChanInfo channel)
+{
+	hal_set_current_channel_ex(pHwData, channel);
+}
+
+static void hal_set_accept_broadcast(struct hw_data *pHwData, u8 enable)
+{
+	struct wb35_reg *reg = &pHwData->reg;
+
+	if (pHwData->SurpriseRemove)
+		return;
+
+	reg->M00_MacControl &= ~0x02000000;	//The HW value
+
+	if (enable)
+		reg->M00_MacControl |= 0x02000000;	//The HW value
+
+	Wb35Reg_Write(pHwData, 0x0800, reg->M00_MacControl);
+}
+
+//for wep key error detection, we need to accept broadcast packets to be received temporary.
+static void hal_set_accept_promiscuous(struct hw_data *pHwData, u8 enable)
+{
+	struct wb35_reg *reg = &pHwData->reg;
+
+	if (pHwData->SurpriseRemove)
+		return;
+	if (enable) {
+		reg->M00_MacControl |= 0x00400000;
+		Wb35Reg_Write(pHwData, 0x0800, reg->M00_MacControl);
+	} else {
+		reg->M00_MacControl &= ~0x00400000;
+		Wb35Reg_Write(pHwData, 0x0800, reg->M00_MacControl);
+	}
+}
+
+static void hal_set_accept_multicast(struct hw_data *pHwData, u8 enable)
+{
+	struct wb35_reg *reg = &pHwData->reg;
+
+	if (pHwData->SurpriseRemove)
+		return;
+
+	reg->M00_MacControl &= ~0x01000000;	//The HW value
+	if (enable)
+		reg->M00_MacControl |= 0x01000000;	//The HW value
+	Wb35Reg_Write(pHwData, 0x0800, reg->M00_MacControl);
+}
+
+static void hal_set_accept_beacon(struct hw_data *pHwData, u8 enable)
+{
+	struct wb35_reg *reg = &pHwData->reg;
+
+	if (pHwData->SurpriseRemove)
+		return;
+
+	// 20040108 debug
+	if (!enable)		//Due to SME and MLME are not suitable for 35
+		return;
+
+	reg->M00_MacControl &= ~0x04000000;	//The HW value
+	if (enable)
+		reg->M00_MacControl |= 0x04000000;	//The HW value
+
+	Wb35Reg_Write(pHwData, 0x0800, reg->M00_MacControl);
+}
+
 static int wbsoft_config(struct ieee80211_hw *dev, u32 changed)
 {
 	struct wbsoft_priv *priv = dev->priv;
@@ -171,6 +292,87 @@ static const struct ieee80211_ops wbsoft_ops = {
 	.get_tsf		= wbsoft_get_tsf,
 };
 
+static void
+hal_set_ethernet_address(struct hw_data *pHwData, u8 * current_address)
+{
+	u32 ltmp[2];
+
+	if (pHwData->SurpriseRemove)
+		return;
+
+	memcpy(pHwData->CurrentMacAddress, current_address, ETH_ALEN);
+
+	ltmp[0] = cpu_to_le32(*(u32 *) pHwData->CurrentMacAddress);
+	ltmp[1] =
+	    cpu_to_le32(*(u32 *) (pHwData->CurrentMacAddress + 4)) & 0xffff;
+
+	Wb35Reg_BurstWrite(pHwData, 0x03e8, ltmp, 2, AUTO_INCREMENT);
+}
+
+static void
+hal_get_permanent_address(struct hw_data *pHwData, u8 * pethernet_address)
+{
+	if (pHwData->SurpriseRemove)
+		return;
+
+	memcpy(pethernet_address, pHwData->PermanentMacAddress, 6);
+}
+
+static void hal_stop(struct hw_data *pHwData)
+{
+	struct wb35_reg *reg = &pHwData->reg;
+
+	pHwData->Wb35Rx.rx_halt = 1;
+	Wb35Rx_stop(pHwData);
+
+	pHwData->Wb35Tx.tx_halt = 1;
+	Wb35Tx_stop(pHwData);
+
+	reg->D00_DmaControl &= ~0xc0000000;	//Tx Off, Rx Off
+	Wb35Reg_Write(pHwData, 0x0400, reg->D00_DmaControl);
+}
+
+static unsigned char hal_idle(struct hw_data *pHwData)
+{
+	struct wb35_reg *reg = &pHwData->reg;
+	struct wb_usb *pWbUsb = &pHwData->WbUsb;
+
+	if (!pHwData->SurpriseRemove
+	    && (pWbUsb->DetectCount || reg->EP0vm_state != VM_STOP))
+		return false;
+
+	return true;
+}
+
+u8 hal_get_antenna_number(struct hw_data *pHwData)
+{
+	struct wb35_reg *reg = &pHwData->reg;
+
+	if ((reg->BB2C & BIT(11)) == 0)
+		return 0;
+	else
+		return 1;
+}
+
+/* 0 : radio on; 1: radio off */
+static u8 hal_get_hw_radio_off(struct hw_data * pHwData)
+{
+	struct wb35_reg *reg = &pHwData->reg;
+
+	if (pHwData->SurpriseRemove)
+		return 1;
+
+	//read the bit16 of register U1B0
+	Wb35Reg_Read(pHwData, 0x3b0, &reg->U1B0);
+	if ((reg->U1B0 & 0x00010000)) {
+		pHwData->CurrentRadioHw = 1;
+		return 1;
+	} else {
+		pHwData->CurrentRadioHw = 0;
+		return 0;
+	}
+}
+
 static u8 LED_GRAY[20] = {
 	0, 3, 4, 6, 8, 10, 11, 12, 13, 14, 15, 14, 13, 12, 11, 10, 8, 6, 4, 2
 };
-- 
1.5.6.3

