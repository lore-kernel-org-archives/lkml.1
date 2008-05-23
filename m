Return-Path: <linux-kernel-owner+w=401wt.eu-S1758281AbYEWNsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281AbYEWNsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755018AbYEWNo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:44:26 -0400
Received: from gw.goop.org ([64.81.55.164]:53252 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744AbYEWNoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:44:20 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 10 of 12] xen: implement save/restore
X-Mercurial-Node: 9e8d06e5ae80248298367fca811e994f0b9e80e3
Message-Id: <9e8d06e5ae8024829836.1211550077@localhost>
In-Reply-To: <patchbomb.1211550067@localhost>
Date: Fri, 23 May 2008 14:41:17 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements Xen save/restore and migration.

Saving is triggered via xenbus, which is polled in
drivers/xen/manage.c.  When a suspend request comes in, the kernel
prepares itself for saving by:

1 - Freeze all processes.  This is primarily to prevent any
    partially-completed pagetable updates from confusing the suspend
    process.  If CONFIG_PREEMPT isn't defined, then this isn't necessary.

2 - Suspend xenbus and other devices

3 - Stop_machine, to make sure all the other vcpus are quiescent.  The
    Xen tools require the domain to run its save off vcpu0.

4 - Within the stop_machine state, it pins any unpinned pgds (under
    construction or destruction), performs canonicalizes various other
    pieces of state (mostly converting mfns to pfns), and finally

5 - Suspend the domain

Restore reverses the steps used to save the domain, ending when all
the frozen processes are thawed.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/Makefile      |    2
 arch/x86/xen/enlighten.c   |    6 +-
 arch/x86/xen/mmu.c         |   46 ++++++++++++++++
 arch/x86/xen/smp.c         |    2
 arch/x86/xen/suspend.c     |   42 ++++++++++++++
 arch/x86/xen/time.c        |    8 ++
 arch/x86/xen/xen-ops.h     |    4 +
 drivers/xen/events.c       |   83 +++++++++++++++++++++++++++++
 drivers/xen/grant-table.c  |    4 -
 drivers/xen/manage.c       |  124 +++++++++++++++++++++++++++++++++++++++-----
 include/linux/page-flags.h |    1
 include/xen/events.h       |    3 +
 include/xen/grant_table.h  |    3 +
 include/xen/xen-ops.h      |    9 +++
 14 files changed, 317 insertions(+), 20 deletions(-)

diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -1,4 +1,4 @@
 obj-y		:= enlighten.o setup.o multicalls.o mmu.o \
-			time.o xen-asm.o grant-table.o
+			time.o xen-asm.o grant-table.o suspend.o
 
 obj-$(CONFIG_SMP)	+= smp.o
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -857,7 +857,7 @@
 			  PFN_DOWN(__pa(xen_start_info->pt_base)));
 }
 
-static __init void setup_shared_info(void)
+void xen_setup_shared_info(void)
 {
 	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
 		unsigned long addr = fix_to_virt(FIX_PARAVIRT_BOOTMAP);
@@ -894,7 +894,7 @@
 	pv_mmu_ops.release_pmd = xen_release_pmd;
 	pv_mmu_ops.set_pte = xen_set_pte;
 
-	setup_shared_info();
+	xen_setup_shared_info();
 
 	/* Actually pin the pagetable down, but we can't set PG_pinned
 	   yet because the page structures don't exist yet. */
@@ -902,7 +902,7 @@
 }
 
 /* This is called once we have the cpu_possible_map */
-void __init xen_setup_vcpu_info_placement(void)
+void xen_setup_vcpu_info_placement(void)
 {
 	int cpu;
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -560,6 +560,29 @@
 	xen_mc_issue(0);
 }
 
+/*
+ * On save, we need to pin all pagetables to make sure they get their
+ * mfns turned into pfns.  Search the list for any unpinned pgds and pin
+ * them (unpinned pgds are not currently in use, probably because the
+ * process is under construction or destruction).
+ */
+void xen_mm_pin_all(void)
+{
+	unsigned long flags;
+	struct page *page;
+
+	spin_lock_irqsave(&pgd_lock, flags);
+
+	list_for_each_entry(page, &pgd_list, lru) {
+		if (!PagePinned(page)) {
+			xen_pgd_pin((pgd_t *)page_address(page));
+			SetPageSavePinned(page);
+		}
+	}
+
+	spin_unlock_irqrestore(&pgd_lock, flags);
+}
+
 /* The init_mm pagetable is really pinned as soon as its created, but
    that's before we have page structures to store the bits.  So do all
    the book-keeping now. */
@@ -615,6 +638,29 @@
 	pgd_walk(pgd, unpin_page, TASK_SIZE);
 
 	xen_mc_issue(0);
