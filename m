Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbYEJRmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbYEJRmi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 13:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbYEJRma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 13:42:30 -0400
Received: from www.tglx.de ([62.245.132.106]:58993 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbYEJRm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 13:42:27 -0400
Date: Sat, 10 May 2008 19:41:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] x86 updates for 2.6.26
Message-ID: <alpine.LFD.1.10.0805101935400.3197@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-267651254-1210441319=:3197"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-267651254-1210441319=:3197
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

Linus,

please pull x86 updates from:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git for-linus

Thanks,
	tglx
---

Andres Salomon (2):
      x86: GEODE: cache results from geode_has_vsa2() and uninline
      x86: geode: define geode_has_vsa2() even if CONFIG_MGEODE_LX is not set

Helge Wagner (1):
      x86: restrict keyboard io ports reservation to make ipmi driver work

Ingo Molnar (1):
      x86: rdc: leds build/config fix

Simon Holm Thøgersen (1):
      x86: revert commit 709f744 ("x86: bitops asm constraint fixes")

Suresh Siddha (1):
      x86: fix fpu restore from sig return

Thomas Gleixner (3):
      x86: revert geode config dependency
      x86: cleanup PAT cpu validation
      x86: revert printk format warning change which is for linux-next

Vaidyanathan Srinivasan (1):
      x86: sysfs cpu?/topology is empty in 2.6.25 (32-bit Intel system)

Yinghai Lu (1):
      x86: remove spew print out about bus to node mapping

 arch/x86/Kconfig                           |    2 +-
 arch/x86/kernel/cpu/addon_cpuid_features.c |   21 ++++++++++++
 arch/x86/kernel/cpu/common.c               |   27 +--------------
 arch/x86/kernel/geode_32.c                 |   19 ++++++++++
 arch/x86/kernel/i387.c                     |   12 +++++-
 arch/x86/kernel/setup.c                    |    2 +-
 arch/x86/kernel/setup_32.c                 |    7 +++-
 arch/x86/kernel/setup_64.c                 |   13 +++----
 arch/x86/mm/pat.c                          |   50 ++++++++++++---------------
 arch/x86/pci/k8-bus_64.c                   |    8 ----
 include/asm-x86/bitops.h                   |   37 +++++++++-----------
 include/asm-x86/geode.h                    |   12 +++----
 include/asm-x86/i387.h                     |   10 +++++-
 include/asm-x86/pat.h                      |    8 ++++
 include/asm-x86/topology.h                 |   18 +++++----
 15 files changed, 136 insertions(+), 110 deletions(-)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index bbcafaa..fe361ae 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -335,6 +335,7 @@ config X86_RDC321X
 	select GENERIC_GPIO
 	select LEDS_CLASS
 	select LEDS_GPIO
+	select NEW_LEDS
 	help
 	  This option is needed for RDC R-321x system-on-chip, also known
 	  as R-8610-(G).
@@ -1662,7 +1663,6 @@ config GEODE_MFGPT_TIMER
 
 config OLPC
 	bool "One Laptop Per Child support"
-	depends on MGEODE_LX
 	default n
 	help
 	  Add support for detecting the unique features of the OLPC
diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index 238468a..c2e1ce3 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -6,6 +6,7 @@
 
 #include <linux/cpu.h>
 
+#include <asm/pat.h>
 #include <asm/processor.h>
 
 struct cpuid_bit {
@@ -48,3 +49,23 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 			set_cpu_cap(c, cb->feature);
 	}
 }
+
+#ifdef CONFIG_X86_PAT
+void __cpuinit validate_pat_support(struct cpuinfo_x86 *c)
+{
+	switch (c->x86_vendor) {
+	case X86_VENDOR_AMD:
+		if (c->x86 >= 0xf && c->x86 <= 0x11)
+			return;
+		break;
+	case X86_VENDOR_INTEL:
+		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
+			return;
+		break;
+	}
+
+	pat_disable(cpu_has_pat ?
+		    "PAT disabled. Not yet verified on this CPU type." :
+		    "PAT not supported by CPU.");
+}
+#endif
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 35b4f6a..d0463a9 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -12,6 +12,7 @@
 #include <asm/mmu_context.h>
 #include <asm/mtrr.h>
 #include <asm/mce.h>
