Return-Path: <linux-kernel-owner+w=401wt.eu-S1756623AbYBJXyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbYBJXyU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 18:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbYBJXyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 18:54:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:12509 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbYBJXx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 18:53:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=oYGnfbbHwwZoX9fOIfv0M2s6J9xYlxNVSQkyBmCw+wungvEhJIXp0OFtyhGDYJ86cdG1gOPGAPiFdVJXueu2gPHtx3E0gL4Igq0ybtFf/98Y0WA9tixtHB00zXRWIDZUKr9hctvkpIPJLM694J8TO+cHAdbaoZmpBu3e0HzKZgs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git patches] IDE fixes
Date: Mon, 11 Feb 2008 01:06:51 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802110106.51185.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

We merged _a_lot_ of IDE patches for 2.6.25 so no wonder that a few bugs
showed up (yes, mostly brown paper ones of mine :).  This update should
put it under control again (there are two more open regression bugreports
left and they are going to be addressed as soon as we have more data).

- fix nasty bug in handling of flush requests (extra thanks to Sebastian
  Siewior / James Bottomley / Christoph Hellwig for help with fixing it)

- fix ide_port_init() regression (spotted by Atsushi Nemoto)

- fix build of bast-ide of gayle host drivers (Adrian Bunk)

- fixes for Palm BK3710 support (Sergei Shtylyov and me)

- fix another possible ide-cd panic (Kiyoshi Ueda)

- other minor fixes


Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/Kconfig            |   26 ++++----------
 drivers/ide/arm/bast-ide.c     |   12 ++----
 drivers/ide/arm/palm_bk3710.c  |   74 ++++++++++++++++++++++++++++-----------
 drivers/ide/ide-cd.c           |    2 +-
 drivers/ide/ide-disk.c         |   18 ++++++----
 drivers/ide/ide-dma.c          |   14 ++++----
 drivers/ide/ide-io.c           |   19 ++++++----
 drivers/ide/ide-iops.c         |   10 +----
 drivers/ide/ide-lib.c          |    9 -----
 drivers/ide/ide-probe.c        |    4 +-
 drivers/ide/ide-tape.c         |   34 ------------------
 drivers/ide/ide.c              |    4 +--
 drivers/ide/legacy/gayle.c     |    2 +-
 drivers/ide/pci/cs5520.c       |    5 ---
 drivers/ide/pci/pdc202xx_old.c |   22 ------------
 include/linux/ide.h            |   11 +++---
 16 files changed, 107 insertions(+), 159 deletions(-)


Adrian Bunk (1):
      ide: fix ide/legacy/gayle.c compilation

Bartlomiej Zolnierkiewicz (12):
      palm_bk3710: ide_register_hw() -> ide_device_add()
      palm_bk3710: fix ide_unregister() usage
      palm_bk3710: port initialization/probing bugfix
      palm_bk3710: use struct ide_port_info
      pdc202xx_old: always enable burst mode
      ide: remove stale version number
      ide-tape: remove never executed code
      bast-ide: build fix
      ide-disk: fix flush requests (take 2)
      ide: ide_init_port() bugfix
      ide: fix comment in init_irq()
      ide: remove stale comment from ide-lib.c

Benjamin Herrenschmidt (1):
      cs5520: remove stale comment

Borislav Petkov (1):
      ide-cd: replace ntohs with generic byteorder macro be16_to_cpu

Kiyoshi Ueda (1):
      ide: another possible ide panic fix for blk-end-request

Sergei Shtylyov (2):
      ide: insert BUG_ON() into __ide_set_handler() (take 2)
      ide: introduce CONFIG_BLK_DEV_IDEDMA_SFF option


diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 043c34a..df752e6 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -378,6 +378,9 @@ config BLK_DEV_IDEPNP
 	  would like the kernel to automatically detect and activate
 	  it, say Y here.
 
+config BLK_DEV_IDEDMA_SFF
+	bool
+
 if PCI
 
 comment "PCI IDE chipsets support"
@@ -459,6 +462,7 @@ config BLK_DEV_RZ1000
 config BLK_DEV_IDEDMA_PCI
 	bool
 	select BLK_DEV_IDEPCI
