Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723AbZDQEWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbZDQEWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 00:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbZDQEVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 00:21:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:41306 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbZDQEVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 00:21:51 -0400
Message-ID: <49E8038C.3010405@kernel.org>
Date: Thu, 16 Apr 2009 21:20:28 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/9] irq: only update affinity if set_affinity() sucessfully
 -v4
References: <49E68C41.4020801@kernel.org> <20090416090315.GF9813@elte.hu> <49E802CE.5030406@kernel.org>
In-Reply-To: <49E802CE.5030406@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: don't change smp_affinity if set_affinity fail

irq_set_affinity() and move_masked_irq() try to assign affinity
before calling chip set_affinity(). some archs are assigning again in set_affinity
again.

something like:
cpumask_cpy(desc->affinity, mask);
desc->chip->set_affinity(mask);

in the failing path, affinity should not be touched.

So try update the afffinity only if set_affinity return wth 0
also call irq_set_thread_affinity accordingly

v2: update after "irq, x86: Remove IRQ_DISABLED check in process context IRQ move"
v3: according to Ingo, change set_affinity() in irq_chip to return int.
v4: update comments by removing moving irq_desc code.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 kernel/irq/internals.h |    3 +++
 kernel/irq/manage.c    |   17 +++++++++++------
 kernel/irq/migration.c |   14 +++++++++-----
 3 files changed, 23 insertions(+), 11 deletions(-)

Index: linux-2.6/kernel/irq/internals.h
===================================================================
--- linux-2.6.orig/kernel/irq/internals.h
+++ linux-2.6/kernel/irq/internals.h
@@ -42,6 +42,9 @@ static inline void unregister_handler_pr
 
 extern int irq_select_affinity_usr(unsigned int irq);
 
+extern void
+irq_set_thread_affinity(struct irq_desc *desc, const struct cpumask *cpumask);
+
 /*
  * Debugging printout:
  */
Index: linux-2.6/kernel/irq/manage.c
===================================================================
--- linux-2.6.orig/kernel/irq/manage.c
+++ linux-2.6/kernel/irq/manage.c
@@ -80,7 +80,7 @@ int irq_can_set_affinity(unsigned int ir
 	return 1;
 }
 
-static void
+void
 irq_set_thread_affinity(struct irq_desc *desc, const struct cpumask *cpumask)
 {
 	struct irqaction *action = desc->action;
@@ -109,17 +109,22 @@ int irq_set_affinity(unsigned int irq, c
 	spin_lock_irqsave(&desc->lock, flags);
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
-	if (desc->status & IRQ_MOVE_PCNTXT)
-		desc->chip->set_affinity(irq, cpumask);
+	if (desc->status & IRQ_MOVE_PCNTXT) {
+		if (!desc->chip->set_affinity(irq, cpumask)) {
+			cpumask_copy(desc->affinity, cpumask);
+			irq_set_thread_affinity(desc, cpumask);
+		}
+	}
 	else {
 		desc->status |= IRQ_MOVE_PENDING;
 		cpumask_copy(desc->pending_mask, cpumask);
 	}
 #else
-	cpumask_copy(desc->affinity, cpumask);
-	desc->chip->set_affinity(irq, cpumask);
+	if (!desc->chip->set_affinity(irq, cpumask)) {
+		cpumask_copy(desc->affinity, cpumask);
+		irq_set_thread_affinity(desc, cpumask);
+	}
 #endif
-	irq_set_thread_affinity(desc, cpumask);
 	desc->status |= IRQ_AFFINITY_SET;
 	spin_unlock_irqrestore(&desc->lock, flags);
 	return 0;
Index: linux-2.6/kernel/irq/migration.c
===================================================================
--- linux-2.6.orig/kernel/irq/migration.c
+++ linux-2.6/kernel/irq/migration.c
@@ -1,5 +1,8 @@
 
 #include <linux/irq.h>
+#include <linux/interrupt.h>
+
+#include "internals.h"
 
 void move_masked_irq(int irq)
 {
@@ -39,11 +42,12 @@ void move_masked_irq(int irq)
 	 * masking the irqs.
 	 */
 	if (likely(cpumask_any_and(desc->pending_mask, cpu_online_mask)
-		   < nr_cpu_ids)) {
-		cpumask_and(desc->affinity,
-			    desc->pending_mask, cpu_online_mask);
-		desc->chip->set_affinity(irq, desc->affinity);
-	}
+		   < nr_cpu_ids))
+		if (!desc->chip->set_affinity(irq, desc->pending_mask)) {
+			cpumask_copy(desc->affinity, desc->pending_mask);
+			irq_set_thread_affinity(desc, desc->pending_mask);
+		}
+
 	cpumask_clear(desc->pending_mask);
 }
 
