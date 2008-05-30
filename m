Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbYE3EC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbYE3EC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbYE3EAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:00:23 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40485 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750897AbYE3EAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:14 -0400
Message-Id: <20080530040012.011711936@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:25 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 05/41] cpu alloc: Percpu_counter conversion
Content-Disposition: inline; filename=cpu_alloc_percpu_counter_conversion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use cpu_alloc instead of allocpercpu.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 lib/percpu_counter.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6/lib/percpu_counter.c
===================================================================
--- linux-2.6.orig/lib/percpu_counter.c	2008-05-28 17:56:17.000000000 -0700
+++ linux-2.6/lib/percpu_counter.c	2008-05-28 18:30:25.000000000 -0700
@@ -20,7 +20,7 @@
 
 	spin_lock(&fbc->lock);
 	for_each_possible_cpu(cpu) {
-		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
+		s32 *pcount = CPU_PTR(fbc->counters, cpu);
 		*pcount = 0;
 	}
 	fbc->count = amount;
@@ -31,20 +31,18 @@
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
 {
 	s64 count;
-	s32 *pcount;
-	int cpu = get_cpu();
 
-	pcount = per_cpu_ptr(fbc->counters, cpu);
-	count = *pcount + amount;
+	preempt_disable();
+	count = __CPU_READ(*fbc->counters) + amount;
 	if (count >= batch || count <= -batch) {
 		spin_lock(&fbc->lock);
 		fbc->count += count;
-		*pcount = 0;
+		__CPU_WRITE(*fbc->counters, 0);
 		spin_unlock(&fbc->lock);
 	} else {
-		*pcount = count;
+		__CPU_WRITE(*fbc->counters, count);
 	}
-	put_cpu();
+	preempt_enable();
 }
 EXPORT_SYMBOL(__percpu_counter_add);
 
@@ -60,7 +58,7 @@
 	spin_lock(&fbc->lock);
 	ret = fbc->count;
 	for_each_online_cpu(cpu) {
-		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
+		s32 *pcount = CPU_PTR(fbc->counters, cpu);
 		ret += *pcount;
 	}
 	spin_unlock(&fbc->lock);
@@ -74,7 +72,7 @@
 {
 	spin_lock_init(&fbc->lock);
 	fbc->count = amount;
-	fbc->counters = alloc_percpu(s32);
+	fbc->counters = CPU_ALLOC(s32, GFP_KERNEL|__GFP_ZERO);
 	if (!fbc->counters)
 		return -ENOMEM;
 #ifdef CONFIG_HOTPLUG_CPU
@@ -101,7 +99,7 @@
 	if (!fbc->counters)
 		return;
 
-	free_percpu(fbc->counters);
+	CPU_FREE(fbc->counters);
 	fbc->counters = NULL;
 #ifdef CONFIG_HOTPLUG_CPU
 	mutex_lock(&percpu_counters_lock);
@@ -128,7 +126,7 @@
 		unsigned long flags;
 
 		spin_lock_irqsave(&fbc->lock, flags);
-		pcount = per_cpu_ptr(fbc->counters, cpu);
+		pcount = CPU_PTR(fbc->counters, cpu);
 		fbc->count += *pcount;
 		*pcount = 0;
 		spin_unlock_irqrestore(&fbc->lock, flags);

-- 
