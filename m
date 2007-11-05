Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbXKEUny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbXKEUny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 15:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbXKEUnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 15:43:41 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:61749 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbXKEUnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 15:43:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=GikxTKvjUH0YW9sqDi34JGqHyHD0g8rCXpvzjro5CQeEeDlW6B5OakPIpoyJ4Xb+GRc9LLa+kCJkwt3x6AAo3AQ33OI1ygwrTwzhOUEm8HSaGqB75PIOxhS7qxzScXMao2XeFkYr88tW23H5GM/DCuxfExKm05cqS6/gimmNgkE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE fixes
Date: Mon, 5 Nov 2007 21:49:04 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711052149.05414.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/Kconfig        |   22 ++++++++++++++++++----
 drivers/ide/ide-dma.c      |    5 +++--
 drivers/ide/ide-io.c       |    5 ++++-
 drivers/ide/ide-iops.c     |    8 ++++++--
 drivers/ide/ide-probe.c    |    5 +++--
 drivers/ide/ide-taskfile.c |    3 +++
 drivers/ide/pci/piix.c     |    1 +
 include/linux/ide.h        |    9 +--------
 8 files changed, 39 insertions(+), 19 deletions(-)


Adrian Bunk (1):
      ide: unexport ide_fix_driveid

Bartlomiej Zolnierkiewicz (8):
      ide/Kconfig: fix BLK_DEV_OFFBOARD dependencies
      ide: check rq->cmd_type in drive_cmd_intr()
      ide: clear HOB bit for REQ_TYPE_ATA_TASK requests in ide_end_drive_cmd()
      ide: add missing rq.ref_count initialization to ide_diag_taskfile()
      ide: fix ide_find_dma_mode() to print human-readable info
      ide: add missing #ifdef/#endif CONFIG_IDE_TASK_IOCTL
      ide: move ide_fixstring() documentation to ide-iops.c from ide.h
      ide: fix IDE_HFLAG_NO_ATAPI_DMA handling in config_drive_for_dma()

Matti Linnanvuori (1):
      ide/Kconfig: add IDEDISK_MULTI_MODE text adapted from hdparm manual page

Tejun Heo (1):
      ide: do_identify() string termination fix

sebdeg@ngi.it (1):
      piix: add support for ICH7 on Acer 5602aWLMi


diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 6eaece9..d1e8df1 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -152,9 +152,22 @@ config BLK_DEV_IDEDISK
 	  If unsure, say Y.
 
 config IDEDISK_MULTI_MODE
-	bool "Use multi-mode by default"
-	help
-	  If you get this error, try to say Y here:
+	bool "Use multiple sector mode for Programmed Input/Output by default"
+	help
+	  This setting is irrelevant for most IDE disks, with direct memory
+	  access, to which multiple sector mode does not apply. Multiple sector
+	  mode is a feature of most modern IDE hard drives, permitting the
+	  transfer of multiple sectors per Programmed Input/Output interrupt,
+	  rather than the usual one sector per interrupt. When this feature is
+	  enabled, it can reduce operating system overhead for disk Programmed
+	  Input/Output. On some systems, it also can increase the data
+	  throughput of Programmed Input/Output. Some drives, however, seemed
+	  to run slower with multiple sector mode enabled. Some drives claimed
+	  to support multiple sector mode, but lost data at some settings.
+	  Under rare circumstances, such failures could result in massive
+	  filesystem corruption.
+
+	  If you get the following error, try to say Y here:
 
 	  hda: set_multmode: status=0x51 { DriveReady SeekComplete Error }
 	  hda: set_multmode: error=0x04 { DriveStatusError }
@@ -380,9 +393,10 @@ config IDEPCI_SHARE_IRQ
 config IDEPCI_PCIBUS_ORDER
 	def_bool BLK_DEV_IDE=y && BLK_DEV_IDEPCI
 
+# TODO: split it on per host driver config options (or module parameters)
 config BLK_DEV_OFFBOARD
 	bool "Boot off-board chipsets first support"
-	depends on BLK_DEV_IDEPCI
+	depends on BLK_DEV_IDEPCI && (BLK_DEV_AEC62XX || BLK_DEV_GENERIC || BLK_DEV_HPT34X || BLK_DEV_HPT366 || BLK_DEV_PDC202XX_NEW || BLK_DEV_PDC202XX_OLD || BLK_DEV_TC86C001)
 	help
 	  Normally, IDE controllers built into the motherboard (on-board
 	  controllers) are assigned to ide0 and ide1 while those on add-in PCI
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 428f7a8..e3add70 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -340,7 +340,7 @@ static int config_drive_for_dma (ide_drive_t *drive)
 
 	if (drive->media != ide_disk) {
 		if (hwif->host_flags & IDE_HFLAG_NO_ATAPI_DMA)
-			return -1;
+			return 0;
 	}
 
 	/*
@@ -752,7 +752,8 @@ u8 ide_find_dma_mode(ide_drive_t *drive, u8 req_mode)
 			mode = XFER_MW_DMA_1;
 	}
 
-	printk(KERN_DEBUG "%s: selected mode 0x%x\n", drive->name, mode);
+	printk(KERN_DEBUG "%s: %s mode selected\n", drive->name,
+			  mode ? ide_xfer_verbose(mode) : "no DMA");
 
 	return min(mode, req_mode);
 }
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index c89f0d3..7550118 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -340,6 +340,8 @@ void ide_end_drive_cmd (ide_drive_t *drive, u8 stat, u8 err)
 		if (args) {
 			args[0] = stat;
 			args[1] = err;
+			/* be sure we're looking at the low order bits */
+			hwif->OUTB(drive->ctl & ~0x80, IDE_CONTROL_REG);
 			args[2] = hwif->INB(IDE_NSECTOR_REG);
 			args[3] = hwif->INB(IDE_SECTOR_REG);
 			args[4] = hwif->INB(IDE_LCYL_REG);
