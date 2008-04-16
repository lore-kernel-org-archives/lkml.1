Return-Path: <linux-kernel-owner+w=401wt.eu-S1762775AbYDPNrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762775AbYDPNrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 09:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbYDPNrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 09:47:41 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:60454 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbYDPNrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 09:47:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EAKqgBUhMROPA/2dsb2JhbACBYK0sgio
Date: Wed, 16 Apr 2008 09:47:35 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: [TEST PATCH] Test NMI kprobe modules
Message-ID: <20080416134735.GA13399@Krystal>
References: <20080414230344.GA16061@Krystal> <20080414230530.GB16061@Krystal> <20080416130605.GG6304@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080416130605.GG6304@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:43:33 up 47 days,  9:54,  4 users,  load average: 0.03, 0.12,
	0.16
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:
> 
> > Implements an alternative iret with popf and return so trap and 
> > exception handlers can return to the NMI handler without issuing iret. 
> > iret would cause NMIs to be reenabled prematurely. x86_32 uses popf 
> > and far return. x86_64 has to copy the return instruction pointer to 
> > the top of the previous stack, issue a popf, loads the previous esp 
> > and issue a near return (ret).
> 
> thanks Mathieu, i've picked this up into x86.git for more testing.
> 
> note that this also fixes an oprofile regression: when oprofile is used 
> to generate stack-backtraces, we can fault on address resolution from 
> NMI context and currently we do an IRET - with your fixes it should work 
> fine. Obscure case but still worth fixing.
> 
> 	Ingo
> 

Hi Ingo,

I also have a test workbench in the form of the following patch. It is
*not* meant for inclusion of any sort, but could help testing.

Enabling a kprobe, a trace_mark() and a vmalloc access requires either
to uncomment the kprobe code or to enable immediate values and disable
the vmalloc code in the marker probe, or disable immediate values and
enable the vmalloc code in the marker probe.

Thanks,

Mathieu

Small marker module to test placing a breakpoint into an NMI handler.

Notes :
We cannot single-step an NMI handler, because iret must set the TF flag and
return back to the instruction to single-step in a single instruction. This
cannot be emulated with popf/lret, because lret would be single-stepped.

Note2 :
Immediate values does not use single-stepping. Hehe. :)

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>
CC: akpm@osdl.org
CC: mingo@elte.hu
---
 arch/x86/kernel/entry_32.S      |   30 ++++++++++
 arch/x86/kernel/entry_64.S      |   87 +++++++++++++++++++++++++++++++
 arch/x86/kernel/immediate.c     |    1 
 arch/x86/kernel/traps_32.c      |   21 +++++++
 arch/x86/kernel/traps_64.c      |   20 ++++++-
 samples/kprobes/Makefile        |    2 
 samples/kprobes/kprobe_nmi.c    |  110 ++++++++++++++++++++++++++++++++++++++++
 samples/markers/probe-example.c |   35 +++++-------
 8 files changed, 284 insertions(+), 22 deletions(-)

Index: linux-2.6-lttng/arch/x86/kernel/entry_32.S
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/entry_32.S	2008-04-11 07:52:36.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kernel/entry_32.S	2008-04-11 07:59:07.000000000 -0400
@@ -430,9 +430,39 @@ return_to_nmi:
 					 */
 	TRACE_IRQS_IRET
 	RESTORE_REGS
+	#ud2 	# TEST, BUG on return to NMI handler
 	addl $4, %esp			# skip orig_eax/error_code
 	CFI_ADJUST_CFA_OFFSET -4
+	pushl %eax
+	pushfl
+	movl (%esp), %eax
+	movl %eax, debugo_eflags
+	addl $4, %esp
+	mov %cs, debugo_cs
+	movl 4(%esp), %eax
+	movl %eax, debug_eip
+	movl 8(%esp), %eax
+	movl %eax, debug_cs
+	movl 12(%esp), %eax
+	movl %eax, debug_eflags
+	movl 16(%esp), %eax
+	movl %eax, debug_extra
+	movl 20(%esp), %eax
+	movl %eax, debug_extra2
+	movl 24(%esp), %eax
+	movl %eax, debug_extra3
+	movl 28(%esp), %eax
+	movl %eax, debug_extra4
+	popl %eax
+	#INTERRUPT_RETURN
 	INTERRUPT_RETURN_NMI_SAFE
