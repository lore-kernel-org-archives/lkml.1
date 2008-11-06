Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbYKFH2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbYKFH2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 02:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbYKFH23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 02:28:29 -0500
Received: from smtp-out.google.com ([216.239.33.17]:34221 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbYKFH21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 02:28:27 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=vdYs1EnSjTBB5d/qcLFb4RzHmgAcHo/4Z8MeA6FmlnFzGK89yz72M+q5b2bCBQJU5
	m8Pn2dls5v7fLncIyy4aA==
MIME-Version: 1.0
In-Reply-To: <20081106065925.GE15731@elte.hu>
References: <b040c32a0811052158r4f6662dega3503a0c7ec72620@mail.gmail.com>
	 <20081106061125.GA6384@elte.hu>
	 <b040c32a0811052216i4594a094gdcee3ae280cddec7@mail.gmail.com>
	 <20081106063012.GA15731@elte.hu>
	 <b040c32a0811052242q767302cbx2667a68a8e058b6e@mail.gmail.com>
	 <20081106065925.GE15731@elte.hu>
Date: Wed, 5 Nov 2008 23:28:17 -0800
Message-ID: <b040c32a0811052328k12c70644n15af3cedab32b6c3@mail.gmail.com>
Subject: Re: [patch] sched: fix single-depth wchan output
From: Ken Chen <kenchen@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2008 at 10:59 PM, Ingo Molnar <mingo@elte.hu> wrote:
> If it does stack walking manually then please update it to use
> save_stack_trace() instead - that is the standard API that will
> utilize the best possible stack walking machinery on the architecture
> level.

OK, I pulled the patch out of our code that export stack trace via
/proc/pid/trace.  I didn't write this patch, but I think a better choice
would be to override struct stacktrace_ops print_trace_ops with a memory
buffer pointer to dump the stack into.  If you have any comments, please
let me know.  I will polish this patch up and rebase to git-head.

--- linux/arch/x86/Kconfig	2008-11-05 22:30:06.000000000 -0800
+++ linux/arch/x86/Kconfig	2008-11-05 22:30:06.000000000 -0800
@@ -213,6 +213,11 @@

 config KTIME_SCALAR
 	def_bool X86_32
+
+config ARCH_HAS_BUF_SHOW_STACK
+	bool
+	default y
+
 source "init/Kconfig"

 menu "Processor type and features"
--- linux/arch/x86/kernel/traps_64.c	2008-11-05 22:30:06.000000000 -0800
+++ linux/arch/x86/kernel/traps_64.c	2008-11-05 22:30:06.000000000 -0800
@@ -78,6 +78,11 @@
 asmlinkage void machine_check(void);
 asmlinkage void spurious_interrupt_bug(void);

+struct arch_unwind {
+	char **posp;
+	char *end;
+};
+
 static unsigned int code_bytes = 64;

 static inline void conditional_sti(struct pt_regs *regs)
@@ -104,22 +109,23 @@

 int kstack_depth_to_print = 12;

-void printk_address(unsigned long address, int reliable)
-{
 #ifdef CONFIG_KALLSYMS
+static void buf_printk_address(char **posp, char *end, unsigned long address,
+			int reliable)
+{
 	unsigned long offset = 0, symsize;
 	const char *symname;
 	char *modname;
 	char *delim = ":";
-	char namebuf[KSYM_NAME_LEN];
+	char namebuf[128];
 	char reliab[4] = "";

 	symname = kallsyms_lookup(address, &symsize, &offset,
-					&modname, namebuf);
+				  &modname, namebuf);
 	if (!offset)
-		return;	/* We don't want to print function ptrs */
+		return;         /* We don't want to print function ptrs */
 	if (!symname) {
-		printk(" [<%016lx>]\n", address);
+		buf_printk(posp, end, " [<%016lx>]\n", address);
 		return;
 	}
 	if (!reliable)
@@ -127,11 +133,21 @@

 	if (!modname)
 		modname = delim = "";
-	printk(" [<%016lx>] %s%s%s%s%s+0x%lx/0x%lx\n",
-		address, reliab, delim, modname, delim, symname, offset, symsize);
+	buf_printk(posp, end, " [<%016lx>] %s%s%s%s%s+0x%lx/0x%lx\n",
+		address, reliab, delim, modname, delim, symname, offset,
+		symsize);
+}
 #else
-	printk(" [<%016lx>]\n", address);
+static void buf_printk_address(char **posp, char *end, unsigned long address,
+			int reliable)
+{
+	buf_printk(posp, end, " [<%016lx>]\n", address);
+}
 #endif
+
+void printk_address(unsigned long address, int reliable)
+{
+	buf_printk_address(NULL, NULL, address, reliable);
 }

 static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
@@ -357,25 +373,31 @@
 static void
 print_trace_warning_symbol(void *data, char *msg, unsigned long symbol)
 {
-	print_symbol(msg, symbol);
-	printk("\n");
+	struct arch_unwind *unw = (struct arch_unwind *)data;
+
+	buf_print_symbol(unw->posp, unw->end, msg, symbol);
+	buf_printk(unw->posp, unw->end, "\n");
 }

 static void print_trace_warning(void *data, char *msg)
 {
-	printk("%s\n", msg);
+	struct arch_unwind *unw = (struct arch_unwind *)data;
+
+	buf_printk(unw->posp, unw->end, "%s\n", msg);
 }

 static int print_trace_stack(void *data, char *name)
 {
-	printk(" <%s> ", name);
+	struct arch_unwind *unw = (struct arch_unwind *)data;
+	buf_printk(unw->posp, unw->end, " <%s> ", name);
 	return 0;
 }

 static void print_trace_address(void *data, unsigned long addr, int reliable)
 {
+	struct arch_unwind *unw = (struct arch_unwind *)data;
 	touch_nmi_watchdog();
-	printk_address(addr, reliable);
+	buf_printk_address(unw->posp, unw->end, addr, reliable);
 }

 static const struct stacktrace_ops print_trace_ops = {
@@ -385,18 +407,29 @@
 	.address = print_trace_address,
 };

+static void
+buf_show_trace(char **posp, char *end,
+		struct task_struct *tsk, struct pt_regs *regs,
+		unsigned long *stack, unsigned long bp) {
+	struct arch_unwind unw;
+	unw.posp = posp;
+	unw.end = end;
+
+	buf_printk(posp, end, "\nCall Trace:\n");
+	dump_trace(tsk, regs, stack, bp, &print_trace_ops, &unw);
+	buf_printk(posp, end, "\n");
+}
+
 void
 show_trace(struct task_struct *tsk, struct pt_regs *regs, unsigned long *stack,
 		unsigned long bp)
 {
-	printk("\nCall Trace:\n");
-	dump_trace(tsk, regs, stack, bp, &print_trace_ops, NULL);
-	printk("\n");
+	buf_show_trace(NULL, NULL, tsk, regs, stack, bp);
 }

 static void
-_show_stack(struct task_struct *tsk, struct pt_regs *regs, unsigned long *sp,
-							unsigned long bp)
+_buf_show_stack(char **posp, char *end, struct task_struct *tsk,
+		struct pt_regs *regs, unsigned long *sp, unsigned long bp)
 {
 	unsigned long *stack;
 	int i;
@@ -419,23 +452,29 @@
 		if (stack >= irqstack && stack <= irqstack_end) {
 			if (stack == irqstack_end) {
 				stack = (unsigned long *) (irqstack_end[-1]);
-				printk(" <EOI> ");
+				buf_printk(posp, end, " <EOI> ");
 			}
 		} else {
 		if (((long) stack & (THREAD_SIZE-1)) == 0)
 			break;
 		}
 		if (i && ((i % 4) == 0))
-			printk("\n");
-		printk(" %016lx", *stack++);
+			buf_printk(posp, end, "\n");
+		buf_printk(posp, end, " %016lx", *stack++);
 		touch_nmi_watchdog();
 	}
-	show_trace(tsk, regs, sp, bp);
+	buf_show_trace(posp, end, tsk, regs, sp, bp);
 }

 void show_stack(struct task_struct *tsk, unsigned long * sp)
 {
-	_show_stack(tsk, NULL, sp, 0);
+	_buf_show_stack(NULL, NULL, tsk, NULL, sp, 0);
+}
+
+void buf_show_stack(char **posp, char *end, struct task_struct *tsk,
+		    unsigned long * sp)
+{
+	_buf_show_stack(posp, end, tsk, NULL, sp, 0);
 }

 /*
@@ -485,7 +524,8 @@
 	if (!user_mode(regs)) {
 		unsigned char c;
 		printk("Stack: ");
-		_show_stack(NULL, regs, (unsigned long *)sp, regs->bp);
+		_buf_show_stack(NULL, NULL,
+				NULL, regs, (unsigned long *)sp, regs->bp);
 		printk("\n");

 		printk(KERN_EMERG "Code: ");
diff -u linux/fs/proc/base.c 2.6.26/fs/proc/base.c
--- linux/fs/proc/base.c	2008-11-05 22:27:42.000000000 -0800
+++ linux/fs/proc/base.c	2008-11-05 22:27:42.000000000 -0800
@@ -2271,6 +2271,31 @@

 #endif

+static int proc_pid_trace(struct task_struct *task, char * buffer)
+{
+	char *pos, *end, **posp;
+
+	posp = &pos;
+	pos = buffer;
+	end = buffer + PAGE_SIZE;
+	memset(buffer, 0, PAGE_SIZE);
+
+	/*
+	 * Add some safety checking
+	 */
+
+	buffer[PAGE_SIZE - 1] = 1;
+	end--;
+
+	read_lock(&tasklist_lock);
+	buf_show_task(posp, end, task);
+	read_unlock(&tasklist_lock);
+
+	WARN_ON(buffer[PAGE_SIZE - 1] != 1);
+	WARN_ON(buffer[PAGE_SIZE - 2] != 0);
+	return (pos - buffer);
+}
+
 #if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
 static ssize_t proc_coredump_filter_read(struct file *file, char __user *buf,
 					 size_t count, loff_t *ppos)
