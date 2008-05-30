Return-Path: <linux-kernel-owner+w=401wt.eu-S1760772AbYE3EQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760772AbYE3EQP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbYE3EBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:01:44 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40495 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751558AbYE3EAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:18 -0400
Message-Id: <20080530040013.755304857@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:31 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 11/41] cpu alloc: SRCU cpu alloc conversion
Content-Disposition: inline; filename=cpu_alloc_srcu_conversion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 kernel/rcutorture.c |    4 ++--
 kernel/srcu.c       |   20 ++++++++------------
 2 files changed, 10 insertions(+), 14 deletions(-)

Index: linux-2.6/kernel/rcutorture.c
===================================================================
--- linux-2.6.orig/kernel/rcutorture.c	2008-04-29 14:55:55.000000000 -0700
+++ linux-2.6/kernel/rcutorture.c	2008-05-21 21:46:19.000000000 -0700
@@ -442,8 +442,8 @@
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
--- linux-2.6.orig/kernel/srcu.c	2008-02-16 20:28:44.000000000 -0800
+++ linux-2.6/kernel/srcu.c	2008-05-21 21:46:19.000000000 -0700
@@ -46,7 +46,8 @@
 {
 	sp->completed = 0;
 	mutex_init(&sp->mutex);
-	sp->per_cpu_ref = alloc_percpu(struct srcu_struct_array);
+	sp->per_cpu_ref = CPU_ALLOC(struct srcu_struct_array,
+						GFP_KERNEL|__GFP_ZERO);
 	return (sp->per_cpu_ref ? 0 : -ENOMEM);
 }
 
@@ -62,7 +63,7 @@
 
 	sum = 0;
 	for_each_possible_cpu(cpu)
-		sum += per_cpu_ptr(sp->per_cpu_ref, cpu)->c[idx];
+		sum += CPU_PTR(sp->per_cpu_ref, cpu)->c[idx];
 	return sum;
 }
 
@@ -94,7 +95,7 @@
 	WARN_ON(sum);  /* Leakage unless caller handles error. */
 	if (sum != 0)
 		return;
-	free_percpu(sp->per_cpu_ref);
+	CPU_FREE(sp->per_cpu_ref);
 	sp->per_cpu_ref = NULL;
 }
 
@@ -110,12 +111,9 @@
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
 
@@ -131,10 +129,8 @@
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
