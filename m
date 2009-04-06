Return-Path: <linux-kernel-owner+w=401wt.eu-S1754414AbZDFQJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbZDFQJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 12:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbZDFQJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 12:09:08 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:56060 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbZDFQJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 12:09:06 -0400
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] tx493[89]ide: Remove big endian version of tx493[89]ide_tf_{load,read}
Date: Tue,  7 Apr 2009 01:09:06 +0900
Message-Id: <1239034146-3514-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now tx493[89]ide_tf_{load,read} do not contain word I/O operations.
They are endian-free now.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/ide/tx4938ide.c |   89 +-----------------------------------------
 drivers/ide/tx4939ide.c |   99 +++--------------------------------------------
 2 files changed, 8 insertions(+), 180 deletions(-)

diff --git a/drivers/ide/tx4938ide.c b/drivers/ide/tx4938ide.c
index 4cb79c4..e33d764 100644
--- a/drivers/ide/tx4938ide.c
+++ b/drivers/ide/tx4938ide.c
@@ -72,91 +72,6 @@ static void tx4938ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
 #ifdef __BIG_ENDIAN
 
 /* custom iops (independent from SWAP_IO_SPACE) */
-static u8 tx4938ide_inb(unsigned long port)
-{
-	return __raw_readb((void __iomem *)port);
-}
-
-static void tx4938ide_outb(u8 value, unsigned long port)
-{
-	__raw_writeb(value, (void __iomem *)port);
-}
-
-static void tx4938ide_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &cmd->tf;
-	u8 HIHI = cmd->tf_flags & IDE_TFLAG_LBA48 ? 0xE0 : 0xEF;
-
-	if (cmd->ftf_flags & IDE_FTFLAG_FLAGGED)
-		HIHI = 0xFF;
-
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
-		tx4938ide_outb(tf->hob_feature, io_ports->feature_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
-		tx4938ide_outb(tf->hob_nsect, io_ports->nsect_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
-		tx4938ide_outb(tf->hob_lbal, io_ports->lbal_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
-		tx4938ide_outb(tf->hob_lbam, io_ports->lbam_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
-		tx4938ide_outb(tf->hob_lbah, io_ports->lbah_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_OUT_FEATURE)
-		tx4938ide_outb(tf->feature, io_ports->feature_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_NSECT)
-		tx4938ide_outb(tf->nsect, io_ports->nsect_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAL)
-		tx4938ide_outb(tf->lbal, io_ports->lbal_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAM)
-		tx4938ide_outb(tf->lbam, io_ports->lbam_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAH)
-		tx4938ide_outb(tf->lbah, io_ports->lbah_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_OUT_DEVICE)
-		tx4938ide_outb((tf->device & HIHI) | drive->select,
-			       io_ports->device_addr);
-}
-
-static void tx4938ide_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &cmd->tf;
-
-	/* be sure we're looking at the low order bits */
-	tx4938ide_outb(ATA_DEVCTL_OBS, io_ports->ctl_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_IN_ERROR)
-		tf->error  = tx4938ide_inb(io_ports->feature_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
-		tf->nsect  = tx4938ide_inb(io_ports->nsect_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_LBAL)
-		tf->lbal   = tx4938ide_inb(io_ports->lbal_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_LBAM)
-		tf->lbam   = tx4938ide_inb(io_ports->lbam_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_LBAH)
-		tf->lbah   = tx4938ide_inb(io_ports->lbah_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_DEVICE)
-		tf->device = tx4938ide_inb(io_ports->device_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
-		tx4938ide_outb(ATA_HOB | ATA_DEVCTL_OBS, io_ports->ctl_addr);
-
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_ERROR)
-			tf->hob_error = tx4938ide_inb(io_ports->feature_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
-			tf->hob_nsect = tx4938ide_inb(io_ports->nsect_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
-			tf->hob_lbal  = tx4938ide_inb(io_ports->lbal_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
-			tf->hob_lbam  = tx4938ide_inb(io_ports->lbam_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
-			tf->hob_lbah  = tx4938ide_inb(io_ports->lbah_addr);
-	}
-}
-
 static void tx4938ide_input_data_swap(ide_drive_t *drive, struct ide_cmd *cmd,
 				void *buf, unsigned int len)
 {
@@ -190,8 +105,8 @@ static const struct ide_tp_ops tx4938ide_tp_ops = {
 	.write_devctl		= ide_write_devctl,
 
 	.dev_select		= ide_dev_select,
-	.tf_load		= tx4938ide_tf_load,
-	.tf_read		= tx4938ide_tf_read,
+	.tf_load		= ide_tf_load,
+	.tf_read		= ide_tf_read,
 
 	.input_data		= tx4938ide_input_data_swap,
 	.output_data		= tx4938ide_output_data_swap,
diff --git a/drivers/ide/tx4939ide.c b/drivers/ide/tx4939ide.c
index 0040a9a..2aad79b 100644
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -434,96 +434,17 @@ static void tx4939ide_tf_load_fixup(ide_drive_t *drive)
 	tx4939ide_writew(sysctl, base, TX4939IDE_Sys_Ctl);
 }
 
-#ifdef __BIG_ENDIAN
-
-/* custom iops (independent from SWAP_IO_SPACE) */
-static u8 tx4939ide_inb(unsigned long port)
-{
-	return __raw_readb((void __iomem *)port);
-}
-
-static void tx4939ide_outb(u8 value, unsigned long port)
-{
-	__raw_writeb(value, (void __iomem *)port);
-}
-
 static void tx4939ide_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
 {
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &cmd->tf;
-	u8 HIHI = cmd->tf_flags & IDE_TFLAG_LBA48 ? 0xE0 : 0xEF;
-
-	if (cmd->ftf_flags & IDE_FTFLAG_FLAGGED)
-		HIHI = 0xFF;
-
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
-		tx4939ide_outb(tf->hob_feature, io_ports->feature_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
-		tx4939ide_outb(tf->hob_nsect, io_ports->nsect_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
-		tx4939ide_outb(tf->hob_lbal, io_ports->lbal_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
-		tx4939ide_outb(tf->hob_lbam, io_ports->lbam_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
-		tx4939ide_outb(tf->hob_lbah, io_ports->lbah_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_OUT_FEATURE)
-		tx4939ide_outb(tf->feature, io_ports->feature_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_NSECT)
-		tx4939ide_outb(tf->nsect, io_ports->nsect_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAL)
-		tx4939ide_outb(tf->lbal, io_ports->lbal_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAM)
-		tx4939ide_outb(tf->lbam, io_ports->lbam_addr);
-	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAH)
-		tx4939ide_outb(tf->lbah, io_ports->lbah_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_OUT_DEVICE) {
-		tx4939ide_outb((tf->device & HIHI) | drive->select,
-			       io_ports->device_addr);
+	ide_tf_load(drive, cmd);
+
+	if (cmd->tf_flags & IDE_TFLAG_OUT_DEVICE)
 		tx4939ide_tf_load_fixup(drive);
-	}
 }
 
-static void tx4939ide_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &cmd->tf;
-
-	/* be sure we're looking at the low order bits */
-	tx4939ide_outb(ATA_DEVCTL_OBS, io_ports->ctl_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_IN_ERROR)
-		tf->error  = tx4939ide_inb(io_ports->feature_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
-		tf->nsect  = tx4939ide_inb(io_ports->nsect_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_LBAL)
-		tf->lbal   = tx4939ide_inb(io_ports->lbal_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_LBAM)
-		tf->lbam   = tx4939ide_inb(io_ports->lbam_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_LBAH)
-		tf->lbah   = tx4939ide_inb(io_ports->lbah_addr);
-	if (cmd->tf_flags & IDE_TFLAG_IN_DEVICE)
-		tf->device = tx4939ide_inb(io_ports->device_addr);
-
-	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
-		tx4939ide_outb(ATA_HOB | ATA_DEVCTL_OBS, io_ports->ctl_addr);
-
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_ERROR)
-			tf->hob_error =	tx4939ide_inb(io_ports->feature_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
-			tf->hob_nsect = tx4939ide_inb(io_ports->nsect_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
-			tf->hob_lbal  = tx4939ide_inb(io_ports->lbal_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
-			tf->hob_lbam  = tx4939ide_inb(io_ports->lbam_addr);
-		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
-			tf->hob_lbah  = tx4939ide_inb(io_ports->lbah_addr);
-	}
-}
+#ifdef __BIG_ENDIAN
 
+/* custom iops (independent from SWAP_IO_SPACE) */
 static void tx4939ide_input_data_swap(ide_drive_t *drive, struct request *rq,
 				void *buf, unsigned int len)
 {
@@ -558,7 +479,7 @@ static const struct ide_tp_ops tx4939ide_tp_ops = {
 
 	.dev_select		= ide_dev_select,
 	.tf_load		= tx4939ide_tf_load,
-	.tf_read		= tx4939ide_tf_read,
+	.tf_read		= ide_tf_read,
 
 	.input_data		= tx4939ide_input_data_swap,
 	.output_data		= tx4939ide_output_data_swap,
@@ -566,14 +487,6 @@ static const struct ide_tp_ops tx4939ide_tp_ops = {
 
 #else	/* __LITTLE_ENDIAN */
 
-static void tx4939ide_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
-{
-	ide_tf_load(drive, cmd);
-
-	if (cmd->tf_flags & IDE_TFLAG_OUT_DEVICE)
-		tx4939ide_tf_load_fixup(drive);
-}
-
 static const struct ide_tp_ops tx4939ide_tp_ops = {
 	.exec_command		= ide_exec_command,
 	.read_status		= ide_read_status,
-- 
1.5.6.3

