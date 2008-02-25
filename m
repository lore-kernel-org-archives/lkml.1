Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbYBYQ2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbYBYQ2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 11:28:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbYBYQ2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 11:28:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55841 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655AbYBYQ2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 11:28:00 -0500
Date: Mon, 25 Feb 2008 17:27:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 updates
Message-ID: <20080225162733.GA7263@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest x86 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

Note: three (well-tested) lguest fixlets are included as well.

Thanks,

	Ingo

------------------>
Adrian Bunk (1):
      x86: don't make swapper_pg_pmd global

Ahmed S. Darwish (1):
      x86/lguest: fix pgdir pmd index calculation

Glauber Costa (1):
      x86: make c_idle.work have a static address.

H. Peter Anvin (5):
      x86: do not promote TM3x00/TM5x00 to i686-class
      x86: require family >= 6 if we are using P6 NOPs
      x86: don't use P6_NOPs if compiling with CONFIG_X86_GENERIC
      x86: add comments for NOPs
      x86: handle BIOSes which terminate e820 with CF=1 and no SMAP

Harvey Harrison (1):
      lguest: include function prototypes

Ingo Molnar (4):
      x86: make DEBUG_PAGEALLOC and CPA more robust
      x86: fix spontaneous reboot with allyesconfig bzImage
      x86: rename KERNEL_TEXT_SIZE => KERNEL_IMAGE_SIZE
      x86: fix execve with -fstack-protect

Joerg Roedel (1):
      x86: don't print a warning when MTRR are blank and running in KVM

Mikael Pettersson (1):
      x86: fix boot failure on 486 due to TSC breakage

Pavel Machek (2):
      x86: hpet fix docbook comment
      x86: notsc is ignored on common configurations

Priit Laes (1):
      x86: fix build on non-C locales.

Randy Dunlap (1):
      x86/mtrr: fix kernel-doc missing notation

Thomas Gleixner (2):
      x86: fix vsyscall wreckage
      x86: no robust/pi futex for real i386 CPUs

Tony Breeds (1):
      lguest: fix build breakage

Vegard Nossum (1):
      x86: don't save unreliable stack trace entries

Yinghai Lu (1):
      x86: remove double-checking empty zero pages debug

 arch/x86/Kconfig.cpu             |   14 ++++++
 arch/x86/boot/memory.c           |    9 +++-
 arch/x86/kernel/asm-offsets_32.c |    4 +-
 arch/x86/kernel/cpu/common.c     |    2 +-
 arch/x86/kernel/cpu/mtrr/main.c  |    9 +++-
 arch/x86/kernel/cpu/transmeta.c  |    7 ---
 arch/x86/kernel/entry_64.S       |    6 ++-
 arch/x86/kernel/head_32.S        |    2 +-
 arch/x86/kernel/head_64.S        |   22 ++++++----
 arch/x86/kernel/hpet.c           |    4 +-
 arch/x86/kernel/process_64.c     |    6 +-
 arch/x86/kernel/setup_64.c       |    2 +-
 arch/x86/kernel/smpboot_64.c     |    2 +-
 arch/x86/kernel/stacktrace.c     |    4 ++
 arch/x86/kernel/tsc_32.c         |    3 +-
 arch/x86/kernel/vsyscall_64.c    |   52 +----------------------
 arch/x86/lguest/boot.c           |   12 +-----
 arch/x86/mm/init_64.c            |   13 +-----
 arch/x86/mm/pageattr.c           |   84 +++++++++++++++++++++++---------------
 arch/x86/vdso/Makefile           |    2 +-
 include/asm-x86/futex.h          |    7 +++
 include/asm-x86/lguest.h         |   11 +++++
 include/asm-x86/nops.h           |   66 +++++++++++++++++++++---------
 include/asm-x86/page_64.h        |    8 +++-
 24 files changed, 191 insertions(+), 160 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index e09a6b7..6d50064 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -377,6 +377,19 @@ config X86_OOSTORE
 	def_bool y
 	depends on (MWINCHIP3D || MWINCHIP2 || MWINCHIPC6) && MTRR
 
+#
+# P6_NOPs are a relatively minor optimization that require a family >=
+# 6 processor, except that it is broken on certain VIA chips.
+# Furthermore, AMD chips prefer a totally different sequence of NOPs
+# (which work on all CPUs).  As a result, disallow these if we're
+# compiling X86_GENERIC but not X86_64 (these NOPs do work on all
+# x86-64 capable chips); the list of processors in the right-hand clause
+# are the cores that benefit from this optimization.
+#
+config X86_P6_NOP
+	def_bool y
+	depends on (X86_64 || !X86_GENERIC) && (M686 || MPENTIUMII || MPENTIUMIII || MPENTIUMM || MCORE2 || PENTIUM4)
+
 config X86_TSC
 	def_bool y
 	depends on ((MWINCHIP3D || MWINCHIP2 || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2) && !X86_NUMAQ) || X86_64
