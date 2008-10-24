Return-Path: <linux-kernel-owner+w=401wt.eu-S1756534AbYJXLlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbYJXLlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 07:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbYJXLlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 07:41:06 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:57281 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905AbYJXLlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 07:41:04 -0400
Date: Fri, 24 Oct 2008 17:10:18 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       travis@sgi.com, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [PATCH 1/7] work_on_cpu: helper for doing task on a CPU.
Message-ID: <20081024114018.GA24080@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20081023005751.53973DDEFE@ozlabs.org> <20081023094036.GA7593@redhat.com> <20081023143605.GN5255@in.ibm.com> <200810241404.35932.rusty@rustcorp.com.au> <20081024072147.GA5000@in.ibm.com> <20081024102957.GC4583@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081024102957.GC4583@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 12:29:57PM +0200, Oleg Nesterov wrote:
> On 10/24, Gautham R Shenoy wrote:
> >
> > On Fri, Oct 24, 2008 at 02:04:35PM +1100, Rusty Russell wrote:
> > >
> > > I think we should BUG_ON(per_cpu(cpu_state, cpuid) != CPU_DEAD) to ensure we
> > > never use work_on_cpu in the hotplug cpu path.  Then we use
> > > smp_call_function() for that hard intel_cacheinfo case.  Finally, we fix the
> > > cpu hotplug path to use schedule_work_on() itself rather than playing games
> > > with cpumask.
> > >
> > > If you agree, I'll spin the patches...
> >
> > How about the following?
> >
> > We go with this method, but instead of piggybacking on
> > the generic kevents workqueue, we create our own on_each_cpu_wq, for this
> > purpose.
> 
> Gautham, Rusty, I am a bit lost on this discussion...
> 
> Why should we care about this deadlock? Just do not use work_on_cpu() from
> the hotplug cpu path, that is all.
> 
> Once again, the "cpu_hotplug_begin()" lock is not special. You can't use
> work_on_cpu() under (say) rtnl_lock() for the same reason, this lock is
> used by work->func() too.
> 
> Perhaps I missed something, and work_on_cpu() is really important for
> cpu-hotplug path?

Rusty, Oleg,

Having a rule that we shouldn't use work_on_cpu() in cpu-hotplug path
is a good thing. But maintaining it can be difficult.

We've seen that in the past with the cpucontrol mutex.
We had clear rules that functions which get called in
cpu-hotplug callback paths, shouldn't take this mutex. But with
functions that were called in the cpu-hotplug notifier
path as well as normal paths, it created a whole locking mess,
and took quite some time to fix.

Similarly, right now, we can have a BUG_ON() which notifies us whenever
someone ends up calling a function that invokes work_on_cpu() from the
CPU-Hotplug callpath. But we will fix it only when the BUG_ON() is hit.

On the other hand, if we have a mechanism that's guaranteed to work
irrespective of the callpaths, why not use that ?

I am not opposed to the proposed design.
Just voicing out an alternative thought. I could be completely wrong :-)

> 
> Oleg.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Thanks and Regards
gautham
