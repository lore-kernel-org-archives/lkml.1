Return-Path: <linux-kernel-owner+w=401wt.eu-S1760220AbYDYPZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220AbYDYPZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 11:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbYDYPZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 11:25:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:36861 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbYDYPZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 11:25:43 -0400
Date: Fri, 25 Apr 2008 17:26:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com, linux-wireless@vger.kernel.org
Subject: w35und: clean up mds_tx function
Message-ID: <20080425152623.GD30033@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Clean up mds_tx function by removing paths that could not be
taken. Remove some evil macros.

Some more removal of evil macros.

---
commit 8a641ec6e230af50cb72311a49a69d76f56c4acd
tree 03082974f8cdc155734925b173f8c4eaa8746095
parent 0913f446261f79557bbe89df29f107f83388415a
author Pavel <pavel@amd.ucw.cz> Fri, 25 Apr 2008 17:25:26 +0200
committer Pavel <pavel@amd.ucw.cz> Fri, 25 Apr 2008 17:25:26 +0200

 drivers/net/wireless/winbond/winbondport/mds.c     |   81 +++++++-------------
 drivers/net/wireless/winbond/winbondport/mds_s.h   |   16 ----
 drivers/net/wireless/winbond/winbondport/wbhal_s.h |    2 
 .../net/wireless/winbond/winbondport/wblinux_s.h   |    1 
 4 files changed, 28 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/winbond/winbondport/mds.c b/drivers/net/wireless/winbond/winbondport/mds.c