@@ -390,6 +403,7 @@ config X86_CMOV
 config X86_MINIMUM_CPU_FAMILY
 	int
 	default "64" if X86_64
+	default "6" if X86_32 && X86_P6_NOP
 	default "4" if X86_32 && (X86_XADD || X86_CMPXCHG || X86_BSWAP || X86_WP_WORKS_OK)
 	default "3"
 
diff --git a/arch/x86/boot/memory.c b/arch/x86/boot/memory.c
index 3783539..e77d89f 100644
--- a/arch/x86/boot/memory.c
+++ b/arch/x86/boot/memory.c
@@ -37,6 +37,12 @@ static int detect_memory_e820(void)
 		      "=m" (*desc)
 		    : "D" (desc), "d" (SMAP), "a" (0xe820));
 
+		/* BIOSes which terminate the chain with CF = 1 as opposed
+		   to %ebx = 0 don't always report the SMAP signature on
+		   the final, failing, probe. */
+		if (err)
+			break;
+
 		/* Some BIOSes stop returning SMAP in the middle of
 		   the search loop.  We don't know exactly how the BIOS
 		   screwed up the map at that point, we might have a
@@ -47,9 +53,6 @@ static int detect_memory_e820(void)
 			break;
 		}
 
-		if (err)
-			break;
-
 		count++;
 		desc++;
 	} while (next && count < E820MAX);
diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
index a33d530..8ea0401 100644
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -128,13 +128,11 @@ void foo(void)
 	OFFSET(XEN_vcpu_info_pending, vcpu_info, evtchn_upcall_pending);
 #endif
 
-#ifdef CONFIG_LGUEST_GUEST
+#if defined(CONFIG_LGUEST) || defined(CONFIG_LGUEST_GUEST) || defined(CONFIG_LGUEST_MODULE)
 	BLANK();
 	OFFSET(LGUEST_DATA_irq_enabled, lguest_data, irq_enabled);
 	OFFSET(LGUEST_DATA_pgdir, lguest_data, pgdir);
-#endif
 
-#ifdef CONFIG_LGUEST
 	BLANK();
 	OFFSET(LGUEST_PAGES_host_gdt_desc, lguest_pages, state.host_gdt_desc);
 	OFFSET(LGUEST_PAGES_host_idt_desc, lguest_pages, state.host_idt_desc);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index f86a3c4..a38aafa 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -504,7 +504,7 @@ void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 
 	/* Clear all flags overriden by options */
 	for (i = 0; i < NCAPINTS; i++)
-		c->x86_capability[i] ^= cleared_cpu_caps[i];
+		c->x86_capability[i] &= ~cleared_cpu_caps[i];
 
 	/* Init Machine Check Exception if available. */
 	mcheck_init(c);
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index b6e136f..be83336 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -43,6 +43,7 @@
 #include <asm/uaccess.h>
 #include <asm/processor.h>
 #include <asm/msr.h>
+#include <asm/kvm_para.h>
 #include "mtrr.h"
 
 u32 num_var_ranges = 0;
@@ -649,6 +650,7 @@ static __init int amd_special_default_mtrr(void)
 
 /**
  * mtrr_trim_uncached_memory - trim RAM not covered by MTRRs
+ * @end_pfn: ending page frame number
  *
  * Some buggy BIOSes don't setup the MTRRs properly for systems with certain
  * memory configurations.  This routine checks that the highest MTRR matches
@@ -688,8 +690,11 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 
 	/* kvm/qemu doesn't have mtrr set right, don't trim them all */
 	if (!highest_pfn) {
-		printk(KERN_WARNING "WARNING: strange, CPU MTRRs all blank?\n");
-		WARN_ON(1);
+		if (!kvm_para_available()) {
+			printk(KERN_WARNING
+				"WARNING: strange, CPU MTRRs all blank?\n");
+			WARN_ON(1);
+		}
 		return 0;
 	}
 
diff --git a/arch/x86/kernel/cpu/transmeta.c b/arch/x86/kernel/cpu/transmeta.c
index 200fb3f..e8b422c 100644
--- a/arch/x86/kernel/cpu/transmeta.c
+++ b/arch/x86/kernel/cpu/transmeta.c
@@ -76,13 +76,6 @@ static void __cpuinit init_transmeta(struct cpuinfo_x86 *c)
 	/* All Transmeta CPUs have a constant TSC */
 	set_bit(X86_FEATURE_CONSTANT_TSC, c->x86_capability);
 	
