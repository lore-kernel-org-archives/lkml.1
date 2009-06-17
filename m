Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbZFQJOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbZFQJOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 05:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764988AbZFQJNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 05:13:50 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48436 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757924AbZFQJNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 05:13:47 -0400
Message-ID: <4A38B3B4.1020304@jp.fujitsu.com>
Date: Wed, 17 Jun 2009 18:13:24 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andrew Patterson <andrew.patterson@hp.com>
CC: linux-pci@vger.kernel.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org
Subject: Re: [PATCH 0/1] Recurse when searching for empty slots in resources
 trees
References: <20090616220419.14021.84524.stgit@bob.kio>
In-Reply-To: <20090616220419.14021.84524.stgit@bob.kio>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Patterson wrote:
> I recently ran into a resource collision problem where PCI hot-plug
> operations are failing for certain PCI topologies.  One case
> illustrating the problem is using a QLogic PCIe HBA in a slot with a
> PCIe root port as its parent bus.  Here is an abbreviated lspci output
> for this topology:
> 
> -+-[0000:c2]---00.0-[0000:c3-fb]--+-00.0  QLogic Corp. 8Gb Fibre Channel HBA
>  |                                \-00.1  QLogic Corp. 8Gb Fibre Channel HBA
> 
> 
> 
> c2:00.0 PCI bridge: PCIe Root Port (prog-if 00 [Normal decode])
> 	Bus: primary=c2, secondary=c3, subordinate=fb, sec-latency=0
> 	I/O behind bridge: 00001000-0000ffff
> 	Memory behind bridge: f0000000-fdffffff
> 	Prefetchable memory behind bridge: 0000080780000000-00000807ffffffff
> 
> c3:00.0 Fibre Channel: QLogic Corp. 8Gb Fibre Channel HBA
> 	Region 0: I/O ports at 8001100 [size=256]
> 	Region 1: Memory at f0284000 (64-bit, non-prefetchable) [size=16K]
> 	Region 3: Memory at f0100000 (64-bit, non-prefetchable) [size=1M]
> 	Expansion ROM at f0240000 [disabled] [size=256K]
> 
> c3:00.1 Fibre Channel: QLogic Corp. 8Gb Fibre Channel HBA
> 	Region 0: I/O ports at 8001000 [size=256]
> 	Region 1: Memory at f0280000 (64-bit, non-prefetchable) [size=16K]
> 	Region 3: Memory at f0000000 (64-bit, non-prefetchable) [size=1M]
> 	Expansion ROM at f0200000 [disabled] [size=256K]
> 
> After boot, the resource tree looks like:
> 
> f0000000-fdffffff : PCI Bus 0000:c3
>   f0000000-fdffffff : PCI Bus 0000:c2
>     f0000000-f00fffff : 0000:c3:00.1
>       f0000000-f00fffff : qla2xxx
>     f0100000-f01fffff : 0000:c3:00.0
>       f0100000-f01fffff : qla2xxx
>     f0200000-f023ffff : 0000:c3:00.1
>     f0240000-f027ffff : 0000:c3:00.0
>     f0280000-f0283fff : 0000:c3:00.1
>       f0280000-f0283fff : qla2xxx
>     f0284000-f0287fff : 0000:c3:00.0
>       f0284000-f0287fff : qla2xxx
> 
> Note that PCI Bus 0000:c2 is a child of PCI Bus 0000:c3 and has an
> identical address range.

According to the lspci output, PCI Bus 0000:c2 is a parent of PCI
Bus 0000:c3. But they are upside down in resource tree. I guess
this is the root cause of the problem.

I think the reason why it happen is ia64 (I believe you are using
ia64 environment) uses pci_claim_resource(), which calls
insert_resource(), to insert resources. In my understanding, if
two resources having an identical address range are inserted using
insert_resource(), the latter one  becomes parent of the first one.

I made a sample patch, though I don't know if it fixes the problem.
I hope this would help you. But please note that it is NOT well
tested.

Thanks,
Kenji Kaneshige



 arch/ia64/pci/pci.c |   32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

Index: 20090612/arch/ia64/pci/pci.c
===================================================================
--- 20090612.orig/arch/ia64/pci/pci.c
+++ 20090612/arch/ia64/pci/pci.c
@@ -301,9 +301,10 @@ static __devinit acpi_status add_window(
 }
 
 static void __devinit
-pcibios_setup_root_windows(struct pci_bus *bus, struct pci_controller *ctrl)
+pcibios_setup_root_windows(struct pci_bus *bus)
 {
 	int i, j;
+	struct pci_controller *ctrl = bus->sysdata;
 
 	j = 0;
 	for (i = 0; i < ctrl->windows; i++) {
@@ -371,9 +372,6 @@ pci_acpi_scan_root(struct acpi_device *d
 	 * such quirk. So we just ignore the case now.
 	 */
 	pbus = pci_scan_bus_parented(NULL, bus, &pci_root_ops, controller);
-	if (pbus)
-		pcibios_setup_root_windows(pbus, controller);
-
 	return pbus;
 
 out3:
@@ -456,15 +454,29 @@ pcibios_fixup_resources(struct pci_dev *
 {
 	struct pci_bus_region region;
 	int i;
+	struct resource *devr, *busr;
 
 	for (i = start; i < limit; i++) {
-		if (!dev->resource[i].flags)
+		char *dtype = i < PCI_BRIDGE_RESOURCES ? "device" : "bridge";
+
+		devr = &dev->resource[i];
+		if (!devr->flags)
 			continue;
+
 		region.start = dev->resource[i].start;
 		region.end = dev->resource[i].end;
-		pcibios_bus_to_resource(dev, &dev->resource[i], &region);
-		if ((is_valid_resource(dev, i)))
-			pci_claim_resource(dev, i);
+		pcibios_bus_to_resource(dev, devr, &region);
+		if (!is_valid_resource(dev, i))
+			continue;
+
+		busr = pci_find_parent_resource(dev, devr);
+		if (!busr || request_resource(busr, devr)) {
+			dev_err(&dev->dev, "BAR %d: %s of %s %pR\n", i,
+				busr ? "address space collision on" :
+				"no parent found for",
+				dtype, devr);
+			devr->flags = 0;
+		}
 	}
 }
 
@@ -487,7 +499,9 @@ pcibios_fixup_bus (struct pci_bus *b)
 {
 	struct pci_dev *dev;
 
-	if (b->self) {
+	if (pci_is_root_bus(b))
+		pcibios_setup_root_windows(b);
+	else {
 		pci_read_bridge_bases(b);
 		pcibios_fixup_bridge_resources(b->self);
 	}

