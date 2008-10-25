Return-Path: <linux-kernel-owner+w=401wt.eu-S1757258AbYJYAWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258AbYJYAWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 20:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757346AbYJYAVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 20:21:48 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:57242 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757225AbYJYAVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 20:21:45 -0400
Subject: [PATCH 2/4] Hypervisor detection and get tsc_freq from hypervisor
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Fri, 24 Oct 2008 17:21:44 -0700
Message-Id: <1224894104.28224.72.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: Get TSC frequency from VMware hypervisor.

From: Alok N Kataria <akataria@vmware.com>

v3->v2 : Abstract the hypervisor detection and feature (tsc_freq) request
	 behind a hypervisor.c file
v2->v1 : Add a x86_hyper_vendor field to the cpuinfo_x86 structure.
	 This avoids multiple calls to the hypervisor detection function.

This patch adds functions to detect if we are running under VMware.
The current way to check if we are on VMware is following,
#  check if "hypervisor present bit" is set, if so read the 0x40000000
   cpuid leaf and check for "VMwareVMware" signature.
#  if the above fails, check the DMI vendors name for "VMware" string
   if we find one we query the VMware backdoor port to check if we are
   under VMware.

The DMI + Backdoor check is needed for older VMware products, which
don't implement the hypervisor signature cpuid leaf.
Also note that since we are checking for the DMI signature the backdoor
port would never be accessed on native hardware.

This patch also adds a hypervisor_get_tsc_freq function, instead of
calibrating the frequency which can be error prone in virtualized
environment, we ask the hypervisor for it. We get the frequency from
the hypervisor by accessing the backdoor port if we are running on VMware.
Other hypervisors too can add code to get frequency on their platform
to this routine.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Signed-off-by: Dan Hecht <dhecht@vmware.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---

 arch/x86/include/asm/cpufeature.h |    2 +
 arch/x86/include/asm/hypervisor.h |   26 +++++++++++
 arch/x86/include/asm/processor.h  |    4 ++
 arch/x86/include/asm/vmware.h     |   26 +++++++++++
 arch/x86/kernel/cpu/Makefile      |    1 
 arch/x86/kernel/cpu/common.c      |    2 +
 arch/x86/kernel/cpu/hypervisor.c  |   48 ++++++++++++++++++++
 arch/x86/kernel/cpu/vmware.c      |   87 +++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup.c           |    7 +++
 arch/x86/kernel/tsc.c             |    9 +++-
 10 files changed, 211 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/include/asm/hypervisor.h
 create mode 100644 arch/x86/include/asm/vmware.h
 create mode 100644 arch/x86/kernel/cpu/hypervisor.c
 create mode 100644 arch/x86/kernel/cpu/vmware.c


diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index f73e95d..78478f2 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -117,6 +117,7 @@
 #define X86_FEATURE_XSAVE	(4*32+26) /* XSAVE/XRSTOR/XSETBV/XGETBV */
 #define X86_FEATURE_OSXSAVE	(4*32+27) /* "" XSAVE enabled in the OS */
 #define X86_FEATURE_AVX		(4*32+28) /* Advanced Vector Extensions */
+#define X86_FEATURE_HYPERVISOR	(4*32+31) /* Running on a hypervisor */
 
 /* VIA/Cyrix/Centaur-defined CPU features, CPUID level 0xC0000001, word 5 */
 #define X86_FEATURE_XSTORE	(5*32+ 2) /* "rng" RNG present (xstore) */
@@ -237,6 +238,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_xmm4_2		boot_cpu_has(X86_FEATURE_XMM4_2)
 #define cpu_has_x2apic		boot_cpu_has(X86_FEATURE_X2APIC)
 #define cpu_has_xsave		boot_cpu_has(X86_FEATURE_XSAVE)
+#define cpu_has_hypervisor	boot_cpu_has(X86_FEATURE_HYPERVISOR)
 
 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg		1
