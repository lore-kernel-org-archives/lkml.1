Return-Path: <linux-kernel-owner+w=401wt.eu-S1753675AbXKBFCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbXKBFCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 01:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbXKBFCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 01:02:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60526
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751694AbXKBFCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 01:02:05 -0400
Date: Thu, 01 Nov 2007 22:02:04 -0700 (PDT)
Message-Id: <20071101.220204.254984189.davem@davemloft.net>
To: npiggin@suse.de
Cc: duaneg@dghda.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23 regression: accessing invalid mmap'ed memory from gdb
 causes unkillable spinning
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071031.004425.12962203.davem@davemloft.net>
References: <20071030.235600.254712083.davem@davemloft.net>
	<20071031074106.GE12189@wotan.suse.de>
	<20071031.004425.12962203.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 31 Oct 2007 00:44:25 -0700 (PDT)

> From: Nick Piggin <npiggin@suse.de>
> Date: Wed, 31 Oct 2007 08:41:06 +0100
> 
> > You could possibly even do a generic "best effort" kind of thing with
> > regular IPIs, that will timeout and continue if some CPUs don't handle
> > them, and should be pretty easy to get working with existing smp_call_
> > function stuff. Not exactly clean, but it would be better than nothing.
> 
> Without a doubt.

Putting my code where my mouth is, here is an example implementation
of a special SysRQ "g" "dump regs globally" debugging tool for
sparc64.

The only thing that has to happen is the SysRQ trigger.  So if you can
either SysRQ-'g' at the console or "echo 'g' >/proc/sysrq-trigger" you
can get the registers from the cpus in the system.

The only case the remote cpu registers would not be capturable would
be if they were stuck looping in the trap entry, trap exit, or low
level TLB handler code.

This means that even if some cpu is stuck in a spinlock loop with
interrupts disabled, you'd see it with this thing.  The way it works
is that cross cpu vectored interrupts are disabled independently of
the processor interrupt level on sparc64.

This version just records the absolute minimum processor state, it
could be trivially extended to record all of pt_regs etc.

Even on my 64 cpu niagara box, the output is reasonable and fills up
one full screen of my console window.  Full pt_regs dumps are too
much.

diff --git a/arch/sparc64/kernel/process.c b/arch/sparc64/kernel/process.c
index ca7cdfd..67bf91d 100644
--- a/arch/sparc64/kernel/process.c
+++ b/arch/sparc64/kernel/process.c
@@ -1,7 +1,6 @@
-/*  $Id: process.c,v 1.131 2002/02/09 19:49:30 davem Exp $
- *  arch/sparc64/kernel/process.c
+/*  arch/sparc64/kernel/process.c
  *
- *  Copyright (C) 1995, 1996 David S. Miller (davem@caip.rutgers.edu)
+ *  Copyright (C) 1995, 1996, 2007 David S. Miller (davem@davemloft.net)
  *  Copyright (C) 1996       Eddie C. Dost   (ecd@skynet.be)
  *  Copyright (C) 1997, 1998 Jakub Jelinek   (jj@sunsite.mff.cuni.cz)
  */
@@ -31,6 +30,7 @@
 #include <linux/tick.h>
 #include <linux/init.h>
 #include <linux/cpu.h>
+#include <linux/sysrq.h>
 
 #include <asm/oplib.h>
 #include <asm/uaccess.h>
@@ -48,6 +48,7 @@
 #include <asm/unistd.h>
 #include <asm/hypervisor.h>
 #include <asm/sstate.h>
+#include <asm/irq_regs.h>
 
 /* #define VERBOSE_SHOWREGS */
 
@@ -388,6 +389,76 @@ void show_regs32(struct pt_regs32 *regs)
 	       regs->u_regs[15]);
 }
 
