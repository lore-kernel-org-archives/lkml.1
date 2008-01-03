Return-Path: <linux-kernel-owner+w=401wt.eu-S1752554AbYACN0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbYACN0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 08:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbYACNXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 08:23:37 -0500
Received: from smtp112.plus.mail.re1.yahoo.com ([69.147.102.75]:42511 "HELO
	smtp112.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753307AbYACNXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:23:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=VPQb/ybDkCkQIGWrZLwYegxFZ1KQjqwbwFfVbD8bRs4kLm1OwJrqgfhUm90pdJwjIjmBpf4I0zBTWsOCcDEPyUyjoie8LjBuljOpB423QkzAVCOgXnsj/mC4Rby9MMUsaJQmQX059MPTPj1KLNUyZ5lO2U0LOtXfZ5DMautW6FQ=  ;
X-YMail-OSG: 6xBtiSkVM1kLWv74JKLYab6sBB2WJMydpo3J7BSy.QAkdI9B8pwHHiHKxvXY9GsUAguHGLxgPw--
From: Borislav Petkov <bbpetkov@yahoo.de>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bzolnier@gmail.com, Borislav Petkov <bbpetkov@yahoo.de>
Subject: [RESEND PATCH 10/10] ide-floppy: replace ntoh{s,l} and hton{s,l} calls with the generic byteorder macros
Date: Thu,  3 Jan 2008 14:20:09 +0100
Message-Id: <1199366409-26016-11-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1199366409-26016-10-git-send-email-bbpetkov@yahoo.de>
References: <1199366409-26016-1-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-2-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-3-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-4-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-5-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-6-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-7-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-8-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-9-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-10-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 6c29b5f..ddab66c 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -695,8 +695,8 @@ static void idefloppy_create_format_unit_cmd(idefloppy_pc_t *pc, int b, int l,
 		pc->buffer[1] ^= 0x20;		/* ... turn off DCRT bit */
 	pc->buffer[3] = 8;
 
-	put_unaligned(htonl(b), (unsigned int *)(&pc->buffer[4]));
-	put_unaligned(htonl(l), (unsigned int *)(&pc->buffer[8]));
+	put_unaligned(cpu_to_be32(b), (unsigned int *)(&pc->buffer[4]));
+	put_unaligned(cpu_to_be32(l), (unsigned int *)(&pc->buffer[8]));
 	pc->buffer_size=12;
 	set_bit(PC_WRITING, &pc->flags);
 }
@@ -723,7 +723,7 @@ static void idefloppy_create_mode_sense_cmd(idefloppy_pc_t *pc, u8 page_code,
 			printk(KERN_ERR "ide-floppy: unsupported page code "
 				"in create_mode_sense_cmd\n");
 	}
-	put_unaligned(htons(length), (u16 *) &pc->c[7]);
+	put_unaligned(cpu_to_be16(length), (u16 *) &pc->c[7]);
 	pc->request_transfer = length;
 }
 
@@ -753,12 +753,12 @@ static void idefloppy_create_rw_cmd(idefloppy_t *floppy, idefloppy_pc_t *pc,
 	idefloppy_init_pc(pc);
 	if (idefl_use_rw(floppy)) {
 		pc->c[0] = cmd == READ ? GPCMD_READ_12 : GPCMD_WRITE_12;
-		put_unaligned(htonl(blocks), (unsigned int *) &pc->c[6]);
+		put_unaligned(cpu_to_be32(blocks), (unsigned int *) &pc->c[6]);
 	} else {
 		pc->c[0] = cmd == READ ? GPCMD_READ_10 : GPCMD_WRITE_10;
-		put_unaligned(htons(blocks), (unsigned short *) &pc->c[7]);
+		put_unaligned(cpu_to_be16(blocks), (unsigned short *) &pc->c[7]);
 	}
-	put_unaligned(htonl(block), (unsigned int *) &pc->c[2]);
+	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[2]);
 	pc->callback = &idefloppy_rw_callback;
 	pc->rq = rq;
 	pc->b_count = cmd == READ ? 0 : rq->bio->bi_size;
@@ -890,10 +890,10 @@ static int idefloppy_get_flexible_disk_page(ide_drive_t *drive)
 	set_disk_ro(floppy->disk, floppy->wp);
 	page = (idefloppy_flex_disk_page_t *) (header + 1);
 
-	page->transfer_rate = ntohs(page->transfer_rate);
-	page->sector_size = ntohs(page->sector_size);
-	page->cyls = ntohs(page->cyls);
-	page->rpm = ntohs(page->rpm);
+	page->transfer_rate = be16_to_cpu(page->transfer_rate);
+	page->sector_size = be16_to_cpu(page->sector_size);
+	page->cyls = be16_to_cpu(page->cyls);
+	page->rpm = be16_to_cpu(page->rpm);
 	capacity = page->cyls * page->heads * page->sectors * page->sector_size;
 
 	if (memcmp (page, &floppy->flex_disk_page,
@@ -972,8 +972,8 @@ static int idefloppy_get_capacity(ide_drive_t *drive)
 	descriptor = (idefloppy_cap_desc_t *) (header + 1);
 
 	for (i = 0; i < descriptors; i++, descriptor++) {
-		blocks = descriptor->blocks = ntohl(descriptor->blocks);
-		length = descriptor->length = ntohs(descriptor->length);
+		blocks = descriptor->blocks = be32_to_cpu(descriptor->blocks);
+		length = descriptor->length = be16_to_cpu(descriptor->length);
 
 		if (!i)
 		{
@@ -1100,8 +1100,8 @@ static int idefloppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
 		if (i == 0)
 			continue;	/* Skip the first descriptor */
 
-		blocks = ntohl(descriptor->blocks);
-		length = ntohs(descriptor->length);
+		blocks = be32_to_cpu(descriptor->blocks);
+		length = be16_to_cpu(descriptor->length);
 
 		if (put_user(blocks, argp))
 			return(-EFAULT);
-- 
1.5.3.7