-	/* If we can run i686 user-space code, call us an i686 */
-#define USER686 ((1 << X86_FEATURE_TSC)|\
-		 (1 << X86_FEATURE_CX8)|\
-		 (1 << X86_FEATURE_CMOV))
-        if (c->x86 == 5 && (c->x86_capability[0] & USER686) == USER686)
-		c->x86 = 6;
-
 #ifdef CONFIG_SYSCTL
 	/* randomize_va_space slows us down enormously;
 	   it probably triggers retranslation of x86->native bytecode */
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 2ad9a1b..c20c9e7 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -453,6 +453,7 @@ ENTRY(stub_execve)
 	CFI_REGISTER rip, r11
 	SAVE_REST
 	FIXUP_TOP_OF_STACK %r11
+	movq %rsp, %rcx
 	call sys_execve
 	RESTORE_TOP_OF_STACK %r11
 	movq %rax,RAX(%rsp)
@@ -1036,15 +1037,16 @@ ENDPROC(child_rip)
  *	rdi: name, rsi: argv, rdx: envp
  *
  * We want to fallback into:
- *	extern long sys_execve(char *name, char **argv,char **envp, struct pt_regs regs)
+ *	extern long sys_execve(char *name, char **argv,char **envp, struct pt_regs *regs)
  *
  * do_sys_execve asm fallback arguments:
- *	rdi: name, rsi: argv, rdx: envp, fake frame on the stack
+ *	rdi: name, rsi: argv, rdx: envp, rcx: fake frame on the stack
  */
 ENTRY(kernel_execve)
 	CFI_STARTPROC
 	FAKE_STACK_FRAME $0
 	SAVE_ALL	
+	movq %rsp,%rcx
 	call sys_execve
 	movq %rax, RAX(%rsp)	
 	RESTORE_REST
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 25eb985..fd8ca53 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -606,7 +606,7 @@ ENTRY(_stext)
 .section ".bss.page_aligned","wa"
 	.align PAGE_SIZE_asm
 #ifdef CONFIG_X86_PAE
-ENTRY(swapper_pg_pmd)
+swapper_pg_pmd:
 	.fill 1024*KPMDS,4,0
 #else
 ENTRY(swapper_pg_dir)
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index eb41504..a007454 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -379,18 +379,24 @@ NEXT_PAGE(level2_ident_pgt)
 	/* Since I easily can, map the first 1G.
 	 * Don't set NX because code runs from these pages.
 	 */
-	PMDS(0x0000000000000000, __PAGE_KERNEL_LARGE_EXEC, PTRS_PER_PMD)
+	PMDS(0, __PAGE_KERNEL_LARGE_EXEC, PTRS_PER_PMD)
 
 NEXT_PAGE(level2_kernel_pgt)
-	/* 40MB kernel mapping. The kernel code cannot be bigger than that.
-	   When you change this change KERNEL_TEXT_SIZE in page.h too. */
-	/* (2^48-(2*1024*1024*1024)-((2^39)*511)-((2^30)*510)) = 0 */
-	PMDS(0x0000000000000000, __PAGE_KERNEL_LARGE_EXEC|_PAGE_GLOBAL, KERNEL_TEXT_SIZE/PMD_SIZE)
-	/* Module mapping starts here */
-	.fill	(PTRS_PER_PMD - (KERNEL_TEXT_SIZE/PMD_SIZE)),8,0
+	/*
+	 * 128 MB kernel mapping. We spend a full page on this pagetable
+	 * anyway.
+	 *
+	 * The kernel code+data+bss must not be bigger than that.
+	 *
+	 * (NOTE: at +128MB starts the module area, see MODULES_VADDR.
+	 *  If you want to increase this then increase MODULES_VADDR
+	 *  too.)
+	 */
+	PMDS(0, __PAGE_KERNEL_LARGE_EXEC|_PAGE_GLOBAL,
+		KERNEL_IMAGE_SIZE/PMD_SIZE)
 
 NEXT_PAGE(level2_spare_pgt)
-	.fill   512,8,0
+	.fill   512, 8, 0
 
 #undef PMDS
 #undef NEXT_PAGE
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 429d084..235fd6c 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -368,8 +368,8 @@ static int hpet_clocksource_register(void)
 	return 0;
 }
 
