Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639AbYFBUCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbYFBUCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 16:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbYFBUBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 16:01:49 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55543 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbYFBUBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 16:01:45 -0400
Date: Mon, 2 Jun 2008 21:00:53 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: rwheeler@redhat.com, kristen.c.accardi@intel.com, Mark Lord <liml@rtr.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Theodore Tso <tytso@mit.edu>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: ahci: power off unused ports
Message-ID: <20080602200053.GA17698@srcf.ucam.org>
References: <4843A4A7.3020809@garzik.org> <4843EF88.2040606@rtr.ca> <48441AA6.8080704@garzik.org> <20080602100019.3d2d2522@appleyard> <484431AB.7010005@garzik.org> <20080602104753.3f24087d@appleyard> <484438BF.7070303@garzik.org> <20080602111644.54738d57@appleyard> <48443C3C.3010401@redhat.com> <48443EB3.8020303@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48443EB3.8020303@garzik.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 02:40:51PM -0400, Jeff Garzik wrote:

> A better patch would enable the _possibility_ of power savings on 
> non-AHCI chips, and not add a one-off AHCI-specific user interface that 
> must be supported for years to come.

So how about somethig like the following, where the module parameter 
just gets moved to libata rather than ahci? Entirely untested, I don't 
have ahci on this machine.

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 97f83fb..5913ebb 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -56,6 +56,7 @@ MODULE_PARM_DESC(skip_host_reset, "skip global host reset (0=don't skip, 1=skip)
 static int ahci_enable_alpm(struct ata_port *ap,
 		enum link_pm policy);
 static void ahci_disable_alpm(struct ata_port *ap);
+static int ahci_is_hotplug_capable(struct ata_port *ap);
 
 enum {
 	AHCI_PCI_BAR		= 5,
@@ -166,6 +167,8 @@ enum {
 	PORT_CMD_ASP		= (1 << 27), /* Aggressive Slumber/Partial */
 	PORT_CMD_ALPE		= (1 << 26), /* Aggressive Link PM enable */
 	PORT_CMD_ATAPI		= (1 << 24), /* Device is ATAPI */
+	PORT_CMD_ESP		= (1 << 21), /* External SATA Port */
+	PORT_CMD_HPCP		= (1 << 18), /* port is hot plug capable */
 	PORT_CMD_PMP		= (1 << 17), /* PMP attached */
 	PORT_CMD_LIST_ON	= (1 << 15), /* cmd list DMA engine running */
 	PORT_CMD_FIS_ON		= (1 << 14), /* FIS DMA engine running */
@@ -1900,6 +1903,15 @@ static int ahci_pci_device_resume(struct pci_dev *pdev)
 }
 #endif
 
+static int ahci_is_hotplug_capable(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u8 cmd;
+
+	cmd = readl(port_mmio + PORT_CMD);
+	return ((cmd & PORT_CMD_HPCP) || (cmd & PORT_CMD_ESP));
+}
+
 static int ahci_port_start(struct ata_port *ap)
 {
 	struct device *dev = ap->host->dev;
@@ -1951,6 +1963,9 @@ static int ahci_port_start(struct ata_port *ap)
 
 	ap->private_data = pp;
 
+	/* set some flags based on port capabilities */
+	if (!ahci_is_hotplug_capable(ap))
+		ap->flags |= ATA_FLAG_NO_HOTPLUG;
 	/* engage engines, captain */
 	return ahci_port_resume(ap);
 }
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 3c89f20..209efe5 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -157,11 +157,28 @@ int libata_allow_tpm = 0;
 module_param_named(allow_tpm, libata_allow_tpm, int, 0444);
 MODULE_PARM_DESC(allow_tpm, "Permit the use of TPM commands");
 
+static int sata_power_save = 1;
+module_param_named(sata_power_save, sata_power_save, int, 0644);
+MODULE_PARM_DESC(sata_power_save, "Power off unused ports (0=don't power off, 1=power off)");
+
 MODULE_AUTHOR("Jeff Garzik");
 MODULE_DESCRIPTION("Library module for ATA devices");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 
+static void ata_phy_offline(struct ata_link *link)
+{
+	u32 scontrol;
+	int rc;
+
+	/* set DET to 4 */
+	rc = sata_scr_read(link, SCR_CONTROL, &scontrol);
+	if (rc)
+		return;
+	scontrol &= ~0xf;
+	scontrol |= (1 << 2);
+	sata_scr_write(link, SCR_CONTROL, scontrol);
+}
 
 /**
  *	ata_force_cbl - force cable type according to libata.force
@@ -2678,6 +2695,7 @@ void ata_port_disable(struct ata_port *ap)
 	ap->link.device[0].class = ATA_DEV_NONE;
 	ap->link.device[1].class = ATA_DEV_NONE;
 	ap->flags |= ATA_FLAG_DISABLED;
+	ata_phy_offline(&ap->link);
 }
 
 /**
@@ -5614,6 +5632,8 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 		if (ap->ops->error_handler) {
 			struct ata_eh_info *ehi = &ap->link.eh_info;
 			unsigned long flags;
+			int device_attached = 0;
+			struct ata_device *dev;
 
 			ata_port_probe(ap);
 
@@ -5632,6 +5652,14 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 
 			/* wait for EH to finish */
 			ata_port_wait_eh(ap);
+			ata_link_for_each_dev(dev, &ap->link)
+				if (ata_dev_enabled(dev))
+					device_attached++;
+			if (!device_attached && sata_power_save &&
+			    (ap->flags & ATA_FLAG_NO_HOTPLUG)) {
+				/* no device present, disable port */
+				ata_port_disable(ap);
+			}
 		} else {
 			DPRINTK("ata%u: bus probe begin\n", ap->print_id);
 			rc = ata_bus_probe(ap);

-- 
Matthew Garrett | mjg59@srcf.ucam.org
