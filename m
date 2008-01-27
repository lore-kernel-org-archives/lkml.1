Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbYA0Im7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbYA0Im7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 03:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbYA0Imb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 03:42:31 -0500
Received: from smtp111.plus.mail.re1.yahoo.com ([69.147.102.74]:31626 "HELO
	smtp111.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754921AbYA0Im3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 03:42:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=TL1J0pBsC7abQ/E+KZy4fN9wj0SBqiYn345z2fNZ63FsLnz8xH9B1mlLR4LTPvi0cfnzhdiyNAHjXKhoVjq0RDR0zZXCVPKl6o6OdS6YXanbsBU7Mmr8+RwZPeL1M5YHoNeh78zi1LyUMG6Ko2dVYbIAiw6yURyZ/tJTm0nk/+k=  ;
X-YMail-OSG: 0wDfS6EVM1l2EUtaYxs04lWctwip3qUKd77zzNSoqrwbQVy8QEQ7IYDCMYGK8UwK.IP0WmYpvg--
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 4/32] ide-tape: remove struct idetape_mode_parameter_header_t
Date: Sun, 27 Jan 2008 09:41:24 +0100
Message-Id: <1201423312-2460-5-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1201423312-2460-1-git-send-email-bbpetkov@yahoo.de>
References: <1201423312-2460-1-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-tape.c |   40 +++++++++++++++-------------------------
 1 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 173ac0d..0542b07 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -748,16 +748,6 @@ typedef struct {
 #define IDETAPE_BUFFER_FILLING_PAGE	0x33
 
 /*
- *	Mode Parameter Header for the MODE SENSE packet command
- */
-typedef struct {
-	__u8	mode_data_length;	/* Length of the following data transfer */
-	__u8	medium_type;		/* Medium Type */
-	__u8	dsp;			/* Device Specific Parameter */
-	__u8	bdl;			/* Block Descriptor Length */
-} idetape_mode_parameter_header_t;
-
-/*
  *	Mode Parameter Block Descriptor the MODE SENSE packet command
  *
  *	Support for block descriptors is optional.
@@ -3916,9 +3906,8 @@ static void idetape_get_mode_sense_results (ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t pc;
-	idetape_mode_parameter_header_t *header;
 	idetape_capabilities_page_t *capabilities;
-	
+
 	idetape_create_mode_sense_cmd(&pc, IDETAPE_CAPABILITIES_PAGE);
 	if (idetape_queue_pc_tail(drive, &pc)) {
 		printk(KERN_ERR "ide-tape: Can't get tape parameters - assuming some default values\n");
@@ -3928,8 +3917,8 @@ static void idetape_get_mode_sense_results (ide_drive_t *drive)
 		tape->capabilities.buffer_size = 6 * 52;
 		return;
 	}
-	header = (idetape_mode_parameter_header_t *) pc.buffer;
-	capabilities = (idetape_capabilities_page_t *) (pc.buffer + sizeof(idetape_mode_parameter_header_t) + header->bdl);
+	capabilities = (idetape_capabilities_page_t *)
+		(pc.buffer + 4 + pc.buffer[3]);
 
 	capabilities->max_speed = ntohs(capabilities->max_speed);
 	capabilities->ctl = ntohs(capabilities->ctl);
@@ -3954,11 +3943,13 @@ static void idetape_get_mode_sense_results (ide_drive_t *drive)
 #if IDETAPE_DEBUG_INFO
 	printk(KERN_INFO "ide-tape: Dumping the results of the MODE SENSE packet command\n");
 	printk(KERN_INFO "ide-tape: Mode Parameter Header:\n");
-	printk(KERN_INFO "ide-tape: Mode Data Length - %d\n",header->mode_data_length);
-	printk(KERN_INFO "ide-tape: Medium Type - %d\n",header->medium_type);
-	printk(KERN_INFO "ide-tape: Device Specific Parameter - %d\n",header->dsp);
-	printk(KERN_INFO "ide-tape: Block Descriptor Length - %d\n",header->bdl);
-	
+	printk(KERN_INFO "ide-tape: Mode Data Length - %d\n", pc.buffer[0]);
+	printk(KERN_INFO "ide-tape: Medium Type - %d\n", pc.buffer[1]);
+	printk(KERN_INFO "ide-tape: Device Specific Parameter - %d\n",
+			pc.buffer[2]);
+	printk(KERN_INFO "ide-tape: Block Descriptor Length - %d\n",
+			pc.buffer[3]);
+
 	printk(KERN_INFO "ide-tape: Capabilities and Mechanical Status Page:\n");
 	printk(KERN_INFO "ide-tape: Page code - %d\n",capabilities->page_code);
 	printk(KERN_INFO "ide-tape: Page length - %d\n",capabilities->page_length);
@@ -3977,7 +3968,8 @@ static void idetape_get_mode_sense_results (ide_drive_t *drive)
 	printk(KERN_INFO "ide-tape: Supports 32768 bytes block size / Restricted byte count for PIO transfers - %s\n",capabilities->blk32768 ? "Yes":"No");
 	printk(KERN_INFO "ide-tape: Maximum supported speed in KBps - %d\n",capabilities->max_speed);
 	printk(KERN_INFO "ide-tape: Continuous transfer limits in blocks - %d\n",capabilities->ctl);
-	printk(KERN_INFO "ide-tape: Current speed in KBps - %d\n",capabilities->speed);	
+	printk(KERN_INFO "ide-tape: Current speed in KBps - %d\n",
+			capabilities->speed);
 	printk(KERN_INFO "ide-tape: Buffer size - %d\n",capabilities->buffer_size*512);
 #endif /* IDETAPE_DEBUG_INFO */
 }
@@ -3991,9 +3983,8 @@ static void idetape_get_blocksize_from_block_descriptor(ide_drive_t *drive)
 
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t pc;
-	idetape_mode_parameter_header_t *header;
 	idetape_parameter_block_descriptor_t *block_descrp;
-	
+
 	idetape_create_mode_sense_cmd(&pc, IDETAPE_BLOCK_DESCRIPTOR);
 	if (idetape_queue_pc_tail(drive, &pc)) {
 		printk(KERN_ERR "ide-tape: Can't get block descriptor\n");
@@ -4003,10 +3994,9 @@ static void idetape_get_blocksize_from_block_descriptor(ide_drive_t *drive)
 		}
 		return;
 	}
-	header = (idetape_mode_parameter_header_t *) pc.buffer;
-	block_descrp = (idetape_parameter_block_descriptor_t *) (pc.buffer + sizeof(idetape_mode_parameter_header_t));
+	block_descrp = (idetape_parameter_block_descriptor_t *) pc.buffer + 4;
 	tape->tape_block_size =( block_descrp->length[0]<<16) + (block_descrp->length[1]<<8) + block_descrp->length[2];
-	tape->drv_write_prot = (header->dsp & 0x80) >> 7;
+	tape->drv_write_prot = (pc.buffer[2] & 0x80) >> 7;
 
 #if IDETAPE_DEBUG_INFO
 	printk(KERN_INFO "ide-tape: Adjusted block size - %d\n", tape->tape_block_size);
-- 
1.5.3.7

