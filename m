Return-Path: <linux-kernel-owner+w=401wt.eu-S1755584AbZEWHnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbZEWHnb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 03:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbZEWHmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 03:42:47 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4472 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbZEWHml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 03:42:41 -0400
From: Joe Perches <joe@perches.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, Tejun Heo <tj@kernel.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] drivers/ide/ide-core: Convert printk(KERN_<level> to pr_<level>
Date: Sat, 23 May 2009 00:41:14 -0700
Message-Id: <ad29856101ea7fec73e2df4fd09708c55afb989a.1243062772.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1243062772.git.joe@perches.com>
References: <cover.1243062772.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/ide/ide-acpi.c     |   18 +++++------
 drivers/ide/ide-atapi.c    |    6 ++--
 drivers/ide/ide-eh.c       |    8 ++--
 drivers/ide/ide-legacy.c   |    8 ++--
 drivers/ide/ide-lib.c      |   64 ++++++++++++++++++------------------
 drivers/ide/ide-probe.c    |   36 ++++++++++----------
 drivers/ide/ide-proc.c     |   17 +++++-----
 drivers/ide/ide-scan-pci.c |    4 +-
 drivers/ide/ide.c          |    4 +-
 drivers/ide/setup-pci.c    |   76 ++++++++++++++++++++++----------------------
 10 files changed, 119 insertions(+), 122 deletions(-)

diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index 77f79d2..f323a60 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -67,7 +67,7 @@ static bool ide_noacpi_psx;
 static int no_acpi_psx(const struct dmi_system_id *id)
 {
 	ide_noacpi_psx = true;
-	printk(KERN_NOTICE"%s detected - disable ACPI _PSx.\n", id->ident);
+	pr_notice("%s detected - disable ACPI _PSx.\n", id->ident);
 	return 0;
 }
 
@@ -262,8 +262,7 @@ static int do_drive_get_GTF(ide_drive_t *drive,
 
 	if (!out_obj->buffer.length || !out_obj->buffer.pointer ||
 	    out_obj->buffer.length % REGS_PER_GTF) {
-		printk(KERN_ERR
-		       "%s: unexpected GTF length (%d) or addr (0x%p)\n",
+		pr_err("%s: unexpected GTF length (%d) or addr (0x%p)\n",
 		       __func__, out_obj->buffer.length,
 		       out_obj->buffer.pointer);
 		err = -ENOENT;
@@ -324,8 +323,8 @@ static int do_drive_set_taskfiles(ide_drive_t *drive,
 
 		err = ide_no_data_taskfile(drive, &cmd);
 		if (err) {
-			printk(KERN_ERR "%s: ide_no_data_taskfile failed: %u\n",
-					__func__, err);
+			pr_err("%s: ide_no_data_taskfile failed: %u\n",
+			       __func__, err);
 			rc = err;
 		}
 	}
@@ -436,11 +435,10 @@ void ide_acpi_get_timing(ide_hwif_t *hwif)
 	if (!out_obj->buffer.length || !out_obj->buffer.pointer ||
 	    out_obj->buffer.length != sizeof(struct GTM_buffer)) {
 		kfree(output.pointer);
-		printk(KERN_ERR
-			"%s: unexpected _GTM length (0x%x)[should be 0x%zx] or "
-			"addr (0x%p)\n",
-			__func__, out_obj->buffer.length,
-			sizeof(struct GTM_buffer), out_obj->buffer.pointer);
+		pr_err("%s: unexpected _GTM length (0x%x)[should be 0x%zx] or "
+		       "addr (0x%p)\n",
+		       __func__, out_obj->buffer.length,
+		       sizeof(struct GTM_buffer), out_obj->buffer.pointer);
 		return;
 	}
 
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index fc5cfb6..46cf46e 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -12,7 +12,7 @@
 
 #ifdef DEBUG
 #define debug_log(fmt, args...) \
-	printk(KERN_INFO "ide: " fmt, ## args)
+	pr_info("ide: " fmt, ## args)
 #else
 #define debug_log(fmt, args...) do {} while (0)
 #endif
@@ -297,8 +297,8 @@ int ide_cd_expiry(ide_drive_t *drive)
 		break;
 	default:
 		if (!(rq->cmd_flags & REQ_QUIET))
-			printk(KERN_INFO "cmd 0x%x timed out\n",
-					 rq->cmd[0]);
+			pr_info("cmd 0x%x timed out\n",
+				rq->cmd[0]);
 		wait = 0;
 		break;
 	}
diff --git a/drivers/ide/ide-eh.c b/drivers/ide/ide-eh.c
index 75019ce..b1d8b85 100644
--- a/drivers/ide/ide-eh.c
+++ b/drivers/ide/ide-eh.c
@@ -204,12 +204,12 @@ static void ide_reset_report_error(ide_hwif_t *hwif, u8 err)
 
 	dev_err(&hwif->gendev, "reset: master: ");
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
diff --git a/drivers/ide/ide-legacy.c b/drivers/ide/ide-legacy.c
index b9654a7..2979b4e 100644
--- a/drivers/ide/ide-legacy.c
+++ b/drivers/ide/ide-legacy.c
@@ -19,14 +19,14 @@ static void ide_legacy_init_one(struct ide_hw **hws, struct ide_hw *hw,
 	}
 
 	if (!request_region(base, 8, d->name)) {
-		printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
-				d->name, base, base + 7);
+		pr_err("%s: I/O resource 0x%lX-0x%lX not free.\n",
+		       d->name, base, base + 7);
 		return;
 	}
 
 	if (!request_region(ctl, 1, d->name)) {
-		printk(KERN_ERR "%s: I/O resource 0x%lX not free.\n",
-				d->name, ctl);
+		pr_err("%s: I/O resource 0x%lX not free.\n",
+		       d->name, ctl);
 		release_region(base, 8);
 		return;
 	}
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index f7432c5..363be92 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -42,11 +42,11 @@ static void ide_dump_opcode(ide_drive_t *drive)
 	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE)
 		cmd = rq->special;
 
-	printk(KERN_ERR "ide: failed opcode was: ");
+	pr_err("ide: failed opcode was: ");
 	if (cmd == NULL)
-		printk(KERN_CONT "unknown\n");
+		pr_cont("unknown\n");
 	else
-		printk(KERN_CONT "0x%02x\n", cmd->tf.command);
+		pr_cont("0x%02x\n", cmd->tf.command);
 }
 
 u64 ide_get_lba_addr(struct ide_cmd *cmd, int lba48)
@@ -82,30 +82,30 @@ static void ide_dump_sector(ide_drive_t *drive)
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
 
 static void ide_dump_ata_error(ide_drive_t *drive, u8 err)
 {
-	printk(KERN_ERR "{ ");
+	pr_err("{ ");
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
-			       (unsigned long long)blk_rq_pos(rq));
+			pr_cont(", sector=%llu",
+				(unsigned long long)blk_rq_pos(rq));
 	}
-	printk(KERN_CONT "\n");
+	pr_cont("\n");
 }
 
 static void ide_dump_atapi_error(ide_drive_t *drive, u8 err)
 {
-	printk(KERN_ERR "{ ");
+	pr_err("{ ");
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
 
 	dev_err(&drive->gendev, "%s: status=0x%02x { ", msg, stat);
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
 		dev_err(&drive->gendev, "%s: error=0x%02x ", msg, err);
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 5672c27..c4b44e2 100644
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
@@ -476,7 +476,7 @@ static u8 probe_for_drive(ide_drive_t *drive)
 
 	drive->id = kzalloc(SECTOR_SIZE, GFP_KERNEL);
 	if (drive->id == NULL) {
-		printk(KERN_ERR "ide: out of memory for id data.\n");
+		pr_err("ide: out of memory for id data.\n");
 		return 0;
 	}
 
@@ -559,8 +559,8 @@ static int ide_register_port(ide_hwif_t *hwif)
 
 	ret = device_register(&hwif->gendev);
 	if (ret < 0) {
-		printk(KERN_WARNING "IDE: %s: device_register error: %d\n",
-			__func__, ret);
+		pr_warning("IDE: %s: device_register error: %d\n",
+			   __func__, ret);
 		goto out;
 	}
 
@@ -674,7 +674,7 @@ void ide_undecoded_slave(ide_drive_t *dev1)
 		return;
 
 	/* Appears to be an IDE flash adapter with decode bugs */
-	printk(KERN_WARNING "ide-probe: ignoring undecoded slave\n");
+	pr_warning("ide-probe: ignoring undecoded slave\n");
 
 	dev1->dev_flags &= ~IDE_DFLAG_PRESENT;
 }
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
@@ -1007,8 +1007,8 @@ static void hwif_register_devices(ide_hwif_t *hwif)
 
 		ret = device_register(dev);
 		if (ret < 0)
