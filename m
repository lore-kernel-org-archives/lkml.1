Return-Path: <linux-kernel-owner+w=401wt.eu-S1753178AbYKZFVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbYKZFVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 00:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760AbYKZFVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 00:21:16 -0500
Received: from rn-out-0910.google.com ([64.233.170.189]:43940 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbYKZFVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 00:21:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uk7bGcNHw8PBcEqv6m+HVbRMhu4wNdJI+C9v37rRAciLg8AFnoRUmAupuvydEG8tF1
         mk7FxTqyk+/r2VD9L75Shfgb9L8+nolZWaJmvEnRYb/VjwQiILs7cWeHaODYlx91Wgao
         wMaAd/9pW+SsI7ut/sr21Kj4kPSq4VHs8syak=
Message-ID: <aec7e5c30811252121i23a719fcl19b4db4af785dd46@mail.gmail.com>
Date: Wed, 26 Nov 2008 14:21:14 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [RFC] Reentrant clock sources
Cc: "john stultz" <johnstul@us.ibm.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, lethal@linux-sh.org, mingo@redhat.com
In-Reply-To: <20081126035251.GA3707@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081125132823.8698.83248.sendpatchset@rx1.opensource.se>
	 <alpine.LFD.2.00.0811252215270.3235@localhost.localdomain>
	 <20081126030720.GC8242@elte.hu> <1227669624.6298.11.camel@localhost>
	 <20081126035251.GA3707@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

Thanks for all the feedback so far.

On Wed, Nov 26, 2008 at 12:52 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * john stultz <johnstul@us.ibm.com> wrote:
>
>> On Wed, 2008-11-26 at 04:07 +0100, Ingo Molnar wrote:
>> > * Thomas Gleixner <tglx@linutronix.de> wrote:
>> >
>> > > > +       cycle_t (*vread)(struct clocksource *cs);
>> > >
>> > > This is crap. vread can not access the clocksource.
>> >
>> > i think 'reentrant' in the sense of creating self-sufficient driver
>> > entities. vread wont (and shouldnt) call ->vread() recursively - but
>> > it might want to access fields on the clocksource.

Uhm, I should have used that wording instead. =)

>> I think Thomas' issue is that vread() *cannot* access fields on the
>> clocksource (since vread has to be careful not to access any
>> non-vsyscall mapped memory).
>
> ah, yeah - i was thinking about ->read().

My main concern is ->read(). Initially I thought that I could pass the
clock source as argument to all callbacks, but I now understand that
passing cs to ->vread() is difficult.

> in a more dynamic driver model the clocksource driver could store
> dynamic data like target port/memory address next to the clocksource
> driver, and access that - if the driver pointer is passed in.

Exactly.

>> However not all clocksources use vread(), but really I'm not quite
>> clear on what one would want to access in the clocksource structure
>> when making a ->read() call.

Below is a link to some helper functions to manage incrementing
timers. The code is a bit rough but the idea is simple - create one
simple interface for timers that can be used as clock source and/or
clock event.

http://comments.gmane.org/gmane.linux.ports.sh.devel/4850

If you like this idea then similar helper code for decrementing timers
may be useful as well.

>> So maybe a further description of what specific need motivates this
>> change would be helpful? The brief description of power management
>> doesn't quite click in my head yet.
>
> yeah, that would be nice.

The reason for passing the clock source as argument to the read() and
resume() callbacks is that I want to use the same function for
multiple timer instances and use container_of() to get access to
per-instance private data. Without any argument I have to rely on
global data or compile time constants which makes it difficult to
reuse functions for multiple instances. Right now the timer_inc helper
code only exports a single clock source because of this limitation.

Regarding power management, the clock event code allows us to put the
hardware block for unused clock events in some kind of sleep mode when
CLOCK_EVT_MODE_SHUTDOWN or CLOCK_EVT_MODE_UNUSED is passed to
->set_mode(). I'd like to have something similar for clock sources
where unused clock sources can be powered down. For instance, we may
have two clock sources, one high resolution and one with not so good
accuracy. If the system is running with performance in mind then the
high resolution clock source should be used, but when we need to save
energy we want to switch over to the more primitive clock source and
disable the hight resolution clock source to be able to enter deeper
sleep states.

It is unfortunately a bit difficult to fully tie the clock framework
to the clock event drivers today. The timer hardware that generates
clock events for us is driven by some clock managed by the clock
framework. We use clk_enable() and clk_disable() to dynamically gate
off the clock for the timer hardware. This gives us basic run time
power management - disabling the clock when the device is unused is a
must to be able to enter deep sleep states.

Anyway, the current clock event interface wants details such as clock
rate and delta values at registration time. The problem is that the
clock framework doesn't guarantee the clock rate to be stable until
the clock is enabled, and at the time the clock is registered the
clock is disabled. So we don't have that information at clock event
registration time. And even if we did - after resuming from SHUTDOWN
or UNUSED the clock rate and deltas may have changed so we need some
way to update these parameters if we want to integrate well with the
clock framework.

I hope this makes things a bit more clear. =)

/ magnus
