Return-Path: <linux-kernel-owner+w=401wt.eu-S1764396AbYDPVxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764396AbYDPVxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 17:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbYDPVxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 17:53:23 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:55548 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbYDPVxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 17:53:22 -0400
Date: Wed, 16 Apr 2008 23:53:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com
Subject: w35und: remove ethernet handling, oops magically went away
Message-ID: <20080416215345.GA6297@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove ethernet handling from mds_TX, and driver started to work
again. I can ping without oopsing.

---
commit c9835475305cc8e53445fb6245269226309fd5ff
tree 5cebb08a98c9f0e2b2c4ac066ef48ff1c00f3942
parent 90a0c62430295f08de972148641283b592a21aa4
author Pavel <pavel@amd.ucw.cz> Wed, 16 Apr 2008 23:52:56 +0200
committer Pavel <pavel@amd.ucw.cz> Wed, 16 Apr 2008 23:52:56 +0200

 drivers/net/wireless/winbond/winbondport/mds.c |  180 +-----------------------
 1 files changed, 8 insertions(+), 172 deletions(-)

diff --git a/drivers/net/wireless/winbond/winbondport/mds.c b/drivers/net/wireless/winbond/winbondport/mds.c
index e7c7b28..8064deb 100644
--- a/drivers/net/wireless/winbond/winbondport/mds.c
+++ b/drivers/net/wireless/winbond/winbondport/mds.c
@@ -328,135 +328,12 @@ Mds_HeaderCopy(PADAPTER Adapter, PDESCRI
 	// Key ID setup
 	pT01->T01_wep_id = 0;
 
-	//
-	// Header convert from 802.3 to 802.11
-	//
-	if (DESCRIPTOR_GET_TYPE( pDes ) == FRAME_TYPE_802_3_DATA) {
-		// Setting 802.11 Frame control 2 byte
-		buffer = TargetBuffer; // Reserved for USB header
-		*buffer = 0x08;// Data type
-		buffer++;
-		*buffer = CURRENT_BSS_TYPE;// BSS type
-		buffer++;
-		buffer+=2;// Duration skipping
-
-		if( src_buffer[0] & 0x1 )	// belong to Group address in DA field. Do not fragment.
-			FragmentThreshold = DEFAULT_FRAGMENT_THRESHOLD;
-
-		switch (CURRENT_BSS_TYPE) {
-			case IBSS_NET:
-				//Copy DA-SA
-				memcpy( buffer, src_buffer, DOT_3_TYPE_OFFSET );
-				buffer += DOT_3_TYPE_OFFSET;
-				//Copy BSSID
-				memcpy( buffer,	CURRENT_BSSID, ETH_LENGTH_OF_ADDRESS );
-				break;
-
-			case ESS_NET:
-				//Copy BSSID
-				memcpy( buffer, CURRENT_BSSID, ETH_LENGTH_OF_ADDRESS );
-				buffer += ETH_LENGTH_OF_ADDRESS;
-				//Copy SA
-				memcpy( buffer, (src_buffer+6), ETH_LENGTH_OF_ADDRESS );
-				buffer += ETH_LENGTH_OF_ADDRESS;
-				//Copy DA
-				memcpy( buffer, src_buffer, ETH_LENGTH_OF_ADDRESS );
-				break;
-		}
-		buffer += ETH_LENGTH_OF_ADDRESS;
-
-		// Skip Frag number and sequence number, set it to 0
-		*(PUSHORT)buffer = 0; // @@ offset 18 from 4n start
-		buffer+=2;
-
-		//=====================================================================
-		// DA SA process OK, transfer the Type/Length encapsulation
-		// The format of first buffer in Descriptor => 14 byte = DA + SA + Type/Length
-		//=====================================================================
-
-		//
-		// Type or Length encapsulation detect
-		//
-		src_buffer+=12;
-		stmp = src_buffer[0] << 8;
-		stmp |= src_buffer[1];
-		if( stmp >= 1536 )// Type encapsulated. Else Treated as length encapsulated. Ignore the length field.
-		{
-			// Fill snap into descriptor 931130.5.i
-			pDes->buffer_address[0] = buffer;
-			pDes->buffer_size[0] = DOT_11_SNAP_SIZE + 2;
-
-			*(PULONG)buffer = cpu_to_le32(0x0003aaaa);// SNAP have to fill into also // @@ YY's endian
-			buffer += 4;
-			*(PUSHORT)buffer = 0x0000;// RFC1042 encapsulation format shall be used. //@@
-
-			if( stmp==0x80F3 || stmp==0x8137 )//Because the stmp has been translated to big-endian.
-			{
-				// Type encapsulated but this protocol type in the table
-				// 802.1H bridge tunnel encapsulation format shall be used.
-				//
-				*(PUSHORT)buffer = cpu_to_le16(0xF800); // YY's endian
-			}
-			buffer+=2;
-			*(PUSHORT)buffer = *(PUSHORT)src_buffer;// Copy Type // @@
-			pDes->buffer_total_size -= 6;//( (DOT_3_TYPE_OFFSET + 2) - (DOT_11_SNAP_SIZE + 2) );
-		}
-		else
-		{
-			// 1'st buffer process complete. Remove the 1'st buffer of descriptor
-			pDes->buffer_start_index++;
-			pDes->buffer_number--;
-			pDes->buffer_total_size -= (DOT_3_TYPE_OFFSET + 2); // 14 byte for DA + SA + Type/Length
-		}
-
-		{
-			//In the WPA countermeasure, it needs to recognize whether the packet is 802.1x
-			//after two mic error are found within 2 s.
-			//The driver should disassociate after the next 802.1x message is transmitted.
-			if ( Adapter->Mds.boCounterMeasureBlock )
-			{
-				pMds->TxInfo[DESCRIPTOR_GET_ID(pDes)] = 1;
-				#ifdef _PE_STATE_DUMP_
-				WBDEBUG(("This is the 802.1x message before sending disassociation frame.\n"));
-				#endif
-			}
-		}
-
-		// Test fix pairwise key setting.
-		if( (src_buffer[3] == 0x03) && // packet type = EAPOL-Key
-			(src_buffer[7] == 0x01) && // 4th message of 4 way handshaking
-			(src_buffer[8] == 0x09) )
-		{
-			u32	*pKeyNonce;
-			u8	i;
-
-			pKeyNonce = (PULONG)((PUCHAR)src_buffer + 19);
-			for( i=0; i<4; i++ )
-			{
-				if( pKeyNonce[i] != 0 )
-				{
-					break;
-				}
-			}
-
-			if( i == 4 )
-			{
-				#ifdef _PE_STATE_DUMP_
-				WBDEBUG(("** The 4th message of PairwiseKey 4 way handshaking!!\n"));
-				#endif
-				pDes->EapFix = 1;
-			}
-		}
-	}
-	else
-	{
-		FragmentThreshold = DEFAULT_FRAGMENT_THRESHOLD;	//Do not fragment
-		// Copy full data, the 1'st buffer contain all the data 931130.5.j
-		memcpy( TargetBuffer, src_buffer, DOT_11_MAC_HEADER_SIZE );// Copy header
-		pDes->buffer_address[0] = src_buffer + DOT_11_MAC_HEADER_SIZE;
-		pDes->buffer_total_size -= DOT_11_MAC_HEADER_SIZE;
-		pDes->buffer_size[0] = pDes->buffer_total_size;
-	}
+	FragmentThreshold = DEFAULT_FRAGMENT_THRESHOLD;	//Do not fragment
+	// Copy full data, the 1'st buffer contain all the data 931130.5.j
+	memcpy( TargetBuffer, src_buffer, DOT_11_MAC_HEADER_SIZE );// Copy header
+	pDes->buffer_address[0] = src_buffer + DOT_11_MAC_HEADER_SIZE;
+	pDes->buffer_total_size -= DOT_11_MAC_HEADER_SIZE;
+	pDes->buffer_size[0] = pDes->buffer_total_size;
 
 	// Set fragment threshold
 	FragmentThreshold -= (DOT_11_MAC_HEADER_SIZE + 4);
@@ -469,50 +346,9 @@ Mds_HeaderCopy(PADAPTER Adapter, PDESCRI
 	// Set tx rate
 	//
 	stmp = *(PUSHORT)(TargetBuffer+30); // 2n alignment address
-	if( ((TargetBuffer[0]&MASK_PROTOCOL_VERSION_TYPE) == MAC_TYPE_MANAGEMENT) || (TargetBuffer[4] & 0x01)
-		|| (stmp == cpu_to_le16(0x8e88)) )
-	{
-		//Use basic rate
-		ctmp1 = ctmpf = CURRENT_TX_RATE_FOR_MNG;
-	}
-	else
-	{
-		if (psLOCAL->TxRateMode == RATE_AUTO)
-		{
-			u8		RateTmp;
-			u16		BssIdx;
-			u8	 	BitIndex;
-			u32		BitMap;
-
-			//ctmp1 = MTO_GetTxRate(Adapter, 1000);
-			RateTmp = MTO_GetTxRate(Adapter, 1000);
-			if (CURRENT_BSS_TYPE == ESS_NET)
-			{
-				CURRENT_TX_RATE = RateTmp;
-				#ifdef _USE_FALLBACK_RATE_
-				CURRENT_FALL_BACK_TX_RATE = MTO_GetTxFallbackRate(Adapter);
-				#else
-				CURRENT_FALL_BACK_TX_RATE = CURRENT_TX_RATE;
-				#endif
-			}
-			else
-			{
-				//IBSS mode should check whether peer STA supports this rate.
-				BitMap = 1 << bRateToBitmapIndex(Adapter, RateTmp);
-				CURRENT_TX_RATE = bBitmapToRate(1);
-				CURRENT_FALL_BACK_TX_RATE = CURRENT_TX_RATE;
-			}
-			printk("Tx rate =%d\n", CURRENT_TX_RATE);
-		}
-		ctmp1 = CURRENT_TX_RATE;
-		ctmpf = CURRENT_FALL_BACK_TX_RATE;
 
-		// Use the DSSS rate for sending during protect mode 931130.5.k
-		if( CURRENT_PROTECT_MECHANISM && (pDes->buffer_total_size > DESCRIPTOR_GET_FRAGMENT_THRESHOLD( pDes )) )
-		{
-			ctmp1 = ctmpf = RATE_11M;
-		}
-	}
+	//Use basic rate
+	ctmp1 = ctmpf = CURRENT_TX_RATE_FOR_MNG;
 
 	DESCRIPTOR_SET_TX_RATE( pDes, ctmp1 );
 	#ifdef _PE_TX_DUMP_

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
