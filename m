Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbZHPTao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbZHPTao (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 15:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbZHPTam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 15:30:42 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:45385 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925AbZHPTai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 15:30:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=lgCv9BIbkwBH494KSLV1LTY6sOSH96F3tNkNM4YB+akBdyOR+bSBSVltLY2M8TMYGz
         BE9ZMhxy1oWV0P9Q4J+5OuwcJ4yveZvFP3Yaj0Xa5e282lIRl+/QP6pfhi8pDk21eoun
         PueU32i9MNl/9cFDaw9+q5n3/L5WG6Lz544vI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 16 Aug 2009 21:30:38 +0200
Message-Id: <20090816193038.3789.90073.sendpatchset@localhost.localdomain>
In-Reply-To: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
References: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
Subject: [PATCH 10/22] Staging: rtxxx0: unify different RT30xx{Read,Write}RFRegister() flavors
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rtxxx0: unify different RT30xx{Read,Write}RFRegister() flavors

RTMP_IO_{READ,WRITE}32 equals RTUSB{Read,Write}MACRegister
in case of USB chipsets so unify RT30xx and !RT30xx code.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/common/mlme.c     |  111 -------------------------------
 drivers/staging/rt2860/rt28xx.h          |    3 
 drivers/staging/rt2860/rtmp.h            |   14 ---
 drivers/staging/rt2870/common/rtusb_io.c |   25 +++---
 drivers/staging/rt2870/rt2870.h          |    3 
 5 files changed, 15 insertions(+), 141 deletions(-)

Index: b/drivers/staging/rt2860/common/mlme.c
===================================================================
--- a/drivers/staging/rt2860/common/mlme.c
+++ b/drivers/staging/rt2860/common/mlme.c
@@ -5636,117 +5636,6 @@ VOID 	AsicUpdateProtect(
 }
 
 #ifdef RT30xx
-/*
-	========================================================================
-
-	Routine Description: Write RT30xx RF register through MAC
-
-	Arguments:
-
-	Return Value:
-
-	IRQL =
-
-	Note:
-
-	========================================================================
-*/
-NTSTATUS RT30xxWriteRFRegister(
-	IN	PRTMP_ADAPTER	pAd,
-	IN	UCHAR			RegID,
-	IN	UCHAR			Value)
-{
-	RF_CSR_CFG_STRUC	rfcsr;
-	UINT				i = 0;
-
-	do
-	{
-		RTMP_IO_READ32(pAd, RF_CSR_CFG, &rfcsr.word);
-
-		if (!rfcsr.field.RF_CSR_KICK)
-			break;
-		i++;
-	}
-	while ((i < RETRY_LIMIT) && (!RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_NIC_NOT_EXIST)));
-
-	if ((i == RETRY_LIMIT) || (RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_NIC_NOT_EXIST)))
-	{
-		DBGPRINT_RAW(RT_DEBUG_ERROR, ("Retry count exhausted or device removed!!!\n"));
-		return STATUS_UNSUCCESSFUL;
-	}
-
-	rfcsr.field.RF_CSR_WR = 1;
-	rfcsr.field.RF_CSR_KICK = 1;
-	rfcsr.field.TESTCSR_RFACC_REGNUM = RegID;
-	rfcsr.field.RF_CSR_DATA = Value;
-
-	RTMP_IO_WRITE32(pAd, RF_CSR_CFG, rfcsr.word);
-
-	return STATUS_SUCCESS;
-}
-
-
-/*
-	========================================================================
-
-	Routine Description: Read RT30xx RF register through MAC
-
-	Arguments:
-
-	Return Value:
-
-	IRQL =
-
-	Note:
-
-	========================================================================
-*/
-NTSTATUS RT30xxReadRFRegister(
-	IN	PRTMP_ADAPTER	pAd,
-	IN	UCHAR			RegID,
-	IN	PUCHAR			pValue)
-{
-	RF_CSR_CFG_STRUC	rfcsr;
-	UINT				i=0, k=0;
-
-	for (i=0; i<MAX_BUSY_COUNT; i++)
-	{
-		RTMP_IO_READ32(pAd, RF_CSR_CFG, &rfcsr.word);
-
-		if (rfcsr.field.RF_CSR_KICK == BUSY)
-		{
-			continue;
-		}
-		rfcsr.word = 0;
-		rfcsr.field.RF_CSR_WR = 0;
-		rfcsr.field.RF_CSR_KICK = 1;
-		rfcsr.field.TESTCSR_RFACC_REGNUM = RegID;
-		RTMP_IO_WRITE32(pAd, RF_CSR_CFG, rfcsr.word);
-		for (k=0; k<MAX_BUSY_COUNT; k++)
-		{
-			RTMP_IO_READ32(pAd, RF_CSR_CFG, &rfcsr.word);
-
-			if (rfcsr.field.RF_CSR_KICK == IDLE)
-				break;
-		}
-		if ((rfcsr.field.RF_CSR_KICK == IDLE) &&
-			(rfcsr.field.TESTCSR_RFACC_REGNUM == RegID))
-		{
-			*pValue = (UCHAR)rfcsr.field.RF_CSR_DATA;
-			break;
-		}
-	}
-	if (rfcsr.field.RF_CSR_KICK == BUSY)
-	{
-		DBGPRINT_ERR(("RF read R%d=0x%x fail, i[%d], k[%d]\n", RegID, rfcsr.word,i,k));
-		return STATUS_UNSUCCESSFUL;
-	}
-
-	return STATUS_SUCCESS;
-}
-#endif // RT30xx //
-
-#ifdef RT30xx
 // add by johnli, RF power sequence setup
 /*
 	==========================================================================
Index: b/drivers/staging/rt2860/rt28xx.h
===================================================================
--- a/drivers/staging/rt2860/rt28xx.h
+++ b/drivers/staging/rt2860/rt28xx.h
@@ -47,10 +47,11 @@
 #define PCI_EECTRL			0x0004
 #define PCI_MCUCTRL			0x0008
 
+typedef int NTSTATUS;
+
 #ifdef RT30xx
 #define	OPT_14			0x114
 
-typedef int				NTSTATUS;
 #define	RETRY_LIMIT             10
 #define STATUS_SUCCESS				0x00
 #define STATUS_UNSUCCESSFUL 		0x01
Index: b/drivers/staging/rt2860/rtmp.h
===================================================================
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -6528,7 +6528,6 @@ VOID AsicTurnOnRFClk(
 	IN PRTMP_ADAPTER 	pAd,
 	IN	UCHAR			Channel);
 
-#ifdef RT30xx
 NTSTATUS RT30xxWriteRFRegister(
 	IN	PRTMP_ADAPTER	pAd,
 	IN	UCHAR			RegID,
@@ -6539,6 +6538,7 @@ NTSTATUS RT30xxReadRFRegister(
 	IN	UCHAR			RegID,
 	IN	PUCHAR			pValue);
 
+#ifdef RT30xx
 //2008/09/11:KH add to support efuse<--
 UCHAR eFuseReadRegisters(
 	IN	PRTMP_ADAPTER	pAd,
@@ -6735,18 +6735,6 @@ NTSTATUS RTUSBWriteRFRegister(
 	IN	PRTMP_ADAPTER	pAd,
 	IN	UINT32			Value);
 
-#ifndef RT30xx
-NTSTATUS	RT30xxWriteRFRegister(
-	IN	PRTMP_ADAPTER	pAd,
-	IN	UCHAR			RegID,
-	IN	UCHAR			Value);
-
-NTSTATUS	RT30xxReadRFRegister(
-	IN	PRTMP_ADAPTER	pAd,
-	IN	UCHAR			RegID,
-	IN	PUCHAR			pValue);
-#endif
-
 NTSTATUS RTUSB_VendorRequest(
 	IN	PRTMP_ADAPTER	pAd,
 	IN	UINT32			TransferFlags,
Index: b/drivers/staging/rt2870/common/rtusb_io.c
===================================================================
--- a/drivers/staging/rt2870/common/rtusb_io.c
+++ b/drivers/staging/rt2870/common/rtusb_io.c
@@ -671,11 +671,10 @@ NTSTATUS	RTUSBWriteRFRegister(
 	return STATUS_SUCCESS;
 }
 
-#ifndef RT30xx
 /*
 	========================================================================
 
-	Routine Description: Write RT3070 RF register through MAC
+	Routine Description: Write RT30xx RF register through MAC
 
 	Arguments:
 
@@ -687,7 +686,7 @@ NTSTATUS	RTUSBWriteRFRegister(
 
 	========================================================================
 */
