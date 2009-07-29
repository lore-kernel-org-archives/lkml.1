Return-Path: <linux-kernel-owner+w=401wt.eu-S1751355AbZG2EZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355AbZG2EZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 00:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbZG2EZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 00:25:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53912 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbZG2EZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 00:25:28 -0400
Message-Id: <20090729042526.438281019@goodmis.org>
References: <20090729042121.727652581@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 29 Jul 2009 00:21:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/2] sched: add new prio to cpupri before removing old prio
Content-Disposition: inline; filename=0002-sched-add-new-prio-to-cpupri-before-removing-old-pri.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

We need to add the new prio to the cpupri accounting before removing the
old prio. This is because removing the old prio first will open a
race window where the cpu will be removed from pri_active. In this
case the cpu will not be visible for RT push and pulls. This could cause
a RT task to not migrate appropriately, and create a very large latency.

This bug was found with the use of ftrace sched events and trace_printk.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/sched_cpupri.c |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index e6c2517..aef68b6 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -114,21 +114,11 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
 
 	/*
 	 * If the cpu was currently mapped to a different value, we
-	 * first need to unmap the old value
+	 * need to map it to the new value then remove the old value.
+	 * Note, we must add the new value first, otherwise we risk the
+	 * cpu being cleared from pri_active, and this cpu could be
+	 * missed for a push or pull.
 	 */
-	if (likely(oldpri != CPUPRI_INVALID)) {
-		struct cpupri_vec *vec  = &cp->pri_to_cpu[oldpri];
-
-		spin_lock_irqsave(&vec->lock, flags);
-
-		vec->count--;
-		if (!vec->count)
-			clear_bit(oldpri, cp->pri_active);
-		cpumask_clear_cpu(cpu, vec->mask);
-
-		spin_unlock_irqrestore(&vec->lock, flags);
-	}
-
 	if (likely(newpri != CPUPRI_INVALID)) {
 		struct cpupri_vec *vec = &cp->pri_to_cpu[newpri];
 
@@ -141,6 +131,18 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
 
 		spin_unlock_irqrestore(&vec->lock, flags);
 	}
+	if (likely(oldpri != CPUPRI_INVALID)) {
+		struct cpupri_vec *vec  = &cp->pri_to_cpu[oldpri];
+
+		spin_lock_irqsave(&vec->lock, flags);
+
+		vec->count--;
+		if (!vec->count)
+			clear_bit(oldpri, cp->pri_active);
+		cpumask_clear_cpu(cpu, vec->mask);
+
+		spin_unlock_irqrestore(&vec->lock, flags);
+	}
 
 	*currpri = newpri;
 }
-- 
1.6.3.3

-- 
