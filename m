Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab0CBSaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 13:30:35 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:38742 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754303Ab0CBS3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 13:29:44 -0500
Date: Tue, 2 Mar 2010 21:29:41 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Jeff Garzik <jgarzik@redhat.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/12] ahci: Move PCI code into ahci_pci.c
Message-ID: <20100302182941.GJ3445@oksana.dev.rtsoft.ru>
References: <20100302182850.GA32057@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100302182850.GA32057@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch should contain no functional changes, just moves code
around.

Currently ahci.c and ahci_pci.c are built into a single module,
so there is no need for EXPORT_SYMBOL_GPL()s, yet. Exports will be
added in a subsequent patch.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/ata/Kconfig    |    8 +-
 drivers/ata/Makefile   |    3 +-
 drivers/ata/ahci.c     | 1426 +-----------------------------------------------
 drivers/ata/ahci.h     |  277 ++++++++++
 drivers/ata/ahci_pci.c | 1175 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 1484 insertions(+), 1405 deletions(-)
 create mode 100644 drivers/ata/ahci.h
 create mode 100644 drivers/ata/ahci_pci.c

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index b17c57f..4656782 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -49,12 +49,18 @@ config SATA_PMP
 
 config SATA_AHCI
 	tristate "AHCI SATA support"
-	depends on PCI
 	help
 	  This option enables support for AHCI Serial ATA.
 
 	  If unsure, say N.
 
+config SATA_AHCI_PCI
+	tristate "PCI AHCI SATA support"
+	depends on SATA_AHCI && PCI
+	default y
+	help
+	  This option enables support for PCI AHCI Serial ATA controllers.
+
 config SATA_SIL24
 	tristate "Silicon Image 3124/3132 SATA support"
 	depends on PCI
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index b7d4923..0ab4c52 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -1,7 +1,8 @@
 
 obj-$(CONFIG_ATA)		+= libata.o
 
-obj-$(CONFIG_SATA_AHCI)		+= ahci.o
+ahci-pci-objs			+= ahci.o ahci_pci.o
+obj-$(CONFIG_SATA_AHCI_PCI)	+= ahci-pci.o
 obj-$(CONFIG_SATA_SVW)		+= sata_svw.o
 obj-$(CONFIG_ATA_PIIX)		+= ata_piix.o
 obj-$(CONFIG_SATA_PROMISE)	+= sata_promise.o
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 6694b17..ce08bc6 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -34,34 +34,19 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/dma-mapping.h>
 #include <linux/device.h>
-#include <linux/dmi.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_cmnd.h>
 #include <linux/libata.h>
-
-#define DRV_NAME	"ahci"
-#define DRV_VERSION	"3.0"
-
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
+#include "ahci.h"
 
 static int ahci_skip_host_reset;
-static int ahci_ignore_sss;
+int ahci_ignore_sss;
 
 module_param_named(skip_host_reset, ahci_skip_host_reset, int, 0444);
 MODULE_PARM_DESC(skip_host_reset, "skip global host reset (0=don't skip, 1=skip)");
@@ -78,240 +63,10 @@ static ssize_t ahci_led_store(struct ata_port *ap, const char *buf,
 static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
 					ssize_t size);
 
-enum {
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
-	board_ahci		= 0,
-	board_ahci_vt8251	= 1,
-	board_ahci_ign_iferr	= 2,
-	board_ahci_sb600	= 3,
-	board_ahci_mv		= 4,
-	board_ahci_sb700	= 5, /* for SB700 and SB800 */
-	board_ahci_mcp65	= 6,
-	board_ahci_nopmp	= 7,
-	board_ahci_yesncq	= 8,
-	board_ahci_nosntf	= 9,
-
-	/* global controller registers */
-	HOST_CAP		= 0x00, /* host capabilities */
-	HOST_CTL		= 0x04, /* global host control */
-	HOST_IRQ_STAT		= 0x08, /* interrupt status */
-	HOST_PORTS_IMPL		= 0x0c, /* bitmap of implemented ports */
-	HOST_VERSION		= 0x10, /* AHCI spec. version compliancy */
-	HOST_EM_LOC		= 0x1c, /* Enclosure Management location */
-	HOST_EM_CTL		= 0x20, /* Enclosure Management Control */
-	HOST_CAP2		= 0x24, /* host capabilities, extended */
-
-	/* HOST_CTL bits */
-	HOST_RESET		= (1 << 0),  /* reset controller; self-clear */
-	HOST_IRQ_EN		= (1 << 1),  /* global IRQ enable */
-	HOST_AHCI_EN		= (1 << 31), /* AHCI enabled */
-
-	/* HOST_CAP bits */
-	HOST_CAP_SXS		= (1 << 5),  /* Supports External SATA */
-	HOST_CAP_EMS		= (1 << 6),  /* Enclosure Management support */
-	HOST_CAP_CCC		= (1 << 7),  /* Command Completion Coalescing */
-	HOST_CAP_PART		= (1 << 13), /* Partial state capable */
-	HOST_CAP_SSC		= (1 << 14), /* Slumber state capable */
-	HOST_CAP_PIO_MULTI	= (1 << 15), /* PIO multiple DRQ support */
-	HOST_CAP_FBS		= (1 << 16), /* FIS-based switching support */
-	HOST_CAP_PMP		= (1 << 17), /* Port Multiplier support */
-	HOST_CAP_ONLY		= (1 << 18), /* Supports AHCI mode only */
-	HOST_CAP_CLO		= (1 << 24), /* Command List Override support */
-	HOST_CAP_LED		= (1 << 25), /* Supports activity LED */
-	HOST_CAP_ALPM		= (1 << 26), /* Aggressive Link PM support */
-	HOST_CAP_SSS		= (1 << 27), /* Staggered Spin-up */
-	HOST_CAP_MPS		= (1 << 28), /* Mechanical presence switch */
-	HOST_CAP_SNTF		= (1 << 29), /* SNotification register */
-	HOST_CAP_NCQ		= (1 << 30), /* Native Command Queueing */
-	HOST_CAP_64		= (1 << 31), /* PCI DAC (64-bit DMA) support */
-
-	/* HOST_CAP2 bits */
-	HOST_CAP2_BOH		= (1 << 0),  /* BIOS/OS handoff supported */
-	HOST_CAP2_NVMHCI	= (1 << 1),  /* NVMHCI supported */
-	HOST_CAP2_APST		= (1 << 2),  /* Automatic partial to slumber */
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
-	AHCI_HFLAG_NO_SUSPEND		= (1 << 10), /* don't suspend */
-	AHCI_HFLAG_SRST_TOUT_IS_OFFLINE	= (1 << 11), /* treat SRST timeout as
-							link offline */
-	AHCI_HFLAG_NO_SNTF		= (1 << 12), /* no sntf */
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
-	/* em constants */
-	EM_MAX_SLOTS			= 8,
-	EM_MAX_RETRY			= 5,
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
-	void __iomem *		mmio;		/* bus-independant mem map */
-	unsigned int		flags;		/* AHCI_HFLAG_* */
-	u32			cap;		/* cap to use */
-	u32			cap2;		/* cap2 to use */
-	u32			port_map;	/* port map to use */
-	u32			saved_cap;	/* saved initial cap */
-	u32			saved_cap2;	/* saved initial cap2 */
-	u32			saved_port_map;	/* saved initial port_map */
-	u32 			em_loc; /* enclosure management location */
-};
-
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
-	/* enclosure management info per PM slot */
-	struct ahci_em_priv	em_priv[EM_MAX_SLOTS];
-};
 
 static int ahci_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
 static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
-static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc);
 static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc);
 static int ahci_port_start(struct ata_port *ap);
@@ -323,14 +78,8 @@ static void ahci_pmp_attach(struct ata_port *ap);
 static void ahci_pmp_detach(struct ata_port *ap);
 static int ahci_softreset(struct ata_link *link, unsigned int *class,
 			  unsigned long deadline);
-static int ahci_sb600_softreset(struct ata_link *link, unsigned int *class,
-			  unsigned long deadline);
 static int ahci_hardreset(struct ata_link *link, unsigned int *class,
 			  unsigned long deadline);
-static int ahci_vt8251_hardreset(struct ata_link *link, unsigned int *class,
-				 unsigned long deadline);
-static int ahci_p5wdh_hardreset(struct ata_link *link, unsigned int *class,
-				unsigned long deadline);
 static void ahci_postreset(struct ata_link *link, unsigned int *class);
 static void ahci_error_handler(struct ata_port *ap);
 static void ahci_post_internal_cmd(struct ata_queued_cmd *qc);
@@ -340,8 +89,6 @@ static void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
 			       u32 opts);
 #ifdef CONFIG_PM
 static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg);
