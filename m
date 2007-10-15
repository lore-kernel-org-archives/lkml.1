Return-Path: <linux-kernel-owner+w=401wt.eu-S1765419AbXJOUUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765419AbXJOUUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764724AbXJOUUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:20:22 -0400
Received: from havoc.gtf.org ([69.61.125.42]:32869 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934051AbXJOUUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:20:14 -0400
Date: Mon, 15 Oct 2007 16:20:12 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates
Message-ID: <20071015202012.GA3997@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The sata_nv update has been in -mm for a while, but couldn't make the
last drop due to last minute bugs.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/Kconfig       |    9 +
 drivers/ata/Makefile      |    1 +
 drivers/ata/ata_piix.c    |   35 ++-
 drivers/ata/libata-core.c |    9 +-
 drivers/ata/libata-scsi.c |    5 +-
 drivers/ata/pata_cs5536.c |  346 ++++++++++++++++++
 drivers/ata/pata_pcmcia.c |    2 +
 drivers/ata/pata_sil680.c |   61 +++-
 drivers/ata/sata_nv.c     |  851 ++++++++++++++++++++++++++++++++++++++++++++-
 9 files changed, 1298 insertions(+), 21 deletions(-)
 create mode 100644 drivers/ata/pata_cs5536.c

Andrew Paprocki (1):
      libata: prevent devices with blank model names from being DMA blacklisted

Benjamin Herrenschmidt (1):
      [libata] pata_sil680: Add MMIO support

Jason Gaston (1):
      ata_piix: SATA 2port controller port map fix

Kristoffer Ericson (1):
      [libata] pata_pcmcia: Add additional id string (corsair, 1GB)

Kuan Luo (1):
      [libata] sata_nv: add SW NCQ support for MCP51/MCP55/MCP61

Martin K. Petersen (1):
      pata_cs5536: ATA driver for Geode companion chip

Tejun Heo (2):
      libata: fix revalidation issuing after configuration commands
      libata: add ST9160821AS / 3.CCD to NCQ blacklist

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 4672066..33f5eb0 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -272,6 +272,15 @@ config PATA_CS5535
 
 	  If unsure, say N.
 
+config PATA_CS5536
+	tristate "CS5536 PATA support (Experimental)"
+	depends on PCI && X86 && !X86_64 && EXPERIMENTAL
+	help
+	  This option enables support for the AMD CS5536
+	  companion chip used with the Geode LX processor family.
+
+	  If unsure, say N.
+
 config PATA_CYPRESS
 	tristate "Cypress CY82C693 PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 2a63645..6bdc307 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_PATA_CMD64X)	+= pata_cmd64x.o
 obj-$(CONFIG_PATA_CS5520)	+= pata_cs5520.o
 obj-$(CONFIG_PATA_CS5530)	+= pata_cs5530.o
 obj-$(CONFIG_PATA_CS5535)	+= pata_cs5535.o
+obj-$(CONFIG_PATA_CS5536)	+= pata_cs5536.o
 obj-$(CONFIG_PATA_CYPRESS)	+= pata_cypress.o
 obj-$(CONFIG_PATA_EFAR)		+= pata_efar.o
 obj-$(CONFIG_PATA_HPT366)	+= pata_hpt366.o
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 9ce4aa9..3c6f43e 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -130,6 +130,7 @@ enum {
 	ich8_sata_ahci		= 9,
 	piix_pata_mwdma		= 10,	/* PIIX3 MWDMA only */
 	tolapai_sata_ahci	= 11,
+	ich9_2port_sata		= 12,
 
 	/* constants for mapping table */
 	P0			= 0,  /* port 0 */
@@ -238,19 +239,19 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	/* SATA Controller 1 IDE (ICH8) */
 	{ 0x8086, 0x2820, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
 	/* SATA Controller 2 IDE (ICH8) */
-	{ 0x8086, 0x2825, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
+	{ 0x8086, 0x2825, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich9_2port_sata },
 	/* Mobile SATA Controller IDE (ICH8M) */
 	{ 0x8086, 0x2828, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
 	/* SATA Controller IDE (ICH9) */
 	{ 0x8086, 0x2920, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
 	/* SATA Controller IDE (ICH9) */
-	{ 0x8086, 0x2921, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
+	{ 0x8086, 0x2921, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich9_2port_sata },
 	/* SATA Controller IDE (ICH9) */
-	{ 0x8086, 0x2926, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
+	{ 0x8086, 0x2926, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich9_2port_sata },
 	/* SATA Controller IDE (ICH9M) */
-	{ 0x8086, 0x2928, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
+	{ 0x8086, 0x2928, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich9_2port_sata },
 	/* SATA Controller IDE (ICH9M) */
-	{ 0x8086, 0x292d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
+	{ 0x8086, 0x292d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich9_2port_sata },
 	/* SATA Controller IDE (ICH9M) */
 	{ 0x8086, 0x292e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
 	/* SATA Controller IDE (Tolapai) */
@@ -448,6 +449,18 @@ static const struct piix_map_db tolapai_map_db = {
 	},
 };
 
+static const struct piix_map_db ich9_2port_map_db = {
+	.mask = 0x3,
+	.port_enable = 0x3,
+	.map = {
+		/* PM   PS   SM   SS       MAP */
+		{  P0,  NA,  P1,  NA }, /* 00b */
+		{  RV,  RV,  RV,  RV }, /* 01b */
+		{  RV,  RV,  RV,  RV }, /* 10b */
+		{  RV,  RV,  RV,  RV },
+	},
+};
+
 static const struct piix_map_db *piix_map_db_table[] = {
 	[ich5_sata]		= &ich5_map_db,
 	[ich6_sata]		= &ich6_map_db,
@@ -455,6 +468,7 @@ static const struct piix_map_db *piix_map_db_table[] = {
 	[ich6m_sata_ahci]	= &ich6m_map_db,
 	[ich8_sata_ahci]	= &ich8_map_db,
 	[tolapai_sata_ahci]	= &tolapai_map_db,
+	[ich9_2port_sata]	= &ich9_2port_map_db,
 };
 
 static struct ata_port_info piix_port_info[] = {
@@ -570,6 +584,17 @@ static struct ata_port_info piix_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
+
+	[ich9_2port_sata] =
+	{
+		.sht		= &piix_sht,
+		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SCR |
+				  PIIX_FLAG_AHCI,
+		.pio_mask	= 0x1f,	/* pio0-4 */
+		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
 };
 
 static struct pci_bits piix_enable_bits[] = {
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index b05384a..68699b3 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3984,6 +3984,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "ST9120822AS",	"3.CLF",	ATA_HORKAGE_NONCQ, },
 	{ "ST9160821AS",	"3.CLF",	ATA_HORKAGE_NONCQ, },
 	{ "ST9160821AS",	"3.ALD",	ATA_HORKAGE_NONCQ, },
+	{ "ST9160821AS",	"3.CCD",	ATA_HORKAGE_NONCQ, },
 	{ "ST3160812AS",	"3.ADJ",	ATA_HORKAGE_NONCQ, },
 	{ "ST980813AS",		"3.ADB",	ATA_HORKAGE_NONCQ, },
 	{ "SAMSUNG HD401LJ",	"ZZ100-15",	ATA_HORKAGE_NONCQ, },
@@ -4013,8 +4014,14 @@ int strn_pattern_cmp(const char *patt, const char *name, int wildchar)
 	p = strchr(patt, wildchar);
 	if (p && ((*(p + 1)) == 0))
 		len = p - patt;
-	else
+	else {
 		len = strlen(name);
+		if (!len) {
+			if (!*patt)
+				return 0;
+			return -1;
+		}
+	}
 
 	return strncmp(patt, name, len);
 }
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index ea53e6a..d63c81e 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1363,6 +1363,7 @@ nothing_to_do:
 static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
+	struct ata_eh_info *ehi = &qc->dev->link->eh_info;
 	struct scsi_cmnd *cmd = qc->scsicmd;
 	u8 *cdb = cmd->cmnd;
  	int need_sense = (qc->err_mask != 0);
@@ -1376,14 +1377,14 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 		case ATA_CMD_SET_FEATURES:
 			if ((qc->tf.feature == SETFEATURES_WC_ON) ||
 			    (qc->tf.feature == SETFEATURES_WC_OFF)) {
-				ap->link.eh_info.action |= ATA_EH_REVALIDATE;
+				ehi->action |= ATA_EH_REVALIDATE;
 				ata_port_schedule_eh(ap);
 			}
 			break;
 
 		case ATA_CMD_INIT_DEV_PARAMS: /* CHS translation changed */
 		case ATA_CMD_SET_MULTI: /* multi_count changed */
-			ap->link.eh_info.action |= ATA_EH_REVALIDATE;
+			ehi->action |= ATA_EH_REVALIDATE;
 			ata_port_schedule_eh(ap);
 			break;
 		}
diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
new file mode 100644
index 0000000..21405bf
--- /dev/null
+++ b/drivers/ata/pata_cs5536.c
@@ -0,0 +1,346 @@
+/*
+ * pata_cs5536.c	- CS5536 PATA for new ATA layer
+ *			  (C) 2007 Martin K. Petersen <mkp@mkp.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307	 USA
+ *
+ * Documentation:
+ *	Available from AMD web site.
+ *
+ * The IDE timing registers for the CS5536 live in the Geode Machine
+ * Specific Register file and not PCI config space.  Most BIOSes
+ * virtualize the PCI registers so the chip looks like a standard IDE
+ * controller.	Unfortunately not all implementations get this right.
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
+#include <linux/blkdev.h>
+#include <linux/delay.h>
+#include <linux/libata.h>
+#include <scsi/scsi_host.h>
+#include <asm/msr.h>
+
+#define DRV_NAME	"pata_cs5536"
+#define DRV_VERSION	"0.0.5"
+
+enum {
+	CFG			= 0,
+	DTC			= 1,
+	CAST			= 2,
+	ETC			= 3,
+
+	MSR_IDE_BASE		= 0x51300000,
+	MSR_IDE_CFG		= (MSR_IDE_BASE + 0x10),
+	MSR_IDE_DTC		= (MSR_IDE_BASE + 0x12),
+	MSR_IDE_CAST		= (MSR_IDE_BASE + 0x13),
+	MSR_IDE_ETC		= (MSR_IDE_BASE + 0x14),
+
+	PCI_IDE_CFG		= 0x40,
+	PCI_IDE_DTC		= 0x48,
+	PCI_IDE_CAST		= 0x4c,
+	PCI_IDE_ETC		= 0x50,
+
+	IDE_CFG_CHANEN		= 0x2,
+	IDE_CFG_CABLE		= 0x10000,
+
+	IDE_D0_SHIFT		= 24,
+	IDE_D1_SHIFT		= 16,
+	IDE_DRV_MASK		= 0xff,
+
+	IDE_CAST_D0_SHIFT	= 6,
+	IDE_CAST_D1_SHIFT	= 4,
+	IDE_CAST_DRV_MASK	= 0x3,
+	IDE_CAST_CMD_MASK	= 0xff,
+	IDE_CAST_CMD_SHIFT	= 24,
+
+	IDE_ETC_NODMA		= 0x03,
+};
+
+static int use_msr;
+
+static const u32 msr_reg[4] = {
+	MSR_IDE_CFG, MSR_IDE_DTC, MSR_IDE_CAST, MSR_IDE_ETC,
+};
+
+static const u8 pci_reg[4] = {
+	PCI_IDE_CFG, PCI_IDE_DTC, PCI_IDE_CAST, PCI_IDE_ETC,
+};
+
+static inline int cs5536_read(struct pci_dev *pdev, int reg, int *val)
+{
+	if (unlikely(use_msr)) {
+		u32 dummy;
+
+		rdmsr(msr_reg[reg], *val, dummy);
+		return 0;
+	}
+
+	return pci_read_config_dword(pdev, pci_reg[reg], val);
+}
+
+static inline int cs5536_write(struct pci_dev *pdev, int reg, int val)
+{
+	if (unlikely(use_msr)) {
+		wrmsr(msr_reg[reg], val, 0);
+		return 0;
+	}
+
+	return pci_write_config_dword(pdev, pci_reg[reg], val);
+}
+
+/**
+ *	cs5536_cable_detect	-	detect cable type
+ *	@ap: Port to detect on
+ *	@deadline: deadline jiffies for the operation
+ *
+ *	Perform cable detection for ATA66 capable cable. Return a libata
+ *	cable type.
+ */
+
+static int cs5536_cable_detect(struct ata_port *ap)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u32 cfg;
+
+	cs5536_read(pdev, CFG, &cfg);
+
+	if (cfg & (IDE_CFG_CABLE << ap->port_no))
+		return ATA_CBL_PATA80;
+	else
+		return ATA_CBL_PATA40;
+}
+
+/**
+ *	cs5536_set_piomode		-	PIO setup
+ *	@ap: ATA interface
+ *	@adev: device on the interface
+ */
+
+static void cs5536_set_piomode(struct ata_port *ap, struct ata_device *adev)
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
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	struct ata_device *pair = ata_dev_pair(adev);
+	int mode = adev->pio_mode - XFER_PIO_0;
+	int cmdmode = mode;
+	int dshift = ap->port_no ? IDE_D1_SHIFT : IDE_D0_SHIFT;
+	int cshift = ap->port_no ? IDE_CAST_D1_SHIFT : IDE_CAST_D0_SHIFT;
+	u32 dtc, cast, etc;
+
+	if (pair)
+		cmdmode = min(mode, pair->pio_mode - XFER_PIO_0);
+
+	cs5536_read(pdev, DTC, &dtc);
+	cs5536_read(pdev, CAST, &cast);
+	cs5536_read(pdev, ETC, &etc);
+
+	dtc &= ~(IDE_DRV_MASK << dshift);
+	dtc |= drv_timings[mode] << dshift;
+
+	cast &= ~(IDE_CAST_DRV_MASK << cshift);
+	cast |= addr_timings[mode] << cshift;
+
+	cast &= ~(IDE_CAST_CMD_MASK << IDE_CAST_CMD_SHIFT);
+	cast |= cmd_timings[cmdmode] << IDE_CAST_CMD_SHIFT;
+
+	etc &= ~(IDE_DRV_MASK << dshift);
+	etc |= IDE_ETC_NODMA << dshift;
+
+	cs5536_write(pdev, DTC, dtc);
+	cs5536_write(pdev, CAST, cast);
+	cs5536_write(pdev, ETC, etc);
+}
+
+/**
+ *	cs5536_set_dmamode		-	DMA timing setup
+ *	@ap: ATA interface
+ *	@adev: Device being configured
+ *
+ */
+
+static void cs5536_set_dmamode(struct ata_port *ap, struct ata_device *adev)
+{
+	static const u8 udma_timings[6] = {
+		0xc2, 0xc1, 0xc0, 0xc4, 0xc5, 0xc6,
+	};
+
+	static const u8 mwdma_timings[3] = {
+		0x67, 0x21, 0x20,
+	};
+
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u32 dtc, etc;
+	int mode = adev->dma_mode;
+	int dshift = ap->port_no ? IDE_D1_SHIFT : IDE_D0_SHIFT;
+
+	if (mode >= XFER_UDMA_0) {
+		cs5536_read(pdev, ETC, &etc);
+
+		etc &= ~(IDE_DRV_MASK << dshift);
+		etc |= udma_timings[mode - XFER_UDMA_0] << dshift;
+
+		cs5536_write(pdev, ETC, etc);
+	} else { /* MWDMA */
+		cs5536_read(pdev, DTC, &dtc);
+
+		dtc &= ~(IDE_DRV_MASK << dshift);
+		dtc |= mwdma_timings[mode] << dshift;
+
+		cs5536_write(pdev, DTC, dtc);
+	}
+}
+
+static struct scsi_host_template cs5536_sht = {
+	.module			= THIS_MODULE,
+	.name			= DRV_NAME,
+	.ioctl			= ata_scsi_ioctl,
+	.queuecommand		= ata_scsi_queuecmd,
+	.can_queue		= ATA_DEF_QUEUE,
+	.this_id		= ATA_SHT_THIS_ID,
+	.sg_tablesize		= LIBATA_MAX_PRD,
+	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
+	.emulated		= ATA_SHT_EMULATED,
+	.use_clustering		= ATA_SHT_USE_CLUSTERING,
+	.proc_name		= DRV_NAME,
+	.dma_boundary		= ATA_DMA_BOUNDARY,
+	.slave_configure	= ata_scsi_slave_config,
+	.slave_destroy		= ata_scsi_slave_destroy,
+	.bios_param		= ata_std_bios_param,
+};
+
+static struct ata_port_operations cs5536_port_ops = {
+	.port_disable		= ata_port_disable,
+	.set_piomode		= cs5536_set_piomode,
+	.set_dmamode		= cs5536_set_dmamode,
+	.mode_filter		= ata_pci_default_filter,
+
+	.tf_load		= ata_tf_load,
+	.tf_read		= ata_tf_read,
+	.check_status		= ata_check_status,
+	.exec_command		= ata_exec_command,
+	.dev_select		= ata_std_dev_select,
+
+	.freeze			= ata_bmdma_freeze,
+	.thaw			= ata_bmdma_thaw,
+	.error_handler		= ata_bmdma_error_handler,
+	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+	.cable_detect		= cs5536_cable_detect,
+
+	.bmdma_setup		= ata_bmdma_setup,
+	.bmdma_start		= ata_bmdma_start,
+	.bmdma_stop		= ata_bmdma_stop,
+	.bmdma_status		= ata_bmdma_status,
+
+	.qc_prep		= ata_qc_prep,
+	.qc_issue		= ata_qc_issue_prot,
+
+	.data_xfer		= ata_data_xfer,
+
+	.irq_handler		= ata_interrupt,
+	.irq_clear		= ata_bmdma_irq_clear,
+	.irq_on			= ata_irq_on,
+	.irq_ack		= ata_irq_ack,
+
+	.port_start		= ata_port_start,
+};
+
+/**
+ *	cs5536_init_one
+ *	@dev: PCI device
+ *	@id: Entry in match table
+ *
+ */
+
+static int cs5536_init_one(struct pci_dev *dev, const struct pci_device_id *id)
+{
+	static const struct ata_port_info info = {
+		.sht = &cs5536_sht,
+		.flags = ATA_FLAG_SLAVE_POSS,
+		.pio_mask = 0x1f,
+		.mwdma_mask = 0x07,
+		.udma_mask = ATA_UDMA5,
+		.port_ops = &cs5536_port_ops,
+	};
+
+	const struct ata_port_info *ppi[] = { &info, &ata_dummy_port_info };
+	u32 cfg;
+
+	if (use_msr)
+		printk(KERN_ERR DRV_NAME ": Using MSR regs instead of PCI\n");
+
+	cs5536_read(dev, CFG, &cfg);
+
+	if ((cfg & IDE_CFG_CHANEN) == 0) {
+		printk(KERN_ERR DRV_NAME ": disabled by BIOS\n");
+		return -ENODEV;
+	}
+
+	return ata_pci_init_one(dev, ppi);
+}
+
+static const struct pci_device_id cs5536[] = {
+	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_CS5536_IDE), },
+	{ },
+};
+
+static struct pci_driver cs5536_pci_driver = {
+	.name		= DRV_NAME,
+	.id_table	= cs5536,
+	.probe		= cs5536_init_one,
+	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
+	.suspend	= ata_pci_device_suspend,
+	.resume		= ata_pci_device_resume,
+#endif
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
+MODULE_AUTHOR("Martin K. Petersen");
+MODULE_DESCRIPTION("low-level driver for the CS5536 IDE controller");
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(pci, cs5536);
+MODULE_VERSION(DRV_VERSION);
+module_param_named(msr, use_msr, int, 0644);
+MODULE_PARM_DESC(msr, "Force using MSR to configure IDE function (Default: 0)");
+
+module_init(cs5536_init);
+module_exit(cs5536_exit);
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 782ff4a..5db2013 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -353,6 +353,7 @@ static void pcmcia_remove_one(struct pcmcia_device *pdev)
 
 static struct pcmcia_device_id pcmcia_devices[] = {
 	PCMCIA_DEVICE_FUNC_ID(4),
+	PCMCIA_DEVICE_MANF_CARD(0x0000, 0x0000),	/* Corsair */
 	PCMCIA_DEVICE_MANF_CARD(0x0007, 0x0000),	/* Hitachi */
 	PCMCIA_DEVICE_MANF_CARD(0x000a, 0x0000),	/* I-O Data CFA */
 	PCMCIA_DEVICE_MANF_CARD(0x001c, 0x0001),	/* Mitsubishi CFA */
@@ -378,6 +379,7 @@ static struct pcmcia_device_id pcmcia_devices[] = {
 	PCMCIA_DEVICE_PROD_ID12("EXP   ", "CD-ROM", 0x0a5c52fd, 0x66536591),
 	PCMCIA_DEVICE_PROD_ID12("EXP   ", "PnPIDE", 0x0a5c52fd, 0x0c694728),
 	PCMCIA_DEVICE_PROD_ID12("FREECOM", "PCCARD-IDE", 0x5714cbf7, 0x48e0ab8e),
+	PCMCIA_DEVICE_PROD_ID12("Hyperstone", "Model1", 0x3d5b9ef5, 0xca6ab420),
 	PCMCIA_DEVICE_PROD_ID12("HITACHI", "FLASH", 0xf4f43949, 0x9eb86aae),
 	PCMCIA_DEVICE_PROD_ID12("HITACHI", "microdrive", 0xf4f43949, 0xa6d76178),
 	PCMCIA_DEVICE_PROD_ID12("IBM", "microdrive", 0xb569a6e5, 0xa6d76178),
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index 2eb75cd..4dc2e73 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -279,7 +279,7 @@ static struct ata_port_operations sil680_port_ops = {
  *	Returns the final clock settings.
  */
 
-static u8 sil680_init_chip(struct pci_dev *pdev)
+static u8 sil680_init_chip(struct pci_dev *pdev, int *try_mmio)
 {
 	u32 class_rev	= 0;
 	u8 tmpbyte	= 0;
@@ -297,6 +297,8 @@ static u8 sil680_init_chip(struct pci_dev *pdev)
 	dev_dbg(&pdev->dev, "sil680: BA5_EN = %d clock = %02X\n",
 		tmpbyte & 1, tmpbyte & 0x30);
 
+	*try_mmio = (tmpbyte & 1) || pci_resource_start(pdev, 5);
+
 	switch(tmpbyte & 0x30) {
 		case 0x00:
 			/* 133 clock attempt to force it on */
@@ -361,25 +363,76 @@ static int __devinit sil680_init_one(struct pci_dev *pdev,
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
 	static int printed_version;
+	struct ata_host *host;
+	void __iomem *mmio_base;
+	int rc, try_mmio;
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
 
-	switch(sil680_init_chip(pdev))
-	{
+	switch (sil680_init_chip(pdev, &try_mmio)) {
 		case 0:
 			ppi[0] = &info_slow;
 			break;
 		case 0x30:
 			return -ENODEV;
 	}
+
+	if (!try_mmio)
+		goto use_ioports;
+
+	/* Try to acquire MMIO resources and fallback to PIO if
+	 * that fails
+	 */
+	rc = pcim_enable_device(pdev);
+	if (rc)
+		return rc;
+	rc = pcim_iomap_regions(pdev, 1 << SIL680_MMIO_BAR, DRV_NAME);
+	if (rc)
+		goto use_ioports;
+
+	/* Allocate host and set it up */
+	host = ata_host_alloc_pinfo(&pdev->dev, ppi, 2);
+	if (!host)
+		return -ENOMEM;
+	host->iomap = pcim_iomap_table(pdev);
+
+	/* Setup DMA masks */
+	rc = pci_set_dma_mask(pdev, ATA_DMA_MASK);
+	if (rc)
+		return rc;
+	rc = pci_set_consistent_dma_mask(pdev, ATA_DMA_MASK);
+	if (rc)
+		return rc;
+	pci_set_master(pdev);
+
+	/* Get MMIO base and initialize port addresses */
+	mmio_base = host->iomap[SIL680_MMIO_BAR];
+	host->ports[0]->ioaddr.bmdma_addr = mmio_base + 0x00;
+	host->ports[0]->ioaddr.cmd_addr = mmio_base + 0x80;
+	host->ports[0]->ioaddr.ctl_addr = mmio_base + 0x8a;
+	host->ports[0]->ioaddr.altstatus_addr = mmio_base + 0x8a;
+	ata_std_ports(&host->ports[0]->ioaddr);
+	host->ports[1]->ioaddr.bmdma_addr = mmio_base + 0x08;
+	host->ports[1]->ioaddr.cmd_addr = mmio_base + 0xc0;
+	host->ports[1]->ioaddr.ctl_addr = mmio_base + 0xca;
+	host->ports[1]->ioaddr.altstatus_addr = mmio_base + 0xca;
+	ata_std_ports(&host->ports[1]->ioaddr);
+
+	/* Register & activate */
+	return ata_host_activate(host, pdev->irq, ata_interrupt, IRQF_SHARED,
+				 &sil680_sht);
+
+use_ioports:
 	return ata_pci_init_one(pdev, ppi);
 }
 
 #ifdef CONFIG_PM
 static int sil680_reinit_one(struct pci_dev *pdev)
 {
-	sil680_init_chip(pdev);
+	int try_mmio;
+
+	sil680_init_chip(pdev, &try_mmio);
 	return ata_pci_device_resume(pdev);
 }
 #endif
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 40557fe..240a892 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -169,6 +169,35 @@ enum {
 	NV_ADMA_PORT_REGISTER_MODE	= (1 << 0),
 	NV_ADMA_ATAPI_SETUP_COMPLETE	= (1 << 1),
 
+	/* MCP55 reg offset */
+	NV_CTL_MCP55			= 0x400,
+	NV_INT_STATUS_MCP55		= 0x440,
+	NV_INT_ENABLE_MCP55		= 0x444,
+	NV_NCQ_REG_MCP55		= 0x448,
+
+	/* MCP55 */
+	NV_INT_ALL_MCP55		= 0xffff,
+	NV_INT_PORT_SHIFT_MCP55		= 16,	/* each port occupies 16 bits */
+	NV_INT_MASK_MCP55		= NV_INT_ALL_MCP55 & 0xfffd,
+
+	/* SWNCQ ENABLE BITS*/
+	NV_CTL_PRI_SWNCQ		= 0x02,
+	NV_CTL_SEC_SWNCQ		= 0x04,
+
+	/* SW NCQ status bits*/
+	NV_SWNCQ_IRQ_DEV		= (1 << 0),
+	NV_SWNCQ_IRQ_PM			= (1 << 1),
+	NV_SWNCQ_IRQ_ADDED		= (1 << 2),
+	NV_SWNCQ_IRQ_REMOVED		= (1 << 3),
+
+	NV_SWNCQ_IRQ_BACKOUT		= (1 << 4),
+	NV_SWNCQ_IRQ_SDBFIS		= (1 << 5),
+	NV_SWNCQ_IRQ_DHREGFIS		= (1 << 6),
+	NV_SWNCQ_IRQ_DMASETUP		= (1 << 7),
+
+	NV_SWNCQ_IRQ_HOTPLUG		= NV_SWNCQ_IRQ_ADDED |
+					  NV_SWNCQ_IRQ_REMOVED,
+
 };
 
 /* ADMA Physical Region Descriptor - one SG segment */
@@ -226,6 +255,42 @@ struct nv_host_priv {
 	unsigned long		type;
 };
 
+struct defer_queue {
+	u32		defer_bits;
+	unsigned int	head;
+	unsigned int	tail;
+	unsigned int	tag[ATA_MAX_QUEUE];
+};
+
+enum ncq_saw_flag_list {
+	ncq_saw_d2h	= (1U << 0),
+	ncq_saw_dmas	= (1U << 1),
+	ncq_saw_sdb	= (1U << 2),
+	ncq_saw_backout	= (1U << 3),
+};
+
+struct nv_swncq_port_priv {
+	struct ata_prd	*prd;	 /* our SG list */
+	dma_addr_t	prd_dma; /* and its DMA mapping */
+	void __iomem	*sactive_block;
+	void __iomem	*irq_block;
+	void __iomem	*tag_block;
+	u32		qc_active;
+
+	unsigned int	last_issue_tag;
+
+	/* fifo circular queue to store deferral command */
+	struct defer_queue defer_queue;
+
+	/* for NCQ interrupt analysis */
+	u32		dhfis_bits;
+	u32		dmafis_bits;
+	u32		sdbfis_bits;
+
+	unsigned int	ncq_flags;
+};
+
+
 #define NV_ADMA_CHECK_INTR(GCTL, PORT) ((GCTL) & ( 1 << (19 + (12 * (PORT)))))
 
 static int nv_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
@@ -263,13 +328,29 @@ static void nv_adma_host_stop(struct ata_host *host);
 static void nv_adma_post_internal_cmd(struct ata_queued_cmd *qc);
 static void nv_adma_tf_read(struct ata_port *ap, struct ata_taskfile *tf);
 
+static void nv_mcp55_thaw(struct ata_port *ap);
+static void nv_mcp55_freeze(struct ata_port *ap);
+static void nv_swncq_error_handler(struct ata_port *ap);
+static int nv_swncq_slave_config(struct scsi_device *sdev);
+static int nv_swncq_port_start(struct ata_port *ap);
+static void nv_swncq_qc_prep(struct ata_queued_cmd *qc);
+static void nv_swncq_fill_sg(struct ata_queued_cmd *qc);
+static unsigned int nv_swncq_qc_issue(struct ata_queued_cmd *qc);
+static void nv_swncq_irq_clear(struct ata_port *ap, u16 fis);
+static irqreturn_t nv_swncq_interrupt(int irq, void *dev_instance);
+#ifdef CONFIG_PM
+static int nv_swncq_port_suspend(struct ata_port *ap, pm_message_t mesg);
+static int nv_swncq_port_resume(struct ata_port *ap);
+#endif
+
 enum nv_host_type
 {
 	GENERIC,
 	NFORCE2,
 	NFORCE3 = NFORCE2,	/* NF2 == NF3 as far as sata_nv is concerned */
 	CK804,
-	ADMA
+	ADMA,
+	SWNCQ,
 };
 
 static const struct pci_device_id nv_pci_tbl[] = {
@@ -280,13 +361,13 @@ static const struct pci_device_id nv_pci_tbl[] = {
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_CK804_SATA2), CK804 },
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP04_SATA), CK804 },
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP04_SATA2), CK804 },
-	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA), GENERIC },
-	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA2), GENERIC },
-	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA), GENERIC },
-	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA2), GENERIC },
-	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA), GENERIC },
-	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA2), GENERIC },
-	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA3), GENERIC },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA), SWNCQ },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA2), SWNCQ },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA), SWNCQ },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA2), SWNCQ },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA), SWNCQ },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA2), SWNCQ },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA3), SWNCQ },
 
 	{ } /* terminate list */
 };
