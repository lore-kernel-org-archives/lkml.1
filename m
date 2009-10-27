Return-Path: <linux-kernel-owner+w=401wt.eu-S932146AbZJ0ILF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146AbZJ0ILF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 04:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932110AbZJ0ILE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 04:11:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:37992 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932109AbZJ0ILB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 04:11:01 -0400
Message-ID: <4AE6AAF2.7010402@kernel.org>
Date: Tue, 27 Oct 2009 01:10:26 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Alex Chiang <achiang@hp.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 4/4] pci: remove  min_size for hotplug bridge
References: <4ADEB601.8020200@kernel.org> <4AE52B68.3070501@jp.fujitsu.com> <4AE53883.3070709@kernel.org> <4AE5545E.1020900@jp.fujitsu.com> <4AE55D72.7080202@kernel.org> <4AE6A9CA.4060106@kernel.org>
In-Reply-To: <4AE6A9CA.4060106@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


revert

| commit 28760489a3f1e136c5ae8581c0fa8f63511f2f4c
| Author: Eric W. Biederman <ebiederm@aristanetworks.com>
| Date:   Wed Sep 9 14:09:24 2009 -0700
|
|    PCI: pcie: Ensure hotplug ports have a minimum number of resources

we don't need this trick anymore. the bridge BAR will be updated automatically

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/pci.c       |   10 ----------
 drivers/pci/probe.c     |   18 ------------------
 drivers/pci/setup-bus.c |   22 +++++-----------------
 include/linux/pci.h     |    4 ----
 4 files changed, 5 insertions(+), 49 deletions(-)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -41,12 +41,6 @@ int pci_domains_supported = 1;
 unsigned long pci_cardbus_io_size = DEFAULT_CARDBUS_IO_SIZE;
 unsigned long pci_cardbus_mem_size = DEFAULT_CARDBUS_MEM_SIZE;
 
-#define DEFAULT_HOTPLUG_IO_SIZE		(256)
-#define DEFAULT_HOTPLUG_MEM_SIZE	(2*1024*1024)
-/* pci=hpmemsize=nnM,hpiosize=nn can override this */
-unsigned long pci_hotplug_io_size  = DEFAULT_HOTPLUG_IO_SIZE;
-unsigned long pci_hotplug_mem_size = DEFAULT_HOTPLUG_MEM_SIZE;
-
 /*
  * The default CLS is used if arch didn't set CLS explicitly and not
  * all pci devices agree on the same value.  Arch can override either
@@ -2787,10 +2781,6 @@ static int __init pci_setup(char *str)
 							strlen(str + 19));
 			} else if (!strncmp(str, "ecrc=", 5)) {
 				pcie_ecrc_get_policy(str + 5);
-			} else if (!strncmp(str, "hpiosize=", 9)) {
-				pci_hotplug_io_size = memparse(str + 9, &str);
-			} else if (!strncmp(str, "hpmemsize=", 10)) {
-				pci_hotplug_mem_size = memparse(str + 10, &str);
 			} else {
 				printk(KERN_ERR "PCI: Unknown option `%s'\n",
 						str);
Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -689,23 +689,6 @@ static void set_pcie_port_type(struct pc
 	pdev->pcie_type = (reg16 & PCI_EXP_FLAGS_TYPE) >> 4;
 }
 
-static void set_pcie_hotplug_bridge(struct pci_dev *pdev)
-{
-	int pos;
-	u16 reg16;
-	u32 reg32;
-
-	pos = pci_find_capability(pdev, PCI_CAP_ID_EXP);
-	if (!pos)
-		return;
-	pci_read_config_word(pdev, pos + PCI_EXP_FLAGS, &reg16);
-	if (!(reg16 & PCI_EXP_FLAGS_SLOT))
-		return;
-	pci_read_config_dword(pdev, pos + PCI_EXP_SLTCAP, &reg32);
-	if (reg32 & PCI_EXP_SLTCAP_HPC)
-		pdev->is_hotplug_bridge = 1;
-}
-
 #define LEGACY_IO_RESOURCE	(IORESOURCE_IO | IORESOURCE_PCI_FIXED)
 
 /**
@@ -813,7 +796,6 @@ int pci_setup_device(struct pci_dev *dev
 		pci_read_irq(dev);
 		dev->transparent = ((dev->class & 0xff) == 1);
 		pci_read_bases(dev, 2, PCI_ROM_ADDRESS1);
-		set_pcie_hotplug_bridge(dev);
 		break;
 
 	case PCI_HEADER_TYPE_CARDBUS:		    /* CardBus bridge header */
Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -375,7 +375,7 @@ static struct resource *find_free_bus_re
    since these windows have 4K granularity and the IO ranges
    of non-bridge PCI devices are limited to 256 bytes.
    We must be careful with the ISA aliasing though. */
