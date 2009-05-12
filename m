Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbZELKBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbZELKBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 06:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbZELKB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 06:01:29 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49624 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbZELKB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 06:01:27 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [tip:sched/core] sched: cpuacct: Use bigger percpu counter batch values for stats counters
Cc: kosaki.motohiro@jp.fujitsu.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       schwidefsky@de.ibm.com, balajirrao@gmail.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, bharata@linux.vnet.ibm.com,
       tglx@linutronix.de, kamezawa.hiroyu@jp.fujitsu.com,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20090511150709.GA23787@elte.hu>
References: <tip-50fbed3bb72cbe38a665512771a91a96d028de46@git.kernel.org> <20090511150709.GA23787@elte.hu>
Message-Id: <20090512185836.D635.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 12 May 2009 19:01:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> * tip-bot for KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > Commit-ID:  50fbed3bb72cbe38a665512771a91a96d028de46
> > Gitweb:     http://git.kernel.org/tip/50fbed3bb72cbe38a665512771a91a96d028de46
> > Author:     KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > AuthorDate: Sat, 9 May 2009 19:14:58 +0900
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Mon, 11 May 2009 14:32:57 +0200
> > 
> > sched: cpuacct: Use bigger percpu counter batch values for stats counters
> 
> -tip testing found a build failure with this patch:
> 
> kernel/sched.c:9278: error: ‘percpu_counter_batch’ undeclared (first use in this function)
> kernel/sched.c:9278: error: (Each undeclared identifier is reported only once
> kernel/sched.c:9278: error: for each function it appears in.)

Oh, my fault again. Good catch!



Changelog:
  since V5
  - fix build error when UP

  since V4
  - move cpuacct_batch initialization into sched_init()

  since V3
  - rewirte patch description (thanks Bharata!)
  - append read_mostly to cpuacct_batch
  - cpuacct_batch is initialized by sched_init()

  since v2
  - revert using percpu_counter_sum()

  since v1
  - use percpu_counter_sum() instead percpu_counter_read()


---------------------------------------------------------
Subject: [PATCH v6] cpuacct: Use bigger percpu counter batch values for stats counters on archs that have VIRT_CPU_ACCOUNTING=y

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

Cc: Balaji Rao <balajirrao@gmail.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 kernel/sched.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: b/kernel/sched.c
===================================================================
--- a/kernel/sched.c	2009-05-12 13:12:59.000000000 +0900
+++ b/kernel/sched.c	2009-05-12 13:28:53.000000000 +0900
@@ -870,6 +870,8 @@ static __read_mostly int scheduler_runni
  */
 int sysctl_sched_rt_runtime = 950000;
 
+static __read_mostly s32 cpuacct_batch;
+
 static inline u64 global_rt_period(void)
 {
 	return (u64)sysctl_sched_rt_period * NSEC_PER_USEC;
@@ -9284,6 +9286,10 @@ void __init sched_init(void)
 
 	perf_counter_init();
 
+#ifdef CONFIGCONFIG_SMP
+	cpuacct_batch = jiffies_to_cputime(percpu_counter_batch);
+#endif
+
 	scheduler_running = 1;
 }
 
@@ -10457,7 +10463,8 @@ static void cpuacct_update_stats(struct 
 	ca = task_ca(tsk);
 
 	do {
-		percpu_counter_add(&ca->cpustat[idx], val);
+		__percpu_counter_add(&ca->cpustat[idx], val, cpuacct_batch);
+
 		ca = ca->parent;
 	} while (ca);
 	rcu_read_unlock();


