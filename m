Return-Path: <linux-kernel-owner+w=401wt.eu-S1757914AbYCKBYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914AbYCKBYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 21:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbYCKBXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 21:23:30 -0400
Received: from havoc.gtf.org ([69.61.125.42]:43860 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728AbYCKBX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 21:23:27 -0400
Date: Mon, 10 Mar 2008 21:23:26 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20080311012325.GA26084@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Adds a new driver for RB500 CF.

Still chasing one cd reading/burning bug.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/Kconfig         |    9 ++
 drivers/ata/Makefile        |    1 +
 drivers/ata/ahci.c          |   14 ++-
 drivers/ata/libata-acpi.c   |    8 +-
 drivers/ata/libata-core.c   |   17 ++-
 drivers/ata/libata-eh.c     |   10 ++
 drivers/ata/libata-sff.c    |   36 +++--
 drivers/ata/pata_pdc2027x.c |    2 +-
 drivers/ata/pata_rb500_cf.c |  314 +++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 383 insertions(+), 28 deletions(-)
 create mode 100644 drivers/ata/pata_rb500_cf.c

Florian Fainelli (1):
      [libata] Add support for the RB500 PATA CompactFlash

Harvey Harrison (1):
      ata: replace remaining __FUNCTION__ occurrences

Roel Kluin (1):
      ahci: logical-bitwise and confusion in ahci_save_initial_config()

Tejun Heo (3):
      libata: allow LLDs w/o any reset method
      libata-sff: handle controllers w/o ctl register
      libata: don't allow sysfs read access to force param

peerchen (1):
      ahci: add the Device IDs for nvidia MCP7B AHCI

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index ba8f7f4..e469647 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -538,6 +538,15 @@ config PATA_RADISYS
 
 	  If unsure, say N.
 
+config PATA_RB500
+	tristate "RouterBoard 500 PATA CompactFlash support"
+	depends on MIKROTIK_RB500
+	help
+	  This option enables support for the RouterBoard 500
+	  PATA CompactFlash controller.
+
+	  If unsure, say N.
+
 config PATA_RZ1000
 	tristate "PC Tech RZ1000 PATA support"
 	depends on PCI
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 701651e..0511e6f 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -55,6 +55,7 @@ obj-$(CONFIG_PATA_PDC2027X)	+= pata_pdc2027x.o
 obj-$(CONFIG_PATA_PDC_OLD)	+= pata_pdc202xx_old.o
 obj-$(CONFIG_PATA_QDI)		+= pata_qdi.o
 obj-$(CONFIG_PATA_RADISYS)	+= pata_radisys.o
+obj-$(CONFIG_PATA_RB500)	+= pata_rb500_cf.o
 obj-$(CONFIG_PATA_RZ1000)	+= pata_rz1000.o
 obj-$(CONFIG_PATA_SC1200)	+= pata_sc1200.o
 obj-$(CONFIG_PATA_SERVERWORKS)	+= pata_serverworks.o
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 8a49835..6978469 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -567,6 +567,18 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(NVIDIA, 0x0abd), board_ahci },		/* MCP79 */
 	{ PCI_VDEVICE(NVIDIA, 0x0abe), board_ahci },		/* MCP79 */
 	{ PCI_VDEVICE(NVIDIA, 0x0abf), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0bc8), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bc9), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bca), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bcb), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bcc), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bcd), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bce), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bcf), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bd0), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bd1), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bd2), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bd3), board_ahci },		/* MCP7B */
 
 	/* SiS */
 	{ PCI_VDEVICE(SI, 0x1184), board_ahci }, /* SiS 966 */
@@ -672,7 +684,7 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
 		cap &= ~HOST_CAP_NCQ;
 	}
 
-	if ((cap && HOST_CAP_PMP) && (hpriv->flags & AHCI_HFLAG_NO_PMP)) {
+	if ((cap & HOST_CAP_PMP) && (hpriv->flags & AHCI_HFLAG_NO_PMP)) {
 		dev_printk(KERN_INFO, &pdev->dev,
 			   "controller can't do PMP, turning off CAP_PMP\n");
 		cap &= ~HOST_CAP_PMP;
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 9e8ec19..0770cb7 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -382,7 +382,7 @@ static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf)
 
 	if (ata_msg_probe(ap))
 		ata_dev_printk(dev, KERN_DEBUG, "%s: ENTER: port#: %d\n",
-			       __FUNCTION__, ap->port_no);
+			       __func__, ap->port_no);
 
 	/* _GTF has no input parameters */
 	status = acpi_evaluate_object(dev->acpi_handle, "_GTF", NULL, &output);
