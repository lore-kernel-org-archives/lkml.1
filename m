Return-Path: <linux-kernel-owner+w=401wt.eu-S1755819AbXJYHtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbXJYHtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 03:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbXJYHta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 03:49:30 -0400
Received: from havoc.gtf.org ([69.61.125.42]:49486 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200AbXJYHt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 03:49:28 -0400
Date: Thu, 25 Oct 2007 03:49:27 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates
Message-ID: <20071025074927.GA8887@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


A couple small cleanups, the rest fixes.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c        |  144 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata-core.c |   40 ++++++------
 drivers/ata/libata-eh.c   |   12 ++--
 drivers/ata/pata_icside.c |   42 +++++++------
 drivers/ata/sata_nv.c     |    6 +-
 5 files changed, 195 insertions(+), 49 deletions(-)

Adrian Bunk (1):
      libata-core.c: make 2 functions static

Al Viro (1):
      Fix pata_icside build for recent libata API changes

Alan Cox (1):
      libata-core: Be a bit more relaxed about early DMA zero devices

Jeff Garzik (1):
      [libata] Create [and use -ed.] internal helper ata_dev_set_feature()

Kuan Luo (1):
      [libata] sata_nv: SWNCQ should not apply to MCP61

Tejun Heo (2):
      libata: cosmetic clean up in ata_eh_reset()
      ahci: ahci: implement workaround for ASUS P5W-DH Deluxe ahci_broken_hardreset(), take #2

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 95229e7..49cf4cf 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -41,6 +41,7 @@
 #include <linux/interrupt.h>
 #include <linux/dma-mapping.h>
 #include <linux/device.h>
+#include <linux/dmi.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_cmnd.h>
 #include <linux/libata.h>
@@ -241,6 +242,7 @@ static void ahci_pmp_attach(struct ata_port *ap);
 static void ahci_pmp_detach(struct ata_port *ap);
 static void ahci_error_handler(struct ata_port *ap);
 static void ahci_vt8251_error_handler(struct ata_port *ap);
+static void ahci_p5wdh_error_handler(struct ata_port *ap);
 static void ahci_post_internal_cmd(struct ata_queued_cmd *qc);
 static int ahci_port_resume(struct ata_port *ap);
 static unsigned int ahci_fill_sg(struct ata_queued_cmd *qc, void *cmd_tbl);
@@ -339,6 +341,40 @@ static const struct ata_port_operations ahci_vt8251_ops = {
 	.port_stop		= ahci_port_stop,
 };
 
+static const struct ata_port_operations ahci_p5wdh_ops = {
+	.check_status		= ahci_check_status,
+	.check_altstatus	= ahci_check_status,
+	.dev_select		= ata_noop_dev_select,
+
+	.tf_read		= ahci_tf_read,
+
+	.qc_defer		= sata_pmp_qc_defer_cmd_switch,
+	.qc_prep		= ahci_qc_prep,
+	.qc_issue		= ahci_qc_issue,
+
+	.irq_clear		= ahci_irq_clear,
+
+	.scr_read		= ahci_scr_read,
+	.scr_write		= ahci_scr_write,
+
+	.freeze			= ahci_freeze,
+	.thaw			= ahci_thaw,
+
+	.error_handler		= ahci_p5wdh_error_handler,
+	.post_internal_cmd	= ahci_post_internal_cmd,
+
+	.pmp_attach		= ahci_pmp_attach,
+	.pmp_detach		= ahci_pmp_detach,
+
+#ifdef CONFIG_PM
+	.port_suspend		= ahci_port_suspend,
+	.port_resume		= ahci_port_resume,
+#endif
+
+	.port_start		= ahci_port_start,
+	.port_stop		= ahci_port_stop,
+};
+
 #define AHCI_HFLAGS(flags)	.private_data	= (void *)(flags)
 
 static const struct ata_port_info ahci_port_info[] = {
@@ -1213,6 +1249,53 @@ static int ahci_vt8251_hardreset(struct ata_link *link, unsigned int *class,
 	return rc ?: -EAGAIN;
 }
 
+static int ahci_p5wdh_hardreset(struct ata_link *link, unsigned int *class,
+				unsigned long deadline)
+{
+	struct ata_port *ap = link->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
+	struct ata_taskfile tf;
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
+				 deadline);
+
+	ahci_start_engine(ap);
+
+	if (rc || ata_link_offline(link))
+		return rc;
+
+	/* spec mandates ">= 2ms" before checking status */
+	msleep(150);
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
+	rc = ata_wait_ready(ap, jiffies + 2 * HZ);
+	if (rc)
+		ahci_kick_engine(ap, 0);
+
+	return 0;
+}
+
 static void ahci_postreset(struct ata_link *link, unsigned int *class)
 {
 	struct ata_port *ap = link->ap;
@@ -1670,6 +1753,19 @@ static void ahci_vt8251_error_handler(struct ata_port *ap)
 		  ahci_postreset);
 }
 