+	select BLK_DEV_IDEDMA_SFF
 
 config BLK_DEV_AEC62XX
 	tristate "AEC62XX chipset support"
@@ -688,23 +692,6 @@ config BLK_DEV_PDC202XX_OLD
 
 	  If unsure, say N.
 
-config PDC202XX_BURST
-	bool "Special UDMA Feature"
-	depends on BLK_DEV_PDC202XX_OLD
-	help
-	  This option causes the pdc202xx driver to enable UDMA modes on the
-	  PDC202xx even when the PDC202xx BIOS has not done so.
-
-	  It was originally designed for the PDC20246/Ultra33, whose BIOS will
-	  only setup UDMA on the first two PDC20246 cards.  It has also been
-	  used successfully on a PDC20265/Ultra100, allowing use of UDMA modes
-	  when the PDC20265 BIOS has been disabled (for faster boot up).
-
-	  Please read the comments at the top of
-	  <file:drivers/ide/pci/pdc202xx_old.c>.
-
-	  If unsure, say N.
-
 config BLK_DEV_PDC202XX_NEW
 	tristate "PROMISE PDC202{68|69|70|71|75|76|77} support"
 	select BLK_DEV_IDEDMA_PCI
@@ -1016,7 +1003,7 @@ config BLK_DEV_Q40IDE
 config BLK_DEV_PALMCHIP_BK3710
 	tristate "Palmchip bk3710 IDE controller support"
 	depends on ARCH_DAVINCI
-	select BLK_DEV_IDEDMA_PCI
+	select BLK_DEV_IDEDMA_SFF
 	help
 	  Say Y here if you want to support the onchip IDE controller on the
 	  TI DaVinci SoC
@@ -1124,7 +1111,8 @@ config BLK_DEV_UMC8672
 endif
 
 config BLK_DEV_IDEDMA
-	def_bool BLK_DEV_IDEDMA_PCI || BLK_DEV_IDEDMA_PMAC || BLK_DEV_IDEDMA_ICS || BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
+	def_bool BLK_DEV_IDEDMA_SFF || BLK_DEV_IDEDMA_PMAC || \
+		 BLK_DEV_IDEDMA_ICS || BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
 
 config IDE_ARCH_OBSOLETE_INIT
 	def_bool ALPHA || (ARM && !ARCH_L7200) || BLACKFIN || X86 || IA64 || M32R || MIPS || PARISC || PPC || (SUPERH64 && BLK_DEV_IDEPCI) || SPARC
diff --git a/drivers/ide/arm/bast-ide.c b/drivers/ide/arm/bast-ide.c
index 0e7574c..161d30c 100644
--- a/drivers/ide/arm/bast-ide.c
+++ b/drivers/ide/arm/bast-ide.c
@@ -21,12 +21,7 @@
 #include <asm/arch/bast-map.h>
 #include <asm/arch/bast-irq.h>
 
-/* list of registered interfaces */
-static ide_hwif_t *ifs[2];
-
-static int __init
-bastide_register(unsigned int base, unsigned int aux, int irq,
-		 ide_hwif_t **hwif)
+static int __init bastide_register(unsigned int base, unsigned int aux, int irq)
 {
 	ide_hwif_t *hwif;
 	hw_regs_t hw;
@@ -76,8 +71,9 @@ static int __init bastide_init(void)
 
 	printk("BAST: IDE driver, (c) 2003-2004 Simtec Electronics\n");
 
-	bastide_register(BAST_VA_IDEPRI, BAST_VA_IDEPRIAUX, IRQ_IDE0, &ifs[0]);
-	bastide_register(BAST_VA_IDESEC, BAST_VA_IDESECAUX, IRQ_IDE1, &ifs[1]);
+	bastide_register(BAST_VA_IDEPRI, BAST_VA_IDEPRIAUX, IRQ_IDE0);
+	bastide_register(BAST_VA_IDESEC, BAST_VA_IDESECAUX, IRQ_IDE1);
+
 	return 0;
 }
 
