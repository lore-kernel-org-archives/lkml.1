Return-Path: <linux-kernel-owner+w=401wt.eu-S1757585AbZDXNeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585AbZDXNeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 09:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbZDXNeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 09:34:04 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:63322 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbZDXNeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 09:34:00 -0400
Message-ID: <49F1BFC3.6060508@monstr.eu>
Date: Fri, 24 Apr 2009 15:33:55 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       lkml <linux-arch@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] arch/microblaze fixes for 2.6.30-rc3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following changes.

Thanks,
Michal


The following changes since commit 091069740304c979f957ceacec39c461d0192158:
  Linus Torvalds (1):
        Linux 2.6.30-rc3

are available in the git repository at:

  git://git.monstr.eu/linux-2.6-microblaze.git fixes-for-linus

Coly Li (1):
      microblaze: add parameter to microblaze_read()

Michal Simek (16):
      microblaze: Remove unneded per cpu SYSCALL_SAVE variable
      microblaze: Remove while(1) loop from show_regs function
      microblaze: Remove uncache shadow condition
      microblaze: Rename kernel_mode to pt_mode in pt_regs
      microblaze: Move task_pt_regs up
      microblaze: Remove sparse error in traps.c
      microblaze: Add missing declaration for die and _exception func
      microblaze: Add missing preadv and pwritev syscalls
      microblaze: Move start_thread to process.c
      microblaze: Remove redundant variable
      microblaze: Correspond CONFIG...PCMP in Makefile/Kconfig
      microblaze: Fix USR1/2 pvr printing message
      microblaze: Do not use PVR configuration for broken MB version
      microblaze: Do not check use_dcache
      microblaze: Add STATE_SAVE_ARG_SPACE for noMMU kernel too
      microblaze: Use CFLAGS_KERNEL instead of CFLAGS

Roel Kluin (1):
      microblaze: iowrite upon timeout

 arch/microblaze/Makefile                      |    8 +++-----
 arch/microblaze/include/asm/cache.h           |    5 -----
 arch/microblaze/include/asm/entry.h           |    4 +++-
 arch/microblaze/include/asm/exceptions.h      |    3 +++
 arch/microblaze/include/asm/processor.h       |   21 ++++++++-------------
 arch/microblaze/include/asm/ptrace.h          |    4 ++--
 arch/microblaze/include/asm/unistd.h          |    4 +++-
 arch/microblaze/kernel/asm-offsets.c          |    2 +-
 arch/microblaze/kernel/cpu/cache.c            |    3 ---
 arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c |    9 +++++++--
 arch/microblaze/kernel/cpu/cpuinfo.c          |    2 +-
 arch/microblaze/kernel/cpu/mb.c               |    4 ++--
 arch/microblaze/kernel/early_printk.c         |    2 +-
 arch/microblaze/kernel/process.c              |   20 ++++++++++++--------
 arch/microblaze/kernel/signal.c               |   14 ++++++++++----
 arch/microblaze/kernel/syscall_table.S        |    2 ++
 arch/microblaze/kernel/timer.c                |    2 +-
 arch/microblaze/kernel/traps.c                |    2 +-
 18 files changed, 60 insertions(+), 51 deletions(-)


diff --git a/arch/microblaze/Makefile b/arch/microblaze/Makefile
index 0dcbb98..aaadfa7 100644
--- a/arch/microblaze/Makefile
+++ b/arch/microblaze/Makefile
@@ -26,21 +26,19 @@ ifeq (,$(findstring spartan2,$(CONFIG_XILINX_MICROBLAZE0_FAMILY)))
 endif
 CPUFLAGS-$(CONFIG_XILINX_MICROBLAZE0_USE_DIV) += -mno-xl-soft-div
 CPUFLAGS-$(CONFIG_XILINX_MICROBLAZE0_USE_BARREL) += -mxl-barrel-shift
-CPUFLAGS-$(CONFIG_XILINX_MICROBLAZE0_USE_PCMP) += -mxl-pattern-compare
+CPUFLAGS-$(CONFIG_XILINX_MICROBLAZE0_USE_PCMP_INSTR) += -mxl-pattern-compare

 CPUFLAGS-1 += $(call cc-option,-mcpu=v$(CPU_VER))

 # The various CONFIG_XILINX cpu features options are integers 0/1/2...
 # rather than bools y/n
-CFLAGS += $(CPUFLAGS-1)
-CFLAGS += $(CPUFLAGS-2)

 # r31 holds current when in kernel mode
