Return-Path: <linux-kernel-owner+w=401wt.eu-S1752604AbYJaTNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbYJaTNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 15:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbYJaTNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 15:13:06 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:45845 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbYJaTND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 15:13:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=oWViSvxqgNcHikeVQU6nNvFgUIS5Z2jrX0m20Gf3NUPiDfVBHGab2EGUyP/IITyS0B
         rBf8KJLGuDpfYr0DpYpTVX43N+J5AbJs/bD5z1W6oHgD7O9+ZPzuqwqfJ9CcMckNEJ1h
         i5kK4KDrbarJd0bE0Xt6ky84IFjAbmpr1K6Jc=
Message-ID: <490B6826.7080604@gmail.com>
Date: Fri, 31 Oct 2008 21:18:46 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Make ftrace able to trace function return
References: <490A08E3.2040201@gmail.com>  <alpine.DEB.1.10.0810301556010.19996@gandalf.stny.rr.com> <c62985530810301705h356decf8oea0db02def2ab3c1@mail.gmail.com> <alpine.DEB.1.10.0810302241420.21031@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0810302241420.21031@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Fri, 31 Oct 2008, Fr?d?ric Weisbecker wrote:
> 
>> 2008/10/30 Steven Rostedt <rostedt@goodmis.org>:
>>> What about storing the return addresses on the bottom of the stack?
>>> That is, start at task->stack + sizeof(thread_info), and stack up on that.
>>> Be careful, there might already be users of that area. This will also need
>>> to be arch dependent.
>> But how could I assume there is enough space behind this address to store a long
>> stack of functions calls for a same thread?
>> And if an interrupt is raised, would a reference to "current task" be
>> really consistant?
>>
>> I don't know much about the bottom stack of the tasks, I'm not sure
>> about how much
>> space I can use inside... I should study this field. Who could be the
>> potential users of this area?
>>
> 
> Because it is the real stack ;-)
> 
> Before adding, test to see if the real stack pointer is getting close. If 
> it is, then there's probably more issues.  You can run the stack_tracer to 
> see how much stack is available too.
> 
> -- Steve
> 
> 

Hhm. That seem dangerous. But why not. I keep this idea for further tests.

I made some changes and the things seem to be better. I drop the locking
with spinlock and irqs disabled to use an atomic counter. If bitmap is already in read
by someone else, then the current function will not be logged.
So I guess I'm missing some entries but I can allocate 32 slots whithout problems.
It's perhaps better for debugging.
I disabled the tracing too when I insert the function data into the ring buffer.

I don't know why but spinlocks and insertion of entry cause system freezes, (or perhaps very long hangs).
There are still some hangs sometimes, I don't know why, but I'm exploring these issues step by step.

I have a trace in attachment with some good results.
Here is the new patch:
---
 arch/x86/kernel/Makefile              |   11 ++
 arch/x86/kernel/entry_32.S            |   19 ++++
 arch/x86/kernel/ftrace.c              |  170 ++++++++++++++++++++++++++++++++-
 include/linux/ftrace.h                |   13 +++
 kernel/trace/Kconfig                  |   13 +++
 kernel/trace/Makefile                 |    1 +
 kernel/trace/ftrace.c                 |   15 +++
 kernel/trace/trace.c                  |   31 +++++--
 kernel/trace/trace.h                  |   21 ++++
 kernel/trace/trace_functions_return.c |   87 +++++++++++++++++
 10 files changed, 370 insertions(+), 11 deletions(-)

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
index 6914933..18b1bc3 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -18,10 +18,23 @@
 #include <linux/list.h>
 
 #include <asm/ftrace.h>
+#include <linux/ftrace.h>
 #include <asm/nops.h>
 
 
