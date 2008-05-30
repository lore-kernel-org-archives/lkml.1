Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbYE3EKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbYE3EKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbYE3EBC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:01:02 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40495 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750856AbYE3EAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:22 -0400
Message-Id: <20080530040019.473812921@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:45 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 25/41] cpu alloc: scheduler: Convert cpuusage to cpu_alloc.
Content-Disposition: inline; filename=cpu_alloc_scheduler_usage_conversion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert scheduler handling of cpuusage to cpu alloc.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/x86/kernel/setup.c |    2 +-
 kernel/sched.c          |   10 +++++-----
 mm/cpu_alloc.c          |   25 +++++++++++++++++++------
 3 files changed, 25 insertions(+), 12 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c	2008-05-26 20:38:49.000000000 -0700
+++ linux-2.6/kernel/sched.c	2008-05-26 20:38:53.000000000 -0700
@@ -9090,7 +9090,7 @@
 	if (!ca)
 		return ERR_PTR(-ENOMEM);
 
-	ca->cpuusage = alloc_percpu(u64);
+	ca->cpuusage = CPU_ALLOC(u64, GFP_KERNEL|__GFP_ZERO);
 	if (!ca->cpuusage) {
 		kfree(ca);
 		return ERR_PTR(-ENOMEM);
@@ -9105,7 +9105,7 @@
 {
 	struct cpuacct *ca = cgroup_ca(cgrp);
 
-	free_percpu(ca->cpuusage);
+	CPU_FREE(ca->cpuusage);
 	kfree(ca);
 }
 
@@ -9117,7 +9117,7 @@
 	int i;
 
 	for_each_possible_cpu(i) {
-		u64 *cpuusage = percpu_ptr(ca->cpuusage, i);
+		u64 *cpuusage = CPU_PTR(cpuusage, i);
 
 		/*
 		 * Take rq->lock to make 64-bit addition safe on 32-bit
@@ -9144,7 +9144,7 @@
 	}
 
 	for_each_possible_cpu(i) {
-		u64 *cpuusage = percpu_ptr(ca->cpuusage, i);
+		u64 *cpuusage = CPU_PTR(ca->cpuusage, i);
 
 		spin_lock_irq(&cpu_rq(i)->lock);
 		*cpuusage = 0;
@@ -9181,7 +9181,7 @@
 
 	ca = task_ca(tsk);
 	if (ca) {
-		u64 *cpuusage = percpu_ptr(ca->cpuusage, task_cpu(tsk));
+		u64 *cpuusage = CPU_PTR(ca->cpuusage, task_cpu(tsk));
 
 		*cpuusage += cputime;
 	}

-- 
