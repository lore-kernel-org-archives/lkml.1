Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbZJMGMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbZJMGMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 02:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbZJMGMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 02:12:32 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:35746 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbZJMGM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 02:12:29 -0400
Subject: Re: [PATCH] pci: increase alignment to make more space for hidden
	code
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Ricardo Jorge da Fonseca Marques Ferreira 
	<storm@sys49152.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Yannick Roehlly <yannick.roehlly@free.fr>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, x86@kernel.org,
       andreaorru91@gmail.com, jjorge@free.fr
In-Reply-To: <4AD38734.2040600@kernel.org>
References: <200908072333.24631.storm@sys49152.net>
	 <4ACAC8F1.1050706@kernel.org> <4AD24B5C.4050905@kernel.org>
	 <200910121059.10366.bjorn.helgaas@hp.com> <4AD37CA4.90601@kernel.org>
	 <20091012192242.GA2691@elte.hu>  <4AD38734.2040600@kernel.org>
Content-Type: text/plain
Date: Tue, 13 Oct 2009 00:08:35 -0600
Message-Id: <1255414115.14484.47.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-12 at 12:44 -0700, Yinghai Lu wrote:

> [    0.012392] ACPI: Core revision 20090521
> ...
> [    0.117217] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
> [    0.117223] ACPI: bus type pci registered
> [    0.117292] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
> [    0.117297] PCI: Not using MMCONFIG.
> [    0.117301] PCI: Using configuration type 1 for base access
> [    0.118064] bio: create slab <bio-0> at 0
> [    0.118995] ACPI: EC: Look up EC in DSDT
> [    0.125066] ACPI: BIOS _OSI(Linux) query ignored
> [    0.127077] ACPI: EC: non-query interrupt received, switching to interrupt mode
> [    0.632002] ACPI: EC: missing confirmations, switch off interrupt mode.
> [    0.793109] ACPI: Interpreter enabled
> [    0.793114] ACPI: (supports S0 S3 S4 S5)
> [    0.793139] ACPI: Using IOAPIC for interrupt routing
> [    0.793193] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
> [    0.795871] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
> [    0.806419] PCI: Using MMCONFIG at e0000000 - efffffff
> [    0.812767] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
> [    0.812772] ACPI: EC: driver started in poll mode
> [    0.813206] ACPI: No dock devices found.
> [    0.813879] ACPI: PCI Root Bridge [PCI0] (0000:00)
> 
> could be ACPI EC AML code related.
> 
> because with pci=nommconf, the BARs still get cleared.
> 
> need the reporter to boot with acpi.debug_layer=0x400000 acpi.debug_level=
> to get more info

We've established that the bridge and the NIC are handed off from BIOS
like this:

  pci 0000:00:1c.4: bridge io port: [0x3000-0x3fff]
  pci 0000:00:1c.4: bridge 32bit mmio: [0xf4500000-0xf45fffff]
  pci 0000:07:00.0: reg 10 64bit mmio: [0xf4500000-0xf4503fff]
  pci 0000:07:00.0: reg 18 io port: [0x3000-0x30ff]

Unless we boot with "acpi=off", this configuration is lost, and by the
time we discover them, they look like this:

  pci 0000:00:1c.4: bridge io port: [0x00-0xfff]
  pci 0000:00:1c.4: bridge 32bit mmio: [0x000000-0x0fffff]
  pci 0000:00:1c.4: bridge 64bit mmio pref: [0x000000-0x0fffff]
  pci 0000:07:00.0: reg 10 64bit mmio: [0x000000-0x003fff]
  pci 0000:07:00.0: reg 18 io port: [0x00-0xff]

Mystery #1 is why this configuration gets lost, and whether this is
telling us about a Linux defect.  We might get a clue about this if we
could see what resources the NIC uses under Windows.  If it uses the
handoff range (0xf4500000-0xf4503fff), it's likely that Windows managed
to keep the BIOS-programmed resources, and Linux is doing something
wrong.  If it uses some other range, then Windows likely had to
reconfigure the device just like Linux does.

Mystery #2 is why, even with the lost configuration, 2.6.30 configures
the NIC so it works, but 2.6.31 does not.  In 2.6.30, we put the NIC in
the [0xb8000000-0xb80fffff] range, and in 2.6.31, we put it in
[0xb6000000-0xb60fffff].  I'd really like to know what the host bridge
_CRS says.  It's possible that we're only supposed to use the range
above 0xb8000000.  If that's the case, the fact that we're ignoring the
_CRS would be another Linux defect.

In the patch below, I added some extra PCI dumps of the bridge and the
NIC around the ACPI EC init.  The patch also removes Yinghai's
workaround so we should see the original failure, just with a little
more debug.

If anybody can try this, I'd really appreciate it.  Here's what I would
like to see:

  - start with a current git tree (I used 2caa731819a633be)
  - apply the patch below
  - turn on CONFIG_PCI_DEBUG
  - boot with "pci=earlydump", collect dmesg
  - boot with "pci=earlydump,use_crs", collect dmesg
  - boot Windows, collect Device Manager resources for 00:1c.4 and
07:00.0

Bjorn


commit 8b9328483e5991d41e3e30cca2cb1fae9d1126bf
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Oct 12 22:32:55 2009 -0600

diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index 7de76dd..3eeaef8 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -126,6 +126,7 @@ alloc_pci_controller (int seg)
 }
 
 struct pci_root_info {
+	struct acpi_device *bridge;
 	struct pci_controller *controller;
 	char *name;
 };
