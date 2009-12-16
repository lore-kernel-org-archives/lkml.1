Return-Path: <linux-kernel-owner+w=401wt.eu-S1762344AbZLPRGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762344AbZLPRGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762374AbZLPRGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:06:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:53828 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762331AbZLPRGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:06:33 -0500
Message-Id: <20091216170517.500272612@chello.nl>
References: <20091216170430.073353839@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 16 Dec 2009 18:04:32 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Xiaotian Feng <dfeng@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 02/12] sched: Fix set_cpu_active() in cpu_down()
Content-Disposition: inline; filename=foo13.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sachin found cpu hotplug test failures on powerpc, which made the
kernel hang on his POWER box. 

The problem is that we fail to re-activate a cpu when a hot-unplug
fails. Fix this by moving the de-activation into _cpu_down after doing
the initial checks.

Remove the synchronize_sched() calls and rely on those implied by
rebuilding the sched domains using the new mask.

Reported-by: Sachin Sant <sachinp@in.ibm.com>
Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Tested-by: Sachin Sant <sachinp@in.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/cpu.c |   24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -209,6 +209,7 @@ static int __ref _cpu_down(unsigned int 
 		return -ENOMEM;
 
 	cpu_hotplug_begin();
+	set_cpu_active(cpu, false);
 	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
 					hcpu, -1, &nr_calls);
 	if (err == NOTIFY_BAD) {
@@ -280,18 +281,6 @@ int __ref cpu_down(unsigned int cpu)
 		goto out;
 	}
 
-	set_cpu_active(cpu, false);
-
-	/*
-	 * Make sure the all cpus did the reschedule and are not
-	 * using stale version of the cpu_active_mask.
-	 * This is not strictly necessary becuase stop_machine()
-	 * that we run down the line already provides the required
-	 * synchronization. But it's really a side effect and we do not
-	 * want to depend on the innards of the stop_machine here.
-	 */
-	synchronize_sched();
-
 	err = _cpu_down(cpu, 0);
 
 out:
@@ -382,19 +371,12 @@ int disable_nonboot_cpus(void)
 		return error;
 	cpu_maps_update_begin();
 	first_cpu = cpumask_first(cpu_online_mask);
-	/* We take down all of the non-boot CPUs in one shot to avoid races
+	/*
+	 * We take down all of the non-boot CPUs in one shot to avoid races
 	 * with the userspace trying to use the CPU hotplug at the same time
 	 */
 	cpumask_clear(frozen_cpus);
 
-	for_each_online_cpu(cpu) {
-		if (cpu == first_cpu)
-			continue;
-		set_cpu_active(cpu, false);
-	}
-
-	synchronize_sched();
-
 	printk("Disabling non-boot CPUs ...\n");
 	for_each_online_cpu(cpu) {
 		if (cpu == first_cpu)

-- 

