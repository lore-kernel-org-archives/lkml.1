Return-Path: <linux-kernel-owner+w=401wt.eu-S1753410AbZEKMho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbZEKMho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbZEKMhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:37:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:52744 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbZEKMhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:37:33 -0400
Date: Mon, 11 May 2009 12:36:29 GMT
From: tip-bot for KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, schwidefsky@de.ibm.com,
       dhaval@linux.vnet.ibm.com, balajirrao@gmail.com,
       balbir@linux.vnet.ibm.com, bharata@linux.vnet.ibm.com,
       tglx@linutronix.de, kamezawa.hiroyu@jp.fujitsu.com,
       kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, schwidefsky@de.ibm.com, balajirrao@gmail.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       bharata@linux.vnet.ibm.com, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
       mingo@elte.hu
In-Reply-To: <20090509191430.3AD5.A69D9226@jp.fujitsu.com>
References: <20090509191430.3AD5.A69D9226@jp.fujitsu.com>
Subject: [tip:sched/core] sched: cpuacct: Use bigger percpu counter batch values for stats counters
Message-ID: <tip-50fbed3bb72cbe38a665512771a91a96d028de46@git.kernel.org>
Git-Commit-ID: 50fbed3bb72cbe38a665512771a91a96d028de46
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 12:36:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  50fbed3bb72cbe38a665512771a91a96d028de46
Gitweb:     http://git.kernel.org/tip/50fbed3bb72cbe38a665512771a91a96d028de46
Author:     KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
AuthorDate: Sat, 9 May 2009 19:14:58 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 14:32:57 +0200

sched: cpuacct: Use bigger percpu counter batch values for stats counters

percpu counters used to accumulate statistics in cpuacct controller use
the default batch value [max(2*nr_cpus, 32)] which can be too small for
archs that define VIRT_CPU_ACCOUNTING. In such archs, a tick could result in
cputime updates in the range of thousands. As a result, cpuacct_update_stats()
would end up acquiring the percpu counter spinlock on every tick which
is not good for performance.

Let those architectures to have a bigger batch threshold so that percpu counter
spinlock isn't taken on every tick. This change doesn't affect the archs which
don't define VIRT_CPU_ACCOUNTING and they continue to have the default
percpu counter batch value.

 v5:
 - move cpuacct_batch initialization into sched_init()

 v4:
  - rewrite patch description (thanks Bharata!)
  - append read_mostly to cpuacct_batch
  - cpuacct_batch is initialized by sched_init_debug()

 v3:
  - revert using percpu_counter_sum()

 v2:
  - use percpu_counter_sum() instead percpu_counter_read()

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Balaji Rao <balajirrao@gmail.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
LKML-Reference: <20090509191430.3AD5.A69D9226@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8908d19..873bc3b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -872,6 +872,8 @@ static __read_mostly int scheduler_running;
  */
 int sysctl_sched_rt_runtime = 950000;
 
+static __read_mostly s32 cpuacct_batch;
+
 static inline u64 global_rt_period(void)
 {
 	return (u64)sysctl_sched_rt_period * NSEC_PER_USEC;
@@ -9171,6 +9173,8 @@ void __init sched_init(void)
 	 */
 	current->sched_class = &fair_sched_class;
 
+	cpuacct_batch = jiffies_to_cputime(percpu_counter_batch);
+
 	/* Allocate the nohz_cpu_mask if CONFIG_CPUMASK_OFFSTACK */
 	alloc_bootmem_cpumask_var(&nohz_cpu_mask);
 #ifdef CONFIG_SMP
@@ -10354,7 +10358,8 @@ static void cpuacct_update_stats(struct task_struct *tsk,
 	ca = task_ca(tsk);
 
 	do {
-		percpu_counter_add(&ca->cpustat[idx], val);
+		__percpu_counter_add(&ca->cpustat[idx], val, cpuacct_batch);
+
 		ca = ca->parent;
 	} while (ca);
 	rcu_read_unlock();
