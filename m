Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbZBBTvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbZBBTvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 14:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbZBBTus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 14:50:48 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:15266 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbZBBTuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 14:50:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=uYyL4EY7M3TCKpjCUoY4Gz+k6jUtRy6j9VTKJFTDMM9+Kz2puDfqPrypck58Q6/fR3
         lGcRKWwzDzfiCWCcz17NPr1rWXv0AzOmi5R64pT/FMeyB6T+qeW4d9NSEsxLrMFDt9ys
         wMhyH4yqTS3AR6nKgICHmZTOfufpcVMXfgaBM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE fixes
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Mon, 2 Feb 2009 20:48:10 +0100
Message-Id: <200902022048.10264.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inside:

- ide-cd bug fix for non-bio backed requests from Borislav Petkov
  (closes kernel.org bug #12320).

- icside bug fix to make it work again on PCB v6.

- Port initialization failure handling fix from Ian Campbell.

- Support for CS5536 PATA controller (based on older driver
  from Martin K. Petersen, also extra thanks to Sergei Shtylyov
  for excellent review of the new driver).

- Support for AmigaOne board for VIA IDE host driver
  from Gerhard Pircher.

- dev->bus_id -> dev_name() conversion from Kay Sievers.

- tx4939ide update from Atsushi Nemoto.


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/Kconfig     |   10 ++
 drivers/ide/Makefile    |    1 +
 drivers/ide/cs5536.c    |  308 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/ide/icside.c    |    2 +-
 drivers/ide/ide-acpi.c  |    2 +-
 drivers/ide/ide-cd.c    |    3 +
 drivers/ide/ide-io.c    |    9 +-
 drivers/ide/ide-probe.c |   43 +++++--
 drivers/ide/tx4939ide.c |    4 +-
 drivers/ide/via82cxxx.c |    5 +
 10 files changed, 371 insertions(+), 16 deletions(-)
 create mode 100644 drivers/ide/cs5536.c


Atsushi Nemoto (1):
      tx4939ide: typo fix and minor cleanup

Bartlomiej Zolnierkiewicz (3):
      ide: fix ide_register_port() failure handling
      ide: add CS5536 host driver (v3)
      icside: fix PCB version 6 support (v2)

Borislav Petkov (1):
      ide-cd: fix DMA for non bio-backed requests

Gerhard Pircher (1):
      ide: Force VIA IDE legacy interrupts for AmigaOne boards

Ian Campbell (1):
      IDE: Unregister and disable devices if initialization fails.

Kay Sievers (1):
      ide: struct device - replace bus_id with dev_name(), dev_set_name()


diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index b1c6f68..3dad229 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -465,6 +465,16 @@ config BLK_DEV_CS5535
 
 	  It is safe to say Y to this question.
 
+config BLK_DEV_CS5536
+	tristate "CS5536 chipset support"
+	depends on X86_32
+	select BLK_DEV_IDEDMA_PCI
+	help
+	  This option enables support for the AMD CS5536
+	  companion chip used with the Geode LX processor family.
+
+	  If unsure, say N.
+
 config BLK_DEV_HPT366
 	tristate "HPT36X/37X chipset support"
 	select BLK_DEV_IDEDMA_PCI
diff --git a/drivers/ide/Makefile b/drivers/ide/Makefile
index c2b9c93..d0e3d7d 100644
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_BLK_DEV_CMD64X)		+= cmd64x.o
 obj-$(CONFIG_BLK_DEV_CS5520)		+= cs5520.o
 obj-$(CONFIG_BLK_DEV_CS5530)		+= cs5530.o
 obj-$(CONFIG_BLK_DEV_CS5535)		+= cs5535.o
+obj-$(CONFIG_BLK_DEV_CS5536)		+= cs5536.o
 obj-$(CONFIG_BLK_DEV_SC1200)		+= sc1200.o
 obj-$(CONFIG_BLK_DEV_CY82C693)		+= cy82c693.o
 obj-$(CONFIG_BLK_DEV_DELKIN)		+= delkin_cb.o
