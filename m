Return-Path: <linux-kernel-owner+w=401wt.eu-S1758624AbZAGOgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624AbZAGOgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 09:36:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758252AbZAGOgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 09:36:31 -0500
Received: from mail.gmx.net ([213.165.64.20]:59758 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758202AbZAGOga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 09:36:30 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX192jkQIBgN2wlKbVeD+GZBLD69L0Sj6Pik1TZ4On3
	vY8RItcFIE5TN5
Subject: Re: [PATCH v7 0/8] Tunable sched_mc_power_savings=n
From: Mike Galbraith <efault@gmx.de>
To: svaidy@linux.vnet.ibm.com
Cc: balbir@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090107112639.GI4574@dirshya.in.ibm.com>
References: <1231098769.5757.43.camel@marge.simson.net>
	 <20090105032029.GE4301@dirshya.in.ibm.com>
	 <1231130416.5479.8.camel@marge.simson.net>
	 <1231137413.10471.23.camel@marge.simson.net>
	 <1231168786.9120.26.camel@marge.simson.net>
	 <1231234297.3806.50.camel@marge.simson.net>
	 <20090106150709.GG4574@dirshya.in.ibm.com>
	 <1231264117.5254.23.camel@marge.simson.net>
	 <20090106184552.GI17198@balbir.in.ibm.com>
	 <1231318755.3899.57.camel@marge.simson.net>
	 <20090107112639.GI4574@dirshya.in.ibm.com>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 15:36:25 +0100
Message-Id: <1231338985.5709.22.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-07 at 16:56 +0530, Vaidyanathan Srinivasan wrote:
> * Mike Galbraith <efault@gmx.de> [2009-01-07 09:59:15]:
> 
> > I have a couple questions if you don't mind.
> > 
> > In wake_idle() there's an odd looking check for kthreads.  Why does it
> > matter if a kbuild task wakes kernel or userland helper thread?
> 
> Only user space tasks/threads should be biased at wakeup and
> consolidated for the following reasons:
> 
> * kernel threads generally perform housekeeping tasks and its rate of
>   execution and cpu utilisation is far less than that of user task in
>   an under utilised system.  
> * Biasing at wakeup help consolidate bursty user space tasks. Long
>   running user space tasks will be consolidated by load balancer.
>   kthreads are not bursty, they are generally very short running.

Rummaging around in an nfs mount is bursty, and the nfs threads are part
of the burst.  No big deal, but I think it's illogical to differentiate.

> > I also don't see why sched_mc overrides domain tunings.  You can turn
> > NEWIDLE off and sched_mc remains as set, so it's a one-way override.  If
> > NEWIDLE is a requirement for sched_mc > 0, it seems only logical to set
> > sched_mc to 0 if the user explicitly disables NEWIDLE.
> 
> SD_BALANCE_NEWIDLE is required for sched_mc=2 and power savings while

That's a buglet then, because you can have sched_mc=2 and NEWIDLE off.

> not mandated for sched_mc=0.  We can remove NEWIDLE balance at
> sched_mc=0 if that helps baseline performance.  Ingo had identified
> that removing NEWIDLE balance help performance in certain benchmarks.

It used to help mysql+oltp low end throughput for one.  efbe027 seems to
have done away with that though (not that alone).

> I do not get what you have mentioned by NEWIDLE off?  Is there
> a separate user space control to independently set or reset
> SD_BALANCE_NEWIDLE at a give sched_domain level?

Yes. /proc/sys/kernel/sched_domain/cpuN/domainN/*

> Thanks for the detailed review.

You're very welcome.

	-Mike

> --Vaidy