+static void ahci_p5wdh_error_handler(struct ata_port *ap)
+{
+	if (!(ap->pflags & ATA_PFLAG_FROZEN)) {
+		/* restart engine */
+		ahci_stop_engine(ap);
+		ahci_start_engine(ap);
+	}
+
+	/* perform recovery */
+	ata_do_eh(ap, ata_std_prereset, ahci_softreset, ahci_p5wdh_hardreset,
+		  ahci_postreset);
+}
+
 static void ahci_post_internal_cmd(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
@@ -1955,6 +2051,51 @@ static void ahci_print_info(struct ata_host *host)
 		);
 }
 
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
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
@@ -2024,6 +2165,9 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			ap->ops = &ata_dummy_port_ops;
 	}
 
+	/* apply workaround for ASUS P5W DH Deluxe mainboard */
+	ahci_p5wdh_workaround(host);
+
 	/* initialize adapter */
 	rc = ahci_configure_dma_masks(pdev, hpriv->cap & HOST_CAP_64);
 	if (rc)
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 2d147b5..9d10e2f 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -68,7 +68,8 @@ const unsigned long sata_deb_timing_long[]		= { 100, 2000, 5000 };
 static unsigned int ata_dev_init_params(struct ata_device *dev,
 					u16 heads, u16 sectors);
 static unsigned int ata_dev_set_xfermode(struct ata_device *dev);
-static unsigned int ata_dev_set_AN(struct ata_device *dev, u8 enable);
+static unsigned int ata_dev_set_feature(struct ata_device *dev,
+					u8 enable, u8 feature);
 static void ata_dev_xfermask(struct ata_device *dev);
 static unsigned long ata_dev_blacklisted(const struct ata_device *dev);
 
@@ -1799,13 +1800,7 @@ int ata_dev_read_id(struct ata_device *dev, unsigned int *p_class,
 		 * SET_FEATURES spin-up subcommand before it will accept
 		 * anything other than the original IDENTIFY command.
 		 */
-		ata_tf_init(dev, &tf);
-		tf.command = ATA_CMD_SET_FEATURES;
-		tf.feature = SETFEATURES_SPINUP;
-		tf.protocol = ATA_PROT_NODATA;
-		tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
-		err_mask = ata_exec_internal(dev, &tf, NULL,
-					     DMA_NONE, NULL, 0, 0);
+		err_mask = ata_dev_set_feature(dev, SETFEATURES_SPINUP, 0);
 		if (err_mask && id[2] != 0x738c) {
 			rc = -EIO;
 			reason = "SPINUP failed";
@@ -2075,7 +2070,8 @@ int ata_dev_configure(struct ata_device *dev)
 			unsigned int err_mask;
 
 			/* issue SET feature command to turn this on */
-			err_mask = ata_dev_set_AN(dev, SETFEATURES_SATA_ENABLE);
+			err_mask = ata_dev_set_feature(dev,
+					SETFEATURES_SATA_ENABLE, SATA_AN);
 			if (err_mask)
 				ata_dev_printk(dev, KERN_ERR,
 					"failed to enable ATAPI AN "
@@ -2886,6 +2882,13 @@ static int ata_dev_set_mode(struct ata_device *dev)
 			dev->pio_mode <= XFER_PIO_2)
 		err_mask &= ~AC_ERR_DEV;
 
+	/* Early MWDMA devices do DMA but don't allow DMA mode setting.
+	   Don't fail an MWDMA0 set IFF the device indicates it is in MWDMA0 */
+	if (dev->xfer_shift == ATA_SHIFT_MWDMA && 
+	    dev->dma_mode == XFER_MW_DMA_0 &&
+	    (dev->id[63] >> 8) & 1)
+		err_mask &= ~AC_ERR_DEV;
+
 	if (err_mask) {
 		ata_dev_printk(dev, KERN_ERR, "failed to set xfermode "
 			       "(err_mask=0x%x)\n", err_mask);
@@ -3947,9 +3950,6 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "_NEC DV5800A", 	NULL,		ATA_HORKAGE_NODMA },
 	{ "SAMSUNG CD-ROM SN-124", "N001",	ATA_HORKAGE_NODMA },
 	{ "Seagate STT20000A", NULL,		ATA_HORKAGE_NODMA },
-	{ "IOMEGA  ZIP 250       ATAPI", NULL,	ATA_HORKAGE_NODMA }, /* temporary fix */
-	{ "IOMEGA  ZIP 250       ATAPI       Floppy",
-				NULL,		ATA_HORKAGE_NODMA },
 	/* Odd clown on sil3726/4726 PMPs */
 	{ "Config  Disk",	NULL,		ATA_HORKAGE_NODMA |
 						ATA_HORKAGE_SKIP_PM },
@@ -4007,7 +4007,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ }
 };
 