index e7dbba7..3ef8584 100644
--- a/drivers/net/wireless/winbond/winbondport/mds.c
+++ b/drivers/net/wireless/winbond/winbondport/mds.c
@@ -3,20 +3,20 @@ #include "os_common.h"
 void
 Mds_reset_descriptor(PADAPTER Adapter)
 {
-	PMDS		pMds = &Adapter->Mds;
+	PMDS pMds = &Adapter->Mds;
 
 	pMds->TxPause = 0;
 	pMds->TxThreadCount = 0;
 	pMds->TxFillIndex = 0;
 	pMds->TxDesIndex = 0;
 	pMds->ScanTxPause = 0;
-	OS_MEMORY_CLEAR( pMds->TxOwner, ((MAX_USB_TX_BUFFER_NUMBER + 3) & ~0x03) );
+	memset(pMds->TxOwner, 0, ((MAX_USB_TX_BUFFER_NUMBER + 3) & ~0x03));
 }
 
 unsigned char
 Mds_initial(PADAPTER Adapter)
 {
-	PMDS		pMds = &Adapter->Mds;
+	PMDS pMds = &Adapter->Mds;
 
 	pMds->TxPause = FALSE;
 	pMds->TxRTSThreshold = DEFAULT_RTSThreshold;
@@ -42,7 +42,7 @@ Mds_Tx(PADAPTER Adapter)
 	PDESCRIPTOR	pTxDes = &TxDes;
 	PUCHAR		XmitBufAddress;
 	u16		XmitBufSize, PacketSize, stmp, CurrentSize, FragmentThreshold;
-	u8		FillIndex, TxDesIndex, PacketFrom, FragmentCount, FillCount;
+	u8		FillIndex, TxDesIndex, FragmentCount, FillCount;
 	unsigned char	BufferFilled = FALSE, MICAdd = 0;
 
 
@@ -69,23 +69,9 @@ Mds_Tx(PADAPTER Adapter)
 			XmitBufSize = 0;
 			FillCount = 0;
 			do {
-				// Sending packet path
-				PacketFrom = 1;
-				PacketSize = 0;
-				if (!PacketSize) {
-					if (1) { // If driver doesn't run in test mode, send MLME and normal data frame
-						PacketFrom = 2;
-						PacketSize = Adapter->sMlmeFrame.len;
-						if (!PacketSize) {
-							if (pMds->ScanTxPause)	//No management frames to transmit.
-								break;				//The scanning is progressing, so stop the data
-												//frames transmission
-							break;
-						}
-					}
-					else
-						break;
-				}
+				PacketSize = Adapter->sMlmeFrame.len;
+				if (!PacketSize)
+					break;
 
 				//For Check the buffer resource
 				FragmentThreshold = CURRENT_FRAGMENT_THRESHOLD;
@@ -105,20 +91,18 @@ Mds_Tx(PADAPTER Adapter)
 				//
 				BufferFilled = TRUE;
 
-				DESCRIPTOR_RESET(pTxDes);
+				/* Leaves first u8 intact */
+				memset((PUCHAR)pTxDes + 1, 0, sizeof(DESCRIPTOR) - 1);
+				
 				TxDesIndex = pMds->TxDesIndex;//Get the current ID
-				DESCRIPTOR_SET_ID( pTxDes, TxDesIndex );
-				pMds->TxDesFrom[ TxDesIndex ] = PacketFrom;//Storing the information of source comming from
+				pTxDes->Descriptor_ID = TxDesIndex;
+				pMds->TxDesFrom[ TxDesIndex ] = 2;//Storing the information of source comming from
 				pMds->TxDesIndex++;
 				pMds->TxDesIndex %= MAX_USB_TX_DESCRIPTOR;
 
 				// Get packet to transmit, 1:TESTSTA 2:MLME 3: Ndis data
-				if (PacketFrom == 3)
-					{ BUG(); }
-				else if (PacketFrom == 2)
-					{ GET_DESCRIPTOR_SECOND( Adapter, pTxDes ); }
-				else if (PacketFrom == 1)
-					{  }
+				
+				MLME_GetNextPacket( Adapter, pTxDes );
 
 				// Copy header. 8byte USB + 24byte 802.11Hdr. Set TxRate, Preamble type
 				Mds_HeaderCopy( Adapter, pTxDes, XmitBufAddress );
@@ -164,12 +148,7 @@ Mds_Tx(PADAPTER Adapter)
 				#endif
 
 				// Get packet to transmit completed, 1:TESTSTA 2:MLME 3: Ndis data
-				if (PacketFrom == 3)
-					{ BUG(); }
-				else if (PacketFrom == 2)
-					{ GET_DESCRIPTOR_SECOND_COMPLETED( Adapter, pTxDes ); }
-				else if (PacketFrom == 1)
-					{ BUG(); }
+				MLME_SendComplete( Adapter, 0, TRUE);
 
 				// Software TSC count 20060214
 				pMds->TxTsc++;
@@ -264,7 +243,7 @@ Mds_SendComplete(PADAPTER Adapter, PT02_
 		if( pMds->TxDesFrom[ PacketId ] == 3 )
 			{ BUG(); }
 		else if( pMds->TxDesFrom[ PacketId ] == 2 )
-			{ COMPLETE_DESCRIPTOR_SECOND( Adapter, PacketId, SendOK ); }
+			{ }
 		else if( pMds->TxDesFrom[ PacketId ] == 1 )
 			{ BUG();  }
 
@@ -309,7 +288,7 @@ Mds_HeaderCopy(PADAPTER Adapter, PDESCRI
 	pT00->value = 0;// Clear
 	pT01->value = 0;// Clear
 
-	pT00->T00_tx_packet_id = DESCRIPTOR_GET_ID( pDes );// Set packet ID
+	pT00->T00_tx_packet_id = pDes->Descriptor_ID;// Set packet ID
 	pT00->T00_header_length = 24;// Set header length
 	pT01->T01_retry_abort_ebable = 1;//921013 931130.5.h
 
@@ -325,7 +304,7 @@ Mds_HeaderCopy(PADAPTER Adapter, PDESCRI
 
 	// Set fragment threshold
 	FragmentThreshold -= (DOT_11_MAC_HEADER_SIZE + 4);
-	DESCRIPTOR_SET_FRAGMENT_THRESHOLD( pDes, FragmentThreshold );
+	pDes->FragmentThreshold = FragmentThreshold;
 
 	// Set more frag bit
 	TargetBuffer[1] |= 0x04;// Set more frag bit
@@ -338,7 +317,7 @@ Mds_HeaderCopy(PADAPTER Adapter, PDESCRI
 	//Use basic rate
 	ctmp1 = ctmpf = CURRENT_TX_RATE_FOR_MNG;
 
-	DESCRIPTOR_SET_TX_RATE( pDes, ctmp1 );
+	pDes->TxRate = ctmp1;
 	#ifdef _PE_TX_DUMP_
 	WBDEBUG(("Tx rate =%x\n", ctmp1));
 	#endif
@@ -349,7 +328,7 @@ Mds_HeaderCopy(PADAPTER Adapter, PDESCRI
 		if( i == 1 )
 			ctmp1 = ctmpf;
 
-		pMds->TxRate[DESCRIPTOR_GET_ID(pDes)][i] = ctmp1; // backup the ta rate and fall back rate
+		pMds->TxRate[pDes->Descriptor_ID][i] = ctmp1; // backup the ta rate and fall back rate
 
 		if( ctmp1 == 108) ctmp2 = 7;
 		else if( ctmp1 == 96 ) ctmp2 = 6; // Rate convert for USB
@@ -374,10 +353,10 @@ Mds_HeaderCopy(PADAPTER Adapter, PDESCRI
 	// Set preamble type
 	//
 	if ((pT01->T01_modulation_type == 0) && (pT01->T01_transmit_rate == 0))	// RATE_1M
-		DESCRIPTOR_SET_PREAMBLE_MODE( pDes, WLAN_PREAMBLE_TYPE_LONG );
+		pDes->PreambleMode =  WLAN_PREAMBLE_TYPE_LONG;
 	else
-		DESCRIPTOR_SET_PREAMBLE_MODE( pDes, CURRENT_PREAMBLE_MODE );
-	pT01->T01_plcp_header_length = DESCRIPTOR_GET_PREAMBLE_MODE( pDes );// Set preamble
+		pDes->PreambleMode =  CURRENT_PREAMBLE_MODE;
+	pT01->T01_plcp_header_length = pDes->PreambleMode;	// Set preamble
 
 }
 
@@ -399,16 +378,13 @@ Mds_BodyCopy(PADAPTER Adapter, PDESCRIPT
 	buf_index = pDes->buffer_start_index;
 
 	pT00 = (PT00_DESCRIPTOR)buffer;
-	while( SizeLeft )
-	{
+	while (SizeLeft) {
 		pT00 = (PT00_DESCRIPTOR)buffer;
 		CopySize = SizeLeft;
-		if( SizeLeft > DESCRIPTOR_GET_FRAGMENT_THRESHOLD(pDes) )
-		{
-			CopySize = DESCRIPTOR_GET_FRAGMENT_THRESHOLD(pDes);
+		if (SizeLeft > pDes->FragmentThreshold) {
+			CopySize = pDes->FragmentThreshold;
 			pT00->T00_frame_length = 24 + CopySize;//Set USB length
-		}
-		else
+		} else
 			pT00->T00_frame_length = 24 + SizeLeft;//Set USB length
 
 		SizeLeft -= CopySize;
@@ -488,8 +464,7 @@ Mds_BodyCopy(PADAPTER Adapter, PDESCRIPT
 	pT00->T00_IsLastMpdu = 1;
 	buffer = (PUCHAR)pT00 + 8; // +8 for USB hdr
 	buffer[1] &= ~0x04; // Clear more frag bit of 802.11 frame control
-	DESCRIPTOR_SET_FRAGMENT_COUNT( pDes, FragmentCount ); // Update the correct fragment number
-
+	pDes->FragmentCount = FragmentCount; // Update the correct fragment number
 	return Size;
 }
 
diff --git a/drivers/net/wireless/winbond/winbondport/mds_s.h b/drivers/net/wireless/winbond/winbondport/mds_s.h
index 2cf3b38..f929c7d 100644
--- a/drivers/net/wireless/winbond/winbondport/mds_s.h
+++ b/drivers/net/wireless/winbond/winbondport/mds_s.h
@@ -7,22 +7,6 @@ #define MDS_EVENT_INDICATE( _A, _B, _F )
 #define AUTH_REQUEST_PAIRWISE_ERROR			0		// _F flag setting
 #define AUTH_REQUEST_GROUP_ERROR			1		// _F flag setting
 
-#define QUERY_SIZE_FIRST( _A )	MDS_GetPacketSize( _A ) // 20060802
-#define QUERY_SIZE_SECOND( _A )	Adapter->sMlmeFrame.len
-#define	QUERY_SIZE_THIRD( _A )	OS_PACKET_SIZE( _A )
-
-#define GET_DESCRIPTOR_FIRST( _A, _D )	MDS_GetNextPacket( _A, _D )
-#define GET_DESCRIPTOR_SECOND( _A, _D )	MLME_GetNextPacket( _A, _D )
-#define GET_DESCRIPTOR_THIRD( _A, _D )	OS_GET_PACKET( _A, _D )	
-#define GET_DESCRIPTOR_FIRST_COMPLETED( _A, _D )	MDS_GetNextPacketComplete( _A, _D )
-#define GET_DESCRIPTOR_SECOND_COMPLETED( _A, _D )	MLME_SendComplete( _A, 0, TRUE)
-#define GET_DESCRIPTOR_THIRD_COMPLETED( _A, _D )	OS_GET_PACKET_COMPLETE( _A, _D )
-
-
-#define COMPLETE_DESCRIPTOR_FIRST( _A, _ID, _R )	MDS_SendResult( _A, _ID, _R )
-#define COMPLETE_DESCRIPTOR_SECOND( _A, _ID, _R )
-#define COMPLETE_DESCRIPTOR_THIRD( _A, _ID, _R )	OS_SEND_RESULT( _A, _ID, _R )
-
 // For variable setting
 #define CURRENT_BSS_TYPE				psBSS(psLOCAL->wConnectedSTAindex)->bBssType
 #define CURRENT_WEP_MODE				psSME->_dot11PrivacyInvoked
diff --git a/drivers/net/wireless/winbond/winbondport/wbhal_s.h b/drivers/net/wireless/winbond/winbondport/wbhal_s.h
index b41956e..7e98669 100644
--- a/drivers/net/wireless/winbond/winbondport/wbhal_s.h
+++ b/drivers/net/wireless/winbond/winbondport/wbhal_s.h
@@ -412,7 +412,6 @@ typedef struct _DESCRIPTOR {		// Skip le
 //=======================================================
 // Common operation for DESCRIPTOR
 //=======================================================
-#define DESCRIPTOR_RESET( _D ) memset((PUCHAR)_D + 1, 0, sizeof(DESCRIPTOR) - 1)
 #define DESCRIPTOR_ADD_BUFFER( _D, _A, _S ) \
 {\
 	_D->InternalUsed = _D->buffer_start_index + _D->buffer_number; \
@@ -425,7 +424,6 @@ #define DESCRIPTOR_ADD_BUFFER( _D, _A, _
 #define DESCRIPTOR_GET_TYPE( _D ) _D->Type
 #define DESCRIPTOR_SET_TYPE( _D, _T ) _D->Type = _T
 #define DESCRIPTOR_GET_ID( _D ) _D->Descriptor_ID
-#define DESCRIPTOR_SET_ID( _D, _T ) _D->Descriptor_ID = _T
 #define DESCRIPTOR_GET_FRAGMENT_COUNT( _D ) _D->FragmentCount
 #define DESCRIPTOR_SET_FRAGMENT_COUNT( _D, _T ) _D->FragmentCount = _T
 #define DESCRIPTOR_GET_FRAGMENT_THRESHOLD( _D ) _D->FragmentThreshold
diff --git a/drivers/net/wireless/winbond/winbondport/wblinux_s.h b/drivers/net/wireless/winbond/winbondport/wblinux_s.h
index 5f483b7..97e9167 100644
--- a/drivers/net/wireless/winbond/winbondport/wblinux_s.h
+++ b/drivers/net/wireless/winbond/winbondport/wblinux_s.h
@@ -2,7 +2,6 @@
 // wblinux_s.h
 //
 #define OS_MEMORY_ALLOC( _V, _S )	WBLINUX_MemoryAlloc( _V, _S )
-#define OS_PACKET_SIZE( _A )		(!Adapter->WbLinux.shutdown && Adapter->WbLinux.skb_array[Adapter->WbLinux.skb_GetIndex]) ? (u16)Adapter->WbLinux.skb_array[Adapter->WbLinux.skb_GetIndex]->len : 0
 #define OS_LINK_STATUS			(Adapter->WbLinux.LinkStatus == OS_CONNECTED)
 #define OS_SET_SHUTDOWN( _A )		_A->WbLinux.shutdown=1
 #define OS_SET_RESUME( _A )		_A->WbLinux.shutdown=0

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