+}
+
+/*
+ * On resume, undo any pinning done at save, so that the rest of the
+ * kernel doesn't see any unexpected pinned pagetables.
+ */
+void xen_mm_unpin_all(void)
+{
+	unsigned long flags;
+	struct page *page;
+
+	spin_lock_irqsave(&pgd_lock, flags);
+
+	list_for_each_entry(page, &pgd_list, lru) {
+		if (PageSavePinned(page)) {
+			BUG_ON(!PagePinned(page));
+			printk("unpinning pinned %p\n", page_address(page));
+			xen_pgd_unpin((pgd_t *)page_address(page));
+			ClearPageSavePinned(page);
+		}
+	}
+
+	spin_unlock_irqrestore(&pgd_lock, flags);
 }
 
 void xen_activate_mm(struct mm_struct *prev, struct mm_struct *next)
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -35,7 +35,7 @@
 #include "xen-ops.h"
 #include "mmu.h"
 
-static cpumask_t xen_cpu_initialized_map;
+cpumask_t xen_cpu_initialized_map;
 static DEFINE_PER_CPU(int, resched_irq) = -1;
 static DEFINE_PER_CPU(int, callfunc_irq) = -1;
 static DEFINE_PER_CPU(int, debug_irq) = -1;
diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
new file mode 100644
--- /dev/null
+++ b/arch/x86/xen/suspend.c
@@ -0,0 +1,42 @@
+#include <linux/types.h>
+
+#include <xen/interface/xen.h>
+#include <xen/grant_table.h>
+#include <xen/events.h>
+
+#include <asm/xen/hypercall.h>
+#include <asm/xen/page.h>
+
+#include "xen-ops.h"
+#include "mmu.h"
+
+void xen_pre_suspend(void)
+{
+	xen_start_info->store_mfn = mfn_to_pfn(xen_start_info->store_mfn);
+	xen_start_info->console.domU.mfn =
+		mfn_to_pfn(xen_start_info->console.domU.mfn);
+
+	BUG_ON(!irqs_disabled());
+
+	HYPERVISOR_shared_info = &xen_dummy_shared_info;
+	if (HYPERVISOR_update_va_mapping(fix_to_virt(FIX_PARAVIRT_BOOTMAP),
+					 __pte_ma(0), 0))
+		BUG();
+}
+
+void xen_post_suspend(int suspend_cancelled)
+{
+	if (suspend_cancelled) {
+		xen_start_info->store_mfn =
+			pfn_to_mfn(xen_start_info->store_mfn);
+		xen_start_info->console.domU.mfn =
+			pfn_to_mfn(xen_start_info->console.domU.mfn);
+	} else {
+#ifdef CONFIG_SMP
+		xen_cpu_initialized_map = cpu_online_map;
+#endif
+	}
+
+	xen_setup_shared_info();
+}
+
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -565,6 +565,14 @@
 	clockevents_register_device(&__get_cpu_var(xen_clock_events));
 }
 
+void xen_time_suspend(void)
+{
+}
+
+void xen_time_resume(void)
+{
+}
+
 __init void xen_time_init(void)
 {
 	int cpu = smp_processor_id();
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -9,6 +9,7 @@
 extern const char xen_hypervisor_callback[];
 extern const char xen_failsafe_callback[];
 
+struct trap_info;
 void xen_copy_trap_info(struct trap_info *traps);
 
 DECLARE_PER_CPU(unsigned long, xen_cr3);
@@ -19,6 +20,7 @@
 extern struct shared_info *HYPERVISOR_shared_info;
 
 void xen_setup_mfn_list_list(void);
+void xen_setup_shared_info(void);
 
 char * __init xen_memory_setup(void);
 void __init xen_arch_setup(void);
@@ -59,6 +61,8 @@
 int xen_smp_call_function_mask(cpumask_t mask, void (*func)(void *),
 			       void *info, int wait);
 
+extern cpumask_t xen_cpu_initialized_map;
+
 
 /* Declare an asm function, along with symbols needed to make it
    inlineable */
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -674,6 +674,89 @@
 	return ret;
 }
 
