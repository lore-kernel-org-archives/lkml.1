Return-Path: <linux-kernel-owner+w=401wt.eu-S1759522AbYHHXiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522AbYHHXiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 19:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbYHHXiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 19:38:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56418 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbYHHXiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 19:38:05 -0400
Date: Fri, 8 Aug 2008 19:38:01 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
In-Reply-To: <20080808190506.GD11376@Krystal>
Message-ID: <alpine.DEB.1.10.0808081750590.16691@gandalf.stny.rr.com>
References: <20080807182013.984175558@goodmis.org> <20080807184741.GB18164@Krystal> <alpine.DEB.1.10.0808071639420.9449@gandalf.stny.rr.com> <20080808172259.GB8244@Krystal> <alpine.DEB.1.10.0808081334010.4436@gandalf.stny.rr.com> <20080808174607.GG8244@Krystal>
 <alpine.DEB.1.10.0808081410380.6116@gandalf.stny.rr.com> <20080808182104.GA11376@Krystal> <alpine.DEB.1.10.0808081432400.8922@gandalf.stny.rr.com> <20080808190506.GD11376@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ patch included ]

On Fri, 8 Aug 2008, Mathieu Desnoyers wrote:

> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > > That's why I use kstop_machine.
> > > > 
> > > 
> > > kstop_machine does not guarantee that you won't have _any_ thread
> > > preempted with IP pointing exactly in the middle of your instructions
> > > _before_ the modification scheduled back in _after_ the modification and
> > > thus causing an illegal instruction.
> > > 
> > > Still buggy. :/
> > 
> > Hmm, good point. Unless...
> > 
> > Can a processor be preempted in a middle of nops?  What do nops do for a 
> > processor? Can it skip them nicely in one shot?
> > 
> 
> Given that those are multiple instructions, I think a processor has all
> the rights to preempt in the middle of them. And even if some specific
> architecture, for any obscure reason, happens to merge them, I don't
> think this will be portable across Intel, AMD, ...
> 
> > This means I'll have to do the benchmarks again, and see what the 
> > performance difference of a jmp and a nop is significant. I'm thinking 
> > that if the processor can safely skip nops without any type of processing, 
> > this may be the reason that nops are better than a jmp. A jmp causes the 
> > processor to do a little more work.
> > 
> > I might even run a test to see if I can force a processor that uses the 
> > three-two nops to preempt between them.
> > 
> 
> Yup, although one architecture not triggering this doesn't say much
> about the various x86 flavors out there. In any case
> - if you trigger the problem, we have to fix it.
> - if you do not succeed to trigger the problem, we will have to test it
>   on a wider architecture range and maybe end up fixit it anyway to play
>   safe with the specs.
> 
> So, in every case, we end up fixing the issue.
> 
> 
> > I can add a test in x86 ftrace.c to check to see which nop was used, and 
> > use the jmp if the arch does not have a 5 byte nop.
> > 
> 
> I would propose the following alternative :
> 
> Create new macros in include/asm-x86/nops.h :
> 
> /* short jump, offset 3 bytes : skips total of 5 bytes */
> #define GENERIC_ATOMIC_NOP5 ".byte 0xeb,0x03,0x00,0x00,0x00\n"
> 
> #if defined(CONFIG_MK7)
> #define ATOMIC_NOP5 GENERIC_ATOMIC_NOP5
> #elif defined(CONFIG_X86_P6_NOP)
> #define ATOMIC_NOP5 P6_NOP5
> #elif defined(CONFIG_X86_64)
> #define ATOMIC_NOP5 GENERIC_ATOMIC_NOP5
> #else
> #define ATOMIC_NOP5 GENERIC_ATOMIC_NOP5
> #endif
> 
> And then optimize if necessary. You will probably find plenty of
> knowledgeable people who will know better 5-bytes nop instruction more
> efficient than this "generic" short jump offset 0x3.
> 
> Then you can use the (buggy) 3nops/2nops as a performance baseline and
> see the performance hit on each architecture.
> 
> First get it right, then make it fast....
> 

I'm stubborn, I want to get it right _and_ keep it fast.

I still want the NOPS. Using jmps will hurt performance and that would 
keep this turned off on all distros.