@@ -2574,6 +2599,7 @@
 	REG("smaps",      S_IRUGO, smaps),
 	REG("pagemap",    S_IRUSR, pagemap),
 #endif
+	INF("trace",  S_IFREG|S_IRUGO, pid_trace),
 #ifdef CONFIG_SECURITY
 	DIR("attr",       S_IRUGO|S_IXUGO, attr_dir),
 #endif
--- linux/include/linux/kallsyms.h	2008-11-05 22:30:06.000000000 -0800
+++ linux/include/linux/kallsyms.h	2008-11-05 22:30:06.000000000 -0800
@@ -31,6 +31,8 @@

 /* Look up a kernel symbol and print it to the kernel messages. */
 extern void __print_symbol(const char *fmt, unsigned long address);
+extern void __buf_print_symbol(char **posp, char *end,
+			       const char *fmt, unsigned long address);

 int lookup_symbol_name(unsigned long addr, char *symname);
 int lookup_symbol_attrs(unsigned long addr, unsigned long *size,
unsigned long *offset, char *modname, char *name);
@@ -75,6 +77,7 @@

 /* Stupid that this does nothing, but I didn't create this mess. */
 #define __print_symbol(fmt, addr)
+#define __buf_print_symbol(posp, end, fmt, addr)
 #endif /*CONFIG_KALLSYMS*/

 /* This macro allows us to keep printk typechecking */