+static void restore_cpu_virqs(unsigned int cpu)
+{
+	struct evtchn_bind_virq bind_virq;
+	int virq, irq, evtchn;
+
+	for (virq = 0; virq < NR_VIRQS; virq++) {
+		if ((irq = per_cpu(virq_to_irq, cpu)[virq]) == -1)
+			continue;
+
+		BUG_ON(irq_info[irq].type != IRQT_VIRQ);
+		BUG_ON(irq_info[irq].index != virq);
+
+		/* Get a new binding from Xen. */
+		bind_virq.virq = virq;
+		bind_virq.vcpu = cpu;
+		if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_virq,
+						&bind_virq) != 0)
+			BUG();
+		evtchn = bind_virq.port;
+
+		/* Record the new mapping. */
+		evtchn_to_irq[evtchn] = irq;
+		irq_info[irq] = mk_irq_info(IRQT_VIRQ, virq, evtchn);
+		bind_evtchn_to_cpu(evtchn, cpu);
+
+		/* Ready for use. */
+		unmask_evtchn(evtchn);
+	}
+}
+
+static void restore_cpu_ipis(unsigned int cpu)
+{
+	struct evtchn_bind_ipi bind_ipi;
+	int ipi, irq, evtchn;
+
+	for (ipi = 0; ipi < XEN_NR_IPIS; ipi++) {
+		if ((irq = per_cpu(ipi_to_irq, cpu)[ipi]) == -1)
+			continue;
+
+		BUG_ON(irq_info[irq].type != IRQT_IPI);
+		BUG_ON(irq_info[irq].index != ipi);
+
+		/* Get a new binding from Xen. */
+		bind_ipi.vcpu = cpu;
+		if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_ipi,
+						&bind_ipi) != 0)
+			BUG();
+		evtchn = bind_ipi.port;
+
+		/* Record the new mapping. */
+		evtchn_to_irq[evtchn] = irq;
+		irq_info[irq] = mk_irq_info(IRQT_IPI, ipi, evtchn);
+		bind_evtchn_to_cpu(evtchn, cpu);
+
+		/* Ready for use. */
+		unmask_evtchn(evtchn);
+
+	}
+}
+
+void xen_irq_resume(void)
+{
+	unsigned int cpu, irq, evtchn;
+
+	init_evtchn_cpu_bindings();
+
+	/* New event-channel space is not 'live' yet. */
+	for (evtchn = 0; evtchn < NR_EVENT_CHANNELS; evtchn++)
+		mask_evtchn(evtchn);
+
+	/* No IRQ <-> event-channel mappings. */
+	for (irq = 0; irq < NR_IRQS; irq++)
+		irq_info[irq].evtchn = 0; /* zap event-channel binding */
+
+	for (evtchn = 0; evtchn < NR_EVENT_CHANNELS; evtchn++)
+		evtchn_to_irq[evtchn] = -1;
+
+	for_each_possible_cpu(cpu) {
+		restore_cpu_virqs(cpu);
+		restore_cpu_ipis(cpu);
+	}
+}
+
 static struct irq_chip xen_dynamic_chip __read_mostly = {
 	.name		= "xen-dyn",
 	.mask		= disable_dynirq,
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -471,14 +471,14 @@
 	return 0;
 }
 
-static int gnttab_resume(void)
+int gnttab_resume(void)
 {
 	if (max_nr_grant_frames() < nr_grant_frames)
 		return -ENOSYS;
 	return gnttab_map(0, nr_grant_frames - 1);
 }
 
