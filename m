Return-Path: <linux-kernel-owner+w=401wt.eu-S1752993AbZDLRZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbZDLRZf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 13:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbZDLRZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 13:25:12 -0400
Received: from havoc.gtf.org ([69.61.125.42]:44170 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564AbZDLRY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 13:24:56 -0400
Date: Sun, 12 Apr 2009 13:24:53 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: sagar.borikar@gmail.com
Subject: [PATCH 1/3] Create libahci.  Move Marvell support to mv-ahci.
Message-ID: <20090412172453.GA5763@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sagar -- libahci should help you implement AHCI on the amba bus, too
(with modification...)



commit 8c773549b08a54f7d418a5e06b19d92f87f59aaf
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sun Apr 12 10:24:42 2009 -0400

    libata: Move Marvell AHCI to separate driver 'mv-ahci'.  Create 'libahci'.
    
    Move AHCI common code into new kernel module "libahci".
    
    Move Marvell-specific code into new driver "mv-ahci".
    
    NOT-Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 drivers/ata/Kconfig   |   13 
 drivers/ata/Makefile  |    3 
 drivers/ata/ahci.c    | 2004 --------------------------------------------------
 drivers/ata/ahci.h    |  283 +++++++
 drivers/ata/libahci.c | 1737 +++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/mv-ahci.c |  375 +++++++++
 6 files changed, 2429 insertions(+), 1986 deletions(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 9120717..2b697fe 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -111,6 +111,15 @@ config ATA_PIIX
 
 	  If unsure, say N.
 
+config SATA_MV_AHCI
+	tristate "Marvell AHCI support (6121, 6145)"
+	depends on PCI
+	help
+	  This option enables support for AHCI-like chips
+	  from Marvell:  6121, 6145.
+
+	  If unsure, say N.
+
 config SATA_MV
 	tristate "Marvell SATA support"
 	help
@@ -118,6 +127,10 @@ config SATA_MV
 	  Currently supports 88SX[56]0[48][01] PCI(-X) chips,
 	  as well as the newer [67]042 PCI-X/PCIe and SOC devices.
 
+	  This does NOT include support for AHCI-like chips from
+	  Marvell, notably: 6121, 6145.  Use the mv-ahci (SATA_MV_AHCI)
+	  driver for that.
+
 	  If unsure, say N.
 
 config SATA_NV
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 7f1ecf9..6055016 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -1,7 +1,7 @@
 
 obj-$(CONFIG_ATA)		+= libata.o
 
-obj-$(CONFIG_SATA_AHCI)		+= ahci.o
+obj-$(CONFIG_SATA_AHCI)		+= libahci.o ahci.o
 obj-$(CONFIG_SATA_SVW)		+= sata_svw.o
 obj-$(CONFIG_ATA_PIIX)		+= ata_piix.o
 obj-$(CONFIG_SATA_PROMISE)	+= sata_promise.o
@@ -14,6 +14,7 @@ obj-$(CONFIG_SATA_SIS)		+= sata_sis.o
 obj-$(CONFIG_SATA_SX4)		+= sata_sx4.o
 obj-$(CONFIG_SATA_NV)		+= sata_nv.o
 obj-$(CONFIG_SATA_ULI)		+= sata_uli.o
+obj-$(CONFIG_SATA_MV_AHCI)	+= libahci.o mv-ahci.o
 obj-$(CONFIG_SATA_MV)		+= sata_mv.o
 obj-$(CONFIG_SATA_INIC162X)	+= sata_inic162x.o
 obj-$(CONFIG_PDC_ADMA)		+= pdc_adma.o
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 57be6be..c08c34f 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1,3 +1,4 @@
+
 /*
  *  ahci.c - AHCI SATA support
  *
@@ -45,284 +46,33 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_cmnd.h>
 #include <linux/libata.h>
+#include "ahci.h"
 
 #define DRV_NAME	"ahci"
 #define DRV_VERSION	"3.0"
 
-/* Enclosure Management Control */
-#define EM_CTRL_MSG_TYPE              0x000f0000
-
-/* Enclosure Management LED Message Type */
-#define EM_MSG_LED_HBA_PORT           0x0000000f
-#define EM_MSG_LED_PMP_SLOT           0x0000ff00
-#define EM_MSG_LED_VALUE              0xffff0000
-#define EM_MSG_LED_VALUE_ACTIVITY     0x00070000
-#define EM_MSG_LED_VALUE_OFF          0xfff80000
-#define EM_MSG_LED_VALUE_ON           0x00010000
-
-static int ahci_skip_host_reset;
-static int ahci_ignore_sss;
-
-module_param_named(skip_host_reset, ahci_skip_host_reset, int, 0444);
-MODULE_PARM_DESC(skip_host_reset, "skip global host reset (0=don't skip, 1=skip)");
-
-module_param_named(ignore_sss, ahci_ignore_sss, int, 0444);
-MODULE_PARM_DESC(ignore_sss, "Ignore staggered spinup flag (0=don't ignore, 1=ignore)");
-
-static int ahci_enable_alpm(struct ata_port *ap,
-		enum link_pm policy);
-static void ahci_disable_alpm(struct ata_port *ap);
-static ssize_t ahci_led_show(struct ata_port *ap, char *buf);
-static ssize_t ahci_led_store(struct ata_port *ap, const char *buf,
-			      size_t size);
-static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
-					ssize_t size);
-#define MAX_SLOTS 8
-#define MAX_RETRY 15
-
 enum {
-	AHCI_PCI_BAR		= 5,
-	AHCI_MAX_PORTS		= 32,
-	AHCI_MAX_SG		= 168, /* hardware max is 64K */
-	AHCI_DMA_BOUNDARY	= 0xffffffff,
-	AHCI_MAX_CMDS		= 32,
-	AHCI_CMD_SZ		= 32,
-	AHCI_CMD_SLOT_SZ	= AHCI_MAX_CMDS * AHCI_CMD_SZ,
-	AHCI_RX_FIS_SZ		= 256,
-	AHCI_CMD_TBL_CDB	= 0x40,
-	AHCI_CMD_TBL_HDR_SZ	= 0x80,
-	AHCI_CMD_TBL_SZ		= AHCI_CMD_TBL_HDR_SZ + (AHCI_MAX_SG * 16),
-	AHCI_CMD_TBL_AR_SZ	= AHCI_CMD_TBL_SZ * AHCI_MAX_CMDS,
-	AHCI_PORT_PRIV_DMA_SZ	= AHCI_CMD_SLOT_SZ + AHCI_CMD_TBL_AR_SZ +
-				  AHCI_RX_FIS_SZ,
-	AHCI_IRQ_ON_SG		= (1 << 31),
-	AHCI_CMD_ATAPI		= (1 << 5),
-	AHCI_CMD_WRITE		= (1 << 6),
-	AHCI_CMD_PREFETCH	= (1 << 7),
-	AHCI_CMD_RESET		= (1 << 8),
-	AHCI_CMD_CLR_BUSY	= (1 << 10),
-
-	RX_FIS_D2H_REG		= 0x40,	/* offset of D2H Register FIS data */
-	RX_FIS_SDB		= 0x58, /* offset of SDB FIS data */
-	RX_FIS_UNK		= 0x60, /* offset of Unknown FIS data */
-
 	board_ahci		= 0,
 	board_ahci_vt8251	= 1,
 	board_ahci_ign_iferr	= 2,
 	board_ahci_sb600	= 3,
-	board_ahci_mv		= 4,
 	board_ahci_sb700	= 5, /* for SB700 and SB800 */
 	board_ahci_mcp65	= 6,
 	board_ahci_nopmp	= 7,
-
-	/* global controller registers */
-	HOST_CAP		= 0x00, /* host capabilities */
-	HOST_CTL		= 0x04, /* global host control */
-	HOST_IRQ_STAT		= 0x08, /* interrupt status */
-	HOST_PORTS_IMPL		= 0x0c, /* bitmap of implemented ports */
-	HOST_VERSION		= 0x10, /* AHCI spec. version compliancy */
-	HOST_EM_LOC		= 0x1c, /* Enclosure Management location */
-	HOST_EM_CTL		= 0x20, /* Enclosure Management Control */
-
-	/* HOST_CTL bits */
-	HOST_RESET		= (1 << 0),  /* reset controller; self-clear */
-	HOST_IRQ_EN		= (1 << 1),  /* global IRQ enable */
-	HOST_AHCI_EN		= (1 << 31), /* AHCI enabled */
-
-	/* HOST_CAP bits */
-	HOST_CAP_EMS		= (1 << 6),  /* Enclosure Management support */
-	HOST_CAP_SSC		= (1 << 14), /* Slumber capable */
-	HOST_CAP_PMP		= (1 << 17), /* Port Multiplier support */
-	HOST_CAP_CLO		= (1 << 24), /* Command List Override support */
-	HOST_CAP_ALPM		= (1 << 26), /* Aggressive Link PM support */
-	HOST_CAP_SSS		= (1 << 27), /* Staggered Spin-up */
-	HOST_CAP_SNTF		= (1 << 29), /* SNotification register */
-	HOST_CAP_NCQ		= (1 << 30), /* Native Command Queueing */
-	HOST_CAP_64		= (1 << 31), /* PCI DAC (64-bit DMA) support */
-
-	/* registers for each SATA port */
-	PORT_LST_ADDR		= 0x00, /* command list DMA addr */
-	PORT_LST_ADDR_HI	= 0x04, /* command list DMA addr hi */
-	PORT_FIS_ADDR		= 0x08, /* FIS rx buf addr */
-	PORT_FIS_ADDR_HI	= 0x0c, /* FIS rx buf addr hi */
-	PORT_IRQ_STAT		= 0x10, /* interrupt status */
-	PORT_IRQ_MASK		= 0x14, /* interrupt enable/disable mask */
-	PORT_CMD		= 0x18, /* port command */
-	PORT_TFDATA		= 0x20,	/* taskfile data */
-	PORT_SIG		= 0x24,	/* device TF signature */
-	PORT_CMD_ISSUE		= 0x38, /* command issue */
-	PORT_SCR_STAT		= 0x28, /* SATA phy register: SStatus */
-	PORT_SCR_CTL		= 0x2c, /* SATA phy register: SControl */
-	PORT_SCR_ERR		= 0x30, /* SATA phy register: SError */
-	PORT_SCR_ACT		= 0x34, /* SATA phy register: SActive */
-	PORT_SCR_NTF		= 0x3c, /* SATA phy register: SNotification */
-
-	/* PORT_IRQ_{STAT,MASK} bits */
-	PORT_IRQ_COLD_PRES	= (1 << 31), /* cold presence detect */
-	PORT_IRQ_TF_ERR		= (1 << 30), /* task file error */
-	PORT_IRQ_HBUS_ERR	= (1 << 29), /* host bus fatal error */
-	PORT_IRQ_HBUS_DATA_ERR	= (1 << 28), /* host bus data error */
-	PORT_IRQ_IF_ERR		= (1 << 27), /* interface fatal error */
-	PORT_IRQ_IF_NONFATAL	= (1 << 26), /* interface non-fatal error */
-	PORT_IRQ_OVERFLOW	= (1 << 24), /* xfer exhausted available S/G */
-	PORT_IRQ_BAD_PMP	= (1 << 23), /* incorrect port multiplier */
-
-	PORT_IRQ_PHYRDY		= (1 << 22), /* PhyRdy changed */
-	PORT_IRQ_DEV_ILCK	= (1 << 7), /* device interlock */
-	PORT_IRQ_CONNECT	= (1 << 6), /* port connect change status */
-	PORT_IRQ_SG_DONE	= (1 << 5), /* descriptor processed */
-	PORT_IRQ_UNK_FIS	= (1 << 4), /* unknown FIS rx'd */
-	PORT_IRQ_SDB_FIS	= (1 << 3), /* Set Device Bits FIS rx'd */
-	PORT_IRQ_DMAS_FIS	= (1 << 2), /* DMA Setup FIS rx'd */
-	PORT_IRQ_PIOS_FIS	= (1 << 1), /* PIO Setup FIS rx'd */
-	PORT_IRQ_D2H_REG_FIS	= (1 << 0), /* D2H Register FIS rx'd */
-
-	PORT_IRQ_FREEZE		= PORT_IRQ_HBUS_ERR |
-				  PORT_IRQ_IF_ERR |
-				  PORT_IRQ_CONNECT |
-				  PORT_IRQ_PHYRDY |
-				  PORT_IRQ_UNK_FIS |
-				  PORT_IRQ_BAD_PMP,
-	PORT_IRQ_ERROR		= PORT_IRQ_FREEZE |
-				  PORT_IRQ_TF_ERR |
-				  PORT_IRQ_HBUS_DATA_ERR,
-	DEF_PORT_IRQ		= PORT_IRQ_ERROR | PORT_IRQ_SG_DONE |
-				  PORT_IRQ_SDB_FIS | PORT_IRQ_DMAS_FIS |
-				  PORT_IRQ_PIOS_FIS | PORT_IRQ_D2H_REG_FIS,
-
-	/* PORT_CMD bits */
-	PORT_CMD_ASP		= (1 << 27), /* Aggressive Slumber/Partial */
-	PORT_CMD_ALPE		= (1 << 26), /* Aggressive Link PM enable */
-	PORT_CMD_ATAPI		= (1 << 24), /* Device is ATAPI */
-	PORT_CMD_PMP		= (1 << 17), /* PMP attached */
-	PORT_CMD_LIST_ON	= (1 << 15), /* cmd list DMA engine running */
-	PORT_CMD_FIS_ON		= (1 << 14), /* FIS DMA engine running */
-	PORT_CMD_FIS_RX		= (1 << 4), /* Enable FIS receive DMA engine */
-	PORT_CMD_CLO		= (1 << 3), /* Command list override */
-	PORT_CMD_POWER_ON	= (1 << 2), /* Power up device */
-	PORT_CMD_SPIN_UP	= (1 << 1), /* Spin up device */
-	PORT_CMD_START		= (1 << 0), /* Enable port DMA engine */
-
-	PORT_CMD_ICC_MASK	= (0xf << 28), /* i/f ICC state mask */
-	PORT_CMD_ICC_ACTIVE	= (0x1 << 28), /* Put i/f in active state */
-	PORT_CMD_ICC_PARTIAL	= (0x2 << 28), /* Put i/f in partial state */
-	PORT_CMD_ICC_SLUMBER	= (0x6 << 28), /* Put i/f in slumber state */
-
-	/* hpriv->flags bits */
-	AHCI_HFLAG_NO_NCQ		= (1 << 0),
-	AHCI_HFLAG_IGN_IRQ_IF_ERR	= (1 << 1), /* ignore IRQ_IF_ERR */
-	AHCI_HFLAG_IGN_SERR_INTERNAL	= (1 << 2), /* ignore SERR_INTERNAL */
-	AHCI_HFLAG_32BIT_ONLY		= (1 << 3), /* force 32bit */
-	AHCI_HFLAG_MV_PATA		= (1 << 4), /* PATA port */
-	AHCI_HFLAG_NO_MSI		= (1 << 5), /* no PCI MSI */
-	AHCI_HFLAG_NO_PMP		= (1 << 6), /* no PMP */
-	AHCI_HFLAG_NO_HOTPLUG		= (1 << 7), /* ignore PxSERR.DIAG.N */
-	AHCI_HFLAG_SECT255		= (1 << 8), /* max 255 sectors */
-	AHCI_HFLAG_YES_NCQ		= (1 << 9), /* force NCQ cap on */
-
-	/* ap->flags bits */
-
-	AHCI_FLAG_COMMON		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-					  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
-					  ATA_FLAG_ACPI_SATA | ATA_FLAG_AN |
-					  ATA_FLAG_IPM,
-
-	ICH_MAP				= 0x90, /* ICH MAP register */
-
-	/* em_ctl bits */
-	EM_CTL_RST			= (1 << 9), /* Reset */
-	EM_CTL_TM			= (1 << 8), /* Transmit Message */
-	EM_CTL_ALHD			= (1 << 26), /* Activity LED */
-};
-
-struct ahci_cmd_hdr {
-	__le32			opts;
-	__le32			status;
-	__le32			tbl_addr;
-	__le32			tbl_addr_hi;
-	__le32			reserved[4];
-};
-
-struct ahci_sg {
-	__le32			addr;
-	__le32			addr_hi;
-	__le32			reserved;
-	__le32			flags_size;
-};
-
-struct ahci_em_priv {
-	enum sw_activity blink_policy;
-	struct timer_list timer;
-	unsigned long saved_activity;
-	unsigned long activity;
-	unsigned long led_state;
-};
-
-struct ahci_host_priv {
-	unsigned int		flags;		/* AHCI_HFLAG_* */
-	u32			cap;		/* cap to use */
-	u32			port_map;	/* port map to use */
-	u32			saved_cap;	/* saved initial cap */
-	u32			saved_port_map;	/* saved initial port_map */
-	u32 			em_loc; /* enclosure management location */
 };
 
-struct ahci_port_priv {
-	struct ata_link		*active_link;
-	struct ahci_cmd_hdr	*cmd_slot;
-	dma_addr_t		cmd_slot_dma;
-	void			*cmd_tbl;
-	dma_addr_t		cmd_tbl_dma;
-	void			*rx_fis;
-	dma_addr_t		rx_fis_dma;
-	/* for NCQ spurious interrupt analysis */
-	unsigned int		ncq_saw_d2h:1;
-	unsigned int		ncq_saw_dmas:1;
-	unsigned int		ncq_saw_sdb:1;
-	u32 			intr_mask;	/* interrupts to enable */
-	struct ahci_em_priv	em_priv[MAX_SLOTS];/* enclosure management info
-					 	 * per PM slot */
-};
-
-static int ahci_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
-static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
-static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc);
-static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc);
-static int ahci_port_start(struct ata_port *ap);
-static void ahci_port_stop(struct ata_port *ap);
-static void ahci_qc_prep(struct ata_queued_cmd *qc);
-static void ahci_freeze(struct ata_port *ap);
-static void ahci_thaw(struct ata_port *ap);
-static void ahci_pmp_attach(struct ata_port *ap);
-static void ahci_pmp_detach(struct ata_port *ap);
-static int ahci_softreset(struct ata_link *link, unsigned int *class,
-			  unsigned long deadline);
 static int ahci_sb600_softreset(struct ata_link *link, unsigned int *class,
 			  unsigned long deadline);
-static int ahci_hardreset(struct ata_link *link, unsigned int *class,
-			  unsigned long deadline);
 static int ahci_vt8251_hardreset(struct ata_link *link, unsigned int *class,
 				 unsigned long deadline);
 static int ahci_p5wdh_hardreset(struct ata_link *link, unsigned int *class,
 				unsigned long deadline);
-static void ahci_postreset(struct ata_link *link, unsigned int *class);
-static void ahci_error_handler(struct ata_port *ap);
-static void ahci_post_internal_cmd(struct ata_queued_cmd *qc);
-static int ahci_port_resume(struct ata_port *ap);
 static void ahci_dev_config(struct ata_device *dev);
-static unsigned int ahci_fill_sg(struct ata_queued_cmd *qc, void *cmd_tbl);
-static void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
-			       u32 opts);
-#ifdef CONFIG_PM
-static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg);
-static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
-static int ahci_pci_device_resume(struct pci_dev *pdev);
-#endif
-static ssize_t ahci_activity_show(struct ata_device *dev, char *buf);
-static ssize_t ahci_activity_store(struct ata_device *dev,
-				   enum sw_activity val);
-static void ahci_init_sw_activity(struct ata_link *link);
+
+static int ahci_ignore_sss;
+module_param_named(ignore_sss, ahci_ignore_sss, int, 0444);
+MODULE_PARM_DESC(ignore_sss, "Ignore staggered spinup flag (0=don't ignore, 1=ignore)");
 
 static struct device_attribute *ahci_shost_attrs[] = {
 	&dev_attr_link_power_management_policy,
@@ -399,17 +149,16 @@ static struct ata_port_operations ahci_sb600_ops = {
 	.pmp_softreset		= ahci_sb600_softreset,
 };
 
-#define AHCI_HFLAGS(flags)	.private_data	= (void *)(flags)
-
 static const struct ata_port_info ahci_port_info[] = {
-	/* board_ahci */
+	[board_ahci] =
 	{
 		.flags		= AHCI_FLAG_COMMON,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
-	/* board_ahci_vt8251 */
+
+	[board_ahci_vt8251] =
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_NO_NCQ | AHCI_HFLAG_NO_PMP),
 		.flags		= AHCI_FLAG_COMMON,
@@ -417,7 +166,8 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_vt8251_ops,
 	},
-	/* board_ahci_ign_iferr */
+
+	[board_ahci_ign_iferr] =
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_IGN_IRQ_IF_ERR),
 		.flags		= AHCI_FLAG_COMMON,
@@ -425,7 +175,8 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
-	/* board_ahci_sb600 */
+
+	[board_ahci_sb600] =
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_IGN_SERR_INTERNAL |
 				 AHCI_HFLAG_32BIT_ONLY | AHCI_HFLAG_NO_MSI |
@@ -435,17 +186,8 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_sb600_ops,
 	},
-	/* board_ahci_mv */
-	{
-		AHCI_HFLAGS	(AHCI_HFLAG_NO_NCQ | AHCI_HFLAG_NO_MSI |
-				 AHCI_HFLAG_MV_PATA | AHCI_HFLAG_NO_PMP),
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA,
-		.pio_mask	= ATA_PIO4,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &ahci_ops,
-	},
-	/* board_ahci_sb700, for SB700 and SB800 */
+
+	[board_ahci_sb700] =	/* for SB700 and SB800 */
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_IGN_SERR_INTERNAL),
 		.flags		= AHCI_FLAG_COMMON,
