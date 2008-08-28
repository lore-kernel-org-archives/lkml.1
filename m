Return-Path: <linux-kernel-owner+w=401wt.eu-S1754415AbYH1IWC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbYH1IWC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 04:22:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbYH1IVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 04:21:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34660 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbYH1IVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 04:21:38 -0400
Date: Thu, 28 Aug 2008 10:21:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] resource/x86: add sticky resource type
Message-ID: <20080828082119.GN21875@elte.hu>
References: <1219888583-31577-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219888583-31577-1-git-send-email-yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> Ingo suggest to use sticky resource type to record fixed resource. so 
> could check that BAR and avoid update it after request_resource 
> failed.
> 
> and we could remove tricky code about insert some resource with 
> late_initcall.

very nice patch! I've split your patch into two, and applied the 
kernel/resource.c and include/linux/ioresource.h core bits to the 
tip/core/resources topic branch - see the first patch below. (i renamed 
the new API to check_sticky_resource())

Then i've merged this topic branch into irq/sparseirq and applied the 
x86 bits that use this new facility to irq/sparseirq [on which it has 
many dependencies, io_apic.c and apic.c got unified, etc.]. See the 
second patch below.

Especially the second patch shows how much fragile resource code we are 
able to remove this way:

 5 files changed, 22 insertions(+), 138 deletions(-)

nice work.

Does anyone have any suggestions of how to improve this some more? (or 
do it differently)

	Ingo

----------------------->
>From 0fec91fc00059401dc756ad635975bea8f813309 Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yhlu.kernel@gmail.com>
Date: Wed, 27 Aug 2008 18:56:23 -0700
Subject: [PATCH] IO resources: add sticky resource type

Ingo suggested to use sticky resource type to record fixed resource.
That way we could check that BAR in the PCI init code and avoid updating
it after request_resource failed.

