Return-Path: <linux-kernel-owner+w=401wt.eu-S1753721AbZALWIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbZALWIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbZALWFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:05:30 -0500
Received: from relay2.sgi.com ([192.48.179.30]:48530 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753896AbZALWFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:05:22 -0500
Message-Id: <20090112220520.435553000@polaris-admin.engr.sgi.com>
References: <20090112220519.566749000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 12 Jan 2009 14:05:25 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       <linux-parisc@vger.kernel.org>
Subject: [PATCH 6/8] parisc irq: update parisc for new irq_desc
Content-Disposition: inline; filename=irq:update-parisc-to-new-irq_desc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, update to new cpumask API

Irq_desc.affinity and irq_desc.pending_mask are now cpumask_var_t's
so access to them should be using the new cpumask API.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: <linux-parisc@vger.kernel.org>
---
 arch/parisc/kernel/irq.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6-for-ingo.orig/arch/parisc/kernel/irq.c
+++ linux-2.6-for-ingo/arch/parisc/kernel/irq.c
@@ -120,7 +120,7 @@ int cpu_check_affinity(unsigned int irq,
 	if (CHECK_IRQ_PER_CPU(irq)) {
 		/* Bad linux design decision.  The mask has already
 		 * been set; we must reset it */
-		irq_desc[irq].affinity = CPU_MASK_ALL;
+		cpumask_setall(irq_desc[irq].affinity);
 		return -EINVAL;
 	}
 
@@ -136,7 +136,7 @@ static void cpu_set_affinity_irq(unsigne
 	if (cpu_check_affinity(irq, dest))
 		return;
 
-	irq_desc[irq].affinity = *dest;
+	cpumask_copy(irq_desc[irq].affinity, dest);
 }
 #endif
 
@@ -295,7 +295,7 @@ int txn_alloc_irq(unsigned int bits_wide
 unsigned long txn_affinity_addr(unsigned int irq, int cpu)
 {
 #ifdef CONFIG_SMP
-	irq_desc[irq].affinity = cpumask_of_cpu(cpu);
+	cpumask_copy(irq_desc[irq].affinity, cpumask_of(cpu));
 #endif
 
 	return per_cpu(cpu_data, cpu).txn_addr;
@@ -352,7 +352,7 @@ void do_cpu_irq_mask(struct pt_regs *reg
 	irq = eirr_to_irq(eirr_val);
 
 #ifdef CONFIG_SMP
-	dest = irq_desc[irq].affinity;
+	cpumask_copy(&dest, irq_desc[irq].affinity);
 	if (CHECK_IRQ_PER_CPU(irq_desc[irq].status) &&
 	    !cpu_isset(smp_processor_id(), dest)) {
 		int cpu = first_cpu(dest);

-- 
