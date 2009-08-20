Return-Path: <linux-kernel-owner+w=401wt.eu-S1752599AbZHTBLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbZHTBLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 21:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbZHTBLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 21:11:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:3697 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbZHTBLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 21:11:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,411,1246863600"; 
   d="scan'208";a="485456286"
Message-Id: <20090820010813.078511000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 19 Aug 2009 18:05:35 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: npiggin@suse.de, shaohua.li@intel.com, akpm@linux-foundation.org,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 1/2] generic-ipi: Allow cpus not yet online to call smp_call_function with irqs disabled
Content-Disposition: inline; filename=smp_call_function_checks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of deadlock possiblities smp_call_function() is not allowed to
be called with interrupts disabled. Add an exception for the cpu not
yet online, as no one else can send smp call function interrupt to this
cpu that is not yet online and as such deadlock condition is not possible.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Nick Piggin <npiggin@suse.de>
---
 kernel/smp.c |   40 ++++++++++++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 6 deletions(-)

Index: tip/kernel/smp.c
===================================================================
--- tip.orig/kernel/smp.c
+++ tip/kernel/smp.c
@@ -177,6 +177,11 @@ void generic_smp_call_function_interrupt
 	int cpu = get_cpu();
 
 	/*
+	 * Shouldn't receive this interrupt on a cpu that is not yet online.
+	 */
+	WARN_ON_ONCE(!cpu_online(cpu));
+
+	/*
 	 * Ensure entry is visible on call_function_queue after we have
 	 * entered the IPI. See comment in smp_call_function_many.
 	 * If we don't have this, then we may miss an entry on the list
@@ -230,6 +235,11 @@ void generic_smp_call_function_single_in
 	unsigned int data_flags;
 	LIST_HEAD(list);
 
+	/*
+	 * Shouldn't receive this interrupt on a cpu that is not yet online.
+	 */
+	WARN_ON_ONCE(!cpu_online(smp_processor_id()));
+
 	spin_lock(&q->lock);
 	list_replace_init(&q->list, &list);
 	spin_unlock(&q->lock);
@@ -285,8 +295,14 @@ int smp_call_function_single(int cpu, vo
 	 */
 	this_cpu = get_cpu();
 
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON_ONCE(irqs_disabled() && !oops_in_progress);
+	/*
+	 * Can deadlock when called with interrupts disabled.
+	 * We allow cpu's that are not yet online though, as no one else can
+	 * send smp call function interrupt to this cpu and as such deadlocks
+	 * can't happen.
+	 */
+	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
+		     && !oops_in_progress);
 
 	if (cpu == this_cpu) {
 		local_irq_save(flags);
@@ -329,8 +345,14 @@ void __smp_call_function_single(int cpu,
 {
 	csd_lock(data);
 
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON_ONCE(wait && irqs_disabled() && !oops_in_progress);
+	/*
+	 * Can deadlock when called with interrupts disabled.
+	 * We allow cpu's that are not yet online though, as no one else can
+	 * send smp call function interrupt to this cpu and as such deadlocks
+	 * can't happen.
+	 */
+	WARN_ON_ONCE(cpu_online(smp_processor_id()) && wait && irqs_disabled()
+		     && !oops_in_progress);
 
 	generic_exec_single(cpu, data, wait);
 }
@@ -365,8 +387,14 @@ void smp_call_function_many(const struct
 	unsigned long flags;
 	int cpu, next_cpu, this_cpu = smp_processor_id();
 
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON_ONCE(irqs_disabled() && !oops_in_progress);
+	/*
+	 * Can deadlock when called with interrupts disabled.
+	 * We allow cpu's that are not yet online though, as no one else can
+	 * send smp call function interrupt to this cpu and as such deadlocks
+	 * can't happen.
+	 */
+	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
+		     && !oops_in_progress);
 
 	/* So, what's a CPU they want? Ignoring this one. */
 	cpu = cpumask_first_and(mask, cpu_online_mask);

-- 

