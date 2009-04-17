Return-Path: <linux-kernel-owner+w=401wt.eu-S1759287AbZDQCmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287AbZDQCmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 22:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757228AbZDQCmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 22:42:11 -0400
Received: from havoc.gtf.org ([69.61.125.42]:34723 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931AbZDQCmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 22:42:08 -0400
Date: Thu, 16 Apr 2009 22:42:06 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 3/3] acard-ahci: Add new ACard ATP AHCI driver
Message-ID: <20090417024206.GC15475@havoc.gtf.org>
References: <20090417023949.GA14469@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417023949.GA14469@havoc.gtf.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit d67b67d0b5ec6a9ccd79fbc4082e84337a59dbf4
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sun Apr 12 13:14:19 2009 -0400

    libata: Add new 'acard-ahci' driver for ACard ATP8620 chips
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 drivers/ata/Kconfig      |    9 +
 drivers/ata/Makefile     |    1 
 drivers/ata/acard-ahci.c |  350 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/ahci.c       |   94 ------------
 drivers/ata/ahci.h       |    3 
 drivers/ata/libahci.c    |   98 +++++++++++++
 6 files changed, 462 insertions(+), 93 deletions(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 2b697fe..088a2a8 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -55,6 +55,15 @@ config SATA_AHCI
 
 	  If unsure, say N.
 
+config SATA_ACARD_AHCI
+	tristate "ACard AHCI variant (ATP 8620)"
+	depends on PCI
+	help
+	  This option enables support for AHCI-like chips
+	  from ACard: 8620
+
+	  If unsure, say N.
+
 config SATA_SIL24
 	tristate "Silicon Image 3124/3132 SATA support"
 	depends on PCI
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 6055016..a36c53a 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -2,6 +2,7 @@
 obj-$(CONFIG_ATA)		+= libata.o
 
 obj-$(CONFIG_SATA_AHCI)		+= libahci.o ahci.o
+obj-$(CONFIG_SATA_ACARD_AHCI)	+= libahci.o acard-ahci.o
 obj-$(CONFIG_SATA_SVW)		+= sata_svw.o
 obj-$(CONFIG_ATA_PIIX)		+= ata_piix.o
 obj-$(CONFIG_SATA_PROMISE)	+= sata_promise.o
diff --git a/drivers/ata/acard-ahci.c b/drivers/ata/acard-ahci.c
new file mode 100644
index 0000000..0980ace
--- /dev/null
+++ b/drivers/ata/acard-ahci.c
@@ -0,0 +1,350 @@
+
+/*
+ *  acard-ahci.c - ACard AHCI SATA support
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
+ * http://gkernel.sourceforge.net/specs/acard/ATP8620pub_Rev0.98.pdf
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
+#define DRV_NAME	"acard-ahci"
+#define DRV_VERSION	"0.5"
+
+enum {
+	board_ahci_acard		= 0,
+};
+
+struct acard_sg {
+	__le32			addr;
+	__le32			addr_hi;
+	__le32			flags;		/* bit 31 == EOT */
+	__le32			size;		/* max==0x10000 (64k) */
+};
+
+static void acard_qc_prep(struct ata_queued_cmd *qc);
+
+static struct device_attribute *acard_ahci_shost_attrs[] = {
+	&dev_attr_link_power_management_policy,
+	&dev_attr_em_message_type,
+	&dev_attr_em_message,
+	NULL
+};
+
+static struct device_attribute *acard_ahci_sdev_attrs[] = {
+	&dev_attr_sw_activity,
+	&dev_attr_unload_heads,
+	NULL
+};
+
+static struct scsi_host_template acard_sht = {
+	ATA_NCQ_SHT(DRV_NAME),
+	.can_queue		= AHCI_MAX_CMDS - 1,
+	.sg_tablesize		= AHCI_MAX_SG,
+
+	/* we don't really care about the DMA boundary... we use this
+	 * to limit our DMA segment size to 64k
+	 */
+	.dma_boundary		= ATA_DMA_BOUNDARY,
+	.shost_attrs		= acard_ahci_shost_attrs,
+	.sdev_attrs		= acard_ahci_sdev_attrs,
+};
+
+static struct ata_port_operations acard_ops = {
+	.inherits		= &ahci_base_ops,
+	.qc_prep		= acard_qc_prep,
+};
+
+static const struct ata_port_info acard_ahci_port_info[] = {
+	[board_ahci_acard] =
+	{
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &acard_ops,
+	},
+};
+
+static const struct pci_device_id acard_ahci_pci_tbl[] = {
+	{ PCI_VDEVICE(ARTOP, 0x000D), board_ahci_acard },
+
+	{ }	/* terminate list */
+};
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
+static unsigned int acard_fill_sg(struct ata_queued_cmd *qc, void *cmd_tbl)
+{
+	struct scatterlist *sg;
+	struct acard_sg *acard_sg = cmd_tbl + AHCI_CMD_TBL_HDR_SZ;
+	unsigned int si, last_si = 0;
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
+		/* ACard note: flags and size are different
+		 * fields, rather than AHCI's flags_size,
+		 * we must set an end-of-table (EOT) bit,
+		 * and the segment cannot exceed 64k (0x10000)
+		 */
+		acard_sg[si].addr = cpu_to_le32(addr & 0xffffffff);
+		acard_sg[si].addr_hi = cpu_to_le32((addr >> 16) >> 16);
+		acard_sg[si].flags = 0;
+		acard_sg[si].size = cpu_to_le32(sg_len);
+		last_si = si;
+	}
+
+	acard_sg[last_si].flags |= cpu_to_le32(1 << 31);	/* set EOT */
+
+	return si;
+}
+
+static void acard_qc_prep(struct ata_queued_cmd *qc)
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
+		n_elem = acard_fill_sg(qc, cmd_tbl);
+
+	/*
+	 * Fill in command slot information.
+	 *
+	 * ACard note: prd table length not filled in
+	 */
+	opts = cmd_fis_len | (qc->dev->link->pmp << 12);
+	if (qc->tf.flags & ATA_TFLAG_WRITE)
+		opts |= AHCI_CMD_WRITE;
+	if (is_atapi)
+		opts |= AHCI_CMD_ATAPI | AHCI_CMD_PREFETCH;
+
+	ahci_fill_cmd_slot(pp, qc->tag, opts);
+}
+
+static int acard_ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	static int printed_version;
+	unsigned int board_id = ent->driver_data;
+	struct ata_port_info pi = acard_ahci_port_info[board_id];
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
+	return ata_host_activate(host, pdev->irq, ahci_interrupt,
+				 IRQF_SHARED, &acard_sht);
+}
+
+static struct pci_driver acard_ahci_pci_driver = {
+	.name			= DRV_NAME,
+	.id_table		= acard_ahci_pci_tbl,
+	.probe			= acard_ahci_init_one,
+	.remove			= ata_pci_remove_one,
+#ifdef CONFIG_PM
+	.suspend		= ahci_pci_device_suspend,
+	.resume			= ahci_pci_device_resume,
+#endif
+};
+
+static int __init acard_ahci_init(void)
+{
+	return pci_register_driver(&acard_ahci_pci_driver);
+}
+
+static void __exit acard_ahci_exit(void)
+{
+	pci_unregister_driver(&acard_ahci_pci_driver);
+}
+
+MODULE_AUTHOR("Jeff Garzik");
+MODULE_DESCRIPTION("ACard AHCI SATA low-level driver");
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(pci, acard_ahci_pci_tbl);
+MODULE_VERSION(DRV_VERSION);
+
+module_init(acard_ahci_init);
+module_exit(acard_ahci_exit);
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index cbd9c24..40be352 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -98,40 +98,8 @@ static struct scsi_host_template ahci_sht = {
 };
 
 static struct ata_port_operations ahci_ops = {
-	.inherits		= &sata_pmp_port_ops,
-
-	.qc_defer		= sata_pmp_qc_defer_cmd_switch,
-	.qc_prep		= ahci_qc_prep,
-	.qc_issue		= ahci_qc_issue,
-	.qc_fill_rtf		= ahci_qc_fill_rtf,
-
-	.freeze			= ahci_freeze,
-	.thaw			= ahci_thaw,
-	.softreset		= ahci_softreset,
-	.hardreset		= ahci_hardreset,
-	.postreset		= ahci_postreset,
-	.pmp_softreset		= ahci_softreset,
-	.error_handler		= ahci_error_handler,
-	.post_internal_cmd	= ahci_post_internal_cmd,
+	.inherits		= &ahci_base_ops,
 	.dev_config		= ahci_dev_config,
-
-	.scr_read		= ahci_scr_read,
-	.scr_write		= ahci_scr_write,
-	.pmp_attach		= ahci_pmp_attach,
-	.pmp_detach		= ahci_pmp_detach,
-
-	.enable_pm		= ahci_enable_alpm,
-	.disable_pm		= ahci_disable_alpm,
-	.em_show		= ahci_led_show,
-	.em_store		= ahci_led_store,
-	.sw_activity_show	= ahci_activity_show,
-	.sw_activity_store	= ahci_activity_store,
-#ifdef CONFIG_PM
-	.port_suspend		= ahci_port_suspend,
-	.port_resume		= ahci_port_resume,
-#endif
-	.port_start		= ahci_port_start,
-	.port_stop		= ahci_port_stop,
 };
 
 static struct ata_port_operations ahci_vt8251_ops = {
@@ -511,66 +479,6 @@ static int ahci_p5wdh_hardreset(struct ata_link *link, unsigned int *class,
 	return rc;
 }
 
-static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
-{
-	struct ata_host *host = dev_instance;
-	struct ahci_host_priv *hpriv;
-	unsigned int i, handled = 0;
-	void __iomem *mmio;
-	u32 irq_stat, irq_masked;
-
-	VPRINTK("ENTER\n");
-
-	hpriv = host->private_data;
-	mmio = host->iomap[AHCI_PCI_BAR];
-
-	/* sigh.  0xffffffff is a valid return from h/w */
-	irq_stat = readl(mmio + HOST_IRQ_STAT);
-	if (!irq_stat)
-		return IRQ_NONE;
-
-	irq_masked = irq_stat & hpriv->port_map;
-
-	spin_lock(&host->lock);
-
-	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap;
-
-		if (!(irq_masked & (1 << i)))
-			continue;
-
-		ap = host->ports[i];
-		if (ap) {
-			ahci_port_intr(ap);
-			VPRINTK("port %u\n", i);
-		} else {
-			VPRINTK("port %u (no irq)\n", i);
-			if (ata_ratelimit())
-				dev_printk(KERN_WARNING, host->dev,
-					"interrupt on disabled port %u\n", i);
-		}
-
-		handled = 1;
-	}
-
-	/* HOST_IRQ_STAT behaves as level triggered latch meaning that
-	 * it should be cleared after all the port events are cleared;
-	 * otherwise, it will raise a spurious interrupt after each
-	 * valid one.  Please read section 10.6.2 of ahci 1.1 for more
-	 * information.
-	 *
-	 * Also, use the unmasked value to clear interrupt as spurious
-	 * pending event on a dummy port might cause screaming IRQ.
-	 */
-	writel(irq_stat, mmio + HOST_IRQ_STAT);
-
-	spin_unlock(&host->lock);
-
-	VPRINTK("EXIT\n");
-
-	return IRQ_RETVAL(handled);
-}
-
 /* On ASUS P5W DH Deluxe, the second port of PCI device 00:1f.2 is
  * hardwired to on-board SIMG 4726.  The chipset is ICH8 and doesn't
  * support PMP and the 4726 either directly exports the device
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 57c792a..890da4e 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -237,6 +237,8 @@ static inline int ahci_nr_ports(u32 cap)
 	return (cap & 0x1f) + 1;
 }
 
+extern struct ata_port_operations ahci_base_ops;
+
 extern void ahci_postreset(struct ata_link *link, unsigned int *class);
 extern void ahci_qc_prep(struct ata_queued_cmd *qc);
 extern void ahci_freeze(struct ata_port *ap);
@@ -277,6 +279,7 @@ extern ssize_t ahci_activity_store(struct ata_device *dev, enum sw_activity val)
 extern ssize_t ahci_activity_show(struct ata_device *dev, char *buf);
 extern void ahci_print_info(struct ata_host *host);
 extern void ahci_port_intr(struct ata_port *ap);
+extern irqreturn_t ahci_interrupt(int irq, void *dev_instance);
 extern void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag, u32 opts);
 extern unsigned int ahci_fill_sg(struct ata_queued_cmd *qc, void *cmd_tbl);
 extern int ahci_deinit_port(struct ata_port *ap, const char **emsg);
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 280638a..e50f08a 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1709,3 +1709,101 @@ void ahci_port_intr(struct ata_port *ap)
 }
 EXPORT_SYMBOL_GPL(ahci_port_intr);
 
+irqreturn_t ahci_interrupt(int irq, void *dev_instance)
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
+EXPORT_SYMBOL_GPL(ahci_interrupt);
+
+struct ata_port_operations ahci_base_ops = {
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
+EXPORT_SYMBOL_GPL(ahci_base_ops);
+
