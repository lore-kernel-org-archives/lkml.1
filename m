Return-Path: <linux-kernel-owner+w=401wt.eu-S933492AbYEBJp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492AbYEBJp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 05:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759006AbYEBJpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 05:45:46 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:35726 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757927AbYEBJpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 05:45:45 -0400
Date: Fri, 2 May 2008 11:45:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       sandeen@sandeen.net
Subject: Re: [PATCH] i386: Execute stack overflow warning on interrupt stack II
Message-ID: <20080502094543.GA11114@basil.nowhere.org>
References: <20080502091806.GA26062@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080502091806.GA26062@basil.nowhere.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 02 May 2008 09:38:48.0796 (UTC) FILETIME=[52D5F9C0:01C8AC38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 11:18:06AM +0200, Andi Kleen wrote:
> i386: Execute stack overflow warning on interrupt stack
[...] Sorry the earlier patch was unrefreshed with a dumb typo. Correct
version appended.

---
i386: Execute stack overflow warning on interrupt stack

[Repost. This was posted deep in the 4K flame war some time ago. Probably
very few people read it completely, so the patch was missed.]

Previously the reporting printk would run on the process stack, which risks 
overflow an already low stack. Instead execute it on the interrupt stack.
This makes it more likely for the printk to make it actually out.

It adds one not taken test/branch more to the interrupt path when
stack overflow checking is enabled. We could avoid that by duplicating
more code, but that seemed not worth it.

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
+			: "memory", "cc", "ecx");
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
@@ -127,18 +143,19 @@ unsigned int do_IRQ(struct pt_regs *regs
 			(irqctx->tinfo.preempt_count & ~SOFTIRQ_MASK) |
 			(curctx->tinfo.preempt_count & SOFTIRQ_MASK);
 
-		asm volatile(
-			"       xchgl  %%ebx,%%esp    \n"
-			"       call   *%%edi         \n"
-			"       movl   %%ebx,%%esp    \n"
-			: "=a" (arg1), "=d" (arg2), "=b" (bx)
-			:  "0" (irq),   "1" (desc),  "2" (isp),
-			   "D" (desc->handle_irq)
-			: "memory", "cc", "ecx"
-		);
+		/* Execute warning on interrupt stack */
+		if (unlikely(overflow))
+			call_on_stack2(stack_overflow, isp, 0, 0);
+
+		call_on_stack2(desc->handle_irq, isp, irq, desc);
 	} else
 #endif
-		desc->handle_irq(irq, desc);
+	{
+		/* AK: Slightly bogus here */
+		if (overflow)
+			stack_overflow();
+ 		desc->handle_irq(irq, desc);
+	}
 
 	irq_exit();
 	set_irq_regs(old_regs);
