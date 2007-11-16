Return-Path: <linux-kernel-owner+w=401wt.eu-S935530AbXKPXSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935530AbXKPXSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 18:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934872AbXKPXLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 18:11:36 -0500
Received: from relay1.sgi.com ([192.48.171.29]:39567 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761611AbXKPXLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 18:11:06 -0500
Message-Id: <20071116231105.700581864@sgi.com>
References: <20071116230920.278761667@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 16 Nov 2007 15:09:35 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [patch 15/30] cpu alloc: SRCU
Content-Disposition: inline; filename=0025-cpu-alloc-SRCU.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 kernel/rcutorture.c |    4 ++--
 kernel/srcu.c       |   11 ++++++-----
 2 files changed, 8 insertions(+), 7 deletions(-)

Index: linux-2.6/kernel/rcutorture.c
===================================================================
--- linux-2.6.orig/kernel/rcutorture.c	2007-11-15 21:17:24.515654132 -0800
+++ linux-2.6/kernel/rcutorture.c	2007-11-15 21:25:32.102406141 -0800
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
Index: linux-2.6/kernel/srcu.c
===================================================================
--- linux-2.6.orig/kernel/srcu.c	2007-11-15 21:17:24.523654368 -0800
+++ linux-2.6/kernel/srcu.c	2007-11-15 21:25:32.102406141 -0800
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
 

-- 