-			printk(KERN_WARNING "IDE: %s: device_register error: "
-					    "%d\n", __func__, ret);
+			pr_warning("IDE: %s: device_register error: "
+				   "%d\n", __func__, ret);
 	}
 }
 
@@ -1292,8 +1292,8 @@ struct ide_host *ide_host_alloc(const struct ide_port_info *d,
 
 		idx = ide_find_port_slot(d);
 		if (idx < 0) {
-			printk(KERN_ERR "%s: no free slot for interface\n",
-					d ? d->name : "ide");
+			pr_err("%s: no free slot for interface\n",
+			       d ? d->name : "ide");
 			kfree(hwif);
 			continue;
 		}
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index 3242698..23b9d6a 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -241,8 +241,8 @@ static void proc_ide_settings_warn(void)
 	if (warned)
 		return;
 
-	printk(KERN_WARNING "Warning: /proc/ide/hd?/settings interface is "
-			    "obsolete, and will be removed soon!\n");
+	pr_warning("Warning: /proc/ide/hd?/settings interface is "
+		   "obsolete, and will be removed soon!\n");
 	warned = 1;
 }
 
@@ -464,15 +464,14 @@ static int ide_replace_subdriver(ide_drive_t *drive, const char *driver)
 	strlcpy(drive->driver_req, driver, sizeof(drive->driver_req));
 	err = device_attach(dev);
 	if (err < 0)
