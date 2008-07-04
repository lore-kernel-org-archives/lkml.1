Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbYGDVXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbYGDVXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 17:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614AbYGDVVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 17:21:35 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:52819 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213AbYGDVVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 17:21:34 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200807041120.678642023@firstfloor.org>
In-Reply-To: <200807041120.678642023@firstfloor.org>
To: masbock@linux.vnet.ibm.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [9/9] MCE: Use 64bit machine check code on 32bit
Message-Id: <20080704212033.D40551B431F@basil.firstfloor.org>
Date: Fri,  4 Jul 2008 23:20:33 +0200 (CEST)
X-OriginalArrivalTime: 04 Jul 2008 21:13:11.0267 (UTC) FILETIME=[C3A0CB30:01C8DE1A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The 64bit machine check code is in many ways much better than 
the 32bit machine check code: it is more specification compliant,
is cleaner, only has a single code base versus one per CPU, 
has better infrastructure for recovery, has a cleaner way to communicate
with user space etc. etc.

Use the 64bit code for 32bit too.

This is the second attempt to do this. There was one a couple of years
ago to unify this code for 32bit and 64bit.  Back then this ran into some 
trouble with K7s and was reverted.

I believe this time the K7 problems (and some others) are addressed. 
I went over the old handlers and was very careful to retain
all quirks.

But of course this needs a lot of testing on old systems. On newer 
64bit capable systems I don't expect much problems because they have been
already tested with the 64bit kernel.

I made this a CONFIG for now that still allows to select the old
machine check code. This is mostly to make testing easier,
if someone runs into a problem we can ask them to try
with the CONFIG switched.

The new code is default y for more coverage.

Once there is confidence the 64bit code works well on older hardware
too the CONFIG_X86_OLD_MCE and the associated code can be easily
removed.

This causes a behaviour change for 32bit installations. They now
have to install the mcelog package to be able to log 
corrected machine checks.

The 64bit machine check code only handles CPUs which support the 
standard Intel machine check architecture described in the IA32 SDM.
The 32bit code has special support for some older CPUs which
have non standard machine check architectures, in particular 
WinChip C3 and Intel P5.  I made those a separate CONFIG option
and kept them for now. The WinChip variant could be probably
removed without too much pain, it doesn't really do anything
interesting. P5 is also disabled by default (like it 
was before) because many motherboards have it miswired, but 
according to Alan Cox a few embedded setups use that one.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/Kconfig                     |   35 +++++++++++++++++++++++++++++++----
 arch/x86/kernel/cpu/mcheck/Makefile  |    6 ++++--
 arch/x86/kernel/cpu/mcheck/ancient.h |   12 ++++++++++++
 arch/x86/kernel/cpu/mcheck/mce.h     |    2 --
 arch/x86/kernel/cpu/mcheck/mce_32.c  |    1 +
 arch/x86/kernel/cpu/mcheck/mce_64.c  |   16 ++++++++++++++++
 include/asm-x86/mce.h                |    8 --------
 7 files changed, 64 insertions(+), 16 deletions(-)

Index: linux/include/asm-x86/mce.h
===================================================================
--- linux.orig/include/asm-x86/mce.h
+++ linux/include/asm-x86/mce.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_X86_MCE_H
 #define _ASM_X86_MCE_H
 
-#ifdef __x86_64__
-
 #include <asm/ioctls.h>
 #include <asm/types.h>
 
@@ -80,8 +78,6 @@ struct mce_log {
 #define K8_MCE_THRESHOLD_BANK_5    (MCE_THRESHOLD_BASE + 5 * 9)
 #define K8_MCE_THRESHOLD_DRAM_ECC  (MCE_THRESHOLD_BANK_4 + 0)
 
-#endif /* __x86_64__ */
-
 #ifdef __KERNEL__
 
 extern int mce_disabled;
@@ -112,10 +108,6 @@ extern atomic_t mce_entry;
 extern void do_machine_check(struct pt_regs *, long);
 extern int mce_notify_user(void);
 
-#endif /* !CONFIG_X86_32 */
-
-
-
 #ifdef CONFIG_X86_MCE
 extern void mcheck_init(struct cpuinfo_x86 *c);
 #else
Index: linux/arch/x86/Kconfig
===================================================================
--- linux.orig/arch/x86/Kconfig
+++ linux/arch/x86/Kconfig
@@ -652,10 +652,37 @@ config X86_MCE
 	  to disable it.  MCE support simply ignores non-MCE processors like
 	  the 386 and 486, so nearly everyone can say Y here.
 
+config X86_OLD_MCE
+	depends on X86_32
+	bool "Use legacy machine check code (will go away)"
+	default n
+	help
+	  Use the old i386 machine check code. This is merely intended for testing
+	  in a transition period. Try this if you run into any machine check
+	  related software problems.
+	  When in doubt say no.
+
+config X86_ANCIENT_MCE
+	depends on X86_32
+	bool "Support ancient machine check handler for very old CPUs"
+	default n
+	help
+	  Include support for family 5 (Intel Pentium 1 and Centaur Winchip)
+	  machine check code.  Machine check handles uncorrected CPU errors.
+	  Note that the P5 pentium support is disabled
+	  by default and can be only enabled on special hardware.
+	  The Winchip code doesn't do much.
+	  If you're still sure you want it, say n, otherwise n is safe
+	  for nearly everybody.
+
+config X86_NEW_MCE
+	bool
+	default y if (!X86_OLD_MCE && X86_32) || X86_64
+
 config X86_MCE_INTEL
 	def_bool y
 	prompt "Intel MCE features"
-	depends on X86_64 && X86_MCE && X86_LOCAL_APIC
+	depends on X86_NEW_MCE && X86_MCE && X86_LOCAL_APIC
 	help
 	   Additional support for intel specific MCE features such as
 	   the thermal monitor.
@@ -663,14 +690,14 @@ config X86_MCE_INTEL
 config X86_MCE_AMD
 	def_bool y
 	prompt "AMD MCE features"
-	depends on X86_64 && X86_MCE && X86_LOCAL_APIC
+	depends on X86_NEW_MCE && X86_MCE && X86_LOCAL_APIC && X86_64
 	help
 	   Additional support for AMD specific MCE features such as
 	   the DRAM Error Threshold.
 
 config X86_MCE_NONFATAL
 	tristate "Check for non-fatal errors on AMD Athlon/Duron / Intel Pentium 4"
-	depends on X86_32 && X86_MCE
+	depends on !X86_NEW_MCE && X86_MCE
 	help
 	  Enabling this feature starts a timer that triggers every 5 seconds which
 	  will look at the machine check registers to see if anything happened.
@@ -683,7 +710,7 @@ config X86_MCE_NONFATAL
 
 config X86_MCE_P4THERMAL
 	bool "check for P4 thermal throttling interrupt."
-	depends on X86_32 && X86_MCE && (X86_UP_APIC || SMP) && !X86_VISWS
+	depends on !X86_NEW_MCE && X86_MCE && (X86_UP_APIC || SMP) && !X86_VISWS
 	help
 	  Enabling this feature will cause a message to be printed when the P4
 	  enters thermal throttling.
Index: linux/arch/x86/kernel/cpu/mcheck/Makefile
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/Makefile
+++ linux/arch/x86/kernel/cpu/mcheck/Makefile
@@ -1,6 +1,8 @@
-obj-y				=  mce_$(BITS).o therm_throt.o
+obj-y				=  therm_throt.o
 
-obj-$(CONFIG_X86_32)		+= k7.o p4.o p5.o p6.o winchip.o
+obj-$(CONFIG_X86_OLD_MCE)	+= mce_32.o k7.o p4.o p6.o
+obj-$(CONFIG_X86_NEW_MCE)	+= mce_64.o
+obj-$(CONFIG_X86_ANCIENT_MCE)	+= p5.o winchip.o
 obj-$(CONFIG_X86_MCE_INTEL)	+= mce_intel_64.o
 obj-$(CONFIG_X86_MCE_AMD)	+= mce_amd_64.o
 obj-$(CONFIG_X86_MCE_NONFATAL)	+= non-fatal.o
Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -29,6 +29,7 @@
 #include <asm/uaccess.h>
 #include <asm/smp.h>
 #include <asm/idle.h>
+#include "ancient.h"
 
 #define MISC_MCELOG_MINOR 227
 #define NR_BANKS 6
@@ -491,6 +492,20 @@ static void __cpuinit mce_cpu_quirks(str
 
 }
 
+static void __cpuinit mce_ancient_init(struct cpuinfo_x86 *c)
+{
+	if (c->x86 != 5)
+		return;
+	switch (c->x86_vendor) {
+	case X86_VENDOR_INTEL:
+		intel_p5_mcheck_init(c);
+		break;
+	case X86_VENDOR_CENTAUR:
+		winchip_mcheck_init(c);
+		break;
+	}
+}
+
 static void __cpuinit mce_cpu_features(struct cpuinfo_x86 *c)
 {
 	switch (c->x86_vendor) {
@@ -513,6 +528,7 @@ void __cpuinit mcheck_init(struct cpuinf
 {
 	static cpumask_t mce_cpus = CPU_MASK_NONE;
 
+	mce_ancient_init(c);
 	mce_cpu_quirks(c);
 
 	if (mce_disabled ||
Index: linux/arch/x86/kernel/cpu/mcheck/ancient.h
===================================================================
--- /dev/null
+++ linux/arch/x86/kernel/cpu/mcheck/ancient.h
@@ -0,0 +1,12 @@
+#ifdef CONFIG_X86_ANCIENT_MCE
+void intel_p5_mcheck_init(struct cpuinfo_x86 *);
+void winchip_mcheck_init(struct cpuinfo_x86 *);
+#else
+static inline void intel_p5_mcheck_init(struct cpuinfo_x86 *c)
+{
+}
+
+static inline void winchip_mcheck_init(struct cpuinfo_x86 *c)
+{
+}
+#endif
Index: linux/arch/x86/kernel/cpu/mcheck/mce.h
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce.h
+++ linux/arch/x86/kernel/cpu/mcheck/mce.h
@@ -3,9 +3,7 @@
 
 void amd_mcheck_init(struct cpuinfo_x86 *c);
 void intel_p4_mcheck_init(struct cpuinfo_x86 *c);
-void intel_p5_mcheck_init(struct cpuinfo_x86 *c);
 void intel_p6_mcheck_init(struct cpuinfo_x86 *c);
-void winchip_mcheck_init(struct cpuinfo_x86 *c);
 
 /* Call the installed machine check handler for this CPU setup. */
 extern void (*machine_check_vector)(struct pt_regs *, long error_code);
Index: linux/arch/x86/kernel/cpu/mcheck/mce_32.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_32.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce_32.c
@@ -15,6 +15,7 @@
 #include <asm/mce.h>
 
 #include "mce.h"
+#include "ancient.h"
 
 int mce_disabled;
 int nr_mce_banks;
