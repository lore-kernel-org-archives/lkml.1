Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357AbYIWAl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbYIWAl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 20:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbYIWAls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 20:41:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751634AbYIWAlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 20:41:47 -0400
Date: Mon, 22 Sep 2008 17:39:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
cc: Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, darren@dvhart.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: Unified tracing buffer
In-Reply-To: <48D832B6.3010409@redhat.com>
Message-ID: <alpine.LFD.1.10.0809221718100.3265@nehalem.linux-foundation.org>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>  <48D7F5E8.3000705@redhat.com>  <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com>  <48D81B5F.2030702@redhat.com> <33307c790809221616h5e7410f5gc37c262d83722111@mail.gmail.com>
 <48D832B6.3010409@redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 22 Sep 2008, Masami Hiramatsu wrote:
> 
> Sure, atomic counter might be more expensive but accurate for ordering.

Don't be silly.

An atomic counter is no more accurate for ordering than anything else.

Why?

Because all it tells you is the ordering of the atomic increment, not of 
the caller. The atomic increment is not related to all the other ops that 
the code that you trace actually does in any shape or form, and so the 
ordering of the trace doesn't actually imply anything for the ordering of 
the operations you are tracing!

Except for a single CPU, of course, but for that case you don't need a 
sequence number either, since the ordering is entirely determined by the 
ring buffer itself.

So the counter will be more expensive (cross-cpu cache bouncing for EVERY 
SINGLE EVENT), less useful (no real meaning for people who DO want to have 
a timestamp), and it's really no more "ordered" than anything that bases 
itself on a TSC.

The fact is, you cannot order operations based on log messages unless you 
have a lock around the whole caller - absolutely _no_ amount of locking or 
atomic accesses in the log itself will guarantee ordering of the upper 
layers.

And sure, if you have locking at a higher layer, then a sequence number is 
sufficient, but on the other hand, so is a well-synchronized TSC.

So personally, I think that the optimal solution is:

 - let each ring buffer be associated with a "gettimestamp()" function, so 
   that everybody _can_ set it to something of their own. But default to 
   something sane, namely a raw TSC thing.

 - Add synchronization events to the ring buffer often enough that you can 
   make do with a _raw_ (ie unscaled) 32-bit timestamp. Possibly by simply 
   noticing when the upper 32 bits change, although you could possibly do 
   it with a heartbeat too.

 - Similarly, add a synchronization event when the TSC frequency changes.

 - Make the synchronization packet contain the full 64-bit TSC base, in 
   addition to TSC frequency info _and_ the timebase.

 - From those synchronization events, you should be able to get a very 
   accurate timestamp *after* the fact from the raw TSC numbers (ie do all 
   the scaling not when you gather the info, but when you present it), 
   even if you only spent 32 bits of TSC info on 99% of all events (an 
   just had a overflow log occasionally to get the rest of the info)

 - Most people will be _way_ happier with a timestamp that has enough 
   precision to also show ordering (assuming that the caller holds a 
   lock over the operation _including_ the tracing) than they would ever 
   be with a sequence number.

 - people who really want to can consider the incrementing counter a TSC, 
   but it will suck in so many ways that I bet it will not be very popular 
   at all. But having the option to set a special timestamp function will
   give people the option (on a per-buffer level) to make the "TSC" be a 
   simple incrementing 32-bit counter using xaddl and the upper bits 
   incrementing from a timer, but keep that as a "ok, the TSC is really 
   broken, or this architecture doesn't support any fast cycle counters at 
   all, or I really don't care about time, just sequence, and I guarantee 
   I have a single lock in all callers that makes things unambiguous"

Note the "single lock" part. It's not enough that you make any trace thing 
under a lock. They must be under the _same_ lock for all relevant events 
for you to be able to say anything about ordering. And that's actually 
pretty rare for any complex behavior.

The timestamping, btw, is likely the most important part of the whole 
logging thing. So we need to get it right. But by "right" I mean really 
really low-latency so that it's acceptable to everybody, real-time enough 
that you can tell how far apart events were, and precise enough that you 
really _can_ see ordering.

The "raw TSC value with correction information" should be able to give you 
all of that. At least on x86. On some platforms, the TSC may not give you 
enough resolution to get reasonable guesses on event ordering.

			Linus