diff --git a/drivers/ide/cs5536.c b/drivers/ide/cs5536.c
new file mode 100644
index 0000000..7a62db7
--- /dev/null
+++ b/drivers/ide/cs5536.c
@@ -0,0 +1,308 @@
+/*
+ * CS5536 PATA support
+ * (C) 2007 Martin K. Petersen <mkp@mkp.net>
+ * (C) 2009 Bartlomiej Zolnierkiewicz
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * Documentation:
+ *	Available from AMD web site.
+ *
+ * The IDE timing registers for the CS5536 live in the Geode Machine
+ * Specific Register file and not PCI config space.  Most BIOSes
+ * virtualize the PCI registers so the chip looks like a standard IDE
+ * controller.  Unfortunately not all implementations get this right.
+ * In particular some have problems with unaligned accesses to the
+ * virtualized PCI registers.  This driver always does full dword
+ * writes to work around the issue.  Also, in case of a bad BIOS this
+ * driver can be loaded with the "msr=1" parameter which forces using
+ * the Machine Specific Registers to configure the device.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/ide.h>
+#include <asm/msr.h>
+
+#define DRV_NAME	"cs5536"
+
+enum {
+	MSR_IDE_CFG		= 0x51300010,
+	PCI_IDE_CFG		= 0x40,
+
+	CFG			= 0,
+	DTC			= 2,
+	CAST			= 3,
+	ETC			= 4,
+
+	IDE_CFG_CHANEN		= (1 << 1),
+	IDE_CFG_CABLE		= (1 << 17) | (1 << 16),
+
+	IDE_D0_SHIFT		= 24,
+	IDE_D1_SHIFT		= 16,
+	IDE_DRV_MASK		= 0xff,
+
+	IDE_CAST_D0_SHIFT	= 6,
+	IDE_CAST_D1_SHIFT	= 4,
+	IDE_CAST_DRV_MASK	= 0x3,
+
+	IDE_CAST_CMD_SHIFT	= 24,
+	IDE_CAST_CMD_MASK	= 0xff,
+
+	IDE_ETC_UDMA_MASK	= 0xc0,
+};
+
+static int use_msr;
+
+static int cs5536_read(struct pci_dev *pdev, int reg, u32 *val)
+{
+	if (unlikely(use_msr)) {
+		u32 dummy;
+
+		rdmsr(MSR_IDE_CFG + reg, *val, dummy);
+		return 0;
+	}
+
+	return pci_read_config_dword(pdev, PCI_IDE_CFG + reg * 4, val);
+}
+
+static int cs5536_write(struct pci_dev *pdev, int reg, int val)
+{
+	if (unlikely(use_msr)) {
+		wrmsr(MSR_IDE_CFG + reg, val, 0);
+		return 0;
+	}
+
+	return pci_write_config_dword(pdev, PCI_IDE_CFG + reg * 4, val);
+}
+
+static void cs5536_program_dtc(ide_drive_t *drive, u8 tim)
+{
+	struct pci_dev *pdev = to_pci_dev(drive->hwif->dev);
+	int dshift = (drive->dn & 1) ? IDE_D1_SHIFT : IDE_D0_SHIFT;
+	u32 dtc;
+
+	cs5536_read(pdev, DTC, &dtc);
+	dtc &= ~(IDE_DRV_MASK << dshift);
+	dtc |= tim << dshift;
+	cs5536_write(pdev, DTC, dtc);
+}
+
+/**
+ *	cs5536_cable_detect	-	detect cable type
+ *	@hwif: Port to detect on
+ *
+ *	Perform cable detection for ATA66 capable cable.
+ *
+ *	Returns a cable type.
+ */
+
+static u8 cs5536_cable_detect(ide_hwif_t *hwif)
+{
+	struct pci_dev *pdev = to_pci_dev(hwif->dev);
+	u32 cfg;
+
+	cs5536_read(pdev, CFG, &cfg);
+
+	if (cfg & IDE_CFG_CABLE)
+		return ATA_CBL_PATA80;
+	else
+		return ATA_CBL_PATA40;
+}
+
+/**
+ *	cs5536_set_pio_mode		-	PIO timing setup
+ *	@drive: ATA device
+ *	@pio: PIO mode number
+ */
+
+static void cs5536_set_pio_mode(ide_drive_t *drive, const u8 pio)
+{
+	static const u8 drv_timings[5] = {
+		0x98, 0x55, 0x32, 0x21, 0x20,
+	};
+
+	static const u8 addr_timings[5] = {
+		0x2, 0x1, 0x0, 0x0, 0x0,
+	};
+
+	static const u8 cmd_timings[5] = {
+		0x99, 0x92, 0x90, 0x22, 0x20,
+	};
+
+	struct pci_dev *pdev = to_pci_dev(drive->hwif->dev);
+	ide_drive_t *pair = ide_get_pair_dev(drive);
+	int cshift = (drive->dn & 1) ? IDE_CAST_D1_SHIFT : IDE_CAST_D0_SHIFT;
+	u32 cast;
+	u8 cmd_pio = pio;
+
+	if (pair)
+		cmd_pio = min(pio, ide_get_best_pio_mode(pair, 255, 4));
+
+	drive->drive_data &= (IDE_DRV_MASK << 8);
+	drive->drive_data |= drv_timings[pio];
+
+	cs5536_program_dtc(drive, drv_timings[pio]);
+
+	cs5536_read(pdev, CAST, &cast);
+
+	cast &= ~(IDE_CAST_DRV_MASK << cshift);
+	cast |= addr_timings[pio] << cshift;
+
+	cast &= ~(IDE_CAST_CMD_MASK << IDE_CAST_CMD_SHIFT);
+	cast |= cmd_timings[cmd_pio] << IDE_CAST_CMD_SHIFT;
+
+	cs5536_write(pdev, CAST, cast);
+}
+
+/**
+ *	cs5536_set_dma_mode		-	DMA timing setup
+ *	@drive: ATA device
+ *	@mode: DMA mode
+ */
+
+static void cs5536_set_dma_mode(ide_drive_t *drive, const u8 mode)
+{
+	static const u8 udma_timings[6] = {
+		0xc2, 0xc1, 0xc0, 0xc4, 0xc5, 0xc6,
+	};
+
+	static const u8 mwdma_timings[3] = {
+		0x67, 0x21, 0x20,
+	};
+
+	struct pci_dev *pdev = to_pci_dev(drive->hwif->dev);
+	int dshift = (drive->dn & 1) ? IDE_D1_SHIFT : IDE_D0_SHIFT;
+	u32 etc;
+
+	cs5536_read(pdev, ETC, &etc);
+
+	if (mode >= XFER_UDMA_0) {
+		etc &= ~(IDE_DRV_MASK << dshift);
+		etc |= udma_timings[mode - XFER_UDMA_0] << dshift;
+	} else { /* MWDMA */
+		etc &= ~(IDE_ETC_UDMA_MASK << dshift);
+		drive->drive_data &= IDE_DRV_MASK;
+		drive->drive_data |= mwdma_timings[mode - XFER_MW_DMA_0] << 8;
+	}
+
+	cs5536_write(pdev, ETC, etc);
+}
+
+static void cs5536_dma_start(ide_drive_t *drive)
+{
+	if (drive->current_speed < XFER_UDMA_0 &&
+	    (drive->drive_data >> 8) != (drive->drive_data & IDE_DRV_MASK))
+		cs5536_program_dtc(drive, drive->drive_data >> 8);
+
+	ide_dma_start(drive);
+}
+
+static int cs5536_dma_end(ide_drive_t *drive)
+{
+	int ret = ide_dma_end(drive);
+
+	if (drive->current_speed < XFER_UDMA_0 &&
+	    (drive->drive_data >> 8) != (drive->drive_data & IDE_DRV_MASK))
+		cs5536_program_dtc(drive, drive->drive_data & IDE_DRV_MASK);
+
+	return ret;
+}
+
+static const struct ide_port_ops cs5536_port_ops = {
+	.set_pio_mode		= cs5536_set_pio_mode,
+	.set_dma_mode		= cs5536_set_dma_mode,
+	.cable_detect		= cs5536_cable_detect,
+};
+
+static const struct ide_dma_ops cs5536_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= cs5536_dma_start,
+	.dma_end		= cs5536_dma_end,
+	.dma_test_irq		= ide_dma_test_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
+};
+
+static const struct ide_port_info cs5536_info = {
+	.name		= DRV_NAME,
+	.port_ops	= &cs5536_port_ops,
+	.dma_ops	= &cs5536_dma_ops,
+	.host_flags	= IDE_HFLAG_SINGLE,
+	.pio_mask	= ATA_PIO4,
+	.mwdma_mask	= ATA_MWDMA2,
+	.udma_mask	= ATA_UDMA5,
+};
+
+/**
+ *	cs5536_init_one
+ *	@dev: PCI device
+ *	@id: Entry in match table
+ */
+
+static int cs5536_init_one(struct pci_dev *dev, const struct pci_device_id *id)
+{
+	u32 cfg;
+
+	if (use_msr)
+		printk(KERN_INFO DRV_NAME ": Using MSR regs instead of PCI\n");
+
+	cs5536_read(dev, CFG, &cfg);
+
+	if ((cfg & IDE_CFG_CHANEN) == 0) {
+		printk(KERN_ERR DRV_NAME ": disabled by BIOS\n");
+		return -ENODEV;
+	}
+
+	return ide_pci_init_one(dev, &cs5536_info, NULL);
+}
+
+static const struct pci_device_id cs5536_pci_tbl[] = {
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_CS5536_IDE), },
+	{ },
+};
+
+static struct pci_driver cs5536_pci_driver = {
+	.name		= DRV_NAME,
+	.id_table	= cs5536_pci_tbl,
+	.probe		= cs5536_init_one,
+	.remove		= ide_pci_remove,
+	.suspend	= ide_pci_suspend,
+	.resume		= ide_pci_resume,
+};
+
+static int __init cs5536_init(void)
+{
+	return pci_register_driver(&cs5536_pci_driver);
+}
+
+static void __exit cs5536_exit(void)
+{
+	pci_unregister_driver(&cs5536_pci_driver);
+}
+
+MODULE_AUTHOR("Martin K. Petersen, Bartlomiej Zolnierkiewicz");
+MODULE_DESCRIPTION("low-level driver for the CS5536 IDE controller");
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(pci, cs5536_pci_tbl);
+
+module_param_named(msr, use_msr, int, 0644);
+MODULE_PARM_DESC(msr, "Force using MSR to configure IDE function (Default: 0)");
+
+module_init(cs5536_init);
+module_exit(cs5536_exit);
diff --git a/drivers/ide/icside.c b/drivers/ide/icside.c
index 97a35c6..415d7e2 100644
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -534,7 +534,7 @@ icside_register_v6(struct icside_state *state, struct expansion_card *ec)
 		d.dma_ops = NULL;
 	}
 