But lets think outside the box here (and we will ignore Alan's cat).

Right now the issue is that we might preempt after the first nop, and when 
we enable the code, that task will crash when it tries to read the second 
nop.

Since we are doing the modifications from kstop_machine, all the tasks are 
stopped. We can simply look to see if the tasks have been preempted in 
kernel space and if so, is their instruction pointer pointing to the 
second nop. If it is, move the ip forward.

Here's a patch that does just that for both i386 and x86_64.

I added a field in the thread_info struct called "ip". This is a pointer 
to the location of the task ip in the stack if it was preempted in kernel 
space. Null otherwise:

         jz restore_all
 +       lea PT_EIP(%esp), %eax
 +       movl %eax, TI_ip(%ebp)
         call preempt_schedule_irq
 +       GET_THREAD_INFO(%ebp)
 +       movl $0, TI_ip(%ebp)
         jmp need_resched


Then, just before we enable tracing (we only need to do this when we 
enable tracing, since that is when we have a two instruction nop), we look 
at all the tasks. If the task->thread_info->ip is set, this means that it
was preempted just before going back to the kernel.

We look at the **ip and see if it compares with the second nop. If it 
does, we increment the ip by the size of that nop:

               if (memcmp(*ip, second_nop, x86_nop5_part2) == 0)
                       /* Match, move the ip forward */
                       *ip += x86_nop5_part2;



We do this just once before enabling all the locations, and we only do it 
if we have a two part nop.

Interesting enough, I wrote a module that did the following:

void (*silly_func)(void);

void do_something_silly(void)
{
}


static int my_thread(void *arg)
{
        int i;
        while (!kthread_should_stop()) {
                for (i=0; i < 100; i++)
                        silly_func();
        }
        return 0;
}

static struct task_struct *p;

static int __init mcount_stress_init(void)
{
        silly_func = do_something_silly;
        p = kthread_run(my_thread, NULL, "sillytask");
        return 0;
}

static void mcount_stress_exit(void)
{
        kthread_stop(p);
}



The do_something_silly had an mcount pointer to it. I put in printks in 
the ftrace enabled code to see where this was preempted. It was preempted 
several times before and after the nops, but never at either nop.

Maybe I didn't run it enough (almost 2 hours), but perhaps it is very 
unlikely to be preempted at a nop if there's something coming up next.

Yes a string of nops may be preempted, but perhaps only two nops followed 
by an actual command might be skipped quickly.

I'll write some hacks to look at where it is preempted in the scheduler 
itself, and see if I see it preempting at the second nop ever.

But here's a patch that will work around the problem that we might be 
preempted within the two nops.

Note, this is only in the slow path of enabling the function tracer. It is 
only done at enabling time inside the kstop_machine, which has a large 
overhead anyways.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/alternative.c    |   29 +++++++++++++++++++-------
 arch/x86/kernel/asm-offsets_32.c |    1 
 arch/x86/kernel/asm-offsets_64.c |    1 
 arch/x86/kernel/entry_32.S       |    4 +++
 arch/x86/kernel/entry_64.S       |    4 +++
 arch/x86/kernel/ftrace.c         |   43 +++++++++++++++++++++++++++++++++++++++
 include/asm-x86/ftrace.h         |    5 ++++
 include/asm-x86/thread_info.h    |    4 +++
 kernel/trace/ftrace.c            |   12 ++++++++++
 9 files changed, 96 insertions(+), 7 deletions(-)

Index: linux-tip.git/arch/x86/kernel/alternative.c
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/alternative.c	2008-06-05 11:52:24.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/alternative.c	2008-08-08 16:20:23.000000000 -0400
@@ -140,13 +140,26 @@ static const unsigned char *const p6_nop
 };
 #endif
 
+/*
+ * Some versions of x86 CPUs have a two part NOP5. This
+ * can break ftrace if a process is preempted between
+ * the two. ftrace needs to know what the second nop
+ * is to handle this case.
+ */
+int x86_nop5_part2;
+
 #ifdef CONFIG_X86_64
 
 extern char __vsyscall_0;
 const unsigned char *const *find_nop_table(void)
 {
-	return boot_cpu_data.x86_vendor != X86_VENDOR_INTEL ||
-	       boot_cpu_data.x86 < 6 ? k8_nops : p6_nops;
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL ||
+	    boot_cpu_data.x86 < 6) {
+		x86_nop5_part2 = 2; /* K8_NOP2 */
+		return k8_nops;
+	} else
+		/* keep k86_nop5_part2 NULL */
+		return p6_nops;
 }
 
 #else /* CONFIG_X86_64 */
