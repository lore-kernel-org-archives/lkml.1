Return-Path: <linux-kernel-owner+w=401wt.eu-S934101AbZHWNbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934101AbZHWNbt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934080AbZHWNbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:31:44 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:58451 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933677AbZHWNbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:31:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=t7oPKbaPI8rNnKvtlMe07qxgvWTFuREkLAWKXSFX7wCniMyUO8SuQS1UlFdpTzDOG9
         invw5glArwZLM9Jj7PFn7Aj7D1x86HWFJL63qRD7iHo3Fzz627YQYiGdBbO/LMJN3z0I
         bP/7lzCtWfgmC0p49iWkJhQbPzLUVxNq9d1Vs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:31:54 +0200
Message-Id: <20090823133154.17784.63974.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 29/33] Staging: rt2870: add eFuse support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt2870: add eFuse support

rt3070:
* remove unused bEEPROMFile field from RTMP_ADAPTER

rt2870:
* propagate eFuse support from rt3070

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/common/eeprom.c    |    7 ++-----
 drivers/staging/rt2860/common/rtmp_init.c |   10 +++-------
 drivers/staging/rt2860/rtmp.h             |    7 ++-----
 drivers/staging/rt2860/sta_ioctl.c        |    6 ++----
 drivers/staging/rt2870/common/rtusb_io.c  |    8 --------
 drivers/staging/rt2870/rt2870.h           |   16 ----------------
 6 files changed, 9 insertions(+), 45 deletions(-)

Index: b/drivers/staging/rt2860/common/eeprom.c
===================================================================
--- a/drivers/staging/rt2860/common/eeprom.c
+++ b/drivers/staging/rt2860/common/eeprom.c
@@ -291,8 +291,7 @@ VOID RTMP_EEPROM_WRITE16(
 #endif
 }
 