@@ -654,7 +656,8 @@ static ide_startstop_t drive_cmd_intr (ide_drive_t *drive)
 	int retries = 10;
 
 	local_irq_enable_in_hardirq();
-	if ((stat & DRQ_STAT) && args && args[3]) {
+	if (rq->cmd_type == REQ_TYPE_ATA_CMD &&
+	    (stat & DRQ_STAT) && args && args[3]) {
 		u8 io_32bit = drive->io_32bit;
 		drive->io_32bit = 0;
 		hwif->ata_input_data(drive, &args[4], args[3] * SECTOR_WORDS);
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index dcda0f1..e17a9ee 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -403,8 +403,12 @@ void ide_fix_driveid (struct hd_driveid *id)
 #endif
 }
 
-/* FIXME: exported for use by the USB storage (isd200.c) code only */
-EXPORT_SYMBOL(ide_fix_driveid);
+/*
+ * ide_fixstring() cleans up and (optionally) byte-swaps a text string,
+ * removing leading/trailing blanks and compressing internal blanks.
+ * It is primarily used to tidy up the model name/number fields as
+ * returned by the WIN_[P]IDENTIFY commands.
+ */
 
 void ide_fixstring (u8 *s, const int bytecount, const int byteswap)
 {
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 6a6f2e0..56fb0b8 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -172,11 +172,12 @@ static inline void do_identify (ide_drive_t *drive, u8 cmd)
 	ide_fixstring(id->fw_rev,    sizeof(id->fw_rev),    bswap);
 	ide_fixstring(id->serial_no, sizeof(id->serial_no), bswap);
 
+	/* we depend on this a lot! */
+	id->model[sizeof(id->model)-1] = '\0';
+
 	if (strstr(id->model, "E X A B Y T E N E S T"))
 		goto err_misc;
 
-	/* we depend on this a lot! */
-	id->model[sizeof(id->model)-1] = '\0';
 	printk("%s: %s, ", drive->name, id->model);
 	drive->present = 1;
 	drive->dead = 0;
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index d066546..2b60f1b 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -471,6 +471,7 @@ static int ide_diag_taskfile(ide_drive_t *drive, ide_task_t *args, unsigned long
 	struct request rq;
 
 	memset(&rq, 0, sizeof(rq));
+	rq.ref_count = 1;
 	rq.cmd_type = REQ_TYPE_ATA_TASKFILE;
 	rq.buffer = buf;
 
@@ -511,6 +512,7 @@ int ide_raw_taskfile (ide_drive_t *drive, ide_task_t *args, u8 *buf)
 
 EXPORT_SYMBOL(ide_raw_taskfile);
 
+#ifdef CONFIG_IDE_TASK_IOCTL
 int ide_taskfile_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
 {
 	ide_task_request_t	*req_task;
@@ -660,6 +662,7 @@ abort:
 
 	return err;
 }
+#endif
 
 int ide_wait_cmd (ide_drive_t *drive, u8 cmd, u8 nsect, u8 feature, u8 sectors, u8 *buf)
 {
diff --git a/drivers/ide/pci/piix.c b/drivers/ide/pci/piix.c
index 9329d4a..63625a0 100644
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -302,6 +302,7 @@ struct ich_laptop {
 
 static const struct ich_laptop ich_laptop[] = {
 	/* devid, subvendor, subdev */
+	{ 0x27DF, 0x1025, 0x0102 },	/* ICH7 on Acer 5602aWLMi */
 	{ 0x27DF, 0x0005, 0x0280 },	/* ICH7 on Acer 5602WLMi */
 	{ 0x27DF, 0x1025, 0x0110 },	/* ICH7 on Acer 3682WLMi */
 	{ 0x27DF, 0x1043, 0x1267 },	/* ICH7 on Asus W5F */
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 4ed4777..dc75ccb 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1031,14 +1031,7 @@ ide_startstop_t __ide_abort(ide_drive_t *, struct request *);
 extern ide_startstop_t ide_abort(ide_drive_t *, const char *);
 
 extern void ide_fix_driveid(struct hd_driveid *);
-/*
- * ide_fixstring() cleans up and (optionally) byte-swaps a text string,
- * removing leading/trailing blanks and compressing internal blanks.
- * It is primarily used to tidy up the model name/number fields as
- * returned by the WIN_[P]IDENTIFY commands.
- *
- * (s, bytecount, byteswap)
- */
+
 extern void ide_fixstring(u8 *, const int, const int);
 
 int ide_wait_stat(ide_startstop_t *, ide_drive_t *, u8, u8, unsigned long);
