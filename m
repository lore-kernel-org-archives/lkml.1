Return-Path: <linux-kernel-owner+w=401wt.eu-S1760014AbZCMTDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760014AbZCMTDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 15:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759298AbZCMTDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 15:03:18 -0400
Received: from havoc.gtf.org ([69.61.125.42]:51885 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759908AbZCMTDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 15:03:17 -0400
Date: Fri, 13 Mar 2009 15:03:14 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20090313190314.GA27157@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The ata_piix and sata_mv problems are reasonable isolated,
but the libata core fix is notable...

Failure to maintain the cached version of that register properly
could (and probably did) lead to screaming interrupt situations,
or situations where PIO polling data xfer failed.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ata_piix.c   |   37 +++++++++++++++++++++++++++++++++++++
 drivers/ata/libata-sff.c |    6 +++++-
 drivers/ata/sata_mv.c    |    3 ++-
 3 files changed, 44 insertions(+), 2 deletions(-)

Mark Lord (1):
      sata_mv: fix MSI irq race condition

Stuart MENEFY (1):
      libata: Keep shadow last_ctl up to date during resets

Tejun Heo (1):
      ata_piix: add workaround for Samsung DB-P70

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 54961c0..ef8b30d 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1289,6 +1289,39 @@ static const int *__devinit piix_init_sata_map(struct pci_dev *pdev,
 	return map;
 }
 
+static bool piix_no_sidpr(struct ata_host *host)
+{
+	struct pci_dev *pdev = to_pci_dev(host->dev);
+
+	/*
+	 * Samsung DB-P70 only has three ATA ports exposed and
+	 * curiously the unconnected first port reports link online
+	 * while not responding to SRST protocol causing excessive
+	 * detection delay.
+	 *
+	 * Unfortunately, the system doesn't carry enough DMI
+	 * information to identify the machine but does have subsystem
+	 * vendor and device set.  As it's unclear whether the
+	 * subsystem vendor/device is used only for this specific
+	 * board, the port can't be disabled solely with the
+	 * information; however, turning off SIDPR access works around
+	 * the problem.  Turn it off.
+	 *
+	 * This problem is reported in bnc#441240.
+	 *
+	 * https://bugzilla.novell.com/show_bug.cgi?id=441420
+	 */
+	if (pdev->vendor == PCI_VENDOR_ID_INTEL && pdev->device == 0x2920 &&
+	    pdev->subsystem_vendor == PCI_VENDOR_ID_SAMSUNG &&
+	    pdev->subsystem_device == 0xb049) {
+		dev_printk(KERN_WARNING, host->dev,
+			   "Samsung DB-P70 detected, disabling SIDPR\n");
+		return true;
+	}
+
+	return false;
+}
+
 static int __devinit piix_init_sidpr(struct ata_host *host)
 {
 	struct pci_dev *pdev = to_pci_dev(host->dev);
@@ -1302,6 +1335,10 @@ static int __devinit piix_init_sidpr(struct ata_host *host)
 		if (hpriv->map[i] == IDE)
 			return 0;
 
+	/* is it blacklisted? */
+	if (piix_no_sidpr(host))
+		return 0;
+
 	if (!(host->ports[0]->flags & PIIX_FLAG_SIDPR))
 		return 0;
 
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 714cb04..f93dc02 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2066,6 +2066,7 @@ static int ata_bus_softreset(struct ata_port *ap, unsigned int devmask,
 	iowrite8(ap->ctl | ATA_SRST, ioaddr->ctl_addr);
 	udelay(20);	/* FIXME: flush */
 	iowrite8(ap->ctl, ioaddr->ctl_addr);
+	ap->last_ctl = ap->ctl;
 
 	/* wait the port to become ready */
 	return ata_sff_wait_after_reset(&ap->link, devmask, deadline);
@@ -2190,8 +2191,10 @@ void ata_sff_postreset(struct ata_link *link, unsigned int *classes)
 	}
 
 	/* set up device control */
-	if (ap->ioaddr.ctl_addr)
+	if (ap->ioaddr.ctl_addr) {
 		iowrite8(ap->ctl, ap->ioaddr.ctl_addr);
+		ap->last_ctl = ap->ctl;
+	}
 }
 EXPORT_SYMBOL_GPL(ata_sff_postreset);
 
@@ -2534,6 +2537,7 @@ void ata_bus_reset(struct ata_port *ap)
 	if (ap->flags & (ATA_FLAG_SATA_RESET | ATA_FLAG_SRST)) {
 		/* set up device control for ATA_FLAG_SATA_RESET */
 		iowrite8(ap->ctl, ioaddr->ctl_addr);
+		ap->last_ctl = ap->ctl;
 	}
 
 	DPRINTK("EXIT\n");
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 7007edd..74b1080 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -2218,12 +2218,13 @@ static irqreturn_t mv_interrupt(int irq, void *dev_instance)
 		else
 			handled = mv_host_intr(host, pending_irqs);
 	}
-	spin_unlock(&host->lock);
 
 	/* for MSI: unmask; interrupt cause bits will retrigger now */
 	if (using_msi)
 		writel(hpriv->main_irq_mask, hpriv->main_irq_mask_addr);
 
+	spin_unlock(&host->lock);
+
 	return IRQ_RETVAL(handled);
 }
 
