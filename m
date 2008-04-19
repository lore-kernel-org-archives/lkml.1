Return-Path: <linux-kernel-owner+w=401wt.eu-S1758910AbYDSM6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910AbYDSM6R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 08:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbYDSM6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 08:58:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:54188 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361AbYDSM6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 08:58:04 -0400
Date: Sat, 19 Apr 2008 14:58:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com
Subject: w35und: remove key management
Message-ID: <20080419125845.GA7282@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

key management isdone by softmac, so it became dead code.

key management is dead code that can be removed

---
commit 72ef967c3bdda42a1b39e533650b1588003cbb08
tree e9308481d119bfe6a85144849e88ace82431614b
parent ce03f9f145abf2e8be4b69f9ee56cd0e49c8770d
author Pavel <pavel@amd.ucw.cz> Sat, 19 Apr 2008 14:53:31 +0200
committer Pavel <pavel@amd.ucw.cz> Sat, 19 Apr 2008 14:53:31 +0200

 drivers/net/wireless/winbond/winbondport/wbhal.c |  335 ----------------------
 1 files changed, 0 insertions(+), 335 deletions(-)

diff --git a/drivers/net/wireless/winbond/winbondport/wbhal.c b/drivers/net/wireless/winbond/winbondport/wbhal.c
index 0177bc0..55eccde 100644
--- a/drivers/net/wireless/winbond/winbondport/wbhal.c
+++ b/drivers/net/wireless/winbond/winbondport/wbhal.c
@@ -8,340 +8,6 @@ void hal_start_tx0(phw_data_t pHwData)
 		Wb35Tx_start( pHwData );
 }
 