-static int gnttab_suspend(void)
+int gnttab_suspend(void)
 {
 	arch_gnttab_unmap_shared(shared, nr_grant_frames);
 	return 0;
diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -5,21 +5,113 @@
 #include <linux/err.h>
 #include <linux/reboot.h>
 #include <linux/sysrq.h>
+#include <linux/stop_machine.h>
+#include <linux/freezer.h>
 
 #include <xen/xenbus.h>
+#include <xen/grant_table.h>
+#include <xen/events.h>
+#include <xen/hvc-console.h>
+#include <xen/xen-ops.h>
 
-#define SHUTDOWN_INVALID  -1
-#define SHUTDOWN_POWEROFF  0
-#define SHUTDOWN_SUSPEND   2
-/* Code 3 is SHUTDOWN_CRASH, which we don't use because the domain can only
- * report a crash, not be instructed to crash!
- * HALT is the same as POWEROFF, as far as we're concerned.  The tools use
- * the distinction when we return the reason code to them.
- */
-#define SHUTDOWN_HALT      4
+#include <asm/xen/hypercall.h>
+#include <asm/xen/page.h>
+
+enum shutdown_state {
+	SHUTDOWN_INVALID = -1,
+	SHUTDOWN_POWEROFF = 0,
+	SHUTDOWN_SUSPEND = 2,
+	/* Code 3 is SHUTDOWN_CRASH, which we don't use because the domain can only
+	   report a crash, not be instructed to crash!
+	   HALT is the same as POWEROFF, as far as we're concerned.  The tools use
+	   the distinction when we return the reason code to them.  */
+	 SHUTDOWN_HALT = 4,
+};
 
 /* Ignore multiple shutdown requests. */
-static int shutting_down = SHUTDOWN_INVALID;
+static enum shutdown_state shutting_down = SHUTDOWN_INVALID;
+
+static int xen_suspend(void *data)
+{
+	int *cancelled = data;
+
+	BUG_ON(!irqs_disabled());
+
+	load_cr3(swapper_pg_dir);
+
+	xen_mm_pin_all();
+	gnttab_suspend();
+	xen_time_suspend();
+	xen_pre_suspend();
+
+	/*
+	 * This hypercall returns 1 if suspend was cancelled
+	 * or the domain was merely checkpointed, and 0 if it
+	 * is resuming in a new domain.
+	 */
+	*cancelled = HYPERVISOR_suspend(virt_to_mfn(xen_start_info));
+
+	xen_post_suspend(*cancelled);
+	xen_time_resume();
+	gnttab_resume();
+	xen_mm_unpin_all();
+
+	if (!*cancelled) {
+		xen_irq_resume();
+		xen_console_resume();
+	}
+
+	return 0;
+}
+
+static void do_suspend(void)
+{
+	int err;
+	int cancelled = 1;
+
+	shutting_down = SHUTDOWN_SUSPEND;
+
+#ifdef CONFIG_PREEMPT
+	/* If the kernel is preemptible, we need to freeze all the processes
+	   to prevent them from being in the middle of a pagetable update
+	   during suspend. */
+	err = freeze_processes();
+	if (err) {
+		printk(KERN_ERR "xen suspend: freeze failed %d\n", err);
+		return;
+	}
+#endif
+
+	err = device_suspend(PMSG_SUSPEND);
+	if (err) {
+		printk(KERN_ERR "xen suspend: device_suspend %d\n", err);
+		goto out;
+	}
+
+	printk("suspending xenbus...\n");
+	/* XXX use normal device tree? */
+	xenbus_suspend();
+
+	err = stop_machine_run(xen_suspend, &cancelled, 0);
+	if (err) {
+		printk(KERN_ERR "failed to start xen_suspend: %d\n", err);
+		goto out;
+	}
+
+	if (!cancelled)
+		xenbus_resume();
+	else
+		xenbus_suspend_cancel();
+
+	device_resume();
+
+
+out:
+#ifdef CONFIG_PREEMPT
+	thaw_processes();
+#endif
+	shutting_down = SHUTDOWN_INVALID;
+}
 
 static void shutdown_handler(struct xenbus_watch *watch,
 			     const char **vec, unsigned int len)
@@ -52,11 +144,17 @@
 	}
 
 	if (strcmp(str, "poweroff") == 0 ||
-	    strcmp(str, "halt") == 0)
+	    strcmp(str, "halt") == 0) {
+		shutting_down = SHUTDOWN_POWEROFF;
 		orderly_poweroff(false);
-	else if (strcmp(str, "reboot") == 0)
+	} else if (strcmp(str, "reboot") == 0) {
+		shutting_down = SHUTDOWN_POWEROFF; /* ? */
 		ctrl_alt_del();
-	else {
+#ifdef CONFIG_PM_SLEEP
+	} else if (strcmp(str, "suspend") == 0) {
+		do_suspend();
+#endif
+	} else {
 		printk(KERN_INFO "Ignoring shutdown request: %s\n", str);
 		shutting_down = SHUTDOWN_INVALID;
 	}
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -157,6 +157,7 @@
 __PAGEFLAG(Slab, slab)
 PAGEFLAG(Checked, owner_priv_1)		/* Used by some filesystems */
 PAGEFLAG(Pinned, owner_priv_1) TESTSCFLAG(Pinned, owner_priv_1) /* Xen */
+PAGEFLAG(SavePinned, dirty);					/* Xen */
 PAGEFLAG(Reserved, reserved) __CLEARPAGEFLAG(Reserved, reserved)
 PAGEFLAG(Private, private) __CLEARPAGEFLAG(Private, private)
 	__SETPAGEFLAG(Private, private)
diff --git a/include/xen/events.h b/include/xen/events.h
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -41,4 +41,7 @@
 }
 
 extern void notify_remote_via_irq(int irq);
+
+extern void xen_irq_resume(void);
+
 #endif	/* _XEN_EVENTS_H */
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -50,6 +50,9 @@
 	void *arg;
 	u16 count;
 };
+
+int gnttab_suspend(void);
+int gnttab_resume(void);
 
 int gnttab_grant_foreign_access(domid_t domid, unsigned long frame,
 				int readonly);
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -5,4 +5,13 @@
 
 DECLARE_PER_CPU(struct vcpu_info *, xen_vcpu);
 
+void xen_pre_suspend(void);
+void xen_post_suspend(int suspend_cancelled);
+
+void xen_mm_pin_all(void);
+void xen_mm_unpin_all(void);
+
+void xen_time_suspend(void);
+void xen_time_resume(void);
+
 #endif /* INCLUDE_XEN_OPS_H */


