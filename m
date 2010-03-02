Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab0CBPhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 10:37:22 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:50947 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab0CBPhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 10:37:20 -0500
Message-ID: <84774cde4a948cb726db3bfcb463a04c.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <45a44e481003012249p6970d442o593af7d4971f0183@mail.gmail.com>
References: <201002252215.o1PMFnoP011425@mustang.cs.nmsu.edu>
    <45a44e481002251830j710e87bah52486a489eef04cb@mail.gmail.com>
    <0b055dc4810836e24ff21a776504142b.squirrel@intranet.cs.nmsu.edu>
    <45a44e481003012249p6970d442o593af7d4971f0183@mail.gmail.com>
Date: Tue, 2 Mar 2010 08:36:54 -0700
Subject: Re: [PATCH] Add sysfs support for fbdefio delay
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, npavel@ituner.com, tomi.valkeinen@nokia.com,
       tony@atomide.com, florianschandinat@gmx.de, krzysztof.h1@wp.pl,
       akpm@linux-foundation.org, linux-fbdev@vger.kernel.org, jkosina@suse.cz,
       bonbons@linux-vserver.org
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jaya Kumar wrote:
> On Tue, Mar 2, 2010 at 12:10 AM, Rick L. Vinyard, Jr.
> <rvinyard@cs.nmsu.edu> wrote:
>> Jaya Kumar wrote:
>>> Hi Rick,
>>>
>>> On Fri, Feb 26, 2010 at 6:15 AM, Rick L. Vinyard Jr.
>>> <rvinyard@cs.nmsu.edu> wrote:
>>>
>>>> +               Set the deferred I/O delay of the framebuffer in ms.
>>>> +               This value can be used to throttle deferred I/O
>>>> updates.
>>>
>>> Please help us understand how userspace should use the ability to set
>>> this delay.
>>
>> I think that there isn't one specific answer since, just like the
>> approach
>> to priority of processes there isn't one specific answer. The real
>> answer
>> is: it depends.
>
> Rick,
>
> Thanks for your reply.
>
>>
>> One of the factors I was concerned about was having two or more G13
>> devices on the same bus with other traffic. Each frame is sent as an
>> interrupt transfer out, and I was concerned that the framebuffer updates
>> might be detrimental to other traffic.
>>
>> I know that a pair of G13 devices running at 30 FPS would only consume
>> about 5% of the USB 1.1 bandwidth (~500 Mbit/s) for framebuffer
>> transfers
>> (sans headers and other control messages), but I was concerned that it
>> could introduce enough latency to make other devices laggy.
>
> You mentioned in your responses and above that you're concerned about
> saturating the USB bus and lagginess, and I think it is good to have
> those concerns. Defio delay may be an easy parameter to expose, and in
> at least a specific set of drivers, changing it would have a
> meaningful effect on bus utilization, but are you convinced that
> exposing it generally (remember your patch makes it apply to all fb
> drivers) to userspace is a right way or even a good way to address bus
> saturation concerns?
>
>> As a result of this translation, I was concerned with the driver
>> consuming
>> too much CPU time when doing multiple translations for multiple
>> devices...
>> or even one translation on a limited or saturated CPU at a high frame
>> rate.
>
> Being concerned about CPU utilization is a good thing. But say for
> example, your USB ethernet driver or USB audio driver is taking a lot
> of cpu time packetizing traffic, then would I be correct that your
> desire is to expose an inter-packetization driver specific sleep time
> controllable by userspace via sysfs for all ethernet, audio, etc
> drivers? (by driver specific, I mean the sysfs parameter would be
> presented by all drivers but the value would be specific to each one,
> which is the way your current patch would behave for all fb drivers).
>

I think the answer is yes, whether this were a fb, network, audio, etc. If
there is a clearly defined parameter at which resource utilization can be
adjusted in a standard way.

Although the value is specific to each one, the min/max parameters provide
the bounds and standardized units, allowing userspace to modify the delay
parameter in a standardized way.

I also tried to make it where the driver had to explicitly modify the
min/max parameters so that unless a driver sets min/max values the delay
parameter can be examined from userspace but not modified.

I agree that the motivation for throttling varies by device, and even as
in this case there could be different motivations for the same device (USB
bus bandwidth and/or CPU utilization).

I think that what also distinguishes the fbdefio case is the fact that
there is a single defined point at which resource utilization would be
throttled and that's the fb_deferred_io structure's deferred_io hook.

>> I think it would be an interesting possibility to develop a daemon that
>> watched traffic on buses with USB devices that could be throttled and
>> throttle them according to bus saturation.
>>
>> However, at this point I wasn't planning on going there. But, having the
>> ability to throttle would be a key point for developing such daemons.
>
> Just curious, do such sysfs throttling parameters exist for any other
> subsystems? If so, are userspace apps/services using them, and are
> they happy with it?

An example of something like this is the ACPI CPU thermal class. It
provides two parameters, cur_state and max_state. The minimum is presumed
to be 0.

In this case though, I think fbdefio needs to provide both a min and a max
as a driver may want to set the minimum refresh rate to be non-zero.

Another example would be the CPU frequency subsystem, and in particular
the userspace governor. There are similar sysfs attributes for obtaining
the current frequency, setting the frequency, and obtaining the min/max
frequencies.

In particular they used:
     scaling_cur_freq (ro)
     scaling_min_freq (ro)
     scaling_max_freq (ro)
     scaling_setspeed (wo)

I used a single read/write attribute for read/write on the delay instead
of the two parameter approach used for frequencies. I used:
     defio_delay     (rw)
     defio_delay_min (ro)
     defio_delay_max (ro)

But, it wouldn't be hard to use an analogous set like:
     defio_cur_delay (ro)
     defio_min_delay (ro)
     defio_max_delay (ro)
     defio_set_delay (wo)

-- 

Rick

