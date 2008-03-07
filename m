Return-Path: <linux-kernel-owner+w=401wt.eu-S1763583AbYCGXE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763583AbYCGXE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 18:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758406AbYCGXEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 18:04:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:48043 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758290AbYCGXEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 18:04:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,464,1199692800"; 
   d="scan'208";a="304490905"
Date: Fri, 7 Mar 2008 15:01:26 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>, ego@in.ibm.com,
       mingo@elte.hu, oleg@tv-sign.ru, yi.y.yang@intel.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [BUG 2.6.25-rc3] scheduler/hotplug: some processes are dealocked when cpu is set to offline
Message-ID: <20080307230126.GA15909@linux-os.sc.intel.com>
References: <1204483329.3607.8.camel@yangyi-dev.bj.intel.com> <b647ffbd0803070502m28355751rd526ed8ca4dd90a@mail.gmail.com> <20080307121822.54b8c2fb.akpm@linux-foundation.org> <200803072236.26256.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803072236.26256.rjw@sisk.pl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 10:36:25PM +0100, Rafael J. Wysocki wrote:
> On Friday, 7 of March 2008, Andrew Morton wrote:
> > -		sched_setscheduler(p, SCHED_FIFO, &param);
> > +//		sched_setscheduler(p, SCHED_FIFO, &param);
> >  		kthread_stop(p);
> >  		takeover_tasklets(hotcpu);
> >  		break;
> > _
> > 
> > fixes the wont-power-off regression.
> > 
> > But 2.6.24 runs the watchdog threads SCHED_FIFO too.  Are you saying that
> > it's the migration code which changed? 
> 
> Well, that would be a problem for suspend/hibernation if there were SCHED_FIFO
> non-freezable tasks bound to the nonboot CPUs.  I'm not aware of any, but ...
> 
> Also, it should be possible to just offline one or more CPUs using the sysfs
> interface at any time and what happens if there are any RT tasks bound to these
> CPUs at that time?  That would be the $subject problem, IMHO.
> 
> Anyone who made the change affecting __migrate_task() so it's unable to migrate
> RT tasks any more should have fixed the CPU hotplug as well.

No. Its not the issue with __migrate_task(). Appended patch fixes my issue.
Recent RT wakeup balance code changes exposed a bug in migration_call() code
path.

Andrew, Please check if the appended patch fixes your power-off problem aswell.

thanks,
suresh
---

Handle the `CPU_DOWN_PREPARE_FROZEN' case in migration_call().

Otherwise, without this, we don't clear the cpu going down in the
root domains "online" mask. This was causing the RT tasks to be woken
up on already dead cpus, causing system hangs during standby, shutdown etc.

For example, on my system, this is the failing sequence:

kthread_stop() // coming from the cpu_callback's
    wake_up_process()
	sched_class->select_task_rq(); //select_task_rq_rt
	    find_lowest_rq
		find_lowest_cpus
	    	    cpus_and(*lowest_mask, task_rq(task)->rd->online, task->cpus_allowed);

In my case tasks->cpus_allowed is set to cpu_possible_map and because of the
this bug, rd->online still shows the dead cpu. Resulting in
find_lowest_rq() return an offlined cpu, because of which RT task gets woken
up on a DEAD cpu, causing various hangs.

This issue doesn't happen with normal tasks because, the select_task_rq_fair()
chooses between only two cpu's (the cpu which is waking up the task or last run
cpu (task_cpu()), kernel hotplug code makes sure that both of which always
represent the online CPU's).

Why it didn't show up in 2.6.24? Because the new wakeup code is using a
complex CPU selection logic in select_task_rq_rt() which exposed this
bug in migration_call()

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/kernel/sched.c b/kernel/sched.c
index 52b9867..60550d8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5882,6 +5882,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 
 	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
 		/* Update our root-domain */
 		rq = cpu_rq(cpu);
 		spin_lock_irqsave(&rq->lock, flags);