+	#pushl 8(%esp);
+	#popfl;
+	#.byte 0xCA;	#lret
+	#.word 4;	# pop eflags
+	#.byte 0xC2;	#ret
+	#.word 8;	# pop CS and eflags
+	#lret
 
 .section .fixup,"ax"
 iret_exc:
Index: linux-2.6-lttng/arch/x86/kernel/traps_32.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/traps_32.c	2008-04-11 07:52:36.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kernel/traps_32.c	2008-04-11 07:59:07.000000000 -0400
@@ -791,7 +791,7 @@ void __kprobes die_nmi(struct pt_regs *r
 	do_exit(SIGSEGV);
 }
 
-static __kprobes void default_do_nmi(struct pt_regs * regs)
+void default_do_nmi(struct pt_regs * regs)
 {
 	unsigned char reason = 0;
 
@@ -799,6 +799,8 @@ static __kprobes void default_do_nmi(str
 	if (!smp_processor_id())
 		reason = get_nmi_reason();
  
+ 	/* int3 disabled */
+	_trace_mark(test_nmi, MARK_NOARGS);
 	trace_mark(kernel_arch_trap_entry, "trap_id %d ip #p%ld", 2,
 		instruction_pointer(regs));
 
@@ -1289,3 +1291,20 @@ static int __init code_bytes_setup(char 
 	return 1;
 }
 __setup("code_bytes=", code_bytes_setup);
+
+long debug_eip, debug_cs, debug_eflags, debug_extra, debug_extra2, debug_extra3, debug_extra4;
+long debugo_eip, debugo_cs, debugo_eflags, debugo_extra, debugo_extra2, debugo_extra3, debugo_extra4;
+EXPORT_SYMBOL(debug_eip);
+EXPORT_SYMBOL(debug_cs);
+EXPORT_SYMBOL(debug_eflags);
+EXPORT_SYMBOL(debug_extra);
+EXPORT_SYMBOL(debug_extra2);
+EXPORT_SYMBOL(debug_extra3);
+EXPORT_SYMBOL(debug_extra4);
+EXPORT_SYMBOL(debugo_eip);
+EXPORT_SYMBOL(debugo_cs);
+EXPORT_SYMBOL(debugo_eflags);
+EXPORT_SYMBOL(debugo_extra);
+EXPORT_SYMBOL(debugo_extra2);
+EXPORT_SYMBOL(debugo_extra3);
+EXPORT_SYMBOL(debugo_extra4);
Index: linux-2.6-lttng/samples/kprobes/Makefile
===================================================================
--- linux-2.6-lttng.orig/samples/kprobes/Makefile	2008-04-11 07:52:36.000000000 -0400
+++ linux-2.6-lttng/samples/kprobes/Makefile	2008-04-11 07:59:07.000000000 -0400
@@ -1,5 +1,5 @@
 # builds the kprobes example kernel modules;
 # then to use one (as root):  insmod <module_name.ko>
 
-obj-$(CONFIG_SAMPLE_KPROBES) += kprobe_example.o jprobe_example.o
+obj-$(CONFIG_SAMPLE_KPROBES) += kprobe_example.o jprobe_example.o kprobe_nmi.o
 obj-$(CONFIG_SAMPLE_KRETPROBES) += kretprobe_example.o
Index: linux-2.6-lttng/samples/kprobes/kprobe_nmi.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/samples/kprobes/kprobe_nmi.c	2008-04-11 08:40:14.000000000 -0400
@@ -0,0 +1,110 @@
+/*
+ * NOTE: This example is works on x86 and powerpc.
+ * Here's a sample kernel module showing the use of kprobes to dump a
+ * stack trace and selected registers when do_fork() is called.
+ *
+ * For more information on theory of operation of kprobes, see
+ * Documentation/kprobes.txt
+ *
+ * You will see the trace data in /var/log/messages and on the console
+ * whenever do_fork() is invoked to create a new process.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/kprobes.h>
+
+extern long debug_eip, debug_cs, debug_eflags, debug_extra, debug_extra2, debug_extra3, debug_extra4;
+extern long debugo_eip, debugo_cs, debugo_eflags, debugo_extra, debugo_extra2, debugo_extra3, debugo_extra4;
+static int disable;
+
+/* For each probe you need to allocate a kprobe structure */
+static struct kprobe kp = {
+	.symbol_name	= "default_do_nmi",
+};
+
+/* kprobe pre_handler: called just before the probed instruction is executed */
+static int handler_pre(struct kprobe *p, struct pt_regs *regs)
+{
+	if (disable)
+		return 0;
+#ifdef CONFIG_X86
+	printk(KERN_INFO "pre_handler: p->addr = 0x%p, ip = %lx,"
+			" flags = 0x%lx\n",
+		p->addr, regs->ip, regs->flags);
+#endif
+#ifdef CONFIG_PPC
+	printk(KERN_INFO "pre_handler: p->addr = 0x%p, nip = 0x%lx,"
+			" msr = 0x%lx\n",
+		p->addr, regs->nip, regs->msr);
+#endif
+
+	/* A dump_stack() here will give a stack backtrace */
+	return 0;
+}
+
+/* kprobe post_handler: called after the probed instruction is executed */
+static void handler_post(struct kprobe *p, struct pt_regs *regs,
+				unsigned long flags)
+{
+	if (disable)
+		return;
+#ifdef CONFIG_X86
+	printk(KERN_INFO "post_handler: p->addr = 0x%p, flags = 0x%lx\n",
+		p->addr, regs->flags);
+#endif
+#ifdef CONFIG_PPC
+	printk(KERN_INFO "post_handler: p->addr = 0x%p, msr = 0x%lx\n",
+		p->addr, regs->msr);
+#endif
+	disable = 1;
+}
+
+/*
+ * fault_handler: this is called if an exception is generated for any
+ * instruction within the pre- or post-handler, or when Kprobes
+ * single-steps the probed instruction.
+ */
+static int handler_fault(struct kprobe *p, struct pt_regs *regs, int trapnr)
+{
+	if (disable)
+		return 0;
+	printk(KERN_INFO "fault_handler: p->addr = 0x%p, trap #%dn",
+		p->addr, trapnr);
+	/* Return 0 because we don't handle the fault. */
+	return 0;
+}
+
+static int __init kprobe_init(void)
+{
+	int ret;
+	kp.pre_handler = handler_pre;
+	kp.post_handler = handler_post;
+	kp.fault_handler = handler_fault;
+
+	//ret = register_kprobe(&kp);
+	//if (ret < 0) {
+	//	printk(KERN_INFO "register_kprobe failed, returned %d\n", ret);
+	//	return ret;
+	//}
+	printk(KERN_INFO "Planted kprobe at %p\n", kp.addr);
+	return 0;
+}
+
+static void __exit kprobe_exit(void)
+{
+	printk("debug data:  eip 0x%lX, cs 0x%lX, eflags 0x%lX, "
+		"extra 0x%lX 0x%lX 0x%lX 0x%lX\n",
+		debug_eip, debug_cs, debug_eflags, debug_extra,
+		debug_extra2, debug_extra3, debug_extra4);
+	printk("debugo data: eip 0x%lX, cs 0x%lX, eflags 0x%lX, "
+		"extra 0x%lX 0x%lX 0x%lX 0x%lX\n",
+		debugo_eip, debugo_cs, debugo_eflags, debugo_extra,
+		debugo_extra2, debugo_extra3, debugo_extra4);
+	unregister_kprobe(&kp);
+	printk(KERN_INFO "kprobe at %p unregistered\n", kp.addr);
+}
+
+module_init(kprobe_init)
+module_exit(kprobe_exit)
+MODULE_LICENSE("GPL");
Index: linux-2.6-lttng/arch/x86/kernel/immediate.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/immediate.c	2008-04-11 07:52:36.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kernel/immediate.c	2008-04-11 07:59:07.000000000 -0400
@@ -272,6 +272,7 @@ __kprobes int arch_imv_update(const stru
 		 * interrupts.
 		 */
 		wmb();
+		mdelay(10);
 		text_poke((void *)insn, (unsigned char *)bypass_eip, 1);
 		/*
 		 * Wait for all int3 handlers to end (interrupts are disabled in
Index: linux-2.6-lttng/samples/markers/probe-example.c
===================================================================
--- linux-2.6-lttng.orig/samples/markers/probe-example.c	2008-04-11 07:52:36.000000000 -0400
+++ linux-2.6-lttng/samples/markers/probe-example.c	2008-04-11 07:59:07.000000000 -0400
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/marker.h>
+#include <linux/vmalloc.h>
 #include <asm/atomic.h>
 
 struct probe_data {
@@ -20,40 +21,34 @@ struct probe_data {
 	marker_probe_func *probe_func;
 };
 
+/* 20 MB buffer */
+char *vmem;
+atomic_t eventb_count = ATOMIC_INIT(0);
+
 void probe_subsystem_event(void *probe_data, void *call_data,
 	const char *format, va_list *args)
 {
+	vmem[atomic_read(&eventb_count) % 20971520] = 0x42;
+	atomic_add(4096, &eventb_count);
 	/* Declare args */
-	unsigned int value;
-	const char *mystr;
+	//unsigned int value;
+	//const char *mystr;
 
 	/* Assign args */
-	value = va_arg(*args, typeof(value));
-	mystr = va_arg(*args, typeof(mystr));
+	//value = va_arg(*args, typeof(value));
+	//mystr = va_arg(*args, typeof(mystr));
 
 	/* Call printk */
-	printk(KERN_INFO "Value %u, string %s\n", value, mystr);
+	//printk(KERN_INFO "Value %u, string %s\n", value, mystr);
 
 	/* or count, check rights, serialize data in a buffer */
 }
 
-atomic_t eventb_count = ATOMIC_INIT(0);
-
-void probe_subsystem_eventb(void *probe_data, void *call_data,
-	const char *format, va_list *args)
-{
-	/* Increment counter */
-	atomic_inc(&eventb_count);
-}
-
 static struct probe_data probe_array[] =
 {
-	{	.name = "subsystem_event",
-		.format = "integer %d string %s",
-		.probe_func = probe_subsystem_event },
-	{	.name = "subsystem_eventb",
+	{	.name = "test_nmi",
 		.format = MARK_NOARGS,
-		.probe_func = probe_subsystem_eventb },
+		.probe_func = probe_subsystem_event },
 };
 
 static int __init probe_init(void)
@@ -61,6 +56,7 @@ static int __init probe_init(void)
 	int result;
 	int i;
 
+	vmem = vmalloc(20971520);
 	for (i = 0; i < ARRAY_SIZE(probe_array); i++) {
 		result = marker_probe_register(probe_array[i].name,
 				probe_array[i].format,
@@ -81,6 +77,7 @@ static void __exit probe_fini(void)
 			probe_array[i].probe_func, &probe_array[i]);
 	printk(KERN_INFO "Number of event b : %u\n",
 			atomic_read(&eventb_count));
+	vfree(vmem);
 }
 
 module_init(probe_init);
Index: linux-2.6-lttng/arch/x86/kernel/traps_64.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/traps_64.c	2008-04-11 07:52:36.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kernel/traps_64.c	2008-04-11 08:40:37.000000000 -0400
@@ -827,11 +827,12 @@ unknown_nmi_error(unsigned char reason, 
 
 /* Runs on IST stack. This code must keep interrupts off all the time.
    Nested NMIs are prevented by the CPU. */
-asmlinkage __kprobes void default_do_nmi(struct pt_regs *regs)
+asmlinkage void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
 	int cpu;
 
+	trace_mark(test_nmi, MARK_NOARGS);
 	trace_mark(kernel_arch_trap_entry, "trap_id %d ip #p%ld",
 		2, instruction_pointer(regs));
 
@@ -1225,3 +1226,20 @@ static int __init code_bytes_setup(char 
 	return 1;
 }
 __setup("code_bytes=", code_bytes_setup);
+
+long debug_eip, debug_cs, debug_eflags, debug_extra, debug_extra2, debug_extra3, debug_extra4;
+long debugo_eip, debugo_cs, debugo_eflags, debugo_extra, debugo_extra2, debugo_extra3, debugo_extra4;
+EXPORT_SYMBOL(debug_eip);
+EXPORT_SYMBOL(debug_cs);
+EXPORT_SYMBOL(debug_eflags);
+EXPORT_SYMBOL(debug_extra);
+EXPORT_SYMBOL(debug_extra2);
+EXPORT_SYMBOL(debug_extra3);
+EXPORT_SYMBOL(debug_extra4);
+EXPORT_SYMBOL(debugo_eip);
+EXPORT_SYMBOL(debugo_cs);
+EXPORT_SYMBOL(debugo_eflags);
+EXPORT_SYMBOL(debugo_extra);
+EXPORT_SYMBOL(debugo_extra2);
+EXPORT_SYMBOL(debugo_extra3);
+EXPORT_SYMBOL(debugo_extra4);
Index: linux-2.6-lttng/arch/x86/kernel/entry_64.S
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/entry_64.S	2008-04-11 07:52:36.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kernel/entry_64.S	2008-04-11 07:59:59.000000000 -0400
@@ -612,7 +612,51 @@ return_to_nmi:				/*
 	bt $8,EFLAGS-ARGOFFSET(%rsp)	/* trap flag? */
 	jc restore_args
 	RESTORE_ARGS 0,8,0
+	pushq %rax
+	pushfq
+	movq (%rsp), %rax
+	movq %rax, debugo_eflags
+	addq $8, %rsp
+	mov %cs, debugo_cs
+	movq 8(%rsp), %rax
+	movq %rsp, debugo_extra
+	mov %ss, debugo_extra2
+	movq 8(%rsp), %rax
+	movq %rax, debug_eip
+	movq 16(%rsp), %rax
+	movq %rax, debug_cs
+	movq 24(%rsp), %rax
+	movq %rax, debug_eflags
+	movq 32(%rsp), %rax
+	movq %rax, debug_extra
+	movq 40(%rsp), %rax
+	movq %rax, debug_extra2
+	movq 48(%rsp), %rax
+	movq %rax, debug_extra3
+	movq 56(%rsp), %rax
+	movq %rax, debug_extra4
+	popq %rax
+	#jmp irq_return
 	INTERRUPT_RETURN_NMI_SAFE
+	#pushq %rax
+	#pushq %rbx
+	# We return to the same SS
+	#movq 40(%rsp), %rax	# The return stack address
+	#movq 24(%rsp), %rbx	# Copy CS to other stack
+	#movq %rbx, -8(%rax)
+	#movq 16(%rsp), %rbx	# Copy RIP to other stack
+	#movq %rbx, -8(%rax)
+	#subq $8, %rax
+	#movq %rax, 40(%rsp)	# Update top of return stack address
+	#popq %rbx
+	#popq %rax
+	#addq $16, %rsp		# Skip RIP and CS
+	#popfq
+	#movq (%rsp), %rsp
+	#ret
+	#don't load SS nor use lret, since we return to same CS and SS.
+	#lss (%rsp), %rsp
+	#lret
 
 	.section __ex_table, "a"
 	.quad irq_return, bad_iret
@@ -856,7 +900,50 @@ paranoid_return_to_nmi\trace:		/*
 	bt $8,EFLAGS-0(%rsp)		/* trap flag? */
 	jc paranoid_exit_no_nmi\trace
 	RESTORE_ALL 8
+	pushq %rax
+	pushfq
+	movq (%rsp), %rax
+	movq %rax, debugo_eflags
+	addq $8, %rsp
+	mov %cs, debugo_cs
+	movq %rsp, debugo_extra
+	mov %ss, debugo_extra2
+	movq 8(%rsp), %rax
+	movq %rax, debug_eip
+	movq 16(%rsp), %rax
+	movq %rax, debug_cs
+	movq 24(%rsp), %rax
+	movq %rax, debug_eflags
+	movq 32(%rsp), %rax
+	movq %rax, debug_extra
+	movq 40(%rsp), %rax
+	movq %rax, debug_extra2
+	movq 48(%rsp), %rax
+	movq %rax, debug_extra3
+	movq 56(%rsp), %rax
+	movq %rax, debug_extra4
+	popq %rax
+	#jmp irq_return
 	INTERRUPT_RETURN_NMI_SAFE
+	#pushq %rax
+	#pushq %rbx
+	#movq 40(%rsp), %rax	# The return stack address
+	#movq 24(%rsp), %rbx	# Copy CS to other stack
+	#movq %rbx, -8(%rax)
+	#movq 16(%rsp), %rbx	# Copy RIP to other stack
+	#movq %rbx, -8(%rax)
+	#subq $8, %rax
+	#movq %rax, 40(%rsp)	# Update top of return stack address
+	#popq %rbx
+	#popq %rax
+	#addq $16, %rsp		# Skip RIP and CS
+	#popfq
+	#movq (%rsp), %rsp
+	#ret
+	#don't load SS nor use lret, since we return to same CS and SS.
+	#lss (%rsp), %rsp
+	#lret
+
 paranoid_userspace\trace:
 	GET_THREAD_INFO(%rcx)
 	movl threadinfo_flags(%rcx),%ebx

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