@@ -105,6 +108,14 @@
 	print_symbol(fmt, (unsigned long)addr);
 }

+static inline void buf_print_symbol(char **posp, char *end,
+				    const char *fmt, unsigned long addr)
+{
+	__check_printsym_format(fmt, "");
+	__buf_print_symbol(posp, end, fmt, (unsigned long)
+			   __builtin_extract_return_addr((void *)addr));
+}
+
 #ifndef CONFIG_64BIT
 #define print_ip_sym(ip)		\
 do {					\
--- linux/include/linux/kernel.h	2008-11-05 22:30:06.000000000 -0800
+++ linux/include/linux/kernel.h	2008-11-05 22:30:06.000000000 -0800
@@ -224,6 +224,9 @@
 extern void __attribute__((format(printf, 1, 2)))
 	early_printk(const char *fmt, ...);

+extern void buf_printk(char **posp, char *end, const char *fmt, ...)
+	__attribute__ ((format (printf, 3, 4)));
+
 void redisplay_console_messages(void);

 unsigned long int_sqrt(unsigned long);
--- linux/include/linux/sched.h	2008-11-05 22:30:06.000000000 -0800
+++ linux/include/linux/sched.h	2008-11-05 22:30:06.000000000 -0800
@@ -267,6 +267,7 @@
  */
 extern void show_state_filter(unsigned long state_filter);

+extern void buf_show_task(char **posp, char *end, struct task_struct *p);
 static inline void show_state(void)
 {
 	show_state_filter(0);
@@ -280,7 +281,17 @@
  * trace (or NULL if the entire call-chain of the task should be shown).
  */
 extern void show_stack(struct task_struct *task, unsigned long *sp);
-
+#ifdef CONFIG_ARCH_HAS_BUF_SHOW_STACK
+extern void buf_show_stack(char **posp, char *end,
+			   struct task_struct *task, unsigned long *sp);
+#else
+static inline void buf_show_stack(char **posp, char *end,
+			     struct task_struct *task, unsigned long *sp)
+{
+	if (posp == NULL)
+		show_stack(task, sp);
+}
+#endif
 void io_schedule(void);
 long io_schedule_timeout(long timeout);

--- linux/kernel/kallsyms.c	2008-11-05 22:30:06.000000000 -0800
+++ linux/kernel/kallsyms.c	2008-11-05 22:30:06.000000000 -0800
@@ -319,13 +319,19 @@
 }

 /* Look up a kernel symbol and print it to the kernel messages. */
+void __buf_print_symbol(char **posp, char *end,
+			const char *fmt, unsigned long address)
+{
+	char buffer[KSYM_SYMBOL_LEN];
+
+	sprint_symbol(buffer, address);
+
+	buf_printk(posp, end, fmt, buffer);
+}
+
 void __print_symbol(const char *fmt, unsigned long address)
 {
-	char buffer[KSYM_SYMBOL_LEN];
-
-	sprint_symbol(buffer, address);
-
-	printk(fmt, buffer);
+	__buf_print_symbol(NULL, NULL, fmt, address);
 }

 /* To avoid using get_symbol_offset for every symbol, we carry prefix along. */
--- linux/kernel/printk.c	2008-11-05 22:30:06.000000000 -0800
+++ linux/kernel/printk.c	2008-11-05 22:30:06.000000000 -0800
@@ -655,6 +655,20 @@
 	return r;
 }

