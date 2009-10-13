Return-Path: <linux-kernel-owner+w=401wt.eu-S934003AbZJMSQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934003AbZJMSQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 14:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbZJMSQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 14:16:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50687 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760856AbZJMSQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 14:16:23 -0400
Date: Tue, 13 Oct 2009 20:15:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20091013181535.GA3471@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Alok Kataria (1):
      x86, vmi: Mark VMI deprecated and schedule it for removal

H. Peter Anvin (1):
      x86: fix kernel panic on 32 bits when profiling

Jan Beulich (1):
      x86: Fix Suspend to RAM freeze on Acer Aspire 1511Lmi laptop

Jeremy Fitzhardinge (1):
      x86/paravirt: Use normal calling sequences for irq enable/disable


 Documentation/feature-removal-schedule.txt |   30 ++++++++++++++++++++++++++++
 arch/x86/Kconfig                           |   11 +++++++++-
 arch/x86/include/asm/paravirt.h            |   28 +++----------------------
 arch/x86/include/asm/paravirt_types.h      |   10 +++++---
 arch/x86/kernel/time.c                     |    3 +-
 arch/x86/kernel/trampoline.c               |   12 +++++++++-
 arch/x86/kernel/trampoline_64.S            |    4 +++
 arch/x86/kernel/vmi_32.c                   |    2 +-
 8 files changed, 67 insertions(+), 33 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 89a47b5..04e6c81 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -451,3 +451,33 @@ Why:	OSS sound_core grabs all legacy minors (0-255) of SOUND_MAJOR
 	will also allow making ALSA OSS emulation independent of
 	sound_core.  The dependency will be broken then too.
 Who:	Tejun Heo <tj@kernel.org>
+
+----------------------------
+
+What:	Support for VMware's guest paravirtuliazation technique [VMI] will be
+	dropped.
+When:	2.6.37 or earlier.
+Why:	With the recent innovations in CPU hardware acceleration technologies
+	from Intel and AMD, VMware ran a few experiments to compare these
+	techniques to guest paravirtualization technique on VMware's platform.
+	These hardware assisted virtualization techniques have outperformed the
+	performance benefits provided by VMI in most of the workloads. VMware
+	expects that these hardware features will be ubiquitous in a couple of
+	years, as a result, VMware has started a phased retirement of this
+	feature from the hypervisor. We will be removing this feature from the
+	Kernel too. Right now we are targeting 2.6.37 but can retire earlier if
+	technical reasons (read opportunity to remove major chunk of pvops)
+	arise.
+
+	Please note that VMI has always been an optimization and non-VMI kernels
+	still work fine on VMware's platform.
+	Latest versions of VMware's product which support VMI are,
+	Workstation 7.0 and VSphere 4.0 on ESX side, future maintainence
+	releases for these products will continue supporting VMI.
+
+	For more details about VMI retirement take a look at this,
+	http://blogs.vmware.com/guestosguide/2009/09/vmi-retirement.html
+
+Who:	Alok N Kataria <akataria@vmware.com>
+
+----------------------------
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c876bac..07e0114 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -491,7 +491,7 @@ if PARAVIRT_GUEST
 source "arch/x86/xen/Kconfig"
 
 config VMI
-	bool "VMI Guest support"
+	bool "VMI Guest support (DEPRECATED)"
 	select PARAVIRT
 	depends on X86_32
 	---help---
@@ -500,6 +500,15 @@ config VMI
 	  at the moment), by linking the kernel to a GPL-ed ROM module
 	  provided by the hypervisor.
 
+	  As of September 2009, VMware has started a phased retirement
+	  of this feature from VMware's products. Please see
+	  feature-removal-schedule.txt for details.  If you are
+	  planning to enable this option, please note that you cannot
+	  live migrate a VMI enabled VM to a future VMware product,
+	  which doesn't support VMI. So if you expect your kernel to
+	  seamlessly migrate to newer VMware products, keep this
+	  disabled.
+
 config KVM_CLOCK
 	bool "KVM paravirtualized clock"
 	select PARAVIRT
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 8aebcc4..efb3899 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -840,42 +840,22 @@ static __always_inline void __raw_spin_unlock(struct raw_spinlock *lock)
 
 static inline unsigned long __raw_local_save_flags(void)
 {
-	unsigned long f;
-
-	asm volatile(paravirt_alt(PARAVIRT_CALL)
-		     : "=a"(f)
-		     : paravirt_type(pv_irq_ops.save_fl),
-		       paravirt_clobber(CLBR_EAX)
-		     : "memory", "cc");
-	return f;
+	return PVOP_CALLEE0(unsigned long, pv_irq_ops.save_fl);
 }
 
 static inline void raw_local_irq_restore(unsigned long f)
 {
-	asm volatile(paravirt_alt(PARAVIRT_CALL)
-		     : "=a"(f)
-		     : PV_FLAGS_ARG(f),
-		       paravirt_type(pv_irq_ops.restore_fl),
-		       paravirt_clobber(CLBR_EAX)
-		     : "memory", "cc");
+	PVOP_VCALLEE1(pv_irq_ops.restore_fl, f);
 }
 
 static inline void raw_local_irq_disable(void)
 {
-	asm volatile(paravirt_alt(PARAVIRT_CALL)
-		     :
-		     : paravirt_type(pv_irq_ops.irq_disable),
-		       paravirt_clobber(CLBR_EAX)
-		     : "memory", "eax", "cc");
+	PVOP_VCALLEE0(pv_irq_ops.irq_disable);
 }
 
 static inline void raw_local_irq_enable(void)
 {
-	asm volatile(paravirt_alt(PARAVIRT_CALL)
-		     :
-		     : paravirt_type(pv_irq_ops.irq_enable),
-		       paravirt_clobber(CLBR_EAX)
-		     : "memory", "eax", "cc");
+	PVOP_VCALLEE0(pv_irq_ops.irq_enable);
 }
 
 static inline unsigned long __raw_local_irq_save(void)
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index dd0f5b3..9357473 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -494,10 +494,11 @@ int paravirt_disable_iospace(void);
 #define EXTRA_CLOBBERS
 #define VEXTRA_CLOBBERS
 #else  /* CONFIG_X86_64 */
