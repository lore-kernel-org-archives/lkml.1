Return-Path: <linux-kernel-owner+w=401wt.eu-S1763387AbXGVI7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763387AbXGVI7y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 04:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760834AbXGVI7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 04:59:44 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:44530
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760767AbXGVI7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 04:59:42 -0400
Date: Sun, 22 Jul 2007 01:58:50 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Igor Stoppa <igor.stoppa@nokia.com>
cc: "ext linux-pm-bounces@lists.linux-foundation.org" 
	<linux-pm-bounces@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Power Management framework proposal
In-Reply-To: <1185091022.19678.28.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0707220057210.6350@asgard.lang.hm>
References: <Pine.LNX.4.64.0707212339550.6350@asgard.lang.hm>
 <1185091022.19678.28.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jul 2007, Igor Stoppa wrote:

> Hi,
> On Sat, 2007-07-21 at 23:49 -0700, ext
> linux-pm-bounces@lists.linux-foundation.org wrote:
>> I'm deliberatly breaking the threading on this so that people who have
>> tuned out the hibernation thread can take a look at this.
>>
>> below is the proposal that I made at the bottom of one of the posts on the
>> hibernation thread.
>
> I have the impression that you are trying to describe a mix of the clock
> and latency frameworks.
>
> Could you elaborate on how your proposal is incompatible with enhancing
> the clock framework?

It's not that I think it's incompatible with any existing powersaving 
tools (in fact I hope it's not)

it's that I think that this (or something similar) could be made to cover 
all thevarious power options instead of CPU's having one interface, ACPI 
capable drivers having another, embeded devices presenting a third, etc

this was triggered by the mess of different function calls for different 
purposes that are used for the suspend functions where you have a bunch of 
different functions that are each supposed to be called at a specific time 
from a specific mode during the suspend process. with all these different 
functions driver writes tend to not bother implementing any of them, and 
it seems like there is a fairly steady stream of new functions that end up 
being needed. the initial intent was to just change this into a generic 
set of calls that every driver writer would implement the minimum set of, 
and make it trivially extensable to future capabilities of hardware.

one other effect of this is that driver writers would see the mode 
interface from day one rather then just completely ignoring it. right now 
device driver authors tend to thing " why worry about figuring out how to 
implement 'prepare to suspend', 'late suspend', 'suspend', 'quiese but 
don't suspend', etc" if they aren't really interested in working on 
suspend, it's not really clear what each of these should do even after 
reading the docs on it. however listing the power modes that a device can 
be in, documenting the cost of switching between them, and implementing 
the transition is something very straightforward for the device driver 
author to do (and they don't have to worry about the details of how and 
when the various modes get used, that's up to the suspend/powersaving 
software to figure out). as such I expect that the driver support for 
powersaving modes to improve. in fact, I expect that some driver writers 
will implement a whole bunch of modes, just to show off the features of 
the hardware. and even if nothing uses the modes right now at least they 
are implemented and documented for future use (and it should be trivial to 
have a test routine that just runs every driver you have hardware for 
through every mode transition to make sure that they all work, so the less 
commonly used modes shouldn't bitrot too badly)

while I was describing the issues to my roomates over dinner I realized 
that the same type of functions are needed for the CPU clocks.

if you have an accepted framework in place there that can do what I 
described, please consider extending it to cover other types of devices 
and drivers.

I want sanity and functionality far more then credit :-)

David Lang

> It looks like you are proposing a brand new shiny thing that frankly I
> would be happy to leave alone, unless it is crystal clear that the clock
> fw cannot be improved.
>
> The clocfk fw is used for OMAP and other architectures (including SH,
> iirc) and so far it has provided very good support for our power
> management needs (Nokia 770 and N800).
>
> Currently we are working on DVFS for OMAP2 (see slides presented at the
> linux-pm summit for OLS 2007 http://tinyurl.com/28tact ) and even if the
> current prototype is not actively involving the clock fw, our final goal
> is to make it capable of supporting atomic transactions for changing the
> core parameters.

thanks for the link. I've read through it, and it looks like there is a 
lot of the same ideas in your proposal. I think you are passing too much 
info up the chain to the part makeing the decision (that part doesn't need 
to know the details of the voltage/freq choices, the %power/%capability 
numbers I suggested are in many ways more what they are making decision 
son anyway)

in the slideshow you list in the sequence of changing the cpu speed to pre 
and post notify drivers. what exactly are the drivers expected to do with 
the notification? are you asking them to pause and then re-initialize for 
the new power level?

> OMAP3 will require suspend to ram implementation where the content of
> system memory is retained, while parts or all the SoC are switched off.
> The plan is still to have a clock fw based implementation (plus
> interaction with the power rails, of course).
>
> I think these are good examples of the non-ACPI systems you are
> mentioning.

yes, I think they are.

> To make any proposal that has some chance of being accepted, you have to
> compare it against the existing solution, explaining:
>
> -what it is bringing in terms of new functionalities
> -how it is different

it unifies all power/performance trade-offs (including power on/off) into 
a single API, but decouples that API from the implementation details of 
exactly what the technical details of the different modes are and how the 
changes are made.

for some subsystems this would be little more then renameing existing 
fucntions, for others it would be converting several indepndant functions 
into one, discoverable api

> -why the current implementation cannot simply be enhanced

which current implementation should be enhanced? and with the massive 
broadening of functionality should it retain the same name, or should it 
get renamed to something more generic?

the cpufreq implementation is very close to what I'm proposing, it would 
need to get broadend to cover other devices (like disk drives, wireless 
cards, etc), is this really the right thing to do or should the more 
generic API go in for external use and then the existing cpufreq be called 
from the set_mode() call?

> You can refer to the linux-pm archives for examples of failed attempts
> over the last year or so, just search for "framework" in the subject.

I'll try to do some digging.

David Lang
