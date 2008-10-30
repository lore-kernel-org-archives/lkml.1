Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbYJ3SO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbYJ3SO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 14:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755703AbYJ3SOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 14:14:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:31427 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbYJ3SOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 14:14:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Ew+CGr4o3bn3Pg+snf75XolMs7ydp/ARTWG94KrvfZ4p0zym4Lh36BA6M1Owex/WSn
         u/o5SK0x6K2laOD3olOwdOJlObznpeemLrMoxyRoHFRybn3TZp+lhkP16KTapuD64f8O
         hF6O5/pSaEGgTY/W+DdhkMLDFv4O4HH3fMTM8=
Message-ID: <490A08E3.2040201@gmail.com>
Date: Thu, 30 Oct 2008 20:20:03 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] Make ftrace able to trace function return
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

First of all, I want to say this patch is absolutely not ready for inclusion. 
Some parts are really ugly and the thing is only partially functionning.

It's just an idea or a kind of proof of concept. I just wanted to make ftrace
able to measure the time of execution of a function. For that I had to
hook both the function call and its return.

By using mcount, we can hook the function on enter and we can override its
return address. So we can catch the time at those two points. The problem comes
when a function run concurrently through preemption or smp. We can measure the
return time but how to be sure which time capture we had on call since this time
could have been captured multiple times. And for the same reason, how to make sure
of the return address.

So the idea is to allocate a general set of slots on which we can save our original
return address and the call time. After that we change the return address of the
hooked function to jump on a trampoline which will push the offset for us
to retrieve the slot on the set for this function call. Then the trampoline
will call a return handler that will trace the return time and send all of these
informations to a specific tracer. And then the return handler will return to the
original return address.

To determine quickly which slot is free, I use a bitmap of 32 bits. 
Perhaps it is a bad assumption but I could enlarge it and there is an overrun
counter. This is the only point which needs to be protected against 
concurrent access.

I made a tracer for this but the problem is that the capture by ftrace will hang
the system if we can use several slots. When I dedicate only one free slot,
wherever on the set, there is no problem but I miss a lot of calls.
So by default on this patch, there is only one slot dedicated on the bitmap.

Don't hesitate to comment this patch made of trashes...

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/Makefile              |   11 ++
 arch/x86/kernel/entry_32.S            |   19 ++++
 arch/x86/kernel/ftrace.c              |  174 ++++++++++++++++++++++++++++++++-
 include/linux/ftrace.h                |   13 +++
 kernel/trace/Kconfig                  |   13 +++
 kernel/trace/Makefile                 |    1 +
 kernel/trace/ftrace.c                 |   15 +++
 kernel/trace/trace.c                  |    9 +--
 kernel/trace/trace.h                  |   19 ++++
 kernel/trace/trace_functions_return.c |  108 ++++++++++++++++++++
 10 files changed, 371 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 58814cc..38b5d43 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -14,6 +14,16 @@ CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
 CFLAGS_REMOVE_ftrace.o = -pg
 endif
 
+ifdef CONFIG_FTRACE_RETURN
+# Do not profile debug and lowlevel utilities
+CFLAGS_REMOVE_tsc.o = -pg
+CFLAGS_REMOVE_rtc.o = -pg
+CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
+CFLAGS_REMOVE_ftrace.o = -pg
+endif
+
+
+
 #
 # vsyscalls (which work on the user stack) should have
 # no stack-protector checks:
@@ -66,6 +76,7 @@ obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o nmi.o
 obj-$(CONFIG_X86_IO_APIC)	+= io_apic.o
 obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
+obj-$(CONFIG_FTRACE_RETURN)	+= ftrace.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
 obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 28b597e..bbac81e 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1182,7 +1182,13 @@ END(ftrace_caller)
 ENTRY(mcount)
 	cmpl $ftrace_stub, ftrace_trace_function
 	jnz trace
+#ifdef CONFIG_FTRACE_RETURN
+	cmpl $ftrace_return_stub, ftrace_function_return
+	jnz trace_return
+#endif
 .globl ftrace_stub
