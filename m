Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbXKFTzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbXKFTzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 14:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757400AbXKFTwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:52:18 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52132 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755626AbXKFTwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:52:01 -0500
Message-Id: <20071106195159.479111097@sgi.com>
References: <20071106195144.983665861@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 11:51:52 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 08/28] cpu alloc: percpu_counter conversion
Content-Disposition: inline; filename=cpu_alloc_percpu_counters
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/percpu_counter.h |    1 -
 lib/percpu_counter.c           |   13 +++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6/include/linux/percpu_counter.h
===================================================================
--- linux-2.6.orig/include/linux/percpu_counter.h	2007-11-04 13:18:33.000000000 -0800
+++ linux-2.6/include/linux/percpu_counter.h	2007-11-04 13:18:47.000000000 -0800
@@ -10,7 +10,6 @@
 #include <linux/smp.h>
 #include <linux/list.h>
 #include <linux/threads.h>
-#include <linux/percpu.h>
 #include <linux/types.h>
 
 #ifdef CONFIG_SMP
Index: linux-2.6/lib/percpu_counter.c
===================================================================
--- linux-2.6.orig/lib/percpu_counter.c	2007-11-04 13:18:33.000000000 -0800
+++ linux-2.6/lib/percpu_counter.c	2007-11-04 16:43:52.000000000 -0800
@@ -8,6 +8,7 @@
 #include <linux/init.h>
 #include <linux/cpu.h>
 #include <linux/module.h>
+#include <linux/cpu_alloc.h>
 
 #ifdef CONFIG_HOTPLUG_CPU
 static LIST_HEAD(percpu_counters);
@@ -20,7 +21,7 @@ void percpu_counter_set(struct percpu_co
 
 	spin_lock(&fbc->lock);
 	for_each_possible_cpu(cpu) {
-		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
+		s32 *pcount = CPU_PTR(fbc->counters, cpu);
 		*pcount = 0;
 	}
 	fbc->count = amount;
@@ -34,7 +35,7 @@ void __percpu_counter_add(struct percpu_
 	s32 *pcount;
 	int cpu = get_cpu();
 
-	pcount = per_cpu_ptr(fbc->counters, cpu);
+	pcount = CPU_PTR(fbc->counters, cpu);
 	count = *pcount + amount;
 	if (count >= batch || count <= -batch) {
 		spin_lock(&fbc->lock);
@@ -60,7 +61,7 @@ s64 __percpu_counter_sum(struct percpu_c
 	spin_lock(&fbc->lock);
 	ret = fbc->count;
 	for_each_online_cpu(cpu) {
-		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
+		s32 *pcount = CPU_PTR(fbc->counters, cpu);
 		ret += *pcount;
 	}
 	spin_unlock(&fbc->lock);
@@ -74,7 +75,7 @@ int percpu_counter_init(struct percpu_co
 {
 	spin_lock_init(&fbc->lock);
 	fbc->count = amount;
-	fbc->counters = alloc_percpu(s32);
+	fbc->counters = CPU_ALLOC(s32, GFP_KERNEL|__GFP_ZERO);
 	if (!fbc->counters)
 		return -ENOMEM;
 #ifdef CONFIG_HOTPLUG_CPU
@@ -101,7 +102,7 @@ void percpu_counter_destroy(struct percp
 	if (!fbc->counters)
 		return;
 
-	free_percpu(fbc->counters);
+	CPU_FREE(fbc->counters);
 #ifdef CONFIG_HOTPLUG_CPU
 	mutex_lock(&percpu_counters_lock);
 	list_del(&fbc->list);
@@ -127,7 +128,7 @@ static int __cpuinit percpu_counter_hotc
 		unsigned long flags;
 
 		spin_lock_irqsave(&fbc->lock, flags);
-		pcount = per_cpu_ptr(fbc->counters, cpu);
+		pcount = CPU_PTR(fbc->counters, cpu);
 		fbc->count += *pcount;
 		*pcount = 0;
 		spin_unlock_irqrestore(&fbc->lock, flags);

-- 
