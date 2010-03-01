Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab0CATlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:41:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39869 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747Ab0CATlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:41:37 -0500
Date: Mon, 1 Mar 2010 20:41:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] "perf probe" updates, kprobes jump optimization, for
 v2.6.34
Message-ID: <20100301194109.GA10847@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-probes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-probes-for-linus

This tree introduces the kprobes "jump optimization", which optimizes certain 
types of (not all) kprobes. The performance advantage is significant:

                          x86-32  x86-64
  kprobe:                 0.80us  0.99us
  kprobe+booster:         0.33us  0.43us
  kprobe+optimized:       0.05us  0.06us

'perf probe' (based on CONFIG_KPROBES_TRACER) makes use of this optimization 
by default - but AFAIK the SystemTap folks are also interested in this 
optimization.

The tree also includes a number of further 'perf probe' improvements.

 Thanks,

	Ingo

------------------>
Masami Hiramatsu (18):
      kprobes/x86: Cleanup RELATIVEJUMP_INSTRUCTION to RELATIVEJUMP_OPCODE
      kprobes: Introduce generic insn_slot framework
      kprobes: Introduce kprobes jump optimization
      kprobes: Jump optimization sysctl interface
      kprobes/x86: Boost probes when reentering
      kprobes/x86: Cleanup save/restore registers
      x86: Add text_poke_smp for SMP cross modifying code
      kprobes/x86: Support kprobes jump optimization on x86
      kprobes: Add documents of jump optimization
      perf probe: Do not show --line option without dwarf support
      perf probe: Update perf probe document
      perf probe: Fix bugs in line range finder
      perf probe: Rename probe finder functions
      perf probe: Use elfutils-libdw for analyzing debuginfo
      perf probe: Use libdw callback routines
      perf probe: Check function address range strictly in line finder
      perf probe: Show more lines after last line
      perf probe: Add lazy line matching support


 Documentation/kprobes.txt               |  207 ++++++-
 arch/Kconfig                            |   13 +
 arch/x86/Kconfig                        |    1 +
 arch/x86/include/asm/alternative.h      |    4 +-
 arch/x86/include/asm/kprobes.h          |   31 +-
 arch/x86/kernel/alternative.c           |   60 ++
 arch/x86/kernel/kprobes.c               |  609 ++++++++++++++++----
 include/linux/kprobes.h                 |   44 ++
 kernel/kprobes.c                        |  647 +++++++++++++++++---
 kernel/sysctl.c                         |   12 +
 tools/perf/Documentation/perf-probe.txt |   58 ++-
 tools/perf/Makefile                     |   10 +-
 tools/perf/builtin-probe.c              |   36 +-
 tools/perf/util/probe-event.c           |   55 ++-
 tools/perf/util/probe-finder.c          | 1002 ++++++++++++++-----------------
 tools/perf/util/probe-finder.h          |   53 +-
 tools/perf/util/string.c                |   55 ++-
 tools/perf/util/string.h                |    1 +
 18 files changed, 2063 insertions(+), 835 deletions(-)

diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
index 053037a..2f9115c 100644
--- a/Documentation/kprobes.txt
+++ b/Documentation/kprobes.txt
@@ -1,6 +1,7 @@
 Title	: Kernel Probes (Kprobes)
 Authors	: Jim Keniston <jkenisto@us.ibm.com>
-	: Prasanna S Panchamukhi <prasanna@in.ibm.com>
+	: Prasanna S Panchamukhi <prasanna.panchamukhi@gmail.com>
+	: Masami Hiramatsu <mhiramat@redhat.com>
 
 CONTENTS
 
@@ -15,6 +16,7 @@ CONTENTS
 9. Jprobes Example
 10. Kretprobes Example
 Appendix A: The kprobes debugfs interface
+Appendix B: The kprobes sysctl interface
 
 1. Concepts: Kprobes, Jprobes, Return Probes
 
@@ -42,13 +44,13 @@ registration/unregistration of a group of *probes. These functions
 can speed up unregistration process when you have to unregister
 a lot of probes at once.
 
-The next three subsections explain how the different types of
-probes work.  They explain certain things that you'll need to
-know in order to make the best use of Kprobes -- e.g., the
-difference between a pre_handler and a post_handler, and how
-to use the maxactive and nmissed fields of a kretprobe.  But
-if you're in a hurry to start using Kprobes, you can skip ahead
-to section 2.
+The next four subsections explain how the different types of
+probes work and how jump optimization works.  They explain certain
+things that you'll need to know in order to make the best use of
+Kprobes -- e.g., the difference between a pre_handler and
+a post_handler, and how to use the maxactive and nmissed fields of
+a kretprobe.  But if you're in a hurry to start using Kprobes, you
+can skip ahead to section 2.
 
 1.1 How Does a Kprobe Work?
 
@@ -161,13 +163,125 @@ In case probed function is entered but there is no kretprobe_instance
 object available, then in addition to incrementing the nmissed count,
 the user entry_handler invocation is also skipped.
 
+1.4 How Does Jump Optimization Work?
+
+If you configured your kernel with CONFIG_OPTPROBES=y (currently
+this option is supported on x86/x86-64, non-preemptive kernel) and
+the "debug.kprobes_optimization" kernel parameter is set to 1 (see
+sysctl(8)), Kprobes tries to reduce probe-hit overhead by using a jump
+instruction instead of a breakpoint instruction at each probepoint.
+
+1.4.1 Init a Kprobe
+
+When a probe is registered, before attempting this optimization,
+Kprobes inserts an ordinary, breakpoint-based kprobe at the specified
+address. So, even if it's not possible to optimize this particular
+probepoint, there'll be a probe there.
+
+1.4.2 Safety Check
+
+Before optimizing a probe, Kprobes performs the following safety checks:
+
+- Kprobes verifies that the region that will be replaced by the jump
+instruction (the "optimized region") lies entirely within one function.
+(A jump instruction is multiple bytes, and so may overlay multiple
+instructions.)
+
+- Kprobes analyzes the entire function and verifies that there is no
+jump into the optimized region.  Specifically:
+  - the function contains no indirect jump;
+  - the function contains no instruction that causes an exception (since
+  the fixup code triggered by the exception could jump back into the
+  optimized region -- Kprobes checks the exception tables to verify this);
+  and
+  - there is no near jump to the optimized region (other than to the first
+  byte).
+
+- For each instruction in the optimized region, Kprobes verifies that
+the instruction can be executed out of line.
+
+1.4.3 Preparing Detour Buffer
+
+Next, Kprobes prepares a "detour" buffer, which contains the following
+instruction sequence:
+- code to push the CPU's registers (emulating a breakpoint trap)
+- a call to the trampoline code which calls user's probe handlers.
+- code to restore registers
+- the instructions from the optimized region
+- a jump back to the original execution path.
+
+1.4.4 Pre-optimization
+
+After preparing the detour buffer, Kprobes verifies that none of the
+following situations exist:
+- The probe has either a break_handler (i.e., it's a jprobe) or a
+post_handler.
+- Other instructions in the optimized region are probed.
+- The probe is disabled.
+In any of the above cases, Kprobes won't start optimizing the probe.
+Since these are temporary situations, Kprobes tries to start
+optimizing it again if the situation is changed.
+
+If the kprobe can be optimized, Kprobes enqueues the kprobe to an
+optimizing list, and kicks the kprobe-optimizer workqueue to optimize
+it.  If the to-be-optimized probepoint is hit before being optimized,
+Kprobes returns control to the original instruction path by setting
+the CPU's instruction pointer to the copied code in the detour buffer
+-- thus at least avoiding the single-step.
+
+1.4.5 Optimization
+
+The Kprobe-optimizer doesn't insert the jump instruction immediately;
+rather, it calls synchronize_sched() for safety first, because it's
+possible for a CPU to be interrupted in the middle of executing the
+optimized region(*).  As you know, synchronize_sched() can ensure
+that all interruptions that were active when synchronize_sched()
+was called are done, but only if CONFIG_PREEMPT=n.  So, this version
+of kprobe optimization supports only kernels with CONFIG_PREEMPT=n.(**)
+
+After that, the Kprobe-optimizer calls stop_machine() to replace
+the optimized region with a jump instruction to the detour buffer,
+using text_poke_smp().
+
+1.4.6 Unoptimization
+
+When an optimized kprobe is unregistered, disabled, or blocked by
+another kprobe, it will be unoptimized.  If this happens before
+the optimization is complete, the kprobe is just dequeued from the
+optimized list.  If the optimization has been done, the jump is
+replaced with the original code (except for an int3 breakpoint in
+the first byte) by using text_poke_smp().
+
+(*)Please imagine that the 2nd instruction is interrupted and then
+the optimizer replaces the 2nd instruction with the jump *address*
+while the interrupt handler is running. When the interrupt
+returns to original address, there is no valid instruction,
+and it causes an unexpected result.
+
+(**)This optimization-safety checking may be replaced with the
+stop-machine method that ksplice uses for supporting a CONFIG_PREEMPT=y
+kernel.
+
+NOTE for geeks:
+The jump optimization changes the kprobe's pre_handler behavior.
+Without optimization, the pre_handler can change the kernel's execution
+path by changing regs->ip and returning 1.  However, when the probe
+is optimized, that modification is ignored.  Thus, if you want to
+tweak the kernel's execution path, you need to suppress optimization,
+using one of the following techniques:
+- Specify an empty function for the kprobe's post_handler or break_handler.
+ or
+- Config CONFIG_OPTPROBES=n.
+ or
+- Execute 'sysctl -w debug.kprobes_optimization=n'
+
 2. Architectures Supported
 
 Kprobes, jprobes, and return probes are implemented on the following
 architectures:
 
-- i386
-- x86_64 (AMD-64, EM64T)
+- i386 (Supports jump optimization)
+- x86_64 (AMD-64, EM64T) (Supports jump optimization)
 - ppc64
 - ia64 (Does not support probes on instruction slot1.)
 - sparc64 (Return probes not yet implemented.)
@@ -193,6 +307,10 @@ it useful to "Compile the kernel with debug info" (CONFIG_DEBUG_INFO),
 so you can use "objdump -d -l vmlinux" to see the source-to-object
 code mapping.
 
+If you want to reduce probing overhead, set "Kprobes jump optimization
+support" (CONFIG_OPTPROBES) to "y". You can find this option under the
+"Kprobes" line.
+
 4. API Reference
 
 The Kprobes API includes a "register" function and an "unregister"
@@ -389,7 +507,10 @@ the probe which has been registered.
 
 Kprobes allows multiple probes at the same address.  Currently,
 however, there cannot be multiple jprobes on the same function at
-the same time.
+the same time.  Also, a probepoint for which there is a jprobe or
+a post_handler cannot be optimized.  So if you install a jprobe,
+or a kprobe with a post_handler, at an optimized probepoint, the
+probepoint will be unoptimized automatically.
 
 In general, you can install a probe anywhere in the kernel.
 In particular, you can probe interrupt handlers.  Known exceptions
@@ -453,6 +574,38 @@ reason, Kprobes doesn't support return probes (or kprobes or jprobes)
 on the x86_64 version of __switch_to(); the registration functions
 return -EINVAL.
 
+On x86/x86-64, since the Jump Optimization of Kprobes modifies
+instructions widely, there are some limitations to optimization. To
+explain it, we introduce some terminology. Imagine a 3-instruction
+sequence consisting of a two 2-byte instructions and one 3-byte
+instruction.
+
+        IA
+         |
+[-2][-1][0][1][2][3][4][5][6][7]
+        [ins1][ins2][  ins3 ]
+	[<-     DCR       ->]
+	   [<- JTPR ->]
+
+ins1: 1st Instruction
+ins2: 2nd Instruction
+ins3: 3rd Instruction
+IA:  Insertion Address
+JTPR: Jump Target Prohibition Region
+DCR: Detoured Code Region
+
+The instructions in DCR are copied to the out-of-line buffer
+of the kprobe, because the bytes in DCR are replaced by
+a 5-byte jump instruction. So there are several limitations.
+
+a) The instructions in DCR must be relocatable.
+b) The instructions in DCR must not include a call instruction.
+c) JTPR must not be targeted by any jump or call instruction.
+d) DCR must not straddle the border betweeen functions.
+
+Anyway, these limitations are checked by the in-kernel instruction
+decoder, so you don't need to worry about that.
+
 6. Probe Overhead
 
 On a typical CPU in use in 2005, a kprobe hit takes 0.5 to 1.0
@@ -476,6 +629,19 @@ k = 0.49 usec; j = 0.76; r = 0.80; kr = 0.82; jr = 1.07
 ppc64: POWER5 (gr), 1656 MHz (SMT disabled, 1 virtual CPU per physical CPU)
 k = 0.77 usec; j = 1.31; r = 1.26; kr = 1.45; jr = 1.99
 
+6.1 Optimized Probe Overhead
+
+Typically, an optimized kprobe hit takes 0.07 to 0.1 microseconds to
+process. Here are sample overhead figures (in usec) for x86 architectures.
+k = unoptimized kprobe, b = boosted (single-step skipped), o = optimized kprobe,
+r = unoptimized kretprobe, rb = boosted kretprobe, ro = optimized kretprobe.
+
+i386: Intel(R) Xeon(R) E5410, 2.33GHz, 4656.90 bogomips
+k = 0.80 usec; b = 0.33; o = 0.05; r = 1.10; rb = 0.61; ro = 0.33
+
+x86-64: Intel(R) Xeon(R) E5410, 2.33GHz, 4656.90 bogomips
+k = 0.99 usec; b = 0.43; o = 0.06; r = 1.24; rb = 0.68; ro = 0.30
+
 7. TODO
 
 a. SystemTap (http://sourceware.org/systemtap): Provides a simplified
@@ -523,7 +689,8 @@ is also specified. Following columns show probe status. If the probe is on
 a virtual address that is no longer valid (module init sections, module
 virtual addresses that correspond to modules that've been unloaded),
 such probes are marked with [GONE]. If the probe is temporarily disabled,
-such probes are marked with [DISABLED].
+such probes are marked with [DISABLED]. If the probe is optimized, it is
+marked with [OPTIMIZED].
 
 /sys/kernel/debug/kprobes/enabled: Turn kprobes ON/OFF forcibly.
 
@@ -533,3 +700,19 @@ registered probes will be disarmed, till such time a "1" is echoed to this
 file. Note that this knob just disarms and arms all kprobes and doesn't
 change each probe's disabling state. This means that disabled kprobes (marked
 [DISABLED]) will be not enabled if you turn ON all kprobes by this knob.
+
+
+Appendix B: The kprobes sysctl interface
+
+/proc/sys/debug/kprobes-optimization: Turn kprobes optimization ON/OFF.
+
+When CONFIG_OPTPROBES=y, this sysctl interface appears and it provides
+a knob to globally and forcibly turn jump optimization (see section
+1.4) ON or OFF. By default, jump optimization is allowed (ON).
+If you echo "0" to this file or set "debug.kprobes_optimization" to
+0 via sysctl, all optimized probes will be unoptimized, and any new
+probes registered after that will not be optimized.  Note that this
+knob *changes* the optimized state. This means that optimized probes
+(marked [OPTIMIZED]) will be unoptimized ([OPTIMIZED] tag will be
+removed). If the knob is turned on, they will be optimized again.
+
diff --git a/arch/Kconfig b/arch/Kconfig
index 9d055b4..e0ad3ca 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -57,6 +57,17 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+config OPTPROBES
+	bool "Kprobes jump optimization support (EXPERIMENTAL)"
+	default y
+	depends on KPROBES
+	depends on !PREEMPT
+	depends on HAVE_OPTPROBES
+	select KALLSYMS_ALL
+	help
+	  This option will allow kprobes to optimize breakpoint to
+	  a jump for reducing its overhead.
+
 config HAVE_EFFICIENT_UNALIGNED_ACCESS
 	bool
 	help
@@ -99,6 +110,8 @@ config HAVE_KPROBES
 config HAVE_KRETPROBES
 	bool
 
+config HAVE_OPTPROBES
+	bool
 #
 # An arch should select this if it provides all these things:
 #
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cbcbfde..e6f5a98 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -31,6 +31,7 @@ config X86
 	select ARCH_WANT_FRAME_POINTERS
 	select HAVE_DMA_ATTRS
 	select HAVE_KRETPROBES
+	select HAVE_OPTPROBES
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_TRACER
diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index ac80b7d..643d6ab 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -160,10 +160,12 @@ static inline void apply_paravirt(struct paravirt_patch_site *start,
  * invalid instruction possible) or if the instructions are changed from a
  * consistent state to another consistent state atomically.
  * More care must be taken when modifying code in the SMP case because of
- * Intel's errata.
+ * Intel's errata. text_poke_smp() takes care that errata, but still
+ * doesn't support NMI/MCE handler code modifying.
  * On the local CPU you need to be protected again NMI or MCE handlers seeing an
  * inconsistent instruction while you patch.
  */
 extern void *text_poke(void *addr, const void *opcode, size_t len);
+extern void *text_poke_smp(void *addr, const void *opcode, size_t len);
 
 #endif /* _ASM_X86_ALTERNATIVE_H */
diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
index 4fe681d..4ffa345 100644
--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
@@ -32,7 +32,10 @@ struct kprobe;
 
 typedef u8 kprobe_opcode_t;
 #define BREAKPOINT_INSTRUCTION	0xcc
-#define RELATIVEJUMP_INSTRUCTION 0xe9
+#define RELATIVEJUMP_OPCODE 0xe9
+#define RELATIVEJUMP_SIZE 5
+#define RELATIVECALL_OPCODE 0xe8
+#define RELATIVE_ADDR_SIZE 4
 #define MAX_INSN_SIZE 16
 #define MAX_STACK_SIZE 64
 #define MIN_STACK_SIZE(ADDR)					       \
@@ -44,6 +47,17 @@ typedef u8 kprobe_opcode_t;
 
 #define flush_insn_slot(p)	do { } while (0)
 
+/* optinsn template addresses */
+extern kprobe_opcode_t optprobe_template_entry;
+extern kprobe_opcode_t optprobe_template_val;
+extern kprobe_opcode_t optprobe_template_call;
+extern kprobe_opcode_t optprobe_template_end;
+#define MAX_OPTIMIZED_LENGTH (MAX_INSN_SIZE + RELATIVE_ADDR_SIZE)
+#define MAX_OPTINSN_SIZE 				\
+	(((unsigned long)&optprobe_template_end -	\
+	  (unsigned long)&optprobe_template_entry) +	\
+	 MAX_OPTIMIZED_LENGTH + RELATIVEJUMP_SIZE)
+
 extern const int kretprobe_blacklist_size;
 
 void arch_remove_kprobe(struct kprobe *p);
@@ -64,6 +78,21 @@ struct arch_specific_insn {
 	int boostable;
 };
 
+struct arch_optimized_insn {
+	/* copy of the original instructions */
+	kprobe_opcode_t copied_insn[RELATIVE_ADDR_SIZE];
+	/* detour code buffer */
+	kprobe_opcode_t *insn;
+	/* the size of instructions copied to detour code buffer */
+	size_t size;
+};
+
+/* Return true (!0) if optinsn is prepared for optimization. */
+static inline int arch_prepared_optinsn(struct arch_optimized_insn *optinsn)
+{
+	return optinsn->size;
+}
+
 struct prev_kprobe {
 	struct kprobe *kp;
 	unsigned long status;
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index e63b80e..c41f13c 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -7,6 +7,7 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/memory.h>
+#include <linux/stop_machine.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
 #include <asm/pgtable.h>
@@ -570,3 +571,62 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
 	local_irq_restore(flags);
 	return addr;
 }
+
+/*
+ * Cross-modifying kernel text with stop_machine().
+ * This code originally comes from immediate value.
+ */
+static atomic_t stop_machine_first;
+static int wrote_text;
+
+struct text_poke_params {
+	void *addr;
+	const void *opcode;
+	size_t len;
+};
+
+static int __kprobes stop_machine_text_poke(void *data)
+{
+	struct text_poke_params *tpp = data;
+
+	if (atomic_dec_and_test(&stop_machine_first)) {
+		text_poke(tpp->addr, tpp->opcode, tpp->len);
+		smp_wmb();	/* Make sure other cpus see that this has run */
+		wrote_text = 1;
+	} else {
+		while (!wrote_text)
+			smp_rmb();
+		sync_core();
+	}
+
+	flush_icache_range((unsigned long)tpp->addr,
+			   (unsigned long)tpp->addr + tpp->len);
+	return 0;
+}
+
+/**
+ * text_poke_smp - Update instructions on a live kernel on SMP
+ * @addr: address to modify
+ * @opcode: source of the copy
+ * @len: length to copy
+ *
+ * Modify multi-byte instruction by using stop_machine() on SMP. This allows
+ * user to poke/set multi-byte text on SMP. Only non-NMI/MCE code modifying
+ * should be allowed, since stop_machine() does _not_ protect code against
+ * NMI and MCE.
+ *
+ * Note: Must be called under get_online_cpus() and text_mutex.
+ */
+void *__kprobes text_poke_smp(void *addr, const void *opcode, size_t len)
+{
+	struct text_poke_params tpp;
+
+	tpp.addr = addr;
+	tpp.opcode = opcode;
+	tpp.len = len;
+	atomic_set(&stop_machine_first, 1);
+	wrote_text = 0;
+	stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
+	return addr;
+}
+
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 5de9f4a..b43bbae 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -49,6 +49,7 @@
 #include <linux/module.h>
 #include <linux/kdebug.h>
 #include <linux/kallsyms.h>
+#include <linux/ftrace.h>
 
 #include <asm/cacheflush.h>
 #include <asm/desc.h>
@@ -106,16 +107,22 @@ struct kretprobe_blackpoint kretprobe_blacklist[] = {
 };
 const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
 
-/* Insert a jump instruction at address 'from', which jumps to address 'to'.*/
-static void __kprobes set_jmp_op(void *from, void *to)
+static void __kprobes __synthesize_relative_insn(void *from, void *to, u8 op)
 {
-	struct __arch_jmp_op {
-		char op;
+	struct __arch_relative_insn {
+		u8 op;
 		s32 raddr;
-	} __attribute__((packed)) * jop;
-	jop = (struct __arch_jmp_op *)from;
-	jop->raddr = (s32)((long)(to) - ((long)(from) + 5));
-	jop->op = RELATIVEJUMP_INSTRUCTION;
+	} __attribute__((packed)) *insn;
+
+	insn = (struct __arch_relative_insn *)from;
+	insn->raddr = (s32)((long)(to) - ((long)(from) + 5));
+	insn->op = op;
+}
+
+/* Insert a jump instruction at address 'from', which jumps to address 'to'.*/
+static void __kprobes synthesize_reljump(void *from, void *to)
+{
+	__synthesize_relative_insn(from, to, RELATIVEJUMP_OPCODE);
 }
 
 /*
@@ -202,7 +209,7 @@ static int recover_probed_instruction(kprobe_opcode_t *buf, unsigned long addr)
 	/*
 	 *  Basically, kp->ainsn.insn has an original instruction.
 	 *  However, RIP-relative instruction can not do single-stepping
-	 *  at different place, fix_riprel() tweaks the displacement of
+	 *  at different place, __copy_instruction() tweaks the displacement of
 	 *  that instruction. In that case, we can't recover the instruction
 	 *  from the kp->ainsn.insn.
 	 *
@@ -284,21 +291,37 @@ static int __kprobes is_IF_modifier(kprobe_opcode_t *insn)
 }
 
 /*
- * Adjust the displacement if the instruction uses the %rip-relative
- * addressing mode.
+ * Copy an instruction and adjust the displacement if the instruction
+ * uses the %rip-relative addressing mode.
  * If it does, Return the address of the 32-bit displacement word.
  * If not, return null.
  * Only applicable to 64-bit x86.
  */
-static void __kprobes fix_riprel(struct kprobe *p)
+static int __kprobes __copy_instruction(u8 *dest, u8 *src, int recover)
 {
-#ifdef CONFIG_X86_64
 	struct insn insn;
-	kernel_insn_init(&insn, p->ainsn.insn);
+	int ret;
+	kprobe_opcode_t buf[MAX_INSN_SIZE];
 
+	kernel_insn_init(&insn, src);
+	if (recover) {
+		insn_get_opcode(&insn);
+		if (insn.opcode.bytes[0] == BREAKPOINT_INSTRUCTION) {
+			ret = recover_probed_instruction(buf,
+							 (unsigned long)src);
+			if (ret)
+				return 0;
+			kernel_insn_init(&insn, buf);
+		}
+	}
+	insn_get_length(&insn);
+	memcpy(dest, insn.kaddr, insn.length);
+
+#ifdef CONFIG_X86_64
 	if (insn_rip_relative(&insn)) {
 		s64 newdisp;
 		u8 *disp;
+		kernel_insn_init(&insn, dest);
 		insn_get_displacement(&insn);
 		/*
 		 * The copied instruction uses the %rip-relative addressing
@@ -312,20 +335,23 @@ static void __kprobes fix_riprel(struct kprobe *p)
 		 * extension of the original signed 32-bit displacement would
 		 * have given.
 		 */
-		newdisp = (u8 *) p->addr + (s64) insn.displacement.value -
-			  (u8 *) p->ainsn.insn;
+		newdisp = (u8 *) src + (s64) insn.displacement.value -
+			  (u8 *) dest;
 		BUG_ON((s64) (s32) newdisp != newdisp); /* Sanity check.  */
-		disp = (u8 *) p->ainsn.insn + insn_offset_displacement(&insn);
+		disp = (u8 *) dest + insn_offset_displacement(&insn);
 		*(s32 *) disp = (s32) newdisp;
 	}
 #endif
+	return insn.length;
 }
 
 static void __kprobes arch_copy_kprobe(struct kprobe *p)
 {
-	memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
-
-	fix_riprel(p);
+	/*
+	 * Copy an instruction without recovering int3, because it will be
+	 * put by another subsystem.
+	 */
+	__copy_instruction(p->ainsn.insn, p->addr, 0);
 
 	if (can_boost(p->addr))
 		p->ainsn.boostable = 0;
@@ -406,18 +432,6 @@ static void __kprobes restore_btf(void)
 		update_debugctlmsr(current->thread.debugctlmsr);
 }
 
-static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
-{
-	clear_btf();
-	regs->flags |= X86_EFLAGS_TF;
-	regs->flags &= ~X86_EFLAGS_IF;
-	/* single step inline if the instruction is an int3 */
-	if (p->opcode == BREAKPOINT_INSTRUCTION)
-		regs->ip = (unsigned long)p->addr;
-	else
-		regs->ip = (unsigned long)p->ainsn.insn;
-}
-
 void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
@@ -429,20 +443,50 @@ void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 	*sara = (unsigned long) &kretprobe_trampoline;
 }
 
