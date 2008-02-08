Return-Path: <linux-kernel-owner+w=401wt.eu-S1763335AbYBHAiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763335AbYBHAiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 19:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763309AbYBHAcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 19:32:08 -0500
Received: from wr-out-0506.google.com ([64.233.184.224]:46536 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933757AbYBHAcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 19:32:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=YoStLXAiDH1Z+fvUDl2Xn7sgrA0Lmw1tZ509Gp28Y62lnerYsOMLN0uc3N7FJ97ZMUEmcZ/96yBJdoHw1jd51/u2qBUV0j1tTu67vlBLt2QDyzdyD34L1BLxmlCwdNPqLrXa3Mb/59u1CpSBxxZbUusoNXvqU2sfQPKa5F5d0cY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 08 Feb 2008 01:46:06 +0100
Message-Id: <20080208004606.17746.90799.sendpatchset@localhost.localdomain>
In-Reply-To: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
References: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
Subject: [PATCH 15/18] ide: remove broken/dangerous HDIO_[UNREGISTER,SCAN]_HWIF ioctls
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hdparm explicitely marks HDIO_[UNREGISTER,SCAN]_HWIF ioctls as DANGEROUS
and given the number of bugs we can assume that there are no real users:

* DMA has no chance of working because DMA resources are released by
  ide_unregister() and they are never allocated again.

* Since ide_init_hwif_ports() is used for ->io_ports[] setup the ioctls
  don't work for almost all hosts with "non-standard" (== non ISA-like)
  layout of IDE taskfile registers (there is a lot of such host drivers).

* ide_port_init_devices() is not called when probing IDE devices so:
  - drive->autotune is never set and IDE host/devices are not programmed
    for the correct PIO/DMA transfer modes (=> possible data corruption)
  - host specific I/O 32-bit and IRQ unmasking settings are not applied
    (=> possible data corruption)
  - host specific ->port_init_devs method is not called (=> no luck with
    ht6560b, qd65xx and opti621 host drivers)

* ->rw_disk method is not preserved (=> no HPT3xxN chipsets support).

* ->serialized flag is not preserved (=> possible data corruption when
   using icside, aec62xx (ATP850UF chipset), cmd640, cs5530, hpt366
   (HPT3xxN chipsets), rz1000, sc1200, dtc2278 and ht6560b host drivers).

* ->ack_intr method is not preserved (=> needed by ide-cris, buddha,
  gayle and macide host drivers).

* ->sata_scr[] and sata_misc[] is cleared by ide_unregister() and it
  isn't initialized again (SiI3112 support needs them).

* To issue an ioctl() there need to be at least one IDE device present
  in the system.

* ->cable_detect method is not preserved + it is not called when probing
  IDE devices so cable detection is broken (however since DMA support is
  also broken it doesn't really matter ;-).

* Some objects which may have already been freed in ide_unregister()
  are restored by ide_hwif_restore() (i.e. ->hwgroup).

* ide_register_hw() may unregister unrelated IDE ports if free ide_hwifs[]
  slot cannot be found.

* When IDE host drivers are modular unregistered port may be re-used by
  different host driver that owned it first causing subtle bugs.

Since we now have a proper warm-plug support remove these ioctls,
then remove no longer needed:
- ide_register_hw() and ide_hwif_restore() functions
- 'init_default' and 'restore' arguments of ide_unregister()
- zeroeing of hwif->{dma,extra}_* fields in ide_unregister()

As an added bonus IDE core code size shrinks by ~3kB (x86-32).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 block/compat_ioctl.c              |    1 
 drivers/ide/arm/bast-ide.c        |    2 
 drivers/ide/arm/rapide.c          |    2 
 drivers/ide/ide-pnp.c             |    2 
 drivers/ide/ide.c                 |  198 --------------------------------------
 drivers/ide/legacy/ide-cs.c       |    4 
 drivers/ide/legacy/ide_platform.c |    2 
 drivers/ide/mips/au1xxx-ide.c     |    2 
 drivers/ide/pci/delkin_cb.c       |    4 
 drivers/ide/pci/scc_pata.c        |    2 
 include/linux/hdreg.h             |    4 
 include/linux/ide.h               |    2 
 12 files changed, 17 insertions(+), 208 deletions(-)

Index: b/block/compat_ioctl.c
===================================================================
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -624,7 +624,6 @@ static int compat_blkdev_driver_ioctl(st
 	case HDIO_GET_IDENTITY:
 	case HDIO_DRIVE_TASK:
 	case HDIO_DRIVE_CMD:
-	case HDIO_SCAN_HWIF:
 	/* 0x330 is reserved -- it used to be HDIO_GETGEO_BIG */
 	case 0x330:
 	/* 0x02 -- Floppy ioctls */
Index: b/drivers/ide/arm/bast-ide.c
===================================================================
--- a/drivers/ide/arm/bast-ide.c
+++ b/drivers/ide/arm/bast-ide.c
@@ -53,7 +53,7 @@ bastide_register(unsigned int base, unsi
 	i = hwif->index;
 
 	if (hwif->present)
-		ide_unregister(i, 0, 0);
+		ide_unregister(i);
 	else if (!hwif->hold)
 		ide_init_port_data(hwif, i);
 
Index: b/drivers/ide/arm/rapide.c
===================================================================
--- a/drivers/ide/arm/rapide.c
+++ b/drivers/ide/arm/rapide.c
@@ -76,7 +76,7 @@ static void __devexit rapide_remove(stru
 
 	ecard_set_drvdata(ec, NULL);
 
-	ide_unregister(hwif->index, 0, 0);
+	ide_unregister(hwif->index);
 
 	ecard_release_resources(ec);
 }
Index: b/drivers/ide/ide-pnp.c
===================================================================
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -62,7 +62,7 @@ static void idepnp_remove(struct pnp_dev
 	ide_hwif_t *hwif = pnp_get_drvdata(dev);
 
 	if (hwif)
-		ide_unregister(hwif->index, 0, 0);
+		ide_unregister(hwif->index);
 	else
 		printk(KERN_ERR "idepnp: Unable to remove device, please report.\n");
 }
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -364,108 +364,6 @@ void ide_hwif_release_regions(ide_hwif_t
 			release_region(hwif->io_ports[i], 1);
 }
 
-/**
- *	ide_hwif_restore	-	restore hwif to template
- *	@hwif: hwif to update
- *	@tmp_hwif: template
- *
- *	Restore hwif to a previous state by copying most settings
- *	from the template.
- */
-
-static void ide_hwif_restore(ide_hwif_t *hwif, ide_hwif_t *tmp_hwif)
-{
-	hwif->hwgroup			= tmp_hwif->hwgroup;
-
-	hwif->gendev.parent		= tmp_hwif->gendev.parent;
-
-	hwif->proc			= tmp_hwif->proc;
-
-	hwif->major			= tmp_hwif->major;
-	hwif->straight8			= tmp_hwif->straight8;
-	hwif->bus_state			= tmp_hwif->bus_state;
-
-	hwif->host_flags		= tmp_hwif->host_flags;
-
-	hwif->pio_mask			= tmp_hwif->pio_mask;
-
-	hwif->ultra_mask		= tmp_hwif->ultra_mask;
-	hwif->mwdma_mask		= tmp_hwif->mwdma_mask;
-	hwif->swdma_mask		= tmp_hwif->swdma_mask;
-
-	hwif->cbl			= tmp_hwif->cbl;
-
-	hwif->chipset			= tmp_hwif->chipset;
-	hwif->hold			= tmp_hwif->hold;
-
-	hwif->dev			= tmp_hwif->dev;
-
-#ifdef CONFIG_BLK_DEV_IDEPCI
-	hwif->cds			= tmp_hwif->cds;
-#endif
-
-	hwif->set_pio_mode		= tmp_hwif->set_pio_mode;
-	hwif->set_dma_mode		= tmp_hwif->set_dma_mode;
-	hwif->mdma_filter		= tmp_hwif->mdma_filter;
-	hwif->udma_filter		= tmp_hwif->udma_filter;
-	hwif->selectproc		= tmp_hwif->selectproc;
-	hwif->reset_poll		= tmp_hwif->reset_poll;
-	hwif->pre_reset			= tmp_hwif->pre_reset;
-	hwif->resetproc			= tmp_hwif->resetproc;
-	hwif->maskproc			= tmp_hwif->maskproc;
-	hwif->quirkproc			= tmp_hwif->quirkproc;
-	hwif->busproc			= tmp_hwif->busproc;
-
-	hwif->ata_input_data		= tmp_hwif->ata_input_data;
-	hwif->ata_output_data		= tmp_hwif->ata_output_data;
-	hwif->atapi_input_bytes		= tmp_hwif->atapi_input_bytes;
-	hwif->atapi_output_bytes	= tmp_hwif->atapi_output_bytes;
-
-	hwif->dma_host_set		= tmp_hwif->dma_host_set;
-	hwif->dma_setup			= tmp_hwif->dma_setup;
-	hwif->dma_exec_cmd		= tmp_hwif->dma_exec_cmd;
-	hwif->dma_start			= tmp_hwif->dma_start;
-	hwif->ide_dma_end		= tmp_hwif->ide_dma_end;
-	hwif->ide_dma_test_irq		= tmp_hwif->ide_dma_test_irq;
-	hwif->ide_dma_clear_irq		= tmp_hwif->ide_dma_clear_irq;
-	hwif->dma_lost_irq		= tmp_hwif->dma_lost_irq;
-	hwif->dma_timeout		= tmp_hwif->dma_timeout;
-
-	hwif->OUTB			= tmp_hwif->OUTB;
-	hwif->OUTBSYNC			= tmp_hwif->OUTBSYNC;
-	hwif->OUTW			= tmp_hwif->OUTW;
-	hwif->OUTSW			= tmp_hwif->OUTSW;
-	hwif->OUTSL			= tmp_hwif->OUTSL;
-
-	hwif->INB			= tmp_hwif->INB;
-	hwif->INW			= tmp_hwif->INW;
-	hwif->INSW			= tmp_hwif->INSW;
-	hwif->INSL			= tmp_hwif->INSL;
-
-	hwif->sg_max_nents		= tmp_hwif->sg_max_nents;
-
-	hwif->mmio			= tmp_hwif->mmio;
-	hwif->rqsize			= tmp_hwif->rqsize;
-
-#ifndef CONFIG_BLK_DEV_IDECS
-	hwif->irq			= tmp_hwif->irq;
-#endif
-
-	hwif->dma_base			= tmp_hwif->dma_base;
-	hwif->dma_command		= tmp_hwif->dma_command;
-	hwif->dma_vendor1		= tmp_hwif->dma_vendor1;
-	hwif->dma_status		= tmp_hwif->dma_status;
-	hwif->dma_vendor3		= tmp_hwif->dma_vendor3;
-	hwif->dma_prdtable		= tmp_hwif->dma_prdtable;
-
-	hwif->config_data		= tmp_hwif->config_data;
-	hwif->select_data		= tmp_hwif->select_data;
-	hwif->extra_base		= tmp_hwif->extra_base;
-	hwif->extra_ports		= tmp_hwif->extra_ports;
-
-	hwif->hwif_data			= tmp_hwif->hwif_data;
-}
-
 void ide_remove_port_from_hwgroup(ide_hwif_t *hwif)
 {
 	ide_hwgroup_t *hwgroup = hwif->hwgroup;
@@ -533,8 +431,6 @@ EXPORT_SYMBOL_GPL(ide_port_unregister_de
 /**
  *	ide_unregister		-	free an IDE interface
  *	@index: index of interface (will change soon to a pointer)
- *	@init_default: init default hwif flag
- *	@restore: restore hwif flag
  *
  *	Perform the final unregister of an IDE interface. At the moment
  *	we don't refcount interfaces so this will also get split up.
@@ -554,10 +450,9 @@ EXPORT_SYMBOL_GPL(ide_port_unregister_de
  *	This is raving bonkers.
  */
 
-void ide_unregister(unsigned int index, int init_default, int restore)
+void ide_unregister(unsigned int index)
 {
 	ide_hwif_t *hwif, *g;
-	static ide_hwif_t tmp_hwif; /* protected by ide_cfg_mtx */
 	ide_hwgroup_t *hwgroup;
 	int irq_count = 0;
 
@@ -604,19 +499,8 @@ void ide_unregister(unsigned int index, 
 	unregister_blkdev(hwif->major, hwif->name);
 	spin_lock_irq(&ide_lock);
 
-	if (hwif->dma_base) {
-		(void) ide_release_dma(hwif);
-
-		hwif->dma_base = 0;
-		hwif->dma_command = 0;
-		hwif->dma_vendor1 = 0;
-		hwif->dma_status = 0;
-		hwif->dma_vendor3 = 0;
-		hwif->dma_prdtable = 0;
-
-		hwif->extra_base  = 0;
-		hwif->extra_ports = 0;
-	}
+	if (hwif->dma_base)
+		(void)ide_release_dma(hwif);
 
 	/*
 	 * Note that we only release the standard ports,
@@ -625,18 +509,9 @@ void ide_unregister(unsigned int index, 
 	 */
 	ide_hwif_release_regions(hwif);
 
-	/* copy original settings */
-	tmp_hwif = *hwif;
-
 	/* restore hwif data to pristine status */
 	ide_init_port_data(hwif, index);
 
-	if (init_default)
-		init_hwif_default(hwif, index);
-
-	if (restore)
-		ide_hwif_restore(hwif, &tmp_hwif);
-
 abort:
 	spin_unlock_irq(&ide_lock);
 	mutex_unlock(&ide_cfg_mtx);
@@ -655,52 +530,6 @@ void ide_init_port_hw(ide_hwif_t *hwif, 
 }
 EXPORT_SYMBOL_GPL(ide_init_port_hw);
 
-/**
- *	ide_register_hw		-	register IDE interface
- *	@hw: hardware registers
- *	@quirkproc: quirkproc function
- *	@hwifp: pointer to returned hwif
- *
- *	Register an IDE interface, specifying exactly the registers etc.
- *
- *	Returns -1 on error.
- */
-
-static int ide_register_hw(hw_regs_t *hw, void (*quirkproc)(ide_drive_t *),
-			   ide_hwif_t **hwifp)
-{
-	int index, retry = 1;
-	ide_hwif_t *hwif;
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-
-	do {
-		hwif = ide_find_port(hw->io_ports[IDE_DATA_OFFSET]);
-		index = hwif->index;
-		if (hwif)
-			goto found;
-		for (index = 0; index < MAX_HWIFS; index++)
-			ide_unregister(index, 1, 1);
-	} while (retry--);
-	return -1;
-found:
-	if (hwif->present)
-		ide_unregister(index, 0, 1);
-	else if (!hwif->hold)
-		ide_init_port_data(hwif, index);
-
-	ide_init_port_hw(hwif, hw);
-	hwif->quirkproc = quirkproc;
-
-	idx[0] = index;
-
-	ide_device_add(idx, NULL);
-
-	if (hwifp)
-		*hwifp = hwif;
-
-	return hwif->present ? index : -1;
-}
-
 /*
  *	Locks for IDE setting functionality
  */
@@ -1003,27 +832,6 @@ int generic_ide_ioctl(ide_drive_t *drive
 			if (!capable(CAP_SYS_RAWIO))
 				return -EACCES;
 			return ide_task_ioctl(drive, cmd, arg);
-
-		case HDIO_SCAN_HWIF:
-		{
-			hw_regs_t hw;
-			int args[3];
-			if (!capable(CAP_SYS_RAWIO)) return -EACCES;
-			if (copy_from_user(args, p, 3 * sizeof(int)))
-				return -EFAULT;
-			memset(&hw, 0, sizeof(hw));
-			ide_init_hwif_ports(&hw, (unsigned long) args[0],
-					    (unsigned long) args[1], NULL);
-			hw.irq = args[2];
-			if (ide_register_hw(&hw, NULL, NULL) == -1)
-				return -EIO;
-			return 0;
-		}
-	        case HDIO_UNREGISTER_HWIF:
-			if (!capable(CAP_SYS_RAWIO)) return -EACCES;
-			/* (arg > MAX_HWIFS) checked in function */
-			ide_unregister(arg, 1, 1);
-			return 0;
 		case HDIO_SET_NICE:
 			if (!capable(CAP_SYS_ADMIN)) return -EACCES;
 			if (arg != (arg & ((1 << IDE_NICE_DSC_OVERLAP) | (1 << IDE_NICE_1))))
Index: b/drivers/ide/legacy/ide-cs.c
===================================================================
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -163,7 +163,7 @@ static int idecs_register(unsigned long 
     i = hwif->index;
 
     if (hwif->present)
-	ide_unregister(i, 0, 0);
+	ide_unregister(i);
     else if (!hwif->hold)
 	ide_init_port_data(hwif, i);
 
@@ -360,7 +360,7 @@ void ide_release(struct pcmcia_device *l
     if (info->ndev) {
 	/* FIXME: if this fails we need to queue the cleanup somehow
 	   -- need to investigate the required PCMCIA magic */
-	ide_unregister(info->hd, 0, 0);
+	ide_unregister(info->hd);
     }
     info->ndev = 0;
 
Index: b/drivers/ide/legacy/ide_platform.c
===================================================================
--- a/drivers/ide/legacy/ide_platform.c
+++ b/drivers/ide/legacy/ide_platform.c
@@ -122,7 +122,7 @@ static int __devexit plat_ide_remove(str
 {
 	ide_hwif_t *hwif = pdev->dev.driver_data;
 
-	ide_unregister(hwif->index, 0, 0);
+	ide_unregister(hwif->index);
 
 	return 0;
 }
Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -677,7 +677,7 @@ static int au_ide_remove(struct device *
 	ide_hwif_t *hwif = dev_get_drvdata(dev);
 	_auide_hwif *ahwif = &auide_hwif;
 
-	ide_unregister(hwif->index, 0, 0);
+	ide_unregister(hwif->index);
 
 	iounmap((void *)ahwif->regbase);
 
Index: b/drivers/ide/pci/delkin_cb.c
===================================================================
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -85,7 +85,7 @@ delkin_cb_probe (struct pci_dev *dev, co
 	i = hwif->index;
 
 	if (hwif->present)
-		ide_unregister(i, 0, 0);
+		ide_unregister(i);
 	else if (!hwif->hold)
 		ide_init_port_data(hwif, i);
 
@@ -120,7 +120,7 @@ delkin_cb_remove (struct pci_dev *dev)
 	ide_hwif_t *hwif = pci_get_drvdata(dev);
 
 	if (hwif)
-		ide_unregister(hwif->index, 0, 0);
+		ide_unregister(hwif->index);
 
 	pci_disable_device(dev);
 }
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -736,7 +736,7 @@ static void __devexit scc_remove(struct 
 		hwif->dmatable_cpu = NULL;
 	}
 
-	ide_unregister(hwif->index, 0, 0);
+	ide_unregister(hwif->index);
 
 	hwif->chipset = ide_unknown;
 	iounmap((void*)ports->dma);
Index: b/include/linux/hdreg.h
===================================================================
--- a/include/linux/hdreg.h
+++ b/include/linux/hdreg.h
@@ -422,9 +422,11 @@ struct hd_geometry {
 #define HDIO_SET_NOWERR		0x0325	/* change ignore-write-error flag */
 #define HDIO_SET_DMA		0x0326	/* change use-dma flag */
 #define HDIO_SET_PIO_MODE	0x0327	/* reconfig interface to new speed */
+#ifndef __KERNEL__
 #define HDIO_SCAN_HWIF		0x0328	/* register and (re)scan interface */
-#define HDIO_SET_NICE		0x0329	/* set nice flags */
 #define HDIO_UNREGISTER_HWIF	0x032a  /* unregister interface */
+#endif
+#define HDIO_SET_NICE		0x0329	/* set nice flags */
 #define HDIO_SET_WCACHE		0x032b	/* change write cache enable-disable */
 #define HDIO_SET_ACOUSTIC	0x032c	/* change acoustic behavior */
 #define HDIO_SET_BUSSTATE	0x032d	/* set the bus state of the hwif */
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1193,7 +1193,7 @@ static inline void ide_acpi_set_state(id
 void ide_remove_port_from_hwgroup(ide_hwif_t *);
 extern int ide_hwif_request_regions(ide_hwif_t *hwif);
 extern void ide_hwif_release_regions(ide_hwif_t* hwif);
-void ide_unregister(unsigned int, int, int);
+void ide_unregister(unsigned int);
 
 void ide_register_region(struct gendisk *);
 void ide_unregister_region(struct gendisk *);
