Return-Path: <linux-kernel-owner+w=401wt.eu-S965179AbXG2V7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965179AbXG2V7g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 17:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935349AbXG2V72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 17:59:28 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:58535
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbXG2V70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 17:59:26 -0400
Date: Sun, 29 Jul 2007 14:56:25 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Jerome Glisse <glisse@protox.org>
cc: Igor Stoppa <igor.stoppa@nokia.com>,
       "ext linux-pm-bounces@lists.linux-foundation.org" 
	<linux-pm-bounces@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Power Management framework proposal
In-Reply-To: <46A746D1.4030506@protox.org>
Message-ID: <Pine.LNX.4.64.0707291422340.15835@asgard.lang.hm>
References: <Pine.LNX.4.64.0707212339550.6350@asgard.lang.hm> 
 <1185091022.19678.28.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0707220057210.6350@asgard.lang.hm> 
 <1185105911.29238.43.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0707221156210.6350@asgard.lang.hm> 
 <1185187720.26628.23.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0707231033430.3828@asgard.lang.hm> 
 <4240b9160707240143u6cdaba64rae93528661f4475c@mail.gmail.com> 
 <Pine.LNX.4.64.0707241303010.6590@asgard.lang.hm>
 <4240b9160707241614k5d8d51ack9c231c4a023ae110@mail.gmail.com>
 <Pine.LNX.4.64.0707241735230.6590@asgard.lang.hm> <46A746D1.4030506@protox.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sorry for the delay in responding

On Wed, 25 Jul 2007, Jerome Glisse wrote:
> david@lang.hm wrote:
>>  On Wed, 25 Jul 2007, Jerome Glisse wrote:
>> 
>> >  On 7/24/07, david@lang.hm <david@lang.hm> wrote:
>> > > >   For instance on graphics card you could do the following (maybe 
>> > >  more):
>> > > >   -change GPU clock
>> > > >   -change memory clock
>> > > >   -disable part of engine
>> > > >   -disable unit
>> > > >   i truly don't think you can make a common interface for all this, 
>> > >  more
>> > > >   over there might be constraint on how you can change things (GPU &
>> > > >   memory clock might need to follow a given ratio). So you definitely
>> > > >   need knowledge in the user space program to handle this.
>> > > 
>> > >  sure you can, just enumerate all the options the driver writer wants 
>> > >  to
>> > >   offer as options. yes this could be a lengthy list, so what?
>> > > 
>> > 
>> >  My point was that your interface by trying to fit square pegs into round 
>> >  hole
>> >  will fail to expose all subtility of each device which might in the end 
>> >  bring
>> >  to wrong power management decision. So i believe we can't sum up
>> >  power management to list of mode whose attribute are power consumption
>>> & capacity.
>>
>>  it's possible (which is part of the reason I started the thread), but so
>>  far there hasn't been anything identified that is a really bad fit.
>> 
> Tell me how i do this in your model:
> GPU/VRAM memory clock change power consumption of the card and
> the power consumption is often not a trivial function of both of this 
> parameters
> (i even here simplify the problem by omitting pipeline shutdown). So how with
> two different separate mode list (one for GPU speed another one for VRAM 
> speed)
> can you provide consumption information while this consumption depends on the
> others settings. Then if you give as a solution to make only one list you end 
> up
> with a more bigger list than previously needed (nrGPUmodes * nrVRAMmodes)
> do you expect the user to go through a lengthy list to find what he wants ?
> (remember that we will have to add pipeline power off, pll tweaking or many
> others way of saving power on such card).

yes I expect that it would be a large list in some conditions. but one 
purpose of this API is to make these options able to be discovered by 
software. right now nothing could be done at all without driver specific 
knowledge. even a lengthy list can be better then that.

presenting the list to the user directly is a last resort, only for 
experimentation or when nothing else wants to deal with devices of that 
type.

with a description field (which I didn't include initially, but seems 
obviously needed now) it should be fairly easy to create descriptions that 
let the software see that there are multiple factors involved.