-static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size)
+static void pbus_size_io(struct pci_bus *bus)
 {
 	struct pci_dev *dev;
 	struct resource *b_res = find_free_bus_resource(bus, IORESOURCE_IO);
@@ -402,8 +402,6 @@ static void pbus_size_io(struct pci_bus
 				size1 += r_size;
 		}
 	}
-	if (size < min_size)
-		size = min_size;
 /* To be fixed in 2.5: we should have sort of HAVE_ISA
    flag in the struct pci_bus. */
 #if defined(CONFIG_ISA) || defined(CONFIG_EISA)
@@ -422,8 +420,7 @@ static void pbus_size_io(struct pci_bus
 
 /* Calculate the size of the bus and minimal alignment which
    guarantees that all child resources fit in this size. */
-static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
-			 unsigned long type, resource_size_t min_size)
+static int pbus_size_mem(struct pci_bus *bus, unsigned long mask, unsigned long type)
 {
 	struct pci_dev *dev;
 	resource_size_t min_align, align, size;
@@ -473,8 +470,6 @@ static int pbus_size_mem(struct pci_bus
 			mem64_mask &= r->flags & IORESOURCE_MEM_64;
 		}
 	}
-	if (size < min_size)
-		size = min_size;
 
 	align = 0;
 	min_align = 0;
@@ -554,7 +549,6 @@ void __ref pci_bus_size_bridges(struct p
 {
 	struct pci_dev *dev;
 	unsigned long mask, prefmask;
-	resource_size_t min_mem_size = 0, min_io_size = 0;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		struct pci_bus *b = dev->subordinate;
@@ -584,12 +578,8 @@ void __ref pci_bus_size_bridges(struct p
 
 	case PCI_CLASS_BRIDGE_PCI:
 		pci_bridge_check_ranges(bus);
-		if (bus->self->is_hotplug_bridge) {
-			min_io_size  = pci_hotplug_io_size;
-			min_mem_size = pci_hotplug_mem_size;
-		}
 	default:
-		pbus_size_io(bus, min_io_size);
+		pbus_size_io(bus);
 		/* If the bridge supports prefetchable range, size it
 		   separately. If it doesn't, or its prefetchable window
 		   has already been allocated by arch code, try
@@ -597,11 +587,9 @@ void __ref pci_bus_size_bridges(struct p
 		   resources. */
 		mask = IORESOURCE_MEM;
 		prefmask = IORESOURCE_MEM | IORESOURCE_PREFETCH;
-		if (pbus_size_mem(bus, prefmask, prefmask, min_mem_size))
+		if (pbus_size_mem(bus, prefmask, prefmask))
 			mask = prefmask; /* Success, size non-prefetch only. */
-		else
-			min_mem_size += min_mem_size;
-		pbus_size_mem(bus, mask, IORESOURCE_MEM, min_mem_size);
+		pbus_size_mem(bus, mask, IORESOURCE_MEM);
 		break;
 	}
 }
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -279,7 +279,6 @@ struct pci_dev {
 	unsigned int	is_physfn:1;
 	unsigned int	is_virtfn:1;
 	unsigned int	reset_fn:1;
-	unsigned int    is_hotplug_bridge:1;
 	pci_dev_flags_t dev_flags;
 	atomic_t	enable_cnt;	/* pci_enable_device has been called */
 
@@ -1256,9 +1255,6 @@ extern unsigned long pci_cardbus_mem_siz
 extern u8 pci_dfl_cache_line_size;
 extern u8 pci_cache_line_size;
 
-extern unsigned long pci_hotplug_io_size;
-extern unsigned long pci_hotplug_mem_size;
-
 int pcibios_add_platform_entries(struct pci_dev *dev);
 void pcibios_disable_device(struct pci_dev *dev);
 int pcibios_set_pcie_reset_state(struct pci_dev *dev,

