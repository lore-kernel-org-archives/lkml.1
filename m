Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbYKEOCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbYKEOCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 09:02:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbYKEOC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 09:02:26 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:8797 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbYKEOCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 09:02:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type;
        b=iKGR07iy/T/X09e7NR3FwwT0VOIgTOnk/3NALJGnUoN4Aw2hZxOoOBsh0FfFKg0Hcx
         wP/nuKOFhOneyYkfyC9G0RKyZvKOfiAHIPzGarlByuHFcBHoQYZ1Hc9j8pBy/11Ojb6U
         Vi2YySKQPlHbTpzfHM0fDKoCwWH6b6qd5jDNw=
Message-ID: <4911A76C.6060405@gmail.com>
Date: Wed, 05 Nov 2008 16:02:20 +0200
From: Lior Dotan <liodot@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: gregkh@suse.de
CC: linux-kernel@vger.kernel.org, charrer@alacritech.com
Subject: [STAGING] slicoss - use request_firmware
Content-Type: multipart/mixed;
 boundary="------------080807030602060905090901"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080807030602060905090901
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This should make the driver use request_firmware() instead of a static 
firmware.
Some obvious things are missing:
1) The unneeded header files are not removed yet. This is to keep the 
patch size small.
2) The .bin files are missing so the driver doesn't have what to load.
3) Testing. None of this was tested. It does compiles OK though :)

Signed-off-by: Lior Dotan <liodot@gmail.com>



--------------080807030602060905090901
Content-Type: text/plain;
 name="slicoss-firmware.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="slicoss-firmware.patch"

diff -up -X a/Documentation/dontdiff b/drivers/staging/slicoss/slic.h a/drivers/staging/slicoss/slic.h
--- b/drivers/staging/slicoss/slic.h	2008-11-04 11:53:12.798139149 +0200
+++ a/drivers/staging/slicoss/slic.h	2008-11-05 15:20:48.497808311 +0200
@@ -41,6 +41,40 @@
 #ifndef __SLIC_DRIVER_H__
 #define __SLIC_DRIVER_H__
 
