Return-Path: <linux-kernel-owner+w=401wt.eu-S1756925AbYDYFg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbYDYFg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 01:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbYDYFgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 01:36:46 -0400
Received: from havoc.gtf.org ([69.61.125.42]:46562 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461AbYDYFgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 01:36:43 -0400
Date: Fri, 25 Apr 2008 01:36:41 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20080425053641.GA16759@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fixes and a few cleanups, including several critical fixes from Tejun.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c                |   15 +-
 drivers/ata/ata_piix.c            |    1 +
 drivers/ata/libata-acpi.c         |    4 -
 drivers/ata/libata-core.c         |    7 +-
 drivers/ata/libata-eh.c           |    1 +
 drivers/ata/libata-sff.c          |    4 +-
 drivers/ata/libata.h              |    1 -
 drivers/ata/pata_at32.c           |    3 +
 drivers/ata/pata_bf54x.c          |    3 +-
 drivers/ata/pata_ixp4xx_cf.c      |    1 +
 drivers/ata/pata_platform.c       |    1 +
 drivers/ata/pata_rb500_cf.c       |    3 +
 drivers/ata/sata_mv.c             |  583 ++++++++++++++++++-------------------
 drivers/ata/sata_nv.c             |   11 +-
 drivers/ata/sata_sis.c            |   12 +-
 drivers/ide/arm/palm_bk3710.c     |    4 +
 drivers/ide/legacy/ide_platform.c |    2 +
 include/linux/libata.h            |    1 -
 18 files changed, 332 insertions(+), 325 deletions(-)

Adrian Bunk (3):
      libata-acpi.c: remove unneeded #if's
      make sata_print_link_status() static
      make sata_set_spd_needed() static

Dan McGee (1):
      ata_piix: add Asus Eee 701 controller to short cable list

Harvey Harrison (1):
      libata: functions with definition should not be extern

Kay Sievers (1):
      ATA/IDE: fix platform driver hotplug/coldplug

Mark Lord (9):
      libata-eh set tf flags in NCQ EH result_tf
      sata_mv more cosmetics
      sata_mv mask all interrupt coalescing bits
      sata_mv: simplify freeze/thaw bit-shift calculations
      sata_mv: simplify request/response queue handling
      sata_mv: tidy host controller interrupt handling
      sata_mv: more interrupt handling rework
      sata_mv: leave SError bits untouched in mv_err_intr
      sata_mv: re-enable hotplug, update TODO list

Roel Kluin (1):
      pata_bf54x: decrease count first.

Tejun Heo (4):
      sata_sis: SCR accessors return -EINVAL when requested SCR isn't available
      libata: make WARN_ON conditions in ata_sff_hsm_move() more strict
      ahci: retry enabling AHCI a few times before spitting out WARN_ON()
      sata_nv: make hardreset return -EAGAIN on success

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 986e332..7c4f886 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -556,16 +556,27 @@ static inline void __iomem *ahci_port_base(struct ata_port *ap)
 
 static void ahci_enable_ahci(void __iomem *mmio)
 {
+	int i;
 	u32 tmp;
 
 	/* turn on AHCI_EN */
 	tmp = readl(mmio + HOST_CTL);
-	if (!(tmp & HOST_AHCI_EN)) {
+	if (tmp & HOST_AHCI_EN)
+		return;
+
+	/* Some controllers need AHCI_EN to be written multiple times.
+	 * Try a few times before giving up.
+	 */
+	for (i = 0; i < 5; i++) {
 		tmp |= HOST_AHCI_EN;
 		writel(tmp, mmio + HOST_CTL);
 		tmp = readl(mmio + HOST_CTL);	/* flush && sanity check */
-		WARN_ON(!(tmp & HOST_AHCI_EN));
+		if (tmp & HOST_AHCI_EN)
+			return;
+		msleep(10);
 	}
+
+	WARN_ON(1);
 }
 
 /**
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index b7c38ee..ea2c764 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -573,6 +573,7 @@ static const struct ich_laptop ich_laptop[] = {
 	{ 0x27DF, 0x1043, 0x1267 },	/* ICH7 on Asus W5F */
 	{ 0x27DF, 0x103C, 0x30A1 },	/* ICH7 on HP Compaq nc2400 */
 	{ 0x24CA, 0x1025, 0x0061 },	/* ICH4 on ACER Aspire 2023WLMi */
+	{ 0x2653, 0x1043, 0x82D8 },	/* ICH6M on Asus Eee 701 */
 	/* end marker */
 	{ 0, }
 };
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 8c1cfc6..70b77e0 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -227,11 +227,9 @@ void ata_acpi_associate(struct ata_host *host)
 			acpi_install_notify_handler(ap->acpi_handle,
 						    ACPI_SYSTEM_NOTIFY,
 						    ata_acpi_ap_notify, ap);
-#if defined(CONFIG_ACPI_DOCK) || defined(CONFIG_ACPI_DOCK_MODULE)
 			/* we might be on a docking station */
 			register_hotplug_dock_device(ap->acpi_handle,
 						     ata_acpi_ap_notify, ap);
-#endif
 		}
 
 		for (j = 0; j < ata_link_max_devices(&ap->link); j++) {
@@ -241,11 +239,9 @@ void ata_acpi_associate(struct ata_host *host)
 				acpi_install_notify_handler(dev->acpi_handle,
 						ACPI_SYSTEM_NOTIFY,
 						ata_acpi_dev_notify, dev);
-#if defined(CONFIG_ACPI_DOCK) || defined(CONFIG_ACPI_DOCK_MODULE)
 				/* we might be on a docking station */
 				register_hotplug_dock_device(dev->acpi_handle,
 						ata_acpi_dev_notify, dev);
-#endif
 			}
 		}
 	}
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index b0b00af..51b7d2f 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2616,7 +2616,7 @@ void ata_port_probe(struct ata_port *ap)
  *	LOCKING:
  *	None.
  */
