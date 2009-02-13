Return-Path: <linux-kernel-owner+w=401wt.eu-S1761507AbZBMFa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761507AbZBMFa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 00:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbZBMFaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 00:30:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55353 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbZBMFaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 00:30:07 -0500
Message-Id: <20090213053004.995555198@goodmis.org>
References: <20090213052358.524970112@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 13 Feb 2009 00:24:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/7] powerpc64: port of the function graph tracer
Content-Disposition: inline; filename=0002-powerpc64-port-of-the-function-graph-tracer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This is a port of the function graph tracer that was written by
Frederic Weisbecker for the x86.

This only works for PPC64 at the moment and only for static tracing.
PPC32 and dynamic function graph tracing support will come later.

The trace produces a visual calling of functions:

 # tracer: function_graph
 #
 # CPU  DURATION                  FUNCTION CALLS
 # |     |   |                     |   |   |   |
  0)   2.224 us    |                        }
  0) ! 271.024 us  |                      }
  0) ! 320.080 us  |                    }
  0) ! 324.656 us  |                  }
  0) ! 329.136 us  |                }
  0)               |                .put_prev_task_fair() {
  0)               |                  .update_curr() {
  0)   2.240 us    |                    .update_min_vruntime();
  0)   6.512 us    |                  }
  0)   2.528 us    |                  .__enqueue_entity();
  0) + 15.536 us   |                }
  0)               |                .pick_next_task_fair() {
  0)   2.032 us    |                  .__pick_next_entity();
  0)   2.064 us    |                  .__clear_buddies();
  0)               |                  .set_next_entity() {
  0)   2.672 us    |                    .__dequeue_entity();
  0)   6.864 us    |                  }

Geoff Lavand tested on PS3.

Tested-by: Geoff Levand <geoffrey.levand@am.sony.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/powerpc/Kconfig              |    1 +
 arch/powerpc/kernel/Makefile      |    9 ++--
 arch/powerpc/kernel/entry_64.S    |   58 +++++++++++++++++++++++++-
 arch/powerpc/kernel/ftrace.c      |   79 ++++++++++++++++++++++++++++++++++++-
 arch/powerpc/kernel/process.c     |   16 +++++++
 arch/powerpc/kernel/vmlinux.lds.S |    1 +
 6 files changed, 154 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 74cc312..ca4647e 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -111,6 +111,7 @@ config PPC
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_TRACER
+	select HAVE_FUNCTION_GRAPH_TRACER if !DYNAMIC_FTRACE && PPC64
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_IDE
 	select HAVE_IOREMAP_PROT
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 8d1a419..a70aeea 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -18,12 +18,10 @@ CFLAGS_REMOVE_cputable.o = -pg -mno-sched-epilog
 CFLAGS_REMOVE_prom_init.o = -pg -mno-sched-epilog
 CFLAGS_REMOVE_btext.o = -pg -mno-sched-epilog
 CFLAGS_REMOVE_prom.o = -pg -mno-sched-epilog
-
-ifdef CONFIG_DYNAMIC_FTRACE
-# dynamic ftrace setup.
+# do not trace tracer code
 CFLAGS_REMOVE_ftrace.o = -pg -mno-sched-epilog
-endif
-
+# timers used by tracing
+CFLAGS_REMOVE_time.o = -pg -mno-sched-epilog
 endif
 
 obj-y				:= cputable.o ptrace.o syscalls.o \
@@ -94,6 +92,7 @@ obj-$(CONFIG_AUDIT)		+= audit.o
 obj64-$(CONFIG_AUDIT)		+= compat_audit.o
 
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
+obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o
 
 obj-$(CONFIG_8XX_MINIMAL_FPEMU) += softemu8xx.o
 
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index 383ed6e..a32699e 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -931,13 +931,65 @@ _GLOBAL(_mcount)
 	ld	r5,0(r5)
 	mtctr	r5
 	bctrl
-
 	nop
+
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	b	ftrace_graph_caller
+#endif
 	ld	r0, 128(r1)
 	mtlr	r0
 	addi	r1, r1, 112
 _GLOBAL(ftrace_stub)
 	blr
 
-#endif
-#endif
+#endif /* CONFIG_DYNAMIC_FTRACE */
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+ftrace_graph_caller:
+	/* load r4 with local address */
+	ld	r4, 128(r1)
+	subi	r4, r4, MCOUNT_INSN_SIZE
+
+	/* get the parent address */
+	ld	r11, 112(r1)
+	addi	r3, r11, 16
+
+	bl	.prepare_ftrace_return
+	nop
+
+	ld	r0, 128(r1)
+	mtlr	r0
+	addi	r1, r1, 112
+	blr
+
+_GLOBAL(return_to_handler)
+	/* need to save return values */
+	std	r4,  -32(r1)
+	std	r3,  -24(r1)
+	/* save TOC */
+	std	r2,  -16(r1)
+	std	r31, -8(r1)
+	mr	r31, r1
+	stdu	r1, -112(r1)
+
+	/* update the TOC */
+	LOAD_REG_IMMEDIATE(r4,ftrace_return_to_handler)
+	ld	r2, 8(r4)
+
+	bl	.ftrace_return_to_handler
+	nop
+
+	/* return value has real return address */
+	mtlr	r3
+
+	ld	r1, 0(r1)
+	ld	r4,  -32(r1)
+	ld	r3,  -24(r1)
+	ld	r2,  -16(r1)
+	ld	r31, -8(r1)
+
+	/* Jump back to real return address */
+	blr
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+#endif /* CONFIG_FUNCTION_TRACER */
diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index 4112175..c9b1547 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -5,6 +5,9 @@
  *
  * Thanks goes out to P.A. Semi, Inc for supplying me with a PPC64 box.
  *
