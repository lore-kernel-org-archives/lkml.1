Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbYLNOvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbYLNOvD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 09:51:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbYLNOux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 09:50:53 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39824 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbYLNOuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 09:50:52 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: Performance counter API review was [patch] Performance Counters for Linux, v3
From: Andi Kleen <andi@firstfloor.org>
References: <20081211155230.GA4230@elte.hu>
Date: Sun, 14 Dec 2008 15:51:20 +0100
In-Reply-To: <20081211155230.GA4230@elte.hu> (Ingo Molnar's message of "Thu, 11 Dec 2008 16:52:30 +0100")
Message-ID: <87r64ag68n.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

Here are some comments from my (mostly x86) perspective on the interface.
I'm focusing on the interface only, not the code.

- There was a lot of discussion about counter assignment. But an event
actually needs much more meta data than just the counter assignments.
For example here's an event-set out of the upcoming Core i7 oprofile
events file:

event:0xC3 counters:0,1,2,3 um:machine_clears minimum:6000 name:machine_clears : Counts the cycles machine clear is asserted. 

and the associated sub unit masks:

name:machine_clears type:bitmask default:0x01
        0x01 cycles Counts the cycles machine clear is asserted
        0x02 mem_order Counts the number of machine clears due to memory order conflicts
        0x04 smc Counts the number of times that a program writes to a code section
        0x10 fusion_assist Counts the number of macro-fusion assists 


As you can see there is a lot of meta data in there and to my knowledge
none of it is really optional. For example without the name and the description
it's pretty much impossible to use the event (in fact even with description
it is often hard enough to figure out what it means). I think every
non trivial perfctr user front end will need a way to query name and 
description. Where should they be stored? 

Then the minimum overflow period is needed (see below)

Counter assignment is needed as discussed earlier: there are some events
that can only go to specific counters, and then there are complication
like fixed event counters and uncore events in separate registers.

Then there is the concept of unit_masks, which define the sub-events.
Right now the single event number does not specify how unit masks
are specified. Unit masks also are complicated because they are 
sometimes masks (you can or them up) or enumerations (you can't)
To make good use of them the software needs to know the difference.

So these all need to be somewhere. I assume the right place is 
not the kernel. I don't think it would be a good idea to duplicate
all of this in every application. So some user space library is needed anyways.

- All the event meta data should be ideally stored in a single place,
otherwise there is risk of it getting out of sync. Events are relatively
often updated (even during a CPU life-cycle when a event is found
to be buggy), so a smooth upgrade procedure is crucial.

- There doesn't seem to be a way to enforce minimum overflow periods.
It's also pretty easy to hang a system by programming a too short
overflow period to a commonly encountered event. For example
if you program a counter to trigger an NMI every hundred cycles
then the system will not do much useful work anymore.

This might even be a security hazard because the interface is available
to non-root. Solving that one would actually argue to put at least
some knowledge into the kernel or always enforce a minimum safe period?

The minimum safe period has the problem that it might break some
useful tracing setups on low frequency event where it might
be quite useful to useful on each event. But on a common event
that's a really bad idea. So probably it needs per event information.

Hard problem. oprofile avoids it by only allowing root to configure events.

[btw i'm not sure perfmon3 has solved that one either]

- Split of event into event and unit mask
On x86 events consist of a event number and a unit mask (which
can be sometimes an enumeration, not a mask). It's unclear 
right now how the unit mask is specified in the perfctr structure.
While it could be both encoded in type that would be clumsy,
requiring special macros. So likely it needs a separate field.

- PEBS/Debug Store

Intel/x86 has support for letting the CPU directly log events into a memory 
ring buffer with some additional information like register contents.  From
the first look this could be supported with additional record types. One
issue there is that the record layout is not architectural and varies
with different CPUs. Getting a nice general API out of that might be tricky.
Would each new CPU need a new record type? 

Processing PEBS records is also moderately performance critical
(and they can be quite big) so it would be a good idea to have some way
to process them copy less.

Another issue is that you need to specify the buffer size/overflow threshold 
somewhere. Right now there is no way in the API to do that (and the
existing syscall has already quite a lot of arguments). So PEBS would
likely need a new syscall?

- Additional bits. x86 has some more flag bits in the perfctr
registers like edge triggering or counter inversion. Right now there
doesn't seem to be any way to specify those in the syscall. There are
some events (especially when multiple events are counted together)
which can be only counted by setting those bits. Likely needs to be
controlled by the application.

I suppose adding new fields to perf_counter_hw_event would be possible.

- It's unclear to me why the API has a special NMI mode. For me it looks
like that if NMIs are implemented they should be the default way.
Or rather if you have NMI events, why ever not use them?
The only exception I can think of would be if the system is known
to have NMI problems in the BIOS like some ThinkPads. In that case
it shouldn't be per syscall/user controlled though, but some global
root only knob (ideally set automatically)

- Global tracing. Right now there seem to be two modi: per task and
per CPU. But a common variant is global tracing of all CPUs. While this
could be in theory done right now by attaching to each CPU
this has the problem that it doesn't interact very well with CPU
hot plug. The application would need to poll for additional/lost
CPUs somehow and then re-attach to them (or detach). This would
likely be quite clumsy and slow. It would be better if the kernel supported 
that better.

Or alternative here is to do nothing and keep oprofile for that job
(which it doesn't do that badly)

- Ring 3 vs ring 0.
x86 supports counting only user space or only kernel space. Right 
now there is no way to specify that in the syscall interface.
I suppose adding a new field to perf_counter_hw_event would be possible.

- SMT support
Sometimes you want to count events occurred by both SMT siblings.
For example this is useful when measuring a multi threaded
application that uses both threads and you want to see the
shared cache events of both.
In arch perfmon v3 there is a new perfctr "AnyThread" bit 
that controls this.  It needs to be exposed.

- In general the SMT and shared resource semantics seem to be a
bit unclear recently. Some clarification of that would be good.
What happens when the resource is not available? How are
the reservation semantics?

- Uncore monitoring
Nehalem has some additional performance counters in the Uncore
which count specific uncore events.  They have slightly different
semantics and additional register (like an opcode filter).
It's unclear how they would be programmed in this API.

Also the shared resource problem applies. An uncore is shared
by multiple cores/threads on a socket. Neither a CPU number nor
a pid are particularly useful to address them.

- RDPMC self monitoring
x86 supports reading performance counters from user space
using the RDPMC application. I find that rather useful
as a replacement for RDTSC because it allows to count
real cycles using one of the fixed performance counter.

One problem is that it needs to be explicitely enabled and also
controlled because it always exposes information from
all performance counters (which could be an information
leak). So ideally it needs to cooperate with the kernel 
and allow to set up suitable counters for own use and also
to make sure that counters do not leak information on context
switch. There should be some way in the API to specify that.

-Andi

-- 
ak@linux.intel.com
