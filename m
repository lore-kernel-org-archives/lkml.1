Return-Path: <linux-kernel-owner+w=401wt.eu-S933174AbXCMUNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174AbXCMUNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 16:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933185AbXCMUNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 16:13:00 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59841 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933174AbXCMUM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 16:12:58 -0400
Subject: Re: Stolen and degraded time and schedulers
From: john stultz <johnstul@us.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Con Kolivas <kernel@kolivas.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       James Morris <jmorris@namei.org>, Chris Wright <chrisw@sous-sol.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cpufreq@lists.linux.org.uk,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Daniel Walker <dwalker@mvista.com>
In-Reply-To: <45F6D1D0.6080905@goop.org>
References: <45F6D1D0.6080905@goop.org>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 13:12:48 -0700
Message-Id: <1173816769.22180.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 09:31 -0700, Jeremy Fitzhardinge wrote:
> The current Linux scheduler makes one big assumption: that 1ms of CPU
> time is the same as any other 1ms of CPU time, and that therefore a
> process makes the same amount of progress regardless of which particular
> ms of time it gets.
> 
> This assumption is wrong now, and will become more wrong as
> virtualization gets more widely used.
> 
> It's wrong now, because it fails to take into account of several kinds
> of missing time:
> 
>    1. interrupts - time spent in an ISR is accounted to the current
>       process, even though it gets no direct benefit
>    2. SMM - time is completely lost from the kernel
>    3. slow CPUs - 1ms of 600MHz CPU is less useful than 1ms of 2.4GHz CPU
> 
[snip]
> So how to deal with this?  Basically we need a clock which measures "CPU
> work units", and have the scheduler use this clock.
> 
> A "CPU work unit" clock has these properties:
> 
>     * inherently per-CPU (from the kernel's perspective, so it would be
>       per-VCPU in a virtual machine)
>     * monotonic - you can't do negative work
>     * measured in "work units"
[snip]
> So, how to implement this?
> 
> One quick hack would be to just make a new clocksource entrypoint, which
> returns work units rather than real-time cycles.  That would be fairly
> simple to implement, but it doesn't really take the per-cpu nature of
> the clock into account (since its possible that different cpus on the
> same machine might need their own methods).
> 
> Perhaps a better fit would be an entity which is equivalent to a
> clocksource, but registered per-cpu like (some) clockevents.
> 
> I don't have a particular preference, but I wonder what the clock gurus
> think.

My gut reaction would be to avoid using clocksources for now. While
there is some thought going into how to expand clocksources for other
uses (Daniel is working on this, for example), the design for
clocksources has been very focused on its utility to timekeeping, so I'm
hesitant to try complicate the clocksources in order to multiplex
functionality until what is really needed is well understood.

I suspect the best approach would be see how the sched_clock interface
can be reworked/used for what you want, as it's design goals map closest
to the work-unit properties you list above.

Then we can look to see how clocksources can be best used to implement
the sched_clock interface.

-john