@@ -453,7 +195,8 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_sb600_ops,
 	},
-	/* board_ahci_mcp65 */
+
+	[board_ahci_mcp65] =
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_YES_NCQ),
 		.flags		= AHCI_FLAG_COMMON,
@@ -461,7 +204,8 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
-	/* board_ahci_nopmp */
+
+	[board_ahci_nopmp] =
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_NO_PMP),
 		.flags		= AHCI_FLAG_COMMON,
@@ -601,10 +345,6 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(SI, 0x1185), board_ahci },		/* SiS 968 */
 	{ PCI_VDEVICE(SI, 0x0186), board_ahci },		/* SiS 968 */
 
-	/* Marvell */
-	{ PCI_VDEVICE(MARVELL, 0x6145), board_ahci_mv },	/* 6145 */
-	{ PCI_VDEVICE(MARVELL, 0x6121), board_ahci_mv },	/* 6121 */
-
 	/* Promise */
 	{ PCI_VDEVICE(PROMISE, 0x3f20), board_ahci },	/* PDC42819 */
 
@@ -633,900 +373,6 @@ module_param(ahci_em_messages, int, 0444);
 MODULE_PARM_DESC(ahci_em_messages,
 	"Set AHCI Enclosure Management Message type (0 = disabled, 1 = LED");
 
-#if defined(CONFIG_PATA_MARVELL) || defined(CONFIG_PATA_MARVELL_MODULE)
-static int marvell_enable;
-#else
-static int marvell_enable = 1;
-#endif
-module_param(marvell_enable, int, 0644);
-MODULE_PARM_DESC(marvell_enable, "Marvell SATA via AHCI (1 = enabled)");
-
-
-static inline int ahci_nr_ports(u32 cap)
-{
-	return (cap & 0x1f) + 1;
-}
-
-static inline void __iomem *__ahci_port_base(struct ata_host *host,
-					     unsigned int port_no)
-{
-	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
-
-	return mmio + 0x100 + (port_no * 0x80);
-}
-
-static inline void __iomem *ahci_port_base(struct ata_port *ap)
-{
-	return __ahci_port_base(ap->host, ap->port_no);
-}
-
-static void ahci_enable_ahci(void __iomem *mmio)
-{
-	int i;
-	u32 tmp;
-
-	/* turn on AHCI_EN */
-	tmp = readl(mmio + HOST_CTL);
-	if (tmp & HOST_AHCI_EN)
-		return;
-
-	/* Some controllers need AHCI_EN to be written multiple times.
-	 * Try a few times before giving up.
-	 */
-	for (i = 0; i < 5; i++) {
-		tmp |= HOST_AHCI_EN;
-		writel(tmp, mmio + HOST_CTL);
-		tmp = readl(mmio + HOST_CTL);	/* flush && sanity check */
-		if (tmp & HOST_AHCI_EN)
-			return;
-		msleep(10);
-	}
-
-	WARN_ON(1);
-}
-
-/**
- *	ahci_save_initial_config - Save and fixup initial config values
- *	@pdev: target PCI device
- *	@hpriv: host private area to store config values
- *
- *	Some registers containing configuration info might be setup by
- *	BIOS and might be cleared on reset.  This function saves the
- *	initial values of those registers into @hpriv such that they
- *	can be restored after controller reset.
- *
- *	If inconsistent, config values are fixed up by this function.
- *
- *	LOCKING:
- *	None.
- */
-static void ahci_save_initial_config(struct pci_dev *pdev,
-				     struct ahci_host_priv *hpriv)
-{
-	void __iomem *mmio = pcim_iomap_table(pdev)[AHCI_PCI_BAR];
-	u32 cap, port_map;
-	int i;
-	int mv;
-
-	/* make sure AHCI mode is enabled before accessing CAP */
-	ahci_enable_ahci(mmio);
-
-	/* Values prefixed with saved_ are written back to host after
-	 * reset.  Values without are used for driver operation.
-	 */
-	hpriv->saved_cap = cap = readl(mmio + HOST_CAP);
-	hpriv->saved_port_map = port_map = readl(mmio + HOST_PORTS_IMPL);
-
-	/* some chips have errata preventing 64bit use */
-	if ((cap & HOST_CAP_64) && (hpriv->flags & AHCI_HFLAG_32BIT_ONLY)) {
-		dev_printk(KERN_INFO, &pdev->dev,
-			   "controller can't do 64bit DMA, forcing 32bit\n");
-		cap &= ~HOST_CAP_64;
-	}
-
-	if ((cap & HOST_CAP_NCQ) && (hpriv->flags & AHCI_HFLAG_NO_NCQ)) {
-		dev_printk(KERN_INFO, &pdev->dev,
-			   "controller can't do NCQ, turning off CAP_NCQ\n");
-		cap &= ~HOST_CAP_NCQ;
-	}
-
-	if (!(cap & HOST_CAP_NCQ) && (hpriv->flags & AHCI_HFLAG_YES_NCQ)) {
-		dev_printk(KERN_INFO, &pdev->dev,
-			   "controller can do NCQ, turning on CAP_NCQ\n");
-		cap |= HOST_CAP_NCQ;
-	}
-
-	if ((cap & HOST_CAP_PMP) && (hpriv->flags & AHCI_HFLAG_NO_PMP)) {
-		dev_printk(KERN_INFO, &pdev->dev,
-			   "controller can't do PMP, turning off CAP_PMP\n");
-		cap &= ~HOST_CAP_PMP;
-	}
-
-	if (pdev->vendor == PCI_VENDOR_ID_JMICRON && pdev->device == 0x2361 &&
-	    port_map != 1) {
-		dev_printk(KERN_INFO, &pdev->dev,
-			   "JMB361 has only one port, port_map 0x%x -> 0x%x\n",
-			   port_map, 1);
-		port_map = 1;
-	}
-
-	/*
-	 * Temporary Marvell 6145 hack: PATA port presence
-	 * is asserted through the standard AHCI port
-	 * presence register, as bit 4 (counting from 0)
-	 */
-	if (hpriv->flags & AHCI_HFLAG_MV_PATA) {
-		if (pdev->device == 0x6121)
-			mv = 0x3;
-		else
-			mv = 0xf;
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "MV_AHCI HACK: port_map %x -> %x\n",
-			   port_map,
-			   port_map & mv);
-		dev_printk(KERN_ERR, &pdev->dev,
-			  "Disabling your PATA port. Use the boot option 'ahci.marvell_enable=0' to avoid this.\n");
-
-		port_map &= mv;
-	}
-
-	/* cross check port_map and cap.n_ports */
-	if (port_map) {
-		int map_ports = 0;
-
-		for (i = 0; i < AHCI_MAX_PORTS; i++)
-			if (port_map & (1 << i))
-				map_ports++;
-
-		/* If PI has more ports than n_ports, whine, clear
-		 * port_map and let it be generated from n_ports.
-		 */
-		if (map_ports > ahci_nr_ports(cap)) {
-			dev_printk(KERN_WARNING, &pdev->dev,
-				   "implemented port map (0x%x) contains more "
-				   "ports than nr_ports (%u), using nr_ports\n",
-				   port_map, ahci_nr_ports(cap));
-			port_map = 0;
-		}
-	}
-
-	/* fabricate port_map from cap.nr_ports */
-	if (!port_map) {
-		port_map = (1 << ahci_nr_ports(cap)) - 1;
-		dev_printk(KERN_WARNING, &pdev->dev,
-			   "forcing PORTS_IMPL to 0x%x\n", port_map);
-
-		/* write the fixed up value to the PI register */
-		hpriv->saved_port_map = port_map;
-	}
-
-	/* record values to use during operation */
-	hpriv->cap = cap;
-	hpriv->port_map = port_map;
-}
-
-/**
- *	ahci_restore_initial_config - Restore initial config
- *	@host: target ATA host
- *
- *	Restore initial config stored by ahci_save_initial_config().
- *
- *	LOCKING:
- *	None.
- */
-static void ahci_restore_initial_config(struct ata_host *host)
-{
-	struct ahci_host_priv *hpriv = host->private_data;
-	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
-
-	writel(hpriv->saved_cap, mmio + HOST_CAP);
-	writel(hpriv->saved_port_map, mmio + HOST_PORTS_IMPL);
-	(void) readl(mmio + HOST_PORTS_IMPL);	/* flush */
-}
-
-static unsigned ahci_scr_offset(struct ata_port *ap, unsigned int sc_reg)
-{
-	static const int offset[] = {
-		[SCR_STATUS]		= PORT_SCR_STAT,
-		[SCR_CONTROL]		= PORT_SCR_CTL,
-		[SCR_ERROR]		= PORT_SCR_ERR,
-		[SCR_ACTIVE]		= PORT_SCR_ACT,
-		[SCR_NOTIFICATION]	= PORT_SCR_NTF,
-	};
-	struct ahci_host_priv *hpriv = ap->host->private_data;
-
-	if (sc_reg < ARRAY_SIZE(offset) &&
-	    (sc_reg != SCR_NOTIFICATION || (hpriv->cap & HOST_CAP_SNTF)))
-		return offset[sc_reg];
-	return 0;
-}
-
-static int ahci_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val)
-{
-	void __iomem *port_mmio = ahci_port_base(link->ap);
-	int offset = ahci_scr_offset(link->ap, sc_reg);
-
-	if (offset) {
-		*val = readl(port_mmio + offset);
-		return 0;
-	}
-	return -EINVAL;
-}
-
-static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
-{
-	void __iomem *port_mmio = ahci_port_base(link->ap);
-	int offset = ahci_scr_offset(link->ap, sc_reg);
-
-	if (offset) {
-		writel(val, port_mmio + offset);
-		return 0;
-	}
-	return -EINVAL;
-}
-
-static void ahci_start_engine(struct ata_port *ap)
-{
-	void __iomem *port_mmio = ahci_port_base(ap);
-	u32 tmp;
-
-	/* start DMA */
-	tmp = readl(port_mmio + PORT_CMD);
-	tmp |= PORT_CMD_START;
-	writel(tmp, port_mmio + PORT_CMD);
-	readl(port_mmio + PORT_CMD); /* flush */
-}
-
-static int ahci_stop_engine(struct ata_port *ap)
-{
-	void __iomem *port_mmio = ahci_port_base(ap);
-	u32 tmp;
-
-	tmp = readl(port_mmio + PORT_CMD);
-
-	/* check if the HBA is idle */
-	if ((tmp & (PORT_CMD_START | PORT_CMD_LIST_ON)) == 0)
-		return 0;
-
-	/* setting HBA to idle */
-	tmp &= ~PORT_CMD_START;
-	writel(tmp, port_mmio + PORT_CMD);
-
-	/* wait for engine to stop. This could be as long as 500 msec */
-	tmp = ata_wait_register(port_mmio + PORT_CMD,
-				PORT_CMD_LIST_ON, PORT_CMD_LIST_ON, 1, 500);
-	if (tmp & PORT_CMD_LIST_ON)
-		return -EIO;
-
-	return 0;
-}
-
-static void ahci_start_fis_rx(struct ata_port *ap)
-{
-	void __iomem *port_mmio = ahci_port_base(ap);
-	struct ahci_host_priv *hpriv = ap->host->private_data;
-	struct ahci_port_priv *pp = ap->private_data;
-	u32 tmp;
-
-	/* set FIS registers */
-	if (hpriv->cap & HOST_CAP_64)
-		writel((pp->cmd_slot_dma >> 16) >> 16,
-		       port_mmio + PORT_LST_ADDR_HI);
-	writel(pp->cmd_slot_dma & 0xffffffff, port_mmio + PORT_LST_ADDR);
-
-	if (hpriv->cap & HOST_CAP_64)
-		writel((pp->rx_fis_dma >> 16) >> 16,
-		       port_mmio + PORT_FIS_ADDR_HI);
-	writel(pp->rx_fis_dma & 0xffffffff, port_mmio + PORT_FIS_ADDR);
-
-	/* enable FIS reception */
-	tmp = readl(port_mmio + PORT_CMD);
-	tmp |= PORT_CMD_FIS_RX;
-	writel(tmp, port_mmio + PORT_CMD);
-
-	/* flush */
-	readl(port_mmio + PORT_CMD);
-}
-
-static int ahci_stop_fis_rx(struct ata_port *ap)
-{
-	void __iomem *port_mmio = ahci_port_base(ap);
-	u32 tmp;
-
-	/* disable FIS reception */
-	tmp = readl(port_mmio + PORT_CMD);
-	tmp &= ~PORT_CMD_FIS_RX;
-	writel(tmp, port_mmio + PORT_CMD);
-
-	/* wait for completion, spec says 500ms, give it 1000 */
-	tmp = ata_wait_register(port_mmio + PORT_CMD, PORT_CMD_FIS_ON,
-				PORT_CMD_FIS_ON, 10, 1000);
-	if (tmp & PORT_CMD_FIS_ON)
-		return -EBUSY;
-
-	return 0;
-}
-
-static void ahci_power_up(struct ata_port *ap)
-{
-	struct ahci_host_priv *hpriv = ap->host->private_data;
-	void __iomem *port_mmio = ahci_port_base(ap);
-	u32 cmd;
-
-	cmd = readl(port_mmio + PORT_CMD) & ~PORT_CMD_ICC_MASK;
-
-	/* spin up device */
-	if (hpriv->cap & HOST_CAP_SSS) {
-		cmd |= PORT_CMD_SPIN_UP;
-		writel(cmd, port_mmio + PORT_CMD);
-	}
-
-	/* wake up link */
-	writel(cmd | PORT_CMD_ICC_ACTIVE, port_mmio + PORT_CMD);
-}
-
-static void ahci_disable_alpm(struct ata_port *ap)
-{
-	struct ahci_host_priv *hpriv = ap->host->private_data;
-	void __iomem *port_mmio = ahci_port_base(ap);
-	u32 cmd;
-	struct ahci_port_priv *pp = ap->private_data;
-
-	/* IPM bits should be disabled by libata-core */
-	/* get the existing command bits */
-	cmd = readl(port_mmio + PORT_CMD);
-
-	/* disable ALPM and ASP */
-	cmd &= ~PORT_CMD_ASP;
-	cmd &= ~PORT_CMD_ALPE;
-
-	/* force the interface back to active */
-	cmd |= PORT_CMD_ICC_ACTIVE;
-
-	/* write out new cmd value */
-	writel(cmd, port_mmio + PORT_CMD);
-	cmd = readl(port_mmio + PORT_CMD);
-
-	/* wait 10ms to be sure we've come out of any low power state */
-	msleep(10);
-
-	/* clear out any PhyRdy stuff from interrupt status */
-	writel(PORT_IRQ_PHYRDY, port_mmio + PORT_IRQ_STAT);
-
-	/* go ahead and clean out PhyRdy Change from Serror too */
-	ahci_scr_write(&ap->link, SCR_ERROR, ((1 << 16) | (1 << 18)));
-
-	/*
- 	 * Clear flag to indicate that we should ignore all PhyRdy
- 	 * state changes
- 	 */
-	hpriv->flags &= ~AHCI_HFLAG_NO_HOTPLUG;
-
-	/*
- 	 * Enable interrupts on Phy Ready.
- 	 */
-	pp->intr_mask |= PORT_IRQ_PHYRDY;
-	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
-
-	/*
- 	 * don't change the link pm policy - we can be called
- 	 * just to turn of link pm temporarily
- 	 */
-}
-
-static int ahci_enable_alpm(struct ata_port *ap,
-	enum link_pm policy)
-{
-	struct ahci_host_priv *hpriv = ap->host->private_data;
-	void __iomem *port_mmio = ahci_port_base(ap);
-	u32 cmd;
-	struct ahci_port_priv *pp = ap->private_data;
-	u32 asp;
-
-	/* Make sure the host is capable of link power management */
-	if (!(hpriv->cap & HOST_CAP_ALPM))
-		return -EINVAL;
-
-	switch (policy) {
-	case MAX_PERFORMANCE:
-	case NOT_AVAILABLE:
-		/*
- 		 * if we came here with NOT_AVAILABLE,
- 		 * it just means this is the first time we
- 		 * have tried to enable - default to max performance,
- 		 * and let the user go to lower power modes on request.
- 		 */
-		ahci_disable_alpm(ap);
-		return 0;
-	case MIN_POWER:
-		/* configure HBA to enter SLUMBER */
-		asp = PORT_CMD_ASP;
-		break;
-	case MEDIUM_POWER:
-		/* configure HBA to enter PARTIAL */
-		asp = 0;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	/*
- 	 * Disable interrupts on Phy Ready. This keeps us from
- 	 * getting woken up due to spurious phy ready interrupts
-	 * TBD - Hot plug should be done via polling now, is
-	 * that even supported?
- 	 */
-	pp->intr_mask &= ~PORT_IRQ_PHYRDY;
-	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
-
-	/*
- 	 * Set a flag to indicate that we should ignore all PhyRdy
- 	 * state changes since these can happen now whenever we
- 	 * change link state
- 	 */
-	hpriv->flags |= AHCI_HFLAG_NO_HOTPLUG;
-
-	/* get the existing command bits */
-	cmd = readl(port_mmio + PORT_CMD);
-
-	/*
- 	 * Set ASP based on Policy
- 	 */
-	cmd |= asp;
-
-	/*
- 	 * Setting this bit will instruct the HBA to aggressively
- 	 * enter a lower power link state when it's appropriate and
- 	 * based on the value set above for ASP
- 	 */
-	cmd |= PORT_CMD_ALPE;
-
-	/* write out new cmd value */
-	writel(cmd, port_mmio + PORT_CMD);
-	cmd = readl(port_mmio + PORT_CMD);
-
-	/* IPM bits should be set by libata-core */
-	return 0;
-}
-
-#ifdef CONFIG_PM
-static void ahci_power_down(struct ata_port *ap)
-{
-	struct ahci_host_priv *hpriv = ap->host->private_data;
-	void __iomem *port_mmio = ahci_port_base(ap);
-	u32 cmd, scontrol;
-
-	if (!(hpriv->cap & HOST_CAP_SSS))
-		return;
-
-	/* put device into listen mode, first set PxSCTL.DET to 0 */
-	scontrol = readl(port_mmio + PORT_SCR_CTL);
-	scontrol &= ~0xf;
-	writel(scontrol, port_mmio + PORT_SCR_CTL);
-
-	/* then set PxCMD.SUD to 0 */
-	cmd = readl(port_mmio + PORT_CMD) & ~PORT_CMD_ICC_MASK;
-	cmd &= ~PORT_CMD_SPIN_UP;
-	writel(cmd, port_mmio + PORT_CMD);
-}
-#endif
-
-static void ahci_start_port(struct ata_port *ap)
-{
-	struct ahci_port_priv *pp = ap->private_data;
-	struct ata_link *link;
-	struct ahci_em_priv *emp;
-	ssize_t rc;
-	int i;
-
-	/* enable FIS reception */
-	ahci_start_fis_rx(ap);
-
-	/* enable DMA */
-	ahci_start_engine(ap);
-
-	/* turn on LEDs */
-	if (ap->flags & ATA_FLAG_EM) {
-		ata_for_each_link(link, ap, EDGE) {
-			emp = &pp->em_priv[link->pmp];
-
-			/* EM Transmit bit maybe busy during init */
-			for (i = 0; i < MAX_RETRY; i++) {
-				rc = ahci_transmit_led_message(ap,
-							       emp->led_state,
-							       4);
-				if (rc == -EBUSY)
-					udelay(100);
-				else
-					break;
-			}
-		}
-	}
-
-	if (ap->flags & ATA_FLAG_SW_ACTIVITY)
-		ata_for_each_link(link, ap, EDGE)
-			ahci_init_sw_activity(link);
-
-}
-
-static int ahci_deinit_port(struct ata_port *ap, const char **emsg)
-{
-	int rc;
-
-	/* disable DMA */
-	rc = ahci_stop_engine(ap);
-	if (rc) {
-		*emsg = "failed to stop engine";
-		return rc;
-	}
-
-	/* disable FIS reception */
-	rc = ahci_stop_fis_rx(ap);
-	if (rc) {
-		*emsg = "failed stop FIS RX";
-		return rc;
-	}
-
-	return 0;
-}
-
-static int ahci_reset_controller(struct ata_host *host)
-{
-	struct pci_dev *pdev = to_pci_dev(host->dev);
-	struct ahci_host_priv *hpriv = host->private_data;
-	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
-	u32 tmp;
-
-	/* we must be in AHCI mode, before using anything
-	 * AHCI-specific, such as HOST_RESET.
-	 */
-	ahci_enable_ahci(mmio);
-
-	/* global controller reset */
-	if (!ahci_skip_host_reset) {
-		tmp = readl(mmio + HOST_CTL);
-		if ((tmp & HOST_RESET) == 0) {
-			writel(tmp | HOST_RESET, mmio + HOST_CTL);
-			readl(mmio + HOST_CTL); /* flush */
-		}
-
-		/*
-		 * to perform host reset, OS should set HOST_RESET
-		 * and poll until this bit is read to be "0".
-		 * reset must complete within 1 second, or
-		 * the hardware should be considered fried.
-		 */
-		tmp = ata_wait_register(mmio + HOST_CTL, HOST_RESET,
-					HOST_RESET, 10, 1000);
-
-		if (tmp & HOST_RESET) {
-			dev_printk(KERN_ERR, host->dev,
-				   "controller reset failed (0x%x)\n", tmp);
-			return -EIO;
-		}
-
-		/* turn on AHCI mode */
-		ahci_enable_ahci(mmio);
-
-		/* Some registers might be cleared on reset.  Restore
-		 * initial values.
-		 */
-		ahci_restore_initial_config(host);
-	} else
-		dev_printk(KERN_INFO, host->dev,
-			   "skipping global host reset\n");
-
-	if (pdev->vendor == PCI_VENDOR_ID_INTEL) {
-		u16 tmp16;
-
-		/* configure PCS */
-		pci_read_config_word(pdev, 0x92, &tmp16);
-		if ((tmp16 & hpriv->port_map) != hpriv->port_map) {
-			tmp16 |= hpriv->port_map;
-			pci_write_config_word(pdev, 0x92, tmp16);
-		}
-	}
-
-	return 0;
-}
-
-static void ahci_sw_activity(struct ata_link *link)
-{
-	struct ata_port *ap = link->ap;
-	struct ahci_port_priv *pp = ap->private_data;
-	struct ahci_em_priv *emp = &pp->em_priv[link->pmp];
-
-	if (!(link->flags & ATA_LFLAG_SW_ACTIVITY))
-		return;
-
-	emp->activity++;
-	if (!timer_pending(&emp->timer))
-		mod_timer(&emp->timer, jiffies + msecs_to_jiffies(10));
-}
-
-static void ahci_sw_activity_blink(unsigned long arg)
-{
-	struct ata_link *link = (struct ata_link *)arg;
-	struct ata_port *ap = link->ap;
-	struct ahci_port_priv *pp = ap->private_data;
-	struct ahci_em_priv *emp = &pp->em_priv[link->pmp];
-	unsigned long led_message = emp->led_state;
-	u32 activity_led_state;
-	unsigned long flags;
-
-	led_message &= EM_MSG_LED_VALUE;
-	led_message |= ap->port_no | (link->pmp << 8);
-
-	/* check to see if we've had activity.  If so,
-	 * toggle state of LED and reset timer.  If not,
-	 * turn LED to desired idle state.
-	 */
-	spin_lock_irqsave(ap->lock, flags);
-	if (emp->saved_activity != emp->activity) {
-		emp->saved_activity = emp->activity;
-		/* get the current LED state */
-		activity_led_state = led_message & EM_MSG_LED_VALUE_ON;
-
-		if (activity_led_state)
-			activity_led_state = 0;
-		else
-			activity_led_state = 1;
-
-		/* clear old state */
-		led_message &= ~EM_MSG_LED_VALUE_ACTIVITY;
-
-		/* toggle state */
-		led_message |= (activity_led_state << 16);
-		mod_timer(&emp->timer, jiffies + msecs_to_jiffies(100));
-	} else {
-		/* switch to idle */
-		led_message &= ~EM_MSG_LED_VALUE_ACTIVITY;
-		if (emp->blink_policy == BLINK_OFF)
-			led_message |= (1 << 16);
-	}
-	spin_unlock_irqrestore(ap->lock, flags);
-	ahci_transmit_led_message(ap, led_message, 4);
-}
-
-static void ahci_init_sw_activity(struct ata_link *link)
-{
-	struct ata_port *ap = link->ap;
-	struct ahci_port_priv *pp = ap->private_data;
-	struct ahci_em_priv *emp = &pp->em_priv[link->pmp];
-
-	/* init activity stats, setup timer */
-	emp->saved_activity = emp->activity = 0;
-	setup_timer(&emp->timer, ahci_sw_activity_blink, (unsigned long)link);
-
-	/* check our blink policy and set flag for link if it's enabled */
-	if (emp->blink_policy)
-		link->flags |= ATA_LFLAG_SW_ACTIVITY;
-}
-
-static int ahci_reset_em(struct ata_host *host)
-{
-	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
-	u32 em_ctl;
-
-	em_ctl = readl(mmio + HOST_EM_CTL);
-	if ((em_ctl & EM_CTL_TM) || (em_ctl & EM_CTL_RST))
-		return -EINVAL;
-
-	writel(em_ctl | EM_CTL_RST, mmio + HOST_EM_CTL);
-	return 0;
-}
-
-static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
-					ssize_t size)
-{
-	struct ahci_host_priv *hpriv = ap->host->private_data;
-	struct ahci_port_priv *pp = ap->private_data;
-	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
-	u32 em_ctl;
-	u32 message[] = {0, 0};
-	unsigned long flags;
-	int pmp;
-	struct ahci_em_priv *emp;
-
-	/* get the slot number from the message */
-	pmp = (state & EM_MSG_LED_PMP_SLOT) >> 8;
-	if (pmp < MAX_SLOTS)
-		emp = &pp->em_priv[pmp];
-	else
-		return -EINVAL;
-
-	spin_lock_irqsave(ap->lock, flags);
-
-	/*
-	 * if we are still busy transmitting a previous message,
-	 * do not allow
-	 */
-	em_ctl = readl(mmio + HOST_EM_CTL);
-	if (em_ctl & EM_CTL_TM) {
-		spin_unlock_irqrestore(ap->lock, flags);
-		return -EBUSY;
-	}
-
-	/*
-	 * create message header - this is all zero except for
-	 * the message size, which is 4 bytes.
-	 */
-	message[0] |= (4 << 8);
-
-	/* ignore 0:4 of byte zero, fill in port info yourself */
-	message[1] = ((state & ~EM_MSG_LED_HBA_PORT) | ap->port_no);
-
-	/* write message to EM_LOC */
-	writel(message[0], mmio + hpriv->em_loc);
-	writel(message[1], mmio + hpriv->em_loc+4);
-
-	/* save off new led state for port/slot */
-	emp->led_state = state;
-
-	/*
-	 * tell hardware to transmit the message
-	 */
-	writel(em_ctl | EM_CTL_TM, mmio + HOST_EM_CTL);
-
-	spin_unlock_irqrestore(ap->lock, flags);
-	return size;
-}
-
-static ssize_t ahci_led_show(struct ata_port *ap, char *buf)
-{
-	struct ahci_port_priv *pp = ap->private_data;
-	struct ata_link *link;
-	struct ahci_em_priv *emp;
-	int rc = 0;
-
-	ata_for_each_link(link, ap, EDGE) {
-		emp = &pp->em_priv[link->pmp];
-		rc += sprintf(buf, "%lx\n", emp->led_state);
-	}
-	return rc;
-}
-
-static ssize_t ahci_led_store(struct ata_port *ap, const char *buf,
-				size_t size)
-{
-	int state;
-	int pmp;
-	struct ahci_port_priv *pp = ap->private_data;
-	struct ahci_em_priv *emp;
-
-	state = simple_strtoul(buf, NULL, 0);
-
-	/* get the slot number from the message */
-	pmp = (state & EM_MSG_LED_PMP_SLOT) >> 8;
-	if (pmp < MAX_SLOTS)
-		emp = &pp->em_priv[pmp];
-	else
-		return -EINVAL;
-
-	/* mask off the activity bits if we are in sw_activity
-	 * mode, user should turn off sw_activity before setting
-	 * activity led through em_message
-	 */
-	if (emp->blink_policy)
-		state &= ~EM_MSG_LED_VALUE_ACTIVITY;
-
-	return ahci_transmit_led_message(ap, state, size);
-}
-
-static ssize_t ahci_activity_store(struct ata_device *dev, enum sw_activity val)
-{
-	struct ata_link *link = dev->link;
-	struct ata_port *ap = link->ap;
-	struct ahci_port_priv *pp = ap->private_data;
-	struct ahci_em_priv *emp = &pp->em_priv[link->pmp];
-	u32 port_led_state = emp->led_state;
-
-	/* save the desired Activity LED behavior */
-	if (val == OFF) {
-		/* clear LFLAG */
-		link->flags &= ~(ATA_LFLAG_SW_ACTIVITY);
-
-		/* set the LED to OFF */
-		port_led_state &= EM_MSG_LED_VALUE_OFF;
-		port_led_state |= (ap->port_no | (link->pmp << 8));
-		ahci_transmit_led_message(ap, port_led_state, 4);
-	} else {
-		link->flags |= ATA_LFLAG_SW_ACTIVITY;
-		if (val == BLINK_OFF) {
-			/* set LED to ON for idle */
-			port_led_state &= EM_MSG_LED_VALUE_OFF;
-			port_led_state |= (ap->port_no | (link->pmp << 8));
-			port_led_state |= EM_MSG_LED_VALUE_ON; /* check this */
-			ahci_transmit_led_message(ap, port_led_state, 4);
-		}
-	}
-	emp->blink_policy = val;
-	return 0;
-}
-
-static ssize_t ahci_activity_show(struct ata_device *dev, char *buf)
-{
-	struct ata_link *link = dev->link;
-	struct ata_port *ap = link->ap;
-	struct ahci_port_priv *pp = ap->private_data;
-	struct ahci_em_priv *emp = &pp->em_priv[link->pmp];
-
-	/* display the saved value of activity behavior for this
-	 * disk.
-	 */
-	return sprintf(buf, "%d\n", emp->blink_policy);
-}
-
-static void ahci_port_init(struct pci_dev *pdev, struct ata_port *ap,
-			   int port_no, void __iomem *mmio,
-			   void __iomem *port_mmio)
-{
-	const char *emsg = NULL;
-	int rc;
-	u32 tmp;
-
-	/* make sure port is not active */
-	rc = ahci_deinit_port(ap, &emsg);
-	if (rc)
-		dev_printk(KERN_WARNING, &pdev->dev,
-			   "%s (%d)\n", emsg, rc);
-
-	/* clear SError */
-	tmp = readl(port_mmio + PORT_SCR_ERR);
-	VPRINTK("PORT_SCR_ERR 0x%x\n", tmp);
-	writel(tmp, port_mmio + PORT_SCR_ERR);
-
-	/* clear port IRQ */
-	tmp = readl(port_mmio + PORT_IRQ_STAT);
-	VPRINTK("PORT_IRQ_STAT 0x%x\n", tmp);
-	if (tmp)
-		writel(tmp, port_mmio + PORT_IRQ_STAT);
-
-	writel(1 << port_no, mmio + HOST_IRQ_STAT);
-}
-
-static void ahci_init_controller(struct ata_host *host)
-{
-	struct ahci_host_priv *hpriv = host->private_data;
-	struct pci_dev *pdev = to_pci_dev(host->dev);
-	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
-	int i;
-	void __iomem *port_mmio;
-	u32 tmp;
-	int mv;
-
-	if (hpriv->flags & AHCI_HFLAG_MV_PATA) {
-		if (pdev->device == 0x6121)
-			mv = 2;
-		else
-			mv = 4;
-		port_mmio = __ahci_port_base(host, mv);
-
-		writel(0, port_mmio + PORT_IRQ_MASK);
-
-		/* clear port IRQ */
-		tmp = readl(port_mmio + PORT_IRQ_STAT);
-		VPRINTK("PORT_IRQ_STAT 0x%x\n", tmp);
-		if (tmp)
-			writel(tmp, port_mmio + PORT_IRQ_STAT);
-	}
-
-	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap = host->ports[i];
-
-		port_mmio = ahci_port_base(ap);
-		if (ata_port_is_dummy(ap))
-			continue;
-
-		ahci_port_init(pdev, ap, i, mmio, port_mmio);
-	}
-
-	tmp = readl(mmio + HOST_CTL);
-	VPRINTK("HOST_CTL 0x%x\n", tmp);
-	writel(tmp | HOST_IRQ_EN, mmio + HOST_CTL);
-	tmp = readl(mmio + HOST_CTL);
-	VPRINTK("HOST_CTL 0x%x\n", tmp);
-}
 
 static void ahci_dev_config(struct ata_device *dev)
 {
@@ -1539,186 +385,6 @@ static void ahci_dev_config(struct ata_device *dev)
 	}
 }
 
