Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbYHPQep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbYHPQep (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 12:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbYHPQe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 12:34:27 -0400
Received: from gw.goop.org ([64.81.55.164]:47262 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626AbYHPQe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 12:34:26 -0400
Message-ID: <48A7018F.3050808@goop.org>
Date: Sat, 16 Aug 2008 09:34:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH RFC 2/3] x86: implement trigger API
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an x86-specific implementation.  This patch doesn't do much other
than wire it up to paravirt_ops, and lay the groundwork for the
upcoming monitor/mwait implementation.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/Kconfig                     |    3 +
 arch/x86/kernel/Makefile             |    1 
 arch/x86/kernel/paravirt-spinlocks.c |    6 +++
 arch/x86/kernel/trigger.c            |   23 ++++++++++++++
 include/asm-x86/paravirt.h           |   27 +++++++++++++++++
 include/asm-x86/trigger.h            |   54 ++++++++++++++++++++++++++++++++++
 6 files changed, 114 insertions(+)

===================================================================
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -124,6 +124,9 @@
 
 config ARCH_HAS_CPU_RELAX
 	def_bool y
+
+config ARCH_HAS_TRIGGER
+        def_bool y
 
 config ARCH_HAS_CACHE_LINE_SIZE
 	def_bool y
===================================================================
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -36,6 +36,7 @@
 obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o
 obj-y			+= tsc.o io_delay.o rtc.o
+obj-y			+= trigger.o
 
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
 obj-y				+= process.o
===================================================================
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -3,6 +3,7 @@
  * compiled in a FTRACE-compatible way.
  */
 #include <linux/spinlock.h>
+#include <linux/trigger.h>
 #include <linux/module.h>
 
 #include <asm/paravirt.h>
@@ -22,6 +23,11 @@
 	.spin_trylock = __ticket_spin_trylock,
 	.spin_unlock = __ticket_spin_unlock,
 #endif
+
+	.trigger_wait = native_trigger_wait,
+	.trigger_reset = native_trigger_reset,
+	.trigger_kick = native_trigger_kick,
+	.trigger_finish = paravirt_nop,
 };
 EXPORT_SYMBOL_GPL(pv_lock_ops);
 
===================================================================
--- /dev/null
+++ b/arch/x86/kernel/trigger.c
@@ -0,0 +1,23 @@
+#include <linux/trigger.h>
+#include <linux/smp.h>
+
+void native_trigger_reset(trigger_t *t)
+{
+	cpu_clear(smp_processor_id(), t->cpus);
+}
+
+void native_trigger_wait(trigger_t *t)
+{
+	int cpu = smp_processor_id();
+
+	while(!cpu_isset(cpu, t->cpus))
+		cpu_relax();
+
+	cpu_clear(cpu, t->cpus);
+}
+
+void native_trigger_kick(trigger_t *t)
+{
+	smp_wmb();
+	cpus_setall(t->cpus);
+}
===================================================================
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -324,6 +324,8 @@
 };
 
 struct raw_spinlock;
+struct trigger;
+
 struct pv_lock_ops {
 	int (*spin_is_locked)(struct raw_spinlock *lock);
 	int (*spin_is_contended)(struct raw_spinlock *lock);
@@ -331,6 +333,11 @@
 	void (*spin_lock_flags)(struct raw_spinlock *lock, unsigned long flags);
 	int (*spin_trylock)(struct raw_spinlock *lock);
 	void (*spin_unlock)(struct raw_spinlock *lock);
+
+	void (*trigger_reset)(struct trigger *t);
+	void (*trigger_wait)(struct trigger *t);
+	void (*trigger_kick)(struct trigger *t);
+	void (*trigger_finish)(struct trigger *t);
 };
 
 /* This contains all the paravirt structures: we get a convenient
@@ -1415,6 +1422,26 @@
 
 #endif
 
+static __always_inline void __raw_trigger_reset(struct trigger *t)
+{
+	PVOP_VCALL1(pv_lock_ops.trigger_reset, t);
+}
+
+static __always_inline void __raw_trigger_wait(struct trigger *t)
+{
+	PVOP_VCALL1(pv_lock_ops.trigger_wait, t);
+}
+
+static __always_inline void __raw_trigger_kick(struct trigger *t)
+{
+	PVOP_VCALL1(pv_lock_ops.trigger_kick, t);
+}
+
+static __always_inline void __raw_trigger_finish(struct trigger *t)
+{
+	PVOP_VCALL1(pv_lock_ops.trigger_finish, t);
+}
+
 /* These all sit in the .parainstructions section to tell us what to patch. */
 struct paravirt_patch_site {
 	u8 *instr; 		/* original instructions */
===================================================================
--- /dev/null
+++ b/include/asm-x86/trigger.h
@@ -0,0 +1,54 @@
+#ifndef _ASM_X86_TRIGGER_H
+#define _ASM_X86_TRIGGER_H
+
+#include <linux/cpumask.h>
+
+struct trigger {
+	unsigned trigger;
+	cpumask_t cpus;
+};
+
+typedef struct trigger trigger_t;
+
+#define DEFINE_TRIGGER(t)	trigger_t t = { 0, CPU_MASK_NONE }
+
+static inline void __raw_trigger_init(trigger_t *t)
+{
+	t->cpus = CPU_MASK_NONE;
+	t->trigger = 0;
+}
+
+static inline void native_trigger_finish(trigger_t *t)
+{
+}
+
+/* out of line to avoid #include hell */
+extern void native_trigger_reset(trigger_t *t);
+extern void native_trigger_wait(trigger_t *t);
+extern void native_trigger_kick(trigger_t *t);
+
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else  /* CONFIG_PARAVIRT */
+static inline void __raw_trigger_reset(trigger_t *t)
+{
+	native_trigger_reset(t);
+}
+
+static inline void __raw_trigger_wait(trigger_t *t)
+{
+	native_trigger_wait(t);
+}
+
+static inline void __raw_trigger_finish(trigger_t *t)
+{
+	native_trigger_finish(t);
+}
+
+static inline void __raw_trigger_kick(trigger_t *t)
+{
+	native_trigger_kick(t);
+}
+#endif	/* CONFIG_PARAVIRT */
+
+#endif	/* _ASM_X86_TRIGGER_H */


