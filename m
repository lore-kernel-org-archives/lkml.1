Return-Path: <linux-kernel-owner+w=401wt.eu-S1758472AbZGCODt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472AbZGCODt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 10:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757702AbZGCOBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 10:01:14 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62728 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757605AbZGCOBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 10:01:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=QiZII6MvARk+0qBLlYHGqss1qny8wsyAIzVf1x0h5HkDKJvGZC7cEknAeWWRnsexNh
         lKKeFkwEixmL7pJOY5OmlUqEJRY2ii0gzzCgUIjNjPhfO+jEIA+khj47LiqL1j7fw96a
         LRwVdUaf2XoId56/jz8C/D+eu9IuMmp/R6wHw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 03 Jul 2009 16:07:48 +0200
Message-Id: <20090703140748.7303.64101.sendpatchset@localhost.localdomain>
In-Reply-To: <20090703140605.7303.54416.sendpatchset@localhost.localdomain>
References: <20090703140605.7303.54416.sendpatchset@localhost.localdomain>
Subject: [PATCH 16/22] Staging: rtl8192su: remove RTL8190_Download_Firmware_From_Header ifdefs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH staging] Staging: rtl8192su: remove RTL8190_Download_Firmware_From_Header ifdefs

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8192su/Makefile         |    1 
 drivers/staging/rtl8192su/r8192S_phy.c     |   36 -----------------------------
 drivers/staging/rtl8192su/r8192S_rtl6052.c |   11 --------
 3 files changed, 48 deletions(-)

Index: b/drivers/staging/rtl8192su/Makefile
===================================================================
--- a/drivers/staging/rtl8192su/Makefile
+++ b/drivers/staging/rtl8192su/Makefile
@@ -8,7 +8,6 @@ EXTRA_CFLAGS += -DJACKSON_NEW_RX
 EXTRA_CFLAGS += -DTHOMAS_BEACON
 
 EXTRA_CFLAGS += -DRTL8192SU
-EXTRA_CFLAGS += -DRTL8190_Download_Firmware_From_Header=1
 EXTRA_CFLAGS += -DRTL8192S_PREPARE_FOR_NORMAL_RELEASE
 EXTRA_CFLAGS += -DRTL8192SU_DISABLE_IQK=1
 
Index: b/drivers/staging/rtl8192su/r8192S_phy.c
===================================================================
--- a/drivers/staging/rtl8192su/r8192S_phy.c
+++ b/drivers/staging/rtl8192su/r8192S_phy.c
@@ -1331,13 +1331,7 @@ extern bool PHY_MACConfig8192S(struct ne
 	//
 	// Config MAC
 	//
-#if RTL8190_Download_Firmware_From_Header
 	rtStatus = phy_ConfigMACWithHeaderFile(dev);
-#else
-	// Not make sure EEPROM, add later
-	RT_TRACE(COMP_INIT, "Read MACREG.txt\n");
-	//rtStatus = phy_ConfigMACWithParaFile(dev, RTL819X_PHY_MACREG);// lzm del it temp
-#endif
 	return (rtStatus == RT_STATUS_SUCCESS) ? true:false;
 
 }
