Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686AbYJRRBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbYJRRBt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 13:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbYJRRBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 13:01:38 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:45596 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751157AbYJRRBh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 13:01:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsQEAIut+UhMQWq+/2dsb2JhbACBcr8Vg2w
Date: Sat, 18 Oct 2008 13:01:19 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "ltt-dev@lists.casi.polymtl.ca" <ltt-dev@lists.casi.polymtl.ca>
Subject: Re: [RFC patch 15/15] LTTng timestamp x86
Message-ID: <20081018170118.GA22243@Krystal>
References: <20081016234657.837704867@polymtl.ca> <alpine.LFD.2.00.0810161701470.3288@nehalem.linux-foundation.org> <20081017012835.GA30195@Krystal> <57C9024A16AD2D4C97DC78E552063EA3532D455F@orsmsx505.amr.corp.intel.com> <20081017172515.GA9639@goodmis.org> <57C9024A16AD2D4C97DC78E552063EA3533458AC@orsmsx505.amr.corp.intel.com> <20081017184215.GB9874@Krystal> <57C9024A16AD2D4C97DC78E552063EA35334594F@orsmsx505.amr.corp.intel.com> <20081017202313.GA13597@Krystal> <57C9024A16AD2D4C97DC78E552063EA353345B9B@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA353345B9B@orsmsx505.amr.corp.intel.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:44:10 up 135 days, 20:24,  5 users,  load average: 0.26, 0.43,
	0.45
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Luck, Tony (tony.luck@intel.com) wrote:
> Complexity of dealing with all the random issues that have
> plagued TSC in different cpus over the years definitely
> seems to be a problem.
> 

Yes :(

> I have one more idea on how we might be able to use
> TSC locally and still have confidence that we can
> merge local cpu buffers into a consistent stream.
> 
> What if we read the HPET occasionally (once per
> second?) and add a record to our per-cpu buffer
> with the value of the HPET.  That would give us
> a periodic cross-check of each cpus TSC against
> real time so that a "smart" post-processor can
> sanity check the log entries at regular intervals.
> 

Hrm, that would make the timestamps much more sensitive to tracing
hiccups :

- if interrupts are disabled for a long time on the system (kernel bug
  or at early boot), we cannot assume those HPET events will be logged
  at the expected interval.
- if we are in buffer full condition (buffers are too small to handle
  the load and we drop events on buffer full condition), we will not
  only have missing events : given we depend on those HPET events to
  have a consistent time-base, all the trace time-base must be
  considered untrustable.
- we would also have to get this HPET timer value at each subbuffer
  boundary (at each page in Steven's implementation). This is required
  so we can make sense of the time-base of buffers when we only gather
  the last subbuffers written, given the previous ones have been
  overwritten in flight-recorder mode. However, with a relatively large
  load and small subbuffers (e.g. 4kB), we would have to get this HPET
  value 2048 times/second/cpu. On a 512 nodes machine, it may become a
  problem. See my analysis of poor HPET scalability below.
  
> It doesn't deal with the truly insane TSC behaivours
> (like stopping completely in certain C states, or
> varying frequency) ... but it would at least be able
> to reliably detect these forms of insanity.
> 

I also like the one done by AMD when the cycle counter goes backward
one a single CPU. :) Hrm, I thought those you say are truly insane
behaviors are exactly the ones we are trying to deal with ?

And what do we say when we detect this ? "sorry, please upgrade your
hardware to get a reliable trace" ? ;)

> We need periodic entries added to the buffer anyway
> to make sure we can detect rollover since we don't
> want waste space in log records with a full width
> TSC value.
> 

Nope, this is not required. I removed the heartbeat event from LTTng two
weeks ago, implementing detection of the delta from the last timestamp
written into the trace. If we detect that the new timestamp is too far
from the previous one, we write the full 64 bits TSC in an extended
event header. Therefore, we have no dependency on interrupt latency to
get a sane time-base.


> -Tony
> 

Here are some numbers showing the scalability of synchronized TSC vs
cache-line bouncing vs HPET read under tracing load. I use LTTng to take
a trace only in circular per-cpu memory buffers while tbench is running.
I look at the resulting tbench speed. This kind of load generates a lot
of tracing data especially because tbench does a lot of small
read/writes which generates a lot of system call events. Side-note:
LTTng is currently fully dynamic and parses the format string like
printk, and this is accountable for a large part of the performance
degradation. LTTng however supports to override this probe with
"specialized" probes which know exactly which types to record. I just
did not create any yet. So let's focus on timestamping :


model name	: Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz
stepping	: 6
cpu MHz		: 2000.073

tbench, x86_64 dual quad-core, 2.0GHz, 16GB ram      Speed          Slowdown

(8 cores up)
  No tracing :                                      1910.50 MB/sec
  Flight recorder tracing (per-cpu memory buffers)
    synchronized TSC, get_cycles with cpuid :        940.20 MB/sec (50%)
    unsync TSC, get_cycles + cmpxchg :               716.96 MB/sec (62%)
    unsync TSC, HPET read :                          586.53 MB/sec (69%)

(2 cores up)
  No tracing :                                       488.15 MB/sec
  Flight recorder tracing (per-cpu memory buffers)
    synchronized TSC, get_cycles with cpuid :        241.34 MB/sec (50%)
    unsync TSC, get_cycles + cmpxchg :               202.30 MB/sec (58%)
    unsync TSC, HPET read :                          187.04 MB/sec (61%)

(1 core up)
  No tracing :                                       270.67 MB/sec
  Flight recorder tracing (per-cpu memory buffers)
    synchronized TSC, get_cycles with cpuid :        126.82 MB/sec (53.1%)
    unsync TSC, get_cycles + cmpxchg :               124.54 MB/sec (53.9%)
    unsync TSC, HPET read :                           98.75 MB/sec (63.5%)

So, the conclusion it brings about scalability of those time sources
regarding tracing is :
- local TSC read scales very well when the number of CPU increases
  (constant 50% overhead)
- Comparing the added overhead of both get_cyles+cmpxchg and HPET to
  the local sync TSC :

  cores    get_cycles+cmpxchg    HPET
      1                  0.8%     10%
      2                  8  %     11%
      8                 12  %     19%

So, is it me, or HPET scales even more poorly than a cache-line bouncing
cmpxchg ? I find it a bit surprising.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