-//2008/09/11:KH add to support efuse<--
-#ifdef RT30xx
+#ifdef RT2870
 /*
 	========================================================================
 
@@ -1485,6 +1484,4 @@ NTSTATUS eFuseWriteRegistersFromBin(
 
 	return TRUE;
 }
-
-#endif // RT30xx //
-//2008/09/11:KH add to support efuse-->
+#endif
Index: b/drivers/staging/rt2860/common/rtmp_init.c
===================================================================
--- a/drivers/staging/rt2860/common/rtmp_init.c
+++ b/drivers/staging/rt2860/common/rtmp_init.c
@@ -2213,10 +2213,8 @@ NDIS_STATUS	NICInitializeAsic(
 	UINT32			MacCsr0 = 0;
 	NTSTATUS		Status;
 	UCHAR			Value = 0xff;
-#endif // RT2870 //
-#ifdef RT30xx
 	UINT32			eFuseCtrl;
-#endif // RT30xx //
+#endif
 	USHORT			KeyIdx;
 	INT				i,apidx;
 
@@ -2528,8 +2526,7 @@ NDIS_STATUS	NICInitializeAsic(
 	Counter&=0xffffff00;
 	Counter|=0x000001e;
 	RTMP_IO_WRITE32(pAd, USB_CYC_CFG, Counter);
-#endif // RT2870 //
-#ifdef RT30xx
+
 	pAd->bUseEfuse=FALSE;
 	RTMP_IO_READ32(pAd, EFUSE_CTRL, &eFuseCtrl);
 	pAd->bUseEfuse = ( (eFuseCtrl & 0x80000000) == 0x80000000) ? 1 : 0;
@@ -2540,9 +2537,8 @@ NDIS_STATUS	NICInitializeAsic(
 	else
 	{
 			DBGPRINT(RT_DEBUG_TRACE, ("NVM is EEPROM\n"));
-
 	}
-#endif // RT30xx //
+#endif
 
 	{
 		// for rt2860E and after, init TXOP_CTRL_CFG with 0x583f. This is for extension channel overlapping IOT.
Index: b/drivers/staging/rt2860/rtmp.h
===================================================================
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -2939,12 +2939,9 @@ typedef struct _RTMP_ADAPTER
 
 	UINT8					PM_FlgSuspend;
 
-#ifdef RT30xx
-//======efuse
+#ifdef RT2870
 	BOOLEAN		bUseEfuse;
-	BOOLEAN		bEEPROMFile;
-#endif // RT30xx //
-
+#endif
 } RTMP_ADAPTER, *PRTMP_ADAPTER;
 
 //
Index: b/drivers/staging/rt2860/sta_ioctl.c
===================================================================
--- a/drivers/staging/rt2860/sta_ioctl.c
+++ b/drivers/staging/rt2860/sta_ioctl.c
@@ -239,13 +239,11 @@ static struct {
     {"ForceGF",		        		Set_ForceGF_Proc},
 	{"LongRetry",	        		Set_LongRetryLimit_Proc},
 	{"ShortRetry",	        		Set_ShortRetryLimit_Proc},
-//2008/09/11:KH add to support efuse<--
-#ifdef RT30xx
+#ifdef RT2870
 	{"efuseFreeNumber",				set_eFuseGetFreeBlockCount_Proc},
 	{"efuseDump",					set_eFusedump_Proc},
 	{"efuseLoadFromBin",				set_eFuseLoadFromBin_Proc},
-#endif // RT30xx //
-//2008/09/11:KH add to support efuse-->
+#endif
 	{NULL,}
 };
 
Index: b/drivers/staging/rt2870/common/rtusb_io.c
===================================================================
--- a/drivers/staging/rt2870/common/rtusb_io.c
+++ b/drivers/staging/rt2870/common/rtusb_io.c
@@ -803,13 +803,9 @@ NTSTATUS	RTUSBReadEEPROM(
 {
 	NTSTATUS	Status = STATUS_SUCCESS;
 
-#ifdef RT30xx
 	if(pAd->bUseEfuse)
-	{
 		Status =eFuseRead(pAd, Offset, pData, length);
-	}
 	else
-#endif // RT30xx //
 	{
 	Status = RTUSB_VendorRequest(
 		pAd,
@@ -848,13 +844,9 @@ NTSTATUS	RTUSBWriteEEPROM(
 {
 	NTSTATUS	Status = STATUS_SUCCESS;
 
-#ifdef RT30xx
 	if(pAd->bUseEfuse)
-	{
 		Status = eFuseWrite(pAd, Offset, pData, length);
-	}
 	else
-#endif // RT30xx //
 	{
 	Status = RTUSB_VendorRequest(
 		pAd,
Index: b/drivers/staging/rt2870/rt2870.h
===================================================================
--- a/drivers/staging/rt2870/rt2870.h
+++ b/drivers/staging/rt2870/rt2870.h
@@ -135,7 +135,6 @@ typedef	struct	_MGMT_STRUC	{
 
 
 /* ----------------- EEPROM Related MACRO ----------------- */
-#ifdef RT30xx
 #define RT28xx_EEPROM_READ16(pAd, offset, var)					\
 	do {														\
 		RTUSBReadEEPROM(pAd, offset, (PUCHAR)&(var), 2);		\
@@ -150,21 +149,6 @@ typedef	struct	_MGMT_STRUC	{
 		_tmpVar = cpu2le16(var);								\
 		RTUSBWriteEEPROM(pAd, offset, (PUCHAR)&(_tmpVar), 2);	\
 	}while(0)
-#endif // RT30xx //
-#ifndef RT30xx
-#define RT28xx_EEPROM_READ16(pAd, offset, var)					\
-	do {														\
-		RTUSBReadEEPROM(pAd, offset, (PUCHAR)&(var), 2);		\
-		var = le2cpu16(var);									\
-	}while(0)
-
-#define RT28xx_EEPROM_WRITE16(pAd, offset, var)					\
-	do{															\
-		USHORT _tmpVar;											\
-		_tmpVar = cpu2le16(var);								\
-		RTUSBWriteEEPROM(pAd, offset, (PUCHAR)&(_tmpVar), 2);	\
-	}while(0)
-#endif // RT30xx //
 
 /* ----------------- TASK/THREAD Related MACRO ----------------- */
 #define RT28XX_TASK_THREAD_INIT(pAd, Status)		\
