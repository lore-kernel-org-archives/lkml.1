Return-Path: <linux-kernel-owner+w=401wt.eu-S1764221AbYHFVWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764221AbYHFVWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932150AbYHFVM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:12:59 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:47651 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932141AbYHFVM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:12:57 -0400
Date: Thu, 7 Aug 2008 00:11:28 +0300
From: Adrian Bunk <bunk@kernel.org>
To: takata@linux-m32r.org
Cc: linux-m32r@ml.linux-m32r.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] m32r/kernel/: cleanups
Message-ID: <20080806211128.GU1702@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- make the following needlessly global code static:
  - entry.S: resume_userspace
  - process.c: pm_idle
  - process.c: default_idle()
  - smp.c: send_IPI_allbutself()
  - time.c: timer_interrupt()
  - time.c: struct irq0
  - traps.c: set_eit_vector_entries()
  - traps.c: kstack_depth_to_print
  - traps.c: show_trace()
  - traps.c: die_lock
- remove the following unused code:
  - head.S: startup_32
  - process.c: hlt_counter
  - process.c: disable_hlt()
  - process.c: enable_hlt()
  - process.c: dump_task_regs()
- remove the following variables and their usages since they were
  always 0:
  - irq.c: irq_err_count
  - irq.c: irq_mis_count

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 13 Jun 2008

 arch/m32r/kernel/entry.S   |    2 +-
 arch/m32r/kernel/head.S    |    1 -
 arch/m32r/kernel/irq.c     |    6 ------
 arch/m32r/kernel/process.c |   30 ++----------------------------
 arch/m32r/kernel/smp.c     |    4 ++--
 arch/m32r/kernel/time.c    |    5 ++---
 arch/m32r/kernel/traps.c   |    8 ++++----
 7 files changed, 11 insertions(+), 45 deletions(-)

4f6007ee77a635938b87b6a3845f4b93dbdf9a35 diff --git a/arch/m32r/kernel/entry.S b/arch/m32r/kernel/entry.S
index d4eaa2f..612d35b 100644
--- a/arch/m32r/kernel/entry.S
+++ b/arch/m32r/kernel/entry.S
@@ -143,7 +143,7 @@ ret_from_intr:
 	and3	r4, r4, #0x8000		; check BSM bit
 #endif
 	beqz	r4, resume_kernel
-ENTRY(resume_userspace)
+resume_userspace:
 	DISABLE_INTERRUPTS(r4)		; make sure we don't miss an interrupt
 					; setting need_resched or sigpending
 					; between sampling and the iret
diff --git a/arch/m32r/kernel/head.S b/arch/m32r/kernel/head.S
index dab7436..4018077 100644
--- a/arch/m32r/kernel/head.S
+++ b/arch/m32r/kernel/head.S
@@ -29,7 +29,6 @@ __INITDATA
 	.global _end
 ENTRY(stext)
 ENTRY(_stext)
-ENTRY(startup_32)
 	/* Setup up the stack pointer */
 	LDIMM	(r0, spi_stack_top)
 	LDIMM	(r1, spu_stack_top)
diff --git a/arch/m32r/kernel/irq.c b/arch/m32r/kernel/irq.c
index d0c5b0b..2aeae46 100644
--- a/arch/m32r/kernel/irq.c
+++ b/arch/m32r/kernel/irq.c
@@ -22,9 +22,6 @@
 #include <linux/module.h>
 #include <asm/uaccess.h>
 
-atomic_t irq_err_count;
-atomic_t irq_mis_count;
-
 /*
  * Generic, controller-independent functions:
  */
@@ -63,9 +60,6 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_putc(p, '\n');
 skip:
 		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
-	} else if (i == NR_IRQS) {
-		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
-		seq_printf(p, "MIS: %10u\n", atomic_read(&irq_mis_count));
 	}
 	return 0;
 }
diff --git a/arch/m32r/kernel/process.c b/arch/m32r/kernel/process.c
index a689e29..5be4faa 100644
--- a/arch/m32r/kernel/process.c
+++ b/arch/m32r/kernel/process.c
@@ -35,8 +35,6 @@
 
 #include <linux/err.h>
 
-static int hlt_counter=0;
-
 /*
  * Return saved PC of a blocked thread.
  */
@@ -48,31 +46,16 @@ unsigned long thread_saved_pc(struct task_struct *tsk)
 /*
  * Powermanagement idle function, if any..
  */
-void (*pm_idle)(void) = NULL;
-EXPORT_SYMBOL(pm_idle);
+static void (*pm_idle)(void) = NULL;
 
 void (*pm_power_off)(void) = NULL;
 EXPORT_SYMBOL(pm_power_off);
 