-//-----------------------------------------------------------------------------------
-void hal_remove_mapping_key( phw_data_t pHwData, PUCHAR pmac_addr )
-{
-	u32	i;
-
-	if( pHwData->SurpriseRemove ) return;
-
-	#ifdef _PE_STATE_DUMP_
-	WBDEBUG(("hal_remove_mapping_key\n"));
-	#endif
-
-	for (i=MAPPING_KEY_START_INDEX; i<MAX_KEY_TABLE; i++) {
-		if( OS_MEMORY_COMPARE( pmac_addr, pHwData->Key_slot[i], MAC_ADDR_LENGTH ) )
-			break;
-	}
-	if (i != MAX_KEY_TABLE) { //Find the same index
-		// Clear the mac address
-		memset(pHwData->Key_slot[i], 0, MAC_ADDR_LENGTH);
-
-		// Writing into register to clear the valid bit
-		Wb35Reg_Write( pHwData, 0x0820, 0x0 );//Value
-		i<<=4;
-		i |= 0x4000000;
-		Wb35Reg_Write( pHwData, 0x081c, i );
-	}
-}
-
-void hal_remove_default_key( phw_data_t pHwData, u32 i )
-{
-	u32	ltmp;
-	if( pHwData->SurpriseRemove ) return;
-
-	#ifdef _PE_STATE_DUMP_
-	WBDEBUG(("hal_remove_default_key\n"));
-	#endif
-
-	if (i < 4) {  // For default key index 0 ~ 3
-		//Writing into register to clear the valid bit
-		Wb35Reg_Write( pHwData, 0x0820, 0x0 );//Value
-		ltmp = i<<4;
-		ltmp |= 0x4000000;
-		Wb35Reg_Write( pHwData, 0x081c, ltmp );
-
-		memset(pHwData->Key_slot[i], 0, MAC_ADDR_LENGTH);
-	}
-}
-
-unsigned char hal_set_mapping_key( phw_data_t pHwData,  PUCHAR pmac_addr,  u8 null_key,
-				   u8 wep_on,  PUCHAR ptx_tsc,  PUCHAR prx_tsc,
-				   u8 key_type,  u8 key_len,  PUCHAR pkey_data )
-{
-	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
-	PKEY_TABLE	pKey;
-	PULONG		pltmp;
-	u32		ltmp;
-	u8		Key_content[sizeof(KEY_TABLE)+ 16 + 8 ]; //16 bytes for key content, 8 bytes for burst writing
-	u8		i, j;
-	PUCHAR		pValue;  //20060926 anson's endian
-
-	if( pHwData->SurpriseRemove ) return FALSE;
-
-	#ifdef _PE_STATE_DUMP_
-	WBDEBUG(("hal mapping key set\n"));
-	for( i=0; i<key_len; i++ )
-		WBDEBUG(("%x ", pkey_data[i] ));
-	WBDEBUG(("\n"));
-	#endif
-
-	// Turn off the reply ACK ability 930409.2
-	// Due to DI-624. If user uses the WPA-PSK mode, driver doesn't
-	// have enough time to setup the pairwise key into hardware.
-	// For getting more time, disable the ACK ability to let the
-	// AP retry to send the next packet which contains the group key data.
-	pWb35Reg->M40_MacControl |= 0x4000;
-	Wb35Reg_Write( pHwData, 0x0840, pWb35Reg->M40_MacControl );
-
-	// Set key table contain
-	memset(Key_content, 0, sizeof(KEY_TABLE)+ 16 + 8); // 8 bytes for burst writing
-	pKey = (PKEY_TABLE)(Key_content + 4 ); // Space 4 byte for burst command
-
-	pValue = (u8 *)pKey;
-	*pValue = 0x01;							//bit 0
-	*pValue |= ((null_key ? 0: 1) << 1);	//bit 1, 35 hardware different with 33
-	*pValue |= (key_type << 2);				//bit 2~3
-	*pValue |= (wep_on << 4);				//bit 4
-	pValue += 2;
-	memcpy(pValue, pmac_addr, sizeof(u16));	//addr 1
-
-	memcpy( &(pKey->DW1_Address2), pmac_addr + 2, sizeof(u32) );
-
-	if (prx_tsc) {
-		pValue = (u8 *)pKey +8 ;  //20060926 anson's endian
-		memcpy( pValue, prx_tsc, 6 ); //20060926 anson's endian
-	}
-	if (ptx_tsc) {
-		pValue = (u8 *)pKey +16;   //20060926 anson's endian
-		memcpy( pValue, ptx_tsc, 6 ); //20060926 anson's endian
-	}
-
-	//fill key content [20060623]
-	memcpy( ((PUCHAR)pKey+sizeof(KEY_TABLE)), pkey_data, key_len );
-
-	j = 0xff;
-	for (i=MAPPING_KEY_START_INDEX; i<MAX_KEY_TABLE; i++) {
-		pValue = (u8 *)pKey + 2;  //20060926 anson's endian
-		if (!memcpy(pValue, pHwData->Key_slot[i], 6)) {
-			pHwData->mapping_key_replace_index = i + 1;
-			if( pHwData->mapping_key_replace_index == MAX_KEY_TABLE )
-				pHwData->mapping_key_replace_index = MAPPING_KEY_START_INDEX;
-			break;
-		}
-
-		if (!memcpy(pHwData->Key_slot[i], "\x00\x00\x00\x00\x00\x00", MAC_ADDR_LENGTH ))
-			if (j == 0xff)
-				j = i;//Storing the index which can be used
-	}
-
-	if (i == MAX_KEY_TABLE) { //Not found the entry, get one to use
-		if( j == 0xff )//Is out of resource? If yes, get an elder one index to be replaced
-			i = pHwData->mapping_key_replace_index;
-		else
-			i = j;
-
-		pHwData->mapping_key_replace_index = i + 1;
-		if( pHwData->mapping_key_replace_index == MAX_KEY_TABLE )
-			pHwData->mapping_key_replace_index = MAPPING_KEY_START_INDEX;
-
-		//storing data
-		//--- 20060926 anson's endian
-		// *(PUSHORT)pHwData->Key_slot[i] = (u16)pKey->DW0_Address1; // @@
-		//memcpy( pHwData->Key_slot[i] + 2, &(pKey->DW1_Address2), sizeof(u32) );
-		pValue = (u8 *)pKey + 2;  //20060926 add by anson's endian
-		memcpy( pHwData->Key_slot[i], pValue, 6); //20060926 add by anson's endian
-	}
-
-	// For new hardware supported. Using Burst register write
-	#ifdef _PE_STATE_DUMP_
-	WBDEBUG(("35: Key set start..\n"));
-	#endif
-	pltmp = (PULONG)Key_content;
-	ltmp = i<<4;
-	ltmp |= 0x4000000;
-	pltmp[0] = ltmp; // Burst command
-	pltmp[11] = pltmp[1]; // The last, valid bit set
-	pltmp[1] = 0;// The first, clear the valid bit
-	memcpy( pHwData->Key_content[i], pltmp, sizeof(u32)*12 ); // 20060214 for recover
-        //--- 20060926 add by anson's endian
-        pltmp[0] = cpu_to_le32( ltmp );
-        for (i=0; i<=11; i++)
-		pltmp[i] = cpu_to_le32( pltmp[i] );
-
-        //--- end 20060926 add by anson's endian
-	Wb35Reg_BurstWrite( pHwData, 0x881c, pltmp, 12, IGNORE_INCREMENT );
-
-	// Turn on the reply ACK ability
-	pWb35Reg->M40_MacControl &= ~0x4000;
-	Wb35Reg_Write( pHwData, 0x0840, pWb35Reg->M40_MacControl );
-
-	#ifdef _PE_STATE_DUMP_
-	WBDEBUG(("hal_set_mapping_key[%d]\n", i));
-	#endif
-
-	return TRUE;
-}
-//---------------------------------------------------------------------------------------------------
-unsigned char hal_set_default_key( phw_data_t pHwData,  u8 index,  u8 null_key,
-				   u8 wep_on,  PUCHAR ptx_tsc,  PUCHAR prx_tsc,
-				   u8 key_type,  u8 key_len,  PUCHAR pkey_data )
-{
-	PKEY_TABLE	pKey;
-	PULONG		pltmp;
-	u32		ltmp;
-	u8		Key_content[sizeof(KEY_TABLE)+ 16 + 8 ]; //16 bytes for key content, 8 bytes for burst writing
-	PUCHAR		pValue;  //20060926 add by anson's endian  
-	u8		i;  //20060926 add by anson's endian
-
-	if( pHwData->SurpriseRemove ) return FALSE;
-
-	#ifdef _PE_STATE_DUMP_
-	{
-		int i;
-
-		WBDEBUG(("hal default key set\n"));
-		for( i=0; i<key_len; i++ )
-			WBDEBUG(("%x ", pkey_data[i] ));
-		WBDEBUG(("\n"));
-	}
-	#endif
-
-	// Set key table contain
-	memset( Key_content, 0, sizeof(KEY_TABLE) + 16 + 8 ); // 8 bytes for burst writing
-	pKey = (PKEY_TABLE)(Key_content + 4 );
-
-	pValue = (u8 *)pKey;
-	*pValue = 0x01;							//bit 0
-	*pValue |= ((null_key ? 0: 1) << 1);	//bit 1, 35 hardware different with 33
-	*pValue |= (key_type << 2);				//bit 2~3
-	*pValue |= (wep_on << 4);				//bit 4
-
-	if (prx_tsc) {
-                pValue = (u8 *)pKey +8; //20060926 anson's endian
-	        memcpy( pValue, prx_tsc, 6 ); //20060926 anson's endian
-	}
-	if( ptx_tsc ) {
-                pValue = (u8 *)pKey+ 16; //20060926 anson's endian
-                memcpy( pValue, ptx_tsc, 6 ); //20060926 anson's endian
-	}
-
-	//fill key content [20060623]
-	memcpy(((PUCHAR)pKey+sizeof(KEY_TABLE)), pkey_data, key_len );
-
-	// 950301.3.a modify
-	pHwData->CurrentDefaultKeyIndex = index;// Backup default key 941130.2
-	pHwData->CurrentDefaultKeyLength = key_len;
-
-	// For new hardware supported. Using Burst register write
-	pltmp = (PULONG)Key_content;
-	ltmp = index<<4;
-		ltmp |= 0x4000000;
-	
-	pltmp[0] = ltmp; // Burst command
-	pltmp[11] = pltmp[1]; // The last, valid bit set
-	pltmp[1] = 0;// The first, clear the valid bit
-	memcpy( pHwData->Key_content[index], pltmp, sizeof(u32)*12 );
-        //---20060926 add by anson's endian
-        pltmp[0] = cpu_to_le32( ltmp );  
-        for( i=0; i<=11; i++)
-               pltmp[i]=cpu_to_le32( pltmp[i]);
-	//--- end 20060926 add by anson's endian
-	Wb35Reg_BurstWrite( pHwData, 0x881c, pltmp, 12, IGNORE_INCREMENT );
-
-	#ifdef _PE_STATE_DUMP_
-	WBDEBUG(("hal_set_default_key[%d]\n", index));
-	#endif
-
-	return TRUE;
-}
-
-//--------------------------------------------------------------------------------
-void hal_clear_all_default_key( phw_data_t pHwData )
-{
-	u32	pltmp[GROUP_KEY_START_INDEX];
-	u8	i;
-
-	if( pHwData->SurpriseRemove ) return;
-
-	#ifdef _PE_STATE_DUMP_
-	WBDEBUG(("hal_clear_all_default_key\n"));
-	#endif
-
-	// M20 KEY data, set to 0
-	Wb35Reg_Write( pHwData, 0x0820, 0 );
-	// M1c KEY write operation
-	for( i=0; i<GROUP_KEY_START_INDEX; i++ ) {
-		pltmp[i] = i<<4;
-		pltmp[i] |= 0x4000000;
-	}
-	Wb35Reg_BurstWrite( pHwData, 0x081c, pltmp, GROUP_KEY_START_INDEX, NO_INCREMENT );
-	memset( pHwData->Key_slot[0], 0, GROUP_KEY_START_INDEX*8 ); // 20060214 for recover
-}
-
-//------------------------------------------------------------------------------------
-void hal_clear_all_group_key(phw_data_t pHwData)
-{
-	u32	pltmp[MAPPING_KEY_START_INDEX-GROUP_KEY_START_INDEX];
-	u8	i;
-
-	if( pHwData->SurpriseRemove ) return;
-
-	#ifdef _PE_STATE_DUMP_
-	WBDEBUG(("hal_clear_all_group_key\n"));
-	#endif
-
-	// M20 KEY data, set to 0
-	Wb35Reg_Write( pHwData, 0x0820, 0 );
-	// M1c KEY write operation
-	for( i=GROUP_KEY_START_INDEX; i<MAPPING_KEY_START_INDEX; i++ )
-	{
-		pltmp[i-GROUP_KEY_START_INDEX] = i<<4;
-		pltmp[i-GROUP_KEY_START_INDEX] |= 0x4000000;
-	}
-	Wb35Reg_BurstWrite( pHwData, 0x081c, pltmp, MAPPING_KEY_START_INDEX-GROUP_KEY_START_INDEX, NO_INCREMENT );
-	memset( pHwData->Key_slot[GROUP_KEY_START_INDEX], 0, (MAPPING_KEY_START_INDEX-GROUP_KEY_START_INDEX)*8 );
-}
-//---------------------------------------------------------------------------------------------------
-void hal_clear_all_mapping_key( phw_data_t pHwData )
-{
-	u32	pltmp[MAX_KEY_TABLE-MAPPING_KEY_START_INDEX];
-	u8	i;
-
-	if( pHwData->SurpriseRemove ) return;
-
-	#ifdef _PE_STATE_DUMP_
-	WBDEBUG(("hal_clear_all_mapping_key\n"));
-	#endif
-
-	// M20 KEY data, set to 0
-	Wb35Reg_Write( pHwData, 0x0820, 0 );
-	// M1c KEY write operation
-	for( i=MAPPING_KEY_START_INDEX; i<MAX_KEY_TABLE; i++ )
-	{
-		pltmp[i-MAPPING_KEY_START_INDEX] = i<<4;
-		pltmp[i-MAPPING_KEY_START_INDEX] |= 0x4000000;
-	}
-	Wb35Reg_BurstWrite( pHwData, 0x081c, pltmp, MAX_KEY_TABLE-MAPPING_KEY_START_INDEX, NO_INCREMENT );
-
-	pHwData->mapping_key_replace_index = MAPPING_KEY_START_INDEX;
-	memset( pHwData->Key_slot[MAPPING_KEY_START_INDEX], 0, (MAX_KEY_TABLE-MAPPING_KEY_START_INDEX)*8 ); // Modify due to enlarge data struct 6 -> 8
-}
-//---------------------------------------------------------------------------------------------------
-void hal_clear_all_key( phw_data_t pHwData )
-{
-	u32	pltmp[MAX_KEY_TABLE];
-	u8	i;
-
-	if( pHwData->SurpriseRemove ) return;
-
-	#ifdef _PE_STATE_DUMP_
-	WBDEBUG(("hal_clear_all_key\n"));
-	#endif
-
-	// M20 KEY data, set to 0
-	Wb35Reg_Write( pHwData, 0x0820, 0 );
-	// M1c KEY write operation
-	for( i=0; i<MAX_KEY_TABLE; i++ )
-	{
-		pltmp[i] = i<<4;
-		pltmp[i] |= 0x4000000;
-	}
-	Wb35Reg_BurstWrite( pHwData, 0x081c, pltmp, 16, NO_INCREMENT );
-	Wb35Reg_BurstWrite( pHwData, 0x081c, pltmp+16, MAX_KEY_TABLE-16, NO_INCREMENT );
-	memset( pHwData->Key_slot[0], 0, MAX_KEY_TABLE*8 ); // 20060214 for recover
-}
-
 void hal_get_ethernet_address( phw_data_t pHwData, PUCHAR current_address )
 {
 	if( pHwData->SurpriseRemove ) return;
@@ -390,7 +56,6 @@ u8 hal_init_hardware(phw_data_t pHwData,
 					pHwData->InitialResource = 4;
 					OS_TIMER_INITIAL( &pHwData->LEDTimer, hal_led_control, pHwData );
 					OS_TIMER_SET( &pHwData->LEDTimer, 1000 ); // 20060623
-					hal_clear_all_key( pHwData );//Because HW doesn't clear the WEP KEY table
 
 					//
 					// For restrict to vendor's hardware

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
