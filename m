Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbYIZXrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbYIZXrL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 19:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbYIZXq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 19:46:57 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:38068 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752332AbYIZXq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 19:46:56 -0400
Subject: Use CPUID to communicate with the hypervisor.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, avi@redhat.com,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       Dan Hecht <dhecht@vmware.com>, Jun.Nakajima@Intel.Com
Content-Type: text/plain
Organization: VMware INC.
Date: Fri, 26 Sep 2008 16:46:55 -0700
Message-Id: <1222472815.29886.43.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alok N Kataria <akataria@vmware.com>

This patch proposes to use a cpuid interface to detect if we are running on an
hypervisor.
The discovery of a hypervisor is determined by bit 31 of CPUID#1_ECX, which is
defined to be "hypervisor present bit". For a VM, the bit is 1, otherwise it is
set to 0. This bit is not officially documented by either Intel/AMD yet, but
they plan to do so some time soon, in the meanwhile they have promised to keep
it reserved for virtualization.

Also, Intel & AMD have reserved the cpuid levels 0x40000000 - 0x400000FF for
software use. Hypervisors can use these levels to provide an interface to pass
information from the hypervisor to the guest. This is similar to how we extract
information about a physical cpu by using cpuid.
XEN/KVM are already using the info leaf to get the hypervisor signature.

VMware hardware version 7 defines some of these cpuid levels, below is a brief
description about those. These levels can be implemented by other hypervisors
too so that Linux has a standard way of communicating to any hypervisor.

Leaf 0x40000000, Hypervisor CPUID information
# EAX: The maximum input value for hypervisor CPUID info (0x40000010).
# EBX, ECX, EDX: Hypervisor vendor ID signature. E.g. "VMwareVMware"

Leaf 0x40000010,  Timing information.
# EAX: (Virtual) TSC frequency in kHz.
# EBX: (Virtual) Bus (local apic timer) frequency in kHz.
# ECX, EDX: RESERVED

This patch uses the timing leaf to get the tsc_frequency from the hypervisor.
Since the calibration algorithm can have errors in a virtualized environment,
the best way to calibrate TSC frequency would be to ask the hypervisor about it.

Along with it we also use the hypervisor information leaf to print info messages
at kernel bootup.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Cc: Jun Nakajima <Jun.Nakajima@Intel.Com>
---

 arch/x86/kernel/setup.c      |   17 +++++++++++++++++
 arch/x86/kernel/tsc.c        |   24 +++++++++++++++++++++++-
 include/asm-x86/cpufeature.h |    2 ++
 include/asm-x86/processor.h  |   21 +++++++++++++++++++++
 4 files changed, 63 insertions(+), 1 deletions(-)


diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 6133530..14a4f64 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -765,6 +765,21 @@ static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
 	{}
 };
 
+static void __init detect_hypervisor(void)
+{
+	if (cpu_has_hypervisor) {
+		unsigned int eax, ebx, ecx, edx;
+		char hyper_vendor_id[13];
+
+		cpuid(HYPERVISOR_INFO_LEAF, &eax, &ebx, &ecx, &edx);
+		memcpy(hyper_vendor_id + 0, &ebx, 4);
+		memcpy(hyper_vendor_id + 4, &ecx, 4);
+		memcpy(hyper_vendor_id + 8, &edx, 4);
+		hyper_vendor_id[12] = '\0';
+		printk(KERN_INFO "Hypervisor vendor id %s\n", hyper_vendor_id);
+	}
+}
+
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
@@ -915,6 +930,8 @@ void __init setup_arch(char **cmdline_p)
 	if (efi_enabled)
 		efi_init();
 
