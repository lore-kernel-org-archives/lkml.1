Return-Path: <linux-kernel-owner+w=401wt.eu-S1751747AbXBOXeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbXBOXeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbXBOXeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:34:16 -0500
Received: from havoc.gtf.org ([69.61.125.42]:56428 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbXBOXeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:34:13 -0500
Date: Thu, 15 Feb 2007 18:34:11 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [git patches] libata updates (mostly fixes)
Message-ID: <20070215233411.GA10782@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The pile that was waiting for post-conference, largely bug fixes.

As mentioned in the last push, were two other push points planned for
2.6.21:
1) merge libata support for ACPI
2) Remove ugly combined mode hacks in libata-sff and pci/quirks, now
   that old-IDE and libata have the necessary improvements.

Depending on timing and the devres bug count, I may push #2 back to
2.6.22.  The sum of devres + ACPI + remove-combined-mode-quirks
might be more change than should be in 2.6.21.

Both ACPI and remove-combined-quirks are ready to be pushed, it's just a
matter of staging.  Comments welcome.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 arch/ia64/Kconfig                 |    1 +
 drivers/ata/libata-core.c         |   11 ++++++-
 drivers/ata/pata_legacy.c         |   11 +++++-
 drivers/ata/pata_qdi.c            |    4 ++-
 drivers/ata/pata_sl82c105.c       |    3 ++
 drivers/ata/sata_nv.c             |    6 +++-
 drivers/ata/sata_promise.c        |   64 +++++++------------------------------
 drivers/ata/sata_vsc.c            |    8 +++-
 include/asm-ia64/libata-portmap.h |   12 +++++++
 include/linux/ata.h               |    2 +-
 include/linux/libata.h            |    1 +
 11 files changed, 63 insertions(+), 60 deletions(-)
 create mode 100644 include/asm-ia64/libata-portmap.h

Alan Cox (1):
      libata: Add a host flag to indicate lack of IORDY capability

Mikael Pettersson (2):
      sata_promise: fix missing PATA cable detection
      sata_promise: new EH conversion for 20619 chips, take 2

Nate Dailey (1):
      sata_vsc: use default cache line size if non-zero

Olaf Hering (1):
      add delay around sl82c105_reset_engine calls

Robert Hancock (1):
      sata_nv: handle SError status indication

Tejun Heo (2):
      libata: fix drive side 80c cable check, take 3
      libata: clear TF before IDENTIFYing

Zhang, Yanmin (1):
      ATA convert GSI to irq on ia64

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index db185f3..d51f0f1 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -22,6 +22,7 @@ config IA64
 
 config 64BIT
 	bool
+	select ATA_NONSTANDARD if ATA
 	default y
 
 config ZONE_DMA
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 25d8d3f..2cf8251 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1410,7 +1410,16 @@ int ata_dev_read_id(struct ata_device *dev, unsigned int *p_class,
 	}
 
 	tf.protocol = ATA_PROT_PIO;
-	tf.flags |= ATA_TFLAG_POLLING; /* for polling presence detection */
+
+	/* Some devices choke if TF registers contain garbage.  Make
+	 * sure those are properly initialized.
+	 */
+	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
+
+	/* Device presence detection is unreliable on some
+	 * controllers.  Always poll IDENTIFY if available.
+	 */
+	tf.flags |= ATA_TFLAG_POLLING;
 
 	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_FROM_DEVICE,
 				     id, sizeof(id[0]) * ATA_ID_WORDS);
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 4223e10..98c1fee 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -89,9 +89,10 @@ static int probe_all;			/* Set to check all ISA port ranges */
 static int ht6560a;			/* HT 6560A on primary 1, secondary 2, both 3 */
 static int ht6560b;			/* HT 6560A on primary 1, secondary 2, both 3 */
 static int opti82c611a;			/* Opti82c611A on primary 1, secondary 2, both 3 */
-static int opti82c46x;		/* Opti 82c465MV present (pri/sec autodetect) */
+static int opti82c46x;			/* Opti 82c465MV present (pri/sec autodetect) */
 static int autospeed;			/* Chip present which snoops speed changes */
 static int pio_mask = 0x1F;		/* PIO range for autospeed devices */
