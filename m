Return-Path: <linux-kernel-owner+w=401wt.eu-S1762479AbXGWKr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762479AbXGWKr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 06:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbXGWKrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 06:47:51 -0400
Received: from smtp.nokia.com ([131.228.20.171]:23899 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564AbXGWKru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 06:47:50 -0400
Subject: Re: [linux-pm] Power Management framework proposal
From: Igor Stoppa <igor.stoppa@nokia.com>
To: "ext david@lang.hm" <david@lang.hm>
Cc: "ext linux-pm-bounces@lists.linux-foundation.org" 
	<linux-pm-bounces@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0707221156210.6350@asgard.lang.hm>
References: <Pine.LNX.4.64.0707212339550.6350@asgard.lang.hm>
	 <1185091022.19678.28.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0707220057210.6350@asgard.lang.hm>
	 <1185105911.29238.43.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0707221156210.6350@asgard.lang.hm>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: OSSO
Date: Mon, 23 Jul 2007 13:48:40 +0300
Message-Id: <1185187720.26628.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 23 Jul 2007 10:47:26.0351 (UTC) FILETIME=[DBC601F0:01C7CD16]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-22 at 14:21 -0700, ext david@lang.hm wrote:

[snip]

> this is another one. I'd be happy to get pointers to prior ones to learn 
> from.

https://lists.linux-foundation.org/pipermail/linux-pm/2007-March/011204.html

This is probably one of the latest. Previously there was some clash
between powerop and oppoints that lead to people running away from too
much confusion.

> > Unfortunately, while it's true that there are significant similarities,
> > there are also notable differencies; as far as i know the USB subsystem
> > is the one that gets closer to what we have in the embedded arena, since
> > it can have complex cases of parent-child powering and wakeup.
> 
> this API is not trying to represent the parent-child hierarchy. as far as 
> I know that's documented in sysfs (or is supposed to be). this is just an 
> attempt to make it so that as you are going through the hierarchy you 
> don't have to use vastly different API's to control the different 
> functions.

You are going to end up with parent child relationships, or
user-consumer.
Devices don't exist in the void, but are interconnected.

> I suspect that most (if not all) of the previous One Solutions have tried 
> to completely handle all the details of their original case, and then 
> branch out to the other cases.
> 
> this attempt is working from the other direction. the user of this API 
> doesn't care how something is done, it just wants to know what's possible 
> and how to tell the system to switch modes.

True, but you are endding up in the same situation: too much abstraction
makes the governing system clumsy and inefficient.

> other then just me searching through the lists, do you have a pointer to 
> some of the differences between the different types that are seen as being 
> so large that they can't be unified?

I'll be more detailed in further replies to following emails from this
same thread that have already piled up.

> >> while I was describing the issues to my roomates over dinner I realized
> >> that the same type of functions are needed for the CPU clocks.
> >>
> >> if you have an accepted framework in place there that can do what I
> >> described, please consider extending it to cover other types of devices
> >> and drivers.
> >
> > That is not part of the fw: the fw simply expresses parent-child clock
> > distribution and keeps usecounts so that unused clocks are automatically
> > gated.
> >
> > The actual clock tree description is platform/arch/board specific and
> > doesn't affect the framework. You can just roll your own version for x86
> > by providing a description of the methods used to switch on/off every
> > individual clock on your board.
> >
> > So what you are asking for is that somebody writes an x86 version of the
> > clock fw.
> 
> this is more then just setting the clocks on everything (although setting 
> clocks seems like it fits well into the model) becouse some power modes 
> are not easily represented just as clocks.

The very same idea of power mode is something that can maybe fit some
simple peripherals (simple as not fine grained contraollable in terms of
what is on and what is off), but certainly it doesn't fit nicely modern
SoC (see OMAP) since ata certain point of time you don't really know
what is the power consumption because many resources are automatically
gated by HW on an on-need basis.
And you don't want to switch this feature off.

> > As for latencies, well, only few clocks really have significant impact.
> > Most notably the main system oscillator. Everything else has 0 latency
> > since it ends up in opening/closing a clock gate.
> >
> > Powering device on/off will certainly introduce more latency, but either
> > the powering is supported by the hw, to make it quick or it has to go
> > through most, if not all of he usual initialisation sequence; in that
> > case it probably makes sense to avoid controlling it from kernelspace,
> > since it will be slow and won't require dedcisions made with us
> > precision.
> 
> and many devices support both a quick almost-off mode and a slow 
> almost-off mode (as well as a completely off mode), with the slow mode 
> eating less power, but takeing longer to wake up from. that's the reason 
> for providing the matrix to let the program makeing the decision decide if 
> it's worth the time delays to get the power savings
> 
> as I note in anther message, this SPI isn't intended to be strictly 
> kernelspace or strictly userspace. for the ondemand speed governer you are 
> changing the settings quickly and so probably want to do so in the kernel, 
> however some people may be satisfied with slower controls and so could 
> have them in userspace (an extreme example of this would be turning off 
> wireless cards that aren't in use to save power and improve security)

So you are goingto have 2 API: one for kernelspace (evolution of
CPUfreq) and one for userspace, which seems more and more likely to be
an extension to HAL.
Are you informed on HOM and Intel Mobilin ?
http://ohm.freedesktop.org/wiki/
http://www.moblin.org/index.html
> 
> >> I think you are passing too much
> >> info up the chain to the part makeing the decision (that part doesn't need
> >> to know the details of the voltage/freq choices, the %power/%capability
> >> numbers I suggested are in many ways more what they are making decision
> >> son anyway)
> >
> > I don't think you have got it right: the only info being passed is the
> > standard cpufreq list of frequencies; everything else is part of the
> > cpufreq driver.
> 
> to make the decisions the software makeing the decision needs to know how 
> much power would be used at each freq setting.

And that's the wrong assumption: you don't know for real what the power
consumption is going to be; on decent embedded systems the clock gating
takes care of minimizing power consumption, while the frequency
throttling is intended to provide enough performance.

If you happen to know that for x86 it's because they suck in terms of
idle power cunsumption, but certainly that's not a good reason to
penalise those that have better design.

And i'm sure things are going to change rapidly now that intel is
stepping into the lightweight mobile arena.

> >> in the slideshow you list in the sequence of changing the cpu speed to pre
> >> and post notify drivers. what exactly are the drivers expected to do with
> >> the notification? are you asking them to pause and then re-initialize for
> >> the new power level?
> >
> > It's just a  notification. The drivers are supposed to know how to deal
> > with it.
> > In OMAP2 the major concern is that the external memory cannot be
> > accessed since it is on a bus that is being re-clocked:
> > - the dma controllers must be paused
> > - the other cores (dsp) must not access sdram
> > - the onenand driver needs to adjust its timing parameters
> 
> in my proposal this would require one or more 'pause' modes (more then 
> one if you need to pause at different power settings fro some reason) for 
> the first notification, and then you would set them to the mode you want 
> them in at the second notification point (which is probably going to be 
> the mode they were in before)

pauses are to be avoided as much as possible, or at least made very
short. The change has to be seamless; stopping the system is not a good
start.

> > [snip]
> >
> >>> To make any proposal that has some chance of being accepted, you have to
> >>> compare it against the existing solution, explaining:
> >>>
> >>> -what it is bringing in terms of new functionalities
> >>> -how it is different
> >>
> >> it unifies all power/performance trade-offs (including power on/off) into
> >> a single API, but decouples that API from the implementation details of
> >> exactly what the technical details of the different modes are and how the
> >> changes are made.
> >
> > It always looks great at this level of abstraction, but then usually
> > what is discovered later is that _a lot_ of extra complexity is
> > introduced, in order to cover every case on every platform that is
> > intended to be supported.
> 
> which is why I posted this for comments.
> 
> what are the cases that require extra info.can that extra info be as 
> simple as a set of flags for the mode (or possibly for the transition 
> matrix).
> 
> for your clock example you need a flag that says 'this requires everything 
> connected to this be paused'
> 
> for suspend other low power modes you need to be able to say 'contents of 
> things below this point will be lost when you go into this mode' so that 
> the decision makeing software knows that it needs to save the contents of 
> memory before switching to a mode that stops the dram refresh. I don't 
> have any idea at the moment for how to prvide a common interface for 
> actually saving or restoring the contents, that is outside the scope of 
> this API

That's wrong: the drdiver can keep to itself the information about
saving/restoring; if fit advertises the time it will take, that's
enough.

> the ACPI people will need a flag for 'this device can generate wakeup 
> signals in this mode'
> 
> but this API would just provide this info to the decision makeing code, 
> that code would have to antually enforce the limits

Again, you are going into a field that belongs to hw abstraction and
already has a standard tool do dela with it - HAL

> >> for some subsystems this would be little more then renameing existing
> >> fucntions, for others it would be converting several indepndant functions
> >> into one, discoverable api
> >
> > if you check cpufreq, you will find out that it already covers the
> > multiple cores case (but nothing prevents from using the same logic on
> > something that is not really a cpu) and also has some simple concept of
> > latency for frequency transition, concept that could be enhanced to
> > handle latencies that are depending on the current operating point and
> > target operating point.
> 
> does it provide a full matrix of latencies, or just mode 1->mode2=x, 
> mode2->mode3=y so mode1->mode3=x+y?

IIRC it's just 1 value

> >>> -why the current implementation cannot simply be enhanced
> >>
> >> which current implementation should be enhanced? and with the massive
> >> broadening of functionality should it retain the same name, or should it
> >> get renamed to something more generic?
> >
> > cpufreq could be renamed to anything that makes sense, but i see _no_
> > massive broadening of functionality.
> 
> what I'm talking about would provide an API to devices that you are 
> ignoring becouse they should be managed from userspace.

again, HAL / OHM / Mobilin

> >> the cpufreq implementation is very close to what I'm proposing, it would
> >> need to get broadend to cover other devices (like disk drives, wireless
> >> cards, etc), is this really the right thing to do or should the more
> >> generic API go in for external use and then the existing cpufreq be called
> >> from the set_mode() call?
> >
> > No, that doesn't make sense, as general approach.
> > You want to manage from kernel only those parts of the system where the
> > latency is so low that userspace wouldn't be able to keep up.
> >
> > Your examples (wireless, disk drive) can be easily controlled from
> > userspace, with a timeout.
> 
> absoutly, and they should be (at least most of the time). this was not 
> intended as a kernelspace only api. it is intended to be available to both 
> kernelspace and userspace.
> 
> > In both cases there are significant delays (change of rotation speed /
> > sync with the access point).
> 
> correct, and these delays should be reflected in the transition cost 
> matrix
> 
> > All this is hand waiving unless it is backed up by numbers.
> > Real cases are required in order to establish a list of priorities for
> > latency/power consumption.
> 
> this isn't attempting to establish a list of priorites, simply to give the 
> software that is trying to establish such a list the info to make it's 
> decisions, and the interface to use to issue the resulting instructions.

What i'm saying is that sw is implemented to fulfill certain needs. I'd
rather see a detailed description of the need and based on that debate
on the actual API / implementation.

-- 
Cheers, Igor

Igor Stoppa <igor.stoppa@nokia.com>
(Nokia Multimedia - CP - OSSO / Helsinki, Finland)