+#ifdef CONFIG_MAGIC_SYSRQ
+struct global_reg_snapshot {
+	unsigned long		tstate;
+	unsigned long		tpc;
+	unsigned long		tnpc;
+	struct thread_info	*thread;
+} global_reg_snapshot[NR_CPUS];
+static DEFINE_SPINLOCK(global_reg_snapshot_lock);
+
+static void sysrq_handle_globreg(int key, struct tty_struct *tty)
+{
+	struct pt_regs *regs = get_irq_regs();
+#ifdef CONFIG_KALLSYMS
+	char buffer[KSYM_SYMBOL_LEN];
+#endif
+	unsigned long flags;
+	int cpu;
+
+	spin_lock_irqsave(&global_reg_snapshot_lock, flags);
+	cpu = raw_smp_processor_id();
+	if (regs) {
+		global_reg_snapshot[cpu].tstate = regs->tstate;
+		global_reg_snapshot[cpu].tpc = regs->tpc;
+		global_reg_snapshot[cpu].tnpc = regs->tnpc;
+	} else {
+		global_reg_snapshot[cpu].tstate = 0;
+		global_reg_snapshot[cpu].tpc = 0;
+		global_reg_snapshot[cpu].tnpc = 0;
+	}
+	global_reg_snapshot[cpu].thread = current_thread_info();
+
+	smp_fetch_global_regs();
+
+	for_each_online_cpu(cpu) {
+		struct global_reg_snapshot *gp = &global_reg_snapshot[cpu];
+		struct thread_info *tp = gp->thread;
+
+		printk("%c CPU[%3d]: TSTATE[%016lx] TPC[%016lx] TNPC[%016lx] TASK[%s:%d]\n",
+		       (cpu == raw_smp_processor_id() ? '*' : ' '), cpu,
+		       gp->tstate, gp->tpc, gp->tnpc,
+		       ((tp  && tp->task) ? tp->task->comm : "NULL"),
+		       ((tp  && tp->task) ? tp->task->pid : -1));
+#ifdef CONFIG_KALLSYMS
+		if ((gp->tstate & TSTATE_PRIV) && (gp->tpc != 0UL)) {
+			sprint_symbol(buffer, gp->tpc);
+			printk("             TPC[%s]\n", buffer);
+		}
+#endif
+	}
+
+	memset(global_reg_snapshot, 0, sizeof(global_reg_snapshot));
+
+	spin_unlock_irqrestore(&global_reg_snapshot_lock, flags);
+}
+
+static struct sysrq_key_op sparc_globalreg_op = {
+	.handler	= sysrq_handle_globreg,
+	.help_msg	= "Globalregs",
+	.action_msg	= "Show Global CPU Regs",
+};
+
+static int __init sparc_globreg_init(void)
+{
+	return register_sysrq_key('g', &sparc_globalreg_op);
+}
+
+core_initcall(sparc_globreg_init);
+
+#endif
+
 unsigned long thread_saved_pc(struct task_struct *tsk)
 {
 	struct thread_info *ti = task_thread_info(tsk);
diff --git a/arch/sparc64/kernel/smp.c b/arch/sparc64/kernel/smp.c
index c73b7a4..cbedf27 100644
--- a/arch/sparc64/kernel/smp.c
+++ b/arch/sparc64/kernel/smp.c
@@ -894,6 +894,7 @@ extern unsigned long xcall_flush_tlb_mm;
 extern unsigned long xcall_flush_tlb_pending;
 extern unsigned long xcall_flush_tlb_kernel_range;
 extern unsigned long xcall_report_regs;
+extern unsigned long xcall_fetch_glob_regs;
 extern unsigned long xcall_receive_signal;
 extern unsigned long xcall_new_mmu_context_version;
 
@@ -1064,6 +1065,11 @@ void smp_report_regs(void)
 	smp_cross_call(&xcall_report_regs, 0, 0, 0);
 }
 
