Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbYK1OWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbYK1OWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 09:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbYK1OWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 09:22:10 -0500
Received: from tomts43.bellnexxia.net ([209.226.175.110]:61676 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752381AbYK1OWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 09:22:09 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAOWJL0lMROB9/2dsb2JhbACBbc8/gn0
Date: Fri, 28 Nov 2008 09:17:04 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch 17/17] x86 trace clock
Message-ID: <20081128141704.GE10401@Krystal>
References: <20081126124246.800751190@polymtl.ca> <20081126124637.043515637@polymtl.ca> <878wr64cmj.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <878wr64cmj.fsf@basil.nowhere.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:31:59 up 11 days, 14:12,  2 users,  load average: 0.10, 0.53,
	0.55
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
> 
> > X86 trace clock. Depends on tsc_sync to detect if timestamp counters are
> > synchronized on the machine.
> 
> For that tsc_sync needs to be fixed first? e.g. see thread about
> it firing incorrectly on vmware some time ago.
> 

I assume you are talking about this thread:
http://lkml.org/lkml/2008/10/20/467

Thanks for pointing it out to me.

Yes, the x86 trace clock depends on the tsc_sync detection code. Note
that the patchset I propose here includes a new tsc_sync detection code
which behaves differently from the current x86 tsc_sync code. We can
specify an acceptable cycle delta between the CPUs and also, given I
retry 10 times for each CPU and take the _best_ result of the test, it
should make sure it does not suffer from NMI, MCE, SMI nor hypervisor
delays.


> > A "Big Fat" (TM) warning is shown on the console when the trace clock is used on
> > systems without synchronized TSCs to tell the user to
> >
> 
> How about Intel systems where the TSC only stops in C3 and deeper?
> You don't seem to handle that case well.
> 

The thing is : if the users specify the idle=poll kernel command line
option, the cycle counters will stay synchronized even if it would stop
in C3 and deeper halt states. This code assumes that the idle thread has
already executed on at least one of the CPUs before the synchronization
code is called. Maybe it would be safer to explicitly call the idle loop
on one CPU to insure we would detect delta caused by it ?

But hrm, if we have a virtualized environment, with one guest using
idle=poll and then a second guest using the halt states starting later,
I wonder what the result would be ?

Also, all this stuff about vmware giving TSCs "synchronized enough" for
timekeeping does not work work tracing. NTP precision, if I recall well,
was too loose for tracing needs.

> On modern Intel systems that's a common case.
> > +			new_tsc = last_tsc + TRACE_CLOCK_MIN_PROBE_DURATION;
> > +		/*
> > +		 * If cmpxchg fails with a value higher than the new_tsc, don't
> > +		 * retry : the value has been incremented and the events
> > +		 * happened almost at the same time.
> > +		 * We must retry if cmpxchg fails with a lower value :
> > +		 * it means that we are the CPU with highest frequency and
> > +		 * therefore MUST update the value.
> 
> Sorry but any global TSC measurements without scaling when the TSCs
> run on different frequencies just don't make sense. The results will
> be always poor. You really have to scale appropimately then and also
> handle the "instable period"

This scheme only offers the following guarantees :

- the max time imprecision is 1 jiffy.
- the cycles counter values read will increase monotonically across the
  system.

And also, yes, if all CPUs happen to go slower than their original
speed, the cpu_khz value used will be wrong and time will appear to go
slower than it does.

Given that, we could do "better" by also keep per cpu offset/frequency
and scale each frequency read using these reference values, so the TSCs
are almost in sync, but this would not deal correctly with the C3 and
lower halt states anyway.. so ther might be limited interest in this.

And yes, we would eventually have to record the frequency change events
in a specific tracing buffer, which would let us reconstruct the CPU
speed along the execution, but I think starting with such less precise
but still accurate (in term of event order) tracing data would be a
simpler start. We can always add this frequency change monitoring layer
in a second phase.

So, given that, what would you think would be "good enough" for a first
shot as a tracing clock, given we keep room for later improvement ?

Considering your comments here, we may want to add some knowledge about
the current CPU frequency in the trace clock tsc read primitive so we go
at a rate which follows the real speed more closely, even though this
would not take care of the C3 and - halt states. And also given that, we
might want to resynchronize the TSC values based on HPET reads
periodically (e.g. every time we go out of idle, but at most once per
jiffy) to deal with halt states. We could wrap that into the current
cmpxchg-based method I proposed here to deal with the "instable period".

Hm ?

Mathieu

> 
> -Andi
> 
> -- 
> ak@linux.intel.com

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