-/*
- * Try to setup the HPET timer
+/**
+ * hpet_enable - Try to setup the HPET timer. Returns 1 on success.
  */
 int __init hpet_enable(void)
 {
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index b0cc8f0..43f2877 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -730,16 +730,16 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
  */
 asmlinkage
 long sys_execve(char __user *name, char __user * __user *argv,
-		char __user * __user *envp, struct pt_regs regs)
+		char __user * __user *envp, struct pt_regs *regs)
 {
 	long error;
 	char * filename;
 
 	filename = getname(name);
 	error = PTR_ERR(filename);
-	if (IS_ERR(filename)) 
+	if (IS_ERR(filename))
 		return error;
-	error = do_execve(filename, argv, envp, &regs); 
+	error = do_execve(filename, argv, envp, regs);
 	putname(filename);
 	return error;
 }
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 6fd804f..7637dc9 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -1021,7 +1021,7 @@ void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 
 	/* Clear all flags overriden by options */
 	for (i = 0; i < NCAPINTS; i++)
-		c->x86_capability[i] ^= cleared_cpu_caps[i];
+		c->x86_capability[i] &= ~cleared_cpu_caps[i];
 
 #ifdef CONFIG_X86_MCE
 	mcheck_init(c);
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index d53bd6f..0880f2c 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -554,10 +554,10 @@ static int __cpuinit do_boot_cpu(int cpu, int apicid)
 	int timeout;
 	unsigned long start_rip;
 	struct create_idle c_idle = {
-		.work = __WORK_INITIALIZER(c_idle.work, do_fork_idle),
 		.cpu = cpu,
 		.done = COMPLETION_INITIALIZER_ONSTACK(c_idle.done),
 	};