@@ -292,9 +293,20 @@ static __devinit acpi_status add_window(struct acpi_resource *res, void *data)
 	window->offset = offset;
 
 	if (insert_resource(root, &window->resource)) {
-		printk(KERN_ERR "alloc 0x%llx-0x%llx from %s for %s failed\n",
-			window->resource.start, window->resource.end,
-			root->name, info->name);
+		dev_err(&info->bridge->dev,
+			"can't allocate host bridge window %pR\n",
+			&window->resource);
+	} else {
+		if (offset)
+			dev_info(&info->bridge->dev, "host bridge window %pR "
+				 "(PCI address [%#llx-%#llx])\n",
+				 &window->resource,
+				 window->resource.start - offset,
+				 window->resource.end - offset);
+		else
+			dev_info(&info->bridge->dev,
+				 "host bridge window %pR\n",
+				 &window->resource);
 	}
 
 	return AE_OK;
@@ -314,8 +326,7 @@ pcibios_setup_root_windows(struct pci_bus *bus, struct pci_controller *ctrl)
 		    (res->end - res->start < 16))
 			continue;
 		if (j >= PCI_BUS_NUM_RESOURCES) {
-			printk("Ignoring range [%#llx-%#llx] (%lx)\n",
-					res->start, res->end, res->flags);
+			dev_warn(&bus->dev, "ignoring %pR (no space)\n", res);
 			continue;
 		}
 		bus->resource[j++] = res;
@@ -359,6 +370,7 @@ pci_acpi_scan_root(struct acpi_device *device, int domain, int bus)
 			goto out3;
 
 		sprintf(name, "PCI Bus %04x:%02x", domain, bus);
+		info.bridge = device;
 		info.controller = controller;
 		info.name = name;
 		acpi_walk_resources(device->handle, METHOD_NAME__CRS,
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index d17d482..85419bb 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1378,8 +1378,8 @@ static unsigned long ram_alignment(resource_size_t pos)
 	if (mb < 16)
 		return 1024*1024;
 
-	/* To 64MB for anything above that */
-	return 64*1024*1024;
+	/* To 32MB for anything above that */
+	return 32*1024*1024;
 }
 
 #define MAX_RESOURCE_SIZE ((resource_size_t)-1)
diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 1014eb4..6bf8091 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -7,6 +7,7 @@
 #include <asm/pci_x86.h>
 
 struct pci_root_info {
+	struct acpi_device *bridge;
 	char *name;
 	unsigned int res_num;
 	struct resource *res;
@@ -107,12 +108,19 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
 	res->child = NULL;
 
 	if (insert_resource(root, res)) {
-		printk(KERN_ERR "PCI: Failed to allocate 0x%lx-0x%lx "
-			"from %s for %s\n", (unsigned long) res->start,
-			(unsigned long) res->end, root->name, info->name);
+		dev_err(&info->bridge->dev,
+			"can't allocate host bridge window %pR\n", res);
 	} else {
 		info->bus->resource[info->res_num] = res;
 		info->res_num++;
+		if (addr.translation_offset)
+			dev_info(&info->bridge->dev, "host bridge window %pR "
+				 "(PCI address [%#llx-%#llx])\n",
+				 res, res->start - addr.translation_offset,
+				 res->end - addr.translation_offset);
+		else
+			dev_info(&info->bridge->dev,
+				 "host bridge window %pR\n", res);
 	}
 	return AE_OK;
 }
@@ -124,6 +132,7 @@ get_current_resources(struct acpi_device *device, int busnum,
 	struct pci_root_info info;
 	size_t size;
 
+	info.bridge = device;
 	info.bus = bus;
 	info.res_num = 0;
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, count_resource,
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index b22d13b..e1dcd61 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -129,7 +129,7 @@ static void __init pcibios_allocate_bus_resources(struct list_head *bus_list)
 					continue;
 				if (!r->start ||
 				    pci_claim_resource(dev, idx) < 0) {
-					dev_info(&dev->dev, "BAR %d: can't allocate resource\n", idx);
+					dev_info(&dev->dev, "BAR %d: can't allocate %pR\n", idx, r);
 					/*
 					 * Something is wrong with the region.
 					 * Invalidate the resource to prevent
@@ -137,6 +137,7 @@ static void __init pcibios_allocate_bus_resources(struct list_head *bus_list)
 					 * range.
 					 */
 					r->flags = 0;
+					dev_info(&dev->dev, "BAR %d: invalidated %pR\n", idx, r);
 				}
 			}
 		}
@@ -164,15 +165,15 @@ static void __init pcibios_allocate_resources(int pass)
 			else
 				disabled = !(command & PCI_COMMAND_MEMORY);
 			if (pass == disabled) {
-				dev_dbg(&dev->dev, "resource %#08llx-%#08llx (f=%lx, d=%d, p=%d)\n",
-					(unsigned long long) r->start,
-					(unsigned long long) r->end,
-					r->flags, disabled, pass);
+				dev_dbg(&dev->dev,
+					"BAR %d: claiming %pr (d=%d, p=%d)\n",
+					idx, r, disabled, pass);
 				if (pci_claim_resource(dev, idx) < 0) {
-					dev_info(&dev->dev, "BAR %d: can't allocate resource\n", idx);
+					dev_info(&dev->dev, "BAR %d: can't claim %pR\n", idx, r);
 					/* We'll assign a new address later */
 					r->end -= r->start;
 					r->start = 0;
+					dev_info(&dev->dev, "BAR %d: adjusted start %pR\n", idx, r);
 				}
 			}
 		}
