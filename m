Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612Ab0BXTEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 14:04:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:54155 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757584Ab0BXTE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 14:04:28 -0500
Date: Wed, 24 Feb 2010 19:04:18 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de
In-Reply-To: <4B84AAC4.2020204@kernel.org>
References: <4B84AAC4.2020204@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86, legacy_irq: Remove left over nr_legacy_irqs
Message-ID: <tip-28c6a0ba30457380b140d9d7a61530eda8969180@git.kernel.org>
Git-Commit-ID: 28c6a0ba30457380b140d9d7a61530eda8969180
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 24 Feb 2010 19:04:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  28c6a0ba30457380b140d9d7a61530eda8969180
Gitweb:     http://git.kernel.org/tip/28c6a0ba30457380b140d9d7a61530eda8969180
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Tue, 23 Feb 2010 20:27:48 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 24 Feb 2010 11:01:34 -0800

x86, legacy_irq: Remove left over nr_legacy_irqs

nr_legacy_irqs and its ilk have moved to legacy_pic.

-v2: there is one in ioapic_.c

Singed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4B84AAC4.2020204@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/irq.h     |    1 -
 arch/x86/kernel/apic/io_apic.c |    2 +-
 arch/x86/kernel/irqinit.c      |    7 ++-----
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index 2622927..5458380 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -48,6 +48,5 @@ extern DECLARE_BITMAP(used_vectors, NR_VECTORS);
 extern int vector_used_by_percpu_irq(unsigned int vector);
 
 extern void init_ISA_irqs(void);
-extern int nr_legacy_irqs;
 
 #endif /* _ASM_X86_IRQ_H */
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 8c848b5..b9d08f0 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1440,7 +1440,7 @@ static void setup_IO_APIC_irq(int apic_id, int pin, unsigned int irq, struct irq
 	 * controllers like 8259. Now that IO-APIC can handle this irq, update
 	 * the cfg->domain.
 	 */
-	if (irq < nr_legacy_irqs && cpumask_test_cpu(0, cfg->domain))
+	if (irq < legacy_pic->nr_legacy_irqs && cpumask_test_cpu(0, cfg->domain))
 		apic->vector_allocation_domain(0, cfg->domain);
 
 	if (assign_irq_vector(irq, cfg, apic->target_cpus()))
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index d2f787b..ef257fc 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -99,9 +99,6 @@ int vector_used_by_percpu_irq(unsigned int vector)
 	return 0;
 }
 
-/* Number of legacy interrupts */
-int nr_legacy_irqs __read_mostly = NR_IRQS_LEGACY;
-
 void __init init_ISA_irqs(void)
 {
 	int i;
@@ -114,7 +111,7 @@ void __init init_ISA_irqs(void)
 	/*
 	 * 16 old-style INTA-cycle interrupts:
 	 */
-	for (i = 0; i < NR_IRQS_LEGACY; i++) {
+	for (i = 0; i < legacy_pic->nr_legacy_irqs; i++) {
 		struct irq_desc *desc = irq_to_desc(i);
 
 		desc->status = IRQ_DISABLED;
@@ -138,7 +135,7 @@ void __init init_IRQ(void)
 	 * then this vector space can be freed and re-used dynamically as the
 	 * irq's migrate etc.
 	 */
-	for (i = 0; i < nr_legacy_irqs; i++)
+	for (i = 0; i < legacy_pic->nr_legacy_irqs; i++)
 		per_cpu(vector_irq, 0)[IRQ0_VECTOR + i] = i;
 
 	x86_init.irqs.intr_init();
