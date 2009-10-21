Return-Path: <linux-kernel-owner+w=401wt.eu-S1753774AbZJUUoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbZJUUoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 16:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbZJUUoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 16:44:08 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:39437 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbZJUUoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 16:44:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=xpPuAM2gJp5wfUVjlHylPTv8gOp3J7Ro0kK7kdssgoXmVntknmwBIhk0uRUkHaSWsG
         HpB2AWESgLDFhRvPAOQm806dqnjYBccJC4cweEyCSZzBhQt/msBVzqIrJhGzHSaIk+kY
         f1pnGQXD29+5ZjEyIpMIXf+TItRo6ceHKm5NI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 21 Oct 2009 22:43:51 +0200
Message-Id: <20091021204351.4593.80897.sendpatchset@localhost.localdomain>
In-Reply-To: <20091021204344.4593.99070.sendpatchset@localhost.localdomain>
References: <20091021204344.4593.99070.sendpatchset@localhost.localdomain>
Subject: [PATCH 01/12] Staging: rt28x0: remove unused ->eewrite methods
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt28x0: remove unused ->eewrite methods

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/common/ee_efuse.c |   17 ----------
 drivers/staging/rt2860/common/ee_prom.c  |   48 -------------------------------
 drivers/staging/rt2860/common/eeprom.c   |    3 -
 drivers/staging/rt2860/eeprom.h          |   15 ---------
 drivers/staging/rt2860/rtmp.h            |    1 
 drivers/staging/rt2860/rtmp_chip.h       |    4 --
 drivers/staging/rt2870/common/rtusb_io.c |   11 -------
 7 files changed, 99 deletions(-)

Index: b/drivers/staging/rt2860/common/ee_efuse.c
===================================================================
--- a/drivers/staging/rt2860/common/ee_efuse.c
+++ b/drivers/staging/rt2860/common/ee_efuse.c
@@ -1271,23 +1271,6 @@ int rtmp_ee_efuse_read16(
 	return (*pValue);
 }
 
