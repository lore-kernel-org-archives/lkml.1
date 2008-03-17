Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbYCRF0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbYCRF0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbYCRFYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:24:10 -0400
Received: from gw.goop.org ([64.81.55.164]:37834 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbYCRFYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:24:06 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 27 of 31] xen: implement a debug-interrupt handler
X-Mercurial-Node: 8634e9f84d7f4ef2988b121c2650c43242ebac9b
Message-Id: <8634e9f84d7f4ef2988b.1205797038@localhost>
In-Reply-To: <patchbomb.1205797011@localhost>
Date: Mon, 17 Mar 2008 16:37:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen supports the notion of a debug interrupt which can be triggered
from the console.  For now this is implemented to show pending events,
masks and each CPU's pending event set.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/events.c  |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/xen/smp.c     |   19 ++++++++++++++-----
 arch/x86/xen/xen-ops.h |    3 +++
 3 files changed, 64 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/events.c b/arch/x86/xen/events.c
--- a/arch/x86/xen/events.c
+++ b/arch/x86/xen/events.c
@@ -455,6 +455,53 @@
 	notify_remote_via_irq(irq);
 }
 
+irqreturn_t xen_debug_interrupt(int irq, void *dev_id)
+{
+	struct shared_info *sh = HYPERVISOR_shared_info;
+	int cpu = smp_processor_id();
+	int i;
+	unsigned long flags;
+	static DEFINE_SPINLOCK(debug_lock);
+
+	spin_lock_irqsave(&debug_lock, flags);
+
+	printk("vcpu %d\n  ", cpu);
+
+	for_each_online_cpu(i) {
+		struct vcpu_info *v = per_cpu(xen_vcpu, i);
+		printk("%d: masked=%d pending=%d event_sel %08lx\n  ", i,
+			(get_irq_regs() && i == cpu) ? !(get_irq_regs()->flags & X86_EFLAGS_IF) : v->evtchn_upcall_mask,
+			v->evtchn_upcall_pending,
+			v->evtchn_pending_sel);
+	}
+	printk("pending:\n   ");
+	for(i = ARRAY_SIZE(sh->evtchn_pending)-1; i >= 0; i--)
+		printk("%08lx%s", sh->evtchn_pending[i],
+			i % 8 == 0 ? "\n   " : " ");
+	printk("\nmasks:\n   ");
+	for(i = ARRAY_SIZE(sh->evtchn_mask)-1; i >= 0; i--)
+		printk("%08lx%s", sh->evtchn_mask[i],
+			i % 8 == 0 ? "\n   " : " ");
+
+	printk("\nunmasked:\n   ");
+	for(i = ARRAY_SIZE(sh->evtchn_mask)-1; i >= 0; i--)
+		printk("%08lx%s", sh->evtchn_pending[i] & ~sh->evtchn_mask[i],
+			i % 8 == 0 ? "\n   " : " ");
+
+	printk("\npending list:\n");
+	for(i = 0; i < NR_EVENT_CHANNELS; i++) {
+		if (sync_test_bit(i, sh->evtchn_pending)) {
+			printk("  %d: event %d -> irq %d\n",
+				cpu_evtchn[i], i,
+				evtchn_to_irq[i]);
+		}
+	}
+
+	spin_unlock_irqrestore(&debug_lock, flags);
+
+	return IRQ_HANDLED;
+}
+
 
 /*
  * Search the CPUs pending events bitmasks.  For each one found, map
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -36,8 +36,9 @@
 #include "mmu.h"
 
 static cpumask_t cpu_initialized_map;
-static DEFINE_PER_CPU(int, resched_irq);
-static DEFINE_PER_CPU(int, callfunc_irq);
+static DEFINE_PER_CPU(int, resched_irq) = -1;
+static DEFINE_PER_CPU(int, callfunc_irq) = -1;
+static DEFINE_PER_CPU(int, debug_irq) = -1;
 
 /*
  * Structure and data for smp_call_function(). This is designed to minimise
@@ -89,9 +90,7 @@
 static int xen_smp_intr_init(unsigned int cpu)
 {
 	int rc;
-	const char *resched_name, *callfunc_name;
-
-	per_cpu(resched_irq, cpu) = per_cpu(callfunc_irq, cpu) = -1;
+	const char *resched_name, *callfunc_name, *debug_name;
 
 	resched_name = kasprintf(GFP_KERNEL, "resched%d", cpu);
 	rc = bind_ipi_to_irqhandler(XEN_RESCHEDULE_VECTOR,
@@ -115,6 +114,14 @@
 		goto fail;
 	per_cpu(callfunc_irq, cpu) = rc;
 
+	debug_name = kasprintf(GFP_KERNEL, "debug%d", cpu);
+	rc = bind_virq_to_irqhandler(VIRQ_DEBUG, cpu, xen_debug_interrupt,
+				     IRQF_DISABLED | IRQF_PERCPU | IRQF_NOBALANCING,
+				     debug_name, NULL);
+	if (rc < 0)
+		goto fail;
+	per_cpu(debug_irq, cpu) = rc;
+
 	return 0;
 
  fail:
@@ -122,6 +129,8 @@
 		unbind_from_irqhandler(per_cpu(resched_irq, cpu), NULL);
 	if (per_cpu(callfunc_irq, cpu) >= 0)
 		unbind_from_irqhandler(per_cpu(callfunc_irq, cpu), NULL);
+	if (per_cpu(debug_irq, cpu) >= 0)
+		unbind_from_irqhandler(per_cpu(debug_irq, cpu), NULL);
 	return rc;
 }
 
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -2,6 +2,7 @@
 #define XEN_OPS_H
 
 #include <linux/init.h>
+#include <linux/irqreturn.h>
 
 /* These are code, but not functions.  Defined in entry.S */
 extern const char xen_hypervisor_callback[];
@@ -29,6 +30,8 @@
 int xen_set_wallclock(unsigned long time);
 unsigned long long xen_sched_clock(void);
 
+irqreturn_t xen_debug_interrupt(int irq, void *dev_id);
+
 bool xen_vcpu_stolen(int vcpu);
 
 void xen_mark_init_mm_pinned(void);


