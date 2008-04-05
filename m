Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbYDEBNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbYDEBNl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 21:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbYDEBLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 21:11:12 -0400
Received: from relay1.sgi.com ([192.48.171.29]:57952 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751738AbYDEBLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 21:11:04 -0400
Message-Id: <20080405011102.807056000@polaris-admin.engr.sgi.com>
References: <20080405011100.720014000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 18:11:12 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 12/12] cpumask: Cleanup more uses of CPU_MASK and NODE_MASK
Content-Disposition: inline; filename=use-CPUMASK_ALL_PTR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 *  Replace usages of CPU_MASK_NONE, CPU_MASK_ALL, NODE_MASK_NONE,
    NODE_MASK_ALL to reduce stack requirements for large NR_CPUS
    and MAXNODES counts.

 *  In some cases, the cpumask variable was initialized but then overwritten
    with another value.  This is the case for changes like this:

    -       cpumask_t oldmask = CPU_MASK_ALL;
    +       cpumask_t oldmask;

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   x86/latest          .../x86/linux-2.6-x86.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/genapic_flat_64.c |    4 +++-
 arch/x86/kernel/io_apic_64.c      |    2 +-
 kernel/irq/chip.c                 |    2 +-
 mm/allocpercpu.c                  |    3 ++-
 4 files changed, 7 insertions(+), 4 deletions(-)

--- linux-2.6.x86.orig/arch/x86/kernel/genapic_flat_64.c
+++ linux-2.6.x86/arch/x86/kernel/genapic_flat_64.c
@@ -138,7 +138,9 @@ static cpumask_t physflat_target_cpus(vo
 
 static cpumask_t physflat_vector_allocation_domain(int cpu)
 {
-	cpumask_t domain = CPU_MASK_NONE;
+	cpumask_t domain;
+
+	cpus_clear(domain);
 	cpu_set(cpu, domain);
 	return domain;
 }
--- linux-2.6.x86.orig/arch/x86/kernel/io_apic_64.c
+++ linux-2.6.x86/arch/x86/kernel/io_apic_64.c
@@ -772,7 +772,7 @@ static void __clear_irq_vector(int irq)
 		per_cpu(vector_irq, cpu)[vector] = -1;
 
 	cfg->vector = 0;
-	cfg->domain = CPU_MASK_NONE;
+	cpus_clear(cfg->domain);
 }
 
 void __setup_vector_irq(int cpu)
--- linux-2.6.x86.orig/kernel/irq/chip.c
+++ linux-2.6.x86/kernel/irq/chip.c
@@ -47,7 +47,7 @@ void dynamic_irq_init(unsigned int irq)
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
 #ifdef CONFIG_SMP
-	desc->affinity = CPU_MASK_ALL;
+	cpus_setall(desc->affinity);
 #endif
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
--- linux-2.6.x86.orig/mm/allocpercpu.c
+++ linux-2.6.x86/mm/allocpercpu.c
@@ -82,9 +82,10 @@ EXPORT_SYMBOL_GPL(percpu_populate);
 int __percpu_populate_mask(void *__pdata, size_t size, gfp_t gfp,
 			   cpumask_t *mask)
 {
-	cpumask_t populated = CPU_MASK_NONE;
+	cpumask_t populated;
 	int cpu;
 
+	cpus_clear(populated);
 	for_each_cpu_mask(cpu, *mask)
 		if (unlikely(!percpu_populate(__pdata, size, gfp, cpu))) {
 			__percpu_depopulate_mask(__pdata, &populated);

-- 
