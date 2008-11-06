Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbYKFF63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbYKFF63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 00:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbYKFF6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 00:58:21 -0500
Received: from smtp-out.google.com ([216.239.33.17]:29719 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbYKFF6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 00:58:19 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:content-transfer-encoding;
	b=ZeLp/qgKBxYzZItlfUEf3jhX4iPPKJJU6aZddlKWWCIuzUAmBjmVA60/6QhHlNw02
	ErdhAWiqDDWjOo6rluWYQ==
MIME-Version: 1.0
Date: Wed, 5 Nov 2008 21:58:12 -0800
Message-ID: <b040c32a0811052158r4f6662dega3503a0c7ec72620@mail.gmail.com>
Subject: [patch] sched: fix single-depth wchan output
From: Ken Chen <kenchen@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To get a meaningful /proc/<pid>/wchan, one is required to turn on full
frame pointer when compile kernel/sched.c on x86 arch.  The enabling of
frame pointer applies to entire kernel/sched.c and affects lots of other
core scheduler functions that aren't related to wchan's call stack
unwind.  This causes unnecessary expansion of stack pointer push and pop
on the stack for scheduler functions.  To cut down the cost of frame
pointer push/pop, one can use compile time config option 'single-depth
wchan'.  However, the 'single-depth' option is broken on x86 due to lack
of stack frame marker and simple stack unwind doesn't work, i.e., wchan
always produces '0'.

This patch adds call site location explicitly in thread_struct for
schedule() function so that get_wchan() can reliably get the data and at
the same time not to overly burden the entire kernel/sched.c with frame
pointer generation.  The remove of frame pointer dependency allows
compiler to generate better and faster core scheduler code on x86_64.

Signed-off-by: Ken Chen <kenchen@google.com>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e60c59b..9951853 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -34,6 +34,7 @@ config X86
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_GENERIC_DMA_COHERENT if X86_32
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
+	select SCHED_NO_NO_OMIT_FRAME_POINTER

 config ARCH_DEFCONFIG
 	string
@@ -367,7 +368,7 @@ config X86_RDC321X
 config SCHED_NO_NO_OMIT_FRAME_POINTER
 	def_bool y
 	prompt "Single-depth WCHAN output"
-	depends on X86_32
+	depends on X86
 	help
 	  Calculate simpler /proc/<PID>/wchan values. If this option
 	  is disabled then wchan values will recurse back to the
index 5ca01e3..1d2ff70 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -401,6 +401,7 @@ struct thread_struct {
 	unsigned long		ip;
 	unsigned long		fs;
 	unsigned long		gs;
+	unsigned long		wchan;
 	/* Hardware debugging registers: */
 	unsigned long		debugreg0;
 	unsigned long		debugreg1;
@@ -603,6 +604,12 @@ extern void release_thread(struct task_struct *);
 extern void prepare_to_copy(struct task_struct *tsk);

 unsigned long get_wchan(struct task_struct *p);
+#define set_wchan(task, ip) do { (task)->thread.wchan = (ip); } while (0)
+#define set_wchan_cond(task, ip) do {			\
+	unsigned long *__wchan = &(task)->thread.wchan;	\
+	if (!__wchan)					\
+		*__wchan = (ip);			\
+} while (0)

 /*
  * Generic CPUID function
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 0a1302f..ba02359 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -697,26 +697,10 @@ out:

 unsigned long get_wchan(struct task_struct *p)
 {
-	unsigned long bp, sp, ip;
-	unsigned long stack_page;
-	int count = 0;
 	if (!p || p == current || p->state == TASK_RUNNING)
 		return 0;
-	stack_page = (unsigned long)task_stack_page(p);
-	sp = p->thread.sp;
-	if (!stack_page || sp < stack_page || sp > top_esp+stack_page)
-		return 0;
-	/* include/asm-i386/system.h:switch_to() pushes bp last. */
-	bp = *(unsigned long *) sp;
-	do {
-		if (bp < stack_page || bp > top_ebp+stack_page)
-			return 0;
-		ip = *(unsigned long *) (bp+4);
-		if (!in_sched_functions(ip))
-			return ip;
-		bp = *(unsigned long *) bp;
-	} while (count++ < 16);
-	return 0;
+
+	return p->thread.wchan;
 }

 unsigned long arch_align_stack(unsigned long sp)
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index c958120..222029b 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -739,26 +739,10 @@ asmlinkage long sys_vfork(struct pt_regs *regs)

 unsigned long get_wchan(struct task_struct *p)
 {
-	unsigned long stack;
-	u64 fp, ip;
-	int count = 0;
-
 	if (!p || p == current || p->state == TASK_RUNNING)
 		return 0;
-	stack = (unsigned long)task_stack_page(p);
-	if (p->thread.sp < stack || p->thread.sp >= stack+THREAD_SIZE)
-		return 0;
-	fp = *(u64 *)(p->thread.sp);
-	do {
-		if (fp < (unsigned long)stack ||
-		    fp >= (unsigned long)stack+THREAD_SIZE)
-			return 0;
-		ip = *(u64 *)(fp+8);
-		if (!in_sched_functions(ip))
-			return ip;
-		fp = *(u64 *)fp;
-	} while (count++ < 16);
-	return 0;
+
+	return p->thread.wchan;
 }

 long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b483f39..82f0b11 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -324,6 +324,11 @@ extern char __sched_text_start[], __sched_text_end[];
 /* Is this address in the __sched functions? */
 extern int in_sched_functions(unsigned long addr);

