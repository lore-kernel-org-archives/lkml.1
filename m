Return-Path: <linux-kernel-owner+w=401wt.eu-S1752535AbYLBUGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbYLBUGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:06:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbYLBUFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:05:50 -0500
Received: from gv-out-0910.google.com ([216.239.58.185]:3366 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbYLBUFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:05:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=gni8LMNadN6Sca5E/zGmb9uHJ4zpOP59QvKIXt9qclz3AraZgbbH4U9IMtxfGeYWd7
         E7FO+4aBB58tw75KeQosjVCyLzB9oU9X601nJy9Hlxrzoa07ZIC6rrIOW3ZyT/+vr9nM
         b2mORQ2dqWptV0v/bs4DRnjRCUG2V+JM5+500=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE fixes for 2.6.28-rc7
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Tue, 2 Dec 2008 21:02:14 +0100
Message-Id: <200812022102.14690.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id mB2K6Adq027437


* amd74xx host driver fix for nVidia controllers (this should take  care of most bugreports about ATAPI devices not working properly) 
  [ libata developers are encouraged to copy the fix to pata_amd    (the issue manifests itself with pata_amd reporting diagnostics    failure on good devices) ]
* quirk for SAMSUNG SP0822N with firmware WA100-10 to allow UDMA > 33
* fix ide_release_lock imbalance for Atari (from Michael Schmitz)
+ few misc fixes

Linus, please pull from:
master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/
to receive the following updates:
 drivers/ide/alim15x3.c  |    2 +- drivers/ide/amd74xx.c   |   11 ++++++++++- drivers/ide/ide-io.c    |   30 ++++++++++++++---------------- drivers/ide/ide-iops.c  |    9 +++------ drivers/ide/ide-probe.c |    3 ++- include/linux/ide.h     |    8 ++++++++ 6 files changed, 38 insertions(+), 25 deletions(-)

Bartlomiej Zolnierkiewicz (5):      amd74xx: workaround unreliable AltStatus register for nVidia controllers      ide: add SAMSUNG SP0822N with firmware WA100-10 to ivb_list[]      ide: respect current DMA setting during resume      ide: fix build for DEBUG_PM      ide: remove dead code from drive_is_ready()
Hannes Eder (1):      alim15x3: fix sparse warning
Michael Schmitz (1):      ide: fix the ide_release_lock imbalance

diff --git a/drivers/ide/alim15x3.c b/drivers/ide/alim15x3.cindex e56c7b7..45d2356 100644--- a/drivers/ide/alim15x3.c+++ b/drivers/ide/alim15x3.c@@ -591,7 +591,7 @@ static int __init ali15x3_ide_init(void)  static void __exit ali15x3_ide_exit(void) {-	return pci_unregister_driver(&alim15x3_pci_driver);+	pci_unregister_driver(&alim15x3_pci_driver); }  module_init(ali15x3_ide_init);diff --git a/drivers/ide/amd74xx.c b/drivers/ide/amd74xx.cindex 81ec731..c6bcd30 100644--- a/drivers/ide/amd74xx.c+++ b/drivers/ide/amd74xx.c@@ -3,7 +3,7 @@  * IDE driver for Linux.  *  * Copyright (c) 2000-2002 Vojtech Pavlik- * Copyright (c) 2007 Bartlomiej Zolnierkiewicz+ * Copyright (c) 2007-2008 Bartlomiej Zolnierkiewicz  *  * Based on the work of:  *      Andre Hedrick@@ -263,6 +263,15 @@ static int __devinit amd74xx_probe(struct pci_dev *dev, const struct pci_device_ 			d.udma_mask = ATA_UDMA5; 	} +	/*+	 * It seems that on some nVidia controllers using AltStatus+	 * register can be unreliable so default to Status register+	 * if the device is in Compatibility Mode.+	 */+	if (dev->vendor == PCI_VENDOR_ID_NVIDIA &&+	    ide_pci_is_in_compatibility_mode(dev))+		d.host_flags |= IDE_HFLAG_BROKEN_ALTSTATUS;+ 	printk(KERN_INFO "%s %s: UDMA%s controller\n", 		d.name, pci_name(dev), amd_dma[fls(d.udma_mask) - 1]); diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.cindex 7162d67..7d275b2 100644--- a/drivers/ide/ide-io.c+++ b/drivers/ide/ide-io.c@@ -132,10 +132,14 @@ int ide_end_request (ide_drive_t *drive, int uptodate, int nr_sectors) } EXPORT_SYMBOL(ide_end_request); -static void ide_complete_power_step(ide_drive_t *drive, struct request *rq, u8 stat, u8 error)+static void ide_complete_power_step(ide_drive_t *drive, struct request *rq) { 	struct request_pm_state *pm = rq->data; +#ifdef DEBUG_PM+	printk(KERN_INFO "%s: complete_power_step(step: %d)\n",+		drive->name, pm->pm_step);+#endif 	if (drive->media != ide_disk) 		return; @@ -172,7 +176,7 @@ static ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request * 		/* Not supported? Switch to next step now. */ 		if (ata_id_flush_enabled(drive->id) == 0 || 		    (drive->dev_flags & IDE_DFLAG_WCACHE) == 0) {-			ide_complete_power_step(drive, rq, 0, 0);+			ide_complete_power_step(drive, rq); 			return ide_stopped; 		} 		if (ata_id_flush_ext_enabled(drive->id))@@ -191,7 +195,7 @@ static ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request * 		if (drive->media != ide_disk) 			pm->pm_step = IDE_PM_RESTORE_DMA; 		else-			ide_complete_power_step(drive, rq, 0, 0);+			ide_complete_power_step(drive, rq); 		return ide_stopped; 	case IDE_PM_IDLE:		/* Resume step 2 (idle) */ 		args->tf.command = ATA_CMD_IDLEIMMEDIATE;@@ -204,10 +208,8 @@ static ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request * 		 */ 		if (drive->hwif->dma_ops == NULL) 			break;-		/*-		 * TODO: respect IDE_DFLAG_USING_DMA-		 */-		ide_set_dma(drive);+		if (drive->dev_flags & IDE_DFLAG_USING_DMA)+			ide_set_dma(drive); 		break; 	} @@ -322,11 +324,8 @@ void ide_end_drive_cmd (ide_drive_t *drive, u8 stat, u8 err) 		} 	} else if (blk_pm_request(rq)) { 		struct request_pm_state *pm = rq->data;-#ifdef DEBUG_PM-		printk("%s: complete_power_step(step: %d, stat: %x, err: %x)\n",-			drive->name, rq->pm->pm_step, stat, err);-#endif-		ide_complete_power_step(drive, rq, stat, err);++		ide_complete_power_step(drive, rq); 		if (pm->pm_step == IDE_PM_COMPLETED) 			ide_complete_pm_request(drive, rq); 		return;@@ -804,7 +803,7 @@ static ide_startstop_t start_request (ide_drive_t *drive, struct request *rq) 			struct request_pm_state *pm = rq->data; #ifdef DEBUG_PM 			printk("%s: start_power_step(step: %d)\n",-				drive->name, rq->pm->pm_step);+				drive->name, pm->pm_step); #endif 			startstop = ide_start_power_step(drive, rq); 			if (startstop == ide_stopped &&@@ -967,14 +966,13 @@ static void ide_do_request (ide_hwgroup_t *hwgroup, int masked_irq) 	ide_startstop_t	startstop; 	int             loops = 0; -	/* for atari only: POSSIBLY BROKEN HERE(?) */-	ide_get_lock(ide_intr, hwgroup);- 	/* caller must own ide_lock */ 	BUG_ON(!irqs_disabled());  	while (!hwgroup->busy) { 		hwgroup->busy = 1;+		/* for atari only */+		ide_get_lock(ide_intr, hwgroup); 		drive = choose_drive(hwgroup); 		if (drive == NULL) { 			int sleeping = 0;diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.cindex 5d6ba14..c41c3b9 100644--- a/drivers/ide/ide-iops.c+++ b/drivers/ide/ide-iops.c@@ -457,18 +457,14 @@ int drive_is_ready (ide_drive_t *drive) 	if (drive->waiting_for_dma) 		return hwif->dma_ops->dma_test_irq(drive); -#if 0-	/* need to guarantee 400ns since last command was issued */-	udelay(1);-#endif- 	/* 	 * We do a passive status test under shared PCI interrupts on 	 * cards that truly share the ATA side interrupt, but may also share 	 * an interrupt with another pci card/device.  We make no assumptions 	 * about possible isa-pnp and pci-pnp issues yet. 	 */-	if (hwif->io_ports.ctl_addr)+	if (hwif->io_ports.ctl_addr &&+	    (hwif->host_flags & IDE_HFLAG_BROKEN_ALTSTATUS) == 0) 		stat = hwif->tp_ops->read_altstatus(hwif); 	else 		/* Note: this may clear a pending IRQ!! */@@ -610,6 +606,7 @@ static const struct drive_list_entry ivb_list[] = { 	{ "TSSTcorp CDDVDW SH-S202N"	, "SB01"	}, 	{ "TSSTcorp CDDVDW SH-S202H"	, "SB00"	}, 	{ "TSSTcorp CDDVDW SH-S202H"	, "SB01"	},+	{ "SAMSUNG SP0822N"		, "WA100-10"	}, 	{ NULL				, NULL		} }; diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.cindex 1649ea5..c55bdbd 100644--- a/drivers/ide/ide-probe.c+++ b/drivers/ide/ide-probe.c@@ -266,7 +266,8 @@ static int actual_try_to_identify (ide_drive_t *drive, u8 cmd) 	/* take a deep breath */ 	msleep(50); -	if (io_ports->ctl_addr) {+	if (io_ports->ctl_addr &&+	    (hwif->host_flags & IDE_HFLAG_BROKEN_ALTSTATUS) == 0) { 		a = tp_ops->read_altstatus(hwif); 		s = tp_ops->read_status(hwif); 		if ((a ^ s) & ~ATA_IDX)diff --git a/include/linux/ide.h b/include/linux/ide.hindex 54525be..010fb26 100644--- a/include/linux/ide.h+++ b/include/linux/ide.h@@ -1296,6 +1296,13 @@ extern int __ide_pci_register_driver(struct pci_driver *driver, struct module *o #define ide_pci_register_driver(d) pci_register_driver(d) #endif +static inline int ide_pci_is_in_compatibility_mode(struct pci_dev *dev)+{+	if ((dev->class >> 8) == PCI_CLASS_STORAGE_IDE && (dev->class & 5) != 5)+		return 1;+	return 0;+}+ void ide_pci_setup_ports(struct pci_dev *, const struct ide_port_info *, int, 			 hw_regs_t *, hw_regs_t **); void ide_setup_pci_noise(struct pci_dev *, const struct ide_port_info *);@@ -1375,6 +1382,7 @@ enum { 	IDE_HFLAG_IO_32BIT		= (1 << 24), 	/* unmask IRQs */ 	IDE_HFLAG_UNMASK_IRQS		= (1 << 25),+	IDE_HFLAG_BROKEN_ALTSTATUS	= (1 << 26), 	/* serialize ports if DMA is possible (for sl82c105) */ 	IDE_HFLAG_SERIALIZE_DMA		= (1 << 27), 	/* force host out of "simplex" mode */ ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
