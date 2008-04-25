Return-Path: <linux-kernel-owner+w=401wt.eu-S1760453AbYDYLm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760453AbYDYLm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 07:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761758AbYDYLmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 07:42:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:54364 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761596AbYDYLmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 07:42:02 -0400
Date: Fri, 25 Apr 2008 13:42:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com, linux-wireless@vger.kernel.org
Subject: w35und: remove unused parts of wbhal.c
Message-ID: <20080425114244.GO14903@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove unused parts of wbhal.c

---
commit f2b3c87836825f5c8edbd3e1f9dd23f1154d5feb
tree 3e8c492905baf11d5526a03150b2856b31b60031
parent c706b0c0bdb700920b7679afad37a397e9e30bf3
author Pavel <pavel@amd.ucw.cz> Fri, 25 Apr 2008 13:41:41 +0200
committer Pavel <pavel@amd.ucw.cz> Fri, 25 Apr 2008 13:41:41 +0200

 drivers/net/wireless/winbond/winbondport/wbhal.c |  348 ----------------------
 1 files changed, 0 insertions(+), 348 deletions(-)

diff --git a/drivers/net/wireless/winbond/winbondport/wbhal.c b/drivers/net/wireless/winbond/winbondport/wbhal.c
index 439023c..6cdc162 100644
--- a/drivers/net/wireless/winbond/winbondport/wbhal.c
+++ b/drivers/net/wireless/winbond/winbondport/wbhal.c
@@ -1,13 +1,5 @@
 #include "os_common.h"
 