+#ifdef CONFIG_OPTPROBES
+static int  __kprobes setup_detour_execution(struct kprobe *p,
+					     struct pt_regs *regs,
+					     int reenter);
+#else
+#define setup_detour_execution(p, regs, reenter) (0)
+#endif
+
 static void __kprobes setup_singlestep(struct kprobe *p, struct pt_regs *regs,
-				       struct kprobe_ctlblk *kcb)
+				       struct kprobe_ctlblk *kcb, int reenter)
 {
+	if (setup_detour_execution(p, regs, reenter))
+		return;
+
 #if !defined(CONFIG_PREEMPT)
 	if (p->ainsn.boostable == 1 && !p->post_handler) {
 		/* Boost up -- we can execute copied instructions directly */
-		reset_current_kprobe();
+		if (!reenter)
+			reset_current_kprobe();
+		/*
+		 * Reentering boosted probe doesn't reset current_kprobe,
+		 * nor set current_kprobe, because it doesn't use single
+		 * stepping.
+		 */
 		regs->ip = (unsigned long)p->ainsn.insn;
 		preempt_enable_no_resched();
 		return;
 	}
 #endif
-	prepare_singlestep(p, regs);
-	kcb->kprobe_status = KPROBE_HIT_SS;
+	if (reenter) {
+		save_previous_kprobe(kcb);
+		set_current_kprobe(p, regs, kcb);
+		kcb->kprobe_status = KPROBE_REENTER;
+	} else
+		kcb->kprobe_status = KPROBE_HIT_SS;
+	/* Prepare real single stepping */
+	clear_btf();
+	regs->flags |= X86_EFLAGS_TF;
+	regs->flags &= ~X86_EFLAGS_IF;
+	/* single step inline if the instruction is an int3 */
+	if (p->opcode == BREAKPOINT_INSTRUCTION)
+		regs->ip = (unsigned long)p->addr;
+	else
+		regs->ip = (unsigned long)p->ainsn.insn;
 }
 
 /*
@@ -456,11 +500,8 @@ static int __kprobes reenter_kprobe(struct kprobe *p, struct pt_regs *regs,
 	switch (kcb->kprobe_status) {
 	case KPROBE_HIT_SSDONE:
 	case KPROBE_HIT_ACTIVE:
-		save_previous_kprobe(kcb);
-		set_current_kprobe(p, regs, kcb);
 		kprobes_inc_nmissed_count(p);
-		prepare_singlestep(p, regs);
-		kcb->kprobe_status = KPROBE_REENTER;
+		setup_singlestep(p, regs, kcb, 1);
 		break;
 	case KPROBE_HIT_SS:
 		/* A probe has been hit in the codepath leading up to, or just
@@ -535,13 +576,13 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 			 * more here.
 			 */
 			if (!p->pre_handler || !p->pre_handler(p, regs))
-				setup_singlestep(p, regs, kcb);
+				setup_singlestep(p, regs, kcb, 0);
 			return 1;
 		}
 	} else if (kprobe_running()) {
 		p = __get_cpu_var(current_kprobe);
 		if (p->break_handler && p->break_handler(p, regs)) {
-			setup_singlestep(p, regs, kcb);
+			setup_singlestep(p, regs, kcb, 0);
 			return 1;
 		}
 	} /* else: not a kprobe fault; let the kernel handle it */
@@ -550,6 +591,69 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 	return 0;
 }
 
+#ifdef CONFIG_X86_64
+#define SAVE_REGS_STRING		\
+	/* Skip cs, ip, orig_ax. */	\
+	"	subq $24, %rsp\n"	\
+	"	pushq %rdi\n"		\
+	"	pushq %rsi\n"		\
+	"	pushq %rdx\n"		\
+	"	pushq %rcx\n"		\
+	"	pushq %rax\n"		\
+	"	pushq %r8\n"		\
+	"	pushq %r9\n"		\
+	"	pushq %r10\n"		\
+	"	pushq %r11\n"		\
+	"	pushq %rbx\n"		\
+	"	pushq %rbp\n"		\
+	"	pushq %r12\n"		\
+	"	pushq %r13\n"		\
+	"	pushq %r14\n"		\
+	"	pushq %r15\n"
+#define RESTORE_REGS_STRING		\
+	"	popq %r15\n"		\
+	"	popq %r14\n"		\
+	"	popq %r13\n"		\
+	"	popq %r12\n"		\
+	"	popq %rbp\n"		\
+	"	popq %rbx\n"		\
+	"	popq %r11\n"		\
+	"	popq %r10\n"		\
+	"	popq %r9\n"		\
+	"	popq %r8\n"		\
+	"	popq %rax\n"		\
+	"	popq %rcx\n"		\
+	"	popq %rdx\n"		\
+	"	popq %rsi\n"		\
+	"	popq %rdi\n"		\
+	/* Skip orig_ax, ip, cs */	\
+	"	addq $24, %rsp\n"
+#else
+#define SAVE_REGS_STRING		\
+	/* Skip cs, ip, orig_ax and gs. */	\
+	"	subl $16, %esp\n"	\
+	"	pushl %fs\n"		\
+	"	pushl %ds\n"		\
+	"	pushl %es\n"		\
+	"	pushl %eax\n"		\
+	"	pushl %ebp\n"		\
+	"	pushl %edi\n"		\
+	"	pushl %esi\n"		\
+	"	pushl %edx\n"		\
+	"	pushl %ecx\n"		\
+	"	pushl %ebx\n"
+#define RESTORE_REGS_STRING		\
+	"	popl %ebx\n"		\
+	"	popl %ecx\n"		\
+	"	popl %edx\n"		\
+	"	popl %esi\n"		\
+	"	popl %edi\n"		\
+	"	popl %ebp\n"		\
+	"	popl %eax\n"		\
+	/* Skip ds, es, fs, gs, orig_ax, and ip. Note: don't pop cs here*/\
+	"	addl $24, %esp\n"
+#endif
+
 /*
  * When a retprobed function returns, this code saves registers and
  * calls trampoline_handler() runs, which calls the kretprobe's handler.
@@ -563,65 +667,16 @@ static void __used __kprobes kretprobe_trampoline_holder(void)
 			/* We don't bother saving the ss register */
 			"	pushq %rsp\n"
 			"	pushfq\n"
-			/*
-			 * Skip cs, ip, orig_ax.
-			 * trampoline_handler() will plug in these values
-			 */
-			"	subq $24, %rsp\n"
-			"	pushq %rdi\n"
-			"	pushq %rsi\n"
-			"	pushq %rdx\n"
-			"	pushq %rcx\n"
-			"	pushq %rax\n"
-			"	pushq %r8\n"
-			"	pushq %r9\n"
-			"	pushq %r10\n"
-			"	pushq %r11\n"
-			"	pushq %rbx\n"
-			"	pushq %rbp\n"
-			"	pushq %r12\n"
-			"	pushq %r13\n"
-			"	pushq %r14\n"
-			"	pushq %r15\n"
+			SAVE_REGS_STRING
 			"	movq %rsp, %rdi\n"
 			"	call trampoline_handler\n"
 			/* Replace saved sp with true return address. */
 			"	movq %rax, 152(%rsp)\n"
-			"	popq %r15\n"
-			"	popq %r14\n"
-			"	popq %r13\n"
-			"	popq %r12\n"
-			"	popq %rbp\n"
-			"	popq %rbx\n"
-			"	popq %r11\n"
-			"	popq %r10\n"
-			"	popq %r9\n"
-			"	popq %r8\n"
-			"	popq %rax\n"
-			"	popq %rcx\n"
-			"	popq %rdx\n"
-			"	popq %rsi\n"
-			"	popq %rdi\n"
-			/* Skip orig_ax, ip, cs */
-			"	addq $24, %rsp\n"
+			RESTORE_REGS_STRING
 			"	popfq\n"
 #else
 			"	pushf\n"
-			/*
-			 * Skip cs, ip, orig_ax and gs.
-			 * trampoline_handler() will plug in these values
-			 */
-			"	subl $16, %esp\n"
-			"	pushl %fs\n"
-			"	pushl %es\n"
-			"	pushl %ds\n"
-			"	pushl %eax\n"
-			"	pushl %ebp\n"
-			"	pushl %edi\n"
-			"	pushl %esi\n"
-			"	pushl %edx\n"
-			"	pushl %ecx\n"
-			"	pushl %ebx\n"
+			SAVE_REGS_STRING
 			"	movl %esp, %eax\n"
 			"	call trampoline_handler\n"
 			/* Move flags to cs */
@@ -629,15 +684,7 @@ static void __used __kprobes kretprobe_trampoline_holder(void)
 			"	movl %edx, 52(%esp)\n"
 			/* Replace saved flags with true return address. */
 			"	movl %eax, 56(%esp)\n"
-			"	popl %ebx\n"
-			"	popl %ecx\n"
-			"	popl %edx\n"
-			"	popl %esi\n"
-			"	popl %edi\n"
-			"	popl %ebp\n"
-			"	popl %eax\n"
-			/* Skip ds, es, fs, gs, orig_ax and ip */
-			"	addl $24, %esp\n"
+			RESTORE_REGS_STRING
 			"	popf\n"
 #endif
 			"	ret\n");
@@ -805,8 +852,8 @@ static void __kprobes resume_execution(struct kprobe *p,
 			 * These instructions can be executed directly if it
 			 * jumps back to correct address.
 			 */
-			set_jmp_op((void *)regs->ip,
-				   (void *)orig_ip + (regs->ip - copy_ip));
+			synthesize_reljump((void *)regs->ip,
+				(void *)orig_ip + (regs->ip - copy_ip));
 			p->ainsn.boostable = 1;
 		} else {
 			p->ainsn.boostable = -1;
@@ -1033,6 +1080,358 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 	return 0;
 }
 
