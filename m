Return-Path: <linux-kernel-owner+w=401wt.eu-S1757917AbZGCOBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbZGCOBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 10:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757428AbZGCOAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 10:00:19 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62728 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757159AbZGCOAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 10:00:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=JfOhMjcaGCZ9XV4oVjdO4U8ObYAzmUQNOIx+1oa9t4SBFDUpnw093i8vw6G4R/V/OZ
         agFBjzf4pf69/Bcy3Ufcdgi+MMo2gHnFDUg70n+abVTQNd3jvWMYnRwaqW83Eh7fAcfz
         YzIvT6qaTM5CnBYmxKAuwikVRCFQCHHEYJ41k=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 03 Jul 2009 16:06:53 +0200
Message-Id: <20090703140653.7303.31562.sendpatchset@localhost.localdomain>
In-Reply-To: <20090703140605.7303.54416.sendpatchset@localhost.localdomain>
References: <20090703140605.7303.54416.sendpatchset@localhost.localdomain>
Subject: [PATCH 08/22] Staging: rtl8192su: remove RTL8192SU_DISABLE_CCK_RATE ifdefs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH staging] Staging: rtl8192su: remove RTL8192SU_DISABLE_CCK_RATE ifdefs

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8192su/Makefile      |    1 -
 drivers/staging/rtl8192su/r8192U_core.c |   24 ------------------------
 2 files changed, 25 deletions(-)

Index: b/drivers/staging/rtl8192su/Makefile
===================================================================
--- a/drivers/staging/rtl8192su/Makefile
+++ b/drivers/staging/rtl8192su/Makefile
@@ -12,7 +12,6 @@ EXTRA_CFLAGS += -DRTL8190_Download_Firmw
 EXTRA_CFLAGS += -DRTL8192S_PREPARE_FOR_NORMAL_RELEASE
 EXTRA_CFLAGS += -DRTL8192SU_DISABLE_IQK=1
 
-#EXTRA_CFLAGS += -DRTL8192SU_DISABLE_CCK_RATE=0
 EXTRA_CFLAGS += -DRTL8192S_DISABLE_FW_DM=0
 EXTRA_CFLAGS += -DDISABLE_BB_RF=0
 EXTRA_CFLAGS += -DRTL8192SU_USE_PARAM_TXPWR=0
Index: b/drivers/staging/rtl8192su/r8192U_core.c
===================================================================
--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -2981,10 +2981,6 @@ short rtl8192SU_tx(struct net_device *de
 	/* DWORD 0 */
 	tx_desc->TxHT = (tcb_desc->data_rate&0x80)?1:0;
 
-#ifdef RTL8192SU_DISABLE_CCK_RATE
-		if(tx_hal_is_cck_rate(tcb_desc->data_rate))
-			tcb_desc->data_rate = MGN_6M;
-#endif
 
 	tx_desc->TxRate = MRateToHwRate8190Pci(tcb_desc->data_rate);
 	//tx_desc->EnableCPUDur = tcb_desc->bTxEnableFwCalcDur;
@@ -3567,11 +3563,7 @@ void rtl8192SU_net_update(struct net_dev
 	//update Basic rate: RR, BRSR
 	rtl8192_config_rate(dev, &rate_config);	//HalSetBrateCfg
 
-#ifdef RTL8192SU_DISABLE_CCK_RATE
-	priv->basic_rate = rate_config  = rate_config & 0x150; // Disable CCK 11M, 5.5M, 2M, and 1M rates.
-#else
 	priv->basic_rate = rate_config  = rate_config & 0x15f;
-#endif
 
 	// Set RRSR rate table.
 	write_nic_byte(dev, RRSR, rate_config&0xff);
@@ -3700,11 +3692,7 @@ void rtl8192SU_update_ratr_table(struct 
 			break;
 	}
 
-#ifdef RTL8192SU_DISABLE_CCK_RATE
-	ratr_value &= 0x0FFFFFF0;
-#else
 	ratr_value &= 0x0FFFFFFF;
-#endif
 
 	// Get MAX MCS available.
 	if (   (bNMode && ((ieee->pHTInfo->IOTAction & HT_IOT_ACT_DISABLE_SHORT_GI)==0)) &&
@@ -6763,11 +6751,7 @@ static void rtl8192SU_MacConfigAfterFwDo
 
 	// Set Data Auto Rate Fallback Reg. Added by Roger, 2008.09.22.
 	for (i = 0; i < 8; i++)
-#ifdef RTL8192SU_DISABLE_CCK_RATE
-		write_nic_dword(dev, ARFR0+i*4, 0x1f0ff0f0);
-#else
 		write_nic_dword(dev, ARFR0+i*4, 0x1f0ffff0);
-#endif
 
 	//
 	// Set driver info, we only accept PHY status now.
@@ -6877,11 +6861,7 @@ void rtl8192SU_HwConfigureRTL8192SUsb(st
 	// 2008.09.23.
 	//
 	regTmp = read_nic_byte(dev, INIRTSMCS_SEL);
-#ifdef RTL8192SU_DISABLE_CCK_RATE
-	regRRSR = ((regRRSR & 0x000ffff0)<<8) | regTmp;
-#else
 	regRRSR = ((regRRSR & 0x000fffff)<<8) | regTmp;
-#endif
 
 	//
 	// Update SIFS timing.
@@ -6918,11 +6898,7 @@ void rtl8192SU_HwConfigureRTL8192SUsb(st
 
 	// Set Data Auto Rate Fallback Reg. Added by Roger, 2008.09.22.
 	for (i = 0; i < 8; i++)
-#ifdef RTL8192SU_DISABLE_CCK_RATE
-		write_nic_dword(dev, ARFR0+i*4, 0x1f0ff0f0);
-#else
 		write_nic_dword(dev, ARFR0+i*4, 0x1f0ffff0);
-#endif
 
 	//
 	// Aggregation length limit. Revised by Roger. 2008.09.22.