@@ -402,7 +402,7 @@ static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf)
 		if (ata_msg_probe(ap))
 			ata_dev_printk(dev, KERN_DEBUG, "%s: Run _GTF: "
 				"length or ptr is NULL (0x%llx, 0x%p)\n",
-				__FUNCTION__,
+				__func__,
 				(unsigned long long)output.length,
 				output.pointer);
 		rc = -EINVAL;
@@ -432,7 +432,7 @@ static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf)
 		if (ata_msg_probe(ap))
 			ata_dev_printk(dev, KERN_DEBUG,
 				       "%s: returning gtf=%p, gtf_count=%d\n",
-				       __FUNCTION__, *gtf, rc);
+				       __func__, *gtf, rc);
 	}
 	return rc;
 
@@ -725,7 +725,7 @@ static int ata_acpi_push_id(struct ata_device *dev)
 
 	if (ata_msg_probe(ap))
 		ata_dev_printk(dev, KERN_DEBUG, "%s: ix = %d, port#: %d\n",
-			       __FUNCTION__, dev->devno, ap->port_no);
+			       __func__, dev->devno, ap->port_no);
 
 	/* Give the drive Identify data to the drive via the _SDD method */
 	/* _SDD: set up input parameters */
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4fbcce7..4bbe31f 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -106,7 +106,8 @@ static struct ata_force_ent *ata_force_tbl;
 static int ata_force_tbl_size;
 
 static char ata_force_param_buf[PAGE_SIZE] __initdata;
-module_param_string(force, ata_force_param_buf, sizeof(ata_force_param_buf), 0444);
+/* param_buf is thrown away after initialization, disallow read */
+module_param_string(force, ata_force_param_buf, sizeof(ata_force_param_buf), 0);
 MODULE_PARM_DESC(force, "Force ATA configurations including cable type, link speed and transfer mode (see Documentation/kernel-parameters.txt for details)");
 
 int atapi_enabled = 1;
@@ -1719,7 +1720,7 @@ void ata_port_flush_task(struct ata_port *ap)
 	cancel_rearming_delayed_work(&ap->port_task);
 
 	if (ata_msg_ctl(ap))
-		ata_port_printk(ap, KERN_DEBUG, "%s: EXIT\n", __FUNCTION__);
+		ata_port_printk(ap, KERN_DEBUG, "%s: EXIT\n", __func__);
 }
 
 static void ata_qc_complete_internal(struct ata_queued_cmd *qc)
@@ -2056,7 +2057,7 @@ int ata_dev_read_id(struct ata_device *dev, unsigned int *p_class,
 	int rc;
 
 	if (ata_msg_ctl(ap))
-		ata_dev_printk(dev, KERN_DEBUG, "%s: ENTER\n", __FUNCTION__);
+		ata_dev_printk(dev, KERN_DEBUG, "%s: ENTER\n", __func__);
 
 	ata_dev_select(ap, dev->devno, 1, 1); /* select device 0/1 */
  retry:
@@ -2253,12 +2254,12 @@ int ata_dev_configure(struct ata_device *dev)
 
 	if (!ata_dev_enabled(dev) && ata_msg_info(ap)) {
 		ata_dev_printk(dev, KERN_INFO, "%s: ENTER/EXIT -- nodev\n",
-			       __FUNCTION__);
+			       __func__);
 		return 0;
 	}
 
 	if (ata_msg_probe(ap))
-		ata_dev_printk(dev, KERN_DEBUG, "%s: ENTER\n", __FUNCTION__);
+		ata_dev_printk(dev, KERN_DEBUG, "%s: ENTER\n", __func__);
 
 	/* set horkage */
 	dev->horkage |= ata_dev_blacklisted(dev);
@@ -2279,7 +2280,7 @@ int ata_dev_configure(struct ata_device *dev)
 		ata_dev_printk(dev, KERN_DEBUG,
 			       "%s: cfg 49:%04x 82:%04x 83:%04x 84:%04x "
 			       "85:%04x 86:%04x 87:%04x 88:%04x\n",
-			       __FUNCTION__,
+			       __func__,
 			       id[49], id[82], id[83], id[84],
 			       id[85], id[86], id[87], id[88]);
 