+
+#ifdef CONFIG_OPTPROBES
+
+/* Insert a call instruction at address 'from', which calls address 'to'.*/
+static void __kprobes synthesize_relcall(void *from, void *to)
+{
+	__synthesize_relative_insn(from, to, RELATIVECALL_OPCODE);
+}
+
+/* Insert a move instruction which sets a pointer to eax/rdi (1st arg). */
+static void __kprobes synthesize_set_arg1(kprobe_opcode_t *addr,
+					  unsigned long val)
+{
+#ifdef CONFIG_X86_64
+	*addr++ = 0x48;
+	*addr++ = 0xbf;
+#else
+	*addr++ = 0xb8;
+#endif
+	*(unsigned long *)addr = val;
+}
+
+void __kprobes kprobes_optinsn_template_holder(void)
+{
+	asm volatile (
+			".global optprobe_template_entry\n"
+			"optprobe_template_entry: \n"
+#ifdef CONFIG_X86_64
+			/* We don't bother saving the ss register */
+			"	pushq %rsp\n"
+			"	pushfq\n"
+			SAVE_REGS_STRING
+			"	movq %rsp, %rsi\n"
+			".global optprobe_template_val\n"
+			"optprobe_template_val: \n"
+			ASM_NOP5
+			ASM_NOP5
+			".global optprobe_template_call\n"
+			"optprobe_template_call: \n"
+			ASM_NOP5
+			/* Move flags to rsp */
+			"	movq 144(%rsp), %rdx\n"
+			"	movq %rdx, 152(%rsp)\n"
+			RESTORE_REGS_STRING
+			/* Skip flags entry */
+			"	addq $8, %rsp\n"
+			"	popfq\n"
+#else /* CONFIG_X86_32 */
+			"	pushf\n"
+			SAVE_REGS_STRING
+			"	movl %esp, %edx\n"
+			".global optprobe_template_val\n"
+			"optprobe_template_val: \n"
+			ASM_NOP5
+			".global optprobe_template_call\n"
+			"optprobe_template_call: \n"
+			ASM_NOP5
+			RESTORE_REGS_STRING
+			"	addl $4, %esp\n"	/* skip cs */
+			"	popf\n"
+#endif
+			".global optprobe_template_end\n"
+			"optprobe_template_end: \n");
+}
+
+#define TMPL_MOVE_IDX \
+	((long)&optprobe_template_val - (long)&optprobe_template_entry)
+#define TMPL_CALL_IDX \
+	((long)&optprobe_template_call - (long)&optprobe_template_entry)
+#define TMPL_END_IDX \
+	((long)&optprobe_template_end - (long)&optprobe_template_entry)
+
+#define INT3_SIZE sizeof(kprobe_opcode_t)
+
+/* Optimized kprobe call back function: called from optinsn */
+static void __kprobes optimized_callback(struct optimized_kprobe *op,
+					 struct pt_regs *regs)
+{
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	preempt_disable();
+	if (kprobe_running()) {
+		kprobes_inc_nmissed_count(&op->kp);
+	} else {
+		/* Save skipped registers */
+#ifdef CONFIG_X86_64
+		regs->cs = __KERNEL_CS;
+#else
+		regs->cs = __KERNEL_CS | get_kernel_rpl();
+		regs->gs = 0;
+#endif
+		regs->ip = (unsigned long)op->kp.addr + INT3_SIZE;
+		regs->orig_ax = ~0UL;
+
+		__get_cpu_var(current_kprobe) = &op->kp;
+		kcb->kprobe_status = KPROBE_HIT_ACTIVE;
+		opt_pre_handler(&op->kp, regs);
+		__get_cpu_var(current_kprobe) = NULL;
+	}
+	preempt_enable_no_resched();
+}
+
+static int __kprobes copy_optimized_instructions(u8 *dest, u8 *src)
+{
+	int len = 0, ret;
+
+	while (len < RELATIVEJUMP_SIZE) {
+		ret = __copy_instruction(dest + len, src + len, 1);
+		if (!ret || !can_boost(dest + len))
+			return -EINVAL;
+		len += ret;
+	}
+	/* Check whether the address range is reserved */
+	if (ftrace_text_reserved(src, src + len - 1) ||
+	    alternatives_text_reserved(src, src + len - 1))
+		return -EBUSY;
+
+	return len;
+}
+
+/* Check whether insn is indirect jump */
+static int __kprobes insn_is_indirect_jump(struct insn *insn)
+{
+	return ((insn->opcode.bytes[0] == 0xff &&
+		(X86_MODRM_REG(insn->modrm.value) & 6) == 4) || /* Jump */
+		insn->opcode.bytes[0] == 0xea);	/* Segment based jump */
+}
+
+/* Check whether insn jumps into specified address range */
+static int insn_jump_into_range(struct insn *insn, unsigned long start, int len)
+{
+	unsigned long target = 0;
+
+	switch (insn->opcode.bytes[0]) {
+	case 0xe0:	/* loopne */
+	case 0xe1:	/* loope */
+	case 0xe2:	/* loop */
+	case 0xe3:	/* jcxz */
+	case 0xe9:	/* near relative jump */
+	case 0xeb:	/* short relative jump */
+		break;
+	case 0x0f:
+		if ((insn->opcode.bytes[1] & 0xf0) == 0x80) /* jcc near */
+			break;
+		return 0;
+	default:
+		if ((insn->opcode.bytes[0] & 0xf0) == 0x70) /* jcc short */
+			break;
+		return 0;
+	}
+	target = (unsigned long)insn->next_byte + insn->immediate.value;
+
+	return (start <= target && target <= start + len);
+}
+
+/* Decode whole function to ensure any instructions don't jump into target */
+static int __kprobes can_optimize(unsigned long paddr)
+{
+	int ret;
+	unsigned long addr, size = 0, offset = 0;
+	struct insn insn;
+	kprobe_opcode_t buf[MAX_INSN_SIZE];
+	/* Dummy buffers for lookup_symbol_attrs */
+	static char __dummy_buf[KSYM_NAME_LEN];
+
+	/* Lookup symbol including addr */
+	if (!kallsyms_lookup(paddr, &size, &offset, NULL, __dummy_buf))
+		return 0;
+
+	/* Check there is enough space for a relative jump. */
+	if (size - offset < RELATIVEJUMP_SIZE)
+		return 0;
+
+	/* Decode instructions */
+	addr = paddr - offset;
+	while (addr < paddr - offset + size) { /* Decode until function end */
+		if (search_exception_tables(addr))
+			/*
+			 * Since some fixup code will jumps into this function,
+			 * we can't optimize kprobe in this function.
+			 */
+			return 0;
+		kernel_insn_init(&insn, (void *)addr);
+		insn_get_opcode(&insn);
+		if (insn.opcode.bytes[0] == BREAKPOINT_INSTRUCTION) {
+			ret = recover_probed_instruction(buf, addr);
+			if (ret)
+				return 0;
+			kernel_insn_init(&insn, buf);
+		}
+		insn_get_length(&insn);
+		/* Recover address */
+		insn.kaddr = (void *)addr;
+		insn.next_byte = (void *)(addr + insn.length);
+		/* Check any instructions don't jump into target */
+		if (insn_is_indirect_jump(&insn) ||
+		    insn_jump_into_range(&insn, paddr + INT3_SIZE,
+					 RELATIVE_ADDR_SIZE))
+			return 0;
+		addr += insn.length;
+	}
+
+	return 1;
+}
+
+/* Check optimized_kprobe can actually be optimized. */
+int __kprobes arch_check_optimized_kprobe(struct optimized_kprobe *op)
+{
+	int i;
+	struct kprobe *p;
+
+	for (i = 1; i < op->optinsn.size; i++) {
+		p = get_kprobe(op->kp.addr + i);
+		if (p && !kprobe_disabled(p))
+			return -EEXIST;
+	}
+
+	return 0;
+}
+
+/* Check the addr is within the optimized instructions. */
+int __kprobes arch_within_optimized_kprobe(struct optimized_kprobe *op,
+					   unsigned long addr)
+{
+	return ((unsigned long)op->kp.addr <= addr &&
+		(unsigned long)op->kp.addr + op->optinsn.size > addr);
+}
+
+/* Free optimized instruction slot */
+static __kprobes
+void __arch_remove_optimized_kprobe(struct optimized_kprobe *op, int dirty)
+{
+	if (op->optinsn.insn) {
+		free_optinsn_slot(op->optinsn.insn, dirty);
+		op->optinsn.insn = NULL;
+		op->optinsn.size = 0;
+	}
+}
+
+void __kprobes arch_remove_optimized_kprobe(struct optimized_kprobe *op)
+{
+	__arch_remove_optimized_kprobe(op, 1);
+}
+
+/*
+ * Copy replacing target instructions
+ * Target instructions MUST be relocatable (checked inside)
+ */
+int __kprobes arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
+{
+	u8 *buf;
+	int ret;
+	long rel;
+
+	if (!can_optimize((unsigned long)op->kp.addr))
+		return -EILSEQ;
+
+	op->optinsn.insn = get_optinsn_slot();
+	if (!op->optinsn.insn)
+		return -ENOMEM;
+
+	/*
+	 * Verify if the address gap is in 2GB range, because this uses
+	 * a relative jump.
+	 */
+	rel = (long)op->optinsn.insn - (long)op->kp.addr + RELATIVEJUMP_SIZE;
+	if (abs(rel) > 0x7fffffff)
+		return -ERANGE;
+
+	buf = (u8 *)op->optinsn.insn;
+
+	/* Copy instructions into the out-of-line buffer */
+	ret = copy_optimized_instructions(buf + TMPL_END_IDX, op->kp.addr);
+	if (ret < 0) {
+		__arch_remove_optimized_kprobe(op, 0);
+		return ret;
+	}
+	op->optinsn.size = ret;
+
+	/* Copy arch-dep-instance from template */
+	memcpy(buf, &optprobe_template_entry, TMPL_END_IDX);
+
+	/* Set probe information */
+	synthesize_set_arg1(buf + TMPL_MOVE_IDX, (unsigned long)op);
+
+	/* Set probe function call */
+	synthesize_relcall(buf + TMPL_CALL_IDX, optimized_callback);
+
+	/* Set returning jmp instruction at the tail of out-of-line buffer */
+	synthesize_reljump(buf + TMPL_END_IDX + op->optinsn.size,
+			   (u8 *)op->kp.addr + op->optinsn.size);
+
+	flush_icache_range((unsigned long) buf,
+			   (unsigned long) buf + TMPL_END_IDX +
+			   op->optinsn.size + RELATIVEJUMP_SIZE);
+	return 0;
+}
+
+/* Replace a breakpoint (int3) with a relative jump.  */
+int __kprobes arch_optimize_kprobe(struct optimized_kprobe *op)
+{
+	unsigned char jmp_code[RELATIVEJUMP_SIZE];
+	s32 rel = (s32)((long)op->optinsn.insn -
+			((long)op->kp.addr + RELATIVEJUMP_SIZE));
+
+	/* Backup instructions which will be replaced by jump address */
+	memcpy(op->optinsn.copied_insn, op->kp.addr + INT3_SIZE,
+	       RELATIVE_ADDR_SIZE);
+
+	jmp_code[0] = RELATIVEJUMP_OPCODE;
+	*(s32 *)(&jmp_code[1]) = rel;
+
+	/*
+	 * text_poke_smp doesn't support NMI/MCE code modifying.
+	 * However, since kprobes itself also doesn't support NMI/MCE
+	 * code probing, it's not a problem.
+	 */
+	text_poke_smp(op->kp.addr, jmp_code, RELATIVEJUMP_SIZE);
+	return 0;
+}
+
+/* Replace a relative jump with a breakpoint (int3).  */
+void __kprobes arch_unoptimize_kprobe(struct optimized_kprobe *op)
+{
+	u8 buf[RELATIVEJUMP_SIZE];
+
+	/* Set int3 to first byte for kprobes */
+	buf[0] = BREAKPOINT_INSTRUCTION;
+	memcpy(buf + 1, op->optinsn.copied_insn, RELATIVE_ADDR_SIZE);
+	text_poke_smp(op->kp.addr, buf, RELATIVEJUMP_SIZE);
+}
+
+static int  __kprobes setup_detour_execution(struct kprobe *p,
+					     struct pt_regs *regs,
+					     int reenter)
+{
+	struct optimized_kprobe *op;
+
+	if (p->flags & KPROBE_FLAG_OPTIMIZED) {
+		/* This kprobe is really able to run optimized path. */
+		op = container_of(p, struct optimized_kprobe, kp);
+		/* Detour through copied instructions */
+		regs->ip = (unsigned long)op->optinsn.insn + TMPL_END_IDX;
+		if (!reenter)
+			reset_current_kprobe();
+		preempt_enable_no_resched();
+		return 1;
+	}
+	return 0;
+}
+#endif
+
 int __init arch_init_kprobes(void)
 {
 	return 0;
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 1b672f7..e7d1b2e 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -122,6 +122,11 @@ struct kprobe {
 /* Kprobe status flags */
 #define KPROBE_FLAG_GONE	1 /* breakpoint has already gone */
 #define KPROBE_FLAG_DISABLED	2 /* probe is temporarily disabled */
+#define KPROBE_FLAG_OPTIMIZED	4 /*
+				   * probe is really optimized.
+				   * NOTE:
+				   * this flag is only for optimized_kprobe.
+				   */
 
 /* Has this kprobe gone ? */
 static inline int kprobe_gone(struct kprobe *p)
@@ -134,6 +139,12 @@ static inline int kprobe_disabled(struct kprobe *p)
 {
 	return p->flags & (KPROBE_FLAG_DISABLED | KPROBE_FLAG_GONE);
 }
+
+/* Is this kprobe really running optimized path ? */
+static inline int kprobe_optimized(struct kprobe *p)
+{
+	return p->flags & KPROBE_FLAG_OPTIMIZED;
+}
 /*
  * Special probe type that uses setjmp-longjmp type tricks to resume
  * execution at a specified entry with a matching prototype corresponding
@@ -249,6 +260,39 @@ extern kprobe_opcode_t *get_insn_slot(void);
 extern void free_insn_slot(kprobe_opcode_t *slot, int dirty);
 extern void kprobes_inc_nmissed_count(struct kprobe *p);
 
+#ifdef CONFIG_OPTPROBES
+/*
+ * Internal structure for direct jump optimized probe
+ */
+struct optimized_kprobe {
+	struct kprobe kp;
+	struct list_head list;	/* list for optimizing queue */
+	struct arch_optimized_insn optinsn;
+};
+
+/* Architecture dependent functions for direct jump optimization */
+extern int arch_prepared_optinsn(struct arch_optimized_insn *optinsn);
+extern int arch_check_optimized_kprobe(struct optimized_kprobe *op);
+extern int arch_prepare_optimized_kprobe(struct optimized_kprobe *op);
+extern void arch_remove_optimized_kprobe(struct optimized_kprobe *op);
+extern int  arch_optimize_kprobe(struct optimized_kprobe *op);
+extern void arch_unoptimize_kprobe(struct optimized_kprobe *op);
+extern kprobe_opcode_t *get_optinsn_slot(void);
+extern void free_optinsn_slot(kprobe_opcode_t *slot, int dirty);
+extern int arch_within_optimized_kprobe(struct optimized_kprobe *op,
+					unsigned long addr);
+
+extern void opt_pre_handler(struct kprobe *p, struct pt_regs *regs);
+
+#ifdef CONFIG_SYSCTL
+extern int sysctl_kprobes_optimization;
+extern int proc_kprobes_optimization_handler(struct ctl_table *table,
+					     int write, void __user *buffer,
+					     size_t *length, loff_t *ppos);
+#endif
+
+#endif /* CONFIG_OPTPROBES */
+
 /* Get the kprobe at this addr (if any) - called with preemption disabled */
 struct kprobe *get_kprobe(void *addr);
 void kretprobe_hash_lock(struct task_struct *tsk,
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index ccec774..fa034d2 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -42,9 +42,11 @@
 #include <linux/freezer.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
+#include <linux/sysctl.h>
 #include <linux/kdebug.h>
 #include <linux/memory.h>
 #include <linux/ftrace.h>
+#include <linux/cpu.h>
 
 #include <asm-generic/sections.h>
 #include <asm/cacheflush.h>
@@ -105,57 +107,74 @@ static struct kprobe_blackpoint kprobe_blacklist[] = {
  * stepping on the instruction on a vmalloced/kmalloced/data page
  * is a recipe for disaster
  */
-#define INSNS_PER_PAGE	(PAGE_SIZE/(MAX_INSN_SIZE * sizeof(kprobe_opcode_t)))
-
 struct kprobe_insn_page {
 	struct list_head list;
 	kprobe_opcode_t *insns;		/* Page of instruction slots */
-	char slot_used[INSNS_PER_PAGE];
 	int nused;
 	int ngarbage;
+	char slot_used[];
+};
+
+#define KPROBE_INSN_PAGE_SIZE(slots)			\
+	(offsetof(struct kprobe_insn_page, slot_used) +	\
+	 (sizeof(char) * (slots)))
+
+struct kprobe_insn_cache {
+	struct list_head pages;	/* list of kprobe_insn_page */
+	size_t insn_size;	/* size of instruction slot */
+	int nr_garbage;
 };
 
+static int slots_per_page(struct kprobe_insn_cache *c)
+{
+	return PAGE_SIZE/(c->insn_size * sizeof(kprobe_opcode_t));
+}
+
 enum kprobe_slot_state {
 	SLOT_CLEAN = 0,
 	SLOT_DIRTY = 1,
 	SLOT_USED = 2,
 };
 
-static DEFINE_MUTEX(kprobe_insn_mutex);	/* Protects kprobe_insn_pages */
-static LIST_HEAD(kprobe_insn_pages);
-static int kprobe_garbage_slots;
-static int collect_garbage_slots(void);
+static DEFINE_MUTEX(kprobe_insn_mutex);	/* Protects kprobe_insn_slots */
+static struct kprobe_insn_cache kprobe_insn_slots = {
+	.pages = LIST_HEAD_INIT(kprobe_insn_slots.pages),
+	.insn_size = MAX_INSN_SIZE,
+	.nr_garbage = 0,
+};
+static int __kprobes collect_garbage_slots(struct kprobe_insn_cache *c);
 
 /**
  * __get_insn_slot() - Find a slot on an executable page for an instruction.
  * We allocate an executable page if there's no room on existing ones.
  */
-static kprobe_opcode_t __kprobes *__get_insn_slot(void)
+static kprobe_opcode_t __kprobes *__get_insn_slot(struct kprobe_insn_cache *c)
 {
 	struct kprobe_insn_page *kip;
 
  retry:
-	list_for_each_entry(kip, &kprobe_insn_pages, list) {
-		if (kip->nused < INSNS_PER_PAGE) {
+	list_for_each_entry(kip, &c->pages, list) {
+		if (kip->nused < slots_per_page(c)) {
 			int i;
-			for (i = 0; i < INSNS_PER_PAGE; i++) {
+			for (i = 0; i < slots_per_page(c); i++) {
 				if (kip->slot_used[i] == SLOT_CLEAN) {
 					kip->slot_used[i] = SLOT_USED;
 					kip->nused++;
-					return kip->insns + (i * MAX_INSN_SIZE);
+					return kip->insns + (i * c->insn_size);
 				}
 			}
-			/* Surprise!  No unused slots.  Fix kip->nused. */
-			kip->nused = INSNS_PER_PAGE;
+			/* kip->nused is broken. Fix it. */
+			kip->nused = slots_per_page(c);
+			WARN_ON(1);
 		}
 	}
 
 	/* If there are any garbage slots, collect it and try again. */
-	if (kprobe_garbage_slots && collect_garbage_slots() == 0) {
+	if (c->nr_garbage && collect_garbage_slots(c) == 0)
 		goto retry;
-	}
-	/* All out of space.  Need to allocate a new page. Use slot 0. */
-	kip = kmalloc(sizeof(struct kprobe_insn_page), GFP_KERNEL);
+
+	/* All out of space.  Need to allocate a new page. */
+	kip = kmalloc(KPROBE_INSN_PAGE_SIZE(slots_per_page(c)), GFP_KERNEL);
 	if (!kip)
 		return NULL;
 
@@ -170,20 +189,23 @@ static kprobe_opcode_t __kprobes *__get_insn_slot(void)
 		return NULL;
 	}
 	INIT_LIST_HEAD(&kip->list);
-	list_add(&kip->list, &kprobe_insn_pages);
-	memset(kip->slot_used, SLOT_CLEAN, INSNS_PER_PAGE);
+	memset(kip->slot_used, SLOT_CLEAN, slots_per_page(c));
 	kip->slot_used[0] = SLOT_USED;
 	kip->nused = 1;
 	kip->ngarbage = 0;
+	list_add(&kip->list, &c->pages);
 	return kip->insns;
 }
 
+
 kprobe_opcode_t __kprobes *get_insn_slot(void)
 {
-	kprobe_opcode_t *ret;
+	kprobe_opcode_t *ret = NULL;
+
 	mutex_lock(&kprobe_insn_mutex);
-	ret = __get_insn_slot();
+	ret = __get_insn_slot(&kprobe_insn_slots);
 	mutex_unlock(&kprobe_insn_mutex);
+
 	return ret;
 }
 
@@ -199,7 +221,7 @@ static int __kprobes collect_one_slot(struct kprobe_insn_page *kip, int idx)
 		 * so as not to have to set it up again the
 		 * next time somebody inserts a probe.
 		 */
-		if (!list_is_singular(&kprobe_insn_pages)) {
+		if (!list_is_singular(&kip->list)) {
 			list_del(&kip->list);
 			module_free(NULL, kip->insns);
 			kfree(kip);
@@ -209,51 +231,84 @@ static int __kprobes collect_one_slot(struct kprobe_insn_page *kip, int idx)
 	return 0;
 }
 
-static int __kprobes collect_garbage_slots(void)
+static int __kprobes collect_garbage_slots(struct kprobe_insn_cache *c)
 {
 	struct kprobe_insn_page *kip, *next;
 
 	/* Ensure no-one is interrupted on the garbages */
 	synchronize_sched();
 
-	list_for_each_entry_safe(kip, next, &kprobe_insn_pages, list) {
+	list_for_each_entry_safe(kip, next, &c->pages, list) {
 		int i;
 		if (kip->ngarbage == 0)
 			continue;
 		kip->ngarbage = 0;	/* we will collect all garbages */
-		for (i = 0; i < INSNS_PER_PAGE; i++) {
+		for (i = 0; i < slots_per_page(c); i++) {
 			if (kip->slot_used[i] == SLOT_DIRTY &&
 			    collect_one_slot(kip, i))
 				break;
 		}
 	}
-	kprobe_garbage_slots = 0;
+	c->nr_garbage = 0;
 	return 0;
 }
 
-void __kprobes free_insn_slot(kprobe_opcode_t * slot, int dirty)
+static void __kprobes __free_insn_slot(struct kprobe_insn_cache *c,
+				       kprobe_opcode_t *slot, int dirty)
 {
 	struct kprobe_insn_page *kip;
 
-	mutex_lock(&kprobe_insn_mutex);
-	list_for_each_entry(kip, &kprobe_insn_pages, list) {
-		if (kip->insns <= slot &&
-		    slot < kip->insns + (INSNS_PER_PAGE * MAX_INSN_SIZE)) {
-			int i = (slot - kip->insns) / MAX_INSN_SIZE;
+	list_for_each_entry(kip, &c->pages, list) {
+		long idx = ((long)slot - (long)kip->insns) / c->insn_size;
+		if (idx >= 0 && idx < slots_per_page(c)) {
+			WARN_ON(kip->slot_used[idx] != SLOT_USED);
 			if (dirty) {
-				kip->slot_used[i] = SLOT_DIRTY;
+				kip->slot_used[idx] = SLOT_DIRTY;
 				kip->ngarbage++;
+				if (++c->nr_garbage > slots_per_page(c))
+					collect_garbage_slots(c);
 			} else
-				collect_one_slot(kip, i);
-			break;
+				collect_one_slot(kip, idx);
+			return;
 		}
 	}
+	/* Could not free this slot. */
+	WARN_ON(1);
+}
 
-	if (dirty && ++kprobe_garbage_slots > INSNS_PER_PAGE)
-		collect_garbage_slots();
-
+void __kprobes free_insn_slot(kprobe_opcode_t * slot, int dirty)
+{
+	mutex_lock(&kprobe_insn_mutex);
+	__free_insn_slot(&kprobe_insn_slots, slot, dirty);
 	mutex_unlock(&kprobe_insn_mutex);
 }
+#ifdef CONFIG_OPTPROBES
+/* For optimized_kprobe buffer */
+static DEFINE_MUTEX(kprobe_optinsn_mutex); /* Protects kprobe_optinsn_slots */
+static struct kprobe_insn_cache kprobe_optinsn_slots = {
+	.pages = LIST_HEAD_INIT(kprobe_optinsn_slots.pages),
+	/* .insn_size is initialized later */
+	.nr_garbage = 0,
+};
+/* Get a slot for optimized_kprobe buffer */
+kprobe_opcode_t __kprobes *get_optinsn_slot(void)
+{
+	kprobe_opcode_t *ret = NULL;
+
+	mutex_lock(&kprobe_optinsn_mutex);
+	ret = __get_insn_slot(&kprobe_optinsn_slots);
+	mutex_unlock(&kprobe_optinsn_mutex);
+
+	return ret;
+}
+
+void __kprobes free_optinsn_slot(kprobe_opcode_t * slot, int dirty)
+{
+	mutex_lock(&kprobe_optinsn_mutex);
+	__free_insn_slot(&kprobe_optinsn_slots, slot, dirty);
+	mutex_unlock(&kprobe_optinsn_mutex);
+}
+#endif
 #endif
 
 /* We have preemption disabled.. so it is safe to use __ versions */
@@ -284,23 +339,401 @@ struct kprobe __kprobes *get_kprobe(void *addr)
 		if (p->addr == addr)
 			return p;
 	}
+
+	return NULL;
+}
+
+static int __kprobes aggr_pre_handler(struct kprobe *p, struct pt_regs *regs);
+
+/* Return true if the kprobe is an aggregator */
+static inline int kprobe_aggrprobe(struct kprobe *p)
+{
+	return p->pre_handler == aggr_pre_handler;
+}
+
+/*
+ * Keep all fields in the kprobe consistent
+ */
+static inline void copy_kprobe(struct kprobe *old_p, struct kprobe *p)
+{
+	memcpy(&p->opcode, &old_p->opcode, sizeof(kprobe_opcode_t));
+	memcpy(&p->ainsn, &old_p->ainsn, sizeof(struct arch_specific_insn));
+}
+
+#ifdef CONFIG_OPTPROBES
+/* NOTE: change this value only with kprobe_mutex held */
+static bool kprobes_allow_optimization;
+
+/*
+ * Call all pre_handler on the list, but ignores its return value.
+ * This must be called from arch-dep optimized caller.
+ */
+void __kprobes opt_pre_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct kprobe *kp;
+
+	list_for_each_entry_rcu(kp, &p->list, list) {
+		if (kp->pre_handler && likely(!kprobe_disabled(kp))) {
+			set_kprobe_instance(kp);
+			kp->pre_handler(kp, regs);
+		}
+		reset_kprobe_instance();
+	}
+}
+
+/* Return true(!0) if the kprobe is ready for optimization. */
+static inline int kprobe_optready(struct kprobe *p)
+{
+	struct optimized_kprobe *op;
+
+	if (kprobe_aggrprobe(p)) {
+		op = container_of(p, struct optimized_kprobe, kp);
+		return arch_prepared_optinsn(&op->optinsn);
+	}
+
+	return 0;
+}
+
+/*
+ * Return an optimized kprobe whose optimizing code replaces
+ * instructions including addr (exclude breakpoint).
+ */
+struct kprobe *__kprobes get_optimized_kprobe(unsigned long addr)
+{
+	int i;
+	struct kprobe *p = NULL;
+	struct optimized_kprobe *op;
+
+	/* Don't check i == 0, since that is a breakpoint case. */
+	for (i = 1; !p && i < MAX_OPTIMIZED_LENGTH; i++)
+		p = get_kprobe((void *)(addr - i));
+
+	if (p && kprobe_optready(p)) {
+		op = container_of(p, struct optimized_kprobe, kp);
+		if (arch_within_optimized_kprobe(op, addr))
+			return p;
+	}
+
 	return NULL;
 }
 
+/* Optimization staging list, protected by kprobe_mutex */
+static LIST_HEAD(optimizing_list);
+
+static void kprobe_optimizer(struct work_struct *work);
+static DECLARE_DELAYED_WORK(optimizing_work, kprobe_optimizer);
+#define OPTIMIZE_DELAY 5
+
+/* Kprobe jump optimizer */
+static __kprobes void kprobe_optimizer(struct work_struct *work)
+{
+	struct optimized_kprobe *op, *tmp;
+
+	/* Lock modules while optimizing kprobes */
+	mutex_lock(&module_mutex);
+	mutex_lock(&kprobe_mutex);
+	if (kprobes_all_disarmed || !kprobes_allow_optimization)
+		goto end;
+
+	/*
+	 * Wait for quiesence period to ensure all running interrupts
+	 * are done. Because optprobe may modify multiple instructions
+	 * there is a chance that Nth instruction is interrupted. In that
+	 * case, running interrupt can return to 2nd-Nth byte of jump
+	 * instruction. This wait is for avoiding it.
+	 */
+	synchronize_sched();
+
+	/*
+	 * The optimization/unoptimization refers online_cpus via
+	 * stop_machine() and cpu-hotplug modifies online_cpus.
+	 * And same time, text_mutex will be held in cpu-hotplug and here.
+	 * This combination can cause a deadlock (cpu-hotplug try to lock
+	 * text_mutex but stop_machine can not be done because online_cpus
+	 * has been changed)
+	 * To avoid this deadlock, we need to call get_online_cpus()
+	 * for preventing cpu-hotplug outside of text_mutex locking.
+	 */
+	get_online_cpus();
+	mutex_lock(&text_mutex);
+	list_for_each_entry_safe(op, tmp, &optimizing_list, list) {
+		WARN_ON(kprobe_disabled(&op->kp));
+		if (arch_optimize_kprobe(op) < 0)
+			op->kp.flags &= ~KPROBE_FLAG_OPTIMIZED;
+		list_del_init(&op->list);
+	}
+	mutex_unlock(&text_mutex);
+	put_online_cpus();
+end:
+	mutex_unlock(&kprobe_mutex);
+	mutex_unlock(&module_mutex);
+}
+
+/* Optimize kprobe if p is ready to be optimized */
+static __kprobes void optimize_kprobe(struct kprobe *p)
+{
+	struct optimized_kprobe *op;
+
+	/* Check if the kprobe is disabled or not ready for optimization. */
+	if (!kprobe_optready(p) || !kprobes_allow_optimization ||
+	    (kprobe_disabled(p) || kprobes_all_disarmed))
+		return;
+
+	/* Both of break_handler and post_handler are not supported. */
+	if (p->break_handler || p->post_handler)
+		return;
+
+	op = container_of(p, struct optimized_kprobe, kp);
+
+	/* Check there is no other kprobes at the optimized instructions */
+	if (arch_check_optimized_kprobe(op) < 0)
+		return;
+
+	/* Check if it is already optimized. */
+	if (op->kp.flags & KPROBE_FLAG_OPTIMIZED)
+		return;
+
+	op->kp.flags |= KPROBE_FLAG_OPTIMIZED;
+	list_add(&op->list, &optimizing_list);
+	if (!delayed_work_pending(&optimizing_work))
+		schedule_delayed_work(&optimizing_work, OPTIMIZE_DELAY);
+}
+
+/* Unoptimize a kprobe if p is optimized */
+static __kprobes void unoptimize_kprobe(struct kprobe *p)
+{
+	struct optimized_kprobe *op;
+
+	if ((p->flags & KPROBE_FLAG_OPTIMIZED) && kprobe_aggrprobe(p)) {
+		op = container_of(p, struct optimized_kprobe, kp);
+		if (!list_empty(&op->list))
+			/* Dequeue from the optimization queue */
+			list_del_init(&op->list);
+		else
+			/* Replace jump with break */
+			arch_unoptimize_kprobe(op);
+		op->kp.flags &= ~KPROBE_FLAG_OPTIMIZED;
+	}
+}
+
+/* Remove optimized instructions */
+static void __kprobes kill_optimized_kprobe(struct kprobe *p)
+{
+	struct optimized_kprobe *op;
+
+	op = container_of(p, struct optimized_kprobe, kp);
+	if (!list_empty(&op->list)) {
+		/* Dequeue from the optimization queue */
+		list_del_init(&op->list);
+		op->kp.flags &= ~KPROBE_FLAG_OPTIMIZED;
+	}
+	/* Don't unoptimize, because the target code will be freed. */
+	arch_remove_optimized_kprobe(op);
+}
+
+/* Try to prepare optimized instructions */
+static __kprobes void prepare_optimized_kprobe(struct kprobe *p)
+{
+	struct optimized_kprobe *op;
+
+	op = container_of(p, struct optimized_kprobe, kp);
+	arch_prepare_optimized_kprobe(op);
+}
+
+/* Free optimized instructions and optimized_kprobe */
+static __kprobes void free_aggr_kprobe(struct kprobe *p)
+{
+	struct optimized_kprobe *op;
+
+	op = container_of(p, struct optimized_kprobe, kp);
+	arch_remove_optimized_kprobe(op);
+	kfree(op);
+}
+
+/* Allocate new optimized_kprobe and try to prepare optimized instructions */
+static __kprobes struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
+{
+	struct optimized_kprobe *op;
+
+	op = kzalloc(sizeof(struct optimized_kprobe), GFP_KERNEL);
+	if (!op)
+		return NULL;
+
+	INIT_LIST_HEAD(&op->list);
+	op->kp.addr = p->addr;
+	arch_prepare_optimized_kprobe(op);
+
+	return &op->kp;
+}
+
+static void __kprobes init_aggr_kprobe(struct kprobe *ap, struct kprobe *p);
+
+/*
+ * Prepare an optimized_kprobe and optimize it
+ * NOTE: p must be a normal registered kprobe
+ */
+static __kprobes void try_to_optimize_kprobe(struct kprobe *p)
+{
+	struct kprobe *ap;
+	struct optimized_kprobe *op;
+
+	ap = alloc_aggr_kprobe(p);
+	if (!ap)
+		return;
+
+	op = container_of(ap, struct optimized_kprobe, kp);
+	if (!arch_prepared_optinsn(&op->optinsn)) {
+		/* If failed to setup optimizing, fallback to kprobe */
+		free_aggr_kprobe(ap);
+		return;
+	}
+
+	init_aggr_kprobe(ap, p);
+	optimize_kprobe(ap);
+}
+
+#ifdef CONFIG_SYSCTL
+static void __kprobes optimize_all_kprobes(void)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct kprobe *p;
+	unsigned int i;
+
+	/* If optimization is already allowed, just return */
+	if (kprobes_allow_optimization)
+		return;
+
+	kprobes_allow_optimization = true;
+	mutex_lock(&text_mutex);
+	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
+		head = &kprobe_table[i];
+		hlist_for_each_entry_rcu(p, node, head, hlist)
+			if (!kprobe_disabled(p))
+				optimize_kprobe(p);
+	}
+	mutex_unlock(&text_mutex);
+	printk(KERN_INFO "Kprobes globally optimized\n");
+}
+
+static void __kprobes unoptimize_all_kprobes(void)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct kprobe *p;
+	unsigned int i;
+
+	/* If optimization is already prohibited, just return */
+	if (!kprobes_allow_optimization)
+		return;
+
+	kprobes_allow_optimization = false;
+	printk(KERN_INFO "Kprobes globally unoptimized\n");
+	get_online_cpus();	/* For avoiding text_mutex deadlock */
+	mutex_lock(&text_mutex);
+	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
+		head = &kprobe_table[i];
+		hlist_for_each_entry_rcu(p, node, head, hlist) {
+			if (!kprobe_disabled(p))
+				unoptimize_kprobe(p);
+		}
+	}
+
+	mutex_unlock(&text_mutex);
+	put_online_cpus();
+	/* Allow all currently running kprobes to complete */
+	synchronize_sched();
+}
+
+int sysctl_kprobes_optimization;
+int proc_kprobes_optimization_handler(struct ctl_table *table, int write,
+				      void __user *buffer, size_t *length,
+				      loff_t *ppos)
+{
+	int ret;
+
+	mutex_lock(&kprobe_mutex);
+	sysctl_kprobes_optimization = kprobes_allow_optimization ? 1 : 0;
+	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
+
+	if (sysctl_kprobes_optimization)
+		optimize_all_kprobes();
+	else
+		unoptimize_all_kprobes();
+	mutex_unlock(&kprobe_mutex);
+
+	return ret;
+}
+#endif /* CONFIG_SYSCTL */
+
+static void __kprobes __arm_kprobe(struct kprobe *p)
+{
+	struct kprobe *old_p;
+
+	/* Check collision with other optimized kprobes */
+	old_p = get_optimized_kprobe((unsigned long)p->addr);
+	if (unlikely(old_p))
+		unoptimize_kprobe(old_p); /* Fallback to unoptimized kprobe */
+
+	arch_arm_kprobe(p);
+	optimize_kprobe(p);	/* Try to optimize (add kprobe to a list) */
+}
+
+static void __kprobes __disarm_kprobe(struct kprobe *p)
+{
+	struct kprobe *old_p;
+
+	unoptimize_kprobe(p);	/* Try to unoptimize */
+	arch_disarm_kprobe(p);
+
+	/* If another kprobe was blocked, optimize it. */
+	old_p = get_optimized_kprobe((unsigned long)p->addr);
+	if (unlikely(old_p))
+		optimize_kprobe(old_p);
+}
+
+#else /* !CONFIG_OPTPROBES */
+
+#define optimize_kprobe(p)			do {} while (0)
+#define unoptimize_kprobe(p)			do {} while (0)
+#define kill_optimized_kprobe(p)		do {} while (0)
+#define prepare_optimized_kprobe(p)		do {} while (0)
+#define try_to_optimize_kprobe(p)		do {} while (0)
+#define __arm_kprobe(p)				arch_arm_kprobe(p)
+#define __disarm_kprobe(p)			arch_disarm_kprobe(p)
+
+static __kprobes void free_aggr_kprobe(struct kprobe *p)
+{
+	kfree(p);
+}
+
+static __kprobes struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
+{
+	return kzalloc(sizeof(struct kprobe), GFP_KERNEL);
+}
+#endif /* CONFIG_OPTPROBES */
+
 /* Arm a kprobe with text_mutex */
 static void __kprobes arm_kprobe(struct kprobe *kp)
 {
+	/*
+	 * Here, since __arm_kprobe() doesn't use stop_machine(),
+	 * this doesn't cause deadlock on text_mutex. So, we don't
+	 * need get_online_cpus().
+	 */
 	mutex_lock(&text_mutex);
-	arch_arm_kprobe(kp);
+	__arm_kprobe(kp);
 	mutex_unlock(&text_mutex);
 }
 
 /* Disarm a kprobe with text_mutex */
 static void __kprobes disarm_kprobe(struct kprobe *kp)
 {
+	get_online_cpus();	/* For avoiding text_mutex deadlock */
 	mutex_lock(&text_mutex);
-	arch_disarm_kprobe(kp);
+	__disarm_kprobe(kp);
 	mutex_unlock(&text_mutex);
+	put_online_cpus();
 }
 
 /*
@@ -369,7 +802,7 @@ static int __kprobes aggr_break_handler(struct kprobe *p, struct pt_regs *regs)
 void __kprobes kprobes_inc_nmissed_count(struct kprobe *p)
 {
 	struct kprobe *kp;
-	if (p->pre_handler != aggr_pre_handler) {
+	if (!kprobe_aggrprobe(p)) {
 		p->nmissed++;
 	} else {
 		list_for_each_entry_rcu(kp, &p->list, list)
@@ -493,21 +926,16 @@ static void __kprobes cleanup_rp_inst(struct kretprobe *rp)
 }
 
 /*
- * Keep all fields in the kprobe consistent
- */
-static inline void copy_kprobe(struct kprobe *old_p, struct kprobe *p)
-{
-	memcpy(&p->opcode, &old_p->opcode, sizeof(kprobe_opcode_t));
-	memcpy(&p->ainsn, &old_p->ainsn, sizeof(struct arch_specific_insn));
-}
-
-/*
 * Add the new probe to ap->list. Fail if this is the
 * second jprobe at the address - two jprobes can't coexist
 */
 static int __kprobes add_new_kprobe(struct kprobe *ap, struct kprobe *p)
 {
 	BUG_ON(kprobe_gone(ap) || kprobe_gone(p));
+
+	if (p->break_handler || p->post_handler)
+		unoptimize_kprobe(ap);	/* Fall back to normal kprobe */
+
 	if (p->break_handler) {
 		if (ap->break_handler)
 			return -EEXIST;
@@ -522,7 +950,7 @@ static int __kprobes add_new_kprobe(struct kprobe *ap, struct kprobe *p)
 		ap->flags &= ~KPROBE_FLAG_DISABLED;
 		if (!kprobes_all_disarmed)
 			/* Arm the breakpoint again. */
-			arm_kprobe(ap);
+			__arm_kprobe(ap);
 	}
 	return 0;
 }
@@ -531,12 +959,13 @@ static int __kprobes add_new_kprobe(struct kprobe *ap, struct kprobe *p)
  * Fill in the required fields of the "manager kprobe". Replace the
  * earlier kprobe in the hlist with the manager kprobe
  */
-static inline void add_aggr_kprobe(struct kprobe *ap, struct kprobe *p)
+static void __kprobes init_aggr_kprobe(struct kprobe *ap, struct kprobe *p)
 {
+	/* Copy p's insn slot to ap */
 	copy_kprobe(p, ap);
 	flush_insn_slot(ap);
 	ap->addr = p->addr;
-	ap->flags = p->flags;
+	ap->flags = p->flags & ~KPROBE_FLAG_OPTIMIZED;
 	ap->pre_handler = aggr_pre_handler;
 	ap->fault_handler = aggr_fault_handler;
 	/* We don't care the kprobe which has gone. */
@@ -546,8 +975,9 @@ static inline void add_aggr_kprobe(struct kprobe *ap, struct kprobe *p)
 		ap->break_handler = aggr_break_handler;
 
 	INIT_LIST_HEAD(&ap->list);
-	list_add_rcu(&p->list, &ap->list);
+	INIT_HLIST_NODE(&ap->hlist);
 
+	list_add_rcu(&p->list, &ap->list);
 	hlist_replace_rcu(&p->hlist, &ap->hlist);
 }
 
@@ -561,12 +991,12 @@ static int __kprobes register_aggr_kprobe(struct kprobe *old_p,
 	int ret = 0;
 	struct kprobe *ap = old_p;
 
-	if (old_p->pre_handler != aggr_pre_handler) {
-		/* If old_p is not an aggr_probe, create new aggr_kprobe. */
-		ap = kzalloc(sizeof(struct kprobe), GFP_KERNEL);
+	if (!kprobe_aggrprobe(old_p)) {
+		/* If old_p is not an aggr_kprobe, create new aggr_kprobe. */
+		ap = alloc_aggr_kprobe(old_p);
 		if (!ap)
 			return -ENOMEM;
-		add_aggr_kprobe(ap, old_p);
+		init_aggr_kprobe(ap, old_p);
 	}
 
 	if (kprobe_gone(ap)) {
@@ -585,6 +1015,9 @@ static int __kprobes register_aggr_kprobe(struct kprobe *old_p,
 			 */
 			return ret;
 
+		/* Prepare optimized instructions if possible. */
+		prepare_optimized_kprobe(ap);
+
 		/*
 		 * Clear gone flag to prevent allocating new slot again, and
 		 * set disabled flag because it is not armed yet.
@@ -593,6 +1026,7 @@ static int __kprobes register_aggr_kprobe(struct kprobe *old_p,
 			    | KPROBE_FLAG_DISABLED;
 	}
 
+	/* Copy ap's insn slot to p */
 	copy_kprobe(ap, p);
 	return add_new_kprobe(ap, p);
 }
@@ -743,27 +1177,34 @@ int __kprobes register_kprobe(struct kprobe *p)
 	p->nmissed = 0;
 	INIT_LIST_HEAD(&p->list);
 	mutex_lock(&kprobe_mutex);
+
+	get_online_cpus();	/* For avoiding text_mutex deadlock. */
+	mutex_lock(&text_mutex);
+
 	old_p = get_kprobe(p->addr);
 	if (old_p) {
+		/* Since this may unoptimize old_p, locking text_mutex. */
 		ret = register_aggr_kprobe(old_p, p);
 		goto out;
 	}
 
-	mutex_lock(&text_mutex);
 	ret = arch_prepare_kprobe(p);
 	if (ret)
-		goto out_unlock_text;
+		goto out;
 
 	INIT_HLIST_NODE(&p->hlist);
 	hlist_add_head_rcu(&p->hlist,
 		       &kprobe_table[hash_ptr(p->addr, KPROBE_HASH_BITS)]);
 
 	if (!kprobes_all_disarmed && !kprobe_disabled(p))
-		arch_arm_kprobe(p);
+		__arm_kprobe(p);
+
+	/* Try to optimize kprobe */
+	try_to_optimize_kprobe(p);
 
-out_unlock_text:
-	mutex_unlock(&text_mutex);
 out:
+	mutex_unlock(&text_mutex);
+	put_online_cpus();
 	mutex_unlock(&kprobe_mutex);
 
 	if (probed_mod)
@@ -785,7 +1226,7 @@ static int __kprobes __unregister_kprobe_top(struct kprobe *p)
 		return -EINVAL;
 
 	if (old_p == p ||
-	    (old_p->pre_handler == aggr_pre_handler &&
+	    (kprobe_aggrprobe(old_p) &&
 	     list_is_singular(&old_p->list))) {
 		/*
 		 * Only probe on the hash list. Disarm only if kprobes are
@@ -793,7 +1234,7 @@ static int __kprobes __unregister_kprobe_top(struct kprobe *p)
 		 * already have been removed. We save on flushing icache.
 		 */
 		if (!kprobes_all_disarmed && !kprobe_disabled(old_p))
-			disarm_kprobe(p);
+			disarm_kprobe(old_p);
 		hlist_del_rcu(&old_p->hlist);
 	} else {
 		if (p->break_handler && !kprobe_gone(p))
@@ -809,8 +1250,13 @@ noclean:
 		list_del_rcu(&p->list);
 		if (!kprobe_disabled(old_p)) {
 			try_to_disable_aggr_kprobe(old_p);
-			if (!kprobes_all_disarmed && kprobe_disabled(old_p))
-				disarm_kprobe(old_p);
+			if (!kprobes_all_disarmed) {
+				if (kprobe_disabled(old_p))
+					disarm_kprobe(old_p);
+				else
+					/* Try to optimize this probe again */
+					optimize_kprobe(old_p);
+			}
 		}
 	}
 	return 0;
@@ -827,7 +1273,7 @@ static void __kprobes __unregister_kprobe_bottom(struct kprobe *p)
 		old_p = list_entry(p->list.next, struct kprobe, list);
 		list_del(&p->list);
 		arch_remove_kprobe(old_p);
-		kfree(old_p);
+		free_aggr_kprobe(old_p);
 	}
 }
 
@@ -1123,7 +1569,7 @@ static void __kprobes kill_kprobe(struct kprobe *p)
 	struct kprobe *kp;
 
 	p->flags |= KPROBE_FLAG_GONE;
-	if (p->pre_handler == aggr_pre_handler) {
+	if (kprobe_aggrprobe(p)) {
 		/*
 		 * If this is an aggr_kprobe, we have to list all the
 		 * chained probes and mark them GONE.
@@ -1132,6 +1578,7 @@ static void __kprobes kill_kprobe(struct kprobe *p)
 			kp->flags |= KPROBE_FLAG_GONE;
 		p->post_handler = NULL;
 		p->break_handler = NULL;
+		kill_optimized_kprobe(p);
 	}
 	/*
 	 * Here, we can remove insn_slot safely, because no thread calls
@@ -1241,6 +1688,15 @@ static int __init init_kprobes(void)
 		}
 	}
 
+#if defined(CONFIG_OPTPROBES)
+#if defined(__ARCH_WANT_KPROBES_INSN_SLOT)
+	/* Init kprobe_optinsn_slots */
+	kprobe_optinsn_slots.insn_size = MAX_OPTINSN_SIZE;
+#endif
+	/* By default, kprobes can be optimized */
+	kprobes_allow_optimization = true;
+#endif
+
 	/* By default, kprobes are armed */
 	kprobes_all_disarmed = false;
 
@@ -1259,7 +1715,7 @@ static int __init init_kprobes(void)
 
 #ifdef CONFIG_DEBUG_FS
 static void __kprobes report_probe(struct seq_file *pi, struct kprobe *p,
-		const char *sym, int offset,char *modname)
+		const char *sym, int offset, char *modname, struct kprobe *pp)
 {
 	char *kprobe_type;
 
@@ -1269,19 +1725,21 @@ static void __kprobes report_probe(struct seq_file *pi, struct kprobe *p,
 		kprobe_type = "j";
 	else
 		kprobe_type = "k";
+
 	if (sym)
-		seq_printf(pi, "%p  %s  %s+0x%x  %s %s%s\n",
+		seq_printf(pi, "%p  %s  %s+0x%x  %s ",
 			p->addr, kprobe_type, sym, offset,
-			(modname ? modname : " "),
-			(kprobe_gone(p) ? "[GONE]" : ""),
-			((kprobe_disabled(p) && !kprobe_gone(p)) ?
-			 "[DISABLED]" : ""));
+			(modname ? modname : " "));
 	else
-		seq_printf(pi, "%p  %s  %p %s%s\n",
-			p->addr, kprobe_type, p->addr,
-			(kprobe_gone(p) ? "[GONE]" : ""),
-			((kprobe_disabled(p) && !kprobe_gone(p)) ?
-			 "[DISABLED]" : ""));
+		seq_printf(pi, "%p  %s  %p ",
+			p->addr, kprobe_type, p->addr);
+
+	if (!pp)
+		pp = p;
+	seq_printf(pi, "%s%s%s\n",
+		(kprobe_gone(p) ? "[GONE]" : ""),
+		((kprobe_disabled(p) && !kprobe_gone(p)) ?  "[DISABLED]" : ""),
+		(kprobe_optimized(pp) ? "[OPTIMIZED]" : ""));
 }
 
 static void __kprobes *kprobe_seq_start(struct seq_file *f, loff_t *pos)
@@ -1317,11 +1775,11 @@ static int __kprobes show_kprobe_addr(struct seq_file *pi, void *v)
 	hlist_for_each_entry_rcu(p, node, head, hlist) {
 		sym = kallsyms_lookup((unsigned long)p->addr, NULL,
 					&offset, &modname, namebuf);
-		if (p->pre_handler == aggr_pre_handler) {
+		if (kprobe_aggrprobe(p)) {
 			list_for_each_entry_rcu(kp, &p->list, list)
-				report_probe(pi, kp, sym, offset, modname);
+				report_probe(pi, kp, sym, offset, modname, p);
 		} else
-			report_probe(pi, p, sym, offset, modname);
+			report_probe(pi, p, sym, offset, modname, NULL);
 	}
 	preempt_enable();
 	return 0;
@@ -1399,12 +1857,13 @@ int __kprobes enable_kprobe(struct kprobe *kp)
 		goto out;
 	}
 
-	if (!kprobes_all_disarmed && kprobe_disabled(p))
-		arm_kprobe(p);
-
-	p->flags &= ~KPROBE_FLAG_DISABLED;
 	if (p != kp)
 		kp->flags &= ~KPROBE_FLAG_DISABLED;
+
+	if (!kprobes_all_disarmed && kprobe_disabled(p)) {
+		p->flags &= ~KPROBE_FLAG_DISABLED;
+		arm_kprobe(p);
+	}
 out:
 	mutex_unlock(&kprobe_mutex);
 	return ret;
@@ -1424,12 +1883,13 @@ static void __kprobes arm_all_kprobes(void)
 	if (!kprobes_all_disarmed)
 		goto already_enabled;
 
+	/* Arming kprobes doesn't optimize kprobe itself */
 	mutex_lock(&text_mutex);
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist)
 			if (!kprobe_disabled(p))
-				arch_arm_kprobe(p);
+				__arm_kprobe(p);
 	}
 	mutex_unlock(&text_mutex);
 
@@ -1456,16 +1916,23 @@ static void __kprobes disarm_all_kprobes(void)
 
 	kprobes_all_disarmed = true;
 	printk(KERN_INFO "Kprobes globally disabled\n");
+
+	/*
+	 * Here we call get_online_cpus() for avoiding text_mutex deadlock,
+	 * because disarming may also unoptimize kprobes.
+	 */
+	get_online_cpus();
 	mutex_lock(&text_mutex);
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist) {
 			if (!arch_trampoline_kprobe(p) && !kprobe_disabled(p))
-				arch_disarm_kprobe(p);
+				__disarm_kprobe(p);
 		}
 	}
 
 	mutex_unlock(&text_mutex);
+	put_online_cpus();
 	mutex_unlock(&kprobe_mutex);
 	/* Allow all currently running kprobes to complete */
 	synchronize_sched();
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 8a68b24..40d791d 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -50,6 +50,7 @@
 #include <linux/ftrace.h>
 #include <linux/slow-work.h>
 #include <linux/perf_event.h>
+#include <linux/kprobes.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -1450,6 +1451,17 @@ static struct ctl_table debug_table[] = {
 		.proc_handler	= proc_dointvec
 	},
 #endif
+#if defined(CONFIG_OPTPROBES)
+	{
+		.procname	= "kprobes-optimization",
+		.data		= &sysctl_kprobes_optimization,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_kprobes_optimization_handler,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+#endif
 	{ }
 };
 
diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 2de3407..34202b1 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -41,7 +41,8 @@ OPTIONS
 
 -d::
 --del=::
-	Delete a probe event.
+	Delete probe events. This accepts glob wildcards('*', '?') and character
+	classes(e.g. [a-z], [!A-Z]).
 
 -l::
 --list::
@@ -50,17 +51,29 @@ OPTIONS
 -L::
 --line=::
 	Show source code lines which can be probed. This needs an argument
-	which specifies a range of the source code.
+	which specifies a range of the source code. (see LINE SYNTAX for detail)
+
+-f::
+--force::
+	Forcibly add events with existing name.
 
 PROBE SYNTAX
 ------------
 Probe points are defined by following syntax.
 
- "[EVENT=]FUNC[+OFFS|:RLN|%return][@SRC]|SRC:ALN [ARG ...]"
+    1) Define event based on function name
+     [EVENT=]FUNC[@SRC][:RLN|+OFFS|%return|;PTN] [ARG ...]
+
+    2) Define event based on source file with line number
+     [EVENT=]SRC:ALN [ARG ...]
+
+    3) Define event based on source file with lazy pattern
+     [EVENT=]SRC;PTN [ARG ...]
+
 
 'EVENT' specifies the name of new event, if omitted, it will be set the name of the probed function. Currently, event group name is set as 'probe'.
