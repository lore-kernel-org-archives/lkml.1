Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbXJWR0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbXJWR0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 13:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbXJWR01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 13:26:27 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39922 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755AbXJWR0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 13:26:25 -0400
Date: Tue, 23 Oct 2007 23:08:37 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] CFS CGroup: Report usage
Message-ID: <20071023173837.GG4667@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <471D4523.4040509@google.com> <20071023164704.GE4667@linux.vnet.ibm.com> <6599ad830710230941y5d175688ob3a4d9ac42ba8c8f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830710230941y5d175688ob3a4d9ac42ba8c8f@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 09:41:49AM -0700, Paul Menage wrote:
> > > Adds a cpu.usage file to the CFS cgroup that reports CPU usage in
> > > milliseconds for that cgroup's tasks
> >
> > It would be nice to split this into user and sys time at some point.
> 
> Sounds reasonable - but does CFS track this?

No, not for a group. We could extend account_user_time() and
account_systime_time() in this regard.

> > We have also received request to provide idle time for a
> > container/cgroup.
> 
> The semantics of "idle time" for a cgroup on a shared system seem a
> bit fuzzy. How would you define it?

I think the percentage of time when it didn't have any runnable task in
its runqueues.

> Suppose you have two cgroups that would each want to use, say, 55% of
> a CPU - technically they should each be regarded as having 45% idle
> time, but if they run on a the same CPU the chances are that they will
> both always have some processes on their runqueue due to contention
> with the other group. So how would you measure the difference between
> this and a cgroup that really is trying to use 100%?

Good point. I think we need to subtract out the time it was waiting on runqueue
when calculating idle time.

	|------- . . . . . . ---------zzzzzzzzzzzz.......-----------|
	t0     t1	     t2	      t3 	 t4     t5          t6


	----	-> Running time
	....	-> Waiting time (to get on the cpu)
	zzzz	-> Sleeping time (when it didnt want to run because of
		   lack of tasks)

So, in this case, 

	idle time = (t4 - t3) / [ (t6 - t1) - (t2-t1) - (t5-t4) 

?

This idle time will be a per-cpu stat for every cgroup and needs to be
consolidated across cpus into a single idle-stat number, just like how
top does it.

-- 
Regards,
vatsa