-static unsigned int ahci_dev_classify(struct ata_port *ap)
-{
-	void __iomem *port_mmio = ahci_port_base(ap);
-	struct ata_taskfile tf;
-	u32 tmp;
-
-	tmp = readl(port_mmio + PORT_SIG);
-	tf.lbah		= (tmp >> 24)	& 0xff;
-	tf.lbam		= (tmp >> 16)	& 0xff;
-	tf.lbal		= (tmp >> 8)	& 0xff;
-	tf.nsect	= (tmp)		& 0xff;
-
-	return ata_dev_classify(&tf);
-}
-
-static void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
-			       u32 opts)
-{
-	dma_addr_t cmd_tbl_dma;
-
-	cmd_tbl_dma = pp->cmd_tbl_dma + tag * AHCI_CMD_TBL_SZ;
-
-	pp->cmd_slot[tag].opts = cpu_to_le32(opts);
-	pp->cmd_slot[tag].status = 0;
-	pp->cmd_slot[tag].tbl_addr = cpu_to_le32(cmd_tbl_dma & 0xffffffff);
-	pp->cmd_slot[tag].tbl_addr_hi = cpu_to_le32((cmd_tbl_dma >> 16) >> 16);
-}
-
-static int ahci_kick_engine(struct ata_port *ap, int force_restart)
-{
-	void __iomem *port_mmio = ahci_port_base(ap);
-	struct ahci_host_priv *hpriv = ap->host->private_data;
-	u8 status = readl(port_mmio + PORT_TFDATA) & 0xFF;
-	u32 tmp;
-	int busy, rc;
-
-	/* do we need to kick the port? */
-	busy = status & (ATA_BUSY | ATA_DRQ);
-	if (!busy && !force_restart)
-		return 0;
-
-	/* stop engine */
-	rc = ahci_stop_engine(ap);
-	if (rc)
-		goto out_restart;
-
-	/* need to do CLO? */
-	if (!busy) {
-		rc = 0;
-		goto out_restart;
-	}
-
-	if (!(hpriv->cap & HOST_CAP_CLO)) {
-		rc = -EOPNOTSUPP;
-		goto out_restart;
-	}
-
-	/* perform CLO */
-	tmp = readl(port_mmio + PORT_CMD);
-	tmp |= PORT_CMD_CLO;
-	writel(tmp, port_mmio + PORT_CMD);
-
-	rc = 0;
-	tmp = ata_wait_register(port_mmio + PORT_CMD,
-				PORT_CMD_CLO, PORT_CMD_CLO, 1, 500);
-	if (tmp & PORT_CMD_CLO)
-		rc = -EIO;
-
-	/* restart engine */
- out_restart:
-	ahci_start_engine(ap);
-	return rc;
-}
-
-static int ahci_exec_polled_cmd(struct ata_port *ap, int pmp,
-				struct ata_taskfile *tf, int is_cmd, u16 flags,
-				unsigned long timeout_msec)
-{
-	const u32 cmd_fis_len = 5; /* five dwords */
-	struct ahci_port_priv *pp = ap->private_data;
-	void __iomem *port_mmio = ahci_port_base(ap);
-	u8 *fis = pp->cmd_tbl;
-	u32 tmp;
-
-	/* prep the command */
-	ata_tf_to_fis(tf, pmp, is_cmd, fis);
-	ahci_fill_cmd_slot(pp, 0, cmd_fis_len | flags | (pmp << 12));
-
-	/* issue & wait */
-	writel(1, port_mmio + PORT_CMD_ISSUE);
-
-	if (timeout_msec) {
-		tmp = ata_wait_register(port_mmio + PORT_CMD_ISSUE, 0x1, 0x1,
-					1, timeout_msec);
-		if (tmp & 0x1) {
-			ahci_kick_engine(ap, 1);
-			return -EBUSY;
-		}
-	} else
-		readl(port_mmio + PORT_CMD_ISSUE);	/* flush */
-
-	return 0;
-}
-
-static int ahci_do_softreset(struct ata_link *link, unsigned int *class,
-			     int pmp, unsigned long deadline,
-			     int (*check_ready)(struct ata_link *link))
-{
-	struct ata_port *ap = link->ap;
-	const char *reason = NULL;
-	unsigned long now, msecs;
-	struct ata_taskfile tf;
-	int rc;
-
-	DPRINTK("ENTER\n");
-
-	/* prepare for SRST (AHCI-1.1 10.4.1) */
-	rc = ahci_kick_engine(ap, 1);
-	if (rc && rc != -EOPNOTSUPP)
-		ata_link_printk(link, KERN_WARNING,
-				"failed to reset engine (errno=%d)\n", rc);
-
-	ata_tf_init(link->device, &tf);
-
-	/* issue the first D2H Register FIS */
-	msecs = 0;
-	now = jiffies;
-	if (time_after(now, deadline))
-		msecs = jiffies_to_msecs(deadline - now);
-
-	tf.ctl |= ATA_SRST;
-	if (ahci_exec_polled_cmd(ap, pmp, &tf, 0,
-				 AHCI_CMD_RESET | AHCI_CMD_CLR_BUSY, msecs)) {
-		rc = -EIO;
-		reason = "1st FIS failed";
-		goto fail;
-	}
-
-	/* spec says at least 5us, but be generous and sleep for 1ms */
-	msleep(1);
-
-	/* issue the second D2H Register FIS */
-	tf.ctl &= ~ATA_SRST;
-	ahci_exec_polled_cmd(ap, pmp, &tf, 0, 0, 0);
-
-	/* wait for link to become ready */
-	rc = ata_wait_after_reset(link, deadline, check_ready);
-	/* link occupied, -ENODEV too is an error */
-	if (rc) {
-		reason = "device not ready";
-		goto fail;
-	}
-	*class = ahci_dev_classify(ap);
-
-	DPRINTK("EXIT, class=%u\n", *class);
-	return 0;
-
- fail:
-	ata_link_printk(link, KERN_ERR, "softreset failed (%s)\n", reason);
-	return rc;
-}
-
-static int ahci_check_ready(struct ata_link *link)
-{
-	void __iomem *port_mmio = ahci_port_base(link->ap);
-	u8 status = readl(port_mmio + PORT_TFDATA) & 0xFF;
-
-	return ata_check_ready(status);
-}
-
-static int ahci_softreset(struct ata_link *link, unsigned int *class,
-			  unsigned long deadline)
-{
-	int pmp = sata_srst_pmp(link);
-
-	DPRINTK("ENTER\n");
-
-	return ahci_do_softreset(link, class, pmp, deadline, ahci_check_ready);
-}
-
 static int ahci_sb600_check_ready(struct ata_link *link)
 {
 	void __iomem *port_mmio = ahci_port_base(link->ap);
@@ -1767,38 +433,6 @@ static int ahci_sb600_softreset(struct ata_link *link, unsigned int *class,
 	return rc;
 }
 
-static int ahci_hardreset(struct ata_link *link, unsigned int *class,
-			  unsigned long deadline)
-{
-	const unsigned long *timing = sata_ehc_deb_timing(&link->eh_context);
-	struct ata_port *ap = link->ap;
-	struct ahci_port_priv *pp = ap->private_data;
-	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
-	struct ata_taskfile tf;
-	bool online;
-	int rc;
-
-	DPRINTK("ENTER\n");
-
-	ahci_stop_engine(ap);
-
-	/* clear D2H reception area to properly wait for D2H FIS */
-	ata_tf_init(link->device, &tf);
-	tf.command = 0x80;
-	ata_tf_to_fis(&tf, 0, 0, d2h_fis);
-
-	rc = sata_link_hardreset(link, timing, deadline, &online,
-				 ahci_check_ready);
-
-	ahci_start_engine(ap);
-
-	if (online)
-		*class = ahci_dev_classify(ap);
-
-	DPRINTK("EXIT, rc=%d, class=%u\n", rc, *class);
-	return rc;
-}
-
 static int ahci_vt8251_hardreset(struct ata_link *link, unsigned int *class,
 				 unsigned long deadline)
 {
@@ -1867,251 +501,6 @@ static int ahci_p5wdh_hardreset(struct ata_link *link, unsigned int *class,
 	return rc;
 }
 
-static void ahci_postreset(struct ata_link *link, unsigned int *class)
-{
-	struct ata_port *ap = link->ap;
-	void __iomem *port_mmio = ahci_port_base(ap);
-	u32 new_tmp, tmp;
-
-	ata_std_postreset(link, class);
-
-	/* Make sure port's ATAPI bit is set appropriately */
-	new_tmp = tmp = readl(port_mmio + PORT_CMD);
-	if (*class == ATA_DEV_ATAPI)
-		new_tmp |= PORT_CMD_ATAPI;
-	else
-		new_tmp &= ~PORT_CMD_ATAPI;
-	if (new_tmp != tmp) {
-		writel(new_tmp, port_mmio + PORT_CMD);
-		readl(port_mmio + PORT_CMD); /* flush */
-	}
-}
-
-static unsigned int ahci_fill_sg(struct ata_queued_cmd *qc, void *cmd_tbl)
-{
-	struct scatterlist *sg;
-	struct ahci_sg *ahci_sg = cmd_tbl + AHCI_CMD_TBL_HDR_SZ;
-	unsigned int si;
-
-	VPRINTK("ENTER\n");
-
-	/*
-	 * Next, the S/G list.
-	 */
-	for_each_sg(qc->sg, sg, qc->n_elem, si) {
-		dma_addr_t addr = sg_dma_address(sg);
-		u32 sg_len = sg_dma_len(sg);
-
-		ahci_sg[si].addr = cpu_to_le32(addr & 0xffffffff);
-		ahci_sg[si].addr_hi = cpu_to_le32((addr >> 16) >> 16);
-		ahci_sg[si].flags_size = cpu_to_le32(sg_len - 1);
-	}
-
-	return si;
-}
-
-static void ahci_qc_prep(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	struct ahci_port_priv *pp = ap->private_data;
-	int is_atapi = ata_is_atapi(qc->tf.protocol);
-	void *cmd_tbl;
-	u32 opts;
-	const u32 cmd_fis_len = 5; /* five dwords */
-	unsigned int n_elem;
-
-	/*
-	 * Fill in command table information.  First, the header,
-	 * a SATA Register - Host to Device command FIS.
-	 */
-	cmd_tbl = pp->cmd_tbl + qc->tag * AHCI_CMD_TBL_SZ;
-
-	ata_tf_to_fis(&qc->tf, qc->dev->link->pmp, 1, cmd_tbl);
-	if (is_atapi) {
-		memset(cmd_tbl + AHCI_CMD_TBL_CDB, 0, 32);
-		memcpy(cmd_tbl + AHCI_CMD_TBL_CDB, qc->cdb, qc->dev->cdb_len);
-	}
-
-	n_elem = 0;
-	if (qc->flags & ATA_QCFLAG_DMAMAP)
-		n_elem = ahci_fill_sg(qc, cmd_tbl);
-
-	/*
-	 * Fill in command slot information.
-	 */
-	opts = cmd_fis_len | n_elem << 16 | (qc->dev->link->pmp << 12);
-	if (qc->tf.flags & ATA_TFLAG_WRITE)
-		opts |= AHCI_CMD_WRITE;
-	if (is_atapi)
-		opts |= AHCI_CMD_ATAPI | AHCI_CMD_PREFETCH;
-
-	ahci_fill_cmd_slot(pp, qc->tag, opts);
-}
-
-static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
-{
-	struct ahci_host_priv *hpriv = ap->host->private_data;
-	struct ahci_port_priv *pp = ap->private_data;
-	struct ata_eh_info *host_ehi = &ap->link.eh_info;
-	struct ata_link *link = NULL;
-	struct ata_queued_cmd *active_qc;
-	struct ata_eh_info *active_ehi;
-	u32 serror;
-
-	/* determine active link */
-	ata_for_each_link(link, ap, EDGE)
-		if (ata_link_active(link))
-			break;
-	if (!link)
-		link = &ap->link;
-
-	active_qc = ata_qc_from_tag(ap, link->active_tag);
-	active_ehi = &link->eh_info;
-
-	/* record irq stat */
-	ata_ehi_clear_desc(host_ehi);
-	ata_ehi_push_desc(host_ehi, "irq_stat 0x%08x", irq_stat);
-
-	/* AHCI needs SError cleared; otherwise, it might lock up */
-	ahci_scr_read(&ap->link, SCR_ERROR, &serror);
-	ahci_scr_write(&ap->link, SCR_ERROR, serror);
-	host_ehi->serror |= serror;
-
-	/* some controllers set IRQ_IF_ERR on device errors, ignore it */
-	if (hpriv->flags & AHCI_HFLAG_IGN_IRQ_IF_ERR)
-		irq_stat &= ~PORT_IRQ_IF_ERR;
-
-	if (irq_stat & PORT_IRQ_TF_ERR) {
-		/* If qc is active, charge it; otherwise, the active
-		 * link.  There's no active qc on NCQ errors.  It will
-		 * be determined by EH by reading log page 10h.
-		 */
-		if (active_qc)
-			active_qc->err_mask |= AC_ERR_DEV;
-		else
-			active_ehi->err_mask |= AC_ERR_DEV;
-
-		if (hpriv->flags & AHCI_HFLAG_IGN_SERR_INTERNAL)
-			host_ehi->serror &= ~SERR_INTERNAL;
-	}
-
-	if (irq_stat & PORT_IRQ_UNK_FIS) {
-		u32 *unk = (u32 *)(pp->rx_fis + RX_FIS_UNK);
-
-		active_ehi->err_mask |= AC_ERR_HSM;
-		active_ehi->action |= ATA_EH_RESET;
-		ata_ehi_push_desc(active_ehi,
-				  "unknown FIS %08x %08x %08x %08x" ,
-				  unk[0], unk[1], unk[2], unk[3]);
-	}
-
-	if (sata_pmp_attached(ap) && (irq_stat & PORT_IRQ_BAD_PMP)) {
-		active_ehi->err_mask |= AC_ERR_HSM;
-		active_ehi->action |= ATA_EH_RESET;
-		ata_ehi_push_desc(active_ehi, "incorrect PMP");
-	}
-
-	if (irq_stat & (PORT_IRQ_HBUS_ERR | PORT_IRQ_HBUS_DATA_ERR)) {
-		host_ehi->err_mask |= AC_ERR_HOST_BUS;
-		host_ehi->action |= ATA_EH_RESET;
-		ata_ehi_push_desc(host_ehi, "host bus error");
-	}
-
-	if (irq_stat & PORT_IRQ_IF_ERR) {
-		host_ehi->err_mask |= AC_ERR_ATA_BUS;
-		host_ehi->action |= ATA_EH_RESET;
-		ata_ehi_push_desc(host_ehi, "interface fatal error");
-	}
-
-	if (irq_stat & (PORT_IRQ_CONNECT | PORT_IRQ_PHYRDY)) {
-		ata_ehi_hotplugged(host_ehi);
-		ata_ehi_push_desc(host_ehi, "%s",
-			irq_stat & PORT_IRQ_CONNECT ?
-			"connection status changed" : "PHY RDY changed");
-	}
-
-	/* okay, let's hand over to EH */
-
-	if (irq_stat & PORT_IRQ_FREEZE)
-		ata_port_freeze(ap);
-	else
-		ata_port_abort(ap);
-}
-
-static void ahci_port_intr(struct ata_port *ap)
-{
-	void __iomem *port_mmio = ahci_port_base(ap);
-	struct ata_eh_info *ehi = &ap->link.eh_info;
-	struct ahci_port_priv *pp = ap->private_data;
-	struct ahci_host_priv *hpriv = ap->host->private_data;
-	int resetting = !!(ap->pflags & ATA_PFLAG_RESETTING);
-	u32 status, qc_active;
-	int rc;
-
-	status = readl(port_mmio + PORT_IRQ_STAT);
-	writel(status, port_mmio + PORT_IRQ_STAT);
-
-	/* ignore BAD_PMP while resetting */
-	if (unlikely(resetting))
-		status &= ~PORT_IRQ_BAD_PMP;
-
-	/* If we are getting PhyRdy, this is
- 	 * just a power state change, we should
- 	 * clear out this, plus the PhyRdy/Comm
- 	 * Wake bits from Serror
- 	 */
-	if ((hpriv->flags & AHCI_HFLAG_NO_HOTPLUG) &&
-		(status & PORT_IRQ_PHYRDY)) {
-		status &= ~PORT_IRQ_PHYRDY;
-		ahci_scr_write(&ap->link, SCR_ERROR, ((1 << 16) | (1 << 18)));
-	}
-
-	if (unlikely(status & PORT_IRQ_ERROR)) {
-		ahci_error_intr(ap, status);
-		return;
-	}
-
-	if (status & PORT_IRQ_SDB_FIS) {
-		/* If SNotification is available, leave notification
-		 * handling to sata_async_notification().  If not,
-		 * emulate it by snooping SDB FIS RX area.
-		 *
-		 * Snooping FIS RX area is probably cheaper than
-		 * poking SNotification but some constrollers which
-		 * implement SNotification, ICH9 for example, don't
-		 * store AN SDB FIS into receive area.
-		 */
-		if (hpriv->cap & HOST_CAP_SNTF)
-			sata_async_notification(ap);
-		else {
-			/* If the 'N' bit in word 0 of the FIS is set,
-			 * we just received asynchronous notification.
-			 * Tell libata about it.
-			 */
-			const __le32 *f = pp->rx_fis + RX_FIS_SDB;
-			u32 f0 = le32_to_cpu(f[0]);
-
-			if (f0 & (1 << 15))
-				sata_async_notification(ap);
-		}
-	}
-
-	/* pp->active_link is valid iff any command is in flight */
-	if (ap->qc_active && pp->active_link->sactive)
-		qc_active = readl(port_mmio + PORT_SCR_ACT);
-	else
-		qc_active = readl(port_mmio + PORT_CMD_ISSUE);
-
-	rc = ata_qc_complete_multiple(ap, qc_active);
-
-	/* while resetting, invalid completions are expected */
-	if (unlikely(rc < 0 && !resetting)) {
-		ehi->err_mask |= AC_ERR_HSM;
-		ehi->action |= ATA_EH_RESET;
-		ata_port_freeze(ap);
-	}
-}
-
 static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
@@ -2172,355 +561,6 @@ static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 	return IRQ_RETVAL(handled);
 }
 
-static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	void __iomem *port_mmio = ahci_port_base(ap);
-	struct ahci_port_priv *pp = ap->private_data;
-
-	/* Keep track of the currently active link.  It will be used
-	 * in completion path to determine whether NCQ phase is in
-	 * progress.
-	 */
-	pp->active_link = qc->dev->link;
-
-	if (qc->tf.protocol == ATA_PROT_NCQ)
-		writel(1 << qc->tag, port_mmio + PORT_SCR_ACT);
-	writel(1 << qc->tag, port_mmio + PORT_CMD_ISSUE);
-
-	ahci_sw_activity(qc->dev->link);
-
-	return 0;
-}
-
-static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc)
-{
-	struct ahci_port_priv *pp = qc->ap->private_data;
-	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
-
-	ata_tf_from_fis(d2h_fis, &qc->result_tf);
-	return true;
-}
-
-static void ahci_freeze(struct ata_port *ap)
-{
-	void __iomem *port_mmio = ahci_port_base(ap);
-
-	/* turn IRQ off */
-	writel(0, port_mmio + PORT_IRQ_MASK);
-}
-
-static void ahci_thaw(struct ata_port *ap)
-{
-	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
-	void __iomem *port_mmio = ahci_port_base(ap);
-	u32 tmp;
-	struct ahci_port_priv *pp = ap->private_data;
-
-	/* clear IRQ */
-	tmp = readl(port_mmio + PORT_IRQ_STAT);
-	writel(tmp, port_mmio + PORT_IRQ_STAT);
-	writel(1 << ap->port_no, mmio + HOST_IRQ_STAT);
-
-	/* turn IRQ back on */
-	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
-}
-
-static void ahci_error_handler(struct ata_port *ap)
-{
-	if (!(ap->pflags & ATA_PFLAG_FROZEN)) {
-		/* restart engine */
-		ahci_stop_engine(ap);
-		ahci_start_engine(ap);
-	}
-
-	sata_pmp_error_handler(ap);
-}
-
-static void ahci_post_internal_cmd(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-
-	/* make DMA engine forget about the failed command */
-	if (qc->flags & ATA_QCFLAG_FAILED)
-		ahci_kick_engine(ap, 1);
-}
-
-static void ahci_pmp_attach(struct ata_port *ap)
-{
-	void __iomem *port_mmio = ahci_port_base(ap);
-	struct ahci_port_priv *pp = ap->private_data;
-	u32 cmd;
-
-	cmd = readl(port_mmio + PORT_CMD);
-	cmd |= PORT_CMD_PMP;
-	writel(cmd, port_mmio + PORT_CMD);
-
-	pp->intr_mask |= PORT_IRQ_BAD_PMP;
-	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
-}
-
-static void ahci_pmp_detach(struct ata_port *ap)
-{
-	void __iomem *port_mmio = ahci_port_base(ap);
-	struct ahci_port_priv *pp = ap->private_data;
-	u32 cmd;
-
-	cmd = readl(port_mmio + PORT_CMD);
-	cmd &= ~PORT_CMD_PMP;
-	writel(cmd, port_mmio + PORT_CMD);
-
-	pp->intr_mask &= ~PORT_IRQ_BAD_PMP;
-	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
-}
-
-static int ahci_port_resume(struct ata_port *ap)
-{
-	ahci_power_up(ap);
-	ahci_start_port(ap);
-
-	if (sata_pmp_attached(ap))
-		ahci_pmp_attach(ap);
-	else
-		ahci_pmp_detach(ap);
-
-	return 0;
-}
-
-#ifdef CONFIG_PM
-static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg)
-{
-	const char *emsg = NULL;
-	int rc;
-
-	rc = ahci_deinit_port(ap, &emsg);
-	if (rc == 0)
-		ahci_power_down(ap);
-	else {
-		ata_port_printk(ap, KERN_ERR, "%s (%d)\n", emsg, rc);
-		ahci_start_port(ap);
-	}
-
-	return rc;
-}
-
-static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
-{
-	struct ata_host *host = dev_get_drvdata(&pdev->dev);
-	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
-	u32 ctl;
-
-	if (mesg.event & PM_EVENT_SLEEP) {
-		/* AHCI spec rev1.1 section 8.3.3:
-		 * Software must disable interrupts prior to requesting a
-		 * transition of the HBA to D3 state.
-		 */
-		ctl = readl(mmio + HOST_CTL);
-		ctl &= ~HOST_IRQ_EN;
-		writel(ctl, mmio + HOST_CTL);
-		readl(mmio + HOST_CTL); /* flush */
-	}
-
-	return ata_pci_device_suspend(pdev, mesg);
-}
-
-static int ahci_pci_device_resume(struct pci_dev *pdev)
-{
-	struct ata_host *host = dev_get_drvdata(&pdev->dev);
-	int rc;
-
-	rc = ata_pci_device_do_resume(pdev);
-	if (rc)
-		return rc;
-
-	if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
-		rc = ahci_reset_controller(host);
-		if (rc)
-			return rc;
-
-		ahci_init_controller(host);
-	}
-
-	ata_host_resume(host);
-
-	return 0;
-}
-#endif
-
-static int ahci_port_start(struct ata_port *ap)
-{
-	struct device *dev = ap->host->dev;
-	struct ahci_port_priv *pp;
-	void *mem;
-	dma_addr_t mem_dma;
-
-	pp = devm_kzalloc(dev, sizeof(*pp), GFP_KERNEL);
-	if (!pp)
-		return -ENOMEM;
-
-	mem = dmam_alloc_coherent(dev, AHCI_PORT_PRIV_DMA_SZ, &mem_dma,
-				  GFP_KERNEL);
-	if (!mem)
-		return -ENOMEM;
-	memset(mem, 0, AHCI_PORT_PRIV_DMA_SZ);
-
-	/*
-	 * First item in chunk of DMA memory: 32-slot command table,
-	 * 32 bytes each in size
-	 */
-	pp->cmd_slot = mem;
-	pp->cmd_slot_dma = mem_dma;
-
-	mem += AHCI_CMD_SLOT_SZ;
-	mem_dma += AHCI_CMD_SLOT_SZ;
-
-	/*
-	 * Second item: Received-FIS area
-	 */
-	pp->rx_fis = mem;
-	pp->rx_fis_dma = mem_dma;
-
-	mem += AHCI_RX_FIS_SZ;
-	mem_dma += AHCI_RX_FIS_SZ;
-
-	/*
-	 * Third item: data area for storing a single command
-	 * and its scatter-gather table
-	 */
-	pp->cmd_tbl = mem;
-	pp->cmd_tbl_dma = mem_dma;
-
-	/*
-	 * Save off initial list of interrupts to be enabled.
-	 * This could be changed later
-	 */
-	pp->intr_mask = DEF_PORT_IRQ;
-
-	ap->private_data = pp;
-
-	/* engage engines, captain */
-	return ahci_port_resume(ap);
-}
-
-static void ahci_port_stop(struct ata_port *ap)
-{
-	const char *emsg = NULL;
-	int rc;
-
-	/* de-initialize port */
-	rc = ahci_deinit_port(ap, &emsg);
-	if (rc)
-		ata_port_printk(ap, KERN_WARNING, "%s (%d)\n", emsg, rc);
-}
-
-static int ahci_configure_dma_masks(struct pci_dev *pdev, int using_dac)
-{
-	int rc;
-
-	if (using_dac &&
-	    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
-		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
-		if (rc) {
-			rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
-			if (rc) {
-				dev_printk(KERN_ERR, &pdev->dev,
-					   "64-bit DMA enable failed\n");
-				return rc;
-			}
-		}
-	} else {
-		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
-		if (rc) {
-			dev_printk(KERN_ERR, &pdev->dev,
-				   "32-bit DMA enable failed\n");
-			return rc;
-		}
-		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
-		if (rc) {
-			dev_printk(KERN_ERR, &pdev->dev,
-				   "32-bit consistent DMA enable failed\n");
-			return rc;
-		}
-	}
-	return 0;
-}
-
-static void ahci_print_info(struct ata_host *host)
-{
-	struct ahci_host_priv *hpriv = host->private_data;
-	struct pci_dev *pdev = to_pci_dev(host->dev);
-	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
-	u32 vers, cap, impl, speed;
-	const char *speed_s;
-	u16 cc;
-	const char *scc_s;
-
-	vers = readl(mmio + HOST_VERSION);
-	cap = hpriv->cap;
-	impl = hpriv->port_map;
-
-	speed = (cap >> 20) & 0xf;
-	if (speed == 1)
-		speed_s = "1.5";
-	else if (speed == 2)
-		speed_s = "3";
-	else if (speed == 3)
-		speed_s = "6";
-	else
-		speed_s = "?";
-
-	pci_read_config_word(pdev, 0x0a, &cc);
-	if (cc == PCI_CLASS_STORAGE_IDE)
-		scc_s = "IDE";
-	else if (cc == PCI_CLASS_STORAGE_SATA)
-		scc_s = "SATA";
-	else if (cc == PCI_CLASS_STORAGE_RAID)
-		scc_s = "RAID";
-	else
-		scc_s = "unknown";
-
-	dev_printk(KERN_INFO, &pdev->dev,
-		"AHCI %02x%02x.%02x%02x "
-		"%u slots %u ports %s Gbps 0x%x impl %s mode\n"
-		,
-
-		(vers >> 24) & 0xff,
-		(vers >> 16) & 0xff,
-		(vers >> 8) & 0xff,
-		vers & 0xff,
-
-		((cap >> 8) & 0x1f) + 1,
-		(cap & 0x1f) + 1,
-		speed_s,
-		impl,
-		scc_s);
-
-	dev_printk(KERN_INFO, &pdev->dev,
-		"flags: "
-		"%s%s%s%s%s%s%s"
-		"%s%s%s%s%s%s%s"
-		"%s\n"
-		,
-
-		cap & (1 << 31) ? "64bit " : "",
-		cap & (1 << 30) ? "ncq " : "",
-		cap & (1 << 29) ? "sntf " : "",
-		cap & (1 << 28) ? "ilck " : "",
-		cap & (1 << 27) ? "stag " : "",
-		cap & (1 << 26) ? "pm " : "",
-		cap & (1 << 25) ? "led " : "",
-
-		cap & (1 << 24) ? "clo " : "",
-		cap & (1 << 19) ? "nz " : "",
-		cap & (1 << 18) ? "only " : "",
-		cap & (1 << 17) ? "pmp " : "",
-		cap & (1 << 15) ? "pio " : "",
-		cap & (1 << 14) ? "slum " : "",
-		cap & (1 << 13) ? "part " : "",
-		cap & (1 << 6) ? "ems ": ""
-		);
-}
-
 /* On ASUS P5W DH Deluxe, the second port of PCI device 00:1f.2 is
  * hardwired to on-board SIMG 4726.  The chipset is ICH8 and doesn't
  * support PMP and the 4726 either directly exports the device
@@ -2619,12 +659,6 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
 
-	/* The AHCI driver can only drive the SATA ports, the PATA driver
-	   can drive them all so if both drivers are selected make sure
-	   AHCI stays out of the way */
-	if (pdev->vendor == PCI_VENDOR_ID_MARVELL && !marvell_enable)
-		return -ENODEV;
-
 	/* acquire resources */
 	rc = pcim_enable_device(pdev);
 	if (rc)
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
new file mode 100644
index 0000000..cf5b9d8
--- /dev/null
+++ b/drivers/ata/ahci.h
@@ -0,0 +1,283 @@
+#ifndef __LINUX_AHCI_H__
+#define __LINUX_AHCI_H__
+
+#define AHCI_HFLAGS(flags)	.private_data	= (void *)(flags)
+
+enum {
+	AHCI_PCI_BAR		= 5,
+	AHCI_MAX_PORTS		= 32,
+	AHCI_MAX_SG		= 168, /* hardware max is 64K */
+	AHCI_DMA_BOUNDARY	= 0xffffffff,
+	AHCI_MAX_CMDS		= 32,
+	AHCI_MAX_SLOTS		= 8,
+
+	AHCI_CMD_SZ		= 32,
+	AHCI_CMD_SLOT_SZ	= AHCI_MAX_CMDS * AHCI_CMD_SZ,
+	AHCI_RX_FIS_SZ		= 256,
+	AHCI_CMD_TBL_CDB	= 0x40,
+	AHCI_CMD_TBL_HDR_SZ	= 0x80,
+	AHCI_CMD_TBL_SZ		= AHCI_CMD_TBL_HDR_SZ + (AHCI_MAX_SG * 16),
+	AHCI_CMD_TBL_AR_SZ	= AHCI_CMD_TBL_SZ * AHCI_MAX_CMDS,
+	AHCI_PORT_PRIV_DMA_SZ	= AHCI_CMD_SLOT_SZ + AHCI_CMD_TBL_AR_SZ +
+				  AHCI_RX_FIS_SZ,
+	AHCI_IRQ_ON_SG		= (1 << 31),
+	AHCI_CMD_ATAPI		= (1 << 5),
+	AHCI_CMD_WRITE		= (1 << 6),
+	AHCI_CMD_PREFETCH	= (1 << 7),
+	AHCI_CMD_RESET		= (1 << 8),
+	AHCI_CMD_CLR_BUSY	= (1 << 10),
+
+	RX_FIS_D2H_REG		= 0x40,	/* offset of D2H Register FIS data */
+	RX_FIS_SDB		= 0x58, /* offset of SDB FIS data */
+	RX_FIS_UNK		= 0x60, /* offset of Unknown FIS data */
+
+	/* global controller registers */
+	HOST_CAP		= 0x00, /* host capabilities */
+	HOST_CTL		= 0x04, /* global host control */
+	HOST_IRQ_STAT		= 0x08, /* interrupt status */
+	HOST_PORTS_IMPL		= 0x0c, /* bitmap of implemented ports */
+	HOST_VERSION		= 0x10, /* AHCI spec. version compliancy */
+	HOST_EM_LOC		= 0x1c, /* Enclosure Management location */
+	HOST_EM_CTL		= 0x20, /* Enclosure Management Control */
+
+	/* HOST_CTL bits */
+	HOST_RESET		= (1 << 0),  /* reset controller; self-clear */
+	HOST_IRQ_EN		= (1 << 1),  /* global IRQ enable */
+	HOST_AHCI_EN		= (1 << 31), /* AHCI enabled */
+
+	/* HOST_CAP bits */
+	HOST_CAP_EMS		= (1 << 6),  /* Enclosure Management support */
+	HOST_CAP_SSC		= (1 << 14), /* Slumber capable */
+	HOST_CAP_PMP		= (1 << 17), /* Port Multiplier support */
+	HOST_CAP_CLO		= (1 << 24), /* Command List Override support */
+	HOST_CAP_ALPM		= (1 << 26), /* Aggressive Link PM support */
+	HOST_CAP_SSS		= (1 << 27), /* Staggered Spin-up */
+	HOST_CAP_SNTF		= (1 << 29), /* SNotification register */
+	HOST_CAP_NCQ		= (1 << 30), /* Native Command Queueing */
+	HOST_CAP_64		= (1 << 31), /* PCI DAC (64-bit DMA) support */
+
+	/* registers for each SATA port */
+	PORT_LST_ADDR		= 0x00, /* command list DMA addr */
+	PORT_LST_ADDR_HI	= 0x04, /* command list DMA addr hi */
+	PORT_FIS_ADDR		= 0x08, /* FIS rx buf addr */
+	PORT_FIS_ADDR_HI	= 0x0c, /* FIS rx buf addr hi */
+	PORT_IRQ_STAT		= 0x10, /* interrupt status */
+	PORT_IRQ_MASK		= 0x14, /* interrupt enable/disable mask */
+	PORT_CMD		= 0x18, /* port command */
+	PORT_TFDATA		= 0x20,	/* taskfile data */
+	PORT_SIG		= 0x24,	/* device TF signature */
+	PORT_CMD_ISSUE		= 0x38, /* command issue */
+	PORT_SCR_STAT		= 0x28, /* SATA phy register: SStatus */
+	PORT_SCR_CTL		= 0x2c, /* SATA phy register: SControl */
+	PORT_SCR_ERR		= 0x30, /* SATA phy register: SError */
+	PORT_SCR_ACT		= 0x34, /* SATA phy register: SActive */
+	PORT_SCR_NTF		= 0x3c, /* SATA phy register: SNotification */
+
+	/* PORT_IRQ_{STAT,MASK} bits */
+	PORT_IRQ_COLD_PRES	= (1 << 31), /* cold presence detect */
+	PORT_IRQ_TF_ERR		= (1 << 30), /* task file error */
+	PORT_IRQ_HBUS_ERR	= (1 << 29), /* host bus fatal error */
+	PORT_IRQ_HBUS_DATA_ERR	= (1 << 28), /* host bus data error */
+	PORT_IRQ_IF_ERR		= (1 << 27), /* interface fatal error */
+	PORT_IRQ_IF_NONFATAL	= (1 << 26), /* interface non-fatal error */
+	PORT_IRQ_OVERFLOW	= (1 << 24), /* xfer exhausted available S/G */
+	PORT_IRQ_BAD_PMP	= (1 << 23), /* incorrect port multiplier */
+
+	PORT_IRQ_PHYRDY		= (1 << 22), /* PhyRdy changed */
+	PORT_IRQ_DEV_ILCK	= (1 << 7), /* device interlock */
+	PORT_IRQ_CONNECT	= (1 << 6), /* port connect change status */
+	PORT_IRQ_SG_DONE	= (1 << 5), /* descriptor processed */
+	PORT_IRQ_UNK_FIS	= (1 << 4), /* unknown FIS rx'd */
+	PORT_IRQ_SDB_FIS	= (1 << 3), /* Set Device Bits FIS rx'd */
+	PORT_IRQ_DMAS_FIS	= (1 << 2), /* DMA Setup FIS rx'd */
+	PORT_IRQ_PIOS_FIS	= (1 << 1), /* PIO Setup FIS rx'd */
+	PORT_IRQ_D2H_REG_FIS	= (1 << 0), /* D2H Register FIS rx'd */
+
+	PORT_IRQ_FREEZE		= PORT_IRQ_HBUS_ERR |
+				  PORT_IRQ_IF_ERR |
+				  PORT_IRQ_CONNECT |
+				  PORT_IRQ_PHYRDY |
+				  PORT_IRQ_UNK_FIS |
+				  PORT_IRQ_BAD_PMP,
+	PORT_IRQ_ERROR		= PORT_IRQ_FREEZE |
+				  PORT_IRQ_TF_ERR |
+				  PORT_IRQ_HBUS_DATA_ERR,
+	DEF_PORT_IRQ		= PORT_IRQ_ERROR | PORT_IRQ_SG_DONE |
+				  PORT_IRQ_SDB_FIS | PORT_IRQ_DMAS_FIS |
+				  PORT_IRQ_PIOS_FIS | PORT_IRQ_D2H_REG_FIS,
+
+	/* PORT_CMD bits */
+	PORT_CMD_ASP		= (1 << 27), /* Aggressive Slumber/Partial */
+	PORT_CMD_ALPE		= (1 << 26), /* Aggressive Link PM enable */
+	PORT_CMD_ATAPI		= (1 << 24), /* Device is ATAPI */
+	PORT_CMD_PMP		= (1 << 17), /* PMP attached */
+	PORT_CMD_LIST_ON	= (1 << 15), /* cmd list DMA engine running */
+	PORT_CMD_FIS_ON		= (1 << 14), /* FIS DMA engine running */
+	PORT_CMD_FIS_RX		= (1 << 4), /* Enable FIS receive DMA engine */
+	PORT_CMD_CLO		= (1 << 3), /* Command list override */
+	PORT_CMD_POWER_ON	= (1 << 2), /* Power up device */
+	PORT_CMD_SPIN_UP	= (1 << 1), /* Spin up device */
+	PORT_CMD_START		= (1 << 0), /* Enable port DMA engine */
+
+	PORT_CMD_ICC_MASK	= (0xf << 28), /* i/f ICC state mask */
+	PORT_CMD_ICC_ACTIVE	= (0x1 << 28), /* Put i/f in active state */
+	PORT_CMD_ICC_PARTIAL	= (0x2 << 28), /* Put i/f in partial state */
+	PORT_CMD_ICC_SLUMBER	= (0x6 << 28), /* Put i/f in slumber state */
+
+	/* hpriv->flags bits */
+	AHCI_HFLAG_NO_NCQ		= (1 << 0),
+	AHCI_HFLAG_IGN_IRQ_IF_ERR	= (1 << 1), /* ignore IRQ_IF_ERR */
+	AHCI_HFLAG_IGN_SERR_INTERNAL	= (1 << 2), /* ignore SERR_INTERNAL */
+	AHCI_HFLAG_32BIT_ONLY		= (1 << 3), /* force 32bit */
+	AHCI_HFLAG_MV_PATA		= (1 << 4), /* PATA port */
+	AHCI_HFLAG_NO_MSI		= (1 << 5), /* no PCI MSI */
+	AHCI_HFLAG_NO_PMP		= (1 << 6), /* no PMP */
+	AHCI_HFLAG_NO_HOTPLUG		= (1 << 7), /* ignore PxSERR.DIAG.N */
+	AHCI_HFLAG_SECT255		= (1 << 8), /* max 255 sectors */
+	AHCI_HFLAG_YES_NCQ		= (1 << 9), /* force NCQ cap on */
+
+	/* ap->flags bits */
+
+	AHCI_FLAG_COMMON		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
+					  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
+					  ATA_FLAG_ACPI_SATA | ATA_FLAG_AN |
+					  ATA_FLAG_IPM,
+
+	ICH_MAP				= 0x90, /* ICH MAP register */
+
+	/* em_ctl bits */
+	EM_CTL_RST			= (1 << 9), /* Reset */
+	EM_CTL_TM			= (1 << 8), /* Transmit Message */
+	EM_CTL_ALHD			= (1 << 26), /* Activity LED */
+};
+
+enum {
+	/* Enclosure Management Control */
+	EM_CTRL_MSG_TYPE		= 0x000f0000,
+
+	/* Enclosure Management LED Message Type */
+	EM_MSG_LED_HBA_PORT		= 0x0000000f,
+	EM_MSG_LED_PMP_SLOT		= 0x0000ff00,
+	EM_MSG_LED_VALUE		= 0xffff0000,
+	EM_MSG_LED_VALUE_ACTIVITY	= 0x00070000,
+	EM_MSG_LED_VALUE_OFF		= 0xfff80000,
+	EM_MSG_LED_VALUE_ON		= 0x00010000,
+
+	AHCI_EM_MAX_RETRY		= 15,
+};
+
+struct ahci_cmd_hdr {
+	__le32			opts;
+	__le32			status;
+	__le32			tbl_addr;
+	__le32			tbl_addr_hi;
+	__le32			reserved[4];
+};
+
+struct ahci_sg {
+	__le32			addr;
+	__le32			addr_hi;
+	__le32			reserved;
+	__le32			flags_size;
+};
+
+struct ahci_em_priv {
+	enum sw_activity blink_policy;
+	struct timer_list timer;
+	unsigned long saved_activity;
+	unsigned long activity;
+	unsigned long led_state;
+};
+
+struct ahci_host_priv {
+	unsigned int		flags;		/* AHCI_HFLAG_* */
+	u32			cap;		/* cap to use */
+	u32			port_map;	/* port map to use */
+	u32			saved_cap;	/* saved initial cap */
+	u32			saved_port_map;	/* saved initial port_map */
+	u32 			em_loc; /* enclosure management location */
+};
+
+struct ahci_port_priv {
+	struct ata_link		*active_link;
+	struct ahci_cmd_hdr	*cmd_slot;
+	dma_addr_t		cmd_slot_dma;
+	void			*cmd_tbl;
+	dma_addr_t		cmd_tbl_dma;
+	void			*rx_fis;
+	dma_addr_t		rx_fis_dma;
+	/* for NCQ spurious interrupt analysis */
+	unsigned int		ncq_saw_d2h:1;
+	unsigned int		ncq_saw_dmas:1;
+	unsigned int		ncq_saw_sdb:1;
+	u32 			intr_mask;	/* interrupts to enable */
+	struct ahci_em_priv	em_priv[AHCI_MAX_SLOTS];
+				     /* enclosure management info per PM slot */
+};
+
+static inline void __iomem *__ahci_port_base(struct ata_host *host,
+					     unsigned int port_no)
+{
+	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
+
+	return mmio + 0x100 + (port_no * 0x80);
+}
+
+static inline void __iomem *ahci_port_base(struct ata_port *ap)
+{
+	return __ahci_port_base(ap->host, ap->port_no);
+}
+
+static inline int ahci_nr_ports(u32 cap)
+{
+	return (cap & 0x1f) + 1;
+}
+
+extern void ahci_postreset(struct ata_link *link, unsigned int *class);
+extern void ahci_qc_prep(struct ata_queued_cmd *qc);
+extern void ahci_freeze(struct ata_port *ap);
+extern void ahci_thaw(struct ata_port *ap);
+extern void ahci_error_handler(struct ata_port *ap);
+extern void ahci_post_internal_cmd(struct ata_queued_cmd *qc);
+extern unsigned int ahci_qc_issue(struct ata_queued_cmd *qc);
+extern bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc);
+extern void ahci_init_controller(struct ata_host *host);
+extern int ahci_softreset(struct ata_link *link, unsigned int *class,
+		  unsigned long deadline);
+extern int ahci_hardreset(struct ata_link *link, unsigned int *class,
+		  unsigned long deadline);
+extern void ahci_start_engine(struct ata_port *ap);
+extern int ahci_stop_engine(struct ata_port *ap);
+extern int ahci_do_softreset(struct ata_link *link, unsigned int *class,
+			     int pmp, unsigned long deadline,
+			     int (*check_ready)(struct ata_link *link));
+extern int ahci_check_ready(struct ata_link *link);
+extern int ahci_kick_engine(struct ata_port *ap, int force_restart);
+extern int ahci_port_resume(struct ata_port *ap);
+extern void ahci_pmp_attach(struct ata_port *ap);
+extern void ahci_pmp_detach(struct ata_port *ap);
+extern int ahci_reset_controller(struct ata_host *host);
+extern int ahci_port_start(struct ata_port *ap);
+extern void ahci_port_stop(struct ata_port *ap);
+extern void ahci_save_initial_config(struct pci_dev *pdev,
+				     struct ahci_host_priv *hpriv);
+extern int ahci_configure_dma_masks(struct pci_dev *pdev, int using_dac);
+extern int ahci_reset_em(struct ata_host *host);
+extern int ahci_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
+extern int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
+extern void ahci_disable_alpm(struct ata_port *ap);
+extern int ahci_enable_alpm(struct ata_port *ap, enum link_pm policy);
+extern ssize_t ahci_led_show(struct ata_port *ap, char *buf);
+extern ssize_t ahci_led_store(struct ata_port *ap, const char *buf, size_t size);
+extern ssize_t ahci_activity_store(struct ata_device *dev, enum sw_activity val);
+extern ssize_t ahci_activity_show(struct ata_device *dev, char *buf);
+extern void ahci_print_info(struct ata_host *host);
+extern void ahci_port_intr(struct ata_port *ap);
+
+#ifdef CONFIG_PM
+extern int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg);
+extern int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
+extern int ahci_pci_device_resume(struct pci_dev *pdev);
+#endif /* CONFIG_PM */
+
+#endif /* __LINUX_AHCI_H__ */
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
new file mode 100644
index 0000000..929d555
--- /dev/null
+++ b/drivers/ata/libahci.c
@@ -0,0 +1,1737 @@
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/pci.h>
+#include <linux/libata.h>
+#include "ahci.h"
+
+#define DRV_VERSION "1.0"
+
+static int ahci_skip_host_reset;
+
+static void ahci_init_sw_activity(struct ata_link *link);
+static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
+					ssize_t size);
+static void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
+			       u32 opts);
+static void ahci_enable_ahci(void __iomem *mmio);
+
+module_param_named(skip_host_reset, ahci_skip_host_reset, int, 0444);
+MODULE_PARM_DESC(skip_host_reset, "skip global host reset (0=don't skip, 1=skip)");
+
+MODULE_AUTHOR("Jeff Garzik");
+MODULE_DESCRIPTION("AHCI helper library");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
+
+static unsigned ahci_scr_offset(struct ata_port *ap, unsigned int sc_reg)
+{
+	static const int offset[] = {
+		[SCR_STATUS]		= PORT_SCR_STAT,
+		[SCR_CONTROL]		= PORT_SCR_CTL,
+		[SCR_ERROR]		= PORT_SCR_ERR,
+		[SCR_ACTIVE]		= PORT_SCR_ACT,
+		[SCR_NOTIFICATION]	= PORT_SCR_NTF,
+	};
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+
+	if (sc_reg < ARRAY_SIZE(offset) &&
+	    (sc_reg != SCR_NOTIFICATION || (hpriv->cap & HOST_CAP_SNTF)))
+		return offset[sc_reg];
+	return 0;
+}
+
+int ahci_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val)
+{
+	void __iomem *port_mmio = ahci_port_base(link->ap);
+	int offset = ahci_scr_offset(link->ap, sc_reg);
+
+	if (offset) {
+		*val = readl(port_mmio + offset);
+		return 0;
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(ahci_scr_read);
+
+int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
+{
+	void __iomem *port_mmio = ahci_port_base(link->ap);
+	int offset = ahci_scr_offset(link->ap, sc_reg);
+
+	if (offset) {
+		writel(val, port_mmio + offset);
+		return 0;
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(ahci_scr_write);
+
+void ahci_pmp_attach(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	struct ahci_port_priv *pp = ap->private_data;
+	u32 cmd;
+
+	cmd = readl(port_mmio + PORT_CMD);
+	cmd |= PORT_CMD_PMP;
+	writel(cmd, port_mmio + PORT_CMD);
+
+	pp->intr_mask |= PORT_IRQ_BAD_PMP;
+	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
+}
+EXPORT_SYMBOL_GPL(ahci_pmp_attach);
+
+void ahci_pmp_detach(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	struct ahci_port_priv *pp = ap->private_data;
+	u32 cmd;
+
+	cmd = readl(port_mmio + PORT_CMD);
+	cmd &= ~PORT_CMD_PMP;
+	writel(cmd, port_mmio + PORT_CMD);
+
+	pp->intr_mask &= ~PORT_IRQ_BAD_PMP;
+	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
+}
+EXPORT_SYMBOL_GPL(ahci_pmp_detach);
+
+void ahci_start_engine(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 tmp;
+
+	/* start DMA */
+	tmp = readl(port_mmio + PORT_CMD);
+	tmp |= PORT_CMD_START;
+	writel(tmp, port_mmio + PORT_CMD);
+	readl(port_mmio + PORT_CMD); /* flush */
+}
+EXPORT_SYMBOL_GPL(ahci_start_engine);
+
+int ahci_stop_engine(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 tmp;
+
+	tmp = readl(port_mmio + PORT_CMD);
+
+	/* check if the HBA is idle */
+	if ((tmp & (PORT_CMD_START | PORT_CMD_LIST_ON)) == 0)
+		return 0;
+
+	/* setting HBA to idle */
+	tmp &= ~PORT_CMD_START;
+	writel(tmp, port_mmio + PORT_CMD);
+
+	/* wait for engine to stop. This could be as long as 500 msec */
+	tmp = ata_wait_register(port_mmio + PORT_CMD,
+				PORT_CMD_LIST_ON, PORT_CMD_LIST_ON, 1, 500);
+	if (tmp & PORT_CMD_LIST_ON)
+		return -EIO;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ahci_stop_engine);
+
+int ahci_kick_engine(struct ata_port *ap, int force_restart)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	u8 status = readl(port_mmio + PORT_TFDATA) & 0xFF;
+	u32 tmp;
+	int busy, rc;
+
+	/* do we need to kick the port? */
+	busy = status & (ATA_BUSY | ATA_DRQ);
+	if (!busy && !force_restart)
+		return 0;
+
+	/* stop engine */
+	rc = ahci_stop_engine(ap);
+	if (rc)
+		goto out_restart;
+
+	/* need to do CLO? */
+	if (!busy) {
+		rc = 0;
+		goto out_restart;
+	}
+
+	if (!(hpriv->cap & HOST_CAP_CLO)) {
+		rc = -EOPNOTSUPP;
+		goto out_restart;
+	}
+
+	/* perform CLO */
+	tmp = readl(port_mmio + PORT_CMD);
+	tmp |= PORT_CMD_CLO;
+	writel(tmp, port_mmio + PORT_CMD);
+
+	rc = 0;
+	tmp = ata_wait_register(port_mmio + PORT_CMD,
+				PORT_CMD_CLO, PORT_CMD_CLO, 1, 500);
+	if (tmp & PORT_CMD_CLO)
+		rc = -EIO;
+
+	/* restart engine */
+ out_restart:
+	ahci_start_engine(ap);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(ahci_kick_engine);
+
+static void ahci_start_fis_rx(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	struct ahci_port_priv *pp = ap->private_data;
+	u32 tmp;
+
+	/* set FIS registers */
+	if (hpriv->cap & HOST_CAP_64)
+		writel((pp->cmd_slot_dma >> 16) >> 16,
+		       port_mmio + PORT_LST_ADDR_HI);
+	writel(pp->cmd_slot_dma & 0xffffffff, port_mmio + PORT_LST_ADDR);
+
+	if (hpriv->cap & HOST_CAP_64)
+		writel((pp->rx_fis_dma >> 16) >> 16,
+		       port_mmio + PORT_FIS_ADDR_HI);
+	writel(pp->rx_fis_dma & 0xffffffff, port_mmio + PORT_FIS_ADDR);
+
+	/* enable FIS reception */
+	tmp = readl(port_mmio + PORT_CMD);
+	tmp |= PORT_CMD_FIS_RX;
+	writel(tmp, port_mmio + PORT_CMD);
+
+	/* flush */
+	readl(port_mmio + PORT_CMD);
+}
+
+static int ahci_stop_fis_rx(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 tmp;
+
+	/* disable FIS reception */
+	tmp = readl(port_mmio + PORT_CMD);
+	tmp &= ~PORT_CMD_FIS_RX;
+	writel(tmp, port_mmio + PORT_CMD);
+
+	/* wait for completion, spec says 500ms, give it 1000 */
+	tmp = ata_wait_register(port_mmio + PORT_CMD, PORT_CMD_FIS_ON,
+				PORT_CMD_FIS_ON, 10, 1000);
+	if (tmp & PORT_CMD_FIS_ON)
+		return -EBUSY;
+
+	return 0;
+}
+
+static void ahci_start_port(struct ata_port *ap)
+{
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ata_link *link;
+	struct ahci_em_priv *emp;
+	ssize_t rc;
+	int i;
+
+	/* enable FIS reception */
+	ahci_start_fis_rx(ap);
+
+	/* enable DMA */
+	ahci_start_engine(ap);
+
+	/* turn on LEDs */
+	if (ap->flags & ATA_FLAG_EM) {
+		ata_for_each_link(link, ap, EDGE) {
+			emp = &pp->em_priv[link->pmp];
+
+			/* EM Transmit bit maybe busy during init */
+			for (i = 0; i < AHCI_EM_MAX_RETRY; i++) {
+				rc = ahci_transmit_led_message(ap,
+							       emp->led_state,
+							       4);
+				if (rc == -EBUSY)
+					udelay(100);
+				else
+					break;
+			}
+		}
+	}
+
+	if (ap->flags & ATA_FLAG_SW_ACTIVITY)
+		ata_for_each_link(link, ap, EDGE)
+			ahci_init_sw_activity(link);
+
+}
+
+static int ahci_deinit_port(struct ata_port *ap, const char **emsg)
+{
+	int rc;
+
+	/* disable DMA */
+	rc = ahci_stop_engine(ap);
+	if (rc) {
+		*emsg = "failed to stop engine";
+		return rc;
+	}
+
+	/* disable FIS reception */
+	rc = ahci_stop_fis_rx(ap);
+	if (rc) {
+		*emsg = "failed stop FIS RX";
+		return rc;
+	}
+
+	return 0;
+}
+
+static void ahci_port_init(struct pci_dev *pdev, struct ata_port *ap,
+			   int port_no, void __iomem *mmio,
+			   void __iomem *port_mmio)
+{
+	const char *emsg = NULL;
+	int rc;
+	u32 tmp;
+
+	/* make sure port is not active */
+	rc = ahci_deinit_port(ap, &emsg);
+	if (rc)
+		dev_printk(KERN_WARNING, &pdev->dev,
+			   "%s (%d)\n", emsg, rc);
+
+	/* clear SError */
+	tmp = readl(port_mmio + PORT_SCR_ERR);
+	VPRINTK("PORT_SCR_ERR 0x%x\n", tmp);
+	writel(tmp, port_mmio + PORT_SCR_ERR);
+
+	/* clear port IRQ */
+	tmp = readl(port_mmio + PORT_IRQ_STAT);
+	VPRINTK("PORT_IRQ_STAT 0x%x\n", tmp);
+	if (tmp)
+		writel(tmp, port_mmio + PORT_IRQ_STAT);
+
+	writel(1 << port_no, mmio + HOST_IRQ_STAT);
+}
+
+int ahci_port_start(struct ata_port *ap)
+{
+	struct device *dev = ap->host->dev;
+	struct ahci_port_priv *pp;
+	void *mem;
+	dma_addr_t mem_dma;
+
+	pp = devm_kzalloc(dev, sizeof(*pp), GFP_KERNEL);
+	if (!pp)
+		return -ENOMEM;
+
+	mem = dmam_alloc_coherent(dev, AHCI_PORT_PRIV_DMA_SZ, &mem_dma,
+				  GFP_KERNEL);
+	if (!mem)
+		return -ENOMEM;
+	memset(mem, 0, AHCI_PORT_PRIV_DMA_SZ);
+
+	/*
+	 * First item in chunk of DMA memory: 32-slot command table,
+	 * 32 bytes each in size
+	 */
+	pp->cmd_slot = mem;
+	pp->cmd_slot_dma = mem_dma;
+
+	mem += AHCI_CMD_SLOT_SZ;
+	mem_dma += AHCI_CMD_SLOT_SZ;
+
+	/*
+	 * Second item: Received-FIS area
+	 */
+	pp->rx_fis = mem;
+	pp->rx_fis_dma = mem_dma;
+
+	mem += AHCI_RX_FIS_SZ;
+	mem_dma += AHCI_RX_FIS_SZ;
+
+	/*
+	 * Third item: data area for storing a single command
+	 * and its scatter-gather table
+	 */
+	pp->cmd_tbl = mem;
+	pp->cmd_tbl_dma = mem_dma;
+
+	/*
+	 * Save off initial list of interrupts to be enabled.
+	 * This could be changed later
+	 */
+	pp->intr_mask = DEF_PORT_IRQ;
+
+	ap->private_data = pp;
+
+	/* engage engines, captain */
+	return ahci_port_resume(ap);
+}
+EXPORT_SYMBOL_GPL(ahci_port_start);
+
+void ahci_port_stop(struct ata_port *ap)
+{
+	const char *emsg = NULL;
+	int rc;
+
+	/* de-initialize port */
+	rc = ahci_deinit_port(ap, &emsg);
+	if (rc)
+		ata_port_printk(ap, KERN_WARNING, "%s (%d)\n", emsg, rc);
+}
+EXPORT_SYMBOL_GPL(ahci_port_stop);
+
+int ahci_configure_dma_masks(struct pci_dev *pdev, int using_dac)
+{
+	int rc;
+
+	if (using_dac &&
+	    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
+		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+		if (rc) {
+			rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+			if (rc) {
+				dev_printk(KERN_ERR, &pdev->dev,
+					   "64-bit DMA enable failed\n");
+				return rc;
+			}
+		}
+	} else {
+		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		if (rc) {
+			dev_printk(KERN_ERR, &pdev->dev,
+				   "32-bit DMA enable failed\n");
+			return rc;
+		}
+		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+		if (rc) {
+			dev_printk(KERN_ERR, &pdev->dev,
+				   "32-bit consistent DMA enable failed\n");
+			return rc;
+		}
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ahci_configure_dma_masks);
+
+void ahci_init_controller(struct ata_host *host)
+{
+	struct ahci_host_priv *hpriv = host->private_data;
+	struct pci_dev *pdev = to_pci_dev(host->dev);
+	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
+	int i;
+	void __iomem *port_mmio;
+	u32 tmp;
+	int mv;
+
+	if (hpriv->flags & AHCI_HFLAG_MV_PATA) {
+		if (pdev->device == 0x6121)
+			mv = 2;
+		else
+			mv = 4;
+		port_mmio = __ahci_port_base(host, mv);
+
+		writel(0, port_mmio + PORT_IRQ_MASK);
+
+		/* clear port IRQ */
+		tmp = readl(port_mmio + PORT_IRQ_STAT);
+		VPRINTK("PORT_IRQ_STAT 0x%x\n", tmp);
+		if (tmp)
+			writel(tmp, port_mmio + PORT_IRQ_STAT);
+	}
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		port_mmio = ahci_port_base(ap);
+		if (ata_port_is_dummy(ap))
+			continue;
+
+		ahci_port_init(pdev, ap, i, mmio, port_mmio);
+	}
+
+	tmp = readl(mmio + HOST_CTL);
+	VPRINTK("HOST_CTL 0x%x\n", tmp);
+	writel(tmp | HOST_IRQ_EN, mmio + HOST_CTL);
+	tmp = readl(mmio + HOST_CTL);
+	VPRINTK("HOST_CTL 0x%x\n", tmp);
+}
+EXPORT_SYMBOL_GPL(ahci_init_controller);
+
+/**
+ *	ahci_save_initial_config - Save and fixup initial config values
+ *	@pdev: target PCI device
+ *	@hpriv: host private area to store config values
+ *
+ *	Some registers containing configuration info might be setup by
+ *	BIOS and might be cleared on reset.  This function saves the
+ *	initial values of those registers into @hpriv such that they
+ *	can be restored after controller reset.
+ *
+ *	If inconsistent, config values are fixed up by this function.
+ *
+ *	LOCKING:
+ *	None.
+ */
+void ahci_save_initial_config(struct pci_dev *pdev,
+				     struct ahci_host_priv *hpriv)
+{
+	void __iomem *mmio = pcim_iomap_table(pdev)[AHCI_PCI_BAR];
+	u32 cap, port_map;
+	int i;
+	int mv;
+
+	/* make sure AHCI mode is enabled before accessing CAP */
+	ahci_enable_ahci(mmio);
+
+	/* Values prefixed with saved_ are written back to host after
+	 * reset.  Values without are used for driver operation.
+	 */
+	hpriv->saved_cap = cap = readl(mmio + HOST_CAP);
+	hpriv->saved_port_map = port_map = readl(mmio + HOST_PORTS_IMPL);
+
+	/* some chips have errata preventing 64bit use */
+	if ((cap & HOST_CAP_64) && (hpriv->flags & AHCI_HFLAG_32BIT_ONLY)) {
+		dev_printk(KERN_INFO, &pdev->dev,
+			   "controller can't do 64bit DMA, forcing 32bit\n");
+		cap &= ~HOST_CAP_64;
+	}
+
+	if ((cap & HOST_CAP_NCQ) && (hpriv->flags & AHCI_HFLAG_NO_NCQ)) {
+		dev_printk(KERN_INFO, &pdev->dev,
+			   "controller can't do NCQ, turning off CAP_NCQ\n");
+		cap &= ~HOST_CAP_NCQ;
+	}
+
+	if (!(cap & HOST_CAP_NCQ) && (hpriv->flags & AHCI_HFLAG_YES_NCQ)) {
+		dev_printk(KERN_INFO, &pdev->dev,
+			   "controller can do NCQ, turning on CAP_NCQ\n");
+		cap |= HOST_CAP_NCQ;
+	}
+
+	if ((cap & HOST_CAP_PMP) && (hpriv->flags & AHCI_HFLAG_NO_PMP)) {
+		dev_printk(KERN_INFO, &pdev->dev,
+			   "controller can't do PMP, turning off CAP_PMP\n");
+		cap &= ~HOST_CAP_PMP;
+	}
+
+	if (pdev->vendor == PCI_VENDOR_ID_JMICRON && pdev->device == 0x2361 &&
+	    port_map != 1) {
+		dev_printk(KERN_INFO, &pdev->dev,
+			   "JMB361 has only one port, port_map 0x%x -> 0x%x\n",
+			   port_map, 1);
+		port_map = 1;
+	}
+
+	/*
+	 * Temporary Marvell 6145 hack: PATA port presence
+	 * is asserted through the standard AHCI port
+	 * presence register, as bit 4 (counting from 0)
+	 */
+	if (hpriv->flags & AHCI_HFLAG_MV_PATA) {
+		if (pdev->device == 0x6121)
+			mv = 0x3;
+		else
+			mv = 0xf;
+		dev_printk(KERN_ERR, &pdev->dev,
+			   "MV_AHCI HACK: port_map %x -> %x\n",
+			   port_map,
+			   port_map & mv);
+		dev_printk(KERN_ERR, &pdev->dev,
+			  "Disabling your PATA port. Use the boot option 'ahci.marvell_enable=0' to avoid this.\n");
+
+		port_map &= mv;
+	}
+
+	/* cross check port_map and cap.n_ports */
+	if (port_map) {
+		int map_ports = 0;
+
+		for (i = 0; i < AHCI_MAX_PORTS; i++)
+			if (port_map & (1 << i))
+				map_ports++;
+
+		/* If PI has more ports than n_ports, whine, clear
+		 * port_map and let it be generated from n_ports.
+		 */
+		if (map_ports > ahci_nr_ports(cap)) {
+			dev_printk(KERN_WARNING, &pdev->dev,
+				   "implemented port map (0x%x) contains more "
+				   "ports than nr_ports (%u), using nr_ports\n",
+				   port_map, ahci_nr_ports(cap));
+			port_map = 0;
+		}
+	}
+
+	/* fabricate port_map from cap.nr_ports */
+	if (!port_map) {
+		port_map = (1 << ahci_nr_ports(cap)) - 1;
+		dev_printk(KERN_WARNING, &pdev->dev,
+			   "forcing PORTS_IMPL to 0x%x\n", port_map);
+
+		/* write the fixed up value to the PI register */
+		hpriv->saved_port_map = port_map;
+	}
+
+	/* record values to use during operation */
+	hpriv->cap = cap;
+	hpriv->port_map = port_map;
+}
+EXPORT_SYMBOL_GPL(ahci_save_initial_config);
+
+/**
+ *	ahci_restore_initial_config - Restore initial config
+ *	@host: target ATA host
+ *
+ *	Restore initial config stored by ahci_save_initial_config().
+ *
+ *	LOCKING:
+ *	None.
+ */
+static void ahci_restore_initial_config(struct ata_host *host)
+{
+	struct ahci_host_priv *hpriv = host->private_data;
+	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
+
+	writel(hpriv->saved_cap, mmio + HOST_CAP);
+	writel(hpriv->saved_port_map, mmio + HOST_PORTS_IMPL);
+	(void) readl(mmio + HOST_PORTS_IMPL);	/* flush */
+}
+
+static void ahci_enable_ahci(void __iomem *mmio)
+{
+	int i;
+	u32 tmp;
+
+	/* turn on AHCI_EN */
+	tmp = readl(mmio + HOST_CTL);
+	if (tmp & HOST_AHCI_EN)
+		return;
+
+	/* Some controllers need AHCI_EN to be written multiple times.
+	 * Try a few times before giving up.
+	 */
+	for (i = 0; i < 5; i++) {
+		tmp |= HOST_AHCI_EN;
+		writel(tmp, mmio + HOST_CTL);
+		tmp = readl(mmio + HOST_CTL);	/* flush && sanity check */
+		if (tmp & HOST_AHCI_EN)
+			return;
+		msleep(10);
+	}
+
+	WARN_ON(1);
+}
+
+int ahci_reset_controller(struct ata_host *host)
+{
+	struct pci_dev *pdev = to_pci_dev(host->dev);
+	struct ahci_host_priv *hpriv = host->private_data;
+	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
+	u32 tmp;
+
+	/* we must be in AHCI mode, before using anything
+	 * AHCI-specific, such as HOST_RESET.
+	 */
+	ahci_enable_ahci(mmio);
+
+	/* global controller reset */
+	if (!ahci_skip_host_reset) {
+		tmp = readl(mmio + HOST_CTL);
+		if ((tmp & HOST_RESET) == 0) {
+			writel(tmp | HOST_RESET, mmio + HOST_CTL);
+			readl(mmio + HOST_CTL); /* flush */
+		}
+
+		/*
+		 * to perform host reset, OS should set HOST_RESET
+		 * and poll until this bit is read to be "0".
+		 * reset must complete within 1 second, or
+		 * the hardware should be considered fried.
+		 */
+		tmp = ata_wait_register(mmio + HOST_CTL, HOST_RESET,
+					HOST_RESET, 10, 1000);
+
+		if (tmp & HOST_RESET) {
+			dev_printk(KERN_ERR, host->dev,
+				   "controller reset failed (0x%x)\n", tmp);
+			return -EIO;
+		}
+
+		/* turn on AHCI mode */
+		ahci_enable_ahci(mmio);
+
+		/* Some registers might be cleared on reset.  Restore
+		 * initial values.
+		 */
+		ahci_restore_initial_config(host);
+	} else
+		dev_printk(KERN_INFO, host->dev,
+			   "skipping global host reset\n");
+
+	if (pdev->vendor == PCI_VENDOR_ID_INTEL) {
+		u16 tmp16;
+
+		/* configure PCS */
+		pci_read_config_word(pdev, 0x92, &tmp16);
+		if ((tmp16 & hpriv->port_map) != hpriv->port_map) {
+			tmp16 |= hpriv->port_map;
+			pci_write_config_word(pdev, 0x92, tmp16);
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ahci_reset_controller);
+
+static void ahci_power_up(struct ata_port *ap)
+{
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 cmd;
+
+	cmd = readl(port_mmio + PORT_CMD) & ~PORT_CMD_ICC_MASK;
+
+	/* spin up device */
+	if (hpriv->cap & HOST_CAP_SSS) {
+		cmd |= PORT_CMD_SPIN_UP;
+		writel(cmd, port_mmio + PORT_CMD);
+	}
+
+	/* wake up link */
+	writel(cmd | PORT_CMD_ICC_ACTIVE, port_mmio + PORT_CMD);
+}
+
+#ifdef CONFIG_PM
+static void ahci_power_down(struct ata_port *ap)
+{
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 cmd, scontrol;
+
+	if (!(hpriv->cap & HOST_CAP_SSS))
+		return;
+
+	/* put device into listen mode, first set PxSCTL.DET to 0 */
+	scontrol = readl(port_mmio + PORT_SCR_CTL);
+	scontrol &= ~0xf;
+	writel(scontrol, port_mmio + PORT_SCR_CTL);
+
+	/* then set PxCMD.SUD to 0 */
+	cmd = readl(port_mmio + PORT_CMD) & ~PORT_CMD_ICC_MASK;
+	cmd &= ~PORT_CMD_SPIN_UP;
+	writel(cmd, port_mmio + PORT_CMD);
+}
+#endif
+
+int ahci_port_resume(struct ata_port *ap)
+{
+	ahci_power_up(ap);
+	ahci_start_port(ap);
+
+	if (sata_pmp_attached(ap))
+		ahci_pmp_attach(ap);
+	else
+		ahci_pmp_detach(ap);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ahci_port_resume);
+
+#ifdef CONFIG_PM
+int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg)
+{
+	const char *emsg = NULL;
+	int rc;
+
+	rc = ahci_deinit_port(ap, &emsg);
+	if (rc == 0)
+		ahci_power_down(ap);
+	else {
+		ata_port_printk(ap, KERN_ERR, "%s (%d)\n", emsg, rc);
+		ahci_start_port(ap);
+	}
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(ahci_port_suspend);
+
+int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
+	u32 ctl;
+
+	if (mesg.event & PM_EVENT_SLEEP) {
+		/* AHCI spec rev1.1 section 8.3.3:
+		 * Software must disable interrupts prior to requesting a
+		 * transition of the HBA to D3 state.
+		 */
+		ctl = readl(mmio + HOST_CTL);
+		ctl &= ~HOST_IRQ_EN;
+		writel(ctl, mmio + HOST_CTL);
+		readl(mmio + HOST_CTL); /* flush */
+	}
+
+	return ata_pci_device_suspend(pdev, mesg);
+}
+EXPORT_SYMBOL_GPL(ahci_pci_device_suspend);
+
+int ahci_pci_device_resume(struct pci_dev *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	int rc;
+
+	rc = ata_pci_device_do_resume(pdev);
+	if (rc)
+		return rc;
+
+	if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
+		rc = ahci_reset_controller(host);
+		if (rc)
+			return rc;
+
+		ahci_init_controller(host);
+	}
+
+	ata_host_resume(host);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ahci_pci_device_resume);
+#endif
+
+void ahci_freeze(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+
+	/* turn IRQ off */
+	writel(0, port_mmio + PORT_IRQ_MASK);
+}
+EXPORT_SYMBOL_GPL(ahci_freeze);
+
+void ahci_thaw(struct ata_port *ap)
+{
+	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 tmp;
+	struct ahci_port_priv *pp = ap->private_data;
+
+	/* clear IRQ */
+	tmp = readl(port_mmio + PORT_IRQ_STAT);
+	writel(tmp, port_mmio + PORT_IRQ_STAT);
+	writel(1 << ap->port_no, mmio + HOST_IRQ_STAT);
+
+	/* turn IRQ back on */
+	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
+}
+EXPORT_SYMBOL_GPL(ahci_thaw);
+
+void ahci_error_handler(struct ata_port *ap)
+{
+	if (!(ap->pflags & ATA_PFLAG_FROZEN)) {
+		/* restart engine */
+		ahci_stop_engine(ap);
+		ahci_start_engine(ap);
+	}
+
+	sata_pmp_error_handler(ap);
+}
+EXPORT_SYMBOL_GPL(ahci_error_handler);
+
+void ahci_post_internal_cmd(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+
+	/* make DMA engine forget about the failed command */
+	if (qc->flags & ATA_QCFLAG_FAILED)
+		ahci_kick_engine(ap, 1);
+}
+EXPORT_SYMBOL_GPL(ahci_post_internal_cmd);
+
+static unsigned int ahci_dev_classify(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	struct ata_taskfile tf;
+	u32 tmp;
+
+	tmp = readl(port_mmio + PORT_SIG);
+	tf.lbah		= (tmp >> 24)	& 0xff;
+	tf.lbam		= (tmp >> 16)	& 0xff;
+	tf.lbal		= (tmp >> 8)	& 0xff;
+	tf.nsect	= (tmp)		& 0xff;
+
+	return ata_dev_classify(&tf);
+}
+
+static int ahci_exec_polled_cmd(struct ata_port *ap, int pmp,
+				struct ata_taskfile *tf, int is_cmd, u16 flags,
+				unsigned long timeout_msec)
+{
+	const u32 cmd_fis_len = 5; /* five dwords */
+	struct ahci_port_priv *pp = ap->private_data;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u8 *fis = pp->cmd_tbl;
+	u32 tmp;
+
+	/* prep the command */
+	ata_tf_to_fis(tf, pmp, is_cmd, fis);
+	ahci_fill_cmd_slot(pp, 0, cmd_fis_len | flags | (pmp << 12));
+
+	/* issue & wait */
+	writel(1, port_mmio + PORT_CMD_ISSUE);
+
+	if (timeout_msec) {
+		tmp = ata_wait_register(port_mmio + PORT_CMD_ISSUE, 0x1, 0x1,
+					1, timeout_msec);
+		if (tmp & 0x1) {
+			ahci_kick_engine(ap, 1);
+			return -EBUSY;
+		}
+	} else
+		readl(port_mmio + PORT_CMD_ISSUE);	/* flush */
+
+	return 0;
+}
+
+int ahci_do_softreset(struct ata_link *link, unsigned int *class,
+			     int pmp, unsigned long deadline,
+			     int (*check_ready)(struct ata_link *link))
+{
+	struct ata_port *ap = link->ap;
+	const char *reason = NULL;
+	unsigned long now, msecs;
+	struct ata_taskfile tf;
+	int rc;
+
+	DPRINTK("ENTER\n");
+
+	/* prepare for SRST (AHCI-1.1 10.4.1) */
+	rc = ahci_kick_engine(ap, 1);
+	if (rc && rc != -EOPNOTSUPP)
+		ata_link_printk(link, KERN_WARNING,
+				"failed to reset engine (errno=%d)\n", rc);
+
+	ata_tf_init(link->device, &tf);
+
+	/* issue the first D2H Register FIS */
+	msecs = 0;
+	now = jiffies;
+	if (time_after(now, deadline))
+		msecs = jiffies_to_msecs(deadline - now);
+
+	tf.ctl |= ATA_SRST;
+	if (ahci_exec_polled_cmd(ap, pmp, &tf, 0,
+				 AHCI_CMD_RESET | AHCI_CMD_CLR_BUSY, msecs)) {
+		rc = -EIO;
+		reason = "1st FIS failed";
+		goto fail;
+	}
+
+	/* spec says at least 5us, but be generous and sleep for 1ms */
+	msleep(1);
+
+	/* issue the second D2H Register FIS */
+	tf.ctl &= ~ATA_SRST;
+	ahci_exec_polled_cmd(ap, pmp, &tf, 0, 0, 0);
+
+	/* wait for link to become ready */
+	rc = ata_wait_after_reset(link, deadline, check_ready);
+	/* link occupied, -ENODEV too is an error */
+	if (rc) {
+		reason = "device not ready";
+		goto fail;
+	}
+	*class = ahci_dev_classify(ap);
+
+	DPRINTK("EXIT, class=%u\n", *class);
+	return 0;
+
+ fail:
+	ata_link_printk(link, KERN_ERR, "softreset failed (%s)\n", reason);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(ahci_do_softreset);
+
+int ahci_check_ready(struct ata_link *link)
+{
+	void __iomem *port_mmio = ahci_port_base(link->ap);
+	u8 status = readl(port_mmio + PORT_TFDATA) & 0xFF;
+
+	return ata_check_ready(status);
+}
+EXPORT_SYMBOL_GPL(ahci_check_ready);
+
+int ahci_softreset(struct ata_link *link, unsigned int *class,
+		  unsigned long deadline)
+{
+	int pmp = sata_srst_pmp(link);
+
+	DPRINTK("ENTER\n");
+
+	return ahci_do_softreset(link, class, pmp, deadline, ahci_check_ready);
+}
+EXPORT_SYMBOL_GPL(ahci_softreset);
+
+int ahci_hardreset(struct ata_link *link, unsigned int *class,
+		  unsigned long deadline)
+{
+	const unsigned long *timing = sata_ehc_deb_timing(&link->eh_context);
+	struct ata_port *ap = link->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
+	struct ata_taskfile tf;
+	bool online;
+	int rc;
+
+	DPRINTK("ENTER\n");
+
+	ahci_stop_engine(ap);
+
+	/* clear D2H reception area to properly wait for D2H FIS */
+	ata_tf_init(link->device, &tf);
+	tf.command = 0x80;
+	ata_tf_to_fis(&tf, 0, 0, d2h_fis);
+
+	rc = sata_link_hardreset(link, timing, deadline, &online,
+				 ahci_check_ready);
+
+	ahci_start_engine(ap);
+
+	if (online)
+		*class = ahci_dev_classify(ap);
+
+	DPRINTK("EXIT, rc=%d, class=%u\n", rc, *class);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(ahci_hardreset);
+
+void ahci_postreset(struct ata_link *link, unsigned int *class)
+{
+	struct ata_port *ap = link->ap;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 new_tmp, tmp;
+
+	ata_std_postreset(link, class);
+
+	/* Make sure port's ATAPI bit is set appropriately */
+	new_tmp = tmp = readl(port_mmio + PORT_CMD);
+	if (*class == ATA_DEV_ATAPI)
+		new_tmp |= PORT_CMD_ATAPI;
+	else
+		new_tmp &= ~PORT_CMD_ATAPI;
+	if (new_tmp != tmp) {
+		writel(new_tmp, port_mmio + PORT_CMD);
+		readl(port_mmio + PORT_CMD); /* flush */
+	}
+}
+EXPORT_SYMBOL_GPL(ahci_postreset);
+
+static void ahci_sw_activity(struct ata_link *link)
+{
+	struct ata_port *ap = link->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ahci_em_priv *emp = &pp->em_priv[link->pmp];
+
+	if (!(link->flags & ATA_LFLAG_SW_ACTIVITY))
+		return;
+
+	emp->activity++;
+	if (!timer_pending(&emp->timer))
+		mod_timer(&emp->timer, jiffies + msecs_to_jiffies(10));
+}
+
+static void ahci_sw_activity_blink(unsigned long arg)
+{
+	struct ata_link *link = (struct ata_link *)arg;
+	struct ata_port *ap = link->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ahci_em_priv *emp = &pp->em_priv[link->pmp];
+	unsigned long led_message = emp->led_state;
+	u32 activity_led_state;
+	unsigned long flags;
+
+	led_message &= EM_MSG_LED_VALUE;
+	led_message |= ap->port_no | (link->pmp << 8);
+
+	/* check to see if we've had activity.  If so,
+	 * toggle state of LED and reset timer.  If not,
+	 * turn LED to desired idle state.
+	 */
+	spin_lock_irqsave(ap->lock, flags);
+	if (emp->saved_activity != emp->activity) {
+		emp->saved_activity = emp->activity;
+		/* get the current LED state */
+		activity_led_state = led_message & EM_MSG_LED_VALUE_ON;
+
+		if (activity_led_state)
+			activity_led_state = 0;
+		else
+			activity_led_state = 1;
+
+		/* clear old state */
+		led_message &= ~EM_MSG_LED_VALUE_ACTIVITY;
+
+		/* toggle state */
+		led_message |= (activity_led_state << 16);
+		mod_timer(&emp->timer, jiffies + msecs_to_jiffies(100));
+	} else {
+		/* switch to idle */
+		led_message &= ~EM_MSG_LED_VALUE_ACTIVITY;
+		if (emp->blink_policy == BLINK_OFF)
+			led_message |= (1 << 16);
+	}
+	spin_unlock_irqrestore(ap->lock, flags);
+	ahci_transmit_led_message(ap, led_message, 4);
+}
+
+static void ahci_init_sw_activity(struct ata_link *link)
+{
+	struct ata_port *ap = link->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ahci_em_priv *emp = &pp->em_priv[link->pmp];
+
+	/* init activity stats, setup timer */
+	emp->saved_activity = emp->activity = 0;
+	setup_timer(&emp->timer, ahci_sw_activity_blink, (unsigned long)link);
+
+	/* check our blink policy and set flag for link if it's enabled */
+	if (emp->blink_policy)
+		link->flags |= ATA_LFLAG_SW_ACTIVITY;
+}
+
+int ahci_reset_em(struct ata_host *host)
+{
+	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
+	u32 em_ctl;
+
+	em_ctl = readl(mmio + HOST_EM_CTL);
+	if ((em_ctl & EM_CTL_TM) || (em_ctl & EM_CTL_RST))
+		return -EINVAL;
+
+	writel(em_ctl | EM_CTL_RST, mmio + HOST_EM_CTL);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ahci_reset_em);
+
+static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
+					ssize_t size)
+{
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	struct ahci_port_priv *pp = ap->private_data;
+	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
+	u32 em_ctl;
+	u32 message[] = {0, 0};
+	unsigned long flags;
+	int pmp;
+	struct ahci_em_priv *emp;
+
+	/* get the slot number from the message */
+	pmp = (state & EM_MSG_LED_PMP_SLOT) >> 8;
+	if (pmp < AHCI_MAX_SLOTS)
+		emp = &pp->em_priv[pmp];
+	else
+		return -EINVAL;
+
+	spin_lock_irqsave(ap->lock, flags);
+
+	/*
+	 * if we are still busy transmitting a previous message,
+	 * do not allow
+	 */
+	em_ctl = readl(mmio + HOST_EM_CTL);
+	if (em_ctl & EM_CTL_TM) {
+		spin_unlock_irqrestore(ap->lock, flags);
+		return -EBUSY;
+	}
+
+	/*
+	 * create message header - this is all zero except for
+	 * the message size, which is 4 bytes.
+	 */
+	message[0] |= (4 << 8);
+
+	/* ignore 0:4 of byte zero, fill in port info yourself */
+	message[1] = ((state & ~EM_MSG_LED_HBA_PORT) | ap->port_no);
+
+	/* write message to EM_LOC */
+	writel(message[0], mmio + hpriv->em_loc);
+	writel(message[1], mmio + hpriv->em_loc+4);
+
+	/* save off new led state for port/slot */
+	emp->led_state = state;
+
+	/*
+	 * tell hardware to transmit the message
+	 */
+	writel(em_ctl | EM_CTL_TM, mmio + HOST_EM_CTL);
+
+	spin_unlock_irqrestore(ap->lock, flags);
+	return size;
+}
+
+static void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
+			       u32 opts)
+{
+	dma_addr_t cmd_tbl_dma;
+
+	cmd_tbl_dma = pp->cmd_tbl_dma + tag * AHCI_CMD_TBL_SZ;
+
+	pp->cmd_slot[tag].opts = cpu_to_le32(opts);
+	pp->cmd_slot[tag].status = 0;
+	pp->cmd_slot[tag].tbl_addr = cpu_to_le32(cmd_tbl_dma & 0xffffffff);
+	pp->cmd_slot[tag].tbl_addr_hi = cpu_to_le32((cmd_tbl_dma >> 16) >> 16);
+}
+
+static unsigned int ahci_fill_sg(struct ata_queued_cmd *qc, void *cmd_tbl)
+{
+	struct scatterlist *sg;
+	struct ahci_sg *ahci_sg = cmd_tbl + AHCI_CMD_TBL_HDR_SZ;
+	unsigned int si;
+
+	VPRINTK("ENTER\n");
+
+	/*
+	 * Next, the S/G list.
+	 */
+	for_each_sg(qc->sg, sg, qc->n_elem, si) {
+		dma_addr_t addr = sg_dma_address(sg);
+		u32 sg_len = sg_dma_len(sg);
+
+		ahci_sg[si].addr = cpu_to_le32(addr & 0xffffffff);
+		ahci_sg[si].addr_hi = cpu_to_le32((addr >> 16) >> 16);
+		ahci_sg[si].flags_size = cpu_to_le32(sg_len - 1);
+	}
+
+	return si;
+}
+
+void ahci_qc_prep(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+	int is_atapi = ata_is_atapi(qc->tf.protocol);
+	void *cmd_tbl;
+	u32 opts;
+	const u32 cmd_fis_len = 5; /* five dwords */
+	unsigned int n_elem;
+
+	/*
+	 * Fill in command table information.  First, the header,
+	 * a SATA Register - Host to Device command FIS.
+	 */
+	cmd_tbl = pp->cmd_tbl + qc->tag * AHCI_CMD_TBL_SZ;
+
+	ata_tf_to_fis(&qc->tf, qc->dev->link->pmp, 1, cmd_tbl);
+	if (is_atapi) {
+		memset(cmd_tbl + AHCI_CMD_TBL_CDB, 0, 32);
+		memcpy(cmd_tbl + AHCI_CMD_TBL_CDB, qc->cdb, qc->dev->cdb_len);
+	}
+
+	n_elem = 0;
+	if (qc->flags & ATA_QCFLAG_DMAMAP)
+		n_elem = ahci_fill_sg(qc, cmd_tbl);
+
+	/*
+	 * Fill in command slot information.
+	 */
+	opts = cmd_fis_len | n_elem << 16 | (qc->dev->link->pmp << 12);
+	if (qc->tf.flags & ATA_TFLAG_WRITE)
+		opts |= AHCI_CMD_WRITE;
+	if (is_atapi)
+		opts |= AHCI_CMD_ATAPI | AHCI_CMD_PREFETCH;
+
+	ahci_fill_cmd_slot(pp, qc->tag, opts);
+}
+EXPORT_SYMBOL_GPL(ahci_qc_prep);
+
+unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	struct ahci_port_priv *pp = ap->private_data;
+
+	/* Keep track of the currently active link.  It will be used
+	 * in completion path to determine whether NCQ phase is in
+	 * progress.
+	 */
+	pp->active_link = qc->dev->link;
+
+	if (qc->tf.protocol == ATA_PROT_NCQ)
+		writel(1 << qc->tag, port_mmio + PORT_SCR_ACT);
+	writel(1 << qc->tag, port_mmio + PORT_CMD_ISSUE);
+
+	ahci_sw_activity(qc->dev->link);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ahci_qc_issue);
+
+bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc)
+{
+	struct ahci_port_priv *pp = qc->ap->private_data;
+	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
+
+	ata_tf_from_fis(d2h_fis, &qc->result_tf);
+	return true;
+}
+EXPORT_SYMBOL_GPL(ahci_qc_fill_rtf);
+
+void ahci_disable_alpm(struct ata_port *ap)
+{
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 cmd;
+	struct ahci_port_priv *pp = ap->private_data;
+
+	/* IPM bits should be disabled by libata-core */
+	/* get the existing command bits */
+	cmd = readl(port_mmio + PORT_CMD);
+
+	/* disable ALPM and ASP */
+	cmd &= ~PORT_CMD_ASP;
+	cmd &= ~PORT_CMD_ALPE;
+
+	/* force the interface back to active */
+	cmd |= PORT_CMD_ICC_ACTIVE;
+
+	/* write out new cmd value */
+	writel(cmd, port_mmio + PORT_CMD);
+	cmd = readl(port_mmio + PORT_CMD);
+
+	/* wait 10ms to be sure we've come out of any low power state */
+	msleep(10);
+
+	/* clear out any PhyRdy stuff from interrupt status */
+	writel(PORT_IRQ_PHYRDY, port_mmio + PORT_IRQ_STAT);
+
+	/* go ahead and clean out PhyRdy Change from Serror too */
+	ahci_scr_write(&ap->link, SCR_ERROR, ((1 << 16) | (1 << 18)));
+
+	/*
+ 	 * Clear flag to indicate that we should ignore all PhyRdy
+ 	 * state changes
+ 	 */
+	hpriv->flags &= ~AHCI_HFLAG_NO_HOTPLUG;
+
+	/*
+ 	 * Enable interrupts on Phy Ready.
+ 	 */
+	pp->intr_mask |= PORT_IRQ_PHYRDY;
+	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
+
+	/*
+ 	 * don't change the link pm policy - we can be called
+ 	 * just to turn of link pm temporarily
+ 	 */
+}
+EXPORT_SYMBOL_GPL(ahci_disable_alpm);
+
+int ahci_enable_alpm(struct ata_port *ap, enum link_pm policy)
+{
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 cmd;
+	struct ahci_port_priv *pp = ap->private_data;
+	u32 asp;
+
+	/* Make sure the host is capable of link power management */
+	if (!(hpriv->cap & HOST_CAP_ALPM))
+		return -EINVAL;
+
+	switch (policy) {
+	case MAX_PERFORMANCE:
+	case NOT_AVAILABLE:
+		/*
+ 		 * if we came here with NOT_AVAILABLE,
+ 		 * it just means this is the first time we
+ 		 * have tried to enable - default to max performance,
+ 		 * and let the user go to lower power modes on request.
+ 		 */
+		ahci_disable_alpm(ap);
+		return 0;
+	case MIN_POWER:
+		/* configure HBA to enter SLUMBER */
+		asp = PORT_CMD_ASP;
+		break;
+	case MEDIUM_POWER:
+		/* configure HBA to enter PARTIAL */
+		asp = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/*
+ 	 * Disable interrupts on Phy Ready. This keeps us from
+ 	 * getting woken up due to spurious phy ready interrupts
+	 * TBD - Hot plug should be done via polling now, is
+	 * that even supported?
+ 	 */
+	pp->intr_mask &= ~PORT_IRQ_PHYRDY;
+	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
+
+	/*
+ 	 * Set a flag to indicate that we should ignore all PhyRdy
+ 	 * state changes since these can happen now whenever we
+ 	 * change link state
+ 	 */
+	hpriv->flags |= AHCI_HFLAG_NO_HOTPLUG;
+
+	/* get the existing command bits */
+	cmd = readl(port_mmio + PORT_CMD);
+
+	/*
+ 	 * Set ASP based on Policy
+ 	 */
+	cmd |= asp;
+
+	/*
+ 	 * Setting this bit will instruct the HBA to aggressively
+ 	 * enter a lower power link state when it's appropriate and
+ 	 * based on the value set above for ASP
+ 	 */
+	cmd |= PORT_CMD_ALPE;
+
+	/* write out new cmd value */
+	writel(cmd, port_mmio + PORT_CMD);
+	cmd = readl(port_mmio + PORT_CMD);
+
+	/* IPM bits should be set by libata-core */
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ahci_enable_alpm);
+
+ssize_t ahci_led_show(struct ata_port *ap, char *buf)
+{
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ata_link *link;
+	struct ahci_em_priv *emp;
+	int rc = 0;
+
+	ata_for_each_link(link, ap, EDGE) {
+		emp = &pp->em_priv[link->pmp];
+		rc += sprintf(buf, "%lx\n", emp->led_state);
+	}
+	return rc;
+}
+EXPORT_SYMBOL_GPL(ahci_led_show);
+
+ssize_t ahci_led_store(struct ata_port *ap, const char *buf, size_t size)
+{
+	int state;
+	int pmp;
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ahci_em_priv *emp;
+
+	state = simple_strtoul(buf, NULL, 0);
+
+	/* get the slot number from the message */
+	pmp = (state & EM_MSG_LED_PMP_SLOT) >> 8;
+	if (pmp < AHCI_MAX_SLOTS)
+		emp = &pp->em_priv[pmp];
+	else
+		return -EINVAL;
+
+	/* mask off the activity bits if we are in sw_activity
+	 * mode, user should turn off sw_activity before setting
+	 * activity led through em_message
+	 */
+	if (emp->blink_policy)
+		state &= ~EM_MSG_LED_VALUE_ACTIVITY;
+
+	return ahci_transmit_led_message(ap, state, size);
+}
+EXPORT_SYMBOL_GPL(ahci_led_store);
+
+ssize_t ahci_activity_store(struct ata_device *dev, enum sw_activity val)
+{
+	struct ata_link *link = dev->link;
+	struct ata_port *ap = link->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ahci_em_priv *emp = &pp->em_priv[link->pmp];
+	u32 port_led_state = emp->led_state;
+
+	/* save the desired Activity LED behavior */
+	if (val == OFF) {
+		/* clear LFLAG */
+		link->flags &= ~(ATA_LFLAG_SW_ACTIVITY);
+
+		/* set the LED to OFF */
+		port_led_state &= EM_MSG_LED_VALUE_OFF;
+		port_led_state |= (ap->port_no | (link->pmp << 8));
+		ahci_transmit_led_message(ap, port_led_state, 4);
+	} else {
+		link->flags |= ATA_LFLAG_SW_ACTIVITY;
+		if (val == BLINK_OFF) {
+			/* set LED to ON for idle */
+			port_led_state &= EM_MSG_LED_VALUE_OFF;
+			port_led_state |= (ap->port_no | (link->pmp << 8));
+			port_led_state |= EM_MSG_LED_VALUE_ON; /* check this */
+			ahci_transmit_led_message(ap, port_led_state, 4);
+		}
+	}
+	emp->blink_policy = val;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ahci_activity_store);
+
+ssize_t ahci_activity_show(struct ata_device *dev, char *buf)
+{
+	struct ata_link *link = dev->link;
+	struct ata_port *ap = link->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ahci_em_priv *emp = &pp->em_priv[link->pmp];
+
+	/* display the saved value of activity behavior for this
+	 * disk.
+	 */
+	return sprintf(buf, "%d\n", emp->blink_policy);
+}
+EXPORT_SYMBOL_GPL(ahci_activity_show);
+
+void ahci_print_info(struct ata_host *host)
+{
+	struct ahci_host_priv *hpriv = host->private_data;
+	struct pci_dev *pdev = to_pci_dev(host->dev);
+	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
+	u32 vers, cap, impl, speed;
+	const char *speed_s;
+	u16 cc;
+	const char *scc_s;
+
+	vers = readl(mmio + HOST_VERSION);
+	cap = hpriv->cap;
+	impl = hpriv->port_map;
+
+	speed = (cap >> 20) & 0xf;
+	if (speed == 1)
+		speed_s = "1.5";
+	else if (speed == 2)
+		speed_s = "3";
+	else if (speed == 3)
+		speed_s = "6";
+	else
+		speed_s = "?";
+
+	pci_read_config_word(pdev, 0x0a, &cc);
+	if (cc == PCI_CLASS_STORAGE_IDE)
+		scc_s = "IDE";
+	else if (cc == PCI_CLASS_STORAGE_SATA)
+		scc_s = "SATA";
+	else if (cc == PCI_CLASS_STORAGE_RAID)
+		scc_s = "RAID";
+	else
+		scc_s = "unknown";
+
+	dev_printk(KERN_INFO, &pdev->dev,
+		"AHCI %02x%02x.%02x%02x "
+		"%u slots %u ports %s Gbps 0x%x impl %s mode\n"
+		,
+
+		(vers >> 24) & 0xff,
+		(vers >> 16) & 0xff,
+		(vers >> 8) & 0xff,
+		vers & 0xff,
+
+		((cap >> 8) & 0x1f) + 1,
+		(cap & 0x1f) + 1,
+		speed_s,
+		impl,
+		scc_s);
+
+	dev_printk(KERN_INFO, &pdev->dev,
+		"flags: "
+		"%s%s%s%s%s%s%s"
+		"%s%s%s%s%s%s%s"
+		"%s\n"
+		,
+
+		cap & (1 << 31) ? "64bit " : "",
+		cap & (1 << 30) ? "ncq " : "",
+		cap & (1 << 29) ? "sntf " : "",
+		cap & (1 << 28) ? "ilck " : "",
+		cap & (1 << 27) ? "stag " : "",
+		cap & (1 << 26) ? "pm " : "",
+		cap & (1 << 25) ? "led " : "",
+
+		cap & (1 << 24) ? "clo " : "",
+		cap & (1 << 19) ? "nz " : "",
+		cap & (1 << 18) ? "only " : "",
+		cap & (1 << 17) ? "pmp " : "",
+		cap & (1 << 15) ? "pio " : "",
+		cap & (1 << 14) ? "slum " : "",
+		cap & (1 << 13) ? "part " : "",
+		cap & (1 << 6) ? "ems ": ""
+		);
+}
+EXPORT_SYMBOL_GPL(ahci_print_info);
+
+static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
+{
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ata_eh_info *host_ehi = &ap->link.eh_info;
+	struct ata_link *link = NULL;
+	struct ata_queued_cmd *active_qc;
+	struct ata_eh_info *active_ehi;
+	u32 serror;
+
+	/* determine active link */
+	ata_for_each_link(link, ap, EDGE)
+		if (ata_link_active(link))
+			break;
+	if (!link)
+		link = &ap->link;
+
+	active_qc = ata_qc_from_tag(ap, link->active_tag);
+	active_ehi = &link->eh_info;
+
+	/* record irq stat */
+	ata_ehi_clear_desc(host_ehi);
+	ata_ehi_push_desc(host_ehi, "irq_stat 0x%08x", irq_stat);
+
+	/* AHCI needs SError cleared; otherwise, it might lock up */
+	ahci_scr_read(&ap->link, SCR_ERROR, &serror);
+	ahci_scr_write(&ap->link, SCR_ERROR, serror);
+	host_ehi->serror |= serror;
+
+	/* some controllers set IRQ_IF_ERR on device errors, ignore it */
+	if (hpriv->flags & AHCI_HFLAG_IGN_IRQ_IF_ERR)
+		irq_stat &= ~PORT_IRQ_IF_ERR;
+
+	if (irq_stat & PORT_IRQ_TF_ERR) {
+		/* If qc is active, charge it; otherwise, the active
+		 * link.  There's no active qc on NCQ errors.  It will
+		 * be determined by EH by reading log page 10h.
+		 */
+		if (active_qc)
+			active_qc->err_mask |= AC_ERR_DEV;
+		else
+			active_ehi->err_mask |= AC_ERR_DEV;
+
+		if (hpriv->flags & AHCI_HFLAG_IGN_SERR_INTERNAL)
+			host_ehi->serror &= ~SERR_INTERNAL;
+	}
+
+	if (irq_stat & PORT_IRQ_UNK_FIS) {
+		u32 *unk = (u32 *)(pp->rx_fis + RX_FIS_UNK);
+
+		active_ehi->err_mask |= AC_ERR_HSM;
+		active_ehi->action |= ATA_EH_RESET;
+		ata_ehi_push_desc(active_ehi,
+				  "unknown FIS %08x %08x %08x %08x" ,
+				  unk[0], unk[1], unk[2], unk[3]);
+	}
+
+	if (sata_pmp_attached(ap) && (irq_stat & PORT_IRQ_BAD_PMP)) {
+		active_ehi->err_mask |= AC_ERR_HSM;
+		active_ehi->action |= ATA_EH_RESET;
+		ata_ehi_push_desc(active_ehi, "incorrect PMP");
+	}
+
+	if (irq_stat & (PORT_IRQ_HBUS_ERR | PORT_IRQ_HBUS_DATA_ERR)) {
+		host_ehi->err_mask |= AC_ERR_HOST_BUS;
+		host_ehi->action |= ATA_EH_RESET;
+		ata_ehi_push_desc(host_ehi, "host bus error");
+	}
+
+	if (irq_stat & PORT_IRQ_IF_ERR) {
+		host_ehi->err_mask |= AC_ERR_ATA_BUS;
+		host_ehi->action |= ATA_EH_RESET;
+		ata_ehi_push_desc(host_ehi, "interface fatal error");
+	}
+
+	if (irq_stat & (PORT_IRQ_CONNECT | PORT_IRQ_PHYRDY)) {
+		ata_ehi_hotplugged(host_ehi);
+		ata_ehi_push_desc(host_ehi, "%s",
+			irq_stat & PORT_IRQ_CONNECT ?
+			"connection status changed" : "PHY RDY changed");
+	}
+
+	/* okay, let's hand over to EH */
+
+	if (irq_stat & PORT_IRQ_FREEZE)
+		ata_port_freeze(ap);
+	else
+		ata_port_abort(ap);
+}
+
+void ahci_port_intr(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	struct ata_eh_info *ehi = &ap->link.eh_info;
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	int resetting = !!(ap->pflags & ATA_PFLAG_RESETTING);
+	u32 status, qc_active;
+	int rc;
+
+	status = readl(port_mmio + PORT_IRQ_STAT);
+	writel(status, port_mmio + PORT_IRQ_STAT);
+
+	/* ignore BAD_PMP while resetting */
+	if (unlikely(resetting))
+		status &= ~PORT_IRQ_BAD_PMP;
+
+	/* If we are getting PhyRdy, this is
+ 	 * just a power state change, we should
+ 	 * clear out this, plus the PhyRdy/Comm
+ 	 * Wake bits from Serror
+ 	 */
+	if ((hpriv->flags & AHCI_HFLAG_NO_HOTPLUG) &&
+		(status & PORT_IRQ_PHYRDY)) {
+		status &= ~PORT_IRQ_PHYRDY;
+		ahci_scr_write(&ap->link, SCR_ERROR, ((1 << 16) | (1 << 18)));
+	}
+
+	if (unlikely(status & PORT_IRQ_ERROR)) {
+		ahci_error_intr(ap, status);
+		return;
+	}
+
+	if (status & PORT_IRQ_SDB_FIS) {
+		/* If SNotification is available, leave notification
+		 * handling to sata_async_notification().  If not,
+		 * emulate it by snooping SDB FIS RX area.
+		 *
+		 * Snooping FIS RX area is probably cheaper than
+		 * poking SNotification but some constrollers which
+		 * implement SNotification, ICH9 for example, don't
+		 * store AN SDB FIS into receive area.
+		 */
+		if (hpriv->cap & HOST_CAP_SNTF)
+			sata_async_notification(ap);
+		else {
+			/* If the 'N' bit in word 0 of the FIS is set,
+			 * we just received asynchronous notification.
+			 * Tell libata about it.
+			 */
+			const __le32 *f = pp->rx_fis + RX_FIS_SDB;
+			u32 f0 = le32_to_cpu(f[0]);
+
+			if (f0 & (1 << 15))
+				sata_async_notification(ap);
+		}
+	}
+
+	/* pp->active_link is valid iff any command is in flight */
+	if (ap->qc_active && pp->active_link->sactive)
+		qc_active = readl(port_mmio + PORT_SCR_ACT);
+	else
+		qc_active = readl(port_mmio + PORT_CMD_ISSUE);
+
+	rc = ata_qc_complete_multiple(ap, qc_active);
+
+	/* while resetting, invalid completions are expected */
+	if (unlikely(rc < 0 && !resetting)) {
+		ehi->err_mask |= AC_ERR_HSM;
+		ehi->action |= ATA_EH_RESET;
+		ata_port_freeze(ap);
+	}
+}
+EXPORT_SYMBOL_GPL(ahci_port_intr);
+
diff --git a/drivers/ata/mv-ahci.c b/drivers/ata/mv-ahci.c
new file mode 100644
index 0000000..0a3ac6c
--- /dev/null
+++ b/drivers/ata/mv-ahci.c
@@ -0,0 +1,375 @@
+
+/*
+ *  mv-ahci.c - Marvell AHCI SATA/PATA support
+ *
+ *  Maintained by:  Jeff Garzik <jgarzik@pobox.com>
+ *    		    Please ALWAYS copy linux-ide@vger.kernel.org
+ *		    on emails.
+ *
+ *  Copyright 2009 Red Hat, Inc.
+ *
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2, or (at your option)
+ *  any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ *
+ * libata documentation is available via 'make {ps|pdf}docs',
+ * as Documentation/DocBook/libata.*
+ *
+ * AHCI hardware documentation:
+ * http://www.intel.com/technology/serialata/pdf/rev1_0.pdf
+ * http://www.intel.com/technology/serialata/pdf/rev1_1.pdf
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/blkdev.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/dma-mapping.h>
+#include <linux/device.h>
+#include <linux/dmi.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_cmnd.h>
+#include <linux/libata.h>
+#include "ahci.h"
+
+#define DRV_NAME	"mv-ahci"
+#define DRV_VERSION	"0.5"
+
+enum {
+	board_ahci_mv		= 0,
+};
+
+static struct device_attribute *mv_ahci_shost_attrs[] = {
+	&dev_attr_link_power_management_policy,
+	&dev_attr_em_message_type,
+	&dev_attr_em_message,
+	NULL
+};
+
+static struct device_attribute *mv_ahci_sdev_attrs[] = {
+	&dev_attr_sw_activity,
+	&dev_attr_unload_heads,
+	NULL
+};
+
+static struct scsi_host_template mv_ahci_sht = {
+	ATA_NCQ_SHT(DRV_NAME),
+	.can_queue		= AHCI_MAX_CMDS - 1,
+	.sg_tablesize		= AHCI_MAX_SG,
+	.dma_boundary		= AHCI_DMA_BOUNDARY,
+	.shost_attrs		= mv_ahci_shost_attrs,
+	.sdev_attrs		= mv_ahci_sdev_attrs,
+};
+
+static struct ata_port_operations mv_ahci_ops = {
+	.inherits		= &sata_pmp_port_ops,
+
+	.qc_defer		= sata_pmp_qc_defer_cmd_switch,
+	.qc_prep		= ahci_qc_prep,
+	.qc_issue		= ahci_qc_issue,
+	.qc_fill_rtf		= ahci_qc_fill_rtf,
+
+	.freeze			= ahci_freeze,
+	.thaw			= ahci_thaw,
+	.softreset		= ahci_softreset,
+	.hardreset		= ahci_hardreset,
+	.postreset		= ahci_postreset,
+	.pmp_softreset		= ahci_softreset,
+	.error_handler		= ahci_error_handler,
+	.post_internal_cmd	= ahci_post_internal_cmd,
+
+	.scr_read		= ahci_scr_read,
+	.scr_write		= ahci_scr_write,
+	.pmp_attach		= ahci_pmp_attach,
+	.pmp_detach		= ahci_pmp_detach,
+
+	.enable_pm		= ahci_enable_alpm,
+	.disable_pm		= ahci_disable_alpm,
+	.em_show		= ahci_led_show,
+	.em_store		= ahci_led_store,
+	.sw_activity_show	= ahci_activity_show,
+	.sw_activity_store	= ahci_activity_store,
+#ifdef CONFIG_PM
+	.port_suspend		= ahci_port_suspend,
+	.port_resume		= ahci_port_resume,
+#endif
+	.port_start		= ahci_port_start,
+	.port_stop		= ahci_port_stop,
+};
+
+static const struct ata_port_info mv_ahci_port_info[] = {
+	[board_ahci_mv] =
+	{
+		AHCI_HFLAGS	(AHCI_HFLAG_NO_NCQ | AHCI_HFLAG_NO_MSI |
+				 AHCI_HFLAG_MV_PATA | AHCI_HFLAG_NO_PMP),
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
+				  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &mv_ahci_ops,
+	},
+};
+
+static const struct pci_device_id mv_ahci_pci_tbl[] = {
+	{ PCI_VDEVICE(MARVELL, 0x6145), board_ahci_mv },	/* 6145 */
+	{ PCI_VDEVICE(MARVELL, 0x6121), board_ahci_mv },	/* 6121 */
+
+	{ }	/* terminate list */
+};
+
+#if defined(CONFIG_PATA_MARVELL) || defined(CONFIG_PATA_MARVELL_MODULE)
+static int pata_enable;
+#else
+static int pata_enable = 1;
+#endif
+module_param(pata_enable, int, 0644);
+MODULE_PARM_DESC(pata_enable, "Marvell PATA via AHCI (1 = enabled)");
+
+static int ahci_ignore_sss;
+module_param_named(ignore_sss, ahci_ignore_sss, int, 0444);
+MODULE_PARM_DESC(ignore_sss, "Ignore staggered spinup flag (0=don't ignore, 1=ignore)");
+
+static int ahci_em_messages = 1;
+module_param(ahci_em_messages, int, 0444);
+/* add other LED protocol types when they become supported */
+MODULE_PARM_DESC(ahci_em_messages,
+	"Set AHCI Enclosure Management Message type (0 = disabled, 1 = LED");
+
+static irqreturn_t mv_ahci_interrupt(int irq, void *dev_instance)
+{
+	struct ata_host *host = dev_instance;
+	struct ahci_host_priv *hpriv;
+	unsigned int i, handled = 0;
+	void __iomem *mmio;
+	u32 irq_stat, irq_masked;
+
+	VPRINTK("ENTER\n");
+
+	hpriv = host->private_data;
+	mmio = host->iomap[AHCI_PCI_BAR];
+
+	/* sigh.  0xffffffff is a valid return from h/w */
+	irq_stat = readl(mmio + HOST_IRQ_STAT);
+	if (!irq_stat)
+		return IRQ_NONE;
+
+	irq_masked = irq_stat & hpriv->port_map;
+
+	spin_lock(&host->lock);
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap;
+
+		if (!(irq_masked & (1 << i)))
+			continue;
+
+		ap = host->ports[i];
+		if (ap) {
+			ahci_port_intr(ap);
+			VPRINTK("port %u\n", i);
+		} else {
+			VPRINTK("port %u (no irq)\n", i);
+			if (ata_ratelimit())
+				dev_printk(KERN_WARNING, host->dev,
+					"interrupt on disabled port %u\n", i);
+		}
+
+		handled = 1;
+	}
+
+	/* HOST_IRQ_STAT behaves as level triggered latch meaning that
+	 * it should be cleared after all the port events are cleared;
+	 * otherwise, it will raise a spurious interrupt after each
+	 * valid one.  Please read section 10.6.2 of ahci 1.1 for more
+	 * information.
+	 *
+	 * Also, use the unmasked value to clear interrupt as spurious
+	 * pending event on a dummy port might cause screaming IRQ.
+	 */
+	writel(irq_stat, mmio + HOST_IRQ_STAT);
+
+	spin_unlock(&host->lock);
+
+	VPRINTK("EXIT\n");
+
+	return IRQ_RETVAL(handled);
+}
+
+static int mv_ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	static int printed_version;
+	unsigned int board_id = ent->driver_data;
+	struct ata_port_info pi = mv_ahci_port_info[board_id];
+	const struct ata_port_info *ppi[] = { &pi, NULL };
+	struct device *dev = &pdev->dev;
+	struct ahci_host_priv *hpriv;
+	struct ata_host *host;
+	int n_ports, i, rc;
+
+	VPRINTK("ENTER\n");
+
+	WARN_ON(ATA_MAX_QUEUE > AHCI_MAX_CMDS);
+
+	if (!printed_version++)
+		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
+
+	/* The AHCI driver can only drive the SATA ports, the PATA driver
+	   can drive them all so if both drivers are selected make sure
+	   AHCI stays out of the way */
+	if (!pata_enable)
+		return -ENODEV;
+
+	/* acquire resources */
+	rc = pcim_enable_device(pdev);
+	if (rc)
+		return rc;
+
+	/* AHCI controllers often implement SFF compatible interface.
+	 * Grab all PCI BARs just in case.
+	 */
+	rc = pcim_iomap_regions_request_all(pdev, 1 << AHCI_PCI_BAR, DRV_NAME);
+	if (rc == -EBUSY)
+		pcim_pin_device(pdev);
+	if (rc)
+		return rc;
+
+	hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
+	if (!hpriv)
+		return -ENOMEM;
+	hpriv->flags |= (unsigned long)pi.private_data;
+
+	if (!(hpriv->flags & AHCI_HFLAG_NO_MSI))
+		pci_enable_msi(pdev);
+
+	/* save initial config */
+	ahci_save_initial_config(pdev, hpriv);
+
+	/* prepare host */
+	if (hpriv->cap & HOST_CAP_NCQ)
+		pi.flags |= ATA_FLAG_NCQ;
+
+	if (hpriv->cap & HOST_CAP_PMP)
+		pi.flags |= ATA_FLAG_PMP;
+
+	if (ahci_em_messages && (hpriv->cap & HOST_CAP_EMS)) {
+		u8 messages;
+		void __iomem *mmio = pcim_iomap_table(pdev)[AHCI_PCI_BAR];
+		u32 em_loc = readl(mmio + HOST_EM_LOC);
+		u32 em_ctl = readl(mmio + HOST_EM_CTL);
+
+		messages = (em_ctl & EM_CTRL_MSG_TYPE) >> 16;
+
+		/* we only support LED message type right now */
+		if ((messages & 0x01) && (ahci_em_messages == 1)) {
+			/* store em_loc */
+			hpriv->em_loc = ((em_loc >> 16) * 4);
+			pi.flags |= ATA_FLAG_EM;
+			if (!(em_ctl & EM_CTL_ALHD))
+				pi.flags |= ATA_FLAG_SW_ACTIVITY;
+		}
+	}
+
+	/* CAP.NP sometimes indicate the index of the last enabled
+	 * port, at other times, that of the last possible port, so
+	 * determining the maximum port number requires looking at
+	 * both CAP.NP and port_map.
+	 */
+	n_ports = max(ahci_nr_ports(hpriv->cap), fls(hpriv->port_map));
+
+	host = ata_host_alloc_pinfo(&pdev->dev, ppi, n_ports);
+	if (!host)
+		return -ENOMEM;
+	host->iomap = pcim_iomap_table(pdev);
+	host->private_data = hpriv;
+
+	if (!(hpriv->cap & HOST_CAP_SSS) || ahci_ignore_sss)
+		host->flags |= ATA_HOST_PARALLEL_SCAN;
+	else
+		printk(KERN_INFO "ahci: SSS flag set, parallel bus scan disabled\n");
+
+	if (pi.flags & ATA_FLAG_EM)
+		ahci_reset_em(host);
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		ata_port_pbar_desc(ap, AHCI_PCI_BAR, -1, "abar");
+		ata_port_pbar_desc(ap, AHCI_PCI_BAR,
+				   0x100 + ap->port_no * 0x80, "port");
+
+		/* set initial link pm policy */
+		ap->pm_policy = NOT_AVAILABLE;
+
+		/* set enclosure management message type */
+		if (ap->flags & ATA_FLAG_EM)
+			ap->em_message_type = ahci_em_messages;
+
+
+		/* disabled/not-implemented port */
+		if (!(hpriv->port_map & (1 << i)))
+			ap->ops = &ata_dummy_port_ops;
+	}
+
+	/* initialize adapter */
+	rc = ahci_configure_dma_masks(pdev, hpriv->cap & HOST_CAP_64);
+	if (rc)
+		return rc;
+
+	rc = ahci_reset_controller(host);
+	if (rc)
+		return rc;
+
+	ahci_init_controller(host);
+	ahci_print_info(host);
+
+	pci_set_master(pdev);
+	return ata_host_activate(host, pdev->irq, mv_ahci_interrupt,
+				 IRQF_SHARED, &mv_ahci_sht);
+}
+
+static struct pci_driver mv_ahci_pci_driver = {
+	.name			= DRV_NAME,
+	.id_table		= mv_ahci_pci_tbl,
+	.probe			= mv_ahci_init_one,
+	.remove			= ata_pci_remove_one,
+#ifdef CONFIG_PM
+	.suspend		= ahci_pci_device_suspend,
+	.resume			= ahci_pci_device_resume,
+#endif
+};
+
+static int __init mv_ahci_init(void)
+{
+	return pci_register_driver(&mv_ahci_pci_driver);
+}
+
+static void __exit mv_ahci_exit(void)
+{
+	pci_unregister_driver(&mv_ahci_pci_driver);
+}
+
+
+MODULE_AUTHOR("Jeff Garzik");
+MODULE_DESCRIPTION("Marvell AHCI SATA/PATA low-level driver");
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(pci, mv_ahci_pci_tbl);
+MODULE_VERSION(DRV_VERSION);
+
+module_init(mv_ahci_init);
+module_exit(mv_ahci_exit);
