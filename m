Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbZIKSlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbZIKSlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 14:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755788AbZIKSlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 14:41:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38252 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbZIKSlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 14:41:06 -0400
Date: Fri, 11 Sep 2009 20:41:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] core/debug for v2.6.32
Message-ID: <20090911184105.GA32185@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the core-debug-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-debug-for-linus

 Thanks,

	Ingo

------------------>
Ingo Molnar (2):
      debug lockups: Improve lockup detection
      debug lockups: Improve lockup detection, fix generic arch fallback


 arch/sparc/include/asm/irq_64.h |    4 ++--
 arch/sparc/kernel/process_64.c  |    4 ++--
 arch/x86/include/asm/nmi.h      |    4 ++--
 arch/x86/kernel/apic/nmi.c      |   20 +++++++++++++-------
 drivers/char/sysrq.c            |   19 ++++++++++++++-----
 include/linux/nmi.h             |   19 +++++++++++++++++--
 kernel/rcutree.c                |    7 ++++++-
 7 files changed, 56 insertions(+), 21 deletions(-)

diff --git a/arch/sparc/include/asm/irq_64.h b/arch/sparc/include/asm/irq_64.h
index 1934f2c..a0b443c 100644
--- a/arch/sparc/include/asm/irq_64.h
+++ b/arch/sparc/include/asm/irq_64.h
@@ -89,8 +89,8 @@ static inline unsigned long get_softint(void)
 	return retval;
 }
 
-void __trigger_all_cpu_backtrace(void);
-#define trigger_all_cpu_backtrace() __trigger_all_cpu_backtrace()
+void arch_trigger_all_cpu_backtrace(void);
+#define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
 
 extern void *hardirq_stack[NR_CPUS];
 extern void *softirq_stack[NR_CPUS];
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index 4041f94..18d6785 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -251,7 +251,7 @@ static void __global_reg_poll(struct global_reg_snapshot *gp)
 	}
 }
 