@@ -1545,7 +1539,6 @@ phy_BB8192S_Config_ParaFile(struct net_d
 	// 1. Read PHY_REG.TXT BB INIT!!
 	// We will seperate as 1T1R/1T2R/1T2R_GREEN/2T2R
 	//
-#if RTL8190_Download_Firmware_From_Header
 	if (priv->rf_type == RF_1T2R || priv->rf_type == RF_2T2R ||
 	    priv->rf_type == RF_1T1R ||priv->rf_type == RF_2T2R_GREEN)
 	{
@@ -1557,26 +1550,6 @@ phy_BB8192S_Config_ParaFile(struct net_d
 		}
 	}else
 		rtStatus = RT_STATUS_FAILURE;
-#else
-	RT_TRACE(COMP_INIT, "RF_Type == %d\n", priv->rf_type);
-	// No matter what kind of RF we always read PHY_REG.txt. We must copy different
-	// type of parameter files to phy_reg.txt at first.
-	if (priv->rf_type == RF_1T2R || priv->rf_type == RF_2T2R ||
-	    priv->rf_type == RF_1T1R ||priv->rf_type == RF_2T2R_GREEN)
-	{
-		rtStatus = phy_ConfigBBWithParaFile(dev, (char* )&szBBRegFile);
-		if(priv->rf_type != RF_2T2R && priv->rf_type != RF_2T2R_GREEN)
-		{//2008.11.10 Added by tynli. The default PHY_REG.txt we read is for 2T2R,
-		  //so we should reconfig BB reg with the right PHY parameters.
-			if(priv->rf_type == RF_1T1R)
-				rtStatus = phy_SetBBtoDiffRFWithParaFile(dev, (char* )&szBBRegto1T1RFile);
-			else if(priv->rf_type == RF_1T2R)
-				rtStatus = phy_SetBBtoDiffRFWithParaFile(dev, (char* )&szBBRegto1T2RFile);
-		}
-
-	}else
-		rtStatus = RT_STATUS_FAILURE;
-#endif
 
 	if(rtStatus != RT_STATUS_SUCCESS){
 		RT_TRACE(COMP_INIT, "phy_BB8192S_Config_ParaFile():Write BB Reg Fail!!");
@@ -1588,11 +1561,7 @@ phy_BB8192S_Config_ParaFile(struct net_d
 	//
 	if (priv->AutoloadFailFlag == false)
 	{
-#if	RTL8190_Download_Firmware_From_Header
 		rtStatus = phy_ConfigBBWithPgHeaderFile(dev,BaseBand_Config_PHY_REG);
-#else
-		rtStatus = phy_ConfigBBWithPgParaFile(dev, (char* )&szBBRegPgFile);
-#endif
 	}
 	if(rtStatus != RT_STATUS_SUCCESS){
 		RT_TRACE(COMP_INIT, "phy_BB8192S_Config_ParaFile():BB_PG Reg Fail!!");
@@ -1602,12 +1571,7 @@ phy_BB8192S_Config_ParaFile(struct net_d
 	//
 	// 3. BB AGC table Initialization
 	//
-#if RTL8190_Download_Firmware_From_Header
 	rtStatus = phy_ConfigBBWithHeaderFile(dev,BaseBand_Config_AGC_TAB);
-#else
-	RT_TRACE(COMP_INIT, "phy_BB8192S_Config_ParaFile AGC_TAB.txt\n");
-	rtStatus = phy_ConfigBBWithParaFile(Adapter, (char* )&szAGCTableFile);
-#endif
 
 	if(rtStatus != RT_STATUS_SUCCESS){
 		printk( "phy_BB8192S_Config_ParaFile():AGC Table Fail\n");
Index: b/drivers/staging/rtl8192su/r8192S_rtl6052.c
===================================================================
--- a/drivers/staging/rtl8192su/r8192S_rtl6052.c
+++ b/drivers/staging/rtl8192su/r8192S_rtl6052.c
@@ -684,21 +684,10 @@ RT_STATUS phy_RF6052_Config_ParaFile(str
 		switch(eRFPath)
 		{
 		case RF90_PATH_A:
-#if	RTL8190_Download_Firmware_From_Header
 			rtStatus= rtl8192_phy_ConfigRFWithHeaderFile(dev,(RF90_RADIO_PATH_E)eRFPath);
-#else
-			rtStatus = PHY_ConfigRFWithParaFile(Adapter, (char* )&szRadioAFile, (RF90_RADIO_PATH_E)eRFPath);
-#endif
 			break;
 		case RF90_PATH_B:
-#if	RTL8190_Download_Firmware_From_Header
 			rtStatus= rtl8192_phy_ConfigRFWithHeaderFile(dev,(RF90_RADIO_PATH_E)eRFPath);
-#else
-			if(priv->rf_type == RF_2T2R_GREEN)
-				rtStatus = PHY_ConfigRFWithParaFile(Adapter, (ps1Byte)&szRadioBGMFile, (RF90_RADIO_PATH_E)eRFPath);
-			else
-				rtStatus = PHY_ConfigRFWithParaFile(Adapter, (char* )&szRadioBFile, (RF90_RADIO_PATH_E)eRFPath);
-#endif
 			break;
 		case RF90_PATH_C:
 			break;
