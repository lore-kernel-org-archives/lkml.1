Return-Path: <linux-kernel-owner+w=401wt.eu-S935499AbXJSH4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935499AbXJSH4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 03:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933204AbXJSHzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 03:55:47 -0400
Received: from havoc.gtf.org ([69.61.125.42]:51863 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966970AbXJSHzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 03:55:44 -0400
Date: Fri, 19 Oct 2007 03:55:43 -0400
From: Jeff Garzik <jeff@garzik.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Subject: [PATCH 2/9] irq-remove: arch non-trivial
Message-ID: <20071019075543.GC6407@havoc.gtf.org>
References: <20071019075443.GA6407@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071019075443.GA6407@havoc.gtf.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit 8d45690dd90b18daaa21b981ab20caf393220bf0
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 00:46:23 2007 -0400

    [IRQ ARG REMOVAL] various non-trivial arch updates

 arch/x86/kernel/vm86_32.c     |    3 ++-
 include/asm-x86/irq_regs_32.h |   25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 1 deletion(-)

8d45690dd90b18daaa21b981ab20caf393220bf0
diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index 157e4be..18aae9e 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -739,10 +739,11 @@ static int irqbits;
 	| (1 << SIGUSR1) | (1 << SIGUSR2) | (1 << SIGIO)  | (1 << SIGURG) \
 	| (1 << SIGUNUSED) )
 	
-static irqreturn_t irq_handler(int intno, void *dev_id)
+static irqreturn_t irq_handler(void *dev_id)
 {
 	int irq_bit;
 	unsigned long flags;
+	unsigned int intno = get_irqfunc_irq();
 
 	spin_lock_irqsave(&irqbits_lock, flags);	
 	irq_bit = 1 << intno;
diff --git a/include/asm-x86/irq_regs_32.h b/include/asm-x86/irq_regs_32.h
index 3368b20..68a531d 100644
--- a/include/asm-x86/irq_regs_32.h
+++ b/include/asm-x86/irq_regs_32.h
@@ -26,4 +26,29 @@ static inline struct pt_regs *set_irq_regs(struct pt_regs *new_regs)
 	return old_regs;
 }
 
+DECLARE_PER_CPU(unsigned int, __irqfunc_irqs);
+
+static inline unsigned int get_irqfunc_irq(void)
+{
+	return __get_cpu_var(__irqfunc_irqs);
+}
+
+#if 0
+static inline unsigned int set_irqfunc_irq(unsigned int new_irq)
+{
+	unsigned int old_irq, *pirq = &__get_cpu_var(__irqfunc_irqs);
+
+	old_irq = *pirq;
+	*pirq = new_irq;
+	return old_irq;
+}
+#else
+static inline void set_irqfunc_irq(unsigned int new_irq)
+{
+	int *pirq = &__get_cpu_var(__irqfunc_irqs);
+
+	*pirq = new_irq;
+}
+#endif
+
 #endif /* _ASM_I386_IRQ_REGS_H */