+#include <asm/pat.h>
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/mpspec.h>
 #include <asm/apic.h>
@@ -308,19 +309,6 @@ static void __cpuinit early_get_cap(struct cpuinfo_x86 *c)
 
 	}
 
-	clear_cpu_cap(c, X86_FEATURE_PAT);
-
-	switch (c->x86_vendor) {
-	case X86_VENDOR_AMD:
-		if (c->x86 >= 0xf && c->x86 <= 0x11)
-			set_cpu_cap(c, X86_FEATURE_PAT);
-		break;
-	case X86_VENDOR_INTEL:
-		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
-			set_cpu_cap(c, X86_FEATURE_PAT);
-		break;
-	}
-
 }
 
 /*
@@ -409,18 +397,6 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 		init_scattered_cpuid_features(c);
 	}
 
-	clear_cpu_cap(c, X86_FEATURE_PAT);
-
-	switch (c->x86_vendor) {
-	case X86_VENDOR_AMD:
-		if (c->x86 >= 0xf && c->x86 <= 0x11)
-			set_cpu_cap(c, X86_FEATURE_PAT);
-		break;
-	case X86_VENDOR_INTEL:
-		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
-			set_cpu_cap(c, X86_FEATURE_PAT);
-		break;
-	}
 }
 
 static void __cpuinit squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
@@ -651,6 +627,7 @@ void __init early_cpu_init(void)
 		cpu_devs[cvdev->vendor] = cvdev->cpu_dev;
 
 	early_cpu_detect();
+	validate_pat_support(&boot_cpu_data);
 }
 
 /* Make sure %fs is initialized properly in idle threads */
diff --git a/arch/x86/kernel/geode_32.c b/arch/x86/kernel/geode_32.c
index 9dad6ca..e8edd63 100644
--- a/arch/x86/kernel/geode_32.c
+++ b/arch/x86/kernel/geode_32.c
@@ -161,6 +161,25 @@ void geode_gpio_setup_event(unsigned int gpio, int pair, int pme)
 }
 EXPORT_SYMBOL_GPL(geode_gpio_setup_event);
 
