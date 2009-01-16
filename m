Return-Path: <linux-kernel-owner+w=401wt.eu-S933236AbZAPM0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236AbZAPM0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 07:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757670AbZAPM0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 07:26:36 -0500
Received: from oceanic.CalvaEDI.COM ([81.252.197.184]:63606 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622AbZAPM0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 07:26:35 -0500
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jan 2009 07:26:34 EST
Message-ID: <49707BA9.1040102@Calva.COM>
Date: Fri, 16 Jan 2009 13:20:57 +0100
From: John Hughes <john@Calva.COM>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: A patch to arch/i386/kernel/irq.c to help get backtraces of (near)
 stack overflow situations
Content-Type: multipart/mixed;
 boundary="------------000902060702010105070300"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000902060702010105070300
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I'm working on a system that is using a bit too much stack to work 
reliably with 4K stacks (OpenSSI with DRBD for the root filesystem 
replication) and I find that the CONFIG_DEBUG_STACKOVERFLOW stuff works 
rather poorly - often the stack dump will cause a stack overflow itself.

Here's a little patch to irq.c to make stack overflow dumps use a 
separate stack.

It's based on 2.6.12 'cos that's how out of date I am.  :-)

Maybe it'll be of use to someone.

Please CC john@calva.com with any comments, I'm not subscribed to the list.

--------------000902060702010105070300
Content-Type: text/x-patch;
 name="arch-i386-kernel-irq.c-overflow.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="arch-i386-kernel-irq.c-overflow.patch"

--- linux/arch/i386/kernel/irq.c	2005-06-17 21:48:29.000000000 +0200
+++ linux-ssi/arch/i386/kernel/irq.c	2009-01-15 13:09:45.000000000 +0100
@@ -41,6 +41,23 @@
 
 static union irq_ctx *hardirq_ctx[NR_CPUS];
 static union irq_ctx *softirq_ctx[NR_CPUS];
+#ifdef CONFIG_DEBUG_STACKOVERFLOW
+static union irq_ctx *overflow_ctx[NR_CPUS];
+#endif
+#ifdef	CONFIG_KDB
+const char *kdba_irq_ctx_type(int cpu, struct thread_info *tinfo)
+{
+	if (tinfo == &hardirq_ctx[cpu]->tinfo)
+		return "hardirq_ctx";
+	if (tinfo == &softirq_ctx[cpu]->tinfo)
+		return "softirq_ctx";
+#ifdef CONFIG_DEBUG_STACKOVERFLOW
+	if (tinfo == &overflow_ctx[cpu]->tinfo)
+		return "overflow_ctx";
+#endif
+	return NULL;
+}
+#endif	/* CONFIG_KDB */
 #endif
 
 /*
@@ -53,6 +70,7 @@
 	/* high bits used in ret_from_ code */
 	int irq = regs->orig_eax & 0xff;
 #ifdef CONFIG_4KSTACKS
+	int arg1, arg2, ebx;
 	union irq_ctx *curctx, *irqctx;
 	u32 *isp;
 #endif
@@ -66,9 +84,38 @@
 		__asm__ __volatile__("andl %%esp,%0" :
 					"=r" (esp) : "0" (THREAD_SIZE - 1));
 		if (unlikely(esp < (sizeof(struct thread_info) + STACK_WARN))) {
+#if CONFIG_4KSTACKS
+			/* use a special stack for overflow warning,
+			   we want to avoid overflowing while telling
+			   the user about the problem! */
+
+			curctx = (union irq_ctx *) current_thread_info();
+			irqctx = overflow_ctx[smp_processor_id()];
+
+			if (curctx == irqctx) {
+				panic("double overflow");
+			}
+			
+			/* build the stack frame on the oflow stack */
+			isp = (u32*) ((char*)irqctx + sizeof(*irqctx));
+			irqctx->tinfo.task = curctx->tinfo.task;
+			irqctx->tinfo.previous_esp = current_stack_pointer;
+
+			asm volatile(
+				"       xchgl   %%ebx,%%esp    \n"
+				"       call    __overflow     \n"
+				"       movl   %%ebx,%%esp     \n"
+				: "=a" (arg1), "=d" (arg2), "=b" (ebx)
+				:  "0" (irq),   "1" (esp),  "2" (isp)
+				: "memory", "cc", "ecx"
+			);
+
+			printk ("Back from overflow\n");
+#else
 			printk("do_IRQ: stack overflow: %ld\n",
 				esp - sizeof(struct thread_info));
 			dump_stack();
+#endif
 		}
 	}
 #endif
@@ -109,6 +156,17 @@
 	return 1;
 }
 
+#ifdef CONFIG_DEBUG_STACKOVERFLOW
+#ifdef CONFIG_4KSTACKS
+static fastcall void __overflow (int irq, long esp)
+{
+	printk("do_IRQ: stack overflow: %ld\n",
+		esp - sizeof(struct thread_info));
+	dump_stack();
+}
+#endif
+#endif
+
 #ifdef CONFIG_4KSTACKS
 
 /*
@@ -121,6 +179,10 @@
 static char hardirq_stack[NR_CPUS * THREAD_SIZE]
 		__attribute__((__aligned__(THREAD_SIZE)));
 
+#ifdef CONFIG_DEBUG_STACKOVERFLOW
+static char overflow_stack[NR_CPUS * THREAD_SIZE]
+		__attribute__((__aligned__(THREAD_SIZE)));
+#endif
 /*
  * allocate per-cpu stacks for hardirq and for softirq processing
  */
@@ -151,6 +213,20 @@
 
 	printk("CPU %u irqstacks, hard=%p soft=%p\n",
 		cpu,hardirq_ctx[cpu],softirq_ctx[cpu]);
+#ifdef CONFIG_DEBUG_STACKOVERFLOW
+
+	irqctx = (union irq_ctx*) &overflow_stack[cpu*THREAD_SIZE];
+	irqctx->tinfo.task              = NULL;
+	irqctx->tinfo.exec_domain       = NULL;
+	irqctx->tinfo.cpu               = cpu;
+	irqctx->tinfo.preempt_count     = HARDIRQ_OFFSET;	/* ? */
+	irqctx->tinfo.addr_limit        = MAKE_MM_SEG(0);
+
+	overflow_ctx[cpu] = irqctx;
+
+	printk("CPU %u irqstacks, overflow=%p\n",
+		cpu,overflow_ctx[cpu]);
+#endif
 }
 
 extern asmlinkage void __do_softirq(void);

--------------000902060702010105070300--
