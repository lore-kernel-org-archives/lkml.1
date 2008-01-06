Return-Path: <linux-kernel-owner+w=401wt.eu-S1759425AbYAFWoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425AbYAFWoq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 17:44:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759155AbYAFWod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 17:44:33 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42418 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758506AbYAFWoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 17:44:30 -0500
Date: Sun, 6 Jan 2008 23:44:29 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, Raymano Garibaldi <raymano@faunos.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [FEATURE REQUEST] Transparent hot plugging
	of root file system on portable storage devices.
Message-ID: <20080106224429.GA1664@elf.ucw.cz>
References: <200801062159.46481.oliver@neukum.org> <Pine.LNX.4.44L0.0801061722400.19222-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.0801061722400.19222-100000@netrider.rowland.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-01-06 17:26:17, Alan Stern wrote:
> On Sun, 6 Jan 2008, Oliver Neukum wrote:
> 
> > Am Sonntag 06 Januar 2008 schrieb Alan Stern:
> > > What about people who want to suspend to RAM instead of hibernating and
> > > _do_ want to unplug the USB device containing their root filesystem
> > > while the machine is asleep? 

Ok, I guess I'm lost here. That sounds like a nice way to do
self-leg-shooting. Are there such people?

> > >  In this case we will _know_ that the
> > > power session has been interrupted, but USB Persist won't activate
> > > because the host controller never lost power.
> > 
> > Would it be hard to force the persist feature on for a replugged device?
> 
> Right now the persist feature is enabled by a per-device boolean flag.  
> In theory the flag could accept 3 values: off, on if power was lost,
> or on for any resume transition.  This would not be a hard change.

But do we need it?

Did you progress on "usb-storage-autosuspend"?

Here are my hacks to try to get SATA to survive autosuspend;
unfortunately they do not work :-(.
									Pavel



diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 54f38c2..21e6709 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1808,8 +1808,22 @@ static void ahci_thaw(struct ata_port *a
 	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
 }
 
+struct pci_dev *my_pdev;
+
 static void ahci_error_handler(struct ata_port *ap)
 {
+	struct ata_host *host = ap->host;
+	int rc;
+	extern int slept;
+	
+	if (slept) {
+		printk("ahci_error_handler: Resuming...\n");
+		rc =ahci_pci_device_resume(my_pdev);
+		     printk("ahci: bad %d\n", rc);
+
+		printk("ahci_error_handler: Device resumed?\n");
+	}
+
 	if (!(ap->pflags & ATA_PFLAG_FROZEN)) {
 		/* restart engine */
 		ahci_stop_engine(ap);
@@ -1945,7 +1959,7 @@ static int ahci_pci_device_resume(struct
 	if (rc)
 		return rc;
 
-	if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
+	if (1) {
 		rc = ahci_reset_controller(host);
 		if (rc)
 			return rc;
@@ -2179,6 +2193,7 @@ static void ahci_p5wdh_workaround(struct
 	}
 }
 
+
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
@@ -2190,6 +2205,7 @@ static int ahci_init_one(struct pci_dev 
 	int i, rc;
 
 	VPRINTK("ENTER\n");
+	my_pdev = pdev;
 
 	WARN_ON(ATA_MAX_QUEUE > AHCI_MAX_CMDS);
 
@@ -2283,8 +2299,11 @@ static int ahci_init_one(struct pci_dev 
 	ahci_print_info(host);
 
 	pci_set_master(pdev);
-	return ata_host_activate(host, pdev->irq, ahci_interrupt, IRQF_SHARED,
+
+	rc = ata_host_activate(host, pdev->irq, ahci_interrupt, IRQF_SHARED,
 				 &ahci_sht);
+	pci_save_state(pdev);
+	return rc;
 }
 
 static int __init ahci_init(void)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
