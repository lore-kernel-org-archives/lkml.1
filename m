Return-Path: <linux-kernel-owner+w=401wt.eu-S1756915AbZCNPc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbZCNPc2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 11:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756773AbZCNPcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 11:32:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:59514 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756610AbZCNPcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 11:32:12 -0400
Date: Sat, 14 Mar 2009 15:30:28 GMT
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       sebastian@breakpoint.cc, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, sebastian@breakpoint.cc, mingo@elte.hu
In-Reply-To: <1237029843-28076-2-git-send-email-sebastian@breakpoint.cc>
References: <1237029843-28076-2-git-send-email-sebastian@breakpoint.cc>
Subject: [tip:x86/cpu] x86/centaur: merge 32 & 64 bit version
Message-ID: <tip-48f4c485c275e9550fa1a1191768689cc3ae0037@git.kernel.org>
Git-Commit-ID: 48f4c485c275e9550fa1a1191768689cc3ae0037
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 14 Mar 2009 15:30:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  48f4c485c275e9550fa1a1191768689cc3ae0037
Gitweb:     http://git.kernel.org/tip/48f4c485c275e9550fa1a1191768689cc3ae0037
Author:     Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
AuthorDate: Sat, 14 Mar 2009 12:24:02 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 14 Mar 2009 16:27:29 +0100

x86/centaur: merge 32 & 64 bit version

there should be no difference, except:

 * the 64bit variant now also initializes the padlock unit.
 * ->c_early_init() is executed again from ->c_init()
 * the 64bit fixups made into 32bit path.

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: herbert@gondor.apana.org.au
LKML-Reference: <1237029843-28076-2-git-send-email-sebastian@breakpoint.cc>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/Kconfig.cpu             |   17 +----------------
 arch/x86/kernel/cpu/Makefile     |    3 +--
 arch/x86/kernel/cpu/centaur.c    |   34 +++++++++++++++++++++++++++-------
 arch/x86/kernel/cpu/centaur_64.c |   37 -------------------------------------
 4 files changed, 29 insertions(+), 62 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index a95eaf0..924e156 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -456,24 +456,9 @@ config CPU_SUP_AMD
 
 	  If unsure, say N.
 
-config CPU_SUP_CENTAUR_32
+config CPU_SUP_CENTAUR
 	default y
 	bool "Support Centaur processors" if PROCESSOR_SELECT
-	depends on !64BIT
-	---help---
-	  This enables detection, tunings and quirks for Centaur processors
-
-	  You need this enabled if you want your kernel to run on a
-	  Centaur CPU. Disabling this option on other types of CPUs
-	  makes the kernel a tiny bit smaller. Disabling it on a Centaur
-	  CPU might render the kernel unbootable.
-
-	  If unsure, say N.
-
-config CPU_SUP_CENTAUR_64
-	default y
-	bool "Support Centaur processors" if PROCESSOR_SELECT
-	depends on 64BIT
 	---help---
 	  This enables detection, tunings and quirks for Centaur processors
 
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index d4356f8..4e242f9 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -19,8 +19,7 @@ obj-$(CONFIG_X86_CPU_DEBUG)		+= cpu_debug.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= intel.o
 obj-$(CONFIG_CPU_SUP_AMD)		+= amd.o
 obj-$(CONFIG_CPU_SUP_CYRIX_32)		+= cyrix.o
-obj-$(CONFIG_CPU_SUP_CENTAUR_32)	+= centaur.o
-obj-$(CONFIG_CPU_SUP_CENTAUR_64)	+= centaur_64.o
+obj-$(CONFIG_CPU_SUP_CENTAUR)		+= centaur.o
 obj-$(CONFIG_CPU_SUP_TRANSMETA_32)	+= transmeta.o
 obj-$(CONFIG_CPU_SUP_UMC_32)		+= umc.o
 
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index 983e083..c95e831 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -1,11 +1,11 @@
+#include <linux/bitops.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/bitops.h>
 
 #include <asm/processor.h>
-#include <asm/msr.h>
 #include <asm/e820.h>
 #include <asm/mtrr.h>
+#include <asm/msr.h>
 
 #include "cpu.h"
 
@@ -276,7 +276,7 @@ static void __cpuinit init_c3(struct cpuinfo_x86 *c)
 		 */
 		c->x86_capability[5] = cpuid_edx(0xC0000001);
 	}