-	ret = ide_host_register(host, NULL, hws);
+	ret = ide_host_register(host, &d, hws);
 	if (ret)
 		goto err_free;
 
diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index d8f295b..ec7d07f 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -282,7 +282,7 @@ static int do_drive_get_GTF(ide_drive_t *drive,
 	port = hwif->channel ? drive->dn - 2: drive->dn;
 
 	DEBPRINT("ENTER: %s at %s, port#: %d, hard_port#: %d\n",
-		 hwif->name, dev->bus_id, port, hwif->channel);
+		 hwif->name, dev_name(dev), port, hwif->channel);
 
 	if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0) {
 		DEBPRINT("%s drive %d:%d not present\n",
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index cae6937..0bfeb0c 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -787,6 +787,9 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 		if (blk_fs_request(rq)) {
 			ide_end_request(drive, 1, rq->nr_sectors);
 			return ide_stopped;
+		} else if (rq->cmd_type == REQ_TYPE_ATA_PC && !rq->bio) {
+			ide_end_request(drive, 1, 1);
+			return ide_stopped;
 		}
 		goto end_request;
 	}
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index cc16331..9ee51ad 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -418,11 +418,14 @@ void ide_map_sg(ide_drive_t *drive, struct request *rq)
 	ide_hwif_t *hwif = drive->hwif;
 	struct scatterlist *sg = hwif->sg_table;
 
-	if (rq->cmd_type != REQ_TYPE_ATA_TASKFILE) {
-		hwif->sg_nents = blk_rq_map_sg(drive->queue, rq, sg);
-	} else {
+	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
 		sg_init_one(sg, rq->buffer, rq->nr_sectors * SECTOR_SIZE);
 		hwif->sg_nents = 1;
+	} else if (!rq->bio) {
+		sg_init_one(sg, rq->data, rq->data_len);
+		hwif->sg_nents = 1;
+	} else {
+		hwif->sg_nents = blk_rq_map_sg(drive->queue, rq, sg);
 	}
 }
 
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 0db1ed9..ce0818a 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1467,6 +1467,30 @@ struct ide_host *ide_host_alloc(const struct ide_port_info *d, hw_regs_t **hws)
 }
 EXPORT_SYMBOL_GPL(ide_host_alloc);
 
