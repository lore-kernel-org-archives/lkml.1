Return-Path: <linux-kernel-owner+w=401wt.eu-S1758837AbYEVUbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837AbYEVUbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbYEVUbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:31:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384AbYEVUbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:31:22 -0400
Date: Thu, 22 May 2008 15:44:10 -0400
Message-Id: <200805221944.m4MJiAGi029848@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa@zytor.com
Subject: [X86] Move the 64-bit Centaur specific parts out of setup_64.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a separate centaur_64.c file in the cpu/ dir for
the useful parts to live in.

Signed-off-by: Dave Jones <davej@redhat.com>
---
 arch/x86/kernel/cpu/Makefile     |    1 +
 arch/x86/kernel/cpu/centaur_64.c |   28 ++++++++++++++++++++++++++++
 arch/x86/kernel/setup_64.c       |   29 ++---------------------------
 3 files changed, 31 insertions(+), 27 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/centaur_64.c

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index b7a1192..c77a1c5 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_X86_32)	+= amd.o
 obj-$(CONFIG_X86_64)	+= amd_64.o
 obj-$(CONFIG_X86_32)	+= cyrix.o
 obj-$(CONFIG_X86_32)	+= centaur.o
+obj-$(CONFIG_X86_64)	+= centaur_64.o
 obj-$(CONFIG_X86_32)	+= transmeta.o
 obj-$(CONFIG_X86_32)	+= intel.o
 obj-$(CONFIG_X86_64)	+= intel_64.o
diff --git a/arch/x86/kernel/cpu/centaur_64.c b/arch/x86/kernel/cpu/centaur_64.c
new file mode 100644
index 0000000..08e07b5
--- /dev/null
+++ b/arch/x86/kernel/cpu/centaur_64.c
@@ -0,0 +1,28 @@
+#include <linux/init.h>
+#include <linux/smp.h>
+
+void __cpuinit early_init_centaur(struct cpuinfo_x86 *c)
+{
+	if (c->x86 == 0x6 && c->x86_model >= 0xf)
+		set_bit(X86_FEATURE_CONSTANT_TSC, &c->x86_capability);
+}
+
+void __cpuinit init_centaur(struct cpuinfo_x86 *c)
+{
+	/* Cache sizes */
+	unsigned n;
+
+	n = c->extended_cpuid_level;
+	if (n >= 0x80000008) {
+		unsigned eax = cpuid_eax(0x80000008);
+		c->x86_virt_bits = (eax >> 8) & 0xff;
+		c->x86_phys_bits = eax & 0xff;
+	}
+
+	if (c->x86 == 0x6 && c->x86_model >= 0xf) {
+		c->x86_cache_alignment = c->x86_clflush_size * 2;
+		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
+		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
+	}
+	set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
+}
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index b3d25d6..9159f85 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -614,33 +614,6 @@ out:
 #endif
 }
 
-
-static void __cpuinit early_init_centaur(struct cpuinfo_x86 *c)
-{
-	if (c->x86 == 0x6 && c->x86_model >= 0xf)
-		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
-}
-
-static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
-{
-	/* Cache sizes */
-	unsigned n;
-
-	n = c->extended_cpuid_level;
-	if (n >= 0x80000008) {
-		unsigned eax = cpuid_eax(0x80000008);
-		c->x86_virt_bits = (eax >> 8) & 0xff;
-		c->x86_phys_bits = eax & 0xff;
-	}
-
-	if (c->x86 == 0x6 && c->x86_model >= 0xf) {
-		c->x86_cache_alignment = c->x86_clflush_size * 2;
-		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
-		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
-	}
-	set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
-}
-
 static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
 {
 	char *v = c->x86_vendor_id;
@@ -660,6 +633,8 @@ extern void __cpuinit early_init_amd(struct cpuinfo_x86 *c);
 extern void __cpuinit init_amd(struct cpuinfo_x86 *c);
 extern void __cpuinit early_init_intel(struct cpuinfo_x86 *c);
 extern void __cpuinit init_intel(struct cpuinfo_x86 *c);
+extern void __cpuinit early_init_centaur(struct cpuinfo_x86 *c);
+extern void __cpuinit init_centaur(struct cpuinfo_x86 *c);
 
 /* Do some early cpuid on the boot CPU to get some parameter that are
    needed before check_bugs. Everything advanced is in identify_cpu
-- 
1.5.5.1