-void disable_hlt(void)
-{
-	hlt_counter++;
-}
-
-EXPORT_SYMBOL(disable_hlt);
-
-void enable_hlt(void)
-{
-	hlt_counter--;
-}
-
-EXPORT_SYMBOL(enable_hlt);
-
 /*
  * We use this is we don't have any better
  * idle routine..
  */
-void default_idle(void)
+static void default_idle(void)
 {
 	/* M32R_FIXME: Please use "cpu_sleep" mode.  */
 	cpu_relax();
@@ -260,15 +243,6 @@ int copy_thread(int nr, unsigned long clone_flags, unsigned long spu,
 	return 0;
 }
 
-/*
- * Capture the user space registers if the task is not running (in user space)
- */
-int dump_task_regs(struct task_struct *tsk, elf_gregset_t *regs)
-{
-	/* M32R_FIXME */
-	return 1;
-}
-
 asmlinkage int sys_fork(unsigned long r0, unsigned long r1, unsigned long r2,
 	unsigned long r3, unsigned long r4, unsigned long r5, unsigned long r6,
 	struct pt_regs regs)
diff --git a/arch/m32r/kernel/smp.c b/arch/m32r/kernel/smp.c
index c837bc1..5b1e763 100644
--- a/arch/m32r/kernel/smp.c
+++ b/arch/m32r/kernel/smp.c
@@ -103,7 +103,7 @@ void smp_send_timer(void);
 void smp_ipi_timer_interrupt(struct pt_regs *);
 void smp_local_timer_interrupt(void);
 
-void send_IPI_allbutself(int, int);
+static void send_IPI_allbutself(int, int);
 static void send_IPI_mask(cpumask_t, int, int);
 unsigned long send_IPI_mask_phys(cpumask_t, int, int);
 
@@ -824,7 +824,7 @@ void smp_local_timer_interrupt(void)
  * ---------- --- --------------------------------------------------------
  *
  *==========================================================================*/
-void send_IPI_allbutself(int ipi_num, int try)
+static void send_IPI_allbutself(int ipi_num, int try)
 {
 	cpumask_t cpumask;
 
diff --git a/arch/m32r/kernel/time.c b/arch/m32r/kernel/time.c
index 994cc15..6ea0177 100644
--- a/arch/m32r/kernel/time.c
+++ b/arch/m32r/kernel/time.c
@@ -34,7 +34,6 @@
 #include <asm/hw_irq.h>
 
 #ifdef CONFIG_SMP
-extern void send_IPI_allbutself(int, int);
 extern void smp_local_timer_interrupt(void);
 #endif
 
@@ -188,7 +187,7 @@ static long last_rtc_update = 0;
  * timer_interrupt() needs to keep up the real-time clock,
  * as well as call the "do_timer()" routine every clocktick
  */
-irqreturn_t timer_interrupt(int irq, void *dev_id)
+static irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
 #ifndef CONFIG_SMP
 	profile_tick(CPU_PROFILING);
@@ -228,7 +227,7 @@ irqreturn_t timer_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-struct irqaction irq0 = {
+static struct irqaction irq0 = {
 	.handler = timer_interrupt,
 	.flags = IRQF_DISABLED,
 	.mask = CPU_MASK_NONE,
diff --git a/arch/m32r/kernel/traps.c b/arch/m32r/kernel/traps.c
index 89ba4a0..26a73ff 100644
--- a/arch/m32r/kernel/traps.c
+++ b/arch/m32r/kernel/traps.c
@@ -60,7 +60,7 @@ extern unsigned long	eit_vector[];
 	((unsigned long)func - (unsigned long)eit_vector - entry*4)/4 \
 	+ 0xff000000UL
 
-void	set_eit_vector_entries(void)
+static void set_eit_vector_entries(void)
 {
 	extern void default_eit_handler(void);
 	extern void system_call(void);
@@ -120,9 +120,9 @@ void __init trap_init(void)
 	cpu_init();
 }
 
-int kstack_depth_to_print = 24;
+static int kstack_depth_to_print = 24;
 
-void show_trace(struct task_struct *task, unsigned long *stack)
+static void show_trace(struct task_struct *task, unsigned long *stack)
 {
 	unsigned long addr;
 
@@ -223,7 +223,7 @@ bad:
 	printk("\n");
 }
 
-DEFINE_SPINLOCK(die_lock);
+static DEFINE_SPINLOCK(die_lock);
 
 void die(const char * str, struct pt_regs * regs, long err)
 {

