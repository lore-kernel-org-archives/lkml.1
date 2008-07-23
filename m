Return-Path: <linux-kernel-owner+w=401wt.eu-S1755671AbYGWU30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbYGWU30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 16:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbYGWU3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 16:29:06 -0400
Received: from gw.goop.org ([64.81.55.164]:60173 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756220AbYGWU3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 16:29:03 -0400
Message-ID: <4887948A.9070301@goop.org>
Date: Wed, 23 Jul 2008 13:28:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: x86: split spinlock implementations out into their own files
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ftrace requires certain low-level code, like spinlocks and timestamps,
to be compiled without -pg in order to avoid infinite recursion.  This
patch splits out the core paravirt spinlocks and the Xen spinlocks
into separate files which can be compiled without -pg.

Also do xen/time.c while we're about it.  As a result, we can now use
ftrace within a Xen domain.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/Makefile             |    4 
 arch/x86/kernel/paravirt-spinlocks.c |   31 +++++
 arch/x86/kernel/paravirt.c           |   23 ----
 arch/x86/xen/Makefile                |    8 +
 arch/x86/xen/smp.c                   |  167 -------------------------------
 arch/x86/xen/spinlock.c              |  183 ++++++++++++++++++++++++++++++++++
 arch/x86/xen/xen-ops.h               |    3 
 7 files changed, 226 insertions(+), 193 deletions(-)

===================================================================
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -10,7 +10,7 @@
 # Do not profile debug and lowlevel utilities
 CFLAGS_REMOVE_tsc.o = -pg
 CFLAGS_REMOVE_rtc.o = -pg
-CFLAGS_REMOVE_paravirt.o = -pg
+CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
 endif
 
 #
@@ -90,7 +90,7 @@
 obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
 obj-$(CONFIG_KVM_GUEST)		+= kvm.o
 obj-$(CONFIG_KVM_CLOCK)		+= kvmclock.o
-obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
+obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o paravirt-spinlocks.o
 obj-$(CONFIG_PARAVIRT_CLOCK)	+= pvclock.o
 
 obj-$(CONFIG_PCSPKR_PLATFORM)	+= pcspeaker.o
===================================================================
--- /dev/null
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -0,0 +1,31 @@
+/*
+ * Split spinlock implementation out into its own file, so it can be
+ * compiled in a FTRACE-compatible way.
+ */
+#include <linux/spinlock.h>
+#include <linux/module.h>
+
+#include <asm/paravirt.h>
+
+struct pv_lock_ops pv_lock_ops = {
+#ifdef CONFIG_SMP
+	.spin_is_locked = __ticket_spin_is_locked,
+	.spin_is_contended = __ticket_spin_is_contended,
+
+	.spin_lock = __ticket_spin_lock,
+	.spin_trylock = __ticket_spin_trylock,
+	.spin_unlock = __ticket_spin_unlock,
+#endif
+};
+EXPORT_SYMBOL_GPL(pv_lock_ops);
+
+void __init paravirt_use_bytelocks(void)
+{
+#ifdef CONFIG_SMP
+	pv_lock_ops.spin_is_locked = __byte_spin_is_locked;
+	pv_lock_ops.spin_is_contended = __byte_spin_is_contended;
+	pv_lock_ops.spin_lock = __byte_spin_lock;
+	pv_lock_ops.spin_trylock = __byte_spin_trylock;
+	pv_lock_ops.spin_unlock = __byte_spin_unlock;
+#endif
+}
===================================================================
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -270,17 +270,6 @@
 	return __get_cpu_var(paravirt_lazy_mode);
 }
 
-void __init paravirt_use_bytelocks(void)
-{
-#ifdef CONFIG_SMP
-	pv_lock_ops.spin_is_locked = __byte_spin_is_locked;
-	pv_lock_ops.spin_is_contended = __byte_spin_is_contended;
-	pv_lock_ops.spin_lock = __byte_spin_lock;
-	pv_lock_ops.spin_trylock = __byte_spin_trylock;
-	pv_lock_ops.spin_unlock = __byte_spin_unlock;
-#endif
-}
-
 struct pv_info pv_info = {
 	.name = "bare hardware",
 	.paravirt_enabled = 0,
@@ -466,18 +455,6 @@
 	.set_fixmap = native_set_fixmap,
 };
 
