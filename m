Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbYIWCrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbYIWCrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 22:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754344AbYIWCrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 22:47:08 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:53735 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754270AbYIWCrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 22:47:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEEAFTt10hMQWq+/2dsb2JhbACBXbUcgWY
Date: Mon, 22 Sep 2008 22:30:16 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, darren@dvhart.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: Unified tracing buffer
Message-ID: <20080923023016.GD24937@Krystal>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <48D7F5E8.3000705@redhat.com> <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com> <48D81B5F.2030702@redhat.com> <33307c790809221616h5e7410f5gc37c262d83722111@mail.gmail.com> <48D832B6.3010409@redhat.com> <alpine.LFD.1.10.0809221718100.3265@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809221718100.3265@nehalem.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:08:17 up 110 days,  6:48,  7 users,  load average: 0.36, 0.25,
	0.26
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Mon, 22 Sep 2008, Masami Hiramatsu wrote:
> > 
> > Sure, atomic counter might be more expensive but accurate for ordering.
> 
> Don't be silly.
> 
> An atomic counter is no more accurate for ordering than anything else.
> 
> Why?
> 
> Because all it tells you is the ordering of the atomic increment, not of 
> the caller. The atomic increment is not related to all the other ops that 
> the code that you trace actually does in any shape or form, and so the 
> ordering of the trace doesn't actually imply anything for the ordering of 
> the operations you are tracing!
> 
> Except for a single CPU, of course, but for that case you don't need a 
> sequence number either, since the ordering is entirely determined by the 
> ring buffer itself.
> 
> So the counter will be more expensive (cross-cpu cache bouncing for EVERY 
> SINGLE EVENT), less useful (no real meaning for people who DO want to have 
> a timestamp), and it's really no more "ordered" than anything that bases 
> itself on a TSC.
> 
> The fact is, you cannot order operations based on log messages unless you 
> have a lock around the whole caller - absolutely _no_ amount of locking or 
> atomic accesses in the log itself will guarantee ordering of the upper 
> layers.
> 
> And sure, if you have locking at a higher layer, then a sequence number is 
> sufficient, but on the other hand, so is a well-synchronized TSC.
> 
> So personally, I think that the optimal solution is:
> 
>  - let each ring buffer be associated with a "gettimestamp()" function, so 
>    that everybody _can_ set it to something of their own. But default to 
>    something sane, namely a raw TSC thing.
> 
>  - Add synchronization events to the ring buffer often enough that you can 
>    make do with a _raw_ (ie unscaled) 32-bit timestamp. Possibly by simply 
>    noticing when the upper 32 bits change, although you could possibly do 
>    it with a heartbeat too.
> 


Hi Linus,

I totally agree with all of the above,


>  - Similarly, add a synchronization event when the TSC frequency changes.
> 
>  - Make the synchronization packet contain the full 64-bit TSC base, in 
>    addition to TSC frequency info _and_ the timebase.
> 

If possible, I would recommend to stay as far away as possible from
using frequency change events to support broken frequency scaling.
First, some architectures, like AMD, does not trigger an event for every
frequency changes on the CPU (if my memory is right, I think the
southbridge temperature throttling does not generate any event) and we
also have to consider the delay between the frequency change and and
moment the instrumentation would be called. Each frequency change event
would therefore increase the over TSC imprecision and I doubt we really
want to rely on this for our time base. I welcome people to prove me
wrong or paranoid by providing results proving the correct synchronicity
of such approach over time. :-) I however explain how LTTng deals with
such architectures I consider to fall into the "broken" category below.


>  - From those synchronization events, you should be able to get a very 
>    accurate timestamp *after* the fact from the raw TSC numbers (ie do all 
>    the scaling not when you gather the info, but when you present it), 
>    even if you only spent 32 bits of TSC info on 99% of all events (an 
>    just had a overflow log occasionally to get the rest of the info)
> 
>  - Most people will be _way_ happier with a timestamp that has enough 
>    precision to also show ordering (assuming that the caller holds a 
>    lock over the operation _including_ the tracing) than they would ever 
>    be with a sequence number.
> 

One gettimestamp() we could think of, to satisfy both people expecting
tracing to perform a memory barrier and for people expecting a
timestamp, would be to write timestamps taken from synchronized TSCs
into a variable with a cmpxchg, which would succeed only if the TSC
value is higher than the value present in this variable. That would
give both the memory barrier behavior and the timestamping. Given the
cache-line bouncing implied, I would only recommend to activate this
when really needed, e.g. when debugging race issues.

I currently use this scheme in LTTng to deal with broken x86
architecture with non-synchronized TSCs. Basically, all CPUs laging behind
others take the TSC value read from memory and adds 200 cycles (or how
many cycles it takes to actually read tsc) from the last cycle counter
value written to memory by the previous time base read. I also plan to
execute an heartbeat on every CPUs someday to give an upper bound to the
imprecision of such TSCs so it could be use for some sort of performance
measurement.

>  - people who really want to can consider the incrementing counter a TSC, 
>    but it will suck in so many ways that I bet it will not be very popular 
>    at all. But having the option to set a special timestamp function will
>    give people the option (on a per-buffer level) to make the "TSC" be a 
>    simple incrementing 32-bit counter using xaddl and the upper bits 
>    incrementing from a timer, but keep that as a "ok, the TSC is really 
>    broken, or this architecture doesn't support any fast cycle counters at 
>    all, or I really don't care about time, just sequence, and I guarantee 
>    I have a single lock in all callers that makes things unambiguous"
> 

I currently use the scheme you propose here on architectures
lacking TSC. I hook in the timer interrupt to increment the MSBs.
I doubt anyone will ever go the way of locking every caller, but yeah,
why not.

Also note that getting only 32-bits TSCs on MIPS makes things a bit less
simple, but I did an RCU-style adaptation layer which generates a full
64-bits TSC from a 32-bits time base. It's currently in the -lttng tree.

> Note the "single lock" part. It's not enough that you make any trace thing 
> under a lock. They must be under the _same_ lock for all relevant events 
> for you to be able to say anything about ordering. And that's actually 
> pretty rare for any complex behavior.
> 
> The timestamping, btw, is likely the most important part of the whole 
> logging thing. So we need to get it right. But by "right" I mean really 
> really low-latency so that it's acceptable to everybody, real-time enough 
> that you can tell how far apart events were, and precise enough that you 
> really _can_ see ordering.
> 
> The "raw TSC value with correction information" should be able to give you 
> all of that. At least on x86. On some platforms, the TSC may not give you 
> enough resolution to get reasonable guesses on event ordering.
> 

Mathieu


> 			Linus
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
