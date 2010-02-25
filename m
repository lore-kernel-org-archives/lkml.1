Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356Ab0BYPfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:35:07 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:41008 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759190Ab0BYPfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:35:05 -0500
Message-ID: <7316226fbd1cb53b7f90965c54acd343.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <alpine.LNX.2.00.1002251157500.30967@pobox.suse.cz>
References: <20100221002001.0a7e05a7@neptune.home>
    <20100224170049.0d04af3c@neptune.home>
    <201002241927.53532.oliver@neukum.org>
    <ffb352764fc5a0da5cca6f3da7fc2603.squirrel@intranet.cs.nmsu.edu>
    <alpine.LNX.2.00.1002251157500.30967@pobox.suse.cz>
Date: Thu, 25 Feb 2010 08:34:42 -0700
Subject: Re: [PATCH 1/3] picolcd: driver for PicoLCD HID device
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Jiri Kosina" <jkosina@suse.cz>
Cc: "Oliver Neukum" <oliver@neukum.org>,
       Bruno =?iso-8859-1?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
       linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Nicu Pavel" <npavel@ituner.com>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Wed, 24 Feb 2010, Rick L. Vinyard, Jr. wrote:
>
>> The key difference is the replacement of spin_lock() with spin_trylock()
>> such that if the non-interrupt code has already obtained the lock, the
>> interrupt will not deadlock but instead take the else path and schedule
>> a
>> framebuffer update at the next interval.
>
> Why is _irqsave() and/or deferred work not enough? The aproach with
> _trylock() seems to be overly complicated for no good reason (I personally
> become very suspicious every time I see code that is using _trylock()).
>

I was concerned about _irqsave() because the lock is split across two
functions to protect the urb after it is handed off to the usb subsystem
with usb_submit_urb(). It's locked in g13_fb_send() and unlocked in the
urb completion callback.

As for deferred work, the g13_fb_send() is the I/O portion of the deferred
framebuffer callback. I was concerned that without a lock one deferred
update could hand the urb off to the usb subsystem and a second could try
to access it before it was handed back to the driver.

In this case the _trylock() would fail and in the else patch we would
defer yet again until the next update cycle.

I took this approach because usb_interrupt_msg() couldn't be used from an
interrupt context, such as a resume hook because eventually down the chain
it does a wait_for_completion_timeout().

It has the added benefit of reusing the urb instead of creating a new one
for each framebuffer sent out, but that wasn't a reason... just a side
effect.

The downside is that I had to manage the urb.

One thing I could do is forget about directly calling g13_fb_send() from
any context and instead use the deferred framebuffer workqueue.

That's probably a simpler approach anyway.

> [ by the way, Rick, are you planning to resubmit the G13 driver with
> incorporated feedback from the last review round? ]
>

Yes. I just wanted to get the details of suspend/resume worked out before
resubmitting.

-- 

Rick