diff --git a/arch/x86/include/asm/hypervisor.h b/arch/x86/include/asm/hypervisor.h
new file mode 100644
index 0000000..369f5c5
--- /dev/null
+++ b/arch/x86/include/asm/hypervisor.h
@@ -0,0 +1,26 @@
+/*
+ * Copyright (C) 2008, VMware, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+#ifndef ASM_X86__HYPERVISOR_H
+#define ASM_X86__HYPERVISOR_H
+
+extern unsigned long get_hypervisor_tsc_freq(void);
+extern void init_hypervisor(struct cpuinfo_x86 *c);
+
+#endif
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 5ca01e3..a570eaf 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -110,6 +110,7 @@ struct cpuinfo_x86 {
 	/* Index into per_cpu list: */
 	u16			cpu_index;
 #endif
+	unsigned int		x86_hyper_vendor;
 } __attribute__((__aligned__(SMP_CACHE_BYTES)));
 
 #define X86_VENDOR_INTEL	0
@@ -123,6 +124,9 @@ struct cpuinfo_x86 {
 
 #define X86_VENDOR_UNKNOWN	0xff
 
+#define X86_HYPER_VENDOR_NONE  0
+#define X86_HYPER_VENDOR_VMWARE 1
+
 /*
  * capabilities of CPUs
  */
diff --git a/arch/x86/include/asm/vmware.h b/arch/x86/include/asm/vmware.h
new file mode 100644
index 0000000..02dfea5
--- /dev/null
+++ b/arch/x86/include/asm/vmware.h
@@ -0,0 +1,26 @@
+/*
+ * Copyright (C) 2008, VMware, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+#ifndef ASM_X86__VMWARE_H
+#define ASM_X86__VMWARE_H
+
+extern unsigned long vmware_get_tsc_khz(void);
+extern int vmware_platform(void);
+
+#endif
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 82ec607..a5c04e8 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -4,6 +4,7 @@
 
 obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
 obj-y			+= proc.o capflags.o powerflags.o common.o
+obj-y			+= vmware.o hypervisor.o
 
 obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
 obj-$(CONFIG_X86_64)	+= bugs_64.o
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 25581dc..c80d233 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -35,6 +35,7 @@
 #include <asm/proto.h>
 #include <asm/sections.h>
 #include <asm/setup.h>
+#include <asm/hypervisor.h>
 
 #include "cpu.h"
 
@@ -698,6 +699,7 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 	detect_ht(c);
 #endif
 
+	init_hypervisor(c);
 	/*
 	 * On SMP, boot_cpu_data holds the common feature set between
 	 * all CPUs; so make sure that we indicate which features are
diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
new file mode 100644
index 0000000..7bd5506
--- /dev/null
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -0,0 +1,48 @@
+/*
+ * Common hypervisor code
+ *
+ * Copyright (C) 2008, VMware, Inc.
+ * Author : Alok N Kataria <akataria@vmware.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#include <asm/processor.h>
+#include <asm/vmware.h>
+
+static inline void __cpuinit
+detect_hypervisor_vendor(struct cpuinfo_x86 *c)
+{
+	if (vmware_platform()) {
+		c->x86_hyper_vendor = X86_HYPER_VENDOR_VMWARE;
+	} else {
+		c->x86_hyper_vendor = X86_HYPER_VENDOR_NONE;
+	}
+}
+
+unsigned long get_hypervisor_tsc_freq(void)
+{
+	if (boot_cpu_data.x86_hyper_vendor == X86_HYPER_VENDOR_VMWARE)
+		return vmware_get_tsc_khz();
+	return 0;
+}
+
+void __cpuinit init_hypervisor(struct cpuinfo_x86 *c)
+{
+	detect_hypervisor_vendor(c);
+}
+
diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
new file mode 100644
index 0000000..650de86
--- /dev/null
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -0,0 +1,87 @@
+/*
+ * VMware Detection code.
+ *
+ * Copyright (C) 2008, VMware, Inc.
+ * Author : Alok N Kataria <akataria@vmware.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#include <linux/dmi.h>
+#include <asm/div64.h>
+
+#define CPUID_VMWARE_INFO_LEAF	0x40000000
+#define VMWARE_BDOOR_MAGIC	0x564D5868
+#define VMWARE_BDOOR_PORT	0x5658
+
+#define VMWARE_BDOOR_CMD_GETVERSION	10
+#define VMWARE_BDOOR_CMD_GETHZ		45
+
+#define VMWARE_BDOOR(cmd, eax, ebx, ecx, edx)                         \
+	__asm__("inl (%%dx)" :                                        \
+			"=a"(eax), "=c"(ecx), "=d"(edx), "=b"(ebx) :          \
+			"0"(VMWARE_BDOOR_MAGIC), "1"(VMWARE_BDOOR_CMD_##cmd), \
+			"2"(VMWARE_BDOOR_PORT), "3"(0) :                      \
+			"memory");
+
+static inline int __vmware_platform(void)
+{
+	uint32_t eax, ebx, ecx, edx;
+	VMWARE_BDOOR(GETVERSION, eax, ebx, ecx, edx);
+	return eax != (uint32_t)-1 && ebx == VMWARE_BDOOR_MAGIC;
+}
+
+static unsigned long __vmware_get_tsc_khz(void)
+{
+        uint64_t tsc_hz;
+        uint32_t eax, ebx, ecx, edx;
+
+        VMWARE_BDOOR(GETHZ, eax, ebx, ecx, edx);
+
+        if (eax == (uint32_t)-1)
+                return 0;
+        tsc_hz = eax | (((uint64_t)ebx) << 32);
+        do_div(tsc_hz, 1000);
+        BUG_ON(tsc_hz >> 32);
+        return tsc_hz;
+}
+
+int vmware_platform(void)
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
+	} else if (dmi_available && dmi_name_in_vendors("VMware") &&
+		   __vmware_platform())
+		return 1;
+
+	return 0;
+}
+
+unsigned long vmware_get_tsc_khz(void)
+{
+	BUG_ON(!vmware_platform());
+	return __vmware_get_tsc_khz();
+}
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c35ec3f..47ba46f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -98,6 +98,7 @@
 
 #include <mach_apic.h>
 #include <asm/paravirt.h>
+#include <asm/hypervisor.h>
 
 #include <asm/percpu.h>
 #include <asm/topology.h>
@@ -911,6 +912,12 @@ void __init setup_arch(char **cmdline_p)
 
 	dmi_check_system(bad_bios_dmi_table);
 
+	/*
+	 * VMware detection requires dmi to be available, so this
+	 * needs to be done after dmi_scan_machine, for the BP.
+	 */
+	init_hypervisor(&boot_cpu_data);
+
 #ifdef CONFIG_X86_32
 	probe_roms();
 #endif
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 161bb85..189741f 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -15,6 +15,7 @@
 #include <asm/vgtod.h>
 #include <asm/time.h>
 #include <asm/delay.h>
+#include <asm/hypervisor.h>
 
 unsigned int cpu_khz;           /* TSC clocks / usec, not used here */
 EXPORT_SYMBOL(cpu_khz);
@@ -352,9 +353,15 @@ unsigned long native_calibrate_tsc(void)
 {
 	u64 tsc1, tsc2, delta, ref1, ref2;
 	unsigned long tsc_pit_min = ULONG_MAX, tsc_ref_min = ULONG_MAX;
-	unsigned long flags, latch, ms, fast_calibrate;
+	unsigned long flags, latch, ms, fast_calibrate, tsc_khz;
 	int hpet = is_hpet_enabled(), i, loopmin;
 
+	tsc_khz = get_hypervisor_tsc_freq();
+	if (tsc_khz) {
+		printk(KERN_INFO "TSC: Frequency read from the hypervisor\n");
+		return tsc_khz;
+	}
+
 	local_irq_save(flags);
 	fast_calibrate = quick_pit_calibrate();
 	local_irq_restore(flags);


