Return-Path: <linux-kernel-owner+w=401wt.eu-S1760265AbZELKox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760265AbZELKox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 06:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbZELKon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 06:44:43 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46564 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbZELKom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 06:44:42 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [tip:sched/core] sched: cpuacct: Use bigger percpu counter batch values for stats counters
Cc: kosaki.motohiro@jp.fujitsu.com, Balbir Singh <balbir@linux.vnet.ibm.com>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, schwidefsky@de.ibm.com, balajirrao@gmail.com,
       dhaval@linux.vnet.ibm.com, bharata@linux.vnet.ibm.com,
       tglx@linutronix.de, kamezawa.hiroyu@jp.fujitsu.com,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20090512102939.GB11714@elte.hu>
References: <20090512102412.GG6351@balbir.in.ibm.com> <20090512102939.GB11714@elte.hu>
Message-Id: <20090512193656.D647.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 12 May 2009 19:44:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> * Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2009-05-12 19:13:42]:
> > 
> > > > > +#ifdef CONFIGCONFIG_SMP
> > > > > +	cpuacct_batch = jiffies_to_cputime(percpu_counter_batch);
> > > > > +#endif
> > > > 
> > > > Slow down and compile patches before sending them out.. please. That
> > > > is a basic expectation if you expect it to be merged.
> > > 
> > > Unfortunately, this mistake pass test successfully ;)
> > > it because cpuacct_batch=0 works even SMP.
> > >
> > 
> > OK, BTW, using an #ifdef right in the middle of a function makes 
> > the code harder to read, can't we use an inline function to 
> > abstract out SMP?
> 
> or rather, to make cpuacct_batch have a sane value on UP too. (1? 
> 0?)

umm..

I've reviewed my patch again.
but sched_init() already has multiple #ifdef SMP. Thus I don't think
cosmetic changing improve readability largely.



------------------------------------
Subject: [PATCH] sched: cpuacct: Use bigger percpu counter batch values for stats counters

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

 v7:
 - fix typo and changelog

 v6:
 - fix build error when UP

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
+++ b/kernel/sched.c	2009-05-12 19:04:49.000000000 +0900
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
 
+#ifdef CONFIG_SMP
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