-int strn_pattern_cmp(const char *patt, const char *name, int wildchar)
+static int strn_pattern_cmp(const char *patt, const char *name, int wildchar)
 {
 	const char *p;
 	int len;
@@ -4181,15 +4181,14 @@ static unsigned int ata_dev_set_xfermode(struct ata_device *dev)
 	DPRINTK("EXIT, err_mask=%x\n", err_mask);
 	return err_mask;
 }
-
 /**
- *	ata_dev_set_AN - Issue SET FEATURES - SATA FEATURES
+ *	ata_dev_set_feature - Issue SET FEATURES - SATA FEATURES
  *	@dev: Device to which command will be sent
  *	@enable: Whether to enable or disable the feature
+ *	@feature: The sector count represents the feature to set
  *
  *	Issue SET FEATURES - SATA FEATURES command to device @dev
- *	on port @ap with sector count set to indicate Asynchronous
- *	Notification feature
+ *	on port @ap with sector count
  *
  *	LOCKING:
  *	PCI/etc. bus probe sem.
@@ -4197,7 +4196,8 @@ static unsigned int ata_dev_set_xfermode(struct ata_device *dev)
  *	RETURNS:
  *	0 on success, AC_ERR_* mask otherwise.
  */
-static unsigned int ata_dev_set_AN(struct ata_device *dev, u8 enable)
+static unsigned int ata_dev_set_feature(struct ata_device *dev, u8 enable,
+					u8 feature)
 {
 	struct ata_taskfile tf;
 	unsigned int err_mask;
@@ -4210,7 +4210,7 @@ static unsigned int ata_dev_set_AN(struct ata_device *dev, u8 enable)
 	tf.feature = enable;
 	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
 	tf.protocol = ATA_PROT_NODATA;
-	tf.nsect = SATA_AN;
+	tf.nsect = feature;
 
 	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0, 0);
 
@@ -6921,7 +6921,7 @@ int ata_host_activate(struct ata_host *host, int irq,
  *	LOCKING:
  *	Kernel thread context (may sleep).
  */
-void ata_port_detach(struct ata_port *ap)
+static void ata_port_detach(struct ata_port *ap)
 {
 	unsigned long flags;
 	struct ata_link *link;
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 93e2b54..8cb35bb 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2071,7 +2071,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	int try = 0;
 	struct ata_device *dev;
 	unsigned long deadline;
-	unsigned int action;
+	unsigned int tmp_action;
 	ata_reset_fn_t reset;
 	unsigned long flags;
 	int rc;
@@ -2086,14 +2086,14 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	/* Determine which reset to use and record in ehc->i.action.
 	 * prereset() may examine and modify it.
 	 */
-	action = ehc->i.action;
-	ehc->i.action &= ~ATA_EH_RESET_MASK;
 	if (softreset && (!hardreset || (!(link->flags & ATA_LFLAG_NO_SRST) &&
 					 !sata_set_spd_needed(link) &&
-					 !(action & ATA_EH_HARDRESET))))
-		ehc->i.action |= ATA_EH_SOFTRESET;
+					 !(ehc->i.action & ATA_EH_HARDRESET))))
+		tmp_action = ATA_EH_SOFTRESET;
 	else