+int geode_has_vsa2(void)
+{
+	static int has_vsa2 = -1;
+
+	if (has_vsa2 == -1) {
+		/*
+		 * The VSA has virtual registers that we can query for a
+		 * signature.
+		 */
+		outw(VSA_VR_UNLOCK, VSA_VRC_INDEX);
+		outw(VSA_VR_SIGNATURE, VSA_VRC_INDEX);
+
+		has_vsa2 = (inw(VSA_VRC_DATA) == VSA_SIG);
+	}
+
+	return has_vsa2;
+}
+EXPORT_SYMBOL_GPL(geode_has_vsa2);
+
 static int __init geode_southbridge_init(void)
 {
 	if (!is_geode())
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index db6839b..e03cc95 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -450,7 +450,6 @@ static inline int restore_i387_fsave(struct _fpstate_ia32 __user *buf)
 {
 	struct task_struct *tsk = current;
 
-	clear_fpu(tsk);
 	return __copy_from_user(&tsk->thread.xstate->fsave, buf,
 				sizeof(struct i387_fsave_struct));
 }
@@ -461,7 +460,6 @@ static int restore_i387_fxsave(struct _fpstate_ia32 __user *buf)
 	struct user_i387_ia32_struct env;
 	int err;
 
-	clear_fpu(tsk);
 	err = __copy_from_user(&tsk->thread.xstate->fxsave, &buf->_fxsr_env[0],
 			       sizeof(struct i387_fxsave_struct));
 	/* mxcsr reserved bits must be masked to zero for security reasons */
@@ -478,6 +476,16 @@ int restore_i387_ia32(struct _fpstate_ia32 __user *buf)
 	int err;
 
 	if (HAVE_HWFP) {
+		struct task_struct *tsk = current;
+
+		clear_fpu(tsk);
+
+		if (!used_math()) {
+			err = init_fpu(tsk);
+			if (err)
+				return err;
+		}
+
 		if (cpu_has_fxsr)
 			err = restore_i387_fxsave(buf);
 		else
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index cc6f5eb..c0c68c1 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -95,7 +95,7 @@ void __init setup_per_cpu_areas(void)
 
 	/* Copy section for each CPU (we discard the original) */
 	size = PERCPU_ENOUGH_ROOM;
-	printk(KERN_INFO "PERCPU: Allocating %zd bytes of per cpu data\n",
+	printk(KERN_INFO "PERCPU: Allocating %lu bytes of per cpu data\n",
 			  size);
 
 	for_each_possible_cpu(i) {
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index 2283422..2c5f8b2 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -127,7 +127,12 @@ static struct resource standard_io_resources[] = { {
 }, {
 	.name	= "keyboard",
 	.start	= 0x0060,
-	.end	= 0x006f,
+	.end	= 0x0060,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
+}, {
+	.name	= "keyboard",
+	.start	= 0x0064,
+	.end	= 0x0064,
 	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
 }, {
 	.name	= "dma page reg",
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 22c14e2..f2fc8fe 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -70,6 +70,7 @@
 #include <asm/ds.h>
 #include <asm/topology.h>
 #include <asm/trampoline.h>
+#include <asm/pat.h>
 
 #include <mach_apic.h>
 #ifdef CONFIG_PARAVIRT
@@ -128,7 +129,9 @@ static struct resource standard_io_resources[] = {
 		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
 	{ .name = "timer1", .start = 0x50, .end = 0x53,
 		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
-	{ .name = "keyboard", .start = 0x60, .end = 0x6f,
+	{ .name = "keyboard", .start = 0x60, .end = 0x60,
+		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
+	{ .name = "keyboard", .start = 0x64, .end = 0x64,
 		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
 	{ .name = "dma page reg", .start = 0x80, .end = 0x8f,
 		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
@@ -1063,25 +1066,19 @@ static void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c)
 	if (c->extended_cpuid_level >= 0x80000007)
 		c->x86_power = cpuid_edx(0x80000007);
 
-
-	clear_cpu_cap(c, X86_FEATURE_PAT);
-
 	switch (c->x86_vendor) {
 	case X86_VENDOR_AMD:
 		early_init_amd(c);
-		if (c->x86 >= 0xf && c->x86 <= 0x11)
-			set_cpu_cap(c, X86_FEATURE_PAT);
 		break;
 	case X86_VENDOR_INTEL:
 		early_init_intel(c);
-		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
-			set_cpu_cap(c, X86_FEATURE_PAT);
 		break;
 	case X86_VENDOR_CENTAUR:
 		early_init_centaur(c);
 		break;
 	}
 
+	validate_pat_support(c);
 }
 
 /*
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 277446c..60adbe2 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -25,31 +25,24 @@
 #include <asm/mtrr.h>
 #include <asm/io.h>
 
-int pat_wc_enabled = 1;
+#ifdef CONFIG_X86_PAT
+int __read_mostly pat_wc_enabled = 1;
 
-static u64 __read_mostly boot_pat_state;
-
-static int nopat(char *str)
+void __init pat_disable(char *reason)
 {
 	pat_wc_enabled = 0;
-	printk(KERN_INFO "x86: PAT support disabled.\n");
-
-	return 0;
+	printk(KERN_INFO "%s\n", reason);
 }
-early_param("nopat", nopat);
 
-static int pat_known_cpu(void)
+static int nopat(char *str)
 {
-	if (!pat_wc_enabled)
-		return 0;
-
-	if (cpu_has_pat)
-		return 1;
-
-	pat_wc_enabled = 0;
-	printk(KERN_INFO "CPU and/or kernel does not support PAT.\n");
+	pat_disable("PAT support disabled.");
 	return 0;
 }
+early_param("nopat", nopat);
+#endif
+
+static u64 __read_mostly boot_pat_state;
 
 enum {
 	PAT_UC = 0,		/* uncached */
@@ -66,17 +59,19 @@ void pat_init(void)
 {
 	u64 pat;
 
-#ifndef CONFIG_X86_PAT
-	nopat(NULL);
-#endif
-
-	/* Boot CPU enables PAT based on CPU feature */
-	if (!smp_processor_id() && !pat_known_cpu())
+	if (!pat_wc_enabled)
 		return;
 
-	/* APs enable PAT iff boot CPU has enabled it before */
-	if (smp_processor_id() && !pat_wc_enabled)
-		return;
+	/* Paranoia check. */
+	if (!cpu_has_pat) {
+		printk(KERN_ERR "PAT enabled, but CPU feature cleared\n");
+		/*
+		 * Panic if this happens on the secondary CPU, and we
+		 * switched to PAT on the boot CPU. We have no way to
+		 * undo PAT.
+		*/
+		BUG_ON(boot_pat_state);
+	}
 
 	/* Set PWT to Write-Combining. All other bits stay the same */
 	/*
@@ -95,9 +90,8 @@ void pat_init(void)
 	      PAT(4,WB) | PAT(5,WC) | PAT(6,UC_MINUS) | PAT(7,UC);
 
 	/* Boot CPU check */
-	if (!smp_processor_id()) {
+	if (!boot_pat_state)
 		rdmsrl(MSR_IA32_CR_PAT, boot_pat_state);
-	}
 
 	wrmsrl(MSR_IA32_CR_PAT, pat);
 	printk(KERN_INFO "x86 PAT enabled: cpu %d, old 0x%Lx, new 0x%Lx\n",
diff --git a/arch/x86/pci/k8-bus_64.c b/arch/x86/pci/k8-bus_64.c
index ab6d4b1..5c2799c 100644
--- a/arch/x86/pci/k8-bus_64.c
+++ b/arch/x86/pci/k8-bus_64.c
@@ -504,14 +504,6 @@ static int __init early_fill_mp_bus_info(void)
 		}
 	}
 
-#ifdef CONFIG_NUMA
-	for (i = 0; i < BUS_NR; i++) {
-		node = mp_bus_to_node[i];
-		if (node >= 0)
-			printk(KERN_DEBUG "bus: %02x to node: %02x\n", i, node);
-	}
-#endif
-
 	for (i = 0; i < pci_root_num; i++) {
 		int res_num;
 		int busnum;
diff --git a/include/asm-x86/bitops.h b/include/asm-x86/bitops.h
index b81a4d4..ee4b3ea 100644
--- a/include/asm-x86/bitops.h
+++ b/include/asm-x86/bitops.h
@@ -23,13 +23,10 @@
 #if __GNUC__ < 4 || (__GNUC__ == 4 && __GNUC_MINOR__ < 1)
 /* Technically wrong, but this avoids compilation errors on some gcc
    versions. */
-#define ADDR "=m" (*(volatile long *)addr)
-#define BIT_ADDR "=m" (((volatile int *)addr)[nr >> 5])
+#define ADDR "=m" (*(volatile long *) addr)
 #else
 #define ADDR "+m" (*(volatile long *) addr)
-#define BIT_ADDR "+m" (((volatile int *)addr)[nr >> 5])
 #endif
-#define BASE_ADDR "m" (*(volatile int *)addr)
 
 /**
  * set_bit - Atomically set a bit in memory
@@ -77,7 +74,7 @@ static inline void __set_bit(int nr, volatile void *addr)
  */
 static inline void clear_bit(int nr, volatile void *addr)
 {
-	asm volatile(LOCK_PREFIX "btr %1,%2" : BIT_ADDR : "Ir" (nr), BASE_ADDR);
+	asm volatile(LOCK_PREFIX "btr %1,%0" : ADDR : "Ir" (nr));
 }
 
 /*
@@ -96,7 +93,7 @@ static inline void clear_bit_unlock(unsigned nr, volatile void *addr)
 
 static inline void __clear_bit(int nr, volatile void *addr)
 {
-	asm volatile("btr %1,%2" : BIT_ADDR : "Ir" (nr), BASE_ADDR);
+	asm volatile("btr %1,%0" : ADDR : "Ir" (nr));
 }
 
 /*
@@ -131,7 +128,7 @@ static inline void __clear_bit_unlock(unsigned nr, volatile void *addr)
  */
 static inline void __change_bit(int nr, volatile void *addr)
 {
-	asm volatile("btc %1,%2" : BIT_ADDR : "Ir" (nr), BASE_ADDR);
+	asm volatile("btc %1,%0" : ADDR : "Ir" (nr));
 }
 
 /**
@@ -145,7 +142,7 @@ static inline void __change_bit(int nr, volatile void *addr)
  */
 static inline void change_bit(int nr, volatile void *addr)
 {
-	asm volatile(LOCK_PREFIX "btc %1,%2" : BIT_ADDR : "Ir" (nr), BASE_ADDR);
+	asm volatile(LOCK_PREFIX "btc %1,%0" : ADDR : "Ir" (nr));
 }
 
 /**
@@ -191,9 +188,10 @@ static inline int __test_and_set_bit(int nr, volatile void *addr)
 {
 	int oldbit;
 
-	asm volatile("bts %2,%3\n\t"
-		     "sbb %0,%0"
-		     : "=r" (oldbit), BIT_ADDR : "Ir" (nr), BASE_ADDR);
+	asm("bts %2,%1\n\t"
+	    "sbb %0,%0"
+	    : "=r" (oldbit), ADDR
+	    : "Ir" (nr));
 	return oldbit;
 }
 
@@ -229,9 +227,10 @@ static inline int __test_and_clear_bit(int nr, volatile void *addr)
 {
 	int oldbit;
 
-	asm volatile("btr %2,%3\n\t"
+	asm volatile("btr %2,%1\n\t"
 		     "sbb %0,%0"
-		     : "=r" (oldbit), BIT_ADDR : "Ir" (nr), BASE_ADDR);
+		     : "=r" (oldbit), ADDR
+		     : "Ir" (nr));
 	return oldbit;
 }
 
@@ -240,9 +239,10 @@ static inline int __test_and_change_bit(int nr, volatile void *addr)
 {
 	int oldbit;
 
-	asm volatile("btc %2,%3\n\t"
+	asm volatile("btc %2,%1\n\t"
 		     "sbb %0,%0"
-		     : "=r" (oldbit), BIT_ADDR : "Ir" (nr), BASE_ADDR);
+		     : "=r" (oldbit), ADDR
+		     : "Ir" (nr) : "memory");
 
 	return oldbit;
 }
@@ -276,11 +276,10 @@ static inline int variable_test_bit(int nr, volatile const void *addr)
 {
 	int oldbit;
 
-	asm volatile("bt %2,%3\n\t"
+	asm volatile("bt %2,%1\n\t"
 		     "sbb %0,%0"
 		     : "=r" (oldbit)
-		     : "m" (((volatile const int *)addr)[nr >> 5]),
-		       "Ir" (nr), BASE_ADDR);
+		     : "m" (*(unsigned long *)addr), "Ir" (nr));
 
 	return oldbit;
 }
@@ -397,8 +396,6 @@ static inline int fls(int x)
 }
 #endif /* __KERNEL__ */
 
-#undef BASE_ADDR
-#undef BIT_ADDR
 #undef ADDR
 
 static inline void set_bit_string(unsigned long *bitmap,
diff --git a/include/asm-x86/geode.h b/include/asm-x86/geode.h
index 7154dc4..6e64588 100644
--- a/include/asm-x86/geode.h
+++ b/include/asm-x86/geode.h
@@ -185,16 +185,14 @@ static inline int is_geode(void)
 	return (is_geode_gx() || is_geode_lx());
 }
 
-/*
- * The VSA has virtual registers that we can query for a signature.
- */
+#ifdef CONFIG_MGEODE_LX
+extern int geode_has_vsa2(void);
+#else
 static inline int geode_has_vsa2(void)
 {
-	outw(VSA_VR_UNLOCK, VSA_VRC_INDEX);
-	outw(VSA_VR_SIGNATURE, VSA_VRC_INDEX);
-
-	return (inw(VSA_VRC_DATA) == VSA_SIG);
+	return 0;
 }
+#endif
 
 /* MFGPTs */
 
diff --git a/include/asm-x86/i387.h b/include/asm-x86/i387.h
index da2adb4..6b722d3 100644
--- a/include/asm-x86/i387.h
+++ b/include/asm-x86/i387.h
@@ -175,7 +175,15 @@ static inline int save_i387(struct _fpstate __user *buf)
  */
 static inline int restore_i387(struct _fpstate __user *buf)
 {
-	set_used_math();
+	struct task_struct *tsk = current;
+	int err;
+
+	if (!used_math()) {
+		err = init_fpu(tsk);
+		if (err)
+			return err;
+	}
+
 	if (!(task_thread_info(current)->status & TS_USEDFPU)) {
 		clts();
 		task_thread_info(current)->status |= TS_USEDFPU;
diff --git a/include/asm-x86/pat.h b/include/asm-x86/pat.h
index 8b822b5..88f60cc 100644
--- a/include/asm-x86/pat.h
+++ b/include/asm-x86/pat.h
@@ -4,7 +4,13 @@
 
 #include <linux/types.h>
 
+#ifdef CONFIG_X86_PAT
 extern int pat_wc_enabled;
+extern void validate_pat_support(struct cpuinfo_x86 *c);
+#else
+static const int pat_wc_enabled = 0;
+static inline void validate_pat_support(struct cpuinfo_x86 *c) { }
+#endif
 
 extern void pat_init(void);
 
@@ -12,5 +18,7 @@ extern int reserve_memtype(u64 start, u64 end,
 		unsigned long req_type, unsigned long *ret_type);
 extern int free_memtype(u64 start, u64 end);
 
+extern void pat_disable(char *reason);
+
 #endif
 
diff --git a/include/asm-x86/topology.h b/include/asm-x86/topology.h
index 4f35a0f..dcf3f81 100644
--- a/include/asm-x86/topology.h
+++ b/include/asm-x86/topology.h
@@ -25,6 +25,16 @@
 #ifndef _ASM_X86_TOPOLOGY_H
 #define _ASM_X86_TOPOLOGY_H
 
+#ifdef CONFIG_X86_32
+# ifdef CONFIG_X86_HT
+#  define ENABLE_TOPO_DEFINES
+# endif
+#else
+# ifdef CONFIG_SMP
+#  define ENABLE_TOPO_DEFINES
+# endif
+#endif
+
 #ifdef CONFIG_NUMA
 #include <linux/cpumask.h>
 #include <asm/mpspec.h>
@@ -130,10 +140,6 @@ extern unsigned long node_end_pfn[];
 extern unsigned long node_remap_size[];
 #define node_has_online_mem(nid) (node_start_pfn[nid] != node_end_pfn[nid])
 
-# ifdef CONFIG_X86_HT
-#  define ENABLE_TOPO_DEFINES
-# endif
-
 # define SD_CACHE_NICE_TRIES	1
 # define SD_IDLE_IDX		1
 # define SD_NEWIDLE_IDX		2
@@ -141,10 +147,6 @@ extern unsigned long node_remap_size[];
 
 #else
 
-# ifdef CONFIG_SMP
-#  define ENABLE_TOPO_DEFINES
-# endif
-
 # define SD_CACHE_NICE_TRIES	2
 # define SD_IDLE_IDX		2
 # define SD_NEWIDLE_IDX		2
--8323328-267651254-1210441319=:3197--