+	detect_hypervisor();
+
 #ifdef CONFIG_X86_32
 	if (ppro_with_ram_bug()) {
 		e820_update_range(0x70000000ULL, 0x40000ULL, E820_RAM,
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 161bb85..605cf84 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -345,16 +345,38 @@ failed:
 	return 0;
 }
 
+unsigned long hypervisor_tsc_freq(void)
+{
+	unsigned long tsc_khz;
+	unsigned int max_cpuid_leaf;
+
+	if (cpu_has_hypervisor) {
+		max_cpuid_leaf = cpuid_eax(HYPERVISOR_INFO_LEAF);
+		if (max_cpuid_leaf >= HYPERVISOR_TIMING_LEAF) {
+			tsc_khz = cpuid_eax(HYPERVISOR_TIMING_LEAF);
+			printk(KERN_INFO
+				"TSC frequency read from hypervisor\n");
+			return tsc_khz;
+		}
+	}
+	return 0;
+}
+
 /**
  * native_calibrate_tsc - calibrate the tsc on boot
+ * return value is the tsc frequency in khz.
  */
 unsigned long native_calibrate_tsc(void)
 {
 	u64 tsc1, tsc2, delta, ref1, ref2;
 	unsigned long tsc_pit_min = ULONG_MAX, tsc_ref_min = ULONG_MAX;
-	unsigned long flags, latch, ms, fast_calibrate;
+	unsigned long flags, latch, ms, fast_calibrate, tsc_khz;
 	int hpet = is_hpet_enabled(), i, loopmin;
 
+	tsc_khz = hypervisor_tsc_freq();
+	if (tsc_khz)
+		return tsc_khz;
+
 	local_irq_save(flags);
 	fast_calibrate = quick_pit_calibrate();
 	local_irq_restore(flags);
diff --git a/include/asm-x86/cpufeature.h b/include/asm-x86/cpufeature.h
index 800ec03..d3aaff0 100644
--- a/include/asm-x86/cpufeature.h
+++ b/include/asm-x86/cpufeature.h
@@ -116,6 +116,7 @@
 #define X86_FEATURE_XSAVE	(4*32+26) /* XSAVE/XRSTOR/XSETBV/XGETBV */
 #define X86_FEATURE_OSXSAVE	(4*32+27) /* "" XSAVE enabled in the OS */
 #define X86_FEATURE_AVX		(4*32+28) /* Advanced Vector Extensions */
+#define X86_FEATURE_HYPERVISOR	(4*32+31) /* Running on a hypervisor */
 
 /* VIA/Cyrix/Centaur-defined CPU features, CPUID level 0xC0000001, word 5 */
 #define X86_FEATURE_XSTORE	(5*32+ 2) /* "rng" RNG present (xstore) */
@@ -236,6 +237,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_xmm4_2		boot_cpu_has(X86_FEATURE_XMM4_2)
 #define cpu_has_x2apic		boot_cpu_has(X86_FEATURE_X2APIC)
 #define cpu_has_xsave		boot_cpu_has(X86_FEATURE_XSAVE)
+#define cpu_has_hypervisor	boot_cpu_has(X86_FEATURE_HYPERVISOR)
 
 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg		1
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index ee7cbb3..70ca49b 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -124,6 +124,27 @@ struct cpuinfo_x86 {
 #define X86_VENDOR_UNKNOWN	0xff
 
 /*
+ * Intel & AMD have reserved the cpuid levels 0x40000000 - 0x400000FF for
+ * software use. Hypervisors can use these levels to provide an interface
+ * to pass information from the hypervisor to the guest. This is similar
+ * to how we extract information about a physical cpu by using cpuid.
+ */
+
+/*
+ * This CPUID leaf returns the information about the hypervisor.
+ * EAX : maximum input value for CPUID supported by the hypervisor.
+ * EBX, ECX, EDX : Hypervisor vendor ID signature. E.g. VMwareVMware.
+ */
+#define HYPERVISOR_INFO_LEAF   0x40000000
+/*
+ * This leaf gets timing information from the hypervisor.
+ * EAX: (Virtual) TSC frequency in kHz.
+ * EBX: (Virtual) Bus (local apic timer) frequency in kHz.
+ * ECX, EDX: RESERVED
+ */
+#define HYPERVISOR_TIMING_LEAF 0x40000010
+
+/*
  * capabilities of CPUs
  */
 extern struct cpuinfo_x86	boot_cpu_data;