+static int iordy_mask = 0xFFFFFFFF;	/* Use iordy if available */
 
 /**
  *	legacy_set_mode		-	mode setting
@@ -113,6 +114,7 @@ static int legacy_set_mode(struct ata_port *ap, struct ata_device **unused)
 	for (i = 0; i < ATA_MAX_DEVICES; i++) {
 		struct ata_device *dev = &ap->device[i];
 		if (ata_dev_enabled(dev)) {
+			ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
 			dev->pio_mode = XFER_PIO_0;
 			dev->xfer_mode = XFER_PIO_0;
 			dev->xfer_shift = ATA_SHIFT_PIO;
@@ -695,6 +697,7 @@ static __init int legacy_init_one(int port, unsigned long io, unsigned long ctrl
 	void __iomem *io_addr, *ctrl_addr;
 	int pio_modes = pio_mask;
 	u32 mask = (1 << port);
+	u32 iordy = (iordy_mask & mask) ? 0: ATA_FLAG_NO_IORDY;
 	int ret;
 
 	pdev = platform_device_register_simple(DRV_NAME, nr_legacy_host, NULL, 0);
@@ -715,6 +718,7 @@ static __init int legacy_init_one(int port, unsigned long io, unsigned long ctrl
 	if (ht6560a & mask) {
 		ops = &ht6560a_port_ops;
 		pio_modes = 0x07;
+		iordy = ATA_FLAG_NO_IORDY;
 	}
 	if (ht6560b & mask) {
 		ops = &ht6560b_port_ops;
@@ -750,6 +754,7 @@ static __init int legacy_init_one(int port, unsigned long io, unsigned long ctrl
 			printk(KERN_INFO "PDC20230-C/20630 VLB ATA controller detected.\n");
 				pio_modes = 0x07;
 			ops = &pdc20230_port_ops;
+			iordy = ATA_FLAG_NO_IORDY;
 			udelay(100);
 			inb(0x1F5);
 		} else {
@@ -767,6 +772,7 @@ static __init int legacy_init_one(int port, unsigned long io, unsigned long ctrl
 	/* Chip does mode setting by command snooping */
 	if (ops == &legacy_port_ops && (autospeed & mask))
 		ops = &simple_port_ops;
+
 	memset(&ae, 0, sizeof(struct ata_probe_ent));
 	INIT_LIST_HEAD(&ae.node);
 	ae.dev = &pdev->dev;
@@ -776,7 +782,7 @@ static __init int legacy_init_one(int port, unsigned long io, unsigned long ctrl
 	ae.pio_mask = pio_modes;
 	ae.irq = irq;
 	ae.irq_flags = 0;
-	ae.port_flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST;
+	ae.port_flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST|iordy;
 	ae.port[0].cmd_addr = io_addr;
 	ae.port[0].altstatus_addr = ctrl_addr;
 	ae.port[0].ctl_addr = ctrl_addr;
@@ -945,6 +951,7 @@ module_param(ht6560b, int, 0);
 module_param(opti82c611a, int, 0);
 module_param(opti82c46x, int, 0);
 module_param(pio_mask, int, 0);
+module_param(iordy_mask, int, 0);
 
 module_init(legacy_init);
 module_exit(legacy_exit);
diff --git a/drivers/ata/pata_qdi.c b/drivers/ata/pata_qdi.c
index 1b3b4ed..4362141 100644
--- a/drivers/ata/pata_qdi.c
+++ b/drivers/ata/pata_qdi.c
@@ -264,16 +264,18 @@ static __init int qdi_init_one(unsigned long port, int type, unsigned long io, i
 	if (type == 6580) {
 		ae.port_ops = &qdi6580_port_ops;
 		ae.pio_mask = 0x1F;
+		ae.port_flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST;
 	} else {
 		ae.port_ops = &qdi6500_port_ops;
 		ae.pio_mask = 0x07;	/* Actually PIO3 !IORDY is possible */
+		ae.port_flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST |
+				ATA_FLAG_NO_IORDY;
 	}
 
 	ae.sht = &qdi_sht;
 	ae.n_ports = 1;
 	ae.irq = irq;
 	ae.irq_flags = 0;
-	ae.port_flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST;
 	ae.port[0].cmd_addr = io_addr;
 	ae.port[0].altstatus_addr = ctl_addr;
 	ae.port[0].ctl_addr = ctl_addr;
diff --git a/drivers/ata/pata_sl82c105.c b/drivers/ata/pata_sl82c105.c
index f2fa158..96e890f 100644
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -187,7 +187,9 @@ static void sl82c105_bmdma_start(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 
+	udelay(100);
 	sl82c105_reset_engine(ap);
+	udelay(100);
 
 	/* Set the clocks for DMA */
 	sl82c105_configure_dmamode(ap, qc->dev);
@@ -216,6 +218,7 @@ static void sl82c105_bmdma_stop(struct ata_queued_cmd *qc)
 
 	ata_bmdma_stop(qc);
 	sl82c105_reset_engine(ap);
+	udelay(100);
 
 	/* This will redo the initial setup of the DMA device to matching
 	   PIO timings */
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 095ef1b..ab92f20 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -827,7 +827,8 @@ static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
 			/* freeze if hotplugged or controller error */
 			if (unlikely(status & (NV_ADMA_STAT_HOTPLUG |
 					       NV_ADMA_STAT_HOTUNPLUG |
-					       NV_ADMA_STAT_TIMEOUT))) {
+					       NV_ADMA_STAT_TIMEOUT |
+					       NV_ADMA_STAT_SERROR))) {
 				struct ata_eh_info *ehi = &ap->eh_info;
 
 				ata_ehi_clear_desc(ehi);
@@ -841,6 +842,9 @@ static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
 				} else if (status & NV_ADMA_STAT_HOTUNPLUG) {
 					ata_ehi_hotplugged(ehi);
 					ata_ehi_push_desc(ehi, ": hot unplug");
+				} else if (status & NV_ADMA_STAT_SERROR) {
+					/* let libata analyze SError and figure out the cause */
+					ata_ehi_push_desc(ehi, ": SError");
 				}
 				ata_port_freeze(ap);
 				continue;
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index b2e2e69..cf9ed8c 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -119,9 +119,7 @@ static u32 pdc_sata_scr_read (struct ata_port *ap, unsigned int sc_reg);
 static void pdc_sata_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val);
 static int pdc_ata_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
 static irqreturn_t pdc_interrupt (int irq, void *dev_instance);