+void smp_fetch_global_regs(void)
+{
+	smp_cross_call(&xcall_fetch_glob_regs, 0, 0, 0);
+}
+
 /* We know that the window frames of the user have been flushed
  * to the stack before we get here because all callers of us
  * are flush_tlb_*() routines, and these run after flush_cache_*()
diff --git a/arch/sparc64/mm/ultra.S b/arch/sparc64/mm/ultra.S
index 737c269..7a079ed 100644
--- a/arch/sparc64/mm/ultra.S
+++ b/arch/sparc64/mm/ultra.S
@@ -1,7 +1,6 @@
-/* $Id: ultra.S,v 1.72 2002/02/09 19:49:31 davem Exp $
- * ultra.S: Don't expand these all over the place...
+/* ultra.S: Don't expand these all over the place...
  *
- * Copyright (C) 1997, 2000 David S. Miller (davem@redhat.com)
+ * Copyright (C) 1997, 2000, 2007 David S. Miller (davem@davemloft.net)
  */
 
 #include <asm/asi.h>
@@ -15,6 +14,7 @@
 #include <asm/thread_info.h>
 #include <asm/cacheflush.h>
 #include <asm/hypervisor.h>
+#include <asm/cpudata.h>
 
 	/* Basically, most of the Spitfire vs. Cheetah madness
 	 * has to do with the fact that Cheetah does not support
@@ -523,6 +523,27 @@ xcall_report_regs:
 	b		rtrap_xcall
 	 ldx		[%sp + PTREGS_OFF + PT_V9_TSTATE], %l1
 
+	.globl		xcall_fetch_glob_regs
+xcall_fetch_glob_regs:
+	sethi		%hi(global_reg_snapshot), %g1
+	or		%g1, %lo(global_reg_snapshot), %g1
+	__GET_CPUID(%g2)
+	sllx		%g2, 5, %g3
+	add		%g1, %g3, %g1
+	rdpr		%tstate, %g7
+	stx		%g7, [%g1 + 0x00]
+	rdpr		%tpc, %g7
+	stx		%g7, [%g1 + 0x08]
+	rdpr		%tnpc, %g7
+	stx		%g7, [%g1 + 0x10]
+	sethi		%hi(trap_block), %g7
+	or		%g7, %lo(trap_block), %g7
+	sllx		%g2, TRAP_BLOCK_SZ_SHIFT, %g2
+	add		%g7, %g2, %g7
+	ldx		[%g7 + TRAP_PER_CPU_THREAD], %g3
+	stx		%g3, [%g1 + 0x18]
+	retry
+
 #ifdef DCACHE_ALIASING_POSSIBLE
 	.align		32
 	.globl		xcall_flush_dcache_page_cheetah
diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index 39cc318..7f871a5 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -335,6 +335,7 @@ static struct sysrq_key_op *sysrq_key_table[36] = {
 	&sysrq_term_op,			/* e */
 	&sysrq_moom_op,			/* f */
 	/* g: May be registered by ppc for kgdb */
+	/*    May be registered by sparc for global register dump */
 	NULL,				/* g */
 	NULL,				/* h */
 	&sysrq_kill_op,			/* i */
diff --git a/include/asm-sparc64/smp.h b/include/asm-sparc64/smp.h
index e8a96a3..29393e3 100644
--- a/include/asm-sparc64/smp.h
+++ b/include/asm-sparc64/smp.h
@@ -1,6 +1,6 @@
 /* smp.h: Sparc64 specific SMP stuff.
  *
- * Copyright (C) 1996 David S. Miller (davem@caip.rutgers.edu)
+ * Copyright (C) 1996, 2007 David S. Miller (davem@davemloft.net)
  */
 
 #ifndef _SPARC64_SMP_H
@@ -43,6 +43,8 @@ extern int hard_smp_processor_id(void);
 extern void smp_fill_in_sib_core_maps(void);
 extern void cpu_play_dead(void);
 
+extern void smp_fetch_global_regs(void);
+
 #ifdef CONFIG_HOTPLUG_CPU
 extern int __cpu_disable(void);
 extern void __cpu_die(unsigned int cpu);
@@ -54,6 +56,7 @@ extern void __cpu_die(unsigned int cpu);
 
 #define hard_smp_processor_id()		0
 #define smp_fill_in_sib_core_maps() do { } while (0)
+#define smp_fetch_global_regs() do { } while (0)
 
 #endif /* !(CONFIG_SMP) */
 
