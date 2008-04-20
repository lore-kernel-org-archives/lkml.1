Return-Path: <linux-kernel-owner+w=401wt.eu-S1762122AbYDTMh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762122AbYDTMh6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 08:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756801AbYDTMhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 08:37:37 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:40949 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbYDTMhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 08:37:36 -0400
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
From: Andi Kleen <andi@firstfloor.org>
References: <200804181737.m3IHbabI010051@hera.kernel.org>
	<20080418142934.38ce6bf4.akpm@linux-foundation.org>
	<20080419142329.GA5339@elte.hu> <480AB88C.1050900@sandeen.net>
Date: Sun, 20 Apr 2008 14:36:38 +0200
In-Reply-To: <480AB88C.1050900@sandeen.net> (Eric Sandeen's message of "Sat, 19 Apr 2008 22:29:16 -0500")
Message-ID: <87prskaejt.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Apr 2008 12:29:50.0893 (UTC) FILETIME=[3A90B5D0:01C8A2E2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen <sandeen@sandeen.net> writes:
>
> CONFIG_DEBUG_STACKOVERFLOW isn't ery useful because the warning printk
> it generates uses the remaining amount of stack, and tips the box.

That could be easily fixed by executing the printk on the interrupt
stack on i386.  Currently it is before the stack switch which is wrong
agreed. On x86-64 it should already execute on the interrupt stack. Or
perhaps it would be better to just move the stack switch on i386 into
entry.S too similar to 64bit.

That wouldn't help without interrupt stacks of course, but these
should be always on anyways even with 8k stacks.

Experimental patch appended to do this.

-Andi

---

i386: Execute stack overflow warning on interrupt stack

Previously it would run on the process stack, which risks overflow
an already low stack. Instead execute it on the interrupt stack.

Based on an observation by Eric Sandeen.

Signed-off-by: Andi Kleen <andi@firstfloor.org>

Index: linux/arch/x86/kernel/irq_32.c
===================================================================
--- linux.orig/arch/x86/kernel/irq_32.c
+++ linux/arch/x86/kernel/irq_32.c
@@ -61,6 +61,26 @@ static union irq_ctx *hardirq_ctx[NR_CPU
 static union irq_ctx *softirq_ctx[NR_CPUS] __read_mostly;
 #endif
 
+static void stack_overflow(void)
+{
+	printk("low stack detected by irq handler\n");
+	dump_stack();
+}
+
+static inline void call_on_stack2(void *func, unsigned long stack,
+			   unsigned long arg1, unsigned long arg2)
+{
+	unsigned long bx;
+	asm volatile(
+			"       xchgl  %%ebx,%%esp    \n"
+			"       call   *%%edi         \n"
+			"       movl   %%ebx,%%esp    \n"
+			: "=a" (arg1), "=d" (arg2), "=b" (bx)
+			:  "0" (arg1),   "1" (arg2),  "2" (stack),
+			   "D" (func)
+			: "memory", "cc");
+}
+
 /*
  * do_IRQ handles all normal device IRQ's (the special
  * SMP cross-CPU interrupts have their own specific
@@ -76,6 +96,7 @@ unsigned int do_IRQ(struct pt_regs *regs
 	union irq_ctx *curctx, *irqctx;
 	u32 *isp;
 #endif
+	int overflow = 0;
 
 	if (unlikely((unsigned)irq >= NR_IRQS)) {
 		printk(KERN_EMERG "%s: cannot handle IRQ %d\n",
@@ -92,11 +113,8 @@ unsigned int do_IRQ(struct pt_regs *regs
 
 		__asm__ __volatile__("andl %%esp,%0" :
 					"=r" (sp) : "0" (THREAD_SIZE - 1));
-		if (unlikely(sp < (sizeof(struct thread_info) + STACK_WARN))) {
-			printk("do_IRQ: stack overflow: %ld\n",
-				sp - sizeof(struct thread_info));
-			dump_stack();
-		}
+		if (unlikely(sp < (sizeof(struct thread_info) + STACK_WARN)))
+			overflow = 1;
 	}
 #endif
 
@@ -112,8 +130,6 @@ unsigned int do_IRQ(struct pt_regs *regs
 	 * current stack (which is the irq stack already after all)
 	 */
 	if (curctx != irqctx) {
-		int arg1, arg2, bx;
-
 		/* build the stack frame on the IRQ stack */
 		isp = (u32*) ((char*)irqctx + sizeof(*irqctx));
 		irqctx->tinfo.task = curctx->tinfo.task;
@@ -127,18 +143,20 @@ unsigned int do_IRQ(struct pt_regs *regs
 			(irqctx->tinfo.preempt_count & ~SOFTIRQ_MASK) |
 			(curctx->tinfo.preempt_count & SOFTIRQ_MASK);
 
-		asm volatile(
-			"       xchgl  %%ebx,%%esp    \n"
-			"       call   *%%edi         \n"
-			"       movl   %%ebx,%%esp    \n"
-			: "=a" (arg1), "=d" (arg2), "=b" (bx)
-			:  "0" (irq),   "1" (desc),  "2" (isp),
-			   "D" (desc->handle_irq)
-			: "memory", "cc"
-		);
+		/* Execute warning on interrupt stack */
+		if (unlikely(overflow))
+			call_on_stack2(stack_overflow, isp, 0, 0);
+
+		call_on_stack2(desc->handle_irq, isp, irq, desc);
+
 	} else
 #endif
+	{
+		/* AK: Slightly bogus here */
+		if (overflow)
+			stack_overflow();
 		desc->handle_irq(irq, desc);
+	}
 
 	irq_exit();
 	set_irq_regs(old_regs);
