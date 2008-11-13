Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbYKMTrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbYKMTrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbYKMTek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:40 -0500
Received: from gw.goop.org ([64.81.55.164]:34445 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721AbYKMTeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:12 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 32 of 38] xen: use our own eventchannel->irq path
X-Mercurial-Node: 8e0d2520b48d674e8a4c5c7ead5fc20748381fda
Message-Id: <8e0d2520b48d674e8a4c.1226603430@abulafia.goop.org>
In-Reply-To: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:10:30 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than overloading vectors for event channels, take full
responsibility for mapping an event channel to irq directly.  With
this patch Xen has its own irq allocator.

When the kernel gets an event channel upcall, it maps the event
channel number to an irq and injects it into the normal interrupt
path.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/xen/events.h |    6 ------
 arch/x86/xen/irq.c                |   17 +----------------
 drivers/xen/events.c              |   22 ++++++++++++++++++++--
 3 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/xen/events.h b/arch/x86/include/asm/xen/events.h
--- a/arch/x86/include/asm/xen/events.h
+++ b/arch/x86/include/asm/xen/events.h
@@ -15,10 +15,4 @@
 	return raw_irqs_disabled_flags(regs->flags);
 }
 
-static inline void xen_do_IRQ(int irq, struct pt_regs *regs)
-{
-	regs->orig_ax = ~irq;
-	do_IRQ(regs);
-}
-
 #endif /* _ASM_X86_XEN_EVENTS_H */
diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
--- a/arch/x86/xen/irq.c
+++ b/arch/x86/xen/irq.c
@@ -19,21 +19,6 @@
 	(void)HYPERVISOR_xen_version(0, NULL);
 }
 
-static void __init __xen_init_IRQ(void)
-{
-	int i;
-
-	/* Create identity vector->irq map */
-	for(i = 0; i < NR_VECTORS; i++) {
-		int cpu;
-
-		for_each_possible_cpu(cpu)
-			per_cpu(vector_irq, cpu)[i] = i;
-	}
-
-	xen_init_IRQ();
-}
-
 static unsigned long xen_save_fl(void)
 {
 	struct vcpu_info *vcpu;
@@ -123,7 +108,7 @@
 }
 
 static const struct pv_irq_ops xen_irq_ops __initdata = {
-	.init_IRQ = __xen_init_IRQ,
+	.init_IRQ = xen_init_IRQ,
 	.save_fl = xen_save_fl,
 	.restore_fl = xen_restore_fl,
 	.irq_disable = xen_irq_disable,
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -29,6 +29,7 @@
 
 #include <asm/ptrace.h>
 #include <asm/irq.h>
+#include <asm/idle.h>
 #include <asm/sync_bitops.h>
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
@@ -503,6 +504,24 @@
 }
 
 
+static void xen_do_irq(unsigned irq, struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	if (WARN_ON(irq == -1))
+		return;
+
+	exit_idle();
+	irq_enter();
+
+	//printk("cpu %d handling irq %d\n", smp_processor_id(), info->irq);
+	handle_irq(irq, regs);
+
+	irq_exit();
+
+	set_irq_regs(old_regs);
+}
+
 /*
  * Search the CPUs pending events bitmasks.  For each one found, map
  * the event number to an irq, and feed it into do_IRQ() for
@@ -543,8 +562,7 @@
 				int port = (word_idx * BITS_PER_LONG) + bit_idx;
 				int irq = evtchn_to_irq[port];
 
-				if (irq != -1)
-					xen_do_IRQ(irq, regs);
+				xen_do_irq(irq, regs);
 			}
 		}
 


