Return-Path: <linux-kernel-owner+w=401wt.eu-S1759089AbXKFUBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089AbXKFUBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 15:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757533AbXKFTwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:52:37 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45388 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755827AbXKFTwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:52:01 -0500
Message-Id: <20071106195200.858225561@sgi.com>
References: <20071106195144.983665861@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 11:51:58 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 14/28] cpu alloc: SRCU
Content-Disposition: inline; filename=cpu_alloc_rcu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 kernel/rcutorture.c |    4 ++--
 kernel/srcu.c       |   13 +++++++------
 2 files changed, 9 insertions(+), 8 deletions(-)

Index: linux-2.6/kernel/srcu.c
===================================================================
--- linux-2.6.orig/kernel/srcu.c	2007-11-04 19:32:38.000000000 -0800
+++ linux-2.6/kernel/srcu.c	2007-11-04 19:38:09.000000000 -0800
@@ -26,7 +26,7 @@
 
 #include <linux/module.h>
 #include <linux/mutex.h>
-#include <linux/percpu.h>
+#include <linux/cpu_alloc.h>
 #include <linux/preempt.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
@@ -46,7 +46,8 @@ int init_srcu_struct(struct srcu_struct 
 {
 	sp->completed = 0;
 	mutex_init(&sp->mutex);
-	sp->per_cpu_ref = alloc_percpu(struct srcu_struct_array);
+	sp->per_cpu_ref = CPU_ALLOC(struct srcu_struct_array,
+						GFP_KERNEL|__GFP_ZERO);
 	return (sp->per_cpu_ref ? 0 : -ENOMEM);
 }
 
@@ -62,7 +63,7 @@ static int srcu_readers_active_idx(struc
 
 	sum = 0;
 	for_each_possible_cpu(cpu)
-		sum += per_cpu_ptr(sp->per_cpu_ref, cpu)->c[idx];
+		sum += CPU_PTR(sp->per_cpu_ref, cpu)->c[idx];
 	return sum;
 }
 
@@ -94,7 +95,7 @@ void cleanup_srcu_struct(struct srcu_str
 	WARN_ON(sum);  /* Leakage unless caller handles error. */
 	if (sum != 0)
 		return;
-	free_percpu(sp->per_cpu_ref);
+	CPU_FREE(sp->per_cpu_ref);
 	sp->per_cpu_ref = NULL;
 }
 
@@ -113,7 +114,7 @@ int srcu_read_lock(struct srcu_struct *s
 	preempt_disable();
 	idx = sp->completed & 0x1;
 	barrier();  /* ensure compiler looks -once- at sp->completed. */
-	per_cpu_ptr(sp->per_cpu_ref, smp_processor_id())->c[idx]++;
+	THIS_CPU(sp->per_cpu_ref)->c[idx]++;
 	srcu_barrier();  /* ensure compiler won't misorder critical section. */
 	preempt_enable();
 	return idx;
@@ -133,7 +134,7 @@ void srcu_read_unlock(struct srcu_struct
 {
 	preempt_disable();
 	srcu_barrier();  /* ensure compiler won't misorder critical section. */
-	per_cpu_ptr(sp->per_cpu_ref, smp_processor_id())->c[idx]--;
+	THIS_CPU(sp->per_cpu_ref)->c[idx]--;
 	preempt_enable();
 }
 
Index: linux-2.6/kernel/rcutorture.c
===================================================================
--- linux-2.6.orig/kernel/rcutorture.c	2007-11-04 19:32:38.000000000 -0800
+++ linux-2.6/kernel/rcutorture.c	2007-11-04 19:33:51.000000000 -0800
@@ -441,8 +441,8 @@ static int srcu_torture_stats(char *page
 		       torture_type, TORTURE_FLAG, idx);
 	for_each_possible_cpu(cpu) {
 		cnt += sprintf(&page[cnt], " %d(%d,%d)", cpu,
-			       per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[!idx],
-			       per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[idx]);
+			       CPU_PTR(srcu_ctl.per_cpu_ref, cpu)->c[!idx],
+			       CPU_PTR(srcu_ctl.per_cpu_ref, cpu)->c[idx]);
 	}
 	cnt += sprintf(&page[cnt], "\n");
 	return cnt;

-- 
