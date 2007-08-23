Return-Path: <linux-kernel-owner+w=401wt.eu-S1765395AbXHWPzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765395AbXHWPzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 11:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765150AbXHWPzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 11:55:32 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42541 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765127AbXHWPz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 11:55:29 -0400
Date: Thu, 23 Aug 2007 08:55:26 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de
Subject: Re: [PATCH RFC] Priority boosting for preemptible RCU
Message-ID: <20070823155526.GB8371@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070822190254.GA1135@linux.vnet.ibm.com> <20070823042639.GA28026@in.ibm.com> <20070823085456.GA18627@linux.vnet.ibm.com> <20070823101444.GB11258@in.ibm.com> <20070823131501.GC18627@linux.vnet.ibm.com> <20070823142211.GC11258@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823142211.GC11258@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 07:52:11PM +0530, Gautham R Shenoy wrote:
> On Thu, Aug 23, 2007 at 06:15:01AM -0700, Paul E. McKenney wrote:
> > On Thu, Aug 23, 2007 at 03:44:44PM +0530, Gautham R Shenoy wrote:
> > > On Thu, Aug 23, 2007 at 01:54:56AM -0700, Paul E. McKenney wrote:
> > > > On Thu, Aug 23, 2007 at 09:56:39AM +0530, Gautham R Shenoy wrote:
> > > > > 
> > > > > I feel we should still be able to use for_each_online_cpu(cpu) instead
> > > > > of for_each_possible_cpu. Again, there's a good chance that I might
> > > > > be mistaken!
> > > > > 
> > > > > How about the following ?
> > > > > 
> > > > > 	preempt_disable(); /* We Dont want cpus going down here */
> > > > > 	for_each_online_cpu(cpu) 
> > > > > 		for (i = 0; i < RCU_BOOST_ELEMENTS; i++) {
> > > > > 			rbdp = per_cpu(rcu_boost_dat, cpu);
> > > > > 			sum.rbs_blocked += rbdp[i].rbs_blocked;
> > > > > 			sum.rbs_boost_attempt += rbdp[i].rbs_boost_attempt;
> > > > > 			sum.rbs_boost += rbdp[i].rbs_boost;
> > > > > 			sum.rbs_unlock += rbdp[i].rbs_unlock;
> > > > > 			sum.rbs_unboosted += rbdp[i].rbs_unboosted;
> > > > > 		}
> > > > > 	preempt_enable(); 
> > > > > 
> > > > > 
> > > > > 	static int rcu_boost_cpu_callback(struct notifier_bloack *nb, 
> > > > > 					unsigned long action, void *hcpu) 
> > > > > 	{
> > > > > 		int this_cpu, cpu;
> > > > > 		rcu_boost_data *rbdp, *this_rbdp;
> > > > > 
> > > > > 		switch (action) {
> > > > > 		case CPU_DEAD:
> > > > > 			this_cpu = get_cpu();
> > > > > 			cpu = (long)hcpu;
> > > > > 			this_cpu = smp_processor_id();
> > > > > 			rbdp = per_cpu(rcu_boost_dat, cpu);
> > > > > 			this_rbdp = per_cpu(rcu_boost_dat, cpu);
> > > > > 			/* 
> > > > > 			 *  Transfer all of rbdp's statistics to
> > > > > 			 *  this_rbdp here.
> > > > > 			 */	
> > > > > 			 put_cpu();
> > > > > 	
> > > > > 			return NOTIFY_OK;
> > > > > 		}
> > > > > 	}
> > > > > 
> > > > > 
> > > > > Won't this work in this case?
> > > > 
> > > > Hello, Gautham,
> > > > 
> > > > We could do something similar.  If there was a global rcu_boost_data
> > > > variable that held the sums of the fields of the rcu_boost_data
> > > > structures for all offline CPUs, and if we used a new lock to protect
> > > > that global rcu_boost data variable (both when reading and when
> > > > CPU hotplugging), then we could indeed scan only the online CPUs'
> > > > rcu_boost_data elements.
> > > > 
> > > > We would also have to maintain a cpumask_t for this purpose, and
> > > > we would need to add a CPU's contribution when it went offline and
> > > > subtract it when that CPU came back online.
> > > 
> > > The additional cpumask_t beats me though! Doesn't the cpu_online_map
> > > suffice here? 
> > > The addition and subtraction of a hotplugged cpu's
> > > contribution from the global rcu_boost_data could be done while
> > > handling the CPU_ONLINE and CPU_DEAD (or CPU_UP_PREPARE
> > > and CPU_DOWN_PREPARE, whichever suits better), in the cpu hotplug
> > > callback. 
> > > 
> > > Am I missing something ?
> > 
> > Don't we need to synchronize the manipulation of the hotplugged CPU's
> > contribution and the manipulation of cpu_online_map?  Otherwise, if
> > stats are called for just before (or just after, depending on the
> > ordering of hotplug operations) the invocation will get the wrong
> > statistics.
> 
> Oh, yes we need to synchronize that :-)
> 
> Can't we use lock_cpu_hotplug/unlock_cpu_hotplug (or it's variant when 
> it is available) around any access to cpu_online_map ? With that, it's
> guaranteed that no cpu-hotplug operation will be permitted while you're
> iterating over the cpu_online_map, and hence you have a  
> consistent view of global rcu_boost_data.
> 
> Even if we use another cpumask_t, whenever a cpu goes down or comes up,
> that will be reflected in this map, no? So what's the additional
> advantage of using it?

The additional map allows the code to use something other than the
lock_cpu_hotplug/unlock_cpu_hotplug, and also is robust against any
changes to the hotplug synchronization mechanism.  Might well be
better just to use the current hotplug synchronization mechanism,
but I was feeling paranoid.  ;-)

						Thanx, Paul

> > > > The lock should not be a problem even on very large systems because
> > > > of the low frequency of statistics printing -- and of hotplug operations,
> > > > for that matter.
> > > 
> > > The lock is not a problem, so long as somebody else doesn't call
> > > the function taking the lock from their cpu-hotplug callback path :-)
> > > Though I don't see it happening here.
> > 
> > There are some ways to decrease its utilization if it should become
> > a problem in any case.
> 
> Cool!
> 
> > 
> > 						Thanx, Paul
> > 
> 
> Thanks and Regards
> gautham.
> -- 
> Gautham R Shenoy
> Linux Technology Center
> IBM India.
> "Freedom comes with a price tag of responsibility, which is still a bargain,
> because Freedom is priceless!"
