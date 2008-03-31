Return-Path: <linux-kernel-owner+w=401wt.eu-S1756311AbYCaJee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbYCaJee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 05:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754490AbYCaJe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 05:34:28 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:37920 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753962AbYCaJe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 05:34:27 -0400
Date: Mon, 31 Mar 2008 18:34:26 +0900
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: chrisw@sous-sol.org, sct@redhat.com,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       xen-ia64-devel@lists.xensource.com, eddie.dong@intel.com
Subject: Re: [PATCH 07/12] Xen: Make events.c portable for ia64/xen support.
Message-ID: <20080331093426.GG17609%yamahata@valinux.co.jp>
References: <12067044183207-git-send-email-yamahata@valinux.co.jp> <12067044180-git-send-email-yamahata@valinux.co.jp> <47ED54CE.7000007@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47ED54CE.7000007@goop.org>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 01:27:58PM -0700, Jeremy Fitzhardinge wrote:
> Isaku Yamahata wrote:
> >+/* macro to avoid header inclusion dependncy hell */
> >+#define xen_irqs_disabled(regs)	(!((regs)->flags & X86_EFLAGS_IF))
> >  
> 
> This seems pretty generic.  Is there no suitable existing function?  
> Could irqs_disabled_flags() be pressed into service?  I guess it depends 
> on how ia64 (and other architectures) can get the saved flags state from 
> the interrupt context.

Unfortunately ia64 doesn't support CONFIG_TRACE_IRQFLAGS_SUPPORT.
I couldn't found any generic one.

> >+
> >+/* macro to avoid header inclusion dependncy hell */
> >+#define xen_do_IRQ(irq, regs)			\
> >+	do {					\
> >+		(regs)->orig_ax = ~(irq);	\
> >+		do_IRQ(regs);			\
> >+	} while (0)
> >  
> 
> It's not possible to put this somewhere it could be an inline function?  
> It might be better to make it an out of line function then.

I revised events.c again so that I found that enum ipi_vector needs to
be arch specific because ia64/xen needs 4 vectors for ipi.
Thus I reached this one.

Changes before
- inetroduced include/asm/xen/events.h
- make enum ipi_vector arch spefic
- make xen_irqs_disabled() static inline.
- make xen_do_IRQ() static inline


>From 871d085cf15450a35497ded6b56a8bcb133d597a Mon Sep 17 00:00:00 2001
From: Isaku Yamahata <yamahata@valinux.co.jp>
Date: Mon, 31 Mar 2008 18:18:56 -0700
Subject: [PATCH 007/112] Xen: Make events.c portable for ia64/xen support.

Remove x86 dependency in drivers/xen/events.c for ia64/xen support
introducing include/asm/xen/events.h.
Introduce xen_irqs_disabled() to hide regs->flags
Introduce xen_do_IRQ() to hide regs->orig_ax.
make enum ipi_vector definition arch specific. ia64/xen needs four vectors.
Add one rmb() because on ia64 xchg() isn't barrier.

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
---
 drivers/xen/events.c         |   13 +++++++------
 include/asm-x86/xen/events.h |   22 ++++++++++++++++++++++
 include/xen/events.h         |    8 +-------
 3 files changed, 30 insertions(+), 13 deletions(-)
 create mode 100644 include/asm-x86/xen/events.h

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
 
diff --git a/include/asm-x86/xen/events.h b/include/asm-x86/xen/events.h
new file mode 100644
index 0000000..596312a
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
index 2bde54d..d99a3e0 100644
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
-- 
1.5.3



-- 
yamahata