+.globl ftrace_return_stub
+ftrace_return_stub:
 ftrace_stub:
 	ret
 
@@ -1201,6 +1207,19 @@ trace:
 	popl %ecx
 	popl %eax
 
+#ifdef CONFIG_FTRACE_RETURN
+trace_return:
+	pushl %eax
+	pushl %ecx
+	pushl %edx
+	lea 0x4(%ebp), %eax
+	pushl %eax
+	call prepare_ftrace_return
+	addl $4, %esp
+	popl %edx
+	popl %ecx
+	popl %eax
+#endif
 	jmp ftrace_stub
 END(mcount)
 #endif /* CONFIG_DYNAMIC_FTRACE */
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 50ea0ac..e47444a 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -18,10 +18,24 @@
 #include <linux/list.h>
 
 #include <asm/ftrace.h>
+#include <linux/ftrace.h>
 #include <asm/nops.h>
 
 
-static unsigned char ftrace_nop[MCOUNT_INSN_SIZE];
+
+#if defined(CONFIG_FTRACE_RETURN) || defined(CONFIG_DYNAMIC_FTRACE)
+
+#define FTRACE_TRAMPOLINE_SIZE 32
+
+struct ftrace_return_data {
+	unsigned int bitmap; /* Bitmap which defines free slots in func table */
+	raw_spinlock_t bitmap_spinlock; /* Protect the bitmap */
+	union ftrace_return_code_union *trampoline;
+	struct ftrace_retfunc *func_table;
+	unsigned long overrun;
+};
+
+static struct ftrace_return_data ftrace_return_state;
 
 union ftrace_code_union {
 	char code[MCOUNT_INSN_SIZE];
@@ -31,17 +45,161 @@ union ftrace_code_union {
 	} __attribute__((packed));
 };
 
+union ftrace_return_code_union {
+	char code[MCOUNT_INSN_SIZE + 2];
+	struct {
+		char push; /* push imm8 */
+		char index; /* index on the trampoline/func table */
+		char e8; /* call to the return handler */
+		int offset;
+	} __attribute__((packed));
+};
+
 
 static int ftrace_calc_offset(long ip, long addr)
 {
 	return (int)(addr - ip);
 }
 
-unsigned char *ftrace_nop_replace(void)
+void ftrace_call_replace(char index, unsigned long ip, unsigned long addr, 
+						 union ftrace_return_code_union *calc)
 {
-	return ftrace_nop;
+	calc->push		= 0x6a;
+	calc->index		= index;
+	calc->e8		= 0xe8;
+	calc->offset	= ftrace_calc_offset(ip + 2 + MCOUNT_INSN_SIZE, addr);
+
+}
+
+void prepare_ftrace_return(unsigned long *addr)
+{
+	unsigned long flags;
+	int index;
+	int bitmap;
+
+	raw_local_irq_save(flags);
+	__raw_spin_lock(&ftrace_return_state.bitmap_spinlock);
+	bitmap = ftrace_return_state.bitmap;
+	if (!bitmap) {
+		__raw_spin_unlock(&ftrace_return_state.bitmap_spinlock);
+		raw_local_irq_restore(flags);
+		return;
+	}
+	/* Find next free slot */
+	index = ffs(bitmap) - 1;
+
+	ftrace_return_state.bitmap &= ~(1 << index);
+	__raw_spin_unlock(&ftrace_return_state.bitmap_spinlock);
+	raw_local_irq_restore(flags);
+
+	ftrace_return_state.func_table[index].calltime = cpu_clock(raw_smp_processor_id());
+	ftrace_return_state.func_table[index].ret = *addr;
+	*addr = (unsigned long)&ftrace_return_state.trampoline[index];
+	return;
+
 }
 
