Return-Path: <linux-kernel-owner+w=401wt.eu-S1756784AbYJWVvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbYJWVvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 17:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756702AbYJWVu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 17:50:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:61509 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbYJWVuQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 17:50:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=fw7abmm3Ub7Lb1zUt8CRMnoVvULhOY7Dv/wGABCeFo+fehj4xcd8BA9KM6I32C4n74
         qVROAivz3u0ZIZq+AvX/z+XmN9ULknWFtE0VrJQtbhoT1uJXHMkNXXbF9VjjQNncMvWY
         Ku7S2DQU5kCzveBCUmjkQsRvsgBsXIDtuQAbM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE updates #5
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Thu, 23 Oct 2008 23:44:40 +0200
Message-Id: <200810232344.40652.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This time:

* Support for Toshiba TX4938 and TX4939 SoC controllers.
  (Atsushi Nemoto, mips part acked by Ralf Baechle)

* Set new non-rotational queue flag for SSD and CF devices.

* TEAC CD-224E workaround for close tray issue.
  (Márton Németh)

* SGIIOC4 IDE host driver fixups.
  (Sergei Shtylyov)

* Use new pci_ioremap_bar() helper in IDE host drivers.
  (Arjan van de Ven)

It should be the the last IDE update during this merge window.

Once again thanks to all contributors, with extra thanks to
Sergei for reviewing TX493x host drivers (among other patches).


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 arch/mips/include/asm/txx9/tx4938.h          |   13 +
 arch/mips/txx9/generic/setup_tx4938.c        |   47 ++
 arch/mips/txx9/rbtx4938/setup.c              |    1 +
 drivers/ide/Kconfig                          |   10 +
 drivers/ide/Makefile                         |    4 +-
 drivers/ide/ide-cd.c                         |    1 +
 drivers/ide/ide-disk.c                       |    8 +-
 drivers/ide/{generic.c => ide-pci-generic.c} |    0 
 drivers/ide/scc_pata.c                       |   10 +-
 drivers/ide/sgiioc4.c                        |   24 +-
 drivers/ide/siimage.c                        |    2 +-
 drivers/ide/tx4938ide.c                      |  310 +++++++++++
 drivers/ide/tx4939ide.c                      |  754 ++++++++++++++++++++++++++
 13 files changed, 1157 insertions(+), 27 deletions(-)
 rename drivers/ide/{generic.c => ide-pci-generic.c} (100%)
 create mode 100644 drivers/ide/tx4938ide.c
 create mode 100644 drivers/ide/tx4939ide.c


Arjan van de Ven (2):
      pci: use pci_ioremap_bar() in drivers/ide
      ide: two more pci_ioremap_bar() conversions

Atsushi Nemoto (3):
      ide: Add tx4939ide driver (v6)
      TXx9: Add TX4938 ATA support (v3)
      ide: Add tx4938ide driver (v2)

Bartlomiej Zolnierkiewicz (2):
      ide-disk: set non-rotational queue flag for SSD and CF devices
      ide: drivers/ide/generic.c -> drivers/ide/ide-pci-generic.c

Márton Németh (1):
      ide-cd: add TEAC CD-224E to the NO_AUTOCLOSE list

Sergei Shtylyov (2):
      sgiioc4: fix error cleanup path (take 2)
      sgiioc4: use ide_host_add() (take 2)


diff --git a/arch/mips/include/asm/txx9/tx4938.h b/arch/mips/include/asm/txx9/tx4938.h
index 989e775..0b06815 100644
--- a/arch/mips/include/asm/txx9/tx4938.h
+++ b/arch/mips/include/asm/txx9/tx4938.h
@@ -292,4 +292,17 @@ void tx4938_setup_pcierr_irq(void);
 void tx4938_irq_init(void);
 void tx4938_mtd_init(int ch);
 
+struct tx4938ide_platform_info {
+	/*
+	 * I/O port shift, for platforms with ports that are
+	 * constantly spaced and need larger than the 1-byte
+	 * spacing used by ata_std_ports().
+	 */
+	unsigned int ioport_shift;
+	unsigned int gbus_clock;	/*  0 means no PIO mode tuning. */
+	unsigned int ebus_ch;
+};
+
+void tx4938_ata_init(unsigned int irq, unsigned int shift, int tune);
+
 #endif
diff --git a/arch/mips/txx9/generic/setup_tx4938.c b/arch/mips/txx9/generic/setup_tx4938.c
index af724e5..25819ff 100644
--- a/arch/mips/txx9/generic/setup_tx4938.c
+++ b/arch/mips/txx9/generic/setup_tx4938.c
@@ -16,6 +16,7 @@
 #include <linux/param.h>
 #include <linux/ptrace.h>
 #include <linux/mtd/physmap.h>
+#include <linux/platform_device.h>
 #include <asm/reboot.h>
 #include <asm/traps.h>
 #include <asm/txx9irq.h>
@@ -335,6 +336,52 @@ void __init tx4938_mtd_init(int ch)
 	txx9_physmap_flash_init(ch, start, size, &pdata);
 }
 
+void __init tx4938_ata_init(unsigned int irq, unsigned int shift, int tune)
+{
+	struct platform_device *pdev;
+	struct resource res[] = {
+		{
+			/* .start and .end are filled in later */
+			.flags = IORESOURCE_MEM,
+		}, {
+			.start = irq,
+			.flags = IORESOURCE_IRQ,
+		},
+	};
+	struct tx4938ide_platform_info pdata = {
+		.ioport_shift = shift,
+		/*
+		 * The IDE driver should not change bus timings if other ISA
+		 * devices existed.
+		 */
+		.gbus_clock = tune ? txx9_gbus_clock : 0,
+	};
+	u64 ebccr;
+	int i;
+
+	if ((__raw_readq(&tx4938_ccfgptr->pcfg) &
+	     (TX4938_PCFG_ATA_SEL | TX4938_PCFG_NDF_SEL))
+	    != TX4938_PCFG_ATA_SEL)
+		return;
+	for (i = 0; i < 8; i++) {
+		/* check EBCCRn.ISA, EBCCRn.BSZ, EBCCRn.ME */
+		ebccr = __raw_readq(&tx4938_ebuscptr->cr[i]);
+		if ((ebccr & 0x00f00008) == 0x00e00008)
+			break;
+	}
+	if (i == 8)
+		return;
+	pdata.ebus_ch = i;
+	res[0].start = ((ebccr >> 48) << 20) + 0x10000;
+	res[0].end = res[0].start + 0x20000 - 1;
+	pdev = platform_device_alloc("tx4938ide", -1);
+	if (!pdev ||
+	    platform_device_add_resources(pdev, res, ARRAY_SIZE(res)) ||
+	    platform_device_add_data(pdev, &pdata, sizeof(pdata)) ||
+	    platform_device_add(pdev))
+		platform_device_put(pdev);
+}
+
 static void __init tx4938_stop_unused_modules(void)
 {
 	__u64 pcfg, rst = 0, ckd = 0;
diff --git a/arch/mips/txx9/rbtx4938/setup.c b/arch/mips/txx9/rbtx4938/setup.c
index e077cc4..547ff29 100644
--- a/arch/mips/txx9/rbtx4938/setup.c
+++ b/arch/mips/txx9/rbtx4938/setup.c
@@ -352,6 +352,7 @@ static void __init rbtx4938_device_init(void)
 	rbtx4938_ne_init();
 	tx4938_wdt_init();
 	rbtx4938_mtd_init();
+	tx4938_ata_init(RBTX4938_IRQ_IOC_ATA, 0, 1);
 	txx9_iocled_init(RBTX4938_LED_ADDR - IO_BASE, -1, 8, 1, "green", NULL);
 }
 
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index a820ca6..6d74017 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -720,6 +720,16 @@ config BLK_DEV_IDE_AU1XXX_SEQTS_PER_RQ
        default "128"
        depends on BLK_DEV_IDE_AU1XXX
 
