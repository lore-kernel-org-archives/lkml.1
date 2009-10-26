Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbZJZVX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbZJZVX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 17:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbZJZVX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 17:23:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:46344 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803AbZJZVXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 17:23:55 -0400
Message-ID: <4AE6135B.2070003@kernel.org>
Date: Mon, 26 Oct 2009 14:23:39 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] pci: only release that resource index is less than 3
References: <4AE2C827.8040905@kernel.org>	<200910261032.58231.bjorn.helgaas@hp.com> <20091026101942.578f41b2@jbarnes-g45>
In-Reply-To: <20091026101942.578f41b2@jbarnes-g45>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Mon, 26 Oct 2009 10:32:57 -0600
> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> 
>> On Saturday 24 October 2009 03:25:59 am Yinghai Lu wrote:
>>> after
>>>
>>> | commit 308cf8e13f42f476dfd6552aeff58fdc0788e566
>>> |
>>> |    PCI: get larger bridge ranges when space is available
>>>
>>> found one of resource of peer root bus (0x00) get released from root
>>> resource. later one hotplug device can not get big range anymore.
>>> other peer root buses is ok.
>>>
>>> it turns out it is from transparent path.
>>>
>>> those resources will be used for pci bridge BAR updated.
>>> so need to limit it to 3.
>>>
>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>
>>> ---
>>>  drivers/pci/setup-bus.c |    9 +++++++--
>>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>>
>>> Index: linux-2.6/drivers/pci/setup-bus.c
>>> ===================================================================
>>> --- linux-2.6.orig/drivers/pci/setup-bus.c
>>> +++ linux-2.6/drivers/pci/setup-bus.c
>>> @@ -344,9 +344,14 @@ static struct resource *find_free_bus_re
>>>  			 * if there is no child under that, we
>>> should release
>>>  			 * and use it. don't need to reset it,
>>> pbus_size_* will
>>>  			 * set it again
>>> +			 * need to be less 3, otherwise can not
>>> write it to
>>> +			 * bridge, also need to avoid releasing it
>>> from
>>> +			 * transparent bus path
>>>  			 */
>>> -			if (!r->child && !release_resource(r))
>>> -				return r;
>>> +			if (i < 3 && !r->child) {
>>> +				if (!release_resource(r))
>>> +					return r;
>>> +			}
>> I am bewildered.
>>
>> 308cf8e13f42f added the release_resource() call here in
>> find_free_bus_resource().  I don't understand why the release
>> should be there in the first place -- it doesn't seem to
>> logically fit there.  A "release" should be connected to an
>> event, maybe a hot-remove or a move of a device from one place
>> to another.  It shouldn't be something we do as a side-effect
>> of searching for a free resource.
>>
>> Now you're adding the magic number "3", which seems even less
>> related to the job of "finding an available bus resource."  I'm
>> guessing the "3" is related to PCI_BRIDGE_RESOURCES or something,
>> but that should be made explicit, and I really don't think it
>> belongs in this function.
> 
> I agree, the 3 is a bit of magic.  The free could probably be shuffled
> around a bit too, though it really is related to finding bus
> resources.  I was a bit ambivalent about putting it in
> find_free_bus_resources but when I started a reply to Yinghai and
> looked for a better place it made some sense to leave it as-is.
> 
> But if we're going to be adding more logic here, we should probably
> figure out a better way of doing it, maybe by adding a new pass to do
> the freeing?  I know we've avoided modifying bus resources too much in
> the past, but I think that'll be harder and harder to avoid as Windows
> moves to that model and platforms begin to expect it.

not sure if you like this version. it need more lines changes.

[PATCH] pci: only release that resource index is less than 3 -v2


after

| commit 308cf8e13f42f476dfd6552aeff58fdc0788e566
|
|    PCI: get larger bridge ranges when space is available

found one of resource of peer root bus (0x00) get released from root
resource. later one hotplug device can not get big range anymore.
other peer root buses is ok.

it turns out it is from transparent path.

those resources will be used for pci bridge BAR updated.
so need to limit it to 3.

v2: Jesse doesn't like it is in find_free_bus_resource...
    try to move out of pci_bus_size_bridges loop.
need to apply after:
	[PATCH] pci: pciehp update the slot bridge res to get big range for pcie devices - v3

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/hotplug/pciehp_pci.c |    1 
 drivers/pci/setup-bus.c          |   83 +++++++++++++++++++++++++++++++++------
 include/linux/pci.h              |    1 
 3 files changed, 74 insertions(+), 11 deletions(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -322,33 +322,54 @@ static void pci_bridge_check_ranges(stru
 	}
 }
 