+/* [re]ax isn't an arg, but the return val */
 #define PVOP_VCALL_ARGS					\
 	unsigned long __edi = __edi, __esi = __esi,	\
-		__edx = __edx, __ecx = __ecx
-#define PVOP_CALL_ARGS		PVOP_VCALL_ARGS, __eax
+		__edx = __edx, __ecx = __ecx, __eax = __eax
+#define PVOP_CALL_ARGS		PVOP_VCALL_ARGS
 
 #define PVOP_CALL_ARG1(x)		"D" ((unsigned long)(x))
 #define PVOP_CALL_ARG2(x)		"S" ((unsigned long)(x))
@@ -509,6 +510,7 @@ int paravirt_disable_iospace(void);
 				"=c" (__ecx)
 #define PVOP_CALL_CLOBBERS	PVOP_VCALL_CLOBBERS, "=a" (__eax)
 
+/* void functions are still allowed [re]ax for scratch */
 #define PVOP_VCALLEE_CLOBBERS	"=a" (__eax)
 #define PVOP_CALLEE_CLOBBERS	PVOP_VCALLEE_CLOBBERS
 
@@ -583,8 +585,8 @@ int paravirt_disable_iospace(void);
 		       VEXTRA_CLOBBERS,					\
 		       pre, post, ##__VA_ARGS__)
 
-#define __PVOP_VCALLEESAVE(rettype, op, pre, post, ...)			\
-	____PVOP_CALL(rettype, op.func, CLBR_RET_REG,			\
+#define __PVOP_VCALLEESAVE(op, pre, post, ...)				\
+	____PVOP_VCALL(op.func, CLBR_RET_REG,				\
 		      PVOP_VCALLEE_CLOBBERS, ,				\
 		      pre, post, ##__VA_ARGS__)
 
diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index dcb00d2..be25734 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -38,7 +38,8 @@ unsigned long profile_pc(struct pt_regs *regs)
 #ifdef CONFIG_FRAME_POINTER
 		return *(unsigned long *)(regs->bp + sizeof(long));
 #else
-		unsigned long *sp = (unsigned long *)regs->sp;
+		unsigned long *sp =
+			(unsigned long *)kernel_stack_pointer(regs);
 		/*
 		 * Return address is either directly at stack pointer
 		 * or above a saved flags. Eflags has bits 22-31 zero,
diff --git a/arch/x86/kernel/trampoline.c b/arch/x86/kernel/trampoline.c
index 699f7ee..cd02212 100644
--- a/arch/x86/kernel/trampoline.c
+++ b/arch/x86/kernel/trampoline.c
@@ -3,8 +3,16 @@
 #include <asm/trampoline.h>
 #include <asm/e820.h>
 
+#if defined(CONFIG_X86_64) && defined(CONFIG_ACPI_SLEEP)
+#define __trampinit
+#define __trampinitdata
+#else
+#define __trampinit __cpuinit
+#define __trampinitdata __cpuinitdata
+#endif
+
 /* ready for x86_64 and x86 */
-unsigned char *__cpuinitdata trampoline_base = __va(TRAMPOLINE_BASE);
+unsigned char *__trampinitdata trampoline_base = __va(TRAMPOLINE_BASE);
 
 void __init reserve_trampoline_memory(void)
 {
@@ -26,7 +34,7 @@ void __init reserve_trampoline_memory(void)
  * bootstrap into the page concerned. The caller
  * has made sure it's suitably aligned.
  */
-unsigned long __cpuinit setup_trampoline(void)
+unsigned long __trampinit setup_trampoline(void)
 {
 	memcpy(trampoline_base, trampoline_data, TRAMPOLINE_SIZE);
 	return virt_to_phys(trampoline_base);
diff --git a/arch/x86/kernel/trampoline_64.S b/arch/x86/kernel/trampoline_64.S
index 596d54c..3af2dff 100644
--- a/arch/x86/kernel/trampoline_64.S
+++ b/arch/x86/kernel/trampoline_64.S
@@ -32,8 +32,12 @@
 #include <asm/segment.h>
 #include <asm/processor-flags.h>
 
+#ifdef CONFIG_ACPI_SLEEP
+.section .rodata, "a", @progbits
+#else
 /* We can free up the trampoline after bootup if cpu hotplug is not supported. */
 __CPUINITRODATA
+#endif
 .code16
 
 ENTRY(trampoline_data)
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index 31e6f6c..d430e4c 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -648,7 +648,7 @@ static inline int __init activate_vmi(void)
 
 	pv_info.paravirt_enabled = 1;
 	pv_info.kernel_rpl = kernel_cs & SEGMENT_RPL_MASK;
-	pv_info.name = "vmi";
+	pv_info.name = "vmi [deprecated]";
 
 	pv_init_ops.patch = vmi_patch;
 