-struct pv_lock_ops pv_lock_ops = {
-#ifdef CONFIG_SMP
-	.spin_is_locked = __ticket_spin_is_locked,
-	.spin_is_contended = __ticket_spin_is_contended,
-
-	.spin_lock = __ticket_spin_lock,
-	.spin_trylock = __ticket_spin_trylock,
-	.spin_unlock = __ticket_spin_unlock,
-#endif
-};
-EXPORT_SYMBOL_GPL(pv_lock_ops);
-
 EXPORT_SYMBOL_GPL(pv_time_ops);
 EXPORT_SYMBOL    (pv_cpu_ops);
 EXPORT_SYMBOL    (pv_mmu_ops);
===================================================================
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -1,4 +1,10 @@
+ifdef CONFIG_FTRACE
+# Do not profile debug and lowlevel utilities
+CFLAGS_REMOVE_spinlock.o = -pg
+CFLAGS_REMOVE_time.o = -pg
+endif
+
 obj-y		:= enlighten.o setup.o multicalls.o mmu.o \
 			time.o xen-asm_$(BITS).o grant-table.o suspend.o
 
-obj-$(CONFIG_SMP)	+= smp.o
+obj-$(CONFIG_SMP)	+= smp.o spinlock.o
===================================================================
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -15,7 +15,6 @@
  * This does not handle HOTPLUG_CPU yet.
  */
 #include <linux/sched.h>
-#include <linux/kernel_stat.h>
 #include <linux/err.h>
 #include <linux/smp.h>
 
@@ -35,8 +34,6 @@
 
 #include "xen-ops.h"
 #include "mmu.h"
-
-static void __cpuinit xen_init_lock_cpu(int cpu);
 
 cpumask_t xen_cpu_initialized_map;
 
@@ -419,170 +416,6 @@
 	return IRQ_HANDLED;
 }
 