@@ -339,6 +420,25 @@ static struct scsi_host_template nv_adma_sht = {
 	.bios_param		= ata_std_bios_param,
 };
 
+static struct scsi_host_template nv_swncq_sht = {
+	.module			= THIS_MODULE,
+	.name			= DRV_NAME,
+	.ioctl			= ata_scsi_ioctl,
+	.queuecommand		= ata_scsi_queuecmd,
+	.change_queue_depth	= ata_scsi_change_queue_depth,
+	.can_queue		= ATA_MAX_QUEUE,
+	.this_id		= ATA_SHT_THIS_ID,
+	.sg_tablesize		= LIBATA_MAX_PRD,
+	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
+	.emulated		= ATA_SHT_EMULATED,
+	.use_clustering		= ATA_SHT_USE_CLUSTERING,
+	.proc_name		= DRV_NAME,
+	.dma_boundary		= ATA_DMA_BOUNDARY,
+	.slave_configure	= nv_swncq_slave_config,
+	.slave_destroy		= ata_scsi_slave_destroy,
+	.bios_param		= ata_std_bios_param,
+};
+
 static const struct ata_port_operations nv_generic_ops = {
 	.tf_load		= ata_tf_load,
 	.tf_read		= ata_tf_read,
@@ -444,6 +544,35 @@ static const struct ata_port_operations nv_adma_ops = {
 	.host_stop		= nv_adma_host_stop,
 };
 
+static const struct ata_port_operations nv_swncq_ops = {
+	.tf_load		= ata_tf_load,
+	.tf_read		= ata_tf_read,
+	.exec_command		= ata_exec_command,
+	.check_status		= ata_check_status,
+	.dev_select		= ata_std_dev_select,
+	.bmdma_setup		= ata_bmdma_setup,
+	.bmdma_start		= ata_bmdma_start,
+	.bmdma_stop		= ata_bmdma_stop,
+	.bmdma_status		= ata_bmdma_status,
+	.qc_defer		= ata_std_qc_defer,
+	.qc_prep		= nv_swncq_qc_prep,
+	.qc_issue		= nv_swncq_qc_issue,
+	.freeze			= nv_mcp55_freeze,
+	.thaw			= nv_mcp55_thaw,
+	.error_handler		= nv_swncq_error_handler,
+	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+	.data_xfer		= ata_data_xfer,
+	.irq_clear		= ata_bmdma_irq_clear,
+	.irq_on			= ata_irq_on,
+	.scr_read		= nv_scr_read,
+	.scr_write		= nv_scr_write,
+#ifdef CONFIG_PM
+	.port_suspend		= nv_swncq_port_suspend,
+	.port_resume		= nv_swncq_port_resume,
+#endif
+	.port_start		= nv_swncq_port_start,
+};
+
 static const struct ata_port_info nv_port_info[] = {
 	/* generic */
 	{
@@ -490,6 +619,18 @@ static const struct ata_port_info nv_port_info[] = {
 		.port_ops	= &nv_adma_ops,
 		.irq_handler	= nv_adma_interrupt,
 	},
+	/* SWNCQ */
+	{
+		.sht		= &nv_swncq_sht,
+		.flags	        = ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
+				  ATA_FLAG_NCQ,
+		.link_flags	= ATA_LFLAG_HRST_TO_RESUME,
+		.pio_mask	= NV_PIO_MASK,
+		.mwdma_mask	= NV_MWDMA_MASK,
+		.udma_mask	= NV_UDMA_MASK,
+		.port_ops	= &nv_swncq_ops,
+		.irq_handler	= nv_swncq_interrupt,
+	},
 };
 
 MODULE_AUTHOR("NVIDIA");
@@ -499,6 +640,7 @@ MODULE_DEVICE_TABLE(pci, nv_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
 
 static int adma_enabled = 1;
+static int swncq_enabled;
 
 static void nv_adma_register_mode(struct ata_port *ap)
 {
@@ -1452,6 +1594,34 @@ static void nv_ck804_thaw(struct ata_port *ap)
 	writeb(mask, mmio_base + NV_INT_ENABLE_CK804);
 }
 
+static void nv_mcp55_freeze(struct ata_port *ap)
+{
+	void __iomem *mmio_base = ap->host->iomap[NV_MMIO_BAR];
+	int shift = ap->port_no * NV_INT_PORT_SHIFT_MCP55;
+	u32 mask;
+
+	writel(NV_INT_ALL_MCP55 << shift, mmio_base + NV_INT_STATUS_MCP55);
+
+	mask = readl(mmio_base + NV_INT_ENABLE_MCP55);
+	mask &= ~(NV_INT_ALL_MCP55 << shift);
+	writel(mask, mmio_base + NV_INT_ENABLE_MCP55);
+	ata_bmdma_freeze(ap);
+}
+
+static void nv_mcp55_thaw(struct ata_port *ap)
+{
+	void __iomem *mmio_base = ap->host->iomap[NV_MMIO_BAR];
+	int shift = ap->port_no * NV_INT_PORT_SHIFT_MCP55;
+	u32 mask;
+
+	writel(NV_INT_ALL_MCP55 << shift, mmio_base + NV_INT_STATUS_MCP55);
+
+	mask = readl(mmio_base + NV_INT_ENABLE_MCP55);
+	mask |= (NV_INT_MASK_MCP55 << shift);
+	writel(mask, mmio_base + NV_INT_ENABLE_MCP55);
+	ata_bmdma_thaw(ap);
+}
+
 static int nv_hardreset(struct ata_link *link, unsigned int *class,
 			unsigned long deadline)
 {
@@ -1525,6 +1695,663 @@ static void nv_adma_error_handler(struct ata_port *ap)
 			   nv_hardreset, ata_std_postreset);
 }
 
+static void nv_swncq_qc_to_dq(struct ata_port *ap, struct ata_queued_cmd *qc)
+{
+	struct nv_swncq_port_priv *pp = ap->private_data;
+	struct defer_queue *dq = &pp->defer_queue;
+
+	/* queue is full */
+	WARN_ON(dq->tail - dq->head == ATA_MAX_QUEUE);
+	dq->defer_bits |= (1 << qc->tag);
+	dq->tag[dq->tail++ & (ATA_MAX_QUEUE - 1)] = qc->tag;
+}
+
+static struct ata_queued_cmd *nv_swncq_qc_from_dq(struct ata_port *ap)
+{
+	struct nv_swncq_port_priv *pp = ap->private_data;
+	struct defer_queue *dq = &pp->defer_queue;
+	unsigned int tag;
+
+	if (dq->head == dq->tail)	/* null queue */
+		return NULL;
+
+	tag = dq->tag[dq->head & (ATA_MAX_QUEUE - 1)];
+	dq->tag[dq->head++ & (ATA_MAX_QUEUE - 1)] = ATA_TAG_POISON;
+	WARN_ON(!(dq->defer_bits & (1 << tag)));
+	dq->defer_bits &= ~(1 << tag);
+
+	return ata_qc_from_tag(ap, tag);
+}
+
+static void nv_swncq_fis_reinit(struct ata_port *ap)
+{
+	struct nv_swncq_port_priv *pp = ap->private_data;
+
+	pp->dhfis_bits = 0;
+	pp->dmafis_bits = 0;
+	pp->sdbfis_bits = 0;
+	pp->ncq_flags = 0;
+}
+
+static void nv_swncq_pp_reinit(struct ata_port *ap)
+{
+	struct nv_swncq_port_priv *pp = ap->private_data;
+	struct defer_queue *dq = &pp->defer_queue;
+
+	dq->head = 0;
+	dq->tail = 0;
+	dq->defer_bits = 0;
+	pp->qc_active = 0;
+	pp->last_issue_tag = ATA_TAG_POISON;
+	nv_swncq_fis_reinit(ap);
+}
+
+static void nv_swncq_irq_clear(struct ata_port *ap, u16 fis)
+{
+	struct nv_swncq_port_priv *pp = ap->private_data;
+
+	writew(fis, pp->irq_block);
+}
+
+static void __ata_bmdma_stop(struct ata_port *ap)
+{
+	struct ata_queued_cmd qc;
+
+	qc.ap = ap;
+	ata_bmdma_stop(&qc);
+}
+
+static void nv_swncq_ncq_stop(struct ata_port *ap)
+{
+	struct nv_swncq_port_priv *pp = ap->private_data;
+	unsigned int i;
+	u32 sactive;
+	u32 done_mask;
+
+	ata_port_printk(ap, KERN_ERR,
+			"EH in SWNCQ mode,QC:qc_active 0x%X sactive 0x%X\n",
+			ap->qc_active, ap->link.sactive);
+	ata_port_printk(ap, KERN_ERR,
+		"SWNCQ:qc_active 0x%X defer_bits 0x%X last_issue_tag 0x%x\n  "
+		"dhfis 0x%X dmafis 0x%X sdbfis 0x%X\n",
+		pp->qc_active, pp->defer_queue.defer_bits, pp->last_issue_tag,
+		pp->dhfis_bits, pp->dmafis_bits, pp->sdbfis_bits);
+
+	ata_port_printk(ap, KERN_ERR, "ATA_REG 0x%X ERR_REG 0x%X\n",
+			ap->ops->check_status(ap),
+			ioread8(ap->ioaddr.error_addr));
+
+	sactive = readl(pp->sactive_block);
+	done_mask = pp->qc_active ^ sactive;
+
+	ata_port_printk(ap, KERN_ERR, "tag : dhfis dmafis sdbfis sacitve\n");
+	for (i = 0; i < ATA_MAX_QUEUE; i++) {
+		u8 err = 0;
+		if (pp->qc_active & (1 << i))
+			err = 0;
+		else if (done_mask & (1 << i))
+			err = 1;
+		else
+			continue;
+
+		ata_port_printk(ap, KERN_ERR,
+				"tag 0x%x: %01x %01x %01x %01x %s\n", i,
+				(pp->dhfis_bits >> i) & 0x1,
+				(pp->dmafis_bits >> i) & 0x1,
+				(pp->sdbfis_bits >> i) & 0x1,
+				(sactive >> i) & 0x1,
+				(err ? "error! tag doesn't exit" : " "));
+	}
+
+	nv_swncq_pp_reinit(ap);
+	ap->ops->irq_clear(ap);
+	__ata_bmdma_stop(ap);
+	nv_swncq_irq_clear(ap, 0xffff);
+}
+
+static void nv_swncq_error_handler(struct ata_port *ap)
+{
+	struct ata_eh_context *ehc = &ap->link.eh_context;
+
+	if (ap->link.sactive) {
+		nv_swncq_ncq_stop(ap);
+		ehc->i.action |= ATA_EH_HARDRESET;
+	}
+
+	ata_bmdma_drive_eh(ap, ata_std_prereset, ata_std_softreset,
+			   nv_hardreset, ata_std_postreset);
+}
+
+#ifdef CONFIG_PM
+static int nv_swncq_port_suspend(struct ata_port *ap, pm_message_t mesg)
+{
+	void __iomem *mmio = ap->host->iomap[NV_MMIO_BAR];
+	u32 tmp;
+
+	/* clear irq */
+	writel(~0, mmio + NV_INT_STATUS_MCP55);
+
+	/* disable irq */
+	writel(0, mmio + NV_INT_ENABLE_MCP55);
+
+	/* disable swncq */
+	tmp = readl(mmio + NV_CTL_MCP55);
+	tmp &= ~(NV_CTL_PRI_SWNCQ | NV_CTL_SEC_SWNCQ);
+	writel(tmp, mmio + NV_CTL_MCP55);
+
+	return 0;
+}
+
+static int nv_swncq_port_resume(struct ata_port *ap)
+{
+	void __iomem *mmio = ap->host->iomap[NV_MMIO_BAR];
+	u32 tmp;
+
+	/* clear irq */
+	writel(~0, mmio + NV_INT_STATUS_MCP55);
+
+	/* enable irq */
+	writel(0x00fd00fd, mmio + NV_INT_ENABLE_MCP55);
+
+	/* enable swncq */
+	tmp = readl(mmio + NV_CTL_MCP55);
+	writel(tmp | NV_CTL_PRI_SWNCQ | NV_CTL_SEC_SWNCQ, mmio + NV_CTL_MCP55);
+
+	return 0;
+}
+#endif
+
+static void nv_swncq_host_init(struct ata_host *host)
+{
+	u32 tmp;
+	void __iomem *mmio = host->iomap[NV_MMIO_BAR];
+	struct pci_dev *pdev = to_pci_dev(host->dev);
+	u8 regval;
+
+	/* disable  ECO 398 */
+	pci_read_config_byte(pdev, 0x7f, &regval);
+	regval &= ~(1 << 7);
+	pci_write_config_byte(pdev, 0x7f, regval);
+
+	/* enable swncq */
+	tmp = readl(mmio + NV_CTL_MCP55);
+	VPRINTK("HOST_CTL:0x%X\n", tmp);
+	writel(tmp | NV_CTL_PRI_SWNCQ | NV_CTL_SEC_SWNCQ, mmio + NV_CTL_MCP55);
+
+	/* enable irq intr */
+	tmp = readl(mmio + NV_INT_ENABLE_MCP55);
+	VPRINTK("HOST_ENABLE:0x%X\n", tmp);
+	writel(tmp | 0x00fd00fd, mmio + NV_INT_ENABLE_MCP55);
+
+	/*  clear port irq */
+	writel(~0x0, mmio + NV_INT_STATUS_MCP55);
+}
+
+static int nv_swncq_slave_config(struct scsi_device *sdev)
+{
+	struct ata_port *ap = ata_shost_to_port(sdev->host);
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	struct ata_device *dev;
+	int rc;
+	u8 rev;
+	u8 check_maxtor = 0;
+	unsigned char model_num[ATA_ID_PROD_LEN + 1];
+
+	rc = ata_scsi_slave_config(sdev);
+	if (sdev->id >= ATA_MAX_DEVICES || sdev->channel || sdev->lun)
+		/* Not a proper libata device, ignore */
+		return rc;
+
+	dev = &ap->link.device[sdev->id];
+	if (!(ap->flags & ATA_FLAG_NCQ) || dev->class == ATA_DEV_ATAPI)
+		return rc;
+
+	/* if MCP51 and Maxtor, then disable ncq */
+	if (pdev->device == PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA ||
+		pdev->device == PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA2)
+		check_maxtor = 1;
+
+	/* if MCP55 and rev <= a2 and Maxtor, then disable ncq */
+	if (pdev->device == PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA ||
+		pdev->device == PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA2) {
+		pci_read_config_byte(pdev, 0x8, &rev);
+		if (rev <= 0xa2)
+			check_maxtor = 1;
+	}
+
+	if (!check_maxtor)
+		return rc;
+
+	ata_id_c_string(dev->id, model_num, ATA_ID_PROD, sizeof(model_num));
+
+	if (strncmp(model_num, "Maxtor", 6) == 0) {
+		ata_scsi_change_queue_depth(sdev, 1);
+		ata_dev_printk(dev, KERN_NOTICE,
+			"Disabling SWNCQ mode (depth %x)\n", sdev->queue_depth);
+	}
+
+	return rc;
+}
+
+static int nv_swncq_port_start(struct ata_port *ap)
+{
+	struct device *dev = ap->host->dev;
+	void __iomem *mmio = ap->host->iomap[NV_MMIO_BAR];
+	struct nv_swncq_port_priv *pp;
+	int rc;
+
+	rc = ata_port_start(ap);
+	if (rc)
+		return rc;
+
+	pp = devm_kzalloc(dev, sizeof(*pp), GFP_KERNEL);
+	if (!pp)
+		return -ENOMEM;
+
+	pp->prd = dmam_alloc_coherent(dev, ATA_PRD_TBL_SZ * ATA_MAX_QUEUE,
+				      &pp->prd_dma, GFP_KERNEL);
+	if (!pp->prd)
+		return -ENOMEM;
+	memset(pp->prd, 0, ATA_PRD_TBL_SZ * ATA_MAX_QUEUE);
+
+	ap->private_data = pp;
+	pp->sactive_block = ap->ioaddr.scr_addr + 4 * SCR_ACTIVE;
+	pp->irq_block = mmio + NV_INT_STATUS_MCP55 + ap->port_no * 2;
+	pp->tag_block = mmio + NV_NCQ_REG_MCP55 + ap->port_no * 2;
+
+	return 0;
+}
+
+static void nv_swncq_qc_prep(struct ata_queued_cmd *qc)
+{
+	if (qc->tf.protocol != ATA_PROT_NCQ) {
+		ata_qc_prep(qc);
+		return;
+	}
+
+	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
+		return;
+
+	nv_swncq_fill_sg(qc);
+}
+
+static void nv_swncq_fill_sg(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct scatterlist *sg;
+	unsigned int idx;
+	struct nv_swncq_port_priv *pp = ap->private_data;
+	struct ata_prd *prd;
+
+	WARN_ON(qc->__sg == NULL);
+	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
+
+	prd = pp->prd + ATA_MAX_PRD * qc->tag;
+
+	idx = 0;
+	ata_for_each_sg(sg, qc) {
+		u32 addr, offset;
+		u32 sg_len, len;
+
+		addr = (u32)sg_dma_address(sg);
+		sg_len = sg_dma_len(sg);
+
+		while (sg_len) {
+			offset = addr & 0xffff;
+			len = sg_len;
+			if ((offset + sg_len) > 0x10000)
+				len = 0x10000 - offset;
+
+			prd[idx].addr = cpu_to_le32(addr);
+			prd[idx].flags_len = cpu_to_le32(len & 0xffff);
+
+			idx++;
+			sg_len -= len;
+			addr += len;
+		}
+	}
+
+	if (idx)
+		prd[idx - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
+}
+
+static unsigned int nv_swncq_issue_atacmd(struct ata_port *ap,
+					  struct ata_queued_cmd *qc)
+{
+	struct nv_swncq_port_priv *pp = ap->private_data;
+
+	if (qc == NULL)
+		return 0;
+
+	DPRINTK("Enter\n");
+
+	writel((1 << qc->tag), pp->sactive_block);
+	pp->last_issue_tag = qc->tag;
+	pp->dhfis_bits &= ~(1 << qc->tag);
+	pp->dmafis_bits &= ~(1 << qc->tag);
+	pp->qc_active |= (0x1 << qc->tag);
+
+	ap->ops->tf_load(ap, &qc->tf);	 /* load tf registers */
+	ap->ops->exec_command(ap, &qc->tf);
+
+	DPRINTK("Issued tag %u\n", qc->tag);
+
+	return 0;
+}
+
+static unsigned int nv_swncq_qc_issue(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct nv_swncq_port_priv *pp = ap->private_data;
+
+	if (qc->tf.protocol != ATA_PROT_NCQ)
+		return ata_qc_issue_prot(qc);
+
+	DPRINTK("Enter\n");
+
+	if (!pp->qc_active)
+		nv_swncq_issue_atacmd(ap, qc);
+	else
+		nv_swncq_qc_to_dq(ap, qc);	/* add qc to defer queue */
+
+	return 0;
+}
+
+static void nv_swncq_hotplug(struct ata_port *ap, u32 fis)
+{
+	u32 serror;
+	struct ata_eh_info *ehi = &ap->link.eh_info;
+
+	ata_ehi_clear_desc(ehi);
+
+	/* AHCI needs SError cleared; otherwise, it might lock up */
+	sata_scr_read(&ap->link, SCR_ERROR, &serror);
+	sata_scr_write(&ap->link, SCR_ERROR, serror);
+
+	/* analyze @irq_stat */
+	if (fis & NV_SWNCQ_IRQ_ADDED)
+		ata_ehi_push_desc(ehi, "hot plug");
+	else if (fis & NV_SWNCQ_IRQ_REMOVED)
+		ata_ehi_push_desc(ehi, "hot unplug");
+
+	ata_ehi_hotplugged(ehi);
+
+	/* okay, let's hand over to EH */
+	ehi->serror |= serror;
+
+	ata_port_freeze(ap);
+}
+
+static int nv_swncq_sdbfis(struct ata_port *ap)
+{
+	struct ata_queued_cmd *qc;
+	struct nv_swncq_port_priv *pp = ap->private_data;
+	struct ata_eh_info *ehi = &ap->link.eh_info;
+	u32 sactive;
+	int nr_done = 0;
+	u32 done_mask;
+	int i;
+	u8 host_stat;
+	u8 lack_dhfis = 0;
+
+	host_stat = ap->ops->bmdma_status(ap);
+	if (unlikely(host_stat & ATA_DMA_ERR)) {
+		/* error when transfering data to/from memory */
+		ata_ehi_clear_desc(ehi);
+		ata_ehi_push_desc(ehi, "BMDMA stat 0x%x", host_stat);
+		ehi->err_mask |= AC_ERR_HOST_BUS;
+		ehi->action |= ATA_EH_SOFTRESET;
+		return -EINVAL;
+	}
+
+	ap->ops->irq_clear(ap);
+	__ata_bmdma_stop(ap);
+
+	sactive = readl(pp->sactive_block);
+	done_mask = pp->qc_active ^ sactive;
+
+	if (unlikely(done_mask & sactive)) {
+		ata_ehi_clear_desc(ehi);
+		ata_ehi_push_desc(ehi, "illegal SWNCQ:qc_active transition"
+				  "(%08x->%08x)", pp->qc_active, sactive);
+		ehi->err_mask |= AC_ERR_HSM;
+		ehi->action |= ATA_EH_HARDRESET;
+		return -EINVAL;
+	}
+	for (i = 0; i < ATA_MAX_QUEUE; i++) {
+		if (!(done_mask & (1 << i)))
+			continue;
+
+		qc = ata_qc_from_tag(ap, i);
+		if (qc) {
+			ata_qc_complete(qc);
+			pp->qc_active &= ~(1 << i);
+			pp->dhfis_bits &= ~(1 << i);
+			pp->dmafis_bits &= ~(1 << i);
+			pp->sdbfis_bits |= (1 << i);
+			nr_done++;
+		}
+	}
+
+	if (!ap->qc_active) {
+		DPRINTK("over\n");
+		nv_swncq_pp_reinit(ap);
+		return nr_done;
+	}
+
+	if (pp->qc_active & pp->dhfis_bits)
+		return nr_done;
+
+	if ((pp->ncq_flags & ncq_saw_backout) ||
+	    (pp->qc_active ^ pp->dhfis_bits))
+		/* if the controller cann't get a device to host register FIS,
+		 * The driver needs to reissue the new command.
+		 */
+		lack_dhfis = 1;
+
+	DPRINTK("id 0x%x QC: qc_active 0x%x,"
+		"SWNCQ:qc_active 0x%X defer_bits %X "
+		"dhfis 0x%X dmafis 0x%X last_issue_tag %x\n",
+		ap->print_id, ap->qc_active, pp->qc_active,
+		pp->defer_queue.defer_bits, pp->dhfis_bits,
+		pp->dmafis_bits, pp->last_issue_tag);
+
+	nv_swncq_fis_reinit(ap);
+
+	if (lack_dhfis) {
+		qc = ata_qc_from_tag(ap, pp->last_issue_tag);
+		nv_swncq_issue_atacmd(ap, qc);
+		return nr_done;
+	}
+
+	if (pp->defer_queue.defer_bits) {
+		/* send deferral queue command */
+		qc = nv_swncq_qc_from_dq(ap);
+		WARN_ON(qc == NULL);
+		nv_swncq_issue_atacmd(ap, qc);
+	}
+
+	return nr_done;
+}
+
+static inline u32 nv_swncq_tag(struct ata_port *ap)
+{
+	struct nv_swncq_port_priv *pp = ap->private_data;
+	u32 tag;
+
+	tag = readb(pp->tag_block) >> 2;
+	return (tag & 0x1f);
+}
+
+static int nv_swncq_dmafis(struct ata_port *ap)
+{
+	struct ata_queued_cmd *qc;
+	unsigned int rw;
+	u8 dmactl;
+	u32 tag;
+	struct nv_swncq_port_priv *pp = ap->private_data;
+
+	__ata_bmdma_stop(ap);
+	tag = nv_swncq_tag(ap);
+
+	DPRINTK("dma setup tag 0x%x\n", tag);
+	qc = ata_qc_from_tag(ap, tag);
+
+	if (unlikely(!qc))
+		return 0;
+
+	rw = qc->tf.flags & ATA_TFLAG_WRITE;
+
+	/* load PRD table addr. */
+	iowrite32(pp->prd_dma + ATA_PRD_TBL_SZ * qc->tag,
+		  ap->ioaddr.bmdma_addr + ATA_DMA_TABLE_OFS);
+
+	/* specify data direction, triple-check start bit is clear */
+	dmactl = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
+	dmactl &= ~ATA_DMA_WR;
+	if (!rw)
+		dmactl |= ATA_DMA_WR;
+
+	iowrite8(dmactl | ATA_DMA_START, ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
+
+	return 1;
+}
+
+static void nv_swncq_host_interrupt(struct ata_port *ap, u16 fis)
+{
+	struct nv_swncq_port_priv *pp = ap->private_data;
+	struct ata_queued_cmd *qc;
+	struct ata_eh_info *ehi = &ap->link.eh_info;
+	u32 serror;
+	u8 ata_stat;
+	int rc = 0;
+
+	ata_stat = ap->ops->check_status(ap);
+	nv_swncq_irq_clear(ap, fis);
+	if (!fis)
+		return;
+
+	if (ap->pflags & ATA_PFLAG_FROZEN)
+		return;
+
+	if (fis & NV_SWNCQ_IRQ_HOTPLUG) {
+		nv_swncq_hotplug(ap, fis);
+		return;
+	}
+
+	if (!pp->qc_active)
+		return;
+
+	if (ap->ops->scr_read(ap, SCR_ERROR, &serror))
+		return;
+	ap->ops->scr_write(ap, SCR_ERROR, serror);
+
+	if (ata_stat & ATA_ERR) {
+		ata_ehi_clear_desc(ehi);
+		ata_ehi_push_desc(ehi, "Ata error. fis:0x%X", fis);
+		ehi->err_mask |= AC_ERR_DEV;
+		ehi->serror |= serror;
+		ehi->action |= ATA_EH_SOFTRESET;
+		ata_port_freeze(ap);
+		return;
+	}
+
+	if (fis & NV_SWNCQ_IRQ_BACKOUT) {
+		/* If the IRQ is backout, driver must issue
+		 * the new command again some time later.
+		 */
+		pp->ncq_flags |= ncq_saw_backout;
+	}
+
+	if (fis & NV_SWNCQ_IRQ_SDBFIS) {
+		pp->ncq_flags |= ncq_saw_sdb;
+		DPRINTK("id 0x%x SWNCQ: qc_active 0x%X "
+			"dhfis 0x%X dmafis 0x%X sactive 0x%X\n",
+			ap->print_id, pp->qc_active, pp->dhfis_bits,
+			pp->dmafis_bits, readl(pp->sactive_block));
+		rc = nv_swncq_sdbfis(ap);
+		if (rc < 0)
+			goto irq_error;
+	}
+
+	if (fis & NV_SWNCQ_IRQ_DHREGFIS) {
+		/* The interrupt indicates the new command
+		 * was transmitted correctly to the drive.
+		 */
+		pp->dhfis_bits |= (0x1 << pp->last_issue_tag);
+		pp->ncq_flags |= ncq_saw_d2h;
+		if (pp->ncq_flags & (ncq_saw_sdb | ncq_saw_backout)) {
+			ata_ehi_push_desc(ehi, "illegal fis transaction");
+			ehi->err_mask |= AC_ERR_HSM;
+			ehi->action |= ATA_EH_HARDRESET;
+			goto irq_error;
+		}
+
+		if (!(fis & NV_SWNCQ_IRQ_DMASETUP) &&
+		    !(pp->ncq_flags & ncq_saw_dmas)) {
+			ata_stat = ap->ops->check_status(ap);
+			if (ata_stat & ATA_BUSY)
+				goto irq_exit;
+
+			if (pp->defer_queue.defer_bits) {
+				DPRINTK("send next command\n");
+				qc = nv_swncq_qc_from_dq(ap);
+				nv_swncq_issue_atacmd(ap, qc);
+			}
+		}
+	}
+
+	if (fis & NV_SWNCQ_IRQ_DMASETUP) {
+		/* program the dma controller with appropriate PRD buffers
+		 * and start the DMA transfer for requested command.
+		 */
+		pp->dmafis_bits |= (0x1 << nv_swncq_tag(ap));
+		pp->ncq_flags |= ncq_saw_dmas;
+		rc = nv_swncq_dmafis(ap);
+	}
+
+irq_exit:
+	return;
+irq_error:
+	ata_ehi_push_desc(ehi, "fis:0x%x", fis);
+	ata_port_freeze(ap);
+	return;
+}
+
+static irqreturn_t nv_swncq_interrupt(int irq, void *dev_instance)
+{
+	struct ata_host *host = dev_instance;
+	unsigned int i;
+	unsigned int handled = 0;
+	unsigned long flags;
+	u32 irq_stat;
+
+	spin_lock_irqsave(&host->lock, flags);
+
+	irq_stat = readl(host->iomap[NV_MMIO_BAR] + NV_INT_STATUS_MCP55);
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		if (ap && !(ap->flags & ATA_FLAG_DISABLED)) {
+			if (ap->link.sactive) {
+				nv_swncq_host_interrupt(ap, (u16)irq_stat);
+				handled = 1;
+			} else {
+				if (irq_stat)	/* reserve Hotplug */
+					nv_swncq_irq_clear(ap, 0xfff0);
+
+				handled += nv_host_intr(ap, (u8)irq_stat);
+			}
+		}
+		irq_stat >>= NV_INT_PORT_SHIFT_MCP55;
+	}
+
+	spin_unlock_irqrestore(&host->lock, flags);
+
+	return IRQ_RETVAL(handled);
+}
+
 static int nv_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version = 0;
@@ -1551,7 +2378,7 @@ static int nv_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 		return rc;
 
 	/* determine type and allocate host */
-	if (type >= CK804 && adma_enabled) {
+	if (type == CK804 && adma_enabled) {
 		dev_printk(KERN_NOTICE, &pdev->dev, "Using ADMA mode\n");
 		type = ADMA;
 	}
@@ -1597,6 +2424,9 @@ static int nv_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 		rc = nv_adma_host_init(host);
 		if (rc)
 			return rc;
+	} else if (type == SWNCQ && swncq_enabled) {
+		dev_printk(KERN_NOTICE, &pdev->dev, "Using SWNCQ mode\n");
+		nv_swncq_host_init(host);
 	}
 
 	pci_set_master(pdev);
@@ -1696,3 +2526,6 @@ module_init(nv_init);
 module_exit(nv_exit);
 module_param_named(adma, adma_enabled, bool, 0444);
 MODULE_PARM_DESC(adma, "Enable use of ADMA (Default: true)");
+module_param_named(swncq, swncq_enabled, bool, 0444);
+MODULE_PARM_DESC(swncq, "Enable use of SWNCQ (Default: false)");
+