-static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
-static int ahci_pci_device_resume(struct pci_dev *pdev);
 #endif
 static ssize_t ahci_activity_show(struct ata_device *dev, char *buf);
 static ssize_t ahci_activity_store(struct ata_device *dev,
@@ -379,7 +126,7 @@ static struct device_attribute *ahci_sdev_attrs[] = {
 	NULL
 };
 
-static struct scsi_host_template ahci_sht = {
+struct scsi_host_template ahci_sht = {
 	ATA_NCQ_SHT(DRV_NAME),
 	.can_queue		= AHCI_MAX_CMDS - 1,
 	.sg_tablesize		= AHCI_MAX_SG,
@@ -388,7 +135,7 @@ static struct scsi_host_template ahci_sht = {
 	.sdev_attrs		= ahci_sdev_attrs,
 };
 
-static struct ata_port_operations ahci_ops = {
+struct ata_port_operations ahci_ops = {
 	.inherits		= &sata_pmp_port_ops,
 
 	.qc_defer		= sata_pmp_qc_defer_cmd_switch,
@@ -425,312 +172,12 @@ static struct ata_port_operations ahci_ops = {
 	.port_stop		= ahci_port_stop,
 };
 
-static struct ata_port_operations ahci_vt8251_ops = {
-	.inherits		= &ahci_ops,
-	.hardreset		= ahci_vt8251_hardreset,
-};
-
-static struct ata_port_operations ahci_p5wdh_ops = {
-	.inherits		= &ahci_ops,
-	.hardreset		= ahci_p5wdh_hardreset,
-};
-
-static struct ata_port_operations ahci_sb600_ops = {
-	.inherits		= &ahci_ops,
-	.softreset		= ahci_sb600_softreset,
-	.pmp_softreset		= ahci_sb600_softreset,
-};
-
-#define AHCI_HFLAGS(flags)	.private_data	= (void *)(flags)
-
-static const struct ata_port_info ahci_port_info[] = {
-	[board_ahci] =
-	{
-		.flags		= AHCI_FLAG_COMMON,
-		.pio_mask	= ATA_PIO4,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &ahci_ops,
-	},
-	[board_ahci_vt8251] =
-	{
-		AHCI_HFLAGS	(AHCI_HFLAG_NO_NCQ | AHCI_HFLAG_NO_PMP),
-		.flags		= AHCI_FLAG_COMMON,
-		.pio_mask	= ATA_PIO4,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &ahci_vt8251_ops,
-	},
-	[board_ahci_ign_iferr] =
-	{
-		AHCI_HFLAGS	(AHCI_HFLAG_IGN_IRQ_IF_ERR),
-		.flags		= AHCI_FLAG_COMMON,
-		.pio_mask	= ATA_PIO4,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &ahci_ops,
-	},
-	[board_ahci_sb600] =
-	{
-		AHCI_HFLAGS	(AHCI_HFLAG_IGN_SERR_INTERNAL |
-				 AHCI_HFLAG_NO_MSI | AHCI_HFLAG_SECT255 |
-				 AHCI_HFLAG_32BIT_ONLY),
-		.flags		= AHCI_FLAG_COMMON,
-		.pio_mask	= ATA_PIO4,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &ahci_sb600_ops,
-	},
-	[board_ahci_mv] =
-	{
-		AHCI_HFLAGS	(AHCI_HFLAG_NO_NCQ | AHCI_HFLAG_NO_MSI |
-				 AHCI_HFLAG_MV_PATA | AHCI_HFLAG_NO_PMP),
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA,
-		.pio_mask	= ATA_PIO4,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &ahci_ops,
-	},
-	[board_ahci_sb700] =	/* for SB700 and SB800 */
-	{
-		AHCI_HFLAGS	(AHCI_HFLAG_IGN_SERR_INTERNAL),
-		.flags		= AHCI_FLAG_COMMON,
-		.pio_mask	= ATA_PIO4,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &ahci_sb600_ops,
-	},
-	[board_ahci_mcp65] =
-	{
-		AHCI_HFLAGS	(AHCI_HFLAG_YES_NCQ),
-		.flags		= AHCI_FLAG_COMMON,
-		.pio_mask	= ATA_PIO4,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &ahci_ops,
-	},
-	[board_ahci_nopmp] =
-	{
-		AHCI_HFLAGS	(AHCI_HFLAG_NO_PMP),
-		.flags		= AHCI_FLAG_COMMON,
-		.pio_mask	= ATA_PIO4,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &ahci_ops,
-	},
-	[board_ahci_yesncq] =
-	{
-		AHCI_HFLAGS	(AHCI_HFLAG_YES_NCQ),
-		.flags		= AHCI_FLAG_COMMON,
-		.pio_mask	= ATA_PIO4,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &ahci_ops,
-	},
-	[board_ahci_nosntf] =
-	{
-		AHCI_HFLAGS	(AHCI_HFLAG_NO_SNTF),
-		.flags		= AHCI_FLAG_COMMON,
-		.pio_mask	= ATA_PIO4,
-		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &ahci_ops,
-	},
-};
-
-static const struct pci_device_id ahci_pci_tbl[] = {
-	/* Intel */
-	{ PCI_VDEVICE(INTEL, 0x2652), board_ahci }, /* ICH6 */
-	{ PCI_VDEVICE(INTEL, 0x2653), board_ahci }, /* ICH6M */
-	{ PCI_VDEVICE(INTEL, 0x27c1), board_ahci }, /* ICH7 */
-	{ PCI_VDEVICE(INTEL, 0x27c5), board_ahci }, /* ICH7M */
-	{ PCI_VDEVICE(INTEL, 0x27c3), board_ahci }, /* ICH7R */
-	{ PCI_VDEVICE(AL, 0x5288), board_ahci_ign_iferr }, /* ULi M5288 */
-	{ PCI_VDEVICE(INTEL, 0x2681), board_ahci }, /* ESB2 */
-	{ PCI_VDEVICE(INTEL, 0x2682), board_ahci }, /* ESB2 */
-	{ PCI_VDEVICE(INTEL, 0x2683), board_ahci }, /* ESB2 */
-	{ PCI_VDEVICE(INTEL, 0x27c6), board_ahci }, /* ICH7-M DH */
-	{ PCI_VDEVICE(INTEL, 0x2821), board_ahci }, /* ICH8 */
-	{ PCI_VDEVICE(INTEL, 0x2822), board_ahci_nosntf }, /* ICH8 */
-	{ PCI_VDEVICE(INTEL, 0x2824), board_ahci }, /* ICH8 */
-	{ PCI_VDEVICE(INTEL, 0x2829), board_ahci }, /* ICH8M */
-	{ PCI_VDEVICE(INTEL, 0x282a), board_ahci }, /* ICH8M */
-	{ PCI_VDEVICE(INTEL, 0x2922), board_ahci }, /* ICH9 */
-	{ PCI_VDEVICE(INTEL, 0x2923), board_ahci }, /* ICH9 */
-	{ PCI_VDEVICE(INTEL, 0x2924), board_ahci }, /* ICH9 */
-	{ PCI_VDEVICE(INTEL, 0x2925), board_ahci }, /* ICH9 */
-	{ PCI_VDEVICE(INTEL, 0x2927), board_ahci }, /* ICH9 */
-	{ PCI_VDEVICE(INTEL, 0x2929), board_ahci }, /* ICH9M */
-	{ PCI_VDEVICE(INTEL, 0x292a), board_ahci }, /* ICH9M */
-	{ PCI_VDEVICE(INTEL, 0x292b), board_ahci }, /* ICH9M */
-	{ PCI_VDEVICE(INTEL, 0x292c), board_ahci }, /* ICH9M */
-	{ PCI_VDEVICE(INTEL, 0x292f), board_ahci }, /* ICH9M */
-	{ PCI_VDEVICE(INTEL, 0x294d), board_ahci }, /* ICH9 */
-	{ PCI_VDEVICE(INTEL, 0x294e), board_ahci }, /* ICH9M */
-	{ PCI_VDEVICE(INTEL, 0x502a), board_ahci }, /* Tolapai */
-	{ PCI_VDEVICE(INTEL, 0x502b), board_ahci }, /* Tolapai */
-	{ PCI_VDEVICE(INTEL, 0x3a05), board_ahci }, /* ICH10 */
-	{ PCI_VDEVICE(INTEL, 0x3a22), board_ahci }, /* ICH10 */
-	{ PCI_VDEVICE(INTEL, 0x3a25), board_ahci }, /* ICH10 */
-	{ PCI_VDEVICE(INTEL, 0x3b22), board_ahci }, /* PCH AHCI */
-	{ PCI_VDEVICE(INTEL, 0x3b23), board_ahci }, /* PCH AHCI */
-	{ PCI_VDEVICE(INTEL, 0x3b24), board_ahci }, /* PCH RAID */
-	{ PCI_VDEVICE(INTEL, 0x3b25), board_ahci }, /* PCH RAID */
-	{ PCI_VDEVICE(INTEL, 0x3b29), board_ahci }, /* PCH AHCI */
-	{ PCI_VDEVICE(INTEL, 0x3b2b), board_ahci }, /* PCH RAID */
-	{ PCI_VDEVICE(INTEL, 0x3b2c), board_ahci }, /* PCH RAID */
-	{ PCI_VDEVICE(INTEL, 0x3b2f), board_ahci }, /* PCH AHCI */
-
-	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
-	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
-	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci_ign_iferr },
-
-	/* ATI */
-	{ PCI_VDEVICE(ATI, 0x4380), board_ahci_sb600 }, /* ATI SB600 */
-	{ PCI_VDEVICE(ATI, 0x4390), board_ahci_sb700 }, /* ATI SB700/800 */
-	{ PCI_VDEVICE(ATI, 0x4391), board_ahci_sb700 }, /* ATI SB700/800 */
-	{ PCI_VDEVICE(ATI, 0x4392), board_ahci_sb700 }, /* ATI SB700/800 */
-	{ PCI_VDEVICE(ATI, 0x4393), board_ahci_sb700 }, /* ATI SB700/800 */
-	{ PCI_VDEVICE(ATI, 0x4394), board_ahci_sb700 }, /* ATI SB700/800 */
-	{ PCI_VDEVICE(ATI, 0x4395), board_ahci_sb700 }, /* ATI SB700/800 */
-
-	/* AMD */
-	{ PCI_VDEVICE(AMD, 0x7800), board_ahci }, /* AMD Hudson-2 */
-	/* AMD is using RAID class only for ahci controllers */
-	{ PCI_VENDOR_ID_AMD, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
-	  PCI_CLASS_STORAGE_RAID << 8, 0xffffff, board_ahci },
-
-	/* VIA */
-	{ PCI_VDEVICE(VIA, 0x3349), board_ahci_vt8251 }, /* VIA VT8251 */
-	{ PCI_VDEVICE(VIA, 0x6287), board_ahci_vt8251 }, /* VIA VT8251 */
-
-	/* NVIDIA */
-	{ PCI_VDEVICE(NVIDIA, 0x044c), board_ahci_mcp65 },	/* MCP65 */
-	{ PCI_VDEVICE(NVIDIA, 0x044d), board_ahci_mcp65 },	/* MCP65 */
-	{ PCI_VDEVICE(NVIDIA, 0x044e), board_ahci_mcp65 },	/* MCP65 */
-	{ PCI_VDEVICE(NVIDIA, 0x044f), board_ahci_mcp65 },	/* MCP65 */
-	{ PCI_VDEVICE(NVIDIA, 0x045c), board_ahci_mcp65 },	/* MCP65 */
-	{ PCI_VDEVICE(NVIDIA, 0x045d), board_ahci_mcp65 },	/* MCP65 */
-	{ PCI_VDEVICE(NVIDIA, 0x045e), board_ahci_mcp65 },	/* MCP65 */
-	{ PCI_VDEVICE(NVIDIA, 0x045f), board_ahci_mcp65 },	/* MCP65 */
-	{ PCI_VDEVICE(NVIDIA, 0x0550), board_ahci_yesncq },	/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0551), board_ahci_yesncq },	/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0552), board_ahci_yesncq },	/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0553), board_ahci_yesncq },	/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0554), board_ahci_yesncq },	/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0555), board_ahci_yesncq },	/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0556), board_ahci_yesncq },	/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0557), board_ahci_yesncq },	/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0558), board_ahci_yesncq },	/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0559), board_ahci_yesncq },	/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x055a), board_ahci_yesncq },	/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x055b), board_ahci_yesncq },	/* MCP67 */
-	{ PCI_VDEVICE(NVIDIA, 0x0580), board_ahci_yesncq },	/* Linux ID */
-	{ PCI_VDEVICE(NVIDIA, 0x07f0), board_ahci_yesncq },	/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f1), board_ahci_yesncq },	/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f2), board_ahci_yesncq },	/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f3), board_ahci_yesncq },	/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f4), board_ahci_yesncq },	/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f5), board_ahci_yesncq },	/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f6), board_ahci_yesncq },	/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f7), board_ahci_yesncq },	/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f8), board_ahci_yesncq },	/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07f9), board_ahci_yesncq },	/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07fa), board_ahci_yesncq },	/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x07fb), board_ahci_yesncq },	/* MCP73 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ad0), board_ahci },		/* MCP77 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ad1), board_ahci },		/* MCP77 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ad2), board_ahci },		/* MCP77 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ad3), board_ahci },		/* MCP77 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ad4), board_ahci },		/* MCP77 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ad5), board_ahci },		/* MCP77 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ad6), board_ahci },		/* MCP77 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ad7), board_ahci },		/* MCP77 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ad8), board_ahci },		/* MCP77 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ad9), board_ahci },		/* MCP77 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ada), board_ahci },		/* MCP77 */
-	{ PCI_VDEVICE(NVIDIA, 0x0adb), board_ahci },		/* MCP77 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ab4), board_ahci },		/* MCP79 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ab5), board_ahci },		/* MCP79 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ab6), board_ahci },		/* MCP79 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ab7), board_ahci },		/* MCP79 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ab8), board_ahci },		/* MCP79 */
-	{ PCI_VDEVICE(NVIDIA, 0x0ab9), board_ahci },		/* MCP79 */
-	{ PCI_VDEVICE(NVIDIA, 0x0aba), board_ahci },		/* MCP79 */
-	{ PCI_VDEVICE(NVIDIA, 0x0abb), board_ahci },		/* MCP79 */
-	{ PCI_VDEVICE(NVIDIA, 0x0abc), board_ahci },		/* MCP79 */
-	{ PCI_VDEVICE(NVIDIA, 0x0abd), board_ahci },		/* MCP79 */
-	{ PCI_VDEVICE(NVIDIA, 0x0abe), board_ahci },		/* MCP79 */
-	{ PCI_VDEVICE(NVIDIA, 0x0abf), board_ahci },		/* MCP79 */
-	{ PCI_VDEVICE(NVIDIA, 0x0d84), board_ahci },		/* MCP89 */
-	{ PCI_VDEVICE(NVIDIA, 0x0d85), board_ahci },		/* MCP89 */
-	{ PCI_VDEVICE(NVIDIA, 0x0d86), board_ahci },		/* MCP89 */
-	{ PCI_VDEVICE(NVIDIA, 0x0d87), board_ahci },		/* MCP89 */
-	{ PCI_VDEVICE(NVIDIA, 0x0d88), board_ahci },		/* MCP89 */
-	{ PCI_VDEVICE(NVIDIA, 0x0d89), board_ahci },		/* MCP89 */
-	{ PCI_VDEVICE(NVIDIA, 0x0d8a), board_ahci },		/* MCP89 */
-	{ PCI_VDEVICE(NVIDIA, 0x0d8b), board_ahci },		/* MCP89 */
-	{ PCI_VDEVICE(NVIDIA, 0x0d8c), board_ahci },		/* MCP89 */
-	{ PCI_VDEVICE(NVIDIA, 0x0d8d), board_ahci },		/* MCP89 */
-	{ PCI_VDEVICE(NVIDIA, 0x0d8e), board_ahci },		/* MCP89 */
-	{ PCI_VDEVICE(NVIDIA, 0x0d8f), board_ahci },		/* MCP89 */
-
-	/* SiS */
-	{ PCI_VDEVICE(SI, 0x1184), board_ahci },		/* SiS 966 */
-	{ PCI_VDEVICE(SI, 0x1185), board_ahci },		/* SiS 968 */
-	{ PCI_VDEVICE(SI, 0x0186), board_ahci },		/* SiS 968 */
-
-	/* Marvell */
-	{ PCI_VDEVICE(MARVELL, 0x6145), board_ahci_mv },	/* 6145 */
-	{ PCI_VDEVICE(MARVELL, 0x6121), board_ahci_mv },	/* 6121 */
-
-	/* Promise */
-	{ PCI_VDEVICE(PROMISE, 0x3f20), board_ahci },	/* PDC42819 */
-
-	/* Generic, PCI class code for AHCI */
-	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
-	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci },
-
-	{ }	/* terminate list */
-};
-
-
-static struct pci_driver ahci_pci_driver = {
-	.name			= DRV_NAME,
-	.id_table		= ahci_pci_tbl,
-	.probe			= ahci_init_one,
-	.remove			= ata_pci_remove_one,
-#ifdef CONFIG_PM
-	.suspend		= ahci_pci_device_suspend,
-	.resume			= ahci_pci_device_resume,
-#endif
-};
-
-static int ahci_em_messages = 1;
+int ahci_em_messages = 1;
 module_param(ahci_em_messages, int, 0444);
 /* add other LED protocol types when they become supported */
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
-	struct ahci_host_priv *hpriv = host->private_data;
-	void __iomem *mmio = hpriv->mmio;
-
-	return mmio + 0x100 + (port_no * 0x80);
-}
-
-static inline void __iomem *ahci_port_base(struct ata_port *ap)
-{
-	return __ahci_port_base(ap->host, ap->port_no);
-}
-
 static void ahci_enable_ahci(void __iomem *mmio)
 {
 	int i;
@@ -814,10 +261,10 @@ static ssize_t ahci_show_port_cmd(struct device *dev,
  *	LOCKING:
  *	None.
  */
-static void ahci_save_initial_config(struct device *dev,
-				     struct ahci_host_priv *hpriv,
-				     unsigned int force_port_map,
-				     unsigned int mask_port_map)
+void ahci_save_initial_config(struct device *dev,
+			      struct ahci_host_priv *hpriv,
+			      unsigned int force_port_map,
+			      unsigned int mask_port_map)
 {
 	void __iomem *mmio = hpriv->mmio;
 	u32 cap, cap2, vers, port_map;
@@ -920,35 +367,6 @@ static void ahci_save_initial_config(struct device *dev,
 	hpriv->port_map = port_map;
 }
 
-static void ahci_pci_save_initial_config(struct pci_dev *pdev,
-					 struct ahci_host_priv *hpriv)
-{
-	unsigned int force_port_map = 0;
-	unsigned int mask_port_map = 0;
-
-	if (pdev->vendor == PCI_VENDOR_ID_JMICRON && pdev->device == 0x2361) {
-		dev_info(&pdev->dev, "JMB361 has only one port\n");
-		force_port_map = 1;
-	}
-
-	/*
-	 * Temporary Marvell 6145 hack: PATA port presence
-	 * is asserted through the standard AHCI port
-	 * presence register, as bit 4 (counting from 0)
-	 */
-	if (hpriv->flags & AHCI_HFLAG_MV_PATA) {
-		if (pdev->device == 0x6121)
-			mask_port_map = 0x3;
-		else
-			mask_port_map = 0xf;
-		dev_info(&pdev->dev,
-			  "Disabling your PATA port. Use the boot option 'ahci.marvell_enable=0' to avoid this.\n");
-	}
-
-	ahci_save_initial_config(&pdev->dev, hpriv, force_port_map,
-				 mask_port_map);
-}
-
 /**
  *	ahci_restore_initial_config - Restore initial config
  *	@host: target ATA host
@@ -1011,7 +429,7 @@ static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
 	return -EINVAL;
 }
 
-static void ahci_start_engine(struct ata_port *ap)
+void ahci_start_engine(struct ata_port *ap)
 {
 	void __iomem *port_mmio = ahci_port_base(ap);
 	u32 tmp;
@@ -1023,7 +441,7 @@ static void ahci_start_engine(struct ata_port *ap)
 	readl(port_mmio + PORT_CMD); /* flush */
 }
 
-static int ahci_stop_engine(struct ata_port *ap)
+int ahci_stop_engine(struct ata_port *ap)
 {
 	void __iomem *port_mmio = ahci_port_base(ap);
 	u32 tmp;
@@ -1316,7 +734,7 @@ static int ahci_deinit_port(struct ata_port *ap, const char **emsg)
 	return 0;
 }
 
-static int ahci_reset_controller(struct ata_host *host)
+int ahci_reset_controller(struct ata_host *host)
 {
 	struct ahci_host_priv *hpriv = host->private_data;
 	void __iomem *mmio = hpriv->mmio;
@@ -1364,27 +782,6 @@ static int ahci_reset_controller(struct ata_host *host)
 	return 0;
 }
 
-static int ahci_pci_reset_controller(struct ata_host *host)
-{
-	struct pci_dev *pdev = to_pci_dev(host->dev);
-
-	ahci_reset_controller(host);
-
-	if (pdev->vendor == PCI_VENDOR_ID_INTEL) {
-		struct ahci_host_priv *hpriv = host->private_data;
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
 static void ahci_sw_activity(struct ata_link *link)
 {
 	struct ata_port *ap = link->ap;
@@ -1458,7 +855,7 @@ static void ahci_init_sw_activity(struct ata_link *link)
 		link->flags |= ATA_LFLAG_SW_ACTIVITY;
 }
 
-static int ahci_reset_em(struct ata_host *host)
+int ahci_reset_em(struct ata_host *host)
 {
 	struct ahci_host_priv *hpriv = host->private_data;
 	void __iomem *mmio = hpriv->mmio;
@@ -1640,7 +1037,7 @@ static void ahci_port_init(struct device *dev, struct ata_port *ap,
 	writel(1 << port_no, mmio + HOST_IRQ_STAT);
 }
 
-static void ahci_init_controller(struct ata_host *host)
+void ahci_init_controller(struct ata_host *host)
 {
 	struct ahci_host_priv *hpriv = host->private_data;
 	void __iomem *mmio = hpriv->mmio;
@@ -1665,33 +1062,6 @@ static void ahci_init_controller(struct ata_host *host)
 	VPRINTK("HOST_CTL 0x%x\n", tmp);
 }
 
-static void ahci_pci_init_controller(struct ata_host *host)
-{
-	struct ahci_host_priv *hpriv = host->private_data;
-	struct pci_dev *pdev = to_pci_dev(host->dev);
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
-	ahci_init_controller(host);
-}
-
 static void ahci_dev_config(struct ata_device *dev)
 {
 	struct ahci_host_priv *hpriv = dev->link->ap->host->private_data;
@@ -1731,7 +1101,7 @@ static void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
 	pp->cmd_slot[tag].tbl_addr_hi = cpu_to_le32((cmd_tbl_dma >> 16) >> 16);
 }
 
-static int ahci_kick_engine(struct ata_port *ap)
+int ahci_kick_engine(struct ata_port *ap)
 {
 	void __iomem *port_mmio = ahci_port_base(ap);
 	struct ahci_host_priv *hpriv = ap->host->private_data;
@@ -1805,9 +1175,9 @@ static int ahci_exec_polled_cmd(struct ata_port *ap, int pmp,
 	return 0;
 }
 
-static int ahci_do_softreset(struct ata_link *link, unsigned int *class,
-			     int pmp, unsigned long deadline,
-			     int (*check_ready)(struct ata_link *link))
+int ahci_do_softreset(struct ata_link *link, unsigned int *class,
+		      int pmp, unsigned long deadline,
+		      int (*check_ready)(struct ata_link *link))
 {
 	struct ata_port *ap = link->ap;
 	struct ahci_host_priv *hpriv = ap->host->private_data;
@@ -1873,7 +1243,7 @@ static int ahci_do_softreset(struct ata_link *link, unsigned int *class,
 	return rc;
 }
 
-static int ahci_check_ready(struct ata_link *link)
+int ahci_check_ready(struct ata_link *link)
 {
 	void __iomem *port_mmio = ahci_port_base(link->ap);
 	u8 status = readl(port_mmio + PORT_TFDATA) & 0xFF;
@@ -1891,55 +1261,6 @@ static int ahci_softreset(struct ata_link *link, unsigned int *class,
 	return ahci_do_softreset(link, class, pmp, deadline, ahci_check_ready);
 }
 
-static int ahci_sb600_check_ready(struct ata_link *link)
-{
-	void __iomem *port_mmio = ahci_port_base(link->ap);
-	u8 status = readl(port_mmio + PORT_TFDATA) & 0xFF;
-	u32 irq_status = readl(port_mmio + PORT_IRQ_STAT);
-
-	/*
-	 * There is no need to check TFDATA if BAD PMP is found due to HW bug,
-	 * which can save timeout delay.
-	 */
-	if (irq_status & PORT_IRQ_BAD_PMP)
-		return -EIO;
-
-	return ata_check_ready(status);
-}
-
-static int ahci_sb600_softreset(struct ata_link *link, unsigned int *class,
-				unsigned long deadline)
-{
-	struct ata_port *ap = link->ap;
-	void __iomem *port_mmio = ahci_port_base(ap);
-	int pmp = sata_srst_pmp(link);
-	int rc;
-	u32 irq_sts;
-
-	DPRINTK("ENTER\n");
-
-	rc = ahci_do_softreset(link, class, pmp, deadline,
-			       ahci_sb600_check_ready);
-
-	/*
-	 * Soft reset fails on some ATI chips with IPMS set when PMP
-	 * is enabled but SATA HDD/ODD is connected to SATA port,
-	 * do soft reset again to port 0.
-	 */
-	if (rc == -EIO) {
-		irq_sts = readl(port_mmio + PORT_IRQ_STAT);
-		if (irq_sts & PORT_IRQ_BAD_PMP) {
-			ata_link_printk(link, KERN_WARNING,
-					"applying SB600 PMP SRST workaround "
-					"and retrying\n");
-			rc = ahci_do_softreset(link, class, 0, deadline,
-					       ahci_check_ready);
-		}
-	}
-
-	return rc;
-}
-
 static int ahci_hardreset(struct ata_link *link, unsigned int *class,
 			  unsigned long deadline)
 {
@@ -1972,74 +1293,6 @@ static int ahci_hardreset(struct ata_link *link, unsigned int *class,
 	return rc;
 }
 
-static int ahci_vt8251_hardreset(struct ata_link *link, unsigned int *class,
-				 unsigned long deadline)
-{
-	struct ata_port *ap = link->ap;
-	bool online;
-	int rc;
-
-	DPRINTK("ENTER\n");
-
-	ahci_stop_engine(ap);
-
-	rc = sata_link_hardreset(link, sata_ehc_deb_timing(&link->eh_context),
-				 deadline, &online, NULL);
-
-	ahci_start_engine(ap);
-
-	DPRINTK("EXIT, rc=%d, class=%u\n", rc, *class);
-
-	/* vt8251 doesn't clear BSY on signature FIS reception,
-	 * request follow-up softreset.
-	 */
-	return online ? -EAGAIN : rc;
-}
-
-static int ahci_p5wdh_hardreset(struct ata_link *link, unsigned int *class,
-				unsigned long deadline)
-{
-	struct ata_port *ap = link->ap;
-	struct ahci_port_priv *pp = ap->private_data;
-	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
-	struct ata_taskfile tf;
-	bool online;
-	int rc;
-
-	ahci_stop_engine(ap);
-
-	/* clear D2H reception area to properly wait for D2H FIS */
-	ata_tf_init(link->device, &tf);
-	tf.command = 0x80;
-	ata_tf_to_fis(&tf, 0, 0, d2h_fis);
-
-	rc = sata_link_hardreset(link, sata_ehc_deb_timing(&link->eh_context),
-				 deadline, &online, NULL);
-
-	ahci_start_engine(ap);
-
-	/* The pseudo configuration device on SIMG4726 attached to
-	 * ASUS P5W-DH Deluxe doesn't send signature FIS after
-	 * hardreset if no device is attached to the first downstream
-	 * port && the pseudo device locks up on SRST w/ PMP==0.  To
-	 * work around this, wait for !BSY only briefly.  If BSY isn't
-	 * cleared, perform CLO and proceed to IDENTIFY (achieved by
-	 * ATA_LFLAG_NO_SRST and ATA_LFLAG_ASSUME_ATA).
-	 *
-	 * Wait for two seconds.  Devices attached to downstream port
-	 * which can't process the following IDENTIFY after this will
-	 * have to be reset again.  For most cases, this should
-	 * suffice while making probing snappish enough.
-	 */
-	if (online) {
-		rc = ata_wait_after_reset(link, jiffies + 2 * HZ,
-					  ahci_check_ready);
-		if (rc)
-			ahci_kick_engine(ap);
-	}
-	return rc;
-}
-
 static void ahci_postreset(struct ata_link *link, unsigned int *class)
 {
 	struct ata_port *ap = link->ap;
@@ -2285,7 +1538,7 @@ static void ahci_port_intr(struct ata_port *ap)
 	}
 }
 
-static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
+irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
 	struct ahci_host_priv *hpriv;
@@ -2477,56 +1730,6 @@ static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg)
 
 	return rc;
 }
-
-static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
-{
-	struct ata_host *host = dev_get_drvdata(&pdev->dev);
-	struct ahci_host_priv *hpriv = host->private_data;
-	void __iomem *mmio = hpriv->mmio;
-	u32 ctl;
-
-	if (mesg.event & PM_EVENT_SUSPEND &&
-	    hpriv->flags & AHCI_HFLAG_NO_SUSPEND) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "BIOS update required for suspend/resume\n");
-		return -EIO;
-	}
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
-		rc = ahci_pci_reset_controller(host);
-		if (rc)
-			return rc;
-
-		ahci_pci_init_controller(host);
-	}
-
-	ata_host_resume(host);
-
-	return 0;
-}
 #endif
 
 static int ahci_port_start(struct ata_port *ap)
@@ -2595,39 +1798,7 @@ static void ahci_port_stop(struct ata_port *ap)
 		ata_port_printk(ap, KERN_WARNING, "%s (%d)\n", emsg, rc);
 }
 
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
-static void ahci_print_info(struct ata_host *host, const char *scc_s)
+void ahci_print_info(struct ata_host *host, const char *scc_s)
 {
 	struct ahci_host_priv *hpriv = host->private_data;
 	void __iomem *mmio = hpriv->mmio;
@@ -2695,353 +1866,8 @@ static void ahci_print_info(struct ata_host *host, const char *scc_s)
 		);
 }
 
-static void ahci_pci_print_info(struct ata_host *host)
-{
-	struct pci_dev *pdev = to_pci_dev(host->dev);
-	u16 cc;
-	const char *scc_s;
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
-	ahci_print_info(host, scc_s);
-}
-
-/* On ASUS P5W DH Deluxe, the second port of PCI device 00:1f.2 is
- * hardwired to on-board SIMG 4726.  The chipset is ICH8 and doesn't
- * support PMP and the 4726 either directly exports the device
- * attached to the first downstream port or acts as a hardware storage
- * controller and emulate a single ATA device (can be RAID 0/1 or some
- * other configuration).
- *
- * When there's no device attached to the first downstream port of the
- * 4726, "Config Disk" appears, which is a pseudo ATA device to
- * configure the 4726.  However, ATA emulation of the device is very
- * lame.  It doesn't send signature D2H Reg FIS after the initial
- * hardreset, pukes on SRST w/ PMP==0 and has bunch of other issues.
- *
- * The following function works around the problem by always using
- * hardreset on the port and not depending on receiving signature FIS
- * afterward.  If signature FIS isn't received soon, ATA class is
- * assumed without follow-up softreset.
- */
-static void ahci_p5wdh_workaround(struct ata_host *host)
-{
-	static struct dmi_system_id sysids[] = {
-		{
-			.ident = "P5W DH Deluxe",
-			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR,
-					  "ASUSTEK COMPUTER INC"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "P5W DH Deluxe"),
-			},
-		},
-		{ }
-	};
-	struct pci_dev *pdev = to_pci_dev(host->dev);
-
-	if (pdev->bus->number == 0 && pdev->devfn == PCI_DEVFN(0x1f, 2) &&
-	    dmi_check_system(sysids)) {
-		struct ata_port *ap = host->ports[1];
-
-		dev_printk(KERN_INFO, &pdev->dev, "enabling ASUS P5W DH "
-			   "Deluxe on-board SIMG4726 workaround\n");
-
-		ap->ops = &ahci_p5wdh_ops;
-		ap->link.flags |= ATA_LFLAG_NO_SRST | ATA_LFLAG_ASSUME_ATA;
-	}
-}
-
-/* only some SB600 ahci controllers can do 64bit DMA */
-static bool ahci_sb600_enable_64bit(struct pci_dev *pdev)
-{
-	static const struct dmi_system_id sysids[] = {
-		/*
-		 * The oldest version known to be broken is 0901 and
-		 * working is 1501 which was released on 2007-10-26.
-		 * Enable 64bit DMA on 1501 and anything newer.
-		 *
-		 * Please read bko#9412 for more info.
-		 */
-		{
-			.ident = "ASUS M2A-VM",
-			.matches = {
-				DMI_MATCH(DMI_BOARD_VENDOR,
-					  "ASUSTeK Computer INC."),
-				DMI_MATCH(DMI_BOARD_NAME, "M2A-VM"),
-			},
-			.driver_data = "20071026",	/* yyyymmdd */
-		},
-		/*
-		 * All BIOS versions for the MSI K9A2 Platinum (MS-7376)
-		 * support 64bit DMA.
-		 *
-		 * BIOS versions earlier than 1.5 had the Manufacturer DMI
-		 * fields as "MICRO-STAR INTERANTIONAL CO.,LTD".
-		 * This spelling mistake was fixed in BIOS version 1.5, so
-		 * 1.5 and later have the Manufacturer as
-		 * "MICRO-STAR INTERNATIONAL CO.,LTD".
-		 * So try to match on DMI_BOARD_VENDOR of "MICRO-STAR INTER".
-		 *
-		 * BIOS versions earlier than 1.9 had a Board Product Name
-		 * DMI field of "MS-7376". This was changed to be
-		 * "K9A2 Platinum (MS-7376)" in version 1.9, but we can still
-		 * match on DMI_BOARD_NAME of "MS-7376".
-		 */
-		{
-			.ident = "MSI K9A2 Platinum",
-			.matches = {
-				DMI_MATCH(DMI_BOARD_VENDOR,
-					  "MICRO-STAR INTER"),
-				DMI_MATCH(DMI_BOARD_NAME, "MS-7376"),
-			},
-		},
-		{ }
-	};
-	const struct dmi_system_id *match;
-	int year, month, date;
-	char buf[9];
-
-	match = dmi_first_match(sysids);
-	if (pdev->bus->number != 0 || pdev->devfn != PCI_DEVFN(0x12, 0) ||
-	    !match)
-		return false;
-
-	if (!match->driver_data)
-		goto enable_64bit;
-
-	dmi_get_date(DMI_BIOS_DATE, &year, &month, &date);
-	snprintf(buf, sizeof(buf), "%04d%02d%02d", year, month, date);
-
-	if (strcmp(buf, match->driver_data) >= 0)
-		goto enable_64bit;
-	else {
-		dev_printk(KERN_WARNING, &pdev->dev, "%s: BIOS too old, "
-			   "forcing 32bit DMA, update BIOS\n", match->ident);
-		return false;
-	}
-
-enable_64bit:
-	dev_printk(KERN_WARNING, &pdev->dev, "%s: enabling 64bit DMA\n",
-		   match->ident);
-	return true;
-}
-
-static bool ahci_broken_system_poweroff(struct pci_dev *pdev)
-{
-	static const struct dmi_system_id broken_systems[] = {
-		{
-			.ident = "HP Compaq nx6310",
-			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6310"),
-			},
-			/* PCI slot number of the controller */
-			.driver_data = (void *)0x1FUL,
-		},
-		{
-			.ident = "HP Compaq 6720s",
-			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq 6720s"),
-			},
-			/* PCI slot number of the controller */
-			.driver_data = (void *)0x1FUL,
-		},
-
-		{ }	/* terminate list */
-	};
-	const struct dmi_system_id *dmi = dmi_first_match(broken_systems);
-
-	if (dmi) {
-		unsigned long slot = (unsigned long)dmi->driver_data;
-		/* apply the quirk only to on-board controllers */
-		return slot == PCI_SLOT(pdev->devfn);
-	}
-
-	return false;
-}
-
-static bool ahci_broken_suspend(struct pci_dev *pdev)
-{
-	static const struct dmi_system_id sysids[] = {
-		/*
-		 * On HP dv[4-6] and HDX18 with earlier BIOSen, link
-		 * to the harddisk doesn't become online after
-		 * resuming from STR.  Warn and fail suspend.
-		 */
-		{
-			.ident = "dv4",
-			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-				DMI_MATCH(DMI_PRODUCT_NAME,
-					  "HP Pavilion dv4 Notebook PC"),
-			},
-			.driver_data = "F.30", /* cutoff BIOS version */
-		},
-		{
-			.ident = "dv5",
-			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-				DMI_MATCH(DMI_PRODUCT_NAME,
-					  "HP Pavilion dv5 Notebook PC"),
-			},
-			.driver_data = "F.16", /* cutoff BIOS version */
-		},
-		{
-			.ident = "dv6",
-			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-				DMI_MATCH(DMI_PRODUCT_NAME,
-					  "HP Pavilion dv6 Notebook PC"),
-			},
-			.driver_data = "F.21",	/* cutoff BIOS version */
-		},
-		{
-			.ident = "HDX18",
-			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-				DMI_MATCH(DMI_PRODUCT_NAME,
-					  "HP HDX18 Notebook PC"),
-			},
-			.driver_data = "F.23",	/* cutoff BIOS version */
-		},
-		/*
-		 * Acer eMachines G725 has the same problem.  BIOS
-		 * V1.03 is known to be broken.  V3.04 is known to
-		 * work.  Inbetween, there are V1.06, V2.06 and V3.03
-		 * that we don't have much idea about.  For now,
-		 * blacklist anything older than V3.04.
-		 */
-		{
-			.ident = "G725",
-			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "eMachines"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "eMachines G725"),
-			},
-			.driver_data = "V3.04",	/* cutoff BIOS version */
-		},
-		{ }	/* terminate list */
-	};
-	const struct dmi_system_id *dmi = dmi_first_match(sysids);
-	const char *ver;
-
-	if (!dmi || pdev->bus->number || pdev->devfn != PCI_DEVFN(0x1f, 2))
-		return false;
-
-	ver = dmi_get_system_info(DMI_BIOS_VERSION);
-
-	return !ver || strcmp(ver, dmi->driver_data) < 0;
-}
-
-static bool ahci_broken_online(struct pci_dev *pdev)
-{
-#define ENCODE_BUSDEVFN(bus, slot, func)			\
-	(void *)(unsigned long)(((bus) << 8) | PCI_DEVFN((slot), (func)))
-	static const struct dmi_system_id sysids[] = {
-		/*
-		 * There are several gigabyte boards which use
-		 * SIMG5723s configured as hardware RAID.  Certain
-		 * 5723 firmware revisions shipped there keep the link
-		 * online but fail to answer properly to SRST or
-		 * IDENTIFY when no device is attached downstream
-		 * causing libata to retry quite a few times leading
-		 * to excessive detection delay.
-		 *
-		 * As these firmwares respond to the second reset try
-		 * with invalid device signature, considering unknown
-		 * sig as offline works around the problem acceptably.
-		 */
-		{
-			.ident = "EP45-DQ6",
-			.matches = {
-				DMI_MATCH(DMI_BOARD_VENDOR,
-					  "Gigabyte Technology Co., Ltd."),
-				DMI_MATCH(DMI_BOARD_NAME, "EP45-DQ6"),
-			},
-			.driver_data = ENCODE_BUSDEVFN(0x0a, 0x00, 0),
-		},
-		{
-			.ident = "EP45-DS5",
-			.matches = {
-				DMI_MATCH(DMI_BOARD_VENDOR,
-					  "Gigabyte Technology Co., Ltd."),
-				DMI_MATCH(DMI_BOARD_NAME, "EP45-DS5"),
-			},
-			.driver_data = ENCODE_BUSDEVFN(0x03, 0x00, 0),
-		},
-		{ }	/* terminate list */
-	};
-#undef ENCODE_BUSDEVFN
-	const struct dmi_system_id *dmi = dmi_first_match(sysids);
-	unsigned int val;
-
-	if (!dmi)
-		return false;
-
-	val = (unsigned long)dmi->driver_data;
-
-	return pdev->bus->number == (val >> 8) && pdev->devfn == (val & 0xff);
-}
-
-#ifdef CONFIG_ATA_ACPI
-static void ahci_gtf_filter_workaround(struct ata_host *host)
-{
-	static const struct dmi_system_id sysids[] = {
-		/*
-		 * Aspire 3810T issues a bunch of SATA enable commands
-		 * via _GTF including an invalid one and one which is
-		 * rejected by the device.  Among the successful ones
-		 * is FPDMA non-zero offset enable which when enabled
-		 * only on the drive side leads to NCQ command
-		 * failures.  Filter it out.
-		 */
-		{
-			.ident = "Aspire 3810T",
-			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 3810T"),
-			},
-			.driver_data = (void *)ATA_ACPI_FILTER_FPDMA_OFFSET,
-		},
-		{ }
-	};
-	const struct dmi_system_id *dmi = dmi_first_match(sysids);
-	unsigned int filter;
-	int i;
-
-	if (!dmi)
-		return;
-
-	filter = (unsigned long)dmi->driver_data;
-	dev_printk(KERN_INFO, host->dev,
-		   "applying extra ACPI _GTF filter 0x%x for %s\n",
-		   filter, dmi->ident);
-
-	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap = host->ports[i];
-		struct ata_link *link;
-		struct ata_device *dev;
-
-		ata_for_each_link(link, ap, EDGE)
-			ata_for_each_dev(dev, link, ALL)
-				dev->gtf_filter |= filter;
-	}
-}
-#else
-static inline void ahci_gtf_filter_workaround(struct ata_host *host)
-{}
-#endif
-
-static void ahci_set_em_messages(struct ahci_host_priv *hpriv,
-				 struct ata_port_info *pi)
+void ahci_set_em_messages(struct ahci_host_priv *hpriv,
+			  struct ata_port_info *pi)
 {
 	u8 messages;
 	void __iomem *mmio = hpriv->mmio;
@@ -3062,209 +1888,3 @@ static void ahci_set_em_messages(struct ahci_host_priv *hpriv,
 			pi->flags |= ATA_FLAG_SW_ACTIVITY;
 	}
 }
