Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbYLHQ44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbYLHQ44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 11:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbYLHQ4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 11:56:45 -0500
Received: from gv-out-0910.google.com ([216.239.58.186]:40177 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbYLHQ4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 11:56:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=CkM4riLRlFIbQu2Swje1R6a+4VnG6d9mLMEBAcYoNkPYuUNZ4n4J8xHGh6pZJ08fns
         sljIfSbJm7oeL3ac46dJIuCjKcPtk5ctTrxCa/ZWnDzgzluXIn4lOwEBApbT/WGB6zYb
         gwUdUeYyotCoK5dQ27w7zQBQFkWWNoKm5EnCg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE fixes
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Mon, 8 Dec 2008 17:55:12 +0100
Message-Id: <200812081755.13024.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id mB8Gv0dq014594


Linus, please pull from:
master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/
to receive the following updates:
 drivers/ide/Kconfig  |   14 +++----------- drivers/ide/ide-io.c |    6 ++++-- drivers/ide/pmac.c   |   30 +++--------------------------- 3 files changed, 10 insertions(+), 40 deletions(-)

Bartlomiej Zolnierkiewicz (2):      Revert "ide: respect current DMA setting during resume"      ide: build-fix for CONFIG_BLK_DEV_IDEDMA_PMAC=n

diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfigindex 6d74017..e6857e0 100644--- a/drivers/ide/Kconfig+++ b/drivers/ide/Kconfig@@ -669,10 +669,12 @@ config BLK_DEV_CELLEB  endif +# TODO: BLK_DEV_IDEDMA_PCI -> BLK_DEV_IDEDMA_SFF config BLK_DEV_IDE_PMAC 	tristate "PowerMac on-board IDE support" 	depends on PPC_PMAC && IDE=y 	select IDE_TIMINGS+	select BLK_DEV_IDEDMA_PCI 	help 	  This driver provides support for the on-board IDE controller on 	  most of the recent Apple Power Macintoshes and PowerBooks.@@ -689,16 +691,6 @@ config BLK_DEV_IDE_PMAC_ATA100FIRST 	  CD-ROM on hda. This option changes this to more natural hda for 	  hard disk and hdc for CD-ROM. -config BLK_DEV_IDEDMA_PMAC-	bool "PowerMac IDE DMA support"-	depends on BLK_DEV_IDE_PMAC-	select BLK_DEV_IDEDMA_PCI-	help-	  This option allows the driver for the on-board IDE controller on-	  Power Macintoshes and PowerBooks to use DMA (direct memory access)-	  to transfer data to and from memory.  Saying Y is safe and improves-	  performance.- config BLK_DEV_IDE_AU1XXX        bool "IDE for AMD Alchemy Au1200"        depends on SOC_AU1200@@ -912,7 +904,7 @@ config BLK_DEV_UMC8672 endif  config BLK_DEV_IDEDMA-	def_bool BLK_DEV_IDEDMA_SFF || BLK_DEV_IDEDMA_PMAC || \+	def_bool BLK_DEV_IDEDMA_SFF || \ 		 BLK_DEV_IDEDMA_ICS || BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA  endif # IDEdiff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.cindex 7d275b2..cc35d6d 100644--- a/drivers/ide/ide-io.c+++ b/drivers/ide/ide-io.c@@ -208,8 +208,10 @@ static ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request * 		 */ 		if (drive->hwif->dma_ops == NULL) 			break;-		if (drive->dev_flags & IDE_DFLAG_USING_DMA)-			ide_set_dma(drive);+		/*+		 * TODO: respect IDE_DFLAG_USING_DMA+		 */+		ide_set_dma(drive); 		break; 	} diff --git a/drivers/ide/pmac.c b/drivers/ide/pmac.cindex 2e19d62..7c481bb 100644--- a/drivers/ide/pmac.c+++ b/drivers/ide/pmac.c@@ -66,7 +66,6 @@ typedef struct pmac_ide_hwif { 	struct macio_dev		*mdev; 	u32				timings[4]; 	volatile u32 __iomem *		*kauai_fcr;-#ifdef CONFIG_BLK_DEV_IDEDMA_PMAC 	/* Those fields are duplicating what is in hwif. We currently 	 * can't use the hwif ones because of some assumptions that are 	 * beeing done by the generic code about the kind of dma controller@@ -74,8 +73,6 @@ typedef struct pmac_ide_hwif { 	 */ 	volatile struct dbdma_regs __iomem *	dma_regs; 	struct dbdma_cmd*		dma_table_cpu;-#endif-	 } pmac_ide_hwif_t;  enum {@@ -222,8 +219,6 @@ static const char* model_name[] = { #define KAUAI_FCR_UATA_RESET_N		0x00000002 #define KAUAI_FCR_UATA_ENABLE		0x00000001 -#ifdef CONFIG_BLK_DEV_IDEDMA_PMAC- /* Rounded Multiword DMA timings  *   * I gave up finding a generic formula for all controller@@ -413,8 +408,6 @@ static int pmac_ide_build_dmatable(ide_drive_t *drive, struct request *rq); static void pmac_ide_selectproc(ide_drive_t *drive); static void pmac_ide_kauai_selectproc(ide_drive_t *drive); -#endif /* CONFIG_BLK_DEV_IDEDMA_PMAC */- #define PMAC_IDE_REG(x) \ 	((void __iomem *)((drive)->hwif->io_ports.data_addr + (x))) @@ -584,8 +577,6 @@ pmac_ide_set_pio_mode(ide_drive_t *drive, const u8 pio) 	pmac_ide_do_update_timings(drive); } -#ifdef CONFIG_BLK_DEV_IDEDMA_PMAC- /*  * Calculate KeyLargo ATA/66 UDMA timings  */@@ -786,7 +777,6 @@ set_timings_mdma(ide_drive_t *drive, int intf_type, u32 *timings, u32 *timings2, 		drive->name, speed & 0xf,  *timings); #endif	 }-#endif /* #ifdef CONFIG_BLK_DEV_IDEDMA_PMAC */  static void pmac_ide_set_dma_mode(ide_drive_t *drive, const u8 speed) {@@ -804,7 +794,6 @@ static void pmac_ide_set_dma_mode(ide_drive_t *drive, const u8 speed) 	tl[0] = *timings; 	tl[1] = *timings2; -#ifdef CONFIG_BLK_DEV_IDEDMA_PMAC 	if (speed >= XFER_UDMA_0) { 		if (pmif->kind == controller_kl_ata4) 			ret = set_timings_udma_ata4(&tl[0], speed);@@ -817,7 +806,7 @@ static void pmac_ide_set_dma_mode(ide_drive_t *drive, const u8 speed) 			ret = -1; 	} else 		set_timings_mdma(drive, pmif->kind, &tl[0], &tl[1], speed);-#endif /* CONFIG_BLK_DEV_IDEDMA_PMAC */+ 	if (ret) 		return; @@ -1008,9 +997,7 @@ static const struct ide_port_info pmac_port_info = { 	.chipset		= ide_pmac, 	.tp_ops			= &pmac_tp_ops, 	.port_ops		= &pmac_ide_port_ops,-#ifdef CONFIG_BLK_DEV_IDEDMA_PMAC 	.dma_ops		= &pmac_dma_ops,-#endif 	.host_flags		= IDE_HFLAG_SET_PIO_MODE_KEEP_DMA | 				  IDE_HFLAG_POST_SET_MODE | 				  IDE_HFLAG_MMIO |@@ -1182,7 +1169,7 @@ pmac_ide_macio_attach(struct macio_dev *mdev, const struct of_device_id *match) 	pmif->regbase = regbase; 	pmif->irq = irq; 	pmif->kauai_fcr = NULL;-#ifdef CONFIG_BLK_DEV_IDEDMA_PMAC+ 	if (macio_resource_count(mdev) >= 2) { 		if (macio_request_resource(mdev, 1, "ide-pmac (dma)")) 			printk(KERN_WARNING "ide-pmac: can't request DMA "@@ -1192,7 +1179,7 @@ pmac_ide_macio_attach(struct macio_dev *mdev, const struct of_device_id *match) 			pmif->dma_regs = ioremap(macio_resource_start(mdev, 1), 0x1000); 	} else 		pmif->dma_regs = NULL;-#endif /* CONFIG_BLK_DEV_IDEDMA_PMAC */+ 	dev_set_drvdata(&mdev->ofdev.dev, pmif);  	memset(&hw, 0, sizeof(hw));@@ -1300,9 +1287,7 @@ pmac_ide_pci_attach(struct pci_dev *pdev, const struct pci_device_id *id)  	base = ioremap(rbase, rlen); 	pmif->regbase = (unsigned long) base + 0x2000;-#ifdef CONFIG_BLK_DEV_IDEDMA_PMAC 	pmif->dma_regs = base + 0x1000;-#endif /* CONFIG_BLK_DEV_IDEDMA_PMAC */ 	pmif->kauai_fcr = base; 	pmif->irq = pdev->irq; @@ -1434,8 +1419,6 @@ out: 	return error; } -#ifdef CONFIG_BLK_DEV_IDEDMA_PMAC- /*  * pmac_ide_build_dmatable builds the DBDMA command list  * for a transfer and sets the DBDMA channel to point to it.@@ -1723,13 +1706,6 @@ static int __devinit pmac_ide_init_dma(ide_hwif_t *hwif,  	return 0; }-#else-static int __devinit pmac_ide_init_dma(ide_hwif_t *hwif,-				       const struct ide_port_info *d)-{-	return -EOPNOTSUPP;-}-#endif /* CONFIG_BLK_DEV_IDEDMA_PMAC */  module_init(pmac_ide_probe);  ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
