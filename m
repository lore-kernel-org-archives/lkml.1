Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbYICNvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbYICNvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 09:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbYICNvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 09:51:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33919 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752010AbYICNu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 09:50:59 -0400
Date: Wed, 3 Sep 2008 14:48:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>, torvalds@osdl.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ahci: Fix long standing Marvell regressions
Message-ID: <20080903144834.35276de7@lxorguk.ukuu.org.uk>
In-Reply-To: <20080903142941.3f25d235@lxorguk.ukuu.org.uk>
References: <20080903000538.7500eaf8@lxorguk.ukuu.org.uk>
	<48BDCF09.7000603@garzik.org>
	<20080903142941.3f25d235@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And here's a rev 3

- Fix the option so it works both ways
- We can using the 6145 detect PATA enabled so implement a facility in
pata_marvell to punt to AHCI if disabled

We can't automate that for the other devices as we don't actually know
how to check the PATA port on them.

--

pata_marvell: Undo multiple ahci caused regressions

From: Alan Cox <alan@redhat.com>

I've been chasing Jeff about this for months so am now giving up and sending
it directly. Jeff added the Marvell device identifiers to the ahci driver
without making the AHCI driver handle the PATA port. This means a lot of users
can't use current kernels and in most distro cases can't even install.

This has been going on since March 2008 for the 6121 Marvell, and late 2007
for the 6145!!!

This was all pointed out at the time and repeatedly ignored. Bugs assigned
to Jeff about this are ignored also.

To quote Jeff in email

"Just switch the order of 'ahci' and 'pata_marvell' in
/etc/modprobe.conf, then use Fedora's tools regenerate the initrd.

See?  It's not rocket science, and the current configuration can be
easily made to work for Fedora users."

(Which isn't trivial, isn't end user, shouldn't be needed, and as it usually
breaks at install time is in fact impossible)

To quote Jeff in August 2007

"   mv-ahci-pata
Marvell 6121/6141 PATA support.  Needs fixing in the 'PATA controller
command' area before it is usable, and can go upstream."

Only he add the ids anyway later and caused regressions, adding a further
id in March causing more regresions.

The actual fix for the moment is very simple. If the user has included
the pata_marvell driver let it drive the ports. If they've only selected
for SATA support give them the AHCI driver which will run the port a fraction
faster. Allow the user to control this decision via ahci.marvell_enable as
a module parameter so that distributions can ship 'it works' defaults and
smarter users (or config tools) can then flip it over it desired.


Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/ata/Kconfig        |    6 +++--
 drivers/ata/ahci.c         |   17 +++++++++++++++
 drivers/ata/pata_marvell.c |   51 +++++++++++++++++++++++++++++++++-----------
 3 files changed, 59 insertions(+), 15 deletions(-)


diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index ae84949..11c8c19 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -448,8 +448,10 @@ config PATA_MARVELL
 	tristate "Marvell PATA support via legacy mode"
 	depends on PCI
 	help
-	  This option enables limited support for the Marvell 88SE6145 ATA
-	  controller.
+	  This option enables limited support for the Marvell 88SE61xx ATA
+	  controllers. If you wish to use only the SATA ports then select
+	  the AHCI driver alone. If you wish to the use the PATA port or
+	  both SATA and PATA include this driver.
 
 	  If unsure, say N.
 
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index c729e69..bce26ee 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -610,6 +610,15 @@ module_param(ahci_em_messages, int, 0444);
 MODULE_PARM_DESC(ahci_em_messages,
 	"Set AHCI Enclosure Management Message type (0 = disabled, 1 = LED");
 
+#if defined(CONFIG_PATA_MARVELL) || defined(CONFIG_PATA_MARVELL_MODULE)
+static int marvell_enable;
+#else
+static int marvell_enable = 1;
+#endif
+module_param(marvell_enable, int, 0644);
+MODULE_PARM_DESC(marvell_enable, "Marvell SATA via AHCI (1 = enabled)");
+
+
 static inline int ahci_nr_ports(u32 cap)
 {
 	return (cap & 0x1f) + 1;
@@ -732,6 +741,8 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
 			   "MV_AHCI HACK: port_map %x -> %x\n",
 			   port_map,
 			   port_map & mv);