+config BLK_DEV_IDE_TX4938
+	tristate "TX4938 internal IDE support"
+	depends on SOC_TX4938
+	select IDE_TIMINGS
+
+config BLK_DEV_IDE_TX4939
+	tristate "TX4939 internal IDE support"
+	depends on SOC_TX4939
+	select BLK_DEV_IDEDMA_SFF
+
 config IDE_ARM
 	tristate "ARM IDE support"
 	depends on ARM && (ARCH_CLPS7500 || ARCH_RPC || ARCH_SHARK)
diff --git a/drivers/ide/Makefile b/drivers/ide/Makefile
index 9cf92ac..7818d40 100644
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -68,7 +68,6 @@ obj-$(CONFIG_BLK_DEV_VIA82CXXX)		+= via82cxxx.o
 
 # Must appear at the end of the block
 obj-$(CONFIG_BLK_DEV_GENERIC)		+= ide-pci-generic.o
-ide-pci-generic-y			+= generic.o
 
 obj-$(CONFIG_IDEPCI_PCIBUS_ORDER)	+= ide-scan-pci.o
 
@@ -111,3 +110,6 @@ obj-$(CONFIG_BLK_DEV_IDE_RAPIDE)	+= rapide.o
 obj-$(CONFIG_BLK_DEV_PALMCHIP_BK3710)	+= palm_bk3710.o
 
 obj-$(CONFIG_BLK_DEV_IDE_AU1XXX)	+= au1xxx-ide.o
+
+obj-$(CONFIG_BLK_DEV_IDE_TX4938)	+= tx4938ide.o
+obj-$(CONFIG_BLK_DEV_IDE_TX4939)	+= tx4939ide.o
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 133afd0..48b5eda 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1966,6 +1966,7 @@ static const struct cd_list_entry ide_cd_quirks_list[] = {
 	{ "Optiarc DVD RW AD-5200A", NULL,   IDE_AFLAG_PLAY_AUDIO_OK	     },
 	{ "Optiarc DVD RW AD-7200A", NULL,   IDE_AFLAG_PLAY_AUDIO_OK	     },
 	{ "Optiarc DVD RW AD-7543A", NULL,   IDE_AFLAG_NO_AUTOCLOSE	     },
+	{ "TEAC CD-ROM CD-224E",     NULL,   IDE_AFLAG_NO_AUTOCLOSE	     },
 	{ NULL, NULL, 0 }
 };
 
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 223750c..e5adebe 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -600,6 +600,7 @@ static int ide_disk_check(ide_drive_t *drive, const char *s)
 static void ide_disk_setup(ide_drive_t *drive)
 {
 	struct ide_disk_obj *idkp = drive->driver_data;
+	struct request_queue *q = drive->queue;
 	ide_hwif_t *hwif = drive->hwif;
 	u16 *id = drive->id;
 	char *m = (char *)&id[ATA_ID_PROD];
@@ -626,11 +627,14 @@ static void ide_disk_setup(ide_drive_t *drive)
 		if (max_s > hwif->rqsize)
 			max_s = hwif->rqsize;
 
-		blk_queue_max_sectors(drive->queue, max_s);
+		blk_queue_max_sectors(q, max_s);
 	}
 
 	printk(KERN_INFO "%s: max request size: %dKiB\n", drive->name,
-			 drive->queue->max_sectors / 2);
+		q->max_sectors / 2);
+
+	if (ata_id_is_ssd(id) || ata_id_is_cfa(id))
+		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
 
 	/* calculate drive capacity, and select LBA if possible */
 	ide_disk_get_capacity(drive);
diff --git a/drivers/ide/generic.c b/drivers/ide/ide-pci-generic.c
similarity index 100%
rename from drivers/ide/generic.c
rename to drivers/ide/ide-pci-generic.c
diff --git a/drivers/ide/scc_pata.c b/drivers/ide/scc_pata.c
index 49f163a..f26aa5d 100644
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -536,10 +536,6 @@ static u8 scc_udma_filter(ide_drive_t *drive)
 
 static int setup_mmio_scc (struct pci_dev *dev, const char *name)
 {
-	unsigned long ctl_base = pci_resource_start(dev, 0);
-	unsigned long dma_base = pci_resource_start(dev, 1);
-	unsigned long ctl_size = pci_resource_len(dev, 0);
-	unsigned long dma_size = pci_resource_len(dev, 1);
 	void __iomem *ctl_addr;
 	void __iomem *dma_addr;
 	int i, ret;
@@ -557,10 +553,12 @@ static int setup_mmio_scc (struct pci_dev *dev, const char *name)
 		return ret;
 	}
 
-	if ((ctl_addr = ioremap(ctl_base, ctl_size)) == NULL)
+	ctl_addr = pci_ioremap_bar(dev, 0);
+	if (!ctl_addr)
 		goto fail_0;
 
-	if ((dma_addr = ioremap(dma_base, dma_size)) == NULL)
+	dma_addr = pci_ioremap_bar(dev, 1);
+	if (!dma_addr)
 		goto fail_1;
 
 	pci_set_master(dev);
diff --git a/drivers/ide/sgiioc4.c b/drivers/ide/sgiioc4.c
index 8af9b23..7defa0a 100644
--- a/drivers/ide/sgiioc4.c
+++ b/drivers/ide/sgiioc4.c
@@ -567,14 +567,12 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 	unsigned long cmd_base, irqport;
 	unsigned long bar0, cmd_phys_base, ctl;
 	void __iomem *virt_base;
-	struct ide_host *host;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
-	struct ide_port_info d = sgiioc4_port_info;
 	int rc;
 
 	/*  Get the CmdBlk and CtrlBlk Base Registers */
 	bar0 = pci_resource_start(dev, 0);
-	virt_base = ioremap(bar0, pci_resource_len(dev, 0));
+	virt_base = pci_ioremap_bar(dev, 0);
 	if (virt_base == NULL) {
 		printk(KERN_ERR "%s: Unable to remap BAR 0 address: 0x%lx\n",
 				DRV_NAME, bar0);
@@ -590,7 +588,8 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 		printk(KERN_ERR "%s %s -- ERROR: addresses 0x%08lx to 0x%08lx "
 		       "already in use\n", DRV_NAME, pci_name(dev),
 		       cmd_phys_base, cmd_phys_base + IOC4_CMD_CTL_BLK_SIZE);
-		return -EBUSY;
+		rc = -EBUSY;
+		goto req_mem_rgn_err;
 	}
 
 	/* Initialize the IO registers */