-
-int rtmp_ee_efuse_write16(
-	IN RTMP_ADAPTER *pAd,
-	IN USHORT Offset,
-	IN USHORT data)
-{
-    if(pAd->bFroceEEPROMBuffer||pAd->bEEPROMFile)
-    {
-        DBGPRINT(RT_DEBUG_TRACE,  ("Write to EEPROM Buffer\n"));
-        NdisMoveMemory(&(pAd->EEPROMImage[Offset]), &data, 2);
-    }
-    else
-        eFuseWriteRegisters(pAd, Offset, 2, &data);
-	return 0;
-}
-
-
 int RtmpEfuseSupportCheck(
 	IN RTMP_ADAPTER *pAd)
 {
Index: b/drivers/staging/rt2860/common/ee_prom.c
===================================================================
--- a/drivers/staging/rt2860/common/ee_prom.c
+++ b/drivers/staging/rt2860/common/ee_prom.c
@@ -220,51 +220,3 @@ int rtmp_ee_prom_read16(
 
 	return NDIS_STATUS_SUCCESS;
 }
-
-
-int rtmp_ee_prom_write16(
-    IN  PRTMP_ADAPTER	pAd,
-    IN  USHORT Offset,
-    IN  USHORT Data)
-{
-	UINT32 x;
-
-
-	Offset /= 2;
-
-	EWEN(pAd);
-
-	// reset bits and set EECS
-	RTMP_IO_READ32(pAd, E2PROM_CSR, &x);
-	x &= ~(EEDI | EEDO | EESK);
-	x |= EECS;
-	RTMP_IO_WRITE32(pAd, E2PROM_CSR, x);
-
-	// patch can not access e-Fuse issue
-	if (!(IS_RT3090(pAd) || IS_RT3572(pAd) || IS_RT3390(pAd)))
-	{
-		// kick a pulse
-		RaiseClock(pAd, &x);
-		LowerClock(pAd, &x);
-	}
-
-	// output the read_opcode ,register number and data in that order
-	ShiftOutBits(pAd, EEPROM_WRITE_OPCODE, 3);
-	ShiftOutBits(pAd, Offset, pAd->EEPROMAddressNum);
-	ShiftOutBits(pAd, Data, 16);		// 16-bit access
-
-	// read DO status
-	RTMP_IO_READ32(pAd, E2PROM_CSR, &x);
-
-	EEpromCleanup(pAd);
-
-	RTMPusecDelay(10000);	//delay for twp(MAX)=10ms
-
-	EWDS(pAd);
-
-	EEpromCleanup(pAd);
-
-
-	return NDIS_STATUS_SUCCESS;
-
-}
Index: b/drivers/staging/rt2860/common/eeprom.c
===================================================================
--- a/drivers/staging/rt2860/common/eeprom.c
+++ b/drivers/staging/rt2860/common/eeprom.c
@@ -66,7 +66,6 @@ INT RtmpChipOpsEepromHook(
 			{
 		pChipOps->eeinit = eFuse_init;
 		pChipOps->eeread = rtmp_ee_efuse_read16;
-		pChipOps->eewrite = rtmp_ee_efuse_write16;
 		return 0 ;
 	     }
 		else
@@ -83,14 +82,12 @@ INT RtmpChipOpsEepromHook(
 		case RTMP_DEV_INF_PCI:
 			pChipOps->eeinit = NULL;
 			pChipOps->eeread = rtmp_ee_prom_read16;
-			pChipOps->eewrite = rtmp_ee_prom_write16;
 					break;
 #endif // RTMP_PCI_SUPPORT //
 #ifdef RTMP_USB_SUPPORT
 		case RTMP_DEV_INF_USB:
 			pChipOps->eeinit = NULL;
 			pChipOps->eeread = RTUSBReadEEPROM16;
-			pChipOps->eewrite = RTUSBWriteEEPROM16;
 					break;
 #endif // RTMP_USB_SUPPORT //
 
Index: b/drivers/staging/rt2860/eeprom.h
===================================================================
--- a/drivers/staging/rt2860/eeprom.h
+++ b/drivers/staging/rt2860/eeprom.h
@@ -48,11 +48,6 @@ int rtmp_ee_prom_read16(
 	IN PRTMP_ADAPTER	pAd,
 	IN USHORT			Offset,
 	OUT USHORT			*pValue);
-
-int rtmp_ee_prom_write16(
-	IN PRTMP_ADAPTER	pAd,
-	IN USHORT			Offset,
-	IN USHORT			value);
 #endif // RTMP_PCI_SUPPORT //
 #ifdef RTMP_USB_SUPPORT
 /*************************************************************************
@@ -62,11 +57,6 @@ NTSTATUS RTUSBReadEEPROM16(
 	IN PRTMP_ADAPTER	pAd,
 	IN	USHORT			offset,
 	OUT	PUSHORT			pData);
-
-NTSTATUS RTUSBWriteEEPROM16(
-	IN RTMP_ADAPTER *pAd,
-	IN USHORT offset,
-	IN USHORT value);
 #endif // RTMP_USB_SUPPORT //
 
 #ifdef RT30xx
@@ -75,11 +65,6 @@ int rtmp_ee_efuse_read16(
 	IN RTMP_ADAPTER *pAd,
 	IN USHORT Offset,
 	OUT USHORT *pValue);
-
-int rtmp_ee_efuse_write16(
-	IN RTMP_ADAPTER *pAd,
-	IN USHORT Offset,
-	IN USHORT data);
 #endif // RTMP_EFUSE_SUPPORT //
 #endif // RT30xx //
 
Index: b/drivers/staging/rt2860/rtmp.h
===================================================================
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -1790,7 +1790,6 @@ struct _RTMP_CHIP_OP_
 	/*  Calibration access related callback functions */
 	int (*eeinit)(RTMP_ADAPTER *pAd);										/* int (*eeinit)(RTMP_ADAPTER *pAd); */
 	int (*eeread)(RTMP_ADAPTER *pAd, USHORT offset, PUSHORT pValue);				/* int (*eeread)(RTMP_ADAPTER *pAd, int offset, PUSHORT pValue); */
-	int (*eewrite)(RTMP_ADAPTER *pAd, USHORT offset, USHORT value);;				/* int (*eewrite)(RTMP_ADAPTER *pAd, int offset, USHORT value); */
 
 	/* MCU related callback functions */
 	int (*loadFirmware)(RTMP_ADAPTER *pAd);								/* int (*loadFirmware)(RTMP_ADAPTER *pAd); */
Index: b/drivers/staging/rt2860/rtmp_chip.h
===================================================================
--- a/drivers/staging/rt2860/rtmp_chip.h
+++ b/drivers/staging/rt2860/rtmp_chip.h
@@ -167,10 +167,6 @@
 #define RT28xx_EEPROM_READ16(_pAd, _offset, _value)			\
 	(_pAd)->chipOps.eeread((RTMP_ADAPTER *)(_pAd), (USHORT)(_offset), (PUSHORT)&(_value))
 
-#define RT28xx_EEPROM_WRITE16(_pAd, _offset, _value)		\
-	(_pAd)->chipOps.eewrite((RTMP_ADAPTER *)(_pAd), (USHORT)(_offset), (USHORT)(_value))
-
-
 
 // -------------------------------------------------------------------
 //  E2PROM data layout
Index: b/drivers/staging/rt2870/common/rtusb_io.c
===================================================================
--- a/drivers/staging/rt2870/common/rtusb_io.c
+++ b/drivers/staging/rt2870/common/rtusb_io.c
@@ -619,17 +619,6 @@ NTSTATUS RTUSBReadEEPROM16(
 
 }
 
-NTSTATUS RTUSBWriteEEPROM16(
-	IN RTMP_ADAPTER *pAd,
-	IN USHORT offset,
-	IN USHORT value)
-{
-	USHORT tmpVal;
-
-	tmpVal = cpu2le16(value);
-	return RTUSBWriteEEPROM(pAd, offset, (PUCHAR)&(tmpVal), 2);
-}
-
 /*
 	========================================================================
 