@@ -2511,13 +2512,13 @@ int ata_dev_configure(struct ata_device *dev)
 
 	if (ata_msg_probe(ap))
 		ata_dev_printk(dev, KERN_DEBUG, "%s: EXIT, drv_stat = 0x%x\n",
-			__FUNCTION__, ata_chk_status(ap));
+			__func__, ata_chk_status(ap));
 	return 0;
 
 err_out_nosup:
 	if (ata_msg_probe(ap))
 		ata_dev_printk(dev, KERN_DEBUG,
-			       "%s: EXIT, err\n", __FUNCTION__);
+			       "%s: EXIT, err\n", __func__);
 	return rc;
 }
 
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 698ce2c..681252f 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2150,6 +2150,15 @@ int ata_eh_reset(struct ata_link *link, int classify,
 			ap->ops->set_piomode(ap, dev);
 	}
 
+	if (!softreset && !hardreset) {
+		if (verbose)
+			ata_link_printk(link, KERN_INFO, "no reset method "
+					"available, skipping reset\n");
+		if (!(lflags & ATA_LFLAG_ASSUME_CLASS))
+			lflags |= ATA_LFLAG_ASSUME_ATA;
+		goto done;
+	}
+
 	/* Determine which reset to use and record in ehc->i.action.
 	 * prereset() may examine and modify it.
 	 */
@@ -2254,6 +2263,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 		lflags |= ATA_LFLAG_ASSUME_ATA;
 	}
 
