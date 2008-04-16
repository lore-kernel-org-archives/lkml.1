Return-Path: <linux-kernel-owner+w=401wt.eu-S1755645AbYDPWmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbYDPWmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 18:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbYDPWmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 18:42:13 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:51367 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbYDPWmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 18:42:12 -0400
Date: Thu, 17 Apr 2008 00:42:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com
Subject: w35und: remove some more junk and fix divide by zero
Message-ID: <20080416224238.GA28192@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Driver now seems to work a bit better than before...

								Pavel

diff --git a/drivers/net/wireless/winbond/winbondport/mds.c b/drivers/net/wireless/winbond/winbondport/mds.c
index 8064deb..b2bd830 100644
--- a/drivers/net/wireless/winbond/winbondport/mds.c
+++ b/drivers/net/wireless/winbond/winbondport/mds.c
@@ -522,6 +522,8 @@ Mds_DurationSet(  PADAPTER Adapter,  PDE
 	OffsetSize = pDes->FragmentThreshold + 32 + 3;
 	OffsetSize &= ~0x03;
 	Rate = pDes->TxRate >> 1;
+	if (!Rate)
+		Rate = 1;
 
 	pT00 = (PT00_DESCRIPTOR)buffer;
 	pT01 = (PT01_DESCRIPTOR)(buffer+4);
@@ -620,7 +622,6 @@ Mds_DurationSet(  PADAPTER Adapter,  PDE
 		Duration = 0;
 	else
 	{
-		//for( i=0; i<pDes->FragmentCount-1; i++ )
 		for( i=pDes->FragmentCount-1; i>0; i-- )
 		{
 			NextBodyLen = (u16)pNextT00->T00_frame_length;
@@ -654,32 +655,6 @@ Mds_DurationSet(  PADAPTER Adapter,  PDE
 			}
 
 			((PUSHORT)buffer)[5] = cpu_to_le16(Duration);// 4 USHOR for skip 8B USB, 2USHORT=FC + Duration
-			#if 0 //20061009 marked by anson's endian
-			#ifdef WB_LINUX // Suitable for Big/Little endian
-			{
-				u32	ltmp;
-				ltmp = pNextT00->T00_frame_length;
-				ltmp |= (pNextT00->T00_header_length<<12);
-				ltmp |= (pNextT00->T00_tx_packet_id<<22);
-				ltmp |= (pNextT00->T00_IgnoreResult<<28);
-				ltmp |= (pNextT00->T00_IsLastMpdu<<29);
-				ltmp |= (pNextT00->T00_last_mpdu<<30);
-				ltmp |= (pNextT00->T00_first_mpdu<<31);
-				pNextT00->value = cpu_to_le32( ltmp );
-
-				ltmp = pT01->T01_retry_abort_ebable;
-				ltmp |= (pT01->T01_wep_id<<4);
-				ltmp |= (pT01->T01_transmit_rate<<6);
-				ltmp |= (pT01->T01_plcp_header_length<<9);
-				ltmp |= (pT01->T01_modulation_type<<10);
-				ltmp |= (pT01->T01_add_cts<<11);
-				ltmp |= (pT01->T01_add_rts<<12);
-				ltmp |= (pT01->T01_rts_cts_duration<<16);
-				//pT01->value = cpu_to_le16( pT01->value );
-				pT01->value = cpu_to_le32( ltmp );  //anson
-			}
-			#endif
-			#endif
 			
 			//----20061009 add by anson's endian
 			pNextT00->value = cpu_to_le32(pNextT00->value);
diff --git a/drivers/net/wireless/winbond/winbondport/mlme_auth.c b/drivers/net/wireless/winbond/winbondport/mlme_auth.c
index 916fc47..a387bba 100644
--- a/drivers/net/wireless/winbond/winbondport/mlme_auth.c
+++ b/drivers/net/wireless/winbond/winbondport/mlme_auth.c
@@ -7,225 +7,3 @@
 
 #include "os_common.h"
 
-void ProduceChallengeText(PWB32_ADAPTER Adapter, u8 *pbChallengeText, u16 index)
-{
-	u32	ltime;
-	u16	i;
-
-    ///NdisGetSystemUpTime(&ltime);
-	OS_TIMER_GET_SYS_TIME( &ltime );
-	for (i=0; i<16; i++)
-	{
-    	*(((u32 *)pbChallengeText)+i)   = (u32)((ltime+0xd35a822e)>>i); // @@ pbChallengeText is 4n alignment
-    	*(((u32 *)pbChallengeText)+(31-i))   = (u32)(ltime>>i)+0x3f489d2c; // @@
-	}
-	#ifdef _PE_STATE_DUMP_
-	WBDEBUG(("Produce challenge text\n"));
-	DataDmp(pbChallengeText, 128, 0);
-	#endif
-	memcpy( psBSS(index)->auth_challengeText, pbChallengeText, 128 );
-}
-
-//===========================================================================
-//  SendAuthenticationRequest --
-//
-//  Description:
-//    Send the authentication frame to the peer STA with auth. transaction
-//    sequence number = 1 (first frame) or 3 (third frame), depending on
-//    the current auth. session.
-//
-//  Arguments:
-//    Adapter       - The pointer to the Miniport Adapter Context
-//    peerSTAAddress- The Address of the peer STA that is desired to authen-
-//                    ticate with.
-//    iMSindex      -
-//    wAuthenType   - AUTH_OPEN_SYSTEM or AUTH_SHARED_KEY.
-//    wAuthenSeqNum -
-//    wStatus       -
-//    ChallengeText - Challenge text element. (Must with the size of 2+128 octets)
-//
-//  Return Value:
-//    -1            - Failed to send.
-//     1            - Has sent to the Tx handler.
-//============================================================================
-s8 SendAuthenticationRequest(PWB32_ADAPTER    Adapter,
-                               u16           iMSindex,
-                               u16           wAuthenType,
-                               u16           wAuthenSeqNum,
-                               u16           wStatus,
-                               PUCHAR           ChallengeText)  // PD43 20021004 Added
-{
-	struct Management_Frame*            msgHeader;
-	struct Authentication_Frame_Body*   msgBody;
-    PUCHAR                              msg;
-    u16                               frameBodyLen;
-
-
-	//TODO: If use WPA, it should use OPEN authentication
-	if (wAuthenType >= WPA_AUTH)
-		wAuthenType = OPEN_AUTH;
-
-    // Get the free data buffer
-    //
-	if ((msg = MLMEGetMMPDUBuffer(Adapter)) == NULL)
-	{
-        // No available data buffer now. Stop send the MMPDU.
-		Adapter->sMlmeFrame.wNumTxMMPDUDiscarded++;
-		//_asm{ int 3 };  //CYLiu debug
-        	return -1;
-    	}
-	msgHeader = (struct Management_Frame*) &msg[0];
-
-	// setup Frame-Header subfield
-	// first setup the frame_control header
-	msgHeader->frame_control.mac_frame_info = MAC_SUBTYPE_MNGMNT_AUTHENTICATION;
-	msgHeader->frame_control.to_ds      = 0;    // TO_DS=0 for management/control Frame
-	msgHeader->frame_control.from_ds    = 0;    // FROM_DS=0 for management/control Frame
-	msgHeader->frame_control.more_frag  = 0;
-	msgHeader->frame_control.retry	    = 0;
-	msgHeader->frame_control.more_data  = 0;
-    msgHeader->frame_control.order      = 0;    // Set by the MDS
-    msgHeader->frame_control.pwr_mgt    = 0;    // PD43 Adapter->pMac80211Parameters.iPowerSaveMode;
-    msgHeader->frame_control.WEP        = 0;
-    msgHeader->duration                 = 0;    // Set by the MDS
-	
-	memcpy( msgHeader->DA, psBSS(iMSindex)->abPeerAddress, MAC_ADDR_LENGTH );
-	memcpy( msgHeader->SA, Adapter->sLocalPara.ThisMacAddress, MAC_ADDR_LENGTH );
-	memcpy( msgHeader->BSSID, psBSS(iMSindex)->abBssID, MAC_ADDR_LENGTH );
-
-    // SW-MAC does not fill the sequence no, but may fill the fragment no in
-    // the MDS.
-    //msgHeader->Sequence_Control = 0x00b0; // need to implement this
-
-	msgBody = (struct Authentication_Frame_Body*) &msg[sizeof(struct Management_Frame)];
-	//20060926 add by anson's endian
-	msgBody->algorithmNumber = cpu_to_le16(wAuthenType);
-	msgBody->sequenceNumber  = cpu_to_le16(wAuthenSeqNum);  // PE23 20021023 Modified
-	msgBody->statusCode      = cpu_to_le16(wStatus);        // status code doesn't matter
-
-	frameBodyLen = sizeof(struct Management_Frame) + sizeof(struct Authentication_Frame_Body);
-
-    if ((ChallengeText != NULL) && (wAuthenType == SHARE_AUTH))
-    {
-        // 3rd auth. frame for Shared-key authentication
-
-        // PD43 20021127 Modified
-        // DO NOT KILL THIS COMMENT PLEASE. Austin ???? Unsure.
-        //
-        // The T-Link 11US01 11Mbps USB Adapter (ATMEL chip) does not encrypt
-        // the 3rd auth. frame.
-        // The Buffallo AP (WLAR-L11-L) and PCI AP (GW-AP11T) do not accept
-        // an encrypted 3rd auth. frame and accept unencrypted 3rd auth. frame
-        // instead.  As a result, deleted the following statementf first: WEP=1.
-        msgHeader->frame_control.WEP = 1;   // Ask the HW-MAC to encrypt this auth-request frame.
-        memcpy( &msg[30], ChallengeText, 2 + 128 ); // offset=30=sizeof(Management_Frame)+sizeof(Authentication_Frame_Body)=24+6
-        // msg[30] = ELEMENT_ID_CHALLENGE_TEXT; // PD43
-        // msg[31] = 128;                       // PD43
-        frameBodyLen = frameBodyLen + 130;   // Include the challenge Text element
-	}
-    // for IBSS Authen Procedure, PD43 20021127
-    else if ((wAuthenType == SHARE_AUTH) && (wAuthenSeqNum == 2))
-    {
-        // Need to instruct the HW-MAC to append the challenge text
-
-        // PD43 20021210 Added
-        msg[30] = ELEMENT_ID_CHALLENGE_TEXT;
-        msg[31] = 128;
-		// S/W produce the challenge text
-		ProduceChallengeText(Adapter, msg+32, iMSindex);
-        //frameBodyLen = frameBodyLen + 2;     // Include element ID and length field
-        frameBodyLen = frameBodyLen + 130;     // Include element ID and length field
-
-        // now send this message out
-		if (1 == MLMESendFrame(Adapter,
-								(u8 *)&msg[0],
-								frameBodyLen,
-								FRAME_TYPE_802_11_MANAGEMENT_CHALLENGE))
-            return 1;                           // Has sent to the Tx handler.
-        else
-		{
-			//return MLME buffer
-			MLMEfreeMMPDUBuffer(Adapter, msg);
-            return -1;
-		}
-    }
-
-    // now send this message out
-	if (1 == MLMESendFrame(Adapter,
-							(u8 *)&msg[0],
-							frameBodyLen,
-							FRAME_TYPE_802_11_MANAGEMENT))
-        return 1;                           // Has sent to the Tx handler.
-	else
-	{
-		//return MLME buffer
-		MLMEfreeMMPDUBuffer(Adapter, msg);
-		return -1;
-	}
-}
-
-
-
-// IBSS seems need not send out Deauthentication, added for DUT test
-//===========================================================================
-//  SendDeauthentication --
-//
-//  Description:
-//
-//  Arguments:
-//    Adapter       - The pointer to the Miniport Adapter Context
-//
-//  Return Value:
-//============================================================================
-s8 SendDeauthentication(PWB32_ADAPTER Adapter,
-                          u16 iMSindex,
-                          u16 reasonCode)
-{
-	PUCHAR	msg;
-	struct Management_Frame* msgHeader;
-	struct Deauthentication_Frame_Body* msgBody;
-
-	if ((msg=MLMEGetMMPDUBuffer(Adapter))==NULL)
-	{
-		Adapter->sMlmeFrame.wNumTxMMPDUDiscarded++;
-		return -1;  // fail get free msg buffer
-	}
-	msgHeader = (struct Management_Frame *) &msg[0];
-
-	// setup Frame-Header subfields
-	msgHeader->frame_control.mac_frame_info = MAC_SUBTYPE_MNGMNT_DEAUTHENTICATION;
-    msgHeader->frame_control.to_ds      = 0;    // ToDs = 0 for MMPDU
-    msgHeader->frame_control.from_ds    = 0;    // FromDs = 0 for MMPDU
-	msgHeader->frame_control.more_frag 	= 0;
-	msgHeader->frame_control.retry		= 0;
-	msgHeader->frame_control.more_data 	= 0;
-	msgHeader->frame_control.order		= 0;
-    msgHeader->frame_control.pwr_mgt    = 0;    // PD43 Adapter->pMac80211Parameters.iPowerSaveMode;
-    msgHeader->frame_control.WEP        = 0;
-    msgHeader->duration                 = 0;    // Set by the MDS.
-	
-	memcpy( msgHeader->DA, Adapter->asBSSDescriptElement[iMSindex].abPeerAddress, MAC_ADDR_LENGTH );
-	memcpy( msgHeader->SA, Adapter->sLocalPara.ThisMacAddress, MAC_ADDR_LENGTH );
-	memcpy( msgHeader->BSSID, psBSS(Adapter->sLocalPara.wConnectedSTAindex)->abBssID, MAC_ADDR_LENGTH );
-
-	// FrameSequenceNumber is generated by HW-MAC
-
-	msgBody = (struct Deauthentication_Frame_Body*) &msg[sizeof(struct Management_Frame)];
-	msgBody->reasonCode = cpu_to_le16(reasonCode); //20060926 add by anson's endian
-
-    // now send this message out
-	if (1 == MLMESendFrame( Adapter,
-					(u8 *)&msg[0],
-					sizeof(struct Management_Frame) + sizeof(struct Deauthentication_Frame_Body),
-					FRAME_TYPE_802_11_MANAGEMENT))
-        return 1;                           // Has sent to the Tx handler.
-	else
-	{
-		//return MLME buffer
-		MLMEfreeMMPDUBuffer(Adapter, msg);
-		return -1;
-	}
-
-}
-
-
diff --git a/drivers/net/wireless/winbond/winbondport/rxisr.c b/drivers/net/wireless/winbond/winbondport/rxisr.c
index e9cca3c..40c4f55 100644
--- a/drivers/net/wireless/winbond/winbondport/rxisr.c
+++ b/drivers/net/wireless/winbond/winbondport/rxisr.c
@@ -169,14 +169,8 @@ void Mds_MsduProcess(  PWB32_ADAPTER Ada
 		}
 
 		// Indicate to Upper Module
-		MDS_EthernetPacketReceive(Adapter, pRxLayer1);
 		Adapter->sLocalPara._NumRxMSDU++; // A packet be indicated
-	} else	{
-		if (!WEPed)
-			Adapter->sLocalPara._dot11WEPExcludedCount ++;
-		else
-			Adapter->sLocalPara._dot11WEPUndecryptableCount ++;
-	}// End of if( (!WEPed && !MLMEGetExcl...
+	}
 }
 
 void vRxTimerInit(PWB32_ADAPTER Adapter)
diff --git a/drivers/net/wireless/winbond/winbondport/wblinux.c b/drivers/net/wireless/winbond/winbondport/wblinux.c
index d492757..a133c9b 100644
--- a/drivers/net/wireless/winbond/winbondport/wblinux.c
+++ b/drivers/net/wireless/winbond/winbondport/wblinux.c
@@ -54,13 +54,6 @@ WBLINUX_Initial(PADAPTER Adapter)
 
 	OS_SPIN_LOCK_ALLOCATE( &pWbLinux->SpinLock );
 	OS_SPIN_LOCK_ALLOCATE( &pWbLinux->AtomicSpinLock );
-	pWbLinux->netdev->open = wb35_open;
-	pWbLinux->netdev->stop = wb35_close;
-	pWbLinux->netdev->hard_start_xmit = wb35_start_xmit;
-	pWbLinux->netdev->set_multicast_list = wb35_set_multicast;
-	pWbLinux->netdev->get_stats = wb35_netdev_stats;
-	pWbLinux->netdev->wireless_handlers = (struct iw_handler_def *)&test_iw_handlers;
-
 	return TRUE;
 }
 
