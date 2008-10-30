Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbYJ3REw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbYJ3REw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757050AbYJ3REb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:04:31 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:27579 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbYJ3REa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:04:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=Nhe+pHCHFxphRiz8NytSSBupDM1PQSzv3aNMyhk8r7vNrfvAX9XcbRgUo78cxQMg+i
         62oVCHw0lVg9an/3nkE4MWNHiWIOVtBW/j9qAIr/eAAIB9p4RI9p+Tdf2WzLp7bQg4kH
         dPoltAsY/2b24DLitditGzhFgAcTy1vvSZAQc=
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@suse.cz>
Subject: [PATCH 2/7] w35und: make functions local to mlmetxrx.c static
Date: Thu, 30 Oct 2008 19:04:51 +0200
Message-Id: <1225386296-19632-2-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1225386296-19632-1-git-send-email-penberg@cs.helsinki.fi>
References: <>
 <1225386296-19632-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert functions that don't have external references to static and remove the
ones that are not used at all.

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/mlmetxrx.c   |   55 +---------------------------------
 drivers/staging/winbond/mlmetxrx_f.h |    9 -----
 2 files changed, 1 insertions(+), 63 deletions(-)

diff --git a/drivers/staging/winbond/mlmetxrx.c b/drivers/staging/winbond/mlmetxrx.c
index d83795f..643ceb0 100644
--- a/drivers/staging/winbond/mlmetxrx.c
+++ b/drivers/staging/winbond/mlmetxrx.c
@@ -19,59 +19,6 @@
 
 #include "mds_f.h"
 
-void MLMEResetTxRx(struct wbsoft_priv * adapter)
-{
-	s32     i;
-
-	// Reset the interface between MDS and MLME
-	for (i = 0; i < MAX_NUM_TX_MMPDU; i++)
-		adapter->sMlmeFrame.TxMMPDUInUse[i] = false;
-	for (i = 0; i < MAX_NUM_RX_MMPDU; i++)
-		adapter->sMlmeFrame.SaveRxBufSlotInUse[i] = false;
-
-	adapter->sMlmeFrame.wNumRxMMPDUInMLME   = 0;
-	adapter->sMlmeFrame.wNumRxMMPDUDiscarded = 0;
-	adapter->sMlmeFrame.wNumRxMMPDU          = 0;
-	adapter->sMlmeFrame.wNumTxMMPDUDiscarded = 0;
-	adapter->sMlmeFrame.wNumTxMMPDU          = 0;
-	adapter->sLocalPara.boCCAbusy    = false;
-	adapter->sLocalPara.iPowerSaveMode     = PWR_ACTIVE;     // Power active
-}
-
-//=============================================================================
-//	Function:
-//    MLMEGetMMPDUBuffer()
-//
-//	Description:
-//    Return the pointer to an available data buffer with
-//    the size MAX_MMPDU_SIZE for a MMPDU.
-//
-//  Arguments:
-//    adapter   - pointer to the miniport adapter context.
-//
-//	Return value:
-//    NULL     : No available data buffer available
-//    Otherwise: Pointer to the data buffer
-//=============================================================================
-
-/* FIXME: Should this just be replaced with kmalloc() and kfree()? */
-u8 *MLMEGetMMPDUBuffer(struct wbsoft_priv * adapter)
-{
-	s32 i;
-	u8 *returnVal;
-
-	for (i = 0; i< MAX_NUM_TX_MMPDU; i++) {
-		if (adapter->sMlmeFrame.TxMMPDUInUse[i] == false)
-			break;
-	}
-	if (i >= MAX_NUM_TX_MMPDU) return NULL;
-
-	returnVal = (u8 *)&(adapter->sMlmeFrame.TxMMPDU[i]);
-	adapter->sMlmeFrame.TxMMPDUInUse[i] = true;
-
-	return returnVal;
-}
-
 //=============================================================================
 u8 MLMESendFrame(struct wbsoft_priv * adapter, u8 *pMMPDU, u16 len, u8 DataType)
 /*	DataType : FRAME_TYPE_802_11_MANAGEMENT, FRAME_TYPE_802_11_MANAGEMENT_CHALLENGE,
@@ -109,7 +56,7 @@ void MLME_GetNextPacket(struct wbsoft_priv *adapter, PDESCRIPTOR desc)
 	desc->Type = adapter->sMlmeFrame.DataType;
 }
 
-void MLMEfreeMMPDUBuffer(struct wbsoft_priv * adapter, s8 *pData)
+static void MLMEfreeMMPDUBuffer(struct wbsoft_priv *adapter, s8 *pData)
 {
 	int i;
 
diff --git a/drivers/staging/winbond/mlmetxrx_f.h b/drivers/staging/winbond/mlmetxrx_f.h
index 905c301..5f05a6e 100644
--- a/drivers/staging/winbond/mlmetxrx_f.h
+++ b/drivers/staging/winbond/mlmetxrx_f.h
@@ -15,15 +15,6 @@ MLMEProcThread(
      struct wbsoft_priv *    adapter
 	);
 
-void MLMEResetTxRx( struct wbsoft_priv * adapter);
-
-u8 *
-MLMEGetMMPDUBuffer(
-     struct wbsoft_priv *    adapter
-   );
-
-void MLMEfreeMMPDUBuffer( struct wbsoft_priv * adapter,  s8 * pData);
-
 void MLME_GetNextPacket(  struct wbsoft_priv * adapter,  PDESCRIPTOR pDes );
 u8 MLMESendFrame( struct wbsoft_priv * adapter,
 					u8	*pMMPDU,
-- 
1.5.3.7

