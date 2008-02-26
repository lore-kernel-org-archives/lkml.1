Return-Path: <linux-kernel-owner+w=401wt.eu-S1763897AbYBZSzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763897AbYBZSzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 13:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759154AbYBZSz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 13:55:29 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:62490 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758788AbYBZSz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 13:55:28 -0500
Date: Tue, 26 Feb 2008 11:04:17 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: Seperate mmconf for fam10h out from setup_64.c
In-reply-to: <20080226072451.GD24820@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Message-id: <200802261104.18341.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802251841.36135.yinghai.lu@sun.com>
 <20080226072451.GD24820@elte.hu>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seperate mmconf for fam10h out from setup_64.c

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 199f8b5..4f2b9ed 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -101,4 +101,6 @@ ifeq ($(CONFIG_X86_64),y)
         obj-$(CONFIG_GART_IOMMU)	+= pci-gart_64.o aperture_64.o
         obj-$(CONFIG_CALGARY_IOMMU)	+= pci-calgary_64.o tce_64.o
         obj-$(CONFIG_SWIOTLB)		+= pci-swiotlb_64.o
+
+        obj-$(CONFIG_PCI_MMCONFIG)	+= mmconf-fam10h_64.o
 endif
diff --git a/arch/x86/kernel/mmconf-fam10h_64.c b/arch/x86/kernel/mmconf-fam10h_64.c
new file mode 100644
index 0000000..3789792
--- /dev/null
+++ b/arch/x86/kernel/mmconf-fam10h_64.c
@@ -0,0 +1,215 @@
+/*
+ * AMD Family 10h mmconfig enablement
+ */
+
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <linux/string.h>
+#include <linux/pci.h>
+#include <asm/pci-direct.h>
+#include <linux/sort.h>
+#include <asm/io.h>
+#include <asm/msr.h>
+#include <asm/acpi.h>
+
+struct pci_hostbridge_probe {
+	u32 bus;
+	u32 slot;
+	u32 vendor;
+	u32 device;
+};
+
+static u64 __cpuinitdata fam10h_pci_mmconf_base;
+static int __cpuinitdata fam10h_pci_mmconf_base_status;
+
+static struct pci_hostbridge_probe pci_probes[] __cpuinitdata = {
+	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1200 },
+	{ 0xff, 0, PCI_VENDOR_ID_AMD, 0x1200 },
+};
+
+struct range {
+	u64 start;
+	u64 end;
+};
+
+static int __cpuinit cmp_range(const void *x1, const void *x2)
+{
+	const struct range *r1 = x1;
+	const struct range *r2 = x2;
+	int start1, start2;
+
+	start1 = r1->start >> 32;
+	start2 = r2->start >> 32;
+
+	return start1 - start2;
+}
+
+/*[47:0] */
+/* need to avoid (0xfd<<32) and (0xfe<<32), ht used space */
+#define FAM10H_PCI_MMCONF_BASE (0xfcULL<<32)
+#define BASE_VALID(b) ((b != (0xfdULL << 32)) && (b != (0xfeULL << 32)))
+static void __cpuinit get_fam10h_pci_mmconf_base(void)
+{
+	int i;
+	unsigned bus;
+	unsigned slot;
+	int found;
+
+	u64 val;
+	u32 address;
+	u64 tom2;
+	u64 base = FAM10H_PCI_MMCONF_BASE;
+
+	int hi_mmio_num;
+	struct range range[8];
+
+	/* only try to get setting from BSP */
+	/* -1 or 1 */
+	if (fam10h_pci_mmconf_base_status)
+		return;
+
+	if (!early_pci_allowed())
+		goto fail;
+
+	found = 0;
+	for (i = 0; i < ARRAY_SIZE(pci_probes); i++) {
+		u32 id;
+		u16 device;
+		u16 vendor;
+
+		bus = pci_probes[i].bus;
+		slot = pci_probes[i].slot;
+		id = read_pci_config(bus, slot, 0, PCI_VENDOR_ID);
+
+		vendor = id & 0xffff;
+		device = (id>>16) & 0xffff;
+		if (pci_probes[i].vendor == vendor &&
+		    pci_probes[i].device == device) {
+			found = 1;
+			break;
+		}
+	}
+
+	if (!found)
+		goto fail;
+
+	/* SYS_CFG */
+	address = MSR_K8_SYSCFG;
+	rdmsrl(address, val);
+
+	/* TOP_MEM2 is not enabled? */
+	if (!(val & (1<<21))) {
+		tom2 = 0;
+	} else {
+		/* TOP_MEM2 */
+		address = MSR_K8_TOP_MEM2;
+		rdmsrl(address, val);
+		tom2 = val & (0xffffULL<<32);
+	}
+
+	if (base <= tom2)
+		base = tom2 + (1ULL<<32);
+
+	/*
+	 * need to check if the range is in the high mmio range that is
+	 * above 4G
+	 */
+	hi_mmio_num = 0;
+	for (i = 0; i < 8; i++) {
+		u32 reg;
+		u64 start;
+		u64 end;
+		reg = read_pci_config(bus, slot, 1, 0x80 + (i << 3));
+		if (!(reg & 3))
+			continue;
+
+		start = (((u64)reg) << 8) & (0xffULL << 32); /* 39:16 on 31:8*/
+		reg = read_pci_config(bus, slot, 1, 0x84 + (i << 3));
+		end = (((u64)reg) << 8) & (0xffULL << 32); /* 39:16 on 31:8*/
+
+		if (!end)
+			continue;
+
+		range[hi_mmio_num].start = start;
+		range[hi_mmio_num].end = end;
+		hi_mmio_num++;
+	}
+
+	if (!hi_mmio_num)
+		goto out;
+
+	/* sort the range */
+	sort(range, hi_mmio_num, sizeof(struct range), cmp_range, NULL);
+
+	if (range[hi_mmio_num - 1].end < base)
+		goto out;
+	if (range[0].start > base)
+		goto out;
+
+	/* need to find one window */
+	base = range[0].start - (1ULL << 32);
+	if ((base > tom2) && BASE_VALID(base))
+		goto out;
+	base = range[hi_mmio_num - 1].end + (1ULL << 32);
+	if ((base > tom2) && BASE_VALID(base))
+		goto out;
+	/* need to find window between ranges */
+	if (hi_mmio_num > 1)
+	for (i = 0; i < hi_mmio_num - 1; i++) {
+		if (range[i + 1].start > (range[i].end + (1ULL << 32))) {
+			base = range[i].end + (1ULL << 32);
+			if ((base > tom2) && BASE_VALID(base))
+				goto out;
+		}
+	}
+
+fail:
+	fam10h_pci_mmconf_base_status = -1;
+	return;
+out:
+	fam10h_pci_mmconf_base = base;
+	fam10h_pci_mmconf_base_status = 1;
+}
+
+void __cpuinit fam10h_check_enable_mmcfg(void)
+{
+	u64 val;
+	u32 address;
+
+	address = MSR_FAM10H_MMIO_CONF_BASE;
+	rdmsrl(address, val);
+
+	/* try to make sure that AP's setting is identical to BSP setting */
+	if (val & FAM10H_MMIO_CONF_ENABLE) {
+		unsigned busnbits;
+		busnbits = (val >> FAM10H_MMIO_CONF_BUSRANGE_SHIFT) &
+			FAM10H_MMIO_CONF_BUSRANGE_MASK;
+
+		/* only trust the one handle 256 buses, if acpi=off */
+		if (!acpi_pci_disabled || busnbits >= 8) {
+			u64 base;
+			base = val & (0xffffULL << 32);
+			if (fam10h_pci_mmconf_base_status <= 0) {
+				fam10h_pci_mmconf_base = base;
+				fam10h_pci_mmconf_base_status = 1;
+				return;
+			} else if (fam10h_pci_mmconf_base ==  base)
+				return;
+		}
+	}
+
+	/*
+	 * if it is not enabled, try to enable it and assume only one segment
+	 * with 256 buses
+	 */
+	get_fam10h_pci_mmconf_base();
+	if (fam10h_pci_mmconf_base_status <= 0)
+		return;
+
+	printk(KERN_INFO "Enable MMCONFIG on AMD Family 10h\n");
+	val &= ~((FAM10H_MMIO_CONF_BASE_MASK<<FAM10H_MMIO_CONF_BASE_SHIFT) |
+	     (FAM10H_MMIO_CONF_BUSRANGE_MASK<<FAM10H_MMIO_CONF_BUSRANGE_SHIFT));
+	val |= fam10h_pci_mmconf_base | (8 << FAM10H_MMIO_CONF_BUSRANGE_SHIFT) |
+	       FAM10H_MMIO_CONF_ENABLE;
+	wrmsrl(address, val);
+}
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index d327155..d71463e 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -548,212 +548,6 @@ static int __cpuinit nearby_node(int apicid)
 }
 #endif
 