-void sata_print_link_status(struct ata_link *link)
+static void sata_print_link_status(struct ata_link *link)
 {
 	u32 sstatus, scontrol, tmp;
 
@@ -2772,7 +2772,7 @@ static int __sata_set_spd_needed(struct ata_link *link, u32 *scontrol)
  *	RETURNS:
  *	1 if SATA spd configuration is needed, 0 otherwise.
  */
-int sata_set_spd_needed(struct ata_link *link)
+static int sata_set_spd_needed(struct ata_link *link)
 {
 	u32 scontrol;
 
@@ -3377,7 +3377,7 @@ int ata_wait_ready(struct ata_link *link, unsigned long deadline,
  *	RETURNS:
  *	0 if @linke is ready before @deadline; otherwise, -errno.
  */
-extern int ata_wait_after_reset(struct ata_link *link, unsigned long deadline,
+int ata_wait_after_reset(struct ata_link *link, unsigned long deadline,
 				int (*check_ready)(struct ata_link *link))
 {
 	msleep(ATA_WAIT_AFTER_RESET_MSECS);
@@ -6208,7 +6208,6 @@ EXPORT_SYMBOL_GPL(ata_host_detach);
 EXPORT_SYMBOL_GPL(ata_sg_init);
 EXPORT_SYMBOL_GPL(ata_qc_complete);
 EXPORT_SYMBOL_GPL(ata_qc_complete_multiple);
-EXPORT_SYMBOL_GPL(sata_print_link_status);
 EXPORT_SYMBOL_GPL(atapi_cmd_type);
 EXPORT_SYMBOL_GPL(ata_tf_to_fis);
 EXPORT_SYMBOL_GPL(ata_tf_from_fis);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index d94359a..61dcd00 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1402,6 +1402,7 @@ static void ata_eh_analyze_ncq_error(struct ata_link *link)
 	/* we've got the perpetrator, condemn it */
 	qc = __ata_qc_from_tag(ap, tag);
 	memcpy(&qc->result_tf, &tf, sizeof(tf));
+	qc->result_tf.flags = ATA_TFLAG_ISADDR | ATA_TFLAG_LBA | ATA_TFLAG_LBA48;
 	qc->err_mask |= AC_ERR_DEV | AC_ERR_NCQ;
 	ehc->i.err_mask &= ~AC_ERR_DEV;
 }
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 1549952..2ec65a8 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1208,7 +1208,7 @@ fsm_start:
 		DPRINTK("ata%u: dev %u command complete, drv_stat 0x%x\n",
 			ap->print_id, qc->dev->devno, status);
 
-		WARN_ON(qc->err_mask);
+		WARN_ON(qc->err_mask & (AC_ERR_DEV | AC_ERR_HSM));
 
 		ap->hsm_task_state = HSM_ST_IDLE;
 
@@ -1222,7 +1222,7 @@ fsm_start:
 		/* make sure qc->err_mask is available to
 		 * know what's wrong and recover
 		 */
-		WARN_ON(qc->err_mask == 0);
+		WARN_ON(!(qc->err_mask & (AC_ERR_DEV | AC_ERR_HSM)));
 
 		ap->hsm_task_state = HSM_ST_IDLE;
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 4aeeabb..ae2cfd9 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -101,7 +101,6 @@ extern int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 			      unsigned int readid_flags);
 extern int ata_dev_configure(struct ata_device *dev);
 extern int sata_down_spd_limit(struct ata_link *link);
-extern int sata_set_spd_needed(struct ata_link *link);
 extern int ata_down_xfermask_limit(struct ata_device *dev, unsigned int sel);
 extern void ata_sg_clean(struct ata_queued_cmd *qc);
 extern void ata_qc_free(struct ata_queued_cmd *qc);
diff --git a/drivers/ata/pata_at32.c b/drivers/ata/pata_at32.c
index 3e8651d..5e10438 100644
--- a/drivers/ata/pata_at32.c
+++ b/drivers/ata/pata_at32.c
@@ -381,6 +381,9 @@ static int __exit pata_at32_remove(struct platform_device *pdev)
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:at32_ide");
+
 static struct platform_driver pata_at32_driver = {
 	.remove	       = __exit_p(pata_at32_remove),
 	.driver	       = {
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index 0a5ad98..a75de06 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1417,7 +1417,7 @@ static int bfin_reset_controller(struct ata_host *host)
 	count = 10000000;
 	do {
 		status = read_atapi_register(base, ATA_REG_STATUS);
-	} while (count-- && (status & ATA_BUSY));
+	} while (--count && (status & ATA_BUSY));
 
 	/* Enable only ATAPI Device interrupt */
 	ATAPI_SET_INT_MASK(base, 1);
@@ -1601,3 +1601,4 @@ MODULE_AUTHOR("Sonic Zhang <sonic.zhang@analog.com>");
 MODULE_DESCRIPTION("PATA driver for blackfin 54x ATAPI controller");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
+MODULE_ALIAS("platform:" DRV_NAME);
diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index 8a175f2..de8d186 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -221,6 +221,7 @@ MODULE_AUTHOR("Alessandro Zummo <a.zummo@towertech.it>");
 MODULE_DESCRIPTION("low-level driver for ixp4xx Compact Flash PATA");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
+MODULE_ALIAS("platform:" DRV_NAME);
 
 module_init(ixp4xx_pata_init);
 module_exit(ixp4xx_pata_exit);
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index 6527c56..8f65ad6 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -277,3 +277,4 @@ MODULE_AUTHOR("Paul Mundt");
 MODULE_DESCRIPTION("low-level driver for platform device ATA");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
+MODULE_ALIAS("platform:" DRV_NAME);
diff --git a/drivers/ata/pata_rb500_cf.c b/drivers/ata/pata_rb500_cf.c
index 800ae46..4345174 100644
--- a/drivers/ata/pata_rb500_cf.c
+++ b/drivers/ata/pata_rb500_cf.c
@@ -239,6 +239,9 @@ static __devexit int rb500_pata_driver_remove(struct platform_device *pdev)
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:" DRV_NAME);
+
 static struct platform_driver rb500_pata_platform_driver = {
 	.probe		= rb500_pata_driver_probe,
 	.remove		= __devexit_p(rb500_pata_driver_remove),
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index d52ce11..26a6337 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -23,46 +23,34 @@
  */
 
 /*
-  sata_mv TODO list:
-
-  1) Needs a full errata audit for all chipsets.  I implemented most
-  of the errata workarounds found in the Marvell vendor driver, but
-  I distinctly remember a couple workarounds (one related to PCI-X)
-  are still needed.
-
-  2) Improve/fix IRQ and error handling sequences.
-
-  3) ATAPI support (Marvell claims the 60xx/70xx chips can do it).
-
-  4) Think about TCQ support here, and for libata in general
-  with controllers that suppport it via host-queuing hardware
-  (a software-only implementation could be a nightmare).
-
-  5) Investigate problems with PCI Message Signalled Interrupts (MSI).
-
-  6) Cache frequently-accessed registers in mv_port_priv to reduce overhead.
-
-  7) Fix/reenable hot plug/unplug (should happen as a side-effect of (2) above).
-
-  8) Develop a low-power-consumption strategy, and implement it.
-
-  9) [Experiment, low priority] See if ATAPI can be supported using
-  "unknown FIS" or "vendor-specific FIS" support, or something creative
-  like that.
-
-  10) [Experiment, low priority] Investigate interrupt coalescing.
-  Quite often, especially with PCI Message Signalled Interrupts (MSI),
-  the overhead reduced by interrupt mitigation is quite often not
-  worth the latency cost.
-
-  11) [Experiment, Marvell value added] Is it possible to use target
-  mode to cross-connect two Linux boxes with Marvell cards?  If so,
-  creating LibATA target mode support would be very interesting.
-
-  Target mode, for those without docs, is the ability to directly
-  connect two SATA controllers.
-
-*/
+ * sata_mv TODO list:
+ *
+ * --> Errata workaround for NCQ device errors.
+ *
+ * --> More errata workarounds for PCI-X.
+ *
+ * --> Complete a full errata audit for all chipsets to identify others.
+ *
+ * --> ATAPI support (Marvell claims the 60xx/70xx chips can do it).
+ *
+ * --> Investigate problems with PCI Message Signalled Interrupts (MSI).
+ *
+ * --> Cache frequently-accessed registers in mv_port_priv to reduce overhead.
+ *
+ * --> Develop a low-power-consumption strategy, and implement it.
+ *
+ * --> [Experiment, low priority] Investigate interrupt coalescing.
+ *       Quite often, especially with PCI Message Signalled Interrupts (MSI),
+ *       the overhead reduced by interrupt mitigation is quite often not
+ *       worth the latency cost.
+ *
+ * --> [Experiment, Marvell value added] Is it possible to use target
+ *       mode to cross-connect two Linux boxes with Marvell cards?  If so,
+ *       creating LibATA target mode support would be very interesting.
+ *
+ *       Target mode, for those without docs, is the ability to directly
+ *       connect two SATA ports.
+ */
 
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -124,11 +112,11 @@ enum {
 	MV_MAX_SG_CT		= 256,
 	MV_SG_TBL_SZ		= (16 * MV_MAX_SG_CT),
 
-	MV_PORTS_PER_HC		= 4,
-	/* == (port / MV_PORTS_PER_HC) to determine HC from 0-7 port */
+	/* Determine hc from 0-7 port: hc = port >> MV_PORT_HC_SHIFT */
 	MV_PORT_HC_SHIFT	= 2,
-	/* == (port % MV_PORTS_PER_HC) to determine hard port from 0-7 port */
-	MV_PORT_MASK		= 3,
+	MV_PORTS_PER_HC		= (1 << MV_PORT_HC_SHIFT), /* 4 */
+	/* Determine hc port from 0-7 port: hardport = port & MV_PORT_MASK */
+	MV_PORT_MASK		= (MV_PORTS_PER_HC - 1),   /* 3 */
 
 	/* Host Flags */
 	MV_FLAG_DUAL_HC		= (1 << 30),  /* two SATA Host Controllers */
@@ -188,8 +176,8 @@ enum {
 	HC_MAIN_IRQ_MASK_OFS	= 0x1d64,
 	HC_SOC_MAIN_IRQ_CAUSE_OFS = 0x20020,
 	HC_SOC_MAIN_IRQ_MASK_OFS = 0x20024,
-	PORT0_ERR		= (1 << 0),	/* shift by port # */
-	PORT0_DONE		= (1 << 1),	/* shift by port # */
+	ERR_IRQ			= (1 << 0),	/* shift by port # */
+	DONE_IRQ		= (1 << 1),	/* shift by port # */
 	HC0_IRQ_PEND		= 0x1ff,	/* bits 0-8 = HC0's ports */
 	HC_SHIFT		= 9,		/* bits 9-17 = HC1's ports */
 	PCI_ERR			= (1 << 18),
@@ -205,6 +193,7 @@ enum {
 	HC_MAIN_RSVD_5		= (0x1fff << 19), /* bits 31-19 */
 	HC_MAIN_RSVD_SOC	= (0x3fffffb << 6),     /* bits 31-9, 7-6 */
 	HC_MAIN_MASKED_IRQS	= (TRAN_LO_DONE | TRAN_HI_DONE |
+				   PORTS_0_3_COAL_DONE | PORTS_4_7_COAL_DONE |
 				   PORTS_0_7_COAL_DONE | GPIO_INT | TWSI_INT |
 				   HC_MAIN_RSVD),
 	HC_MAIN_MASKED_IRQS_5	= (PORTS_0_3_COAL_DONE | PORTS_4_7_COAL_DONE |
@@ -215,8 +204,8 @@ enum {
 	HC_CFG_OFS		= 0,
 
 	HC_IRQ_CAUSE_OFS	= 0x14,
-	CRPB_DMA_DONE		= (1 << 0),	/* shift by port # */
-	HC_IRQ_COAL		= (1 << 4),	/* IRQ coalescing */
+	DMA_IRQ			= (1 << 0),	/* shift by port # */
+	HC_COAL_IRQ		= (1 << 4),	/* IRQ coalescing */
 	DEV_IRQ			= (1 << 8),	/* shift by port # */
 
 	/* Shadow block registers */
@@ -299,9 +288,7 @@ enum {
 	EDMA_ERR_IRQ_TRANSIENT  = EDMA_ERR_LNK_CTRL_RX_0 |
 				  EDMA_ERR_LNK_CTRL_RX_1 |
 				  EDMA_ERR_LNK_CTRL_RX_3 |
-				  EDMA_ERR_LNK_CTRL_TX |
-				 /* temporary, until we fix hotplug: */
-				 (EDMA_ERR_DEV_DCON | EDMA_ERR_DEV_CON),
+				  EDMA_ERR_LNK_CTRL_TX,
 
 	EDMA_EH_FREEZE		= EDMA_ERR_D_PAR |
 				  EDMA_ERR_PRD_PAR |
@@ -349,6 +336,8 @@ enum {
 	EDMA_IORDY_TMOUT	= 0x34,
 	EDMA_ARB_CFG		= 0x38,
 
+	GEN_II_NCQ_MAX_SECTORS	= 256,		/* max sects/io on Gen2 w/NCQ */
+
 	/* Host private flags (hp_flags) */
 	MV_HP_FLAG_MSI		= (1 << 0),
 	MV_HP_ERRATA_50XXB0	= (1 << 1),
@@ -722,11 +711,6 @@ static inline void writelfl(unsigned long data, void __iomem *addr)
 	(void) readl(addr);	/* flush to avoid PCI posted write */
 }
 
-static inline void __iomem *mv_hc_base(void __iomem *base, unsigned int hc)
-{
-	return (base + MV_SATAHC0_REG_BASE + (hc * MV_SATAHC_REG_SZ));
-}
-
 static inline unsigned int mv_hc_from_port(unsigned int port)
 {
 	return port >> MV_PORT_HC_SHIFT;
@@ -737,6 +721,29 @@ static inline unsigned int mv_hardport_from_port(unsigned int port)
 	return port & MV_PORT_MASK;
 }
 
+/*
+ * Consolidate some rather tricky bit shift calculations.
+ * This is hot-path stuff, so not a function.
+ * Simple code, with two return values, so macro rather than inline.
+ *
+ * port is the sole input, in range 0..7.
+ * shift is one output, for use with the main_cause and main_mask registers.
+ * hardport is the other output, in range 0..3
+ *
+ * Note that port and hardport may be the same variable in some cases.
+ */
+#define MV_PORT_TO_SHIFT_AND_HARDPORT(port, shift, hardport)	\
+{								\
+	shift    = mv_hc_from_port(port) * HC_SHIFT;		\
+	hardport = mv_hardport_from_port(port);			\
+	shift   += hardport * 2;				\
+}
+
+static inline void __iomem *mv_hc_base(void __iomem *base, unsigned int hc)
+{
+	return (base + MV_SATAHC0_REG_BASE + (hc * MV_SATAHC_REG_SZ));
+}
+
 static inline void __iomem *mv_hc_base_from_port(void __iomem *base,
 						 unsigned int port)
 {
@@ -783,7 +790,8 @@ static void mv_set_edma_ptrs(void __iomem *port_mmio,
 	/*
 	 * initialize request queue
 	 */
-	index = (pp->req_idx & MV_MAX_Q_DEPTH_MASK) << EDMA_REQ_Q_PTR_SHIFT;
+	pp->req_idx &= MV_MAX_Q_DEPTH_MASK;	/* paranoia */
+	index = pp->req_idx << EDMA_REQ_Q_PTR_SHIFT;
 
 	WARN_ON(pp->crqb_dma & 0x3ff);
 	writel((pp->crqb_dma >> 16) >> 16, port_mmio + EDMA_REQ_Q_BASE_HI_OFS);
@@ -799,7 +807,8 @@ static void mv_set_edma_ptrs(void __iomem *port_mmio,
 	/*
 	 * initialize response queue
 	 */
-	index = (pp->resp_idx & MV_MAX_Q_DEPTH_MASK) << EDMA_RSP_Q_PTR_SHIFT;
+	pp->resp_idx &= MV_MAX_Q_DEPTH_MASK;	/* paranoia */
+	index = pp->resp_idx << EDMA_RSP_Q_PTR_SHIFT;
 
 	WARN_ON(pp->crpb_dma & 0xff);
 	writel((pp->crpb_dma >> 16) >> 16, port_mmio + EDMA_RSP_Q_BASE_HI_OFS);
@@ -837,9 +846,9 @@ static void mv_start_dma(struct ata_port *ap, void __iomem *port_mmio,
 	}
 	if (!(pp->pp_flags & MV_PP_FLAG_EDMA_EN)) {
 		struct mv_host_priv *hpriv = ap->host->private_data;
-		int hard_port = mv_hardport_from_port(ap->port_no);
+		int hardport = mv_hardport_from_port(ap->port_no);
 		void __iomem *hc_mmio = mv_hc_base_from_port(
-					mv_host_base(ap->host), hard_port);
+					mv_host_base(ap->host), hardport);
 		u32 hc_irq_cause, ipending;
 
 		/* clear EDMA event indicators, if any */
@@ -847,8 +856,7 @@ static void mv_start_dma(struct ata_port *ap, void __iomem *port_mmio,
 
 		/* clear EDMA interrupt indicator, if any */
 		hc_irq_cause = readl(hc_mmio + HC_IRQ_CAUSE_OFS);
-		ipending = (DEV_IRQ << hard_port) |
-				(CRPB_DMA_DONE << hard_port);
+		ipending = (DEV_IRQ | DMA_IRQ) << hardport;
 		if (hc_irq_cause & ipending) {
 			writelfl(hc_irq_cause & ~ipending,
 				 hc_mmio + HC_IRQ_CAUSE_OFS);
@@ -864,7 +872,6 @@ static void mv_start_dma(struct ata_port *ap, void __iomem *port_mmio,
 		writelfl(EDMA_EN, port_mmio + EDMA_CMD_OFS);
 		pp->pp_flags |= MV_PP_FLAG_EDMA_EN;
 	}
-	WARN_ON(!(EDMA_EN & readl(port_mmio + EDMA_CMD_OFS)));
 }
 
 /**
@@ -1036,10 +1043,16 @@ static void mv6_dev_config(struct ata_device *adev)
 	 * See mv_qc_prep() for more info.
 	 */
 	if (adev->flags & ATA_DFLAG_NCQ) {
-		if (sata_pmp_attached(adev->link->ap))
+		if (sata_pmp_attached(adev->link->ap)) {
 			adev->flags &= ~ATA_DFLAG_NCQ;
-		else if (adev->max_sectors > ATA_MAX_SECTORS)
-			adev->max_sectors = ATA_MAX_SECTORS;
+			ata_dev_printk(adev, KERN_INFO,
+				"NCQ disabled for command-based switching\n");
+		} else if (adev->max_sectors > GEN_II_NCQ_MAX_SECTORS) {
+			adev->max_sectors = GEN_II_NCQ_MAX_SECTORS;
+			ata_dev_printk(adev, KERN_INFO,
+				"max_sectors limited to %u for NCQ\n",
+				adev->max_sectors);
+		}
 	}
 }
 
@@ -1287,7 +1300,7 @@ static void mv_qc_prep(struct ata_queued_cmd *qc)
 	flags |= (qc->dev->link->pmp & 0xf) << CRQB_PMP_SHIFT;
 
 	/* get current queue index from software */
-	in_index = pp->req_idx & MV_MAX_Q_DEPTH_MASK;
+	in_index = pp->req_idx;
 
 	pp->crqb[in_index].sg_addr =
 		cpu_to_le32(pp->sg_tbl_dma[qc->tag] & 0xffffffff);
@@ -1379,7 +1392,7 @@ static void mv_qc_prep_iie(struct ata_queued_cmd *qc)
 	flags |= (qc->dev->link->pmp & 0xf) << CRQB_PMP_SHIFT;
 
 	/* get current queue index from software */
-	in_index = pp->req_idx & MV_MAX_Q_DEPTH_MASK;
+	in_index = pp->req_idx;
 
 	crqb = (struct mv_crqb_iie *) &pp->crqb[in_index];
 	crqb->addr = cpu_to_le32(pp->sg_tbl_dma[qc->tag] & 0xffffffff);
@@ -1446,9 +1459,8 @@ static unsigned int mv_qc_issue(struct ata_queued_cmd *qc)
 
 	mv_start_dma(ap, port_mmio, pp, qc->tf.protocol);
 
-	pp->req_idx++;
-
-	in_index = (pp->req_idx & MV_MAX_Q_DEPTH_MASK) << EDMA_REQ_Q_PTR_SHIFT;
+	pp->req_idx = (pp->req_idx + 1) & MV_MAX_Q_DEPTH_MASK;
+	in_index = pp->req_idx << EDMA_REQ_Q_PTR_SHIFT;
 
 	/* and write the request in pointer to kick the EDMA to life */
 	writelfl((pp->crqb_dma & EDMA_REQ_Q_BASE_LO_MASK) | in_index,
@@ -1457,16 +1469,51 @@ static unsigned int mv_qc_issue(struct ata_queued_cmd *qc)
 	return 0;
 }
 
+static struct ata_queued_cmd *mv_get_active_qc(struct ata_port *ap)
+{
+	struct mv_port_priv *pp = ap->private_data;
+	struct ata_queued_cmd *qc;
+
+	if (pp->pp_flags & MV_PP_FLAG_NCQ_EN)
+		return NULL;
+	qc = ata_qc_from_tag(ap, ap->link.active_tag);
+	if (qc && (qc->tf.flags & ATA_TFLAG_POLLING))
+		qc = NULL;
+	return qc;
+}
+
+static void mv_unexpected_intr(struct ata_port *ap)
+{
+	struct mv_port_priv *pp = ap->private_data;
+	struct ata_eh_info *ehi = &ap->link.eh_info;
+	char *when = "";
+
+	/*
+	 * We got a device interrupt from something that
+	 * was supposed to be using EDMA or polling.
+	 */
+	ata_ehi_clear_desc(ehi);
+	if (pp->pp_flags & MV_PP_FLAG_EDMA_EN) {
+		when = " while EDMA enabled";
+	} else {
+		struct ata_queued_cmd *qc = ata_qc_from_tag(ap, ap->link.active_tag);
+		if (qc && (qc->tf.flags & ATA_TFLAG_POLLING))
+			when = " while polling";
+	}
+	ata_ehi_push_desc(ehi, "unexpected device interrupt%s", when);
+	ehi->err_mask |= AC_ERR_OTHER;
+	ehi->action   |= ATA_EH_RESET;
+	ata_port_freeze(ap);
+}
+
 /**
  *      mv_err_intr - Handle error interrupts on the port
  *      @ap: ATA channel to manipulate
- *      @reset_allowed: bool: 0 == don't trigger from reset here
+ *      @qc: affected command (non-NCQ), or NULL
  *
- *      In most cases, just clear the interrupt and move on.  However,
- *      some cases require an eDMA reset, which also performs a COMRESET.
- *      The SERR case requires a clear of pending errors in the SATA
- *      SERROR register.  Finally, if the port disabled DMA,
- *      update our cached copy to match.
+ *      Most cases require a full reset of the chip's state machine,
+ *      which also performs a COMRESET.
+ *      Also, if the port disabled DMA, update our cached copy to match.
  *
  *      LOCKING:
  *      Inherited from caller.
@@ -1477,28 +1524,24 @@ static void mv_err_intr(struct ata_port *ap, struct ata_queued_cmd *qc)
 	u32 edma_err_cause, eh_freeze_mask, serr = 0;
 	struct mv_port_priv *pp = ap->private_data;
 	struct mv_host_priv *hpriv = ap->host->private_data;
-	unsigned int edma_enabled = (pp->pp_flags & MV_PP_FLAG_EDMA_EN);
 	unsigned int action = 0, err_mask = 0;
 	struct ata_eh_info *ehi = &ap->link.eh_info;
 
 	ata_ehi_clear_desc(ehi);
 
-	if (!edma_enabled) {
-		/* just a guess: do we need to do this? should we
-		 * expand this, and do it in all cases?
-		 */
-		sata_scr_read(&ap->link, SCR_ERROR, &serr);
-		sata_scr_write_flush(&ap->link, SCR_ERROR, serr);
-	}
-
+	/*
+	 * Read and clear the err_cause bits.  This won't actually
+	 * clear for some errors (eg. SError), but we will be doing
+	 * a hard reset in those cases regardless, which *will* clear it.
+	 */
 	edma_err_cause = readl(port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
+	writelfl(~edma_err_cause, port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
 
-	ata_ehi_push_desc(ehi, "edma_err 0x%08x", edma_err_cause);
+	ata_ehi_push_desc(ehi, "edma_err_cause=%08x", edma_err_cause);
 
 	/*
-	 * all generations share these EDMA error cause bits
+	 * All generations share these EDMA error cause bits:
 	 */
-
 	if (edma_err_cause & EDMA_ERR_DEV)
 		err_mask |= AC_ERR_DEV;
 	if (edma_err_cause & (EDMA_ERR_D_PAR | EDMA_ERR_PRD_PAR |
@@ -1515,34 +1558,36 @@ static void mv_err_intr(struct ata_port *ap, struct ata_queued_cmd *qc)
 		action |= ATA_EH_RESET;
 	}
 
+	/*
+	 * Gen-I has a different SELF_DIS bit,
+	 * different FREEZE bits, and no SERR bit:
+	 */
 	if (IS_GEN_I(hpriv)) {
 		eh_freeze_mask = EDMA_EH_FREEZE_5;
-
 		if (edma_err_cause & EDMA_ERR_SELF_DIS_5) {
-			pp = ap->private_data;
 			pp->pp_flags &= ~MV_PP_FLAG_EDMA_EN;
 			ata_ehi_push_desc(ehi, "EDMA self-disable");
 		}
 	} else {
 		eh_freeze_mask = EDMA_EH_FREEZE;
-
 		if (edma_err_cause & EDMA_ERR_SELF_DIS) {
-			pp = ap->private_data;
 			pp->pp_flags &= ~MV_PP_FLAG_EDMA_EN;
 			ata_ehi_push_desc(ehi, "EDMA self-disable");
 		}
-
 		if (edma_err_cause & EDMA_ERR_SERR) {
-			sata_scr_read(&ap->link, SCR_ERROR, &serr);
-			sata_scr_write_flush(&ap->link, SCR_ERROR, serr);
-			err_mask = AC_ERR_ATA_BUS;
+			/*
+			 * Ensure that we read our own SCR, not a pmp link SCR:
+			 */
+			ap->ops->scr_read(ap, SCR_ERROR, &serr);
+			/*
+			 * Don't clear SError here; leave it for libata-eh:
+			 */
+			ata_ehi_push_desc(ehi, "SError=%08x", serr);
+			err_mask |= AC_ERR_ATA_BUS;
 			action |= ATA_EH_RESET;
 		}
 	}
 
-	/* Clear EDMA now that SERR cleanup done */
-	writelfl(~edma_err_cause, port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
-
 	if (!err_mask) {
 		err_mask = AC_ERR_OTHER;
 		action |= ATA_EH_RESET;
@@ -1562,178 +1607,151 @@ static void mv_err_intr(struct ata_port *ap, struct ata_queued_cmd *qc)
 		ata_port_abort(ap);
 }
 
-static void mv_intr_pio(struct ata_port *ap)
+static void mv_process_crpb_response(struct ata_port *ap,
+		struct mv_crpb *response, unsigned int tag, int ncq_enabled)
 {
-	struct ata_queued_cmd *qc;
-	u8 ata_status;
-
-	/* ignore spurious intr if drive still BUSY */
-	ata_status = readb(ap->ioaddr.status_addr);
-	if (unlikely(ata_status & ATA_BUSY))
-		return;
+	struct ata_queued_cmd *qc = ata_qc_from_tag(ap, tag);
 
-	/* get active ATA command */
-	qc = ata_qc_from_tag(ap, ap->link.active_tag);
-	if (unlikely(!qc))			/* no active tag */
-		return;
-	if (qc->tf.flags & ATA_TFLAG_POLLING)	/* polling; we don't own qc */
-		return;
-
-	/* and finally, complete the ATA command */
-	qc->err_mask |= ac_err_mask(ata_status);
-	ata_qc_complete(qc);
+	if (qc) {
+		u8 ata_status;
+		u16 edma_status = le16_to_cpu(response->flags);
+		/*
+		 * edma_status from a response queue entry:
+		 *   LSB is from EDMA_ERR_IRQ_CAUSE_OFS (non-NCQ only).
+		 *   MSB is saved ATA status from command completion.
+		 */
+		if (!ncq_enabled) {
+			u8 err_cause = edma_status & 0xff & ~EDMA_ERR_DEV;
+			if (err_cause) {
+				/*
+				 * Error will be seen/handled by mv_err_intr().
+				 * So do nothing at all here.
+				 */
+				return;
+			}
+		}
+		ata_status = edma_status >> CRPB_FLAG_STATUS_SHIFT;
+		qc->err_mask |= ac_err_mask(ata_status);
+		ata_qc_complete(qc);
+	} else {
+		ata_port_printk(ap, KERN_ERR, "%s: no qc for tag=%d\n",
+				__func__, tag);
+	}
 }
 
-static void mv_intr_edma(struct ata_port *ap)
+static void mv_process_crpb_entries(struct ata_port *ap, struct mv_port_priv *pp)
 {
 	void __iomem *port_mmio = mv_ap_base(ap);
 	struct mv_host_priv *hpriv = ap->host->private_data;
-	struct mv_port_priv *pp = ap->private_data;
-	struct ata_queued_cmd *qc;
-	u32 out_index, in_index;
+	u32 in_index;
 	bool work_done = false;
+	int ncq_enabled = (pp->pp_flags & MV_PP_FLAG_NCQ_EN);
 
-	/* get h/w response queue pointer */
+	/* Get the hardware queue position index */
 	in_index = (readl(port_mmio + EDMA_RSP_Q_IN_PTR_OFS)
 			>> EDMA_RSP_Q_PTR_SHIFT) & MV_MAX_Q_DEPTH_MASK;
 
-	while (1) {
-		u16 status;
+	/* Process new responses from since the last time we looked */
+	while (in_index != pp->resp_idx) {
 		unsigned int tag;
+		struct mv_crpb *response = &pp->crpb[pp->resp_idx];
 
-		/* get s/w response queue last-read pointer, and compare */
-		out_index = pp->resp_idx & MV_MAX_Q_DEPTH_MASK;
-		if (in_index == out_index)
-			break;
+		pp->resp_idx = (pp->resp_idx + 1) & MV_MAX_Q_DEPTH_MASK;
 
-		/* 50xx: get active ATA command */
-		if (IS_GEN_I(hpriv))
+		if (IS_GEN_I(hpriv)) {
+			/* 50xx: no NCQ, only one command active at a time */
 			tag = ap->link.active_tag;
-
-		/* Gen II/IIE: get active ATA command via tag, to enable
-		 * support for queueing.  this works transparently for
-		 * queued and non-queued modes.
-		 */
-		else
-			tag = le16_to_cpu(pp->crpb[out_index].id) & 0x1f;
-
-		qc = ata_qc_from_tag(ap, tag);
-
-		/* For non-NCQ mode, the lower 8 bits of status
-		 * are from EDMA_ERR_IRQ_CAUSE_OFS,
-		 * which should be zero if all went well.
-		 */
-		status = le16_to_cpu(pp->crpb[out_index].flags);
-		if ((status & 0xff) && !(pp->pp_flags & MV_PP_FLAG_NCQ_EN)) {
-			mv_err_intr(ap, qc);
-			return;
-		}
-
-		/* and finally, complete the ATA command */
-		if (qc) {
-			qc->err_mask |=
-				ac_err_mask(status >> CRPB_FLAG_STATUS_SHIFT);
-			ata_qc_complete(qc);
+		} else {
+			/* Gen II/IIE: get command tag from CRPB entry */
+			tag = le16_to_cpu(response->id) & 0x1f;
 		}
-
-		/* advance software response queue pointer, to
-		 * indicate (after the loop completes) to hardware
-		 * that we have consumed a response queue entry.
-		 */
+		mv_process_crpb_response(ap, response, tag, ncq_enabled);
 		work_done = true;
-		pp->resp_idx++;
 	}
 
+	/* Update the software queue position index in hardware */
 	if (work_done)
 		writelfl((pp->crpb_dma & EDMA_RSP_Q_BASE_LO_MASK) |
-			 (out_index << EDMA_RSP_Q_PTR_SHIFT),
+			 (pp->resp_idx << EDMA_RSP_Q_PTR_SHIFT),
 			 port_mmio + EDMA_RSP_Q_OUT_PTR_OFS);
 }
 
 /**
  *      mv_host_intr - Handle all interrupts on the given host controller
  *      @host: host specific structure
- *      @relevant: port error bits relevant to this host controller
- *      @hc: which host controller we're to look at
- *
- *      Read then write clear the HC interrupt status then walk each
- *      port connected to the HC and see if it needs servicing.  Port
- *      success ints are reported in the HC interrupt status reg, the
- *      port error ints are reported in the higher level main
- *      interrupt status register and thus are passed in via the
- *      'relevant' argument.
+ *      @main_cause: Main interrupt cause register for the chip.
  *
  *      LOCKING:
  *      Inherited from caller.
  */
-static void mv_host_intr(struct ata_host *host, u32 relevant, unsigned int hc)
+static int mv_host_intr(struct ata_host *host, u32 main_cause)
 {
 	struct mv_host_priv *hpriv = host->private_data;
-	void __iomem *mmio = hpriv->base;
-	void __iomem *hc_mmio = mv_hc_base(mmio, hc);
-	u32 hc_irq_cause;
-	int port, port0, last_port;
+	void __iomem *mmio = hpriv->base, *hc_mmio = NULL;
+	u32 hc_irq_cause = 0;
+	unsigned int handled = 0, port;
 
-	if (hc == 0)
-		port0 = 0;
-	else
-		port0 = MV_PORTS_PER_HC;
-
-	if (HAS_PCI(host))
-		last_port = port0 + MV_PORTS_PER_HC;
-	else
-		last_port = port0 + hpriv->n_ports;
-	/* we'll need the HC success int register in most cases */
-	hc_irq_cause = readl(hc_mmio + HC_IRQ_CAUSE_OFS);
-	if (!hc_irq_cause)
-		return;
-
-	writelfl(~hc_irq_cause, hc_mmio + HC_IRQ_CAUSE_OFS);
-
-	VPRINTK("ENTER, hc%u relevant=0x%08x HC IRQ cause=0x%08x\n",
-		hc, relevant, hc_irq_cause);
-
-	for (port = port0; port < last_port; port++) {
+	for (port = 0; port < hpriv->n_ports; port++) {
 		struct ata_port *ap = host->ports[port];
 		struct mv_port_priv *pp;
-		int have_err_bits, hard_port, shift;
-
-		if ((!ap) || (ap->flags & ATA_FLAG_DISABLED))
+		unsigned int shift, hardport, port_cause;
+		/*
+		 * When we move to the second hc, flag our cached
+		 * copies of hc_mmio (and hc_irq_cause) as invalid again.
+		 */
+		if (port == MV_PORTS_PER_HC)
+			hc_mmio = NULL;
+		/*
+		 * Do nothing if port is not interrupting or is disabled:
+		 */
+		MV_PORT_TO_SHIFT_AND_HARDPORT(port, shift, hardport);
+		port_cause = (main_cause >> shift) & (DONE_IRQ | ERR_IRQ);
+		if (!port_cause || !ap || (ap->flags & ATA_FLAG_DISABLED))
 			continue;
-
+		/*
+		 * Each hc within the host has its own hc_irq_cause register.
+		 * We defer reading it until we know we need it, right now:
+		 *
+		 * FIXME later: we don't really need to read this register
+		 * (some logic changes required below if we go that way),
+		 * because it doesn't tell us anything new.  But we do need
+		 * to write to it, outside the top of this loop,
+		 * to reset the interrupt triggers for next time.
+		 */
+		if (!hc_mmio) {
+			hc_mmio = mv_hc_base_from_port(mmio, port);
+			hc_irq_cause = readl(hc_mmio + HC_IRQ_CAUSE_OFS);
+			writelfl(~hc_irq_cause, hc_mmio + HC_IRQ_CAUSE_OFS);
+			handled = 1;
+		}
+		/*
+		 * Process completed CRPB response(s) before other events.
+		 */
 		pp = ap->private_data;
-
-		shift = port << 1;		/* (port * 2) */
-		if (port >= MV_PORTS_PER_HC)
-			shift++;	/* skip bit 8 in the HC Main IRQ reg */
-
-		have_err_bits = ((PORT0_ERR << shift) & relevant);
-
-		if (unlikely(have_err_bits)) {
-			struct ata_queued_cmd *qc;
-
-			qc = ata_qc_from_tag(ap, ap->link.active_tag);
-			if (qc && (qc->tf.flags & ATA_TFLAG_POLLING))
-				continue;
-
-			mv_err_intr(ap, qc);
-			continue;
+		if (hc_irq_cause & (DMA_IRQ << hardport)) {
+			if (pp->pp_flags & MV_PP_FLAG_EDMA_EN)
+				mv_process_crpb_entries(ap, pp);
 		}
-
-		hard_port = mv_hardport_from_port(port); /* range 0..3 */
-
-		if (pp->pp_flags & MV_PP_FLAG_EDMA_EN) {
-			if ((CRPB_DMA_DONE << hard_port) & hc_irq_cause)
-				mv_intr_edma(ap);
-		} else {
-			if ((DEV_IRQ << hard_port) & hc_irq_cause)
-				mv_intr_pio(ap);
+		/*
+		 * Handle chip-reported errors, or continue on to handle PIO.
+		 */
+		if (unlikely(port_cause & ERR_IRQ)) {
+			mv_err_intr(ap, mv_get_active_qc(ap));
+		} else if (hc_irq_cause & (DEV_IRQ << hardport)) {
+			if (!(pp->pp_flags & MV_PP_FLAG_EDMA_EN)) {
+				struct ata_queued_cmd *qc = mv_get_active_qc(ap);
+				if (qc) {
+					ata_sff_host_intr(ap, qc);
+					continue;
+				}
+			}
+			mv_unexpected_intr(ap);
 		}
 	}
-	VPRINTK("EXIT\n");
+	return handled;
 }
 
-static void mv_pci_error(struct ata_host *host, void __iomem *mmio)
+static int mv_pci_error(struct ata_host *host, void __iomem *mmio)
 {
 	struct mv_host_priv *hpriv = host->private_data;
 	struct ata_port *ap;
@@ -1771,6 +1789,7 @@ static void mv_pci_error(struct ata_host *host, void __iomem *mmio)
 			ata_port_freeze(ap);
 		}
 	}
+	return 1;	/* handled */
 }
 
 /**
@@ -1791,41 +1810,23 @@ static irqreturn_t mv_interrupt(int irq, void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
 	struct mv_host_priv *hpriv = host->private_data;
-	unsigned int hc, handled = 0, n_hcs;
-	void __iomem *mmio = hpriv->base;
-	u32 irq_stat, irq_mask;
+	unsigned int handled = 0;
+	u32 main_cause, main_mask;
 
-	/* Note to self: &host->lock == &ap->host->lock == ap->lock */
 	spin_lock(&host->lock);
-
-	irq_stat = readl(hpriv->main_cause_reg_addr);
-	irq_mask = readl(hpriv->main_mask_reg_addr);
-
-	/* check the cases where we either have nothing pending or have read
-	 * a bogus register value which can indicate HW removal or PCI fault
+	main_cause = readl(hpriv->main_cause_reg_addr);
+	main_mask  = readl(hpriv->main_mask_reg_addr);
+	/*
+	 * Deal with cases where we either have nothing pending, or have read
+	 * a bogus register value which can indicate HW removal or PCI fault.
 	 */
-	if (!(irq_stat & irq_mask) || (0xffffffffU == irq_stat))
-		goto out_unlock;
-
-	n_hcs = mv_get_hc_count(host->ports[0]->flags);
-
-	if (unlikely((irq_stat & PCI_ERR) && HAS_PCI(host))) {
-		mv_pci_error(host, mmio);
-		handled = 1;
-		goto out_unlock;	/* skip all other HC irq handling */
-	}
-
-	for (hc = 0; hc < n_hcs; hc++) {
-		u32 relevant = irq_stat & (HC0_IRQ_PEND << (hc * HC_SHIFT));
-		if (relevant) {
-			mv_host_intr(host, relevant, hc);
-			handled = 1;
-		}
+	if ((main_cause & main_mask) && (main_cause != 0xffffffffU)) {
+		if (unlikely((main_cause & PCI_ERR) && HAS_PCI(host)))
+			handled = mv_pci_error(host, hpriv->base);
+		else
+			handled = mv_host_intr(host, main_cause);
 	}
-
-out_unlock:
 	spin_unlock(&host->lock);
-
 	return IRQ_RETVAL(handled);
 }
 
@@ -2109,13 +2110,6 @@ static int mv6_reset_hc(struct mv_host_priv *hpriv, void __iomem *mmio,
 		printk(KERN_ERR DRV_NAME ": can't clear global reset\n");
 		rc = 1;
 	}
-	/*
-	 * Temporary: wait 3 seconds before port-probing can happen,
-	 * so that we don't miss finding sleepy SilXXXX port-multipliers.
-	 * This can go away once hotplug is fully/correctly implemented.
-	 */
-	if (rc == 0)
-		msleep(3000);
 done:
 	return rc;
 }
@@ -2409,55 +2403,44 @@ static int mv_hardreset(struct ata_link *link, unsigned int *class,
 static void mv_eh_freeze(struct ata_port *ap)
 {
 	struct mv_host_priv *hpriv = ap->host->private_data;
-	unsigned int hc = (ap->port_no > 3) ? 1 : 0;
-	u32 tmp, mask;
-	unsigned int shift;
+	unsigned int shift, hardport, port = ap->port_no;
+	u32 main_mask;
 
 	/* FIXME: handle coalescing completion events properly */
 
-	shift = ap->port_no * 2;
-	if (hc > 0)
-		shift++;
-
-	mask = 0x3 << shift;
+	mv_stop_edma(ap);
+	MV_PORT_TO_SHIFT_AND_HARDPORT(port, shift, hardport);
 
 	/* disable assertion of portN err, done events */
-	tmp = readl(hpriv->main_mask_reg_addr);
-	writelfl(tmp & ~mask, hpriv->main_mask_reg_addr);
+	main_mask = readl(hpriv->main_mask_reg_addr);
+	main_mask &= ~((DONE_IRQ | ERR_IRQ) << shift);
+	writelfl(main_mask, hpriv->main_mask_reg_addr);
 }
 
 static void mv_eh_thaw(struct ata_port *ap)
 {
 	struct mv_host_priv *hpriv = ap->host->private_data;
-	void __iomem *mmio = hpriv->base;
-	unsigned int hc = (ap->port_no > 3) ? 1 : 0;
-	void __iomem *hc_mmio = mv_hc_base(mmio, hc);
+	unsigned int shift, hardport, port = ap->port_no;
+	void __iomem *hc_mmio = mv_hc_base_from_port(hpriv->base, port);
 	void __iomem *port_mmio = mv_ap_base(ap);
-	u32 tmp, mask, hc_irq_cause;
-	unsigned int shift, hc_port_no = ap->port_no;
+	u32 main_mask, hc_irq_cause;
 
 	/* FIXME: handle coalescing completion events properly */
 
-	shift = ap->port_no * 2;
-	if (hc > 0) {
-		shift++;
-		hc_port_no -= 4;
-	}
-
-	mask = 0x3 << shift;
+	MV_PORT_TO_SHIFT_AND_HARDPORT(port, shift, hardport);
 
 	/* clear EDMA errors on this port */
 	writel(0, port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
 
 	/* clear pending irq events */
 	hc_irq_cause = readl(hc_mmio + HC_IRQ_CAUSE_OFS);
-	hc_irq_cause &= ~(1 << hc_port_no);	/* clear CRPB-done */
-	hc_irq_cause &= ~(1 << (hc_port_no + 8)); /* clear Device int */
-	writel(hc_irq_cause, hc_mmio + HC_IRQ_CAUSE_OFS);
+	hc_irq_cause &= ~((DEV_IRQ | DMA_IRQ) << hardport);
+	writelfl(hc_irq_cause, hc_mmio + HC_IRQ_CAUSE_OFS);
 
 	/* enable assertion of portN err, done events */
-	tmp = readl(hpriv->main_mask_reg_addr);
-	writelfl(tmp | mask, hpriv->main_mask_reg_addr);
+	main_mask = readl(hpriv->main_mask_reg_addr);
+	main_mask |= ((DONE_IRQ | ERR_IRQ) << shift);
+	writelfl(main_mask, hpriv->main_mask_reg_addr);
 }
 
 /**
@@ -2668,19 +2651,17 @@ static int mv_init_host(struct ata_host *host, unsigned int board_idx)
 
 	rc = mv_chip_id(host, board_idx);
 	if (rc)
-	goto done;
+		goto done;
 
 	if (HAS_PCI(host)) {
-		hpriv->main_cause_reg_addr = hpriv->base +
-		  HC_MAIN_IRQ_CAUSE_OFS;
-		hpriv->main_mask_reg_addr = hpriv->base + HC_MAIN_IRQ_MASK_OFS;
+		hpriv->main_cause_reg_addr = mmio + HC_MAIN_IRQ_CAUSE_OFS;
+		hpriv->main_mask_reg_addr  = mmio + HC_MAIN_IRQ_MASK_OFS;
 	} else {
-		hpriv->main_cause_reg_addr = hpriv->base +
-		  HC_SOC_MAIN_IRQ_CAUSE_OFS;
-		hpriv->main_mask_reg_addr = hpriv->base +
-		  HC_SOC_MAIN_IRQ_MASK_OFS;
+		hpriv->main_cause_reg_addr = mmio + HC_SOC_MAIN_IRQ_CAUSE_OFS;
+		hpriv->main_mask_reg_addr  = mmio + HC_SOC_MAIN_IRQ_MASK_OFS;
 	}
-	/* global interrupt mask */
+
+	/* global interrupt mask: 0 == mask everything */
 	writel(0, hpriv->main_mask_reg_addr);
 
 	n_hc = mv_get_hc_count(host->ports[0]->flags);
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 109b074..858f706 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -1591,13 +1591,16 @@ static void nv_mcp55_thaw(struct ata_port *ap)
 static int nv_hardreset(struct ata_link *link, unsigned int *class,
 			unsigned long deadline)
 {
-	unsigned int dummy;
+	int rc;
 
 	/* SATA hardreset fails to retrieve proper device signature on
-	 * some controllers.  Don't classify on hardreset.  For more
-	 * info, see http://bugzilla.kernel.org/show_bug.cgi?id=3352
+	 * some controllers.  Request follow up SRST.  For more info,
+	 * see http://bugzilla.kernel.org/show_bug.cgi?id=3352
 	 */
-	return sata_sff_hardreset(link, &dummy, deadline);
+	rc = sata_sff_hardreset(link, class, deadline);
+	if (rc)
+		return rc;
+	return -EAGAIN;
 }
 
 static void nv_adma_error_handler(struct ata_port *ap)
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index 6b8e45b..1010b30 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -142,7 +142,7 @@ static u32 sis_scr_cfg_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
 	u8 pmr;
 
 	if (sc_reg == SCR_ERROR) /* doesn't exist in PCI cfg space */
-		return 0xffffffff;
+		return -EINVAL;
 
 	pci_read_config_byte(pdev, SIS_PMR, &pmr);
 
@@ -158,14 +158,14 @@ static u32 sis_scr_cfg_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
 	return 0;
 }
 
-static void sis_scr_cfg_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int sis_scr_cfg_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	unsigned int cfg_addr = get_scr_cfg_addr(ap, sc_reg);
 	u8 pmr;
 
 	if (sc_reg == SCR_ERROR) /* doesn't exist in PCI cfg space */
-		return;
+		return -EINVAL;
 
 	pci_read_config_byte(pdev, SIS_PMR, &pmr);
 
@@ -174,6 +174,8 @@ static void sis_scr_cfg_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
 	if ((pdev->device == 0x0182) || (pdev->device == 0x0183) ||
 	    (pdev->device == 0x1182) || (pmr & SIS_PMR_COMBINED))
 		pci_write_config_dword(pdev, cfg_addr+0x10, val);
+
+	return 0;
 }
 
 static int sis_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
@@ -211,14 +213,14 @@ static int sis_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
 	pci_read_config_byte(pdev, SIS_PMR, &pmr);
 
 	if (ap->flags & SIS_FLAG_CFGSCR)
-		sis_scr_cfg_write(ap, sc_reg, val);
+		return sis_scr_cfg_write(ap, sc_reg, val);
 	else {
 		iowrite32(val, ap->ioaddr.scr_addr + (sc_reg * 4));
 		if ((pdev->device == 0x0182) || (pdev->device == 0x0183) ||
 		    (pdev->device == 0x1182) || (pmr & SIS_PMR_COMBINED))
 			iowrite32(val, ap->ioaddr.scr_addr + (sc_reg * 4)+0x10);
+		return 0;
 	}
-	return 0;
 }
 
 static int sis_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
diff --git a/drivers/ide/arm/palm_bk3710.c b/drivers/ide/arm/palm_bk3710.c
index 474162c..420fcb7 100644
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -409,9 +409,13 @@ out:
 	return -ENODEV;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:palm_bk3710");
+
 static struct platform_driver platform_bk_driver = {
 	.driver = {
 		.name = "palm_bk3710",
+		.owner = THIS_MODULE,
 	},
 	.probe = palm_bk3710_probe,
 	.remove = NULL,
diff --git a/drivers/ide/legacy/ide_platform.c b/drivers/ide/legacy/ide_platform.c
index 249651e..361b1bb 100644
--- a/drivers/ide/legacy/ide_platform.c
+++ b/drivers/ide/legacy/ide_platform.c
@@ -130,6 +130,7 @@ static int __devexit plat_ide_remove(struct platform_device *pdev)
 static struct platform_driver platform_ide_driver = {
 	.driver = {
 		.name = "pata_platform",
+		.owner = THIS_MODULE,
 	},
 	.probe = plat_ide_probe,
 	.remove = __devexit_p(plat_ide_remove),
@@ -147,6 +148,7 @@ static void __exit platform_ide_exit(void)
 
 MODULE_DESCRIPTION("Platform IDE driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:pata_platform");
 
 module_init(platform_ide_init);
 module_exit(platform_ide_exit);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 07ed56f..395a523 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -847,7 +847,6 @@ static inline int ata_port_is_dummy(struct ata_port *ap)
 	return ap->ops == &ata_dummy_port_ops;
 }
 
-extern void sata_print_link_status(struct ata_link *link);
 extern void ata_port_probe(struct ata_port *);
 extern int sata_set_spd(struct ata_link *link);
 extern int ata_std_prereset(struct ata_link *link, unsigned long deadline);