That way we could remove some tricky code about insert some platform
resources with late_initcall.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/ioport.h |    3 ++
 kernel/resource.c      |   58 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 22d2115..db53613 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -48,6 +48,8 @@ struct resource_list {
 #define IORESOURCE_SIZEALIGN	0x00020000	/* size indicates alignment */
 #define IORESOURCE_STARTALIGN	0x00040000	/* start field is alignment */
 
+#define IORESOURCE_STICKY	0x08000000
+
 #define IORESOURCE_DISABLED	0x10000000
 #define IORESOURCE_UNSET	0x20000000
 #define IORESOURCE_AUTO		0x40000000
@@ -109,6 +111,7 @@ extern struct resource iomem_resource;
 extern int request_resource(struct resource *root, struct resource *new);
 extern int release_resource(struct resource *new);
 extern int insert_resource(struct resource *parent, struct resource *new);
+extern struct resource *check_sticky_resource(struct resource *bar_res);
 extern int allocate_resource(struct resource *root, struct resource *new,
 			     resource_size_t size, resource_size_t min,
 			     resource_size_t max, resource_size_t align,
diff --git a/kernel/resource.c b/kernel/resource.c
index f5b518e..957afa7 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -586,6 +586,64 @@ int __check_region(struct resource *parent, resource_size_t start,
 EXPORT_SYMBOL(__check_region);
 
 /**
+ * check_sticky_resource
+ * @bar_res: target resource descriptor
+ *
+ * return res: identical to bar_res, or overlapping it
+ */
+struct resource *check_sticky_resource(struct resource *bar_res)
+{
+	struct resource *parent;
+	struct resource *res;
+
+	if (bar_res->flags | IORESOURCE_MEM)
+		parent = &iomem_resource;
+	else if (bar_res->flags | IORESOURCE_IO)
+		parent = &ioport_resource;
+	else
+		return NULL;
+
+	res = kzalloc(sizeof(*res), GFP_KERNEL);
+	if (res) {
+		res->name = bar_res->name;
+		res->start = bar_res->start;
+		res->end = bar_res->end;
+		res->flags = bar_res->flags | IORESOURCE_BUSY;
+
+		write_lock(&resource_lock);
+
+		for (;;) {
+			struct resource *conflict;
+
+			conflict = __request_resource(parent, res);
+			if (!conflict) {
+				/* not found */
+				break;
+			}
+			if (conflict != parent) {
+				parent = conflict;
+				if (!(conflict->flags & IORESOURCE_STICKY))
+					continue;
+			} else {
+				parent = NULL;
+			}
+
+			kfree(res);
+			res = NULL;
+			break;
+		}
+		write_unlock(&resource_lock);
+	}
+
+	if (res) {
+		release_resource(res);
+		kfree(res);
+	}
+
+	return parent;
+}
+
+/**
  * __release_region - release a previously reserved resource region
  * @parent: parent resource descriptor
  * @start: resource start address

----------------------->
>From b785e212314cf2ed1b0c17a6df1041016437b528 Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yhlu.kernel@gmail.com>
Date: Wed, 27 Aug 2008 18:56:23 -0700
Subject: [PATCH] resource/x86: use sticky resource type for platform resources

Remove tricky (and fragile) late_initcall code that inserted special
platform resources that might overlap with PCI resources.

Instead use the sticky resource type in early init, to make sure these
resources are known to the PCI code already.

>From now on platform code can just register special resources with
the sticky flag set, and the PCI code will not move any overlapping
PCI device resources if there's a conflict.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/acpi/boot.c    |   17 +------------
 arch/x86/kernel/apic.c         |   30 ++++++------------------
 arch/x86/kernel/io_apic.c      |   26 +-------------------
 arch/x86/pci/i386.c            |   38 +++++-------------------------
 arch/x86/pci/mmconfig-shared.c |   49 ++-------------------------------------
 5 files changed, 22 insertions(+), 138 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 06aa544..aefa636 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -703,30 +703,17 @@ static int __init acpi_parse_hpet(struct acpi_table_header *table)
 	hpet_res = alloc_bootmem(sizeof(*hpet_res) + HPET_RESOURCE_NAME_SIZE);
 
 	hpet_res->name = (void *)&hpet_res[1];
-	hpet_res->flags = IORESOURCE_MEM;
+	hpet_res->flags = IORESOURCE_MEM | IORESOURCE_STICKY;
 	snprintf((char *)hpet_res->name, HPET_RESOURCE_NAME_SIZE, "HPET %u",
 		 hpet_tbl->sequence);
 
 	hpet_res->start = hpet_address;
 	hpet_res->end = hpet_address + (1 * 1024) - 1;
+	insert_resource(&iomem_resource, hpet_res);
 
 	return 0;
 }
 
-/*
- * hpet_insert_resource inserts the HPET resources used into the resource
- * tree.
- */
-static __init int hpet_insert_resource(void)
-{
-	if (!hpet_res)
-		return 1;
-
-	return insert_resource(&iomem_resource, hpet_res);
-}
-
-late_initcall(hpet_insert_resource);
-
 #else
 #define	acpi_parse_hpet	NULL
 #endif
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 0556f37..b8b5bb5 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -132,7 +132,7 @@ int smp_found_config;
 
 static struct resource lapic_resource = {
 	.name = "Local APIC",
-	.flags = IORESOURCE_MEM | IORESOURCE_BUSY,
+	.flags = IORESOURCE_MEM | IORESOURCE_BUSY | IORESOURCE_STICKY,
 };
 
 static unsigned int calibration_result;
@@ -1544,11 +1544,16 @@ void __init init_apic_mappings(void)
 	if (!smp_found_config && detect_init_APIC()) {
 		apic_phys = (unsigned long) alloc_bootmem_pages(PAGE_SIZE);
 		apic_phys = __pa(apic_phys);
-	} else
+	} else {
 		apic_phys = mp_lapic_addr;
+		/* Put local APIC into the resource map. */
+		lapic_resource.start = apic_phys;
+		lapic_resource.end = lapic_resource.start + PAGE_SIZE - 1;
+		insert_resource(&iomem_resource, &lapic_resource);
+	}
 
 	set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
-	apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
+	apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%8lx)\n",
 				APIC_BASE, apic_phys);
 
 	/*
@@ -2198,22 +2203,3 @@ static int __init apic_set_verbosity(char *arg)
 	return 0;
 }
 early_param("apic", apic_set_verbosity);
-
-static int __init lapic_insert_resource(void)
-{
-	if (!apic_phys)
-		return -1;
-
-	/* Put local APIC into the resource map. */
-	lapic_resource.start = apic_phys;
-	lapic_resource.end = lapic_resource.start + PAGE_SIZE - 1;
-	insert_resource(&iomem_resource, &lapic_resource);
-
-	return 0;
-}
-
-/*
- * need call insert after e820_reserve_resources()
- * that is using request_resource
- */
-late_initcall(lapic_insert_resource);
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index d28128e..8496ba7 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -3846,7 +3846,7 @@ static struct resource * __init ioapic_setup_resources(void)
 
 		for (i = 0; i < nr_ioapics; i++) {
 			res[i].name = mem;
-			res[i].flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+			res[i].flags = IORESOURCE_MEM | IORESOURCE_BUSY | IORESOURCE_STICKY;
 			sprintf(mem,  "IOAPIC %u", i);
 			mem += IOAPIC_RESOURCE_NAME_SIZE;
 		}
