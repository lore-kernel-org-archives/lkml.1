Return-Path: <linux-kernel-owner+w=401wt.eu-S938970AbXGSOEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938970AbXGSOEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765302AbXGSNtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:49:11 -0400
Received: from ns1.suse.de ([195.135.220.2]:54574 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764934AbXGSNtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:49:05 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: stefanr@s5r6.in-berlin.de, mingo@elte.hu, ak@suse.de,
       rpjday@mindspring.com, linux-kernel@vger.kernel.org
Subject: [PATCH for review] [33/48] i386: remove old IRQ balancing debug cruft
Message-Id: <20070719134903.A60C014E71@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:49:03 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Stefan Richter <stefanr@s5r6.in-berlin.de>

Dead or misnamed CONFIG_BALANCED_IRQ_DEBUG found by Robert P. J. Day.
It's not a Kconfig variable.

Since this debug code is ancient, I suggest to get rid of this
misleading CONFIG_ macro by deleting all of this debug code.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/io_apic.c |   24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

Index: linux/arch/i386/kernel/io_apic.c
===================================================================
--- linux.orig/arch/i386/kernel/io_apic.c
+++ linux/arch/i386/kernel/io_apic.c
@@ -353,14 +353,6 @@ static void set_ioapic_affinity_irq(unsi
 # include <linux/slab.h>		/* kmalloc() */
 # include <linux/timer.h>	/* time_after() */
  
-#ifdef CONFIG_BALANCED_IRQ_DEBUG
-#  define TDprintk(x...) do { printk("<%ld:%s:%d>: ", jiffies, __FILE__, __LINE__); printk(x); } while (0)
-#  define Dprintk(x...) do { TDprintk(x); } while (0)
-# else
-#  define TDprintk(x...) 
-#  define Dprintk(x...) 
-# endif
-
 #define IRQBALANCE_CHECK_ARCH -999
 #define MAX_BALANCED_IRQ_INTERVAL	(5*HZ)
 #define MIN_BALANCED_IRQ_INTERVAL	(HZ/2)
@@ -443,7 +435,7 @@ static inline void balance_irq(int cpu, 
 static inline void rotate_irqs_among_cpus(unsigned long useful_load_threshold)
 {
 	int i, j;
-	Dprintk("Rotating IRQs among CPUs.\n");
+
 	for_each_online_cpu(i) {
 		for (j = 0; j < NR_IRQS; j++) {
 			if (!irq_desc[j].action)
@@ -560,19 +552,11 @@ tryanothercpu:
 	max_loaded = tmp_loaded;	/* processor */
 	imbalance = (max_cpu_irq - min_cpu_irq) / 2;
 	
-	Dprintk("max_loaded cpu = %d\n", max_loaded);
-	Dprintk("min_loaded cpu = %d\n", min_loaded);
-	Dprintk("max_cpu_irq load = %ld\n", max_cpu_irq);
-	Dprintk("min_cpu_irq load = %ld\n", min_cpu_irq);
-	Dprintk("load imbalance = %lu\n", imbalance);
-
 	/* if imbalance is less than approx 10% of max load, then
 	 * observe diminishing returns action. - quit
 	 */
-	if (imbalance < (max_cpu_irq >> 3)) {
-		Dprintk("Imbalance too trivial\n");
+	if (imbalance < (max_cpu_irq >> 3))
 		goto not_worth_the_effort;
-	}
 
 tryanotherirq:
 	/* if we select an IRQ to move that can't go where we want, then
@@ -629,9 +613,6 @@ tryanotherirq:
 	cpus_and(tmp, target_cpu_mask, allowed_mask);
 
 	if (!cpus_empty(tmp)) {
-
-		Dprintk("irq = %d moved to cpu = %d\n",
-				selected_irq, min_loaded);
 		/* mark for change destination */
 		set_pending_irq(selected_irq, cpumask_of_cpu(min_loaded));
 
@@ -651,7 +632,6 @@ not_worth_the_effort:
 	 */
 	balanced_irq_interval = min((long)MAX_BALANCED_IRQ_INTERVAL,
 		balanced_irq_interval + BALANCED_IRQ_MORE_DELTA);	
-	Dprintk("IRQ worth rotating not found\n");
 	return;
 }
 
