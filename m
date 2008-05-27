Return-Path: <linux-kernel-owner+w=401wt.eu-S1760139AbYE0WpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760139AbYE0WpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 18:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757327AbYE0WpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 18:45:05 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:46457 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757208AbYE0WpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 18:45:04 -0400
Message-ID: <483C8EEC.2030306@ct.jp.nec.com>
Date: Tue, 27 May 2008 15:45:00 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: [PATCH -rt] fix sysrq+l when nmi_watchdog disabled
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

In nmi_show_all_regs(), set nmi_show_regs for all cpus but NMI never come
to itself when nmi_watchdog is disabled. It means the kernel hangs up when
sysrq+l is issued.

Call irq_show_regs_callback() itself before calling smp_send_nmi_allbutself().

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
Steven, this is a fix for what you pointed.
http://lkml.org/lkml/2008/4/28/455

 arch/x86/kernel/nmi_32.c |   51 ++++++++++++++++++++++++++++------------------
 arch/x86/kernel/nmi_64.c |   49 ++++++++++++++++++++++++++++---------------
 2 files changed, 63 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kernel/nmi_32.c b/arch/x86/kernel/nmi_32.c
index d9266ea..82abc2a 100644
--- a/arch/x86/kernel/nmi_32.c
+++ b/arch/x86/kernel/nmi_32.c
@@ -325,21 +325,49 @@ extern void die_nmi(struct pt_regs *, const char *msg);
 
 int nmi_show_regs[NR_CPUS];
 
+static DEFINE_RAW_SPINLOCK(nmi_print_lock);
+
+notrace int irq_show_regs_callback(int cpu, struct pt_regs *regs)
+{
+	if (!nmi_show_regs[cpu])
+		return 0;
+
+	spin_lock(&nmi_print_lock);
+	printk(KERN_WARNING "NMI show regs on CPU#%d:\n", cpu);
+	printk(KERN_WARNING "apic_timer_irqs: %d\n",
+		per_cpu(irq_stat, cpu).apic_timer_irqs);
+	show_regs(regs);
+	spin_unlock(&nmi_print_lock);
+	nmi_show_regs[cpu] = 0;
+	return 1;
+}
+
 void nmi_show_all_regs(void)
 {
-	int i;
+	struct pt_regs *regs;
+	int i, cpu;
 
 	if (system_state == SYSTEM_BOOTING)
 		return;
 
-	printk(KERN_WARNING "nmi_show_all_regs(): start on CPU#%d.\n",
-		raw_smp_processor_id());
+	preempt_disable();
+
+	regs = get_irq_regs();
+	cpu = smp_processor_id();
+
+	printk(KERN_WARNING "nmi_show_all_regs(): start on CPU#%d.\n", cpu);
 	dump_stack();
 
 	for_each_online_cpu(i)
 		nmi_show_regs[i] = 1;
 
+	if (regs)
+		irq_show_regs_callback(cpu, regs);
+	else
+		nmi_show_regs[cpu] = 0;
+
 	smp_send_nmi_allbutself();
+	preempt_enable();
 
 	for_each_online_cpu(i) {
 		while (nmi_show_regs[i] == 1)
@@ -347,23 +375,6 @@ void nmi_show_all_regs(void)
 	}
 }
 
-static DEFINE_RAW_SPINLOCK(nmi_print_lock);
-
-notrace int irq_show_regs_callback(int cpu, struct pt_regs *regs)
-{
-	if (!nmi_show_regs[cpu])
-		return 0;
-
-	spin_lock(&nmi_print_lock);
-	printk(KERN_WARNING "NMI show regs on CPU#%d:\n", cpu);
-	printk(KERN_WARNING "apic_timer_irqs: %d\n",
-		per_cpu(irq_stat, cpu).apic_timer_irqs);
-	show_regs(regs);
-	spin_unlock(&nmi_print_lock);
-	nmi_show_regs[cpu] = 0;
-	return 1;
-}
-
 __kprobes int nmi_watchdog_tick(struct pt_regs * regs, unsigned reason)
 {
 
diff --git a/arch/x86/kernel/nmi_64.c b/arch/x86/kernel/nmi_64.c
index c802380..5e7e2b0 100644
--- a/arch/x86/kernel/nmi_64.c
+++ b/arch/x86/kernel/nmi_64.c
@@ -317,17 +317,48 @@ EXPORT_SYMBOL(touch_nmi_watchdog);
 
 int nmi_show_regs[NR_CPUS];
 
+static DEFINE_RAW_SPINLOCK(nmi_print_lock);
+
+notrace int irq_show_regs_callback(int cpu, struct pt_regs *regs)
+{
+	if (!nmi_show_regs[cpu])
+		return 0;
+
+	spin_lock(&nmi_print_lock);
+	printk(KERN_WARNING "NMI show regs on CPU#%d:\n", cpu);
+	printk(KERN_WARNING "apic_timer_irqs: %d\n", read_pda(apic_timer_irqs));
+	show_regs(regs);
+	spin_unlock(&nmi_print_lock);
+	nmi_show_regs[cpu] = 0;
+	return 1;
+}
+
 void nmi_show_all_regs(void)
 {
-	int i;
+	struct pt_regs *regs;
+	int i, cpu;
 
 	if (system_state == SYSTEM_BOOTING)
 		return;
 
+	preempt_disable();
+
+	regs = get_irq_regs();
+	cpu = smp_processor_id();
+
+	printk(KERN_WARNING "nmi_show_all_regs(): start on CPU#%d.\n", cpu);
+	dump_stack();
+
 	for_each_online_cpu(i)
 		nmi_show_regs[i] = 1;
 
+	if (regs)
+		irq_show_regs_callback(cpu, regs);
+	else
+		nmi_show_regs[cpu] = 0;
+
 	smp_send_nmi_allbutself();
+	preempt_enable();
 
 	for_each_online_cpu(i) {
 		while (nmi_show_regs[i] == 1)
@@ -335,22 +366,6 @@ void nmi_show_all_regs(void)
 	}
 }
 
-static DEFINE_RAW_SPINLOCK(nmi_print_lock);
-
-notrace int irq_show_regs_callback(int cpu, struct pt_regs *regs)
-{
-	if (!nmi_show_regs[cpu])
-		return 0;
-
-	spin_lock(&nmi_print_lock);
-	printk(KERN_WARNING "NMI show regs on CPU#%d:\n", cpu);
-	printk(KERN_WARNING "apic_timer_irqs: %d\n", read_pda(apic_timer_irqs));
-	show_regs(regs);
-	spin_unlock(&nmi_print_lock);
-	nmi_show_regs[cpu] = 0;
-	return 1;
-}
-
 int __kprobes nmi_watchdog_tick(struct pt_regs * regs, unsigned reason)
 {
 	int sum;
-- 
1.5.4.1

