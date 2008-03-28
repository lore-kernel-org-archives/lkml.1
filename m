Return-Path: <linux-kernel-owner+w=401wt.eu-S1757286AbYC1Lmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286AbYC1Lmr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 07:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598AbYC1LkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 07:40:25 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:44550 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753752AbYC1LkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 07:40:20 -0400
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: jeremy@goop.org
Cc: chrisw@sous-sol.org, sct@redhat.com,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       xen-ia64-devel@lists.xensource.com, eddie.dong@intel.com,
       yamahata@valinux.co.jp
Subject: [PATCH 07/12] Xen: Make events.c portable for ia64/xen support.
Date: Fri, 28 Mar 2008 20:40:13 +0900
Message-Id: <12067044180-git-send-email-yamahata@valinux.co.jp>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <12067044183207-git-send-email-yamahata@valinux.co.jp>
References: <12067044183207-git-send-email-yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove x86 dependency in drivers/xen/events.c for ia64/xen support.
Introduce xen_irqs_disabled() to hide regs->flags
Introduce xen_do_IRQ() to hide regs->orig_ax.
Add one rmb() because on ia64 xchg() isn't barrier.

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
---
 drivers/xen/events.c             |   13 +++++++------
 include/asm-x86/xen/hypervisor.h |   10 ++++++++++
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index c50d499..2396b44 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -469,7 +469,7 @@ irqreturn_t xen_debug_interrupt(int irq, void *dev_id)
 	for_each_online_cpu(i) {
 		struct vcpu_info *v = per_cpu(xen_vcpu, i);
 		printk("%d: masked=%d pending=%d event_sel %08lx\n  ", i,
-			(get_irq_regs() && i == cpu) ? !(get_irq_regs()->flags & X86_EFLAGS_IF) : v->evtchn_upcall_mask,
+			(get_irq_regs() && i == cpu) ? xen_irqs_disabled(get_irq_regs()) : v->evtchn_upcall_mask,
 			v->evtchn_upcall_pending,
 			v->evtchn_pending_sel);
 	}
@@ -527,7 +527,10 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
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
@@ -539,10 +542,8 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
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
 
diff --git a/include/asm-x86/xen/hypervisor.h b/include/asm-x86/xen/hypervisor.h
index 8e15dd2..767a361 100644
--- a/include/asm-x86/xen/hypervisor.h
+++ b/include/asm-x86/xen/hypervisor.h
@@ -61,6 +61,16 @@ extern struct start_info *xen_start_info;
 /* Force a proper event-channel callback from Xen. */
 extern void force_evtchn_callback(void);
 
+/* macro to avoid header inclusion dependncy hell */
+#define xen_irqs_disabled(regs)	(!((regs)->flags & X86_EFLAGS_IF))
+
+/* macro to avoid header inclusion dependncy hell */
+#define xen_do_IRQ(irq, regs)			\
+	do {					\
+		(regs)->orig_ax = ~(irq);	\
+		do_IRQ(regs);			\
+	} while (0)
+
 /* Turn jiffies into Xen system time. */
 u64 jiffies_to_st(unsigned long jiffies);
 
-- 
1.5.3