@@ -603,21 +602,12 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 	/* Initializing chipset IRQ Registers */
 	writel(0x03, (void __iomem *)(irqport + IOC4_INTR_SET * 4));
 
-	host = ide_host_alloc(&d, hws);
-	if (host == NULL) {
-		rc = -ENOMEM;
-		goto err;
-	}
-
-	rc = ide_host_register(host, &d, hws);
-	if (rc)
-		goto err_free;
+	rc = ide_host_add(&sgiioc4_port_info, hws, NULL);
+	if (!rc)
+		return 0;
 
-	return 0;
-err_free:
-	ide_host_free(host);
-err:
 	release_mem_region(cmd_phys_base, IOC4_CMD_CTL_BLK_SIZE);
+req_mem_rgn_err:
 	iounmap(virt_base);
 	return rc;
 }
diff --git a/drivers/ide/siimage.c b/drivers/ide/siimage.c
index eb4faf9..c3107df 100644
--- a/drivers/ide/siimage.c
+++ b/drivers/ide/siimage.c
@@ -784,7 +784,7 @@ static int __devinit siimage_init_one(struct pci_dev *dev,
 			printk(KERN_WARNING DRV_NAME " %s: MMIO ports not "
 				"available\n", pci_name(dev));
 		} else {
-			ioaddr = ioremap(bar5, barsize);
+			ioaddr = pci_ioremap_bar(dev, 5);
 			if (ioaddr == NULL)
 				release_mem_region(bar5, barsize);
 		}
