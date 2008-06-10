Return-Path: <linux-kernel-owner+w=401wt.eu-S1754238AbYFJMdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbYFJMdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 08:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbYFJMdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 08:33:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44781 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbYFJMdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 08:33:04 -0400
Message-Id: <20080610111832.815975131@chello.nl>
References: <20080610111259.766940257@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 10 Jun 2008 13:13:02 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH -rt 3/5] cpu-hotplug: cpu_up vs preempt-rt
Content-Disposition: inline; filename=hotplug-smp-bootstrap.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On PREEMPT_RT the allocators use preemptible locks, cpu bootstrap must have IRQs
disabled because there are no IRQ/exception stacks yet, these we allocate 
atomically, which is not possible on -rt.

Solve this by allocating these stacks on the boot cpu (which already has its
stacks).

This also allows cpu-up to fail instead of panic on OOM scenarios.

I suspect it also fixes a memory leak, as I cannot find the place where 
cpu_down frees these cpu stacks, but each cpu_up used to allocate new ones.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/setup64.c      |   31 ++--------------------
 arch/x86/kernel/smpboot_64.c   |   57 +++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/processor_64.h |    4 ++
 3 files changed, 65 insertions(+), 27 deletions(-)

Index: linux-2.6.24.7.noarch/arch/x86/kernel/setup64.c
===================================================================
--- linux-2.6.24.7.noarch.orig/arch/x86/kernel/setup64.c
+++ linux-2.6.24.7.noarch/arch/x86/kernel/setup64.c
@@ -137,19 +137,12 @@ void pda_init(int cpu)
 		pda->pcurrent = &init_task;
 		pda->irqstackptr = boot_cpu_stack; 
 	} else {
-		pda->irqstackptr = (char *)
-			__get_free_pages(GFP_ATOMIC, IRQSTACK_ORDER);
-		if (!pda->irqstackptr)
-			panic("cannot allocate irqstack for cpu %d", cpu); 
+		pda->irqstackptr = (char *)per_cpu(init_tss, cpu).irqstack;
 	}
 
-
 	pda->irqstackptr += IRQSTACKSIZE-64;
 } 
 
-char boot_exception_stacks[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ + DEBUG_STKSZ]
-__attribute__((section(".bss.page_aligned")));
-
 extern asmlinkage void ignore_sysret(void);
 
 /* May not be marked __init: used by software suspend */
@@ -203,15 +196,13 @@ void __cpuinit cpu_init (void)
 	struct tss_struct *t = &per_cpu(init_tss, cpu);
 	struct orig_ist *orig_ist = &per_cpu(orig_ist, cpu);
 	unsigned long v; 
-	char *estacks = NULL; 
 	struct task_struct *me;
 	int i;
 
 	/* CPU 0 is initialised in head64.c */
 	if (cpu != 0) {
 		pda_init(cpu);
-	} else 
-		estacks = boot_exception_stacks; 
+	}
 
 	me = current;
 
@@ -245,22 +236,8 @@ void __cpuinit cpu_init (void)
 	/*
 	 * set up and load the per-CPU TSS
 	 */
-	for (v = 0; v < N_EXCEPTION_STACKS; v++) {
-		static const unsigned int order[N_EXCEPTION_STACKS] = {
-			[0 ... N_EXCEPTION_STACKS - 1] = EXCEPTION_STACK_ORDER,
-#if DEBUG_STACK > 0
-			[DEBUG_STACK - 1] = DEBUG_STACK_ORDER
-#endif
-		};
-		if (cpu) {
-			estacks = (char *)__get_free_pages(GFP_ATOMIC, order[v]);
-			if (!estacks)
-				panic("Cannot allocate exception stack %ld %d\n",
-				      v, cpu); 
-		}
-		estacks += PAGE_SIZE << order[v];
-		orig_ist->ist[v] = t->ist[v] = (unsigned long)estacks;
-	}
+	for (v = 0; v < N_EXCEPTION_STACKS; v++)
+		orig_ist->ist[v] = t->ist[v] = (unsigned long)t->estacks[v];
 
 	t->io_bitmap_base = offsetof(struct tss_struct, io_bitmap);
 	/*
Index: linux-2.6.24.7.noarch/arch/x86/kernel/smpboot_64.c
===================================================================
--- linux-2.6.24.7.noarch.orig/arch/x86/kernel/smpboot_64.c
+++ linux-2.6.24.7.noarch/arch/x86/kernel/smpboot_64.c
@@ -535,6 +535,60 @@ static void __cpuinit do_fork_idle(struc
 	complete(&c_idle->done);
 }
 
+static char boot_exception_stacks[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ + DEBUG_STKSZ]
+__attribute__((section(".bss.page_aligned")));
+
+static int __cpuinit allocate_stacks(int cpu)
+{
+	static const unsigned int order[N_EXCEPTION_STACKS] = {
+		[0 ... N_EXCEPTION_STACKS - 1] = EXCEPTION_STACK_ORDER,
+#if DEBUG_STACK > 0
+		[DEBUG_STACK - 1] = DEBUG_STACK_ORDER
+#endif
+	};
+	struct tss_struct *t = &per_cpu(init_tss, cpu);
+	int node = cpu_to_node(cpu);
+	struct page *page;
+	char *estack;
+	int v;
+
+	if (cpu && !t->irqstack) {
+		page = alloc_pages_node(node, GFP_KERNEL,
+				IRQSTACK_ORDER);
+		if (!page)
+			goto fail_oom;
+		t->irqstack = page_address(page);
+	}
+
+	if (!cpu)
+		estack = boot_exception_stacks;
+
+	for (v = 0; v < N_EXCEPTION_STACKS; v++) {
+		if (t->estacks[v])
+			continue;
+
+		if (cpu) {
+			page = alloc_pages_node(node, GFP_KERNEL, order[v]);
+			if (!page)
+				goto fail_oom;
+			estack = page_address(page);
+		}
+		estack += PAGE_SIZE << order[v];
+		/*
+		 * XXX: can we set t->isr[v] here directly, or will that be
+		 * modified later? - the existance of orig_ist seems to suggest
+		 * it _can_ be modified, which would imply we'd need to reset
+		 * it.
+		 */
+		t->estacks[v] = estack;
+	}
+
+	return 0;
+
+fail_oom:
+	return -ENOMEM;
+}
+
 /*
  * Boot one CPU.
  */
@@ -605,6 +659,9 @@ static int __cpuinit do_boot_cpu(int cpu
 		return PTR_ERR(c_idle.idle);
 	}
 
+	if (allocate_stacks(cpu))
+		return -ENOMEM;
+
 	set_idle_for_cpu(cpu, c_idle.idle);
 
 do_rest:
Index: linux-2.6.24.7.noarch/include/asm-x86/processor_64.h
===================================================================
--- linux-2.6.24.7.noarch.orig/include/asm-x86/processor_64.h
+++ linux-2.6.24.7.noarch/include/asm-x86/processor_64.h
@@ -197,6 +197,10 @@ struct tss_struct {
 	 * 8 bytes, for an extra "long" of ~0UL
 	 */
 	unsigned long io_bitmap[IO_BITMAP_LONGS + 1];
+
+	void *irqstack;
+	void *estacks[N_EXCEPTION_STACKS];
+
 } __attribute__((packed)) ____cacheline_aligned;
 
 

-- 

