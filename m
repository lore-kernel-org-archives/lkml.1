Return-Path: <linux-kernel-owner+w=401wt.eu-S932491AbZFLQ3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491AbZFLQ3x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764562AbZFLQZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:25:13 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39085 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763371AbZFLQZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:25:04 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Yi Li <yi.li@analog.com>
Subject: [PATCH 15/27] Blackfin: update aedos-ipipe code to upstream 1.10-00
Date: Fri, 12 Jun 2009 12:24:33 -0400
Message-Id: <1244823885-22410-16-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
References: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yi Li <yi.li@analog.com>

Signed-off-by: Yi Li <yi.li@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/ipipe.h |   28 +++++++++++++-----------
 arch/blackfin/kernel/ipipe.c      |   42 +++++++++++++++++++-----------------
 2 files changed, 37 insertions(+), 33 deletions(-)

diff --git a/arch/blackfin/include/asm/ipipe.h b/arch/blackfin/include/asm/ipipe.h
index 51d0bf5..bbe1c37 100644
--- a/arch/blackfin/include/asm/ipipe.h
+++ b/arch/blackfin/include/asm/ipipe.h
@@ -35,10 +35,10 @@
 #include <asm/atomic.h>
 #include <asm/traps.h>
 
-#define IPIPE_ARCH_STRING     "1.9-01"
+#define IPIPE_ARCH_STRING     "1.10-00"
 #define IPIPE_MAJOR_NUMBER    1
-#define IPIPE_MINOR_NUMBER    9
-#define IPIPE_PATCH_NUMBER    1
+#define IPIPE_MINOR_NUMBER    10
+#define IPIPE_PATCH_NUMBER    0
 
 #ifdef CONFIG_SMP
 #error "I-pipe/blackfin: SMP not implemented"
