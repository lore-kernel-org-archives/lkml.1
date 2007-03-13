Return-Path: <linux-kernel-owner+w=401wt.eu-S1030788AbXCMQbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030788AbXCMQbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 12:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030754AbXCMQbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 12:31:15 -0400
Received: from gw.goop.org ([64.81.55.164]:47558 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030789AbXCMQbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 12:31:14 -0400
Message-ID: <45F6D1D0.6080905@goop.org>
Date: Tue, 13 Mar 2007 09:31:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Con Kolivas <kernel@kolivas.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       James Morris <jmorris@namei.org>, john stultz <johnstul@us.ibm.com>,
       Chris Wright <chrisw@sous-sol.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cpufreq@lists.linux.org.uk,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Stolen and degraded time and schedulers
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The current Linux scheduler makes one big assumption: that 1ms of CPU
time is the same as any other 1ms of CPU time, and that therefore a
process makes the same amount of progress regardless of which particular
ms of time it gets.

This assumption is wrong now, and will become more wrong as
virtualization gets more widely used.

It's wrong now, because it fails to take into account of several kinds
of missing time:

   1. interrupts - time spent in an ISR is accounted to the current
      process, even though it gets no direct benefit
   2. SMM - time is completely lost from the kernel
   3. slow CPUs - 1ms of 600MHz CPU is less useful than 1ms of 2.4GHz CPU

The first two - time lost to interrupts - are a well known problem, and
are generally considered to be a non issue.  If you're losing a
significant amount of time to interrupts, you probably have bigger
problems.  (Or maybe not?)

The third is not something I've seen discussed before, but it seems like
it could be a significant problem today.  Certainly, I've noticed it
myself: an interactive program decides to do something CPU-intensive
(like start an animation), and it chugs until the conservative governor
brings the CPU up to speed.  Certainly some of this is because its just
plain CPU-starved, but I think another factor is that it gets penalized
for running on a slow CPU: 1ms is not 1ms.  And for power reasons you
want to encourage processes to run on slow CPUs rather than penalize them.

Virtualization just exacerbates this.  If you have a busy machine
running multiple virtual CPUs, then each VCPU may only get a small
proportion of the total amount of available CPU time.  If the kernel's
scheduler asserts that "you were just scheduled for 1ms, therefore you
made 1ms of progress", then many timeslices will effectively end up
being 1ms of 0Mhz CPU - because the VCPU wasn't scheduled and the real
CPU was doing something else.


So how to deal with this?  Basically we need a clock which measures "CPU
work units", and have the scheduler use this clock.

A "CPU work unit" clock has these properties:

    * inherently per-CPU (from the kernel's perspective, so it would be
      per-VCPU in a virtual machine)
    * monotonic - you can't do negative work
    * measured in "work units"

A "work unit" is probably most simply expressed in cycles - you assume a
cycle of CPU time is equivalent in terms of work done to any other
cycle.  This means that 1 cycle at 600MHz is equivalent to 1 cycle at
2.4GHz - but of course the 2.4GHz processor gets 4 times as many in any
real time interval.  (This is the instance where the worst kind of tsc -
varying speed which stops on idle - is actually exactly what you want.)

You could also measure "work units" in terms of normalized time units:
if the fastest CPU on the machine is 2.4GHz, then 1ms is 1ms a work unit
on that CPU, but 250us on the 600MHz CPU.

It doesn't really matter what the unit is, so long as it is used
consistently to measure how much progress all processes made.


So, how to implement this?

One quick hack would be to just make a new clocksource entrypoint, which
returns work units rather than real-time cycles.  That would be fairly
simple to implement, but it doesn't really take the per-cpu nature of
the clock into account (since its possible that different cpus on the
same machine might need their own methods).

Perhaps a better fit would be an entity which is equivalent to a
clocksource, but registered per-cpu like (some) clockevents.

I don't have a particular preference, but I wonder what the clock gurus
think.

    J