+/*
+ * No caller of this function is really aware it is calling it since
+ * it is a hooker called through a trampoline which passes the offset
+ * of the function in the func table through the stack. So we have to
+ * clean the stack ourself. Hence the stdcall.
+ * We want to be sure our offset pushed on the stack will not be assumed
+ * to be transmitted through a register => asmlinkage.
+ */
+__attribute__((stdcall)) asmlinkage static
+unsigned long ftrace_return_to_handler(int index)
+{
+	struct ftrace_retfunc *table;
+	unsigned long ret;
+	unsigned long flags;
+	unsigned long eax;
+
+	/* The function we are hooking on return could have
+	 * a return value. Just keep the value of eax and return
+	 * it in the end.
+	 */
+
+	asm volatile(
+		"movl %%eax, %0\n"
+		: "=r" (eax)
+	);
+
+	table = &ftrace_return_state.func_table[index];
+	table->rettime = cpu_clock(raw_smp_processor_id());
+	ret = table->ret;
+	ftrace_function_return(table);
+
+	raw_local_irq_save(flags);
+	__raw_spin_lock(&ftrace_return_state.bitmap_spinlock);
+	ftrace_return_state.bitmap |= (1 << index);
+	__raw_spin_unlock(&ftrace_return_state.bitmap_spinlock);
+	raw_local_irq_restore(flags);
+
+	/* Put the original return address of the hooked function as our
+	 * return address.
+	 */
+	asm volatile (
+		"movl %0, 4(%%ebp)\n"
+		:: "r" (ret)
+	);
+
+	return eax;
+}
+
+/*
+ * Set the trampoline. At each slot we have:
+ * push $offset
+ * call ftrace_return_to_handler
+ */
+static void __init fill_trampoline(void)
+{
+	union ftrace_return_code_union tramp_code;
+	int i;
+	unsigned long ip;
+
+	for (i = 0; i < FTRACE_TRAMPOLINE_SIZE; i++) {
+		ip = (unsigned long)&ftrace_return_state.trampoline[i];
+		ftrace_call_replace((char)i, ip,
+				    (unsigned long)&ftrace_return_to_handler,
+				    &tramp_code);
+		memcpy(&ftrace_return_state.trampoline[i],
+		       &tramp_code, sizeof(union ftrace_return_code_union));
+	}
+}
+
+static int __init init_ftrace_function_return(void)
+{
+	ftrace_return_state.bitmap_spinlock =  (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+	ftrace_return_state.trampoline = kmalloc(sizeof(union ftrace_return_code_union)	* 
+						 FTRACE_TRAMPOLINE_SIZE,
+						 GFP_KERNEL);
+	if (!ftrace_return_state.trampoline)
+		return -ENOMEM;
+
+	fill_trampoline();
+	/* At this time, this return tracing only works with
+	 * one slot allocated. If you attend to set more, your
+	 * system will hang. I don't know why.
+	 */
+	ftrace_return_state.bitmap = 1;
+	ftrace_return_state.func_table = kmalloc(FTRACE_TRAMPOLINE_SIZE *
+						 sizeof(struct ftrace_retfunc),
+						 GFP_KERNEL);
+	if (!ftrace_return_state.func_table) {
+		kfree(ftrace_return_state.trampoline);
+		return -ENOMEM;
+	}
+	ftrace_return_state.overrun = 0;
+	return 0;
+}
+device_initcall(init_ftrace_function_return);
+
+
+#endif
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+
 unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 {
 	static union ftrace_code_union calc;
@@ -56,6 +214,15 @@ unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 	return calc.code;
 }
 
+
+
+static unsigned char ftrace_nop[MCOUNT_INSN_SIZE];
+
+unsigned char *ftrace_nop_replace(void)
+{
+	return ftrace_nop;
+}
+
 int
 ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 		   unsigned char *new_code)
@@ -165,3 +332,4 @@ int __init ftrace_dyn_arch_init(void *data)
 
 	return 0;
 }
+#endif
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 899ec4b..757e2c6 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -231,6 +231,19 @@ ftrace_init_module(unsigned long *start, unsigned long *end) { }
 #endif
 
 
