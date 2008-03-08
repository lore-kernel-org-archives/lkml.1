Return-Path: <linux-kernel-owner+w=401wt.eu-S1758250AbYCHBwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbYCHBwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 20:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbYCHBwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 20:52:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:5127 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbYCHBwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 20:52:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,465,1199692800"; 
   d="scan'208";a="530631303"
Date: Fri, 7 Mar 2008 17:50:45 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, dmitry.adamushko@gmail.com,
       ego@in.ibm.com, mingo@elte.hu, oleg@tv-sign.ru, yi.y.yang@intel.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [BUG 2.6.25-rc3] scheduler/hotplug: some processes are dealocked when cpu is set to offline
Message-ID: <20080308015045.GB15909@linux-os.sc.intel.com>
References: <1204483329.3607.8.camel@yangyi-dev.bj.intel.com> <20080307230126.GA15909@linux-os.sc.intel.com> <20080307152934.5c4052db.akpm@linux-foundation.org> <200803080043.16817.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803080043.16817.rjw@sisk.pl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08, 2008 at 12:43:15AM +0100, Rafael J. Wysocki wrote:
> On Saturday, 8 of March 2008, Andrew Morton wrote:
> > On Fri, 7 Mar 2008 15:01:26 -0800
> > Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> > 
> > > 
> > > Andrew, Please check if the appended patch fixes your power-off problem aswell.
> > > ...
> > >
> > > --- a/kernel/sched.c
> > > +++ b/kernel/sched.c
> > > @@ -5882,6 +5882,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
> > >  		break;
> > >  
> > >  	case CPU_DOWN_PREPARE:
> > > +	case CPU_DOWN_PREPARE_FROZEN:
> > >  		/* Update our root-domain */
> > >  		rq = cpu_rq(cpu);
> > >  		spin_lock_irqsave(&rq->lock, flags);
> > 
> > No, it does not.
> 
> Well, this is a bug nevertheless.
> 

Well, my previous root cause needs some small changes.

During the notifier call chain for CPU_DOWN(till 'update_sched_domains'
is called atleast), all the cpu's are attached to 'def_root_domain', for whom
online mask still has the offline cpu.

This is because, during CPU_DOWN_PREPARE, migration_call() first clears
the root_domain->online, and later during the DOWN_PREPARE call chain
detach_destroy_domains() attach to def_root_domain with cpu_online_map(which
still has the just about to die 'cpu' set).

So essentially, during the notifier call chain of CPU_DOWN (before
'update_sched_domains' is called atleast), any one doing RT process
wakeup's (for example: kthread_stop()) can still end up on the dead cpu.

Andrew, Can you please try one more patch(appended) to see if it helps?

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 0a6d2e5..8cb707c 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -597,7 +597,7 @@ static int find_lowest_cpus(struct task_struct *task, cpumask_t *lowest_mask)
 	int       count       = 0;
 	int       cpu;
 
-	cpus_and(*lowest_mask, task_rq(task)->rd->online, task->cpus_allowed);
+	cpus_and(*lowest_mask, task->cpus_allowed, cpu_online_map);
 
 	/*
 	 * Scan each rq for the lowest prio.