-static void pdc_eng_timeout(struct ata_port *ap);
 static int pdc_port_start(struct ata_port *ap);
-static void pdc_pata_phy_reset(struct ata_port *ap);
 static void pdc_qc_prep(struct ata_queued_cmd *qc);
 static void pdc_tf_load_mmio(struct ata_port *ap, const struct ata_taskfile *tf);
 static void pdc_exec_command_mmio(struct ata_port *ap, const struct ata_taskfile *tf);
@@ -215,12 +213,12 @@ static const struct ata_port_operations pdc_pata_ops = {
 	.dev_select		= ata_std_dev_select,
 	.check_atapi_dma	= pdc_check_atapi_dma,
 
-	.phy_reset		= pdc_pata_phy_reset,
-
 	.qc_prep		= pdc_qc_prep,
 	.qc_issue		= pdc_qc_issue_prot,
+	.freeze			= pdc_freeze,
+	.thaw			= pdc_thaw,
+	.error_handler		= pdc_error_handler,
 	.data_xfer		= ata_data_xfer,
-	.eng_timeout		= pdc_eng_timeout,
 	.irq_handler		= pdc_interrupt,
 	.irq_clear		= pdc_irq_clear,
 	.irq_on			= ata_irq_on,
@@ -253,7 +251,7 @@ static const struct ata_port_info pdc_port_info[] = {
 	/* board_20619 */
 	{
 		.sht		= &pdc_ata_sht,
-		.flags		= PDC_COMMON_FLAGS | ATA_FLAG_SRST | ATA_FLAG_SLAVE_POSS,
+		.flags		= PDC_COMMON_FLAGS | ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
@@ -389,14 +387,6 @@ static void pdc_pata_cbl_detect(struct ata_port *ap)
 		ap->cbl = ATA_CBL_PATA80;
 }
 
-static void pdc_pata_phy_reset(struct ata_port *ap)
-{
-	pdc_pata_cbl_detect(ap);
-	pdc_reset_port(ap);
-	ata_port_probe(ap);
-	ata_bus_reset(ap);
-}
-
 static u32 pdc_sata_scr_read (struct ata_port *ap, unsigned int sc_reg)
 {
 	if (sc_reg > SCR_CONTROL || ap->cbl != ATA_CBL_SATA)
@@ -564,6 +554,13 @@ static void pdc_thaw(struct ata_port *ap)
 	readl(mmio + PDC_CTLSTAT); /* flush */
 }
 
+static int pdc_pre_reset(struct ata_port *ap)
+{
+	if (!sata_scr_valid(ap))
+		pdc_pata_cbl_detect(ap);
+	return ata_std_prereset(ap);
+}
+
 static void pdc_error_handler(struct ata_port *ap)
 {
 	ata_reset_fn_t hardreset;
@@ -576,7 +573,7 @@ static void pdc_error_handler(struct ata_port *ap)
 		hardreset = sata_std_hardreset;
 
 	/* perform recovery */
-	ata_do_eh(ap, ata_std_prereset, ata_std_softreset, hardreset,
+	ata_do_eh(ap, pdc_pre_reset, ata_std_softreset, hardreset,
 		  ata_std_postreset);
 }
 
@@ -592,43 +589,6 @@ static void pdc_post_internal_cmd(struct ata_queued_cmd *qc)
 		pdc_reset_port(ap);
 }
 
-static void pdc_eng_timeout(struct ata_port *ap)
-{
-	struct ata_host *host = ap->host;
-	u8 drv_stat;
-	struct ata_queued_cmd *qc;
-	unsigned long flags;
-
-	DPRINTK("ENTER\n");
-
-	spin_lock_irqsave(&host->lock, flags);
-
-	qc = ata_qc_from_tag(ap, ap->active_tag);
-
-	switch (qc->tf.protocol) {
-	case ATA_PROT_DMA:
-	case ATA_PROT_NODATA:
-		ata_port_printk(ap, KERN_ERR, "command timeout\n");
-		drv_stat = ata_wait_idle(ap);
-		qc->err_mask |= __ac_err_mask(drv_stat);
-		break;
-
-	default:
-		drv_stat = ata_busy_wait(ap, ATA_BUSY | ATA_DRQ, 1000);
-
-		ata_port_printk(ap, KERN_ERR,
-				"unknown timeout, cmd 0x%x stat 0x%x\n",
-				qc->tf.command, drv_stat);
-
-		qc->err_mask |= ac_err_mask(drv_stat);
-		break;
-	}
-
-	spin_unlock_irqrestore(&host->lock, flags);
-	ata_eh_qc_complete(qc);
-	DPRINTK("EXIT\n");
-}
-
 static inline unsigned int pdc_host_intr( struct ata_port *ap,
                                           struct ata_queued_cmd *qc)
 {
diff --git a/drivers/ata/sata_vsc.c b/drivers/ata/sata_vsc.c
index 3d9daf2..2fd037b 100644
--- a/drivers/ata/sata_vsc.c
+++ b/drivers/ata/sata_vsc.c
@@ -346,6 +346,7 @@ static int __devinit vsc_sata_init_one (struct pci_dev *pdev, const struct pci_d
 	struct ata_probe_ent *probe_ent;
 	void __iomem *mmio_base;
 	int rc;
+	u8 cls;
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
@@ -383,9 +384,12 @@ static int __devinit vsc_sata_init_one (struct pci_dev *pdev, const struct pci_d
 	INIT_LIST_HEAD(&probe_ent->node);
 
 	/*
-	 * Due to a bug in the chip, the default cache line size can't be used
+	 * Due to a bug in the chip, the default cache line size can't be
+	 * used (unless the default is non-zero).
 	 */
-	pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE, 0x80);
+	pci_read_config_byte(pdev, PCI_CACHE_LINE_SIZE, &cls);
+	if (cls == 0x00)
+		pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE, 0x80);
 
 	if (pci_enable_msi(pdev) == 0)
 		pci_intx(pdev, 0);
diff --git a/include/asm-ia64/libata-portmap.h b/include/asm-ia64/libata-portmap.h
new file mode 100644
index 0000000..0e00c9a
--- /dev/null
+++ b/include/asm-ia64/libata-portmap.h
@@ -0,0 +1,12 @@
+#ifndef __ASM_IA64_LIBATA_PORTMAP_H
+#define __ASM_IA64_LIBATA_PORTMAP_H
+
+#define ATA_PRIMARY_CMD		0x1F0
+#define ATA_PRIMARY_CTL		0x3F6
+#define ATA_PRIMARY_IRQ(dev)	isa_irq_to_vector(14)
+
+#define ATA_SECONDARY_CMD	0x170
+#define ATA_SECONDARY_CTL	0x376
+#define ATA_SECONDARY_IRQ(dev)	isa_irq_to_vector(15)
+
+#endif
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 18e401f..272736e 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -352,7 +352,7 @@ static inline int ata_drive_40wire(const u16 *dev_id)
 {
 	if (ata_id_major_version(dev_id) >= 5 && ata_id_is_sata(dev_id))
 		return 0;	/* SATA */
-	if (dev_id[93] & 0x4000)
+	if ((dev_id[93] & 0xE000) == 0x6000)
 		return 0;	/* 80 wire */
 	return 1;
 }
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 596e0c1..b870b20 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -172,6 +172,7 @@ enum {
 	ATA_FLAG_DEBUGMSG	= (1 << 13),
 	ATA_FLAG_SETXFER_POLLING= (1 << 14), /* use polling for SETXFER */
 	ATA_FLAG_IGN_SIMPLEX	= (1 << 15), /* ignore SIMPLEX */
+	ATA_FLAG_NO_IORDY	= (1 << 16), /* controller lacks iordy */
 
 	/* The following flag belongs to ap->pflags but is kept in
 	 * ap->flags because it's referenced in many LLDs and will be