+#ifdef CONFIG_FTRACE_RETURN
+struct ftrace_retfunc {
+	unsigned long ret;
+	unsigned long long calltime;
+	unsigned long long rettime;
+};
+
+extern void ftrace_return_stub(struct ftrace_retfunc *);
+extern void register_ftrace_return(void (*func)(struct ftrace_retfunc *));
+extern void (*ftrace_function_return)(struct ftrace_retfunc *);
+extern void unregister_ftrace_return(void);
+#endif
+
 struct boot_trace {
 	pid_t			caller;
 	char			func[KSYM_NAME_LEN];
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index e0cea28..6d43268 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -47,6 +47,19 @@ config FUNCTION_TRACER
 	  (the bootup default), then the overhead of the instructions is very
 	  small and not measurable even in micro-benchmarks.
 
+config FTRACE_RETURN
+	bool "Kernel Function return Tracer"
+	depends on !DYNAMIC_FTRACE
+	depends on X86
+	depends on DEBUG_KERNEL
+	select FRAME_POINTER
+	select TRACING
+	help
+	  Enable the kernel to trace a function at its return.
+	  It's first purpose is to trace the duration of functions.
+	  It is totally unstable and ugly at this time and only supports
+	  one function call at a time.
+
 config IRQSOFF_TRACER
 	bool "Interrupts-off Latency Tracer"
 	default n
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index c8228b1..5cfacd5 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -24,5 +24,6 @@ obj-$(CONFIG_NOP_TRACER) += trace_nop.o
 obj-$(CONFIG_STACK_TRACER) += trace_stack.o
 obj-$(CONFIG_MMIOTRACE) += trace_mmiotrace.o
 obj-$(CONFIG_BOOT_TRACER) += trace_boot.o
+obj-$(CONFIG_FTRACE_RETURN) += trace_functions_return.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4a39d24..adb10e8 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1454,3 +1454,18 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 	return ret;
 }
 
+#ifdef CONFIG_FTRACE_RETURN
+void (*ftrace_function_return)(struct ftrace_retfunc *) = ftrace_return_stub;
+void register_ftrace_return(void (*func)(struct ftrace_retfunc *))
+{
+	ftrace_function_return = func;
+}
+
+void unregister_ftrace_return(void)
+{
+	ftrace_function_return = ftrace_return_stub;
+}
+#endif
+
+
+
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9cf5c84..6cf22fe 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -215,13 +215,6 @@ unsigned long nsecs_to_usecs(unsigned long nsecs)
 	return nsecs / 1000;
 }
 