> So by choosing this power consumption as a unit of measure you end up
> in non trivial case. There is also the question of overclocking

if the driver supports overclocking then list it in the modes (nothing 
says that % capacity couldn't go over 100% for example)

> , and other points already identified where unfortunately a global 
> design such as your proposal does not seems to fit properly: local power 
> decision (ethernet, wifi card, ... can power down them self is they are 
> doing nothings but the place where you can know this is the driver)

if they power themselves down with no notice to the system they should 
power themselves back up with no need for the rest of the system to tell 
them either. so this ca either be ignored or presented as a mode between 
off and on that enables this behavior.

> , there is also the child/parent relation, how to
> estimate power usage (on some configuration one device consumption can
> be marginal toward all others things while on other this same device can be
> the most power hungry device)... I see all this as bad fit.

ahh, here we see a disconnect. I was not intending for the power field to 
be that exact. there are just too many variables. for example: even for a 
cpu, the power used isn't exactly tied to the clock speed and voltage, the 
mix of commands that the cpu is running will affect the power it eats, 
sometimes by a significant amount. it was intended to be an ordering 
factor and approximate the power used so that things could make a 
peroformance/power tradeoff with a good chance of makeing a reasonable 
choice.

it's not intended for 'make this laptop use 24w of power instead of 25w of 
power'

>> >  And there is no way to design an abstraction given that all hw we will 
>> >  have
>> >  to deal with are too much different and do not follow any standard 
>> >  things
>> >  (beside ACPI there is other way to save power brightness, gpu/memory
>> >  clock, pll, ...) so i don't see how one might give a common view of 
>> >  things
>> >  which are fundamentally different in how they affect consumption (same 
>> >  end
>> >  result with many different paths leading to it).
>>
>>  so you are saying that the power management software must know the details
>>  of each and every driver, and if you add a new driver you must change the
>>  power management software before it can do anything (including allowing
>>  manual control of the modes)
>> 
> You have to provide an ohm plug in (in an ohm world) where policy for this 
> device will be
> handled and this plug in need to be designed knowing what the hw export 
> through HAL.
> Yes it's pain full but you don't want to put policy in the driver and to do 
> policy you need
> knowledge on the things you deal with.

I'll have to look into what the ohm plugin does.....

ok, after a quick google search and reading the wiki, what I was proposing 
would potentially allow ohm to use it directly instead of having to go 
through HAL (there may still be a place for HAL, but some parts of it 
would get significantly simpler if the abstraction was available directly 
from the driver instead of haivng to teach a second piece of software all 
the nuances of the driver for it to then create an abstraction for the 
system to use)

>>  seems to me I heard similar arguments several years ago about the CPU
>>  speed settings, it turns out that the cpufreq interface works really well
>>  for them and the software that's controlling things no longer needs to
>>  know the details of every CPU.
>>
>>  why did it work there but can't work anywhere else?
>>
>>  David Lang
> cpufreq is unification of processor frequency management, what you try 
> to unify here can go from toaster (i am sure there is usb driven toaster 
> available somewhere on earth don't ask why) to 100000$ specialized DSP 
> card, we can save power on both on them but how, which policy to follow, 
> and what parameters to tweak will be very different. At least i don't 
> think you will want to driver your specialized DSP card as a toaster, 
> personally i won't.

no you don't want to use the same driver for both, however it would be 
very nice to have an interfact that would let yo load the driver for yout 
specialized DSP card and all the opensouce software would see it and be 
able to manipulate it rather then having to modify the HAL, create ohm 
plugins, etc (for how many programs?) before they can know that the card 
is there.

David Lang

> Oh and as a side note i would like a common interface for dealing with 
> power but i just don't think it's possible, i might be wrong but so far 
> i don't see in any other os offering such things. That said you might be 
> able to factor out _some_ common things for given class of hardware 
> (network card, usb device, graphics cards, ...).
>
> best,
> Jerome Glisse
>
