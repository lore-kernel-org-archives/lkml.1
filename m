Return-Path: <linux-kernel-owner+w=401wt.eu-S1756890AbZAVHiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbZAVHiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 02:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbZAVHiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 02:38:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:59309 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbZAVHiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 02:38:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=AKq3Bkl+lWlgffGI8mdtAnPRGmuw2meQF/WpbHCKdNQ/wM+893oMj2puVfKqXHuFQ/
         DTkO/QEQJ9ynB/P7uLB2HXLgADLN/klUs2v+M7AbG0WlO0EkRgzprnEhUlfRQbADzRqK
         hoWyct2IKt5eLx1PRsG8hFRTCK8XtI0+k/0CI=
Message-ID: <49782267.8020903@gmail.com>
Date: Thu, 22 Jan 2009 09:38:15 +0200
From: Lior Dotan <liodot@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org,
       Christopher Harrer <charrer@alacritech.com>,
       "'Mook'" <mmiles@alacritech.com>
Subject: Re: [PATCH] staging: slicoss-use request_firmware
References: <494E40D3.1040500@gmail.com> <20090121171104.GA3991@kroah.com>
In-Reply-To: <20090121171104.GA3991@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------010805000303020801060209"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010805000303020801060209
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

-------- Original Message --------
Subject: Re: [PATCH] staging: slicoss-use request_firmware
From: Greg KH <greg@kroah.com>
To: Lior Dotan <liodot@gmail.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org, Christopher Harrer 
<charrer@alacritech.com>, 'Mook' <mmiles@alacritech.com>
Date: 01/21/2009 07:11 PM

> On Sun, Dec 21, 2008 at 03:12:51PM +0200, Lior Dotan wrote:
>> This patch uses request_firmware() to download the firmware to the card.
>> It seems that some of my previous patches (including an earlier and not 
>> working version of this)
>> are missing from your tree so they are also included here again.
>> This code is more compact than the original as it reads all the meta data 
>> from the firmware
>> file instead of having it hard coded.
>> In addition some 32/64 bit dependent code was removed.
>> I was able to test it on an actual board and verify that it indeed works.
>> If this patch is accepted, I can send a patch to remove the static firmware 
>> from the tree.
> 
> Hm, this doesn't apply against the latest tree at all.  Care to split
> this up into the different patches which would make it easier for me to
> apply?
> 
> thanks,
> 
> greg k-h

It didn't apply because it includec some patches that are already and it 
also missed some patches, so basically it gotten too old and didn't age 
well.
This new patch applies to the latest Linus' git tree.

Signed-off-by: Lior Dotan <liodot@gmail.com>

--------------010805000303020801060209
Content-Type: text/plain;
 name="slicoss-req_firmware.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="slicoss-req_firmware.patch"

diff --git a/drivers/staging/slicoss/slic.h b/drivers/staging/slicoss/slic.h
index a8ea59d..e8d388d 100644
--- a/drivers/staging/slicoss/slic.h
+++ b/drivers/staging/slicoss/slic.h
@@ -46,30 +46,10 @@
 #define OASIS_UCODE_VERS_DATE  	"2006/03/27 15:10:37"
 #define OASIS_UCODE_HOSTIF_ID  	3
 
-static s32 ONumSections = 0x2;
-static u32 OSectionSize[] = {
-	0x00004000, 0x00010000,
-};
-
-static u32 OSectionStart[] = {
-	0x00000000, 0x00008000,
-};
-
 #define MOJAVE_UCODE_VERS_STRING	"1.2"
 #define MOJAVE_UCODE_VERS_DATE  	"2006/03/27 15:12:22"
 #define MOJAVE_UCODE_HOSTIF_ID  	3
 
-static s32 MNumSections = 0x2;
-static u32 MSectionSize[] =
-{
-	0x00008000, 0x00010000,
-};
-
-static u32 MSectionStart[] =
-{
-	0x00000000, 0x00008000,
-};
-
 #define GB_RCVUCODE_VERS_STRING	"1.2"
 #define GB_RCVUCODE_VERS_DATE  	"2006/03/27 15:12:15"
 static u32 OasisRcvUCodeLen = 512;
diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index bf7da8f..2d7f1fa 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -2183,15 +2184,16 @@ static int slic_card_download_gbrcv(struct adapter *adapter)
 	int ret;
 	__iomem struct slic_regs *slic_regs = adapter->slic_regs;
 	u32 codeaddr;
