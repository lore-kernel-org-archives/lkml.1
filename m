Return-Path: <linux-kernel-owner+w=401wt.eu-S1763353AbZEARJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763353AbZEARJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 13:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755874AbZEARIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 13:08:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:42804 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762053AbZEARIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 13:08:46 -0400
Date: Fri, 1 May 2009 17:07:03 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, rusty@rustcorp.com.au, ebiederm@xmission.com,
       akpm@linux-foundation.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, rusty@rustcorp.com.au, ebiederm@xmission.com,
       akpm@linux-foundation.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49F65509.60307@kernel.org>
References: <49F65509.60307@kernel.org>
Subject: [tip:irq/numa] irq: only update affinity if ->set_affinity() is sucessfull
Message-ID: <tip-57b150cce8e004ddd36330490a68bfb59b7271e9@git.kernel.org>
Git-Commit-ID: 57b150cce8e004ddd36330490a68bfb59b7271e9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 01 May 2009 17:07:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  57b150cce8e004ddd36330490a68bfb59b7271e9
Gitweb:     http://git.kernel.org/tip/57b150cce8e004ddd36330490a68bfb59b7271e9
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 27 Apr 2009 17:59:53 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 28 Apr 2009 12:21:16 +0200

irq: only update affinity if ->set_affinity() is sucessfull

irq_set_affinity() and move_masked_irq() try to assign affinity
before calling chip set_affinity(). Some archs are assigning it
in ->set_affinity() again.

We do something like:

 cpumask_cpy(desc->affinity, mask);
 desc->chip->set_affinity(mask);

But in the failure path, affinity should not be touched - otherwise
we'll end up with a different affinity mask despite the failure to
migrate the IRQ.

So try to update the afffinity only if set_affinity returns with 0.
Also call irq_set_thread_affinity accordingly.

v2: update after "irq, x86: Remove IRQ_DISABLED check in process context IRQ move"
v3: according to Ingo, change set_affinity() in irq_chip should return int.
v4: update comments by removing moving irq_desc code.

[ Impact: fix /proc/irq/*/smp_affinity setting corner case bug ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
LKML-Reference: <49F65509.60307@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/irq/internals.h |    3 +++
 kernel/irq/manage.c    |   17 +++++++++++------
 kernel/irq/migration.c |   14 +++++++++-----
 3 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 01ce20e..de5f412 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -42,6 +42,9 @@ static inline void unregister_handler_proc(unsigned int irq,
 
 extern int irq_select_affinity_usr(unsigned int irq);
 
+extern void
+irq_set_thread_affinity(struct irq_desc *desc, const struct cpumask *cpumask);
+
 /*
  * Debugging printout:
  */
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 2734eca..aaf5c9d 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -80,7 +80,7 @@ int irq_can_set_affinity(unsigned int irq)
 	return 1;
 }
 
-static void
+void
 irq_set_thread_affinity(struct irq_desc *desc, const struct cpumask *cpumask)
 {
 	struct irqaction *action = desc->action;
@@ -109,17 +109,22 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
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
diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index e05ad9b..cfe767c 100644
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
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
 
