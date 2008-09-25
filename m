Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbYIYQmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbYIYQmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 12:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbYIYQm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 12:42:28 -0400
Received: from bc.sympatico.ca ([209.226.175.184]:50568 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755202AbYIYQm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 12:42:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAFda20hMQWq+/2dsb2JhbACBXrktgWU
Date: Thu, 25 Sep 2008 12:37:23 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Bligh <mbligh@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
Message-ID: <20080925163722.GA29392@Krystal>
References: <20080924051056.650388887@goodmis.org> <20080924051400.195780424@goodmis.org> <1222268595.16700.149.camel@lappy.programming.kicks-ass.net> <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com> <1222272686.16700.162.camel@lappy.programming.kicks-ass.net> <33307c790809240949i3026170i8f9ac1d67a0fcf00@mail.gmail.com> <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org> <33307c790809241054n47addd27hef90930f109599fd@mail.gmail.com> <alpine.LFD.1.10.0809241323590.3265@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809241323590.3265@nehalem.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:20:46 up 112 days, 20:01, 10 users,  load average: 0.81, 0.85,
	0.83
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Wed, 24 Sep 2008, Martin Bligh wrote:
> > 
> > If we just record the TSC unshifted, in 27 bits, at 4GHz, that gives us
> > about 1/30 of a second? So we either shift, use > 27 bits, or record
> > at least 30 events a second, none of which I like much ...
> 
> No, we don't shift (we don't want to lose precision), and we don't use 
> more than 27 bits by default.
> 
> the TSC at each entry should be a _delta_. It's the difference from the 
> last one. And if you get less than 30 events per second, and you need a 
> bigger difference, you insert an extra "sync" tracepoint that has a 59-bit 
> thing (27 bits _plus_ the extra 'data').
> 
> Yes, it adds 8 bytes (assuming that minimal format), but it does so only 
> for any trace event that is more than 1/30th of a second from its previous 
> one. IOW, think of this not in bytes, but in bytes-per-second. It adds at 
> most 8*30=240 bytes per second, but what it _saves_ is that when you have 
> tens of thousands of events, it shaves 4 bytes FOR EACH EVENT.
> 
> See?
> 
> Also, quite often, the clock won't be running at 4GHz even if the CPU 
> might. Intel already doesn't make the TSC be the nominal frequency, and 
> other architectures with TSC's have long had the TSC be something like a 
> "divide-by-16" clock rather than every single cycle because it's more 
> power-efficient.
> 
> So there is often a built-in shift, and I doubt we'll see 10GHz TSC's even 
> if we see 10GHz CPU's (which many people consider unlikely anyway, but 
> I'm not going to bet against technology).
> 
> 			Linus
> 

I remembered other concerns about 27 vs 32 bits TSC decision, which are
rather important. First, if we have a 27 bits TSC, with overflow every
33ms at 4GHz, we assume the kernel will _never_ have an interrupt
latency longer than this for correct heartbeat behavior. The sad thing
is that it is not uncommon to see such interrupt latencies once in a
while. It's especially bad if the correctness of the timestamps gathered
by the one tool that would be helpful to debug such interrupt latency
problem is broken by the thing it try to instrument.

Given that heartbeat events have this particular downside, we may think
writing an extended TSC value in the event header will solve the
problem, but it actually creates a new kind of problem when we try to
relax buffer locking. The basic idea is that it's easy to compute the
delta from the previous timestamp taken on the same CPU when disabling
interrupts because we are serializing all operations for this specific
core. However, a more lightweight locking (without interrupt disabling)
involves using a loop such as:

reserve space (preempt is disabled) :
unsigned long old, new;

do {
  old = read_offset();
  timestamp = get_cycles();
  new = old + header_size() + event_size();
} while ((local_cmpxchg(&buf->offset, old, new) != old);
write event header
write event payload
commit

So we can make sure the timestamps will never go backward in a given
buffer (this is insured by the fact that this cmpxchg ties together
timestamp read and buffer space reservation).

If we want to implement detection of TSC rollover at the tracing site,
we would have to remember the last TSC value read, and this is where it
becomes racy. We cannot read the previous event slot, because we have no
guarantee it's been written to (only reserve operation is ordered. write
and commit are unordered). We would therefore have to keep a copy of the
previous TSC value, but given we don't do any locking, it would only be
safe to only keep data that can be read/writte to atomically, namely
only 32 bits on x86_32. Also note that the cmpxchg loop may fail, so we
cannot update the "last_tsc_msb" data structure inside the loop. It
could cause a nested IRQ to think the previous event written had a
higher timestamp than what is actually in the trace.

So we could do :

per buffer, per cpu : u32 last_tsc_msb;

reserve space (preempt is disabled) :
unsigned long old, new;
u64 timestamp;
int full_tsc = 0;

do {
  old = read_offset();
  timestamp = get_cycles();
  new = old + event_size();
  if ((u32)(timestamp >> (64 - 27)) - buf->last_tsc_msb) {
    full_tsc = 1;
    new += header_size_full_tsc();
  } else
    new += header_size();
} while ((local_cmpxchg(&buf->offset, old, new) != old);

buf->last_tsc_msb = (u32)(timestamp >> (64 - 27));

if (full_tsc)
  write full tsc event header
else
  write event header
write event payload
commit()

The incorrect race would be not to write a full tsc when needed (an
overflow would go undetected). A correct race would be to write a full
TSC even if unneeded. This would just consume a little more space, but
given the unlikeliness of the race, we don't care.

The worse case scenario is to have an interrupt coming right between a
successful cmpxchg reserving the space to write a full tsc and the
last_tsc_msb write. This interrupt would think it has to write a full
tsc when it in fact the previous slot already does contain the full tsc.
Duplicated full TSCs, that's the "correct race".

Then, the IRQ will update the last_tsc_msb value before the actual
thread that has been interrupted. This will cause the last_tsc_msb value
to go slightly backward when updated by the thread. But it's not a
problem, because letting the last_tsc_msb decrement slightly could only
result in the "correct race", which is to cause following events to
write a full TSC event if not strictly needed.

So I think we could manage to completely remove the heartbeat, which
would make life much easier in dynticks system and would make the time
source much more robust wrt long interrupt latencies.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