+/* firmware stuff */
+#define OASIS_UCODE_VERS_STRING	"1.2"
+#define OASIS_UCODE_VERS_DATE  	"2006/03/27 15:10:37"
+#define OASIS_UCODE_HOSTIF_ID  	3
+
+static s32 ONumSections = 0x2;
+static u32 OSectionSize[] = {
+	0x00004000, 0x00010000,
+};
+
+static u32 OSectionStart[] = {
+	0x00000000, 0x00008000,
+};
+
+#define MOJAVE_UCODE_VERS_STRING	"1.2"
+#define MOJAVE_UCODE_VERS_DATE  	"2006/03/27 15:12:22"
+#define MOJAVE_UCODE_HOSTIF_ID  	3
+
+static s32 MNumSections = 0x2;
+static u32 MSectionSize[] =
+{
+	0x00008000, 0x00010000,
+};
+
+static u32 MSectionStart[] =
+{
+	0x00000000, 0x00008000,
+};
+
+#define GB_RCVUCODE_VERS_STRING	"1.2"
+#define GB_RCVUCODE_VERS_DATE  	"2006/03/27 15:12:15"
+static u32 OasisRcvUCodeLen = 512;
+static u32 GBRcvUCodeLen = 512;
+#define SECTION_SIZE 65536
 
 struct slic_spinlock {
 	spinlock_t	lock;
diff -up -X a/Documentation/dontdiff b/drivers/staging/slicoss/slicoss.c a/drivers/staging/slicoss/slicoss.c
--- b/drivers/staging/slicoss/slicoss.c	2008-11-05 15:48:03.377817712 +0200
+++ a/drivers/staging/slicoss/slicoss.c	2008-11-05 15:54:06.097811733 +0200
@@ -94,6 +94,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 
+#include <linux/firmware.h>
 #include <linux/types.h>
 #include <linux/dma-mapping.h>
 #include <linux/mii.h>
@@ -105,15 +106,6 @@
 
 #include <linux/uaccess.h>
 #include "slicinc.h"
-#include "gbdownload.h"
-#include "gbrcvucode.h"
-#include "oasisrcvucode.h"
-
-#ifdef DEBUG_MICROCODE
-#include "oasisdbgdownload.h"
-#else
-#include "oasisdownload.h"
-#endif
 
 #if SLIC_DUMP_ENABLED
 #include "slicdump.h"
@@ -2187,6 +2179,9 @@ static void slic_card_cleanup(struct sli
 
 static int slic_card_download_gbrcv(struct adapter *adapter)
 {
+	const struct firmware *fw;
+	const char *file = "";
+	int ret;
 	__iomem struct slic_regs *slic_regs = adapter->slic_regs;
 	u32 codeaddr;
 	unsigned char *instruction = NULL;
@@ -2194,12 +2189,32 @@ static int slic_card_download_gbrcv(stru
 
 	switch (adapter->devid) {
 	case SLIC_2GB_DEVICE_ID:
-		instruction = (unsigned char *)&OasisRcvUCode[0];
-		rcvucodelen = OasisRcvUCodeLen;
+		file = "oasis_rcv.bin";
 		break;
 	case SLIC_1GB_DEVICE_ID:
-		instruction = (unsigned char *)&GBRcvUCode[0];
-		rcvucodelen = GBRcvUCodeLen;
+		file = "gb_rcv.bin";
+		break;
+	default:
+		ASSERT(0);
+		break;
+	}
+
+	ret = request_firmware(&fw, file, &adapter->pcidev->dev);
+	if (ret) {
+		printk(KERN_ERR "SLICOSS: Failed to load firmware %s\n", file);
+		return ret;
+	}
+
+	instruction = (unsigned char *)fw->data;
+	rcvucodelen = fw->size;
+	switch (adapter->devid) {
+	case SLIC_2GB_DEVICE_ID:
+		if (rcvucodelen != OasisRcvUCodeLen)
+			return -EINVAL;
+		break;
+	case SLIC_1GB_DEVICE_ID:
+		if (rcvucodelen != GBRcvUCodeLen)
+			return -EINVAL;
 		break;
 	default:
 		ASSERT(0);
@@ -2226,13 +2241,16 @@ static int slic_card_download_gbrcv(stru
 	}
 
 	/* download finished */
+	release_firmware(fw);
 	WRITE_REG(slic_regs->slic_rcv_wcs, SLIC_RCVWCS_FINISH, FLUSH);
-
 	return 0;
 }
 
 static int slic_card_download(struct adapter *adapter)
 {
+	const struct firmware *fw;
+	const char *file = "";
+	int ret;
 	u32 section;
 	int thissectionsize;
 	int codeaddr;
@@ -2256,6 +2274,7 @@ static int slic_card_download(struct ada
 	case SLIC_2GB_DEVICE_ID:
 /*      DBG_MSG ("slicoss: %s devid==SLIC_2GB_DEVICE_ID sections[%x]\n",
 	__func__, (uint) ONumSections); */
+		file = "slic_oasis.bin";
 		numsects = ONumSections;
 		for (i = 0; i < numsects; i++) {
 			sectsize[i] = OSectionSize[i];
@@ -2265,6 +2284,7 @@ static int slic_card_download(struct ada
 	case SLIC_1GB_DEVICE_ID:
 /*              DBG_MSG ("slicoss: %s devid==SLIC_1GB_DEVICE_ID sections[%x]\n",
 		__func__, (uint) MNumSections); */
+		file = "slic_mojave.bin";
 		numsects = MNumSections;
 		for (i = 0; i < numsects; i++) {
 			sectsize[i] = MSectionSize[i];
@@ -2275,26 +2295,33 @@ static int slic_card_download(struct ada
 		ASSERT(0);
 		break;
 	}
+	ret = request_firmware(&fw, file, &adapter->pcidev->dev);
+	if (ret) {
+		printk(KERN_ERR "SLICOSS: Failed to load firmware %s\n", file);
+		return ret;
+	}
 
 	ASSERT(numsects <= 3);
 
 	for (section = 0; section < numsects; section++) {
 		switch (adapter->devid) {
 		case SLIC_2GB_DEVICE_ID:
-			instruction = (u32 *) &OasisUCode[section][0];
+			instruction = (u32 *)(fw->data + (SECTION_SIZE *
+								section));
 			baseaddress = sectstart[section];
 			thissectionsize = sectsize[section] >> 3;
 			lastinstruct =
-			    (u32 *) &OasisUCode[section][sectsize[section] -
-							     8];
+			    (u32 *)(fw->data + (SECTION_SIZE * section) +
+					sectsize[section] - 8);
 			break;
 		case SLIC_1GB_DEVICE_ID:
-			instruction = (u32 *) &MojaveUCode[section][0];
+			instruction = (u32 *)(fw->data + (SECTION_SIZE *
+								section));
 			baseaddress = sectstart[section];
 			thissectionsize = sectsize[section] >> 3;
 			lastinstruct =
-			    (u32 *) &MojaveUCode[section][sectsize[section]
-							      - 8];
+			    (u32 *)(fw->data + (SECTION_SIZE * section) +
+					sectsize[section] - 8);
 			break;
 		default:
 			ASSERT(0);
@@ -2330,10 +2357,12 @@ static int slic_card_download(struct ada
 	for (section = 0; section < numsects; section++) {
 		switch (adapter->devid) {
 		case SLIC_2GB_DEVICE_ID:
-			instruction = (u32 *)&OasisUCode[section][0];
+			instruction = (u32 *)fw->data + (SECTION_SIZE *
+								section);
 			break;
 		case SLIC_1GB_DEVICE_ID:
-			instruction = (u32 *)&MojaveUCode[section][0];
+			instruction = (u32 *)fw->data + (SECTION_SIZE *
+								section);
 			break;
 		default:
 			ASSERT(0);
@@ -2375,13 +2404,13 @@ static int slic_card_download(struct ada
 				    thissectionsize[%x] failure[%x]\n",
 				     __func__, codeaddr, thissectionsize,
 				     failure);
-
+				release_firmware(fw);
 				return -EIO;
 			}
 		}
 	}
 /*    DBG_MSG ("slicoss: Compare done\n");*/
-
+	release_firmware(fw);
 	/* Everything OK, kick off the card */
 	mdelay(10);
 	WRITE_REG(slic_regs->slic_wcs, SLIC_WCS_START, FLUSH);

--------------080807030602060905090901--