-NTSTATUS	RT30xxWriteRFRegister(
+NTSTATUS RT30xxWriteRFRegister(
 	IN	PRTMP_ADAPTER	pAd,
 	IN	UCHAR			RegID,
 	IN	UCHAR			Value)
@@ -697,7 +696,7 @@ NTSTATUS	RT30xxWriteRFRegister(
 
 	do
 	{
-		RTUSBReadMACRegister(pAd, RF_CSR_CFG, &rfcsr.word);
+		RTMP_IO_READ32(pAd, RF_CSR_CFG, &rfcsr.word);
 
 		if (!rfcsr.field.RF_CSR_KICK)
 			break;
@@ -716,15 +715,16 @@ NTSTATUS	RT30xxWriteRFRegister(
 	rfcsr.field.TESTCSR_RFACC_REGNUM = RegID;
 	rfcsr.field.RF_CSR_DATA = Value;
 
-	RTUSBWriteMACRegister(pAd, RF_CSR_CFG, rfcsr.word);
+	RTMP_IO_WRITE32(pAd, RF_CSR_CFG, rfcsr.word);
 
 	return STATUS_SUCCESS;
 }
 
+
 /*
 	========================================================================
 
-	Routine Description: Read RT3070 RF register through MAC
+	Routine Description: Read RT30xx RF register through MAC
 
 	Arguments:
 
@@ -736,17 +736,17 @@ NTSTATUS	RT30xxWriteRFRegister(
 
 	========================================================================
 */
-NTSTATUS	RT30xxReadRFRegister(
+NTSTATUS RT30xxReadRFRegister(
 	IN	PRTMP_ADAPTER	pAd,
 	IN	UCHAR			RegID,
 	IN	PUCHAR			pValue)
 {
 	RF_CSR_CFG_STRUC	rfcsr;
-	UINT				i=0, k;
+	UINT				i=0, k=0;
 
 	for (i=0; i<MAX_BUSY_COUNT; i++)
 	{
-		RTUSBReadMACRegister(pAd, RF_CSR_CFG, &rfcsr.word);
+		RTMP_IO_READ32(pAd, RF_CSR_CFG, &rfcsr.word);
 
 		if (rfcsr.field.RF_CSR_KICK == BUSY)
 		{
@@ -756,10 +756,10 @@ NTSTATUS	RT30xxReadRFRegister(
 		rfcsr.field.RF_CSR_WR = 0;
 		rfcsr.field.RF_CSR_KICK = 1;
 		rfcsr.field.TESTCSR_RFACC_REGNUM = RegID;
-		RTUSBWriteMACRegister(pAd, RF_CSR_CFG, rfcsr.word);
+		RTMP_IO_WRITE32(pAd, RF_CSR_CFG, rfcsr.word);
 		for (k=0; k<MAX_BUSY_COUNT; k++)
 		{
-			RTUSBReadMACRegister(pAd, RF_CSR_CFG, &rfcsr.word);
+			RTMP_IO_READ32(pAd, RF_CSR_CFG, &rfcsr.word);
 
 			if (rfcsr.field.RF_CSR_KICK == IDLE)
 				break;
@@ -773,13 +773,12 @@ NTSTATUS	RT30xxReadRFRegister(
 	}
 	if (rfcsr.field.RF_CSR_KICK == BUSY)
 	{
-		DBGPRINT_ERR(("RF read R%d=0x%x fail\n", RegID, rfcsr.word));
+		DBGPRINT_ERR(("RF read R%d=0x%x fail, i[%d], k[%d]\n", RegID, rfcsr.word,i,k));
 		return STATUS_UNSUCCESSFUL;
 	}
 
 	return STATUS_SUCCESS;
 }
-#endif /* RT30xx */
 
 /*
 	========================================================================
Index: b/drivers/staging/rt2870/rt2870.h
===================================================================
--- a/drivers/staging/rt2870/rt2870.h
+++ b/drivers/staging/rt2870/rt2870.h
@@ -407,9 +407,6 @@ extern UCHAR EpToQueue[6];
 //#undef MlmeAllocateMemory
 //#undef MlmeFreeMemory
 
-#ifndef RT30xx
-typedef int				NTSTATUS;
-#endif
 typedef struct usb_device	* PUSB_DEV;
 
 /* MACRO for linux usb */
