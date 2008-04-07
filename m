Return-Path: <linux-kernel-owner+w=401wt.eu-S1758885AbYDGXK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885AbYDGXK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 19:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754635AbYDGXKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 19:10:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:43348 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbYDGXKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 19:10:18 -0400
Date: Tue, 8 Apr 2008 01:10:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com
Subject: w35und: we don't need windows code in linux driver
Message-ID: <20080407231050.GA27510@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more patch... but this one is untested (have to get some sleep).

diff --git a/drivers/net/wireless/winbond/winbondport/wbhal.c b/drivers/net/wireless/winbond/winbondport/wbhal.c
index 596bf0b..663f615 100644
--- a/drivers/net/wireless/winbond/winbondport/wbhal.c
+++ b/drivers/net/wireless/winbond/winbondport/wbhal.c
@@ -1,10 +1,11 @@
 #include "os_common.h"
 
 
-//-----------------------------------------------------------------------------------
+
 void hal_start_tx0(  phw_data_t pHwData )
 {
-	if( !pHwData->SurpriseRemove ) Wb35Tx_start( pHwData );
+	if (!pHwData->SurpriseRemove)
+		Wb35Tx_start( pHwData );
 }
 
 //-----------------------------------------------------------------------------------
@@ -18,15 +19,14 @@ void hal_remove_mapping_key( phw_data_t 
 	WBDEBUG(("hal_remove_mapping_key\n"));
 	#endif
 
-	for( i=MAPPING_KEY_START_INDEX; i<MAX_KEY_TABLE; i++ )
-	{
+	for (i=MAPPING_KEY_START_INDEX; i<MAX_KEY_TABLE; i++) {
 		if( OS_MEMORY_COMPARE( pmac_addr, pHwData->Key_slot[i], MAC_ADDR_LENGTH ) )
 			break;
 	}
 	if( i != MAX_KEY_TABLE ) //Find the same index
 	{
 		// Clear the mac address
-		OS_MEMORY_CLEAR( pHwData->Key_slot[i], MAC_ADDR_LENGTH );
+		memset(pHwData->Key_slot[i], 0, MAC_ADDR_LENGTH);
 
 		//Writing into register to clear the valid bit
 		Wb35Reg_Write( pHwData, 0x0820, 0x0 );//Value
@@ -771,12 +771,13 @@ void hal_set_ssid(  phw_data_t pHwData, 
 	pWb35Reg->M4C_MacStatus |= tmp;
 	Wb35Reg_Write( pHwData, 0x084c, pWb35Reg->M4C_MacStatus );
 }
-//---------------------------------------------------------------------------------------------------
+
 void hal_set_current_channel_ex(  phw_data_t pHwData,  ChanInfo channel )
 {
 	PWB35REG pWb35Reg = &pHwData->Wb35Reg;
 
-	if( pHwData->SurpriseRemove ) return;
+	if( pHwData->SurpriseRemove )
+		return;
 
 	RFSynthesizer_SwitchingChannel( pHwData, channel );// Switch channel
 	pHwData->Channel = channel.ChanNo;
@@ -786,9 +787,8 @@ void hal_set_current_channel_ex(  phw_da
 	#endif
 	pWb35Reg->M28_MacControl &= ~0xff; // Clean channel information field
 	pWb35Reg->M28_MacControl |= channel.ChanNo;
-	//Wb35Reg_Write( pHwData, 0x0828, pWb35Reg->M28_MacControl );// Writing Channel information
 	Wb35Reg_WriteWithCallbackValue( pHwData, 0x0828, pWb35Reg->M28_MacControl,
-									(PCHAR)&channel, sizeof(ChanInfo));
+					(PCHAR)&channel, sizeof(ChanInfo));
 }
 //---------------------------------------------------------------------------------------------------
 void hal_set_current_channel(  phw_data_t pHwData,  ChanInfo channel )
@@ -816,8 +816,8 @@ void hal_set_accept_broadcast(  phw_data
 
 	pWb35Reg->M00_MacControl &= ~0x02000000;//The HW value
 	
-	if( enable ) pWb35Reg->M00_MacControl |= 0x02000000;//The HW value
-	
+	if (enable)
+		pWb35Reg->M00_MacControl |= 0x02000000;//The HW value
     
 	Wb35Reg_Write( pHwData, 0x0800, pWb35Reg->M00_MacControl );
 }
@@ -827,14 +827,11 @@ void hal_set_accept_promiscuous( phw_dat
 {   
 	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
 
-	if( pHwData->SurpriseRemove ) return;
-	if(enable)
-	{
+	if (pHwData->SurpriseRemove) return;
+	if (enable) {
 		pWb35Reg->M00_MacControl |= 0x00400000;
 		Wb35Reg_Write( pHwData, 0x0800, pWb35Reg->M00_MacControl );
-	}
-	else
-	{
+	} else {
 		pWb35Reg->M00_MacControl&=~0x00400000;
 		Wb35Reg_Write( pHwData, 0x0800, pWb35Reg->M00_MacControl );
 	}
@@ -847,7 +844,7 @@ void hal_set_accept_multicast(  phw_data
 	if( pHwData->SurpriseRemove ) return;
 
 	pWb35Reg->M00_MacControl &= ~0x01000000;//The HW value
-	if( enable ) pWb35Reg->M00_MacControl |= 0x01000000;//The HW value
+	if (enable)  pWb35Reg->M00_MacControl |= 0x01000000;//The HW value
 	Wb35Reg_Write( pHwData, 0x0800, pWb35Reg->M00_MacControl );
 }
 //---------------------------------------------------------------------------------------------------
diff --git a/drivers/net/wireless/winbond/winbondport/wbhal_f.h b/drivers/net/wireless/winbond/winbondport/wbhal_f.h
index 090ee2b..a6e2f52 100644
--- a/drivers/net/wireless/winbond/winbondport/wbhal_f.h
+++ b/drivers/net/wireless/winbond/winbondport/wbhal_f.h
@@ -16,69 +16,69 @@ #endif
 //====================================================================================
 // Function declaration
 //====================================================================================
-void hal_remove_mapping_key			(  phw_data_t pHwData,  PUCHAR pmac_addr );
-void hal_remove_default_key			(  phw_data_t pHwData,  u32 index );
-unsigned char hal_set_mapping_key			(  phw_data_t Adapter,  PUCHAR pmac_addr,  u8 null_key,  u8 wep_on,  PUCHAR ptx_tsc,  PUCHAR prx_tsc,  u8 key_type,  u8 key_len,  PUCHAR pkey_data );
-unsigned char hal_set_default_key			(  phw_data_t Adapter,  u8 index,  u8 null_key,  u8 wep_on,  PUCHAR ptx_tsc,  PUCHAR prx_tsc,  u8 key_type,  u8 key_len,  PUCHAR pkey_data );
-void hal_clear_all_default_key		(  phw_data_t pHwData );
-void hal_clear_all_group_key		(  phw_data_t pHwData );
-void hal_clear_all_mapping_key		(  phw_data_t pHwData );
-void hal_clear_all_key				(  phw_data_t pHwData );
-void hal_get_ethernet_address		(  phw_data_t pHwData,  PUCHAR current_address );
-void hal_set_ethernet_address		(  phw_data_t pHwData,  PUCHAR current_address );
-void hal_get_permanent_address		(  phw_data_t pHwData,  PUCHAR pethernet_address );
-unsigned char hal_init_hardware			(  phw_data_t pHwData,  PADAPTER Adapter );
-void hal_set_power_save_mode		(  phw_data_t pHwData,  unsigned char power_save,  unsigned char wakeup,  unsigned char dtim );
-void hal_get_power_save_mode		(  phw_data_t pHwData,   PBOOLEAN pin_pwr_save );
-void hal_set_slot_time				(  phw_data_t pHwData,  u8 type );
+void hal_remove_mapping_key(  phw_data_t pHwData,  PUCHAR pmac_addr );
+void hal_remove_default_key(  phw_data_t pHwData,  u32 index );
+unsigned char hal_set_mapping_key(  phw_data_t Adapter,  PUCHAR pmac_addr,  u8 null_key,  u8 wep_on,  PUCHAR ptx_tsc,  PUCHAR prx_tsc,  u8 key_type,  u8 key_len,  PUCHAR pkey_data );
+unsigned char hal_set_default_key(  phw_data_t Adapter,  u8 index,  u8 null_key,  u8 wep_on,  PUCHAR ptx_tsc,  PUCHAR prx_tsc,  u8 key_type,  u8 key_len,  PUCHAR pkey_data );
+void hal_clear_all_default_key(  phw_data_t pHwData );
+void hal_clear_all_group_key(  phw_data_t pHwData );
+void hal_clear_all_mapping_key(  phw_data_t pHwData );
+void hal_clear_all_key(  phw_data_t pHwData );
+void hal_get_ethernet_address(  phw_data_t pHwData,  PUCHAR current_address );
+void hal_set_ethernet_address(  phw_data_t pHwData,  PUCHAR current_address );
+void hal_get_permanent_address(  phw_data_t pHwData,  PUCHAR pethernet_address );
+unsigned char hal_init_hardware(  phw_data_t pHwData,  PADAPTER Adapter );
+void hal_set_power_save_mode(  phw_data_t pHwData,  unsigned char power_save,  unsigned char wakeup,  unsigned char dtim );
+void hal_get_power_save_mode(  phw_data_t pHwData,   PBOOLEAN pin_pwr_save );
+void hal_set_slot_time(  phw_data_t pHwData,  u8 type );
 #define hal_set_atim_window( _A, _ATM )
-void hal_set_rates					(  phw_data_t pHwData,  PUCHAR pbss_rates,  u8 length,  unsigned char basic_rate_set );
+void hal_set_rates(  phw_data_t pHwData,  PUCHAR pbss_rates,  u8 length,  unsigned char basic_rate_set );
 #define hal_set_basic_rates( _A, _R, _L ) hal_set_rates( _A, _R, _L, TRUE )
 #define hal_set_op_rates( _A, _R, _L ) hal_set_rates( _A, _R, _L, FALSE )
-void hal_start_bss					(  phw_data_t pHwData,  u8 mac_op_mode );
-void hal_join_request				(  phw_data_t pHwData,  u8 bss_type ); // 0:BSS STA 1:IBSS STA//
-void hal_stop_sync_bss				(  phw_data_t pHwData );
-void hal_resume_sync_bss			(  phw_data_t pHwData);
-void hal_set_aid					(  phw_data_t pHwData,  u16 aid );
-void hal_set_bssid					(  phw_data_t pHwData,  PUCHAR pbssid );
-void hal_get_bssid					(  phw_data_t pHwData,  PUCHAR pbssid );
-void hal_set_beacon_period			(  phw_data_t pHwData,  u16 beacon_period );
-void hal_set_listen_interval		(  phw_data_t pHwData,  u16 listen_interval );
-void hal_set_cap_info				(  phw_data_t pHwData,  u16 capability_info );
-void hal_set_ssid					(  phw_data_t pHwData,  PUCHAR pssid,  u8 ssid_len );
-void hal_set_current_channel		(  phw_data_t pHwData,  ChanInfo channel );
-void hal_set_current_channel_ex		(  phw_data_t pHwData,  ChanInfo channel );
-void hal_get_current_channel		(  phw_data_t pHwData,  ChanInfo *channel );
-void hal_set_accept_broadcast		(  phw_data_t pHwData,  u8 enable );
-void hal_set_accept_multicast		(  phw_data_t pHwData,  u8 enable );
-void hal_set_accept_beacon			(  phw_data_t pHwData,  u8 enable );
-void hal_set_multicast_address		(  phw_data_t pHwData,  PUCHAR address,  u8 number );
-u8 hal_get_accept_beacon			(  phw_data_t pHwData );
-void hal_stop						(  phw_data_t pHwData );
-void hal_halt						(  phw_data_t pHwData, void *ppa_data );
-void hal_start_tx0					(  phw_data_t pHwData );
-void hal_set_phy_type				(  phw_data_t pHwData,  u8 PhyType );
-void hal_get_phy_type				(  phw_data_t pHwData,  u8 *PhyType );
-unsigned char hal_reset_hardware			(  phw_data_t pHwData,  void* ppa );
-void hal_set_cwmin					(  phw_data_t pHwData,  u8	cwin_min );
-#define hal_get_cwmin( _A )			( (_A)->cwmin )
-void hal_set_cwmax					(  phw_data_t pHwData,  u16 cwin_max );
-#define hal_get_cwmax( _A )			( (_A)->cwmax )
-void hal_set_rsn_wpa				(  phw_data_t pHwData,  u32 * RSN_IE_Bitmap , u32 * RSN_OUI_type , unsigned char bDesiredAuthMode);
+void hal_start_bss(  phw_data_t pHwData,  u8 mac_op_mode );
+void hal_join_request(  phw_data_t pHwData,  u8 bss_type ); // 0:BSS STA 1:IBSS STA//
+void hal_stop_sync_bss(  phw_data_t pHwData );
+void hal_resume_sync_bss(  phw_data_t pHwData);
+void hal_set_aid(  phw_data_t pHwData,  u16 aid );
+void hal_set_bssid(  phw_data_t pHwData,  PUCHAR pbssid );
+void hal_get_bssid(  phw_data_t pHwData,  PUCHAR pbssid );
+void hal_set_beacon_period(  phw_data_t pHwData,  u16 beacon_period );
+void hal_set_listen_interval(  phw_data_t pHwData,  u16 listen_interval );
+void hal_set_cap_info(  phw_data_t pHwData,  u16 capability_info );
+void hal_set_ssid(  phw_data_t pHwData,  PUCHAR pssid,  u8 ssid_len );
+void hal_set_current_channel(  phw_data_t pHwData,  ChanInfo channel );
+void hal_set_current_channel_ex(  phw_data_t pHwData,  ChanInfo channel );
+void hal_get_current_channel(  phw_data_t pHwData,  ChanInfo *channel );
+void hal_set_accept_broadcast(  phw_data_t pHwData,  u8 enable );
+void hal_set_accept_multicast(  phw_data_t pHwData,  u8 enable );
+void hal_set_accept_beacon(  phw_data_t pHwData,  u8 enable );
+void hal_set_multicast_address(  phw_data_t pHwData,  PUCHAR address,  u8 number );
+u8 hal_get_accept_beacon(  phw_data_t pHwData );
+void hal_stop(  phw_data_t pHwData );
+void hal_halt(  phw_data_t pHwData, void *ppa_data );
+void hal_start_tx0(  phw_data_t pHwData );
+void hal_set_phy_type(  phw_data_t pHwData,  u8 PhyType );
+void hal_get_phy_type(  phw_data_t pHwData,  u8 *PhyType );
+unsigned char hal_reset_hardware(  phw_data_t pHwData,  void* ppa );
+void hal_set_cwmin(  phw_data_t pHwData,  u8	cwin_min );
+#define hal_get_cwmin( _A ) ( (_A)->cwmin )
+void hal_set_cwmax(  phw_data_t pHwData,  u16 cwin_max );
+#define hal_get_cwmax( _A ) ( (_A)->cwmax )
+void hal_set_rsn_wpa(  phw_data_t pHwData,  u32 * RSN_IE_Bitmap , u32 * RSN_OUI_type , unsigned char bDesiredAuthMode);
 //s32 hal_get_rssi(  phw_data_t pHwData,  u32 HalRssi );
-s32 hal_get_rssi					(  phw_data_t pHwData,  u32 *HalRssiArry,  u8 Count );
+s32 hal_get_rssi(  phw_data_t pHwData,  u32 *HalRssiArry,  u8 Count );
 s32 hal_get_rssi_bss(  phw_data_t pHwData,  u16 idx,  u8 Count );
-void hal_set_connect_info			(  phw_data_t pHwData,  unsigned char boConnect );
-u8 hal_get_est_sq3				(  phw_data_t pHwData,  u8 Count );
-void hal_led_control_1a				(  phw_data_t pHwData );
-void hal_led_control				(  void* S1,  phw_data_t pHwData,  void* S3,  void* S4 );
-void hal_set_rf_power				(  phw_data_t pHwData,  u8 PowerIndex ); // 20060621 Modify
-void hal_reset_counter				(  phw_data_t pHwData );
-void hal_set_radio_mode				(  phw_data_t pHwData,  unsigned char boValue);
-void hal_descriptor_indicate		(  phw_data_t pHwData,  PDESCRIPTOR pDes );
-u8 hal_get_antenna_number			(  phw_data_t pHwData );
-void hal_set_antenna_number			(  phw_data_t pHwData, u8 number );
-u32 hal_get_bss_pk_cnt				(  phw_data_t pHwData );
+void hal_set_connect_info(  phw_data_t pHwData,  unsigned char boConnect );
+u8 hal_get_est_sq3(  phw_data_t pHwData,  u8 Count );
+void hal_led_control_1a(  phw_data_t pHwData );
+void hal_led_control(  void* S1,  phw_data_t pHwData,  void* S3,  void* S4 );
+void hal_set_rf_power(  phw_data_t pHwData,  u8 PowerIndex ); // 20060621 Modify
+void hal_reset_counter(  phw_data_t pHwData );
+void hal_set_radio_mode(  phw_data_t pHwData,  unsigned char boValue);
+void hal_descriptor_indicate(  phw_data_t pHwData,  PDESCRIPTOR pDes );
+u8 hal_get_antenna_number(  phw_data_t pHwData );
+void hal_set_antenna_number(  phw_data_t pHwData, u8 number );
+u32 hal_get_bss_pk_cnt(  phw_data_t pHwData );
 #define hal_get_region_from_EEPROM( _A ) ( (_A)->Wb35Reg.EEPROMRegion )
 void hal_set_accept_promiscuous		(  phw_data_t pHwData,  u8 enable);
 #define hal_get_tx_buffer( _A, _B ) Wb35Tx_get_tx_buffer( _A, _B )
@@ -88,9 +88,9 @@ #define hal_driver_init_OK( _A )	(_A->Is
 #define hal_rssi_boundary_high( _A ) (_A->RSSI_high)
 #define hal_rssi_boundary_low( _A ) (_A->RSSI_low)
 #define hal_scan_interval( _A )		(_A->Scan_Interval)
-void hal_scan_status_indicate		(  phw_data_t pHwData, u8 status);	// 0: complete, 1: in progress
-void hal_system_power_change		(  phw_data_t pHwData, u32 PowerState ); // 20051230 -=D0 1=D1 ..
-void hal_surprise_remove			(  phw_data_t pHwData );
+void hal_scan_status_indicate(  phw_data_t pHwData, u8 status);	// 0: complete, 1: in progress
+void hal_system_power_change(  phw_data_t pHwData, u32 PowerState ); // 20051230 -=D0 1=D1 ..
+void hal_surprise_remove(  phw_data_t pHwData );
 
 #define PHY_DEBUG( msg, args... )  
 
@@ -106,7 +106,6 @@ unsigned char hal_set_LED(  phw_data_t p
 //-------------------------------------------------------------------------
 // The follow function is unused for IS89C35
 //-------------------------------------------------------------------------
-//#define hal_reset_counter(_A)
 #define hal_disable_interrupt(_A)
 #define hal_enable_interrupt(_A)
 #define hal_get_interrupt_type( _A)
diff --git a/drivers/net/wireless/winbond/winbondport/wblinux.c b/drivers/net/wireless/winbond/winbondport/wblinux.c
index 9220e80..27dcca0 100644
--- a/drivers/net/wireless/winbond/winbondport/wblinux.c
+++ b/drivers/net/wireless/winbond/winbondport/wblinux.c
@@ -386,180 +386,161 @@ #endif
 }
 
 unsigned char
-  WbWLanInitialize(  PADAPTER Adapter )
+WbWLanInitialize(PADAPTER Adapter)
 {
-   phw_data_t	pHwData;
-   PUCHAR		pMacAddr, pMacAddr2;
-   u32		InitStep = 0;
-   u8		EEPROM_region;
-   u8		HwRadioOff;
-
-   do
-     {
-	//
-	// Setting default value for Linux
-	//
-	Adapter->sLocalPara.region_INF = REGION_AUTO;
-	Adapter->sLocalPara.TxRateMode = RATE_AUTO;
-	psLOCAL->bMacOperationMode = MODE_802_11_BG;	// B/G mode
-	Adapter->Mds.TxRTSThreshold = DEFAULT_RTSThreshold;
-	Adapter->Mds.TxFragmentThreshold = DEFAULT_FRAGMENT_THRESHOLD;
-	hal_set_phy_type( &Adapter->sHwData, RF_WB_242_1 );
-	Adapter->sLocalPara.MTUsize = MAX_ETHERNET_PACKET_SIZE;
-	psLOCAL->bPreambleMode = AUTO_MODE;
-	Adapter->sLocalPara.RadioOffStatus.boSwRadioOff = FALSE;
-	psSME->bDesiredPowerSave = FALSE;
-	psSCAN->BScanEnable = TRUE;
-	pHwData = &Adapter->sHwData;
-	hal_set_phy_type( pHwData, RF_DECIDE_BY_INF );
-
-	//
-	// Initial each module and variable
-	//
-	if( !WBLINUX_Initial( Adapter ) )
-	  {
+	phw_data_t	pHwData;
+	PUCHAR		pMacAddr, pMacAddr2;
+	u32		InitStep = 0;
+	u8		EEPROM_region;
+	u8		HwRadioOff;
+
+	do {
+		//
+		// Setting default value for Linux
+		//
+		Adapter->sLocalPara.region_INF = REGION_AUTO;
+		Adapter->sLocalPara.TxRateMode = RATE_AUTO;
+		psLOCAL->bMacOperationMode = MODE_802_11_BG;	// B/G mode
+		Adapter->Mds.TxRTSThreshold = DEFAULT_RTSThreshold;
+		Adapter->Mds.TxFragmentThreshold = DEFAULT_FRAGMENT_THRESHOLD;
+		hal_set_phy_type( &Adapter->sHwData, RF_WB_242_1 );
+		Adapter->sLocalPara.MTUsize = MAX_ETHERNET_PACKET_SIZE;
+		psLOCAL->bPreambleMode = AUTO_MODE;
+		Adapter->sLocalPara.RadioOffStatus.boSwRadioOff = FALSE;
+		psSME->bDesiredPowerSave = FALSE;
+		psSCAN->BScanEnable = TRUE;
+		pHwData = &Adapter->sHwData;
+		hal_set_phy_type( pHwData, RF_DECIDE_BY_INF );
+
+		//
+		// Initial each module and variable
+		//
+		if (!WBLINUX_Initial(Adapter)) {
 #ifdef _PE_USB_INI_DUMP_
-	     WBDEBUG(("[w35und]WBNDIS initialization failed\n"));
+			WBDEBUG(("[w35und]WBNDIS initialization failed\n"));
 #endif
-	     break;
-	  }
-
-	// Initial Software variable
-	Adapter->sLocalPara.ShutDowned = FALSE;
-
-        //added by ws for wep key error detection
-        Adapter->sLocalPara.bWepKeyError= FALSE;//added by ws 02/02/04
-	Adapter->sLocalPara.bToSelfPacketReceived = FALSE;
-	Adapter->sLocalPara.WepKeyDetectTimerCount= 2 * 100; /// 2 seconds
-
-	// Initial USB hal
-	InitStep = 1;
-	pHwData = &Adapter->sHwData;
-	if( !hal_init_hardware( pHwData, Adapter ) )
-	  break;
-
-	EEPROM_region = hal_get_region_from_EEPROM( pHwData );
-	if (EEPROM_region != REGION_AUTO)
-	  psLOCAL->region = EEPROM_region;
-	else
-	  {
-	     if (psLOCAL->region_INF != REGION_AUTO)
-	       psLOCAL->region = psLOCAL->region_INF;
-	     else
-	       psLOCAL->region = REGION_USA;	//default setting
-	  }
+			break;
+		}
 
-	// Get Software setting flag from hal
-	Adapter->sLocalPara.boAntennaDiversity = FALSE;
-	if( hal_software_set( pHwData ) & 0x00000001 )
-	  Adapter->sLocalPara.boAntennaDiversity = TRUE;
+		// Initial Software variable
+		Adapter->sLocalPara.ShutDowned = FALSE;
+
+		//added by ws for wep key error detection
+		Adapter->sLocalPara.bWepKeyError= FALSE;//added by ws 02/02/04
+		Adapter->sLocalPara.bToSelfPacketReceived = FALSE;
+		Adapter->sLocalPara.WepKeyDetectTimerCount= 2 * 100; /// 2 seconds
+
+		// Initial USB hal
+		InitStep = 1;
+		pHwData = &Adapter->sHwData;
+		if (!hal_init_hardware(pHwData, Adapter))
+			break;
+
+		EEPROM_region = hal_get_region_from_EEPROM( pHwData );
+		if (EEPROM_region != REGION_AUTO)
+			psLOCAL->region = EEPROM_region;
+		else {
+			if (psLOCAL->region_INF != REGION_AUTO)
+				psLOCAL->region = psLOCAL->region_INF;
+			else
+				psLOCAL->region = REGION_USA;	//default setting
+		}
 
-	//
-	// For TS module
-	//
-	InitStep = 2;
-	if( !TS_initial( Adapter ) )
-	  break;
-
-	// For MDS module
-	InitStep = 3;
-	Mds_initial( Adapter );
-
-	//=======================================
-	// Initialize the SME, SCAN, MLME, ROAM
-	//=======================================
-	//		#ifdef NDIS51_MINIPORT
-	//		//For WinXP required
-	//		vNetDisconnectInd(Adapter);
-	//		#endif
-	InitStep = 4;
-	SME_Init(Adapter);
-	Scan_Init(Adapter);
-	if( !MLME_Init(Adapter) )
-	  break;
-
-	MLMESetExcludeUnencrypted(Adapter, FALSE);
-	MLMESetMaxReceiveLifeTime(Adapter, DEFAULT_MAX_RECEIVE_TIME);
-
-	InitStep = 5;
-	Roam_Init(Adapter);
-
-	InitStep = 6;
-	//		WbNdis51_initial( Adapter );
-
-	// If no user-defined address in the registry, use the addresss "burned" on the NIC instead.
-	pMacAddr = Adapter->sLocalPara.ThisMacAddress;
-	pMacAddr2 = Adapter->sLocalPara.PermanentAddress;
-	hal_get_permanent_address( pHwData, Adapter->sLocalPara.PermanentAddress );// Reading ethernet address from EEPROM
-	if( OS_MEMORY_COMPARE( pMacAddr, "\x00\x00\x00\x00\x00\x00", MAC_ADDR_LENGTH ) ) // Is equal
-	  {
-	     memcpy( pMacAddr, pMacAddr2, MAC_ADDR_LENGTH );
-	  }
-	else
-	  {
-	     // Set the user define MAC address
-	     hal_set_ethernet_address( pHwData, Adapter->sLocalPara.ThisMacAddress );
-	  }
+		// Get Software setting flag from hal
+		Adapter->sLocalPara.boAntennaDiversity = FALSE;
+		if (hal_software_set(pHwData) & 0x00000001)
+			Adapter->sLocalPara.boAntennaDiversity = TRUE;
+
+		//
+		// For TS module
+		//
+		InitStep = 2;
+		if (!TS_initial(Adapter))
+			break;
+
+		// For MDS module
+		InitStep = 3;
+		Mds_initial(Adapter);
+
+		//=======================================
+		// Initialize the SME, SCAN, MLME, ROAM
+		//=======================================
+		InitStep = 4;
+		SME_Init(Adapter);
+		Scan_Init(Adapter);
+		if (!MLME_Init(Adapter))
+			break;
+
+		MLMESetExcludeUnencrypted(Adapter, FALSE);
+		MLMESetMaxReceiveLifeTime(Adapter, DEFAULT_MAX_RECEIVE_TIME);
+
+		InitStep = 5;
+		Roam_Init(Adapter);
+
+		InitStep = 6;
+
+		// If no user-defined address in the registry, use the addresss "burned" on the NIC instead.
+		pMacAddr = Adapter->sLocalPara.ThisMacAddress;
+		pMacAddr2 = Adapter->sLocalPara.PermanentAddress;
+		hal_get_permanent_address( pHwData, Adapter->sLocalPara.PermanentAddress );// Reading ethernet address from EEPROM
+		if (OS_MEMORY_COMPARE(pMacAddr, "\x00\x00\x00\x00\x00\x00", MAC_ADDR_LENGTH )) // Is equal
+		{
+			memcpy( pMacAddr, pMacAddr2, MAC_ADDR_LENGTH );
+		} else {
+			// Set the user define MAC address
+			hal_set_ethernet_address( pHwData, Adapter->sLocalPara.ThisMacAddress );
+		}
 
-	//get current antenna
-	psLOCAL->bAntennaNo = hal_get_antenna_number( pHwData );
+		//get current antenna
+		psLOCAL->bAntennaNo = hal_get_antenna_number(pHwData);
 #ifdef _PE_STATE_DUMP_
-	WBDEBUG(("Driver init, antenna no = %d\n", psLOCAL->bAntennaNo));
+		WBDEBUG(("Driver init, antenna no = %d\n", psLOCAL->bAntennaNo));
 #endif
-	hal_get_hw_radio_off( pHwData );
-
-	// Disable the antenna diversity.
-	//PLMESetAntennaDiversity( Adapter, 0 );
-
-	// Waiting for HAL setting OK
-	while( !hal_idle( pHwData ) )
-	  OS_SLEEP(10000);
-
-	MTO_Init(Adapter);
+		hal_get_hw_radio_off( pHwData );
 
-	HwRadioOff = hal_get_hw_radio_off( pHwData );
-	if (HwRadioOff)
-	  psLOCAL->RadioOffStatus.boHwRadioOff = TRUE;
-	else
-	  psLOCAL->RadioOffStatus.boHwRadioOff = FALSE;
+		// Waiting for HAL setting OK
+		while (!hal_idle(pHwData))
+			OS_SLEEP(10000);
 
-	hal_set_radio_mode( pHwData, (unsigned char)(psLOCAL->RadioOffStatus.boSwRadioOff || psLOCAL->RadioOffStatus.boHwRadioOff) );
+		MTO_Init(Adapter);
 
-	if( TS_RUNNING_IN_TESTSTA_MODE )
-	  { TS_STARTUP( Adapter ); }
-	else
-	  {
-	     K_MSG	sSmeMsg;
-	     sSmeMsg.wMsgType = SMEMSG_SCAN_REQ;
-	     sSmeMsg.pMsgPtr = NULL;
-	     SME_Entry(Adapter, &sSmeMsg);
+		HwRadioOff = hal_get_hw_radio_off( pHwData );
+		psLOCAL->RadioOffStatus.boHwRadioOff = !!HwRadioOff;
 
-	     OS_SLEEP(1000000);	//1 sec
-	  }
+		hal_set_radio_mode( pHwData, (unsigned char)(psLOCAL->RadioOffStatus.boSwRadioOff || psLOCAL->RadioOffStatus.boHwRadioOff) );
 
-	hal_driver_init_OK( pHwData ) = 1; // Notify hal that the driver is ready now.
-	//set a tx power for reference.....
-	sme_set_tx_power_level(Adapter, 12);
-	return TRUE;
+		if (TS_RUNNING_IN_TESTSTA_MODE) { 
+			TS_STARTUP( Adapter );
+		} else {
+			K_MSG	sSmeMsg;
+			sSmeMsg.wMsgType = SMEMSG_SCAN_REQ;
+			sSmeMsg.pMsgPtr = NULL;
+			SME_Entry(Adapter, &sSmeMsg);
 
-     }
-   while(FALSE);
+			OS_SLEEP(1000000);	//1 sec
+		}
 
-   switch( InitStep )
-     {
-	//	case 6: WbNdis51_destroy( Adapter );
-      case 5: Roam_Halt( Adapter );
-      case 4: MLME_Halt( Adapter );
-	SCAN_Halt( Adapter );
-	SME_Halt( Adapter );
-      case 3: Mds_Destroy( Adapter );
-      case 2:
-      case 1: WBLINUX_Destroy( Adapter );
-	hal_halt( pHwData, NULL );
-      case 0: break;
-     }
+		hal_driver_init_OK(pHwData) = 1; // Notify hal that the driver is ready now.
+		//set a tx power for reference.....
+		sme_set_tx_power_level(Adapter, 12);
+		return TRUE;
+	}
+	while(FALSE);
+
+	switch( InitStep )
+	{
+	case 5: Roam_Halt( Adapter );
+	case 4: MLME_Halt( Adapter );
+		SCAN_Halt( Adapter );
+		SME_Halt( Adapter );
+	case 3: Mds_Destroy( Adapter );
+	case 2:
+	case 1: WBLINUX_Destroy( Adapter );
+		hal_halt( pHwData, NULL );
+	case 0: break;
+	}
 
-   return FALSE;
+	return FALSE;
 }
 
 // 20060802
diff --git a/drivers/net/wireless/winbond/winbondport/wbndis_entry.c b/drivers/net/wireless/winbond/winbondport/wbndis_entry.c
index eb761d5..7cae451 100644
--- a/drivers/net/wireless/winbond/winbondport/wbndis_entry.c
+++ b/drivers/net/wireless/winbond/winbondport/wbndis_entry.c
@@ -1,1337 +1 @@
-//============================================================================
-//  Copyright (c) 1996-2004 Winbond Electronic Corporation
-//
-//  Module Name:
-//    WB32.C
-//
-//  Abstract:
-//    NDIS driver.
-//
-//  Author:
-//	  yyli0
-//============================================================================
-#include "os_common.h"
-
-//Debug information
-void DbgPrintfOID(NDIS_OID Oid);
-
-#ifdef NDIS50_MINIPORT
-ANSI_STRING g_String;
-char g_NicName[100];
-#endif
-//
-// List of supported OID for this driver.
-//
-static u32 WbWLanSupportedOids[] = {
-    OID_GEN_SUPPORTED_LIST,
-    OID_GEN_HARDWARE_STATUS,
-    OID_GEN_MEDIA_SUPPORTED,
-    OID_GEN_MEDIA_IN_USE,
-    OID_GEN_MAXIMUM_LOOKAHEAD,
-    OID_GEN_MAXIMUM_FRAME_SIZE,
-    OID_GEN_MAXIMUM_TOTAL_SIZE,
-    OID_GEN_MAC_OPTIONS,
-    OID_GEN_MEDIA_CONNECT_STATUS,
-    OID_GEN_MAXIMUM_SEND_PACKETS,
-    OID_GEN_VENDOR_DRIVER_VERSION,
-    OID_GEN_PROTOCOL_OPTIONS,
-    OID_GEN_LINK_SPEED,
-    OID_GEN_TRANSMIT_BUFFER_SPACE,
-    OID_GEN_RECEIVE_BUFFER_SPACE,
-    OID_GEN_TRANSMIT_BLOCK_SIZE,
-    OID_GEN_RECEIVE_BLOCK_SIZE,
-    OID_GEN_VENDOR_DESCRIPTION,
-    OID_GEN_VENDOR_ID,
-    OID_GEN_DRIVER_VERSION,
-    OID_GEN_CURRENT_PACKET_FILTER,
-    OID_GEN_CURRENT_LOOKAHEAD,
-    OID_GEN_XMIT_OK,
-    OID_GEN_RCV_OK,
-    OID_GEN_XMIT_ERROR,
-    OID_GEN_RCV_ERROR,
-    OID_GEN_RCV_NO_BUFFER,
-    OID_802_3_PERMANENT_ADDRESS,
-    OID_802_3_CURRENT_ADDRESS,
-    OID_802_3_MULTICAST_LIST,
-    OID_802_3_MAXIMUM_LIST_SIZE,
-    OID_802_3_XMIT_ONE_COLLISION,
-    OID_802_3_XMIT_MORE_COLLISIONS,
-	OID_802_11_BSSID,
-	OID_802_11_SSID,
-	OID_802_11_NETWORK_TYPES_SUPPORTED,
-	OID_802_11_NETWORK_TYPE_IN_USE,
-	OID_802_11_RSSI,
-	OID_802_11_INFRASTRUCTURE_MODE,
-	OID_802_11_FRAGMENTATION_THRESHOLD,
-	OID_802_11_RTS_THRESHOLD,
-	OID_802_11_SUPPORTED_RATES,
-	OID_802_11_CONFIGURATION,
-	OID_802_11_BSSID_LIST,
-	OID_802_11_AUTHENTICATION_MODE,
-	OID_802_11_ASSOCIATION_INFORMATION,
-	OID_802_11_ENCRYPTION_STATUS,
-	OID_802_11_ADD_WEP,
-	OID_802_11_REMOVE_WEP,
-	OID_802_11_DISASSOCIATE,
-	OID_802_11_BSSID_LIST_SCAN,
-	OID_802_11_RELOAD_DEFAULTS,
-	OID_802_11_ADD_KEY,
-	OID_802_11_REMOVE_KEY,
-	OID_802_11_TEST,
-	OID_802_11_DESIRED_RATES,//added by ws 09/01/04
-	OID_802_11_POWER_MODE,
-#ifdef _WPA2_
-	OID_802_11_CAPABILITY,
-	OID_802_11_PMKID,
-#endif
-	OID_802_11_CUST_LINK_QUALITY,
-	OID_802_11_CUST_HW_VERSION,
-	OID_802_11_CUST_DRV_VERSION,
-	OID_802_11_CUST_PREAMBLE_TYPE, //added by ws 09/01/0
-	OID_802_11_CUST_DRV_NAME,      //define an OID which wwu should query
-	OID_802_11_CUST_ENCRYPTION_STATUS,//added by ws 02/15/04
-#ifdef WB_CE	// 20051230.4 add for power event
-	OID_PNP_CAPABILITIES,
-	OID_PNP_QUERY_POWER,
-	OID_PNP_SET_POWER,
-#endif
-	OID_GEN_PHYSICAL_MEDIUM			// For PLT Product Line Test
-    };
-
-//============= The following global variable ========================
-// Handle for referring to the wrapper for the NDIS
-NDIS_HANDLE     NdisWrapperHandle = NULL;  
-NDIS_HANDLE     NdisDeviceHandle[MAX_ADAPTER_COUNT] = { NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL };
-void*           pAdapterContext[MAX_ADAPTER_COUNT] = { NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL };
-s32			AdapterCounter = 0; // 20060703 Add
-s32			DriverInitializing = 0;
-
-
-//============================================================================
-//  DriverEntry
-//
-//  Routine Description:
-//
-//    This is the primary initialization routine for the NIC miniport driver.
-//    It is simply responsible for the intializing the wrapper and registering
-//    the Miniport driver.  It then calls a system and architecture specific
-//    routine that will initialize and register each adapter.
-//
-//  Arguments:
-//    DriverObject - Pointer to driver object created by the system.
-//    RegistryPath - Path to the parameters for this driver in the registry.
-//
-//  Return Value:
-//    STATUS_SUCCESS
-//    STATUS_UNSUCCESSFUL
-//============================================================================
-NTSTATUS
-DriverEntry( PDRIVER_OBJECT  DriverObject,
-              PUNICODE_STRING RegistryPath)
-{
-    NDIS_MINIPORT_CHARACTERISTICS WBWLan; // Miniport characteristics struc.
-    NDIS_STATUS     Status;                 // Receives the status of the
-                                            // NdisMRegisterMiniport operation.
-
-#ifdef NDIS50_MINIPORT
-	{
-		
-		ANSI_STRING * GLOBAL_String=&g_String;
-		NTSTATUS status;
-		RTL_QUERY_REGISTRY_TABLE paramTable[2];
-		UNICODE_STRING ParameterValue;
-		PUNICODE_STRING pNicName;
-		WCHAR temp[200];
-
-		NdisZeroMemory(&g_String,sizeof(ANSI_STRING));
-		NdisZeroMemory(g_NicName,100);
-		g_String.Buffer = g_NicName;
-		g_String.Length = 0;
-		g_String.MaximumLength = 100;
-		NdisZeroMemory((char*)temp,400);
-		NdisMoveMemory(temp,L"\\REGISTRY\\MACHINE\\",36);
-		NdisMoveMemory((char*)temp+36,RegistryPath->Buffer,RegistryPath->Length*2);
-		temp[18+RegistryPath->Length] = UNICODE_NULL;
-
-		RtlZeroMemory(paramTable, sizeof(paramTable));
-		NdisInitUnicodeString(&ParameterValue, L"1111111111222222222233333333334444444444455555555556666666666");
-		
-		paramTable[0].Flags = RTL_QUERY_REGISTRY_DIRECT;
-		paramTable[0].Name = L"DriverDesc";
-		paramTable[0].EntryContext = &ParameterValue;
-		paramTable[0].DefaultType = REG_SZ;
-		paramTable[0].DefaultData = L"";
-		paramTable[0].DefaultLength = 0;
-		status =RtlQueryRegistryValues(RTL_REGISTRY_ABSOLUTE ,
-			temp,
-//			L"\\REGISTRY\\MACHINE\\SYSTEM\\CURRENTCONTROLSET\\SERVICES\\CLASS\\NET\\0001",
-			&paramTable[0],
-			NULL,
-			NULL);
-		if(status != STATUS_SUCCESS) 
-		{
-			DbgPrint("RtlQueryRegistryValues FAILED status=%x /n",status);
-		}
-		
-		if((STATUS_SUCCESS == status) && (ParameterValue.Buffer != NULL)) 
-		{
-			if(ParameterValue.MaximumLength >= (ParameterValue.Length + sizeof(WCHAR))) 
-			{
-				(ParameterValue.Buffer)[ParameterValue.Length / sizeof(WCHAR)] = UNICODE_NULL;
-//				RtlUnicodeStringToAnsiString(&g_String,&ParameterValue,FALSE);
-				g_String.Length = (ParameterValue.Length+1);
-				NdisMoveMemory(g_NicName,(char*)(ParameterValue.Buffer),(ParameterValue.Length+1));
-				DbgPrint("g_NicName%s/n",g_NicName);
-			}
-			else
-			{
-				ExFreePool(ParameterValue.Buffer);
-				ParameterValue.Length = 0;
-				ParameterValue.MaximumLength = 0;
-				ParameterValue.Buffer = 0;
-				status = STATUS_UNSUCCESSFUL;
-			}
-		}
-
-	}
-#endif                                        
-
-    //===========================
-    // Initialize the wrapper.
-    //===========================
-    NdisMInitializeWrapper(
-                &NdisWrapperHandle,
-                DriverObject,
-                RegistryPath,
-                NULL
-               );
-
-	NdisZeroMemory(&WBWLan, sizeof(WBWLan));
-
-    //========================================================
-    // Initialize the Miniport characteristics for the call to
-    // NdisMRegisterMiniport.
-    //========================================================
-	WBWLan.MajorNdisVersion			= WB32_NDIS_MAJOR_VERSION;
-	WBWLan.MinorNdisVersion			= WB32_NDIS_MINOR_VERSION;
-	WBWLan.InitializeHandler		= WbWLanInitialize;
-	WBWLan.HaltHandler				= WbWLanHalt;
-	WBWLan.ResetHandler				= WbWLanReset;
-	WBWLan.SetInformationHandler	= WbWLanSetInformation;
-	WBWLan.QueryInformationHandler	= WbWLanQueryInformation;
-	WBWLan.SendPacketsHandler		= WBNDIS_SendPackets;
-
-#ifdef NDIS51_MINIPORT
-//	WBWLan.CancelSendPacketsHandler	= 
-	WBWLan.PnPEventNotifyHandler	= WBNDIS_PnPNotify;
-#endif
-
-	Status = NdisMRegisterMiniport( NdisWrapperHandle, &WBWLan, sizeof(WBWLan) );
-	if( Status == NDIS_STATUS_SUCCESS )
-		return STATUS_SUCCESS;
-
-    NdisTerminateWrapper( NdisWrapperHandle, NULL );
-    return STATUS_UNSUCCESSFUL;
-}
-
-//==========================================================================
-//  Wb32ResetCounter
-//==========================================================================
-void Wb32ResetCounter(PWB32_ADAPTER Adapter)
-{
-    Adapter->sLocalPara._NumTxMSDU                     = 0;
-    Adapter->sLocalPara._NumRxMSDU                     = 0;
-    Adapter->sLocalPara._dot11WEPExcludedCount         = 0;
-    Adapter->sLocalPara._dot11WEPUndecryptableCount    = 0;
-    Adapter->sLocalPara._dot11FrameDuplicateCount      = 0;
-
-	hal_reset_counter(&Adapter->sHwData);
-}
-
-//=========================================================================
-//
-//  WbWLanInitialize --
-//
-//  Routine Description:
-//    WbWLanInitialize starts an adapter and registers resources with the
-//    wrapper.
-//
-//  Arguments:
-//    OpenErrorStatus       - Extra status bytes for opening token ring
-//                            adapters.
-//    SelectedMediumIndex   - Index of the media type chosen by the driver.
-//    MediumArray           - Array of media types for the driver to chose
-//                            from.
-//    MediumArraySize       - Number of entries in the array.
-//    MiniportAdapterHandle - Handle for passing to the wrapper when
-//                            referring to this adapter.
-//    ConfigurationHandle   - A handle to pass to NdisOpenConfiguration.
-//
-//  Return Value:
-//    NDIS_STATUS_SUCCESS
-//    NDIS_STATUS_PENDING ???
-//=========================================================================
-extern
-NDIS_STATUS WbWLanInitialize(  PNDIS_STATUS OpenErrorStatus,
-							   PUINT        SelectedMediumIndex,
-							    PNDIS_MEDIUM MediumArray,
-							    u32         MediumArraySize,
-							    NDIS_HANDLE  MiniportAdapterHandle,
-							    NDIS_HANDLE  ConfigurationHandle)
-{
-	u32			i, IndexTmp;
-	NDIS_STATUS		Status = NDIS_STATUS_FAILURE;
-    PWB32_ADAPTER	Adapter = NULL;		// Pointer to the newly allocated adapter.
-	phw_data_t		pHwData;
-	PUCHAR			pMacAddr, pMacAddr2;
-	u32			InitStep = 0, ltime;
-	u8			EEPROM_region;
-	u8			HwRadioOff;
-
-	do
-	{
-		DriverInitializing = 1;
-
-		// 20060703.2 Add for multipole Adapter IO control
-		if( NdisInterlockedIncrement( &AdapterCounter ) > MAX_ADAPTER_COUNT )
-		{
-			Status = NDIS_STATUS_FAILURE;
-			NdisInterlockedDecrement( &AdapterCounter );
-			break;
-		}
-		IndexTmp = 0;
-		for( i=0; i<MAX_ADAPTER_COUNT; i++ )
-		{
-			if( pAdapterContext[i] == NULL )
-			{
-				IndexTmp = i;
-				break;
-			}
-		}
-		if( i == MAX_ADAPTER_COUNT )
-			break;// Somthing wrong
-
-		//=======================================================
-		// Search for the medium type (802.3) in the given array.
-		//=======================================================
-		for ( i = 0; i < MediumArraySize; i++)
-		{
-			if ( MediumArray[i] == NdisMedium802_3)
-				break;
-		}
-		if ( i == MediumArraySize)
-		{
-			Status = NDIS_STATUS_UNSUPPORTED_MEDIA;// Unsupport media
-			break;
-		}
-		*SelectedMediumIndex = i;
-        
-		//============================================================
-		// Allocate memory for the adapter block now. and Tag = 'W32"
-		//============================================================
-		Status = NdisAllocateMemoryWithTag( (void* *)&Adapter, sizeof(WB32_ADAPTER), '53W' ); 
-		if( Status != NDIS_STATUS_SUCCESS )
-			break;
-
-		// Clear out the adapter block, which sets all default values to FALSE, or NULL.
-		NdisZeroMemory( Adapter, sizeof(WB32_ADAPTER) );
-
-		// Setting NDIS Driver attribution
-		NdisMSetAttributesEx( MiniportAdapterHandle,
-							  (NDIS_HANDLE) Adapter,
-							  0,
-		#ifdef NDIS51_MINIPORT
-							  NDIS_ATTRIBUTE_SURPRISE_REMOVE_OK |
-		#endif
-							  NDIS_ATTRIBUTE_DESERIALIZE,
-							  NdisInterfaceInternal );//For USB device
-
-		// Open the configuration space and Reading
-		pHwData = &Adapter->sHwData;
-		Status = WbReadNdisConfigration( Adapter, ConfigurationHandle );
-		if( Status != NDIS_STATUS_SUCCESS )
-			break;
-
-#ifdef WB_WIN
-		// Register the device for the NDIS.
-		if( NdisDeviceHandle[IndexTmp] == NULL )
-		{
-			Adapter->AdapterIndex = IndexTmp; // 20060703.2
-			Status = WBRegisterMiniportDevice( Adapter );
-			if( Status != NDIS_STATUS_SUCCESS )
-				break;
-		}
-#endif
-
-		//
-		// Initial each module and variable
-		//
-		if( !WBNDIS_Initial( Adapter, MiniportAdapterHandle ) )
-		{
-			Status = NDIS_STATUS_FAILURE;
-			break;
-		}
-
-		// Initial Software variable
-		Adapter->sLocalPara.ShutDowned = FALSE;
-//		Adapter->sNdis.Wb32HardwareStatus = NdisHardwareStatusReady;    // Hardware Ready to use
-		//Adapter->sLocalPara.boAntennaDiversity = TRUE;
-        //Adapter->sSmePara.Pmkid_Available_index=0;
-
-        //added by ws for wep key error detection
-        Adapter->sLocalPara.bWepKeyError= FALSE;//added by ws 02/02/04
-	    Adapter->sLocalPara.bToSelfPacketReceived = FALSE;
-	    Adapter->sLocalPara.WepKeyDetectTimerCount= 2 * 100; /// 2 seconds
-
-		// Initial USB hal
-		InitStep = 1;
-		if( !hal_init_hardware( pHwData, Adapter ) )
-		{
-			Status = NDIS_STATUS_FAILURE;
-			break;
-		}
-
-		EEPROM_region = hal_get_region_from_EEPROM(&Adapter->sHwData);
-		if (EEPROM_region != REGION_AUTO)
-			psLOCAL->region = EEPROM_region;
-		else
-		{
-			if (psLOCAL->region_INF != REGION_AUTO)
-				psLOCAL->region = psLOCAL->region_INF;
-			else
-				psLOCAL->region = REGION_USA;	//default setting
-		}
-
-		// Get Software setting flag from hal
-		Adapter->sLocalPara.boAntennaDiversity = FALSE;
-		if( hal_software_set( pHwData ) &0x00000001 )
-			Adapter->sLocalPara.boAntennaDiversity = TRUE;
-
-		//
-		// For TS module
-		//
-		InitStep = 2;
-		if( !TS_initial( Adapter ) )
-		{
-			Status = NDIS_STATUS_FAILURE;
-			break;
-		}
-
-		// For MDS module
-		InitStep = 3;
-		Mds_initial( Adapter );
-
-		//=======================================
-		// Initialize the SME, SCAN, MLME, ROAM
-		//=======================================
-//		#ifdef NDIS51_MINIPORT 
-//		//For WinXP required
-//		//vNetDisconnectInd(Adapter);	should not be performed here according to the DDK 5048 help
-//		#endif
-		InitStep = 4;
-		SME_Init(Adapter);
-		Scan_Init(Adapter);
-		if( !MLME_Init(Adapter) )
-		{
-			Status = NDIS_STATUS_FAILURE;
-			break;
-		}
-
-		MLMESetExcludeUnencrypted(Adapter, FALSE);
-		MLMESetMaxReceiveLifeTime(Adapter, DEFAULT_MAX_RECEIVE_TIME);
-
-		InitStep = 5;
-		Roam_Init(Adapter);
-
-		InitStep = 6;
-		WbNdis51_initial( Adapter );
-
-		// If no user-defined address in the registry, use the addresss "burned" on the NIC instead.
-		pMacAddr = Adapter->sLocalPara.ThisMacAddress;
-		pMacAddr2 = Adapter->sLocalPara.PermanentAddress;
-		hal_get_permanent_address( pHwData, Adapter->sLocalPara.PermanentAddress );// Reading ethernet address from EEPROM
-
-		if( OS_MEMORY_COMPARE( pMacAddr, "\x00\x00\x00\x00\x00\x00", MAC_ADDR_LENGTH ) ) // Does register set value?
-		{
-			if( OS_MEMORY_COMPARE( pMacAddr2, "\xff\xff\xff\xff", 4 ) ) // Is EEPROM empty?
-			{
-				pMacAddr2[0] = 0x00;
-				pMacAddr2[1] = 0x10;
-				pMacAddr2[2] = 0x1d;
-				pMacAddr2[3] = 0x35;
-
-				OS_TIMER_GET_SYS_TIME( &ltime );
-				memcpy( pMacAddr2 + 4, &ltime, 2 );
-
-				// Set the virtual MAC address
-				hal_set_ethernet_address( pHwData, pMacAddr2 );
-			}
-
-			memcpy( pMacAddr, pMacAddr2, MAC_ADDR_LENGTH );
-		}
-		else
-			// Set the user define MAC address
-			hal_set_ethernet_address( pHwData, Adapter->sLocalPara.ThisMacAddress );
-
-		//get current antenna
-		psLOCAL->bAntennaNo = hal_get_antenna_number( pHwData );
-		#ifdef _PE_STATE_DUMP_
-		WBDEBUG(("Driver init, antenna no = %d\n", psLOCAL->bAntennaNo));
-		#endif
-		hal_get_hw_radio_off( pHwData );
-
-		// Disable the antenna diversity.
-		//PLMESetAntennaDiversity( Adapter, 0 );
-
-		// Waiting for HAL setting OK
-		while( !hal_idle( pHwData ) )
-			OS_SLEEP(10000);
-
-		MTO_Init(Adapter);
-
-		HwRadioOff = hal_get_hw_radio_off( pHwData );
-		if (HwRadioOff)
-			psLOCAL->RadioOffStatus.boHwRadioOff = TRUE;
-		else
-			psLOCAL->RadioOffStatus.boHwRadioOff = FALSE;
-
-		hal_set_radio_mode( pHwData, (unsigned char)(psLOCAL->RadioOffStatus.boSwRadioOff || psLOCAL->RadioOffStatus.boHwRadioOff) );
-
-		// 20060703.4 Recording Adapter point. It must be here to represent the Adapter is initialized.
-		pAdapterContext[IndexTmp] = Adapter;
-
-		DriverInitializing = 0;
-		hal_driver_init_OK( pHwData ) = 1; // Notify hal that the driver is ready now.
-
-// 20060717.3 Move here due to SCAN must after hal_driver_init_OK
-#ifdef WB_WIN
-		if( TS_RUNNING_IN_TESTSTA_MODE )
-			{ TS_STARTUP( Adapter ); }
-		else
-		{
-			K_MSG	sSmeMsg;
-			SCAN_REQ_PARA	ScanReqPara;
-
-			if( !psSCAN->BScanEnable )
-			{
-				sSmeMsg.wMsgType = SMEMSG_SCAN_REQ;
-				sSmeMsg.pMsgPtr = NULL;
-				SME_Entry(Adapter, &sSmeMsg);
-				OS_SLEEP(2000000);	//2 sec 20060620.4 increase to 2
-			}
-			else	//scan only one channel to reduce the time of going to SCAN_READY state
-			{
-				memcpy(&ScanReqPara, psSCANREQ, sizeof(SCAN_REQ_PARA));
-				ScanReqPara.sChannelList.Count=1;	//only scan the first one channel
-				sme_set_bssid_list_scan(Adapter, &ScanReqPara);
-				OS_SLEEP(psSCAN->MaxChannelTime + 50000);
-				//Must guarantee the scan is completed and restore the normal scan channels
-				Scan_SetScanChanRange(Adapter, psSCANREQ);
-			}
-		}
-#endif
-
-		#ifdef _PE_STATE_DUMP_
-		WBDEBUG(("WbWlanInitialize OK\n"));
-		#endif
-
-		return NDIS_STATUS_SUCCESS;
-
-	} while (FALSE);
-
-	switch( InitStep )
-	{
-		case 6: WbNdis51_destroy( Adapter );
-		case 5: Roam_Halt( Adapter );
-		case 4: MLME_Halt( Adapter );
-				SCAN_Halt( Adapter );
-				SME_Halt( Adapter );
-		case 3: Mds_Destroy( Adapter );
-		case 2:
-		case 1: WBNDIS_Destroy( Adapter );
-				hal_halt( pHwData, NULL );
-		case 0: break;
-	}
-
-#ifdef WB_WIN
-	// Deregister the device
-	if( NdisDeviceHandle[IndexTmp] )
-		NdisMDeregisterDevice( NdisDeviceHandle[IndexTmp] );
-		NdisDeviceHandle[IndexTmp] = NULL;
-
-	WbFreeString( Adapter->WbNdis.DeviceName );
-	WbFreeString( Adapter->WbNdis.DeviceLinkUnicodeString );
-#endif
-
-	// Free Adapter memory if necessary
-	if( Adapter ) NdisFreeMemory( Adapter, sizeof(WB32_ADAPTER), 0 );
-	pAdapterContext[IndexTmp] = NULL;
-	DriverInitializing = 0;
-	return Status;
-}
-
-//==========================================================================
-//  WbReadNdisConfigration --
-//
-//  Routine Description:
-//    Reading the configration from registry. Some variable in structure
-//    Adapter will be set if there are some setting in registry.
-//    If not, the default value will be set.
-//
-//  Arguments:
-//    Adapter             - The adapter structure.
-//    ConfigurationHandle - Configuration handle
-//
-//  Return Value:
-//
-//===========================================================================
-NDIS_STATUS WbReadNdisConfigration(  PADAPTER	Adapter,  NDIS_HANDLE  ConfigurationHandle )
-{
-    NDIS_STATUS						Status;
-    NDIS_HANDLE						ConfigHandle;	// The handle for reading from the registry
-	u32							Length; // The length of networkaddress
-	void*							NetAddress; // The network address the adapter should use instead of the default address in the serial EERPOM.
-    PNDIS_CONFIGURATION_PARAMETER	ReturnedValue;  // The value read from the registry.
-	u8	i;
-
-    //
-    // String names of all the parameters that will be read.
-    //
-	NDIS_STRING PLTStr				= NDIS_STRING_CONST("PLT");
-	NDIS_STRING RatePolicyStr		= NDIS_STRING_CONST("RatePolicy");
-	NDIS_STRING RegionStr			= NDIS_STRING_CONST("Region");
-	NDIS_STRING RTSThresholdStr     = NDIS_STRING_CONST("RTSThreshold");
-	NDIS_STRING TxFragThresholdStr  = NDIS_STRING_CONST("TxFragThreshold");
-	NDIS_STRING MTUsizeStr          = NDIS_STRING_CONST("MTUsize");
-	NDIS_STRING ChannelStr			= NDIS_STRING_CONST("Channel");
-    NDIS_STRING MaxTxRateStr		= NDIS_STRING_CONST("MaxTxRate");
-	NDIS_STRING PreambleStr			= NDIS_STRING_CONST("Preamble");
-	NDIS_STRING PHYStr				= NDIS_STRING_CONST("PHY");
-	NDIS_STRING ModulationTypeStr	= NDIS_STRING_CONST("ModulationType");
-	NDIS_STRING RadioModeStr		= NDIS_STRING_CONST("Radio");
-	NDIS_STRING PwrSaveModeStr		= NDIS_STRING_CONST("PowerSave");
-	NDIS_STRING BScanStr			= NDIS_STRING_CONST("BScan");
-
-	//=================================================
-	// Open the configuration space and Reading
-	//=================================================
-	NdisOpenConfiguration( &Status, &ConfigHandle, ConfigurationHandle);
-	if( Status != NDIS_STATUS_SUCCESS )
-	{
-		Status = NDIS_ERROR_CODE_UNSUPPORTED_CONFIGURATION;
-		return Status;
-	}
-
-	// Read the software-configurable network address that was stored in the
-	// registry for a NIC when it was installed in the machine.
-	NdisReadNetworkAddress(	&Status, &NetAddress, &Length, ConfigHandle);
-	if( (Length == ETH_LENGTH_OF_ADDRESS) && (Status == NDIS_STATUS_SUCCESS) )
-		// Save the address that should be used.
-		NdisMoveMemory( Adapter->sLocalPara.ThisMacAddress, NetAddress, ETH_LENGTH_OF_ADDRESS );
-
-    // Read Product Line Test setting
-	NdisReadConfiguration( &Status, &ReturnedValue, ConfigHandle, &PLTStr, NdisParameterInteger );
-	if( Status == NDIS_STATUS_SUCCESS )
-		TS_RUNNING_IN_TESTSTA_MODE = (u8)ReturnedValue->ParameterData.IntegerData;
-
-    // Read Rate Policy setting. reading fail means that decides from eeprom
-	NdisReadConfiguration( &Status, &ReturnedValue, ConfigHandle, &RatePolicyStr, NdisParameterInteger );
-	if( Status == NDIS_STATUS_SUCCESS )
-		Adapter->sMtoPara.RatePolicy = (u8)ReturnedValue->ParameterData.IntegerData;
-
-	// Read Region setting
-	Adapter->sLocalPara.region_INF = REGION_AUTO;
-	NdisReadConfiguration( &Status, &ReturnedValue, ConfigHandle, &RegionStr, NdisParameterInteger );
-	if( Status == NDIS_STATUS_SUCCESS )
-		Adapter->sLocalPara.region_INF = (u8)ReturnedValue->ParameterData.IntegerData;
-
-    // Read MaxTxRate
-	Adapter->sLocalPara.TxRateMode = RATE_AUTO;
-	NdisReadConfiguration( &Status, &ReturnedValue, ConfigHandle, &MaxTxRateStr, NdisParameterInteger );
-	if( Status == NDIS_STATUS_SUCCESS )
-		Adapter->sLocalPara.TxRateMode = (u8)ReturnedValue->ParameterData.IntegerData;
-
-	// Read Operating mode setting
-	psLOCAL->bMacOperationMode = MODE_802_11_BG;	// B/G mode
-	NdisReadConfiguration( &Status, &ReturnedValue, ConfigHandle, &ModulationTypeStr, NdisParameterInteger );
-	if( Status == NDIS_STATUS_SUCCESS )
-		psLOCAL->bMacOperationMode = (u8)ReturnedValue->ParameterData.IntegerData;
-
-    // Read IBSS Channel setting
-	NdisReadConfiguration( &Status, &ReturnedValue, ConfigHandle, &ChannelStr, NdisParameterInteger );
-	if( Status == NDIS_STATUS_SUCCESS )
-	{
-		if (ReturnedValue->ParameterData.IntegerData == 0)	//AUTO
-		{
-			Adapter->sLocalPara.IbssChanSetting.band = 0;
-			Adapter->sLocalPara.IbssChanSetting.ChanNo = 0;
-		}
-		else
-		{
-			if (ReturnedValue->ParameterData.IntegerData >= 3000)
-				Adapter->sLocalPara.IbssChanSetting.band = BAND_TYPE_OFDM_5;
-			else
-				Adapter->sLocalPara.IbssChanSetting.band = BAND_TYPE_OFDM_24;
-			FreqToChannelNum(Adapter->sLocalPara.IbssChanSetting.band,
-								&Adapter->sLocalPara.IbssChanSetting.ChanNo,
-								ReturnedValue->ParameterData.IntegerData);
-		}
-	}
-
-	// Read RTSThreshold setting
-	Adapter->Mds.TxRTSThreshold = DEFAULT_RTSThreshold;
-	NdisReadConfiguration( &Status, &ReturnedValue, ConfigHandle, &RTSThresholdStr, NdisParameterInteger );
-	if( Status == NDIS_STATUS_SUCCESS )
-		Adapter->Mds.TxRTSThreshold = (u16)ReturnedValue->ParameterData.IntegerData;
-
-	// Read Tx Fragmentation Threshold setting
-	Adapter->Mds.TxFragmentThreshold = DEFAULT_FRAGMENT_THRESHOLD;
-	NdisReadConfiguration( &Status, &ReturnedValue, ConfigHandle, &TxFragThresholdStr, NdisParameterInteger );
-	if( Status == NDIS_STATUS_SUCCESS )
-		Adapter->Mds.TxFragmentThreshold = (u16)ReturnedValue->ParameterData.IntegerData;
-
-	// Read PHY type setting
-	NdisReadConfiguration( &Status, &ReturnedValue, ConfigHandle, &PHYStr, NdisParameterInteger );
-	i = (Status == NDIS_STATUS_SUCCESS) ? (u8)ReturnedValue->ParameterData.IntegerData : RF_WB_242_1;
-	hal_set_phy_type( &Adapter->sHwData, i );
-
-	// support the MTU size reading
-	Adapter->sLocalPara.MTUsize = MAX_ETHERNET_PACKET_SIZE;
-	NdisReadConfiguration( &Status, &ReturnedValue, ConfigHandle, &MTUsizeStr, NdisParameterInteger );
-	if( Status == NDIS_STATUS_SUCCESS )
-		Adapter->sLocalPara.MTUsize = ReturnedValue->ParameterData.IntegerData;
-
-	// Read Preamble mode setting
-	psLOCAL->bPreambleMode = AUTO_MODE;
-	NdisReadConfiguration( &Status, &ReturnedValue, ConfigHandle, &PreambleStr, NdisParameterInteger );
-	if( Status == NDIS_STATUS_SUCCESS )
-		psLOCAL->bPreambleMode = (u8)ReturnedValue->ParameterData.IntegerData;
-
-    // Read Radio On/Off setting
-	Adapter->sLocalPara.RadioOffStatus.boSwRadioOff = FALSE;
-	NdisReadConfiguration( &Status, &ReturnedValue, ConfigHandle, &RadioModeStr, NdisParameterInteger );
-	////Radio on : 0, Radio off : 1
-	if( Status == NDIS_STATUS_SUCCESS )
-		Adapter->sLocalPara.RadioOffStatus.boSwRadioOff = (u8)ReturnedValue->ParameterData.IntegerData;
-
-    // Read power save mode setting
-	psSME->bDesiredPowerSave = FALSE;
-	NdisReadConfiguration( &Status, &ReturnedValue, ConfigHandle, &PwrSaveModeStr, NdisParameterInteger );
-	//0: PWR_ACTIVE, 1: PWR_SAVE
-	if( Status == NDIS_STATUS_SUCCESS )
-		psSME->bDesiredPowerSave = (u8)ReturnedValue->ParameterData.IntegerData;
-
-	// Read Background scan setting
-	psSCAN->BScanEnable = TRUE;
-	NdisReadConfiguration( &Status, &ReturnedValue, ConfigHandle, &BScanStr, NdisParameterInteger );
-	//0: Disable for HCT testing, 1: Enable
-	if( Status == NDIS_STATUS_SUCCESS )
-		psSCAN->BScanEnable = (u32)ReturnedValue->ParameterData.IntegerData;
-
-	//=================================================
-	// Close the configuration space. Reading Completed
-	//=================================================
-	NdisCloseConfiguration( ConfigHandle );
-
-	return NDIS_STATUS_SUCCESS;
-}
-
-
-//=========================================================================
-//  WbWLanHalt --
-//
-//  Description:
-//    Called when the NIC is removed and halts the NIC to deallocate the
-//    resources.
-//    In effect, MiniportHalt undoes everything that was done 
-//    by MiniportInitialize for a particular NIC. 
-//    MiniportHalt function should call reciprocal NdisXxx functions 
-//	  in inverse order to the calls the driver made from MiniportInitialize
-//
-//  Arguments:
-//    MiniportAdapterContext - Context registered with the wrapper, really
-//                             a pointer to the adapter.
-//
-//  Return:
-//    None.
-//=========================================================================
-extern
-void WbWLanHalt( NDIS_HANDLE MiniportAdapterContext)
-{
-    PWB32_ADAPTER  Adapter = (PWB32_ADAPTER) MiniportAdapterContext;
-	phw_data_t pHwData = &Adapter->sHwData;
-	u32	IndexTmp = Adapter->AdapterIndex;
-
-	#ifdef _PE_STATE_DUMP_
-	WBDEBUG(("[%d]WbWlanHalt\n",IndexTmp));
-	#endif
-
-	// 20060712.6 move here is better for disable Dispatch operation
-	#ifdef WB_WIN
-	if( NdisDeviceHandle[IndexTmp] )
-		NdisMDeregisterDevice( NdisDeviceHandle[IndexTmp] );
-	NdisDeviceHandle[IndexTmp] = NULL;
-	
-	WbFreeString( Adapter->WbNdis.DeviceName );
-	WbFreeString( Adapter->WbNdis.DeviceLinkUnicodeString );
-	#endif
-
-	// 20060712.1 Add
-	pHwData->SurpriseRemove = 1;
-	OS_SET_SHUTDOWN( Adapter ); // 20060421.1 Add
-	OS_SLEEP(100000); // Wait for awhile. Must great than delay in callback_scheduler
-	while( hal_detect_error( pHwData ) )
-		OS_SLEEP(50000);
-
-	// Halt procedure start..
-	hal_surprise_remove( pHwData );
-	Adapter->sLocalPara.ShutDowned = TRUE;
-	WbNdis51_destroy( Adapter );
-
-	Mds_Destroy( Adapter );
-
-    // Halt
-	Roam_Halt(Adapter);
- 	SCAN_Halt(Adapter);
-	MLME_Halt(Adapter);
-    SME_Halt(Adapter);
-
-	// For Ts module unload
-	TS_destroy( Adapter );
-	// Turn off Rx and Tx hardware ability
-	hal_stop( pHwData );
-
-	// Destroy the NDIS module
-	WBNDIS_Destroy( Adapter );
-	// Halt the HAL
-	hal_halt( pHwData, NULL );
-
-    // Free up the device context
-	NdisFreeMemory(Adapter, sizeof(WB32_ADAPTER), 0);
-	pAdapterContext[IndexTmp] = NULL; // 20051228 move here
-	NdisInterlockedDecrement( &AdapterCounter );
-}
-
-//===========================================================================
-//  WbWLanReset --
-//
-//  Routine Description:
-//    The WBWLanReset request instructs the miniport to issue a hardware reset
-//    to the network adapter.  The driver also resets its software state.  See
-//    the description of miniportMReset for a detailed description.
-//
-//  Arguments:
-//    AddressingReset        - Does the adapter need reload to the address.
-//    MiniportAdapterContext - Pointer to the adapter structure.
-//
-//  Return Value:
-//    The function value is the status of the operation.
-//============================================================================
-NDIS_STATUS
-WbWLanReset(  PBOOLEAN AddressingReset,  NDIS_HANDLE MiniportAdapterContext )
-{
-	return NDIS_STATUS_SUCCESS;
-}
-
-//==========================================================================
-//  WbWLanQueryInformation --
-//
-//  Routine Description:
-//    The WBWLanQueryInformation process a Query request for NDIS_OIDs that
-//    are specific about the Driver.
-//
-//  Arguments:
-//    MiniportAdapterContext  - The pointer to the adapter.
-//    Oid                     - The NDIS_OID to process.
-//    InformationBuffer       - Points to a buffer in which MiniportQuery-
-//                              Information should return the OID-specific
-//                              information.
-//    InformationBufferLength - Specifies the number of bytes at Information-
-//                              Buffer.
-//    BytesWritten            - Points to a variable that MiniportQuery-
-//                              Information sets to the number of bytes it is
-//                              returning at InformationBuffer.
-//    BytesNeeded             - If there is not enough room in the information
-//                              buffer then this will contain the number of
-//                              bytes needed to complete the request.
-//
-//  Return Value:
-//    The function value is the status of the operation.
-//===========================================================================
-NDIS_STATUS
-WbWLanQueryInformation( NDIS_HANDLE MiniportAdapterContext,
-                        NDIS_OID Oid,
-                        void* InformationBuffer,
-                        u32 InformationBufferLength,
-                        PULONG BytesWritten,
-                        PULONG BytesNeeded)
-{
-
-    PWB32_ADAPTER			Adapter = (PWB32_ADAPTER) MiniportAdapterContext;
-    PUCHAR					InfoBuffer = (PUCHAR) InformationBuffer;
-    NDIS_STATUS				StatusToReturn = NDIS_STATUS_SUCCESS;
-    NDIS_HARDWARE_STATUS	HardwareStatus;
-    NDIS_MEDIUM				Medium = NdisMedium802_3;
-    u64					GenericULong64;//901018
-    u32					GenericULong;
-    u16					GenericUShort;
-    u8					GenericArray[6];
-    u32					MoveBytes = sizeof(u32);
-    void*					MoveSource = (void*)(&GenericULong);
-#ifdef WB_CE
-	NDIS_PNP_CAPABILITIES	ndis_pnp_capablities;
-#endif
-
-// 20060706.1 Remove for safety
-	if( Oid & 0x800000 )
-	{
-		Oid &= ~0x800000;
-		return WbWLanSetInformation( MiniportAdapterContext,
-									 Oid,
-									 InformationBuffer,
-									 InformationBufferLength,
-									 BytesWritten,
-									 BytesNeeded );
-	}
-
-    //-------------------------------------------------------------------------------------
-    // Make sure that int is 4 bytes.  Else GenericULong must change to something of size 4.
-    //-------------------------------------------------------------------------------------
-    *BytesWritten = 0;
-    *BytesNeeded  = 0;
-
-	#ifdef _PE_OID_DUMP_
-	WBDEBUG(("Query "));
-	DbgPrintfOID(Oid);
-	#endif
-
-    //============================================
-    // Switch on request type
-    //============================================
-    switch (Oid) {
-#ifdef WB_CE		//20051230.4 add
-	case OID_PNP_QUERY_POWER:
-		break;
-	case OID_PNP_CAPABILITIES:
-		ndis_pnp_capablities.WakeUpCapabilities.MinMagicPacketWakeUp    = NdisDeviceStateD0;
-		ndis_pnp_capablities.WakeUpCapabilities.MinPatternWakeUp        = NdisDeviceStateD0;
-		ndis_pnp_capablities.WakeUpCapabilities.MinLinkChangeWakeUp     = NdisDeviceStateD0;
-		MoveSource        = (void*)&ndis_pnp_capablities; 
-		MoveBytes  = sizeof(ndis_pnp_capablities);
-		break;
-#endif
-	case OID_GEN_CURRENT_PACKET_FILTER:
-		GenericULong = Adapter->Mds.PacketFilter;
-		break;
-    case OID_GEN_MAC_OPTIONS:
-        GenericULong = (u32)(NDIS_MAC_OPTION_TRANSFERS_NOT_PEND  |
-                               NDIS_MAC_OPTION_COPY_LOOKAHEAD_DATA |
-                               NDIS_MAC_OPTION_NO_LOOPBACK);
-        break;
-    case OID_GEN_SUPPORTED_LIST:
-        MoveSource = (void*)WbWLanSupportedOids;
-        MoveBytes  = sizeof(WbWLanSupportedOids);
-        break;
-    case OID_GEN_HARDWARE_STATUS:
-		HardwareStatus = NdisHardwareStatusReady;
-        MoveSource     = (void*)(&HardwareStatus);
-        MoveBytes      = sizeof(NDIS_HARDWARE_STATUS);
-        break;
-    case OID_GEN_MEDIA_SUPPORTED:
-    case OID_GEN_MEDIA_IN_USE:
-        MoveSource = (void*)&Medium;
-        MoveBytes  = sizeof(NDIS_MEDIUM);
-        break;
-    case OID_GEN_MEDIA_CONNECT_STATUS: 
-		GenericULong = NdisMediaStateConnected;
-        if( Adapter->WbNdis.connect_status == NDIS_STATUS_MEDIA_DISCONNECT )
-			GenericULong = NdisMediaStateDisconnected;
-        break;
-    case OID_GEN_MAXIMUM_SEND_PACKETS:
-        GenericULong = 1;
-        break;
-    case OID_GEN_VENDOR_DRIVER_VERSION:
-        GenericULong = ( (u32)WB32_DRIVER_MAJOR_VERSION << 16) | WB32_DRIVER_MINOR_VERSION;
-		if( Adapter->WbNdis.DisconnectIndicate == 0 )
-		{
-			OS_CONNECT_STATUS_INDICATE( Adapter, OS_DISCONNECTED );
-			Adapter->WbNdis.DisconnectIndicate = 1;
-		}
-        break;
-    case OID_GEN_MAXIMUM_LOOKAHEAD:
-    case OID_GEN_CURRENT_LOOKAHEAD:
-        GenericULong = Adapter->sLocalPara.MTUsize - ETHERNET_HEADER_SIZE;
-        break;
-    case OID_GEN_MAXIMUM_FRAME_SIZE:
-        GenericULong = Adapter->sLocalPara.MTUsize - ETHERNET_HEADER_SIZE;
-        break;
-    case OID_GEN_LINK_SPEED:
-		GenericULong = Adapter->WbNdis.TxRateShowResult * 5000;
-        break;
-    case OID_GEN_TRANSMIT_BUFFER_SPACE:
-        GenericULong = ETHERNET_TX_DESCRIPTORS * MAX_USB_TX_BUFFER;
-        break;
-    case OID_GEN_RECEIVE_BUFFER_SPACE:
-        GenericULong = ETHERNET_RX_DESCRIPTORS * MAX_USB_RX_BUFFER;
-        break;
-    case OID_GEN_MAXIMUM_TOTAL_SIZE:
-    case OID_GEN_TRANSMIT_BLOCK_SIZE:
-    case OID_GEN_RECEIVE_BLOCK_SIZE:
-        GenericULong = Adapter->sLocalPara.MTUsize;
-        break;
-    case OID_GEN_VENDOR_ID:
-        NdisMoveMemory( (void*)&GenericULong, (PUCHAR)(&Adapter->sLocalPara.PermanentAddress), 3 );
-        GenericULong &= 0x00FFFFFF;
-        break;
-    case OID_GEN_VENDOR_DESCRIPTION:
-        MoveSource = (void*)"IS89C35 USB20 802.11bg Wireless LAN Adapter Driver";
-        MoveBytes  = 52;
-        break;
-    case OID_GEN_DRIVER_VERSION:
-        GenericUShort = ((u16)WB32_NDIS_MAJOR_VERSION << 8) | WB32_NDIS_MINOR_VERSION;
-        MoveSource    = (void*)&GenericUShort;
-        MoveBytes     = sizeof(GenericUShort);
-        break;
-    case OID_802_3_PERMANENT_ADDRESS:
-        NdisMoveMemory( (PCHAR)GenericArray, Adapter->sLocalPara.PermanentAddress, ETH_LENGTH_OF_ADDRESS );
-        MoveSource = (void*)GenericArray;
-        MoveBytes  = ETH_LENGTH_OF_ADDRESS;
-        break;
-    case OID_802_3_CURRENT_ADDRESS:
-        NdisMoveMemory( (PCHAR)GenericArray, Adapter->sLocalPara.ThisMacAddress, ETH_LENGTH_OF_ADDRESS );
-        MoveSource = (void*)GenericArray;
-        MoveBytes  = ETH_LENGTH_OF_ADDRESS;
-        break;
-    case OID_802_3_MAXIMUM_LIST_SIZE:
-        GenericULong = 32;
-        break;
-    case OID_GEN_XMIT_OK:
-		GenericULong64 = Adapter->sLocalPara.GS_XMIT_OK;
-		MoveSource = (void*) &GenericULong64;
-		*BytesNeeded = sizeof(u64);
-		if( (InformationBufferLength == 0) || InformationBufferLength >= sizeof(u64) )
-		{
-			MoveBytes = sizeof(u64);
-			break;
-		}
-		break;
-    case OID_GEN_RCV_OK:
-		GenericULong64 = Adapter->sLocalPara.GS_RCV_OK;
-		MoveSource = (void*) &GenericULong64;
-		*BytesNeeded = sizeof(u64);
-		if ((InformationBufferLength == 0) || InformationBufferLength >= sizeof(u64)) {
-			MoveBytes = sizeof(u64);
-			break;
-		}
-        break;
-    case OID_GEN_RCV_ERROR:
-        GenericULong = Adapter->sLocalPara.GS_RCV_ERROR;
-        break;
-    case OID_GEN_XMIT_ERROR:
-        GenericULong = Adapter->sLocalPara.GS_XMIT_ERROR;
-        break;
-    case OID_GEN_RCV_NO_BUFFER:
-        GenericULong = Adapter->sLocalPara.GS_RCV_NO_BUFFER;
-        break;
-    case OID_802_3_XMIT_ONE_COLLISION:
-        GenericULong = Adapter->sLocalPara.GS_XMIT_ONE_COLLISION;
-        break;
-    case OID_802_3_XMIT_MORE_COLLISIONS:
-        GenericULong = Adapter->sLocalPara.GS_XMIT_MORE_COLLISIONS;
-        break;
-    default:
-        StatusToReturn = WB_NDIS_STATUS_NOT_SUPPORTED;
-        break;
-    }
-
-	if( StatusToReturn == WB_NDIS_STATUS_NOT_SUPPORTED )
-	{
-		MoveSource = InfoBuffer;
-		StatusToReturn = Ndis51QueryInformation( Adapter,
-												 Oid,
-												 InformationBuffer,
-												 InformationBufferLength,
-												 &MoveBytes);
-	}
-
-	if( StatusToReturn == NDIS_STATUS_SUCCESS )
-	{
-		if( MoveBytes > InformationBufferLength )
-		{
-			//------- Not enough room in InformationBuffer. Punt
-			*BytesNeeded   = MoveBytes;
-			StatusToReturn = NDIS_STATUS_INVALID_LENGTH;
-		} 
-        else
-		{
-			//----------- Store result.
-			NdisMoveMemory(InfoBuffer, MoveSource, MoveBytes);
-			*BytesWritten  = MoveBytes;
-		}
-	}
-
-	return StatusToReturn;
-}
-
-//==========================================================================
-//  WbWLanSetInformation --
-//
-//  Routine Description:
-//    Handles a set operation for a single OID.
-//
-//  Arguments:
-//    MiniportAdapterContext  - Context registered with the wrapper, really
-//                              a pointer to the adapter.
-//    Oid                     - The OID of the set operation.
-//    InformationBuffer       - Holds the data to be set.
-//    InformationBufferLength - The number of bytes at InformationBuffer.
-//    BytesRead               - If the call is successful, returns the number
-//                              of bytes read from InformationBuffer.
-//    BytesNeeded             - If there is not enough data in InformationBuffer
-//                              to satisfy the OID, returns the amount of
-//                              storage needed.
-//
-//  Return Value:
-//    NDIS_STATUS_SUCCESS
-//    NDIS_STATUS_PENDING
-//    NDIS_STATUS_INVALID_LENGTH
-//    NDIS_STATUS_INVALID_OID
-//==========================================================================
-
-NDIS_STATUS 
-WbWLanSetInformation(  NDIS_HANDLE MiniportAdapterContext,
-                       NDIS_OID    Oid,
-                       void*       InformationBuffer,
-                       u32       InformationBufferLength,
-                      PULONG      BytesRead,
-                      PULONG      BytesNeeded)
-{
-	PWB32_ADAPTER	Adapter = (PWB32_ADAPTER) MiniportAdapterContext;
-	u32			BytesLeft       = InformationBufferLength;
-	PUCHAR			InfoBuffer      = (PUCHAR)(InformationBuffer);
-	NDIS_STATUS		StatusToReturn;
-	u32			ltmp;
-	u8			ctmp;
-
-
-	//--------------------------------------------
-	// Get Oid and Length of request
-	//--------------------------------------------
-
-	#ifdef _PE_OID_DUMP_
-	WBDEBUG(("Setting "));
-	DbgPrintfOID(Oid);
-	#endif
-
-
-	StatusToReturn = NDIS_STATUS_SUCCESS;
-	*BytesRead = InformationBufferLength;
-	*BytesNeeded = 0;
-
-
-    switch (Oid)
-	{
-#ifdef WB_CE
-		case OID_PNP_SET_POWER:
-			hal_system_power_change( &Adapter->sHwData, *(PULONG)InfoBuffer ); // 20051230.4 0=D0 1=D1 ..
-			break;
-#endif
-		case OID_802_3_MULTICAST_LIST:
-
-			// Verify length
-			if( (InformationBufferLength % ETH_LENGTH_OF_ADDRESS) != 0 )
-			{
-				StatusToReturn = NDIS_STATUS_INVALID_LENGTH;
-				break;
-			}
-
-			// Get the number of the list
-			Adapter->Mds.MulticastListNo = InformationBufferLength / ETH_LENGTH_OF_ADDRESS;
-
-			// Set the new list on the adapter.
-			NdisMoveMemory( (PUCHAR)(Adapter->Mds.MulticastAddressesArray), InfoBuffer, InformationBufferLength );
-
-			hal_set_multicast_address( &Adapter->sHwData,
-									   (PUCHAR)Adapter->Mds.MulticastAddressesArray,
-									   (u8)Adapter->Mds.MulticastListNo );
-			break;
-
-		case OID_GEN_CURRENT_PACKET_FILTER:
-
-			// Verify length
-			if( InformationBufferLength != 4 )
-			{
-				StatusToReturn  = NDIS_STATUS_INVALID_LENGTH;
-				break;
-			}
-
-			NdisMoveMemory( &ltmp, InfoBuffer, 4 );
-
-			// Verify bits
-			if( ltmp & ~( NDIS_PACKET_TYPE_DIRECTED		|
-						  NDIS_PACKET_TYPE_MULTICAST	|
-						  NDIS_PACKET_TYPE_PROMISCUOUS	|
-						  NDIS_PACKET_TYPE_BROADCAST	) )
-			{
-				StatusToReturn  = WB_NDIS_STATUS_NOT_SUPPORTED;
-				break;
-			}
-
-			ctmp = (ltmp & NDIS_PACKET_TYPE_BROADCAST) ? 1 : 0;
-			hal_set_accept_broadcast( &Adapter->sHwData, ctmp );
-
-			ctmp = (ltmp & NDIS_PACKET_TYPE_MULTICAST) ? 1 : 0;
-			hal_set_accept_multicast( &Adapter->sHwData, ctmp );
-
-			// Set the new value to the adapter.
-			Adapter->Mds.PacketFilter = ltmp;
-
-			break;
-
-		case OID_GEN_CURRENT_LOOKAHEAD:
-
-			// Verify length
-			NdisMoveMemory( &ltmp, InfoBuffer, 4 );
-			if( InformationBufferLength!=4 || ltmp>Adapter->sLocalPara.MTUsize )
-				StatusToReturn = NDIS_STATUS_INVALID_LENGTH;
-
-			break;
-
-		default:
-
-			StatusToReturn = WB_NDIS_STATUS_NOT_SUPPORTED;
-	}
-
-	if( StatusToReturn == WB_NDIS_STATUS_NOT_SUPPORTED )
-	{
-		StatusToReturn = Ndis51SetInformation( Adapter,
-											   Oid,
-											   InformationBuffer,
-											   InformationBufferLength,
-											   BytesNeeded);
-
-		if( *BytesNeeded )
-			StatusToReturn = NDIS_STATUS_INVALID_LENGTH;
-	}
-
-    if( StatusToReturn != NDIS_STATUS_SUCCESS && StatusToReturn != NDIS_STATUS_PENDING )
-        *BytesRead = 0;
-
-    return StatusToReturn;
-}
-
-
-// *************************************************************************************************************************
-#ifdef _PE_OID_DUMP_
-void DbgPrintfOID(NDIS_OID Oid)
-{
-    //=======================
-    // Print information 
-    //=======================
-    switch (Oid) {
-		//----------------- NDIS information ----------------
-		case OID_GEN_MAC_OPTIONS:
-				WBDEBUG(("OID_GEN_MAC_OPTIONS\n"));
-				break;
-		case OID_GEN_SUPPORTED_LIST:
-				WBDEBUG(("OID_GEN_SUPPORTED_LIST\n"));
-				break;
-		case OID_GEN_MEDIA_SUPPORTED:
-				WBDEBUG(("OID_GEN_MEDIA_SUPPORTED\n"));
-				break;
-		case OID_GEN_MEDIA_IN_USE:
-				WBDEBUG(("OID_GEN_MEDIA_IN_USE\n"));
-				break;
-		case OID_GEN_MAXIMUM_SEND_PACKETS:
-				WBDEBUG(("OID_GEN_MAXIMUM_SEND_PACKETS\n"));
-				break;
-		case OID_GEN_VENDOR_DRIVER_VERSION: // from version.h
-				WBDEBUG(("OID_GEN_VENDOR_DRIVER_VERSION\n"));
-				break;
-		case OID_GEN_MAXIMUM_TOTAL_SIZE:
-				WBDEBUG(("OID_GEN_MAXIMUM_TOTAL_SIZE\n"));
-				break;
-		case OID_GEN_TRANSMIT_BLOCK_SIZE:
-				WBDEBUG(("OID_GEN_TRANSMIT_BLOCK_SIZE\n"));
-				break;
-		case OID_GEN_RECEIVE_BLOCK_SIZE:
-				WBDEBUG(("OID_GEN_RECEIVE_BLOCK_SIZE\n"));
-				break;
-		case OID_GEN_MAXIMUM_LOOKAHEAD:
-				WBDEBUG(("OID_GEN_MAXIMUM_LOOKAHEAD\n"));
-				break;
-		case OID_GEN_CURRENT_LOOKAHEAD:
-				WBDEBUG(("OID_GEN_CURRENT_LOOKAHEAD\n"));
-				break;
-		case OID_GEN_MAXIMUM_FRAME_SIZE:
-				WBDEBUG(("OID_GEN_MAXIMUM_FRAME_SIZE\n"));
-				break;
-		case OID_GEN_TRANSMIT_BUFFER_SPACE:
-				WBDEBUG(("OID_GEN_TRANSMIT_BUFFER_SPACE\n"));
-				break;
-		case OID_GEN_RECEIVE_BUFFER_SPACE:
-				WBDEBUG(("OID_GEN_RECEIVE_BUFFER_SPACE\n"));
-				break;
-		case OID_GEN_VENDOR_ID:
-				WBDEBUG(("OID_GEN_VENDOR_ID\n"));
-				break;
-		case OID_GEN_VENDOR_DESCRIPTION:
-				WBDEBUG(("OID_GEN_VENDOR_DESCRIPTION\n"));
-				break;
-		case OID_GEN_DRIVER_VERSION:
-				WBDEBUG(("OID_GEN_DRIVER_VERSION\n"));
-				break;
-		// Hardware status --------------------------------------------------------------------//
-		case OID_GEN_HARDWARE_STATUS:
-				WBDEBUG(("OID_GEN_HARDWARE_STATUS\n"));
-				break;
-		case OID_GEN_LINK_SPEED:
-				//WBDEBUG(("OID_GEN_LINK_SPEED\n"));
-				break;
-		case OID_GEN_MEDIA_CONNECT_STATUS:
-				WBDEBUG(("OID_GEN_MEDIA_CONNECT_STATUS\n"));
-				break;
-		case OID_802_3_PERMANENT_ADDRESS:
-				WBDEBUG(("OID_802_3_PERMANENT_ADDRESS\n"));
-				break;
-		case OID_802_3_CURRENT_ADDRESS:
-				WBDEBUG(("OID_802_3_CURRENT_ADDRESS\n"));
-				break;
-		case OID_802_3_MAXIMUM_LIST_SIZE:
-				WBDEBUG(("OID_802_3_MAXIMUM_LIST_SIZE\n"));
-				break;
-
-		// General Statistics ------------------------------------------------------------//
-		case OID_GEN_XMIT_OK:
-				//WBDEBUG(("OID_GEN_XMIT_OK\n"));
-				break;
-		case OID_GEN_RCV_OK:
-				//WBDEBUG(("OID_GEN_RCV_OK\n"));
-				break;
-		case OID_GEN_RCV_ERROR:
-				//WBDEBUG(("OID_GEN_RCV_ERROR\n"));
-				break;
-		case OID_GEN_XMIT_ERROR:
-				//WBDEBUG(("OID_GEN_XMIT_ERROR\n"));
-				break;
-		case OID_GEN_RCV_NO_BUFFER:
-				WBDEBUG(("OID_GEN_RCV_NO_BUFFER\n"));
-				break;
-		case OID_802_3_RCV_ERROR_ALIGNMENT:
-				WBDEBUG(("OID_802_3_RCV_ERROR_ALIGNMENT\n"));
-				break;
-		case OID_802_3_XMIT_ONE_COLLISION:
-				WBDEBUG(("OID_802_3_XMIT_ONE_COLLISION\n"));
-				break;
-		case OID_802_3_XMIT_MORE_COLLISIONS:
-				WBDEBUG(("OID_802_3_XMIT_MORE_COLLISIONS\n"));
-				break;
-		default:
-				//WBDEBUG(("NONE\n"));
-				break;
-    }
-}
-#endif // _PE_OID_DUMP_
-
-
-
+/* No windows code needed...? */

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