+#ifndef set_wchan
+#define set_wchan(task, ip)
+#define set_wchan_cond(task, ip)
+#endif
+
 #define	MAX_SCHEDULE_TIMEOUT	LONG_MAX
 extern signed long schedule_timeout(signed long timeout);
 extern signed long schedule_timeout_interruptible(signed long timeout);
diff --git a/kernel/sched.c b/kernel/sched.c
index e8819bc..48b0965 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4477,6 +4477,7 @@ need_resched_nonpreemptible:
 		rq->curr = next;
 		++*switch_count;

+		set_wchan_cond(prev, _RET_IP_);
 		context_switch(rq, prev, next); /* unlocks the rq */
 		/*
 		 * the context switch might have flipped the stack from under
@@ -4487,6 +4488,7 @@ need_resched_nonpreemptible:
 	} else
 		spin_unlock_irq(&rq->lock);

+	set_wchan(current, 0);
 	if (unlikely(reacquire_kernel_lock(current) < 0))
 		goto need_resched_nonpreemptible;

@@ -4514,6 +4516,7 @@ asmlinkage void __sched preempt_schedule(void)
 		return;

 	do {
+		set_wchan(current, _RET_IP_);
 		add_preempt_count(PREEMPT_ACTIVE);
 		schedule();
 		sub_preempt_count(PREEMPT_ACTIVE);
@@ -4541,6 +4544,7 @@ asmlinkage void __sched preempt_schedule_irq(void)
 	BUG_ON(ti->preempt_count || !irqs_disabled());

 	do {
+		set_wchan(current, _RET_IP_);
 		add_preempt_count(PREEMPT_ACTIVE);
 		local_irq_enable();
 		schedule();
@@ -5547,6 +5551,7 @@ asmlinkage long sys_sched_yield(void)
 	_raw_spin_unlock(&rq->lock);
 	preempt_enable_no_resched();

+	set_wchan(current, _RET_IP_);
 	schedule();

 	return 0;
@@ -5563,6 +5568,7 @@ static void __cond_resched(void)
 	 * cond_resched() call.
 	 */
 	do {
+		set_wchan(current, _RET_IP_);
 		add_preempt_count(PREEMPT_ACTIVE);
 		schedule();
 		sub_preempt_count(PREEMPT_ACTIVE);
@@ -5646,6 +5652,7 @@ void __sched io_schedule(void)

 	delayacct_blkio_start();
 	atomic_inc(&rq->nr_iowait);
+	set_wchan(current, _RET_IP_);
 	schedule();
 	atomic_dec(&rq->nr_iowait);
 	delayacct_blkio_end();
diff --git a/kernel/timer.c b/kernel/timer.c
index 56becf3..72def2f 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1182,6 +1182,7 @@ signed long __sched schedule_timeout
 	struct timer_list timer;
 	unsigned long expire;

+	set_wchan(current, _RET_IP_);
 	switch (timeout)
 	{
 	case MAX_SCHEDULE_TIMEOUT:
