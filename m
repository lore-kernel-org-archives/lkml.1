Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbZEIHse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbZEIHse (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 03:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbZEIHpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 03:45:55 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:51936 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbZEIHpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 03:45:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hx1SS8B8MT02bov4kbjxbpzVUNGs36qbNBOvnavhTNSZxzQTDSvvRVaemjOFGoS6FJ
         6X2G7vBfSVadiBXRyf+6/OthTiFBKOHRSNVlVwWfcgL3V7traHGw8hDmu7a0gO3mROmH
         wA84HNIxCfwbLHfjZJcdDblYmnonTayvPB70U=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/14] ide-floppy/ide_floppy_get_flexible_disk_page: use local buffer
Date: Sat,  9 May 2009 09:45:26 +0200
Message-Id: <1241855134-4984-7-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241855134-4984-1-git-send-email-petkovbb@gmail.com>
References: <1241855134-4984-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-floppy.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index be21cf2..060c893 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -311,33 +311,33 @@ static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive,
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
 	struct gendisk *disk = floppy->disk;
-	u8 *page;
+	u8 *page, buf[40];
 	int capacity, lba_capacity;
 	u16 transfer_rate, sector_size, cyls, rpm;
 	u8 heads, sectors;
 
 	ide_floppy_create_mode_sense_cmd(pc, IDEFLOPPY_FLEXIBLE_DISK_PAGE);
 
-	if (ide_queue_pc_tail(drive, disk, pc, pc->buf, pc->req_xfer)) {
+	if (ide_queue_pc_tail(drive, disk, pc, buf, pc->req_xfer)) {
 		printk(KERN_ERR PFX "Can't get flexible disk page params\n");
 		return 1;
 	}
 
-	if (pc->buf[3] & 0x80)
+	if (buf[3] & 0x80)
 		drive->dev_flags |= IDE_DFLAG_WP;
 	else
 		drive->dev_flags &= ~IDE_DFLAG_WP;
 
 	set_disk_ro(disk, !!(drive->dev_flags & IDE_DFLAG_WP));
 
-	page = &pc->buf[8];
+	page = &buf[8];
 
-	transfer_rate = be16_to_cpup((__be16 *)&pc->buf[8 + 2]);
-	sector_size   = be16_to_cpup((__be16 *)&pc->buf[8 + 6]);
-	cyls          = be16_to_cpup((__be16 *)&pc->buf[8 + 8]);
-	rpm           = be16_to_cpup((__be16 *)&pc->buf[8 + 28]);
-	heads         = pc->buf[8 + 4];
-	sectors       = pc->buf[8 + 5];
+	transfer_rate = be16_to_cpup((__be16 *)&buf[8 + 2]);
+	sector_size   = be16_to_cpup((__be16 *)&buf[8 + 6]);
+	cyls          = be16_to_cpup((__be16 *)&buf[8 + 8]);
+	rpm           = be16_to_cpup((__be16 *)&buf[8 + 28]);
+	heads         = buf[8 + 4];
+	sectors       = buf[8 + 5];
 
 	capacity = cyls * heads * sectors * sector_size;
 
-- 
1.6.2.4