-CFLAGS += -ffixed-r31
+CFLAGS_KERNEL += -ffixed-r31 $(CPUFLAGS-1) $(CPUFLAGS-2)

 LDFLAGS_BLOB := --format binary --oformat elf32-microblaze

-LIBGCC := $(shell $(CC) $(CFLAGS) -print-libgcc-file-name)
+LIBGCC := $(shell $(CC) $(CFLAGS_KERNEL) -print-libgcc-file-name)

 head-y		:= arch/microblaze/kernel/head.o
 libs-y		+= arch/microblaze/lib/ $(LIBGCC)
diff --git a/arch/microblaze/include/asm/cache.h b/arch/microblaze/include/asm/cache.h
index c4c64b4..c209c47 100644
--- a/arch/microblaze/include/asm/cache.h
+++ b/arch/microblaze/include/asm/cache.h
@@ -37,9 +37,4 @@ void _invalidate_dcache(unsigned int addr);
 #define __disable_dcache()		_disable_dcache()
 #define __invalidate_dcache(addr)	_invalidate_dcache(addr)

-/* FIXME - I don't think this is right */
-#ifdef CONFIG_XILINX_UNCACHED_SHADOW
-#define UNCACHED_SHADOW_MASK (CONFIG_XILINX_ERAM_SIZE)
-#endif
-
 #endif /* _ASM_MICROBLAZE_CACHE_H */
diff --git a/arch/microblaze/include/asm/entry.h b/arch/microblaze/include/asm/entry.h
index 7f57e42..e4c3aef 100644
--- a/arch/microblaze/include/asm/entry.h
+++ b/arch/microblaze/include/asm/entry.h
@@ -29,7 +29,9 @@ DECLARE_PER_CPU(unsigned int, KM); /* Kernel/user mode */
 DECLARE_PER_CPU(unsigned int, ENTRY_SP); /* Saved SP on kernel entry */
 DECLARE_PER_CPU(unsigned int, R11_SAVE); /* Temp variable for entry */
 DECLARE_PER_CPU(unsigned int, CURRENT_SAVE); /* Saved current pointer */
-DECLARE_PER_CPU(unsigned int, SYSCALL_SAVE); /* Saved syscall number */
 # endif /* __ASSEMBLY__ */

+/* noMMU hasn't any space for args */
+# define STATE_SAVE_ARG_SPACE	(0)
+
 #endif /* _ASM_MICROBLAZE_ENTRY_H */
diff --git a/arch/microblaze/include/asm/exceptions.h b/arch/microblaze/include/asm/exceptions.h
index 4cdd215..24ca540 100644
--- a/arch/microblaze/include/asm/exceptions.h
+++ b/arch/microblaze/include/asm/exceptions.h
@@ -61,6 +61,9 @@
 asmlinkage void full_exception(struct pt_regs *regs, unsigned int type,
 							int fsr, int addr);

+void die(const char *str, struct pt_regs *fp, long err);
+void _exception(int signr, struct pt_regs *regs, int code, unsigned long addr);
+
 #if defined(CONFIG_XMON)
 extern void xmon(struct pt_regs *regs);
 extern int xmon_bpt(struct pt_regs *regs);
diff --git a/arch/microblaze/include/asm/processor.h b/arch/microblaze/include/asm/processor.h
index d8e1543..9329029 100644
--- a/arch/microblaze/include/asm/processor.h
+++ b/arch/microblaze/include/asm/processor.h
@@ -15,6 +15,8 @@
 #include <asm/setup.h>
 #include <asm/registers.h>
 #include <asm/segment.h>
+#include <asm/entry.h>
+#include <asm/current.h>

 # ifndef __ASSEMBLY__
 /* from kernel/cpu/mb.c */
@@ -26,6 +28,12 @@ extern const struct seq_operations cpuinfo_op;

 # endif /* __ASSEMBLY__ */

+#define task_pt_regs(tsk) \
+		(((struct pt_regs *)(THREAD_SIZE + task_stack_page(tsk))) - 1)
+
+/* Do necessary setup to start up a newly executed thread. */
+void start_thread(struct pt_regs *regs, unsigned long pc, unsigned long usp);
+
 /*
  * User space process size: memory size
  *
@@ -55,16 +63,6 @@ struct task_struct;
 struct thread_struct { };
 # define INIT_THREAD	{ }

-/* Do necessary setup to start up a newly executed thread. */
-static inline void start_thread(struct pt_regs *regs,
-				unsigned long pc,
-				unsigned long usp)
-{
-	regs->pc = pc;
-	regs->r1 = usp;
-	regs->kernel_mode = 0;
-}
-
 /* Free all resources held by a thread. */
 static inline void release_thread(struct task_struct *dead_task)
 {
@@ -84,9 +82,6 @@ extern unsigned long get_wchan(struct task_struct *p);
  */
 extern int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);

