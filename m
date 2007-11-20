Return-Path: <linux-kernel-owner+w=401wt.eu-S1757798AbXKTBSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798AbXKTBSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:18:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbXKTBNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:13:51 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36868 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754173AbXKTBNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:36 -0500
Message-Id: <20071120011335.737281508@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:11:49 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 17/45] cpu alloc: SRCU
Content-Disposition: inline; filename=0025-cpu-alloc-SRCU.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 kernel/rcutorture.c |    4 ++--
 kernel/srcu.c       |   20 ++++++++------------
 2 files changed, 10 insertions(+), 14 deletions(-)

Index: linux-2.6/kernel/rcutorture.c
===================================================================
--- linux-2.6.orig/kernel/rcutorture.c	2007-11-18 14:38:24.149783392 -0800
+++ linux-2.6/kernel/rcutorture.c	2007-11-18 21:55:20.028547162 -0800
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
--- linux-2.6.orig/kernel/srcu.c	2007-11-18 14:38:24.157783685 -0800
+++ linux-2.6/kernel/srcu.c	2007-11-18 22:04:47.332273074 -0800
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
 
@@ -110,12 +111,9 @@ int srcu_read_lock(struct srcu_struct *s
 {
 	int idx;
 
-	preempt_disable();
 	idx = sp->completed & 0x1;
-	barrier();  /* ensure compiler looks -once- at sp->completed. */
-	per_cpu_ptr(sp->per_cpu_ref, smp_processor_id())->c[idx]++;
-	srcu_barrier();  /* ensure compiler won't misorder critical section. */
-	preempt_enable();
+	srcu_barrier();
+	_CPU_INC(sp->per_cpu_ref->c[idx]);
 	return idx;
 }
 
@@ -131,10 +129,8 @@ int srcu_read_lock(struct srcu_struct *s
  */
 void srcu_read_unlock(struct srcu_struct *sp, int idx)
 {
-	preempt_disable();
-	srcu_barrier();  /* ensure compiler won't misorder critical section. */
-	per_cpu_ptr(sp->per_cpu_ref, smp_processor_id())->c[idx]--;
-	preempt_enable();
+	srcu_barrier();
+	_CPU_DEC(sp->per_cpu_ref->c[idx]);
 }
 
 /**

-- 
