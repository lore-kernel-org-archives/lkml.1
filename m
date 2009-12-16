Return-Path: <linux-kernel-owner+w=401wt.eu-S1762831AbZLPShd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762831AbZLPShd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759023AbZLPSh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:37:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:53403 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935132AbZLPShY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:37:24 -0500
Date: Wed, 16 Dec 2009 18:36:50 GMT
From: tip-bot for Xiaotian Feng <dfeng@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, sachinp@in.ibm.com,
       tglx@linutronix.de, dfeng@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, sachinp@in.ibm.com,
       tglx@linutronix.de, dfeng@redhat.com, mingo@elte.hu
In-Reply-To: <20091216170517.500272612@chello.nl>
References: <20091216170517.500272612@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix set_cpu_active() in cpu_down()
Message-ID: <tip-9ee349ad6d326df3633d43f54202427295999c47@git.kernel.org>
Git-Commit-ID: 9ee349ad6d326df3633d43f54202427295999c47
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ee349ad6d326df3633d43f54202427295999c47
Gitweb:     http://git.kernel.org/tip/9ee349ad6d326df3633d43f54202427295999c47
Author:     Xiaotian Feng <dfeng@redhat.com>
AuthorDate: Wed, 16 Dec 2009 18:04:32 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Dec 2009 19:01:53 +0100

sched: Fix set_cpu_active() in cpu_down()

Sachin found cpu hotplug test failures on powerpc, which made
the kernel hang on his POWER box.

The problem is that we fail to re-activate a cpu when a
hot-unplug fails. Fix this by moving the de-activation into
_cpu_down after doing the initial checks.

Remove the synchronize_sched() calls and rely on those implied
by rebuilding the sched domains using the new mask.

Reported-by: Sachin Sant <sachinp@in.ibm.com>
Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Tested-by: Sachin Sant <sachinp@in.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20091216170517.500272612@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/cpu.c |   24 +++---------------------
 1 files changed, 3 insertions(+), 21 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 291ac58..1c8ddd6 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -209,6 +209,7 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
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