-struct xen_spinlock {
-	unsigned char lock;		/* 0 -> free; 1 -> locked */
-	unsigned short spinners;	/* count of waiting cpus */
-};
-
-static int xen_spin_is_locked(struct raw_spinlock *lock)
-{
-	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
-
-	return xl->lock != 0;
-}
-
-static int xen_spin_is_contended(struct raw_spinlock *lock)
-{
-	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
-
-	/* Not strictly true; this is only the count of contended
-	   lock-takers entering the slow path. */
-	return xl->spinners != 0;
-}
-
-static int xen_spin_trylock(struct raw_spinlock *lock)
-{
-	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
-	u8 old = 1;
-
-	asm("xchgb %b0,%1"
-	    : "+q" (old), "+m" (xl->lock) : : "memory");
-
-	return old == 0;
-}
-
-static DEFINE_PER_CPU(int, lock_kicker_irq) = -1;
-static DEFINE_PER_CPU(struct xen_spinlock *, lock_spinners);
-
-static inline void spinning_lock(struct xen_spinlock *xl)
-{
-	__get_cpu_var(lock_spinners) = xl;
-	wmb();			/* set lock of interest before count */
-	asm(LOCK_PREFIX " incw %0"
-	    : "+m" (xl->spinners) : : "memory");
-}
-
-static inline void unspinning_lock(struct xen_spinlock *xl)
-{
-	asm(LOCK_PREFIX " decw %0"
-	    : "+m" (xl->spinners) : : "memory");
-	wmb();			/* decrement count before clearing lock */
-	__get_cpu_var(lock_spinners) = NULL;
-}
-
-static noinline int xen_spin_lock_slow(struct raw_spinlock *lock)
-{
-	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
-	int irq = __get_cpu_var(lock_kicker_irq);
-	int ret;
-
-	/* If kicker interrupts not initialized yet, just spin */
-	if (irq == -1)
-		return 0;
-
-	/* announce we're spinning */
-	spinning_lock(xl);
-
-	/* clear pending */
-	xen_clear_irq_pending(irq);
-
-	/* check again make sure it didn't become free while
-	   we weren't looking  */
-	ret = xen_spin_trylock(lock);
-	if (ret)
-		goto out;
-
-	/* block until irq becomes pending */
-	xen_poll_irq(irq);
-	kstat_this_cpu.irqs[irq]++;
-
-out:
-	unspinning_lock(xl);
-	return ret;
-}
-
-static void xen_spin_lock(struct raw_spinlock *lock)
-{
-	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
-	int timeout;
-	u8 oldval;
-
-	do {
-		timeout = 1 << 10;
-
-		asm("1: xchgb %1,%0\n"
-		    "   testb %1,%1\n"
-		    "   jz 3f\n"
-		    "2: rep;nop\n"
-		    "   cmpb $0,%0\n"
-		    "   je 1b\n"
-		    "   dec %2\n"
-		    "   jnz 2b\n"
-		    "3:\n"
-		    : "+m" (xl->lock), "=q" (oldval), "+r" (timeout)
-		    : "1" (1)
-		    : "memory");
-
-	} while (unlikely(oldval != 0 && !xen_spin_lock_slow(lock)));
-}
-
-static noinline void xen_spin_unlock_slow(struct xen_spinlock *xl)
-{
-	int cpu;
-
-	for_each_online_cpu(cpu) {
-		/* XXX should mix up next cpu selection */
-		if (per_cpu(lock_spinners, cpu) == xl) {
-			xen_send_IPI_one(cpu, XEN_SPIN_UNLOCK_VECTOR);
-			break;
-		}
-	}
-}
-
-static void xen_spin_unlock(struct raw_spinlock *lock)
-{
-	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
-
-	smp_wmb();		/* make sure no writes get moved after unlock */
-	xl->lock = 0;		/* release lock */
-
-	/* make sure unlock happens before kick */
-	barrier();
-
-	if (unlikely(xl->spinners))
-		xen_spin_unlock_slow(xl);
-}
-
-static __cpuinit void xen_init_lock_cpu(int cpu)
-{
-	int irq;
-	const char *name;
-
-	name = kasprintf(GFP_KERNEL, "spinlock%d", cpu);
-	irq = bind_ipi_to_irqhandler(XEN_SPIN_UNLOCK_VECTOR,
-				     cpu,
-				     xen_reschedule_interrupt,
-				     IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
-				     name,
-				     NULL);
-
-	if (irq >= 0) {
-		disable_irq(irq); /* make sure it's never delivered */
-		per_cpu(lock_kicker_irq, cpu) = irq;
-	}
-
-	printk("cpu %d spinlock event irq %d\n", cpu, irq);
-}
-
-static void __init xen_init_spinlocks(void)
-{
-	pv_lock_ops.spin_is_locked = xen_spin_is_locked;
-	pv_lock_ops.spin_is_contended = xen_spin_is_contended;
-	pv_lock_ops.spin_lock = xen_spin_lock;
-	pv_lock_ops.spin_trylock = xen_spin_trylock;
-	pv_lock_ops.spin_unlock = xen_spin_unlock;
-}
-
 static const struct smp_ops xen_smp_ops __initdata = {
 	.smp_prepare_boot_cpu = xen_smp_prepare_boot_cpu,
 	.smp_prepare_cpus = xen_smp_prepare_cpus,
===================================================================
--- /dev/null
+++ b/arch/x86/xen/spinlock.c
@@ -0,0 +1,183 @@
+/*
+ * Split spinlock implementation out into its own file, so it can be
+ * compiled in a FTRACE-compatible way.
+ */
+#include <linux/kernel_stat.h>
+#include <linux/spinlock.h>
+
+#include <asm/paravirt.h>
+
+#include <xen/interface/xen.h>
+#include <xen/events.h>
+
+#include "xen-ops.h"
+
+struct xen_spinlock {
+	unsigned char lock;		/* 0 -> free; 1 -> locked */
+	unsigned short spinners;	/* count of waiting cpus */
+};
+
+static int xen_spin_is_locked(struct raw_spinlock *lock)
+{
+	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
+
+	return xl->lock != 0;
+}
+
+static int xen_spin_is_contended(struct raw_spinlock *lock)
+{
+	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
+
+	/* Not strictly true; this is only the count of contended
+	   lock-takers entering the slow path. */
+	return xl->spinners != 0;
+}
+
+static int xen_spin_trylock(struct raw_spinlock *lock)
+{
+	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
+	u8 old = 1;
+
+	asm("xchgb %b0,%1"
+	    : "+q" (old), "+m" (xl->lock) : : "memory");
+
+	return old == 0;
+}
+
+static DEFINE_PER_CPU(int, lock_kicker_irq) = -1;
+static DEFINE_PER_CPU(struct xen_spinlock *, lock_spinners);
+
+static inline void spinning_lock(struct xen_spinlock *xl)
+{
+	__get_cpu_var(lock_spinners) = xl;
+	wmb();			/* set lock of interest before count */
+	asm(LOCK_PREFIX " incw %0"
+	    : "+m" (xl->spinners) : : "memory");
+}
+
+static inline void unspinning_lock(struct xen_spinlock *xl)
+{
+	asm(LOCK_PREFIX " decw %0"
+	    : "+m" (xl->spinners) : : "memory");
+	wmb();			/* decrement count before clearing lock */
+	__get_cpu_var(lock_spinners) = NULL;
+}
+
+static noinline int xen_spin_lock_slow(struct raw_spinlock *lock)
+{
+	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
+	int irq = __get_cpu_var(lock_kicker_irq);
+	int ret;
+
+	/* If kicker interrupts not initialized yet, just spin */
+	if (irq == -1)
+		return 0;
+
+	/* announce we're spinning */
+	spinning_lock(xl);
+
+	/* clear pending */
+	xen_clear_irq_pending(irq);
+
+	/* check again make sure it didn't become free while
+	   we weren't looking  */
+	ret = xen_spin_trylock(lock);
+	if (ret)
+		goto out;
+
+	/* block until irq becomes pending */
+	xen_poll_irq(irq);
+	kstat_this_cpu.irqs[irq]++;
+
+out:
+	unspinning_lock(xl);
+	return ret;
+}
+
+static void xen_spin_lock(struct raw_spinlock *lock)
+{
+	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
+	int timeout;
+	u8 oldval;
+
+	do {
+		timeout = 1 << 10;
+
+		asm("1: xchgb %1,%0\n"
+		    "   testb %1,%1\n"
+		    "   jz 3f\n"
+		    "2: rep;nop\n"
+		    "   cmpb $0,%0\n"
+		    "   je 1b\n"
+		    "   dec %2\n"
+		    "   jnz 2b\n"
+		    "3:\n"
+		    : "+m" (xl->lock), "=q" (oldval), "+r" (timeout)
+		    : "1" (1)
+		    : "memory");
+
+	} while (unlikely(oldval != 0 && !xen_spin_lock_slow(lock)));
+}
+
+static noinline void xen_spin_unlock_slow(struct xen_spinlock *xl)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		/* XXX should mix up next cpu selection */
+		if (per_cpu(lock_spinners, cpu) == xl) {
+			xen_send_IPI_one(cpu, XEN_SPIN_UNLOCK_VECTOR);
+			break;
+		}
+	}
+}
+
+static void xen_spin_unlock(struct raw_spinlock *lock)
+{
+	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
+
+	smp_wmb();		/* make sure no writes get moved after unlock */
+	xl->lock = 0;		/* release lock */
+
+	/* make sure unlock happens before kick */
+	barrier();
+
+	if (unlikely(xl->spinners))
+		xen_spin_unlock_slow(xl);
+}
+
+static irqreturn_t dummy_handler(int irq, void *dev_id)
+{
+	BUG();
+	return IRQ_HANDLED;
+}
+
+void __cpuinit xen_init_lock_cpu(int cpu)
+{
+	int irq;
+	const char *name;
+
+	name = kasprintf(GFP_KERNEL, "spinlock%d", cpu);
+	irq = bind_ipi_to_irqhandler(XEN_SPIN_UNLOCK_VECTOR,
+				     cpu,
+				     dummy_handler,
+				     IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
+				     name,
+				     NULL);
+
+	if (irq >= 0) {
+		disable_irq(irq); /* make sure it's never delivered */
+		per_cpu(lock_kicker_irq, cpu) = irq;
+	}
+
+	printk("cpu %d spinlock event irq %d\n", cpu, irq);
+}
+
+void __init xen_init_spinlocks(void)
+{
+	pv_lock_ops.spin_is_locked = xen_spin_is_locked;
+	pv_lock_ops.spin_is_contended = xen_spin_is_contended;
+	pv_lock_ops.spin_lock = xen_spin_lock;
+	pv_lock_ops.spin_trylock = xen_spin_trylock;
+	pv_lock_ops.spin_unlock = xen_spin_unlock;
+}
===================================================================
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -50,6 +50,9 @@
 #ifdef CONFIG_SMP
 void xen_smp_init(void);
 
+void __init xen_init_spinlocks(void);
+__cpuinit void xen_init_lock_cpu(int cpu);
+
 extern cpumask_t xen_cpu_initialized_map;
 #else
 static inline void xen_smp_init(void) {}