-#ifdef CONFIG_PCI_MMCONFIG
-struct pci_hostbridge_probe {
-	u32 bus;
-	u32 slot;
-	u32 vendor;
-	u32 device;
-};
-
-static u64 __cpuinitdata fam10h_pci_mmconf_base;
-static int __cpuinitdata fam10h_pci_mmconf_base_status;
-
-static struct pci_hostbridge_probe pci_probes[] __cpuinitdata = {
-	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1200 },
-	{ 0xff, 0, PCI_VENDOR_ID_AMD, 0x1200 },
-};
-
-struct range {
-	u64 start;
-	u64 end;
-};
-
-static int __cpuinit cmp_range(const void *x1, const void *x2)
-{
-	const struct range *r1 = x1;
-	const struct range *r2 = x2;
-	int start1, start2;
-
-	start1 = r1->start >> 32;
-	start2 = r2->start >> 32;
-
-	return start1 - start2;
-}
-
-/*[47:0] */
-/* need to avoid (0xfd<<32) and (0xfe<<32), ht used space */
-#define FAM10H_PCI_MMCONF_BASE (0xfcULL<<32)
-#define BASE_VALID(b) ((b != (0xfdULL << 32)) && (b != (0xfeULL << 32)))
-static void __cpuinit get_fam10h_pci_mmconf_base(void)
-{
-	int i;
-	unsigned bus;
-	unsigned slot;
-	int found;
-
-	u64 val;
-	u32 address;
-	u64 tom2;
-	u64 base = FAM10H_PCI_MMCONF_BASE;
-
-	int hi_mmio_num;
-	struct range range[8];
-
-	/* only try to get setting from BSP */
-	/* -1 or 1 */
-	if (fam10h_pci_mmconf_base_status)
-		return;
-
-	if (!early_pci_allowed())
-		goto fail;
-
-	found = 0;
-	for (i = 0; i < ARRAY_SIZE(pci_probes); i++) {
-		u32 id;
-		u16 device;
-		u16 vendor;
-
-		bus = pci_probes[i].bus;
-		slot = pci_probes[i].slot;
-		id = read_pci_config(bus, slot, 0, PCI_VENDOR_ID);
-
-		vendor = id & 0xffff;
-		device = (id>>16) & 0xffff;
-		if (pci_probes[i].vendor == vendor &&
-		    pci_probes[i].device == device) {
-			found = 1;
-			break;
-		}
-	}
-
-	if (!found)
-		goto fail;
-
-	/* SYS_CFG */
-	address = MSR_K8_SYSCFG;
-	rdmsrl(address, val);
-
-	/* TOP_MEM2 is not enabled? */
-	if (!(val & (1<<21))) {
-		tom2 = 0;
-	} else {
-		/* TOP_MEM2 */
-		address = MSR_K8_TOP_MEM2;
-		rdmsrl(address, val);
-		tom2 = val & (0xffffULL<<32);
-	}
-
-	if (base <= tom2)
-		base = tom2 + (1ULL<<32);
-
-	/*
-	 * need to check if the range is in the high mmio range that is
-	 * above 4G
-	 */
-	hi_mmio_num = 0;
-	for (i = 0; i < 8; i++) {
-		u32 reg;
-		u64 start;
-		u64 end;
-		reg = read_pci_config(bus, slot, 1, 0x80 + (i << 3));
-		if (!(reg & 3))
-			continue;
-
-		start = (((u64)reg) << 8) & (0xffULL << 32); /* 39:16 on 31:8*/
-		reg = read_pci_config(bus, slot, 1, 0x84 + (i << 3));
-		end = (((u64)reg) << 8) & (0xffULL << 32); /* 39:16 on 31:8*/
-
-		if (!end)
-			continue;
-
-		range[hi_mmio_num].start = start;
-		range[hi_mmio_num].end = end;
-		hi_mmio_num++;
-	}
-
-	if (!hi_mmio_num)
-		goto out;
-
-	/* sort the range */
-	sort(range, hi_mmio_num, sizeof(struct range), cmp_range, NULL);
-
-	if (range[hi_mmio_num - 1].end < base)
-		goto out;
-	if (range[0].start > base)
-		goto out;
-
-	/* need to find one window */
-	base = range[0].start - (1ULL << 32);
-	if ((base > tom2) && BASE_VALID(base))
-		goto out;
-	base = range[hi_mmio_num - 1].end + (1ULL << 32);
-	if ((base > tom2) && BASE_VALID(base))
-		goto out;
-	/* need to find window between ranges */
-	if (hi_mmio_num > 1)
-	for (i = 0; i < hi_mmio_num - 1; i++) {
-		if (range[i + 1].start > (range[i].end + (1ULL << 32))) {
-			base = range[i].end + (1ULL << 32);
-			if ((base > tom2) && BASE_VALID(base))
-				goto out;
-		}
-	}
-
-fail:
-	fam10h_pci_mmconf_base_status = -1;
-	return;
-out:
-	fam10h_pci_mmconf_base = base;
-	fam10h_pci_mmconf_base_status = 1;
-}
-#endif
-
-static void __cpuinit fam10h_check_enable_mmcfg(struct cpuinfo_x86 *c)
-{
-#ifdef CONFIG_PCI_MMCONFIG
-	u64 val;
-	u32 address;
-
-	address = MSR_FAM10H_MMIO_CONF_BASE;
-	rdmsrl(address, val);
-
-	/* try to make sure that AP's setting is identical to BSP setting */
-	if (val & FAM10H_MMIO_CONF_ENABLE) {
-		unsigned busnbits;
-		busnbits = (val >> FAM10H_MMIO_CONF_BUSRANGE_SHIFT) &
-			FAM10H_MMIO_CONF_BUSRANGE_MASK;
-
-		/* only trust the one handle 256 buses, if acpi=off */
-		if (!acpi_pci_disabled || busnbits >= 8) {
-			u64 base;
-			base = val & (0xffffULL << 32);
-			if (fam10h_pci_mmconf_base_status <= 0) {
-				fam10h_pci_mmconf_base = base;
-				fam10h_pci_mmconf_base_status = 1;
-				return;
-			} else if (fam10h_pci_mmconf_base ==  base)
-				return;
-		}
-	}
-
-	/*
-	 * if it is not enabled, try to enable it and assume only one segment
-	 * with 256 buses
-	 */
-	get_fam10h_pci_mmconf_base();
-	if (fam10h_pci_mmconf_base_status <= 0)
-		return;
-
-	printk(KERN_INFO "Enable MMCONFIG on AMD Family 10h\n");
-	val &= ~((FAM10H_MMIO_CONF_BASE_MASK<<FAM10H_MMIO_CONF_BASE_SHIFT) |
-	     (FAM10H_MMIO_CONF_BUSRANGE_MASK<<FAM10H_MMIO_CONF_BUSRANGE_SHIFT));
-	val |= fam10h_pci_mmconf_base | (8 << FAM10H_MMIO_CONF_BUSRANGE_SHIFT) |
-	       FAM10H_MMIO_CONF_ENABLE;
-	wrmsrl(address, val);
-#endif
-}
-
 /*
  * On a AMD dual core setup the lower bits of the APIC id distingush the cores.
  * Assumes number of cores is a power of two.
@@ -872,6 +666,14 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 }
 
+#ifdef CONFIG_PCI_MMCONFIG
+extern void __cpuinit fam10h_check_enable_mmcfg(void);
+#else
+void __cpuinit fam10h_check_enable_mmcfg(void)
+{
+}
+#endif
+
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 {
 	unsigned level;
@@ -938,7 +740,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	set_cpu_cap(c, X86_FEATURE_MFENCE_RDTSC);
 
 	if (c->x86 == 0x10)
-		fam10h_check_enable_mmcfg(c);
+		fam10h_check_enable_mmcfg();
 
 	if (amd_apic_timer_broken())
 		disable_apic_timer = 1;
