Return-Path: <linux-kernel-owner+w=401wt.eu-S934070AbZHWNb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934070AbZHWNb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934054AbZHWNbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:31:23 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:49789 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934041AbZHWNbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:31:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=eLzRaF3FBE9sEUnZcuHUUdJjtn228gD1VzegXaWMHevZLlwmu35ui9xvjj9at5I5oh
         ci5SPlKsWMPRQJmrn7PGC4bbx2expLTMPU4w5kdcPVeGN5jtkMVaL90qZnfJFseVDxjC
         oeTKlAf39/57nvD+VXGwSb1UseEdon/UgQ86Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:31:47 +0200
Message-Id: <20090823133147.17784.22142.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 28/33] Staging: rtxxxx: remove unused AsicAntenna{Select,Setting}()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rtxxxx: remove unused AsicAntenna{Select,Setting}()

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/common/mlme.c      |   92 ------------------------------
 drivers/staging/rt2860/common/rtmp_init.c |    6 -
 drivers/staging/rt2860/rtmp.h             |    8 --
 3 files changed, 2 insertions(+), 104 deletions(-)

Index: b/drivers/staging/rt2860/common/mlme.c
===================================================================
--- a/drivers/staging/rt2860/common/mlme.c
+++ b/drivers/staging/rt2860/common/mlme.c
@@ -6175,98 +6175,6 @@ VOID AsicLockChannel(
 {
 }
 
-/*
-	==========================================================================
-	Description:
-
-	IRQL = PASSIVE_LEVEL
-	IRQL = DISPATCH_LEVEL
-
-	==========================================================================
- */
-VOID	AsicAntennaSelect(
-	IN	PRTMP_ADAPTER	pAd,
-	IN	UCHAR			Channel)
-{
-#ifdef RT30xx
-			if (pAd->Mlme.OneSecPeriodicRound % 2 == 1)
-			{
-				// patch for AsicSetRxAnt failed
-				pAd->RxAnt.EvaluatePeriod = 0;
-
-				// check every 2 second. If rcv-beacon less than 5 in the past 2 second, then AvgRSSI is no longer a
-				// valid indication of the distance between this AP and its clients.
-				if (OPSTATUS_TEST_FLAG(pAd, fOP_STATUS_MEDIA_STATE_CONNECTED))
-				{
-					SHORT	realavgrssi1;
-
-					// if no traffic then reset average rssi to trigger evaluation
-					if (pAd->StaCfg.NumOfAvgRssiSample < 5)
-					{
-						pAd->RxAnt.Pair1LastAvgRssi = (-99);
-						pAd->RxAnt.Pair2LastAvgRssi = (-99);
-						DBGPRINT(RT_DEBUG_TRACE, ("MlmePeriodicExec: no traffic/beacon, reset RSSI\n"));
-					}
-
-					pAd->StaCfg.NumOfAvgRssiSample = 0;
-					realavgrssi1 = (pAd->RxAnt.Pair1AvgRssi[pAd->RxAnt.Pair1PrimaryRxAnt] >> 3);
-
-					DBGPRINT(RT_DEBUG_TRACE,("Ant-realrssi0(%d), Lastrssi0(%d), EvaluateStableCnt=%d\n", realavgrssi1, pAd->RxAnt.Pair1LastAvgRssi, pAd->RxAnt.EvaluateStableCnt));
-
-					// if the difference between two rssi is larger or less than 5, then evaluate the other antenna
-					if ((pAd->RxAnt.EvaluateStableCnt < 2) || (realavgrssi1 > (pAd->RxAnt.Pair1LastAvgRssi + 5)) || (realavgrssi1 < (pAd->RxAnt.Pair1LastAvgRssi - 5)))
-					{
-						pAd->RxAnt.Pair1LastAvgRssi = realavgrssi1;
-						AsicEvaluateRxAnt(pAd);
-					}
-				}
-				else
-				{
-					// if not connected, always switch antenna to try to connect
-					UCHAR	temp;
-
-					temp = pAd->RxAnt.Pair1PrimaryRxAnt;
-					pAd->RxAnt.Pair1PrimaryRxAnt = pAd->RxAnt.Pair1SecondaryRxAnt;
-					pAd->RxAnt.Pair1SecondaryRxAnt = temp;
-
-					DBGPRINT(RT_DEBUG_TRACE, ("MlmePeriodicExec: no connect, switch to another one to try connection\n"));
-
-					AsicSetRxAnt(pAd, pAd->RxAnt.Pair1PrimaryRxAnt);
-				}
-			}
-#endif /* RT30xx */
-}
-
-/*
-	========================================================================
-
-	Routine Description:
-		Antenna miscellaneous setting.
-
-	Arguments:
-		pAd						Pointer to our adapter
-		BandState				Indicate current Band State.
-
-	Return Value:
-		None
-
-	IRQL <= DISPATCH_LEVEL
-
-	Note:
-		1.) Frame End type control
-			only valid for G only (RF_2527 & RF_2529)
-			0: means DPDT, set BBP R4 bit 5 to 1
-			1: means SPDT, set BBP R4 bit 5 to 0
-
-
-	========================================================================
-*/
-VOID	AsicAntennaSetting(
-	IN	PRTMP_ADAPTER	pAd,
-	IN	ABGBAND_STATE	BandState)
-{
-}
-
 VOID AsicRfTuningExec(
 	IN PVOID SystemSpecific1,
 	IN PVOID FunctionContext,
Index: b/drivers/staging/rt2860/common/rtmp_init.c
===================================================================
--- a/drivers/staging/rt2860/common/rtmp_init.c
+++ b/drivers/staging/rt2860/common/rtmp_init.c
@@ -1940,10 +1940,8 @@ VOID	NICInitAsicFromEEPROM(
 		pAd->bAutoTxAgcA = pAd->bAutoTxAgcG = TRUE;
 	else
 		pAd->bAutoTxAgcA = pAd->bAutoTxAgcG = FALSE;
-	//
-	// Since BBP has been progamed, to make sure BBP setting will be
-	// upate inside of AsicAntennaSelect, so reset to UNKNOWN_BAND!!
-	//
+
+	/* BBP has been programmed so reset to UNKNOWN_BAND */
 	pAd->CommonCfg.BandState = UNKNOWN_BAND;
 
 	RTMP_BBP_IO_READ8_BY_REG_ID(pAd, BBP_R3, &BBPR3);
Index: b/drivers/staging/rt2860/rtmp.h
===================================================================
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -3720,14 +3720,6 @@ VOID AsicLockChannel(
 	IN PRTMP_ADAPTER pAd,
 	IN UCHAR Channel) ;
 
-VOID AsicAntennaSelect(
-	IN  PRTMP_ADAPTER   pAd,
-	IN  UCHAR           Channel);
-
-VOID AsicAntennaSetting(
-	IN	PRTMP_ADAPTER	pAd,
-	IN	ABGBAND_STATE	BandState);
-
 VOID AsicRfTuningExec(
 	IN PVOID SystemSpecific1,
 	IN PVOID FunctionContext,
