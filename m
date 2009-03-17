Return-Path: <linux-kernel-owner+w=401wt.eu-S1762961AbZCQJ0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762961AbZCQJ0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 05:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbZCQJZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 05:25:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:56804 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860AbZCQJZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 05:25:54 -0400
Subject: [PATCH -tip] x86: move vmware to hypervisor
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, akataria@vmware.com
Content-Type: text/plain
Date: Tue, 17 Mar 2009 14:49:41 +0530
Message-Id: <1237281581.7907.2.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] x86: move vmware to hypervisor

Impact: cleanup

vmware is only required by hypervisor and having only two functions
by moving these two functions to hypervisor we get rid of 2 vmware files

Added support for CONFIG_X86_HYPERVISOR

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/Kconfig                  |   12 ++++
 arch/x86/include/asm/hypervisor.h |   34 ++++++++++-
 arch/x86/include/asm/vmware.h     |   27 ---------
 arch/x86/kernel/cpu/Makefile      |    2 +-
 arch/x86/kernel/cpu/hypervisor.c  |   80 ++++++++++++++++++++-------
 arch/x86/kernel/cpu/vmware.c      |  112 -------------------------------------
 6 files changed, 104 insertions(+), 163 deletions(-)
 delete mode 100644 arch/x86/include/asm/vmware.h
 delete mode 100644 arch/x86/kernel/cpu/vmware.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9bb9286..e75e578 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -553,6 +553,18 @@ config HPET_EMULATE_RTC
 	def_bool y
 	depends on HPET_TIMER && (RTC=y || RTC=m || RTC_DRV_CMOS=m || RTC_DRV_CMOS=y)
 
+config X86_HYPERVISOR
+	bool
+	default n
+	prompt "X86 Hypervisor Support"
+	---help---
+	  A hypervisor, also called virtual machine monitor (VMM),
+	  is a computer hardware platform virtualization software
+	  that allows multiple operating systems to run on a host
+	  computer concurrently
+
+	  Choose Y to use VMware Hypervisor
+	
 # Mark as embedded because too many people got it wrong.
 # The code disables itself when not needed.
 config DMI
diff --git a/arch/x86/include/asm/hypervisor.h b/arch/x86/include/asm/hypervisor.h
index 369f5c5..e0b1ee0 100644
--- a/arch/x86/include/asm/hypervisor.h
+++ b/arch/x86/include/asm/hypervisor.h
@@ -17,10 +17,38 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
  *
  */
