Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbZDNUpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbZDNUpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 16:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZDNUpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 16:45:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:33023 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123AbZDNUpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 16:45:12 -0400
Message-ID: <49E4F575.7060201@kernel.org>
Date: Tue, 14 Apr 2009 13:43:33 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Gary Hade <garyhade@us.ibm.com>, lcm@us.ibm.com,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] irq: only update affinity in chip set_affinity() -v3
References: <200903231757.53709.rusty@rustcorp.com.au> <20090323165921.GA7559@us.ibm.com> <200903241553.58209.rusty@rustcorp.com.au> <20090402013108.GB7103@us.ibm.com> <20090404003520.GA8847@us.ibm.com> <20090410215515.GC7242@us.ibm.com> <20090411065510.GA11799@elte.hu> <20090413220321.GA11098@us.ibm.com> <49E4146C.7060507@kernel.org> <49E4162A.3060701@kernel.org> <20090414131711.GA4403@elte.hu> <49E4F513.1060709@kernel.org>
In-Reply-To: <49E4F513.1060709@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: keep affinity consistent

irq_set_affinity() and move_masked_irq() try to assign affinity
before calling chip set_affinity(). some archs are assigning again in set_affinity
again.

something like:
cpumask_cpy(desc->affinity, mask);
desc->chip->set_affinity(mask);

in the failing path, affinity should not be touched.

also set_extra_move_desc() ( called by set_affinity)  will rely on the old
affinity to decide if need to move irq_desc to different node when logical
flat apic mode is used.

So try remove those assignment, and make some missed arch to assign affinity
in their set_affinity.

v2: update after "irq, x86: Remove IRQ_DISABLED check in process context IRQ move"
v3: according to Ingo, change set_affinity() in irq_chip to return int.

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
 
