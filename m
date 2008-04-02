Return-Path: <linux-kernel-owner+w=401wt.eu-S1758782AbYDBSlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782AbYDBSlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757391AbYDBSfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:35:50 -0400
Received: from 21.sub-75-208-3.myvzw.com ([75.208.3.21]:38410 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757366AbYDBSfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:35:43 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 07 of 24] Xen: Make events.c portable for ia64/xen support
X-Mercurial-Node: 2be0ce717957fc186993ee918535c8c3f11136da
Message-Id: <2be0ce717957fc186993.1207158836@localhost>
In-Reply-To: <patchbomb.1207158829@localhost>
Date: Wed, 02 Apr 2008 10:53:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Isaku Yamahata <yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Isaku Yamahata <yamahata@valinux.co.jp>

Remove x86 dependency in drivers/xen/events.c for ia64/xen support
introducing include/asm/xen/events.h.
Introduce xen_irqs_disabled() to hide regs->flags
Introduce xen_do_IRQ() to hide regs->orig_ax.
make enum ipi_vector definition arch specific. ia64/xen needs four vectors.
Add one rmb() because on ia64 xchg() isn't barrier.

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/events.c         |   13 +++++++------
 include/asm-x86/xen/events.h |   22 ++++++++++++++++++++++
 include/xen/events.h         |   10 +---------
 3 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -469,7 +469,7 @@
 	for_each_online_cpu(i) {
 		struct vcpu_info *v = per_cpu(xen_vcpu, i);
 		printk("%d: masked=%d pending=%d event_sel %08lx\n  ", i,
-			(get_irq_regs() && i == cpu) ? !(get_irq_regs()->flags & X86_EFLAGS_IF) : v->evtchn_upcall_mask,
+			(get_irq_regs() && i == cpu) ? xen_irqs_disabled(get_irq_regs()) : v->evtchn_upcall_mask,
 			v->evtchn_upcall_pending,
 			v->evtchn_pending_sel);
 	}
@@ -527,7 +527,10 @@
 		if (__get_cpu_var(nesting_count)++)
 			goto out;
 
-		/* NB. No need for a barrier here -- XCHG is a barrier on x86. */
+#ifndef CONFIG_X86 /* No need for a barrier -- XCHG is a barrier on x86. */
+		/* Clear master flag /before/ clearing selector flag. */
+		rmb();
+#endif
 		pending_words = xchg(&vcpu_info->evtchn_pending_sel, 0);
 		while (pending_words != 0) {
 			unsigned long pending_bits;
@@ -539,10 +542,8 @@
 				int port = (word_idx * BITS_PER_LONG) + bit_idx;
 				int irq = evtchn_to_irq[port];
 
-				if (irq != -1) {
-					regs->orig_ax = ~irq;
-					do_IRQ(regs);
-				}
+				if (irq != -1)
+					xen_do_IRQ(irq, regs);
 			}
 		}
 
diff --git a/include/asm-x86/xen/events.h b/include/asm-x86/xen/events.h
new file mode 100644
--- /dev/null
+++ b/include/asm-x86/xen/events.h
@@ -0,0 +1,22 @@
+#ifndef __XEN_EVENTS_H
+#define __XEN_EVENTS_H
+
+enum ipi_vector {
+	XEN_RESCHEDULE_VECTOR,
+	XEN_CALL_FUNCTION_VECTOR,
+
+	XEN_NR_IPIS,
+};
+
+static inline int xen_irqs_disabled(struct pt_regs *regs)
+{
+	return raw_irqs_disabled_flags(regs->flags);
+}
+
+static inline void xen_do_IRQ(int irq, struct pt_regs *regs)
+{
+	regs->orig_ax = ~irq;
+	do_IRQ(regs);
+}
+
+#endif /* __XEN_EVENTS_H */
diff --git a/include/xen/events.h b/include/xen/events.h
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -5,13 +5,7 @@
 
 #include <xen/interface/event_channel.h>
 #include <asm/xen/hypercall.h>
-
-enum ipi_vector {
-	XEN_RESCHEDULE_VECTOR,
-	XEN_CALL_FUNCTION_VECTOR,
-
-	XEN_NR_IPIS,
-};
+#include <asm/xen/events.h>
 
 int bind_evtchn_to_irq(unsigned int evtchn);
 int bind_evtchn_to_irqhandler(unsigned int evtchn,