-'FUNC' specifies a probed function name, and it may have one of the following options; '+OFFS' is the offset from function entry address in bytes, 'RLN' is the relative-line number from function entry line, and '%return' means that it probes function return. In addition, 'SRC' specifies a source file which has that function.
-It is also possible to specify a probe point by the source line number by using 'SRC:ALN' syntax, where 'SRC' is the source file path and 'ALN' is the line number.
+'FUNC' specifies a probed function name, and it may have one of the following options; '+OFFS' is the offset from function entry address in bytes, ':RLN' is the relative-line number from function entry line, and '%return' means that it probes function return. And ';PTN' means lazy matching pattern (see LAZY MATCHING). Note that ';PTN' must be the end of the probe point definition.  In addition, '@SRC' specifies a source file which has that function.
+It is also possible to specify a probe point by the source line number or lazy matching by using 'SRC:ALN' or 'SRC;PTN' syntax, where 'SRC' is the source file path, ':ALN' is the line number and ';PTN' is the lazy matching pattern.
 'ARG' specifies the arguments of this probe point. You can use the name of local variable, or kprobe-tracer argument format (e.g. $retval, %ax, etc).
 
 LINE SYNTAX
@@ -76,6 +89,41 @@ and 'ALN2' is end line number in the file. It is also possible to specify how
 many lines to show by using 'NUM'.
 So, "source.c:100-120" shows lines between 100th to l20th in source.c file. And "func:10+20" shows 20 lines from 10th line of func function.
 