-		printk(KERN_WARNING "IDE: %s: device_attach error: %d\n",
-			__func__, err);
+		pr_warning("IDE: %s: device_attach error: %d\n",
+			   __func__, err);
 	drive->driver_req[0] = 0;
 	if (dev->driver == NULL) {
 		err = device_attach(dev);
 		if (err < 0)
-			printk(KERN_WARNING
-				"IDE: %s: device_attach(2) error: %d\n",
-				__func__, err);
+			pr_warning("IDE: %s: device_attach(2) error: %d\n",
+				   __func__, err);
 	}
 	if (dev->driver && !strcmp(dev->driver->name, driver))
 		ret = 0;
@@ -666,8 +665,8 @@ static int ide_drivers_show(struct seq_file *s, void *p)
 
 	err = bus_for_each_drv(&ide_bus_type, NULL, s, proc_print_driver);
 	if (err < 0)
-		printk(KERN_WARNING "IDE: %s: bus_for_each_drv error: %d\n",
-			__func__, err);
+		pr_warning("IDE: %s: bus_for_each_drv error: %d\n",
+			   __func__, err);
 	return 0;
 }
 
diff --git a/drivers/ide/ide-scan-pci.c b/drivers/ide/ide-scan-pci.c
index 0e79eff..84e791a 100644
--- a/drivers/ide/ide-scan-pci.c
+++ b/drivers/ide/ide-scan-pci.c
@@ -101,8 +101,8 @@ static int __init ide_scan_pcibus(void)
 		d = list_entry(l, struct pci_driver, node);
 		if (__pci_register_driver(d, d->driver.owner,
 					  d->driver.mod_name))