-
-
-void hal_start_tx0(phw_data_t pHwData)
-{
-	if (!pHwData->SurpriseRemove)
-		Wb35Tx_start( pHwData );
-}
-
 void hal_get_ethernet_address( phw_data_t pHwData, PUCHAR current_address )
 {
 	if( pHwData->SurpriseRemove ) return;
@@ -42,7 +34,6 @@ u8 hal_init_hardware(phw_data_t pHwData,
 	pHwData->Adapter = Adapter;
 
 	// Initial the variable
-	pHwData->mapping_key_replace_index = MAPPING_KEY_START_INDEX; // Setting the default mapping key index
 	pHwData->MaxReceiveLifeTime = DEFAULT_MSDU_LIFE_TIME; // Setting Rx maximum MSDU life time
 	pHwData->FragmentThreshold = DEFAULT_FRAGMENT_THRESHOLD; // Setting default fragment threshold
 
@@ -97,72 +88,6 @@ void hal_halt(phw_data_t pHwData, void *
 	}
 }
 
-void
-hal_set_power_save_mode(phw_data_t pHwData, unsigned char power_save, unsigned char wakeup,  unsigned char dtim )
-{
-	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
-	u32		Value;
-
-	if( pHwData->SurpriseRemove ) return;
-
-	// Power save setting
-	pWb35Reg->M24_MacControl &= ~0x0200c000;	//clear ps-poll and pwr active/save bits
-
-	if (power_save) {
-		pWb35Reg->M24_MacControl |= 0x02004000;	//enable ps-poll and pwr save
-	} else {
-		// Force MAC active
-		pWb35Reg->M24_MacControl |= 0x8000;
-		dtim = 0; // Reset dtim set
-	}
-
-	// Receive DTIM set
-	pHwData->dtim = dtim;
-	pWb35Reg->M24_MacControl &= ~0x00002000;
-	if (pHwData->dtim)
-		pWb35Reg->M24_MacControl |= 0x00002000;
-
-	Value = pWb35Reg->M24_MacControl;
-	//M24_MacControl should not record the bits FMACA(force active), FMACPS(force power save)
-	//These h/w bits will be cleared after set. If the s/w M24_MacControl records them, other places
-	//set M24 will set them again. The NULL packets will be sent by h/w.
-	pWb35Reg->M24_MacControl &= ~0x0000c000;
-	// Writing into M24
-	Wb35Reg_Write( pHwData, 0x0824, Value );
-}
-
-//----------------------------------------------------------------------------------
-void hal_get_power_save_mode(  phw_data_t pHwData,   PBOOLEAN pin_pwr_save )
-{
-	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
-
-	if( pHwData->SurpriseRemove ) return;
-
-	Wb35Reg_Read( pHwData, 0x084c, &pWb35Reg->M4C_MacStatus );
-	pHwData->power_save_point = pin_pwr_save;
-}
-
-void hal_set_slot_time( phw_data_t pHwData,  u8 type )
-{
-	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
-
-	if( pHwData->SurpriseRemove ) return;
-
-	// Slot time setting
-	pHwData->slot_time_select =  20; // default set to long
-	pWb35Reg->M78_ERPInformation &= ~0x8; // the same setting in ERP
-	if( WLAN_SLOT_TIME_TYPE_SHORT == type )
-	{
-		pHwData->slot_time_select =  9; // Set to short slot time
-		pWb35Reg->M78_ERPInformation |= 0x8; // the sam setting in ERP
-	}
-
-	pWb35Reg->M40_MacControl &= ~0x3f;
-	pWb35Reg->M40_MacControl |= pHwData->slot_time_select;
-	Wb35Reg_Write( pHwData, 0x0840, pWb35Reg->M40_MacControl );
-
-	Wb35Reg_Write( pHwData, 0x0878, pWb35Reg->M78_ERPInformation );
-}
 //---------------------------------------------------------------------------------------------------
 void hal_set_rates(phw_data_t pHwData, PUCHAR pbss_rates, 
 		   u8 length, unsigned char basic_rate_set)
@@ -247,109 +172,8 @@ void hal_set_rates(phw_data_t pHwData, P
 	pWb35Reg->M78_ERPInformation |= tmp;
 	Wb35Reg_Write( pHwData, 0x0878, pWb35Reg->M78_ERPInformation );
 }
-//---------------------------------------------------------------------------------------------------
-void hal_start_bss(  phw_data_t pHwData,  u8 mac_op_mode )
-{
-	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
-
-	if( pHwData->SurpriseRemove ) return;
-
-	pHwData->bss_type = 1; // Default set to Infrastructure
-	if( mac_op_mode == WLAN_BSSTYPE_INDEPENDENT )
-		pHwData->bss_type = 0; // IBSS
-
-	// Start bss
-	pWb35Reg->M24_MacControl &= ~0xf0000000; // Clear the bit mask
-	if( !pHwData->bss_type )
-		pWb35Reg->M24_MacControl |= 0x40000000; //IBSS mode
-
-	pWb35Reg->M24_MacControl |= 0x20000000; // Start BSS or IBSS bit
-	Wb35Reg_Write( pHwData, 0x0824, pWb35Reg->M24_MacControl );
-}
-//---------------------------------------------------------------------------------------------------
-void hal_join_request(  phw_data_t pHwData,  u8 bss_type )
-{
-	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
-
-	if( pHwData->SurpriseRemove ) return;
-
-	pHwData->IsWaitJoinComplete = TRUE;
-
-	pHwData->bss_type = 1; // Default set to Infrastructure
-
-	if( bss_type == WLAN_BSSTYPE_INDEPENDENT )
-		pHwData->bss_type = 0; // IBSS
-
-	// Join BSS or IBSS request
-	pWb35Reg->M24_MacControl &= ~0xf0000000; // Clear the bit mask
-	if( !pHwData->bss_type )
-		pWb35Reg->M24_MacControl |= 0x40000000; //IBSS mode
-
-	pWb35Reg->M24_MacControl |= 0x10000000; // Join request bit
-	Wb35Reg_Write( pHwData, 0x0824, pWb35Reg->M24_MacControl ); 
-
-	#ifdef _PE_STATE_DUMP_
-	WBDEBUG(("The join channel is %d\n", Adapter->sHwData.Channel));
-	#endif
-}
-//---------------------------------------------------------------------------------------------------
-void hal_stop_sync_bss(  phw_data_t pHwData )
-{
-	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
-
-	if( pHwData->SurpriseRemove ) return;
-
-	pWb35Reg->M24_MacControl &= ~0x30000000; // clear STASS and JOR bits
-	Wb35Reg_Write( pHwData, 0x0824, pWb35Reg->M24_MacControl );
-}
-//---------------------------------------------------------------------------------------------------
-void hal_resume_sync_bss(  phw_data_t pHwData)
-{
-	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
-
-	if( pHwData->SurpriseRemove ) return;
-
-	if (pHwData->bss_type == 1)	//infrastructure mode
-		pWb35Reg->M24_MacControl |= 0x10000000;
-	else
-		pWb35Reg->M24_MacControl |= 0x20000000;	//IBSS mode alway use STASS
-	Wb35Reg_Write( pHwData, 0x0824, pWb35Reg->M24_MacControl );
-}
-//---------------------------------------------------------------------------------------------------
-void hal_set_aid(  phw_data_t pHwData,  u16 aid )
-{
-	u32	tmp;
-
-	if( pHwData->SurpriseRemove ) return;
-
-	pHwData->AID = aid;
-	tmp = pHwData->AID << 16;
-	tmp |= cpu_to_le16( *(PUSHORT)(pHwData->bssid + 4) ); //20060926 anson's endian
-	Wb35Reg_Write( pHwData, 0x0834, tmp );
-}
-//---------------------------------------------------------------------------------------------------
-void hal_set_bssid(  phw_data_t pHwData,  PUCHAR pbssid )
-{
-	u32	pltmp[2];
-
-	if( pHwData->SurpriseRemove ) return;
 
-	memcpy( pHwData->bssid, pbssid, ETH_LENGTH_OF_ADDRESS );
-	pltmp[0] = cpu_to_le32( *(PULONG)pHwData->bssid ); //20060926 anson's endian
-	pltmp[1] = pHwData->AID << 16;
-	pltmp[1] |=cpu_to_le16(*(PUSHORT)(pHwData->bssid + 4) );  //20060926 anson;s endian
-	Wb35Reg_BurstWrite( pHwData, 0x0830, pltmp, 2, AUTO_INCREMENT );
-}
-//---------------------------------------------------------------------------------------------------
-// Memory space pointer pbssid must be kept valid until hal_get_bssid_complete() fired
-void hal_get_bssid(  phw_data_t pHwData,  PUCHAR pbssid )
-{
-	if( pHwData->SurpriseRemove ) return;
 
-		Wb35Reg_Read( pHwData, 0x0834, (PULONG)(pHwData->bssid + 4));
-		Wb35Reg_Read( pHwData, 0x0830, (PULONG)pHwData->bssid );
-		pHwData->bssid_pointer = pbssid;
-}
 //---------------------------------------------------------------------------------------------------
 void hal_set_beacon_period(  phw_data_t pHwData,  u16 beacon_period )
 {
@@ -362,66 +186,7 @@ void hal_set_beacon_period(  phw_data_t 
 	tmp |= pHwData->ProbeDelay;
 	Wb35Reg_Write( pHwData, 0x0848, tmp );
 }
-//---------------------------------------------------------------------------------------------------
-void hal_set_listen_interval(  phw_data_t pHwData,  u16 listen_interval )
-{
-	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
-	u32		tmp;
-
-	if( pHwData->SurpriseRemove ) return;
-
-	pHwData->ListenInterval = listen_interval;
-	pWb35Reg->M2C_MacControl &= 0x0000ffff;//Clear the origial value
-	tmp = pHwData->ListenInterval << 16;
-	pWb35Reg->M2C_MacControl |= tmp;
-	Wb35Reg_Write( pHwData, 0x082c, pWb35Reg->M2C_MacControl );
-}
-//---------------------------------------------------------------------------------------------------
-void hal_set_cap_info(  phw_data_t pHwData,  u16 capability_info )
-{
-	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
-	u32		tmp;
-
-	if( pHwData->SurpriseRemove ) return;
-
-	pHwData->CapabilityInformation = capability_info;
-	pWb35Reg->M38_MacControl &= 0x0000ffff;//Clear the origial value
-	tmp = pHwData->CapabilityInformation << 16;
-	pWb35Reg->M38_MacControl |= tmp;
-	Wb35Reg_Write( pHwData, 0x0838, pWb35Reg->M38_MacControl );
-}
-
-void hal_set_ssid(phw_data_t pHwData,  PUCHAR pssid,  u8 ssid_len)
-{
-	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
-	u32		pltmp[9]; // 1 burst command + 8 DW SSID max
-	u32		tmp;
-	u8		i, j;
-
-	if( pHwData->SurpriseRemove ) return;
 
-	memcpy( pHwData->ssid, pssid, ssid_len );
-	memset( (PUCHAR)pltmp, 0, 36 );
-	//NOTE [WK endian]: ssid values will be tranfered by cpu_to_le32 in Wb35Reg_BurstWrite().
-	//			 The ssid values must be tranfered first but burst cmd is not necessary.
-	
-	pHwData->ssid_length = ssid_len;
-
-	j = (pHwData->ssid_length + 3) & ~0x03;
-	j >>= 2;
-	j += 1;// 1 DW burst command
-	pltmp[0] = 0x10000000; // burst ssid command
-	//[WK endian] 
-	for (i= 1; i<j; i++)
-		pltmp[i] = cpu_to_le32( *(PULONG)(pssid + ((i-1)<<2)) );
-	Wb35Reg_BurstWrite( pHwData,0x881c, pltmp, j, AUTO_INCREMENT );
-
-	// SSID length setting
-	pWb35Reg->M4C_MacStatus &= ~0x003f0000;
-	tmp = pHwData->ssid_length << 16;
-	pWb35Reg->M4C_MacStatus |= tmp;
-	Wb35Reg_Write( pHwData, 0x084c, pWb35Reg->M4C_MacStatus );
-}
 
 void hal_set_current_channel_ex(  phw_data_t pHwData,  ChanInfo channel )
 {
@@ -593,62 +358,6 @@ void hal_set_cwmin(  phw_data_t pHwData,
 	pWb35Reg->M2C_MacControl |= (pHwData->cwmin<<10);
 	Wb35Reg_Write( pHwData, 0x082c, pWb35Reg->M2C_MacControl );
 }
-//---------------------------------------------------------------------------------------------------
-void hal_set_cwmax(  phw_data_t pHwData,  u16 cwin_max )
-{
-	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
-
-	if( pHwData->SurpriseRemove ) return;
-
-	pHwData->cwmax = cwin_max;
-	pWb35Reg->M2C_MacControl &= ~0x3ff;	//bit 0 ~ 9
-	pWb35Reg->M2C_MacControl |= pHwData->cwmax;
-	Wb35Reg_Write( pHwData, 0x082c, pWb35Reg->M2C_MacControl );
-}
-
-void hal_set_rsn_wpa(  phw_data_t pHwData,  u32 * RSN_IE_Bitmap , u32 * RSN_OUI_type,  unsigned char bDesiredAuthMode)
-{
-	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
-	u32		pltmp[2];
-
-	if( pHwData->SurpriseRemove ) return;
-
-#ifdef _PE_STATE_DUMP_
-	WBDEBUG(("[WS]hal_set_rsn_wpa\n"));
-	WBDEBUG(("[WS]hal_RSN_IE_Bitmap=%x\n",*RSN_IE_Bitmap));
-	WBDEBUG(("[WS]hal_RSN_OUI_type=%x\n",*RSN_OUI_type));
-#endif
-
-	pWb35Reg->M24_MacControl &= ~0x500000;
-	switch (bDesiredAuthMode)
-	{
-	case OPEN_AUTH:
-	case SHARE_AUTH:break;
-
-	case WPA_AUTH:
-	case WPAPSK_AUTH:
-	case WPANONE_AUTH:
-		pWb35Reg->M24_MacControl |= 0x500000;
-		break;
-#ifdef _WPA2_
-	case WPA2_AUTH:
-	case WPA2PSK_AUTH:
-		pWb35Reg->M24_MacControl |= 0x100000;
-		break;
-#endif //_WPA2_
-        
-	default:
-		break;
-	}
-	Wb35Reg_Write( pHwData, 0x0824, pWb35Reg->M24_MacControl );
-
-	//pWb35Reg->M24_MacControl = 0x00140042;
-	memcpy( &pltmp[0], RSN_IE_Bitmap, sizeof(u32) );
-	memcpy( &pltmp[1], RSN_OUI_type, sizeof(u32) );
-	pWb35Reg->M70_MacControl = pltmp[0];
-	pWb35Reg->M74_MacControl = pltmp[1];
-	Wb35Reg_BurstWrite( pHwData, 0x0870, pltmp, 2, AUTO_INCREMENT );
-}
 
 s32 hal_get_rssi(  phw_data_t pHwData,  u32 *HalRssiArry,  u8 Count )
 {
@@ -728,19 +437,6 @@ #endif
 	return ltmp;
 }
 
-//----------------------------------------------------------------------------
-//Info the hardware connection or disconnection
-void hal_set_connect_info(  phw_data_t pHwData,  unsigned char boConnect )
-{
-	if( pHwData->SurpriseRemove ) return;
-
-	if (boConnect) {
-		pHwData->LED_LinkOn = 1;
-		pHwData->NullPacketCount = 0;
-	} else
-		pHwData->LED_LinkOn = 0;
-}
-
 //---------------------------------------------------------------------------
 void hal_led_control_1a(  phw_data_t pHwData )
 {
@@ -1030,33 +726,6 @@ void hal_led_control(  void* S1,  phw_da
 	OS_TIMER_SET( &pHwData->LEDTimer, TimeInterval ); // 20060623.1
 }
 
-//--------------------------------------------------------------------------
-u8 hal_get_est_sq3(  phw_data_t pHwData, u8 Count )
-{
-	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
-	u32		ltmp = 0, i;
-
-	if( pHwData->SurpriseRemove ) return 0;
-
-	if( pWb35Reg->BB50 & 0xe0 )
-	{
-		pWb35Reg->BB50 &= ~0xe0;	//EST_SQ3
-		Wb35Reg_Write( pHwData, 0x1050, pWb35Reg->BB50 );
-	}
-
-	Wb35Reg_Read( pHwData, 0x1060, &pWb35Reg->BB60 );
-
-	if( Count > MAX_SQ3_FILTER_SIZE )
-		Count = MAX_SQ3_FILTER_SIZE;
-	pWb35Reg->SQ3_filter[ pWb35Reg->SQ3_index ] = pWb35Reg->BB60 & 0x7f;
-	pWb35Reg->SQ3_index++;
-	pWb35Reg->SQ3_index %= Count;
-
-	for( i=0; i<Count; i++ )
-		ltmp += pWb35Reg->SQ3_filter[i];
-
-	return (u8)(ltmp/Count);
-}
 
 void hal_set_phy_type(  phw_data_t pHwData,  u8 PhyType )
 {
@@ -1120,23 +789,6 @@ #ifdef _PE_STATE_DUMP_
 #endif
 }
 
-u32 hal_get_bss_pk_cnt(  phw_data_t pHwData )
-{
-	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
-	u32		val;
-
-	if( pHwData->SurpriseRemove ) return 0;
-
-	val = pWb35Reg->BB50;
-	val &= 0xffffff1f;
-	val |= 0x0000003f;	//BSS_PK_CNT
-	pWb35Reg->BB50 = val;
-	Wb35Reg_Write( pHwData, 0x1050, pWb35Reg->BB50 );
-
-	Wb35Reg_Read( pHwData, 0x1060, &pWb35Reg->BB60 );
-	return (pWb35Reg->BB60);
-}
-
 //----------------------------------------------------------------------------------------------------
 //0 : radio on; 1: radio off
 u8 hal_get_hw_radio_off(  phw_data_t pHwData )

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
