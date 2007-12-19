Return-Path: <linux-kernel-owner+w=401wt.eu-S1752145AbXLSFMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbXLSFMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 00:12:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbXLSFL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 00:11:57 -0500
Received: from gate.crashing.org ([63.228.1.57]:55050 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbXLSFL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 00:11:56 -0500
Subject: [RFC/PATCH]] x86: pci: Disable IO/Mem on a device when resources
	can't be allocated
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Johannes Weiner <hannes@saeurebad.de>, linux-pci@atrey.karlin.mff.cuni.cz,
       Alan Cox <alan@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
       jgarzik@pobox.com, wingel@nano-system.com,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, james.smart@emulex.com,
       linux-driver@qlogic.com, linux-kernel@vger.kernel.org
In-Reply-To: <20071218123715.A7874@jurassic.park.msu.ru>
References: <1197932473.576079.142524077033.qpush@grosgo>
	 <x7prx4vq3e.fsf@saeurebad.de> <1197936157.13400.9.camel@pasglop>
	 <20071218123715.A7874@jurassic.park.msu.ru>
Content-Type: text/plain
Date: Wed, 19 Dec 2007 16:10:19 +1100
Message-Id: <1198041019.18908.32.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch changes the x86 PCI code to disable IO and/or Memory
decoding on a PCI device when a resource of that type failed to
be allocated.

This is done to avoid having unallocated dangling BARs enabled
that might try to decode on top of other devices.

If a proper resource is assigned later on, then
pci_enable_device{,_io,_mem} will take care of re-enabling
decoding.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

On top of my previous 4 patches to replace pci_enable_device_bars()

I don't have any x86 at hand to test it... this will probably want to
simmer a little bit in -mm, though it shouldn't have any problem of
user setups that don't already have dodgy resource setup. In fact, it
might turn weird latent bugs into right away visible ones.

I'll wait for more comments today and post the whole 5 again tomorrow
as official candidates for inclusion :-) (BTW. What is people general
feeling about inline vs. non inline for the functions in pci.c ?)

Index: linux-merge/arch/x86/pci/i386.c
===================================================================
--- linux-merge.orig/arch/x86/pci/i386.c	2007-12-19 16:00:31.000000000 +1100
+++ linux-merge/arch/x86/pci/i386.c	2007-12-19 16:02:20.000000000 +1100
@@ -143,12 +143,32 @@ static void __init pcibios_allocate_bus_
 	}
 }
 
+static inline int __init pcibios_alloc_resource(struct pci_dev *dev, int idx)
+{
+	struct resource *pr, *r = &dev->resource[idx];
+
+	DBG("PCI: Resource %08lx-%08lx (f=%lx, d=%d, p=%d)\n",
+	    r->start, r->end, r->flags, disabled, pass);
+
+	pr = pci_find_parent_resource(dev, r);
+	if (!pr || request_resource(pr, r) < 0) {
+		printk(KERN_ERR "PCI: Cannot allocate "
+		       "resource region %d of device %s\n",
+		       idx, pci_name(dev));
+		/* We'll assign a new address later */
+		r->end -= r->start;
+		r->start = 0;
+		return -EBUSY;
+	}
+	return 0;
+}
+
 static void __init pcibios_allocate_resources(int pass)
 {
 	struct pci_dev *dev = NULL;
 	int idx, disabled;
 	u16 command;
-	struct resource *r, *pr;
+	struct resource *r;
 
 	for_each_pci_dev(dev) {
 		pci_read_config_word(dev, PCI_COMMAND, &command);
@@ -162,20 +182,11 @@ static void __init pcibios_allocate_reso
 				disabled = !(command & PCI_COMMAND_IO);
 			else
 				disabled = !(command & PCI_COMMAND_MEMORY);
-			if (pass == disabled) {
-				DBG("PCI: Resource %08lx-%08lx "
-				    "(f=%lx, d=%d, p=%d)\n",
-				    r->start, r->end, r->flags, disabled, pass);
-				pr = pci_find_parent_resource(dev, r);
-				if (!pr || request_resource(pr, r) < 0) {
-					printk(KERN_ERR "PCI: Cannot allocate "
-						"resource region %d "
-						"of device %s\n",
-						idx, pci_name(dev));
-					/* We'll assign a new address later */
-					r->end -= r->start;
-					r->start = 0;
-				}
+			if (pass == disabled && pcibios_alloc_resource(dev, idx)) {
+				command &= ~(r->flags & (IORESOURCE_IO |
+							 IORESOURCE_MEM));
+				pci_write_config_word(dev,
+						      PCI_COMMAND, command);
 			}
 		}
 		if (!pass) {


