Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbYJXHWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbYJXHWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 03:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbYJXHWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 03:22:14 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:41449 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbYJXHWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 03:22:14 -0400
Date: Fri, 24 Oct 2008 12:51:47 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       travis@sgi.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/7] work_on_cpu: helper for doing task on a CPU.
Message-ID: <20081024072147.GA5000@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20081023005751.53973DDEFE@ozlabs.org> <20081023094036.GA7593@redhat.com> <20081023143605.GN5255@in.ibm.com> <200810241404.35932.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810241404.35932.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 02:04:35PM +1100, Rusty Russell wrote:
> On Friday 24 October 2008 01:36:05 Gautham R Shenoy wrote:
> > OK, how about doing the following? That will solve the problem
> > of deadlock you pointed out in patch 6.
> >
> > 		get_online_cpus();
> > 		if (likely(per_cpu(cpu_state, cpuid) == CPU_ONLINE)) {
> > 			schedule_work_on(cpu, &wfc.work);
> > 			flush_work(&wfc.work);
> > 		} else if (per_cpu(cpu_state, cpuid) != CPU_DEAD)) {
> > 			/*
> > 			 * We're the CPU-Hotplug thread. Call the
> > 			 * function synchronously so that we don't
> > 			 * deadlock with any pending work-item blocked
> > 			 * on get_online_cpus()
> > 			 */
> > 			 cpumask_t  orignal_mask = current->cpus_allowed;
> > 			 set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu);
> > 			 wfc.ret = fn(arg);
> > 			 set_cpus_allowed_ptr(current, &original_mask);
> > 		}
> 
> Hi Gautham, Oleg,
> 
> Unfortunately that's exactly what I'm trying to get away from: another cpumask 
> on the stack :(

Oh, okay, understood.
> 
> The cpu hotplug thread is just whoever wrote 0 to "online" in sys.  And in 
> fact it already plays with its cpumask, which should be fixed too.

Right, we do that during cpu_offline to ensure that we don't run on the
cpu which is to be offlined.

> 
> I think we should BUG_ON(per_cpu(cpu_state, cpuid) != CPU_DEAD) to ensure we 
> never use work_on_cpu in the hotplug cpu path.  Then we use 
> smp_call_function() for that hard intel_cacheinfo case.  Finally, we fix the 
> cpu hotplug path to use schedule_work_on() itself rather than playing games 
> with cpumask.
> 
> If you agree, I'll spin the patches...

How about the following?

We go with this method, but instead of piggybacking on
the generic kevents workqueue, we create our own on_each_cpu_wq, for this
purpose.

Since the worker threads of this workqueue run only the work-items
queued by us, and since we take care of the cpu-hotplug locking _before_
queueing the work item, we can be sure that we won't deadlock
since no work-item when running can block on get_online_cpus().

This would hold good even for those work-items queued from
the CPU-Hotplug notifier call path.

Thus we can have the same semantics everywhere, rather than having
multiple cases.

Does this make sense?
> 
> Thanks for the brainpower,
> Rusty.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Thanks and Regards
gautham
