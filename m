Return-Path: <linux-kernel-owner+w=401wt.eu-S933768AbZHWN20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933768AbZHWN20 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933714AbZHWN2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:28:24 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:58451 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933713AbZHWN2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:28:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Qt8FPsd4JXz2qovCKsD8WP/lfzZ1g0gNrBknUUI9AtPURYo+fmLoYODa0G0KRfGcLb
         3V5BNDgyQT2xxG5WHM3e9OnBpvtYiG/m8ipV7DJxLbUxvPTEFnYQwQ9U/oqKRHgOUd8x
         Txf7dkX55ydnKBP0CA5wfFZ7KOl1o3s366vPY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:28:52 +0200
Message-Id: <20090823132852.17784.9175.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 01/33] Staging: rtxxxx: unify AsicRxAntEvalTimeout()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rtxxxx: unify AsicRxAntEvalTimeout()

Unify RT30xx and !RT30xx code in AsicRxAntEvalTimeout().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/common/mlme.c |   79 +++--------------------------------
 1 file changed, 7 insertions(+), 72 deletions(-)

Index: b/drivers/staging/rt2860/common/mlme.c
===================================================================
--- a/drivers/staging/rt2860/common/mlme.c
+++ b/drivers/staging/rt2860/common/mlme.c
@@ -8233,85 +8233,19 @@ VOID AsicRxAntEvalTimeout(
 	UCHAR			BBPR3 = 0;
 	CHAR			larger = -127, rssi0, rssi1, rssi2;
 
-#ifndef RT30xx
-	{
-		if (RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_RESET_IN_PROGRESS)	||
-			RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_HALT_IN_PROGRESS)		||
-			RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_RADIO_OFF)			||
-			RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_NIC_NOT_EXIST))
-			return;
-
-		if (pAd->StaCfg.Psm == PWR_SAVE)
-			return;
-
-
-		// if the traffic is low, use average rssi as the criteria
-		if (pAd->Mlme.bLowThroughput == TRUE)
-		{
-			rssi0 = pAd->StaCfg.RssiSample.LastRssi0;
-			rssi1 = pAd->StaCfg.RssiSample.LastRssi1;
-			rssi2 = pAd->StaCfg.RssiSample.LastRssi2;
-		}
-		else
-		{
-			rssi0 = pAd->StaCfg.RssiSample.AvgRssi0;
-			rssi1 = pAd->StaCfg.RssiSample.AvgRssi1;
-			rssi2 = pAd->StaCfg.RssiSample.AvgRssi2;
-		}
-
-		if(pAd->Antenna.field.RxPath == 3)
-		{
-			larger = max(rssi0, rssi1);
-
-			if (larger > (rssi2 + 20))
-				pAd->Mlme.RealRxPath = 2;
-			else
-				pAd->Mlme.RealRxPath = 3;
-		}
-		else if(pAd->Antenna.field.RxPath == 2)
-		{
-			if (rssi0 > (rssi1 + 20))
-				pAd->Mlme.RealRxPath = 1;
-			else
-				pAd->Mlme.RealRxPath = 2;
-		}
-
-		RTMP_BBP_IO_READ8_BY_REG_ID(pAd, BBP_R3, &BBPR3);
-		BBPR3 &= (~0x18);
-		if(pAd->Mlme.RealRxPath == 3)
-		{
-			BBPR3 |= (0x10);
-		}
-		else if(pAd->Mlme.RealRxPath == 2)
-		{
-			BBPR3 |= (0x8);
-		}
-		else if(pAd->Mlme.RealRxPath == 1)
-		{
-			BBPR3 |= (0x0);
-		}
-		RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R3, BBPR3);
-#ifdef RT2860
-		pAd->StaCfg.BBPR3 = BBPR3;
-#endif
-	}
-#endif /* RT30xx */
-#ifdef RT30xx
 	if (RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_RESET_IN_PROGRESS	|
 							fRTMP_ADAPTER_HALT_IN_PROGRESS	|
 							fRTMP_ADAPTER_RADIO_OFF			|
-							fRTMP_ADAPTER_NIC_NOT_EXIST) ||
-							OPSTATUS_TEST_FLAG(pAd, fOP_STATUS_DOZE)
+							fRTMP_ADAPTER_NIC_NOT_EXIST)
 #ifdef RT30xx
+							|| OPSTATUS_TEST_FLAG(pAd, fOP_STATUS_DOZE)
 							|| (pAd->EepromAccess)
 #endif // RT30xx //
 							)
 		return;
 
 	{
-		//if (pAd->StaCfg.Psm == PWR_SAVE)
-		//	return;
-
+#ifdef RT30xx
 		if (pAd->NicConfig2.field.AntDiversity)
 		{
 			if ((pAd->RxAnt.RcvPktNumWhenEvaluate != 0) && (pAd->RxAnt.Pair1AvgRssi[pAd->RxAnt.Pair1SecondaryRxAnt] >= pAd->RxAnt.Pair1AvgRssi[pAd->RxAnt.Pair1PrimaryRxAnt]))
@@ -8343,6 +8277,7 @@ VOID AsicRxAntEvalTimeout(
 					pAd->RxAnt.Pair1PrimaryRxAnt, (pAd->RxAnt.Pair1AvgRssi[0] >> 3), (pAd->RxAnt.Pair1AvgRssi[1] >> 3), pAd->RxAnt.RcvPktNumWhenEvaluate));
 		}
 		else
+#endif
 		{
 			if (pAd->StaCfg.Psm == PWR_SAVE)
 				return;
@@ -8393,13 +8328,13 @@ VOID AsicRxAntEvalTimeout(
 				BBPR3 |= (0x0);
 			}
 			RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R3, BBPR3);
+#ifdef RT2860
+			pAd->StaCfg.BBPR3 = BBPR3;
+#endif
 		}
 	}
-#endif /* RT30xx */
 }
 
-
-
 VOID APSDPeriodicExec(
 	IN PVOID SystemSpecific1,
 	IN PVOID FunctionContext,
