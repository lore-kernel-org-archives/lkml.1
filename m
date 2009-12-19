Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbZLSA1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbZLSA1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 19:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755699AbZLSA1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 19:27:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:36883 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755657AbZLSA1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 19:27:31 -0500
Message-ID: <4B2C1DA9.4030907@kernel.org>
Date: Fri, 18 Dec 2009 16:26:17 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 2/12] pci: add pci_bridge_release_unused_res and pci_bus_release_unused_bridge_res
 -v2
References: <4B2BE9DD.3040504@kernel.org> <4B2BEC1B.9090104@kernel.org> <alpine.LFD.2.00.0912181316190.3712@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912181316190.3712@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 18 Dec 2009, Yinghai Lu wrote:
>> so later we could use it to release small resource before pci assign unassign res
> 
> However, I think this one is wrong.
> 
>> +static void release_child_resources(struct resource *r)
>> +{
>> +	struct resource *p;
>> +	resource_size_t size;
>> +
>> +	p = r->child;
>> +	while (p) {
>> +		release_child_resources(p);
>> +		release_resource(p);
> 
> So not only is this releasing resources that aren't necessarily PCI 
> devices, it's releasing the whole tree - regardless of how they were 
> allocated and initialized. That makes me nervous to begin with. It's in 
> the wrong file.
> 
> But the locking is crap too!
> 
> You need to hold the resource lock for the whole operation - you can't 
> just walk the resource tree and release them.
> 
> And once you do that, then using "release_resrouce()" is the wrong thing, 
> since it turns into just "__release_resource()" and you notice that that 
> walks the chain looking for them - which makes it pointless to have 
> _another_ outer loop that walks the chain to release them!
> 
> So you'd need to
> 
>  - move this to kernel/resource.c
> 
>  - do it all under 'write_lock(&resource_lock);'
> 
>  - stop the silly double list loop, and just do it as a single loop that 
>    does
> 
> 	p = old->parent->child;
> 	old->parent = NULL;
> 	while (p) {
> 		struct resource *tmp = p;
> 		p = p->sibling;
> 
> 		.. do whatever you do to free tmp ..
> 	}
> 
>    and it's much simpler, more efficient, has the rigth locking, and is in 
>    the right place.

ok, please check attached is right or not

> 
> That said, it's still unclear if you can ever do this! Why would the PCI 
> layer be allowed to release ACPI resources int he tree, for example?
> 
> So I can see fixing the _implementation_ issues I have like above, but I'd 
> still be nervous about the whole concept of the patch..

those code are only called during early stage when pci_assign unassigned, and pcie hotplug under the pcie port.
also that is the pci_try_num is default to 1, and only be changed by pci=try=2 etc. only second try start to call
those functions.

Thanks

Yinghai


Subject: [PATCH 2/12] pci: add pci_bridge_release_unused_res and pci_bus_release_unused_bridge_res -v3

so later we could use it to release small resource before pci assign unassign res

-v2: change name to release_child_resources according to Jesse
-v3: according to Linus, move release_child_resources to resource.c
     also need to put the lock around them all to avoid recursive deep.
     (my test case only have one level that need to be released)

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |   95 +++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/ioport.h  |    1 
 kernel/resource.c       |   30 +++++++++++++++
 3 files changed, 125 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -209,7 +209,6 @@ static void pci_setup_bridge_mmio_pref(s
 		l = (region.start >> 16) & 0xfff0;
 		l |= region.end & 0xfff00000;
 		if (res->flags & IORESOURCE_MEM_64) {
-			pref_mem64 = 1;
 			bu = upper_32_bits(region.start);
 			lu = upper_32_bits(region.end);
 		}
@@ -608,6 +607,100 @@ void __ref pci_bus_assign_resources(cons
 }
 EXPORT_SYMBOL(pci_bus_assign_resources);
 
+static void pci_bridge_release_unused_res(struct pci_bus *bus,
+					  unsigned long type)
+{
+	int idx;
+	bool changed = false;
+	struct pci_dev *dev;
+	struct resource *r;
+	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
+				  IORESOURCE_PREFETCH;
+
+	/* for pci bridges res only */
+	dev = bus->self;
+	for (idx = PCI_BRIDGE_RESOURCES; idx < PCI_BRIDGE_RESOURCES + 3;
+	    idx++) {
+		r = &dev->resource[idx];
+		if ((r->flags & type_mask) != type)
+			continue;
+		if (!r->parent)
+			continue;
+		/*
+		 * if there are children under that, we should release them
+		 *  all
+		 */
+		release_child_resources(r);
+		if (!release_resource(r)) {
+			dev_printk(KERN_DEBUG, &dev->dev,
+				 "resource %d %pR released\n", idx, r);
+			/* keep the old size */
+			r->end = resource_size(r) - 1;
+			r->start = 0;
+			r->flags = 0;
+			changed = true;
+		}
+	}
+
+	if (changed) {
+		if (type & IORESOURCE_PREFETCH) {
+			/* avoiding touch the one without PREF */
+			type = IORESOURCE_PREFETCH;
+		}
+		__pci_setup_bridge(bus, type);
+	}
+}
+
+/*
+ * try to release pci bridge resources that is from leaf bridge,
+ * so we can allocate big new one later
+ * check:
+ *    0: only release the bridge and only the bridge is leaf
+ *    1: release all down side bridge for third shoot
+ */
+static void __ref pci_bus_release_unused_bridge_res(struct pci_bus *bus,
+						    unsigned long type,
+						    int check_leaf)
+{
+	struct pci_dev *dev;
+	bool is_leaf_bridge = true;
+
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		struct pci_bus *b = dev->subordinate;
+		if (!b)
+			continue;
+
+		switch (dev->class >> 8) {
+		case PCI_CLASS_BRIDGE_CARDBUS:
+			is_leaf_bridge = false;
+			break;
+
+		case PCI_CLASS_BRIDGE_PCI:
+		default:
+			is_leaf_bridge = false;
+			if (!check_leaf)
+				pci_bus_release_unused_bridge_res(b, type,
+							 check_leaf);
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
+		if ((check_leaf && is_leaf_bridge) || !check_leaf)
+			pci_bridge_release_unused_res(bus, type);
+		break;
+	}
+}
+
 static void pci_bus_dump_res(struct pci_bus *bus)
 {
         int i;
Index: linux-2.6/include/linux/ioport.h
===================================================================
--- linux-2.6.orig/include/linux/ioport.h
+++ linux-2.6/include/linux/ioport.h
@@ -112,6 +112,7 @@ extern struct resource iomem_resource;
 
 extern int request_resource(struct resource *root, struct resource *new);
 extern int release_resource(struct resource *new);
+void release_child_resources(struct resource *new);
 extern void reserve_region_with_split(struct resource *root,
 			     resource_size_t start, resource_size_t end,
 			     const char *name);
Index: linux-2.6/kernel/resource.c
===================================================================
--- linux-2.6.orig/kernel/resource.c
+++ linux-2.6/kernel/resource.c
@@ -188,6 +188,36 @@ static int __release_resource(struct res
 	return -EINVAL;
 }
 
+static void __release_child_resources(struct resource *r)
+{
+	struct resource *tmp, *p;
+	resource_size_t size;
+
+	p = r->child;
+	r->child = NULL;
+	while (p) {
+		tmp = p;
+		p = p->sibling;
+
+		tmp->parent = NULL;
+		tmp->sibling = NULL;
+		__release_child_resources(tmp);
+
+		printk(KERN_DEBUG "release child resource %pR\n", tmp);
+		/* need to restore size, and keep flags */
+		size = resource_size(tmp);
+		tmp->start = 0;
+		tmp->end = size - 1;
+	}
+}
+
+void release_child_resources(struct resource *r)
+{
+	write_lock(&resource_lock);
+	__release_child_resources(r);
+	write_unlock(&resource_lock);
+}
+
 /**
  * request_resource - request and reserve an I/O or memory resource
  * @root: root resource descriptor

