Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbZEIKPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbZEIKPU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 06:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbZEIKPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 06:15:04 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56368 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbZEIKPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 06:15:01 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH v3] cpuacct: VIRT_CPU_ACCOUNTING don't prevent percpu cputime count
Cc: kosaki.motohiro@jp.fujitsu.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <20090509185145.3AD2.A69D9226@jp.fujitsu.com>
References: <1241861925.6316.112.camel@laptop> <20090509185145.3AD2.A69D9226@jp.fujitsu.com>
Message-Id: <20090509191430.3AD5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sat,  9 May 2009 19:14:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Sat, 2009-05-09 at 18:26 +0900, KOSAKI Motohiro wrote:
> > > 
> > > Index: b/kernel/sched.c
> > > ===================================================================
> > > --- a/kernel/sched.c    2009-05-09 16:48:08.000000000 +0900
> > > +++ b/kernel/sched.c    2009-05-09 18:16:00.000000000 +0900
> > > @@ -824,8 +824,12 @@ static struct file_operations sched_feat
> > >         .release        = single_release,
> > >  };
> > >  
> > > +static __read_mostly s32 cpuacct_batch;
> > > +
> > >  static __init int sched_init_debug(void)
> > >  {
> > > +       cpuacct_batch = jiffies_to_cputime(percpu_counter_batch);
> > > +
> > >         debugfs_create_file("sched_features", 0644, NULL, NULL,
> > >                         &sched_feat_fops);
> > 
> > I'm pretty user you can select cpu accounting without SCHED_DEBUG...
> 
> Grr, yes, it's idiot ;)
> I'll fix it soon.


Done.


Changelog:
  since V4
  - move cpuacct_batch initialization into sched_init()

  since V3
  - rewirte patch description (thanks Bharata!)
  - append read_mostly to cpuacct_batch
  - cpuacct_batch is initialized by sched_init_debug()

  since v2
  - revert using percpu_counter_sum()

  since v1
  - use percpu_counter_sum() instead percpu_counter_read()


---------------------------------------------------------
Subject: [PATCH v5] cpuacct: Use bigger percpu counter batch values for stats counters on archs that have VIRT_CPU_ACCOUNTING=y

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
 kernel/sched.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: b/kernel/sched.c
===================================================================
--- a/kernel/sched.c	2009-05-09 16:48:08.000000000 +0900
+++ b/kernel/sched.c	2009-05-09 18:57:35.000000000 +0900
@@ -870,6 +870,8 @@ static __read_mostly int scheduler_runni
  */
 int sysctl_sched_rt_runtime = 950000;
 
+static __read_mostly s32 cpuacct_batch;
+
 static inline u64 global_rt_period(void)
 {
 	return (u64)sysctl_sched_rt_period * NSEC_PER_USEC;
@@ -9284,6 +9286,8 @@ void __init sched_init(void)
 
 	perf_counter_init();
 
+	cpuacct_batch = jiffies_to_cputime(percpu_counter_batch);
+
 	scheduler_running = 1;
 }
 
@@ -10457,7 +10461,8 @@ static void cpuacct_update_stats(struct 
 	ca = task_ca(tsk);
 
 	do {
-		percpu_counter_add(&ca->cpustat[idx], val);
+		__percpu_counter_add(&ca->cpustat[idx], val, cpuacct_batch);
+
 		ca = ca->parent;
 	} while (ca);
 	rcu_read_unlock();


