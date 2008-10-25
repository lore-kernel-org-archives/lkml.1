Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbYJYAWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbYJYAWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 20:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757872AbYJYAWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 20:22:17 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:43530 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757643AbYJYAWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 20:22:01 -0400
Subject: [PATCH 3/4] Add a synthetic TSC_RELIABLE feature bit.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Fri, 24 Oct 2008 17:22:00 -0700
Message-Id: <1224894120.28224.73.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: Add a synthetic TSC_RELIABLE feature bit.

From: Alok N Kataria <akataria@vmware.com>

Virtual TSCs can be kept nearly in sync, but because the virtual TSC
offset is set by software, it's not perfect.  So, the TSC
synchronization test can fail. Even then the TSC can be used as a
clocksource since the VMware platform exports a reliable TSC to the
guest for timekeeping purposes. Use this bit to check if we need to
skip the TSC sync checks.

Along with this also set the CONSTANT_TSC bit when on VMware, since we
still want to use TSC as clocksource on VM running over hardware which
has unsynchronized TSC's (opteron's), since the hypervisor will take
care of providing consistent TSC to the guest.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Signed-off-by: Dan Hecht <dhecht@vmware.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---

 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/include/asm/vmware.h     |    1 +
 arch/x86/kernel/cpu/hypervisor.c  |   11 ++++++++++-
 arch/x86/kernel/cpu/vmware.c      |   18 ++++++++++++++++++
 arch/x86/kernel/tsc_sync.c        |    8 +++++++-
 5 files changed, 37 insertions(+), 2 deletions(-)


diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 78478f2..7f9fa2b 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -92,6 +92,7 @@
 #define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
 #define X86_FEATURE_AMDC1E	(3*32+21) /* AMD C1E detected */
 #define X86_FEATURE_XTOPOLOGY	(3*32+21) /* cpu topology enum extensions */
+#define X86_FEATURE_TSC_RELIABLE (3*32+22) /* TSC is known to be reliable */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
diff --git a/arch/x86/include/asm/vmware.h b/arch/x86/include/asm/vmware.h
index 02dfea5..c11b7e1 100644
--- a/arch/x86/include/asm/vmware.h
+++ b/arch/x86/include/asm/vmware.h
@@ -22,5 +22,6 @@
 
 extern unsigned long vmware_get_tsc_khz(void);
 extern int vmware_platform(void);
+extern void vmware_set_feature_bits(struct cpuinfo_x86 *c);
 
 #endif
diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index 7bd5506..35ae2b7 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -41,8 +41,17 @@ unsigned long get_hypervisor_tsc_freq(void)
 	return 0;
 }
 
+static inline void __cpuinit
+hypervisor_set_feature_bits(struct cpuinfo_x86 *c)
+{
+	if (boot_cpu_data.x86_hyper_vendor == X86_HYPER_VENDOR_VMWARE) {
+		vmware_set_feature_bits(c);
+		return;
+	}
+}
+
 void __cpuinit init_hypervisor(struct cpuinfo_x86 *c)
 {
 	detect_hypervisor_vendor(c);
+	hypervisor_set_feature_bits(c);
 }
-
diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index 650de86..5539e59 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -85,3 +85,21 @@ unsigned long vmware_get_tsc_khz(void)
 	BUG_ON(!vmware_platform());
 	return __vmware_get_tsc_khz();
 }
+
+/*
+ * VMware hypervisor takes care of exporting a reliable TSC to the guest.
+ * Still, due to timing difference when running on virtual cpus, the TSC can
+ * be marked as unstable in some cases. For example, the TSC sync check at
+ * bootup can fail due to a marginal offset between vcpus' TSCs (though the
+ * TSCs do not drift from each other).  Also, the ACPI PM timer clocksource
+ * is not suitable as a watchdog when running on a hypervisor because the
+ * kernel may miss a wrap of the counter if the vcpu is descheduled for a
+ * long time. To skip these checks at runtime we set these capability bits,
+ * so that the kernel could just trust the hypervisor with providing a
+ * reliable virtual TSC that is suitable for timekeeping.
+ */
+void __cpuinit vmware_set_feature_bits(struct cpuinfo_x86 *c)
+{
+	set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
+	set_cpu_cap(c, X86_FEATURE_TSC_RELIABLE);
+}
diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 9ffb01c..5977c40 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -108,6 +108,12 @@ void __cpuinit check_tsc_sync_source(int cpu)
 	if (unsynchronized_tsc())
 		return;
 
+	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE)) {
+		printk(KERN_INFO
+		       "Skipping synchronization checks as TSC is reliable.\n");
+		return;
+	}
+
 	printk(KERN_INFO "checking TSC synchronization [CPU#%d -> CPU#%d]:",
 			  smp_processor_id(), cpu);
 
@@ -161,7 +167,7 @@ void __cpuinit check_tsc_sync_target(void)
 {
 	int cpus = 2;
 
-	if (unsynchronized_tsc())
+	if (unsynchronized_tsc() || boot_cpu_has(X86_FEATURE_TSC_RELIABLE))
 		return;
 
 	/*


