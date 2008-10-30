Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbYJ3REf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbYJ3REf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbYJ3RE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:04:26 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:25723 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbYJ3REY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:04:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=lLbbtT72lzBEFq92i4froS+B4G/a3C4/AezKZBUa0uwUJQxkSWUkJnkusmo3QnTfsf
         3tkVhOBzWernJMo/FhPx8eA9LK7lej/UfNMwI97mGmpfiqbnOkVvE121FT+ySdCoiDNo
         MX0Aq++PpaWmbANP+cddrdHNwSeUHLMGLoJ8s=
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@suse.cz>
Subject: [PATCH 1/7] w35und: make functions local to mds.c static
Date: Thu, 30 Oct 2008 19:04:50 +0200
Message-Id: <1225386296-19632-1-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions have no external references so make them static after shuffling
the code around a bit to avoid forward declarations.

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/mds.c   |  799 +++++++++++++++++++--------------------
 drivers/staging/winbond/mds_f.h |    4 -
 2 files changed, 391 insertions(+), 412 deletions(-)

diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
index a4e7300..0dd1eec 100644
--- a/drivers/staging/winbond/mds.c
+++ b/drivers/staging/winbond/mds.c
@@ -7,19 +7,6 @@
 #include "wbhal_f.h"
 #include "wblinux_f.h"
 
-void
-Mds_reset_descriptor(struct wbsoft_priv * adapter)
-{
-	PMDS pMds = &adapter->Mds;
-
-	pMds->TxPause = 0;
-	atomic_set(&pMds->TxThreadCount, 0);
-	pMds->TxFillIndex = 0;
-	pMds->TxDesIndex = 0;
-	pMds->ScanTxPause = 0;
-	memset(pMds->TxOwner, 0, ((MAX_USB_TX_BUFFER_NUMBER + 3) & ~0x03));
-}
-
 unsigned char
 Mds_initial(struct wbsoft_priv * adapter)
 {
@@ -40,6 +27,397 @@ Mds_Destroy(struct wbsoft_priv * adapter)
 	vRxTimerStop(adapter);
 }
 