@@ -3895,30 +3895,8 @@ fake_ioapic_page:
 		if (ioapic_res != NULL) {
 			ioapic_res->start = ioapic_phys;
 			ioapic_res->end = ioapic_phys + (4 * 1024) - 1;
+			insert_resource(&iomem_resource, ioapic_res);
 			ioapic_res++;
 		}
 	}
 }
-
-static int __init ioapic_insert_resources(void)
-{
-	int i;
-	struct resource *r = ioapic_resources;
-
-	if (!r) {
-		printk(KERN_ERR
-		       "IO APIC resources could be not be allocated.\n");
-		return -1;
-	}
-
-	for (i = 0; i < nr_ioapics; i++) {
-		insert_resource(&iomem_resource, r);
-		r++;
-	}
-
-	return 0;
-}
-
-/* Insert the IO APIC resources after PCI initialization has occured to handle
- * IO APICS that are mapped in on a BAR in PCI space. */
-late_initcall(ioapic_insert_resources);
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index d765da9..023cbc0 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -82,6 +82,7 @@ EXPORT_SYMBOL(pcibios_align_resource);
 
 static int check_res_with_valid(struct pci_dev *dev, struct resource *res)
 {
+	struct resource *sticky_res;
 	unsigned long base;
 	unsigned long size;
 	int i;
@@ -93,39 +94,14 @@ static int check_res_with_valid(struct pci_dev *dev, struct resource *res)
 	if (!base || !size)
 		return 0;
 
-#ifdef CONFIG_HPET_TIMER
-	/* for hpet */
-	if (base == hpet_address && (res->flags & IORESOURCE_MEM)) {
-		dev_info(&dev->dev, "BAR has HPET at %08lx-%08lx\n",
-				 base, base + size - 1);
-		return 1;
-	}
-#endif
-
-#ifdef CONFIG_X86_IO_APIC
-	for (i = 0; i < nr_ioapics; i++) {
-		unsigned long ioapic_phys = mp_ioapics[i].mp_apicaddr;
+	sticky_res = check_sticky_resource(res);
 
-		if (base == ioapic_phys && (res->flags & IORESOURCE_MEM)) {
-			dev_info(&dev->dev, "BAR has ioapic at %08lx-%08lx\n",
-					 base, base + size - 1);
-			return 1;
-		}
-	}
-#endif
-
-#ifdef CONFIG_PCI_MMCONFIG
-	for (i = 0; i < pci_mmcfg_config_num; i++) {
-		unsigned long addr;
-
-		addr = pci_mmcfg_config[i].address;
-		if (base == addr && (res->flags & IORESOURCE_MEM)) {
-			dev_info(&dev->dev, "BAR has MMCONFIG at %08lx-%08lx\n",
-					 base, base + size - 1);
-			return 1;
-		}
+	if (sticky_res) {
+		dev_info(&dev->dev, "BAR %08lx-%08lx with sticky res %s [%08llx, %08llx]\n",
+				 base, base + size - 1, sticky_res->name,
+				 sticky_res->start, sticky_res->end);
+		return 1;
 	}
-#endif
 
 	return 0;
 }
diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index d963576..6d7c179 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -22,9 +22,6 @@
 #define MMCONFIG_APER_MIN	(2 * 1024*1024)
 #define MMCONFIG_APER_MAX	(256 * 1024*1024)
 
-/* Indicate if the mmcfg resources have been placed into the resource table. */
-static int __initdata pci_mmcfg_resources_inserted;
-
 static const char __init *pci_mmcfg_e7520(void)
 {
 	u32 win;
@@ -209,7 +206,7 @@ static int __init pci_mmcfg_check_hostbridge(void)
 	return name != NULL;
 }
 
-static void __init pci_mmcfg_insert_resources(unsigned long resource_flags)
+static void __init pci_mmcfg_insert_resources(void)
 {
 #define PCI_MMCFG_RESOURCE_NAME_LEN 19
 	int i;
@@ -233,13 +230,10 @@ static void __init pci_mmcfg_insert_resources(unsigned long resource_flags)
 			 cfg->pci_segment);
 		res->start = cfg->address;
 		res->end = res->start + (num_buses << 20) - 1;
-		res->flags = IORESOURCE_MEM | resource_flags;
+		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY | IORESOURCE_STICKY;
 		insert_resource(&iomem_resource, res);
 		names += PCI_MMCFG_RESOURCE_NAME_LEN;
 	}
