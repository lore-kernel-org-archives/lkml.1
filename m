Return-Path: <linux-kernel-owner+w=401wt.eu-S1757947AbYFBRJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947AbYFBRJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbYFBRJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:09:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:41476 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbYFBRJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:09:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,578,1204531200"; 
   d="scan'208";a="571345603"
Date: Mon, 2 Jun 2008 10:00:19 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Mark Lord <liml@rtr.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: ahci: power off unused ports
Message-ID: <20080602100019.3d2d2522@appleyard>
In-Reply-To: <48441AA6.8080704@garzik.org>
References: <20080508161008.59361de5@appleyard>
	<20080527030854.GC7515@mit.edu>
	<20080527143202.4bab5bf0@appleyard>
	<20080527225926.GE6843@mit.edu>
	<20080527163251.04054a74@appleyard>
	<20080531080015.GG5405@ucw.cz>
	<4842F5A8.9020708@garzik.org>
	<20080602080440.25fc663c@core>
	<4843A4A7.3020809@garzik.org>
	<4843EF88.2040606@rtr.ca>
	<48441AA6.8080704@garzik.org>
Reply-To: kristen.c.accardi@intel.com
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jun 2008 12:07:02 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Mark Lord wrote:
> > For the power-off of unused ports, the current patch still sounds
> > extremely vendor-specific (Intel).
> > 
> > Does it actually work (demonstrate, please) on any other hardware ?
> 
> Ding...  correct.  We need something per-port that's not Intel specific.
> 
> 	Jeff
> 
> 
> 

Can you tell me what part of this patch is vendor specific?  Maybe
I am misunderstanding what you are saying.  Here's that patch again
in case you need to look at it again.

power off unused ports

If the port isn't either a drive bay or an external SATA port, do not 
keep the phy powered on if the port is unoccupied. This saves .75 watts
on most laptops.  A module parameter can be used to override this 
behavior and allow the phy's to be powered up regardless of whether it
has externally accessible SATA ports. 

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>

---
 drivers/ata/ahci.c        |   21 +++++++++++++++++++++
 drivers/ata/libata-core.c |   24 ++++++++++++++++++++++++
 include/linux/libata.h    |    1 +
 3 files changed, 46 insertions(+)

Index: linux-ahci-phy/drivers/ata/ahci.c
===================================================================
--- linux-ahci-phy.orig/drivers/ata/ahci.c	2008-05-08 14:29:02.000000000 -0700
+++ linux-ahci-phy/drivers/ata/ahci.c	2008-05-08 14:31:05.000000000 -0700
@@ -53,9 +53,13 @@ static int ahci_skip_host_reset;
 module_param_named(skip_host_reset, ahci_skip_host_reset, int, 0444);
 MODULE_PARM_DESC(skip_host_reset, "skip global host reset (0=don't skip, 1=skip)");
 
+static int ahci_power_save = 1;
+module_param_named(power_save, ahci_power_save, int, 0444);
+MODULE_PARM_DESC(power_save, "Power off unused ports (0=don't power off, 1=power off)");
 static int ahci_enable_alpm(struct ata_port *ap,
 		enum link_pm policy);
 static void ahci_disable_alpm(struct ata_port *ap);
+static int ahci_is_hotplug_capable(struct ata_port *ap);
 
 enum {
 	AHCI_PCI_BAR		= 5,
@@ -166,6 +170,8 @@ enum {
 	PORT_CMD_ASP		= (1 << 27), /* Aggressive Slumber/Partial */
 	PORT_CMD_ALPE		= (1 << 26), /* Aggressive Link PM enable */
 	PORT_CMD_ATAPI		= (1 << 24), /* Device is ATAPI */
+	PORT_CMD_ESP		= (1 << 21), /* External SATA Port */
+	PORT_CMD_HPCP		= (1 << 18), /* port is hot plug capable */
 	PORT_CMD_PMP		= (1 << 17), /* PMP attached */
 	PORT_CMD_LIST_ON	= (1 << 15), /* cmd list DMA engine running */
 	PORT_CMD_FIS_ON		= (1 << 14), /* FIS DMA engine running */
@@ -1900,6 +1906,18 @@ static int ahci_pci_device_resume(struct
 }
 #endif
 
+static int ahci_is_hotplug_capable(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u8 cmd;
+
+	if (!ahci_power_save)
+		return 1;
+
+	cmd = readl(port_mmio + PORT_CMD);
+	return ((cmd & PORT_CMD_HPCP) || (cmd & PORT_CMD_ESP));
+}
+
 static int ahci_port_start(struct ata_port *ap)
 {
 	struct device *dev = ap->host->dev;
@@ -1951,6 +1969,9 @@ static int ahci_port_start(struct ata_po
 
 	ap->private_data = pp;
 
+	/* set some flags based on port capabilities */
+	if (!ahci_is_hotplug_capable(ap))
+		ap->flags |= ATA_FLAG_NO_HOTPLUG;
 	/* engage engines, captain */
 	return ahci_port_resume(ap);
 }
Index: linux-ahci-phy/drivers/ata/libata-core.c
===================================================================
--- linux-ahci-phy.orig/drivers/ata/libata-core.c	2008-05-08 14:28:57.000000000 -0700
+++ linux-ahci-phy/drivers/ata/libata-core.c	2008-05-08 14:29:50.000000000 -0700
@@ -162,6 +162,19 @@ MODULE_DESCRIPTION("Library module for A
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
@@ -2671,6 +2684,7 @@ void ata_port_disable(struct ata_port *a
 	ap->link.device[0].class = ATA_DEV_NONE;
 	ap->link.device[1].class = ATA_DEV_NONE;
 	ap->flags |= ATA_FLAG_DISABLED;
+	ata_phy_offline(&ap->link);
 }
 
 /**
@@ -5609,6 +5623,8 @@ int ata_host_register(struct ata_host *h
 		if (ap->ops->error_handler) {
 			struct ata_eh_info *ehi = &ap->link.eh_info;
 			unsigned long flags;
+			int device_attached = 0;
+			struct ata_device *dev;
 
 			ata_port_probe(ap);
 
@@ -5627,6 +5643,14 @@ int ata_host_register(struct ata_host *h
 
 			/* wait for EH to finish */
 			ata_port_wait_eh(ap);
+			ata_link_for_each_dev(dev, &ap->link)
+				if (ata_dev_enabled(dev))
+					device_attached++;
+			if (!device_attached &&
+			    (ap->flags & ATA_FLAG_NO_HOTPLUG)) {
+				/* no device present, disable port */
+				ata_port_disable(ap);
+			}
 		} else {
 			DPRINTK("ata%u: bus probe begin\n", ap->print_id);
 			rc = ata_bus_probe(ap);
Index: linux-ahci-phy/include/linux/libata.h
===================================================================
--- linux-ahci-phy.orig/include/linux/libata.h	2008-05-08 14:28:57.000000000 -0700
+++ linux-ahci-phy/include/linux/libata.h	2008-05-08 14:29:50.000000000 -0700
@@ -193,6 +193,7 @@ enum {
 	ATA_FLAG_AN		= (1 << 18), /* controller supports AN */
 	ATA_FLAG_PMP		= (1 << 19), /* controller supports PMP */
 	ATA_FLAG_IPM		= (1 << 20), /* driver can handle IPM */
+	ATA_FLAG_NO_HOTPLUG	= (1 << 21), /* port doesn't support HP */
 
 	/* The following flag belongs to ap->pflags but is kept in
 	 * ap->flags because it's referenced in many LLDs and will be
