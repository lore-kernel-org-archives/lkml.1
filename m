Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471Ab0A0NQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab0A0NQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 08:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154Ab0A0NQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 08:16:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:37707 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754428Ab0A0NQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 08:16:26 -0500
Date: Wed, 27 Jan 2010 13:15:56 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100118044142.GS12666@kryten>
References: <20100118044142.GS12666@kryten>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: cpuacct: Use bigger percpu counter batch values for stats counters
Message-ID: <tip-43f85eab1411905afe5db510fbf9841b516e7e6a@git.kernel.org>
Git-Commit-ID: 43f85eab1411905afe5db510fbf9841b516e7e6a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Jan 2010 13:15:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  43f85eab1411905afe5db510fbf9841b516e7e6a
Gitweb:     http://git.kernel.org/tip/43f85eab1411905afe5db510fbf9841b516e7e6a
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Mon, 18 Jan 2010 15:41:42 +1100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 Jan 2010 08:34:38 +0100

sched: cpuacct: Use bigger percpu counter batch values for stats counters

When CONFIG_VIRT_CPU_ACCOUNTING and CONFIG_CGROUP_CPUACCT are enabled we
can call cpuacct_update_stats with values much larger than
percpu_counter_batch. This means the call to percpu_counter_add will
always add to the global count which is protected by a spinlock and we
end up with a global spinlock in the scheduler.

Based on an idea by KOSAKI Motohiro, this patch scales the batch value by
cputime_one_jiffy such that we have the same batch limit as we would if
CONFIG_VIRT_CPU_ACCOUNTING was disabled. His patch did this once at boot
but that initialisation happened too early on PowerPC (before time_init)
and it was never updated at runtime as a result of a hotplug cpu
add/remove.

This patch instead scales percpu_counter_batch by cputime_one_jiffy at
runtime, which keeps the batch correct even after cpu hotplug operations.
We cap it at INT_MAX in case of overflow.

For architectures that do not support CONFIG_VIRT_CPU_ACCOUNTING,
cputime_one_jiffy is the constant 1 and gcc is smart enough to optimise
min(s32 percpu_counter_batch, INT_MAX) to just percpu_counter_batch at
least on x86 and PowerPC. So there is no need to add an #ifdef.

On a 64 thread PowerPC box with CONFIG_VIRT_CPU_ACCOUNTING and
CONFIG_CGROUP_CPUACCT enabled, a context switch microbenchmark is 234x
faster and almost matches a CONFIG_CGROUP_CPUACCT disabled kernel:

CONFIG_CGROUP_CPUACCT disabled:		16906698 ctx switches/sec
CONFIG_CGROUP_CPUACCT enabled:		   61720 ctx switches/sec
CONFIG_CGROUP_CPUACCT + patch:		16663217 ctx switches/sec

Tested with:

 wget http://ozlabs.org/~anton/junkcode/context_switch.c
 make context_switch
 for i in `seq 0 63`; do taskset -c $i ./context_switch & done
 vmstat 1

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100118044142.GS12666@kryten>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3a8fb30..8f94138 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -10906,6 +10906,7 @@ static void cpuacct_update_stats(struct task_struct *tsk,
 		enum cpuacct_stat_index idx, cputime_t val)
 {
 	struct cpuacct *ca;
+	int batch;
 
 	if (unlikely(!cpuacct_subsys.active))
 		return;
@@ -10913,8 +10914,9 @@ static void cpuacct_update_stats(struct task_struct *tsk,
 	rcu_read_lock();
 	ca = task_ca(tsk);
 
+	batch = min_t(long, percpu_counter_batch * cputime_one_jiffy, INT_MAX);
 	do {
-		percpu_counter_add(&ca->cpustat[idx], val);
+		__percpu_counter_add(&ca->cpustat[idx], val, batch);
 		ca = ca->parent;
 	} while (ca);
 	rcu_read_unlock();