-		ehc->i.action |= ATA_EH_HARDRESET;
+		tmp_action = ATA_EH_HARDRESET;
+
+	ehc->i.action = (ehc->i.action & ~ATA_EH_RESET_MASK) | tmp_action;
 
 	if (prereset) {
 		rc = prereset(link, jiffies + ATA_EH_PRERESET_TIMEOUT);
diff --git a/drivers/ata/pata_icside.c b/drivers/ata/pata_icside.c
index be30923..842fe08 100644
--- a/drivers/ata/pata_icside.c
+++ b/drivers/ata/pata_icside.c
@@ -332,12 +332,13 @@ static void ata_dummy_noret(struct ata_port *port)
 {
 }
 
-static void pata_icside_postreset(struct ata_port *ap, unsigned int *classes)
+static void pata_icside_postreset(struct ata_link *link, unsigned int *classes)
 {
+	struct ata_port *ap = link->ap;
 	struct pata_icside_state *state = ap->host->private_data;
 
 	if (classes[0] != ATA_DEV_NONE || classes[1] != ATA_DEV_NONE)
-		return ata_std_postreset(ap, classes);
+		return ata_std_postreset(link, classes);
 
 	state->port[ap->port_no].disabled = 1;
 
@@ -395,29 +396,30 @@ static struct ata_port_operations pata_icside_port_ops = {
 
 static void __devinit
 pata_icside_setup_ioaddr(struct ata_port *ap, void __iomem *base,
-			 const struct portinfo *info)
+			 struct pata_icside_info *info,
+			 const struct portinfo *port)
 {
 	struct ata_ioports *ioaddr = &ap->ioaddr;
-	void __iomem *cmd = base + info->dataoffset;
+	void __iomem *cmd = base + port->dataoffset;
 
 	ioaddr->cmd_addr	= cmd;
-	ioaddr->data_addr	= cmd + (ATA_REG_DATA    << info->stepping);
-	ioaddr->error_addr	= cmd + (ATA_REG_ERR     << info->stepping);
-	ioaddr->feature_addr	= cmd + (ATA_REG_FEATURE << info->stepping);
-	ioaddr->nsect_addr	= cmd + (ATA_REG_NSECT   << info->stepping);
-	ioaddr->lbal_addr	= cmd + (ATA_REG_LBAL    << info->stepping);
-	ioaddr->lbam_addr	= cmd + (ATA_REG_LBAM    << info->stepping);
-	ioaddr->lbah_addr	= cmd + (ATA_REG_LBAH    << info->stepping);
-	ioaddr->device_addr	= cmd + (ATA_REG_DEVICE  << info->stepping);
-	ioaddr->status_addr	= cmd + (ATA_REG_STATUS  << info->stepping);
-	ioaddr->command_addr	= cmd + (ATA_REG_CMD     << info->stepping);
-
-	ioaddr->ctl_addr	= base + info->ctrloffset;
+	ioaddr->data_addr	= cmd + (ATA_REG_DATA    << port->stepping);
+	ioaddr->error_addr	= cmd + (ATA_REG_ERR     << port->stepping);
+	ioaddr->feature_addr	= cmd + (ATA_REG_FEATURE << port->stepping);
+	ioaddr->nsect_addr	= cmd + (ATA_REG_NSECT   << port->stepping);
+	ioaddr->lbal_addr	= cmd + (ATA_REG_LBAL    << port->stepping);
+	ioaddr->lbam_addr	= cmd + (ATA_REG_LBAM    << port->stepping);
+	ioaddr->lbah_addr	= cmd + (ATA_REG_LBAH    << port->stepping);
+	ioaddr->device_addr	= cmd + (ATA_REG_DEVICE  << port->stepping);
+	ioaddr->status_addr	= cmd + (ATA_REG_STATUS  << port->stepping);
+	ioaddr->command_addr	= cmd + (ATA_REG_CMD     << port->stepping);
+
+	ioaddr->ctl_addr	= base + port->ctrloffset;
 	ioaddr->altstatus_addr	= ioaddr->ctl_addr;
 
 	ata_port_desc(ap, "cmd 0x%lx ctl 0x%lx",
-		      info->raw_base + info->dataoffset,
-		      info->raw_base + info->ctrloffset);
+		      info->raw_base + port->dataoffset,
+		      info->raw_base + port->ctrloffset);
 
 	if (info->raw_ioc_base)
 		ata_port_desc(ap, "iocbase 0x%lx", info->raw_ioc_base);
@@ -441,7 +443,7 @@ static int __devinit pata_icside_register_v5(struct pata_icside_info *info)
 	info->nr_ports = 1;
 	info->port[0] = &pata_icside_portinfo_v5;
 
-	info->raw_base = ecard_resource_start(ec, ECARD_RES_MEMC);
+	info->raw_base = ecard_resource_start(info->ec, ECARD_RES_MEMC);
 
 	return 0;
 }
@@ -522,7 +524,7 @@ static int __devinit pata_icside_add_ports(struct pata_icside_info *info)
 		ap->flags |= ATA_FLAG_SLAVE_POSS;
 		ap->ops = &pata_icside_port_ops;
 
-		pata_icside_setup_ioaddr(ap, info->base, info->port[i]);
+		pata_icside_setup_ioaddr(ap, info->base, info, info->port[i]);
 	}
 
 	return ata_host_activate(host, ec->irq, ata_interrupt, 0,
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 2e0279f..f1b422f 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -365,9 +365,9 @@ static const struct pci_device_id nv_pci_tbl[] = {
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA2), SWNCQ },
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA), SWNCQ },
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA2), SWNCQ },
-	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA), SWNCQ },
-	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA2), SWNCQ },
-	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA3), SWNCQ },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA), GENERIC },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA2), GENERIC },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA3), GENERIC },
 
 	{ } /* terminate list */
 };