+void buf_printk(char **posp, char *end, const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+
+	if (posp != NULL)
+		*posp += vscnprintf(*posp, end - (*posp), fmt, args);
+	else
+		(void)vprintk(fmt, args);
+
+	va_end(args);
+}
+
 /* cpu currently holding logbuf_lock */
 static volatile unsigned int printk_cpu = UINT_MAX;

--- linux/kernel/sched.c	2008-11-05 22:30:06.000000000 -0800
+++ linux/kernel/sched.c	2008-11-05 22:30:06.000000000 -0800
@@ -5398,24 +5398,24 @@

 static const char stat_nam[] = "RSDTtZX";

-void sched_show_task(struct task_struct *p)
+void buf_show_task(char **posp, char *end, struct task_struct *p)
 {
 	unsigned long free = 0;
 	unsigned state;

 	state = p->state ? __ffs(p->state) + 1 : 0;
-	printk(KERN_INFO "%-13.13s %c", p->comm,
+	buf_printk(posp, end, KERN_INFO "%-13.13s %c", p->comm,
 		state < sizeof(stat_nam) - 1 ? stat_nam[state] : '?');
 #if BITS_PER_LONG == 32
 	if (state == TASK_RUNNING)
-		printk(KERN_CONT " running  ");
+		buf_printk(posp, end, KERN_CONT " running  ");
 	else
-		printk(KERN_CONT " %08lx ", thread_saved_pc(p));
+		buf_printk(posp, end, KERN_CONT " %08lx ", thread_saved_pc(p));
 #else
 	if (state == TASK_RUNNING)
-		printk(KERN_CONT "  running task    ");
+		buf_printk(posp, end, KERN_CONT "  running task    ");
 	else
-		printk(KERN_CONT " %016lx ", thread_saved_pc(p));
+		buf_printk(posp, end, KERN_CONT " %016lx ", thread_saved_pc(p));
 #endif
 #ifdef CONFIG_DEBUG_STACK_USAGE
 	{
@@ -5425,10 +5425,15 @@
 		free = (unsigned long)n - (unsigned long)end_of_stack(p);
 	}
 #endif
-	printk(KERN_CONT "%5lu %5d %6d\n", free,
+	buf_printk(posp, end, KERN_CONT "%5lu %5d %6d\n", free,
 		task_pid_nr(p), task_pid_nr(p->real_parent));

-	show_stack(p, NULL);
+	buf_show_stack(posp, end, p, NULL);
+}
+
+void sched_show_task(struct task_struct *p)
+{
+	buf_show_task(NULL, NULL, p);
 }

 void show_state_filter(unsigned long state_filter)