-
-static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
-{
-	static int printed_version;
-	unsigned int board_id = ent->driver_data;
-	struct ata_port_info pi = ahci_port_info[board_id];
-	const struct ata_port_info *ppi[] = { &pi, NULL };
-	struct device *dev = &pdev->dev;
-	struct ahci_host_priv *hpriv;
-	struct ata_host *host;
-	int n_ports, i, rc;
-
-	VPRINTK("ENTER\n");
-
-	WARN_ON(ATA_MAX_QUEUE > AHCI_MAX_CMDS);
-
-	if (!printed_version++)
-		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
-
-	/* The AHCI driver can only drive the SATA ports, the PATA driver
-	   can drive them all so if both drivers are selected make sure
-	   AHCI stays out of the way */
-	if (pdev->vendor == PCI_VENDOR_ID_MARVELL && !marvell_enable)
-		return -ENODEV;
-
-	/* Promise's PDC42819 is a SAS/SATA controller that has an AHCI mode.
-	 * At the moment, we can only use the AHCI mode. Let the users know
-	 * that for SAS drives they're out of luck.
-	 */
-	if (pdev->vendor == PCI_VENDOR_ID_PROMISE)
-		dev_printk(KERN_INFO, &pdev->dev, "PDC42819 "
-			   "can only drive SATA devices with this driver\n");
-
-	/* acquire resources */
-	rc = pcim_enable_device(pdev);
-	if (rc)
-		return rc;
-
-	/* AHCI controllers often implement SFF compatible interface.
-	 * Grab all PCI BARs just in case.
-	 */
-	rc = pcim_iomap_regions_request_all(pdev, 1 << AHCI_PCI_BAR, DRV_NAME);
-	if (rc == -EBUSY)
-		pcim_pin_device(pdev);
-	if (rc)
-		return rc;
-
-	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
-	    (pdev->device == 0x2652 || pdev->device == 0x2653)) {
-		u8 map;
-
-		/* ICH6s share the same PCI ID for both piix and ahci
-		 * modes.  Enabling ahci mode while MAP indicates
-		 * combined mode is a bad idea.  Yield to ata_piix.
-		 */
-		pci_read_config_byte(pdev, ICH_MAP, &map);
-		if (map & 0x3) {
-			dev_printk(KERN_INFO, &pdev->dev, "controller is in "
-				   "combined mode, can't enable AHCI mode\n");
-			return -ENODEV;
-		}
-	}
-
-	hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
-	if (!hpriv)
-		return -ENOMEM;
-	hpriv->flags |= (unsigned long)pi.private_data;
-
-	/* MCP65 revision A1 and A2 can't do MSI */
-	if (board_id == board_ahci_mcp65 &&
-	    (pdev->revision == 0xa1 || pdev->revision == 0xa2))
-		hpriv->flags |= AHCI_HFLAG_NO_MSI;
-
-	/* SB800 does NOT need the workaround to ignore SERR_INTERNAL */
-	if (board_id == board_ahci_sb700 && pdev->revision >= 0x40)
-		hpriv->flags &= ~AHCI_HFLAG_IGN_SERR_INTERNAL;
-
-	/* only some SB600s can do 64bit DMA */
-	if (ahci_sb600_enable_64bit(pdev))
-		hpriv->flags &= ~AHCI_HFLAG_32BIT_ONLY;
-
-	if ((hpriv->flags & AHCI_HFLAG_NO_MSI) || pci_enable_msi(pdev))
-		pci_intx(pdev, 1);
-
-	hpriv->mmio = pcim_iomap_table(pdev)[AHCI_PCI_BAR];
-
-	/* save initial config */
-	ahci_pci_save_initial_config(pdev, hpriv);
-
-	/* prepare host */
-	if (hpriv->cap & HOST_CAP_NCQ) {
-		pi.flags |= ATA_FLAG_NCQ;
-		/* Auto-activate optimization is supposed to be supported on
-		   all AHCI controllers indicating NCQ support, but it seems
-		   to be broken at least on some NVIDIA MCP79 chipsets.
-		   Until we get info on which NVIDIA chipsets don't have this
-		   issue, if any, disable AA on all NVIDIA AHCIs. */
-		if (pdev->vendor != PCI_VENDOR_ID_NVIDIA)
-			pi.flags |= ATA_FLAG_FPDMA_AA;
-	}
-
-	if (hpriv->cap & HOST_CAP_PMP)
-		pi.flags |= ATA_FLAG_PMP;
-
-	ahci_set_em_messages(hpriv, &pi);
-
-	if (ahci_broken_system_poweroff(pdev)) {
-		pi.flags |= ATA_FLAG_NO_POWEROFF_SPINDOWN;
-		dev_info(&pdev->dev,
-			"quirky BIOS, skipping spindown on poweroff\n");
-	}
-
-	if (ahci_broken_suspend(pdev)) {
-		hpriv->flags |= AHCI_HFLAG_NO_SUSPEND;
-		dev_printk(KERN_WARNING, &pdev->dev,
-			   "BIOS update required for suspend/resume\n");
-	}
-
-	if (ahci_broken_online(pdev)) {
-		hpriv->flags |= AHCI_HFLAG_SRST_TOUT_IS_OFFLINE;
-		dev_info(&pdev->dev,
-			 "online status unreliable, applying workaround\n");
-	}
-
-	/* CAP.NP sometimes indicate the index of the last enabled
-	 * port, at other times, that of the last possible port, so
-	 * determining the maximum port number requires looking at
-	 * both CAP.NP and port_map.
-	 */
-	n_ports = max(ahci_nr_ports(hpriv->cap), fls(hpriv->port_map));
-
-	host = ata_host_alloc_pinfo(&pdev->dev, ppi, n_ports);
-	if (!host)
-		return -ENOMEM;
-	host->private_data = hpriv;
-
-	if (!(hpriv->cap & HOST_CAP_SSS) || ahci_ignore_sss)
-		host->flags |= ATA_HOST_PARALLEL_SCAN;
-	else
-		printk(KERN_INFO "ahci: SSS flag set, parallel bus scan disabled\n");
-
-	if (pi.flags & ATA_FLAG_EM)
-		ahci_reset_em(host);
-
-	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap = host->ports[i];
-
-		ata_port_pbar_desc(ap, AHCI_PCI_BAR, -1, "abar");
-		ata_port_pbar_desc(ap, AHCI_PCI_BAR,
-				   0x100 + ap->port_no * 0x80, "port");
-
-		/* set initial link pm policy */
-		ap->pm_policy = NOT_AVAILABLE;
-
-		/* set enclosure management message type */
-		if (ap->flags & ATA_FLAG_EM)
-			ap->em_message_type = ahci_em_messages;
-
-
-		/* disabled/not-implemented port */
-		if (!(hpriv->port_map & (1 << i)))
-			ap->ops = &ata_dummy_port_ops;
-	}
-
-	/* apply workaround for ASUS P5W DH Deluxe mainboard */
-	ahci_p5wdh_workaround(host);
-
-	/* apply gtf filter quirk */
-	ahci_gtf_filter_workaround(host);
-
-	/* initialize adapter */
-	rc = ahci_configure_dma_masks(pdev, hpriv->cap & HOST_CAP_64);
-	if (rc)
-		return rc;
-
-	rc = ahci_pci_reset_controller(host);
-	if (rc)
-		return rc;
-
-	ahci_pci_init_controller(host);
-	ahci_pci_print_info(host);
-
-	pci_set_master(pdev);
-	return ata_host_activate(host, pdev->irq, ahci_interrupt, IRQF_SHARED,
-				 &ahci_sht);
-}
-
-static int __init ahci_init(void)
-{
-	return pci_register_driver(&ahci_pci_driver);
-}
-
-static void __exit ahci_exit(void)
-{
-	pci_unregister_driver(&ahci_pci_driver);
-}
-
-
-MODULE_AUTHOR("Jeff Garzik");
-MODULE_DESCRIPTION("AHCI SATA low-level driver");
-MODULE_LICENSE("GPL");
-MODULE_DEVICE_TABLE(pci, ahci_pci_tbl);
-MODULE_VERSION(DRV_VERSION);
-
-module_init(ahci_init);
-module_exit(ahci_exit);
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
new file mode 100644
index 0000000..6d66717
--- /dev/null
+++ b/drivers/ata/ahci.h
@@ -0,0 +1,277 @@
+#define DRV_NAME	"ahci"
+
+/* Enclosure Management Control */
+#define EM_CTRL_MSG_TYPE              0x000f0000
+
+/* Enclosure Management LED Message Type */
+#define EM_MSG_LED_HBA_PORT           0x0000000f
+#define EM_MSG_LED_PMP_SLOT           0x0000ff00
+#define EM_MSG_LED_VALUE              0xffff0000
+#define EM_MSG_LED_VALUE_ACTIVITY     0x00070000
+#define EM_MSG_LED_VALUE_OFF          0xfff80000
+#define EM_MSG_LED_VALUE_ON           0x00010000
+
+enum {
+	AHCI_MAX_PORTS		= 32,
+	AHCI_MAX_SG		= 168, /* hardware max is 64K */
+	AHCI_DMA_BOUNDARY	= 0xffffffff,
+	AHCI_MAX_CMDS		= 32,
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
+	HOST_CAP2		= 0x24, /* host capabilities, extended */
+
+	/* HOST_CTL bits */
+	HOST_RESET		= (1 << 0),  /* reset controller; self-clear */
+	HOST_IRQ_EN		= (1 << 1),  /* global IRQ enable */
+	HOST_AHCI_EN		= (1 << 31), /* AHCI enabled */
+
+	/* HOST_CAP bits */
+	HOST_CAP_SXS		= (1 << 5),  /* Supports External SATA */
+	HOST_CAP_EMS		= (1 << 6),  /* Enclosure Management support */
+	HOST_CAP_CCC		= (1 << 7),  /* Command Completion Coalescing */
+	HOST_CAP_PART		= (1 << 13), /* Partial state capable */
+	HOST_CAP_SSC		= (1 << 14), /* Slumber state capable */
+	HOST_CAP_PIO_MULTI	= (1 << 15), /* PIO multiple DRQ support */
+	HOST_CAP_FBS		= (1 << 16), /* FIS-based switching support */
+	HOST_CAP_PMP		= (1 << 17), /* Port Multiplier support */
+	HOST_CAP_ONLY		= (1 << 18), /* Supports AHCI mode only */
+	HOST_CAP_CLO		= (1 << 24), /* Command List Override support */
+	HOST_CAP_LED		= (1 << 25), /* Supports activity LED */
+	HOST_CAP_ALPM		= (1 << 26), /* Aggressive Link PM support */
+	HOST_CAP_SSS		= (1 << 27), /* Staggered Spin-up */
+	HOST_CAP_MPS		= (1 << 28), /* Mechanical presence switch */
+	HOST_CAP_SNTF		= (1 << 29), /* SNotification register */
+	HOST_CAP_NCQ		= (1 << 30), /* Native Command Queueing */
+	HOST_CAP_64		= (1 << 31), /* PCI DAC (64-bit DMA) support */
+
+	/* HOST_CAP2 bits */
+	HOST_CAP2_BOH		= (1 << 0),  /* BIOS/OS handoff supported */
+	HOST_CAP2_NVMHCI	= (1 << 1),  /* NVMHCI supported */
+	HOST_CAP2_APST		= (1 << 2),  /* Automatic partial to slumber */
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
+	AHCI_HFLAG_NO_SUSPEND		= (1 << 10), /* don't suspend */
+	AHCI_HFLAG_SRST_TOUT_IS_OFFLINE	= (1 << 11), /* treat SRST timeout as
+							link offline */
+	AHCI_HFLAG_NO_SNTF		= (1 << 12), /* no sntf */
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
+	/* em constants */
+	EM_MAX_SLOTS			= 8,
+	EM_MAX_RETRY			= 5,
+
+	/* em_ctl bits */
+	EM_CTL_RST			= (1 << 9), /* Reset */
+	EM_CTL_TM			= (1 << 8), /* Transmit Message */
+	EM_CTL_ALHD			= (1 << 26), /* Activity LED */
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
+	/* enclosure management info per PM slot */
+	struct ahci_em_priv	em_priv[EM_MAX_SLOTS];
+};
+
+struct ahci_host_priv {
+	void __iomem *		mmio;		/* bus-independant mem map */
+	unsigned int		flags;		/* AHCI_HFLAG_* */
+	u32			cap;		/* cap to use */
+	u32			cap2;		/* cap2 to use */
+	u32			port_map;	/* port map to use */
+	u32			saved_cap;	/* saved initial cap */
+	u32			saved_cap2;	/* saved initial cap2 */
+	u32			saved_port_map;	/* saved initial port_map */
+	u32 			em_loc; /* enclosure management location */
+};
+
+extern int ahci_em_messages;
+extern int ahci_ignore_sss;
+
+extern struct scsi_host_template ahci_sht;
+extern struct ata_port_operations ahci_ops;
+
+void ahci_save_initial_config(struct device *dev,
+			      struct ahci_host_priv *hpriv,
+			      unsigned int force_port_map,
+			      unsigned int mask_port_map);
+void ahci_init_controller(struct ata_host *host);
+int ahci_reset_controller(struct ata_host *host);
+
+int ahci_do_softreset(struct ata_link *link, unsigned int *class,
+		      int pmp, unsigned long deadline,
+		      int (*check_ready)(struct ata_link *link));
+
+int ahci_stop_engine(struct ata_port *ap);
+void ahci_start_engine(struct ata_port *ap);
+int ahci_check_ready(struct ata_link *link);
+int ahci_kick_engine(struct ata_port *ap);
+void ahci_set_em_messages(struct ahci_host_priv *hpriv,
+			  struct ata_port_info *pi);
+int ahci_reset_em(struct ata_host *host);
+irqreturn_t ahci_interrupt(int irq, void *dev_instance);
+void ahci_print_info(struct ata_host *host, const char *scc_s);
+
+static inline void __iomem *__ahci_port_base(struct ata_host *host,
+					     unsigned int port_no)
+{
+	struct ahci_host_priv *hpriv = host->private_data;
+	void __iomem *mmio = hpriv->mmio;
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
diff --git a/drivers/ata/ahci_pci.c b/drivers/ata/ahci_pci.c
new file mode 100644
index 0000000..2034061
--- /dev/null
+++ b/drivers/ata/ahci_pci.c
@@ -0,0 +1,1175 @@
+/*
+ *  ahci.c - AHCI SATA support
+ *
+ *  Maintained by:  Jeff Garzik <jgarzik@pobox.com>
+ *    		    Please ALWAYS copy linux-ide@vger.kernel.org
+ *		    on emails.
+ *
+ *  Copyright 2004-2005 Red Hat, Inc.
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
+#define DRV_VERSION	"3.0"
+
+#if defined(CONFIG_PATA_MARVELL) || defined(CONFIG_PATA_MARVELL_MODULE)
+static int marvell_enable;
+#else
+static int marvell_enable = 1;
+#endif
+module_param(marvell_enable, int, 0644);
+MODULE_PARM_DESC(marvell_enable, "Marvell SATA via AHCI (1 = enabled)");
+
+enum {
+	AHCI_PCI_BAR		= 5,
+};
+
+static void ahci_pci_save_initial_config(struct pci_dev *pdev,
+					 struct ahci_host_priv *hpriv)
+{
+	unsigned int force_port_map = 0;
+	unsigned int mask_port_map = 0;
+
+	if (pdev->vendor == PCI_VENDOR_ID_JMICRON && pdev->device == 0x2361) {
+		dev_info(&pdev->dev, "JMB361 has only one port\n");
+		force_port_map = 1;
+	}
+
+	/*
+	 * Temporary Marvell 6145 hack: PATA port presence
+	 * is asserted through the standard AHCI port
+	 * presence register, as bit 4 (counting from 0)
+	 */
+	if (hpriv->flags & AHCI_HFLAG_MV_PATA) {
+		if (pdev->device == 0x6121)
+			mask_port_map = 0x3;
+		else
+			mask_port_map = 0xf;
+		dev_info(&pdev->dev,
+			  "Disabling your PATA port. Use the boot option 'ahci.marvell_enable=0' to avoid this.\n");
+	}
+
+	ahci_save_initial_config(&pdev->dev, hpriv, force_port_map,
+				 mask_port_map);
+}
+
+static void ahci_pci_init_controller(struct ata_host *host)
+{
+	struct ahci_host_priv *hpriv = host->private_data;
+	struct pci_dev *pdev = to_pci_dev(host->dev);
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
+	ahci_init_controller(host);
+}
+
+static int ahci_pci_reset_controller(struct ata_host *host)
+{
+	struct pci_dev *pdev = to_pci_dev(host->dev);
+
+	ahci_reset_controller(host);
+
+	if (pdev->vendor == PCI_VENDOR_ID_INTEL) {
+		struct ahci_host_priv *hpriv = host->private_data;
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
+
+static int ahci_sb600_check_ready(struct ata_link *link)
+{
+	void __iomem *port_mmio = ahci_port_base(link->ap);
+	u8 status = readl(port_mmio + PORT_TFDATA) & 0xFF;
+	u32 irq_status = readl(port_mmio + PORT_IRQ_STAT);
+
+	/*
+	 * There is no need to check TFDATA if BAD PMP is found due to HW bug,
+	 * which can save timeout delay.
+	 */
+	if (irq_status & PORT_IRQ_BAD_PMP)
+		return -EIO;
+
+	return ata_check_ready(status);
+}
+
+static int ahci_sb600_softreset(struct ata_link *link, unsigned int *class,
+				unsigned long deadline)
+{
+	struct ata_port *ap = link->ap;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	int pmp = sata_srst_pmp(link);
+	int rc;
+	u32 irq_sts;
+
+	DPRINTK("ENTER\n");
+
+	rc = ahci_do_softreset(link, class, pmp, deadline,
+			       ahci_sb600_check_ready);
+
+	/*
+	 * Soft reset fails on some ATI chips with IPMS set when PMP
+	 * is enabled but SATA HDD/ODD is connected to SATA port,
+	 * do soft reset again to port 0.
+	 */
+	if (rc == -EIO) {
+		irq_sts = readl(port_mmio + PORT_IRQ_STAT);
+		if (irq_sts & PORT_IRQ_BAD_PMP) {
+			ata_link_printk(link, KERN_WARNING,
+					"applying SB600 PMP SRST workaround "
+					"and retrying\n");
+			rc = ahci_do_softreset(link, class, 0, deadline,
+					       ahci_check_ready);
+		}
+	}
+
+	return rc;
+}
+
+static int ahci_vt8251_hardreset(struct ata_link *link, unsigned int *class,
+				 unsigned long deadline)
+{
+	struct ata_port *ap = link->ap;
+	bool online;
+	int rc;
+
+	DPRINTK("ENTER\n");
+
+	ahci_stop_engine(ap);
+
+	rc = sata_link_hardreset(link, sata_ehc_deb_timing(&link->eh_context),
+				 deadline, &online, NULL);
+
+	ahci_start_engine(ap);
+
+	DPRINTK("EXIT, rc=%d, class=%u\n", rc, *class);
+
+	/* vt8251 doesn't clear BSY on signature FIS reception,
+	 * request follow-up softreset.
+	 */
+	return online ? -EAGAIN : rc;
+}
+
+static int ahci_p5wdh_hardreset(struct ata_link *link, unsigned int *class,
+				unsigned long deadline)
+{
+	struct ata_port *ap = link->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
+	struct ata_taskfile tf;
+	bool online;
+	int rc;
+
+	ahci_stop_engine(ap);
+
+	/* clear D2H reception area to properly wait for D2H FIS */
+	ata_tf_init(link->device, &tf);
+	tf.command = 0x80;
+	ata_tf_to_fis(&tf, 0, 0, d2h_fis);
+
+	rc = sata_link_hardreset(link, sata_ehc_deb_timing(&link->eh_context),
+				 deadline, &online, NULL);
+
+	ahci_start_engine(ap);
+
+	/* The pseudo configuration device on SIMG4726 attached to
+	 * ASUS P5W-DH Deluxe doesn't send signature FIS after
+	 * hardreset if no device is attached to the first downstream
+	 * port && the pseudo device locks up on SRST w/ PMP==0.  To
+	 * work around this, wait for !BSY only briefly.  If BSY isn't
+	 * cleared, perform CLO and proceed to IDENTIFY (achieved by
+	 * ATA_LFLAG_NO_SRST and ATA_LFLAG_ASSUME_ATA).
+	 *
+	 * Wait for two seconds.  Devices attached to downstream port
+	 * which can't process the following IDENTIFY after this will
+	 * have to be reset again.  For most cases, this should
+	 * suffice while making probing snappish enough.
+	 */
+	if (online) {
+		rc = ata_wait_after_reset(link, jiffies + 2 * HZ,
+					  ahci_check_ready);
+		if (rc)
+			ahci_kick_engine(ap);
+	}
+	return rc;
+}
+
+#ifdef CONFIG_PM
+static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	struct ahci_host_priv *hpriv = host->private_data;
+	void __iomem *mmio = hpriv->mmio;
+	u32 ctl;
+
+	if (mesg.event & PM_EVENT_SUSPEND &&
+	    hpriv->flags & AHCI_HFLAG_NO_SUSPEND) {
+		dev_printk(KERN_ERR, &pdev->dev,
+			   "BIOS update required for suspend/resume\n");
+		return -EIO;
+	}
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
+
+static int ahci_pci_device_resume(struct pci_dev *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	int rc;
+
+	rc = ata_pci_device_do_resume(pdev);
+	if (rc)
+		return rc;
+
+	if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
+		rc = ahci_pci_reset_controller(host);
+		if (rc)
+			return rc;
+
+		ahci_pci_init_controller(host);
+	}
+
+	ata_host_resume(host);
+
+	return 0;
+}
+#endif
+
+static int ahci_configure_dma_masks(struct pci_dev *pdev, int using_dac)
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
+
+static void ahci_pci_print_info(struct ata_host *host)
+{
+	struct pci_dev *pdev = to_pci_dev(host->dev);
+	u16 cc;
+	const char *scc_s;
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
+	ahci_print_info(host, scc_s);
+}
+
+static struct ata_port_operations ahci_vt8251_ops = {
+	.inherits		= &ahci_ops,
+	.hardreset		= ahci_vt8251_hardreset,
+};
+
+static struct ata_port_operations ahci_p5wdh_ops = {
+	.inherits		= &ahci_ops,
+	.hardreset		= ahci_p5wdh_hardreset,
+};
+
+static struct ata_port_operations ahci_sb600_ops = {
+	.inherits		= &ahci_ops,
+	.softreset		= ahci_sb600_softreset,
+	.pmp_softreset		= ahci_sb600_softreset,
+};
+
+/* On ASUS P5W DH Deluxe, the second port of PCI device 00:1f.2 is
+ * hardwired to on-board SIMG 4726.  The chipset is ICH8 and doesn't
+ * support PMP and the 4726 either directly exports the device
+ * attached to the first downstream port or acts as a hardware storage
+ * controller and emulate a single ATA device (can be RAID 0/1 or some
+ * other configuration).
+ *
+ * When there's no device attached to the first downstream port of the
+ * 4726, "Config Disk" appears, which is a pseudo ATA device to
+ * configure the 4726.  However, ATA emulation of the device is very
+ * lame.  It doesn't send signature D2H Reg FIS after the initial
+ * hardreset, pukes on SRST w/ PMP==0 and has bunch of other issues.
+ *
+ * The following function works around the problem by always using
+ * hardreset on the port and not depending on receiving signature FIS
+ * afterward.  If signature FIS isn't received soon, ATA class is
+ * assumed without follow-up softreset.
+ */
+static void ahci_p5wdh_workaround(struct ata_host *host)
+{
+	static struct dmi_system_id sysids[] = {
+		{
+			.ident = "P5W DH Deluxe",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR,
+					  "ASUSTEK COMPUTER INC"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "P5W DH Deluxe"),
+			},
+		},
+		{ }
+	};
+	struct pci_dev *pdev = to_pci_dev(host->dev);
+
+	if (pdev->bus->number == 0 && pdev->devfn == PCI_DEVFN(0x1f, 2) &&
+	    dmi_check_system(sysids)) {
+		struct ata_port *ap = host->ports[1];
+
+		dev_printk(KERN_INFO, &pdev->dev, "enabling ASUS P5W DH "
+			   "Deluxe on-board SIMG4726 workaround\n");
+
+		ap->ops = &ahci_p5wdh_ops;
+		ap->link.flags |= ATA_LFLAG_NO_SRST | ATA_LFLAG_ASSUME_ATA;
+	}
+}
+
+/* only some SB600 ahci controllers can do 64bit DMA */
+static bool ahci_sb600_enable_64bit(struct pci_dev *pdev)
+{
+	static const struct dmi_system_id sysids[] = {
+		/*
+		 * The oldest version known to be broken is 0901 and
+		 * working is 1501 which was released on 2007-10-26.
+		 * Enable 64bit DMA on 1501 and anything newer.
+		 *
+		 * Please read bko#9412 for more info.
+		 */
+		{
+			.ident = "ASUS M2A-VM",
+			.matches = {
+				DMI_MATCH(DMI_BOARD_VENDOR,
+					  "ASUSTeK Computer INC."),
+				DMI_MATCH(DMI_BOARD_NAME, "M2A-VM"),
+			},
+			.driver_data = "20071026",	/* yyyymmdd */
+		},
+		/*
+		 * All BIOS versions for the MSI K9A2 Platinum (MS-7376)
+		 * support 64bit DMA.
+		 *
+		 * BIOS versions earlier than 1.5 had the Manufacturer DMI
+		 * fields as "MICRO-STAR INTERANTIONAL CO.,LTD".
+		 * This spelling mistake was fixed in BIOS version 1.5, so
+		 * 1.5 and later have the Manufacturer as
+		 * "MICRO-STAR INTERNATIONAL CO.,LTD".
+		 * So try to match on DMI_BOARD_VENDOR of "MICRO-STAR INTER".
+		 *
+		 * BIOS versions earlier than 1.9 had a Board Product Name
+		 * DMI field of "MS-7376". This was changed to be
+		 * "K9A2 Platinum (MS-7376)" in version 1.9, but we can still
+		 * match on DMI_BOARD_NAME of "MS-7376".
+		 */
+		{
+			.ident = "MSI K9A2 Platinum",
+			.matches = {
+				DMI_MATCH(DMI_BOARD_VENDOR,
+					  "MICRO-STAR INTER"),
+				DMI_MATCH(DMI_BOARD_NAME, "MS-7376"),
+			},
+		},
+		{ }
+	};
+	const struct dmi_system_id *match;
+	int year, month, date;
+	char buf[9];
+
+	match = dmi_first_match(sysids);
+	if (pdev->bus->number != 0 || pdev->devfn != PCI_DEVFN(0x12, 0) ||
+	    !match)
+		return false;
+
+	if (!match->driver_data)
+		goto enable_64bit;
+
+	dmi_get_date(DMI_BIOS_DATE, &year, &month, &date);
+	snprintf(buf, sizeof(buf), "%04d%02d%02d", year, month, date);
+
+	if (strcmp(buf, match->driver_data) >= 0)
+		goto enable_64bit;
+	else {
+		dev_printk(KERN_WARNING, &pdev->dev, "%s: BIOS too old, "
+			   "forcing 32bit DMA, update BIOS\n", match->ident);
+		return false;
+	}
+
+enable_64bit:
+	dev_printk(KERN_WARNING, &pdev->dev, "%s: enabling 64bit DMA\n",
+		   match->ident);
+	return true;
+}
+
+static bool ahci_broken_system_poweroff(struct pci_dev *pdev)
+{
+	static const struct dmi_system_id broken_systems[] = {
+		{
+			.ident = "HP Compaq nx6310",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6310"),
+			},
+			/* PCI slot number of the controller */
+			.driver_data = (void *)0x1FUL,
+		},
+		{
+			.ident = "HP Compaq 6720s",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq 6720s"),
+			},
+			/* PCI slot number of the controller */
+			.driver_data = (void *)0x1FUL,
+		},
+
+		{ }	/* terminate list */
+	};
+	const struct dmi_system_id *dmi = dmi_first_match(broken_systems);
+
+	if (dmi) {
+		unsigned long slot = (unsigned long)dmi->driver_data;
+		/* apply the quirk only to on-board controllers */
+		return slot == PCI_SLOT(pdev->devfn);
+	}
+
+	return false;
+}
+
+static bool ahci_broken_suspend(struct pci_dev *pdev)
+{
+	static const struct dmi_system_id sysids[] = {
+		/*
+		 * On HP dv[4-6] and HDX18 with earlier BIOSen, link
+		 * to the harddisk doesn't become online after
+		 * resuming from STR.  Warn and fail suspend.
+		 */
+		{
+			.ident = "dv4",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+				DMI_MATCH(DMI_PRODUCT_NAME,
+					  "HP Pavilion dv4 Notebook PC"),
+			},
+			.driver_data = "F.30", /* cutoff BIOS version */
+		},
+		{
+			.ident = "dv5",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+				DMI_MATCH(DMI_PRODUCT_NAME,
+					  "HP Pavilion dv5 Notebook PC"),
+			},
+			.driver_data = "F.16", /* cutoff BIOS version */
+		},
+		{
+			.ident = "dv6",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+				DMI_MATCH(DMI_PRODUCT_NAME,
+					  "HP Pavilion dv6 Notebook PC"),
+			},
+			.driver_data = "F.21",	/* cutoff BIOS version */
+		},
+		{
+			.ident = "HDX18",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+				DMI_MATCH(DMI_PRODUCT_NAME,
+					  "HP HDX18 Notebook PC"),
+			},
+			.driver_data = "F.23",	/* cutoff BIOS version */
+		},
+		/*
+		 * Acer eMachines G725 has the same problem.  BIOS
+		 * V1.03 is known to be broken.  V3.04 is known to
+		 * work.  Inbetween, there are V1.06, V2.06 and V3.03
+		 * that we don't have much idea about.  For now,
+		 * blacklist anything older than V3.04.
+		 */
+		{
+			.ident = "G725",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "eMachines"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "eMachines G725"),
+			},
+			.driver_data = "V3.04",	/* cutoff BIOS version */
+		},
+		{ }	/* terminate list */
+	};
+	const struct dmi_system_id *dmi = dmi_first_match(sysids);
+	const char *ver;
+
+	if (!dmi || pdev->bus->number || pdev->devfn != PCI_DEVFN(0x1f, 2))
+		return false;
+
+	ver = dmi_get_system_info(DMI_BIOS_VERSION);
+
+	return !ver || strcmp(ver, dmi->driver_data) < 0;
+}
+
+static bool ahci_broken_online(struct pci_dev *pdev)
+{
+#define ENCODE_BUSDEVFN(bus, slot, func)			\
+	(void *)(unsigned long)(((bus) << 8) | PCI_DEVFN((slot), (func)))
+	static const struct dmi_system_id sysids[] = {
+		/*
+		 * There are several gigabyte boards which use
+		 * SIMG5723s configured as hardware RAID.  Certain
+		 * 5723 firmware revisions shipped there keep the link
+		 * online but fail to answer properly to SRST or
+		 * IDENTIFY when no device is attached downstream
+		 * causing libata to retry quite a few times leading
+		 * to excessive detection delay.
+		 *
+		 * As these firmwares respond to the second reset try
+		 * with invalid device signature, considering unknown
+		 * sig as offline works around the problem acceptably.
+		 */
+		{
+			.ident = "EP45-DQ6",
+			.matches = {
+				DMI_MATCH(DMI_BOARD_VENDOR,
+					  "Gigabyte Technology Co., Ltd."),
+				DMI_MATCH(DMI_BOARD_NAME, "EP45-DQ6"),
+			},
+			.driver_data = ENCODE_BUSDEVFN(0x0a, 0x00, 0),
+		},
+		{
+			.ident = "EP45-DS5",
+			.matches = {
+				DMI_MATCH(DMI_BOARD_VENDOR,
+					  "Gigabyte Technology Co., Ltd."),
+				DMI_MATCH(DMI_BOARD_NAME, "EP45-DS5"),
+			},
+			.driver_data = ENCODE_BUSDEVFN(0x03, 0x00, 0),
+		},
+		{ }	/* terminate list */
+	};
+#undef ENCODE_BUSDEVFN
+	const struct dmi_system_id *dmi = dmi_first_match(sysids);
+	unsigned int val;
+
+	if (!dmi)
+		return false;
+
+	val = (unsigned long)dmi->driver_data;
+
+	return pdev->bus->number == (val >> 8) && pdev->devfn == (val & 0xff);
+}
+
+#ifdef CONFIG_ATA_ACPI
+static void ahci_gtf_filter_workaround(struct ata_host *host)
+{
+	static const struct dmi_system_id sysids[] = {
+		/*
+		 * Aspire 3810T issues a bunch of SATA enable commands
+		 * via _GTF including an invalid one and one which is
+		 * rejected by the device.  Among the successful ones
+		 * is FPDMA non-zero offset enable which when enabled
+		 * only on the drive side leads to NCQ command
+		 * failures.  Filter it out.
+		 */
+		{
+			.ident = "Aspire 3810T",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 3810T"),
+			},
+			.driver_data = (void *)ATA_ACPI_FILTER_FPDMA_OFFSET,
+		},
+		{ }
+	};
+	const struct dmi_system_id *dmi = dmi_first_match(sysids);
+	unsigned int filter;
+	int i;
+
+	if (!dmi)
+		return;
+
+	filter = (unsigned long)dmi->driver_data;
+	dev_printk(KERN_INFO, host->dev,
+		   "applying extra ACPI _GTF filter 0x%x for %s\n",
+		   filter, dmi->ident);
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+		struct ata_link *link;
+		struct ata_device *dev;
+
+		ata_for_each_link(link, ap, EDGE)
+			ata_for_each_dev(dev, link, ALL)
+				dev->gtf_filter |= filter;
+	}
+}
+#else
+static inline void ahci_gtf_filter_workaround(struct ata_host *host)
+{}
+#endif
+
+enum {
+	board_ahci		= 0,
+	board_ahci_vt8251	= 1,
+	board_ahci_ign_iferr	= 2,
+	board_ahci_sb600	= 3,
+	board_ahci_mv		= 4,
+	board_ahci_sb700	= 5, /* for SB700 and SB800 */
+	board_ahci_mcp65	= 6,
+	board_ahci_nopmp	= 7,
+	board_ahci_yesncq	= 8,
+	board_ahci_nosntf	= 9,
+};
+
+#define AHCI_HFLAGS(flags)	.private_data	= (void *)(flags)
+
+static const struct ata_port_info ahci_port_info[] = {
+	[board_ahci] =
+	{
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_ops,
+	},
+	[board_ahci_vt8251] =
+	{
+		AHCI_HFLAGS	(AHCI_HFLAG_NO_NCQ | AHCI_HFLAG_NO_PMP),
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_vt8251_ops,
+	},
+	[board_ahci_ign_iferr] =
+	{
+		AHCI_HFLAGS	(AHCI_HFLAG_IGN_IRQ_IF_ERR),
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_ops,
+	},
+	[board_ahci_sb600] =
+	{
+		AHCI_HFLAGS	(AHCI_HFLAG_IGN_SERR_INTERNAL |
+				 AHCI_HFLAG_NO_MSI | AHCI_HFLAG_SECT255 |
+				 AHCI_HFLAG_32BIT_ONLY),
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_sb600_ops,
+	},
+	[board_ahci_mv] =
+	{
+		AHCI_HFLAGS	(AHCI_HFLAG_NO_NCQ | AHCI_HFLAG_NO_MSI |
+				 AHCI_HFLAG_MV_PATA | AHCI_HFLAG_NO_PMP),
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
+				  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_ops,
+	},
+	[board_ahci_sb700] =	/* for SB700 and SB800 */
+	{
+		AHCI_HFLAGS	(AHCI_HFLAG_IGN_SERR_INTERNAL),
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_sb600_ops,
+	},
+	[board_ahci_mcp65] =
+	{
+		AHCI_HFLAGS	(AHCI_HFLAG_YES_NCQ),
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_ops,
+	},
+	[board_ahci_nopmp] =
+	{
+		AHCI_HFLAGS	(AHCI_HFLAG_NO_PMP),
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_ops,
+	},
+	[board_ahci_yesncq] =
+	{
+		AHCI_HFLAGS	(AHCI_HFLAG_YES_NCQ),
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_ops,
+	},
+	[board_ahci_nosntf] =
+	{
+		AHCI_HFLAGS	(AHCI_HFLAG_NO_SNTF),
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_ops,
+	},
+};
+
+static const struct pci_device_id ahci_pci_tbl[] = {
+	/* Intel */
+	{ PCI_VDEVICE(INTEL, 0x2652), board_ahci }, /* ICH6 */
+	{ PCI_VDEVICE(INTEL, 0x2653), board_ahci }, /* ICH6M */
+	{ PCI_VDEVICE(INTEL, 0x27c1), board_ahci }, /* ICH7 */
+	{ PCI_VDEVICE(INTEL, 0x27c5), board_ahci }, /* ICH7M */
+	{ PCI_VDEVICE(INTEL, 0x27c3), board_ahci }, /* ICH7R */
+	{ PCI_VDEVICE(AL, 0x5288), board_ahci_ign_iferr }, /* ULi M5288 */
+	{ PCI_VDEVICE(INTEL, 0x2681), board_ahci }, /* ESB2 */
+	{ PCI_VDEVICE(INTEL, 0x2682), board_ahci }, /* ESB2 */
+	{ PCI_VDEVICE(INTEL, 0x2683), board_ahci }, /* ESB2 */
+	{ PCI_VDEVICE(INTEL, 0x27c6), board_ahci }, /* ICH7-M DH */
+	{ PCI_VDEVICE(INTEL, 0x2821), board_ahci }, /* ICH8 */
+	{ PCI_VDEVICE(INTEL, 0x2822), board_ahci_nosntf }, /* ICH8 */
+	{ PCI_VDEVICE(INTEL, 0x2824), board_ahci }, /* ICH8 */
+	{ PCI_VDEVICE(INTEL, 0x2829), board_ahci }, /* ICH8M */
+	{ PCI_VDEVICE(INTEL, 0x282a), board_ahci }, /* ICH8M */
+	{ PCI_VDEVICE(INTEL, 0x2922), board_ahci }, /* ICH9 */
+	{ PCI_VDEVICE(INTEL, 0x2923), board_ahci }, /* ICH9 */
+	{ PCI_VDEVICE(INTEL, 0x2924), board_ahci }, /* ICH9 */
+	{ PCI_VDEVICE(INTEL, 0x2925), board_ahci }, /* ICH9 */
+	{ PCI_VDEVICE(INTEL, 0x2927), board_ahci }, /* ICH9 */
+	{ PCI_VDEVICE(INTEL, 0x2929), board_ahci }, /* ICH9M */
+	{ PCI_VDEVICE(INTEL, 0x292a), board_ahci }, /* ICH9M */
+	{ PCI_VDEVICE(INTEL, 0x292b), board_ahci }, /* ICH9M */
+	{ PCI_VDEVICE(INTEL, 0x292c), board_ahci }, /* ICH9M */
+	{ PCI_VDEVICE(INTEL, 0x292f), board_ahci }, /* ICH9M */
+	{ PCI_VDEVICE(INTEL, 0x294d), board_ahci }, /* ICH9 */
+	{ PCI_VDEVICE(INTEL, 0x294e), board_ahci }, /* ICH9M */
+	{ PCI_VDEVICE(INTEL, 0x502a), board_ahci }, /* Tolapai */
+	{ PCI_VDEVICE(INTEL, 0x502b), board_ahci }, /* Tolapai */
+	{ PCI_VDEVICE(INTEL, 0x3a05), board_ahci }, /* ICH10 */
+	{ PCI_VDEVICE(INTEL, 0x3a22), board_ahci }, /* ICH10 */
+	{ PCI_VDEVICE(INTEL, 0x3a25), board_ahci }, /* ICH10 */
+	{ PCI_VDEVICE(INTEL, 0x3b22), board_ahci }, /* PCH AHCI */
+	{ PCI_VDEVICE(INTEL, 0x3b23), board_ahci }, /* PCH AHCI */
+	{ PCI_VDEVICE(INTEL, 0x3b24), board_ahci }, /* PCH RAID */
+	{ PCI_VDEVICE(INTEL, 0x3b25), board_ahci }, /* PCH RAID */
+	{ PCI_VDEVICE(INTEL, 0x3b29), board_ahci }, /* PCH AHCI */
+	{ PCI_VDEVICE(INTEL, 0x3b2b), board_ahci }, /* PCH RAID */
+	{ PCI_VDEVICE(INTEL, 0x3b2c), board_ahci }, /* PCH RAID */
+	{ PCI_VDEVICE(INTEL, 0x3b2f), board_ahci }, /* PCH AHCI */
+
+	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
+	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
+	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci_ign_iferr },
+
+	/* ATI */
+	{ PCI_VDEVICE(ATI, 0x4380), board_ahci_sb600 }, /* ATI SB600 */
+	{ PCI_VDEVICE(ATI, 0x4390), board_ahci_sb700 }, /* ATI SB700/800 */
+	{ PCI_VDEVICE(ATI, 0x4391), board_ahci_sb700 }, /* ATI SB700/800 */
+	{ PCI_VDEVICE(ATI, 0x4392), board_ahci_sb700 }, /* ATI SB700/800 */
+	{ PCI_VDEVICE(ATI, 0x4393), board_ahci_sb700 }, /* ATI SB700/800 */
+	{ PCI_VDEVICE(ATI, 0x4394), board_ahci_sb700 }, /* ATI SB700/800 */
+	{ PCI_VDEVICE(ATI, 0x4395), board_ahci_sb700 }, /* ATI SB700/800 */
+
+	/* AMD */
+	{ PCI_VDEVICE(AMD, 0x7800), board_ahci }, /* AMD Hudson-2 */
+	/* AMD is using RAID class only for ahci controllers */
+	{ PCI_VENDOR_ID_AMD, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
+	  PCI_CLASS_STORAGE_RAID << 8, 0xffffff, board_ahci },
+
+	/* VIA */
+	{ PCI_VDEVICE(VIA, 0x3349), board_ahci_vt8251 }, /* VIA VT8251 */
+	{ PCI_VDEVICE(VIA, 0x6287), board_ahci_vt8251 }, /* VIA VT8251 */
+
+	/* NVIDIA */
+	{ PCI_VDEVICE(NVIDIA, 0x044c), board_ahci_mcp65 },	/* MCP65 */
+	{ PCI_VDEVICE(NVIDIA, 0x044d), board_ahci_mcp65 },	/* MCP65 */
+	{ PCI_VDEVICE(NVIDIA, 0x044e), board_ahci_mcp65 },	/* MCP65 */
+	{ PCI_VDEVICE(NVIDIA, 0x044f), board_ahci_mcp65 },	/* MCP65 */
+	{ PCI_VDEVICE(NVIDIA, 0x045c), board_ahci_mcp65 },	/* MCP65 */
+	{ PCI_VDEVICE(NVIDIA, 0x045d), board_ahci_mcp65 },	/* MCP65 */
+	{ PCI_VDEVICE(NVIDIA, 0x045e), board_ahci_mcp65 },	/* MCP65 */
+	{ PCI_VDEVICE(NVIDIA, 0x045f), board_ahci_mcp65 },	/* MCP65 */
+	{ PCI_VDEVICE(NVIDIA, 0x0550), board_ahci_yesncq },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0551), board_ahci_yesncq },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0552), board_ahci_yesncq },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0553), board_ahci_yesncq },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0554), board_ahci_yesncq },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0555), board_ahci_yesncq },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0556), board_ahci_yesncq },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0557), board_ahci_yesncq },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0558), board_ahci_yesncq },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0559), board_ahci_yesncq },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x055a), board_ahci_yesncq },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x055b), board_ahci_yesncq },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0580), board_ahci_yesncq },	/* Linux ID */
+	{ PCI_VDEVICE(NVIDIA, 0x07f0), board_ahci_yesncq },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f1), board_ahci_yesncq },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f2), board_ahci_yesncq },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f3), board_ahci_yesncq },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f4), board_ahci_yesncq },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f5), board_ahci_yesncq },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f6), board_ahci_yesncq },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f7), board_ahci_yesncq },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f8), board_ahci_yesncq },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f9), board_ahci_yesncq },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07fa), board_ahci_yesncq },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07fb), board_ahci_yesncq },	/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad0), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad1), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad2), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad3), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad4), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad5), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad6), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad7), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad8), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad9), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ada), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0adb), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab4), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab5), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab6), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab7), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab8), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab9), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0aba), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0abb), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0abc), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0abd), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0abe), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0abf), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d84), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d85), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d86), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d87), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d88), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d89), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d8a), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d8b), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d8c), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d8d), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d8e), board_ahci },		/* MCP89 */
+	{ PCI_VDEVICE(NVIDIA, 0x0d8f), board_ahci },		/* MCP89 */
+
+	/* SiS */
+	{ PCI_VDEVICE(SI, 0x1184), board_ahci },		/* SiS 966 */
+	{ PCI_VDEVICE(SI, 0x1185), board_ahci },		/* SiS 968 */
+	{ PCI_VDEVICE(SI, 0x0186), board_ahci },		/* SiS 968 */
+
+	/* Marvell */
+	{ PCI_VDEVICE(MARVELL, 0x6145), board_ahci_mv },	/* 6145 */
+	{ PCI_VDEVICE(MARVELL, 0x6121), board_ahci_mv },	/* 6121 */
+
+	/* Promise */
+	{ PCI_VDEVICE(PROMISE, 0x3f20), board_ahci },	/* PDC42819 */
+
+	/* Generic, PCI class code for AHCI */
+	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
+	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci },
+
+	{ }	/* terminate list */
+};
+
+static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	static int printed_version;
+	unsigned int board_id = ent->driver_data;
+	struct ata_port_info pi = ahci_port_info[board_id];
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
+	if (pdev->vendor == PCI_VENDOR_ID_MARVELL && !marvell_enable)
+		return -ENODEV;
+
+	/* Promise's PDC42819 is a SAS/SATA controller that has an AHCI mode.
+	 * At the moment, we can only use the AHCI mode. Let the users know
+	 * that for SAS drives they're out of luck.
+	 */
+	if (pdev->vendor == PCI_VENDOR_ID_PROMISE)
+		dev_printk(KERN_INFO, &pdev->dev, "PDC42819 "
+			   "can only drive SATA devices with this driver\n");
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
+	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
+	    (pdev->device == 0x2652 || pdev->device == 0x2653)) {
+		u8 map;
+
+		/* ICH6s share the same PCI ID for both piix and ahci
+		 * modes.  Enabling ahci mode while MAP indicates
+		 * combined mode is a bad idea.  Yield to ata_piix.
+		 */
+		pci_read_config_byte(pdev, ICH_MAP, &map);
+		if (map & 0x3) {
+			dev_printk(KERN_INFO, &pdev->dev, "controller is in "
+				   "combined mode, can't enable AHCI mode\n");
+			return -ENODEV;
+		}
+	}
+
+	hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
+	if (!hpriv)
+		return -ENOMEM;
+	hpriv->flags |= (unsigned long)pi.private_data;
+
+	/* MCP65 revision A1 and A2 can't do MSI */
+	if (board_id == board_ahci_mcp65 &&
+	    (pdev->revision == 0xa1 || pdev->revision == 0xa2))
+		hpriv->flags |= AHCI_HFLAG_NO_MSI;
+
+	/* SB800 does NOT need the workaround to ignore SERR_INTERNAL */
+	if (board_id == board_ahci_sb700 && pdev->revision >= 0x40)
+		hpriv->flags &= ~AHCI_HFLAG_IGN_SERR_INTERNAL;
+
+	/* only some SB600s can do 64bit DMA */
+	if (ahci_sb600_enable_64bit(pdev))
+		hpriv->flags &= ~AHCI_HFLAG_32BIT_ONLY;
+
+	if ((hpriv->flags & AHCI_HFLAG_NO_MSI) || pci_enable_msi(pdev))
+		pci_intx(pdev, 1);
+
+	hpriv->mmio = pcim_iomap_table(pdev)[AHCI_PCI_BAR];
+
+	/* save initial config */
+	ahci_pci_save_initial_config(pdev, hpriv);
+
+	/* prepare host */
+	if (hpriv->cap & HOST_CAP_NCQ) {
+		pi.flags |= ATA_FLAG_NCQ;
+		/* Auto-activate optimization is supposed to be supported on
+		   all AHCI controllers indicating NCQ support, but it seems
+		   to be broken at least on some NVIDIA MCP79 chipsets.
+		   Until we get info on which NVIDIA chipsets don't have this
+		   issue, if any, disable AA on all NVIDIA AHCIs. */
+		if (pdev->vendor != PCI_VENDOR_ID_NVIDIA)
+			pi.flags |= ATA_FLAG_FPDMA_AA;
+	}
+
+	if (hpriv->cap & HOST_CAP_PMP)
+		pi.flags |= ATA_FLAG_PMP;
+
+	ahci_set_em_messages(hpriv, &pi);
+
+	if (ahci_broken_system_poweroff(pdev)) {
+		pi.flags |= ATA_FLAG_NO_POWEROFF_SPINDOWN;
+		dev_info(&pdev->dev,
+			"quirky BIOS, skipping spindown on poweroff\n");
+	}
+
+	if (ahci_broken_suspend(pdev)) {
+		hpriv->flags |= AHCI_HFLAG_NO_SUSPEND;
+		dev_printk(KERN_WARNING, &pdev->dev,
+			   "BIOS update required for suspend/resume\n");
+	}
+
+	if (ahci_broken_online(pdev)) {
+		hpriv->flags |= AHCI_HFLAG_SRST_TOUT_IS_OFFLINE;
+		dev_info(&pdev->dev,
+			 "online status unreliable, applying workaround\n");
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
+	/* apply workaround for ASUS P5W DH Deluxe mainboard */
+	ahci_p5wdh_workaround(host);
+
+	/* apply gtf filter quirk */
+	ahci_gtf_filter_workaround(host);
+
+	/* initialize adapter */
+	rc = ahci_configure_dma_masks(pdev, hpriv->cap & HOST_CAP_64);
+	if (rc)
+		return rc;
+
+	rc = ahci_pci_reset_controller(host);
+	if (rc)
+		return rc;
+
+	ahci_pci_init_controller(host);
+	ahci_pci_print_info(host);
+
+	pci_set_master(pdev);
+	return ata_host_activate(host, pdev->irq, ahci_interrupt, IRQF_SHARED,
+				 &ahci_sht);
+}
+
+static struct pci_driver ahci_pci_driver = {
+	.name			= DRV_NAME,
+	.id_table		= ahci_pci_tbl,
+	.probe			= ahci_init_one,
+	.remove			= ata_pci_remove_one,
+#ifdef CONFIG_PM
+	.suspend		= ahci_pci_device_suspend,
+	.resume			= ahci_pci_device_resume,
+#endif
+};
+
+static int __init ahci_init(void)
+{
+	return pci_register_driver(&ahci_pci_driver);
+}
+
+static void __exit ahci_exit(void)
+{
+	pci_unregister_driver(&ahci_pci_driver);
+}
+
+
+MODULE_AUTHOR("Jeff Garzik");
+MODULE_DESCRIPTION("AHCI SATA low-level driver");
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(pci, ahci_pci_tbl);
+MODULE_VERSION(DRV_VERSION);
+
+module_init(ahci_init);
+module_exit(ahci_exit);
-- 
1.7.0