-
-	/* Mark that the resources have been inserted. */
-	pci_mmcfg_resources_inserted = 1;
 }
 
 static acpi_status __init check_mcfg_resource(struct acpi_resource *res,
@@ -435,15 +429,8 @@ static void __init __pci_mmcfg_init(int early)
 		return;
 
 	if (pci_mmcfg_arch_init()) {
-		if (known_bridge)
-			pci_mmcfg_insert_resources(IORESOURCE_BUSY);
+		pci_mmcfg_insert_resources();
 		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
-	} else {
-		/*
-		 * Signal not to attempt to insert mmcfg resources because
-		 * the architecture mmcfg setup could not initialize.
-		 */
-		pci_mmcfg_resources_inserted = 1;
 	}
 }
 
@@ -456,33 +443,3 @@ void __init pci_mmcfg_late_init(void)
 {
 	__pci_mmcfg_init(0);
 }
-
-static int __init pci_mmcfg_late_insert_resources(void)
-{
-	/*
-	 * If resources are already inserted or we are not using MMCONFIG,
-	 * don't insert the resources.
-	 */
-	if ((pci_mmcfg_resources_inserted == 1) ||
-	    (pci_probe & PCI_PROBE_MMCONF) == 0 ||
-	    (pci_mmcfg_config_num == 0) ||
-	    (pci_mmcfg_config == NULL) ||
-	    (pci_mmcfg_config[0].address == 0))
-		return 1;
-
-	/*
-	 * Attempt to insert the mmcfg resources but not with the busy flag
-	 * marked so it won't cause request errors when __request_region is
-	 * called.
-	 */
-	pci_mmcfg_insert_resources(0);
-
-	return 0;
-}
-
-/*
- * Perform MMCONFIG resource insertion after PCI initialization to allow for
- * misprogrammed MCFG tables that state larger sizes but actually conflict
- * with other system resources.
- */
-late_initcall(pci_mmcfg_late_insert_resources);
