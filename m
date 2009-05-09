Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbZEIHtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbZEIHtP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 03:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbZEIHp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 03:45:59 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:47404 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbZEIHpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 03:45:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YUJSipOfW3ZZ52MxJqsLZqYPwWNSwhGOQrDWFszZprGg+5CfosyCQUXozxKQFQ7Xv2
         46BwMmDcLFyKg/nwxF/Fmty4yL7V5NggSkSvwGkij9Crz7TWJzsC2f1l2ZbYfV75yHN1
         rqHpTgd01dsGUqYoOiiqZi5O5Ff42SgPqAnvo=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/14] ide-floppy/ide_floppy_format_unit: use local buffer
Date: Sat,  9 May 2009 09:45:28 +0200
Message-Id: <1241855134-4984-9-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241855134-4984-1-git-send-email-petkovbb@gmail.com>
References: <1241855134-4984-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass the buffer into ide_floppy_create_format_unit_cmd instead of using
pc->buf.

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-floppy_ioctl.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/ide/ide-floppy_ioctl.c b/drivers/ide/ide-floppy_ioctl.c
index 0d2c9f0..7a03d34 100644
--- a/drivers/ide/ide-floppy_ioctl.c
+++ b/drivers/ide/ide-floppy_ioctl.c
@@ -93,24 +93,25 @@ static int ide_floppy_get_format_capacities(ide_drive_t *drive,
 	return 0;
 }
 
-static void ide_floppy_create_format_unit_cmd(struct ide_atapi_pc *pc, int b,
-		int l, int flags)
+static void ide_floppy_create_format_unit_cmd(struct ide_atapi_pc *pc,
+					      u8 *buf, int b, int l,
+					      int flags)
 {
 	ide_init_pc(pc);
 	pc->c[0] = GPCMD_FORMAT_UNIT;
 	pc->c[1] = 0x17;
 
-	memset(pc->buf, 0, 12);
-	pc->buf[1] = 0xA2;
+	memset(buf, 0, 12);
+	buf[1] = 0xA2;
 	/* Default format list header, u8 1: FOV/DCRT/IMM bits set */
 
 	if (flags & 1)				/* Verify bit on... */
-		pc->buf[1] ^= 0x20;		/* ... turn off DCRT bit */
-	pc->buf[3] = 8;
+		buf[1] ^= 0x20;			/* ... turn off DCRT bit */
+	buf[3] = 8;
 
-	put_unaligned(cpu_to_be32(b), (unsigned int *)(&pc->buf[4]));
-	put_unaligned(cpu_to_be32(l), (unsigned int *)(&pc->buf[8]));
-	pc->buf_size = 12;
+	put_unaligned(cpu_to_be32(b), (unsigned int *)(&buf[4]));
+	put_unaligned(cpu_to_be32(l), (unsigned int *)(&buf[8]));
+	pc->req_xfer = 12;
 	pc->flags |= PC_FLAG_WRITING;
 }
 
@@ -137,6 +138,7 @@ static int ide_floppy_format_unit(ide_drive_t *drive, struct ide_atapi_pc *pc,
 				  int __user *arg)
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
+	u8 buf[12];
 	int blocks, length, flags, err = 0;
 
 	if (floppy->openers > 1) {
@@ -170,9 +172,9 @@ static int ide_floppy_format_unit(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	}
 
 	ide_floppy_get_sfrp_bit(drive, pc);
-	ide_floppy_create_format_unit_cmd(pc, blocks, length, flags);
+	ide_floppy_create_format_unit_cmd(pc, buf, blocks, length, flags);
 
-	if (ide_queue_pc_tail(drive, floppy->disk, pc, pc->buf, pc->req_xfer))
+	if (ide_queue_pc_tail(drive, floppy->disk, pc, buf, pc->req_xfer))
 		err = -EIO;
 
 out:
-- 
1.6.2.4