-static unsigned char ftrace_nop[MCOUNT_INSN_SIZE];
+#if defined(CONFIG_FTRACE_RETURN) || defined(CONFIG_DYNAMIC_FTRACE)
+
+#define FTRACE_TRAMPOLINE_SIZE 32
+
+struct ftrace_return_data {
+	unsigned long bitmap; /* Bitmap which defines free slots in func table */
+	atomic_t bitmap_lock;
+	union ftrace_return_code_union *trampoline;
+	struct ftrace_retfunc *func_table;
+	unsigned long overrun;
+};
+
+static struct ftrace_return_data ftrace_return_state;
 
 union ftrace_code_union {
 	char code[MCOUNT_INSN_SIZE];
@@ -31,17 +44,158 @@ union ftrace_code_union {
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
+			 union ftrace_return_code_union *calc)
 {
-	return ftrace_nop;
+	calc->push		= 0x6a;
+	calc->index		= index;
+	calc->e8		= 0xe8;
+	calc->offset	= ftrace_calc_offset(ip + 2 + MCOUNT_INSN_SIZE, addr);
+
 }
 
+void prepare_ftrace_return(unsigned long *addr)
+{
+	unsigned long flags;
+	int index;
+
+	if (atomic_inc_return(&ftrace_return_state.bitmap_lock) != 1)
+		goto fail;
+
+	if (!ftrace_return_state.bitmap) {
+		goto fail;
+	}
+	/* Find next free slot */
+	index = ffs(ftrace_return_state.bitmap) - 1;
+
+	__clear_bit(index, &ftrace_return_state.bitmap);
+	smp_mb();
+
+	ftrace_return_state.func_table[index].calltime = cpu_clock(raw_smp_processor_id());
+	atomic_dec(&ftrace_return_state.bitmap_lock);
+	ftrace_return_state.func_table[index].ret = *addr;
+	*addr = (unsigned long)&ftrace_return_state.trampoline[index];
+	smp_mb();
+	return;
+fail:
+	atomic_dec(&ftrace_return_state.bitmap_lock);
+
+}
+
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
+		::"memory"
+	);
+
+	table = &ftrace_return_state.func_table[index];
+	ret = table->ret;
+	atomic_inc(&ftrace_return_state.bitmap_lock);
+	ftrace_function_return(table);
+	table->rettime = cpu_clock(raw_smp_processor_id());
+	atomic_dec(&ftrace_return_state.bitmap_lock);
+
+	__set_bit(index, &ftrace_return_state.bitmap);
+
+	/* Put the original return address of the hooked function as our
+	 * return address.
+	 */
+	asm volatile (
+		"movl %0, 4(%%ebp)\n"
+		:: "r" (ret)
+		: "memory"
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
+	atomic_set(&ftrace_return_state.bitmap_lock, 0);
+	ftrace_return_state.trampoline = kmalloc(sizeof(union ftrace_return_code_union)	* 
+						 FTRACE_TRAMPOLINE_SIZE,
+						 GFP_KERNEL);
+	if (!ftrace_return_state.trampoline)
+		return -ENOMEM;
+
+	fill_trampoline();
+	/* Allocate 32 slots */
+	ftrace_return_state.bitmap = ~0;
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
@@ -183,6 +337,15 @@ do_ftrace_mod_code(unsigned long ip, void *new_code)
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
@@ -292,3 +455,4 @@ int __init ftrace_dyn_arch_init(void *data)
 
 	return 0;
 }
+#endif
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index e46a7b3..10c98ae 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -234,6 +234,19 @@ ftrace_init_module(unsigned long *start, unsigned long *end) { }
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
index b58f43b..572cf73 100644
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
index 5b8c90d..c459ff6 100644
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
@@ -713,6 +706,28 @@ trace_function(struct trace_array *tr, struct trace_array_cpu *data,
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
 }
 
+void trace_function_return(struct ftrace_retfunc *trace)
+{
+	struct ring_buffer_event *event;
+	struct ftrace_ret_entry *entry;
+	unsigned long irq_flags;
+
+	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
+		return;
+
+	event = ring_buffer_lock_reserve(global_trace.buffer, sizeof(*entry),
+					 &irq_flags);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, 0, 0);
+	entry->ent.type			= TRACE_FN_RET;
+	entry->ip			= trace->ret;
+	entry->rettime		= trace->rettime;
+	entry->calltime		= trace->calltime;
+	ring_buffer_unlock_commit(global_trace.buffer, event, irq_flags);
+}
+
 void
 ftrace(struct trace_array *tr, struct trace_array_cpu *data,
        unsigned long ip, unsigned long parent_ip, unsigned long flags,
@@ -1154,7 +1169,7 @@ seq_print_sym_offset(struct trace_seq *s, const char *fmt,
 # define IP_FMT "%016lx"
 #endif
 
-static int
+int
 seq_print_ip_sym(struct trace_seq *s, unsigned long ip, unsigned long sym_flags)
 {
 	int ret;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 8465ad0..f93d9b3 100644
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
@@ -219,6 +228,7 @@ extern void __ftrace_bad_type(void);
 		IF_ASSIGN(var, ent, struct trace_mmiotrace_map,		\
 			  TRACE_MMIO_MAP);				\
 		IF_ASSIGN(var, ent, struct trace_boot, TRACE_BOOT);	\
+		IF_ASSIGN(var, ent, struct ftrace_ret_entry, TRACE_FN_RET); \
 		__ftrace_bad_type();					\
 	} while (0)
 
@@ -320,6 +330,8 @@ void trace_function(struct trace_array *tr,
 		    unsigned long ip,
 		    unsigned long parent_ip,
 		    unsigned long flags, int pc);
+void
+trace_function_return(struct ftrace_retfunc *trace);
 
 void tracing_start_cmdline_record(void);
 void tracing_stop_cmdline_record(void);
@@ -389,6 +401,15 @@ extern void *head_page(struct trace_array_cpu *data);
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
index 0000000..e0dd882
--- /dev/null
+++ b/kernel/trace/trace_functions_return.c
@@ -0,0 +1,87 @@
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
+
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