diff --git a/drivers/ide/arm/palm_bk3710.c b/drivers/ide/arm/palm_bk3710.c
index c306997..8e1f6bd 100644
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -311,15 +311,37 @@ static void __devinit palm_bk3710_chipinit(void __iomem *base)
 	palm_bk3710_setpiomode(base, NULL, 0, 600, 0);
 	palm_bk3710_setpiomode(base, NULL, 1, 600, 0);
 }
+
+static u8 __devinit palm_bk3710_cable_detect(ide_hwif_t *hwif)
+{
+	return ATA_CBL_PATA80;
+}
+
+static void __devinit palm_bk3710_init_hwif(ide_hwif_t *hwif)
+{
+	hwif->set_pio_mode = palm_bk3710_set_pio_mode;
+	hwif->set_dma_mode = palm_bk3710_set_dma_mode;
+
+	hwif->cable_detect = palm_bk3710_cable_detect;
+}
+
+static const struct ide_port_info __devinitdata palm_bk3710_port_info = {
+	.init_hwif		= palm_bk3710_init_hwif,
+	.host_flags		= IDE_HFLAG_NO_DMA, /* hack (no PCI) */
+	.pio_mask		= ATA_PIO4,
+	.udma_mask		= ATA_UDMA4,	/* (input clk 99MHz) */
+	.mwdma_mask		= ATA_MWDMA2,
+};
+
 static int __devinit palm_bk3710_probe(struct platform_device *pdev)
 {
-	hw_regs_t ide_ctlr_info;
-	int index = 0;
-	int pribase;
 	struct clk *clkp;
 	struct resource *mem, *irq;
 	ide_hwif_t *hwif;
 	void __iomem *base;
+	int pribase, i;
+	hw_regs_t hw;
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	clkp = clk_get(NULL, "IDECLK");
 	if (IS_ERR(clkp))
@@ -330,7 +352,7 @@ static int __devinit palm_bk3710_probe(struct platform_device *pdev)
 	ide_palm_clk = clk_get_rate(ideclkp)/100000;
 	ide_palm_clk = (10000/ide_palm_clk) + 1;
 	/* Register the IDE interface with Linux ATA Interface */
-	memset(&ide_ctlr_info, 0, sizeof(ide_ctlr_info));
+	memset(&hw, 0, sizeof(hw));
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (mem == NULL) {
@@ -349,32 +371,42 @@ static int __devinit palm_bk3710_probe(struct platform_device *pdev)
 	palm_bk3710_chipinit(base);
 
 	pribase = mem->start + IDE_PALM_ATA_PRI_REG_OFFSET;
-	for (index = 0; index < IDE_NR_PORTS - 2; index++)
-		ide_ctlr_info.io_ports[index] = pribase + index;
-	ide_ctlr_info.io_ports[IDE_CONTROL_OFFSET] = mem->start +
+	for (i = 0; i < IDE_NR_PORTS - 2; i++)
+		hw.io_ports[i] = pribase + i;
+	hw.io_ports[IDE_CONTROL_OFFSET] = mem->start +
 			IDE_PALM_ATA_PRI_CTL_OFFSET;
-	ide_ctlr_info.irq = irq->start;
-	ide_ctlr_info.chipset = ide_palm3710;
+	hw.irq = irq->start;
+	hw.chipset = ide_palm3710;
 
-	if (ide_register_hw(&ide_ctlr_info, NULL, &hwif) < 0) {
-		printk(KERN_WARNING "Palm Chip BK3710 IDE Register Fail\n");
-		return -ENODEV;
-	}
+	hwif = ide_deprecated_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	if (hwif == NULL)
+		goto out;
+
+	i = hwif->index;
+
+	if (hwif->present)
+		ide_unregister(i, 0, 0);
+	else if (!hwif->hold)
+		ide_init_port_data(hwif, i);
+
+	ide_init_port_hw(hwif, &hw);
 
-	hwif->set_pio_mode = &palm_bk3710_set_pio_mode;
-	hwif->set_dma_mode = &palm_bk3710_set_dma_mode;
 	hwif->mmio = 1;
 	default_hwif_mmiops(hwif);
-	hwif->cbl = ATA_CBL_PATA80;
-	hwif->ultra_mask = 0x1f;	/* Ultra DMA Mode 4 Max
-						(input clk 99MHz) */
-	hwif->mwdma_mask = 0x7;
-	hwif->drives[0].autotune = 1;
-	hwif->drives[1].autotune = 1;
 
 	ide_setup_dma(hwif, mem->start);
 
+	idx[0] = i;
+
+	ide_device_add(idx, &palm_bk3710_port_info);
+
+	if (!hwif->present)
+		goto out;
+
 	return 0;
+out:
+	printk(KERN_WARNING "Palm Chip BK3710 IDE Register Fail\n");
+	return -ENODEV;
 }
 
 static struct platform_driver platform_bk_driver = {
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 5e42c19..354c91d 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1555,7 +1555,7 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 	if (stat)
 		return stat;
 
-	toc->hdr.toc_length = ntohs (toc->hdr.toc_length);
+	toc->hdr.toc_length = be16_to_cpu(toc->hdr.toc_length);
 
 	if (info->cd_flags & IDE_CD_FLAG_TOCTRACKS_AS_BCD) {
 		toc->hdr.first_track = BCD2BIN(toc->hdr.first_track);
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 3c69822..aed8b31 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -590,20 +590,24 @@ static ide_proc_entry_t idedisk_proc[] = {
 static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
 {
 	ide_drive_t *drive = q->queuedata;
-	ide_task_t task;
+	ide_task_t *task = kmalloc(sizeof(*task), GFP_ATOMIC);
 
-	memset(&task, 0, sizeof(task));
+	/* FIXME: map struct ide_taskfile on rq->cmd[] */
+	BUG_ON(task == NULL);
+
+	memset(task, 0, sizeof(*task));
 	if (ide_id_has_flush_cache_ext(drive->id) &&
 	    (drive->capacity64 >= (1UL << 28)))
-		task.tf.command = WIN_FLUSH_CACHE_EXT;
+		task->tf.command = WIN_FLUSH_CACHE_EXT;
 	else
-		task.tf.command = WIN_FLUSH_CACHE;
-	task.tf_flags	= IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE;
-	task.data_phase	= TASKFILE_NO_DATA;
+		task->tf.command = WIN_FLUSH_CACHE;
+	task->tf_flags	 = IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE |
+			   IDE_TFLAG_DYN;
+	task->data_phase = TASKFILE_NO_DATA;
 
 	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
 	rq->cmd_flags |= REQ_SOFTBARRIER;
-	rq->special = &task;
+	rq->special = task;
 }
 
 /*
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index a4bb328..d0e7b53 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -198,7 +198,7 @@ int ide_build_sglist(ide_drive_t *drive, struct request *rq)
 
 EXPORT_SYMBOL_GPL(ide_build_sglist);
 
-#ifdef CONFIG_BLK_DEV_IDEDMA_PCI
+#ifdef CONFIG_BLK_DEV_IDEDMA_SFF
 /**
  *	ide_build_dmatable	-	build IDE DMA table
  *
@@ -316,7 +316,7 @@ void ide_destroy_dmatable (ide_drive_t *drive)
 
 EXPORT_SYMBOL_GPL(ide_destroy_dmatable);
 
-#ifdef CONFIG_BLK_DEV_IDEDMA_PCI
+#ifdef CONFIG_BLK_DEV_IDEDMA_SFF
 /**
  *	config_drive_for_dma	-	attempt to activate IDE DMA
  *	@drive: the drive to place in DMA mode
@@ -424,7 +424,7 @@ void ide_dma_host_set(ide_drive_t *drive, int on)
 }
 
 EXPORT_SYMBOL_GPL(ide_dma_host_set);
-#endif /* CONFIG_BLK_DEV_IDEDMA_PCI */
+#endif /* CONFIG_BLK_DEV_IDEDMA_SFF  */
 
 /**
  *	ide_dma_off_quietly	-	Generic DMA kill
@@ -474,7 +474,7 @@ void ide_dma_on(ide_drive_t *drive)
 	drive->hwif->dma_host_set(drive, 1);
 }
 
-#ifdef CONFIG_BLK_DEV_IDEDMA_PCI
+#ifdef CONFIG_BLK_DEV_IDEDMA_SFF
 /**
  *	ide_dma_setup	-	begin a DMA phase
  *	@drive: target device
@@ -591,7 +591,7 @@ static int __ide_dma_test_irq(ide_drive_t *drive)
 }
 #else
 static inline int config_drive_for_dma(ide_drive_t *drive) { return 0; }
-#endif /* CONFIG_BLK_DEV_IDEDMA_PCI */
+#endif /* CONFIG_BLK_DEV_IDEDMA_SFF */
 
 int __ide_dma_bad_drive (ide_drive_t *drive)
 {
@@ -840,7 +840,7 @@ void ide_check_dma_crc(ide_drive_t *drive)
 		ide_dma_on(drive);
 }
 
-#ifdef CONFIG_BLK_DEV_IDEDMA_PCI
+#ifdef CONFIG_BLK_DEV_IDEDMA_SFF
 void ide_dma_lost_irq (ide_drive_t *drive)
 {
 	printk("%s: DMA interrupt recovery\n", drive->name);
@@ -1002,4 +1002,4 @@ void ide_setup_dma(ide_hwif_t *hwif, unsigned long base)
 }
 
 EXPORT_SYMBOL_GPL(ide_setup_dma);
-#endif /* CONFIG_BLK_DEV_IDEDMA_PCI */
+#endif /* CONFIG_BLK_DEV_IDEDMA_SFF */
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 3addbe4..7153796 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -361,17 +361,21 @@ void ide_end_drive_cmd (ide_drive_t *drive, u8 stat, u8 err)
 	spin_unlock_irqrestore(&ide_lock, flags);
 
 	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
-		ide_task_t *args = (ide_task_t *) rq->special;
+		ide_task_t *task = (ide_task_t *)rq->special;
+
 		if (rq->errors == 0)
-			rq->errors = !OK_STAT(stat,READY_STAT,BAD_STAT);
-			
-		if (args) {
-			struct ide_taskfile *tf = &args->tf;
+			rq->errors = !OK_STAT(stat, READY_STAT, BAD_STAT);
+
+		if (task) {
+			struct ide_taskfile *tf = &task->tf;
 
 			tf->error = err;
 			tf->status = stat;
 
-			ide_tf_read(drive, args);
+			ide_tf_read(drive, task);
+
+			if (task->tf_flags & IDE_TFLAG_DYN)
+				kfree(task);
 		}
 	} else if (blk_pm_request(rq)) {
 		struct request_pm_state *pm = rq->data;
@@ -388,7 +392,8 @@ void ide_end_drive_cmd (ide_drive_t *drive, u8 stat, u8 err)
 	spin_lock_irqsave(&ide_lock, flags);
 	HWGROUP(drive)->rq = NULL;
 	rq->errors = err;
-	if (__blk_end_request(rq, (rq->errors ? -EIO : 0), 0))
+	if (unlikely(__blk_end_request(rq, (rq->errors ? -EIO : 0),
+				       blk_rq_bytes(rq))))
 		BUG();
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index c32e759..c419266 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -786,15 +786,11 @@ static void __ide_set_handler (ide_drive_t *drive, ide_handler_t *handler,
 {
 	ide_hwgroup_t *hwgroup = HWGROUP(drive);
 
-	if (hwgroup->handler != NULL) {
-		printk(KERN_CRIT "%s: ide_set_handler: handler not null; "
-			"old=%p, new=%p\n",
-			drive->name, hwgroup->handler, handler);
-	}
+	BUG_ON(hwgroup->handler);
 	hwgroup->handler	= handler;
 	hwgroup->expiry		= expiry;
 	hwgroup->timer.expires	= jiffies + timeout;
-	hwgroup->req_gen_timer = hwgroup->req_gen;
+	hwgroup->req_gen_timer	= hwgroup->req_gen;
 	add_timer(&hwgroup->timer);
 }
 
@@ -827,11 +823,9 @@ void ide_execute_command(ide_drive_t *drive, u8 cmd, ide_handler_t *handler,
 			 unsigned timeout, ide_expiry_t *expiry)
 {
 	unsigned long flags;
-	ide_hwgroup_t *hwgroup = HWGROUP(drive);
 	ide_hwif_t *hwif = HWIF(drive);
 
 	spin_lock_irqsave(&ide_lock, flags);
-	BUG_ON(hwgroup->handler);
 	__ide_set_handler(drive, handler, timeout, expiry);
 	hwif->OUTBSYNC(drive, cmd, IDE_COMMAND_REG);
 	/*
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index 1ff676c..29e2c97 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -21,15 +21,6 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
-/*
- *	IDE library routines. These are plug in code that most 
- *	drivers can use but occasionally may be weird enough
- *	to want to do their own thing with
- *
- *	Add common non I/O op stuff here. Make sure it has proper
- *	kernel-doc function headers or your patch will be rejected
- */
-
 static const char *udma_str[] =
 	 { "UDMA/16", "UDMA/25",  "UDMA/33",  "UDMA/44",
 	   "UDMA/66", "UDMA/100", "UDMA/133", "UDMA7" };
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 6daea89..4a2cb28 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1051,7 +1051,7 @@ static int init_irq (ide_hwif_t *hwif)
 		int sa = 0;
 #if defined(__mc68000__)
 		sa = IRQF_SHARED;
-#endif /* __mc68000__ || CONFIG_APUS */
+#endif /* __mc68000__ */
 
 		if (IDE_CHIPSET_IS_PCI(hwif->chipset))
 			sa = IRQF_SHARED;
@@ -1355,7 +1355,7 @@ static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
 	hwif->ultra_mask = d->udma_mask;
 
 	/* reset DMA masks only for SFF-style DMA controllers */
-	if ((d->host_flags && IDE_HFLAG_NO_DMA) == 0 && hwif->dma_base == 0)
+	if ((d->host_flags & IDE_HFLAG_NO_DMA) == 0 && hwif->dma_base == 0)
 		hwif->swdma_mask = hwif->mwdma_mask = hwif->ultra_mask = 0;
 
 	if (d->host_flags & IDE_HFLAG_RQSIZE_256)
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 49dd2e7..0598ecf 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -466,9 +466,6 @@ static void ide_tape_put(struct ide_tape_obj *tape)
 /* 0 = no tape is loaded, so we don't rewind after ejecting */
 #define IDETAPE_MEDIUM_PRESENT		9
 
-/* A define for the READ BUFFER command */
-#define IDETAPE_RETRIEVE_FAULTY_BLOCK	6
-
 /* Some defines for the SPACE command */
 #define IDETAPE_SPACE_OVER_FILEMARK	1
 #define IDETAPE_SPACE_TO_EOD		3
@@ -490,7 +487,6 @@ enum {
 	REQ_IDETAPE_PC2		= (1 << 1), /* packet command (second stage) */
 	REQ_IDETAPE_READ	= (1 << 2),
 	REQ_IDETAPE_WRITE	= (1 << 3),
-	REQ_IDETAPE_READ_BUFFER	= (1 << 4),
 };
 
 /* Error codes returned in rq->errors to the higher part of the driver. */
@@ -1523,29 +1519,6 @@ static void idetape_create_read_cmd(idetape_tape_t *tape, idetape_pc_t *pc,
 		set_bit(PC_DMA_RECOMMENDED, &pc->flags);
 }
 
-static void idetape_create_read_buffer_cmd(idetape_tape_t *tape,
-		idetape_pc_t *pc, struct idetape_bh *bh)
-{
-	int size = 32768;
-	struct idetape_bh *p = bh;
-
-	idetape_init_pc(pc);
-	pc->c[0] = READ_BUFFER;
-	pc->c[1] = IDETAPE_RETRIEVE_FAULTY_BLOCK;
-	pc->c[7] = size >> 8;
-	pc->c[8] = size & 0xff;
-	pc->callback = &idetape_pc_callback;
-	pc->bh = bh;
-	atomic_set(&bh->b_count, 0);
-	pc->buffer = NULL;
-	while (p) {
-		atomic_set(&p->b_count, 0);
-		p = p->b_reqnext;
-	}
-	pc->request_transfer = size;
-	pc->buffer_size = size;
-}
-
 static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc,
 		unsigned int length, struct idetape_bh *bh)
 {
@@ -1655,13 +1628,6 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 					 (struct idetape_bh *)rq->special);
 		goto out;
 	}
-	if (rq->cmd[0] & REQ_IDETAPE_READ_BUFFER) {
-		tape->postpone_cnt = 0;
-		pc = idetape_next_pc_storage(drive);
-		idetape_create_read_buffer_cmd(tape, pc,
-				(struct idetape_bh *)rq->special);
-		goto out;
-	}
 	if (rq->cmd[0] & REQ_IDETAPE_PC1) {
 		pc = (idetape_pc_t *) rq->buffer;
 		rq->cmd[0] &= ~(REQ_IDETAPE_PC1);
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index ad0e995..4a8952a 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -44,8 +44,6 @@
  *  inspiration from lots of linux users, esp.  hamish@zot.apana.org.au
  */
 
-#define	REVISION	"Revision: 7.00alpha2"
-
 #define _IDE_C			/* Tell ide.h it's really us */
 
 #include <linux/module.h>
@@ -1618,7 +1616,7 @@ static int __init ide_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO "Uniform Multi-Platform E-IDE driver " REVISION "\n");
+	printk(KERN_INFO "Uniform Multi-Platform E-IDE driver\n");
 	system_bus_speed = ide_system_bus_speed();
 
 	printk(KERN_INFO "ide: Assuming %dMHz system bus speed "
diff --git a/drivers/ide/legacy/gayle.c b/drivers/ide/legacy/gayle.c
index 9d3851d..b7d8109 100644
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -94,7 +94,7 @@ static int gayle_ack_intr_a1200(ide_hwif_t *hwif)
 
 static void __init gayle_setup_ports(hw_regs_t *hw, unsigned long base,
 				     unsigned long ctl, unsigned long irq_port,
-				     ide_ack_intr_t *ack_intr);
+				     ide_ack_intr_t *ack_intr)
 {
 	int i;
 
diff --git a/drivers/ide/pci/cs5520.c b/drivers/ide/pci/cs5520.c
index 0be1a82..1c163e4 100644
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -147,11 +147,6 @@ static int __devinit cs5520_init_one(struct pci_dev *dev, const struct pci_devic
 
 	/* We must not grab the entire device, it has 'ISA' space in its
 	 * BARS too and we will freak out other bits of the kernel
-	 *
-	 * pci_enable_device_bars() is going away. I replaced it with
-	 * IO only enable for now but I'll need confirmation this is
-	 * allright for that device. If not, it will need some kind of
-	 * quirk. --BenH.
 	 */
 	if (pci_enable_device_io(dev)) {
 		printk(KERN_WARNING "%s: Unable to enable 55x0.\n", d->name);
diff --git a/drivers/ide/pci/pdc202xx_old.c b/drivers/ide/pci/pdc202xx_old.c
index da43297..150422e 100644
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -3,26 +3,6 @@
  *  Copyright (C) 2006-2007		MontaVista Software, Inc.
  *  Copyright (C) 2007			Bartlomiej Zolnierkiewicz
  *
- *  Promise Ultra33 cards with BIOS v1.20 through 1.28 will need this
- *  compiled into the kernel if you have more than one card installed.
- *  Note that BIOS v1.29 is reported to fix the problem.  Since this is
- *  safe chipset tuning, including this support is harmless
- *
- *  Promise Ultra66 cards with BIOS v1.11 this
- *  compiled into the kernel if you have more than one card installed.
- *
- *  Promise Ultra100 cards.
- *
- *  The latest chipset code will support the following ::
- *  Three Ultra33 controllers and 12 drives.
- *  8 are UDMA supported and 4 are limited to DMA mode 2 multi-word.
- *  The 8/4 ratio is a BIOS code limit by promise.
- *
- *  UNLESS you enable "CONFIG_PDC202XX_BURST"
- *
- */
-
-/*
  *  Portions Copyright (C) 1999 Promise Technology, Inc.
  *  Author: Frank Tiernan (frankt@promise.com)
  *  Released under terms of General Public License
@@ -344,7 +324,6 @@ static void __devinit init_dma_pdc202xx(ide_hwif_t *hwif, unsigned long dmabase)
 		(primary_mode & 1) ? "MASTER" : "PCI",
 		(secondary_mode & 1) ? "MASTER" : "PCI" );
 
-#ifdef CONFIG_PDC202XX_BURST
 	if (!(udma_speed_flag & 1)) {
 		printk(KERN_INFO "%s: FORCING BURST BIT 0x%02x->0x%02x ",
 			hwif->cds->name, udma_speed_flag,
@@ -352,7 +331,6 @@ static void __devinit init_dma_pdc202xx(ide_hwif_t *hwif, unsigned long dmabase)
 		outb(udma_speed_flag | 1, dmabase | 0x1f);
 		printk("%sACTIVE\n", (inb(dmabase | 0x1f) & 1) ? "" : "IN");
 	}
-#endif /* CONFIG_PDC202XX_BURST */
 
 	ide_setup_dma(hwif, dmabase);
 }
diff --git a/include/linux/ide.h b/include/linux/ide.h
index acec99d..23fad89 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -906,6 +906,8 @@ enum {
 					  IDE_TFLAG_IN_DEVICE,
 	/* force 16-bit I/O operations */
 	IDE_TFLAG_IO_16BIT		= (1 << 30),
+	/* ide_task_t was allocated using kmalloc() */
+	IDE_TFLAG_DYN			= (1 << 31),
 };
 
 struct ide_taskfile {
@@ -998,8 +1000,7 @@ extern int __ide_pci_register_driver(struct pci_driver *driver, struct module *o
 void ide_pci_setup_ports(struct pci_dev *, const struct ide_port_info *, int, u8 *);
 void ide_setup_pci_noise(struct pci_dev *, const struct ide_port_info *);
 
-/* FIXME: palm_bk3710 uses BLK_DEV_IDEDMA_PCI without BLK_DEV_IDEPCI! */
-#if defined(CONFIG_BLK_DEV_IDEPCI) && defined(CONFIG_BLK_DEV_IDEDMA_PCI)
+#ifdef CONFIG_BLK_DEV_IDEDMA_PCI
 void ide_hwif_setup_dma(ide_hwif_t *, const struct ide_port_info *);
 #else
 static inline void ide_hwif_setup_dma(ide_hwif_t *hwif,
@@ -1146,7 +1147,7 @@ ide_startstop_t ide_dma_intr(ide_drive_t *);
 int ide_build_sglist(ide_drive_t *, struct request *);
 void ide_destroy_dmatable(ide_drive_t *);
 
-#ifdef CONFIG_BLK_DEV_IDEDMA_PCI
+#ifdef CONFIG_BLK_DEV_IDEDMA_SFF
 extern int ide_build_dmatable(ide_drive_t *, struct request *);
 extern int ide_release_dma(ide_hwif_t *);
 extern void ide_setup_dma(ide_hwif_t *, unsigned long);
@@ -1157,7 +1158,7 @@ extern void ide_dma_start(ide_drive_t *);
 extern int __ide_dma_end(ide_drive_t *);
 extern void ide_dma_lost_irq(ide_drive_t *);
 extern void ide_dma_timeout(ide_drive_t *);
-#endif /* CONFIG_BLK_DEV_IDEDMA_PCI */
+#endif /* CONFIG_BLK_DEV_IDEDMA_SFF */
 
 #else
 static inline int ide_id_dma_bug(ide_drive_t *drive) { return 0; }
@@ -1171,7 +1172,7 @@ static inline int ide_set_dma(ide_drive_t *drive) { return 1; }
 static inline void ide_check_dma_crc(ide_drive_t *drive) { ; }
 #endif /* CONFIG_BLK_DEV_IDEDMA */
 
-#ifndef CONFIG_BLK_DEV_IDEDMA_PCI
+#ifndef CONFIG_BLK_DEV_IDEDMA_SFF
 static inline void ide_release_dma(ide_hwif_t *drive) {;}
 #endif
 