-			printk(KERN_ERR "%s: failed to register %s driver\n",
-					__func__, d->driver.mod_name);
+			pr_err("%s: failed to register %s driver\n",
+			       __func__, d->driver.mod_name);
 	}
 
 	return 0;
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index fb2b180..ab8ffcf 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -355,11 +355,11 @@ static int __init ide_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO "Uniform Multi-Platform E-IDE driver\n");
+	pr_info("Uniform Multi-Platform E-IDE driver\n");
 
 	ret = bus_register(&ide_bus_type);
 	if (ret < 0) {
-		printk(KERN_WARNING "IDE: bus_register error: %d\n", ret);
+		pr_warning("IDE: bus_register error: %d\n", ret);
 		return ret;
 	}
 
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index 3892351..f139cf3 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -39,18 +39,18 @@ static int ide_setup_pci_baseregs(struct pci_dev *dev, const char *name)
 	if (pci_read_config_byte(dev, PCI_CLASS_PROG, &progif) ||
 			 (progif & 5) != 5) {
 		if ((progif & 0xa) != 0xa) {
-			printk(KERN_INFO "%s %s: device not capable of full "
+			pr_info("%s %s: device not capable of full "
 				"native PCI mode\n", name, pci_name(dev));
 			return -EOPNOTSUPP;
 		}
-		printk(KERN_INFO "%s %s: placing both ports into native PCI "
+		pr_info("%s %s: placing both ports into native PCI "
 			"mode\n", name, pci_name(dev));
 		(void) pci_write_config_byte(dev, PCI_CLASS_PROG, progif|5);
 		if (pci_read_config_byte(dev, PCI_CLASS_PROG, &progif) ||
 		    (progif & 5) != 5) {
-			printk(KERN_ERR "%s %s: rewrite of PROGIF failed, "
-				"wanted 0x%04x, got 0x%04x\n",
-				name, pci_name(dev), progif | 5, progif);
+			pr_err("%s %s: rewrite of PROGIF failed, "
+			       "wanted 0x%04x, got 0x%04x\n",
+			       name, pci_name(dev), progif | 5, progif);
 			return -EOPNOTSUPP;
 		}
 	}
@@ -92,8 +92,8 @@ unsigned long ide_pci_dma_base(ide_hwif_t *hwif, const struct ide_port_info *d)
 		dma_base = pci_resource_start(dev, baridx);
 
 		if (dma_base == 0) {
-			printk(KERN_ERR "%s %s: DMA base is invalid\n",
-				d->name, pci_name(dev));
+			pr_err("%s %s: DMA base is invalid\n",
+			       d->name, pci_name(dev));
 			return 0;
 		}
 	}
@@ -115,7 +115,7 @@ int ide_pci_check_simplex(ide_hwif_t *hwif, const struct ide_port_info *d)
 
 	if (d->host_flags & IDE_HFLAG_CLEAR_SIMPLEX) {
 		if (ide_pci_clear_simplex(hwif->dma_base, d->name))
-			printk(KERN_INFO "%s %s: simplex device: DMA forced\n",
+			pr_info("%s %s: simplex device: DMA forced\n",
 				d->name, pci_name(dev));
 		goto out;
 	}
@@ -132,7 +132,7 @@ int ide_pci_check_simplex(ide_hwif_t *hwif, const struct ide_port_info *d)
 	 */
 	dma_stat = hwif->dma_ops->dma_sff_read_status(hwif);
 	if ((dma_stat & 0x80) && hwif->mate && hwif->mate->dma_base) {
-		printk(KERN_INFO "%s %s: simplex device: DMA disabled\n",
+		pr_info("%s %s: simplex device: DMA disabled\n",
 			d->name, pci_name(dev));
 		return -1;
 	}
@@ -155,8 +155,8 @@ int ide_pci_set_master(struct pci_dev *dev, const char *name)
 
 		if (pci_read_config_word(dev, PCI_COMMAND, &pcicmd) ||
 		    (pcicmd & PCI_COMMAND_MASTER) == 0) {
-			printk(KERN_ERR "%s %s: error updating PCICMD\n",
-				name, pci_name(dev));
+			pr_err("%s %s: error updating PCICMD\n",
+			       name, pci_name(dev));
 			return -EIO;
 		}
 	}
@@ -168,7 +168,7 @@ EXPORT_SYMBOL_GPL(ide_pci_set_master);
 
 void ide_setup_pci_noise(struct pci_dev *dev, const struct ide_port_info *d)
 {
-	printk(KERN_INFO "%s %s: IDE controller (0x%04x:0x%04x rev 0x%02x)\n",
+	pr_info("%s %s: IDE controller (0x%04x:0x%04x rev 0x%02x)\n",
 		d->name, pci_name(dev),
 		dev->vendor, dev->device, dev->revision);
 }
@@ -195,12 +195,12 @@ static int ide_pci_enable(struct pci_dev *dev, const struct ide_port_info *d)
 	if (pci_enable_device(dev)) {
 		ret = pci_enable_device_io(dev);
 		if (ret < 0) {
-			printk(KERN_WARNING "%s %s: couldn't enable device\n",
-				d->name, pci_name(dev));
+			pr_warning("%s %s: couldn't enable device\n",
+				   d->name, pci_name(dev));
 			goto out;
 		}
-		printk(KERN_WARNING "%s %s: BIOS configuration fixed\n",
-			d->name, pci_name(dev));
+		pr_warning("%s %s: BIOS configuration fixed\n",
+			   d->name, pci_name(dev));
 	}
 
 	/*
@@ -210,8 +210,8 @@ static int ide_pci_enable(struct pci_dev *dev, const struct ide_port_info *d)
 	 */
 	ret = pci_set_dma_mask(dev, DMA_BIT_MASK(32));
 	if (ret < 0) {
-		printk(KERN_ERR "%s %s: can't set DMA mask\n",
-			d->name, pci_name(dev));
+		pr_err("%s %s: can't set DMA mask\n",
+		       d->name, pci_name(dev));
 		goto out;
 	}
 
@@ -229,8 +229,8 @@ static int ide_pci_enable(struct pci_dev *dev, const struct ide_port_info *d)
 
 	ret = pci_request_selected_regions(dev, bars, d->name);
 	if (ret < 0)
-		printk(KERN_ERR "%s %s: can't reserve resources\n",
-			d->name, pci_name(dev));
+		pr_err("%s %s: can't reserve resources\n",
+		       d->name, pci_name(dev));
 out:
 	return ret;
 }
@@ -256,18 +256,18 @@ static int ide_pci_configure(struct pci_dev *dev, const struct ide_port_info *d)
 	 */
 	if (ide_setup_pci_baseregs(dev, d->name) ||
 	    pci_write_config_word(dev, PCI_COMMAND, pcicmd | PCI_COMMAND_IO)) {
-		printk(KERN_INFO "%s %s: device disabled (BIOS)\n",
+		pr_info("%s %s: device disabled (BIOS)\n",
 			d->name, pci_name(dev));
 		return -ENODEV;
 	}
 	if (pci_read_config_word(dev, PCI_COMMAND, &pcicmd)) {
-		printk(KERN_ERR "%s %s: error accessing PCI regs\n",
-			d->name, pci_name(dev));
+		pr_err("%s %s: error accessing PCI regs\n",
+		       d->name, pci_name(dev));
 		return -EIO;
 	}
 	if (!(pcicmd & PCI_COMMAND_IO)) {
-		printk(KERN_ERR "%s %s: unable to enable IDE controller\n",
-			d->name, pci_name(dev));
+		pr_err("%s %s: unable to enable IDE controller\n",
+		       d->name, pci_name(dev));
 		return -ENXIO;
 	}
 	return 0;
@@ -322,9 +322,9 @@ static int ide_hw_configure(struct pci_dev *dev, const struct ide_port_info *d,
 	if ((d->host_flags & IDE_HFLAG_ISA_PORTS) == 0) {
 		if (ide_pci_check_iomem(dev, d, 2 * port) ||
 		    ide_pci_check_iomem(dev, d, 2 * port + 1)) {
-			printk(KERN_ERR "%s %s: I/O baseregs (BIOS) are "
-				"reported as MEM for port %d!\n",
-				d->name, pci_name(dev), port);
+			pr_err("%s %s: I/O baseregs (BIOS) are "
+			       "reported as MEM for port %d!\n",
+			       d->name, pci_name(dev), port);
 			return -EINVAL;
 		}
 
@@ -337,8 +337,8 @@ static int ide_hw_configure(struct pci_dev *dev, const struct ide_port_info *d,
 	}
 
 	if (!base || !ctl) {
-		printk(KERN_ERR "%s %s: bad PCI BARs for port %d, skipping\n",
-			d->name, pci_name(dev), port);
+		pr_err("%s %s: bad PCI BARs for port %d, skipping\n",
+		       d->name, pci_name(dev), port);
 		return -EINVAL;
 	}
 
@@ -426,15 +426,15 @@ static int ide_setup_pci_controller(struct pci_dev *dev,
 
 	ret = pci_read_config_word(dev, PCI_COMMAND, &pcicmd);
 	if (ret < 0) {
-		printk(KERN_ERR "%s %s: error accessing PCI regs\n",
-			d->name, pci_name(dev));
+		pr_err("%s %s: error accessing PCI regs\n",
+		       d->name, pci_name(dev));
 		goto out;
 	}
 	if (!(pcicmd & PCI_COMMAND_IO)) {	/* is device disabled? */
 		ret = ide_pci_configure(dev, d);
 		if (ret < 0)
 			goto out;
-		printk(KERN_INFO "%s %s: device enabled (Linux)\n",
+		pr_info("%s %s: device enabled (Linux)\n",
 			d->name, pci_name(dev));
 	}
 
@@ -473,7 +473,7 @@ void ide_pci_setup_ports(struct pci_dev *dev, const struct ide_port_info *d,
 
 		if (e->reg && (pci_read_config_byte(dev, e->reg, &tmp) ||
 		    (tmp & e->mask) != e->val)) {
-			printk(KERN_INFO "%s %s: IDE port disabled\n",
+			pr_info("%s %s: IDE port disabled\n",
 				d->name, pci_name(dev));
 			continue;	/* port not enabled */
 		}
@@ -519,14 +519,14 @@ static int do_ide_setup_pci_device(struct pci_dev *dev,
 
 	if (ide_pci_is_in_compatibility_mode(dev)) {
 		if (noisy)
-			printk(KERN_INFO "%s %s: not 100%% native mode: will "
+			pr_info("%s %s: not 100%% native mode: will "
 				"probe irqs later\n", d->name, pci_name(dev));
 		pciirq = 0;
 	} else if (!pciirq && noisy) {
-		printk(KERN_WARNING "%s %s: bad irq (%d): will probe later\n",
-			d->name, pci_name(dev), pciirq);
+		pr_warning("%s %s: bad irq (%d): will probe later\n",
+			   d->name, pci_name(dev), pciirq);
 	} else if (noisy) {
-		printk(KERN_INFO "%s %s: 100%% native mode on irq %d\n",
+		pr_info("%s %s: 100%% native mode on irq %d\n",
 			d->name, pci_name(dev), pciirq);
 	}
 
-- 
1.6.3.1.10.g659a0.dirty