+static void ide_port_free(ide_hwif_t *hwif)
+{
+	ide_port_free_devices(hwif);
+	ide_free_port_slot(hwif->index);
+	kfree(hwif);
+}
+
+static void ide_disable_port(ide_hwif_t *hwif)
+{
+	struct ide_host *host = hwif->host;
+	int i;
+
+	printk(KERN_INFO "%s: disabling port\n", hwif->name);
+
+	for (i = 0; i < MAX_HOST_PORTS; i++) {
+		if (host->ports[i] == hwif) {
+			host->ports[i] = NULL;
+			host->n_ports--;
+		}
+	}
+
+	ide_port_free(hwif);
+}
+
 int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
 		      hw_regs_t **hws)
 {
@@ -1507,8 +1531,12 @@ int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
 			hwif->present = 1;
 
 		if (hwif->chipset != ide_4drives || !hwif->mate ||
-		    !hwif->mate->present)
-			ide_register_port(hwif);
+		    !hwif->mate->present) {
+			if (ide_register_port(hwif)) {
+				ide_disable_port(hwif);
+				continue;
+			}
+		}
 
 		if (hwif->present)
 			ide_port_tune_devices(hwif);
@@ -1521,7 +1549,8 @@ int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
 		if (hwif_init(hwif) == 0) {
 			printk(KERN_INFO "%s: failed to initialize IDE "
 					 "interface\n", hwif->name);
-			hwif->present = 0;
+			device_unregister(&hwif->gendev);
+			ide_disable_port(hwif);
 			continue;
 		}
 