+		dev_printk(KERN_ERR, &pdev->dev,
+			  "Disabling your PATA port. Use the boot option 'ahci.marvell_enable=0' to avoid this.\n");
 
 		port_map &= mv;
 	}
@@ -2533,6 +2544,12 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
 
+	/* The AHCI driver can only drive the SATA ports, the PATA driver
+	   can drive them all so if both drivers are selected make sure
+	   AHCI stays out of the way */
+	if (pdev->vendor == PCI_VENDOR_ID_MARVELL && !marvell_enable)
+		return -ENODEV;
+
 	/* acquire resources */
 	rc = pcim_enable_device(pdev);
 	if (rc)
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index 24a011b..0d87eec 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -20,29 +20,30 @@
 #include <linux/ata.h>
 
 #define DRV_NAME	"pata_marvell"
-#define DRV_VERSION	"0.1.4"
+#define DRV_VERSION	"0.1.6"
 
 /**
- *	marvell_pre_reset	-	check for 40/80 pin
- *	@link: link
- *	@deadline: deadline jiffies for the operation
+ *	marvell_pata_active	-	check if PATA is active
+ *	@pdev: PCI device
  *
- *	Perform the PATA port setup we need.
+ *	Returns 1 if the PATA port may be active. We know how to check this
+ *	for the 6145 but not the other devices
  */
 
-static int marvell_pre_reset(struct ata_link *link, unsigned long deadline)
+static int marvell_pata_active(struct pci_dev *pdev)
 {
-	struct ata_port *ap = link->ap;
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	int i;
 	u32 devices;
 	void __iomem *barp;
-	int i;
 
-	/* Check if our port is enabled */
+	/* We don't yet know how to do this for other devices */
+	if (pdev->device != 0x6145)
+		return 1;	
 
 	barp = pci_iomap(pdev, 5, 0x10);
 	if (barp == NULL)
 		return -ENOMEM;
+
 	printk("BAR5:");
 	for(i = 0; i <= 0x0F; i++)
 		printk("%02X:%02X ", i, ioread8(barp + i));
@@ -51,9 +52,27 @@ static int marvell_pre_reset(struct ata_link *link, unsigned long deadline)
 	devices = ioread32(barp + 0x0C);
 	pci_iounmap(pdev, barp);
 
-	if ((pdev->device == 0x6145) && (ap->port_no == 0) &&
-	    (!(devices & 0x10)))	/* PATA enable ? */
-		return -ENOENT;
+	if (devices & 0x10)
+		return 1;
+	return 0;
+}
+
+/**
+ *	marvell_pre_reset	-	check for 40/80 pin
+ *	@link: link
+ *	@deadline: deadline jiffies for the operation
+ *
+ *	Perform the PATA port setup we need.
+ */
+
+static int marvell_pre_reset(struct ata_link *link, unsigned long deadline)
+{
+	struct ata_port *ap = link->ap;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+
+	if (pdev->device == 0x6145 && ap->port_no == 0 &&
+		!marvell_pata_active(pdev))	/* PATA enable ? */
+			return -ENOENT;
 
 	return ata_sff_prereset(link, deadline);
 }
@@ -128,6 +147,12 @@ static int marvell_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 	if (pdev->device == 0x6101)
 		ppi[1] = &ata_dummy_port_info;
 
+#if defined(CONFIG_AHCI) || defined(CONFIG_AHCI_MODULE)
+	if (!marvell_pata_active(pdev)) {
+		printk(KERN_INFO DRV_NAME ": PATA port not active, deferring to AHCI driver.\n");
+		return -ENODEV;
+	}
+#endif
 	return ata_pci_sff_init_one(pdev, ppi, &marvell_sht, NULL);
 }
 