-	unsigned char *instruction = NULL;
+	u32 instruction;
+	int index = 0;
 	u32 rcvucodelen = 0;
 
 	switch (adapter->devid) {
 	case SLIC_2GB_DEVICE_ID:
-		file = "oasis_rcv.bin";
+		file = "oasisrcvucode.sys";
 		break;
 	case SLIC_1GB_DEVICE_ID:
-		file = "gb_rcv.bin";
+		file = "gbrcvucode.sys";
 		break;
 	default:
 		ASSERT(0);
@@ -2204,8 +2206,8 @@ static int slic_card_download_gbrcv(struct adapter *adapter)
 		return ret;
 	}
 
-	instruction = (unsigned char *)fw->data;
-	rcvucodelen = fw->size;
+	rcvucodelen = *(u32 *)(fw->data + index);
+	index += 4;
 	switch (adapter->devid) {
 	case SLIC_2GB_DEVICE_ID:
 		if (rcvucodelen != OasisRcvUCodeLen)
@@ -2219,24 +2221,24 @@ static int slic_card_download_gbrcv(struct adapter *adapter)
 		ASSERT(0);
 		break;
 	}
-
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
@@ -2254,16 +2256,14 @@ static int slic_card_download(struct adapter *adapter)
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
@@ -2271,24 +2271,10 @@ static int slic_card_download(struct adapter *adapter)
 
 	switch (adapter->devid) {
 	case SLIC_2GB_DEVICE_ID:
-/*      DBG_MSG ("slicoss: %s devid==SLIC_2GB_DEVICE_ID sections[%x]\n",
-	__func__, (uint) ONumSections); */
-		file = "slic_oasis.bin";
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
-		file = "slic_mojave.bin";
-		numsects = MNumSections;
-		for (i = 0; i < numsects; i++) {
-			sectsize[i] = MSectionSize[i];
-			sectstart[i] = MSectionStart[i];
-		}
+		file = "gbdownload.sys";
 		break;
 	default:
 		ASSERT(0);
@@ -2299,75 +2285,42 @@ static int slic_card_download(struct adapter *adapter)
 		printk(KERN_ERR "SLICOSS: Failed to load firmware %s\n", file);
 		return ret;
 	}
-
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
-			instruction = (u32 *)(fw->data + (SECTION_SIZE *
-								section));
-			baseaddress = sectstart[section];
-			thissectionsize = sectsize[section] >> 3;
-			lastinstruct =
-			    (u32 *)(fw->data + (SECTION_SIZE * section) +
-					sectsize[section] - 8);
-			break;
-		case SLIC_1GB_DEVICE_ID:
-			instruction = (u32 *)(fw->data + (SECTION_SIZE *
-								section));
-			baseaddress = sectstart[section];
-			thissectionsize = sectsize[section] >> 3;
-			lastinstruct =
-			    (u32 *)(fw->data + (SECTION_SIZE * section) +
-					sectsize[section] - 8);
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
-			instruction = (u32 *)fw->data + (SECTION_SIZE *
-								section);
-			break;
-		case SLIC_1GB_DEVICE_ID:
-			instruction = (u32 *)fw->data + (SECTION_SIZE *
-								section);
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
@@ -2375,37 +2328,31 @@ static int slic_card_download(struct adapter *adapter)
 
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
 				release_firmware(fw);
 				return -EIO;
-			}
+			}*/
 		}
 	}
 /*    DBG_MSG ("slicoss: Compare done\n");*/
@@ -2570,8 +2517,8 @@ static int slic_card_init(struct sliccard *card, struct adapter *adapter)
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
@@ -2792,12 +2739,12 @@ static u32 slic_card_locate(struct adapter *adapter)
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
@@ -2865,8 +2812,8 @@ static u32 slic_card_locate(struct adapter *adapter)
 		ASSERT(physcard);
 
 		DBG_MSG
-		    ("\n%s Allocate a PHYSICALcard:\n    PHYSICAL_Card[%p]\n\
-		     LogicalCard  [%p]\n    adapter      [%p]\n",
+		    ("\n%s Allocate a PHYSICALcard:\n    PHYSICAL_Card[%p]\n"
+		     "    LogicalCard  [%p]\n    adapter      [%p]\n",
 		     __func__, physcard, card, adapter);
 
 		physcard->next = slic_global.phys_card;
@@ -4449,7 +4396,7 @@ static int slic_debug_card_show(struct seq_file *seq, void *v)
 	unsigned char *oemfru = (unsigned char *)(&card->config.OemFru);
 #endif
 
-	seq_printf(seq, "driver_version           : %s", slic_proc_version);
+	seq_printf(seq, "driver_version           : %s\n", slic_proc_version);
 	seq_printf(seq, "Microcode versions:           \n");
 	seq_printf(seq, "    Gigabit (gb)         : %s %s\n",
 		    MOJAVE_UCODE_VERS_STRING, MOJAVE_UCODE_VERS_DATE);

--------------010805000303020801060209--
