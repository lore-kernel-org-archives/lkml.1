Return-Path: <linux-kernel-owner+w=401wt.eu-S932452AbYBZWZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452AbYBZWZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 17:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764936AbYBZWXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 17:23:42 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:23868 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764347AbYBZWXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:23:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=hGd/oiKGVxkHiTmntbDDTiiJjgdewRFQ6fCWmwoYAgxIdW2mm3os64TygCEN1rXci5qZVFFADXt5+5WkmuGqjYaDnND3jBOal4+5Eq31wroHVzV9WHG0rIp2ZH++QWKEm5Wqw/ab2PyLxTNgsOMLkIzdImqodJRrHHekiPykmAY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE fixes
Date: Tue, 26 Feb 2008 21:57:58 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802262157.58493.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 Documentation/feature-removal-schedule.txt |   10 +++++
 Documentation/ide.txt                      |   49 --------------------------
 drivers/ide/ide-cd.c                       |   30 +++++++---------
 drivers/ide/ide-disk.c                     |    5 ++-
 drivers/ide/ide-dma.c                      |   52 ++-------------------------
 drivers/ide/ide-probe.c                    |    3 +-
 drivers/ide/ide-tape.c                     |    5 +++
 drivers/ide/ide.c                          |   20 +++-------
 drivers/ide/legacy/qd65xx.c                |   43 +----------------------
 drivers/ide/pci/cmd640.c                   |    3 +-
 drivers/ide/pci/hpt366.c                   |   12 ++++---
 11 files changed, 54 insertions(+), 178 deletions(-)


Andreas Schwab (1):
      ide-cd: fix CD/DVD burning

Bartlomiej Zolnierkiewicz (9):
      ide: remove redundant comment from ide_unregister()
      ide: skip probing port if "hdx=noprobe" was used for both devices on it
      qd65xx: fix setup of QD6580 Control register
      ide-cd: fix 'ireason' handling for REQ_TYPE_ATA_PC requests
      ide: fix sparse warning about shadowing 'flags' symbol
      ide-disk: add missing printk() KERN_* levels
      qd65xx: remove commented out code
      ide: remove ide-tape documentation from Documentation/ide.txt
      ide: remove stale comments from ide-dma.c (take 2)

Borislav Petkov (2):
      ide-cd: Enable audio play quirk for Optiarc DVD RW AD-5200A drive
      ide-tape: schedule driver for removal after 6 months

Sam Ravnborg (1):
      hpt366: fix section mismatch warnings


diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 4d3aa51..ba899ff 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -172,6 +172,16 @@ Who:	Len Brown <len.brown@intel.com>
 
 ---------------------------
 
+What:	ide-tape driver
+When:	July 2008
+Files:	drivers/ide/ide-tape.c
+Why:	This driver might not have any users anymore and maintaining it for no
+	reason is an effort no one wants to make.
+Who:	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Borislav Petkov
+	<petkovbb@googlemail.com>
+
+---------------------------
+
 What: libata spindown skipping and warning
 When: Dec 2008
 Why:  Some halt(8) implementations synchronize caches for and spin
diff --git a/Documentation/ide.txt b/Documentation/ide.txt
index 94e2e3b..bcd7cd1 100644
--- a/Documentation/ide.txt
+++ b/Documentation/ide.txt
@@ -258,8 +258,6 @@ Summary of ide driver parameters for kernel command line
 			  As for VLB, it is safest to not specify it.
 			  Bigger values are safer than smaller ones.
 
- "idex=noprobe"		: do not attempt to access/use this interface
- 
  "idex=base"		: probe for an interface at the addr specified,
 			  where "base" is usually 0x1f0 or 0x170
 			  and "ctl" is assumed to be "base"+0x206
@@ -309,53 +307,6 @@ are detected automatically).
 
 ================================================================================
 