@@ -182,7 +183,7 @@ static void __init pcibios_allocate_resources(int pass)
 				/* Turn the ROM off, leave the resource region,
 				 * but keep it unregistered. */
 				u32 reg;
-				dev_dbg(&dev->dev, "disabling ROM\n");
+				dev_dbg(&dev->dev, "disabling ROM %pR\n", r);
 				r->flags &= ~IORESOURCE_ROM_ENABLE;
 				pci_read_config_dword(dev,
 						dev->rom_base_reg, &reg);
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 7411915..6740a61 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -785,11 +785,13 @@ static int __init acpi_bus_init(void)
 
 struct kobject *acpi_kobj;
 
+#include <asm/pci-direct.h>
+
 static int __init acpi_init(void)
 {
 	int result = 0;
 
-
+	early_dump_pci_device(7, 0, 0);
 	if (acpi_disabled) {
 		printk(KERN_INFO PREFIX "Interpreter disabled.\n");
 		return -ENODEV;
@@ -827,7 +829,9 @@ static int __init acpi_init(void)
 	dmi_check_system(power_nocheck_dmi_table);
 
 	acpi_scan_init();
+	early_dump_pci_device(7, 0, 0);
 	acpi_ec_init();
+	early_dump_pci_device(7, 0, 0);
 	acpi_power_init();
 	acpi_system_init();
 	acpi_debug_init();
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 3835871..832243f 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1669,9 +1669,7 @@ static int __pci_request_region(struct pci_dev *pdev, int bar, const char *res_n
 	return 0;
 
 err_out:
-	dev_warn(&pdev->dev, "BAR %d: can't reserve %s region %pR\n",
-		 bar,
-		 pci_resource_flags(pdev, bar) & IORESOURCE_IO ? "I/O" : "mem",
+	dev_warn(&pdev->dev, "BAR %d: can't reserve %pR\n", bar,
 		 &pdev->resource[bar]);
 	return -EBUSY;
 }
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 8105e32..0199d92 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -222,6 +222,8 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		if (!sz64)
 			goto fail;
 
+		res->flags |= IORESOURCE_MEM_64;
+
 		if ((sizeof(resource_size_t) < 8) && (sz64 > 0x100000000ULL)) {
 			dev_err(&dev->dev, "can't handle 64-bit BAR\n");
 			goto fail;
@@ -234,14 +236,9 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		} else {
 			res->start = l64;
 			res->end = l64 + sz64;
-			dev_printk(KERN_DEBUG, &dev->dev,
-				"reg %x %s: %pR\n", pos,
-				 (res->flags & IORESOURCE_PREFETCH) ?
-					"64bit mmio pref" : "64bit mmio",
-				 res);
+			dev_printk(KERN_DEBUG, &dev->dev, "reg %x: %pR\n",
+				   pos, res);
 		}
-
-		res->flags |= IORESOURCE_MEM_64;
 	} else {
 		sz = pci_size(l, sz, mask);
 
@@ -251,11 +248,7 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		res->start = l;
 		res->end = l + sz;
 
-		dev_printk(KERN_DEBUG, &dev->dev, "reg %x %s: %pR\n", pos,
-			(res->flags & IORESOURCE_IO) ? "io port" :
-			 ((res->flags & IORESOURCE_PREFETCH) ?
-				 "32bit mmio pref" : "32bit mmio"),
-			res);
+		dev_printk(KERN_DEBUG, &dev->dev, "reg %x: %pR\n", pos, res);
 	}
 
  out:
@@ -323,7 +316,7 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 			res->start = base;
 		if (!res->end)
 			res->end = limit + 0xfff;
-		dev_printk(KERN_DEBUG, &dev->dev, "bridge io port: %pR\n", res);
+		dev_printk(KERN_DEBUG, &dev->dev, "bridge window %pR\n", res);
 	}
 
 	res = child->resource[1];
@@ -335,8 +328,7 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		dev_printk(KERN_DEBUG, &dev->dev, "bridge 32bit mmio: %pR\n",
-			res);
+		dev_printk(KERN_DEBUG, &dev->dev, "bridge window %pR\n", res);
 	}
 
 	res = child->resource[2];