+LAZY MATCHING
+-------------
+ The lazy line matching is similar to glob matching but ignoring spaces in both of pattern and target. So this accepts wildcards('*', '?') and character classes(e.g. [a-z], [!A-Z]).
+
+e.g.
+ 'a=*' can matches 'a=b', 'a = b', 'a == b' and so on.
+
+This provides some sort of flexibility and robustness to probe point definitions against minor code changes. For example, actual 10th line of schedule() can be moved easily by modifying schedule(), but the same line matching 'rq=cpu_rq*' may still exist in the function.)
+
+
+EXAMPLES
+--------
+Display which lines in schedule() can be probed:
+
+ ./perf probe --line schedule
+
+Add a probe on schedule() function 12th line with recording cpu local variable:
+
+ ./perf probe schedule:12 cpu
+ or
+ ./perf probe --add='schedule:12 cpu'
+
+ this will add one or more probes which has the name start with "schedule".
+
+ Add probes on lines in schedule() function which calls update_rq_clock().
+
+ ./perf probe 'schedule;update_rq_clock*'
+ or
+ ./perf probe --add='schedule;update_rq_clock*'
+
+Delete all probes on schedule().
+
+ ./perf probe --del='schedule*'
+
+
 SEE ALSO
 --------
 linkperf:perf-trace[1], linkperf:perf-record[1]
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 54a5b50..2d53738 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -500,12 +500,12 @@ else
 	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel and glibc-dev[el]);
 endif
 