-IDE ATAPI streaming tape driver
--------------------------------
-
-This driver is a part of the Linux ide driver and works in co-operation
-with linux/drivers/block/ide.c.
-
-The driver, in co-operation with ide.c, basically traverses the
-request-list for the block device interface. The character device
-interface, on the other hand, creates new requests, adds them
-to the request-list of the block device, and waits for their completion.
-
-Pipelined operation mode is now supported on both reads and writes.
-
-The block device major and minor numbers are determined from the
-tape's relative position in the ide interfaces, as explained in ide.c.
-
-The character device interface consists of the following devices:
-
- ht0		major 37, minor 0	first  IDE tape, rewind on close.
- ht1		major 37, minor 1	second IDE tape, rewind on close.
- ...
- nht0		major 37, minor 128	first  IDE tape, no rewind on close.
- nht1		major 37, minor 129	second IDE tape, no rewind on close.
- ...
-
-Run /dev/MAKEDEV to create the above entries.
-
-The general magnetic tape commands compatible interface, as defined by
-include/linux/mtio.h, is accessible through the character device.
-
-General ide driver configuration options, such as the interrupt-unmask
-flag, can be configured by issuing an ioctl to the block device interface,
-as any other ide device.
-
-Our own ide-tape ioctl's can be issued to either the block device or
-the character device interface.
-
-Maximal throughput with minimal bus load will usually be achieved in the
-following scenario:
-
-	1.	ide-tape is operating in the pipelined operation mode.
-	2.	No buffering is performed by the user backup program.
-
-
-
-================================================================================
-
 Some Terminology
 ----------------
 IDE = Integrated Drive Electronics, meaning that each drive has a built-in
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 310e497..c8d0e87 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -670,8 +670,8 @@ static void cdrom_buffer_sectors (ide_drive_t *drive, unsigned long sector,
  * and attempt to recover if there are problems.  Returns  0 if everything's
  * ok; nonzero if the request has been terminated.
  */
-static
-int ide_cd_check_ireason(ide_drive_t *drive, int len, int ireason, int rw)
+static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
+				int len, int ireason, int rw)
 {
 	/*
 	 * ireason == 0: the drive wants to receive data from us
@@ -701,6 +701,9 @@ int ide_cd_check_ireason(ide_drive_t *drive, int len, int ireason, int rw)
 				drive->name, __FUNCTION__, ireason);
 	}
 
+	if (rq->cmd_type == REQ_TYPE_ATA_PC)
+		rq->cmd_flags |= REQ_FAILED;
+
 	cdrom_end_request(drive, 0);
 	return -1;
 }
@@ -1071,11 +1074,11 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	/*
 	 * check which way to transfer data
 	 */
-	if (blk_fs_request(rq) || blk_pc_request(rq)) {
-		if (ide_cd_check_ireason(drive, len, ireason, write))
-			return ide_stopped;
+	if (ide_cd_check_ireason(drive, rq, len, ireason, write))
+		return ide_stopped;
 
-		if (blk_fs_request(rq) && write == 0) {
+	if (blk_fs_request(rq)) {
+		if (write == 0) {
 			int nskip;
 
 			if (ide_cd_check_transfer_size(drive, len)) {
@@ -1101,16 +1104,9 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	if (ireason == 0) {
 		write = 1;
 		xferfunc = HWIF(drive)->atapi_output_bytes;
-	} else if (ireason == 2 || (ireason == 1 &&
-		   (blk_fs_request(rq) || blk_pc_request(rq)))) {
+	} else {
 		write = 0;
 		xferfunc = HWIF(drive)->atapi_input_bytes;
-	} else {
-		printk(KERN_ERR "%s: %s: The drive "
-				"appears confused (ireason = 0x%02x). "
-				"Trying to recover by ending request.\n",
-				drive->name, __FUNCTION__, ireason);
-		goto end_request;
 	}
 
 	/*
@@ -1182,11 +1178,10 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 			else
 				rq->data += blen;
 		}
+		if (!write && blk_sense_request(rq))
+			rq->sense_len += blen;
 	}
 
-	if (write && blk_sense_request(rq))
-		rq->sense_len += thislen;
-
 	/*
 	 * pad, if necessary
 	 */
@@ -1931,6 +1926,7 @@ static const struct cd_list_entry ide_cd_quirks_list[] = {
 	{ "MATSHITADVD-ROM SR-8186", NULL,   IDE_CD_FLAG_PLAY_AUDIO_OK	    },
 	{ "MATSHITADVD-ROM SR-8176", NULL,   IDE_CD_FLAG_PLAY_AUDIO_OK	    },
 	{ "MATSHITADVD-ROM SR-8174", NULL,   IDE_CD_FLAG_PLAY_AUDIO_OK	    },
+	{ "Optiarc DVD RW AD-5200A", NULL,   IDE_CD_FLAG_PLAY_AUDIO_OK      },
 	{ NULL, NULL, 0 }
 };
 
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 8f5bed4..39501d1 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -867,7 +867,7 @@ static void idedisk_setup (ide_drive_t *drive)
 
 	/* Only print cache size when it was specified */
 	if (id->buf_size)
-		printk (" w/%dKiB Cache", id->buf_size/2);
+		printk(KERN_CONT " w/%dKiB Cache", id->buf_size / 2);
 
 	printk(KERN_CONT ", CHS=%d/%d/%d\n",
 			 drive->bios_cyl, drive->bios_head, drive->bios_sect);
@@ -949,7 +949,8 @@ static void ide_device_shutdown(ide_drive_t *drive)
 		return;
 	}
 
-	printk("Shutdown: %s\n", drive->name);
+	printk(KERN_INFO "Shutdown: %s\n", drive->name);
+
 	drive->gendev.bus->suspend(&drive->gendev, PMSG_SUSPEND);
 }
 
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index d0e7b53..2de99e4 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -1,9 +1,13 @@
 /*
+ *  IDE DMA support (including IDE PCI BM-DMA).
+ *
  *  Copyright (C) 1995-1998   Mark Lord
  *  Copyright (C) 1999-2000   Andre Hedrick <andre@linux-ide.org>
  *  Copyright (C) 2004, 2007  Bartlomiej Zolnierkiewicz
  *
  *  May be copied or modified under the terms of the GNU General Public License
+ *
+ *  DMA is supported for all IDE devices (disk drives, cdroms, tapes, floppies).
  */
 
 /*
@@ -11,49 +15,6 @@
  */
 
 /*
- * This module provides support for the bus-master IDE DMA functions
- * of various PCI chipsets, including the Intel PIIX (i82371FB for
- * the 430 FX chipset), the PIIX3 (i82371SB for the 430 HX/VX and 
- * 440 chipsets), and the PIIX4 (i82371AB for the 430 TX chipset)
- * ("PIIX" stands for "PCI ISA IDE Xcellerator").
- *
- * Pretty much the same code works for other IDE PCI bus-mastering chipsets.
- *
- * DMA is supported for all IDE devices (disk drives, cdroms, tapes, floppies).
- *
- * By default, DMA support is prepared for use, but is currently enabled only
- * for drives which already have DMA enabled (UltraDMA or mode 2 multi/single),
- * or which are recognized as "good" (see table below).  Drives with only mode0
- * or mode1 (multi/single) DMA should also work with this chipset/driver
- * (eg. MC2112A) but are not enabled by default.
- *
- * Use "hdparm -i" to view modes supported by a given drive.
- *
- * The hdparm-3.5 (or later) utility can be used for manually enabling/disabling
- * DMA support, but must be (re-)compiled against this kernel version or later.
- *
- * To enable DMA, use "hdparm -d1 /dev/hd?" on a per-drive basis after booting.
- * If problems arise, ide.c will disable DMA operation after a few retries.
- * This error recovery mechanism works and has been extremely well exercised.
- *
- * IDE drives, depending on their vintage, may support several different modes
- * of DMA operation.  The boot-time modes are indicated with a "*" in
- * the "hdparm -i" listing, and can be changed with *knowledgeable* use of
- * the "hdparm -X" feature.  There is seldom a need to do this, as drives
- * normally power-up with their "best" PIO/DMA modes enabled.
- *
- * Testing has been done with a rather extensive number of drives,
- * with Quantum & Western Digital models generally outperforming the pack,
- * and Fujitsu & Conner (and some Seagate which are really Conner) drives
- * showing more lackluster throughput.
- *
- * Keep an eye on /var/adm/messages for "DMA disabled" messages.
- *
- * Some people have reported trouble with Intel Zappa motherboards.
- * This can be fixed by upgrading the AMI BIOS to version 1.00.04.BS0,
- * available from ftp://ftp.intel.com/pub/bios/10004bs0.exe
- * (thanks to Glen Morrell <glen@spin.Stanford.edu> for researching this).
- *
  * Thanks to "Christopher J. Reimer" <reimer@doe.carleton.ca> for
  * fixing the problem with the BIOS on some Acer motherboards.
  *
@@ -65,11 +26,6 @@
  *
  * Most importantly, thanks to Robert Bringman <rob@mars.trion.com>
  * for supplying a Promise UDMA board & WD UDMA drive for this work!
- *
- * And, yes, Intel Zappa boards really *do* use both PIIX IDE ports.
- *
- * ATA-66/100 and recovery functions, I forgot the rest......
- *
  */
 
 #include <linux/module.h>
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 4a2cb28..194ecb0 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -756,7 +756,8 @@ static int ide_probe_port(ide_hwif_t *hwif)
 
 	BUG_ON(hwif->present);
 
-	if (hwif->noprobe)
+	if (hwif->noprobe ||
+	    (hwif->drives[0].noprobe && hwif->drives[1].noprobe))
 		return -EACCES;
 
 	/*
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 0598ecf..43e0e05 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -3765,6 +3765,11 @@ static int ide_tape_probe(ide_drive_t *drive)
 	g->fops = &idetape_block_ops;
 	ide_register_region(g);
 
+	printk(KERN_WARNING "It is possible that this driver does not have any"
+		" users anymore and, as a result, it will be REMOVED soon."
+		" Please notify Bart <bzolnier@gmail.com> or Boris"
+		" <petkovbb@gmail.com> in case you still need it.\n");
+
 	return 0;
 
 out_free_tape:
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 477833f..fa16bc3 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -590,11 +590,6 @@ void ide_unregister(unsigned int index, int init_default, int restore)
 		hwif->extra_ports = 0;
 	}
 
-	/*
-	 * Note that we only release the standard ports,
-	 * and do not even try to handle any extra ports
-	 * allocated for weird IDE interface chipsets.
-	 */
 	ide_hwif_release_regions(hwif);
 
 	/* copy original settings */
@@ -1036,10 +1031,9 @@ int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device
 			drive->nice1 = (arg >> IDE_NICE_1) & 1;
 			return 0;
 		case HDIO_DRIVE_RESET:
-		{
-			unsigned long flags;
-			if (!capable(CAP_SYS_ADMIN)) return -EACCES;
-			
+			if (!capable(CAP_SYS_ADMIN))
+				return -EACCES;
+
 			/*
 			 *	Abort the current command on the
 			 *	group if there is one, taking
@@ -1058,17 +1052,15 @@ int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device
 			ide_abort(drive, "drive reset");
 
 			BUG_ON(HWGROUP(drive)->handler);
-				
+
 			/* Ensure nothing gets queued after we
 			   drop the lock. Reset will clear the busy */
-		   
+
 			HWGROUP(drive)->busy = 1;
 			spin_unlock_irqrestore(&ide_lock, flags);
 			(void) ide_do_reset(drive);
 
 			return 0;
-		}
-
 		case HDIO_GET_BUSSTATE:
 			if (!capable(CAP_SYS_ADMIN))
 				return -EACCES;
@@ -1449,7 +1441,7 @@ static int __init ide_setup(char *s)
 
 			case -1: /* "noprobe" */
 				hwif->noprobe = 1;
-				goto done;
+				goto obsolete_option;
 
 			case 1:	/* base */
 				vals[1] = vals[0] + 0x206; /* default ctl */
diff --git a/drivers/ide/legacy/qd65xx.c b/drivers/ide/legacy/qd65xx.c
index bba29df..2f4f47a 100644
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -334,43 +334,6 @@ static void __init qd6580_port_init_devs(ide_hwif_t *hwif)
 	hwif->drives[1].drive_data = t2;
 }
 
-/*
- * qd_unsetup:
- *
- * called to unsetup an ata channel : back to default values, unlinks tuning
- */
-/*
-static void __exit qd_unsetup(ide_hwif_t *hwif)
-{
-	u8 config = hwif->config_data;
-	int base = hwif->select_data;
-	void *set_pio_mode = (void *)hwif->set_pio_mode;
-
-	if (hwif->chipset != ide_qd65xx)
-		return;
-
-	printk(KERN_NOTICE "%s: back to defaults\n", hwif->name);
-
-	hwif->selectproc = NULL;
-	hwif->set_pio_mode = NULL;
-
-	if (set_pio_mode == (void *)qd6500_set_pio_mode) {
-		// will do it for both
-		outb(QD6500_DEF_DATA, QD_TIMREG(&hwif->drives[0]));
-	} else if (set_pio_mode == (void *)qd6580_set_pio_mode) {
-		if (QD_CONTROL(hwif) & QD_CONTR_SEC_DISABLED) {
-			outb(QD6580_DEF_DATA, QD_TIMREG(&hwif->drives[0]));
-			outb(QD6580_DEF_DATA2, QD_TIMREG(&hwif->drives[1]));
-		} else {
-			outb(hwif->channel ? QD6580_DEF_DATA2 : QD6580_DEF_DATA, QD_TIMREG(&hwif->drives[0]));
-		}
-	} else {
-		printk(KERN_WARNING "Unknown qd65xx tuning fonction !\n");
-		printk(KERN_WARNING "keeping settings !\n");
-	}
-}
-*/
-
 static const struct ide_port_info qd65xx_port_info __initdata = {
 	.chipset		= ide_qd65xx,
 	.host_flags		= IDE_HFLAG_IO_32BIT |
@@ -444,6 +407,8 @@ static int __init qd_probe(int base)
 		printk(KERN_DEBUG "qd6580: config=%#x, control=%#x, ID3=%u\n",
 			config, control, QD_ID3);
 
+		outb(QD_DEF_CONTR, QD_CONTROL_PORT);
+
 		if (control & QD_CONTR_SEC_DISABLED) {
 			/* secondary disabled */
 
@@ -460,8 +425,6 @@ static int __init qd_probe(int base)
 
 			ide_device_add(idx, &qd65xx_port_info);
 
-			outb(QD_DEF_CONTR, QD_CONTROL_PORT);
-
 			return 1;
 		} else {
 			ide_hwif_t *mate;
@@ -487,8 +450,6 @@ static int __init qd_probe(int base)
 
 			ide_device_add(idx, &qd65xx_port_info);
 
-			outb(QD_DEF_CONTR, QD_CONTROL_PORT);
-
 			return 0; /* no other qd65xx possible */
 		}
 	}
diff --git a/drivers/ide/pci/cmd640.c b/drivers/ide/pci/cmd640.c
index bd24dad..ec66798 100644
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -787,7 +787,8 @@ static int __init cmd640x_init(void)
 	/*
 	 * Try to enable the secondary interface, if not already enabled
 	 */
-	if (cmd_hwif1->noprobe) {
+	if (cmd_hwif1->noprobe ||
+	    (cmd_hwif1->drives[0].noprobe && cmd_hwif1->drives[1].noprobe)) {
 		port2 = "not probed";
 	} else {
 		b = get_cmd640_reg(CNTRL);
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index d0f7bb8..6357bb6 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1570,10 +1570,12 @@ static int __devinit hpt366_init_one(struct pci_dev *dev, const struct pci_devic
 		if (rev < 3)
 			info = &hpt36x;
 		else {
-			static const struct hpt_info *hpt37x_info[] =
-				{ &hpt370, &hpt370a, &hpt372, &hpt372n };
-
-			info = hpt37x_info[min_t(u8, rev, 6) - 3];
+			switch (min_t(u8, rev, 6)) {
+			case 3: info = &hpt370;  break;
+			case 4: info = &hpt370a; break;
+			case 5: info = &hpt372;  break;
+			case 6: info = &hpt372n; break;
+			}
 			idx++;
 		}
 		break;
@@ -1626,7 +1628,7 @@ static int __devinit hpt366_init_one(struct pci_dev *dev, const struct pci_devic
 	return ide_setup_pci_device(dev, &d);
 }
 
-static const struct pci_device_id hpt366_pci_tbl[] = {
+static const struct pci_device_id hpt366_pci_tbl[] __devinitconst = {
 	{ PCI_VDEVICE(TTI, PCI_DEVICE_ID_TTI_HPT366),  0 },
 	{ PCI_VDEVICE(TTI, PCI_DEVICE_ID_TTI_HPT372),  1 },
 	{ PCI_VDEVICE(TTI, PCI_DEVICE_ID_TTI_HPT302),  2 },
