Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbYHPQfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbYHPQfA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 12:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbYHPQe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 12:34:29 -0400
Received: from gw.goop.org ([64.81.55.164]:47274 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbYHPQe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 12:34:28 -0400
Message-ID: <48A70192.7020002@goop.org>
Date: Sat, 16 Aug 2008 09:34:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH RFC 3/3] x86: use mwait for trigger API
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the cpu implements monitor/mwait, use it for the trigger API.

TODO: work out if any mwait hints are going to be useful here.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/kernel/paravirt-spinlocks.c |   22 ++++++++++++
 arch/x86/kernel/trigger.c            |   59 ++++++++++++++++++++++++++++++++++
 include/asm-x86/trigger.h            |   27 +++++++++++++--
 3 files changed, 104 insertions(+), 4 deletions(-)

===================================================================
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -7,6 +7,7 @@
 #include <linux/module.h>
 
 #include <asm/paravirt.h>
+#include <asm/cpufeature.h>
 
 static void default_spin_lock_flags(struct raw_spinlock *lock, unsigned long flags)
 {
@@ -41,3 +42,24 @@
 	pv_lock_ops.spin_unlock = __byte_spin_unlock;
 #endif
 }
+
+static int __init use_mwait_trigger(void)
+{
+	/*
+	 * If we're using normal native trigger operations and the cpu
+	 * supports mwait, then switch to using it.
+	 */
+	if (pv_lock_ops.trigger_wait == native_trigger_wait &&
+	    pv_lock_ops.trigger_reset == native_trigger_reset &&
+	    pv_lock_ops.trigger_kick == native_trigger_kick &&
+	    pv_lock_ops.trigger_finish == paravirt_nop &&
+	    boot_cpu_has(X86_FEATURE_MWAIT)) {
+		pv_lock_ops.trigger_reset = mwait_trigger_reset;
+		pv_lock_ops.trigger_wait = mwait_trigger_wait;
+		pv_lock_ops.trigger_kick = mwait_trigger_kick;
+		pv_lock_ops.trigger_finish = mwait_trigger_finish;
+	}
+
+	return 0;
+}
+early_initcall(use_mwait_trigger);
===================================================================
--- a/arch/x86/kernel/trigger.c
+++ b/arch/x86/kernel/trigger.c
@@ -1,5 +1,9 @@
 #include <linux/trigger.h>
 #include <linux/smp.h>
+#include <linux/percpu.h>
+#include <linux/irqflags.h>
+
+#include <asm/processor.h>
 
 void native_trigger_reset(trigger_t *t)
 {
@@ -20,4 +24,59 @@
 {
 	smp_wmb();
 	cpus_setall(t->cpus);
+	smp_wmb();
 }
+
+/*
+ * mwait requires interrupts to be disabled between monitor and mwait.
+ * On monitor, we disable interrupts and store the previous state
+ * here.  When mwaiting, we enable interrupts if they were originally
+ * enabled.
+ */
+static DEFINE_PER_CPU(unsigned long, mwait_saved_flags);
+
+void mwait_trigger_reset(trigger_t *t)
+{
+	unsigned long flags;
+
+	t->trigger = 0;
+
+	local_save_flags(flags);
+	__get_cpu_var(mwait_saved_flags) = flags;
+
+	__monitor(&t->trigger, 0, 0);
+}
+
+void mwait_trigger_wait(trigger_t *t)
+{
+	unsigned long flags = __get_cpu_var(mwait_saved_flags);
+	int cpu = smp_processor_id();
+
+	if (irqs_disabled_flags(flags)) {
+		while(!cpu_isset(cpu, t->cpus)) {
+			__mwait(0, 0);
+			barrier();
+			__monitor(&t->trigger, 0, 0);
+		}
+	} else {
+		while(!cpu_isset(cpu, t->cpus)) {
+			__sti_mwait(0, 0);
+			barrier();
+			local_irq_disable();
+			__monitor(&t->trigger, 0, 0);
+		}
+	}
+}
+
+void mwait_trigger_finish(trigger_t *t)
+{
+	local_irq_restore(__get_cpu_var(mwait_saved_flags));
+}
+
+void mwait_trigger_kick(trigger_t *t)
+{
+	cpus_setall(t->cpus);
+	smp_wmb();
+	t->trigger = 1;
+	smp_wmb();
+}
===================================================================
--- a/include/asm-x86/trigger.h
+++ b/include/asm-x86/trigger.h
@@ -1,5 +1,7 @@
 #ifndef _ASM_X86_TRIGGER_H
 #define _ASM_X86_TRIGGER_H
+
+#include <asm/cpufeature.h>
 
 #include <linux/cpumask.h>
 
@@ -30,27 +32,44 @@
 extern void native_trigger_wait(trigger_t *t);
 extern void native_trigger_kick(trigger_t *t);
 
+extern void mwait_trigger_reset(trigger_t *);
+extern void mwait_trigger_wait(trigger_t *);
+extern void mwait_trigger_finish(trigger_t *);
+extern void mwait_trigger_kick(trigger_t *);
+
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else  /* CONFIG_PARAVIRT */
 static inline void __raw_trigger_reset(trigger_t *t)
 {
-	native_trigger_reset(t);
+	if (boot_cpu_has(X86_FEATURE_MWAIT))
+		mwait_trigger_reset(t);
+	else
+		native_trigger_reset(t);
 }
 
 static inline void __raw_trigger_wait(trigger_t *t)
 {
-	native_trigger_wait(t);
+	if (boot_cpu_has(X86_FEATURE_MWAIT))
+		mwait_trigger_wait(t);
+	else
+		native_trigger_wait(t);
 }
 
 static inline void __raw_trigger_finish(trigger_t *t)
 {
-	native_trigger_finish(t);
+	if (boot_cpu_has(X86_FEATURE_MWAIT))
+		mwait_trigger_finish(t);
+	else
+		native_trigger_finish(t);
 }
 
 static inline void __raw_trigger_kick(trigger_t *t)
 {
-	native_trigger_kick(t);
+	if (boot_cpu_has(X86_FEATURE_MWAIT))
+		mwait_trigger_finish(t);
+	else
+		native_trigger_finish(t);
 }
 #endif	/* CONFIG_PARAVIRT */
 