-
+#ifdef CONFIG_X86_32
 	/* Cyrix III family needs CX8 & PGE explicitly enabled. */
 	if (c->x86_model >= 6 && c->x86_model <= 9) {
 		rdmsr(MSR_VIA_FCR, lo, hi);
@@ -288,6 +288,11 @@ static void __cpuinit init_c3(struct cpuinfo_x86 *c)
 	/* Before Nehemiah, the C3's had 3dNOW! */
 	if (c->x86_model >= 6 && c->x86_model < 9)
 		set_cpu_cap(c, X86_FEATURE_3DNOW);
+#endif
+	if (c->x86 == 0x6 && c->x86_model >= 0xf) {
+		c->x86_cache_alignment = c->x86_clflush_size * 2;
+		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
+	}
 
 	display_cacheinfo(c);
 }
@@ -316,16 +321,25 @@ enum {
 static void __cpuinit early_init_centaur(struct cpuinfo_x86 *c)
 {
 	switch (c->x86) {
+#ifdef CONFIG_X86_32
 	case 5:
 		/* Emulate MTRRs using Centaur's MCR. */
 		set_cpu_cap(c, X86_FEATURE_CENTAUR_MCR);
 		break;
+#endif
+	case 6:
+		if (c->x86_model >= 0xf)
+			set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
+		break;
 	}
+#ifdef CONFIG_X86_64
+	set_cpu_cap(c, X86_FEATURE_SYSENTER32);
+#endif
 }
 
 static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
 {
-
+#ifdef CONFIG_X86_32
 	char *name;
 	u32  fcr_set = 0;
 	u32  fcr_clr = 0;
@@ -337,8 +351,10 @@ static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
 	 * 3DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway
 	 */
 	clear_cpu_cap(c, 0*32+31);
-
+#endif
+	early_init_centaur(c);
 	switch (c->x86) {
+#ifdef CONFIG_X86_32
 	case 5:
 		switch (c->x86_model) {
 		case 4:
@@ -442,16 +458,20 @@ static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
 		}
 		sprintf(c->x86_model_id, "WinChip %s", name);
 		break;
-
+#endif
 	case 6:
 		init_c3(c);
 		break;
 	}
+#ifdef CONFIG_X86_64
+	set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
+#endif
 }
 
 static unsigned int __cpuinit
 centaur_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 {
+#ifdef CONFIG_X86_32
 	/* VIA C3 CPUs (670-68F) need further shifting. */
 	if ((c->x86 == 6) && ((c->x86_model == 7) || (c->x86_model == 8)))
 		size >>= 8;
@@ -464,7 +484,7 @@ centaur_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 	if ((c->x86 == 6) && (c->x86_model == 9) &&
 				(c->x86_mask == 1) && (size == 65))
 		size -= 1;
-
+#endif
 	return size;
 }
 
diff --git a/arch/x86/kernel/cpu/centaur_64.c b/arch/x86/kernel/cpu/centaur_64.c
deleted file mode 100644
index 51b09c4..0000000
--- a/arch/x86/kernel/cpu/centaur_64.c
+++ /dev/null
@@ -1,37 +0,0 @@
-#include <linux/init.h>
-#include <linux/smp.h>
-
-#include <asm/cpufeature.h>
-#include <asm/processor.h>
-
-#include "cpu.h"
-
-static void __cpuinit early_init_centaur(struct cpuinfo_x86 *c)
-{
-	if (c->x86 == 0x6 && c->x86_model >= 0xf)
-		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
-
-	set_cpu_cap(c, X86_FEATURE_SYSENTER32);
-}
-
-static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
-{
-	early_init_centaur(c);
-
-	if (c->x86 == 0x6 && c->x86_model >= 0xf) {
-		c->x86_cache_alignment = c->x86_clflush_size * 2;
-		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
-	}
-	set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
-}
-
-static const struct cpu_dev centaur_cpu_dev __cpuinitconst = {
-	.c_vendor	= "Centaur",
-	.c_ident	= { "CentaurHauls" },
-	.c_early_init	= early_init_centaur,
-	.c_init		= init_centaur,
-	.c_x86_vendor	= X86_VENDOR_CENTAUR,
-};
-
-cpu_dev_register(centaur_cpu_dev);
-
