Return-Path: <linux-kernel-owner+w=401wt.eu-S1761311AbYAKMEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761311AbYAKMEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 07:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758725AbYAKMDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 07:03:35 -0500
Received: from smtp107.plus.mail.re1.yahoo.com ([69.147.102.70]:20661 "HELO
	smtp107.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758159AbYAKMD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 07:03:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=WjeTbkI96Mg78DfaQz3qZpREMkrOp1Ap5ryXC7MtgLsAvKhXdUNVsVkR+IC2LuTPlLeCrlKvMVhzu8jT7UlEW0IPAOyQOZ+zF2amlU6oXZms8mb+x6s5VuD0OVqTRX5VG7iEqMHiyAikB/t14e0WIM0Vzz72AhQN3SovRgDX0yA=  ;
X-YMail-OSG: _wIkPecVM1mjNcMwqR1q5a2T0gdPvVpiJ7gm5Vnk8RYULeFf1lS5dD4Plhfn1cl61wSsARdxiw--
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej@gollum.tnic, Zolnierkiewicz@gollum.tnic, <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 02/21] ide-floppy: replace ntoh{s,l} and hton{s,l} calls with the generic byteorder
Date: Fri, 11 Jan 2008 12:58:00 +0100
Message-Id: <1200052699-28420-3-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1200052699-28420-2-git-send-email-bbpetkov@yahoo.de>
References: <1200052699-28420-1-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-2-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index e4ebb21..e63758a 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -1060,8 +1060,8 @@ static void idefloppy_create_format_unit_cmd (idefloppy_pc_t *pc, int b, int l,
 		pc->buffer[1] ^= 0x20;		/* ... turn off DCRT bit */
 	pc->buffer[3] = 8;
 
-	put_unaligned(htonl(b), (unsigned int *)(&pc->buffer[4]));
-	put_unaligned(htonl(l), (unsigned int *)(&pc->buffer[8]));
+	put_unaligned(cpu_to_be32(b), (unsigned int *)(&pc->buffer[4]));
+	put_unaligned(cpu_to_be32(l), (unsigned int *)(&pc->buffer[8]));
 	pc->buffer_size=12;
 	set_bit(PC_WRITING, &pc->flags);
 }
@@ -1089,7 +1089,7 @@ static void idefloppy_create_mode_sense_cmd (idefloppy_pc_t *pc, u8 page_code, u
 			printk(KERN_ERR "ide-floppy: unsupported page code "
 				"in create_mode_sense_cmd\n");
 	}
-	put_unaligned(htons(length), (u16 *) &pc->c[7]);
+	put_unaligned(cpu_to_be16(length), (u16 *) &pc->c[7]);
 	pc->request_transfer = length;
 }
 
@@ -1119,12 +1119,12 @@ static void idefloppy_create_rw_cmd (idefloppy_floppy_t *floppy, idefloppy_pc_t
 	idefloppy_init_pc(pc);
 	if (test_bit(IDEFLOPPY_USE_READ12, &floppy->flags)) {
 		pc->c[0] = cmd == READ ? GPCMD_READ_12 : GPCMD_WRITE_12;
-		put_unaligned(htonl(blocks), (unsigned int *) &pc->c[6]);
+		put_unaligned(cpu_to_be32(blocks), (unsigned int *) &pc->c[6]);
 	} else {
 		pc->c[0] = cmd == READ ? GPCMD_READ_10 : GPCMD_WRITE_10;
-		put_unaligned(htons(blocks), (unsigned short *) &pc->c[7]);
+		put_unaligned(cpu_to_be16(blocks), (unsigned short *)&pc->c[7]);
 	}
-	put_unaligned(htonl(block), (unsigned int *) &pc->c[2]);
+	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[2]);
 	pc->callback = &idefloppy_rw_callback;
 	pc->rq = rq;
 	pc->b_count = cmd == READ ? 0 : rq->bio->bi_size;
@@ -1252,10 +1252,10 @@ static int idefloppy_get_flexible_disk_page (ide_drive_t *drive)
 	set_disk_ro(floppy->disk, floppy->wp);
 	page = (idefloppy_flexible_disk_page_t *) (header + 1);
 
-	page->transfer_rate = ntohs(page->transfer_rate);
-	page->sector_size = ntohs(page->sector_size);
-	page->cyls = ntohs(page->cyls);
-	page->rpm = ntohs(page->rpm);
+	page->transfer_rate = be16_to_cpu(page->transfer_rate);
+	page->sector_size = be16_to_cpu(page->sector_size);
+	page->cyls = be16_to_cpu(page->cyls);
+	page->rpm = be16_to_cpu(page->rpm);
 	capacity = page->cyls * page->heads * page->sectors * page->sector_size;
 	if (memcmp (page, &floppy->flexible_disk_page, sizeof (idefloppy_flexible_disk_page_t)))
 		printk(KERN_INFO "%s: %dkB, %d/%d/%d CHS, %d kBps, "
@@ -1328,8 +1328,8 @@ static int idefloppy_get_capacity (ide_drive_t *drive)
 	descriptor = (idefloppy_capacity_descriptor_t *) (header + 1);
 
 	for (i = 0; i < descriptors; i++, descriptor++) {
-		blocks = descriptor->blocks = ntohl(descriptor->blocks);
-		length = descriptor->length = ntohs(descriptor->length);
+		blocks = descriptor->blocks = be32_to_cpu(descriptor->blocks);
+		length = descriptor->length = be16_to_cpu(descriptor->length);
 
 		if (!i) 
 		{
@@ -1456,8 +1456,8 @@ static int idefloppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
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

