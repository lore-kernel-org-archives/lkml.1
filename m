Return-Path: <linux-kernel-owner+w=401wt.eu-S933815AbXCNEiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933815AbXCNEiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 00:38:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933818AbXCNEiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 00:38:03 -0400
Received: from gw.goop.org ([64.81.55.164]:39876 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933815AbXCNEiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 00:38:01 -0400
Message-ID: <45F77C27.8090604@goop.org>
Date: Tue, 13 Mar 2007 21:37:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dan Hecht <dhecht@vmware.com>
CC: dwalker@mvista.com, cpufreq@lists.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Stolen and degraded time and schedulers
References: <45F6D1D0.6080905@goop.org>	 <1173816769.22180.14.camel@localhost>	<45F70A71.9090205@goop.org> <1173821224.1416.24.camel@dwalker1> <45F71EA5.2090203@goop.org> <45F74515.7010808@vmware.com>
In-Reply-To: <45F74515.7010808@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Hecht wrote:
> With your previous definition of work time, would it be that:
>
> monotonic_time == work_time + stolen_time ??

(By monotonic time, I presume you mean monotonic real time.)  Yes, I
suppose you could, but I don't think that's terribly useful.   I think
work_time is probably most naturally measured in cpu clock cycles rather
than an actual time unit.  You could convert it to ns, but I don't see
the point.

I know its a term in general use, but I don't think the term "stolen
time" is all that useful, particularly when we're talking about a more
general notion of cpu work contributing to the progress of process
execution.  In the cpufreq case, time isn't "stolen" per se.

(I guess I don't like the term stolen time because you don't refer to
time spent on other processes as being stolen from your process: its
just processor time being distributed.)

> i.e. would you be defining stolen_time to include the time lost to
> processes due to the cpu running at a lower frequency?  How does this
> play into the other potential users, besides sched_clock(), of stolen
> time?  We should make sure that the abstraction introduced here makes
> sense in those places too.

Be specific.  What other uses are there?

> For example, the stuff that happens in update_process_times().  I
> think we'd want to account the stolen time to cpustat->steal.

I guess we could do something for that.  Would we account non-full-speed
cpus to it?  Maybe?

How is cpustat->steal used?  How does it get out to usermode?


>   Also we'd probably want account for stolen time with regards to
> task_running_tick().  (Though, in the latter case, maybe we first have
> to move the scheduler away from assuming HZ rate decrementing of
> p->time_slice to get this right. i.e. remove the tick based assumption
> from the scheduler, and then maybe stolen time falls in more naturally
> when accounting time slices).

I think the important part is that sched_clock() be used to actually
compute how much time each process gets.  The fact that a time quantum
gets stolen is less important.  Or do you mean something else?

> I guess taking your cpufreq as an example of work_time progressing
> slower than monotonic_time (and assuming that the remaining time is
> what you would call stolen), then e.g. top would report 50% of your
> cpu stolen when you cpu is running at 1/2 max rate.

Yes.  In the same way that clock modulation gates the cpu clock, the
hypervisor effectively gates the clock by giving time to other vcpus.

> And p->time_slice would decrement at 1/2 the rate it normally did when
> running at 1/2 speed.  Is this the right thing to do?  If so, then I
> agree it makes sense to model hypervisor stolen time in terms of your
> "work time".

Yes, that's my thought.

>   But, if not, then maybe the amount of work you can get done during a
> period of time that is not stolen and the stolen time itself are
> really two different notions, and shouldn't be confused.  I can see
> arguments both ways. 

It seems to me like a nice opportunity to solve two problems with one
mechanism.

    J