diff --git a/drivers/ide/tx4938ide.c b/drivers/ide/tx4938ide.c
new file mode 100644
index 0000000..fa660f9
--- /dev/null
+++ b/drivers/ide/tx4938ide.c
@@ -0,0 +1,310 @@
+/*
+ * TX4938 internal IDE driver
+ * Based on tx4939ide.c.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * (C) Copyright TOSHIBA CORPORATION 2005-2007
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/ide.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <asm/txx9/tx4938.h>
+
+static void tx4938ide_tune_ebusc(unsigned int ebus_ch,
+				 unsigned int gbus_clock,
+				 u8 pio)
+{
+	struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
+	u64 cr = __raw_readq(&tx4938_ebuscptr->cr[ebus_ch]);
+	unsigned int sp = (cr >> 4) & 3;
+	unsigned int clock = gbus_clock / (4 - sp);
+	unsigned int cycle = 1000000000 / clock;
+	unsigned int wt, shwt;
+
+	/* Minimum DIOx- active time */
+	wt = DIV_ROUND_UP(t->act8b, cycle) - 2;
+	/* IORDY setup time: 35ns */
+	wt = max(wt, DIV_ROUND_UP(35, cycle));
+	/* actual wait-cycle is max(wt & ~1, 1) */
+	if (wt > 2 && (wt & 1))
+		wt++;
+	wt &= ~1;
+	/* Address-valid to DIOR/DIOW setup */
+	shwt = DIV_ROUND_UP(t->setup, cycle);
+
+	pr_debug("tx4938ide: ebus %d, bus cycle %dns, WT %d, SHWT %d\n",
+		 ebus_ch, cycle, wt, shwt);
+
+	__raw_writeq((cr & ~(0x3f007ull)) | (wt << 12) | shwt,
+		     &tx4938_ebuscptr->cr[ebus_ch]);
+}
+
+static void tx4938ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct tx4938ide_platform_info *pdata = hwif->dev->platform_data;
+	u8 safe = pio;
+	ide_drive_t *pair;
+
+	pair = ide_get_pair_dev(drive);
+	if (pair)
+		safe = min(safe, ide_get_best_pio_mode(pair, 255, 5));
+	tx4938ide_tune_ebusc(pdata->ebus_ch, pdata->gbus_clock, safe);
+}
+
+#ifdef __BIG_ENDIAN
+
+/* custom iops (independent from SWAP_IO_SPACE) */
+static u8 tx4938ide_inb(unsigned long port)
+{
+	return __raw_readb((void __iomem *)port);
+}
+
+static void tx4938ide_outb(u8 value, unsigned long port)
+{
+	__raw_writeb(value, (void __iomem *)port);
+}
+
+static void tx4938ide_tf_load(ide_drive_t *drive, ide_task_t *task)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	struct ide_taskfile *tf = &task->tf;
+	u8 HIHI = task->tf_flags & IDE_TFLAG_LBA48 ? 0xE0 : 0xEF;
+
+	if (task->tf_flags & IDE_TFLAG_FLAGGED)
+		HIHI = 0xFF;
+
+	if (task->tf_flags & IDE_TFLAG_OUT_DATA) {
+		u16 data = (tf->hob_data << 8) | tf->data;
+
+		/* no endian swap */
+		__raw_writew(data, (void __iomem *)io_ports->data_addr);
+	}
+
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
+		tx4938ide_outb(tf->hob_feature, io_ports->feature_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
+		tx4938ide_outb(tf->hob_nsect, io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
+		tx4938ide_outb(tf->hob_lbal, io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
+		tx4938ide_outb(tf->hob_lbam, io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
+		tx4938ide_outb(tf->hob_lbah, io_ports->lbah_addr);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
+		tx4938ide_outb(tf->feature, io_ports->feature_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
+		tx4938ide_outb(tf->nsect, io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
+		tx4938ide_outb(tf->lbal, io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
+		tx4938ide_outb(tf->lbam, io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
+		tx4938ide_outb(tf->lbah, io_ports->lbah_addr);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
+		tx4938ide_outb((tf->device & HIHI) | drive->select,
+			       io_ports->device_addr);
+}
+
+static void tx4938ide_tf_read(ide_drive_t *drive, ide_task_t *task)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	struct ide_taskfile *tf = &task->tf;
+
+	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
+		u16 data;
+
+		/* no endian swap */
+		data = __raw_readw((void __iomem *)io_ports->data_addr);
+		tf->data = data & 0xff;
+		tf->hob_data = (data >> 8) & 0xff;
+	}
+
+	/* be sure we're looking at the low order bits */
+	tx4938ide_outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
+
+	if (task->tf_flags & IDE_TFLAG_IN_FEATURE)
+		tf->feature = tx4938ide_inb(io_ports->feature_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
+		tf->nsect  = tx4938ide_inb(io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
+		tf->lbal   = tx4938ide_inb(io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
+		tf->lbam   = tx4938ide_inb(io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
+		tf->lbah   = tx4938ide_inb(io_ports->lbah_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
+		tf->device = tx4938ide_inb(io_ports->device_addr);
+
+	if (task->tf_flags & IDE_TFLAG_LBA48) {
+		tx4938ide_outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
+
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
+			tf->hob_feature =
+				tx4938ide_inb(io_ports->feature_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
+			tf->hob_nsect   = tx4938ide_inb(io_ports->nsect_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
+			tf->hob_lbal    = tx4938ide_inb(io_ports->lbal_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
+			tf->hob_lbam    = tx4938ide_inb(io_ports->lbam_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
+			tf->hob_lbah    = tx4938ide_inb(io_ports->lbah_addr);
+	}
+}
+
+static void tx4938ide_input_data_swap(ide_drive_t *drive, struct request *rq,
+				void *buf, unsigned int len)
+{
+	unsigned long port = drive->hwif->io_ports.data_addr;
+	unsigned short *ptr = buf;
+	unsigned int count = (len + 1) / 2;
+
+	while (count--)
+		*ptr++ = cpu_to_le16(__raw_readw((void __iomem *)port));
+	__ide_flush_dcache_range((unsigned long)buf, count * 2);
+}
+
+static void tx4938ide_output_data_swap(ide_drive_t *drive, struct request *rq,
+				void *buf, unsigned int len)
+{
+	unsigned long port = drive->hwif->io_ports.data_addr;
+	unsigned short *ptr = buf;
+	unsigned int count = (len + 1) / 2;
+
+	while (count--) {
+		__raw_writew(le16_to_cpu(*ptr), (void __iomem *)port);
+		ptr++;
+	}
+	__ide_flush_dcache_range((unsigned long)buf, count * 2);
+}
+
+static const struct ide_tp_ops tx4938ide_tp_ops = {
+	.exec_command		= ide_exec_command,
+	.read_status		= ide_read_status,
+	.read_altstatus		= ide_read_altstatus,
+	.read_sff_dma_status	= ide_read_sff_dma_status,
+
+	.set_irq		= ide_set_irq,
+
+	.tf_load		= tx4938ide_tf_load,
+	.tf_read		= tx4938ide_tf_read,
+
+	.input_data		= tx4938ide_input_data_swap,
+	.output_data		= tx4938ide_output_data_swap,
+};
+
+#endif	/* __BIG_ENDIAN */
+
+static const struct ide_port_ops tx4938ide_port_ops = {
+	.set_pio_mode = tx4938ide_set_pio_mode,
+};
+
+static const struct ide_port_info tx4938ide_port_info __initdata = {
+	.port_ops = &tx4938ide_port_ops,
+#ifdef __BIG_ENDIAN
+	.tp_ops = &tx4938ide_tp_ops,
+#endif
+	.host_flags = IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
+	.pio_mask = ATA_PIO5,
+};
+
+static int __init tx4938ide_probe(struct platform_device *pdev)
+{
+	hw_regs_t hw;
+	hw_regs_t *hws[] = { &hw, NULL, NULL, NULL };
+	struct ide_host *host;
+	struct resource *res;
+	struct tx4938ide_platform_info *pdata = pdev->dev.platform_data;
+	int irq, ret, i;
+	unsigned long mapbase;
+	struct ide_port_info d = tx4938ide_port_info;
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return -ENODEV;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+
+	if (!devm_request_mem_region(&pdev->dev, res->start,
+				     res->end - res->start + 1, "tx4938ide"))
+		return -EBUSY;
+	mapbase = (unsigned long)devm_ioremap(&pdev->dev, res->start,
+					      res->end - res->start + 1);
+	if (!mapbase)
+		return -EBUSY;
+
+	memset(&hw, 0, sizeof(hw));
+	if (pdata->ioport_shift) {
+		unsigned long port = mapbase;
+
+		hw.io_ports_array[0] = port;
+#ifdef __BIG_ENDIAN
+		port++;
+#endif
+		for (i = 1; i <= 7; i++)
+			hw.io_ports_array[i] =
+				port + (i << pdata->ioport_shift);
+		hw.io_ports.ctl_addr =
+			port + 0x10000 + (6 << pdata->ioport_shift);
+	} else
+		ide_std_init_ports(&hw, mapbase, mapbase + 0x10006);
+	hw.irq = irq;
+	hw.dev = &pdev->dev;
+
+	pr_info("TX4938 IDE interface (base %#lx, irq %d)\n", mapbase, hw.irq);
+	if (pdata->gbus_clock)
+		tx4938ide_tune_ebusc(pdata->ebus_ch, pdata->gbus_clock, 0);
+	else
+		d.port_ops = NULL;
+	ret = ide_host_add(&d, hws, &host);
+	if (ret)
+		return ret;
+	platform_set_drvdata(pdev, host);
+	return 0;
+}
+
+static int __exit tx4938ide_remove(struct platform_device *pdev)
+{
+	struct ide_host *host = platform_get_drvdata(pdev);
+
+	ide_host_remove(host);
+	return 0;
+}
+
+static struct platform_driver tx4938ide_driver = {
+	.driver		= {
+		.name	= "tx4938ide",
+		.owner	= THIS_MODULE,
+	},
+	.remove = __exit_p(tx4938ide_remove),
+};
+
+static int __init tx4938ide_init(void)
+{
+	return platform_driver_probe(&tx4938ide_driver, tx4938ide_probe);
+}
+
+static void __exit tx4938ide_exit(void)
+{
+	platform_driver_unregister(&tx4938ide_driver);
+}
+
+module_init(tx4938ide_init);
+module_exit(tx4938ide_exit);
+
+MODULE_DESCRIPTION("TX4938 internal IDE driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:tx4938ide");
diff --git a/drivers/ide/tx4939ide.c b/drivers/ide/tx4939ide.c
new file mode 100644
index 0000000..bafb7d1
--- /dev/null
+++ b/drivers/ide/tx4939ide.c
@@ -0,0 +1,754 @@
+/*
+ * TX4939 internal IDE driver
+ * Based on RBTX49xx patch from CELF patch archive.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * (C) Copyright TOSHIBA CORPORATION 2005-2007
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/ide.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/scatterlist.h>
+
+#define MODNAME	"tx4939ide"
+
+/* ATA Shadow Registers (8-bit except for Data which is 16-bit) */
+#define TX4939IDE_Data			0x000
+#define TX4939IDE_Error_Feature		0x001
+#define TX4939IDE_Sec			0x002
+#define TX4939IDE_LBA0			0x003
+#define TX4939IDE_LBA1			0x004
+#define TX4939IDE_LBA2			0x005
+#define TX4939IDE_DevHead		0x006
+#define TX4939IDE_Stat_Cmd		0x007
+#define TX4939IDE_AltStat_DevCtl	0x402
+/* H/W DMA Registers  */
+#define TX4939IDE_DMA_Cmd	0x800	/* 8-bit */
+#define TX4939IDE_DMA_Stat	0x802	/* 8-bit */
+#define TX4939IDE_PRD_Ptr	0x804	/* 32-bit */
+/* ATA100 CORE Registers (16-bit) */
+#define TX4939IDE_Sys_Ctl	0xc00
+#define TX4939IDE_Xfer_Cnt_1	0xc08
+#define TX4939IDE_Xfer_Cnt_2	0xc0a
+#define TX4939IDE_Sec_Cnt	0xc10
+#define TX4939IDE_Start_Lo_Addr	0xc18
+#define TX4939IDE_Start_Up_Addr	0xc20
+#define TX4939IDE_Add_Ctl	0xc28
+#define TX4939IDE_Lo_Burst_Cnt	0xc30
+#define TX4939IDE_Up_Burst_Cnt	0xc38
+#define TX4939IDE_PIO_Addr	0xc88
+#define TX4939IDE_H_Rst_Tim	0xc90
+#define TX4939IDE_Int_Ctl	0xc98
+#define TX4939IDE_Pkt_Cmd	0xcb8
+#define TX4939IDE_Bxfer_Cnt_Hi	0xcc0
+#define TX4939IDE_Bxfer_Cnt_Lo	0xcc8
+#define TX4939IDE_Dev_TErr	0xcd0
+#define TX4939IDE_Pkt_Xfer_Ctl	0xcd8
+#define TX4939IDE_Start_TAddr	0xce0
+
+/* bits for Int_Ctl */
+#define TX4939IDE_INT_ADDRERR	0x80
+#define TX4939IDE_INT_REACHMUL	0x40
+#define TX4939IDE_INT_DEVTIMING	0x20
+#define TX4939IDE_INT_UDMATERM	0x10
+#define TX4939IDE_INT_TIMER	0x08
+#define TX4939IDE_INT_BUSERR	0x04
+#define TX4939IDE_INT_XFEREND	0x02
+#define TX4939IDE_INT_HOST	0x01
+
+#define TX4939IDE_IGNORE_INTS	\
+	(TX4939IDE_INT_ADDRERR | TX4939IDE_INT_REACHMUL | \
+	 TX4939IDE_INT_DEVTIMING | TX4939IDE_INT_UDMATERM | \
+	 TX4939IDE_INT_TIMER | TX4939IDE_INT_XFEREND)
+
+#ifdef __BIG_ENDIAN
+#define tx4939ide_swizzlel(a)	((a) ^ 4)
+#define tx4939ide_swizzlew(a)	((a) ^ 6)
+#define tx4939ide_swizzleb(a)	((a) ^ 7)
+#else
+#define tx4939ide_swizzlel(a)	(a)
+#define tx4939ide_swizzlew(a)	(a)
+#define tx4939ide_swizzleb(a)	(a)
+#endif
+
+static u16 tx4939ide_readw(void __iomem *base, u32 reg)
+{
+	return __raw_readw(base + tx4939ide_swizzlew(reg));
+}
+static u8 tx4939ide_readb(void __iomem *base, u32 reg)
+{
+	return __raw_readb(base + tx4939ide_swizzleb(reg));
+}
+static void tx4939ide_writel(u32 val, void __iomem *base, u32 reg)
+{
+	__raw_writel(val, base + tx4939ide_swizzlel(reg));
+}
+static void tx4939ide_writew(u16 val, void __iomem *base, u32 reg)
+{
+	__raw_writew(val, base + tx4939ide_swizzlew(reg));
+}
+static void tx4939ide_writeb(u8 val, void __iomem *base, u32 reg)
+{
+	__raw_writeb(val, base + tx4939ide_swizzleb(reg));
+}
+
+#define TX4939IDE_BASE(hwif)	((void __iomem *)(hwif)->extra_base)
+
+static void tx4939ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	int is_slave = drive->dn;
+	u32 mask, val;
+	u8 safe = pio;
+	ide_drive_t *pair;
+
+	pair = ide_get_pair_dev(drive);
+	if (pair)
+		safe = min(safe, ide_get_best_pio_mode(pair, 255, 4));
+	/*
+	 * Update Command Transfer Mode for master/slave and Data
+	 * Transfer Mode for this drive.
+	 */
+	mask = is_slave ? 0x07f00000 : 0x000007f0;
+	val = ((safe << 8) | (pio << 4)) << (is_slave ? 16 : 0);
+	hwif->select_data = (hwif->select_data & ~mask) | val;
+	/* tx4939ide_tf_load_fixup() will set the Sys_Ctl register */
+}
+
+static void tx4939ide_set_dma_mode(ide_drive_t *drive, const u8 mode)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u32 mask, val;
+
+	/* Update Data Transfer Mode for this drive. */
+	if (mode >= XFER_UDMA_0)
+		val = mode - XFER_UDMA_0 + 8;
+	else
+		val = mode - XFER_MW_DMA_0 + 5;
+	if (drive->dn) {
+		mask = 0x00f00000;
+		val <<= 20;
+	} else {
+		mask = 0x000000f0;
+		val <<= 4;
+	}
+	hwif->select_data = (hwif->select_data & ~mask) | val;
+	/* tx4939ide_tf_load_fixup() will set the Sys_Ctl register */
+}
+
+static u16 tx4939ide_check_error_ints(ide_hwif_t *hwif)
+{
+	void __iomem *base = TX4939IDE_BASE(hwif);
+	u16 ctl = tx4939ide_readw(base, TX4939IDE_Int_Ctl);
+
+	if (ctl & TX4939IDE_INT_BUSERR) {
+		/* reset FIFO */
+		u16 sysctl = tx4939ide_readw(base, TX4939IDE_Sys_Ctl);
+
+		tx4939ide_writew(sysctl | 0x4000, base, TX4939IDE_Sys_Ctl);
+		mmiowb();
+		/* wait 12GBUSCLK (typ. 60ns @ GBUS200MHz, max 270ns) */
+		ndelay(270);
+		tx4939ide_writew(sysctl, base, TX4939IDE_Sys_Ctl);
+	}
+	if (ctl & (TX4939IDE_INT_ADDRERR |
+		   TX4939IDE_INT_DEVTIMING | TX4939IDE_INT_BUSERR))
+		pr_err("%s: Error interrupt %#x (%s%s%s )\n",
+		       hwif->name, ctl,
+		       ctl & TX4939IDE_INT_ADDRERR ? " Address-Error" : "",
+		       ctl & TX4939IDE_INT_DEVTIMING ? " DEV-Timing" : "",
+		       ctl & TX4939IDE_INT_BUSERR ? " Bus-Error" : "");
+	return ctl;
+}
+
+static void tx4939ide_clear_irq(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif;
+	void __iomem *base;
+	u16 ctl;
+
+	/*
+	 * tx4939ide_dma_test_irq() and tx4939ide_dma_end() do all job
+	 * for DMA case.
+	 */
+	if (drive->waiting_for_dma)
+		return;
+	hwif = drive->hwif;
+	base = TX4939IDE_BASE(hwif);
+	ctl = tx4939ide_check_error_ints(hwif);
+	tx4939ide_writew(ctl, base, TX4939IDE_Int_Ctl);
+}
+
+static u8 tx4939ide_cable_detect(ide_hwif_t *hwif)
+{
+	void __iomem *base = TX4939IDE_BASE(hwif);
+
+	return tx4939ide_readw(base, TX4939IDE_Sys_Ctl) & 0x2000 ?
+		ATA_CBL_PATA40 : ATA_CBL_PATA80;
+}
+
+#ifdef __BIG_ENDIAN
+static void tx4939ide_dma_host_set(ide_drive_t *drive, int on)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 unit = drive->dn;
+	void __iomem *base = TX4939IDE_BASE(hwif);
+	u8 dma_stat = tx4939ide_readb(base, TX4939IDE_DMA_Stat);
+
+	if (on)
+		dma_stat |= (1 << (5 + unit));
+	else
+		dma_stat &= ~(1 << (5 + unit));
+
+	tx4939ide_writeb(dma_stat, base, TX4939IDE_DMA_Stat);
+}
+#else
+#define tx4939ide_dma_host_set	ide_dma_host_set
+#endif
+
+static u8 tx4939ide_clear_dma_status(void __iomem *base)
+{
+	u8 dma_stat;
+
+	/* read DMA status for INTR & ERROR flags */
+	dma_stat = tx4939ide_readb(base, TX4939IDE_DMA_Stat);
+	/* clear INTR & ERROR flags */
+	tx4939ide_writeb(dma_stat | ATA_DMA_INTR | ATA_DMA_ERR, base,
+			 TX4939IDE_DMA_Stat);
+	/* recover intmask cleared by writing to bit2 of DMA_Stat */
+	tx4939ide_writew(TX4939IDE_IGNORE_INTS << 8, base, TX4939IDE_Int_Ctl);
+	return dma_stat;
+}
+
+#ifdef __BIG_ENDIAN
+/* custom ide_build_dmatable to handle swapped layout */
+static int tx4939ide_build_dmatable(ide_drive_t *drive, struct request *rq)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u32 *table = (u32 *)hwif->dmatable_cpu;
+	unsigned int count = 0;
+	int i;
+	struct scatterlist *sg;
+
+	hwif->sg_nents = ide_build_sglist(drive, rq);
+	if (hwif->sg_nents == 0)
+		return 0;
+
+	for_each_sg(hwif->sg_table, sg, hwif->sg_nents, i) {
+		u32 cur_addr, cur_len, bcount;
+
+		cur_addr = sg_dma_address(sg);
+		cur_len = sg_dma_len(sg);
+
+		/*
+		 * Fill in the DMA table, without crossing any 64kB boundaries.
+		 */
+
+		while (cur_len) {
+			if (count++ >= PRD_ENTRIES)
+				goto use_pio_instead;
+
+			bcount = 0x10000 - (cur_addr & 0xffff);
+			if (bcount > cur_len)
+				bcount = cur_len;
+			*table++ = bcount & 0xffff;
+			*table++ = cur_addr;
+			cur_addr += bcount;
+			cur_len -= bcount;
+		}
+	}
+
+	if (count) {
+		*(table - 2) |= 0x80000000;
+		return count;
+	}
+
+use_pio_instead:
+	printk(KERN_ERR "%s: %s\n", drive->name,
+		count ? "DMA table too small" : "empty DMA table?");
+
+	ide_destroy_dmatable(drive);
+
+	return 0; /* revert to PIO for this request */
+}
+#else
+#define tx4939ide_build_dmatable	ide_build_dmatable
+#endif
+
+static int tx4939ide_dma_setup(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	void __iomem *base = TX4939IDE_BASE(hwif);
+	struct request *rq = hwif->hwgroup->rq;
+	u8 reading;
+	int nent;
+
+	if (rq_data_dir(rq))
+		reading = 0;
+	else
+		reading = ATA_DMA_WR;
+
+	/* fall back to PIO! */
+	nent = tx4939ide_build_dmatable(drive, rq);
+	if (!nent) {
+		ide_map_sg(drive, rq);
+		return 1;
+	}
+
+	/* PRD table */
+	tx4939ide_writel(hwif->dmatable_dma, base, TX4939IDE_PRD_Ptr);
+
+	/* specify r/w */
+	tx4939ide_writeb(reading, base, TX4939IDE_DMA_Cmd);
+
+	/* clear INTR & ERROR flags */
+	tx4939ide_clear_dma_status(base);
+
+	drive->waiting_for_dma = 1;
+
+	tx4939ide_writew(SECTOR_SIZE / 2, base, drive->dn ?
+			 TX4939IDE_Xfer_Cnt_2 : TX4939IDE_Xfer_Cnt_1);
+	tx4939ide_writew(rq->nr_sectors, base, TX4939IDE_Sec_Cnt);
+	return 0;
+}
+
+static int tx4939ide_dma_end(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 dma_stat, dma_cmd;
+	void __iomem *base = TX4939IDE_BASE(hwif);
+	u16 ctl = tx4939ide_readw(base, TX4939IDE_Int_Ctl);
+
+	drive->waiting_for_dma = 0;
+
+	/* get DMA command mode */
+	dma_cmd = tx4939ide_readb(base, TX4939IDE_DMA_Cmd);
+	/* stop DMA */
+	tx4939ide_writeb(dma_cmd & ~ATA_DMA_START, base, TX4939IDE_DMA_Cmd);
+
+	/* read and clear the INTR & ERROR bits */
+	dma_stat = tx4939ide_clear_dma_status(base);
+
+	/* purge DMA mappings */
+	ide_destroy_dmatable(drive);
+	/* verify good DMA status */
+	wmb();
+
+	if ((dma_stat & (ATA_DMA_INTR | ATA_DMA_ERR | ATA_DMA_ACTIVE)) == 0 &&
+	    (ctl & (TX4939IDE_INT_XFEREND | TX4939IDE_INT_HOST)) ==
+	    (TX4939IDE_INT_XFEREND | TX4939IDE_INT_HOST))
+		/* INT_IDE lost... bug? */
+		return 0;
+	return ((dma_stat & (ATA_DMA_INTR | ATA_DMA_ERR | ATA_DMA_ACTIVE)) !=
+		ATA_DMA_INTR) ? 0x10 | dma_stat : 0;
+}
+
+/* returns 1 if DMA IRQ issued, 0 otherwise */
+static int tx4939ide_dma_test_irq(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	void __iomem *base = TX4939IDE_BASE(hwif);
+	u16 ctl, ide_int;
+	u8 dma_stat, stat;
+	int found = 0;
+
+	ctl = tx4939ide_check_error_ints(hwif);
+	ide_int = ctl & (TX4939IDE_INT_XFEREND | TX4939IDE_INT_HOST);
+	switch (ide_int) {
+	case TX4939IDE_INT_HOST:
+		/* On error, XFEREND might not be asserted. */
+		stat = tx4939ide_readb(base, TX4939IDE_AltStat_DevCtl);
+		if ((stat & (ATA_BUSY | ATA_DRQ | ATA_ERR)) == ATA_ERR)
+			found = 1;
+		else
+			/* Wait for XFEREND (Mask HOST and unmask XFEREND) */
+			ctl &= ~TX4939IDE_INT_XFEREND << 8;
+		ctl |= ide_int << 8;
+		break;
+	case TX4939IDE_INT_HOST | TX4939IDE_INT_XFEREND:
+		dma_stat = tx4939ide_readb(base, TX4939IDE_DMA_Stat);
+		if (!(dma_stat & ATA_DMA_INTR))
+			pr_warning("%s: weird interrupt status. "
+				   "DMA_Stat %#02x int_ctl %#04x\n",
+				   hwif->name, dma_stat, ctl);
+		found = 1;
+		break;
+	}
+	/*
+	 * Do not clear XFEREND, HOST now.  They will be cleared by
+	 * clearing bit2 of DMA_Stat.
+	 */
+	ctl &= ~ide_int;
+	tx4939ide_writew(ctl, base, TX4939IDE_Int_Ctl);
+	return found;
+}
+
+static void tx4939ide_init_hwif(ide_hwif_t *hwif)
+{
+	void __iomem *base = TX4939IDE_BASE(hwif);
+
+	/* Soft Reset */
+	tx4939ide_writew(0x8000, base, TX4939IDE_Sys_Ctl);
+	mmiowb();
+	/* at least 20 GBUSCLK (typ. 100ns @ GBUS200MHz, max 450ns) */
+	ndelay(450);
+	tx4939ide_writew(0x0000, base, TX4939IDE_Sys_Ctl);
+	/* mask some interrupts and clear all interrupts */
+	tx4939ide_writew((TX4939IDE_IGNORE_INTS << 8) | 0xff, base,
+			 TX4939IDE_Int_Ctl);
+
+	tx4939ide_writew(0x0008, base, TX4939IDE_Lo_Burst_Cnt);
+	tx4939ide_writew(0, base, TX4939IDE_Up_Burst_Cnt);
+}
+
+static int tx4939ide_init_dma(ide_hwif_t *hwif, const struct ide_port_info *d)
+{
+	hwif->dma_base =
+		hwif->extra_base + tx4939ide_swizzleb(TX4939IDE_DMA_Cmd);
+	/*
+	 * Note that we cannot use ATA_DMA_TABLE_OFS, ATA_DMA_STATUS
+	 * for big endian.
+	 */
+	return ide_allocate_dma_engine(hwif);
+}
+
+static void tx4939ide_tf_load_fixup(ide_drive_t *drive, ide_task_t *task)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	void __iomem *base = TX4939IDE_BASE(hwif);
+	u16 sysctl = hwif->select_data >> (drive->dn ? 16 : 0);
+
+	/*
+	 * Fix ATA100 CORE System Control Register. (The write to the
+	 * Device/Head register may write wrong data to the System
+	 * Control Register)
+	 * While Sys_Ctl is written here, selectproc is not needed.
+	 */
+	tx4939ide_writew(sysctl, base, TX4939IDE_Sys_Ctl);
+}
+
+#ifdef __BIG_ENDIAN
+
+static u8 tx4939ide_read_sff_dma_status(ide_hwif_t *hwif)
+{
+	void __iomem *base = TX4939IDE_BASE(hwif);
+
+	return tx4939ide_readb(base, TX4939IDE_DMA_Stat);
+}
+
+/* custom iops (independent from SWAP_IO_SPACE) */
+static u8 tx4939ide_inb(unsigned long port)
+{
+	return __raw_readb((void __iomem *)port);
+}
+
+static void tx4939ide_outb(u8 value, unsigned long port)
+{
+	__raw_writeb(value, (void __iomem *)port);
+}
+
+static void tx4939ide_tf_load(ide_drive_t *drive, ide_task_t *task)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	struct ide_taskfile *tf = &task->tf;
+	u8 HIHI = task->tf_flags & IDE_TFLAG_LBA48 ? 0xE0 : 0xEF;
+
+	if (task->tf_flags & IDE_TFLAG_FLAGGED)
+		HIHI = 0xFF;
+
+	if (task->tf_flags & IDE_TFLAG_OUT_DATA) {
+		u16 data = (tf->hob_data << 8) | tf->data;
+
+		/* no endian swap */
+		__raw_writew(data, (void __iomem *)io_ports->data_addr);
+	}
+
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
+		tx4939ide_outb(tf->hob_feature, io_ports->feature_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
+		tx4939ide_outb(tf->hob_nsect, io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
+		tx4939ide_outb(tf->hob_lbal, io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
+		tx4939ide_outb(tf->hob_lbam, io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
+		tx4939ide_outb(tf->hob_lbah, io_ports->lbah_addr);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
+		tx4939ide_outb(tf->feature, io_ports->feature_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
+		tx4939ide_outb(tf->nsect, io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
+		tx4939ide_outb(tf->lbal, io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
+		tx4939ide_outb(tf->lbam, io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
+		tx4939ide_outb(tf->lbah, io_ports->lbah_addr);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE) {
+		tx4939ide_outb((tf->device & HIHI) | drive->select,
+			       io_ports->device_addr);
+		tx4939ide_tf_load_fixup(drive, task);
+	}
+}
+
+static void tx4939ide_tf_read(ide_drive_t *drive, ide_task_t *task)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	struct ide_taskfile *tf = &task->tf;
+
+	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
+		u16 data;
+
+		/* no endian swap */
+		data = __raw_readw((void __iomem *)io_ports->data_addr);
+		tf->data = data & 0xff;
+		tf->hob_data = (data >> 8) & 0xff;
+	}
+
+	/* be sure we're looking at the low order bits */
+	tx4939ide_outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
+
+	if (task->tf_flags & IDE_TFLAG_IN_FEATURE)
+		tf->feature = tx4939ide_inb(io_ports->feature_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
+		tf->nsect  = tx4939ide_inb(io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
+		tf->lbal   = tx4939ide_inb(io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
+		tf->lbam   = tx4939ide_inb(io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
+		tf->lbah   = tx4939ide_inb(io_ports->lbah_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
+		tf->device = tx4939ide_inb(io_ports->device_addr);
+
+	if (task->tf_flags & IDE_TFLAG_LBA48) {
+		tx4939ide_outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
+
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
+			tf->hob_feature =
+				tx4939ide_inb(io_ports->feature_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
+			tf->hob_nsect   = tx4939ide_inb(io_ports->nsect_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
+			tf->hob_lbal    = tx4939ide_inb(io_ports->lbal_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
+			tf->hob_lbam    = tx4939ide_inb(io_ports->lbam_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
+			tf->hob_lbah    = tx4939ide_inb(io_ports->lbah_addr);
+	}
+}
+
+static void tx4939ide_input_data_swap(ide_drive_t *drive, struct request *rq,
+				void *buf, unsigned int len)
+{
+	unsigned long port = drive->hwif->io_ports.data_addr;
+	unsigned short *ptr = buf;
+	unsigned int count = (len + 1) / 2;
+
+	while (count--)
+		*ptr++ = cpu_to_le16(__raw_readw((void __iomem *)port));
+	__ide_flush_dcache_range((unsigned long)buf, count * 2);
+}
+
+static void tx4939ide_output_data_swap(ide_drive_t *drive, struct request *rq,
+				void *buf, unsigned int len)
+{
+	unsigned long port = drive->hwif->io_ports.data_addr;
+	unsigned short *ptr = buf;
+	unsigned int count = (len + 1) / 2;
+
+	while (count--) {
+		__raw_writew(le16_to_cpu(*ptr), (void __iomem *)port);
+		ptr++;
+	}
+	__ide_flush_dcache_range((unsigned long)buf, count * 2);
+}
+
+static const struct ide_tp_ops tx4939ide_tp_ops = {
+	.exec_command		= ide_exec_command,
+	.read_status		= ide_read_status,
+	.read_altstatus		= ide_read_altstatus,
+	.read_sff_dma_status	= tx4939ide_read_sff_dma_status,
+
+	.set_irq		= ide_set_irq,
+
+	.tf_load		= tx4939ide_tf_load,
+	.tf_read		= tx4939ide_tf_read,
+
+	.input_data		= tx4939ide_input_data_swap,
+	.output_data		= tx4939ide_output_data_swap,
+};
+
+#else	/* __LITTLE_ENDIAN */
+
+static void tx4939ide_tf_load(ide_drive_t *drive, ide_task_t *task)
+{
+	ide_tf_load(drive, task);
+	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
+		tx4939ide_tf_load_fixup(drive, task);
+}
+
+static const struct ide_tp_ops tx4939ide_tp_ops = {
+	.exec_command		= ide_exec_command,
+	.read_status		= ide_read_status,
+	.read_altstatus		= ide_read_altstatus,
+	.read_sff_dma_status	= ide_read_sff_dma_status,
+
+	.set_irq		= ide_set_irq,
+
+	.tf_load		= tx4939ide_tf_load,
+	.tf_read		= ide_tf_read,
+
+	.input_data		= ide_input_data,
+	.output_data		= ide_output_data,
+};
+
+#endif	/* __LITTLE_ENDIAN */
+
+static const struct ide_port_ops tx4939ide_port_ops = {
+	.set_pio_mode = tx4939ide_set_pio_mode,
+	.set_dma_mode = tx4939ide_set_dma_mode,
+	.clear_irq = tx4939ide_clear_irq,
+	.cable_detect = tx4939ide_cable_detect,
+};
+
+static const struct ide_dma_ops tx4939ide_dma_ops = {
+	.dma_host_set = tx4939ide_dma_host_set,
+	.dma_setup = tx4939ide_dma_setup,
+	.dma_exec_cmd = ide_dma_exec_cmd,
+	.dma_start = ide_dma_start,
+	.dma_end = tx4939ide_dma_end,
+	.dma_test_irq = tx4939ide_dma_test_irq,
+	.dma_lost_irq = ide_dma_lost_irq,
+	.dma_timeout = ide_dma_timeout,
+};
+
+static const struct ide_port_info tx4939ide_port_info __initdata = {
+	.init_hwif = tx4939ide_init_hwif,
+	.init_dma = tx4939ide_init_dma,
+	.port_ops = &tx4939ide_port_ops,
+	.dma_ops = &tx4939ide_dma_ops,
+	.tp_ops = &tx4939ide_tp_ops,
+	.host_flags = IDE_HFLAG_MMIO,
+	.pio_mask = ATA_PIO4,
+	.mwdma_mask = ATA_MWDMA2,
+	.udma_mask = ATA_UDMA5,
+};
+
+static int __init tx4939ide_probe(struct platform_device *pdev)
+{
+	hw_regs_t hw;
+	hw_regs_t *hws[] = { &hw, NULL, NULL, NULL };
+	struct ide_host *host;
+	struct resource *res;
+	int irq, ret;
+	unsigned long mapbase;
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return -ENODEV;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+
+	if (!devm_request_mem_region(&pdev->dev, res->start,
+				     res->end - res->start + 1, "tx4938ide"))
+		return -EBUSY;
+	mapbase = (unsigned long)devm_ioremap(&pdev->dev, res->start,
+					      res->end - res->start + 1);
+	if (!mapbase)
+		return -EBUSY;
+	memset(&hw, 0, sizeof(hw));
+	hw.io_ports.data_addr =
+		mapbase + tx4939ide_swizzlew(TX4939IDE_Data);
+	hw.io_ports.error_addr =
+		mapbase + tx4939ide_swizzleb(TX4939IDE_Error_Feature);
+	hw.io_ports.nsect_addr =
+		mapbase + tx4939ide_swizzleb(TX4939IDE_Sec);
+	hw.io_ports.lbal_addr =
+		mapbase + tx4939ide_swizzleb(TX4939IDE_LBA0);
+	hw.io_ports.lbam_addr =
+		mapbase + tx4939ide_swizzleb(TX4939IDE_LBA1);
+	hw.io_ports.lbah_addr =
+		mapbase + tx4939ide_swizzleb(TX4939IDE_LBA2);
+	hw.io_ports.device_addr =
+		mapbase + tx4939ide_swizzleb(TX4939IDE_DevHead);
+	hw.io_ports.command_addr =
+		mapbase + tx4939ide_swizzleb(TX4939IDE_Stat_Cmd);
+	hw.io_ports.ctl_addr =
+		mapbase + tx4939ide_swizzleb(TX4939IDE_AltStat_DevCtl);
+	hw.irq = irq;
+	hw.dev = &pdev->dev;
+
+	pr_info("TX4939 IDE interface (base %#lx, irq %d)\n", mapbase, irq);
+	host = ide_host_alloc(&tx4939ide_port_info, hws);
+	if (!host)
+		return -ENOMEM;
+	/* use extra_base for base address of the all registers */
+	host->ports[0]->extra_base = mapbase;
+	ret = ide_host_register(host, &tx4939ide_port_info, hws);
+	if (ret) {
+		ide_host_free(host);
+		return ret;
+	}
+	platform_set_drvdata(pdev, host);
+	return 0;
+}
+
+static int __exit tx4939ide_remove(struct platform_device *pdev)
+{
+	struct ide_host *host = platform_get_drvdata(pdev);
+
+	ide_host_remove(host);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int tx4939ide_resume(struct platform_device *dev)
+{
+	struct ide_host *host = platform_get_drvdata(dev);
+	ide_hwif_t *hwif = host->ports[0];
+
+	tx4939ide_init_hwif(hwif);
+	return 0;
+}
+#else
+#define tx4939ide_resume	NULL
+#endif
+
+static struct platform_driver tx4939ide_driver = {
+	.driver = {
+		.name = MODNAME,
+		.owner = THIS_MODULE,
+	},
+	.remove = __exit_p(tx4939ide_remove),
+	.resume = tx4939ide_resume,
+};
+
+static int __init tx4939ide_init(void)
+{
+	return platform_driver_probe(&tx4939ide_driver, tx4939ide_probe);
+}
+
+static void __exit tx4939ide_exit(void)
+{
+	platform_driver_unregister(&tx4939ide_driver);
+}
+
+module_init(tx4939ide_init);
+module_exit(tx4939ide_exit);
+
+MODULE_DESCRIPTION("TX4939 internal IDE driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:tx4939ide");
