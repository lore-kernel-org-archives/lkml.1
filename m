Return-Path: <linux-kernel-owner+w=401wt.eu-S965830AbYD1SQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965830AbYD1SQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964933AbYD1SQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:16:33 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:2640 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965750AbYD1SQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:16:32 -0400
Message-ID: <4816147F.2010805@ct.jp.nec.com>
Date: Mon, 28 Apr 2008 11:16:31 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: [PATCH -rt 2/4] x86: return true for NMI handled
References: <48161325.1080508@ct.jp.nec.com>
In-Reply-To: <48161325.1080508@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

NMI for show_regs causes unknown NMI when nmi_watchdog is local APIC mode.
Because lapic_wd_event() will fail due to still running perfctr.
If NMI is for show_regs, nmi_watchdog_tick() should return 1.

On x86_32, call irq_show_regs_callback() is moved to top of the
nmi_watchdog_tick() same as x86_64.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/nmi_32.c |   10 +++++-----
 arch/x86/kernel/nmi_64.c |    9 +++++----
 include/linux/sched.h    |    2 +-
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/nmi_32.c b/arch/x86/kernel/nmi_32.c
index da9deb3..d1f92ca 100644
--- a/arch/x86/kernel/nmi_32.c
+++ b/arch/x86/kernel/nmi_32.c
@@ -350,10 +350,10 @@ void nmi_show_all_regs(void)
 
 static DEFINE_RAW_SPINLOCK(nmi_print_lock);
 
-notrace void irq_show_regs_callback(int cpu, struct pt_regs *regs)
+notrace int irq_show_regs_callback(int cpu, struct pt_regs *regs)
 {
 	if (!nmi_show_regs[cpu])
-		return;
+		return 0;
 
 	nmi_show_regs[cpu] = 0;
 	spin_lock(&nmi_print_lock);
@@ -362,6 +362,7 @@ notrace void irq_show_regs_callback(int cpu, struct pt_regs *regs)
 		per_cpu(irq_stat, cpu).apic_timer_irqs);
 	show_regs(regs);
 	spin_unlock(&nmi_print_lock);
+	return 1;
 }
 
 notrace __kprobes int
@@ -376,8 +377,9 @@ nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 	unsigned int sum;
 	int touched = 0;
 	int cpu = smp_processor_id();
-	int rc=0;
+	int rc;
 
+	rc = irq_show_regs_callback(cpu, regs);
 	__profile_tick(CPU_PROFILING, regs);
 
 	/* check for other users first */
@@ -404,8 +406,6 @@ nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 	sum = per_cpu(irq_stat, cpu).apic_timer_irqs +
 		per_cpu(irq_stat, cpu).irq0_irqs;
 
-	irq_show_regs_callback(cpu, regs);
-
 	/* if the apic timer isn't firing, this cpu isn't doing much */
 	/* if the none of the timers isn't firing, this cpu isn't doing much */
 	if (!touched && last_irq_sums[cpu] == sum) {
diff --git a/arch/x86/kernel/nmi_64.c b/arch/x86/kernel/nmi_64.c
index 5d3073c..afc0317 100644
--- a/arch/x86/kernel/nmi_64.c
+++ b/arch/x86/kernel/nmi_64.c
@@ -340,10 +340,10 @@ void nmi_show_all_regs(void)
 
 static DEFINE_RAW_SPINLOCK(nmi_print_lock);
 
-notrace void irq_show_regs_callback(int cpu, struct pt_regs *regs)
+notrace int irq_show_regs_callback(int cpu, struct pt_regs *regs)
 {
 	if (!nmi_show_regs[cpu])
-		return;
+		return 0;
 
 	nmi_show_regs[cpu] = 0;
 	spin_lock(&nmi_print_lock);
@@ -351,6 +351,7 @@ notrace void irq_show_regs_callback(int cpu, struct pt_regs *regs)
 	printk(KERN_WARNING "apic_timer_irqs: %d\n", read_pda(apic_timer_irqs));
 	show_regs(regs);
 	spin_unlock(&nmi_print_lock);
+	return 1;
 }
 
 notrace int __kprobes
@@ -359,9 +360,9 @@ nmi_watchdog_tick(struct pt_regs * regs, unsigned reason)
 	int sum;
 	int touched = 0;
 	int cpu = smp_processor_id();
-	int rc = 0;
+	int rc;
 
-	irq_show_regs_callback(cpu, regs);
+	rc = irq_show_regs_callback(cpu, regs);
 	__profile_tick(CPU_PROFILING, regs);
 
 	/* check for other users first */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4176f87..a37200a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -292,7 +292,7 @@ static inline void show_state(void)
 }
 
 extern void show_regs(struct pt_regs *);
-extern void irq_show_regs_callback(int cpu, struct pt_regs *regs);
+extern int irq_show_regs_callback(int cpu, struct pt_regs *regs);
 
 /*
  * TASK is a pointer to the task whose backtrace we want to see (or NULL for current
-- 
1.5.4.1

