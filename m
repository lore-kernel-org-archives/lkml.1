Return-Path: <linux-kernel-owner+w=401wt.eu-S1764745AbXGYNQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764745AbXGYNQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 09:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756903AbXGYNP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 09:15:57 -0400
Received: from nox.protox.org ([88.191.38.29]:49548 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815AbXGYNP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 09:15:56 -0400
X-Greylist: delayed 1576 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jul 2007 09:15:56 EDT
Message-ID: <46A746D1.4030506@protox.org>
Date: Wed, 25 Jul 2007 14:49:21 +0200
From: Jerome Glisse <glisse@protox.org>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: david@lang.hm
CC: Igor Stoppa <igor.stoppa@nokia.com>,
       "ext linux-pm-bounces@lists.linux-foundation.org" 
	<linux-pm-bounces@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Power Management framework proposal
References: <Pine.LNX.4.64.0707212339550.6350@asgard.lang.hm>  <1185091022.19678.28.camel@localhost.localdomain>  <Pine.LNX.4.64.0707220057210.6350@asgard.lang.hm>  <1185105911.29238.43.camel@localhost.localdomain>  <Pine.LNX.4.64.0707221156210.6350@asgard.lang.hm>  <1185187720.26628.23.camel@localhost.localdomain>  <Pine.LNX.4.64.0707231033430.3828@asgard.lang.hm>  <4240b9160707240143u6cdaba64rae93528661f4475c@mail.gmail.com>  <Pine.LNX.4.64.0707241303010.6590@asgard.lang.hm> <4240b9160707241614k5d8d51ack9c231c4a023ae110@mail.gmail.com> <Pine.LNX.4.64.0707241735230.6590@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707241735230.6590@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> On Wed, 25 Jul 2007, Jerome Glisse wrote:
>
>> On 7/24/07, david@lang.hm <david@lang.hm> wrote:
>>>  will each plugin have it's own interface? or will you have one 
>>> interface
>>>  to access the plugins and then the plugins do things behind the 
>>> scenes?
>>>
>>>  I'll bet that the API for the plugins is common, and if so then it 
>>> could
>>>  be similar to the API that I suggested.
>>
>> I take here ohm as a reference (this come from my limited 
>> understanding of
>> this daemon so there might be inaccuracy) driver export through HAL
>> there power management tunning capacity, Then an ohm plugin would use
>> HAL to give a higher
>> view of this capacity and also manage policy, preference, permission, 
>> ...
>>
>> Last consumer in power management food chain would be an user 
>> interface which
>> will communicate with ohm (and with all ohm plugin) so desktop 
>> writter (gnome,
>> kde, ...) can write some kind of power management center where each 
>> ohm plugin
>> can have its own panel. So in the end the user got one place to do 
>> all its
>> power management which is the goal i think you are trying to aim.
>
> no. I am talking about the interface to the drivers that things like 
> HAL would use
>
Ok, i was just trying to stress that the end result is the same from the 
user point of
view.
>>> >  For instance on graphics card you could do the following (maybe 
>>> more):
>>> >  -change GPU clock
>>> >  -change memory clock
>>> >  -disable part of engine
>>> >  -disable unit
>>> >  i truly don't think you can make a common interface for all this, 
>>> more
>>> >  over there might be constraint on how you can change things (GPU &
>>> >  memory clock might need to follow a given ratio). So you definitely
>>> >  need knowledge in the user space program to handle this.
>>>
>>>  sure you can, just enumerate all the options the driver writer 
>>> wants to
>>>  offer as options. yes this could be a lengthy list, so what?
>>>
>>
>> My point was that your interface by trying to fit square pegs into 
>> round hole
>> will fail to expose all subtility of each device which might in the 
>> end bring
>> to wrong power management decision. So i believe we can't sum up
>> power management to list of mode whose attribute are power consumption
>> & capacity.
>
> it's possible (which is part of the reason I started the thread), but 
> so far there hasn't been anything identified that is a really bad fit.
>
Tell me how i do this in your model:
GPU/VRAM memory clock change power consumption of the card and
the power consumption is often not a trivial function of both of this 
parameters
(i even here simplify the problem by omitting pipeline shutdown). So how 
with
two different separate mode list (one for GPU speed another one for VRAM 
speed)
can you provide consumption information while this consumption depends 
on the
others settings. Then if you give as a solution to make only one list 
you end up
with a more bigger list than previously needed (nrGPUmodes * nrVRAMmodes)
do you expect the user to go through a lengthy list to find what he wants ?
(remember that we will have to add pipeline power off, pll tweaking or many
others way of saving power on such card).

So by choosing this power consumption as a unit of measure you end up
in non trivial case. There is also the question of overclocking, and 
other points
already identified where unfortunately a global design such as your proposal
does not seems to fit properly: local power decision (ethernet, wifi 
card, ...
can power down them self is they are doing nothings but the place where you
can know this is the driver), there is also the child/parent relation, 
how to
estimate power usage (on some configuration one device consumption can
be marginal toward all others things while on other this same device can be
the most power hungry device)... I see all this as bad fit.
>> And there is no way to design an abstraction given that all hw we 
>> will have
>> to deal with are too much different and do not follow any standard 
>> things
>> (beside ACPI there is other way to save power brightness, gpu/memory
>> clock, pll, ...) so i don't see how one might give a common view of 
>> things
>> which are fundamentally different in how they affect consumption 
>> (same end
>> result with many different paths leading to it).
>
> so you are saying that the power management software must know the 
> details of each and every driver, and if you add a new driver you must 
> change the power management software before it can do anything 
> (including allowing manual control of the modes)
>
You have to provide an ohm plug in (in an ohm world) where policy for 
this device will be
handled and this plug in need to be designed knowing what the hw export 
through HAL.
Yes it's pain full but you don't want to put policy in the driver and to 
do policy you need
knowledge on the things you deal with.
> seems to me I heard similar arguments several years ago about the CPU 
> speed settings, it turns out that the cpufreq interface works really 
> well for them and the software that's controlling things no longer 
> needs to know the details of every CPU.
>
> why did it work there but can't work anywhere else?
>
> David Lang
cpufreq is unification of processor frequency management, what you try 
to unify here
can go from toaster (i am sure there is usb driven toaster available 
somewhere on earth
don't ask why) to 100000$ specialized DSP card, we can save power on 
both on them but
how, which policy to follow, and what parameters to tweak will be very 
different. At
least i don't think you will want to driver your specialized DSP card as 
a toaster, personally
i won't.

Oh and as a side note i would like a common interface for dealing with 
power but i just
don't think it's possible, i might be wrong but so far i don't see in 
any other os offering
such things. That said you might be able to factor out _some_ common 
things for
given class of hardware (network card, usb device, graphics cards, ...).

best,
Jerome Glisse