@@ -107,62 +100,6 @@ #endif
 	}
 }
 
-int wb35_start_xmit(struct sk_buff *skb, struct net_device *netdev)
-{
-	PADAPTER	Adapter = netdev->priv;
-	PWBLINUX	pWbLinux = &Adapter->WbLinux;
-	PUCHAR		pBufAddress = (PUCHAR)skb->data;
-	unsigned char	IsStop = FALSE;
-
-#ifdef _PE_TX_DUMP_
-	WBDEBUG(( "[w35und]wb35_start_xmit->\n" ));
-	WBDEBUG(( "[w35und]skb=%x size=%d\n", skb, skb->len ));
-#endif
-
-	// Basic check ---------------------------------------------------
-	if (!skb || (skb->len<(DOT_3_TYPE_OFFSET+2)) || pWbLinux->shutdown || !CURRENT_LINK_ON ||
-	    (
-	    ((psLOCAL->RadioOffStatus.boHwRadioOff == TRUE) || (psLOCAL->RadioOffStatus.boSwRadioOff == TRUE)))) {
-#ifdef _PE_TX_DUMP_
-		WBDEBUG(( "[w35und] wb35_start_xmit SK_BUFF IS NOT OK ! len=%d\n", skb->len ));
-#endif
-		dev_kfree_skb( skb );
-		return 0; // Ignore this packet
-	}
-
-	// Check room space ---------------------------------------------
-	if (pWbLinux->skb_array[pWbLinux->skb_SetIndex])
-		return -EBUSY;
-
-	// Storing skb into skb_array and move point --------------------
-	pWbLinux->skb_array[ pWbLinux->skb_SetIndex ] = skb;
-	pWbLinux->skb_SetIndex++;
-	pWbLinux->skb_SetIndex %= WBLINUX_PACKET_ARRAY_SIZE;
-
-	// Does driver need to stop OS sending?
-	if ((pWbLinux->skb_array[pWbLinux->skb_SetIndex]!=NULL) && !pWbLinux->netif_state_stop) {
-		OS_SPIN_LOCK_ACQUIRED( &pWbLinux->SpinLock );
-		if (!pWbLinux->netif_state_stop) {
-			pWbLinux->netif_state_stop = 1;
-			IsStop = TRUE;
-		}
-		OS_SPIN_LOCK_RELEASED( &pWbLinux->SpinLock );
-
-		if (IsStop) {
-#ifdef _PE_TX_DUMP_
-			WBDEBUG(("[w35und] tx netif stop"));
-#endif
-			netif_stop_queue( netdev );
-		}
-	}
-
-	// Calling Mds for sending packet --------------------
-	Adapter->sLocalPara._NumTxMSDU++;
-	netdev->trans_start=jiffies;
-	Mds_Tx(Adapter);
-
-	return 0;// return 1 if asking kernel retry to send sk-buffer.
-}
 
 void
 WBLINUX_GetNextPacket(PADAPTER Adapter,  PDESCRIPTOR pDes)