@@ -154,12 +167,13 @@ const unsigned char *const *find_nop_tab
 static const struct nop {
 	int cpuid;
 	const unsigned char *const *noptable;
+	int nop5_part2; /* size of part2 nop */
 } noptypes[] = {
-	{ X86_FEATURE_K8, k8_nops },
-	{ X86_FEATURE_K7, k7_nops },
-	{ X86_FEATURE_P4, p6_nops },
-	{ X86_FEATURE_P3, p6_nops },
-	{ -1, NULL }
+	{ X86_FEATURE_K8, k8_nops, 2},
+	{ X86_FEATURE_K7, k7_nops, 1 },
+	{ X86_FEATURE_P4, p6_nops, 0 },
+	{ X86_FEATURE_P3, p6_nops, 0 },
+	{ -1, NULL, 0 }
 };
 
 const unsigned char *const *find_nop_table(void)
@@ -170,6 +184,7 @@ const unsigned char *const *find_nop_tab
 	for (i = 0; noptypes[i].cpuid >= 0; i++) {
 		if (boot_cpu_has(noptypes[i].cpuid)) {
 			noptable = noptypes[i].noptable;
+			x86_nop5_part2 = noptypes[i].nop5_part2;
 			break;
 		}
 	}
Index: linux-tip.git/arch/x86/kernel/asm-offsets_32.c
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/asm-offsets_32.c	2008-07-27 10:43:26.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/asm-offsets_32.c	2008-08-08 15:46:55.000000000 -0400
@@ -59,6 +59,7 @@ void foo(void)
 	OFFSET(TI_restart_block, thread_info, restart_block);
 	OFFSET(TI_sysenter_return, thread_info, sysenter_return);
 	OFFSET(TI_cpu, thread_info, cpu);
+	OFFSET(TI_ip, thread_info, ip);
 	BLANK();
 
 	OFFSET(GDS_size, desc_ptr, size);
Index: linux-tip.git/arch/x86/kernel/asm-offsets_64.c
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/asm-offsets_64.c	2008-07-27 10:43:26.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/asm-offsets_64.c	2008-08-08 15:52:34.000000000 -0400
@@ -41,6 +41,7 @@ int main(void)
 	ENTRY(addr_limit);
 	ENTRY(preempt_count);
 	ENTRY(status);
+	ENTRY(ip);
 #ifdef CONFIG_IA32_EMULATION
 	ENTRY(sysenter_return);
 #endif
Index: linux-tip.git/arch/x86/kernel/entry_32.S
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/entry_32.S	2008-07-27 10:43:26.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/entry_32.S	2008-08-08 17:13:27.000000000 -0400
@@ -304,7 +304,11 @@ need_resched:
 	jz restore_all
 	testl $X86_EFLAGS_IF,PT_EFLAGS(%esp)	# interrupts off (exception path) ?
 	jz restore_all
+	lea PT_EIP(%esp), %eax
+	movl %eax, TI_ip(%ebp)
 	call preempt_schedule_irq
+	GET_THREAD_INFO(%ebp)
+	movl $0, TI_ip(%ebp)
 	jmp need_resched
 END(resume_kernel)
 #endif
Index: linux-tip.git/arch/x86/kernel/entry_64.S
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/entry_64.S	2008-07-27 10:43:26.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/entry_64.S	2008-08-08 17:12:47.000000000 -0400
@@ -837,7 +837,11 @@ ENTRY(retint_kernel)
 	jnc  retint_restore_args
 	bt   $9,EFLAGS-ARGOFFSET(%rsp)	/* interrupts off? */
 	jnc  retint_restore_args
+	leaq RIP-ARGOFFSET(%rsp), %rax
+	movq %rax, TI_ip(%rcx)
 	call preempt_schedule_irq
+	GET_THREAD_INFO(%rcx)
+	movq $0, TI_ip(%rcx)
 	jmp exit_intr
 #endif	
 
Index: linux-tip.git/arch/x86/kernel/ftrace.c
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/ftrace.c	2008-06-26 14:58:54.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/ftrace.c	2008-08-08 17:48:04.000000000 -0400
@@ -127,6 +127,46 @@ notrace int ftrace_mcount_set(unsigned l
 	return 0;
 }
 
