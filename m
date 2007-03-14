Return-Path: <linux-kernel-owner+w=401wt.eu-S933805AbXCNCAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933805AbXCNCAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 22:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933781AbXCNCAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 22:00:13 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:51096 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933796AbXCNCAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 22:00:11 -0400
Subject: Re: Stolen and degraded time and schedulers
From: Daniel Walker <dwalker@mvista.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: john stultz <johnstul@us.ibm.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Zachary Amsden <zach@vmware.com>, James Morris <jmorris@namei.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cpufreq@lists.linux.org.uk,
       Virtualization Mailing List <virtualization@lists.osdl.org>
In-Reply-To: <45F71EA5.2090203@goop.org>
References: <45F6D1D0.6080905@goop.org>
	 <1173816769.22180.14.camel@localhost>  <45F70A71.9090205@goop.org>
	 <1173821224.1416.24.camel@dwalker1>  <45F71EA5.2090203@goop.org>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 19:00:05 -0700
Message-Id: <1173837606.23595.32.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 14:59 -0700, Jeremy Fitzhardinge wrote:
> Daniel Walker wrote:
> > The frequency tracking you mention is done to some extent inside the
> > timekeeping adjustment functions, but I'm not sure it's totally accurate
> > for non-timekeeping, and it also tracks things like interrupt latency.
> > Tracking frequency changes where it's important to get it right
> > shouldn't be done I think ..
> >
> > If you want accurate time accounting, don't use the TSC .
> >   
> 
> I'm not sure I follow you here.  Clocksources have the means to adjust
> the rate of time progression, mostly to warp the time for things like
> ntp.  The stability or otherwise of the tsc is irrelevant.

The adjustments that I spoke of above are working regardless of ntp ..
The stability of the TSC directly effects the clock mult adjustments in
timekeeping, as does interrupt latency since the clock is essentially
validated against the timer interrupt.

> If you had a clocksource which was explicitly using the rate at which a
> CPU does work as a timebase, then using the same warping mechanism would
> allow you to model CPU speed changes.

like I said there are other factors so that's not going to exactly model
cpu speed changes. You could come up with another method, but that would
likely require another known constant clock.

> > The sched_clock interface is basically a stripped down clocksource..
> > I've implemented sched_clock as a clocksource in the past ..
> >   
> 
> Yes, that works.  But a clocksource is strictly about measuring the
> progression of real time, and so doesn't generally measure how much work
> a CPU has done.

sched_clock doesn't measure amounts of cpu work either, it's all about
timing. 

> >> We currently have a sched_clock interface in paravirt_ops to deal with
> >> the hypervisor aspect.  It only occurred to me this morning that cpufreq
> >> presents exactly the same problem to the rest of the kernel, and so
> >> there's room for a more general solution.
> >>     
> >
> > Are there other architecture which have this per-cpu clock frequency
> > changing issue? I worked with several other architectures beyond just
> > x86 and haven't seen this issue ..
> 
> Well, lots of cpus have dynamic frequencies.  Any scheduler which
> maintains history will suffer the same problem, even on UP.  If
> processes A and B are supposed to have the same priority and they both
> execute for 1ms of real time, did they make the same amount of
> progress?  Not if the cpu changed speed in between.

That's true, but given a constant clock (like what sched_clock should
have) then the accounting is similarly inaccurate. Any connection
between the scheduler and the TSC frequency changes aren't part of the
design AFAIK ..

> And any system which commonly runs virtualized (s390, power, etc) will
> need to deal with the notion of stolen time.

I haven't followed the "stolen time" discussion, but just a brief look
at your first email I'd say don't mess with the clocks .. The clocks
should always reflect the time accurately .. That's the point of the
clocks, and when the TSC, or any other clock, changes frequency it
sucks..

I haven't thought it through completely, but you might be able to solve
the issue by adding a value to each jiffie in the scheduler or altering
the scheduler to extend the number of jiffies a task gets pending on the
virtual speed of the cpu..

Daniel