@@ -246,57 +183,6 @@ #endif
 	}
 }
 
-struct net_device_stats * wb35_netdev_stats( struct net_device *netdev )
-{
-   PADAPTER Adapter = (PADAPTER)netdev->priv;
-   return &Adapter->WbLinux.stats;
-}
-
-void wb35_set_multicast( struct net_device *netdev )
-{
-   PADAPTER	Adapter = (PADAPTER)netdev->priv;
-   phw_data_t	pHwData = &Adapter->sHwData;
-   struct dev_mc_list *mcptr;
-   u8           Multcst_enable=0;
-   int i=0;
-
-   // netif_stop_queue( netdev ); not necessary for 35
-   if( netdev->flags & IFF_PROMISC )
-     {
-	//not support for this mode
-#ifdef _PE_STATE_DUMP_
-	WBDEBUG(( "[w35und] %s: promiscuous mode", netdev->name ));
-#endif
-     }
-   else if( (netdev->mc_count > DEFAULT_MULTICASTLISTMAX) || (netdev->flags & IFF_ALLMULTI) )
-     {
-	//not support for this mode
-#ifdef _PE_STATE_DUMP_
-	WBDEBUG(( "[w35und] %s: allmulti set", netdev->name ));
-#endif
-     }
-   else if( (netdev->flags & IFF_MULTICAST) || (netdev->mc_count != 0) )
-     {
-	//multicast packet with multicast address
-	Multcst_enable=1;
-	// set multicast address into regester
-	//
-	for( mcptr = netdev->mc_list; mcptr; mcptr=mcptr->next )
-	  {
-	     memcpy( Adapter->Mds.MulticastAddressesArray[i],
-			     mcptr->dmi_addr, MAC_ADDR_LENGTH );
-	     i++;
-	  }
-	Adapter->Mds.MulticastListNo = (u8)netdev->mc_count;
-	hal_set_multicast_address( &Adapter->sHwData,
-				   (PUCHAR)Adapter->Mds.MulticastAddressesArray,
-				   (u8)Adapter->Mds.MulticastListNo );
-     }
-
-   hal_set_accept_multicast( pHwData, Multcst_enable );
-   //netif_wake_queue(netdev); not necessary for 35
-}
-
 void
 WBLINUX_Destroy(PADAPTER Adapter)
 {


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
