Return-Path: <linux-kernel-owner+w=401wt.eu-S932481AbXGVMEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481AbXGVMEq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 08:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757261AbXGVMEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 08:04:37 -0400
Received: from smtp.nokia.com ([131.228.20.172]:24688 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352AbXGVMEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 08:04:35 -0400
Subject: Re: [linux-pm] Power Management framework proposal
From: Igor Stoppa <igor.stoppa@nokia.com>
To: "ext david@lang.hm" <david@lang.hm>
Cc: "ext linux-pm-bounces@lists.linux-foundation.org" 
	<linux-pm-bounces@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0707220057210.6350@asgard.lang.hm>
References: <Pine.LNX.4.64.0707212339550.6350@asgard.lang.hm>
	 <1185091022.19678.28.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0707220057210.6350@asgard.lang.hm>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: OSSO
Date: Sun, 22 Jul 2007 15:05:11 +0300
Message-Id: <1185105911.29238.43.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 22 Jul 2007 12:04:10.0656 (UTC) FILETIME=[69BD7200:01C7CC58]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-22 at 01:58 -0700, ext david@lang.hm wrote:
> On Sun, 22 Jul 2007, Igor Stoppa wrote:

[snip]

> > Could you elaborate on how your proposal is incompatible with enhancing
> > the clock framework?
> 
> It's not that I think it's incompatible with any existing powersaving 
> tools (in fact I hope it's not)
> 
> it's that I think that this (or something similar) could be made to cover 
> all thevarious power options instead of CPU's having one interface, ACPI 
> capable drivers having another, embeded devices presenting a third, etc
> 
> this was triggered by the mess of different function calls for different 
> purposes that are used for the suspend functions where you have a bunch of 
> different functions that are each supposed to be called at a specific time 
> from a specific mode during the suspend process. with all these different 
> functions driver writes tend to not bother implementing any of them, and 
> it seems like there is a fairly steady stream of new functions that end up 
> being needed. the initial intent was to just change this into a generic 
> set of calls that every driver writer would implement the minimum set of, 
> and make it trivially extensable to future capabilities of hardware.

Every now and then there is some attempt to find One solution to bind
them all: x86, SoC, ACPI ... you name it.

Unfortunately, while it's true that there are significant similarities,
there are also notable differencies; as far as i know the USB subsystem
is the one that gets closer to what we have in the embedded arena, since
it can have complex cases of parent-child powering and wakeup.

> one other effect of this is that driver writers would see the mode 
> interface from day one rather then just completely ignoring it. right now 
> device driver authors tend to thing " why worry about figuring out how to 
> implement 'prepare to suspend', 'late suspend', 'suspend', 'quiese but 
> don't suspend', etc" if they aren't really interested in working on 
> suspend, it's not really clear what each of these should do even after 
> reading the docs on it. however listing the power modes that a device can 
> be in, documenting the cost of switching between them, and implementing 
> the transition is something very straightforward for the device driver 
> author to do (and they don't have to worry about the details of how and 
> when the various modes get used, that's up to the suspend/powersaving 
> software to figure out). as such I expect that the driver support for 
> powersaving modes to improve. in fact, I expect that some driver writers 
> will implement a whole bunch of modes, just to show off the features of 
> the hardware. and even if nothing uses the modes right now at least they 
> are implemented and documented for future use (and it should be trivial to 
> have a test routine that just runs every driver you have hardware for 
> through every mode transition to make sure that they all work, so the less 
> commonly used modes shouldn't bitrot too badly)

What you are saying can be summarised as making the driver model more
expressive.

> while I was describing the issues to my roomates over dinner I realized 
> that the same type of functions are needed for the CPU clocks.
> 
> if you have an accepted framework in place there that can do what I 
> described, please consider extending it to cover other types of devices 
> and drivers.

That is not part of the fw: the fw simply expresses parent-child clock
distribution and keeps usecounts so that unused clocks are automatically
gated.

The actual clock tree description is platform/arch/board specific and
doesn't affect the framework. You can just roll your own version for x86
by providing a description of the methods used to switch on/off every
individual clock on your board.

So what you are asking for is that somebody writes an x86 version of the
clock fw.

As for latencies, well, only few clocks really have significant impact.
Most notably the main system oscillator. Everything else has 0 latency
since it ends up in opening/closing a clock gate.

Powering device on/off will certainly introduce more latency, but either
the powering is supported by the hw, to make it quick or it has to go
through most, if not all of he usual initialisation sequence; in that
case it probably makes sense to avoid controlling it from kernelspace,
since it will be slow and won't require dedcisions made with us
precision.

> I want sanity and functionality far more then credit :-)

I want to avoid redesigning the wheel: the current version is not round
yet, but re-starting from a triangle every time is far less appealing.

> thanks for the link. I've read through it, and it looks like there is a 
> lot of the same ideas in your proposal. 

Unless some new hw/technology shows up, I'm afraid the available set of
ideas is very limited :-)

> I think you are passing too much 
> info up the chain to the part makeing the decision (that part doesn't need 
> to know the details of the voltage/freq choices, the %power/%capability 
> numbers I suggested are in many ways more what they are making decision 
> son anyway)

I don't think you have got it right: the only info being passed is the
standard cpufreq list of frequencies; everything else is part of the
cpufreq driver.

> in the slideshow you list in the sequence of changing the cpu speed to pre 
> and post notify drivers. what exactly are the drivers expected to do with 
> the notification? are you asking them to pause and then re-initialize for 
> the new power level?

It's just a  notification. The drivers are supposed to know how to deal
with it.
In OMAP2 the major concern is that the external memory cannot be
accessed since it is on a bus that is being re-clocked:
- the dma controllers must be paused
- the other cores (dsp) must not access sdram
- the onenand driver needs to adjust its timing parameters

[snip]

> > To make any proposal that has some chance of being accepted, you have to
> > compare it against the existing solution, explaining:
> >
> > -what it is bringing in terms of new functionalities
> > -how it is different
> 
> it unifies all power/performance trade-offs (including power on/off) into 
> a single API, but decouples that API from the implementation details of 
> exactly what the technical details of the different modes are and how the 
> changes are made.

It always looks great at this level of abstraction, but then usually
what is discovered later is that _a lot_ of extra complexity is
introduced, in order to cover every case on every platform that is
intended to be supported.

> for some subsystems this would be little more then renameing existing 
> fucntions, for others it would be converting several indepndant functions 
> into one, discoverable api

if you check cpufreq, you will find out that it already covers the
multiple cores case (but nothing prevents from using the same logic on
something that is not really a cpu) and also has some simple concept of
latency for frequency transition, concept that could be enhanced to
handle latencies that are depending on the current operating point and
target operating point.

> > -why the current implementation cannot simply be enhanced
> 
> which current implementation should be enhanced? and with the massive 
> broadening of functionality should it retain the same name, or should it 
> get renamed to something more generic?

cpufreq could be renamed to anything that makes sense, but i see _no_
massive broadening of functionality.

> the cpufreq implementation is very close to what I'm proposing, it would 
> need to get broadend to cover other devices (like disk drives, wireless 
> cards, etc), is this really the right thing to do or should the more 
> generic API go in for external use and then the existing cpufreq be called 
> from the set_mode() call?

No, that doesn't make sense, as general approach.
You want to manage from kernel only those parts of the system where the
latency is so low that userspace wouldn't be able to keep up.

Your examples (wireless, disk drive) can be easily controlled from
userspace, with a timeout.

In both cases there are significant delays (change of rotation speed /
sync with the access point).

All this is hand waiving unless it is backed up by numbers.
Real cases are required in order to establish a list of priorities for
latency/power consumption.

Afterward, a valid solution that can address such cases can be sketched.

-- 
Cheers, Igor

Igor Stoppa <igor.stoppa@nokia.com>
(Nokia Multimedia - CP - OSSO / Helsinki, Finland)
