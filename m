Return-Path: <linux-kernel-owner+w=401wt.eu-S1760089AbZAGPcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089AbZAGPcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 10:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbZAGPcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 10:32:23 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:45083 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbZAGPcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 10:32:22 -0500
Date: Wed, 7 Jan 2009 21:05:10 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: balbir@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 0/8] Tunable sched_mc_power_savings=n
Message-ID: <20090107153510.GN4574@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <1231130416.5479.8.camel@marge.simson.net> <1231137413.10471.23.camel@marge.simson.net> <1231168786.9120.26.camel@marge.simson.net> <1231234297.3806.50.camel@marge.simson.net> <20090106150709.GG4574@dirshya.in.ibm.com> <1231264117.5254.23.camel@marge.simson.net> <20090106184552.GI17198@balbir.in.ibm.com> <1231318755.3899.57.camel@marge.simson.net> <20090107112639.GI4574@dirshya.in.ibm.com> <1231338985.5709.22.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1231338985.5709.22.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith <efault@gmx.de> [2009-01-07 15:36:25]:

> On Wed, 2009-01-07 at 16:56 +0530, Vaidyanathan Srinivasan wrote:
> > * Mike Galbraith <efault@gmx.de> [2009-01-07 09:59:15]:
> > 
> > > I have a couple questions if you don't mind.
> > > 
> > > In wake_idle() there's an odd looking check for kthreads.  Why does it
> > > matter if a kbuild task wakes kernel or userland helper thread?
> > 
> > Only user space tasks/threads should be biased at wakeup and
> > consolidated for the following reasons:
> > 
> > * kernel threads generally perform housekeeping tasks and its rate of
> >   execution and cpu utilisation is far less than that of user task in
> >   an under utilised system.  
> > * Biasing at wakeup help consolidate bursty user space tasks. Long
> >   running user space tasks will be consolidated by load balancer.
> >   kthreads are not bursty, they are generally very short running.
> 
> Rummaging around in an nfs mount is bursty, and the nfs threads are part
> of the burst.  No big deal, but I think it's illogical to differentiate.

nfs threads is a real good example.  I missed that.  I will play
around with nfs threads and try to optimise the condition.

> > > I also don't see why sched_mc overrides domain tunings.  You can turn
> > > NEWIDLE off and sched_mc remains as set, so it's a one-way override.  If
> > > NEWIDLE is a requirement for sched_mc > 0, it seems only logical to set
> > > sched_mc to 0 if the user explicitly disables NEWIDLE.
> > 
> > SD_BALANCE_NEWIDLE is required for sched_mc=2 and power savings while
> 
> That's a buglet then, because you can have sched_mc=2 and NEWIDLE off.

Tweaking the sched domain parameters affect the default power saving
heuristics anyway.  Protecting against the flags alone will not help.
Your point is valid, I will think about this scenario and see how we
can protect the behavior.
 
> > not mandated for sched_mc=0.  We can remove NEWIDLE balance at
> > sched_mc=0 if that helps baseline performance.  Ingo had identified
> > that removing NEWIDLE balance help performance in certain benchmarks.
> 
> It used to help mysql+oltp low end throughput for one.  efbe027 seems to
> have done away with that though (not that alone).
> 
> > I do not get what you have mentioned by NEWIDLE off?  Is there
> > a separate user space control to independently set or reset
> > SD_BALANCE_NEWIDLE at a give sched_domain level?
> 
> Yes. /proc/sys/kernel/sched_domain/cpuN/domainN/*

Changing flags through this interface is complete low level control.
End users who want to tweak individual sched domain parameters are
either experimenting or optimising for their specific workload.

The defaults should generally across common workloads.  Users can
further tweak this low level settings.  We can clearly document the
relations so that we know what to expect.

sched_mc=2 depends on NEWIDLE but the wakeup biasing part will be
enabled even without this flag.  The power savings will be marginally
better than sched_mc=1 without NEWIDLE.  But the end user can have
that setup if they want to.

You have pointed out a scenario where users can turn off NEWIDLE and
still expect to use sched_mc=2.  The scenario is valid and the user
should be allowed to do so.

--Vaidy
