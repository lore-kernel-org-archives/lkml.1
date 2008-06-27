Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbYF0DWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbYF0DWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 23:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbYF0DVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 23:21:51 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:55422 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750770AbYF0DVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 23:21:50 -0400
Date: Fri, 27 Jun 2008 08:53:17 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Paul Menage <menage@google.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Paul Jackson <pj@sgi.com>,
       a.p.zijlstra@chello.nl, maxk@qualcomm.com, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFC][PATCH] CPUSets: Move most calls to
	rebuild_sched_domains() to the workqueue
Message-ID: <20080627032317.GB3419@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <48634BC1.8@google.com> <20080627032228.GA3419@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627032228.GA3419@in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 08:52:28AM +0530, Gautham R Shenoy wrote:
> On Thu, Jun 26, 2008 at 12:56:49AM -0700, Paul Menage wrote:
> > CPUsets: Move most calls to rebuild_sched_domains() to the workqueue
> >
> > In the current cpusets code the lock nesting between cgroup_mutex and
> > cpuhotplug.lock when calling rebuild_sched_domains is inconsistent -
> > in the CPU hotplug path cpuhotplug.lock nests outside cgroup_mutex,
> > and in all other paths that call rebuild_sched_domains() it nests
> > inside.
> >
> > This patch makes most calls to rebuild_sched_domains() asynchronous
> > via the workqueue, which removes the nesting of the two locks in that
> > case. In the case of an actual hotplug event, cpuhotplug.lock nests
> > outside cgroup_mutex as now.
> >
> > Signed-off-by: Paul Menage <menage@google.com>
> >
> > ---
> >
> > Note that all I've done with this patch is verify that it compiles
> > without warnings; I'm not sure how to trigger a hotplug event to test
> > the lock dependencies or verify that scheduler domain support is still
> > behaving correctly. Vegard, does this fix the problems that you were
> > seeing? Paul/Max, does this still seem sane with regard to scheduler domains?
> >
> 
> Hi Paul, 
> 

This time CC'ing Oleg!

> Using a multithreaded workqueue(kevent here) for this is not such a
> great idea this,since currently we cannot call
> get_online_cpus() from a workitem executed by a multithreaded workqueue.
> 
> Can one use a single threaded workqueue here instead ?
> 
> Or, better, I think we can ask Oleg to re-submit the patch he had to make
> get_online_cpus() safe to be called from within the workqueue. It does
> require a special post CPU_DEAD notification, but as it does work the
> last time I checked.
> 
> >
> > kernel/cpuset.c |   35 +++++++++++++++++++++++------------
> > 1 file changed, 23 insertions(+), 12 deletions(-)
> >
> > Index: lockfix-2.6.26-rc5-mm3/kernel/cpuset.c
> > ===================================================================
> > --- lockfix-2.6.26-rc5-mm3.orig/kernel/cpuset.c
> > +++ lockfix-2.6.26-rc5-mm3/kernel/cpuset.c
> > @@ -522,13 +522,9 @@ update_domain_attr(struct sched_domain_a
> >  * domains when operating in the severe memory shortage situations
> >  * that could cause allocation failures below.
> >  *
> > - * Call with cgroup_mutex held.  May take callback_mutex during
> > - * call due to the kfifo_alloc() and kmalloc() calls.  May nest
> > - * a call to the get_online_cpus()/put_online_cpus() pair.
> > - * Must not be called holding callback_mutex, because we must not
> > - * call get_online_cpus() while holding callback_mutex.  Elsewhere
> > - * the kernel nests callback_mutex inside get_online_cpus() calls.
> > - * So the reverse nesting would risk an ABBA deadlock.
> > + * Call with cgroup_mutex held, and inside get_online_cpus().  May
> > + * take callback_mutex during call due to the kfifo_alloc() and
> > + * kmalloc() calls.
> >  *
> >  * The three key local variables below are:
> >  *    q  - a kfifo queue of cpuset pointers, used to implement a
> > @@ -689,9 +685,7 @@ restart:
> >
> > rebuild:
> > 	/* Have scheduler rebuild sched domains */
> > -	get_online_cpus();
> > 	partition_sched_domains(ndoms, doms, dattr);
> > -	put_online_cpus();
> >
> > done:
> > 	if (q && !IS_ERR(q))
> > @@ -701,6 +695,21 @@ done:
> > 	/* Don't kfree(dattr) -- partition_sched_domains() does that. */
> > }
> >
> > +/*
> > + * Due to the need to nest cgroup_mutex inside cpuhotplug.lock, most
> > + * of our invocations of rebuild_sched_domains() are done
> > + * asynchronously via the workqueue
> > + */
> > +static void delayed_rebuild_sched_domains(struct work_struct *work)
> > +{
> > +	get_online_cpus();
> > +	cgroup_lock();
> > +	rebuild_sched_domains();
> > +	cgroup_unlock();
> > +	put_online_cpus();
> > +}
> > +static DECLARE_WORK(rebuild_sched_domains_work, delayed_rebuild_sched_domains);
> > +
> > static inline int started_after_time(struct task_struct *t1,
> > 				     struct timespec *time,
> > 				     struct task_struct *t2)
> > @@ -853,7 +862,7 @@ static int update_cpumask(struct cpuset 		return 
> > retval;
> >
> > 	if (is_load_balanced)
> > -		rebuild_sched_domains();
> > +		schedule_work(&rebuild_sched_domains_work);
> > 	return 0;
> > }
> >
> > @@ -1080,7 +1089,7 @@ static int update_relax_domain_level(str
> >
> > 	if (val != cs->relax_domain_level) {
> > 		cs->relax_domain_level = val;
> > -		rebuild_sched_domains();
> > +		schedule_work(&rebuild_sched_domains_work);
> > 	}
> >
> > 	return 0;
> > @@ -1121,7 +1130,7 @@ static int update_flag(cpuset_flagbits_t
> > 	mutex_unlock(&callback_mutex);
> >
> > 	if (cpus_nonempty && balance_flag_changed)
> > -		rebuild_sched_domains();
> > +		schedule_work(&rebuild_sched_domains_work);
> >
> > 	return 0;
> > }
> > @@ -1929,6 +1938,7 @@ static void scan_for_empty_cpusets(const
> >
> > static void common_cpu_mem_hotplug_unplug(void)
> > {
> > +	get_online_cpus();
> > 	cgroup_lock();
> >
> > 	top_cpuset.cpus_allowed = cpu_online_map;
> > @@ -1942,6 +1952,7 @@ static void common_cpu_mem_hotplug_unplu
> > 	rebuild_sched_domains();
> >
> > 	cgroup_unlock();
> > +	put_online_cpus();
> > }
> >
> > /*
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> -- 
> Thanks and Regards
> gautham

-- 
Thanks and Regards
gautham
