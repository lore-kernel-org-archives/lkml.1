Return-Path: <linux-kernel-owner+w=401wt.eu-S933839AbZHWN2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933839AbZHWN2k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933649AbZHWN2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:28:38 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:49132 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933781AbZHWN2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:28:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=cvFrUjFQJ+eXEA6GY3z2028SFMQrbz5agL/klxZ7SyHU/1BEkXq0qO1vhNi0E0XSPe
         nxx+Yj+ccE4Wrcsid97dPpw1w3MG2JP0dq1uG/EV96cCwE/PecyS9yi2uRLNH0nv0STF
         iDM3Wvz7eMWSI95Xl0nkrWzFu6UQB5Y7jo/1E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:29:05 +0200
Message-Id: <20090823132905.17784.97814.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 03/33] Staging: rtxx70: unify NICInitRT30xxRFRegisters()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rtxx70: unify NICInitRT30xxRFRegisters()

Unify RT30xx and !RT30xx code in NICInitRT30xxRFRegisters().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/common/rtmp_init.c |   41 ++++++++----------------------
 1 file changed, 12 insertions(+), 29 deletions(-)

Index: b/drivers/staging/rt2860/common/rtmp_init.c
===================================================================
--- a/drivers/staging/rt2860/common/rtmp_init.c
+++ b/drivers/staging/rt2860/common/rtmp_init.c
@@ -1263,37 +1263,20 @@ VOID NICInitRT30xxRFRegisters(IN PRTMP_A
 	INT i;
 	// Driver must read EEPROM to get RfIcType before initial RF registers
 	// Initialize RF register to default value
-#ifndef RT30xx
-        if (IS_RT3070(pAd) && ((pAd->RfIcType == RFIC_3020) ||(pAd->RfIcType == RFIC_2020)))
-        {
-                // Init RF calibration
-                // Driver should toggle RF R30 bit7 before init RF registers
-                ULONG RfReg = 0;
-                RT30xxReadRFRegister(pAd, RF_R30, (PUCHAR)&RfReg);
-                RfReg |= 0x80;
-                RT30xxWriteRFRegister(pAd, RF_R30, (UCHAR)RfReg);
-                RTMPusecDelay(1000);
-                RfReg &= 0x7F;
-                RT30xxWriteRFRegister(pAd, RF_R30, (UCHAR)RfReg);
-
-                // Initialize RF register to default value
-                for (i = 0; i < NUM_RF_REG_PARMS; i++)
-                {
-                        RT30xxWriteRFRegister(pAd, RT30xx_RFRegTable[i].Register, RT30xx_RFRegTable[i].Value);
-                }
-
-                //For RF filter Calibration
-		RTMPFilterCalibration(pAd);
-        }
-#endif
+	if (IS_RT3070(pAd)
 #ifdef RT30xx
-	if (IS_RT3070(pAd) || IS_RT3071(pAd))
+	    || IS_RT3071(pAd)
+#else
+	    && (pAd->RfIcType == RFIC_3020 || pAd->RfIcType == RFIC_2020)
+#endif
+	   )
 	{
 		// Init RF calibration
 		// Driver should toggle RF R30 bit7 before init RF registers
 		UINT32 RfReg = 0;
+#ifdef RT30xx
 		UINT32 data;
-
+#endif
 		RT30xxReadRFRegister(pAd, RF_R30, (PUCHAR)&RfReg);
 		RfReg |= 0x80;
 		RT30xxWriteRFRegister(pAd, RF_R30, (UCHAR)RfReg);
@@ -1307,7 +1290,7 @@ VOID NICInitRT30xxRFRegisters(IN PRTMP_A
 			RT30xxWriteRFRegister(pAd, RT30xx_RFRegTable[i].Register, RT30xx_RFRegTable[i].Value);
 		}
 
-		// add by johnli
+#ifdef RT30xx
 		if (IS_RT3070(pAd))
 		{
 			//  Update MAC 0x05D4 from 01xxxxxx to 0Dxxxxxx (voltage 1.2V to 1.35V) for RT3070 to improve yield rate
@@ -1345,10 +1328,10 @@ VOID NICInitRT30xxRFRegisters(IN PRTMP_A
 			data &= ~(0x20);
 			RTUSBWriteMACRegister(pAd, GPIO_SWITCH, data);
 		}
-
+#endif
 		//For RF filter Calibration
 		RTMPFilterCalibration(pAd);
-
+#ifdef RT30xx
 		// Initialize RF R27 register, set RF R27 must be behind RTMPFilterCalibration()
 		if ((pAd->MACVersion & 0xffff) < 0x0211)
 			RT30xxWriteRFRegister(pAd, RF_R27, 0x3);
@@ -1363,8 +1346,8 @@ VOID NICInitRT30xxRFRegisters(IN PRTMP_A
 			// add by johnli, RF power sequence setup, load RF normal operation-mode setup
 			RT30xxLoadRFNormalModeSetup(pAd);
 		}
-	}
 #endif
+	}
 }
 #endif // RT2870 //
 
