Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbXKTBQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbXKTBQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756385AbXKTBNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:13:44 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49828 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751898AbXKTBNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:34 -0500
Message-Id: <20071120011334.334594749@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:11:43 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 11/45] cpu alloc: percpu_counter conversion
Content-Disposition: inline; filename=0019-cpu-alloc-percpu_counter-conversion.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 lib/percpu_counter.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6/lib/percpu_counter.c
===================================================================
--- linux-2.6.orig/lib/percpu_counter.c	2007-11-15 21:24:46.878154362 -0800
+++ linux-2.6/lib/percpu_counter.c	2007-11-15 21:25:28.963154085 -0800
@@ -20,7 +20,7 @@ void percpu_counter_set(struct percpu_co
 
 	spin_lock(&fbc->lock);
 	for_each_possible_cpu(cpu) {
-		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
+		s32 *pcount = CPU_PTR(fbc->counters, cpu);
 		*pcount = 0;
 	}
 	fbc->count = amount;
@@ -34,7 +34,7 @@ void __percpu_counter_add(struct percpu_
 	s32 *pcount;
 	int cpu = get_cpu();
 
-	pcount = per_cpu_ptr(fbc->counters, cpu);
+	pcount = CPU_PTR(fbc->counters, cpu);
 	count = *pcount + amount;
 	if (count >= batch || count <= -batch) {
 		spin_lock(&fbc->lock);
@@ -60,7 +60,7 @@ s64 __percpu_counter_sum(struct percpu_c
 	spin_lock(&fbc->lock);
 	ret = fbc->count;
 	for_each_online_cpu(cpu) {
-		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
+		s32 *pcount = CPU_PTR(fbc->counters, cpu);
 		ret += *pcount;
 	}
 	spin_unlock(&fbc->lock);
@@ -74,7 +74,7 @@ int percpu_counter_init(struct percpu_co
 {
 	spin_lock_init(&fbc->lock);
 	fbc->count = amount;
-	fbc->counters = alloc_percpu(s32);
+	fbc->counters = CPU_ALLOC(s32, GFP_KERNEL|__GFP_ZERO);
 	if (!fbc->counters)
 		return -ENOMEM;
 #ifdef CONFIG_HOTPLUG_CPU
@@ -101,7 +101,7 @@ void percpu_counter_destroy(struct percp
 	if (!fbc->counters)
 		return;
 
-	free_percpu(fbc->counters);
+	CPU_FREE(fbc->counters);
 #ifdef CONFIG_HOTPLUG_CPU
 	mutex_lock(&percpu_counters_lock);
 	list_del(&fbc->list);
@@ -127,7 +127,7 @@ static int __cpuinit percpu_counter_hotc
 		unsigned long flags;
 
 		spin_lock_irqsave(&fbc->lock, flags);
-		pcount = per_cpu_ptr(fbc->counters, cpu);
+		pcount = CPU_PTR(fbc->counters, cpu);
 		fbc->count += *pcount;
 		*pcount = 0;
 		spin_unlock_irqrestore(&fbc->lock, flags);

-- 