+static const unsigned char *second_nop;
+
+void arch_ftrace_pre_enable(void)
+{
+	struct task_struct *g, *p;
+	unsigned long **ip;
+
+	int i;
+
+	if (!second_nop)
+		return;
+
+	/*
+	 * x86 has a two part nop to handle 5 byte instructions.
+	 * If a task was preempted after the first nop, and has
+	 * not ran the second nop, if we modify the code, we can
+	 * crash the system. Thus, we will look at all the tasks
+	 * and if any of them was preempted and will run the
+	 * second nop next, we simply move their ip pointer past
+	 * the second nop.
+	 */
+
+	/*
+	 * Don't need to grab the task list lock, we are running
+	 * in kstop_machine
+	 */
+	do_each_thread(g, p) {
+		/*
+		 * In entry.S we save the ip when a task is preempted
+		 * and reset it when it is back running.
+		 */
+		ip = task_thread_info(p)->ip;
+		if (!ip)
+			continue;
+		if (memcmp(*ip, second_nop, x86_nop5_part2) == 0)
+			/* Match, move the ip forward */
+			*ip += x86_nop5_part2;
+	} while_each_thread(g, p);
+}
+
 int __init ftrace_dyn_arch_init(void *data)
 {
 	const unsigned char *const *noptable = find_nop_table();
@@ -137,5 +177,8 @@ int __init ftrace_dyn_arch_init(void *da
 
 	ftrace_nop = (unsigned long *)noptable[MCOUNT_INSN_SIZE];
 
+	if (x86_nop5_part2)
+		second_nop = noptable[x86_nop5_part2];
+
 	return 0;
 }
Index: linux-tip.git/include/asm-x86/ftrace.h
===================================================================
--- linux-tip.git.orig/include/asm-x86/ftrace.h	2008-08-08 13:00:51.000000000 -0400
+++ linux-tip.git/include/asm-x86/ftrace.h	2008-08-08 16:41:09.000000000 -0400
@@ -17,6 +17,11 @@ static inline unsigned long ftrace_call_
 	 */
 	return addr - 1;
 }
+
+extern int x86_nop5_part2;
+extern void arch_ftrace_pre_enable(void);
+#define ftrace_pre_enable arch_ftrace_pre_enable
+
 #endif
 
 #endif /* CONFIG_FTRACE */
Index: linux-tip.git/include/asm-x86/thread_info.h
===================================================================
--- linux-tip.git.orig/include/asm-x86/thread_info.h	2008-08-07 11:14:43.000000000 -0400
+++ linux-tip.git/include/asm-x86/thread_info.h	2008-08-08 17:06:15.000000000 -0400
@@ -29,6 +29,9 @@ struct thread_info {
 	__u32			cpu;		/* current CPU */
 	int			preempt_count;	/* 0 => preemptable,
 						   <0 => BUG */
+	unsigned long		**ip;		/* pointer to ip on stackwhen
+						   preempted
+						*/
 	mm_segment_t		addr_limit;
 	struct restart_block    restart_block;
 	void __user		*sysenter_return;
@@ -47,6 +50,7 @@ struct thread_info {
 	.flags		= 0,			\
 	.cpu		= 0,			\
 	.preempt_count	= 1,			\
+	.ip		= NULL,			\
 	.addr_limit	= KERNEL_DS,		\
 	.restart_block = {			\
 		.fn = do_no_restart_syscall,	\
Index: linux-tip.git/kernel/trace/ftrace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ftrace.c	2008-08-08 13:00:52.000000000 -0400
+++ linux-tip.git/kernel/trace/ftrace.c	2008-08-08 16:18:14.000000000 -0400
@@ -32,6 +32,10 @@
 
 #include "trace.h"
 
+#ifndef ftrace_pre_enable
+# define ftrace_pre_enable() do { } while (0)
+#endif
+
 /* ftrace_enabled is a method to turn ftrace on or off */
 int ftrace_enabled __read_mostly;
 static int last_ftrace_enabled;
@@ -500,6 +504,14 @@ static void ftrace_replace_code(int enab
 	else
 		new = ftrace_nop_replace();
 
+	/*
+	 * Some archs *cough*x86*cough* have more than one nop to cover
+	 * the call to mcount. In these cases, special care must be taken
+	 * before we start converting nops into calls.
+	 */
+	if (enable)
+		ftrace_pre_enable();
+
 	for (pg = ftrace_pages_start; pg; pg = pg->next) {
 		for (i = 0; i < pg->index; i++) {
 			rec = &pg->records[i];