+	INIT_WORK(&c_idle.work, do_fork_idle);
 
 	/* allocate memory for gdts of secondary cpus. Hotplug is considered */
 	if (!cpu_gdt_descr[cpu].address &&
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index 02f0f61..c28c342 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -25,6 +25,8 @@ static int save_stack_stack(void *data, char *name)
 static void save_stack_address(void *data, unsigned long addr, int reliable)
 {
 	struct stack_trace *trace = data;
+	if (!reliable)
+		return;
 	if (trace->skip > 0) {
 		trace->skip--;
 		return;
@@ -37,6 +39,8 @@ static void
 save_stack_address_nosched(void *data, unsigned long addr, int reliable)
 {
 	struct stack_trace *trace = (struct stack_trace *)data;
+	if (!reliable)
+		return;
 	if (in_sched_functions(addr))
 		return;
 	if (trace->skip > 0) {
diff --git a/arch/x86/kernel/tsc_32.c b/arch/x86/kernel/tsc_32.c
index 43517e3..f14cfd9 100644
--- a/arch/x86/kernel/tsc_32.c
+++ b/arch/x86/kernel/tsc_32.c
@@ -28,7 +28,8 @@ EXPORT_SYMBOL_GPL(tsc_khz);
 static int __init tsc_setup(char *str)
 {
 	printk(KERN_WARNING "notsc: Kernel compiled with CONFIG_X86_TSC, "
-				"cannot disable TSC.\n");
+				"cannot disable TSC completely.\n");
+	mark_tsc_unstable("user disabled TSC");
 	return 1;
 }
 #else
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 3f82427..b6be812 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -44,11 +44,6 @@
 
 #define __vsyscall(nr) __attribute__ ((unused,__section__(".vsyscall_" #nr)))
 #define __syscall_clobber "r11","cx","memory"
-#define __pa_vsymbol(x)			\
-	({unsigned long v;  		\
-	extern char __vsyscall_0; 	\
-	  asm("" : "=r" (v) : "0" (x)); \
-	  ((v - VSYSCALL_START) + __pa_symbol(&__vsyscall_0)); })
 
 /*
  * vsyscall_gtod_data contains data that is :
@@ -102,7 +97,7 @@ static __always_inline void do_get_tz(struct timezone * tz)
 static __always_inline int gettimeofday(struct timeval *tv, struct timezone *tz)
 {
 	int ret;
-	asm volatile("vsysc2: syscall"
+	asm volatile("syscall"
 		: "=a" (ret)
 		: "0" (__NR_gettimeofday),"D" (tv),"S" (tz)
 		: __syscall_clobber );
@@ -112,7 +107,7 @@ static __always_inline int gettimeofday(struct timeval *tv, struct timezone *tz)
 static __always_inline long time_syscall(long *t)
 {
 	long secs;
-	asm volatile("vsysc1: syscall"
+	asm volatile("syscall"
 		: "=a" (secs)
 		: "0" (__NR_time),"D" (t) : __syscall_clobber);
 	return secs;
@@ -227,50 +222,10 @@ long __vsyscall(3) venosys_1(void)
 }
 
 #ifdef CONFIG_SYSCTL
-
-#define SYSCALL 0x050f
-#define NOP2    0x9090
-
-/*
- * NOP out syscall in vsyscall page when not needed.
- */
-static int vsyscall_sysctl_change(ctl_table *ctl, int write, struct file * filp,
-                        void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	extern u16 vsysc1, vsysc2;
-	u16 __iomem *map1;
-	u16 __iomem *map2;
-	int ret = proc_dointvec(ctl, write, filp, buffer, lenp, ppos);
-	if (!write)
-		return ret;
-	/* gcc has some trouble with __va(__pa()), so just do it this
-	   way. */
-	map1 = ioremap(__pa_vsymbol(&vsysc1), 2);
-	if (!map1)
-		return -ENOMEM;
-	map2 = ioremap(__pa_vsymbol(&vsysc2), 2);
-	if (!map2) {
-		ret = -ENOMEM;
-		goto out;
-	}
-	if (!vsyscall_gtod_data.sysctl_enabled) {
-		writew(SYSCALL, map1);
-		writew(SYSCALL, map2);
-	} else {
-		writew(NOP2, map1);
-		writew(NOP2, map2);
-	}
-	iounmap(map2);
-out:
-	iounmap(map1);
-	return ret;
-}
-
 static ctl_table kernel_table2[] = {
 	{ .procname = "vsyscall64",
 	  .data = &vsyscall_gtod_data.sysctl_enabled, .maxlen = sizeof(int),
-	  .mode = 0644,
-	  .proc_handler = vsyscall_sysctl_change },
+	  .mode = 0644 },
 	{}
 };
 
@@ -279,7 +234,6 @@ static ctl_table kernel_root_table2[] = {
 	  .child = kernel_table2 },
 	{}
 };
-
 #endif
 
 /* Assume __initcall executes before all user space. Hopefully kmod
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 5afdde4..cccb38a 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -57,6 +57,7 @@
 #include <linux/lguest_launcher.h>
 #include <linux/virtio_console.h>
 #include <linux/pm.h>
+#include <asm/lguest.h>
 #include <asm/paravirt.h>
 #include <asm/param.h>
 #include <asm/page.h>
@@ -75,15 +76,6 @@
  * behaving in simplified but equivalent ways.  In particular, the Guest is the
  * same kernel as the Host (or at least, built from the same source code). :*/
 
-/* Declarations for definitions in lguest_guest.S */
-extern char lguest_noirq_start[], lguest_noirq_end[];
-extern const char lgstart_cli[], lgend_cli[];
-extern const char lgstart_sti[], lgend_sti[];
-extern const char lgstart_popf[], lgend_popf[];
-extern const char lgstart_pushf[], lgend_pushf[];
-extern const char lgstart_iret[], lgend_iret[];
-extern void lguest_iret(void);
-
 struct lguest_data lguest_data = {
 	.hcall_status = { [0 ... LHCALL_RING_SIZE-1] = 0xFF },
 	.noirq_start = (u32)lguest_noirq_start,
@@ -489,7 +481,7 @@ static void lguest_set_pmd(pmd_t *pmdp, pmd_t pmdval)
 {
 	*pmdp = pmdval;
 	lazy_hcall(LHCALL_SET_PMD, __pa(pmdp)&PAGE_MASK,
-		   (__pa(pmdp)&(PAGE_SIZE-1))/4, 0);
+		   (__pa(pmdp)&(PAGE_SIZE-1)), 0);
 }
 
 /* There are a couple of legacy places where the kernel sets a PTE, but we
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index bb652f5..a02a14f 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -172,8 +172,9 @@ set_pte_phys(unsigned long vaddr, unsigned long phys, pgprot_t prot)
 }
 
 /*
- * The head.S code sets up the kernel high mapping from:
- * __START_KERNEL_map to __START_KERNEL_map + KERNEL_TEXT_SIZE
+ * The head.S code sets up the kernel high mapping:
+ *
+ *   from __START_KERNEL_map to __START_KERNEL_map + size (== _end-_text)
  *
  * phys_addr holds the negative offset to the kernel, which is added
  * to the compile time generated pmds. This results in invalid pmds up
@@ -515,14 +516,6 @@ void __init mem_init(void)
 
 	/* clear_bss() already clear the empty_zero_page */
 
-	/* temporary debugging - double check it's true: */
-	{
-		int i;
-
-		for (i = 0; i < 1024; i++)
-			WARN_ON_ONCE(empty_zero_page[i]);
-	}
-
 	reservedpages = 0;
 
 	/* this will put all low memory onto the freelists */
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 464d8fc..14e48b5 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -44,6 +44,12 @@ static inline unsigned long highmap_end_pfn(void)
 
 #endif
 
+#ifdef CONFIG_DEBUG_PAGEALLOC
+# define debug_pagealloc 1
+#else
+# define debug_pagealloc 0
+#endif
+
 static inline int
 within(unsigned long addr, unsigned long start, unsigned long end)
 {
@@ -355,45 +361,48 @@ out_unlock:
 
 static LIST_HEAD(page_pool);
 static unsigned long pool_size, pool_pages, pool_low;
-static unsigned long pool_used, pool_failed, pool_refill;
+static unsigned long pool_used, pool_failed;
 
-static void cpa_fill_pool(void)
+static void cpa_fill_pool(struct page **ret)
 {
-	struct page *p;
 	gfp_t gfp = GFP_KERNEL;
+	unsigned long flags;
+	struct page *p;
 
-	/* Do not allocate from interrupt context */
-	if (in_irq() || irqs_disabled())
-		return;
 	/*
-	 * Check unlocked. I does not matter when we have one more
-	 * page in the pool. The bit lock avoids recursive pool
-	 * allocations:
+	 * Avoid recursion (on debug-pagealloc) and also signal
+	 * our priority to get to these pagetables:
 	 */
-	if (pool_pages >= pool_size || test_and_set_bit_lock(0, &pool_refill))
+	if (current->flags & PF_MEMALLOC)
 		return;
+	current->flags |= PF_MEMALLOC;
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
 	/*
-	 * We could do:
-	 * gfp = in_atomic() ? GFP_ATOMIC : GFP_KERNEL;
-	 * but this fails on !PREEMPT kernels
+	 * Allocate atomically from atomic contexts:
 	 */
-	gfp =  GFP_ATOMIC | __GFP_NORETRY | __GFP_NOWARN;
-#endif
+	if (in_atomic() || irqs_disabled() || debug_pagealloc)
+		gfp =  GFP_ATOMIC | __GFP_NORETRY | __GFP_NOWARN;
 
-	while (pool_pages < pool_size) {
+	while (pool_pages < pool_size || (ret && !*ret)) {
 		p = alloc_pages(gfp, 0);
 		if (!p) {
 			pool_failed++;
 			break;
 		}
-		spin_lock_irq(&pgd_lock);
+		/*
+		 * If the call site needs a page right now, provide it:
+		 */
+		if (ret && !*ret) {
+			*ret = p;
+			continue;
+		}
+		spin_lock_irqsave(&pgd_lock, flags);
 		list_add(&p->lru, &page_pool);
 		pool_pages++;
-		spin_unlock_irq(&pgd_lock);
+		spin_unlock_irqrestore(&pgd_lock, flags);
 	}
-	clear_bit_unlock(0, &pool_refill);
+
+	current->flags &= ~PF_MEMALLOC;
 }
 
 #define SHIFT_MB		(20 - PAGE_SHIFT)
@@ -414,11 +423,15 @@ void __init cpa_init(void)
 	 * GiB. Shift MiB to Gib and multiply the result by
 	 * POOL_PAGES_PER_GB:
 	 */
-	gb = ((si.totalram >> SHIFT_MB) + ROUND_MB_GB) >> SHIFT_MB_GB;
-	pool_size = POOL_PAGES_PER_GB * gb;
+	if (debug_pagealloc) {
+		gb = ((si.totalram >> SHIFT_MB) + ROUND_MB_GB) >> SHIFT_MB_GB;
+		pool_size = POOL_PAGES_PER_GB * gb;
+	} else {
+		pool_size = 1;
+	}
 	pool_low = pool_size;
 
-	cpa_fill_pool();
+	cpa_fill_pool(NULL);
 	printk(KERN_DEBUG
 	       "CPA: page pool initialized %lu of %lu pages preallocated\n",
 	       pool_pages, pool_size);
@@ -440,16 +453,20 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 	spin_lock_irqsave(&pgd_lock, flags);
 	if (list_empty(&page_pool)) {
 		spin_unlock_irqrestore(&pgd_lock, flags);
-		return -ENOMEM;
+		base = NULL;
+		cpa_fill_pool(&base);
+		if (!base)
+			return -ENOMEM;
+		spin_lock_irqsave(&pgd_lock, flags);
+	} else {
+		base = list_first_entry(&page_pool, struct page, lru);
+		list_del(&base->lru);
+		pool_pages--;
+
+		if (pool_pages < pool_low)
+			pool_low = pool_pages;
 	}
 
-	base = list_first_entry(&page_pool, struct page, lru);
-	list_del(&base->lru);
-	pool_pages--;
-
-	if (pool_pages < pool_low)
-		pool_low = pool_pages;
-
 	/*
 	 * Check for races, another CPU might have split this page
 	 * up for us already:
@@ -734,7 +751,8 @@ static int change_page_attr_set_clr(unsigned long addr, int numpages,
 		cpa_flush_all(cache);
 
 out:
-	cpa_fill_pool();
+	cpa_fill_pool(NULL);
+
 	return ret;
 }
 
@@ -897,7 +915,7 @@ void kernel_map_pages(struct page *page, int numpages, int enable)
 	 * Try to refill the page pool here. We can do this only after
 	 * the tlb flush.
 	 */
-	cpa_fill_pool();
+	cpa_fill_pool(NULL);
 }
 
 #ifdef CONFIG_HIBERNATION
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index f385a4b..b8bd0c4 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -48,7 +48,7 @@ obj-$(VDSO64-y)			+= vdso-syms.lds
 # Match symbols in the DSO that look like VDSO*; produce a file of constants.
 #
 sed-vdsosym := -e 's/^00*/0/' \
-	-e 's/^\([0-9a-fA-F]*\) . \(VDSO[a-zA-Z0-9_]*\)$$/\2 = 0x\1;/p'
+	-e 's/^\([[:xdigit:]]*\) . \(VDSO[[:alnum:]_]*\)$$/\2 = 0x\1;/p'
 quiet_cmd_vdsosym = VDSOSYM $@
       cmd_vdsosym = $(NM) $< | sed -n $(sed-vdsosym) | LC_ALL=C sort > $@
 
diff --git a/include/asm-x86/futex.h b/include/asm-x86/futex.h
index cd9f894..c9952ea 100644
--- a/include/asm-x86/futex.h
+++ b/include/asm-x86/futex.h
@@ -102,6 +102,13 @@ futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 static inline int
 futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
 {
+
+#if defined(CONFIG_X86_32) && !defined(CONFIG_X86_BSWAP)
+	/* Real i386 machines have no cmpxchg instruction */
+	if (boot_cpu_data.x86 == 3)
+		return -ENOSYS;
+#endif
+
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
 		return -EFAULT;
 
diff --git a/include/asm-x86/lguest.h b/include/asm-x86/lguest.h
index 4d9367b..9b17571 100644
--- a/include/asm-x86/lguest.h
+++ b/include/asm-x86/lguest.h
@@ -23,6 +23,17 @@
 /* Found in switcher.S */
 extern unsigned long default_idt_entries[];
 
+/* Declarations for definitions in lguest_guest.S */
+extern char lguest_noirq_start[], lguest_noirq_end[];
+extern const char lgstart_cli[], lgend_cli[];
+extern const char lgstart_sti[], lgend_sti[];
+extern const char lgstart_popf[], lgend_popf[];
+extern const char lgstart_pushf[], lgend_pushf[];
+extern const char lgstart_iret[], lgend_iret[];
+
+extern void lguest_iret(void);
+extern void lguest_init(void);
+
 struct lguest_regs
 {
 	/* Manually saved part. */
diff --git a/include/asm-x86/nops.h b/include/asm-x86/nops.h
index fec025c..e3b2bce 100644
--- a/include/asm-x86/nops.h
+++ b/include/asm-x86/nops.h
@@ -3,17 +3,29 @@
 
 /* Define nops for use with alternative() */
 
-/* generic versions from gas */
-#define GENERIC_NOP1	".byte 0x90\n"
-#define GENERIC_NOP2    	".byte 0x89,0xf6\n"
-#define GENERIC_NOP3        ".byte 0x8d,0x76,0x00\n"
-#define GENERIC_NOP4        ".byte 0x8d,0x74,0x26,0x00\n"
-#define GENERIC_NOP5        GENERIC_NOP1 GENERIC_NOP4
-#define GENERIC_NOP6	".byte 0x8d,0xb6,0x00,0x00,0x00,0x00\n"
-#define GENERIC_NOP7	".byte 0x8d,0xb4,0x26,0x00,0x00,0x00,0x00\n"
-#define GENERIC_NOP8	GENERIC_NOP1 GENERIC_NOP7
+/* generic versions from gas
+   1: nop
+   2: movl %esi,%esi
+   3: leal 0x00(%esi),%esi
+   4: leal 0x00(,%esi,1),%esi
+   6: leal 0x00000000(%esi),%esi
+   7: leal 0x00000000(,%esi,1),%esi
+*/
+#define GENERIC_NOP1 ".byte 0x90\n"
+#define GENERIC_NOP2 ".byte 0x89,0xf6\n"
+#define GENERIC_NOP3 ".byte 0x8d,0x76,0x00\n"
+#define GENERIC_NOP4 ".byte 0x8d,0x74,0x26,0x00\n"
+#define GENERIC_NOP5 GENERIC_NOP1 GENERIC_NOP4
+#define GENERIC_NOP6 ".byte 0x8d,0xb6,0x00,0x00,0x00,0x00\n"
+#define GENERIC_NOP7 ".byte 0x8d,0xb4,0x26,0x00,0x00,0x00,0x00\n"
+#define GENERIC_NOP8 GENERIC_NOP1 GENERIC_NOP7
 
-/* Opteron 64bit nops */
+/* Opteron 64bit nops
+   1: nop
+   2: osp nop
+   3: osp osp nop
+   4: osp osp osp nop
+*/
 #define K8_NOP1 GENERIC_NOP1
 #define K8_NOP2	".byte 0x66,0x90\n"
 #define K8_NOP3	".byte 0x66,0x66,0x90\n"
@@ -23,19 +35,35 @@
 #define K8_NOP7	K8_NOP4 K8_NOP3
 #define K8_NOP8	K8_NOP4 K8_NOP4
 
-/* K7 nops */
-/* uses eax dependencies (arbitary choice) */
-#define K7_NOP1  GENERIC_NOP1
+/* K7 nops
+   uses eax dependencies (arbitary choice)
+   1: nop
+   2: movl %eax,%eax
+   3: leal (,%eax,1),%eax
+   4: leal 0x00(,%eax,1),%eax
+   6: leal 0x00000000(%eax),%eax
+   7: leal 0x00000000(,%eax,1),%eax
+*/
+#define K7_NOP1	GENERIC_NOP1
 #define K7_NOP2	".byte 0x8b,0xc0\n"
 #define K7_NOP3	".byte 0x8d,0x04,0x20\n"
 #define K7_NOP4	".byte 0x8d,0x44,0x20,0x00\n"
 #define K7_NOP5	K7_NOP4 ASM_NOP1
 #define K7_NOP6	".byte 0x8d,0x80,0,0,0,0\n"
-#define K7_NOP7        ".byte 0x8D,0x04,0x05,0,0,0,0\n"
-#define K7_NOP8        K7_NOP7 ASM_NOP1
+#define K7_NOP7	".byte 0x8D,0x04,0x05,0,0,0,0\n"
+#define K7_NOP8	K7_NOP7 ASM_NOP1
 
-/* P6 nops */
-/* uses eax dependencies (Intel-recommended choice) */
+/* P6 nops
+   uses eax dependencies (Intel-recommended choice)
+   1: nop
+   2: osp nop
+   3: nopl (%eax)
+   4: nopl 0x00(%eax)
+   5: nopl 0x00(%eax,%eax,1)
+   6: osp nopl 0x00(%eax,%eax,1)
+   7: nopl 0x00000000(%eax)
+   8: nopl 0x00000000(%eax,%eax,1)
+*/
 #define P6_NOP1	GENERIC_NOP1
 #define P6_NOP2	".byte 0x66,0x90\n"
 #define P6_NOP3	".byte 0x0f,0x1f,0x00\n"
@@ -63,9 +91,7 @@
 #define ASM_NOP6 K7_NOP6
 #define ASM_NOP7 K7_NOP7
 #define ASM_NOP8 K7_NOP8
-#elif defined(CONFIG_M686) || defined(CONFIG_MPENTIUMII) || \
-      defined(CONFIG_MPENTIUMIII) || defined(CONFIG_MPENTIUMM) || \
-      defined(CONFIG_MCORE2) || defined(CONFIG_PENTIUM4)
+#elif defined(CONFIG_X86_P6_NOP)
 #define ASM_NOP1 P6_NOP1
 #define ASM_NOP2 P6_NOP2
 #define ASM_NOP3 P6_NOP3
diff --git a/include/asm-x86/page_64.h b/include/asm-x86/page_64.h
index f7393bc..1435460 100644
--- a/include/asm-x86/page_64.h
+++ b/include/asm-x86/page_64.h
@@ -47,8 +47,12 @@
 #define __PHYSICAL_MASK_SHIFT	46
 #define __VIRTUAL_MASK_SHIFT	48
 
-#define KERNEL_TEXT_SIZE  (40*1024*1024)
-#define KERNEL_TEXT_START _AC(0xffffffff80000000, UL)
+/*
+ * Kernel image size is limited to 128 MB (see level2_kernel_pgt in
+ * arch/x86/kernel/head_64.S), and it is mapped here:
+ */
+#define KERNEL_IMAGE_SIZE	(128*1024*1024)
+#define KERNEL_IMAGE_START	_AC(0xffffffff80000000, UL)
 
 #ifndef __ASSEMBLY__
 void clear_page(void *page);