-# define task_pt_regs(tsk) \
-		(((struct pt_regs *)(THREAD_SIZE + task_stack_page(tsk))) - 1)
-
 # define KSTK_EIP(tsk)	(0)
 # define KSTK_ESP(tsk)	(0)

diff --git a/arch/microblaze/include/asm/ptrace.h b/arch/microblaze/include/asm/ptrace.h
index f1f0348..55015bc 100644
--- a/arch/microblaze/include/asm/ptrace.h
+++ b/arch/microblaze/include/asm/ptrace.h
@@ -52,10 +52,10 @@ struct pt_regs {
 	microblaze_reg_t ear;
 	microblaze_reg_t esr;
 	microblaze_reg_t fsr;
-	int kernel_mode;
+	int pt_mode;
 };

-#define kernel_mode(regs)		((regs)->kernel_mode)
+#define kernel_mode(regs)		((regs)->pt_mode)
 #define user_mode(regs)			(!kernel_mode(regs))

 #define instruction_pointer(regs)	((regs)->pc)
diff --git a/arch/microblaze/include/asm/unistd.h b/arch/microblaze/include/asm/unistd.h
index d9d3903..b5e2f5f 100644
--- a/arch/microblaze/include/asm/unistd.h
+++ b/arch/microblaze/include/asm/unistd.h
@@ -378,8 +378,10 @@
 #define __NR_sendmsg		360 /* new */
 #define __NR_recvmsg		361 /* new */
 #define __NR_accept04		362 /* new */
+#define __NR_preadv		363 /* new */
+#define __NR_pwritev		364 /* new */

-#define __NR_syscalls		363
+#define __NR_syscalls		365

 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
diff --git a/arch/microblaze/kernel/asm-offsets.c b/arch/microblaze/kernel/asm-offsets.c
index 38e1a2e..aabd9e9 100644
--- a/arch/microblaze/kernel/asm-offsets.c
+++ b/arch/microblaze/kernel/asm-offsets.c
@@ -57,7 +57,7 @@ int main(int argc, char *argv[])
 	DEFINE(PT_R29, offsetof(struct pt_regs, r29));
 	DEFINE(PT_R30, offsetof(struct pt_regs, r30));
 	DEFINE(PT_R31, offsetof(struct pt_regs, r31));
-	DEFINE(PT_MODE, offsetof(struct pt_regs, kernel_mode));
+	DEFINE(PT_MODE, offsetof(struct pt_regs, pt_mode));
 	BLANK();

 	/* Magic offsets for PTRACE PEEK/POKE etc */