-/* Helper function for sizing routines: find first available
-   bus resource of a given type. Note: we intentionally skip
-   the bus resources which have already been assigned (that is,
-   have non-NULL parent resource). */
-static struct resource *find_free_bus_resource(struct pci_bus *bus, unsigned long type)
+void pci_bridge_release_not_used_res(struct pci_bus *bus)
 {
 	int i;
 	struct resource *r;
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
 				  IORESOURCE_PREFETCH;
 
-	for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
+	/* for pci bridges res only */
+	for (i = 0; i < 3; i++) {
 		r = bus->resource[i];
-		if (r == &ioport_resource || r == &iomem_resource)
-			continue;
-		if (r && (r->flags & type_mask) == type) {
+		if (r && (r->flags & type_mask)) {
 			if (!r->parent)
-				return r;
+				continue;
 			/*
 			 * if there is no child under that, we should release
 			 * and use it. don't need to reset it, pbus_size_* will
 			 * set it again
 			 */
 			if (!r->child && !release_resource(r))
-				return r;
+				dev_printk(KERN_DEBUG, &bus->dev,
+					   "resource %d %s %pR released\n", i,
+					   (r->flags & IORESOURCE_IO) ? "io: " :
+					    ((r->flags & IORESOURCE_PREFETCH)?
+						 "pref mem":"mem:"),
+					   r);
 		}
 	}
+}
+EXPORT_SYMBOL(pci_bridge_release_not_used_res);
+
+/* Helper function for sizing routines: find first available
+   bus resource of a given type. Note: we intentionally skip
+   the bus resources which have already been assigned (that is,
+   have non-NULL parent resource). */
+static struct resource *find_free_bus_resource(struct pci_bus *bus, unsigned long type)
+{
+	int i;
+	struct resource *r;
+	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
+				  IORESOURCE_PREFETCH;
+
+	for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
+		r = bus->resource[i];
+		if (r == &ioport_resource || r == &iomem_resource)
+			continue;
+		if (r && (r->flags & type_mask) == type && !r->parent)
+			return r;
+	}
 	return NULL;
 }
 
@@ -588,6 +609,41 @@ void __ref pci_bus_size_bridges(struct p
 }
 EXPORT_SYMBOL(pci_bus_size_bridges);
 
+static void pci_bus_release_bridges_not_used_res(struct pci_bus *bus)
+{
+	struct pci_dev *dev;
+
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		struct pci_bus *b = dev->subordinate;
+		if (!b)
+			continue;
+
+		switch (dev->class >> 8) {
+		case PCI_CLASS_BRIDGE_CARDBUS:
+			break;
+
+		case PCI_CLASS_BRIDGE_PCI:
+		default:
+			pci_bus_release_bridges_not_used_res(b);
+			break;
+		}
+	}
+
+	/* The root bus? */
+	if (!bus->self)
+		return;
+
+	switch (bus->self->class >> 8) {
+	case PCI_CLASS_BRIDGE_CARDBUS:
+		break;
+
+	case PCI_CLASS_BRIDGE_PCI:
+	default:
+		pci_bridge_release_not_used_res(bus);
+		break;
+	}
+}
+
 void __ref pci_bridge_assign_resources(const struct pci_dev *bridge)
 {
 	struct pci_bus *b;
@@ -687,6 +743,11 @@ pci_assign_unassigned_resources(void)
 {
 	struct pci_bus *bus;
 
+	/* Try to release bridge resources, that there is not child under it */
+	list_for_each_entry(bus, &pci_root_buses, node) {
+		pci_bus_release_bridges_not_used_res(bus);
+	}
+
 	/* Depth first, calculate sizes and alignments of all
 	   subordinate buses. */
 	list_for_each_entry(bus, &pci_root_buses, node) {
Index: linux-2.6/drivers/pci/hotplug/pciehp_pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/pciehp_pci.c
+++ linux-2.6/drivers/pci/hotplug/pciehp_pci.c
@@ -171,6 +171,7 @@ int pciehp_unconfigure_device(struct slo
 		}
 		pci_dev_put(temp);
 	}
+	pci_bridge_release_not_used_res(parent);
 
 	return rc;
 }
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -759,6 +759,7 @@ int pci_vpd_truncate(struct pci_dev *dev
 void pci_bridge_assign_resources(const struct pci_dev *bridge);
 void pci_bus_assign_resources(const struct pci_bus *bus);
 void pci_bus_size_bridges(struct pci_bus *bus);
+void pci_bridge_release_not_used_res(struct pci_bus *bus);
 int pci_claim_resource(struct pci_dev *, int);
 void pci_assign_unassigned_resources(void);
 void pdev_enable_device(struct pci_dev *);