-#ifndef ASM_X86__HYPERVISOR_H
-#define ASM_X86__HYPERVISOR_H
+#ifndef ASM_X86_HYPERVISOR_H
+#define ASM_X86_HYPERVISOR_H
+
+#ifdef CONFIG_X86_HYPERVISOR
+
+/* VMware */
+#define CPUID_VMWARE_INFO_LEAF		0x40000000
+#define VMWARE_HYPERVISOR_MAGIC		0x564D5868
+#define VMWARE_HYPERVISOR_PORT		0x5658
+
+#define VMWARE_PORT_CMD_GETVERSION	10
+#define VMWARE_PORT_CMD_GETHZ		45
+
+#define VMWARE_PORT(cmd, eax, ebx, ecx, edx)				\
+	__asm__("inl (%%dx)":						\
+			"=a"(eax), "=c"(ecx), "=d"(edx), "=b"(ebx) :	\
+			"0"(VMWARE_HYPERVISOR_MAGIC),			\
+			"1"(VMWARE_PORT_CMD_##cmd),			\
+			"2"(VMWARE_HYPERVISOR_PORT), "3"(UINT_MAX) :	\
+			"memory");
 
 extern unsigned long get_hypervisor_tsc_freq(void);
 extern void init_hypervisor(struct cpuinfo_x86 *c);
 
-#endif
+#else /* CONFIG_X86_HYPERVISOR */
+
+static inline unsigned long get_hypervisor_tsc_freq(void)
+{
+	return 0;
+}
+
+static inline void init_hypervisor(struct cpuinfo_x86 *c) {}
+#endif /* CONFIG_X86_HYPERVISOR */
+
+#endif /* ASM_X86_HYPERVISOR_H */
diff --git a/arch/x86/include/asm/vmware.h b/arch/x86/include/asm/vmware.h
deleted file mode 100644
index c11b7e1..0000000
--- a/arch/x86/include/asm/vmware.h
+++ /dev/null
@@ -1,27 +0,0 @@
-/*
- * Copyright (C) 2008, VMware, Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- * NON INFRINGEMENT.  See the GNU General Public License for more
- * details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
- *
- */
-#ifndef ASM_X86__VMWARE_H
-#define ASM_X86__VMWARE_H
-
-extern unsigned long vmware_get_tsc_khz(void);
-extern int vmware_platform(void);
-extern void vmware_set_feature_bits(struct cpuinfo_x86 *c);
-
-#endif
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 3efcb2b..55e251e 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -9,11 +9,11 @@ endif
 
 obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
 obj-y			+= proc.o capflags.o powerflags.o common.o
-obj-y			+= vmware.o hypervisor.o
 
 obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
 obj-$(CONFIG_X86_64)	+= bugs_64.o
 
+obj-$(CONFIG_X86_HYPERVISOR)		+= hypervisor.o
 obj-$(CONFIG_X86_CPU_DEBUG)		+= cpu_debug.o
 
 obj-$(CONFIG_CPU_SUP_INTEL)		+= intel.o
diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index fb5b86a..e8b3cb2 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -2,6 +2,7 @@
  * Common hypervisor code
  *
  * Copyright (C) 2008, VMware, Inc.
+ * Copyright (C) 2009, Jaswinder Singh Rajput
  * Author : Alok N Kataria <akataria@vmware.com>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -21,38 +22,77 @@
  *
  */
 
-#include <asm/processor.h>
-#include <asm/vmware.h>
+#include <linux/dmi.h>
+
 #include <asm/hypervisor.h>
+#include <asm/processor.h>
+#include <asm/div64.h>
 
-static inline void __cpuinit
-detect_hypervisor_vendor(struct cpuinfo_x86 *c)
+/* VMware */
+static unsigned long vmware_get_tsc_khz(void)
 {
-	if (vmware_platform()) {
-		c->x86_hyper_vendor = X86_HYPER_VENDOR_VMWARE;
-	} else {
-		c->x86_hyper_vendor = X86_HYPER_VENDOR_NONE;
-	}
+	uint32_t eax, ebx, ecx, edx;
+	uint64_t tsc_hz;
+
+	VMWARE_PORT(GETHZ, eax, ebx, ecx, edx);
+
+	if (ebx == UINT_MAX)
+		return 0;
+	tsc_hz = eax | (((uint64_t)ebx) << 32);
+	do_div(tsc_hz, 1000);
+	BUG_ON(tsc_hz >> 32);
+
+	return tsc_hz;
 }
 
-unsigned long get_hypervisor_tsc_freq(void)
+static inline int __vmware_platform(void)
 {
-	if (boot_cpu_data.x86_hyper_vendor == X86_HYPER_VENDOR_VMWARE)
-		return vmware_get_tsc_khz();
+	uint32_t eax, ebx, ecx, edx;
+
+	VMWARE_PORT(GETVERSION, eax, ebx, ecx, edx);
+
+	return eax != (uint32_t)-1 && ebx == VMWARE_HYPERVISOR_MAGIC;
+}
+
+/*
+ * While checking the dmi string infomation, just checking the product
+ * serial key should be enough, as this will always have a VMware
+ * specific string when running under VMware hypervisor.
+ */
+static int vmware_platform(void)
+{
+	if (cpu_has_hypervisor) {
+		unsigned int eax, ebx, ecx, edx;
+		char hyper_vendor_id[13];
+
+		cpuid(CPUID_VMWARE_INFO_LEAF, &eax, &ebx, &ecx, &edx);
+		memcpy(hyper_vendor_id + 0, &ebx, 4);
+		memcpy(hyper_vendor_id + 4, &ecx, 4);
+		memcpy(hyper_vendor_id + 8, &edx, 4);
+		hyper_vendor_id[12] = '\0';
+		if (!strcmp(hyper_vendor_id, "VMwareVMware"))
+			return 1;
+	} else if (dmi_available && dmi_name_in_serial("VMware") &&
+		   __vmware_platform())
+		return 1;
+
 	return 0;
 }
 
-static inline void __cpuinit
-hypervisor_set_feature_bits(struct cpuinfo_x86 *c)
+unsigned long get_hypervisor_tsc_freq(void)
 {
-	if (boot_cpu_data.x86_hyper_vendor == X86_HYPER_VENDOR_VMWARE) {
-		vmware_set_feature_bits(c);
-		return;
-	}
+	if (boot_cpu_data.x86_hyper_vendor == X86_HYPER_VENDOR_VMWARE)
+		return vmware_get_tsc_khz();
+
+	return 0;
 }
 
 void __cpuinit init_hypervisor(struct cpuinfo_x86 *c)
 {
-	detect_hypervisor_vendor(c);
-	hypervisor_set_feature_bits(c);
+	if (vmware_platform()) {
+		c->x86_hyper_vendor = X86_HYPER_VENDOR_VMWARE;
+		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
+		set_cpu_cap(c, X86_FEATURE_TSC_RELIABLE);
+	} else
+		c->x86_hyper_vendor = X86_HYPER_VENDOR_NONE;
 }
diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
deleted file mode 100644
index 284c399..0000000
--- a/arch/x86/kernel/cpu/vmware.c
+++ /dev/null
@@ -1,112 +0,0 @@
-/*
- * VMware Detection code.
- *
- * Copyright (C) 2008, VMware, Inc.
- * Author : Alok N Kataria <akataria@vmware.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- * NON INFRINGEMENT.  See the GNU General Public License for more
- * details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
- *
- */
-
-#include <linux/dmi.h>
-#include <asm/div64.h>
-#include <asm/vmware.h>
-
-#define CPUID_VMWARE_INFO_LEAF	0x40000000
-#define VMWARE_HYPERVISOR_MAGIC	0x564D5868
-#define VMWARE_HYPERVISOR_PORT	0x5658
-
-#define VMWARE_PORT_CMD_GETVERSION	10
-#define VMWARE_PORT_CMD_GETHZ		45
-
-#define VMWARE_PORT(cmd, eax, ebx, ecx, edx)				\
-	__asm__("inl (%%dx)" :						\
-			"=a"(eax), "=c"(ecx), "=d"(edx), "=b"(ebx) :	\
-			"0"(VMWARE_HYPERVISOR_MAGIC),			\
-			"1"(VMWARE_PORT_CMD_##cmd),			\
-			"2"(VMWARE_HYPERVISOR_PORT), "3"(UINT_MAX) :	\
-			"memory");
-
-static inline int __vmware_platform(void)
-{
-	uint32_t eax, ebx, ecx, edx;
-	VMWARE_PORT(GETVERSION, eax, ebx, ecx, edx);
-	return eax != (uint32_t)-1 && ebx == VMWARE_HYPERVISOR_MAGIC;
-}
-
-static unsigned long __vmware_get_tsc_khz(void)
-{
-        uint64_t tsc_hz;
-        uint32_t eax, ebx, ecx, edx;
-
-        VMWARE_PORT(GETHZ, eax, ebx, ecx, edx);
-
-        if (ebx == UINT_MAX)
-                return 0;
-        tsc_hz = eax | (((uint64_t)ebx) << 32);
-        do_div(tsc_hz, 1000);
-        BUG_ON(tsc_hz >> 32);
-        return tsc_hz;
-}
-
-/*
- * While checking the dmi string infomation, just checking the product
- * serial key should be enough, as this will always have a VMware
- * specific string when running under VMware hypervisor.
- */
-int vmware_platform(void)
-{
-	if (cpu_has_hypervisor) {
-		unsigned int eax, ebx, ecx, edx;
-		char hyper_vendor_id[13];
-
-		cpuid(CPUID_VMWARE_INFO_LEAF, &eax, &ebx, &ecx, &edx);
-		memcpy(hyper_vendor_id + 0, &ebx, 4);
-		memcpy(hyper_vendor_id + 4, &ecx, 4);
-		memcpy(hyper_vendor_id + 8, &edx, 4);
-		hyper_vendor_id[12] = '\0';
-		if (!strcmp(hyper_vendor_id, "VMwareVMware"))
-			return 1;
-	} else if (dmi_available && dmi_name_in_serial("VMware") &&
-		   __vmware_platform())
-		return 1;
-
-	return 0;
-}
-
-unsigned long vmware_get_tsc_khz(void)
-{
-	BUG_ON(!vmware_platform());
-	return __vmware_get_tsc_khz();
-}
-
-/*
- * VMware hypervisor takes care of exporting a reliable TSC to the guest.
- * Still, due to timing difference when running on virtual cpus, the TSC can
- * be marked as unstable in some cases. For example, the TSC sync check at
- * bootup can fail due to a marginal offset between vcpus' TSCs (though the
- * TSCs do not drift from each other).  Also, the ACPI PM timer clocksource
- * is not suitable as a watchdog when running on a hypervisor because the
- * kernel may miss a wrap of the counter if the vcpu is descheduled for a
- * long time. To skip these checks at runtime we set these capability bits,
- * so that the kernel could just trust the hypervisor with providing a
- * reliable virtual TSC that is suitable for timekeeping.
- */
-void __cpuinit vmware_set_feature_bits(struct cpuinfo_x86 *c)
-{
-	set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
-	set_cpu_cap(c, X86_FEATURE_TSC_RELIABLE);
-}
-- 
1.6.0.6