diff --git a/arch/microblaze/kernel/cpu/cache.c b/arch/microblaze/kernel/cpu/cache.c
index be9fecc..af866a4 100644
--- a/arch/microblaze/kernel/cpu/cache.c
+++ b/arch/microblaze/kernel/cpu/cache.c
@@ -100,7 +100,6 @@ void _enable_dcache(void)

 void _disable_dcache(void)
 {
-	if (cpuinfo.use_dcache) {
 #if CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
 		__asm__ __volatile__ ("					\
 				msrclr	r0, %0;				\
@@ -119,12 +118,10 @@ void _disable_dcache(void)
 				: "i" (MSR_DCE)			\
 				: "memory", "r12");
 #endif
-	}
 }

 void _invalidate_dcache(unsigned int addr)
 {
-	if (cpuinfo.use_dcache)
 		__asm__ __volatile__ ("					\
 				wdc	%0, r0"				\
 				:					\
diff --git a/arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c
b/arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c
index cf7424a..153f57c 100644
--- a/arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c
+++ b/arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c
@@ -30,6 +30,13 @@ void set_cpuinfo_pvr_full(struct cpuinfo *ci, struct device_node *cpu)
 	int temp; /* for saving temp value */
 	get_pvr(&pvr);

+	CI(ver_code, VERSION);
+	if (!ci->ver_code) {
+		printk(KERN_ERR "ERROR: MB has broken PVR regs "
+						"-> use DTS setting\n");
+		return;
+	}
+
 	temp = PVR_USE_BARREL(pvr) | PVR_USE_MSR_INSTR(pvr) |\
 		PVR_USE_PCMP_INSTR(pvr) | PVR_USE_DIV(pvr);
 	if (ci->use_instr != temp)
@@ -60,8 +67,6 @@ void set_cpuinfo_pvr_full(struct cpuinfo *ci, struct device_node *cpu)

 	CI(mmu, USE_MMU);

-	CI(ver_code, VERSION);
-
 	CI(use_icache, USE_ICACHE);
 	CI(icache_tagbits, ICACHE_ADDR_TAG_BITS);
 	CI(icache_write, ICACHE_ALLOW_WR);
diff --git a/arch/microblaze/kernel/cpu/cpuinfo.c b/arch/microblaze/kernel/cpu/cpuinfo.c
index 4a740df..a10bea1 100644
--- a/arch/microblaze/kernel/cpu/cpuinfo.c
+++ b/arch/microblaze/kernel/cpu/cpuinfo.c
@@ -71,7 +71,7 @@ void __init setup_cpuinfo(void)
 			__func__);
 		set_cpuinfo_static(&cpuinfo, cpu);
 		break;
-/* FIXME I found weird behavior with MB 7.00.a/b
+/* FIXME I found weird behavior with MB 7.00.a/b 7.10.a
  * please do not use FULL PVR with MMU */
 	case 1:
 		printk(KERN_INFO "%s: Using full CPU PVR support\n",
diff --git a/arch/microblaze/kernel/cpu/mb.c b/arch/microblaze/kernel/cpu/mb.c
index 3b6212b..4dcfccd 100644
--- a/arch/microblaze/kernel/cpu/mb.c
+++ b/arch/microblaze/kernel/cpu/mb.c
@@ -115,8 +115,8 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 			cpuinfo.hw_debug ? "yes" : "no");

 	count += seq_printf(m,
-			"PVR-USR1:\t%x\n"
-			"PVR-USR2:\t%x\n",
+			"PVR-USR1:\t%02x\n"
+			"PVR-USR2:\t%08x\n",
 			cpuinfo.pvr_user1,
 			cpuinfo.pvr_user2);

diff --git a/arch/microblaze/kernel/early_printk.c b/arch/microblaze/kernel/early_printk.c
index 62cc789..4b0f0fd 100644
--- a/arch/microblaze/kernel/early_printk.c
+++ b/arch/microblaze/kernel/early_printk.c
@@ -36,7 +36,7 @@ static void early_printk_putc(char c)

 	unsigned retries = 10000;
 	/* read status bit - 0x8 offset */
-	while (retries-- && (in_be32(base_addr + 8) & (1 << 3)))
+	while (--retries && (in_be32(base_addr + 8) & (1 << 3)))
 		;

 	/* Only attempt the iowrite if we didn't timeout */
diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
index 436f26c..07d4fa3 100644
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
@@ -18,7 +18,7 @@

 void show_regs(struct pt_regs *regs)
 {
-	printk(KERN_INFO " Registers dump: mode=%X\r\n", regs->kernel_mode);
+	printk(KERN_INFO " Registers dump: mode=%X\r\n", regs->pt_mode);
 	printk(KERN_INFO " r1=%08lX, r2=%08lX, r3=%08lX, r4=%08lX\n",
 				regs->r1, regs->r2, regs->r3, regs->r4);
 	printk(KERN_INFO " r5=%08lX, r6=%08lX, r7=%08lX, r8=%08lX\n",
@@ -37,8 +37,6 @@ void show_regs(struct pt_regs *regs)
 				regs->r29, regs->r30, regs->r31, regs->pc);
 	printk(KERN_INFO " msr=%08lX, ear=%08lX, esr=%08lX, fsr=%08lX\n",
 				regs->msr, regs->ear, regs->esr, regs->fsr);
-	while (1)
-		;
 }

 void (*pm_idle)(void);
@@ -163,7 +161,6 @@ static void kernel_thread_helper(int (*fn)(void *), void *arg)
 int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 {
 	struct pt_regs regs;
-	int ret;

 	memset(&regs, 0, sizeof(regs));
 	/* store them in non-volatile registers */
@@ -171,12 +168,10 @@ int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 	regs.r6 = (unsigned long)arg;
 	local_save_flags(regs.msr);
 	regs.pc = (unsigned long)kernel_thread_helper;
-	regs.kernel_mode = 1;
+	regs.pt_mode = 1;

-	ret = do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0,
+	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0,
 			&regs, 0, NULL, NULL);
-
-	return ret;
 }

 unsigned long get_wchan(struct task_struct *p)