@@ -375,9 +367,7 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 			res->flags |= IORESOURCE_MEM_64;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		dev_printk(KERN_DEBUG, &dev->dev, "bridge %sbit mmio pref: %pR\n",
-			(res->flags & PCI_PREF_RANGE_TYPE_64) ? "64" : "32",
-			res);
+		dev_printk(KERN_DEBUG, &dev->dev, "bridge window %pR\n", res);
 	}
 }
 
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index efa6534..d996a2f 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -357,7 +357,7 @@ static void __devinit quirk_io_region(struct pci_dev *dev, unsigned region,
 		pcibios_bus_to_resource(dev, res, &bus_region);
 
 		pci_claim_resource(dev, nr);
-		dev_info(&dev->dev, "quirk: region %04x-%04x claimed by %s\n", region, region + size - 1, name);
+		dev_info(&dev->dev, "quirk: %pR claimed by %s\n", res, name);
 	}
 }	
 
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 0959430..18711cd 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -71,53 +71,62 @@ static void pbus_assign_resources_sorted(const struct pci_bus *bus)
 void pci_setup_cardbus(struct pci_bus *bus)
 {
 	struct pci_dev *bridge = bus->self;
+	struct resource *res;
 	struct pci_bus_region region;
 
 	dev_info(&bridge->dev, "CardBus bridge, secondary bus %04x:%02x\n",
 		 pci_domain_nr(bus), bus->number);
 
-	pcibios_resource_to_bus(bridge, &region, bus->resource[0]);
-	if (bus->resource[0]->flags & IORESOURCE_IO) {
+	res = bus->resource[0];
+	if (res->flags & IORESOURCE_IO) {
 		/*
 		 * The IO resource is allocated a range twice as large as it
 		 * would normally need.  This allows us to set both IO regs.
 		 */
-		dev_info(&bridge->dev, "  IO window: %#08lx-%#08lx\n",
-		       (unsigned long)region.start,
-		       (unsigned long)region.end);
+		pcibios_resource_to_bus(bridge, &region, res);
+		dev_info(&bridge->dev,
+			 "  bridge window %pR (PCI address %#08lx-%#08lx)\n",
+			 res, (unsigned long)region.start,
+		         (unsigned long)region.end);
 		pci_write_config_dword(bridge, PCI_CB_IO_BASE_0,
 					region.start);
 		pci_write_config_dword(bridge, PCI_CB_IO_LIMIT_0,
 					region.end);
 	}
 
-	pcibios_resource_to_bus(bridge, &region, bus->resource[1]);
-	if (bus->resource[1]->flags & IORESOURCE_IO) {
-		dev_info(&bridge->dev, "  IO window: %#08lx-%#08lx\n",
-		       (unsigned long)region.start,
-		       (unsigned long)region.end);
+	res = bus->resource[1];
+	if (res->flags & IORESOURCE_IO) {
+		pcibios_resource_to_bus(bridge, &region, res);
+		dev_info(&bridge->dev,
+			 "  bridge window %pR (PCI address %#08lx-%#08lx)\n",
+			 res, (unsigned long)region.start,
+		         (unsigned long)region.end);
 		pci_write_config_dword(bridge, PCI_CB_IO_BASE_1,
 					region.start);
 		pci_write_config_dword(bridge, PCI_CB_IO_LIMIT_1,
 					region.end);
 	}
 
-	pcibios_resource_to_bus(bridge, &region, bus->resource[2]);
-	if (bus->resource[2]->flags & IORESOURCE_MEM) {
-		dev_info(&bridge->dev, "  PREFETCH window: %#08lx-%#08lx\n",
-		       (unsigned long)region.start,
-		       (unsigned long)region.end);
+	res = bus->resource[2];
+	if (res->flags & IORESOURCE_MEM) {
+		pcibios_resource_to_bus(bridge, &region, res);
+		dev_info(&bridge->dev,
+			 "  bridge window %pR (PCI address %#08lx-%#08lx)\n",
+			 res, (unsigned long)region.start,
+		         (unsigned long)region.end);
 		pci_write_config_dword(bridge, PCI_CB_MEMORY_BASE_0,
 					region.start);
 		pci_write_config_dword(bridge, PCI_CB_MEMORY_LIMIT_0,
 					region.end);
 	}
 
-	pcibios_resource_to_bus(bridge, &region, bus->resource[3]);
-	if (bus->resource[3]->flags & IORESOURCE_MEM) {
-		dev_info(&bridge->dev, "  MEM window: %#08lx-%#08lx\n",
-		       (unsigned long)region.start,
-		       (unsigned long)region.end);
+	res = bus->resource[3];
+	if (res->flags & IORESOURCE_MEM) {
+		pcibios_resource_to_bus(bridge, &region, res);
+		dev_info(&bridge->dev,
+			 "  bridge window %pR (PCI address %#08lx-%#08lx)\n",
+			 res, (unsigned long)region.start,
+		         (unsigned long)region.end);
 		pci_write_config_dword(bridge, PCI_CB_MEMORY_BASE_1,
 					region.start);
 		pci_write_config_dword(bridge, PCI_CB_MEMORY_LIMIT_1,
@@ -140,6 +149,7 @@ EXPORT_SYMBOL(pci_setup_cardbus);
 static void pci_setup_bridge(struct pci_bus *bus)
 {
 	struct pci_dev *bridge = bus->self;
+	struct resource *res;
 	struct pci_bus_region region;
 	u32 l, bu, lu, io_upper16;
 	int pref_mem64;
@@ -151,23 +161,25 @@ static void pci_setup_bridge(struct pci_bus *bus)
 		 pci_domain_nr(bus), bus->number);
 
 	/* Set up the top and bottom of the PCI I/O segment for this bus. */
-	pcibios_resource_to_bus(bridge, &region, bus->resource[0]);
-	if (bus->resource[0]->flags & IORESOURCE_IO) {
+	res = bus->resource[0];
+	if (res->flags & IORESOURCE_IO) {
+		pcibios_resource_to_bus(bridge, &region, res);
 		pci_read_config_dword(bridge, PCI_IO_BASE, &l);
 		l &= 0xffff0000;
 		l |= (region.start >> 8) & 0x00f0;
 		l |= region.end & 0xf000;
 		/* Set up upper 16 bits of I/O base/limit. */
 		io_upper16 = (region.end & 0xffff0000) | (region.start >> 16);
-		dev_info(&bridge->dev, "  IO window: %#04lx-%#04lx\n",
-		    (unsigned long)region.start,
-		    (unsigned long)region.end);
+		dev_info(&bridge->dev,
+			 "  bridge window %pR (PCI address %#04lx-%#04lx)\n",
+			 res, (unsigned long)region.start,
+			 (unsigned long)region.end);
 	}
 	else {
 		/* Clear upper 16 bits of I/O base/limit. */
 		io_upper16 = 0;
 		l = 0x00f0;
-		dev_info(&bridge->dev, "  IO window: disabled\n");
+		dev_info(&bridge->dev, "  bridge window [io  disabled]\n");
 	}
 	/* Temporarily disable the I/O range before updating PCI_IO_BASE. */
 	pci_write_config_dword(bridge, PCI_IO_BASE_UPPER16, 0x0000ffff);
@@ -178,17 +190,19 @@ static void pci_setup_bridge(struct pci_bus *bus)
 
 	/* Set up the top and bottom of the PCI Memory segment
 	   for this bus. */
-	pcibios_resource_to_bus(bridge, &region, bus->resource[1]);
-	if (bus->resource[1]->flags & IORESOURCE_MEM) {
+	res = bus->resource[1];
+	if (res->flags & IORESOURCE_MEM) {
+		pcibios_resource_to_bus(bridge, &region, res);
 		l = (region.start >> 16) & 0xfff0;
 		l |= region.end & 0xfff00000;
-		dev_info(&bridge->dev, "  MEM window: %#08lx-%#08lx\n",
-		    (unsigned long)region.start,
-		    (unsigned long)region.end);
+		dev_info(&bridge->dev,
+			 "  bridge window %pR (PCI address %#08lx-%#08lx)\n",
+			 res, (unsigned long)region.start,
+			 (unsigned long)region.end);
 	}
 	else {
 		l = 0x0000fff0;
-		dev_info(&bridge->dev, "  MEM window: disabled\n");
+		dev_info(&bridge->dev, "  bridge window [mem disabled]\n");
 	}
 	pci_write_config_dword(bridge, PCI_MEMORY_BASE, l);
 
@@ -200,24 +214,24 @@ static void pci_setup_bridge(struct pci_bus *bus)
 	/* Set up PREF base/limit. */
 	pref_mem64 = 0;
 	bu = lu = 0;
-	pcibios_resource_to_bus(bridge, &region, bus->resource[2]);
-	if (bus->resource[2]->flags & IORESOURCE_PREFETCH) {
-		int width = 8;
+	res = bus->resource[2];
+	if (res->flags & IORESOURCE_PREFETCH) {
+		pcibios_resource_to_bus(bridge, &region, res);
 		l = (region.start >> 16) & 0xfff0;
 		l |= region.end & 0xfff00000;
-		if (bus->resource[2]->flags & IORESOURCE_MEM_64) {
+		if (res->flags & IORESOURCE_MEM_64) {
 			pref_mem64 = 1;
 			bu = upper_32_bits(region.start);
 			lu = upper_32_bits(region.end);
-			width = 16;
 		}
-		dev_info(&bridge->dev, "  PREFETCH window: %#0*llx-%#0*llx\n",
-				width, (unsigned long long)region.start,
-				width, (unsigned long long)region.end);
+		dev_info(&bridge->dev,
+			 "  bridge window %pR (PCI address %#llx-%#llx)\n",
+			 res, (unsigned long long)region.start,
+			 (unsigned long long)region.end);
 	}
 	else {
 		l = 0x0000fff0;
-		dev_info(&bridge->dev, "  PREFETCH window: disabled\n");
+		dev_info(&bridge->dev, "  bridge window [mem pref disabled]\n");
 	}
 	pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE, l);
 
@@ -399,7 +413,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 			align = pci_resource_alignment(dev, r);
 			order = __ffs(align) - 20;
 			if (order > 11) {
-				dev_warn(&dev->dev, "BAR %d bad alignment %llx: "
+				dev_warn(&dev->dev, "BAR %d: bad alignment %llx: "
 					 "%pR\n", i, (unsigned long long)align, r);
 				r->flags = 0;
 				continue;
@@ -579,6 +593,7 @@ void __ref pci_bus_assign_resources(const struct pci_bus *bus)
 			break;
 		}
 	}
+	dev_dbg(&bus->dev, "%s done\n", __func__);
 }
 EXPORT_SYMBOL(pci_bus_assign_resources);
 
@@ -591,10 +606,7 @@ static void pci_bus_dump_res(struct pci_bus *bus)
                 if (!res || !res->end)
                         continue;
 
-		dev_printk(KERN_DEBUG, &bus->dev, "resource %d %s %pR\n", i,
-			   (res->flags & IORESOURCE_IO) ? "io: " :
-			    ((res->flags & IORESOURCE_PREFETCH)? "pref mem":"mem:"),
-			   res);
+		dev_printk(KERN_DEBUG, &bus->dev, "resource %d %pR\n", i, res);
         }
 }
 
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index c54526b..58f4892 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -51,12 +51,6 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 
 	pcibios_resource_to_bus(dev, &region, res);
 
-	dev_dbg(&dev->dev, "BAR %d: got res %pR bus [%#llx-%#llx] "
-		"flags %#lx\n", resno, res,
-		 (unsigned long long)region.start,
-		 (unsigned long long)region.end,
-		 (unsigned long)res->flags);
-
 	new = region.start | (res->flags & PCI_REGION_FLAG_MASK);
 	if (res->flags & IORESOURCE_IO)
 		mask = (u32)PCI_BASE_ADDRESS_IO_MASK;
@@ -64,11 +58,16 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 		mask = (u32)PCI_BASE_ADDRESS_MEM_MASK;
 
 	reg = pci_resource_bar(dev, resno, &type);
-	if (!reg)
+	if (!reg) {
+		dev_dbg(&dev->dev, "no BAR (resno %d)\n", resno);
 		return;
+	}
 	if (type != pci_bar_unknown) {
-		if (!(res->flags & IORESOURCE_ROM_ENABLE))
+		if (!(res->flags & IORESOURCE_ROM_ENABLE)) {
+			dev_dbg(&dev->dev, "ROM not enabled (type %d flags 0x%lx)\n",
+				type, res->flags);
 			return;
+		}
 		new |= PCI_ROM_ADDRESS_ENABLE;
 	}
 
@@ -91,9 +90,10 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 		}
 	}
 	res->flags &= ~IORESOURCE_UNSET;
-	dev_dbg(&dev->dev, "BAR %d: moved to bus [%#llx-%#llx] flags %#lx\n",
-		resno, (unsigned long long)region.start,
-		(unsigned long long)region.end, res->flags);
+	dev_info(&dev->dev,
+		 "BAR %d: moved to %pR (PCI address [%#llx-%#llx])\n",
+		 resno, res, (unsigned long long)region.start,
+		 (unsigned long long)region.end);
 }
 
 int pci_claim_resource(struct pci_dev *dev, int resource)
@@ -108,14 +108,10 @@ int pci_claim_resource(struct pci_dev *dev, int resource)
 	if (root != NULL)
 		err = request_resource(root, res);
 
-	if (err) {
-		const char *dtype = resource < PCI_BRIDGE_RESOURCES ? "device" : "bridge";
-		dev_err(&dev->dev, "BAR %d: %s of %s %pR\n",
-			resource,
+	if (err)
+		dev_err(&dev->dev, "BAR %d: %s %pR\n", resource,
 			root ? "address space collision on" :
-				"no parent found for",
-			dtype, res);
-	}
+				"no parent found for", res);
 
 	return err;
 }
@@ -124,7 +120,7 @@ EXPORT_SYMBOL(pci_claim_resource);
 #ifdef CONFIG_PCI_QUIRKS
 void pci_disable_bridge_window(struct pci_dev *dev)
 {
-	dev_dbg(&dev->dev, "Disabling bridge window.\n");
+	dev_info(&dev->dev, "disabling bridge windows\n");
 
 	/* MMIO Base/Limit */
 	pci_write_config_dword(dev, PCI_MEMORY_BASE, 0x0000fff0);
@@ -164,6 +160,7 @@ static int __pci_assign_resource(struct pci_bus *bus, struct pci_dev *dev,
 	}
 
 	if (!ret) {
+		dev_info(&dev->dev, "BAR %d: assigned %pR\n", resno, res);
 		res->flags &= ~IORESOURCE_STARTALIGN;
 		if (resno < PCI_BRIDGE_RESOURCES)
 			pci_update_resource(dev, resno);
@@ -181,9 +178,8 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 
 	align = pci_resource_alignment(dev, res);
 	if (!align) {
-		dev_info(&dev->dev, "BAR %d: can't allocate resource (bogus "
-			"alignment) %pR flags %#lx\n",
-			resno, res, res->flags);
+		dev_info(&dev->dev, "BAR %d: can't allocate %pR "
+			 "(bogus alignment)\n", resno, res);
 		return -EINVAL;
 	}
 
@@ -199,8 +195,8 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 	}
 
 	if (ret)
-		dev_info(&dev->dev, "BAR %d: can't allocate %s resource %pR\n",
-			resno, res->flags & IORESOURCE_IO ? "I/O" : "mem", res);
+		dev_info(&dev->dev, "BAR %d: can't allocate %pR\n",
+			 resno, res);
 
 	return ret;
 }
@@ -225,9 +221,8 @@ void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
 
 		r_align = pci_resource_alignment(dev, r);
 		if (!r_align) {
-			dev_warn(&dev->dev, "BAR %d: bogus alignment "
-				"%pR flags %#lx\n",
-				i, r, r->flags);
+			dev_warn(&dev->dev, "BAR %d: %pR has bogus alignment\n",
+				 i, r);
 			continue;
 		}
 		for (list = head; ; list = list->next) {
diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index 8473fe5..dfbd5a6 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -285,15 +285,10 @@ static void quirk_system_pci_resources(struct pnp_dev *dev)
 				 * the PCI region, and that might prevent a PCI
 				 * driver from requesting its resources.
 				 */
-				dev_warn(&dev->dev, "%s resource "
-					"(0x%llx-0x%llx) overlaps %s BAR %d "
-					"(0x%llx-0x%llx), disabling\n",
-					pnp_resource_type_name(res),
-					(unsigned long long) pnp_start,
-					(unsigned long long) pnp_end,
-					pci_name(pdev), i,
-					(unsigned long long) pci_start,
-					(unsigned long long) pci_end);
+				dev_warn(&dev->dev,
+					 "disabling %pR because it overlaps "
+					 "%s BAR %d %pR\n", res,
+					 pci_name(pdev), i, &pdev->resource[i]);
 				res->flags |= IORESOURCE_DISABLED;
 			}
 		}
diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
index ba97654..64d0596 100644
--- a/drivers/pnp/resource.c
+++ b/drivers/pnp/resource.c
@@ -517,7 +517,7 @@ struct pnp_resource *pnp_add_irq_resource(struct pnp_dev *dev, int irq,
 	res->start = irq;
 	res->end = irq;
 
-	pnp_dbg(&dev->dev, "  add irq %d flags %#x\n", irq, flags);
+	pnp_dbg(&dev->dev, "  add %pr\n", res);
 	return pnp_res;
 }
 
@@ -538,7 +538,7 @@ struct pnp_resource *pnp_add_dma_resource(struct pnp_dev *dev, int dma,
 	res->start = dma;
 	res->end = dma;
 
-	pnp_dbg(&dev->dev, "  add dma %d flags %#x\n", dma, flags);
+	pnp_dbg(&dev->dev, "  add %pr\n", res);
 	return pnp_res;
 }
 
@@ -562,8 +562,7 @@ struct pnp_resource *pnp_add_io_resource(struct pnp_dev *dev,
 	res->start = start;
 	res->end = end;
 
-	pnp_dbg(&dev->dev, "  add io  %#llx-%#llx flags %#x\n",
-		(unsigned long long) start, (unsigned long long) end, flags);
+	pnp_dbg(&dev->dev, "  add %pr\n", res);
 	return pnp_res;
 }
 
@@ -587,8 +586,7 @@ struct pnp_resource *pnp_add_mem_resource(struct pnp_dev *dev,
 	res->start = start;
 	res->end = end;
 
-	pnp_dbg(&dev->dev, "  add mem %#llx-%#llx flags %#x\n",
-		(unsigned long long) start, (unsigned long long) end, flags);
+	pnp_dbg(&dev->dev, "  add %pr\n", res);
 	return pnp_res;
 }
 
diff --git a/drivers/pnp/support.c b/drivers/pnp/support.c
index 63087d5..9585c1c 100644
--- a/drivers/pnp/support.c
+++ b/drivers/pnp/support.c
@@ -75,47 +75,14 @@ char *pnp_resource_type_name(struct resource *res)
 
 void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc)
 {
-	char buf[128];
-	int len;
 	struct pnp_resource *pnp_res;
-	struct resource *res;
 
-	if (list_empty(&dev->resources)) {
+	if (list_empty(&dev->resources))
 		pnp_dbg(&dev->dev, "%s: no current resources\n", desc);
-		return;
-	}
-
-	pnp_dbg(&dev->dev, "%s: current resources:\n", desc);
-	list_for_each_entry(pnp_res, &dev->resources, list) {
-		res = &pnp_res->res;
-		len = 0;
-
-		len += scnprintf(buf + len, sizeof(buf) - len, "  %-3s ",
-				 pnp_resource_type_name(res));
-
-		if (res->flags & IORESOURCE_DISABLED) {
-			pnp_dbg(&dev->dev, "%sdisabled\n", buf);
-			continue;
-		}
-
-		switch (pnp_resource_type(res)) {
-		case IORESOURCE_IO:
-		case IORESOURCE_MEM:
-			len += scnprintf(buf + len, sizeof(buf) - len,
-					 "%#llx-%#llx flags %#lx",
-					 (unsigned long long) res->start,
-					 (unsigned long long) res->end,
-					 res->flags);
-			break;
-		case IORESOURCE_IRQ:
-		case IORESOURCE_DMA:
-			len += scnprintf(buf + len, sizeof(buf) - len,
-					 "%lld flags %#lx",
-					 (unsigned long long) res->start,
-					 res->flags);
-			break;
-		}
-		pnp_dbg(&dev->dev, "%s\n", buf);
+	else {
+		pnp_dbg(&dev->dev, "%s: current resources:\n", desc);
+		list_for_each_entry(pnp_res, &dev->resources, list)
+			pnp_dbg(&dev->dev, "%pr\n", &pnp_res->res);
 	}
 }
 
diff --git a/drivers/pnp/system.c b/drivers/pnp/system.c
index 59b9092..49c1720 100644
--- a/drivers/pnp/system.c
+++ b/drivers/pnp/system.c
@@ -22,11 +22,11 @@ static const struct pnp_device_id pnp_dev_table[] = {
 	{"", 0}
 };
 
-static void reserve_range(struct pnp_dev *dev, resource_size_t start,
-			  resource_size_t end, int port)
+static void reserve_range(struct pnp_dev *dev, struct resource *r, int port)
 {
 	char *regionid;
 	const char *pnpid = dev_name(&dev->dev);
+	resource_size_t start = r->start, end = r->end;
 	struct resource *res;
 
 	regionid = kmalloc(16, GFP_KERNEL);
@@ -48,10 +48,8 @@ static void reserve_range(struct pnp_dev *dev, resource_size_t start,
 	 * example do reserve stuff they know about too, so we may well
 	 * have double reservations.
 	 */
-	dev_info(&dev->dev, "%s range 0x%llx-0x%llx %s reserved\n",
-		port ? "ioport" : "iomem",
-		(unsigned long long) start, (unsigned long long) end,
-		res ? "has been" : "could not be");
+	dev_info(&dev->dev, "%pR %s reserved\n", r,
+		 res ? "has been" : "could not be");
 }
 
 static void reserve_resources_of_dev(struct pnp_dev *dev)
@@ -77,14 +75,14 @@ static void reserve_resources_of_dev(struct pnp_dev *dev)
 		if (res->end < res->start)
 			continue;	/* invalid */
 
-		reserve_range(dev, res->start, res->end, 1);
+		reserve_range(dev, res, 1);
 	}
 
 	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++) {
 		if (res->flags & IORESOURCE_DISABLED)
 			continue;
 
-		reserve_range(dev, res->start, res->end, 0);
+		reserve_range(dev, res, 0);
 	}
 }
 
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 33bed5e..6438cd5 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -595,37 +595,89 @@ static char *symbol_string(char *buf, char *end, void *ptr,
 }
 
 static char *resource_string(char *buf, char *end, struct resource *res,
-				struct printf_spec spec)
+				struct printf_spec spec, const char *fmt)
 {
 #ifndef IO_RSRC_PRINTK_SIZE
-#define IO_RSRC_PRINTK_SIZE	4
+#define IO_RSRC_PRINTK_SIZE	6
 #endif
 
 #ifndef MEM_RSRC_PRINTK_SIZE
-#define MEM_RSRC_PRINTK_SIZE	8
+#define MEM_RSRC_PRINTK_SIZE	10
 #endif
-	struct printf_spec num_spec = {
+	struct printf_spec hex_spec = {
 		.base = 16,
 		.precision = -1,
 		.flags = SPECIAL | SMALL | ZEROPAD,
 	};
-	/* room for the actual numbers, the two "0x", -, [, ] and the final zero */
-	char sym[4*sizeof(resource_size_t) + 8];
+	struct printf_spec dec_spec = {
+		.base = 10,
+		.precision = -1,
+		.flags = 0,
+	};
+	struct printf_spec str_spec = {
+		.field_width = -1,
+		.precision = 10,
+		.flags = LEFT,
+	};
+	struct printf_spec flag_spec = {
+		.base = 16,
+		.precision = -1,
+		.flags = SPECIAL | SMALL,
+	};
+
+	/* 32-bit res (sizeof==4): 10 chars in dec, 10 in hex ("0x" + 8)
+	 * 64-bit res (sizeof==8): 20 chars in dec, 18 in hex ("0x" + 16) */
+#define RSRC_BUF_SIZE		((2 * sizeof(resource_size_t)) + 4)
+#define FLAG_BUF_SIZE		(2 * sizeof(res->flags))
+#define DECODED_BUF_SIZE	sizeof("[mem - 64bit pref disabled]")
+#define RAW_BUF_SIZE		sizeof("[mem - flags 0x]")
+	char sym[max(2*RSRC_BUF_SIZE + DECODED_BUF_SIZE,
+		     2*RSRC_BUF_SIZE + FLAG_BUF_SIZE + RAW_BUF_SIZE)];
+
 	char *p = sym, *pend = sym + sizeof(sym);
-	int size = -1;
+	int size = -1, addr = 0;
+	int decode = (fmt[0] == 'R') ? 1 : 0;
 
-	if (res->flags & IORESOURCE_IO)
+	if (res->flags & IORESOURCE_IO) {
 		size = IO_RSRC_PRINTK_SIZE;
-	else if (res->flags & IORESOURCE_MEM)
+		addr = 1;
+	} else if (res->flags & IORESOURCE_MEM) {
 		size = MEM_RSRC_PRINTK_SIZE;
+		addr = 1;
+	}
 
 	*p++ = '[';
-	num_spec.field_width = size;
-	p = number(p, pend, res->start, num_spec);
-	*p++ = '-';
-	p = number(p, pend, res->end, num_spec);
+	if (res->flags & IORESOURCE_IO)
+		p = string(p, pend, "io  ", str_spec);
+	else if (res->flags & IORESOURCE_MEM)
+		p = string(p, pend, "mem ", str_spec);
+	else if (res->flags & IORESOURCE_IRQ)
+		p = string(p, pend, "irq ", str_spec);
+	else if (res->flags & IORESOURCE_DMA)
+		p = string(p, pend, "dma ", str_spec);
+	else {
+		p = string(p, pend, "??? ", str_spec);
+		decode = 0;
+	}
+	hex_spec.field_width = size;
+	p = number(p, pend, res->start, addr ? hex_spec : dec_spec);
+	if (res->start != res->end) {
+		*p++ = '-';
+		p = number(p, pend, res->end, addr ? hex_spec : dec_spec);
+	}
+	if (decode) {
+		if (res->flags & IORESOURCE_MEM_64)
+			p = string(p, pend, " 64bit", str_spec);
+		if (res->flags & IORESOURCE_PREFETCH)
+			p = string(p, pend, " pref", str_spec);
+		if (res->flags & IORESOURCE_DISABLED)
+			p = string(p, pend, " disabled", str_spec);
+	} else {
+		p = string(p, pend, " flags ", str_spec);
+		p = number(p, pend, res->flags, flag_spec);
+	}
 	*p++ = ']';
-	*p = 0;
+	*p = '\0';
 
 	return string(buf, end, sym, spec);
 }
@@ -801,8 +853,8 @@ static char *ip4_addr_string(char *buf, char *end, const u8 *addr,
  * - 'f' For simple symbolic function names without offset
  * - 'S' For symbolic direct pointers with offset
  * - 's' For symbolic direct pointers without offset
- * - 'R' For a struct resource pointer, it prints the range of
- *       addresses (not the name nor the flags)
+ * - 'R' For decoded struct resource, e.g., [mem 0x0-0x1f 64bit pref]
+ * - 'r' For raw struct resource, e.g., [mem 0x0-0x1f flags 0x201]
  * - 'M' For a 6-byte MAC address, it prints the address in the
  *       usual colon-separated hex notation
  * - 'm' For a 6-byte MAC address, it prints the hex address without colons
@@ -833,7 +885,8 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	case 'S':
 		return symbol_string(buf, end, ptr, spec, *fmt);
 	case 'R':
-		return resource_string(buf, end, ptr, spec);
+	case 'r':
+		return resource_string(buf, end, ptr, spec, fmt);
 	case 'M':			/* Colon separated: 00:01:02:03:04:05 */
 	case 'm':			/* Contiguous: 000102030405 */
 		return mac_address_string(buf, end, ptr, spec, fmt);


