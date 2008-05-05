Return-Path: <linux-kernel-owner+w=401wt.eu-S1760690AbYEEUIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760690AbYEEUIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbYEEUIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:08:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:49751 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbYEEUIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:08:39 -0400
Date: Mon, 5 May 2008 22:09:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com, linux-wireless@vger.kernel.org
Subject: w35und: some more code removal
Message-ID: <20080505200927.GA7273@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove some more unneccessary code

---
commit 5b251c6315097d5f9ab5d30c43813fe74c1db4e4
tree 5ca21582f55886d5f0249f7ca139687450024581
parent e44ccdabb97fa4a6cdc1a95adcad7bcc469d0c16
author Pavel <pavel@amd.ucw.cz> Mon, 05 May 2008 22:08:51 +0200
committer Pavel <pavel@amd.ucw.cz> Mon, 05 May 2008 22:08:51 +0200

 drivers/net/wireless/winbond/winbondport/mds.c     |   46 +++-----------------
 drivers/net/wireless/winbond/winbondport/wblinux.c |    8 +--
 2 files changed, 11 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/winbond/winbondport/mds.c b/drivers/net/wireless/winbond/winbondport/mds.c
index ad09d0b..44f3b61 100644
--- a/drivers/net/wireless/winbond/winbondport/mds.c
+++ b/drivers/net/wireless/winbond/winbondport/mds.c
@@ -46,10 +46,8 @@ Mds_Tx(PADAPTER Adapter)
 	unsigned char	BufferFilled = FALSE, MICAdd = 0;
 
 
-	//931130.5.a
 	if (pMds->TxPause)
 		return;
-	// 20060717.3 Add
 	if (!hal_driver_init_OK(pHwData))
 		return;
 
@@ -195,9 +193,7 @@ Mds_SendComplete(PADAPTER Adapter, PT02_
 		RetryCount = (u8)pT02->T02_MPDU_Cnt;
 		if (pT02->value & FLAG_ERROR_TX_MASK) {
 			SendOK = FALSE;
-			#ifdef _PE_DTO_DUMP_
-			WBDEBUG(("Mds Tx Fail[%d] = %8x\n", PacketId, pT02->value ));
-			#endif
+
 			if (pT02->T02_transmit_abort || pT02->T02_out_of_MaxTxMSDULiftTime) {
 				//retry error
 				pHwData->dto_tx_retry_count += (RetryCount+1);
@@ -226,25 +222,6 @@ Mds_SendComplete(PADAPTER Adapter, PT02_
 			MTO_SetTxCount(Adapter, TxRate, RetryCount);
 		}
 
-		// Return result
-		if( pMds->TxDesFrom[ PacketId ] == 3 )
-			{ BUG(); }
-		else if( pMds->TxDesFrom[ PacketId ] == 2 )
-			{ }
-		else if( pMds->TxDesFrom[ PacketId ] == 1 )
-			{ BUG();  }
-
-		//The next 802.1x message callback after 2 MIC error occur within 60s
-		//TODO: ?? Don't care whether the next 802.1x message is transmitted successfully??
-		if (pMds->TxInfo[PacketId] == 1) {
-			// It needs to send disassoc. frame no matter the connection is still
-			// alive or not(AP disassoc. us).
-			#ifdef _PE_STATE_DUMP_
-			WBDEBUG(("!!Countermeasure, disassoc !!\n"));
-			#endif
-			pMds->TxInfo[PacketId] = 0;
-			WARN_ON(1);
-		}
 		// Clear send result buffer
 		pMds->TxResult[ PacketId ] = 0;
 	} else
@@ -391,37 +368,31 @@ Mds_BodyCopy(PADAPTER Adapter, PDESCRIPT
 		stmp &= ~0x03;//4n Alignment
 		Size += stmp;// Current 4n offset of mpdu
 
-		while( CopySize )
-		{
+		while (CopySize) {
 			// Copy body
 			src_buffer = pDes->buffer_address[buf_index];
 			CopyLeft = CopySize;
-			if( CopySize >= pDes->buffer_size[buf_index] )
-			{
+			if (CopySize >= pDes->buffer_size[buf_index]) {
 				CopyLeft = pDes->buffer_size[buf_index];
 
 				// Get the next buffer of descriptor
 				buf_index++;
 				buf_index %= MAX_DESCRIPTOR_BUFFER_INDEX;
-			}
-			else
-			{
+			} else {
 				PUCHAR	pctmp = pDes->buffer_address[buf_index];
 				pctmp += CopySize;
 				pDes->buffer_address[buf_index] = pctmp;
 				pDes->buffer_size[buf_index] -= CopySize;
 			}
 
-			memcpy( buffer,	src_buffer, CopyLeft );
+			memcpy(buffer, src_buffer, CopyLeft);
 			buffer += CopyLeft;
 			CopySize -= CopyLeft;
 		}
 
 		// 931130.5.n
-		if( pMds->MicAdd )
-		{
-			if( !SizeLeft ) //931130.5.o
-			{
+		if (pMds->MicAdd) {
+			if (!SizeLeft) {
 				pMds->MicWriteAddress[ pMds->MicWriteIndex ] = buffer - pMds->MicAdd;
 				pMds->MicWriteSize[ pMds->MicWriteIndex ] = pMds->MicAdd;
 				pMds->MicAdd = 0;
@@ -436,8 +407,7 @@ Mds_BodyCopy(PADAPTER Adapter, PDESCRIPT
 		}
 
 		// Does it need to generate the new header for next mpdu?
-		if( SizeLeft )
-		{
+		if (SizeLeft) {
 			buffer = TargetBuffer + Size; // Get the next 4n start address
 			memcpy( buffer, TargetBuffer, 32 );//Copy 8B USB +24B 802.11
 			pT00 = (PT00_DESCRIPTOR)buffer;
diff --git a/drivers/net/wireless/winbond/winbondport/wblinux.c b/drivers/net/wireless/winbond/winbondport/wblinux.c
index 3e6a0d3..d2b86cb 100644
--- a/drivers/net/wireless/winbond/winbondport/wblinux.c
+++ b/drivers/net/wireless/winbond/winbondport/wblinux.c
@@ -256,8 +256,7 @@ #endif
 	}
 	while(FALSE);
 
-	switch( InitStep )
-	{
+	switch (InitStep) {
 	case 5: 
 	case 4: 
 	case 3: Mds_Destroy( Adapter );
@@ -270,11 +269,10 @@ #endif
 	return FALSE;
 }
 
-// 20060802
 void WBLINUX_ConnectStatus(PADAPTER Adapter, u32 flag)
 {
-   PWBLINUX	pWbLinux = &Adapter->WbLinux;
+	PWBLINUX	pWbLinux = &Adapter->WbLinux;
 
-   pWbLinux->LinkStatus = flag; // OS_DISCONNECTED	or  OS_CONNECTED
+	pWbLinux->LinkStatus = flag; // OS_DISCONNECTED	or  OS_CONNECTED
 }
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