@@ -184,3 +179,12 @@ unsigned long get_wchan(struct task_struct *p)
 /* TBD (used by procfs) */
 	return 0;
 }
+
+/* Set up a thread for executing a new program */
+void start_thread(struct pt_regs *regs, unsigned long pc, unsigned long usp)
+{
+	set_fs(USER_DS);
+	regs->pc = pc;
+	regs->r1 = usp;
+	regs->pt_mode = 0;
+}
diff --git a/arch/microblaze/kernel/signal.c b/arch/microblaze/kernel/signal.c
index 3889cf4..40d3693 100644
--- a/arch/microblaze/kernel/signal.c
+++ b/arch/microblaze/kernel/signal.c
@@ -178,7 +178,9 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext *sc, int *rval_p)

 asmlinkage int sys_sigreturn(struct pt_regs *regs)
 {
-	struct sigframe *frame = (struct sigframe *)regs->r1;
+	struct sigframe *frame =
+			(struct sigframe *)(regs->r1 + STATE_SAVE_ARG_SPACE);
+
 	sigset_t set;
 	int rval;

@@ -209,7 +211,9 @@ badframe:

 asmlinkage int sys_rt_sigreturn(struct pt_regs *regs)
 {
-	struct rt_sigframe *frame = (struct rt_sigframe *)regs->r1;
+	struct rt_sigframe *frame =
+			(struct rt_sigframe *)(regs->r1 + STATE_SAVE_ARG_SPACE);
+
 	sigset_t set;
 	stack_t st;
 	int rval;
@@ -336,7 +340,8 @@ static void setup_frame(int sig, struct k_sigaction *ka,
 		goto give_sigsegv;

 	/* Set up registers for signal handler */
-	regs->r1 = (unsigned long) frame;
+	regs->r1 = (unsigned long) frame - STATE_SAVE_ARG_SPACE;
+
 	/* Signal handler args: */
 	regs->r5 = signal; /* Arg 0: signum */
 	regs->r6 = (unsigned long) &frame->sc; /* arg 1: sigcontext */
@@ -414,7 +419,8 @@ static void setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		goto give_sigsegv;

 	/* Set up registers for signal handler */
-	regs->r1 = (unsigned long) frame;
+	regs->r1 = (unsigned long) frame - STATE_SAVE_ARG_SPACE;
+
 	/* Signal handler args: */
 	regs->r5 = signal; /* arg 0: signum */
 	regs->r6 = (unsigned long) &frame->info; /* arg 1: siginfo */
diff --git a/arch/microblaze/kernel/syscall_table.S b/arch/microblaze/kernel/syscall_table.S
index 529b0db..3bb42ec 100644
--- a/arch/microblaze/kernel/syscall_table.S
+++ b/arch/microblaze/kernel/syscall_table.S
@@ -363,3 +363,5 @@ ENTRY(sys_call_table)
 	.long sys_sendmsg		/* 360 */
 	.long sys_recvmsg
 	.long sys_ni_syscall
+	.long sys_ni_syscall
+	.long sys_ni_syscall
diff --git a/arch/microblaze/kernel/timer.c b/arch/microblaze/kernel/timer.c
index 05a497e..bdfa2f9 100644
--- a/arch/microblaze/kernel/timer.c
+++ b/arch/microblaze/kernel/timer.c
@@ -176,7 +176,7 @@ static __init void microblaze_clockevent_init(void)
 	clockevents_register_device(&clockevent_microblaze_timer);
 }

-static cycle_t microblaze_read(void)
+static cycle_t microblaze_read(struct clocksource *cs)
 {
 	/* reading actual value of timer 1 */
 	return (cycle_t) (in_be32(TIMER_BASE + TCR1));
diff --git a/arch/microblaze/kernel/traps.c b/arch/microblaze/kernel/traps.c
index fbdc533..293ef48 100644
--- a/arch/microblaze/kernel/traps.c
+++ b/arch/microblaze/kernel/traps.c
@@ -34,7 +34,7 @@ static int kstack_depth_to_print = 24;

 static int __init kstack_setup(char *s)
 {
-	kstack_depth_to_print = strict_strtoul(s, 0, 0);
+	kstack_depth_to_print = strict_strtoul(s, 0, NULL);

 	return 1;
 }

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
