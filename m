Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbZBPAM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbZBPAM0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 19:12:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbZBPALw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 19:11:52 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:51372 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbZBPALt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 19:11:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Qz7+bRoUrgXTXEpF5itV186fvfWR8z0n+ubI37z2YCLGU7ey66DfO/QaO6Op6eoW5Z
         4Nu+6UfwfLtk+f6GO2RSmZAmDJTL+vPhCK5J5tnkIPDvXS+nIW5z90VXfGsZgJqAzSHw
         aMOhxR4WXlauGIXre2eLeAaJi6Vt1HDqY3rTI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 16 Feb 2009 01:13:16 +0100
Message-Id: <20090216001316.27491.28672.sendpatchset@localhost.localdomain>
In-Reply-To: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
References: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
Subject: [PATCH 01/20] ide: add support for arbitrary transfer lengths to ide_pio_bytes()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: add support for arbitrary transfer lengths to ide_pio_bytes()

Add support for arbitrary transfer lengths to ide_pio_bytes()
and then inline ide_pio_multi() into ide_pio_datablock().

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-taskfile.c |   73 ++++++++++++++++++++++-----------------------
 1 file changed, 37 insertions(+), 36 deletions(-)

Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -189,7 +189,7 @@ static u8 wait_drive_not_busy(ide_drive_
 }
 
 static void ide_pio_bytes(ide_drive_t *drive, struct ide_cmd *cmd,
-			  unsigned int write, unsigned int nr_bytes)
+			  unsigned int write, unsigned int len)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct scatterlist *sg = hwif->sg_table;
@@ -202,56 +202,55 @@ static void ide_pio_bytes(ide_drive_t *d
 	u8 *buf;
 
 	cursg = cmd->cursg;
-	if (!cursg) {
-		cursg = sg;
-		cmd->cursg = sg;
-	}
+	if (cursg == NULL)
+		cursg = cmd->cursg = sg;
+
+	while (len) {
+		unsigned nr_bytes = min(len, cursg->length - cmd->cursg_ofs);
+
+		if (nr_bytes > PAGE_SIZE)
+			nr_bytes = PAGE_SIZE;
 
-	page = sg_page(cursg);
-	offset = cursg->offset + cmd->cursg_ofs;
+		page = sg_page(cursg);
+		offset = cursg->offset + cmd->cursg_ofs;
 
-	/* get the current page and offset */
-	page = nth_page(page, (offset >> PAGE_SHIFT));
-	offset %= PAGE_SIZE;
+		/* get the current page and offset */
+		page = nth_page(page, (offset >> PAGE_SHIFT));
+		offset %= PAGE_SIZE;
 
 #ifdef CONFIG_HIGHMEM
-	local_irq_save(flags);
+		local_irq_save(flags);
 #endif
-	buf = kmap_atomic(page, KM_BIO_SRC_IRQ) + offset;
+		buf = kmap_atomic(page, KM_BIO_SRC_IRQ) + offset;
 
-	cmd->nleft -= nr_bytes;
-	cmd->cursg_ofs += nr_bytes;
+		cmd->nleft -= nr_bytes;
+		cmd->cursg_ofs += nr_bytes;
 
-	if (cmd->cursg_ofs == cursg->length) {
-		cmd->cursg = sg_next(cmd->cursg);
-		cmd->cursg_ofs = 0;
-	}
+		if (cmd->cursg_ofs == cursg->length) {
+			cursg = cmd->cursg = sg_next(cmd->cursg);
+			cmd->cursg_ofs = 0;
+		}
 
-	/* do the actual data transfer */
-	if (write)
-		hwif->tp_ops->output_data(drive, cmd, buf, nr_bytes);
-	else
-		hwif->tp_ops->input_data(drive, cmd, buf, nr_bytes);
+		/* do the actual data transfer */
+		if (write)
+			hwif->tp_ops->output_data(drive, cmd, buf, nr_bytes);
+		else
+			hwif->tp_ops->input_data(drive, cmd, buf, nr_bytes);
 
-	kunmap_atomic(buf, KM_BIO_SRC_IRQ);
+		kunmap_atomic(buf, KM_BIO_SRC_IRQ);
 #ifdef CONFIG_HIGHMEM
-	local_irq_restore(flags);
+		local_irq_restore(flags);
 #endif
-}
-
-static void ide_pio_multi(ide_drive_t *drive, struct ide_cmd *cmd,
-			  unsigned int write)
-{
-	unsigned int nsect;
 
-	nsect = min_t(unsigned int, cmd->nleft >> 9, drive->mult_count);
-	while (nsect--)
-		ide_pio_bytes(drive, cmd, write, SECTOR_SIZE);
+		len -= nr_bytes;
+	}
 }
 
 static void ide_pio_datablock(ide_drive_t *drive, struct ide_cmd *cmd,
 			      unsigned int write)
 {
+	unsigned int nr_bytes;
+
 	u8 saved_io_32bit = drive->io_32bit;
 
 	if (cmd->tf_flags & IDE_TFLAG_FS)
@@ -263,9 +262,11 @@ static void ide_pio_datablock(ide_drive_
 	touch_softlockup_watchdog();
 
 	if (cmd->tf_flags & IDE_TFLAG_MULTI_PIO)
-		ide_pio_multi(drive, cmd, write);
+		nr_bytes = min_t(unsigned, cmd->nleft, drive->mult_count << 9);
 	else
-		ide_pio_bytes(drive, cmd, write, SECTOR_SIZE);
+		nr_bytes = SECTOR_SIZE;
+
+	ide_pio_bytes(drive, cmd, write, nr_bytes);
 
 	drive->io_32bit = saved_io_32bit;
 }
