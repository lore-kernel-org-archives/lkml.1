Return-Path: <linux-kernel-owner+w=401wt.eu-S934047AbZHWNbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934047AbZHWNbF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934005AbZHWNbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:31:03 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:58451 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933994AbZHWNa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:30:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=qQSbeLJlRiilOcbnnQZVA+cNVWHtU1C7vioiLPdrudvw2YHhETc62IfB8BNylSoix0
         DodWbDNyIlDTjiK6NRwaZd4QsDzJ6FmcuaXUpxldgcK52HtlfgtYAlCTdz5nC//DyUNb
         24SzDUJhiKSgYgAU+zQEQ2F6vakT4PGdxppe0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:31:28 +0200
Message-Id: <20090823133128.17784.37120.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 25/33] Staging: rt3070: remove unused MiniportDataMMRequest()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt3070: remove unused MiniportDataMMRequest()

Then remove no longer needed MlmeDataHardTransmit().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/common/cmm_data.c |  126 -------------------------------
 drivers/staging/rt2860/rtmp.h            |    8 -
 2 files changed, 1 insertion(+), 133 deletions(-)

Index: b/drivers/staging/rt2860/common/cmm_data.c
===================================================================
--- a/drivers/staging/rt2860/common/cmm_data.c
+++ b/drivers/staging/rt2860/common/cmm_data.c
@@ -252,114 +252,6 @@ NDIS_STATUS MiniportMMRequestUnlock(
 	return Status;
 }
 #endif
-#ifdef RT30xx
-NDIS_STATUS MlmeDataHardTransmit(
-	IN	PRTMP_ADAPTER	pAd,
-	IN	UCHAR	QueIdx,
-	IN	PNDIS_PACKET	pPacket);
-
-#define MAX_DATAMM_RETRY	3
-/*
-	========================================================================
-
-	Routine Description:
-		API for MLME to transmit management frame to AP (BSS Mode)
-	or station (IBSS Mode)
-
-	Arguments:
-		pAd Pointer to our adapter
-		pData		Pointer to the outgoing 802.11 frame
-		Length		Size of outgoing management frame
-
-	Return Value:
-		NDIS_STATUS_FAILURE
-		NDIS_STATUS_PENDING
-		NDIS_STATUS_SUCCESS
-
-	IRQL = PASSIVE_LEVEL
-	IRQL = DISPATCH_LEVEL
-
-	Note:
-
-	========================================================================
-*/
-NDIS_STATUS MiniportDataMMRequest(
-							 IN  PRTMP_ADAPTER   pAd,
-							 IN  UCHAR           QueIdx,
-							 IN  PUCHAR          pData,
-							 IN  UINT            Length)
-{
-	PNDIS_PACKET    pPacket;
-	NDIS_STATUS  Status = NDIS_STATUS_SUCCESS;
-	ULONG    FreeNum;
-	int 	retry = 0;
-	UCHAR           IrqState;
-	UCHAR			rtmpHwHdr[TXINFO_SIZE + TXWI_SIZE]; //RTMP_HW_HDR_LEN];
-
-	ASSERT(Length <= MGMT_DMA_BUFFER_SIZE);
-
-	// 2860C use Tx Ring
-	IrqState = pAd->irq_disabled;
-
-	do
-	{
-		// Reset is in progress, stop immediately
-		if (RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_RESET_IN_PROGRESS) ||
-			 RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_HALT_IN_PROGRESS | fRTMP_ADAPTER_NIC_NOT_EXIST)||
-			!RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_START_UP))
-		{
-			Status = NDIS_STATUS_FAILURE;
-			break;
-		}
-
-		// Check Free priority queue
-		// Since we use PBF Queue2 for management frame.  Its corresponding DMA ring should be using TxRing.
-
-		// 2860C use Tx Ring
-
-		// free Tx(QueIdx) resources
-		FreeNum = GET_TXRING_FREENO(pAd, QueIdx);
-
-		if ((FreeNum > 0))
-		{
-			// We need to reserve space for rtmp hardware header. i.e., TxWI for RT2860 and TxInfo+TxWI for RT2870
-			NdisZeroMemory(&rtmpHwHdr, (TXINFO_SIZE + TXWI_SIZE));
-			Status = RTMPAllocateNdisPacket(pAd, &pPacket, (PUCHAR)&rtmpHwHdr, (TXINFO_SIZE + TXWI_SIZE), pData, Length);
-			if (Status != NDIS_STATUS_SUCCESS)
-			{
-				DBGPRINT(RT_DEBUG_WARN, ("MiniportMMRequest (error:: can't allocate NDIS PACKET)\n"));
-				break;
-			}
-
-			//pAd->CommonCfg.MlmeTransmit.field.MODE = MODE_CCK;
-			//pAd->CommonCfg.MlmeRate = RATE_2;
-
-
-			Status = MlmeDataHardTransmit(pAd, QueIdx, pPacket);
-			if (Status != NDIS_STATUS_SUCCESS)
-				RTMPFreeNdisPacket(pAd, pPacket);
-			retry = MAX_DATAMM_RETRY;
-		}
-		else
-		{
-			retry ++;
-
-			printk("retry %d\n", retry);
-			pAd->RalinkCounters.MgmtRingFullCount++;
-
-			if (retry >= MAX_DATAMM_RETRY)
-			{
-				DBGPRINT(RT_DEBUG_ERROR, ("Qidx(%d), not enough space in DataRing, MgmtRingFullCount=%ld!\n",
-											QueIdx, pAd->RalinkCounters.MgmtRingFullCount));
-			}
-		}
-
-	} while (retry < MAX_DATAMM_RETRY);
-
-
-	return Status;
-}
-#endif /* RT30xx */
 
 /*
 	========================================================================
@@ -588,24 +480,6 @@ NDIS_STATUS MlmeHardTransmitTxRing(
 }
 #endif /* RT2860 */
 
-#ifdef RT30xx
-NDIS_STATUS MlmeDataHardTransmit(
-	IN	PRTMP_ADAPTER	pAd,
-	IN	UCHAR	QueIdx,
-	IN	PNDIS_PACKET	pPacket)
-{
-	if ((pAd->CommonCfg.RadarDetect.RDMode != RD_NORMAL_MODE)
-		)
-	{
-		return NDIS_STATUS_FAILURE;
-	}
-
-#ifdef RT2870
-	return MlmeHardTransmitMgmtRing(pAd,QueIdx,pPacket);
-#endif // RT2870 //
-}
-#endif /* RT30xx */
-
 NDIS_STATUS MlmeHardTransmitMgmtRing(
 	IN	PRTMP_ADAPTER	pAd,
 	IN	UCHAR	QueIdx,
Index: b/drivers/staging/rt2860/rtmp.h
===================================================================
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -3556,13 +3556,7 @@ NDIS_STATUS MiniportMMRequest(
 	IN	UCHAR			QueIdx,
 	IN	PUCHAR			pData,
 	IN  UINT            Length);
-#ifdef RT2870
-NDIS_STATUS MiniportDataMMRequest(
-	 IN  PRTMP_ADAPTER   pAd,
-	 IN  UCHAR           QueIdx,
-	 IN  PUCHAR          pData,
-	 IN  UINT            Length);
-#endif
+
 VOID RTMPSendNullFrame(
 	IN  PRTMP_ADAPTER   pAd,
 	IN  UCHAR           TxRate,