+ done:
 	ata_link_for_each_dev(dev, link) {
 		/* After the reset, the device state is PIO 0 and the
 		 * controller state is undefined.  Reset also wakes up
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 60cd4b1..20dc572 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -56,7 +56,8 @@ u8 ata_irq_on(struct ata_port *ap)
 	ap->ctl &= ~ATA_NIEN;
 	ap->last_ctl = ap->ctl;
 
-	iowrite8(ap->ctl, ioaddr->ctl_addr);
+	if (ioaddr->ctl_addr)
+		iowrite8(ap->ctl, ioaddr->ctl_addr);
 	tmp = ata_wait_idle(ap);
 
 	ap->ops->irq_clear(ap);
@@ -81,12 +82,14 @@ void ata_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
 	unsigned int is_addr = tf->flags & ATA_TFLAG_ISADDR;
 
 	if (tf->ctl != ap->last_ctl) {
-		iowrite8(tf->ctl, ioaddr->ctl_addr);
+		if (ioaddr->ctl_addr)
+			iowrite8(tf->ctl, ioaddr->ctl_addr);
 		ap->last_ctl = tf->ctl;
 		ata_wait_idle(ap);
 	}
 
 	if (is_addr && (tf->flags & ATA_TFLAG_LBA48)) {
+		WARN_ON(!ioaddr->ctl_addr);
 		iowrite8(tf->hob_feature, ioaddr->feature_addr);
 		iowrite8(tf->hob_nsect, ioaddr->nsect_addr);
 		iowrite8(tf->hob_lbal, ioaddr->lbal_addr);
@@ -167,14 +170,17 @@ void ata_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
 	tf->device = ioread8(ioaddr->device_addr);
 
 	if (tf->flags & ATA_TFLAG_LBA48) {
-		iowrite8(tf->ctl | ATA_HOB, ioaddr->ctl_addr);
-		tf->hob_feature = ioread8(ioaddr->error_addr);
-		tf->hob_nsect = ioread8(ioaddr->nsect_addr);
-		tf->hob_lbal = ioread8(ioaddr->lbal_addr);
-		tf->hob_lbam = ioread8(ioaddr->lbam_addr);
-		tf->hob_lbah = ioread8(ioaddr->lbah_addr);
-		iowrite8(tf->ctl, ioaddr->ctl_addr);
-		ap->last_ctl = tf->ctl;
+		if (likely(ioaddr->ctl_addr)) {
+			iowrite8(tf->ctl | ATA_HOB, ioaddr->ctl_addr);
+			tf->hob_feature = ioread8(ioaddr->error_addr);
+			tf->hob_nsect = ioread8(ioaddr->nsect_addr);
+			tf->hob_lbal = ioread8(ioaddr->lbal_addr);
+			tf->hob_lbam = ioread8(ioaddr->lbam_addr);
+			tf->hob_lbah = ioread8(ioaddr->lbah_addr);
+			iowrite8(tf->ctl, ioaddr->ctl_addr);
+			ap->last_ctl = tf->ctl;
+		} else
+			WARN_ON(1);
 	}
 }
 
@@ -352,7 +358,8 @@ void ata_bmdma_freeze(struct ata_port *ap)
 	ap->ctl |= ATA_NIEN;
 	ap->last_ctl = ap->ctl;
 
-	iowrite8(ap->ctl, ioaddr->ctl_addr);
+	if (ioaddr->ctl_addr)
+		iowrite8(ap->ctl, ioaddr->ctl_addr);
 
 	/* Under certain circumstances, some controllers raise IRQ on
 	 * ATA_NIEN manipulation.  Also, many controllers fail to mask
@@ -459,13 +466,14 @@ void ata_bmdma_drive_eh(struct ata_port *ap, ata_prereset_fn_t prereset,
  */
 void ata_bmdma_error_handler(struct ata_port *ap)
 {
-	ata_reset_fn_t hardreset;
+	ata_reset_fn_t softreset = NULL, hardreset = NULL;
 
-	hardreset = NULL;
+	if (ap->ioaddr.ctl_addr)
+		softreset = ata_std_softreset;
 	if (sata_scr_valid(&ap->link))
 		hardreset = sata_std_hardreset;
 
-	ata_bmdma_drive_eh(ap, ata_std_prereset, ata_std_softreset, hardreset,
+	ata_bmdma_drive_eh(ap, ata_std_prereset, softreset, hardreset,
 			   ata_std_postreset);
 }
 
diff --git a/drivers/ata/pata_pdc2027x.c b/drivers/ata/pata_pdc2027x.c
index 028af5d..511c89b 100644
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -39,7 +39,7 @@
 #undef PDC_DEBUG
 
 #ifdef PDC_DEBUG
-#define PDPRINTK(fmt, args...) printk(KERN_ERR "%s: " fmt, __FUNCTION__, ## args)
+#define PDPRINTK(fmt, args...) printk(KERN_ERR "%s: " fmt, __func__, ## args)
 #else
 #define PDPRINTK(fmt, args...)
 #endif
diff --git a/drivers/ata/pata_rb500_cf.c b/drivers/ata/pata_rb500_cf.c
new file mode 100644
index 0000000..4ce9b03
--- /dev/null
+++ b/drivers/ata/pata_rb500_cf.c
@@ -0,0 +1,314 @@
+/*
+ *  A low-level PATA driver to handle a Compact Flash connected on the
+ *  Mikrotik's RouterBoard 532 board.
+ *
+ *  Copyright (C) 2007 Gabor Juhos <juhosg at openwrt.org>
+ *  Copyright (C) 2008 Florian Fainelli <florian@openwrt.org>
+ *
+ *  This file was based on: drivers/ata/pata_ixp4xx_cf.c
+ *	Copyright (C) 2006-07 Tower Technologies
+ *	Author: Alessandro Zummo <a.zummo@towertech.it>
+ *
+ *  Also was based on the driver for Linux 2.4.xx published by Mikrotik for
+ *  their RouterBoard 1xx and 5xx series devices. The original Mikrotik code
+ *  seems not to have a license.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+
+#include <linux/libata.h>
+#include <scsi/scsi_host.h>
+
+#include <asm/gpio.h>
+
+#define DRV_NAME	"pata-rb500-cf"
+#define DRV_VERSION	"0.1.0"
+#define DRV_DESC	"PATA driver for RouterBOARD 532 Compact Flash"
+
+#define RB500_CF_MAXPORTS	1
+#define RB500_CF_IO_DELAY	400
+
+#define RB500_CF_REG_CMD	0x0800
+#define RB500_CF_REG_CTRL	0x080E
+#define RB500_CF_REG_DATA	0x0C00
+
+struct rb500_cf_info {
+	void __iomem	*iobase;
+	unsigned int	gpio_line;
+	int		frozen;
+	unsigned int	irq;
+};
+
+/* ------------------------------------------------------------------------ */
+
+static inline void rb500_pata_finish_io(struct ata_port *ap)
+{
+	struct ata_host *ah = ap->host;
+	struct rb500_cf_info *info = ah->private_data;
+
+	ata_altstatus(ap);
+	ndelay(RB500_CF_IO_DELAY);
+
+	set_irq_type(info->irq, IRQ_TYPE_LEVEL_HIGH);
+}
+
+static void rb500_pata_exec_command(struct ata_port *ap,
+				const struct ata_taskfile *tf)
+{
+	writeb(tf->command, ap->ioaddr.command_addr);
+	rb500_pata_finish_io(ap);
+}
+
+static void rb500_pata_data_xfer(struct ata_device *adev, unsigned char *buf,
+				unsigned int buflen, int write_data)
+{
+	struct ata_port *ap = adev->link->ap;
+	void __iomem *ioaddr = ap->ioaddr.data_addr;
+
+	if (write_data) {
+		for (; buflen > 0; buflen--, buf++)
+			writeb(*buf, ioaddr);
+	} else {
+		for (; buflen > 0; buflen--, buf++)
+			*buf = readb(ioaddr);
+	}
+
+	rb500_pata_finish_io(adev->link->ap);
+}
+
+static void rb500_pata_freeze(struct ata_port *ap)
+{
+	struct rb500_cf_info *info = ap->host->private_data;
+
+	info->frozen = 1;
+}
+
+static void rb500_pata_thaw(struct ata_port *ap)
+{
+	struct rb500_cf_info *info = ap->host->private_data;
+
+	info->frozen = 0;
+}
+
+static irqreturn_t rb500_pata_irq_handler(int irq, void *dev_instance)
+{
+	struct ata_host *ah = dev_instance;
+	struct rb500_cf_info *info = ah->private_data;
+
+	if (gpio_get_value(info->gpio_line)) {
+		set_irq_type(info->irq, IRQ_TYPE_LEVEL_LOW);
+		if (!info->frozen)
+			ata_interrupt(info->irq, dev_instance);
+	} else {
+		set_irq_type(info->irq, IRQ_TYPE_LEVEL_HIGH);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void rb500_pata_irq_clear(struct ata_port *ap)
+{
+}
+
+static int rb500_pata_port_start(struct ata_port *ap)
+{
+	return 0;
+}
+
+static struct ata_port_operations rb500_pata_port_ops = {
+	.tf_load		= ata_tf_load,
+	.tf_read		= ata_tf_read,
+
+	.exec_command		= rb500_pata_exec_command,
+	.check_status 		= ata_check_status,
+	.dev_select 		= ata_std_dev_select,
+
+	.data_xfer		= rb500_pata_data_xfer,
+
+	.qc_prep 		= ata_qc_prep,
+	.qc_issue		= ata_qc_issue_prot,
+
+	.freeze			= rb500_pata_freeze,
+	.thaw			= rb500_pata_thaw,
+	.error_handler		= ata_bmdma_error_handler,
+
+	.irq_handler		= rb500_pata_irq_handler,
+	.irq_clear		= rb500_pata_irq_clear,
+	.irq_on			= ata_irq_on,
+
+	.port_start		= rb500_pata_port_start,
+};
+
+/* ------------------------------------------------------------------------ */
+
+static struct scsi_host_template rb500_pata_sht = {
+	.module			= THIS_MODULE,
+	.name			= DRV_NAME,
+	.ioctl			= ata_scsi_ioctl,
+	.queuecommand		= ata_scsi_queuecmd,
+	.slave_configure	= ata_scsi_slave_config,
+	.slave_destroy		= ata_scsi_slave_destroy,
+	.bios_param		= ata_std_bios_param,
+	.proc_name		= DRV_NAME,
+
+	.can_queue		= ATA_DEF_QUEUE,
+	.this_id		= ATA_SHT_THIS_ID,
+	.sg_tablesize		= LIBATA_MAX_PRD,
+	.dma_boundary		= ATA_DMA_BOUNDARY,
+	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
+	.emulated		= ATA_SHT_EMULATED,
+	.use_clustering		= ATA_SHT_USE_CLUSTERING,
+};
+
+/* ------------------------------------------------------------------------ */
+
+static void rb500_pata_setup_ports(struct ata_host *ah)
+{
+	struct rb500_cf_info *info = ah->private_data;
+	struct ata_port *ap;
+
+	ap = ah->ports[0];
+
+	ap->ops		= &rb500_pata_port_ops;
+	ap->pio_mask	= 0x1f; /* PIO4 */
+	ap->flags	= ATA_FLAG_NO_LEGACY | ATA_FLAG_MMIO;
+
+	ap->ioaddr.cmd_addr	= info->iobase + RB500_CF_REG_CMD;
+	ap->ioaddr.ctl_addr	= info->iobase + RB500_CF_REG_CTRL;
+	ap->ioaddr.altstatus_addr = info->iobase + RB500_CF_REG_CTRL;
+
+	ata_std_ports(&ap->ioaddr);
+
+	ap->ioaddr.data_addr	= info->iobase + RB500_CF_REG_DATA;
+}
+
+static __devinit int rb500_pata_driver_probe(struct platform_device *pdev)
+{
+	unsigned int irq;
+	int gpio;
+	struct resource *res;
+	struct ata_host *ah;
+	struct rb500_cf_info *info;
+	int ret;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "no IOMEM resource found\n");
+		return -EINVAL;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq <= 0) {
+		dev_err(&pdev->dev, "no IRQ resource found\n");
+		return -ENOENT;
+	}
+
+	gpio = irq_to_gpio(irq);
+	if (gpio < 0) {
+		dev_err(&pdev->dev, "no GPIO found for irq%d\n", irq);
+		return -ENOENT;
+	}
+
+	ret = gpio_request(gpio, DRV_NAME);
+	if (ret) {
+		dev_err(&pdev->dev, "GPIO request failed\n");
+		return ret;
+	}
+
+	/* allocate host */
+	ah = ata_host_alloc(&pdev->dev, RB500_CF_MAXPORTS);
+	if (!ah)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, ah);
+
+	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	ah->private_data = info;
+	info->gpio_line = gpio;
+	info->irq = irq;
+
+	info->iobase = devm_ioremap_nocache(&pdev->dev, res->start,
+				res->end - res->start + 1);
+	if (!info->iobase)
+		return -ENOMEM;
+
+	ret = gpio_direction_input(gpio);
+	if (ret) {
+		dev_err(&pdev->dev, "unable to set GPIO direction, err=%d\n",
+				ret);
+		goto err_free_gpio;
+	}
+
+	rb500_pata_setup_ports(ah);
+
+	ret = ata_host_activate(ah, irq, rb500_pata_irq_handler,
+				IRQF_TRIGGER_LOW, &rb500_pata_sht);
+	if (ret)
+		goto err_free_gpio;
+
+	return 0;
+
+err_free_gpio:
+	gpio_free(gpio);
+
+	return ret;
+}
+
+static __devexit int rb500_pata_driver_remove(struct platform_device *pdev)
+{
+	struct ata_host *ah = platform_get_drvdata(pdev);
+	struct rb500_cf_info *info = ah->private_data;
+
+	ata_host_detach(ah);
+	gpio_free(info->gpio_line);
+
+	return 0;
+}
+
+static struct platform_driver rb500_pata_platform_driver = {
+	.probe		= rb500_pata_driver_probe,
+	.remove		= __devexit_p(rb500_pata_driver_remove),
+	.driver	 = {
+		.name   = DRV_NAME,
+		.owner  = THIS_MODULE,
+	},
+};
+
+/* ------------------------------------------------------------------------ */
+
+#define DRV_INFO DRV_DESC " version " DRV_VERSION
+
+static int __init rb500_pata_module_init(void)
+{
+	printk(KERN_INFO DRV_INFO "\n");
+
+	return platform_driver_register(&rb500_pata_platform_driver);
+}
+
+static void __exit rb500_pata_module_exit(void)
+{
+	platform_driver_unregister(&rb500_pata_platform_driver);
+}
+
+MODULE_AUTHOR("Gabor Juhos <juhosg at openwrt.org>");
+MODULE_AUTHOR("Florian Fainelli <florian@openwrt.org>");
+MODULE_DESCRIPTION(DRV_DESC);
+MODULE_VERSION(DRV_VERSION);
+MODULE_LICENSE("GPL");
+
+module_init(rb500_pata_module_init);
+module_exit(rb500_pata_module_exit);
