Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499Ab0CAQLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 11:11:15 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:41086 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311Ab0CAQLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 11:11:13 -0500
Message-ID: <0b055dc4810836e24ff21a776504142b.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <45a44e481002251830j710e87bah52486a489eef04cb@mail.gmail.com>
References: <201002252215.o1PMFnoP011425@mustang.cs.nmsu.edu>
    <45a44e481002251830j710e87bah52486a489eef04cb@mail.gmail.com>
Date: Mon, 1 Mar 2010 09:10:39 -0700
Subject: Re: [PATCH] Add sysfs support for fbdefio delay
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, npavel@ituner.com, tomi.valkeinen@nokia.com,
       tony@atomide.com, florianschandinat@gmx.de, krzysztof.h1@wp.pl,
       akpm@linux-foundation.org, linux-fbdev@vger.kernel.org, jkosina@suse.cz,
       bonbons@linux-vserver.org
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaya Kumar wrote:
> Hi Rick,
>
> On Fri, Feb 26, 2010 at 6:15 AM, Rick L. Vinyard Jr.
> <rvinyard@cs.nmsu.edu> wrote:
>> This patch adds support for examining and modifying the fbdefio delay
>> parameter through sysfs. It also adds two driver definable minimum
>> and maximum bounds.
>
> Thanks for posting this. I've now read through this patch and your
> past patches, but I couldn't get a good understanding of how this
> userspace exposed defio delay would interact with most existing
> systems.
>
>> +               Set the deferred I/O delay of the framebuffer in ms.
>> +               This value can be used to throttle deferred I/O updates.
>
> Please help us understand how userspace should use the ability to set
> this delay.

I think that there isn't one specific answer since, just like the approach
to priority of processes there isn't one specific answer. The real answer
is: it depends.

Bruno has already provided some feedback on his driver so I'll add a few
comments on what motivated it for the G13.

One of the factors I was concerned about was having two or more G13
devices on the same bus with other traffic. Each frame is sent as an
interrupt transfer out, and I was concerned that the framebuffer updates
might be detrimental to other traffic.

I know that a pair of G13 devices running at 30 FPS would only consume
about 5% of the USB 1.1 bandwidth (~500 Mbit/s) for framebuffer transfers
(sans headers and other control messages), but I was concerned that it
could introduce enough latency to make other devices laggy.

There is a bit of translation that has to go on for each framebuffer as
well. The G13 doesn't use the traditional bitwise layout where 0,0 is the
high bit of the first byte and 7,0 is the low bit of the first byte. The
format the G13 expects is 0,0 in the high bit and 0,7 in the low bit.

As a result of this translation, I was concerned with the driver consuming
too much CPU time when doing multiple translations for multiple devices...
or even one translation on a limited or saturated CPU at a high frame
rate.

Extending this beyond the simple case of the G13, I think it could be
useful for any deferred framebuffer that consumes a limited critical
resource, whether it be USB bandwidth, CPU usage, or some other resource.

One driver in particular that I noticed is the xen-fbfront. The update
rate is set at 20FPS, but what if someone wanted 30 FPS?

> Who in userspace is intended to use it? Would this be the
> X server, cairo, or papyrus? A separate daemon? Human interaction?

Again, that has the same issue as who sets priority on processes... It
depends.

As for the G13 I was planning, for the current time, on putting a slider
in the configuration window that allowed the user to modify the update
rate. The slider would populate off the sysfs values.

I think it would be an interesting possibility to develop a daemon that
watched traffic on buses with USB devices that could be throttled and
throttle them according to bus saturation.

However, at this point I wasn't planning on going there. But, having the
ability to throttle would be a key point for developing such daemons.

> When should said userspace entity throttle updates? How would this
> entity know when throttling is needed? Could this throttling possibly
> or should this possibly be done automatically by the driver itself?
>

I don't think it should be incorporated into the driver because I believe
most circumstances will involve factors outside the purview of the driver,
such as bandwidth utilization. One factor could be rather subjective, like
'laggy'. What is 'laggy' to one user may not be to another.

>> +               Most framebuffer devices do not have or need support for
>> +               deferred I/O. Accessing a framebuffer without deferred
>> I/O
>> +               support will return -ENODEV. Can be read but not
>> modified if
>> +               /sys/class/graphics/<fb>/defio_delay_max is 0. When
>> modifying,
>> +               the value must be greater than or equal to
>> +               /sys/class/graphics/<fb>/defio_delay_min and less than
>> or equal
>> +               to /sys/class/graphics/<fb>/defio_delay_max.
>
> Please help the reader of above understand the sequence of userspace
> changing the defio delay, and how and when that would affect the
> associated drivers. Will the delay behaviour be standard for all defio
> client drivers? What happens in all the various timing scenarios, eg:
> if a defio delay is changed in the middle of a display update or a
> defio page clean or before?

I think this could be taken care of by explaining that the parameter will
only effect the next queued framebuffer update. But, it should definitely
be in there.

> The sysfs parameter description mentioning
> min/max above could use some elaboration as reading it doesn't make
> clear if userspace can also affect min/max or if it is completely
> owned by the driver.
>

I can add that as well.

> Thanks,
> jaya
>
> ps: I only found your patches by accident when reading through the
> fbdev mailing list. I'm very interested in defio (I happen to be the
> author of it) and also drivers that use defio so I would appreciate
> being CCed on such changes. Thanks a bunch.
>

No problem. I didn't mean to leave you out.

-- 

Rick