-void __trigger_all_cpu_backtrace(void)
+void arch_trigger_all_cpu_backtrace(void)
 {
 	struct thread_info *tp = current_thread_info();
 	struct pt_regs *regs = get_irq_regs();
@@ -304,7 +304,7 @@ void __trigger_all_cpu_backtrace(void)
 
 static void sysrq_handle_globreg(int key, struct tty_struct *tty)
 {
-	__trigger_all_cpu_backtrace();
+	arch_trigger_all_cpu_backtrace();
 }
 
 static struct sysrq_key_op sparc_globalreg_op = {
diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index c86e5ed..e63cf7d 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -45,8 +45,8 @@ extern int proc_nmi_enabled(struct ctl_table *, int , struct file *,
 			void __user *, size_t *, loff_t *);
 extern int unknown_nmi_panic;
 
-void __trigger_all_cpu_backtrace(void);
-#define trigger_all_cpu_backtrace() __trigger_all_cpu_backtrace()
+void arch_trigger_all_cpu_backtrace(void);
+#define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
 
 static inline void localise_nmi_watchdog(void)
 {
diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index b3025b4..db72202 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -39,7 +39,7 @@
 int unknown_nmi_panic;
 int nmi_watchdog_enabled;
 
-static cpumask_var_t backtrace_mask;
+static cpumask_t backtrace_mask __read_mostly;
 
 /* nmi_active:
  * >0: the lapic NMI watchdog is active, but can be disabled
@@ -138,7 +138,6 @@ int __init check_nmi_watchdog(void)
 	if (!prev_nmi_count)
 		goto error;
 
-	alloc_cpumask_var(&backtrace_mask, GFP_KERNEL|__GFP_ZERO);
 	printk(KERN_INFO "Testing NMI watchdog ... ");
 
 #ifdef CONFIG_SMP
@@ -415,14 +414,17 @@ nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 	}
 
 	/* We can be called before check_nmi_watchdog, hence NULL check. */
-	if (backtrace_mask != NULL && cpumask_test_cpu(cpu, backtrace_mask)) {
+	if (cpumask_test_cpu(cpu, &backtrace_mask)) {
 		static DEFINE_SPINLOCK(lock);	/* Serialise the printks */
 
 		spin_lock(&lock);
 		printk(KERN_WARNING "NMI backtrace for cpu %d\n", cpu);
+		show_regs(regs);
 		dump_stack();
 		spin_unlock(&lock);
-		cpumask_clear_cpu(cpu, backtrace_mask);
+		cpumask_clear_cpu(cpu, &backtrace_mask);
+
+		rc = 1;
 	}
 
 	/* Could check oops_in_progress here too, but it's safer not to */
@@ -552,14 +554,18 @@ int do_nmi_callback(struct pt_regs *regs, int cpu)
 	return 0;
 }
 
-void __trigger_all_cpu_backtrace(void)
+void arch_trigger_all_cpu_backtrace(void)
 {
 	int i;
 
-	cpumask_copy(backtrace_mask, cpu_online_mask);
+	cpumask_copy(&backtrace_mask, cpu_online_mask);
+
+	printk(KERN_INFO "sending NMI to all CPUs:\n");
+	apic->send_IPI_all(NMI_VECTOR);
+
 	/* Wait for up to 10 seconds for all CPUs to do the backtrace */
 	for (i = 0; i < 10 * 1000; i++) {
-		if (cpumask_empty(backtrace_mask))
+		if (cpumask_empty(&backtrace_mask))
 			break;
 		mdelay(1);
 	}
diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index 5d7a02f..50eecfe 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -24,6 +24,7 @@
 #include <linux/sysrq.h>
 #include <linux/kbd_kern.h>
 #include <linux/proc_fs.h>
+#include <linux/nmi.h>
 #include <linux/quotaops.h>
 #include <linux/perf_counter.h>
 #include <linux/kernel.h>
@@ -222,12 +223,20 @@ static DECLARE_WORK(sysrq_showallcpus, sysrq_showregs_othercpus);
 
 static void sysrq_handle_showallcpus(int key, struct tty_struct *tty)
 {
-	struct pt_regs *regs = get_irq_regs();
-	if (regs) {
-		printk(KERN_INFO "CPU%d:\n", smp_processor_id());
-		show_regs(regs);
+	/*
+	 * Fall back to the workqueue based printing if the
+	 * backtrace printing did not succeed or the
+	 * architecture has no support for it:
+	 */
+	if (!trigger_all_cpu_backtrace()) {
+		struct pt_regs *regs = get_irq_regs();
+
+		if (regs) {
+			printk(KERN_INFO "CPU%d:\n", smp_processor_id());
+			show_regs(regs);
+		}
+		schedule_work(&sysrq_showallcpus);
 	}
-	schedule_work(&sysrq_showallcpus);
 }
 
 static struct sysrq_key_op sysrq_showallcpus_op = {
diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index 29af2d5..b752e80 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -28,8 +28,23 @@ static inline void acpi_nmi_disable(void) { }
 static inline void acpi_nmi_enable(void) { }
 #endif
 
-#ifndef trigger_all_cpu_backtrace
-#define trigger_all_cpu_backtrace() do { } while (0)
+/*
+ * Create trigger_all_cpu_backtrace() out of the arch-provided
+ * base function. Return whether such support was available,
+ * to allow calling code to fall back to some other mechanism:
+ */
+#ifdef arch_trigger_all_cpu_backtrace
+static inline bool trigger_all_cpu_backtrace(void)
+{
+	arch_trigger_all_cpu_backtrace();
+
+	return true;
+}
+#else
+static inline bool trigger_all_cpu_backtrace(void)
+{
+	return false;
+}
 #endif
 
 #endif
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 7717b95..9c5fa9f 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -35,6 +35,7 @@
 #include <linux/rcupdate.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
+#include <linux/nmi.h>
 #include <asm/atomic.h>
 #include <linux/bitops.h>
 #include <linux/module.h>
@@ -469,6 +470,8 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	}
 	printk(" (detected by %d, t=%ld jiffies)\n",
 	       smp_processor_id(), (long)(jiffies - rsp->gp_start));
+	trigger_all_cpu_backtrace();
+
 	force_quiescent_state(rsp, 0);  /* Kick them all. */
 }
 
@@ -479,12 +482,14 @@ static void print_cpu_stall(struct rcu_state *rsp)
 
 	printk(KERN_ERR "INFO: RCU detected CPU %d stall (t=%lu jiffies)\n",
 			smp_processor_id(), jiffies - rsp->gp_start);
-	dump_stack();
+	trigger_all_cpu_backtrace();
+
 	spin_lock_irqsave(&rnp->lock, flags);
 	if ((long)(jiffies - rsp->jiffies_stall) >= 0)
 		rsp->jiffies_stall =
 			jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
 	spin_unlock_irqrestore(&rnp->lock, flags);
+
 	set_need_resched();  /* kick ourselves to get things going. */
 }
 