-ifneq ($(shell sh -c "(echo '\#ifndef _MIPS_SZLONG'; echo '\#define _MIPS_SZLONG 0'; echo '\#endif'; echo '\#include <dwarf.h>'; echo '\#include <libdwarf.h>'; echo 'int main(void) { Dwarf_Debug dbg; Dwarf_Error err; Dwarf_Ranges *rng; dwarf_init(0, DW_DLC_READ, 0, 0, &dbg, &err); dwarf_get_ranges(dbg, 0, &rng, 0, 0, &err); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -I/usr/include/libdwarf -ldwarf -lelf -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
-	msg := $(warning No libdwarf.h found or old libdwarf.h found, disables dwarf support. Please install libdwarf-dev/libdwarf-devel >= 20081231);
-	BASIC_CFLAGS += -DNO_LIBDWARF
+ifneq ($(shell sh -c "(echo '\#include <dwarf.h>'; echo '\#include <libdw.h>'; echo 'int main(void) { Dwarf *dbg; dbg = dwarf_begin(0, DWARF_C_READ); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -I/usr/include/elfutils -ldw -lelf -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
+	msg := $(warning No libdw.h found or old libdw.h found, disables dwarf support. Please install elfutils-devel/elfutils-dev);
+	BASIC_CFLAGS += -DNO_DWARF_SUPPORT
 else
-	BASIC_CFLAGS += -I/usr/include/libdwarf
-	EXTLIBS += -lelf -ldwarf
+	BASIC_CFLAGS += -I/usr/include/elfutils
+	EXTLIBS += -lelf -ldw
 	LIB_OBJS += util/probe-finder.o
 endif
 
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index ad47bd4..e3dfd0d 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -128,7 +128,7 @@ static void evaluate_probe_point(struct probe_point *pp)
 		    pp->function);
 }
 
-#ifndef NO_LIBDWARF
+#ifndef NO_DWARF_SUPPORT
 static int open_vmlinux(void)
 {
 	if (map__load(session.kmaps[MAP__FUNCTION], NULL) < 0) {
@@ -156,14 +156,16 @@ static const char * const probe_usage[] = {
 	"perf probe [<options>] --add 'PROBEDEF' [--add 'PROBEDEF' ...]",
 	"perf probe [<options>] --del '[GROUP:]EVENT' ...",
 	"perf probe --list",
+#ifndef NO_DWARF_SUPPORT
 	"perf probe --line 'LINEDESC'",
+#endif
 	NULL
 };
 
 static const struct option options[] = {
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show parsed arguments, etc)"),
-#ifndef NO_LIBDWARF
+#ifndef NO_DWARF_SUPPORT
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
 		   "file", "vmlinux pathname"),
 #endif
@@ -172,30 +174,32 @@ static const struct option options[] = {
 	OPT_CALLBACK('d', "del", NULL, "[GROUP:]EVENT", "delete a probe event.",
 		opt_del_probe_event),
 	OPT_CALLBACK('a', "add", NULL,
-#ifdef NO_LIBDWARF
-		"[EVENT=]FUNC[+OFFS|%return] [ARG ...]",
+#ifdef NO_DWARF_SUPPORT
+		"[EVENT=]FUNC[+OFF|%return] [ARG ...]",
 #else
-		"[EVENT=]FUNC[+OFFS|%return|:RLN][@SRC]|SRC:ALN [ARG ...]",
+		"[EVENT=]FUNC[+OFF|%return|:RL|;PT][@SRC]|SRC:AL|SRC;PT"
+		" [ARG ...]",
 #endif
 		"probe point definition, where\n"
 		"\t\tGROUP:\tGroup name (optional)\n"
 		"\t\tEVENT:\tEvent name\n"
 		"\t\tFUNC:\tFunction name\n"
-		"\t\tOFFS:\tOffset from function entry (in byte)\n"
+		"\t\tOFF:\tOffset from function entry (in byte)\n"
 		"\t\t%return:\tPut the probe at function return\n"
-#ifdef NO_LIBDWARF
+#ifdef NO_DWARF_SUPPORT
 		"\t\tARG:\tProbe argument (only \n"
 #else
 		"\t\tSRC:\tSource code path\n"
-		"\t\tRLN:\tRelative line number from function entry.\n"
-		"\t\tALN:\tAbsolute line number in file.\n"
+		"\t\tRL:\tRelative line number from function entry.\n"
+		"\t\tAL:\tAbsolute line number in file.\n"
+		"\t\tPT:\tLazy expression of line code.\n"
 		"\t\tARG:\tProbe argument (local variable name or\n"
 #endif
 		"\t\t\tkprobe-tracer argument format.)\n",
 		opt_add_probe_event),
 	OPT_BOOLEAN('f', "force", &session.force_add, "forcibly add events"
 		    " with existing name"),
-#ifndef NO_LIBDWARF
+#ifndef NO_DWARF_SUPPORT
 	OPT_CALLBACK('L', "line", NULL,
 		     "FUNC[:RLN[+NUM|:RLN2]]|SRC:ALN[+NUM|:ALN2]",
 		     "Show source code lines.", opt_show_lines),
@@ -223,7 +227,7 @@ static void init_vmlinux(void)
 int cmd_probe(int argc, const char **argv, const char *prefix __used)
 {
 	int i, ret;
-#ifndef NO_LIBDWARF
+#ifndef NO_DWARF_SUPPORT
 	int fd;
 #endif
 	struct probe_point *pp;
@@ -259,7 +263,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 		return 0;
 	}
 
-#ifndef NO_LIBDWARF
+#ifndef NO_DWARF_SUPPORT
 	if (session.show_lines) {
 		if (session.nr_probe != 0 || session.dellist) {
 			pr_warning("  Error: Don't use --line with"
@@ -290,9 +294,9 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 	init_vmlinux();
 
 	if (session.need_dwarf)
-#ifdef NO_LIBDWARF
+#ifdef NO_DWARF_SUPPORT
 		die("Debuginfo-analysis is not supported");
-#else	/* !NO_LIBDWARF */
+#else	/* !NO_DWARF_SUPPORT */
 		pr_debug("Some probes require debuginfo.\n");
 
 	fd = open_vmlinux();
@@ -312,7 +316,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 			continue;
 
 		lseek(fd, SEEK_SET, 0);
-		ret = find_probepoint(fd, pp);
+		ret = find_probe_point(fd, pp);
 		if (ret > 0)
 			continue;
 		if (ret == 0) {	/* No error but failed to find probe point. */
@@ -333,7 +337,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 	close(fd);
 
 end_dwarf:
-#endif /* !NO_LIBDWARF */
+#endif /* !NO_DWARF_SUPPORT */
 
 	/* Synthesize probes without dwarf */
 	for (i = 0; i < session.nr_probe; i++) {
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 71b0dd5..fa156f0 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -119,14 +119,14 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 	char c, nc = 0;
 	/*
 	 * <Syntax>
-	 * perf probe [EVENT=]SRC:LN
-	 * perf probe [EVENT=]FUNC[+OFFS|%return][@SRC]
+	 * perf probe [EVENT=]SRC[:LN|;PTN]
+	 * perf probe [EVENT=]FUNC[@SRC][+OFFS|%return|:LN|;PAT]
 	 *
 	 * TODO:Group name support
 	 */
 
-	ptr = strchr(arg, '=');
-	if (ptr) {	/* Event name */
+	ptr = strpbrk(arg, ";=@+%");
+	if (ptr && *ptr == '=') {	/* Event name */
 		*ptr = '\0';
 		tmp = ptr + 1;
 		ptr = strchr(arg, ':');
@@ -139,7 +139,7 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 		arg = tmp;
 	}
 
-	ptr = strpbrk(arg, ":+@%");
+	ptr = strpbrk(arg, ";:+@%");
 	if (ptr) {
 		nc = *ptr;
 		*ptr++ = '\0';
@@ -156,7 +156,11 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 	while (ptr) {
 		arg = ptr;
 		c = nc;
-		ptr = strpbrk(arg, ":+@%");
+		if (c == ';') {	/* Lazy pattern must be the last part */
+			pp->lazy_line = strdup(arg);
+			break;
+		}
+		ptr = strpbrk(arg, ";:+@%");
 		if (ptr) {
 			nc = *ptr;
 			*ptr++ = '\0';
@@ -165,13 +169,13 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 		case ':':	/* Line number */
 			pp->line = strtoul(arg, &tmp, 0);
 			if (*tmp != '\0')
-				semantic_error("There is non-digit charactor"
-						" in line number.");
+				semantic_error("There is non-digit char"
+					       " in line number.");
 			break;
 		case '+':	/* Byte offset from a symbol */
 			pp->offset = strtoul(arg, &tmp, 0);
 			if (*tmp != '\0')
-				semantic_error("There is non-digit charactor"
+				semantic_error("There is non-digit character"
 						" in offset.");
 			break;
 		case '@':	/* File name */
@@ -179,9 +183,6 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 				semantic_error("SRC@SRC is not allowed.");
 			pp->file = strdup(arg);
 			DIE_IF(pp->file == NULL);
-			if (ptr)
-				semantic_error("@SRC must be the last "
-					       "option.");
 			break;
 		case '%':	/* Probe places */
 			if (strcmp(arg, "return") == 0) {
@@ -196,11 +197,18 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 	}
 
 	/* Exclusion check */
+	if (pp->lazy_line && pp->line)
+		semantic_error("Lazy pattern can't be used with line number.");
+
+	if (pp->lazy_line && pp->offset)
+		semantic_error("Lazy pattern can't be used with offset.");
+
 	if (pp->line && pp->offset)
 		semantic_error("Offset can't be used with line number.");
 
-	if (!pp->line && pp->file && !pp->function)
-		semantic_error("File always requires line number.");
+	if (!pp->line && !pp->lazy_line && pp->file && !pp->function)
+		semantic_error("File always requires line number or "
+			       "lazy pattern.");
 
 	if (pp->offset && !pp->function)
 		semantic_error("Offset requires an entry function.");
@@ -208,11 +216,13 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 	if (pp->retprobe && !pp->function)
 		semantic_error("Return probe requires an entry function.");
 
-	if ((pp->offset || pp->line) && pp->retprobe)
-		semantic_error("Offset/Line can't be used with return probe.");
+	if ((pp->offset || pp->line || pp->lazy_line) && pp->retprobe)
+		semantic_error("Offset/Line/Lazy pattern can't be used with "
+			       "return probe.");
 
-	pr_debug("symbol:%s file:%s line:%d offset:%d, return:%d\n",
-		 pp->function, pp->file, pp->line, pp->offset, pp->retprobe);
+	pr_debug("symbol:%s file:%s line:%d offset:%d return:%d lazy:%s\n",
+		 pp->function, pp->file, pp->line, pp->offset, pp->retprobe,
+		 pp->lazy_line);
 }
 
 /* Parse perf-probe event definition */
@@ -456,6 +466,8 @@ static void clear_probe_point(struct probe_point *pp)
 		free(pp->function);
 	if (pp->file)
 		free(pp->file);
+	if (pp->lazy_line)
+		free(pp->lazy_line);
 	for (i = 0; i < pp->nr_args; i++)
 		free(pp->args[i]);
 	if (pp->args)
@@ -716,6 +728,7 @@ void del_trace_kprobe_events(struct strlist *dellist)
 }
 
 #define LINEBUF_SIZE 256
+#define NR_ADDITIONAL_LINES 2
 
 static void show_one_line(FILE *fp, unsigned int l, bool skip, bool show_num)
 {
@@ -776,5 +789,11 @@ void show_line_range(struct line_range *lr)
 			show_one_line(fp, (l++) - lr->offset, false, false);
 		show_one_line(fp, (l++) - lr->offset, false, true);
 	}
+
+	if (lr->end == INT_MAX)
+		lr->end = l + NR_ADDITIONAL_LINES;
+	while (l < lr->end && !feof(fp))
+		show_one_line(fp, (l++) - lr->offset, false, false);
+
 	fclose(fp);
 }
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 1b2124d..e77dc88 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -32,21 +32,13 @@
 #include <stdarg.h>
 #include <ctype.h>
 
+#include "string.h"
 #include "event.h"
 #include "debug.h"
 #include "util.h"
 #include "probe-finder.h"
 
 
-/* Dwarf_Die Linkage to parent Die */
-struct die_link {
-	struct die_link *parent;	/* Parent die */
-	Dwarf_Die die;			/* Current die */
-};
-
-static Dwarf_Debug __dw_debug;
-static Dwarf_Error __dw_error;
-
 /*
  * Generic dwarf analysis helpers
  */
@@ -113,281 +105,190 @@ static int strtailcmp(const char *s1, const char *s2)
 	return 0;
 }
 
-/* Find the fileno of the target file. */
-static Dwarf_Unsigned cu_find_fileno(Dwarf_Die cu_die, const char *fname)
-{
-	Dwarf_Signed cnt, i;
-	Dwarf_Unsigned found = 0;
-	char **srcs;
-	int ret;
+/* Line number list operations */
 
-	if (!fname)
-		return 0;
+/* Add a line to line number list */
+static void line_list__add_line(struct list_head *head, unsigned int line)
+{
+	struct line_node *ln;
+	struct list_head *p;
 
-	ret = dwarf_srcfiles(cu_die, &srcs, &cnt, &__dw_error);
-	if (ret == DW_DLV_OK) {
-		for (i = 0; i < cnt && !found; i++) {
-			if (strtailcmp(srcs[i], fname) == 0)
-				found = i + 1;
-			dwarf_dealloc(__dw_debug, srcs[i], DW_DLA_STRING);
-		}
-		for (; i < cnt; i++)
-			dwarf_dealloc(__dw_debug, srcs[i], DW_DLA_STRING);
-		dwarf_dealloc(__dw_debug, srcs, DW_DLA_LIST);
+	/* Reverse search, because new line will be the last one */
+	list_for_each_entry_reverse(ln, head, list) {
+		if (ln->line < line) {
+			p = &ln->list;
+			goto found;
+		} else if (ln->line == line)	/* Already exist */
+			return ;
 	}
-	if (found)
-		pr_debug("found fno: %d\n", (int)found);
-	return found;
+	/* List is empty, or the smallest entry */
+	p = head;
+found:
+	pr_debug("line list: add a line %u\n", line);
+	ln = zalloc(sizeof(struct line_node));
+	DIE_IF(ln == NULL);
+	ln->line = line;
+	INIT_LIST_HEAD(&ln->list);
+	list_add(&ln->list, p);
 }
 
-static int cu_get_filename(Dwarf_Die cu_die, Dwarf_Unsigned fno, char **buf)
+/* Check if the line in line number list */
+static int line_list__has_line(struct list_head *head, unsigned int line)
 {
-	Dwarf_Signed cnt, i;
-	char **srcs;
-	int ret = 0;
-
-	if (!buf || !fno)
-		return -EINVAL;
-
-	ret = dwarf_srcfiles(cu_die, &srcs, &cnt, &__dw_error);
-	if (ret == DW_DLV_OK) {
-		if ((Dwarf_Unsigned)cnt > fno - 1) {
-			*buf = strdup(srcs[fno - 1]);
-			ret = 0;
-			pr_debug("found filename: %s\n", *buf);
-		} else
-			ret = -ENOENT;
-		for (i = 0; i < cnt; i++)
-			dwarf_dealloc(__dw_debug, srcs[i], DW_DLA_STRING);
-		dwarf_dealloc(__dw_debug, srcs, DW_DLA_LIST);
-	} else
-		ret = -EINVAL;
-	return ret;
+	struct line_node *ln;
+
+	/* Reverse search, because new line will be the last one */
+	list_for_each_entry(ln, head, list)
+		if (ln->line == line)
+			return 1;
+
+	return 0;
 }
 
-/* Compare diename and tname */
-static int die_compare_name(Dwarf_Die dw_die, const char *tname)
+/* Init line number list */
+static void line_list__init(struct list_head *head)
 {
-	char *name;
-	int ret;
-	ret = dwarf_diename(dw_die, &name, &__dw_error);
-	DIE_IF(ret == DW_DLV_ERROR);
-	if (ret == DW_DLV_OK) {
-		ret = strcmp(tname, name);
-		dwarf_dealloc(__dw_debug, name, DW_DLA_STRING);
-	} else
-		ret = -1;
-	return ret;
+	INIT_LIST_HEAD(head);
 }
 
-/* Check the address is in the subprogram(function). */
-static int die_within_subprogram(Dwarf_Die sp_die, Dwarf_Addr addr,
-				 Dwarf_Signed *offs)
+/* Free line number list */
+static void line_list__free(struct list_head *head)
 {
-	Dwarf_Addr lopc, hipc;
-	int ret;
-
-	/* TODO: check ranges */
-	ret = dwarf_lowpc(sp_die, &lopc, &__dw_error);
-	DIE_IF(ret == DW_DLV_ERROR);
-	if (ret == DW_DLV_NO_ENTRY)
-		return 0;
-	ret = dwarf_highpc(sp_die, &hipc, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
-	if (lopc <= addr && addr < hipc) {
-		*offs = addr - lopc;
-		return 1;
-	} else
-		return 0;
+	struct line_node *ln;
+	while (!list_empty(head)) {
+		ln = list_first_entry(head, struct line_node, list);
+		list_del(&ln->list);
+		free(ln);
+	}
 }
 
-/* Check the die is inlined function */
-static Dwarf_Bool die_inlined_subprogram(Dwarf_Die dw_die)
+/* Dwarf wrappers */
+
+/* Find the realpath of the target file. */
+static const char *cu_find_realpath(Dwarf_Die *cu_die, const char *fname)
 {
-	/* TODO: check strictly */
-	Dwarf_Bool inl;
+	Dwarf_Files *files;
+	size_t nfiles, i;
+	const char *src;
 	int ret;
 
-	ret = dwarf_hasattr(dw_die, DW_AT_inline, &inl, &__dw_error);
-	DIE_IF(ret == DW_DLV_ERROR);
-	return inl;
-}
+	if (!fname)
+		return NULL;
 
-/* Get the offset of abstruct_origin */
-static Dwarf_Off die_get_abstract_origin(Dwarf_Die dw_die)
-{
-	Dwarf_Attribute attr;
-	Dwarf_Off cu_offs;
-	int ret;
+	ret = dwarf_getsrcfiles(cu_die, &files, &nfiles);
+	if (ret != 0)
+		return NULL;
 
-	ret = dwarf_attr(dw_die, DW_AT_abstract_origin, &attr, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
-	ret = dwarf_formref(attr, &cu_offs, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
-	dwarf_dealloc(__dw_debug, attr, DW_DLA_ATTR);
-	return cu_offs;
+	for (i = 0; i < nfiles; i++) {
+		src = dwarf_filesrc(files, i, NULL, NULL);
+		if (strtailcmp(src, fname) == 0)
+			break;
+	}
+	return src;
 }
 
-/* Get entry pc(or low pc, 1st entry of ranges)  of the die */
-static Dwarf_Addr die_get_entrypc(Dwarf_Die dw_die)
+struct __addr_die_search_param {
+	Dwarf_Addr	addr;
+	Dwarf_Die	*die_mem;
+};
+
+static int __die_search_func_cb(Dwarf_Die *fn_die, void *data)
 {
-	Dwarf_Attribute attr;
-	Dwarf_Addr addr;
-	Dwarf_Off offs;
-	Dwarf_Ranges *ranges;
-	Dwarf_Signed cnt;
-	int ret;
+	struct __addr_die_search_param *ad = data;
 
-	/* Try to get entry pc */
-	ret = dwarf_attr(dw_die, DW_AT_entry_pc, &attr, &__dw_error);
-	DIE_IF(ret == DW_DLV_ERROR);
-	if (ret == DW_DLV_OK) {
-		ret = dwarf_formaddr(attr, &addr, &__dw_error);
-		DIE_IF(ret != DW_DLV_OK);
-		dwarf_dealloc(__dw_debug, attr, DW_DLA_ATTR);
-		return addr;
+	if (dwarf_tag(fn_die) == DW_TAG_subprogram &&
+	    dwarf_haspc(fn_die, ad->addr)) {
+		memcpy(ad->die_mem, fn_die, sizeof(Dwarf_Die));
+		return DWARF_CB_ABORT;
 	}
+	return DWARF_CB_OK;
+}
 
-	/* Try to get low pc */
-	ret = dwarf_lowpc(dw_die, &addr, &__dw_error);
-	DIE_IF(ret == DW_DLV_ERROR);
-	if (ret == DW_DLV_OK)
-		return addr;
-
-	/* Try to get ranges */
-	ret = dwarf_attr(dw_die, DW_AT_ranges, &attr, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
-	ret = dwarf_formref(attr, &offs, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
-	ret = dwarf_get_ranges(__dw_debug, offs, &ranges, &cnt, NULL,
-				&__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
-	addr = ranges[0].dwr_addr1;
-	dwarf_ranges_dealloc(__dw_debug, ranges, cnt);
-	return addr;
+/* Search a real subprogram including this line, */
+static Dwarf_Die *die_get_real_subprogram(Dwarf_Die *cu_die, Dwarf_Addr addr,
+					  Dwarf_Die *die_mem)
+{
+	struct __addr_die_search_param ad;
+	ad.addr = addr;
+	ad.die_mem = die_mem;
+	/* dwarf_getscopes can't find subprogram. */
+	if (!dwarf_getfuncs(cu_die, __die_search_func_cb, &ad, 0))
+		return NULL;
+	else
+		return die_mem;
 }
 
-/*
- * Search a Die from Die tree.
- * Note: cur_link->die should be deallocated in this function.
- */
-static int __search_die_tree(struct die_link *cur_link,
-			     int (*die_cb)(struct die_link *, void *),
-			     void *data)
+/* Similar to dwarf_getfuncs, but returns inlined_subroutine if exists. */
+static Dwarf_Die *die_get_inlinefunc(Dwarf_Die *sp_die, Dwarf_Addr addr,
+				     Dwarf_Die *die_mem)
 {
-	Dwarf_Die new_die;
-	struct die_link new_link;
+	Dwarf_Die child_die;
 	int ret;
 
-	if (!die_cb)
-		return 0;
-
-	/* Check current die */
-	while (!(ret = die_cb(cur_link, data))) {
-		/* Check child die */
-		ret = dwarf_child(cur_link->die, &new_die, &__dw_error);
-		DIE_IF(ret == DW_DLV_ERROR);
-		if (ret == DW_DLV_OK) {
-			new_link.parent = cur_link;
-			new_link.die = new_die;
-			ret = __search_die_tree(&new_link, die_cb, data);
-			if (ret)
-				break;
-		}
+	ret = dwarf_child(sp_die, die_mem);
+	if (ret != 0)
+		return NULL;
 
-		/* Move to next sibling */
-		ret = dwarf_siblingof(__dw_debug, cur_link->die, &new_die,
-				      &__dw_error);
-		DIE_IF(ret == DW_DLV_ERROR);
-		dwarf_dealloc(__dw_debug, cur_link->die, DW_DLA_DIE);
-		cur_link->die = new_die;
-		if (ret == DW_DLV_NO_ENTRY)
-			return 0;
-	}
-	dwarf_dealloc(__dw_debug, cur_link->die, DW_DLA_DIE);
-	return ret;
-}
+	do {
+		if (dwarf_tag(die_mem) == DW_TAG_inlined_subroutine &&
+		    dwarf_haspc(die_mem, addr))
+			return die_mem;
 
-/* Search a die in its children's die tree */
-static int search_die_from_children(Dwarf_Die parent_die,
-				    int (*die_cb)(struct die_link *, void *),
-				    void *data)
-{
-	struct die_link new_link;
-	int ret;
+		if (die_get_inlinefunc(die_mem, addr, &child_die)) {
+			memcpy(die_mem, &child_die, sizeof(Dwarf_Die));
+			return die_mem;
+		}
+	} while (dwarf_siblingof(die_mem, die_mem) == 0);
 
-	new_link.parent = NULL;
-	ret = dwarf_child(parent_die, &new_link.die, &__dw_error);
-	DIE_IF(ret == DW_DLV_ERROR);
-	if (ret == DW_DLV_OK)
-		return __search_die_tree(&new_link, die_cb, data);
-	else
-		return 0;
+	return NULL;
 }
 
-/* Find a locdesc corresponding to the address */
-static int attr_get_locdesc(Dwarf_Attribute attr, Dwarf_Locdesc *desc,
-			    Dwarf_Addr addr)
+/* Compare diename and tname */
+static bool die_compare_name(Dwarf_Die *dw_die, const char *tname)
 {
-	Dwarf_Signed lcnt;
-	Dwarf_Locdesc **llbuf;
-	int ret, i;
-
-	ret = dwarf_loclist_n(attr, &llbuf, &lcnt, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
-	ret = DW_DLV_NO_ENTRY;
-	for (i = 0; i < lcnt; ++i) {
-		if (llbuf[i]->ld_lopc <= addr &&
-		    llbuf[i]->ld_hipc > addr) {
-			memcpy(desc, llbuf[i], sizeof(Dwarf_Locdesc));
-			desc->ld_s =
-				malloc(sizeof(Dwarf_Loc) * llbuf[i]->ld_cents);
-			DIE_IF(desc->ld_s == NULL);
-			memcpy(desc->ld_s, llbuf[i]->ld_s,
-				sizeof(Dwarf_Loc) * llbuf[i]->ld_cents);
-			ret = DW_DLV_OK;
-			break;
-		}
-		dwarf_dealloc(__dw_debug, llbuf[i]->ld_s, DW_DLA_LOC_BLOCK);
-		dwarf_dealloc(__dw_debug, llbuf[i], DW_DLA_LOCDESC);
-	}
-	/* Releasing loop */
-	for (; i < lcnt; ++i) {
-		dwarf_dealloc(__dw_debug, llbuf[i]->ld_s, DW_DLA_LOC_BLOCK);
-		dwarf_dealloc(__dw_debug, llbuf[i], DW_DLA_LOCDESC);
-	}
-	dwarf_dealloc(__dw_debug, llbuf, DW_DLA_LIST);
-	return ret;
+	const char *name;
+	name = dwarf_diename(dw_die);
+	DIE_IF(name == NULL);
+	return strcmp(tname, name);
 }
 
-/* Get decl_file attribute value (file number) */
-static Dwarf_Unsigned die_get_decl_file(Dwarf_Die sp_die)
+/* Get entry pc(or low pc, 1st entry of ranges)  of the die */
+static Dwarf_Addr die_get_entrypc(Dwarf_Die *dw_die)
 {
-	Dwarf_Attribute attr;
-	Dwarf_Unsigned fno;
+	Dwarf_Addr epc;
 	int ret;
 
-	ret = dwarf_attr(sp_die, DW_AT_decl_file, &attr, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
-	dwarf_formudata(attr, &fno, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
-	dwarf_dealloc(__dw_debug, attr, DW_DLA_ATTR);
-	return fno;
+	ret = dwarf_entrypc(dw_die, &epc);
+	DIE_IF(ret == -1);
+	return epc;
 }
 
-/* Get decl_line attribute value (line number) */
-static Dwarf_Unsigned die_get_decl_line(Dwarf_Die sp_die)
+/* Get a variable die */
+static Dwarf_Die *die_find_variable(Dwarf_Die *sp_die, const char *name,
+				    Dwarf_Die *die_mem)
 {
-	Dwarf_Attribute attr;
-	Dwarf_Unsigned lno;
+	Dwarf_Die child_die;
+	int tag;
 	int ret;
 
-	ret = dwarf_attr(sp_die, DW_AT_decl_line, &attr, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
-	dwarf_formudata(attr, &lno, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
-	dwarf_dealloc(__dw_debug, attr, DW_DLA_ATTR);
-	return lno;
+	ret = dwarf_child(sp_die, die_mem);
+	if (ret != 0)
+		return NULL;
+
+	do {
+		tag = dwarf_tag(die_mem);
+		if ((tag == DW_TAG_formal_parameter ||
+		     tag == DW_TAG_variable) &&
+		    (die_compare_name(die_mem, name) == 0))
+			return die_mem;
+
+		if (die_find_variable(die_mem, name, &child_die)) {
+			memcpy(die_mem, &child_die, sizeof(Dwarf_Die));
+			return die_mem;
+		}
+	} while (dwarf_siblingof(die_mem, die_mem) == 0);
+
+	return NULL;
 }
 
 /*
@@ -395,47 +296,45 @@ static Dwarf_Unsigned die_get_decl_line(Dwarf_Die sp_die)
  */
 
 /* Show a location */
-static void show_location(Dwarf_Loc *loc, struct probe_finder *pf)
+static void show_location(Dwarf_Op *op, struct probe_finder *pf)
 {
-	Dwarf_Small op;
-	Dwarf_Unsigned regn;
-	Dwarf_Signed offs;
+	unsigned int regn;
+	Dwarf_Word offs = 0;
 	int deref = 0, ret;
 	const char *regs;
 
-	op = loc->lr_atom;
-
+	/* TODO: support CFA */
 	/* If this is based on frame buffer, set the offset */
-	if (op == DW_OP_fbreg) {
+	if (op->atom == DW_OP_fbreg) {
+		if (pf->fb_ops == NULL)
+			die("The attribute of frame base is not supported.\n");
 		deref = 1;
-		offs = (Dwarf_Signed)loc->lr_number;
-		op = pf->fbloc.ld_s[0].lr_atom;
-		loc = &pf->fbloc.ld_s[0];
-	} else
-		offs = 0;
+		offs = op->number;
+		op = &pf->fb_ops[0];
+	}
 
-	if (op >= DW_OP_breg0 && op <= DW_OP_breg31) {
-		regn = op - DW_OP_breg0;
-		offs += (Dwarf_Signed)loc->lr_number;
+	if (op->atom >= DW_OP_breg0 && op->atom <= DW_OP_breg31) {
+		regn = op->atom - DW_OP_breg0;
+		offs += op->number;
 		deref = 1;
-	} else if (op >= DW_OP_reg0 && op <= DW_OP_reg31) {
-		regn = op - DW_OP_reg0;
-	} else if (op == DW_OP_bregx) {
-		regn = loc->lr_number;
-		offs += (Dwarf_Signed)loc->lr_number2;
+	} else if (op->atom >= DW_OP_reg0 && op->atom <= DW_OP_reg31) {
+		regn = op->atom - DW_OP_reg0;
+	} else if (op->atom == DW_OP_bregx) {
+		regn = op->number;
+		offs += op->number2;
 		deref = 1;
-	} else if (op == DW_OP_regx) {
-		regn = loc->lr_number;
+	} else if (op->atom == DW_OP_regx) {
+		regn = op->number;
 	} else
-		die("Dwarf_OP %d is not supported.", op);
+		die("DW_OP %d is not supported.", op->atom);
 
 	regs = get_arch_regstr(regn);
 	if (!regs)
-		die("%lld exceeds max register number.", regn);
+		die("%u exceeds max register number.", regn);
 
 	if (deref)
-		ret = snprintf(pf->buf, pf->len,
-				 " %s=%+lld(%s)", pf->var, offs, regs);
+		ret = snprintf(pf->buf, pf->len, " %s=+%ju(%s)",
+			       pf->var, (uintmax_t)offs, regs);
 	else
 		ret = snprintf(pf->buf, pf->len, " %s=%s", pf->var, regs);
 	DIE_IF(ret < 0);
@@ -443,52 +342,37 @@ static void show_location(Dwarf_Loc *loc, struct probe_finder *pf)
 }
 
 /* Show a variables in kprobe event format */
-static void show_variable(Dwarf_Die vr_die, struct probe_finder *pf)
+static void show_variable(Dwarf_Die *vr_die, struct probe_finder *pf)
 {
 	Dwarf_Attribute attr;
-	Dwarf_Locdesc ld;
+	Dwarf_Op *expr;
+	size_t nexpr;
 	int ret;
 
-	ret = dwarf_attr(vr_die, DW_AT_location, &attr, &__dw_error);
-	if (ret != DW_DLV_OK)
+	if (dwarf_attr(vr_die, DW_AT_location, &attr) == NULL)
 		goto error;
-	ret = attr_get_locdesc(attr, &ld, (pf->addr - pf->cu_base));
-	if (ret != DW_DLV_OK)
+	/* TODO: handle more than 1 exprs */
+	ret = dwarf_getlocation_addr(&attr, (pf->addr - pf->cu_base),
+				     &expr, &nexpr, 1);
+	if (ret <= 0 || nexpr == 0)
 		goto error;
-	/* TODO? */
-	DIE_IF(ld.ld_cents != 1);
-	show_location(&ld.ld_s[0], pf);
-	free(ld.ld_s);
-	dwarf_dealloc(__dw_debug, attr, DW_DLA_ATTR);
+
+	show_location(expr, pf);
+	/* *expr will be cached in libdw. Don't free it. */
 	return ;
 error:
+	/* TODO: Support const_value */
 	die("Failed to find the location of %s at this address.\n"
 	    " Perhaps, it has been optimized out.", pf->var);
 }
 
-static int variable_callback(struct die_link *dlink, void *data)
-{
-	struct probe_finder *pf = (struct probe_finder *)data;
-	Dwarf_Half tag;
-	int ret;
-
-	ret = dwarf_tag(dlink->die, &tag, &__dw_error);
-	DIE_IF(ret == DW_DLV_ERROR);
-	if ((tag == DW_TAG_formal_parameter ||
-	     tag == DW_TAG_variable) &&
-	    (die_compare_name(dlink->die, pf->var) == 0)) {
-		show_variable(dlink->die, pf);
-		return 1;
-	}
-	/* TODO: Support struct members and arrays */
-	return 0;
-}
-
 /* Find a variable in a subprogram die */
-static void find_variable(Dwarf_Die sp_die, struct probe_finder *pf)
+static void find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 {
 	int ret;
+	Dwarf_Die vr_die;
 
+	/* TODO: Support struct members and arrays */
 	if (!is_c_varname(pf->var)) {
 		/* Output raw parameters */
 		ret = snprintf(pf->buf, pf->len, " %s", pf->var);
@@ -499,58 +383,51 @@ static void find_variable(Dwarf_Die sp_die, struct probe_finder *pf)
 
 	pr_debug("Searching '%s' variable in context.\n", pf->var);
 	/* Search child die for local variables and parameters. */
-	ret = search_die_from_children(sp_die, variable_callback, pf);
-	if (!ret)
+	if (!die_find_variable(sp_die, pf->var, &vr_die))
 		die("Failed to find '%s' in this function.", pf->var);
-}
-
-/* Get a frame base on the address */
-static void get_current_frame_base(Dwarf_Die sp_die, struct probe_finder *pf)
-{
-	Dwarf_Attribute attr;
-	int ret;
 
-	ret = dwarf_attr(sp_die, DW_AT_frame_base, &attr, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
-	ret = attr_get_locdesc(attr, &pf->fbloc, (pf->addr - pf->cu_base));
-	DIE_IF(ret != DW_DLV_OK);
-	dwarf_dealloc(__dw_debug, attr, DW_DLA_ATTR);
-}
-
-static void free_current_frame_base(struct probe_finder *pf)
-{
-	free(pf->fbloc.ld_s);
-	memset(&pf->fbloc, 0, sizeof(Dwarf_Locdesc));
+	show_variable(&vr_die, pf);
 }
 
 /* Show a probe point to output buffer */
-static void show_probepoint(Dwarf_Die sp_die, Dwarf_Signed offs,
-			    struct probe_finder *pf)
+static void show_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 {
 	struct probe_point *pp = pf->pp;
-	char *name;
+	Dwarf_Addr eaddr;
+	Dwarf_Die die_mem;
+	const char *name;
 	char tmp[MAX_PROBE_BUFFER];
 	int ret, i, len;
+	Dwarf_Attribute fb_attr;
+	size_t nops;
+
+	/* If no real subprogram, find a real one */
+	if (!sp_die || dwarf_tag(sp_die) != DW_TAG_subprogram) {
+		sp_die = die_get_real_subprogram(&pf->cu_die,
+						 pf->addr, &die_mem);
+		if (!sp_die)
+			die("Probe point is not found in subprograms.");
+	}
 
 	/* Output name of probe point */
-	ret = dwarf_diename(sp_die, &name, &__dw_error);
-	DIE_IF(ret == DW_DLV_ERROR);
-	if (ret == DW_DLV_OK) {
-		ret = snprintf(tmp, MAX_PROBE_BUFFER, "%s+%u", name,
-				(unsigned int)offs);
+	name = dwarf_diename(sp_die);
+	if (name) {
+		dwarf_entrypc(sp_die, &eaddr);
+		ret = snprintf(tmp, MAX_PROBE_BUFFER, "%s+%lu", name,
+				(unsigned long)(pf->addr - eaddr));
 		/* Copy the function name if possible */
 		if (!pp->function) {
 			pp->function = strdup(name);
-			pp->offset = offs;
+			pp->offset = (size_t)(pf->addr - eaddr);
 		}
-		dwarf_dealloc(__dw_debug, name, DW_DLA_STRING);
 	} else {
 		/* This function has no name. */
-		ret = snprintf(tmp, MAX_PROBE_BUFFER, "0x%llx", pf->addr);
+		ret = snprintf(tmp, MAX_PROBE_BUFFER, "0x%jx",
+			       (uintmax_t)pf->addr);
 		if (!pp->function) {
 			/* TODO: Use _stext */
 			pp->function = strdup("");
-			pp->offset = (int)pf->addr;
+			pp->offset = (size_t)pf->addr;
 		}
 	}
 	DIE_IF(ret < 0);
@@ -558,8 +435,15 @@ static void show_probepoint(Dwarf_Die sp_die, Dwarf_Signed offs,
 	len = ret;
 	pr_debug("Probe point found: %s\n", tmp);
 
+	/* Get the frame base attribute/ops */
+	dwarf_attr(sp_die, DW_AT_frame_base, &fb_attr);
+	ret = dwarf_getlocation_addr(&fb_attr, (pf->addr - pf->cu_base),
+				     &pf->fb_ops, &nops, 1);
+	if (ret <= 0 || nops == 0)
+		pf->fb_ops = NULL;
+
 	/* Find each argument */
-	get_current_frame_base(sp_die, pf);
+	/* TODO: use dwarf_cfi_addrframe */
 	for (i = 0; i < pp->nr_args; i++) {
 		pf->var = pp->args[i];
 		pf->buf = &tmp[len];
@@ -567,289 +451,327 @@ static void show_probepoint(Dwarf_Die sp_die, Dwarf_Signed offs,
 		find_variable(sp_die, pf);
 		len += strlen(pf->buf);
 	}
-	free_current_frame_base(pf);
+
+	/* *pf->fb_ops will be cached in libdw. Don't free it. */
+	pf->fb_ops = NULL;
 
 	pp->probes[pp->found] = strdup(tmp);
 	pp->found++;
 }
 
-static int probeaddr_callback(struct die_link *dlink, void *data)
+/* Find probe point from its line number */
+static void find_probe_point_by_line(struct probe_finder *pf)
 {
-	struct probe_finder *pf = (struct probe_finder *)data;
-	Dwarf_Half tag;
-	Dwarf_Signed offs;
+	Dwarf_Lines *lines;
+	Dwarf_Line *line;
+	size_t nlines, i;
+	Dwarf_Addr addr;
+	int lineno;
 	int ret;
 
-	ret = dwarf_tag(dlink->die, &tag, &__dw_error);
-	DIE_IF(ret == DW_DLV_ERROR);
-	/* Check the address is in this subprogram */
-	if (tag == DW_TAG_subprogram &&
-	    die_within_subprogram(dlink->die, pf->addr, &offs)) {
-		show_probepoint(dlink->die, offs, pf);
-		return 1;
+	ret = dwarf_getsrclines(&pf->cu_die, &lines, &nlines);
+	DIE_IF(ret != 0);
+
+	for (i = 0; i < nlines; i++) {
+		line = dwarf_onesrcline(lines, i);
+		dwarf_lineno(line, &lineno);
+		if (lineno != pf->lno)
+			continue;
+
+		/* TODO: Get fileno from line, but how? */
+		if (strtailcmp(dwarf_linesrc(line, NULL, NULL), pf->fname) != 0)
+			continue;
+
+		ret = dwarf_lineaddr(line, &addr);
+		DIE_IF(ret != 0);
+		pr_debug("Probe line found: line[%d]:%d addr:0x%jx\n",
+			 (int)i, lineno, (uintmax_t)addr);
+		pf->addr = addr;
+
+		show_probe_point(NULL, pf);
+		/* Continuing, because target line might be inlined. */
 	}
-	return 0;
 }
 
-/* Find probe point from its line number */
-static void find_probe_point_by_line(struct probe_finder *pf)
+/* Find lines which match lazy pattern */
+static int find_lazy_match_lines(struct list_head *head,
+				 const char *fname, const char *pat)
 {
-	Dwarf_Signed cnt, i, clm;
-	Dwarf_Line *lines;
-	Dwarf_Unsigned lineno = 0;
+	char *fbuf, *p1, *p2;
+	int fd, line, nlines = 0;
+	struct stat st;
+
+	fd = open(fname, O_RDONLY);
+	if (fd < 0)
+		die("failed to open %s", fname);
+	DIE_IF(fstat(fd, &st) < 0);
+	fbuf = malloc(st.st_size + 2);
+	DIE_IF(fbuf == NULL);
+	DIE_IF(read(fd, fbuf, st.st_size) < 0);
+	close(fd);
+	fbuf[st.st_size] = '\n';	/* Dummy line */
+	fbuf[st.st_size + 1] = '\0';
+	p1 = fbuf;
+	line = 1;
+	while ((p2 = strchr(p1, '\n')) != NULL) {
+		*p2 = '\0';
+		if (strlazymatch(p1, pat)) {
+			line_list__add_line(head, line);
+			nlines++;
+		}
+		line++;
+		p1 = p2 + 1;
+	}
+	free(fbuf);
+	return nlines;
+}
+
+/* Find probe points from lazy pattern  */
+static void find_probe_point_lazy(Dwarf_Die *sp_die, struct probe_finder *pf)
+{
+	Dwarf_Lines *lines;
+	Dwarf_Line *line;
+	size_t nlines, i;
 	Dwarf_Addr addr;
-	Dwarf_Unsigned fno;
+	Dwarf_Die die_mem;
+	int lineno;
 	int ret;
 
-	ret = dwarf_srclines(pf->cu_die, &lines, &cnt, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
+	if (list_empty(&pf->lcache)) {
+		/* Matching lazy line pattern */
+		ret = find_lazy_match_lines(&pf->lcache, pf->fname,
+					    pf->pp->lazy_line);
+		if (ret <= 0)
+			die("No matched lines found in %s.", pf->fname);
+	}
+
+	ret = dwarf_getsrclines(&pf->cu_die, &lines, &nlines);
+	DIE_IF(ret != 0);
+	for (i = 0; i < nlines; i++) {
+		line = dwarf_onesrcline(lines, i);
 
-	for (i = 0; i < cnt; i++) {
-		ret = dwarf_line_srcfileno(lines[i], &fno, &__dw_error);
-		DIE_IF(ret != DW_DLV_OK);
-		if (fno != pf->fno)
+		dwarf_lineno(line, &lineno);
+		if (!line_list__has_line(&pf->lcache, lineno))
 			continue;
 
-		ret = dwarf_lineno(lines[i], &lineno, &__dw_error);
-		DIE_IF(ret != DW_DLV_OK);
-		if (lineno != pf->lno)
+		/* TODO: Get fileno from line, but how? */
+		if (strtailcmp(dwarf_linesrc(line, NULL, NULL), pf->fname) != 0)
 			continue;
 
-		ret = dwarf_lineoff(lines[i], &clm, &__dw_error);
-		DIE_IF(ret != DW_DLV_OK);
+		ret = dwarf_lineaddr(line, &addr);
+		DIE_IF(ret != 0);
+		if (sp_die) {
+			/* Address filtering 1: does sp_die include addr? */
+			if (!dwarf_haspc(sp_die, addr))
+				continue;
+			/* Address filtering 2: No child include addr? */
+			if (die_get_inlinefunc(sp_die, addr, &die_mem))
+				continue;
+		}
 
-		ret = dwarf_lineaddr(lines[i], &addr, &__dw_error);
-		DIE_IF(ret != DW_DLV_OK);
-		pr_debug("Probe line found: line[%d]:%u,%d addr:0x%llx\n",
-			 (int)i, (unsigned)lineno, (int)clm, addr);
+		pr_debug("Probe line found: line[%d]:%d addr:0x%llx\n",
+			 (int)i, lineno, (unsigned long long)addr);
 		pf->addr = addr;
-		/* Search a real subprogram including this line, */
-		ret = search_die_from_children(pf->cu_die,
-					       probeaddr_callback, pf);
-		if (ret == 0)
-			die("Probe point is not found in subprograms.");
+
+		show_probe_point(sp_die, pf);
 		/* Continuing, because target line might be inlined. */
 	}
-	dwarf_srclines_dealloc(__dw_debug, lines, cnt);
+	/* TODO: deallocate lines, but how? */
+}
+
+static int probe_point_inline_cb(Dwarf_Die *in_die, void *data)
+{
+	struct probe_finder *pf = (struct probe_finder *)data;
+	struct probe_point *pp = pf->pp;
+
+	if (pp->lazy_line)
+		find_probe_point_lazy(in_die, pf);
+	else {
+		/* Get probe address */
+		pf->addr = die_get_entrypc(in_die);
+		pf->addr += pp->offset;
+		pr_debug("found inline addr: 0x%jx\n",
+			 (uintmax_t)pf->addr);
+
+		show_probe_point(in_die, pf);
+	}
+
+	return DWARF_CB_OK;
 }
 
 /* Search function from function name */
-static int probefunc_callback(struct die_link *dlink, void *data)
+static int probe_point_search_cb(Dwarf_Die *sp_die, void *data)
 {
 	struct probe_finder *pf = (struct probe_finder *)data;
 	struct probe_point *pp = pf->pp;
-	struct die_link *lk;
-	Dwarf_Signed offs;
-	Dwarf_Half tag;
-	int ret;
 
-	ret = dwarf_tag(dlink->die, &tag, &__dw_error);
-	DIE_IF(ret == DW_DLV_ERROR);
-	if (tag == DW_TAG_subprogram) {
-		if (die_compare_name(dlink->die, pp->function) == 0) {
-			if (pp->line) {	/* Function relative line */
-				pf->fno = die_get_decl_file(dlink->die);
-				pf->lno = die_get_decl_line(dlink->die)
-					 + pp->line;
-				find_probe_point_by_line(pf);
-				return 1;
-			}
-			if (die_inlined_subprogram(dlink->die)) {
-				/* Inlined function, save it. */
-				ret = dwarf_die_CU_offset(dlink->die,
-							  &pf->inl_offs,
-							  &__dw_error);
-				DIE_IF(ret != DW_DLV_OK);
-				pr_debug("inline definition offset %lld\n",
-					 pf->inl_offs);
-				return 0;	/* Continue to search */
-			}
-			/* Get probe address */
-			pf->addr = die_get_entrypc(dlink->die);
+	/* Check tag and diename */
+	if (dwarf_tag(sp_die) != DW_TAG_subprogram ||
+	    die_compare_name(sp_die, pp->function) != 0)
+		return 0;
+
+	pf->fname = dwarf_decl_file(sp_die);
+	if (pp->line) { /* Function relative line */
+		dwarf_decl_line(sp_die, &pf->lno);
+		pf->lno += pp->line;
+		find_probe_point_by_line(pf);
+	} else if (!dwarf_func_inline(sp_die)) {
+		/* Real function */
+		if (pp->lazy_line)
+			find_probe_point_lazy(sp_die, pf);
+		else {
+			pf->addr = die_get_entrypc(sp_die);
 			pf->addr += pp->offset;
 			/* TODO: Check the address in this function */
-			show_probepoint(dlink->die, pp->offset, pf);
-			return 1; /* Exit; no same symbol in this CU. */
-		}
-	} else if (tag == DW_TAG_inlined_subroutine && pf->inl_offs) {
-		if (die_get_abstract_origin(dlink->die) == pf->inl_offs) {
-			/* Get probe address */
-			pf->addr = die_get_entrypc(dlink->die);
-			pf->addr += pp->offset;
-			pr_debug("found inline addr: 0x%llx\n", pf->addr);
-			/* Inlined function. Get a real subprogram */
-			for (lk = dlink->parent; lk != NULL; lk = lk->parent) {
-				tag = 0;
-				dwarf_tag(lk->die, &tag, &__dw_error);
-				DIE_IF(ret == DW_DLV_ERROR);
-				if (tag == DW_TAG_subprogram &&
-				    !die_inlined_subprogram(lk->die))
-					goto found;
-			}
-			die("Failed to find real subprogram.");
-found:
-			/* Get offset from subprogram */
-			ret = die_within_subprogram(lk->die, pf->addr, &offs);
-			DIE_IF(!ret);
-			show_probepoint(lk->die, offs, pf);
-			/* Continue to search */
+			show_probe_point(sp_die, pf);
 		}
-	}
-	return 0;
+	} else
+		/* Inlined function: search instances */
+		dwarf_func_inline_instances(sp_die, probe_point_inline_cb, pf);
+
+	return 1; /* Exit; no same symbol in this CU. */
 }
 
 static void find_probe_point_by_func(struct probe_finder *pf)
 {
-	search_die_from_children(pf->cu_die, probefunc_callback, pf);
+	dwarf_getfuncs(&pf->cu_die, probe_point_search_cb, pf, 0);
 }
 
 /* Find a probe point */
-int find_probepoint(int fd, struct probe_point *pp)
+int find_probe_point(int fd, struct probe_point *pp)
 {
-	Dwarf_Half addr_size = 0;
-	Dwarf_Unsigned next_cuh = 0;
-	int cu_number = 0, ret;
 	struct probe_finder pf = {.pp = pp};
+	int ret;
+	Dwarf_Off off, noff;
+	size_t cuhl;
+	Dwarf_Die *diep;
+	Dwarf *dbg;
 
-	ret = dwarf_init(fd, DW_DLC_READ, 0, 0, &__dw_debug, &__dw_error);
-	if (ret != DW_DLV_OK)
+	dbg = dwarf_begin(fd, DWARF_C_READ);
+	if (!dbg)
 		return -ENOENT;
 
 	pp->found = 0;
-	while (++cu_number) {
-		/* Search CU (Compilation Unit) */
-		ret = dwarf_next_cu_header(__dw_debug, NULL, NULL, NULL,
-			&addr_size, &next_cuh, &__dw_error);
-		DIE_IF(ret == DW_DLV_ERROR);
-		if (ret == DW_DLV_NO_ENTRY)
-			break;
-
+	off = 0;
+	line_list__init(&pf.lcache);
+	/* Loop on CUs (Compilation Unit) */
+	while (!dwarf_nextcu(dbg, off, &noff, &cuhl, NULL, NULL, NULL)) {
 		/* Get the DIE(Debugging Information Entry) of this CU */
-		ret = dwarf_siblingof(__dw_debug, 0, &pf.cu_die, &__dw_error);
-		DIE_IF(ret != DW_DLV_OK);
+		diep = dwarf_offdie(dbg, off + cuhl, &pf.cu_die);
+		if (!diep)
+			continue;
 
 		/* Check if target file is included. */
 		if (pp->file)
-			pf.fno = cu_find_fileno(pf.cu_die, pp->file);
+			pf.fname = cu_find_realpath(&pf.cu_die, pp->file);
+		else
+			pf.fname = NULL;
 
-		if (!pp->file || pf.fno) {
+		if (!pp->file || pf.fname) {
 			/* Save CU base address (for frame_base) */
-			ret = dwarf_lowpc(pf.cu_die, &pf.cu_base, &__dw_error);
-			DIE_IF(ret == DW_DLV_ERROR);
-			if (ret == DW_DLV_NO_ENTRY)
+			ret = dwarf_lowpc(&pf.cu_die, &pf.cu_base);
+			if (ret != 0)
 				pf.cu_base = 0;
 			if (pp->function)
 				find_probe_point_by_func(&pf);
+			else if (pp->lazy_line)
+				find_probe_point_lazy(NULL, &pf);
 			else {
 				pf.lno = pp->line;
 				find_probe_point_by_line(&pf);
 			}
 		}
-		dwarf_dealloc(__dw_debug, pf.cu_die, DW_DLA_DIE);
+		off = noff;
 	}
-	ret = dwarf_finish(__dw_debug, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
+	line_list__free(&pf.lcache);
+	dwarf_end(dbg);
 
 	return pp->found;
 }
 
-
-static void line_range_add_line(struct line_range *lr, unsigned int line)
-{
-	struct line_node *ln;
-	struct list_head *p;
-
-	/* Reverse search, because new line will be the last one */
-	list_for_each_entry_reverse(ln, &lr->line_list, list) {
-		if (ln->line < line) {
-			p = &ln->list;
-			goto found;
-		} else if (ln->line == line)	/* Already exist */
-			return ;
-	}
-	/* List is empty, or the smallest entry */
-	p = &lr->line_list;
-found:
-	pr_debug("Debug: add a line %u\n", line);
-	ln = zalloc(sizeof(struct line_node));
-	DIE_IF(ln == NULL);
-	ln->line = line;
-	INIT_LIST_HEAD(&ln->list);
-	list_add(&ln->list, p);
-}
-
 /* Find line range from its line number */
-static void find_line_range_by_line(struct line_finder *lf)
+static void find_line_range_by_line(Dwarf_Die *sp_die, struct line_finder *lf)
 {
-	Dwarf_Signed cnt, i;
-	Dwarf_Line *lines;
-	Dwarf_Unsigned lineno = 0;
-	Dwarf_Unsigned fno;
+	Dwarf_Lines *lines;
+	Dwarf_Line *line;
+	size_t nlines, i;
 	Dwarf_Addr addr;
+	int lineno;
 	int ret;
+	const char *src;
+	Dwarf_Die die_mem;
 
-	ret = dwarf_srclines(lf->cu_die, &lines, &cnt, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
+	line_list__init(&lf->lr->line_list);
+	ret = dwarf_getsrclines(&lf->cu_die, &lines, &nlines);
+	DIE_IF(ret != 0);
 
-	for (i = 0; i < cnt; i++) {
-		ret = dwarf_line_srcfileno(lines[i], &fno, &__dw_error);
-		DIE_IF(ret != DW_DLV_OK);
-		if (fno != lf->fno)
-			continue;
-
-		ret = dwarf_lineno(lines[i], &lineno, &__dw_error);
-		DIE_IF(ret != DW_DLV_OK);
+	for (i = 0; i < nlines; i++) {
+		line = dwarf_onesrcline(lines, i);
+		ret = dwarf_lineno(line, &lineno);
+		DIE_IF(ret != 0);
 		if (lf->lno_s > lineno || lf->lno_e < lineno)
 			continue;
 
-		/* Filter line in the function address range */
-		if (lf->addr_s && lf->addr_e) {
-			ret = dwarf_lineaddr(lines[i], &addr, &__dw_error);
-			DIE_IF(ret != DW_DLV_OK);
-			if (lf->addr_s > addr || lf->addr_e <= addr)
+		if (sp_die) {
+			/* Address filtering 1: does sp_die include addr? */
+			ret = dwarf_lineaddr(line, &addr);
+			DIE_IF(ret != 0);
+			if (!dwarf_haspc(sp_die, addr))
+				continue;
+
+			/* Address filtering 2: No child include addr? */
+			if (die_get_inlinefunc(sp_die, addr, &die_mem))
 				continue;
 		}
-		line_range_add_line(lf->lr, (unsigned int)lineno);
+
+		/* TODO: Get fileno from line, but how? */
+		src = dwarf_linesrc(line, NULL, NULL);
+		if (strtailcmp(src, lf->fname) != 0)
+			continue;
+
+		/* Copy real path */
+		if (!lf->lr->path)
+			lf->lr->path = strdup(src);
+		line_list__add_line(&lf->lr->line_list, (unsigned int)lineno);
 	}
-	dwarf_srclines_dealloc(__dw_debug, lines, cnt);
+	/* Update status */
 	if (!list_empty(&lf->lr->line_list))
 		lf->found = 1;
+	else {
+		free(lf->lr->path);
+		lf->lr->path = NULL;
+	}
+}
+
+static int line_range_inline_cb(Dwarf_Die *in_die, void *data)
+{
+	find_line_range_by_line(in_die, (struct line_finder *)data);
+	return DWARF_CB_ABORT;	/* No need to find other instances */
 }
 
 /* Search function from function name */
-static int linefunc_callback(struct die_link *dlink, void *data)
+static int line_range_search_cb(Dwarf_Die *sp_die, void *data)
 {
 	struct line_finder *lf = (struct line_finder *)data;
 	struct line_range *lr = lf->lr;
-	Dwarf_Half tag;
-	int ret;
 
-	ret = dwarf_tag(dlink->die, &tag, &__dw_error);
-	DIE_IF(ret == DW_DLV_ERROR);
-	if (tag == DW_TAG_subprogram &&
-	    die_compare_name(dlink->die, lr->function) == 0) {
-		/* Get the address range of this function */
-		ret = dwarf_highpc(dlink->die, &lf->addr_e, &__dw_error);
-		if (ret == DW_DLV_OK)
-			ret = dwarf_lowpc(dlink->die, &lf->addr_s, &__dw_error);
-		DIE_IF(ret == DW_DLV_ERROR);
-		if (ret == DW_DLV_NO_ENTRY) {
-			lf->addr_s = 0;
-			lf->addr_e = 0;
-		}
-
-		lf->fno = die_get_decl_file(dlink->die);
-		lr->offset = die_get_decl_line(dlink->die);;
+	if (dwarf_tag(sp_die) == DW_TAG_subprogram &&
+	    die_compare_name(sp_die, lr->function) == 0) {
+		lf->fname = dwarf_decl_file(sp_die);
+		dwarf_decl_line(sp_die, &lr->offset);
+		pr_debug("fname: %s, lineno:%d\n", lf->fname, lr->offset);
 		lf->lno_s = lr->offset + lr->start;
 		if (!lr->end)
-			lf->lno_e = (Dwarf_Unsigned)-1;
+			lf->lno_e = INT_MAX;
 		else
 			lf->lno_e = lr->offset + lr->end;
 		lr->start = lf->lno_s;
 		lr->end = lf->lno_e;
-		find_line_range_by_line(lf);
-		/* If we find a target function, this should be end. */
-		lf->found = 1;
+		if (dwarf_func_inline(sp_die))
+			dwarf_func_inline_instances(sp_die,
+						    line_range_inline_cb, lf);
+		else
+			find_line_range_by_line(sp_die, lf);
 		return 1;
 	}
 	return 0;
@@ -857,55 +779,55 @@ static int linefunc_callback(struct die_link *dlink, void *data)
 
 static void find_line_range_by_func(struct line_finder *lf)
 {
-	search_die_from_children(lf->cu_die, linefunc_callback, lf);
+	dwarf_getfuncs(&lf->cu_die, line_range_search_cb, lf, 0);
 }
 
 int find_line_range(int fd, struct line_range *lr)
 {
-	Dwarf_Half addr_size = 0;
-	Dwarf_Unsigned next_cuh = 0;
+	struct line_finder lf = {.lr = lr, .found = 0};
 	int ret;
-	struct line_finder lf = {.lr = lr};
+	Dwarf_Off off = 0, noff;
+	size_t cuhl;
+	Dwarf_Die *diep;
+	Dwarf *dbg;
 
-	ret = dwarf_init(fd, DW_DLC_READ, 0, 0, &__dw_debug, &__dw_error);
-	if (ret != DW_DLV_OK)
+	dbg = dwarf_begin(fd, DWARF_C_READ);
+	if (!dbg)
 		return -ENOENT;
 
+	/* Loop on CUs (Compilation Unit) */
 	while (!lf.found) {
-		/* Search CU (Compilation Unit) */
-		ret = dwarf_next_cu_header(__dw_debug, NULL, NULL, NULL,
-			&addr_size, &next_cuh, &__dw_error);
-		DIE_IF(ret == DW_DLV_ERROR);
-		if (ret == DW_DLV_NO_ENTRY)
+		ret = dwarf_nextcu(dbg, off, &noff, &cuhl, NULL, NULL, NULL);
+		if (ret != 0)
 			break;
 
 		/* Get the DIE(Debugging Information Entry) of this CU */
-		ret = dwarf_siblingof(__dw_debug, 0, &lf.cu_die, &__dw_error);
-		DIE_IF(ret != DW_DLV_OK);
+		diep = dwarf_offdie(dbg, off + cuhl, &lf.cu_die);
+		if (!diep)
+			continue;
 
 		/* Check if target file is included. */
 		if (lr->file)
-			lf.fno = cu_find_fileno(lf.cu_die, lr->file);
+			lf.fname = cu_find_realpath(&lf.cu_die, lr->file);
+		else
+			lf.fname = 0;
 
-		if (!lr->file || lf.fno) {
+		if (!lr->file || lf.fname) {
 			if (lr->function)
 				find_line_range_by_func(&lf);
 			else {
 				lf.lno_s = lr->start;
 				if (!lr->end)
-					lf.lno_e = (Dwarf_Unsigned)-1;
+					lf.lno_e = INT_MAX;
 				else
 					lf.lno_e = lr->end;
-				find_line_range_by_line(&lf);
+				find_line_range_by_line(NULL, &lf);
 			}
-			/* Get the real file path */
-			if (lf.found)
-				cu_get_filename(lf.cu_die, lf.fno, &lr->path);
 		}
-		dwarf_dealloc(__dw_debug, lf.cu_die, DW_DLA_DIE);
+		off = noff;
 	}
-	ret = dwarf_finish(__dw_debug, &__dw_error);
-	DIE_IF(ret != DW_DLV_OK);
+	pr_debug("path: %lx\n", (unsigned long)lr->path);
+	dwarf_end(dbg);
 	return lf.found;
 }
 
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 972b386..d1a6517 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -1,6 +1,7 @@
 #ifndef _PROBE_FINDER_H
 #define _PROBE_FINDER_H
 
+#include <stdbool.h>
 #include "util.h"
 
 #define MAX_PATH_LEN		 256
@@ -20,6 +21,7 @@ struct probe_point {
 	/* Inputs */
 	char			*file;			/* File name */
 	int			line;			/* Line number */
+	char			*lazy_line;		/* Lazy line pattern */
 
 	char			*function;		/* Function name */
 	int			offset;			/* Offset bytes */
@@ -46,53 +48,46 @@ struct line_range {
 	char			*function;		/* Function name */
 	unsigned int		start;			/* Start line number */
 	unsigned int		end;			/* End line number */
-	unsigned int		offset;			/* Start line offset */
+	int			offset;			/* Start line offset */
 	char			*path;			/* Real path name */
 	struct list_head	line_list;		/* Visible lines */
 };
 
-#ifndef NO_LIBDWARF
-extern int find_probepoint(int fd, struct probe_point *pp);
+#ifndef NO_DWARF_SUPPORT
+extern int find_probe_point(int fd, struct probe_point *pp);
 extern int find_line_range(int fd, struct line_range *lr);
 
-/* Workaround for undefined _MIPS_SZLONG bug in libdwarf.h: */
-#ifndef _MIPS_SZLONG
-# define _MIPS_SZLONG		0
-#endif
-
 #include <dwarf.h>
-#include <libdwarf.h>
+#include <libdw.h>
 
 struct probe_finder {
-	struct probe_point	*pp;			/* Target probe point */
+	struct probe_point	*pp;		/* Target probe point */
 
 	/* For function searching */
-	Dwarf_Addr		addr;			/* Address */
-	Dwarf_Unsigned		fno;			/* File number */
-	Dwarf_Unsigned		lno;			/* Line number */
-	Dwarf_Off		inl_offs;		/* Inline offset */
-	Dwarf_Die		cu_die;			/* Current CU */
+	Dwarf_Addr		addr;		/* Address */
+	const char		*fname;		/* File name */
+	int			lno;		/* Line number */
+	Dwarf_Die		cu_die;		/* Current CU */
 
 	/* For variable searching */
-	Dwarf_Addr		cu_base;		/* Current CU base address */
-	Dwarf_Locdesc		fbloc;			/* Location of Current Frame Base */
-	const char		*var;			/* Current variable name */
-	char			*buf;			/* Current output buffer */
-	int			len;			/* Length of output buffer */
+	Dwarf_Op		*fb_ops;	/* Frame base attribute */
+	Dwarf_Addr		cu_base;	/* Current CU base address */
+	const char		*var;		/* Current variable name */
+	char			*buf;		/* Current output buffer */
+	int			len;		/* Length of output buffer */
+	struct list_head	lcache;		/* Line cache for lazy match */
 };
 
 struct line_finder {
-	struct line_range	*lr;			/* Target line range */
-
-	Dwarf_Unsigned		fno;			/* File number */
-	Dwarf_Unsigned		lno_s;			/* Start line number */
-	Dwarf_Unsigned		lno_e;			/* End line number */
-	Dwarf_Addr		addr_s;			/* Start address */
-	Dwarf_Addr		addr_e;			/* End address */
-	Dwarf_Die		cu_die;			/* Current CU */
+	struct line_range	*lr;		/* Target line range */
+
+	const char		*fname;		/* File name */
+	int			lno_s;		/* Start line number */
+	int			lno_e;		/* End line number */
+	Dwarf_Die		cu_die;		/* Current CU */
 	int			found;
 };
 
-#endif /* NO_LIBDWARF */
+#endif /* NO_DWARF_SUPPORT */
 
 #endif /*_PROBE_FINDER_H */
diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index c397d4f..a175949 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -265,21 +265,21 @@ error:
 	return false;
 }
 
-/**
- * strglobmatch - glob expression pattern matching
- * @str: the target string to match
- * @pat: the pattern string to match
- *
- * This returns true if the @str matches @pat. @pat can includes wildcards
- * ('*','?') and character classes ([CHARS], complementation and ranges are
- * also supported). Also, this supports escape character ('\') to use special
- * characters as normal character.
- *
- * Note: if @pat syntax is broken, this always returns false.
- */
-bool strglobmatch(const char *str, const char *pat)
+/* Glob/lazy pattern matching */
+static bool __match_glob(const char *str, const char *pat, bool ignore_space)
 {
 	while (*str && *pat && *pat != '*') {
+		if (ignore_space) {
+			/* Ignore spaces for lazy matching */
+			if (isspace(*str)) {
+				str++;
+				continue;
+			}
+			if (isspace(*pat)) {
+				pat++;
+				continue;
+			}
+		}
 		if (*pat == '?') {	/* Matches any single character */
 			str++;
 			pat++;
@@ -308,3 +308,32 @@ bool strglobmatch(const char *str, const char *pat)
 	return !*str && !*pat;
 }
 
+/**
+ * strglobmatch - glob expression pattern matching
+ * @str: the target string to match
+ * @pat: the pattern string to match
+ *
+ * This returns true if the @str matches @pat. @pat can includes wildcards
+ * ('*','?') and character classes ([CHARS], complementation and ranges are
+ * also supported). Also, this supports escape character ('\') to use special
+ * characters as normal character.
+ *
+ * Note: if @pat syntax is broken, this always returns false.
+ */
+bool strglobmatch(const char *str, const char *pat)
+{
+	return __match_glob(str, pat, false);
+}
+
+/**
+ * strlazymatch - matching pattern strings lazily with glob pattern
+ * @str: the target string to match
+ * @pat: the pattern string to match
+ *
+ * This is similar to strglobmatch, except this ignores spaces in
+ * the target string.
+ */
+bool strlazymatch(const char *str, const char *pat)
+{
+	return __match_glob(str, pat, true);
+}
diff --git a/tools/perf/util/string.h b/tools/perf/util/string.h
index 02ede58..542e44d 100644
--- a/tools/perf/util/string.h
+++ b/tools/perf/util/string.h
@@ -10,6 +10,7 @@ s64 perf_atoll(const char *str);
 char **argv_split(const char *str, int *argcp);
 void argv_free(char **argv);
 bool strglobmatch(const char *str, const char *pat);
+bool strlazymatch(const char *str, const char *pat);
 
 #define _STR(x) #x
 #define STR(x) _STR(x)
