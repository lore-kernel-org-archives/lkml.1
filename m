Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbZHPTiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbZHPTiz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 15:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755770AbZHPTbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 15:31:09 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:45385 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200AbZHPTa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 15:30:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Hr/eiCh1eWtBKLCkCU3oQNt1RaNUVHriFZCQCFBZcitZHGcwNxXeOu3adw8oHJ3zBC
         3knJJrqHpNtAdMthWYNEbkOkS/dFffTjEuoYuvaQLr+UWJihDJ+FxzgD40vjybmKbXLq
         9pKI/1/3PxpOJ9EH/YQingDp+Kf8Y2X7Y2tQs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 16 Aug 2009 21:31:11 +0200
Message-Id: <20090816193111.3789.9342.sendpatchset@localhost.localdomain>
In-Reply-To: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
References: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
Subject: [PATCH 13/22] Staging: rtxxx0: unify MlmeCheckPsmChange()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rtxxx0: unify MlmeCheckPsmChange()

Unify RT30xx and !RT30xx code in MlmeCheckPsmChange().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/common/mlme.c |   30 ++----------------------------
 1 file changed, 2 insertions(+), 28 deletions(-)

Index: b/drivers/staging/rt2860/common/mlme.c
===================================================================
--- a/drivers/staging/rt2860/common/mlme.c
+++ b/drivers/staging/rt2860/common/mlme.c
@@ -2771,44 +2771,19 @@ VOID MlmeCheckPsmChange(
 		(pAd->StaCfg.Psm == PWR_ACTIVE) &&
 #ifdef RT2860
 		RTMP_TEST_PSFLAG(pAd, fRTMP_PS_CAN_GO_SLEEP))
-#endif
-#if !defined(RT2860) && !defined(RT30xx)
+#else
 		(pAd->Mlme.CntlMachine.CurrState == CNTL_IDLE))
 #endif
-#ifndef RT30xx
 	{
-		NdisGetSystemUpTime(&pAd->Mlme.LastSendNULLpsmTime);
-		pAd->RalinkCounters.RxCountSinceLastNULL = 0;
-		MlmeSetPsmBit(pAd, PWR_SAVE);
-		if (!(pAd->CommonCfg.bAPSDCapable && pAd->CommonCfg.APEdcaParm.bAPSDCapable))
-		{
-			RTMPSendNullFrame(pAd, pAd->CommonCfg.TxRate, FALSE);
-		}
-		else
-		{
-			RTMPSendNullFrame(pAd, pAd->CommonCfg.TxRate, TRUE);
-		}
-	}
-#endif
 #ifdef RT30xx
-//		(! RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_BSS_SCAN_IN_PROGRESS))
-		(pAd->Mlme.CntlMachine.CurrState == CNTL_IDLE) /*&&
-		(pAd->RalinkCounters.OneSecTxNoRetryOkCount == 0) &&
-		(pAd->RalinkCounters.OneSecTxRetryOkCount == 0)*/)
-	{
 		// add by johnli, use Rx OK data count per second to calculate throughput
 		// If Ttraffic is too high ( > 400 Rx per second), don't go to sleep mode. If tx rate is low, use low criteria
 		// Mode=CCK/MCS=3 => 11 Mbps, Mode=OFDM/MCS=3 => 18 Mbps
 		if (((pAd->StaCfg.HTPhyMode.field.MCS <= 3) &&
-/* Iverson mark
-				(pAd->StaCfg.HTPhyMode.field.MODE <= MODE_OFDM) &&
-*/
 				(pAd->RalinkCounters.OneSecRxOkDataCnt < (ULONG)100)) ||
 			((pAd->StaCfg.HTPhyMode.field.MCS > 3) &&
-/* Iverson mark
-			(pAd->StaCfg.HTPhyMode.field.MODE > MODE_OFDM) &&
-*/
 			(pAd->RalinkCounters.OneSecRxOkDataCnt < (ULONG)400)))
+#endif
 		{
 				// Get this time
 			NdisGetSystemUpTime(&pAd->Mlme.LastSendNULLpsmTime);
@@ -2824,7 +2799,6 @@ VOID MlmeCheckPsmChange(
 			}
 		}
 	}
-#endif
 }
 
 // IRQL = PASSIVE_LEVEL