-/*
- * TRACE_ITER_SYM_MASK masks the options in trace_flags that
- * control the output of kernel symbols.
- */
-#define TRACE_ITER_SYM_MASK \
-	(TRACE_ITER_PRINT_PARENT|TRACE_ITER_SYM_OFFSET|TRACE_ITER_SYM_ADDR)
-
 /* These must match the bit postions in trace_iterator_flags */
 static const char *trace_options[] = {
 	"print-parent",
@@ -1150,7 +1143,7 @@ seq_print_sym_offset(struct trace_seq *s, const char *fmt,
 # define IP_FMT "%016lx"
 #endif
 
-static int
+int
 seq_print_ip_sym(struct trace_seq *s, unsigned long ip, unsigned long sym_flags)
 {
 	int ret;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 6889ca4..7c73e78 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -22,6 +22,7 @@ enum trace_type {
 	TRACE_MMIO_RW,
 	TRACE_MMIO_MAP,
 	TRACE_BOOT,
+	TRACE_FN_RET,
 
 	__TRACE_LAST_TYPE
 };
@@ -48,6 +49,14 @@ struct ftrace_entry {
 	unsigned long		ip;
 	unsigned long		parent_ip;
 };
+
+/* Function return entry */
+struct ftrace_ret_entry {
+	struct trace_entry	ent;
+	unsigned long		ip;
+	unsigned long long	calltime;
+	unsigned long long	rettime;
+};
 extern struct tracer boot_tracer;
 
 /*
@@ -217,6 +226,7 @@ extern void __ftrace_bad_type(void);
 		IF_ASSIGN(var, ent, struct trace_mmiotrace_map,		\
 			  TRACE_MMIO_MAP);				\
 		IF_ASSIGN(var, ent, struct trace_boot, TRACE_BOOT);	\
+		IF_ASSIGN(var, ent, struct ftrace_ret_entry, TRACE_FN_RET); \
 		__ftrace_bad_type();					\
 	} while (0)
 
@@ -387,6 +397,15 @@ extern void *head_page(struct trace_array_cpu *data);
 extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...);
 extern void trace_seq_print_cont(struct trace_seq *s,
 				 struct trace_iterator *iter);
+
+/*
+ * TRACE_ITER_SYM_MASK masks the options in trace_flags that
+ * control the output of kernel symbols.
+ */
+#define TRACE_ITER_SYM_MASK \
+	(TRACE_ITER_PRINT_PARENT|TRACE_ITER_SYM_OFFSET|TRACE_ITER_SYM_ADDR)
+extern int
+seq_print_ip_sym(struct trace_seq *s, unsigned long ip, unsigned long sym_flags);
 extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
 				 size_t cnt);
 extern long ns2usecs(cycle_t nsec);
diff --git a/kernel/trace/trace_functions_return.c b/kernel/trace/trace_functions_return.c
new file mode 100644
index 0000000..9bc08d8
--- /dev/null
+++ b/kernel/trace/trace_functions_return.c
@@ -0,0 +1,108 @@
+/*
+ * Function return tracer (mostly borrowed from function tracer).
+ *
+ */
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
+#include <linux/ftrace.h>
+#include <linux/fs.h>
+
+#include "trace.h"
+
+struct trace_array *ret_trace;
+
+static void
+trace_function_return(struct ftrace_retfunc *trace);
+
+static void start_return_trace(struct trace_array *tr)
+{
+	register_ftrace_return(&trace_function_return);
+}
+
+static void stop_return_trace(struct trace_array *tr)
+{
+	unregister_ftrace_return();
+}
+
+static void return_trace_init(struct trace_array *tr)
+{
+	int cpu;
+	for_each_online_cpu(cpu)
+		tracing_reset(tr, cpu);
+	ret_trace = tr;
+
+	if (tr->ctrl)
+		start_return_trace(tr);
+}
+
+static void return_trace_reset(struct trace_array *tr)
+{
+	if (tr->ctrl)
+		stop_return_trace(tr);
+}
+
+static void return_trace_ctrl_update(struct trace_array *tr)
+{
+	if (tr->ctrl)
+		start_return_trace(tr);
+	else
+		stop_return_trace(tr);
+}
+
+static void
+trace_function_return(struct ftrace_retfunc *trace)
+{
+	struct ring_buffer_event *event;
+	struct ftrace_ret_entry *entry;
+	unsigned long irq_flags;
+
+	event = ring_buffer_lock_reserve(ret_trace->buffer, sizeof(*entry),
+					 &irq_flags);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, 0, 0);
+	entry->ent.type			= TRACE_FN_RET;
+	entry->ip			= trace->ret;
+	entry->rettime		= trace->rettime;
+	entry->calltime		= trace->calltime;
+	ring_buffer_unlock_commit(ret_trace->buffer, event, irq_flags);
+}
+
+static enum print_line_t
+print_return(struct trace_iterator *iter)
+{
+	struct trace_seq *s = &iter->seq;
+	struct trace_entry *entry = iter->ent;
+	struct ftrace_ret_entry *field;
+	int ret;
+
+	if (entry->type == TRACE_FN_RET) {
+		trace_assign_type(field, entry);
+		seq_print_ip_sym(s, field->ip,
+				(trace_flags & TRACE_ITER_SYM_MASK));
+		ret = trace_seq_printf(s, " Called: %llu Returned: %llu\n",
+					field->calltime, field->rettime);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+		else
+			return TRACE_TYPE_HANDLED;
+	}
+	return TRACE_TYPE_UNHANDLED;
+}
+
+static struct tracer return_trace __read_mostly =
+{
+	.name	     = "return",
+	.init	     = return_trace_init,
+	.reset	     = return_trace_reset,
+	.ctrl_update = return_trace_ctrl_update,
+	.print_line = print_return
+};
+
+static __init int init_return_trace(void)
+{
+	return register_tracer(&return_trace);
+}
+
+device_initcall(init_return_trace);
