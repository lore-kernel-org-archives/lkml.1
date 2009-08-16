Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbZHPTbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbZHPTbK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 15:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755788AbZHPTbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 15:31:08 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:55539 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790AbZHPTbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 15:31:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=cMD65KxUkE63Piexf7sDM/Bm757ovkDqZsXReTC72D1Z82j3HYIvMu1/y3aNbXRVkC
         BgzMFm27/9WnJhtJiNLYSBI/41Ub18Xt1VYoMieB/4/JNksd4K1pnUavjUPvORf+GQDA
         fLBiDKDhng3OA7NjAZ/2BqRDcSMIUnjVPB2CY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 16 Aug 2009 21:31:17 +0200
Message-Id: <20090816193117.3789.76517.sendpatchset@localhost.localdomain>
In-Reply-To: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
References: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
Subject: [PATCH 14/22] Staging: rtxxx0: unify AsicEvaluateRxAnt()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rtxxx0: unify AsicEvaluateRxAnt()

Unify RT30xx and !RT30xx code in AsicEvaluateRxAnt().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/common/mlme.c |   63 ++++++++---------------------------
 1 file changed, 15 insertions(+), 48 deletions(-)

Index: b/drivers/staging/rt2860/common/mlme.c
===================================================================
--- a/drivers/staging/rt2860/common/mlme.c
+++ b/drivers/staging/rt2860/common/mlme.c
@@ -8252,56 +8252,19 @@ VOID AsicEvaluateRxAnt(
 {
 	UCHAR	BBPR3 = 0;
 
-#ifndef RT30xx
-	{
-		if (RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_RESET_IN_PROGRESS	|
-								fRTMP_ADAPTER_HALT_IN_PROGRESS	|
-								fRTMP_ADAPTER_RADIO_OFF			|
-								fRTMP_ADAPTER_NIC_NOT_EXIST		|
-								fRTMP_ADAPTER_BSS_SCAN_IN_PROGRESS))
-			return;
-
-		if (pAd->StaCfg.Psm == PWR_SAVE)
+	if (RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_RESET_IN_PROGRESS |
+				fRTMP_ADAPTER_HALT_IN_PROGRESS |
+				fRTMP_ADAPTER_RADIO_OFF |
+				fRTMP_ADAPTER_NIC_NOT_EXIST |
+				fRTMP_ADAPTER_BSS_SCAN_IN_PROGRESS)
+#ifdef RT30xx
+				|| OPSTATUS_TEST_FLAG(pAd, fOP_STATUS_DOZE)
+				|| (pAd->EepromAccess)
+#endif
+				)
 			return;
-	}
 
-	RTMP_BBP_IO_READ8_BY_REG_ID(pAd, BBP_R3, &BBPR3);
-	BBPR3 &= (~0x18);
-	if(pAd->Antenna.field.RxPath == 3)
-	{
-		BBPR3 |= (0x10);
-	}
-	else if(pAd->Antenna.field.RxPath == 2)
-	{
-		BBPR3 |= (0x8);
-	}
-	else if(pAd->Antenna.field.RxPath == 1)
-	{
-		BBPR3 |= (0x0);
-	}
-	RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R3, BBPR3);
-
-#ifdef RT2860
-    	pAd->StaCfg.BBPR3 = BBPR3;
-#endif
-#endif /* RT30xx */
 #ifdef RT30xx
-	if (RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_RESET_IN_PROGRESS	|
-							fRTMP_ADAPTER_HALT_IN_PROGRESS	|
-							fRTMP_ADAPTER_RADIO_OFF			|
-							fRTMP_ADAPTER_NIC_NOT_EXIST		|
-							fRTMP_ADAPTER_BSS_SCAN_IN_PROGRESS) ||
-							OPSTATUS_TEST_FLAG(pAd, fOP_STATUS_DOZE)
-							|| (pAd->EepromAccess)
-							)
-		return;
-
-
-	{
-		//if (pAd->StaCfg.Psm == PWR_SAVE)
-		//	return;
-	}
-
 	// two antenna selection mechanism- one is antenna diversity, the other is failed antenna remove
 	// one is antenna diversity:there is only one antenna can rx and tx
 	// the other is failed antenna remove:two physical antenna can rx and tx
@@ -8324,6 +8287,7 @@ VOID AsicEvaluateRxAnt(
 			RTMPSetTimer(&pAd->Mlme.RxAntEvalTimer, 300);
 	}
 	else
+#endif
 	{
 		if (pAd->StaCfg.Psm == PWR_SAVE)
 			return;
@@ -8343,8 +8307,11 @@ VOID AsicEvaluateRxAnt(
 			BBPR3 |= (0x0);
 		}
 		RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R3, BBPR3);
+
+#ifdef RT2860
+		pAd->StaCfg.BBPR3 = BBPR3;
+#endif
 	}
-#endif /* RT30xx */
 
 	if (OPSTATUS_TEST_FLAG(pAd, fOP_STATUS_MEDIA_STATE_CONNECTED)
 		)
