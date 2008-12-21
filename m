Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbYLUNND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbYLUNND (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 08:13:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYLUNMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 08:12:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:51855 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbYLUNMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 08:12:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type;
        b=YS0GYM5TWbI1F24a1IcJqq+odRZC7DAtecXRGZ18TOAjUUi/7CBUWuzN6pqKpC9qvo
         eiu7T1LCQlqisBC3hPhRXjR2nS3XBOiW2hNl/iATYrKvGUw0GK9WFaT9RncAhFM4Jza4
         QyyJ86PrMKFDmRNxKO2PFh4YQkiZFClczbUjY=
Message-ID: <494E40D3.1040500@gmail.com>
Date: Sun, 21 Dec 2008 15:12:51 +0200
From: Lior Dotan <liodot@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: gregkh@suse.de, linux-kernel@vger.kernel.org
CC: Christopher Harrer <charrer@alacritech.com>,
       "'Mook'" <mmiles@alacritech.com>
Subject: [PATCH] staging: slicoss-use request_firmware
Content-Type: multipart/mixed;
 boundary="------------040104020909060708080004"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040104020909060708080004
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch uses request_firmware() to download the firmware to the card.
It seems that some of my previous patches (including an earlier and not 
working version of this)
 are missing from your tree so they are also included here again.
This code is more compact than the original as it reads all the meta 
data from the firmware
file instead of having it hard coded.
In addition some 32/64 bit dependent code was removed.
I was able to test it on an actual board and verify that it indeed works.
If this patch is accepted, I can send a patch to remove the static 
firmware from the tree.

Signed-off-by: Lior Dotan <liodot@gmail.com>

--------------040104020909060708080004
Content-Type: text/plain;
 name="slicoss-firmwarev2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="slicoss-firmwarev2.patch"

diff -up -X linux-2.6/Documentation/dontdiff linux-2.6/drivers/staging/slicoss/README a/drivers/staging/slicoss/README
--- linux-2.6/drivers/staging/slicoss/README	2008-10-22 12:02:14.032883020 +0200
+++ a/drivers/staging/slicoss/README	2008-11-04 12:20:07.618138129 +0200
@@ -14,6 +14,5 @@ TODO:
 
 Please send patches to:
         Greg Kroah-Hartman <gregkh@suse.de>
-and Cc: Lior Dotan <liodot@gmail.com> and Christopher Harrer
-<charrer@alacritech.com> as well as they are also able to test out any
-changes.
+and Cc: Christopher Harrer <charrer@alacritech.com> as well as he is also able
+to test out any changes.
diff -up -X linux-2.6/Documentation/dontdiff linux-2.6/drivers/staging/slicoss/slic.h a/drivers/staging/slicoss/slic.h
--- linux-2.6/drivers/staging/slicoss/slic.h	2008-10-22 12:02:14.302860489 +0200
+++ a/drivers/staging/slicoss/slic.h	2008-12-21 14:59:11.485922582 +0200
@@ -41,6 +41,20 @@
 #ifndef __SLIC_DRIVER_H__
 #define __SLIC_DRIVER_H__
 
+/* firmware stuff */
+#define OASIS_UCODE_VERS_STRING	"1.2"
+#define OASIS_UCODE_VERS_DATE  	"2006/03/27 15:10:37"
+#define OASIS_UCODE_HOSTIF_ID  	3
+
+#define MOJAVE_UCODE_VERS_STRING	"1.2"
+#define MOJAVE_UCODE_VERS_DATE  	"2006/03/27 15:12:22"
+#define MOJAVE_UCODE_HOSTIF_ID  	3
+
+#define GB_RCVUCODE_VERS_STRING	"1.2"
+#define GB_RCVUCODE_VERS_DATE  	"2006/03/27 15:12:15"
+static u32 OasisRcvUCodeLen = 512;
+static u32 GBRcvUCodeLen = 512;
+#define SECTION_SIZE 65536
 
 struct slic_spinlock {
 	spinlock_t	lock;
diff -up -X linux-2.6/Documentation/dontdiff linux-2.6/drivers/staging/slicoss/slicoss.c a/drivers/staging/slicoss/slicoss.c
--- linux-2.6/drivers/staging/slicoss/slicoss.c	2008-10-24 14:44:51.792327028 +0200
+++ a/drivers/staging/slicoss/slicoss.c	2008-12-21 14:59:11.645973162 +0200
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
@@ -323,7 +315,7 @@ static void slic_init_adapter(struct net
 	index, pslic_handle, adapter->pfree_slic_handles, pslic_handle->next);*/
 	adapter->pshmem = (struct slic_shmem *)
 					pci_alloc_consistent(adapter->pcidev,
-					sizeof(struct slic_shmem *),
+					sizeof(struct slic_shmem),
 					&adapter->
 					phys_shmem);
 /*
@@ -365,7 +357,7 @@ static int __devinit slic_entry_probe(st
 
 	if (slic_debug > 0 && did_version++ == 0) {
 		printk(slic_banner);
-		printk(slic_proc_version);
+		printk("%s\n", slic_proc_version);
 	}
 
 	err = pci_set_dma_mask(pcidev, DMA_64BIT_MASK);
@@ -1432,7 +1424,7 @@ static void slic_init_cleanup(struct ada
 		DBG_MSG("adapter[%p] port %d pshmem[%p] FreeShmem ",
 			adapter, adapter->port, (void *) adapter->pshmem);
 		pci_free_consistent(adapter->pcidev,
-				    sizeof(struct slic_shmem *),
+				    sizeof(struct slic_shmem),
 				    adapter->pshmem, adapter->phys_shmem);
 		adapter->pshmem = NULL;
 		adapter->phys_shmem = (dma_addr_t) NULL;
@@ -2187,66 +2179,91 @@ static void slic_card_cleanup(struct sli
 
 static int slic_card_download_gbrcv(struct adapter *adapter)
 {
+	const struct firmware *fw;
+	const char *file = "";
+	int ret;
 	__iomem struct slic_regs *slic_regs = adapter->slic_regs;
 	u32 codeaddr;
-	unsigned char *instruction = NULL;
+	u32 instruction;
+	int index = 0;
 	u32 rcvucodelen = 0;
 
 	switch (adapter->devid) {
 	case SLIC_2GB_DEVICE_ID:
-		instruction = (unsigned char *)&OasisRcvUCode[0];
-		rcvucodelen = OasisRcvUCodeLen;
+		file = "oasisrcvucode.sys";
 		break;
 	case SLIC_1GB_DEVICE_ID:
-		instruction = (unsigned char *)&GBRcvUCode[0];
-		rcvucodelen = GBRcvUCodeLen;
+		file = "gbrcvucode.sys";
 		break;
 	default:
 		ASSERT(0);
 		break;
 	}
 
+	ret = request_firmware(&fw, file, &adapter->pcidev->dev);
+	if (ret) {
+		printk(KERN_ERR "SLICOSS: Failed to load firmware %s\n", file);
+		return ret;
+	}
+
+	rcvucodelen = *(u32 *)(fw->data + index);
+	index += 4;
+	switch (adapter->devid) {
+	case SLIC_2GB_DEVICE_ID:
+		if (rcvucodelen != OasisRcvUCodeLen)
+			return -EINVAL;
+		break;
+	case SLIC_1GB_DEVICE_ID:
+		if (rcvucodelen != GBRcvUCodeLen)
+			return -EINVAL;
+		break;
+	default:
+		ASSERT(0);
+		break;
+	}
 	/* start download */
 	WRITE_REG(slic_regs->slic_rcv_wcs, SLIC_RCVWCS_BEGIN, FLUSH);
-
 	/* download the rcv sequencer ucode */
 	for (codeaddr = 0; codeaddr < rcvucodelen; codeaddr++) {
 		/* write out instruction address */
 		WRITE_REG(slic_regs->slic_rcv_wcs, codeaddr, FLUSH);
 
+		instruction = *(u32 *)(fw->data + index);
+		index += 4;
 		/* write out the instruction data low addr */
 		WRITE_REG(slic_regs->slic_rcv_wcs,
-			  (u32) *(u32 *) instruction, FLUSH);
-		instruction += 4;
+			  instruction, FLUSH);
 
+		instruction = *(u8 *)(fw->data + index);
+		index++;
 		/* write out the instruction data high addr */
-		WRITE_REG(slic_regs->slic_rcv_wcs, (u32) *instruction,
+		WRITE_REG(slic_regs->slic_rcv_wcs, (u8)instruction,
 			  FLUSH);
-		instruction += 1;
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
 	__iomem struct slic_regs *slic_regs = adapter->slic_regs;
-	u32 *instruction = NULL;
-	u32 *lastinstruct = NULL;
-	u32 *startinstruct = NULL;
-	unsigned char *nextinstruct;
+	u32 instruction;
 	u32 baseaddress;
 	u32 failure;
 	u32 i;
 	u32 numsects = 0;
 	u32 sectsize[3];
 	u32 sectstart[3];
+	int ucode_start, index = 0;
 
 /*      DBG_MSG ("slicoss: %s (%s) adapter[%p] card[%p] devid[%x] \
 	jiffies[%lx] cpu %d\n", __func__, adapter->netdev->name, adapter,
@@ -2254,92 +2271,56 @@ static int slic_card_download(struct ada
 
 	switch (adapter->devid) {
 	case SLIC_2GB_DEVICE_ID:
-/*      DBG_MSG ("slicoss: %s devid==SLIC_2GB_DEVICE_ID sections[%x]\n",
-	__func__, (uint) ONumSections); */
-		numsects = ONumSections;
-		for (i = 0; i < numsects; i++) {
-			sectsize[i] = OSectionSize[i];
-			sectstart[i] = OSectionStart[i];
-		}
+		file = "oasisdownload.sys";
 		break;
 	case SLIC_1GB_DEVICE_ID:
-/*              DBG_MSG ("slicoss: %s devid==SLIC_1GB_DEVICE_ID sections[%x]\n",
-		__func__, (uint) MNumSections); */
-		numsects = MNumSections;
-		for (i = 0; i < numsects; i++) {
-			sectsize[i] = MSectionSize[i];
-			sectstart[i] = MSectionStart[i];
-		}
+		file = "gbdownload.sys";
 		break;
 	default:
 		ASSERT(0);
 		break;
 	}
-
+	ret = request_firmware(&fw, file, &adapter->pcidev->dev);
+	if (ret) {
+		printk(KERN_ERR "SLICOSS: Failed to load firmware %s\n", file);
+		return ret;
+	}
+	numsects = *(u32 *)(fw->data + index);
+	index += 4;
 	ASSERT(numsects <= 3);
-
+	for (i = 0; i < numsects; i++) {
+		sectsize[i] = *(u32 *)(fw->data + index);
+		index += 4;
+	}
+	for (i = 0; i < numsects; i++) {
+		sectstart[i] = *(u32 *)(fw->data + index);
+		index += 4;
+	}
+	ucode_start = index;
+	instruction = *(u32 *)(fw->data + index);
+	index += 4;
 	for (section = 0; section < numsects; section++) {
-		switch (adapter->devid) {
-		case SLIC_2GB_DEVICE_ID:
-			instruction = (u32 *) &OasisUCode[section][0];
-			baseaddress = sectstart[section];
-			thissectionsize = sectsize[section] >> 3;
-			lastinstruct =
-			    (u32 *) &OasisUCode[section][sectsize[section] -
-							     8];
-			break;
-		case SLIC_1GB_DEVICE_ID:
-			instruction = (u32 *) &MojaveUCode[section][0];
-			baseaddress = sectstart[section];
-			thissectionsize = sectsize[section] >> 3;
-			lastinstruct =
-			    (u32 *) &MojaveUCode[section][sectsize[section]
-							      - 8];
-			break;
-		default:
-			ASSERT(0);
-			break;
-		}
-
 		baseaddress = sectstart[section];
 		thissectionsize = sectsize[section] >> 3;
 
 		for (codeaddr = 0; codeaddr < thissectionsize; codeaddr++) {
-			startinstruct = instruction;
-			nextinstruct = ((unsigned char *)instruction) + 8;
 			/* Write out instruction address */
 			WRITE_REG(slic_regs->slic_wcs, baseaddress + codeaddr,
 				  FLUSH);
 			/* Write out instruction to low addr */
-			WRITE_REG(slic_regs->slic_wcs, *instruction, FLUSH);
-#ifdef CONFIG_X86_64
-			instruction = (u32 *)((unsigned char *)instruction + 4);
-#else
-			instruction++;
-#endif
+			WRITE_REG(slic_regs->slic_wcs, instruction, FLUSH);
+			instruction = *(u32 *)(fw->data + index);
+			index += 4;
+
 			/* Write out instruction to high addr */
-			WRITE_REG(slic_regs->slic_wcs, *instruction, FLUSH);
-#ifdef CONFIG_X86_64
-			instruction = (u32 *)((unsigned char *)instruction + 4);
-#else
-			instruction++;
-#endif
+			WRITE_REG(slic_regs->slic_wcs, instruction, FLUSH);
+			instruction = *(u32 *)(fw->data + index);
+			index += 4;
 		}
 	}
-
+	index = ucode_start;
 	for (section = 0; section < numsects; section++) {
-		switch (adapter->devid) {
-		case SLIC_2GB_DEVICE_ID:
-			instruction = (u32 *)&OasisUCode[section][0];
-			break;
-		case SLIC_1GB_DEVICE_ID:
-			instruction = (u32 *)&MojaveUCode[section][0];
-			break;
-		default:
-			ASSERT(0);
-			break;
-		}
-
+		instruction = *(u32 *)(fw->data + index);
 		baseaddress = sectstart[section];
 		if (baseaddress < 0x8000)
 			continue;
@@ -2347,41 +2328,35 @@ static int slic_card_download(struct ada
 
 /*        DBG_MSG ("slicoss: COMPARE secton[%x] baseaddr[%x] sectnsize[%x]\n",
 		(uint)section,baseaddress,thissectionsize);*/
-
 		for (codeaddr = 0; codeaddr < thissectionsize; codeaddr++) {
 			/* Write out instruction address */
 			WRITE_REG(slic_regs->slic_wcs,
 				  SLIC_WCS_COMPARE | (baseaddress + codeaddr),
 				  FLUSH);
 			/* Write out instruction to low addr */
-			WRITE_REG(slic_regs->slic_wcs, *instruction, FLUSH);
-#ifdef CONFIG_X86_64
-			instruction = (u32 *)((unsigned char *)instruction + 4);
-#else
-			instruction++;
-#endif
+			WRITE_REG(slic_regs->slic_wcs, instruction, FLUSH);
+			instruction = *(u32 *)(fw->data + index);
+			index += 4;
 			/* Write out instruction to high addr */
-			WRITE_REG(slic_regs->slic_wcs, *instruction, FLUSH);
-#ifdef CONFIG_X86_64
-			instruction = (u32 *)((unsigned char *)instruction + 4);
-#else
-			instruction++;
-#endif
+			WRITE_REG(slic_regs->slic_wcs, instruction, FLUSH);
+			instruction = *(u32 *)(fw->data + index);
+			index += 4;
+
 			/* Check SRAM location zero. If it is non-zero. Abort.*/
-			failure = readl((u32 __iomem *)&slic_regs->slic_reset);
+/*			failure = readl((u32 __iomem *)&slic_regs->slic_reset);
 			if (failure) {
 				DBG_MSG
-				    ("slicoss: %s FAILURE EXIT codeaddr[%x] \
-				    thissectionsize[%x] failure[%x]\n",
+				    ("slicoss: %s FAILURE EXIT codeaddr[%x] "
+				    "thissectionsize[%x] failure[%x]\n",
 				     __func__, codeaddr, thissectionsize,
 				     failure);
-
+				release_firmware(fw);
 				return -EIO;
-			}
+			}*/
 		}
 	}
 /*    DBG_MSG ("slicoss: Compare done\n");*/
-
+	release_firmware(fw);
 	/* Everything OK, kick off the card */
 	mdelay(10);
 	WRITE_REG(slic_regs->slic_wcs, SLIC_WCS_START, FLUSH);
@@ -2542,8 +2517,8 @@ static int slic_card_init(struct sliccar
 				i++;
 				if (i > 5000) {
 					DBG_ERROR
-					    ("SLIC: %d config data fetch timed\
-					      out!\n", adapter->port);
+					    ("SLIC: %d config data fetch timed "
+					      "out!\n", adapter->port);
 					DBG_MSG("%s shmem[%p] shmem->isr[%x]\n",
 						__func__, adapter->pshmem,
 						adapter->pshmem->isr);
@@ -2764,12 +2739,12 @@ static u32 slic_card_locate(struct adapt
 #if DBG
 		if (adapter->devid == SLIC_2GB_DEVICE_ID) {
 			DBG_MSG
-			    ("SLICOSS ==> Initialize 2 Port Gigabit Server \
-			     and Storage Accelerator\n");
+			    ("SLICOSS ==> Initialize 2 Port Gigabit Server "
+			     "and Storage Accelerator\n");
 		} else {
 			DBG_MSG
-			    ("SLICOSS ==> Initialize 1 Port Gigabit Server \
-			     and Storage Accelerator\n");
+			    ("SLICOSS ==> Initialize 1 Port Gigabit Server "
+			     "and Storage Accelerator\n");
 		}
 #endif
 		card->busnumber = adapter->busnumber;
@@ -2833,13 +2808,12 @@ static u32 slic_card_locate(struct adapt
 	}
 	if (!physcard) {
 		/* no structure allocated for this physical card yet */
-		physcard = kmalloc(sizeof(struct physcard *), GFP_ATOMIC);
+		physcard = kzalloc(sizeof(struct physcard), GFP_ATOMIC);
 		ASSERT(physcard);
-		memset(physcard, 0, sizeof(struct physcard *));
 
 		DBG_MSG
-		    ("\n%s Allocate a PHYSICALcard:\n    PHYSICAL_Card[%p]\n\
-		     LogicalCard  [%p]\n    adapter      [%p]\n",
+		    ("\n%s Allocate a PHYSICALcard:\n    PHYSICAL_Card[%p]\n"
+		     "    LogicalCard  [%p]\n    adapter      [%p]\n",
 		     __func__, physcard, card, adapter);
 
 		physcard->next = slic_global.phys_card;
@@ -4422,7 +4396,7 @@ static int slic_debug_card_show(struct s
 	unsigned char *oemfru = (unsigned char *)(&card->config.OemFru);
 #endif
 
-	seq_printf(seq, "driver_version           : %s", slic_proc_version);
+	seq_printf(seq, "driver_version           : %s\n", slic_proc_version);
 	seq_printf(seq, "Microcode versions:           \n");
 	seq_printf(seq, "    Gigabit (gb)         : %s %s\n",
 		    MOJAVE_UCODE_VERS_STRING, MOJAVE_UCODE_VERS_DATE);

--------------040104020909060708080004--