+static void Mds_DurationSet(struct wbsoft_priv *adapter,  PDESCRIPTOR pDes,  u8 *buffer)
+{
+	PT00_DESCRIPTOR	pT00;
+	PT01_DESCRIPTOR	pT01;
+	u16	Duration, NextBodyLen, OffsetSize;
+	u8	Rate, i;
+	unsigned char	CTS_on = false, RTS_on = false;
+	PT00_DESCRIPTOR pNextT00;
+	u16 BodyLen = 0;
+	unsigned char boGroupAddr = false;
+
+	OffsetSize = pDes->FragmentThreshold + 32 + 3;
+	OffsetSize &= ~0x03;
+	Rate = pDes->TxRate >> 1;
+	if (!Rate)
+		Rate = 1;
+
+	pT00 = (PT00_DESCRIPTOR)buffer;
+	pT01 = (PT01_DESCRIPTOR)(buffer+4);
+	pNextT00 = (PT00_DESCRIPTOR)(buffer+OffsetSize);
+
+	if( buffer[ DOT_11_DA_OFFSET+8 ] & 0x1 ) // +8 for USB hdr
+		boGroupAddr = true;
+
+	//========================================
+	// Set RTS/CTS mechanism
+	//========================================
+	if (!boGroupAddr)
+	{
+		//NOTE : If the protection mode is enabled and the MSDU will be fragmented,
+		//		 the tx rates of MPDUs will all be DSSS rates. So it will not use
+		//		 CTS-to-self in this case. CTS-To-self will only be used when without
+		//		 fragmentation. -- 20050112
+		BodyLen = (u16)pT00->T00_frame_length;	//include 802.11 header
+		BodyLen += 4;	//CRC
+
+		if( BodyLen >= CURRENT_RTS_THRESHOLD )
+			RTS_on = true; // Using RTS
+		else
+		{
+			if( pT01->T01_modulation_type ) // Is using OFDM
+			{
+				if( CURRENT_PROTECT_MECHANISM ) // Is using protect
+					CTS_on = true; // Using CTS
+			}
+		}
+	}
+
+	if( RTS_on || CTS_on )
+	{
+		if( pT01->T01_modulation_type) // Is using OFDM
+		{
+			//CTS duration
+			// 2 SIFS + DATA transmit time + 1 ACK
+			// ACK Rate : 24 Mega bps
+			// ACK frame length = 14 bytes
+			Duration = 2*DEFAULT_SIFSTIME +
+					   2*PREAMBLE_PLUS_SIGNAL_PLUS_SIGNALEXTENSION +
+					   ((BodyLen*8 + 22 + Rate*4 - 1)/(Rate*4))*Tsym +
+					   ((112 + 22 + 95)/96)*Tsym;
+		}
+		else	//DSSS
+		{
+			//CTS duration
+			// 2 SIFS + DATA transmit time + 1 ACK
+			// Rate : ?? Mega bps
+			// ACK frame length = 14 bytes
+			if( pT01->T01_plcp_header_length ) //long preamble
+				Duration = LONG_PREAMBLE_PLUS_PLCPHEADER_TIME*2;
+			else
+				Duration = SHORT_PREAMBLE_PLUS_PLCPHEADER_TIME*2;
+
+			Duration += ( ((BodyLen + 14)*8 + Rate-1) / Rate +
+						DEFAULT_SIFSTIME*2 );
+		}
+
+		if( RTS_on )
+		{
+			if( pT01->T01_modulation_type ) // Is using OFDM
+			{
+				//CTS + 1 SIFS + CTS duration
+				//CTS Rate : 24 Mega bps
+				//CTS frame length = 14 bytes
+				Duration += (DEFAULT_SIFSTIME +
+								PREAMBLE_PLUS_SIGNAL_PLUS_SIGNALEXTENSION +
+								((112 + 22 + 95)/96)*Tsym);
+			}
+			else
+			{
+				//CTS + 1 SIFS + CTS duration
+				//CTS Rate : ?? Mega bps
+				//CTS frame length = 14 bytes
+				if( pT01->T01_plcp_header_length ) //long preamble
+					Duration += LONG_PREAMBLE_PLUS_PLCPHEADER_TIME;
+				else
+					Duration += SHORT_PREAMBLE_PLUS_PLCPHEADER_TIME;
+
+				Duration += ( ((112 + Rate-1) / Rate) + DEFAULT_SIFSTIME );
+			}
+		}
+
+		// Set the value into USB descriptor
+		pT01->T01_add_rts = RTS_on ? 1 : 0;
+		pT01->T01_add_cts = CTS_on ? 1 : 0;
+		pT01->T01_rts_cts_duration = Duration;
+	}
+
+	//=====================================
+	// Fill the more fragment descriptor
+	//=====================================
+	if( boGroupAddr )
+		Duration = 0;
+	else
+	{
+		for( i=pDes->FragmentCount-1; i>0; i-- )
+		{
+			NextBodyLen = (u16)pNextT00->T00_frame_length;
+			NextBodyLen += 4;	//CRC
+
+			if( pT01->T01_modulation_type )
+			{
+				//OFDM
+				// data transmit time + 3 SIFS + 2 ACK
+				// Rate : ??Mega bps
+				// ACK frame length = 14 bytes, tx rate = 24M
+				Duration = PREAMBLE_PLUS_SIGNAL_PLUS_SIGNALEXTENSION * 3;
+				Duration += (((NextBodyLen*8 + 22 + Rate*4 - 1)/(Rate*4)) * Tsym +
+							(((2*14)*8 + 22 + 95)/96)*Tsym +
+							DEFAULT_SIFSTIME*3);
+			}
+			else
+			{
+				//DSSS
+				// data transmit time + 2 ACK + 3 SIFS
+				// Rate : ??Mega bps
+				// ACK frame length = 14 bytes
+				//TODO :
+				if( pT01->T01_plcp_header_length ) //long preamble
+					Duration = LONG_PREAMBLE_PLUS_PLCPHEADER_TIME*3;
+				else
+					Duration = SHORT_PREAMBLE_PLUS_PLCPHEADER_TIME*3;
+
+				Duration += ( ((NextBodyLen + (2*14))*8 + Rate-1) / Rate +
+							DEFAULT_SIFSTIME*3 );
+			}
+
+			((u16 *)buffer)[5] = cpu_to_le16(Duration);// 4 USHOR for skip 8B USB, 2USHORT=FC + Duration
+
+			//----20061009 add by anson's endian
+			pNextT00->value = cpu_to_le32(pNextT00->value);
+			pT01->value = cpu_to_le32( pT01->value );
+			//----end 20061009 add by anson's endian
+
+			buffer += OffsetSize;
+			pT01 = (PT01_DESCRIPTOR)(buffer+4);
+			if (i != 1)	//The last fragment will not have the next fragment
+				pNextT00 = (PT00_DESCRIPTOR)(buffer+OffsetSize);
+		}
+
+		//=====================================
+		// Fill the last fragment descriptor
+		//=====================================
+		if( pT01->T01_modulation_type )
+		{
+			//OFDM
+			// 1 SIFS + 1 ACK
+			// Rate : 24 Mega bps
+			// ACK frame length = 14 bytes
+			Duration = PREAMBLE_PLUS_SIGNAL_PLUS_SIGNALEXTENSION;
+			//The Tx rate of ACK use 24M
+			Duration += (((112 + 22 + 95)/96)*Tsym + DEFAULT_SIFSTIME );
+		}
+		else
+		{
+			// DSSS
+			// 1 ACK + 1 SIFS
+			// Rate : ?? Mega bps
+			// ACK frame length = 14 bytes(112 bits)
+			if( pT01->T01_plcp_header_length ) //long preamble
+				Duration = LONG_PREAMBLE_PLUS_PLCPHEADER_TIME;
+			else
+				Duration = SHORT_PREAMBLE_PLUS_PLCPHEADER_TIME;
+
+			Duration += ( (112 + Rate-1)/Rate +	DEFAULT_SIFSTIME );
+		}
+	}
+
+	((u16 *)buffer)[5] = cpu_to_le16(Duration);// 4 USHOR for skip 8B USB, 2USHORT=FC + Duration
+	pT00->value = cpu_to_le32(pT00->value);
+	pT01->value = cpu_to_le32(pT01->value);
+	//--end 20061009 add
+
+}
+
+// The function return the 4n size of usb pk
+static u16 Mds_BodyCopy(struct wbsoft_priv *adapter, PDESCRIPTOR pDes, u8 *TargetBuffer)
+{
+	PT00_DESCRIPTOR	pT00;
+	PMDS	pMds = &adapter->Mds;
+	u8	*buffer;
+	u8	*src_buffer;
+	u8	*pctmp;
+	u16	Size = 0;
+	u16	SizeLeft, CopySize, CopyLeft, stmp;
+	u8	buf_index, FragmentCount = 0;
+
+
+	// Copy fragment body
+	buffer = TargetBuffer; // shift 8B usb + 24B 802.11
+	SizeLeft = pDes->buffer_total_size;
+	buf_index = pDes->buffer_start_index;
+
+	pT00 = (PT00_DESCRIPTOR)buffer;
+	while (SizeLeft) {
+		pT00 = (PT00_DESCRIPTOR)buffer;
+		CopySize = SizeLeft;
+		if (SizeLeft > pDes->FragmentThreshold) {
+			CopySize = pDes->FragmentThreshold;
+			pT00->T00_frame_length = 24 + CopySize;//Set USB length
+		} else
+			pT00->T00_frame_length = 24 + SizeLeft;//Set USB length
+
+		SizeLeft -= CopySize;
+
+		// 1 Byte operation
+		pctmp = (u8 *)( buffer + 8 + DOT_11_SEQUENCE_OFFSET );
+		*pctmp &= 0xf0;
+		*pctmp |= FragmentCount;//931130.5.m
+		if( !FragmentCount )
+			pT00->T00_first_mpdu = 1;
+
+		buffer += 32; // 8B usb + 24B 802.11 header
+		Size += 32;
+
+		// Copy into buffer
+		stmp = CopySize + 3;
+		stmp &= ~0x03;//4n Alignment
+		Size += stmp;// Current 4n offset of mpdu
+
+		while (CopySize) {
+			// Copy body
+			src_buffer = pDes->buffer_address[buf_index];
+			CopyLeft = CopySize;
+			if (CopySize >= pDes->buffer_size[buf_index]) {
+				CopyLeft = pDes->buffer_size[buf_index];
+
+				// Get the next buffer of descriptor
+				buf_index++;
+				buf_index %= MAX_DESCRIPTOR_BUFFER_INDEX;
+			} else {
+				u8	*pctmp = pDes->buffer_address[buf_index];
+				pctmp += CopySize;
+				pDes->buffer_address[buf_index] = pctmp;
+				pDes->buffer_size[buf_index] -= CopySize;
+			}
+
+			memcpy(buffer, src_buffer, CopyLeft);
+			buffer += CopyLeft;
+			CopySize -= CopyLeft;
+		}
+
+		// 931130.5.n
+		if (pMds->MicAdd) {
+			if (!SizeLeft) {
+				pMds->MicWriteAddress[ pMds->MicWriteIndex ] = buffer - pMds->MicAdd;
+				pMds->MicWriteSize[ pMds->MicWriteIndex ] = pMds->MicAdd;
+				pMds->MicAdd = 0;
+			}
+			else if( SizeLeft < 8 ) //931130.5.p
+			{
+				pMds->MicAdd = SizeLeft;
+				pMds->MicWriteAddress[ pMds->MicWriteIndex ] = buffer - ( 8 - SizeLeft );
+				pMds->MicWriteSize[ pMds->MicWriteIndex ] = 8 - SizeLeft;
+				pMds->MicWriteIndex++;
+			}
+		}
+
+		// Does it need to generate the new header for next mpdu?
+		if (SizeLeft) {
+			buffer = TargetBuffer + Size; // Get the next 4n start address
+			memcpy( buffer, TargetBuffer, 32 );//Copy 8B USB +24B 802.11
+			pT00 = (PT00_DESCRIPTOR)buffer;
+			pT00->T00_first_mpdu = 0;
+		}
+
+		FragmentCount++;
+	}
+
+	pT00->T00_last_mpdu = 1;
+	pT00->T00_IsLastMpdu = 1;
+	buffer = (u8 *)pT00 + 8; // +8 for USB hdr
+	buffer[1] &= ~0x04; // Clear more frag bit of 802.11 frame control
+	pDes->FragmentCount = FragmentCount; // Update the correct fragment number
+	return Size;
+}
+
+static void Mds_HeaderCopy(struct wbsoft_priv * adapter, PDESCRIPTOR pDes, u8 *TargetBuffer)
+{
+	PMDS	pMds = &adapter->Mds;
+	u8	*src_buffer = pDes->buffer_address[0];//931130.5.g
+	PT00_DESCRIPTOR	pT00;
+	PT01_DESCRIPTOR	pT01;
+	u16	stmp;
+	u8	i, ctmp1, ctmp2, ctmpf;
+	u16	FragmentThreshold = CURRENT_FRAGMENT_THRESHOLD;
+
+
+	stmp = pDes->buffer_total_size;
+	//
+	// Set USB header 8 byte
+	//
+	pT00 = (PT00_DESCRIPTOR)TargetBuffer;
+	TargetBuffer += 4;
+	pT01 = (PT01_DESCRIPTOR)TargetBuffer;
+	TargetBuffer += 4;
+
+	pT00->value = 0;// Clear
+	pT01->value = 0;// Clear
+
+	pT00->T00_tx_packet_id = pDes->Descriptor_ID;// Set packet ID
+	pT00->T00_header_length = 24;// Set header length
+	pT01->T01_retry_abort_ebable = 1;//921013 931130.5.h
+
+	// Key ID setup
+	pT01->T01_wep_id = 0;
+
+	FragmentThreshold = DEFAULT_FRAGMENT_THRESHOLD;	//Do not fragment
+	// Copy full data, the 1'st buffer contain all the data 931130.5.j
+	memcpy( TargetBuffer, src_buffer, DOT_11_MAC_HEADER_SIZE );// Copy header
+	pDes->buffer_address[0] = src_buffer + DOT_11_MAC_HEADER_SIZE;
+	pDes->buffer_total_size -= DOT_11_MAC_HEADER_SIZE;
+	pDes->buffer_size[0] = pDes->buffer_total_size;
+
+	// Set fragment threshold
+	FragmentThreshold -= (DOT_11_MAC_HEADER_SIZE + 4);
+	pDes->FragmentThreshold = FragmentThreshold;
+
+	// Set more frag bit
+	TargetBuffer[1] |= 0x04;// Set more frag bit
+
+	//
+	// Set tx rate
+	//
+	stmp = *(u16 *)(TargetBuffer+30); // 2n alignment address
+
+	//Use basic rate
+	ctmp1 = ctmpf = CURRENT_TX_RATE_FOR_MNG;
+
+	pDes->TxRate = ctmp1;
+	#ifdef _PE_TX_DUMP_
+	WBDEBUG(("Tx rate =%x\n", ctmp1));
+	#endif
+
+	pT01->T01_modulation_type = (ctmp1%3) ? 0 : 1;
+
+	for( i=0; i<2; i++ ) {
+		if( i == 1 )
+			ctmp1 = ctmpf;
+
+		pMds->TxRate[pDes->Descriptor_ID][i] = ctmp1; // backup the ta rate and fall back rate
+
+		if( ctmp1 == 108) ctmp2 = 7;
+		else if( ctmp1 == 96 ) ctmp2 = 6; // Rate convert for USB
+		else if( ctmp1 == 72 ) ctmp2 = 5;
+		else if( ctmp1 == 48 ) ctmp2 = 4;
+		else if( ctmp1 == 36 ) ctmp2 = 3;
+		else if( ctmp1 == 24 ) ctmp2 = 2;
+		else if( ctmp1 == 18 ) ctmp2 = 1;
+		else if( ctmp1 == 12 ) ctmp2 = 0;
+		else if( ctmp1 == 22 ) ctmp2 = 3;
+		else if( ctmp1 == 11 ) ctmp2 = 2;
+		else if( ctmp1 == 4  ) ctmp2 = 1;
+		else ctmp2 = 0; // if( ctmp1 == 2  ) or default
+
+		if( i == 0 )
+			pT01->T01_transmit_rate = ctmp2;
+		else
+			pT01->T01_fall_back_rate = ctmp2;
+	}
+
+	//
+	// Set preamble type
+	//
+	if ((pT01->T01_modulation_type == 0) && (pT01->T01_transmit_rate == 0))	// RATE_1M
+		pDes->PreambleMode =  WLAN_PREAMBLE_TYPE_LONG;
+	else
+		pDes->PreambleMode =  CURRENT_PREAMBLE_MODE;
+	pT01->T01_plcp_header_length = pDes->PreambleMode;	// Set preamble
+
+}
+
 void
 Mds_Tx(struct wbsoft_priv * adapter)
 {
@@ -234,398 +612,3 @@ Mds_SendComplete(struct wbsoft_priv * adapter, PT02_DESCRIPTOR pT02)
 	} else
 		pMds->TxResult[ PacketId ] |= ((u16)(pT02->value & 0x0ffff));
 }
