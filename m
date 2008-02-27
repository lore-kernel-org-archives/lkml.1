Return-Path: <linux-kernel-owner+w=401wt.eu-S1757183AbYB0Rme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183AbYB0Rme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 12:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756611AbYB0RmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 12:42:12 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:44590 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808AbYB0RmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 12:42:09 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: a7839e96 (PNP: increase max resources) breaks my ALSA intel8x0 sound card
Date: Wed, 27 Feb 2008 10:43:47 -0700
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Robert Hancock <hancockr@shaw.ca>,
       Andrew Morton <akpm@linux-foundation.org>, avuton@gmail.com,
       yakui.zhao@intel.com, shaohua.li@intel.com, trenn@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
References: <fa.Kmpf0B4W44W1VefIME7+BnfUouY@ifi.uio.no> <200802141713.23461.bjorn.helgaas@hp.com> <alpine.LFD.1.00.0802141620380.6110@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802141620380.6110@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802271043.47763.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2008 05:40:36 pm Linus Torvalds wrote:
> 
> That said, if we really want to handle this, we could certainly add a 
> whole new ioresource flag bit that says "allow inserting resources into 
> this", and we could set that bit not just for the PnP reservations 
> themselves, but in PCI bus resources too.
> 
> Basically, there are two different ways of inserting a resource:
> 
>  - the "register this subresource" thing that "request_resource()" does, 
>    which just works on the one given resource and honors the BUSY bit.
> 
>  - the "insert this resource into the tree" (insert_resource()) that 
>    starts from the root and tries to find the right location. It honors 
>    the BUSY bit too, but we could extend it to _only_ extend into 
>    resources that allow it.

I guess it's time to get back to this problem.

I don't want to make PNP insert resources only at the root.  That
would avoid the ALSA problem because the enclosing PCI resource is
allocated first, but it also precludes us from dealing with lots of
valid ACPI information.  ACPI can describe layers of bridges and
devices behind them.  It don't think we should throw away that
information just to solve this problem.

And I don't really want to add IORESOURCE_INSERT.  It's probably a
useful idea, but I don't think it helps solve *this* problem.  We'd
have to mark both the PCI and the PNP regions as "insert", and I
think we'd end up with the exact same situation we have today:

  febf8000-febfbfff : 0000:00:1b.0 -- from pcibios_resource_survey (!busy)
  febfa000-febfac00 : pnp 00:08    -- from PNP system driver (!busy)
  febf8000-febfbfff : ICH HD audio -- fails; spans part of PNP region

I'm back to the quirk idea, which is still ugly but seems the most
straightforward to me.  Here's my current patch (this won't apply
directly because we'd have to revert the Supermicro-specific quirk
first).

Excuse me a minute while I put on my asbestos underwear.

Bjorn


PNP: disable PNP motherboard resources that overlap PCI BARs

Some BIOSes have PNP motherboard devices with resources that
partially overlap PCI BARs.  The PNP system driver claims these
motherboard resources, which prevents the normal PCI driver from
requesting them later.

This patch disables the PNP resources that conflict with PCI BARs
so they won't be claimed by the PNP system driver.

Of course, this only works if PCI devices have already been enumerated.
Currently, PCI devices are discovered before any PNP init via this path:

    acpi_pci_root_init() -> acpi_pci_root_add() -> pci_acpi_scan_root() ->
	pci_scan_bus_parented() -> pci_scan_child_bus() -> ...

References:
    https://bugzilla.redhat.com/show_bug.cgi?id=280641
    https://bugzilla.redhat.com/show_bug.cgi?id=313491
    http://lkml.org/lkml/2008/1/9/449
    http://thread.gmane.org/gmane.linux.acpi.devel/27312
    http://lkml.org/lkml/2008/1/27/168

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work7/drivers/pnp/quirks.c
===================================================================
--- work7.orig/drivers/pnp/quirks.c	2008-02-27 10:17:40.000000000 -0700
+++ work7/drivers/pnp/quirks.c	2008-02-27 10:19:35.000000000 -0700
@@ -108,6 +108,77 @@
 		       "pnp: SB audio device quirk - increasing port range\n");
 }
 
+
+#include <linux/pci.h>
+
+static void quirk_system_pci_resources(struct pnp_dev *dev)
+{
+	struct pci_dev *pdev = NULL;
+	resource_size_t pnp_start, pnp_end, pci_start, pci_end;
+	int i, j;
+
+	/*
+	 * Some BIOSes have PNP motherboard devices with resources that
+	 * partially overlap PCI BARs.  The PNP system driver claims these
+	 * motherboard resources, which prevents the normal PCI driver from
+	 * requesting them later.
+	 *
+	 * This patch disables the PNP resources that conflict with PCI BARs
+	 * so they won't be claimed by the PNP system driver.
+	 */
+	for_each_pci_dev(pdev) {
+		for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
+			if (!(pci_resource_flags(pdev, i) & IORESOURCE_MEM) ||
+			    pci_resource_len(pdev, i) == 0)
+				continue;
+
+			pci_start = pci_resource_start(pdev, i);
+			pci_end = pci_resource_end(pdev, i);
+			for (j = 0; j < PNP_MAX_MEM; j++) {
+				if (!pnp_mem_valid(dev, j) ||
+				    pnp_mem_len(dev, j) == 0)
+					continue;
+
+				pnp_start = pnp_mem_start(dev, j);
+				pnp_end = pnp_mem_end(dev, j);
+
+				/*
+				 * If the PNP region doesn't overlap the PCI
+				 * region at all, there's no problem.
+				 */
+				if (pnp_end < pci_start || pnp_start > pci_end)
+					continue;
+
+				/*
+				 * If the PNP region completely encloses (or is
+				 * at least as large as) the PCI region, that's
+				 * also OK.  For example, this happens when the
+				 * PNP device describes a bridge with PCI
+				 * behind it.
+				 */
+				if (pnp_start <= pci_start &&
+				    pnp_end >= pci_end)
+					continue;
+
+				/*
+				 * Otherwise, the PNP region overlaps *part* of
+				 * the PCI region, and that might prevent a PCI
+				 * driver from requesting its resources.
+				 */
+				dev_warn(&dev->dev, "mem resource "
+					"(0x%llx-0x%llx) overlaps %s BAR %d "
+					"(0x%llx-0x%llx), disabling\n",
+					(unsigned long long) pnp_start,
+					(unsigned long long) pnp_end,
+					pci_name(pdev), i,
+					(unsigned long long) pci_start,
+					(unsigned long long) pci_end);
+				pnp_mem_flags(dev, j) = 0;
+			}
+		}
+	}
+}
+
 /*
  *  PnP Quirks
  *  Cards or devices that need some tweaking due to incomplete resource info
@@ -128,6 +199,8 @@
 	{"CTL0043", quirk_sb16audio_resources},
 	{"CTL0044", quirk_sb16audio_resources},
 	{"CTL0045", quirk_sb16audio_resources},
+	{"PNP0c01", quirk_system_pci_resources},
+	{"PNP0c02", quirk_system_pci_resources},
 	{""}
 };
 