+ * Added function graph tracer code, taken from x86 that was written
+ * by Frederic Weisbecker, and ported to PPC by Steven Rostedt.
+ *
  */
 
 #include <linux/spinlock.h>
@@ -20,8 +23,6 @@
 #include <asm/code-patching.h>
 #include <asm/ftrace.h>
 
-static unsigned int ftrace_nop = PPC_NOP_INSTR;
-
 #ifdef CONFIG_PPC32
 # define GET_ADDR(addr) addr
 #else
@@ -29,6 +30,8 @@ static unsigned int ftrace_nop = PPC_NOP_INSTR;
 # define GET_ADDR(addr) (*(unsigned long *)addr)
 #endif
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+static unsigned int ftrace_nop = PPC_NOP_INSTR;
 
 static unsigned int ftrace_calc_offset(long ip, long addr)
 {
@@ -525,3 +528,75 @@ int __init ftrace_dyn_arch_init(void *data)
 
 	return 0;
 }
+#endif /* CONFIG_DYNAMIC_FTRACE */
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+
+/*
+ * Hook the return address and push it in the stack of return addrs
+ * in current thread info.
+ */
+void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
+{
+	unsigned long old;
+	unsigned long long calltime;
+	int faulted;
+	struct ftrace_graph_ent trace;
+	unsigned long return_hooker = (unsigned long)
+				&return_to_handler;
+
+	if (unlikely(atomic_read(&current->tracing_graph_pause)))
+		return;
+
+	return_hooker = GET_ADDR(return_hooker);
+
+	/*
+	 * Protect against fault, even if it shouldn't
+	 * happen. This tool is too much intrusive to
+	 * ignore such a protection.
+	 */
+	asm volatile(
+		"1: " PPC_LL "%[old], 0(%[parent])\n"
+		"2: " PPC_STL "%[return_hooker], 0(%[parent])\n"
+		"   li %[faulted], 0\n"
+		"3:"
+
+		".section .fixup, \"ax\"\n"
+		"4: li %[faulted], 1\n"
+		"   b 3b\n"
+		".previous\n"
+
+		".section __ex_table,\"a\"\n"
+			PPC_LONG_ALIGN "\n"
+			PPC_LONG "1b,4b\n"
+			PPC_LONG "2b,4b\n"
+		".previous"
+
+		: [old] "=r" (old), [faulted] "=r" (faulted)
+		: [parent] "r" (parent), [return_hooker] "r" (return_hooker)
+		: "memory"
+	);
+
+	if (unlikely(faulted)) {
+		ftrace_graph_stop();
+		WARN_ON(1);
+		return;
+	}
+
+	calltime = cpu_clock(raw_smp_processor_id());
+
+	if (ftrace_push_return_trace(old, calltime,
+				self_addr, &trace.depth) == -EBUSY) {
+		*parent = old;
+		return;
+	}
+
+	trace.func = self_addr;
+
+	/* Only trace if the calling function expects to */
+	if (!ftrace_graph_entry(&trace)) {
+		current->curr_ret_stack--;
+		*parent = old;
+	}
+}
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index fb7049c..8ede428 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -33,6 +33,7 @@
 #include <linux/mqueue.h>
 #include <linux/hardirq.h>
 #include <linux/utsname.h>
+#include <linux/ftrace.h>
 #include <linux/kernel_stat.h>
 
 #include <asm/pgtable.h>
@@ -1008,6 +1009,14 @@ void show_stack(struct task_struct *tsk, unsigned long *stack)
 	unsigned long sp, ip, lr, newsp;
 	int count = 0;
 	int firstframe = 1;
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	int curr_frame = current->curr_ret_stack;
+	extern void return_to_handler(void);
+	unsigned long addr = (unsigned long)return_to_handler;
+#ifdef CONFIG_PPC64
+	addr = *(unsigned long*)addr;
+#endif
+#endif
 
 	sp = (unsigned long) stack;
 	if (tsk == NULL)
@@ -1030,6 +1039,13 @@ void show_stack(struct task_struct *tsk, unsigned long *stack)
 		ip = stack[STACK_FRAME_LR_SAVE];
 		if (!firstframe || ip != lr) {
 			printk("["REG"] ["REG"] %pS", sp, ip, (void *)ip);
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+			if (ip == addr && curr_frame >= 0) {
+				printk(" (%pS)",
+				       (void *)current->ret_stack[curr_frame].ret);
+				curr_frame--;
+			}
+#endif
 			if (firstframe)
 				printk(" (unreliable)");
 			printk("\n");
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 161b9b9..895af44 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -58,6 +58,7 @@ SECTIONS
 		SCHED_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
+		IRQENTRY_TEXT
 
 #ifdef CONFIG_PPC32
 		*(.got1)
-- 
1.5.6.5

-- 