-
-void
-Mds_HeaderCopy(struct wbsoft_priv * adapter, PDESCRIPTOR pDes, u8 *TargetBuffer)
-{
-	PMDS	pMds = &adapter->Mds;
-	u8	*src_buffer = pDes->buffer_address[0];//931130.5.g
-	PT00_DESCRIPTOR	pT00;
-	PT01_DESCRIPTOR	pT01;
-	u16	stmp;
-	u8	i, ctmp1, ctmp2, ctmpf;
-	u16	FragmentThreshold = CURRENT_FRAGMENT_THRESHOLD;
-
-
-	stmp = pDes->buffer_total_size;
-	//
-	// Set USB header 8 byte
-	//
-	pT00 = (PT00_DESCRIPTOR)TargetBuffer;
-	TargetBuffer += 4;
-	pT01 = (PT01_DESCRIPTOR)TargetBuffer;
-	TargetBuffer += 4;
-
-	pT00->value = 0;// Clear
-	pT01->value = 0;// Clear
-
-	pT00->T00_tx_packet_id = pDes->Descriptor_ID;// Set packet ID
-	pT00->T00_header_length = 24;// Set header length
-	pT01->T01_retry_abort_ebable = 1;//921013 931130.5.h
-
-	// Key ID setup
-	pT01->T01_wep_id = 0;
-
-	FragmentThreshold = DEFAULT_FRAGMENT_THRESHOLD;	//Do not fragment
-	// Copy full data, the 1'st buffer contain all the data 931130.5.j
-	memcpy( TargetBuffer, src_buffer, DOT_11_MAC_HEADER_SIZE );// Copy header
-	pDes->buffer_address[0] = src_buffer + DOT_11_MAC_HEADER_SIZE;
-	pDes->buffer_total_size -= DOT_11_MAC_HEADER_SIZE;
-	pDes->buffer_size[0] = pDes->buffer_total_size;
-
-	// Set fragment threshold
-	FragmentThreshold -= (DOT_11_MAC_HEADER_SIZE + 4);
-	pDes->FragmentThreshold = FragmentThreshold;
-
-	// Set more frag bit
-	TargetBuffer[1] |= 0x04;// Set more frag bit
-
-	//
-	// Set tx rate
-	//
-	stmp = *(u16 *)(TargetBuffer+30); // 2n alignment address
-
-	//Use basic rate
-	ctmp1 = ctmpf = CURRENT_TX_RATE_FOR_MNG;
-
-	pDes->TxRate = ctmp1;
-	#ifdef _PE_TX_DUMP_
-	WBDEBUG(("Tx rate =%x\n", ctmp1));
-	#endif
-
-	pT01->T01_modulation_type = (ctmp1%3) ? 0 : 1;
-
-	for( i=0; i<2; i++ ) {
-		if( i == 1 )
-			ctmp1 = ctmpf;
-
-		pMds->TxRate[pDes->Descriptor_ID][i] = ctmp1; // backup the ta rate and fall back rate
-
-		if( ctmp1 == 108) ctmp2 = 7;
-		else if( ctmp1 == 96 ) ctmp2 = 6; // Rate convert for USB
-		else if( ctmp1 == 72 ) ctmp2 = 5;
-		else if( ctmp1 == 48 ) ctmp2 = 4;
-		else if( ctmp1 == 36 ) ctmp2 = 3;
-		else if( ctmp1 == 24 ) ctmp2 = 2;
-		else if( ctmp1 == 18 ) ctmp2 = 1;
-		else if( ctmp1 == 12 ) ctmp2 = 0;
-		else if( ctmp1 == 22 ) ctmp2 = 3;
-		else if( ctmp1 == 11 ) ctmp2 = 2;
-		else if( ctmp1 == 4  ) ctmp2 = 1;
-		else ctmp2 = 0; // if( ctmp1 == 2  ) or default
-
-		if( i == 0 )
-			pT01->T01_transmit_rate = ctmp2;
-		else
-			pT01->T01_fall_back_rate = ctmp2;
-	}
-
-	//
-	// Set preamble type
-	//
-	if ((pT01->T01_modulation_type == 0) && (pT01->T01_transmit_rate == 0))	// RATE_1M
-		pDes->PreambleMode =  WLAN_PREAMBLE_TYPE_LONG;
-	else
-		pDes->PreambleMode =  CURRENT_PREAMBLE_MODE;
-	pT01->T01_plcp_header_length = pDes->PreambleMode;	// Set preamble
-
-}
-
-// The function return the 4n size of usb pk
-u16
-Mds_BodyCopy(struct wbsoft_priv * adapter, PDESCRIPTOR pDes, u8 *TargetBuffer)
-{
-	PT00_DESCRIPTOR	pT00;
-	PMDS	pMds = &adapter->Mds;
-	u8	*buffer;
-	u8	*src_buffer;
-	u8	*pctmp;
-	u16	Size = 0;
-	u16	SizeLeft, CopySize, CopyLeft, stmp;
-	u8	buf_index, FragmentCount = 0;
-
-
-	// Copy fragment body
-	buffer = TargetBuffer; // shift 8B usb + 24B 802.11
-	SizeLeft = pDes->buffer_total_size;
-	buf_index = pDes->buffer_start_index;
-
-	pT00 = (PT00_DESCRIPTOR)buffer;
-	while (SizeLeft) {
-		pT00 = (PT00_DESCRIPTOR)buffer;
-		CopySize = SizeLeft;
-		if (SizeLeft > pDes->FragmentThreshold) {
-			CopySize = pDes->FragmentThreshold;
-			pT00->T00_frame_length = 24 + CopySize;//Set USB length
-		} else
-			pT00->T00_frame_length = 24 + SizeLeft;//Set USB length
-
-		SizeLeft -= CopySize;
-
-		// 1 Byte operation
-		pctmp = (u8 *)( buffer + 8 + DOT_11_SEQUENCE_OFFSET );
-		*pctmp &= 0xf0;
-		*pctmp |= FragmentCount;//931130.5.m
-		if( !FragmentCount )
-			pT00->T00_first_mpdu = 1;
-
-		buffer += 32; // 8B usb + 24B 802.11 header
-		Size += 32;
-
-		// Copy into buffer
-		stmp = CopySize + 3;
-		stmp &= ~0x03;//4n Alignment
-		Size += stmp;// Current 4n offset of mpdu
-
-		while (CopySize) {
-			// Copy body
-			src_buffer = pDes->buffer_address[buf_index];
-			CopyLeft = CopySize;
-			if (CopySize >= pDes->buffer_size[buf_index]) {
-				CopyLeft = pDes->buffer_size[buf_index];
-
-				// Get the next buffer of descriptor
-				buf_index++;
-				buf_index %= MAX_DESCRIPTOR_BUFFER_INDEX;
-			} else {
-				u8	*pctmp = pDes->buffer_address[buf_index];
-				pctmp += CopySize;
-				pDes->buffer_address[buf_index] = pctmp;
-				pDes->buffer_size[buf_index] -= CopySize;
-			}
-
-			memcpy(buffer, src_buffer, CopyLeft);
-			buffer += CopyLeft;
-			CopySize -= CopyLeft;
-		}
-
-		// 931130.5.n
-		if (pMds->MicAdd) {
-			if (!SizeLeft) {
-				pMds->MicWriteAddress[ pMds->MicWriteIndex ] = buffer - pMds->MicAdd;
-				pMds->MicWriteSize[ pMds->MicWriteIndex ] = pMds->MicAdd;
-				pMds->MicAdd = 0;
-			}
-			else if( SizeLeft < 8 ) //931130.5.p
-			{
-				pMds->MicAdd = SizeLeft;
-				pMds->MicWriteAddress[ pMds->MicWriteIndex ] = buffer - ( 8 - SizeLeft );
-				pMds->MicWriteSize[ pMds->MicWriteIndex ] = 8 - SizeLeft;
-				pMds->MicWriteIndex++;
-			}
-		}
-
-		// Does it need to generate the new header for next mpdu?
-		if (SizeLeft) {
-			buffer = TargetBuffer + Size; // Get the next 4n start address
-			memcpy( buffer, TargetBuffer, 32 );//Copy 8B USB +24B 802.11
-			pT00 = (PT00_DESCRIPTOR)buffer;
-			pT00->T00_first_mpdu = 0;
-		}
-
-		FragmentCount++;
-	}
-
-	pT00->T00_last_mpdu = 1;
-	pT00->T00_IsLastMpdu = 1;
-	buffer = (u8 *)pT00 + 8; // +8 for USB hdr
-	buffer[1] &= ~0x04; // Clear more frag bit of 802.11 frame control
-	pDes->FragmentCount = FragmentCount; // Update the correct fragment number
-	return Size;
-}
-
-
-void
-Mds_DurationSet(  struct wbsoft_priv * adapter,  PDESCRIPTOR pDes,  u8 *buffer )
-{
-	PT00_DESCRIPTOR	pT00;
-	PT01_DESCRIPTOR	pT01;
-	u16	Duration, NextBodyLen, OffsetSize;
-	u8	Rate, i;
-	unsigned char	CTS_on = false, RTS_on = false;
-	PT00_DESCRIPTOR pNextT00;
-	u16 BodyLen = 0;
-	unsigned char boGroupAddr = false;
-
-	OffsetSize = pDes->FragmentThreshold + 32 + 3;
-	OffsetSize &= ~0x03;
-	Rate = pDes->TxRate >> 1;
-	if (!Rate)
-		Rate = 1;
-
-	pT00 = (PT00_DESCRIPTOR)buffer;
-	pT01 = (PT01_DESCRIPTOR)(buffer+4);
-	pNextT00 = (PT00_DESCRIPTOR)(buffer+OffsetSize);
-
-	if( buffer[ DOT_11_DA_OFFSET+8 ] & 0x1 ) // +8 for USB hdr
-		boGroupAddr = true;
-
-	//========================================
-	// Set RTS/CTS mechanism
-	//========================================
-	if (!boGroupAddr)
-	{
-		//NOTE : If the protection mode is enabled and the MSDU will be fragmented,
-		//		 the tx rates of MPDUs will all be DSSS rates. So it will not use
-		//		 CTS-to-self in this case. CTS-To-self will only be used when without
-		//		 fragmentation. -- 20050112
-		BodyLen = (u16)pT00->T00_frame_length;	//include 802.11 header
-		BodyLen += 4;	//CRC
-
-		if( BodyLen >= CURRENT_RTS_THRESHOLD )
-			RTS_on = true; // Using RTS
-		else
-		{
-			if( pT01->T01_modulation_type ) // Is using OFDM
-			{
-				if( CURRENT_PROTECT_MECHANISM ) // Is using protect
-					CTS_on = true; // Using CTS
-			}
-		}
-	}
-
-	if( RTS_on || CTS_on )
-	{
-		if( pT01->T01_modulation_type) // Is using OFDM
-		{
-			//CTS duration
-			// 2 SIFS + DATA transmit time + 1 ACK
-			// ACK Rate : 24 Mega bps
-			// ACK frame length = 14 bytes
-			Duration = 2*DEFAULT_SIFSTIME +
-					   2*PREAMBLE_PLUS_SIGNAL_PLUS_SIGNALEXTENSION +
-					   ((BodyLen*8 + 22 + Rate*4 - 1)/(Rate*4))*Tsym +
-					   ((112 + 22 + 95)/96)*Tsym;
-		}
-		else	//DSSS
-		{
-			//CTS duration
-			// 2 SIFS + DATA transmit time + 1 ACK
-			// Rate : ?? Mega bps
-			// ACK frame length = 14 bytes
-			if( pT01->T01_plcp_header_length ) //long preamble
-				Duration = LONG_PREAMBLE_PLUS_PLCPHEADER_TIME*2;
-			else
-				Duration = SHORT_PREAMBLE_PLUS_PLCPHEADER_TIME*2;
-
-			Duration += ( ((BodyLen + 14)*8 + Rate-1) / Rate +
-						DEFAULT_SIFSTIME*2 );
-		}
-
-		if( RTS_on )
-		{
-			if( pT01->T01_modulation_type ) // Is using OFDM
-			{
-				//CTS + 1 SIFS + CTS duration
-				//CTS Rate : 24 Mega bps
-				//CTS frame length = 14 bytes
-				Duration += (DEFAULT_SIFSTIME +
-								PREAMBLE_PLUS_SIGNAL_PLUS_SIGNALEXTENSION +
-								((112 + 22 + 95)/96)*Tsym);
-			}
-			else
-			{
-				//CTS + 1 SIFS + CTS duration
-				//CTS Rate : ?? Mega bps
-				//CTS frame length = 14 bytes
-				if( pT01->T01_plcp_header_length ) //long preamble
-					Duration += LONG_PREAMBLE_PLUS_PLCPHEADER_TIME;
-				else
-					Duration += SHORT_PREAMBLE_PLUS_PLCPHEADER_TIME;
-
-				Duration += ( ((112 + Rate-1) / Rate) + DEFAULT_SIFSTIME );
-			}
-		}
-
-		// Set the value into USB descriptor
-		pT01->T01_add_rts = RTS_on ? 1 : 0;
-		pT01->T01_add_cts = CTS_on ? 1 : 0;
-		pT01->T01_rts_cts_duration = Duration;
-	}
-
-	//=====================================
-	// Fill the more fragment descriptor
-	//=====================================
-	if( boGroupAddr )
-		Duration = 0;
-	else
-	{
-		for( i=pDes->FragmentCount-1; i>0; i-- )
-		{
-			NextBodyLen = (u16)pNextT00->T00_frame_length;
-			NextBodyLen += 4;	//CRC
-
-			if( pT01->T01_modulation_type )
-			{
-				//OFDM
-				// data transmit time + 3 SIFS + 2 ACK
-				// Rate : ??Mega bps
-				// ACK frame length = 14 bytes, tx rate = 24M
-				Duration = PREAMBLE_PLUS_SIGNAL_PLUS_SIGNALEXTENSION * 3;
-				Duration += (((NextBodyLen*8 + 22 + Rate*4 - 1)/(Rate*4)) * Tsym +
-							(((2*14)*8 + 22 + 95)/96)*Tsym +
-							DEFAULT_SIFSTIME*3);
-			}
-			else
-			{
-				//DSSS
-				// data transmit time + 2 ACK + 3 SIFS
-				// Rate : ??Mega bps
-				// ACK frame length = 14 bytes
-				//TODO :
-				if( pT01->T01_plcp_header_length ) //long preamble
-					Duration = LONG_PREAMBLE_PLUS_PLCPHEADER_TIME*3;
-				else
-					Duration = SHORT_PREAMBLE_PLUS_PLCPHEADER_TIME*3;
-
-				Duration += ( ((NextBodyLen + (2*14))*8 + Rate-1) / Rate +
-							DEFAULT_SIFSTIME*3 );
-			}
-
-			((u16 *)buffer)[5] = cpu_to_le16(Duration);// 4 USHOR for skip 8B USB, 2USHORT=FC + Duration
-
-			//----20061009 add by anson's endian
-			pNextT00->value = cpu_to_le32(pNextT00->value);
-			pT01->value = cpu_to_le32( pT01->value );
-			//----end 20061009 add by anson's endian
-
-			buffer += OffsetSize;
-			pT01 = (PT01_DESCRIPTOR)(buffer+4);
-			if (i != 1)	//The last fragment will not have the next fragment
-				pNextT00 = (PT00_DESCRIPTOR)(buffer+OffsetSize);
-		}
-
-		//=====================================
-		// Fill the last fragment descriptor
-		//=====================================
-		if( pT01->T01_modulation_type )
-		{
-			//OFDM
-			// 1 SIFS + 1 ACK
-			// Rate : 24 Mega bps
-			// ACK frame length = 14 bytes
-			Duration = PREAMBLE_PLUS_SIGNAL_PLUS_SIGNALEXTENSION;
-			//The Tx rate of ACK use 24M
-			Duration += (((112 + 22 + 95)/96)*Tsym + DEFAULT_SIFSTIME );
-		}
-		else
-		{
-			// DSSS
-			// 1 ACK + 1 SIFS
-			// Rate : ?? Mega bps
-			// ACK frame length = 14 bytes(112 bits)
-			if( pT01->T01_plcp_header_length ) //long preamble
-				Duration = LONG_PREAMBLE_PLUS_PLCPHEADER_TIME;
-			else
-				Duration = SHORT_PREAMBLE_PLUS_PLCPHEADER_TIME;
-
-			Duration += ( (112 + Rate-1)/Rate +	DEFAULT_SIFSTIME );
-		}
-	}
-
-	((u16 *)buffer)[5] = cpu_to_le16(Duration);// 4 USHOR for skip 8B USB, 2USHORT=FC + Duration
-	pT00->value = cpu_to_le32(pT00->value);
-	pT01->value = cpu_to_le32(pT01->value);
-	//--end 20061009 add
-
-}
diff --git a/drivers/staging/winbond/mds_f.h b/drivers/staging/winbond/mds_f.h
index a3724ac..8109eba 100644
--- a/drivers/staging/winbond/mds_f.h
+++ b/drivers/staging/winbond/mds_f.h
@@ -7,12 +7,8 @@
 unsigned char Mds_initial(  struct wbsoft_priv *adapter );
 void Mds_Destroy(  struct wbsoft_priv *adapter );
 void Mds_Tx(  struct wbsoft_priv *adapter );
-void Mds_HeaderCopy(  struct wbsoft_priv *adapter,  PDESCRIPTOR pDes,  u8 *TargetBuffer );
-u16 Mds_BodyCopy(  struct wbsoft_priv *adapter,  PDESCRIPTOR pDes,  u8 *TargetBuffer );
-void Mds_DurationSet(  struct wbsoft_priv *adapter,  PDESCRIPTOR pDes,  u8 *TargetBuffer );
 void Mds_SendComplete(  struct wbsoft_priv *adapter,  PT02_DESCRIPTOR pT02 );
 void Mds_MpduProcess(  struct wbsoft_priv *adapter,  PDESCRIPTOR pRxDes );
-void Mds_reset_descriptor(  struct wbsoft_priv *adapter );
 extern void DataDmp(u8 *pdata, u32 len, u32 offset);
 
 
-- 
1.5.3.7