@@ -1660,12 +1689,8 @@ void ide_host_free(struct ide_host *host)
 	int i;
 
 	ide_host_for_each_port(i, hwif, host) {
-		if (hwif == NULL)
-			continue;
-
-		ide_port_free_devices(hwif);
-		ide_free_port_slot(hwif->index);
-		kfree(hwif);
+		if (hwif)
+			ide_port_free(hwif);
 	}
 
 	kfree(host);
diff --git a/drivers/ide/tx4939ide.c b/drivers/ide/tx4939ide.c
index 882f6f0..40b0812 100644
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -261,9 +261,9 @@ static int tx4939ide_build_dmatable(ide_drive_t *drive, struct request *rq)
 				bcount = cur_len;
 			/*
 			 * This workaround for zero count seems required.
-			 * (standard ide_build_dmatable do it too)
+			 * (standard ide_build_dmatable does it too)
 			 */
-			if ((bcount & 0xffff) == 0x0000)
+			if (bcount == 0x10000)
 				bcount = 0x8000;
 			*table++ = bcount & 0xffff;
 			*table++ = cur_addr;
diff --git a/drivers/ide/via82cxxx.c b/drivers/ide/via82cxxx.c
index 703c3ee..6092fe3 100644
--- a/drivers/ide/via82cxxx.c
+++ b/drivers/ide/via82cxxx.c
@@ -448,6 +448,11 @@ static int __devinit via_init_one(struct pci_dev *dev, const struct pci_device_i
 		d.host_flags |= IDE_HFLAG_FORCE_LEGACY_IRQS;
 #endif
 
+#ifdef CONFIG_AMIGAONE
+	if (machine_is(amigaone))
+		d.host_flags |= IDE_HFLAG_FORCE_LEGACY_IRQS;
+#endif
+
 	d.udma_mask = via_config->udma_mask;
 
 	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
