Return-Path: <linux-kernel-owner+w=401wt.eu-S1753099AbYGYNxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbYGYNxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 09:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbYGYNxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 09:53:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbYGYNxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 09:53:40 -0400
Date: Fri, 25 Jul 2008 15:53:29 +0200
From: Michal Schmidt <mschmidt@redhat.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Vrabel <david.vrabel@csr.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: PCI: MSI interrupts masked using prohibited method
Message-ID: <20080725155329.79821436@brian.englab.brq.redhat.com>
In-Reply-To: <20080725134252.GG6701@parisc-linux.org>
References: <4860D09D.4060801@csr.com>
	<48807166.9010006@csr.com>
	<20080722155629.1160635e@brian.englab.brq.redhat.com>
	<200807221052.26879.jbarnes@virtuousgeek.org>
	<20080725152918.43bf3100@brian.englab.brq.redhat.com>
	<20080725134252.GG6701@parisc-linux.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008 07:42:52 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Fri, Jul 25, 2008 at 03:29:18PM +0200, Michal Schmidt wrote:
> > The interesting thing is that I can see Destination ID bits of MSI
> > Message Address change correctly in lspci output. But the interrupt
> > is still delivered load-balanced to all CPUs even though the
> > Destination ID identifies the single CPU I asked for. It seems the
> > device only takes the new Message Address setting into account when
> > the MSI Enable bit in the Message Control register is changed from
> > 0 to 1. I tested this by setting the MSI enable bit to 0 and then
> > immediately back to 1 at the end of
> > io_apic_64.c:set_msi_irq_affinity().
> > 
> > Is this a permitted behaviour for the device? I couldn't find
> > anything in the PCI specification that would mentioned it.
> 
> I don't think that's necessary.  However, the thought occurs that we
> ought to disable MSI, then write the address, then re-enable MSI.  It
> doesn't cause a problem at the moment because we don't change the
> top 32 bits of the address (at least on any of my systems ..) but
> theoretically if we were to use a 64-bit address, we would experience
> MSIs being sent to an address that was a mixture of the top 32 bits of
> the old address and the bottom 32 bits of the new address.
> 
> We definitely can already get tearing when we've written the lower
> address register but not the data register yet (also true for MSIX, by
> the way).  So we ought to fix this properly.
> 
> We have the problem that we might still get interrupts on the old
> pin-based interrupt line (ie David's original problem).  I have a
> feeling somebody needs to register a handler for the pin-based
> interrupt to handle this.  One possibility would be for the MSI code
> to register a handler that calls the driver's MSI handler.  I don't
> think that's a good idea though -- the driver's MSI handler is able
> to make different assumptions from the pin handler.  Do we want to
> make drivers register an interrupt handler for the original interrupt
> number before they try to set up MSI?  It's certainly not what the
> PCI spec people had in mind, but they seem to have overlooked this
> problem.
> 
> Yuck.

Maybe we should just not use MSI for devices without maskbits.
What would you think of this patch?:

This adds the parameter pci=msimaskbits to enable MSI only for devices with
maskbits. It is useful when setting of IRQ SMP affinity is needed, because
smp_affinity does not work reliably for MSI interrupts of devices without
maskbits.

And maybe this behaviour should be the default?

Michal

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 15af618..2771356 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -23,6 +23,7 @@
 #include "pci.h"
 #include "msi.h"
 
+/* 0 = disabled, 1 = enabled, 2 = enabled only for devices with mask bits */
 static int pci_msi_enable = 1;
 
 /* Arch hooks */
@@ -356,8 +357,13 @@ static int msi_capability_init(struct pci_dev *dev)
 
 	msi_set_enable(dev, 0);	/* Ensure msi is disabled as I set it up */
 
-   	pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
+	pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
 	pci_read_config_word(dev, msi_control_reg(pos), &control);
+	if (pci_msi_enable == 2 && !is_mask_bit_support(control)) {
+		dev_info(&dev->dev,
+			"does not support maskbits, will not use MSI\n");
+		return -ENODEV;
+	}
 	/* MSI Entry Initialization */
 	entry = alloc_msi_entry();
 	if (!entry)
@@ -749,6 +755,11 @@ void pci_no_msi(void)
 	pci_msi_enable = 0;
 }
 
+void pci_msi_require_mask_bits(void)
+{
+	pci_msi_enable = 2;
+}
+
 void pci_msi_init_pci_dev(struct pci_dev *dev)
 {
 	INIT_LIST_HEAD(&dev->msi_list);
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index d00f0e0..0e6019d 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1868,6 +1868,8 @@ static int __devinit pci_setup(char *str)
 		if (*str && (str = pcibios_setup(str)) && *str) {
 			if (!strcmp(str, "nomsi")) {
 				pci_no_msi();
+			} else if (!strcmp(str, "msimaskbits")) {
+				pci_msi_require_mask_bits();
 			} else if (!strcmp(str, "noaer")) {
 				pci_no_aer();
 			} else if (!strcmp(str, "nodomains")) {
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index d807cd7..2af4750 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -85,9 +85,11 @@ extern unsigned int pci_pm_d3_delay;
 
 #ifdef CONFIG_PCI_MSI
 void pci_no_msi(void);
+void pci_msi_require_mask_bits(void);
 extern void pci_msi_init_pci_dev(struct pci_dev *dev);
 #else
 static inline void pci_no_msi(void) { }
+static inline void pci_msi_require_mask_bits(void) { }
 static inline void pci_msi_init_pci_dev(struct pci_dev *dev) { }
 #endif
 
