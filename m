Return-Path: <linux-kernel-owner+w=401wt.eu-S1760329AbZEZXVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760329AbZEZXVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759134AbZEZXSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:18:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53169 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758978AbZEZXSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:18:32 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 12/17] x86: MCE: Enable MCE_INTEL for 32bit new MCE
Date: Wed, 27 May 2009 01:18:11 +0200
Message-Id: <6dfa191bd595ff969fafb3603ba464254ca895a7.1243377662.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <2bc54830cc9e63d090dc461db0bdf99fc3d3cd4a.1243377662.git.ak@linux.intel.com>
References: <1243379896-26869-1-git-send-email-andi@firstfloor.org>
 <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
 <86b35f6b0b17e1edc38fb5c3178967ffc4d1fa0a.1243377662.git.ak@linux.intel.com>
 <5a2337a03ce794fe7cf69e338ffacacb3770797c.1243377662.git.ak@linux.intel.com>
 <4010bb177562589d0fd54043bb7bc6ea4d7998fd.1243377662.git.ak@linux.intel.com>
 <c21d841c7b7d68f60e52c9c20c3d9573cfd8bf95.1243377662.git.ak@linux.intel.com>
 <e625a26c7a082ec6033b4a836c98d7f725fe80f9.1243377662.git.ak@linux.intel.com>
 <b7b15c0ea92409e6641de1e90da9c63664066eba.1243377662.git.ak@linux.intel.com>
 <e2d81decded3202e410a569f8c224986f2e83668.1243377662.git.ak@linux.intel.com>
 <c8c4b619d810eba16e62044a38284761ef69c8f2.1243377662.git.ak@linux.intel.com>
 <91219e907da103fc39dba8d32aaa9f872f0e6cc1.1243377662.git.ak@linux.intel.com>
 <2bc54830cc9e63d090dc461db0bdf99fc3d3cd4a.1243377662.git.ak@linux.intel.com>
In-Reply-To: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
References: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Enable the 64bit MCE_INTEL code (CMCI, thermal interrupts) for 32bit NEW_MCE.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/Kconfig                       |    2 +-
 arch/x86/include/asm/entry_arch.h      |    4 ++++
 arch/x86/include/asm/hardirq.h         |    2 +-
 arch/x86/include/asm/irq_vectors.h     |    5 +++--
 arch/x86/kernel/cpu/mcheck/threshold.c |    2 +-
 arch/x86/kernel/entry_64.S             |    2 +-
 arch/x86/kernel/irqinit_32.c           |    4 ++++
 arch/x86/kernel/traps.c                |    2 +-
 8 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c1c5ccd..e1c9f77 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -808,7 +808,7 @@ config X86_NEW_MCE
 config X86_MCE_INTEL
 	def_bool y
 	prompt "Intel MCE features"
-	depends on X86_64 && X86_MCE && X86_LOCAL_APIC
+	depends on X86_NEW_MCE && X86_LOCAL_APIC
 	---help---
 	   Additional support for intel specific MCE features such as
 	   the thermal monitor.
diff --git a/arch/x86/include/asm/entry_arch.h b/arch/x86/include/asm/entry_arch.h
index 486c9e9..b2eb9c0 100644
--- a/arch/x86/include/asm/entry_arch.h
+++ b/arch/x86/include/asm/entry_arch.h
@@ -56,4 +56,8 @@ BUILD_INTERRUPT(perf_counter_interrupt, LOCAL_PERF_VECTOR)
 BUILD_INTERRUPT(thermal_interrupt,THERMAL_APIC_VECTOR)
 #endif
 
+#ifdef CONFIG_X86_MCE_THRESHOLD
+BUILD_INTERRUPT(threshold_interrupt,THRESHOLD_APIC_VECTOR)
+#endif
+
 #endif
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index 37555e5..922ee7c 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -20,7 +20,7 @@ typedef struct {
 #endif
 #ifdef CONFIG_X86_MCE
 	unsigned int irq_thermal_count;
-# ifdef CONFIG_X86_64
+# ifdef CONFIG_X86_MCE_THRESHOLD
 	unsigned int irq_threshold_count;
 # endif
 #endif
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 3cbd79b..451e24d 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -87,10 +87,11 @@
 #define CALL_FUNCTION_SINGLE_VECTOR	0xfb
 #define THERMAL_APIC_VECTOR		0xfa
 
+#define THRESHOLD_APIC_VECTOR		0xf9
+
 #ifdef CONFIG_X86_32
-/* 0xf8 - 0xf9 : free */
+/* 0xf9 : free */
 #else
-# define THRESHOLD_APIC_VECTOR		0xf9
 # define UV_BAU_MESSAGE			0xf8
 #endif
 
diff --git a/arch/x86/kernel/cpu/mcheck/threshold.c b/arch/x86/kernel/cpu/mcheck/threshold.c
index 23ee9e7..d746df2 100644
--- a/arch/x86/kernel/cpu/mcheck/threshold.c
+++ b/arch/x86/kernel/cpu/mcheck/threshold.c
@@ -17,7 +17,7 @@ static void default_threshold_interrupt(void)
 
 void (*mce_threshold_vector)(void) = default_threshold_interrupt;
 
-asmlinkage void mce_threshold_interrupt(void)
+asmlinkage void smp_threshold_interrupt(void)
 {
 	exit_idle();
 	irq_enter();
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 63276c4..a31a7f2 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1007,7 +1007,7 @@ apicinterrupt INVALIDATE_TLB_VECTOR_START+7 \
 #endif
 
 apicinterrupt THRESHOLD_APIC_VECTOR \
-	threshold_interrupt mce_threshold_interrupt
+	threshold_interrupt smp_threshold_interrupt
 apicinterrupt THERMAL_APIC_VECTOR \
 	thermal_interrupt smp_thermal_interrupt
 
diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index 98846e0..2512ad9 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -186,6 +186,10 @@ void __init native_init_IRQ(void)
 	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
 #endif
 
+#ifdef CONFIG_X86_MCE_THRESHOLD
+	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
+#endif
+
 	if (!acpi_ioapic)
 		setup_irq(2, &irq2);
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index ad771f1..0d358c8 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -804,7 +804,7 @@ asmlinkage void __attribute__((weak)) smp_thermal_interrupt(void)
 {
 }
 
-asmlinkage void __attribute__((weak)) mce_threshold_interrupt(void)
+asmlinkage void __attribute__((weak)) smp_threshold_interrupt(void)
 {
 }
 
-- 
1.6.0.2

