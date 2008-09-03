Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbYICNcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbYICNcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 09:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbYICNca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 09:32:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55634 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751778AbYICNc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 09:32:29 -0400
Date: Wed, 3 Sep 2008 14:29:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: torvalds@osdl.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ahci: Fix long standing Marvell regressions
Message-ID: <20080903142941.3f25d235@lxorguk.ukuu.org.uk>
In-Reply-To: <48BDCF09.7000603@garzik.org>
References: <20080903000538.7500eaf8@lxorguk.ukuu.org.uk>
	<48BDCF09.7000603@garzik.org>
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

> 1) Applying my attached patch

This is another way of doing it that again unlike your joke 'patch'
actually isn't a pointless no-op. Push the decision into a config
variable with module option. Also document that the PATA port is being
disabled so the end user knows who screwed up their machine and how to
undo it.

Default is pata_marvell = use this driver, no pata_marvell use AHCI, but
the default can be reversed in either direction using
ahci.marvell_enable=0/1.

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

 drivers/ata/Kconfig |    6 ++++--
 drivers/ata/ahci.c  |   19 +++++++++++++++++++
 2 files changed, 23 insertions(+), 2 deletions(-)


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
index c729e69..91d2a47 100644
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
@@ -2533,6 +2544,14 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
 
+#if  !defined(CONFIG_PATA_MARVELL) && !defined(CONFIG_PATA_MARVELL_MODULE)
+	/* The AHCI driver can only drive the SATA ports, the PATA driver
+	   can drive them all so if both drivers are selected make sure
+	   AHCI stays out of the way */
+	if (pdev->vendor == PCI_VENDOR_ID_MARVELL && !marvell_enable)
+		return -ENODEV;
+#endif
+
 	/* acquire resources */
 	rc = pcim_enable_device(pdev);
 	if (rc)
