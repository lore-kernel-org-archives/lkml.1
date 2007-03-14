Return-Path: <linux-kernel-owner+w=401wt.eu-S932372AbXCNVcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372AbXCNVcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 17:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932433AbXCNVcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 17:32:18 -0400
Received: from mail10.syd.optusnet.com.au ([211.29.132.191]:46669 "EHLO
	mail10.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932372AbXCNVcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 17:32:17 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: Stolen and degraded time and schedulers
Date: Thu, 15 Mar 2007 08:40:48 +1100
User-Agent: KMail/1.9.5
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       James Morris <jmorris@namei.org>, john stultz <johnstul@us.ibm.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cpufreq@lists.linux.org.uk,
       Virtualization Mailing List <virtualization@lists.osdl.org>
References: <45F6D1D0.6080905@goop.org> <200703150836.08670.kernel@kolivas.org>
In-Reply-To: <200703150836.08670.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703150840.49269.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 March 2007 08:36, Con Kolivas wrote:
> On Wednesday 14 March 2007 03:31, Jeremy Fitzhardinge wrote:
> > The current Linux scheduler makes one big assumption: that 1ms of CPU
> > time is the same as any other 1ms of CPU time, and that therefore a
> > process makes the same amount of progress regardless of which particular
> > ms of time it gets.
> >
> > This assumption is wrong now, and will become more wrong as
> > virtualization gets more widely used.
> >
> > It's wrong now, because it fails to take into account of several kinds
> > of missing time:
> >
> >    1. interrupts - time spent in an ISR is accounted to the current
> >       process, even though it gets no direct benefit
> >    2. SMM - time is completely lost from the kernel
> >    3. slow CPUs - 1ms of 600MHz CPU is less useful than 1ms of 2.4GHz CPU
> >
> > The first two - time lost to interrupts - are a well known problem, and
> > are generally considered to be a non issue.  If you're losing a
> > significant amount of time to interrupts, you probably have bigger
> > problems.  (Or maybe not?)
> >
> > The third is not something I've seen discussed before, but it seems like
> > it could be a significant problem today.  Certainly, I've noticed it
> > myself: an interactive program decides to do something CPU-intensive
> > (like start an animation), and it chugs until the conservative governor
> > brings the CPU up to speed.  Certainly some of this is because its just
> > plain CPU-starved, but I think another factor is that it gets penalized
> > for running on a slow CPU: 1ms is not 1ms.  And for power reasons you
> > want to encourage processes to run on slow CPUs rather than penalize
> > them.
> >
> > Virtualization just exacerbates this.  If you have a busy machine
> > running multiple virtual CPUs, then each VCPU may only get a small
> > proportion of the total amount of available CPU time.  If the kernel's
> > scheduler asserts that "you were just scheduled for 1ms, therefore you
> > made 1ms of progress", then many timeslices will effectively end up
> > being 1ms of 0Mhz CPU - because the VCPU wasn't scheduled and the real
> > CPU was doing something else.
> >
> >
> > So how to deal with this?  Basically we need a clock which measures "CPU
> > work units", and have the scheduler use this clock.
> >
> > A "CPU work unit" clock has these properties:
> >
> >     * inherently per-CPU (from the kernel's perspective, so it would be
> >       per-VCPU in a virtual machine)
> >     * monotonic - you can't do negative work
> >     * measured in "work units"
> >
> > A "work unit" is probably most simply expressed in cycles - you assume a
> > cycle of CPU time is equivalent in terms of work done to any other
> > cycle.  This means that 1 cycle at 600MHz is equivalent to 1 cycle at
> > 2.4GHz - but of course the 2.4GHz processor gets 4 times as many in any
> > real time interval.  (This is the instance where the worst kind of tsc -
> > varying speed which stops on idle - is actually exactly what you want.)
> >
> > You could also measure "work units" in terms of normalized time units:
> > if the fastest CPU on the machine is 2.4GHz, then 1ms is 1ms a work unit
> > on that CPU, but 250us on the 600MHz CPU.
> >
> > It doesn't really matter what the unit is, so long as it is used
> > consistently to measure how much progress all processes made.
>
> I think you're looking for a complex solution to a problem that doesn't
> exist. The job of the process scheduler is to meter out the available cpu
> resources. It cannot make up cycles for a slow cpu or one that is
> throttled. If the problem is happening due to throttling it should be fixed
> by altering the throttle. The example you describe with the conservative
> governor is as easy to fix as changing to the ondemand governor.
> Differential power cpus on an SMP machine should be managed by SMP
> balancing choices based on power groups.
>
> It would be fine to implement some other accounting of this definition of
> time for other purposes

I mean such as for virtualisation purposes.

> but not for process scheduler decisions per se. 

>
> Sorry to chime in late.  My physical condition prevents me spending any
> extended period of time at the computer so I've tried to be succinct with
> my comments and may not be able to reply again.

-- 
-ck
