Return-Path: <linux-kernel-owner+w=401wt.eu-S1755796AbZERCZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbZERCZN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 22:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755917AbZERCY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 22:24:28 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4761 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467AbZERCYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 22:24:24 -0400
From: Joe Perches <joe@perches.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Borislav Petkov <petkovbb@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Perches <joe@perches.com>
Subject: [PATCH 5/6] drivers/ide: Convert printk(KERN_CONT to pr_cont(
Date: Sun, 17 May 2009 19:21:14 -0700
Message-Id: <522167ee2abb43d5f60cc88c6b2a7aae317852ed.1242609804.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1242609803.git.joe@perches.com>
References: <cover.1242609803.git.joe@perches.com>
In-Reply-To: <cover.1242609803.git.joe@perches.com>
References: <cover.1242609803.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/ide/ide-cd.c         |   24 ++++++++--------
 drivers/ide/ide-cd_verbose.c |   38 +++++++++++++++++----------
 drivers/ide/ide-disk.c       |    4 +-
 drivers/ide/ide-eh.c         |    8 +++---
 drivers/ide/ide-lib.c        |   58 +++++++++++++++++++++---------------------
 drivers/ide/ide-probe.c      |   20 +++++++-------
 drivers/ide/it821x.c         |    4 +-
 drivers/ide/trm290.c         |    2 +-
 8 files changed, 84 insertions(+), 74 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index f2836c0..3578fa0 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1359,27 +1359,27 @@ static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 
 	/* don't print speed if the drive reported 0 */
 	if (cd->max_speed)
-		printk(KERN_CONT " %dX", cd->max_speed);
+		pr_cont(" %dX", cd->max_speed);
 
-	printk(KERN_CONT " %s", (cdi->mask & CDC_DVD) ? "CD-ROM" : "DVD-ROM");
+	pr_cont(" %s", (cdi->mask & CDC_DVD) ? "CD-ROM" : "DVD-ROM");
 
 	if ((cdi->mask & CDC_DVD_R) == 0 || (cdi->mask & CDC_DVD_RAM) == 0)
-		printk(KERN_CONT " DVD%s%s",
-				 (cdi->mask & CDC_DVD_R) ? "" : "-R",
-				 (cdi->mask & CDC_DVD_RAM) ? "" : "/RAM");
+		pr_cont(" DVD%s%s",
+			(cdi->mask & CDC_DVD_R) ? "" : "-R",
+			(cdi->mask & CDC_DVD_RAM) ? "" : "/RAM");
 
 	if ((cdi->mask & CDC_CD_R) == 0 || (cdi->mask & CDC_CD_RW) == 0)
-		printk(KERN_CONT " CD%s%s",
-				 (cdi->mask & CDC_CD_R) ? "" : "-R",
-				 (cdi->mask & CDC_CD_RW) ? "" : "/RW");
+		pr_cont(" CD%s%s",
+			(cdi->mask & CDC_CD_R) ? "" : "-R",
+			(cdi->mask & CDC_CD_RW) ? "" : "/RW");
 
 	if ((cdi->mask & CDC_SELECT_DISC) == 0)
-		printk(KERN_CONT " changer w/%d slots", nslots);
+		pr_cont(" changer w/%d slots", nslots);
 	else
-		printk(KERN_CONT " drive");
+		pr_cont(" drive");
 
-	printk(KERN_CONT ", %dkB Cache\n",
-			 be16_to_cpup((__be16 *)&buf[8 + 12]));
+	pr_cont(", %dkB Cache\n",
+		be16_to_cpup((__be16 *)&buf[8 + 12]));
 
 	return nslots;
 }
diff --git a/drivers/ide/ide-cd_verbose.c b/drivers/ide/ide-cd_verbose.c
index d05ad08..8a93e92 100644
--- a/drivers/ide/ide-cd_verbose.c
+++ b/drivers/ide/ide-cd_verbose.c
@@ -252,23 +252,33 @@ void ide_cd_log_error(const char *name, struct request *failed_command,
 		      struct request_sense *sense)
 {
 	int i;
-	const char *s = "bad sense key!";
+	const char *s;
+	const char *prefix;
 	char buf[80];
 
 	pr_err("ATAPI device %s:\n", name);
-	if (sense->error_code == 0x70)
-		printk(KERN_CONT "  Error: ");
-	else if (sense->error_code == 0x71)
-		printk("  Deferred Error: ");
-	else if (sense->error_code == 0x7f)
-		printk(KERN_CONT "  Vendor-specific Error: ");
-	else
-		printk(KERN_CONT "  Unknown Error Type: ");
+
+	switch (sense->error_code) {
+	case 0x70:
+		prefix = "Error";
+		break;
+	case 0x71:
+		prefix = "Deferred Error";
+		break;
+	case 0x7f:
+		prefix = "Vendor-specific Error";
+		break;
+	default:
+		prefix = "Unknown Error Type";
+		break;
+	}
 
 	if (sense->sense_key < ARRAY_SIZE(sense_key_texts))
 		s = sense_key_texts[sense->sense_key];
+	else
+		s = "bad sense key!";
 
-	printk(KERN_CONT "%s -- (Sense key=0x%02x)\n", s, sense->sense_key);
+	pr_err("  %s: %s -- (Sense key=0x%02x)\n", prefix, s, sense->sense_key);
 
 	if (sense->asc == 0x40) {
 		sprintf(buf, "Diagnostic failure on component 0x%02x",
@@ -326,8 +336,8 @@ void ide_cd_log_error(const char *name, struct request *failed_command,
 
 		pr_err("  The failed \"%s\" packet command was: \n  \"", s);
 		for (i = 0; i < BLK_MAX_CDB; i++)
-			printk(KERN_CONT "%02x ", failed_command->cmd[i]);
-		printk(KERN_CONT "\"\n");
+			pr_cont("%02x ", failed_command->cmd[i]);
+		pr_cont("\"\n");
 	}
 
 	/* The SKSV bit specifies validity of the sense_key_specific
@@ -349,9 +359,9 @@ void ide_cd_log_error(const char *name, struct request *failed_command,
 		       (sense->sks[1] << 8) + sense->sks[2]);
 
 		if ((sense->sks[0] & 0x40) != 0)
-			printk(KERN_CONT " bit %d", sense->sks[0] & 0x07);
+			pr_cont(" bit %d", sense->sks[0] & 0x07);
 
-		printk(KERN_CONT "\n");
+		pr_cont("\n");
 	}
 }
 #endif
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 1d9489d..19f59e0 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -680,9 +680,9 @@ static void ide_disk_setup(ide_drive_t *drive)
 
 	/* Only print cache size when it was specified */
 	if (id[ATA_ID_BUF_SIZE])
-		printk(KERN_CONT " w/%dKiB Cache", id[ATA_ID_BUF_SIZE] / 2);
+		pr_cont(" w/%dKiB Cache", id[ATA_ID_BUF_SIZE] / 2);
 
-	printk(KERN_CONT ", CHS=%d/%d/%d\n",
+	pr_cont(", CHS=%d/%d/%d\n",
 			 drive->bios_cyl, drive->bios_head, drive->bios_sect);
 
 	/* write cache enabled? */
diff --git a/drivers/ide/ide-eh.c b/drivers/ide/ide-eh.c
index 92062f0..a7f0142 100644
--- a/drivers/ide/ide-eh.c
+++ b/drivers/ide/ide-eh.c
@@ -204,12 +204,12 @@ static void ide_reset_report_error(ide_hwif_t *hwif, u8 err)
 
 	pr_err("%s: reset: master: ", hwif->name);
 	if (err_master && err_master < 6)
-		printk(KERN_CONT "%s", err_master_vals[err_master]);
+		pr_cont("%s", err_master_vals[err_master]);
 	else
-		printk(KERN_CONT "error (0x%02x?)", err);
+		pr_cont("error (0x%02x?)", err);
 	if (err & 0x80)
-		printk(KERN_CONT "; slave: failed");
-	printk(KERN_CONT "\n");
+		pr_cont("; slave: failed");
+	pr_cont("\n");
 }
 
 /*
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index 7872af6..b7b7474 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -44,9 +44,9 @@ static void ide_dump_opcode(ide_drive_t *drive)
 
 	pr_err("ide: failed opcode was: ");
 	if (cmd == NULL)
-		printk(KERN_CONT "unknown\n");
+		pr_cont("unknown\n");
 	else
-		printk(KERN_CONT "0x%02x\n", cmd->tf.command);
+		pr_cont("0x%02x\n", cmd->tf.command);
 }
 
 u64 ide_get_lba_addr(struct ide_cmd *cmd, int lba48)
@@ -82,10 +82,10 @@ static void ide_dump_sector(ide_drive_t *drive)
 	ide_tf_readback(drive, &cmd);
 
 	if (lba48 || (tf->device & ATA_LBA))
-		printk(KERN_CONT ", LBAsect=%llu",
+		pr_cont(", LBAsect=%llu",
 			(unsigned long long)ide_get_lba_addr(&cmd, lba48));
 	else
-		printk(KERN_CONT ", CHS=%d/%d/%d", (tf->lbah << 8) + tf->lbam,
+		pr_cont(", CHS=%d/%d/%d", (tf->lbah << 8) + tf->lbam,
 			tf->device & 0xf, tf->lbal);
 }
 
@@ -93,19 +93,19 @@ static void ide_dump_ata_error(ide_drive_t *drive, u8 err)
 {
 	pr_err("{ ");
 	if (err & ATA_ABORTED)
-		printk(KERN_CONT "DriveStatusError ");
+		pr_cont("DriveStatusError ");
 	if (err & ATA_ICRC)
-		printk(KERN_CONT "%s",
+		pr_cont("%s",
 			(err & ATA_ABORTED) ? "BadCRC " : "BadSector ");
 	if (err & ATA_UNC)
-		printk(KERN_CONT "UncorrectableError ");
+		pr_cont("UncorrectableError ");
 	if (err & ATA_IDNF)
-		printk(KERN_CONT "SectorIdNotFound ");
+		pr_cont("SectorIdNotFound ");
 	if (err & ATA_TRK0NF)
-		printk(KERN_CONT "TrackZeroNotFound ");
+		pr_cont("TrackZeroNotFound ");
 	if (err & ATA_AMNF)
-		printk(KERN_CONT "AddrMarkNotFound ");
-	printk(KERN_CONT "}");
+		pr_cont("AddrMarkNotFound ");
+	pr_cont("}");
 	if ((err & (ATA_BBK | ATA_ABORTED)) == ATA_BBK ||
 	    (err & (ATA_UNC | ATA_IDNF | ATA_AMNF))) {
 		struct request *rq = drive->hwif->rq;
@@ -113,27 +113,27 @@ static void ide_dump_ata_error(ide_drive_t *drive, u8 err)
 		ide_dump_sector(drive);
 
 		if (rq)
-			printk(KERN_CONT ", sector=%llu",
-			       (unsigned long long)rq->sector);
+			pr_cont(", sector=%llu",
+				(unsigned long long)rq->sector);
 	}
-	printk(KERN_CONT "\n");
+	pr_cont("\n");
 }
 
 static void ide_dump_atapi_error(ide_drive_t *drive, u8 err)
 {
 	pr_err("{ ");
 	if (err & ATAPI_ILI)
-		printk(KERN_CONT "IllegalLengthIndication ");
+		pr_cont("IllegalLengthIndication ");
 	if (err & ATAPI_EOM)
-		printk(KERN_CONT "EndOfMedia ");
+		pr_cont("EndOfMedia ");
 	if (err & ATA_ABORTED)
-		printk(KERN_CONT "AbortedCommand ");
+		pr_cont("AbortedCommand ");
 	if (err & ATA_MCR)
-		printk(KERN_CONT "MediaChangeRequested ");
+		pr_cont("MediaChangeRequested ");
 	if (err & ATAPI_LFS)
-		printk(KERN_CONT "LastFailedSense=0x%02x ",
+		pr_cont("LastFailedSense=0x%02x ",
 			(err & ATAPI_LFS) >> 4);
-	printk(KERN_CONT "}\n");
+	pr_cont("}\n");
 }
 
 /**
@@ -153,24 +153,24 @@ u8 ide_dump_status(ide_drive_t *drive, const char *msg, u8 stat)
 
 	pr_err("%s: %s: status=0x%02x { ", drive->name, msg, stat);
 	if (stat & ATA_BUSY)
-		printk(KERN_CONT "Busy ");
+		pr_cont("Busy ");
 	else {
 		if (stat & ATA_DRDY)
-			printk(KERN_CONT "DriveReady ");
+			pr_cont("DriveReady ");
 		if (stat & ATA_DF)
-			printk(KERN_CONT "DeviceFault ");
+			pr_cont("DeviceFault ");
 		if (stat & ATA_DSC)
-			printk(KERN_CONT "SeekComplete ");
+			pr_cont("SeekComplete ");
 		if (stat & ATA_DRQ)
-			printk(KERN_CONT "DataRequest ");
+			pr_cont("DataRequest ");
 		if (stat & ATA_CORR)
-			printk(KERN_CONT "CorrectedError ");
+			pr_cont("CorrectedError ");
 		if (stat & ATA_IDX)
-			printk(KERN_CONT "Index ");
+			pr_cont("Index ");
 		if (stat & ATA_ERR)
-			printk(KERN_CONT "Error ");
+			pr_cont("Error ");
 	}
-	printk(KERN_CONT "}\n");
+	pr_cont("}\n");
 	if ((stat & (ATA_BUSY | ATA_ERR)) == ATA_ERR) {
 		err = ide_read_error(drive);
 		pr_err("%s: %s: error=0x%02x ", drive->name, msg, err);
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 3b32d25..ceaeeb6 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -133,9 +133,9 @@ static void ide_classify_atapi_dev(ide_drive_t *drive)
 			if (!strstr(m, "oppy") &&
 			    !strstr(m, "poyp") &&
 			    !strstr(m, "ZIP"))
-				printk(KERN_CONT "cdrom or floppy?, assuming ");
+				pr_cont("cdrom or floppy?, assuming ");
 			if (drive->media != ide_cdrom) {
-				printk(KERN_CONT "FLOPPY");
+				pr_cont("FLOPPY");
 				drive->dev_flags |= IDE_DFLAG_REMOVABLE;
 				break;
 			}
@@ -147,26 +147,26 @@ static void ide_classify_atapi_dev(ide_drive_t *drive)
 #ifdef CONFIG_PPC
 		/* kludge for Apple PowerBook internal zip */
 		if (!strstr(m, "CD-ROM") && strstr(m, "ZIP")) {
-			printk(KERN_CONT "FLOPPY");
+			pr_cont("FLOPPY");
 			type = ide_floppy;
 			break;
 		}
 #endif
-		printk(KERN_CONT "CD/DVD-ROM");
+		pr_cont("CD/DVD-ROM");
 		break;
 	case ide_tape:
-		printk(KERN_CONT "TAPE");
+		pr_cont("TAPE");
 		break;
 	case ide_optical:
-		printk(KERN_CONT "OPTICAL");
+		pr_cont("OPTICAL");
 		drive->dev_flags |= IDE_DFLAG_REMOVABLE;
 		break;
 	default:
-		printk(KERN_CONT "UNKNOWN (type %d)", type);
+		pr_cont("UNKNOWN (type %d)", type);
 		break;
 	}
 
-	printk(KERN_CONT " drive\n");
+	pr_cont(" drive\n");
 	drive->media = type;
 	/* an ATAPI device ignores DRDY */
 	drive->ready_stat = 0;
@@ -856,8 +856,8 @@ static int init_irq (ide_hwif_t *hwif)
 		io_ports->data_addr, hwif->irq);
 #endif /* __mc68000__ */
 	if (hwif->host->host_flags & IDE_HFLAG_SERIALIZE)
-		printk(KERN_CONT " (serialized)");
-	printk(KERN_CONT "\n");
+		pr_cont(" (serialized)");
+	pr_cont("\n");
 
 	return 0;
 out_up:
diff --git a/drivers/ide/it821x.c b/drivers/ide/it821x.c
index 1bac7cd..d2b9deb 100644
--- a/drivers/ide/it821x.c
+++ b/drivers/ide/it821x.c
@@ -471,8 +471,8 @@ static void it821x_quirkproc(ide_drive_t *drive)
 				drive->name, id[147] ? "Bootable " : "",
 				id[ATA_ID_CSFO]);
 			if (id[ATA_ID_CSFO] != 1)
-				printk(KERN_CONT "(%dK stripe)", id[146]);
-			printk(KERN_CONT ".\n");
+				pr_cont("(%dK stripe)", id[146]);
+			pr_cont(".\n");
 		} else {
 			/* Non RAID volume. Fixups to stop the core code
 			   doing unsupported things */
diff --git a/drivers/ide/trm290.c b/drivers/ide/trm290.c
index 8f710e8..f79d39f 100644
--- a/drivers/ide/trm290.c
+++ b/drivers/ide/trm290.c
@@ -244,7 +244,7 @@ static void __devinit init_hwif_trm290(ide_hwif_t *hwif)
 		cfg_base = 0x3df0;
 		pr_info(DRV_NAME " %s: using default", pci_name(dev));
 	}
-	printk(KERN_CONT " config base at 0x%04x\n", cfg_base);
+	pr_cont(" config base at 0x%04x\n", cfg_base);
 	hwif->config_data = cfg_base;
 	hwif->dma_base = (cfg_base + 4) ^ (hwif->channel ? 0x80 : 0);
 
-- 
1.6.3.1.10.g659a0.dirty