@@ -54,10 +54,11 @@ do {						\
 
 #define task_hijacked(p)						\
 	({								\
-		int __x__ = ipipe_current_domain != ipipe_root_domain;	\
-		/* We would need to clear the SYNC flag for the root domain */ \
-		/* over the current processor in SMP mode. */		\
-		local_irq_enable_hw(); __x__;				\
+		int __x__ = __ipipe_root_domain_p;			\
+		__clear_bit(IPIPE_SYNC_FLAG, &ipipe_root_cpudom_var(status)); \
+		if (__x__)						\
+			local_irq_enable_hw();				\
+		!__x__;							\
 	})
 
 struct ipipe_domain;
@@ -179,23 +180,24 @@ static inline unsigned long __ipipe_ffnz(unsigned long ul)
 
 #define __ipipe_run_isr(ipd, irq)					\
 	do {								\
-		if (ipd == ipipe_root_domain) {				\
+		if (!__ipipe_pipeline_head_p(ipd))			\
 			local_irq_enable_hw();				\
-			if (ipipe_virtual_irq_p(irq))			\
+		if (ipd == ipipe_root_domain) {				\
+			if (unlikely(ipipe_virtual_irq_p(irq))) {	\
+				irq_enter();				\
 				ipd->irqs[irq].handler(irq, ipd->irqs[irq].cookie); \
-			else						\
+				irq_exit();				\
+			} else 						\
 				ipd->irqs[irq].handler(irq, &__raw_get_cpu_var(__ipipe_tick_regs)); \
-			local_irq_disable_hw();				\
 		} else {						\
 			__clear_bit(IPIPE_SYNC_FLAG, &ipipe_cpudom_var(ipd, status)); \
-			local_irq_enable_nohead(ipd);			\
 			ipd->irqs[irq].handler(irq, ipd->irqs[irq].cookie); \
 			/* Attempt to exit the outer interrupt level before \
 			 * starting the deferred IRQ processing. */	\
-			local_irq_disable_nohead(ipd);			\
 			__ipipe_run_irqtail();				\
 			__set_bit(IPIPE_SYNC_FLAG, &ipipe_cpudom_var(ipd, status)); \
 		}							\
+		local_irq_disable_hw();					\
 	} while (0)
 
 #define __ipipe_syscall_watched_p(p, sc)	\
diff --git a/arch/blackfin/kernel/ipipe.c b/arch/blackfin/kernel/ipipe.c
index 5fc4248..d8cde1f 100644
--- a/arch/blackfin/kernel/ipipe.c
+++ b/arch/blackfin/kernel/ipipe.c
@@ -99,7 +99,7 @@ void __ipipe_handle_irq(unsigned irq, struct pt_regs *regs)
 	 * interrupt.
 	 */
 	m_ack = (regs == NULL || irq == IRQ_SYSTMR || irq == IRQ_CORETMR);
-	this_domain = ipipe_current_domain;
+	this_domain = __ipipe_current_domain;
 
 	if (unlikely(test_bit(IPIPE_STICKY_FLAG, &this_domain->irqs[irq].control)))
 		head = &this_domain->p_link;
@@ -212,7 +212,9 @@ void __ipipe_unstall_root_raw(void)
 
 int __ipipe_syscall_root(struct pt_regs *regs)
 {
+	struct ipipe_percpu_domain_data *p;
 	unsigned long flags;
+	int ret;
 
 	/*
 	 * We need to run the IRQ tail hook whenever we don't
@@ -231,29 +233,31 @@ int __ipipe_syscall_root(struct pt_regs *regs)
 	/*
 	 * This routine either returns:
 	 * 0 -- if the syscall is to be passed to Linux;
-	 * 1 -- if the syscall should not be passed to Linux, and no
+	 * >0 -- if the syscall should not be passed to Linux, and no
 	 * tail work should be performed;
-	 * -1 -- if the syscall should not be passed to Linux but the
+	 * <0 -- if the syscall should not be passed to Linux but the
 	 * tail work has to be performed (for handling signals etc).
 	 */
 
-	if (__ipipe_event_monitored_p(IPIPE_EVENT_SYSCALL) &&
-	    __ipipe_dispatch_event(IPIPE_EVENT_SYSCALL, regs) > 0) {
-		if (ipipe_root_domain_p && !in_atomic()) {
-			/*
-			 * Sync pending VIRQs before _TIF_NEED_RESCHED
-			 * is tested.
-			 */
-			local_irq_save_hw(flags);
-			if ((ipipe_root_cpudom_var(irqpend_himask) & IPIPE_IRQMASK_VIRT) != 0)
-				__ipipe_sync_pipeline(IPIPE_IRQMASK_VIRT);
-			local_irq_restore_hw(flags);
-			return -1;
-		}
+	if (!__ipipe_event_monitored_p(IPIPE_EVENT_SYSCALL))
+		return 0;
+
+	ret = __ipipe_dispatch_event(IPIPE_EVENT_SYSCALL, regs);
+
+	local_irq_save_hw(flags);
+
+	if (!__ipipe_root_domain_p) {
+		local_irq_restore_hw(flags);
 		return 1;
 	}
 
-	return 0;
+	p = ipipe_root_cpudom_ptr();
+	if ((p->irqpend_himask & IPIPE_IRQMASK_VIRT) != 0)
+		__ipipe_sync_pipeline(IPIPE_IRQMASK_VIRT);
+
+	local_irq_restore_hw(flags);
+
+	return -ret;
 }
 
 unsigned long ipipe_critical_enter(void (*syncfn) (void))
@@ -329,9 +333,7 @@ asmlinkage void __ipipe_sync_root(void)
 
 void ___ipipe_sync_pipeline(unsigned long syncmask)
 {
-	struct ipipe_domain *ipd = ipipe_current_domain;
-
-	if (ipd == ipipe_root_domain) {
+	if (__ipipe_root_domain_p) {
 		if (test_bit(IPIPE_SYNCDEFER_FLAG, &ipipe_root_cpudom_var(status)))
 			return;
 	}
-- 
1.6.3.1

