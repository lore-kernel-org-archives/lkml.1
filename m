Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab0BXE3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 23:29:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:50535 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195Ab0BXE3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 23:29:06 -0500
Message-ID: <4B84AAC4.2020204@kernel.org>
Date: Tue, 23 Feb 2010 20:27:48 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, alek.du@intel.com, jacob.jun.pan@intel.com,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH -v2] x86: remove left over nr_legacy_irqs
References: <43F901BD926A4E43B106BF17856F07559FB80D01@orsmsx508.amr.corp.intel.com> <tip-d39f6495f66616b637260405d0b5dc2656bc490e@git.kernel.org> <4B8493A0.6080501@kernel.org> <4B84A846.1000805@kernel.org>
In-Reply-To: <4B84A846.1000805@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

already in legacy_pic

-v2: there is one in ioapic_.c

Singed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/irq.h     |    1 -
 arch/x86/kernel/apic/io_apic.c |    2 +-
 arch/x86/kernel/irqinit.c      |    7 ++-----
 3 files changed, 3 insertions(+), 7 deletions(-)

Index: linux-2.6/arch/x86/include/asm/irq.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/irq.h
+++ linux-2.6/arch/x86/include/asm/irq.h
@@ -48,6 +48,5 @@ extern DECLARE_BITMAP(used_vectors, NR_V
 extern int vector_used_by_percpu_irq(unsigned int vector);
 
 extern void init_ISA_irqs(void);
-extern int nr_legacy_irqs;
 
 #endif /* _ASM_X86_IRQ_H */
Index: linux-2.6/arch/x86/kernel/irqinit.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irqinit.c
+++ linux-2.6/arch/x86/kernel/irqinit.c
@@ -99,9 +99,6 @@ int vector_used_by_percpu_irq(unsigned i
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
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -1438,7 +1438,7 @@ static void setup_IO_APIC_irq(int apic_i
 	 * controllers like 8259. Now that IO-APIC can handle this irq, update
 	 * the cfg->domain.
 	 */
-	if (irq < nr_legacy_irqs && cpumask_test_cpu(0, cfg->domain))
+	if (irq < legacy_pic->nr_legacy_irqs && cpumask_test_cpu(0, cfg->domain))
 		apic->vector_allocation_domain(0, cfg->domain);
 
 	if (assign_irq_vector(irq, cfg, apic->target_cpus()))
