Return-Path: <linux-kernel-owner+w=401wt.eu-S1757920AbXGIExR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920AbXGIExR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 00:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbXGIExH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 00:53:07 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:7666 "EHLO
	asav07.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbXGIExF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 00:53:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkZAAhckUZKhRO4R2dsb2JhbACBTIVdiAQBARsNBhEB
From: Dmitry Torokhov <dtor@insightbb.com>
To: Shem Multinymous <multinymous@gmail.com>
Subject: Re: [Hdaps-devel] [PATCH] hdaps - switch to using input-polldev
Date: Mon, 9 Jul 2007 00:53:02 -0400
User-Agent: KMail/1.9.3
Cc: hdaps-devel@lists.sourceforge.net, rlove@rlove.org,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Michael Riepe <michael@mr511.de>,
       Henrique de Moraes Holschuh <hmh@debian.org>
References: <200705252354.43730.dtor@insightbb.com> <200707082324.11315.dtor@insightbb.com> <41840b750707082131n66382908o94790ac608bbf775@mail.gmail.com>
In-Reply-To: <41840b750707082131n66382908o94790ac608bbf775@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707090053.03228.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 July 2007 00:31, Shem Multinymous wrote:
> Hi Dmitry,
> 
> On 7/8/07, Dmitry Torokhov <dtor@insightbb.com> wrote:
> > > First, the hdaps driver regularly polls the embedded controller, which
> > > in turns regularly polls the hardware. If the two polling rates differ
> > > or fluctuate, we lose events.
> >
> > That was the case with the original driver as well bit instead of
> > rearming workqueue it was using rearming timer.
> 
> Right. Doesn't the latter result in more regular scheduling?
>

Probably.
 
> 
> > > AFAICT, the delayed workqueues used by
> > > input-polldev can get very laggy under load. That's very bad for
> > > sensitive clients like hdapsd (the hard disk shock protection daemon).
> > >
> >
> > input-polldev uses a separate workqueue, not keventd, and so should not
> > suffer from other workqueue users loading keventd. But if entire box
> > is under stress then workqueue vs timer context does not matter much -
> > your daemon which is in userspace may not get to run in a timely manner
> > anyway.
> 
> The daemon itself typically runs with a higher priority (and sleeps a
> lot so it gets further dumped). More importantly, the daemon depends
> not only on the latest measurement, but also on recent measurements
> have been obtained from the hardware in a regular fashion and with
> reasonably accurate timestamps. And *this* depends solely on the hdaps
> driver.
>

Every input event carries a timestamp so even if there are irregularities
in taking the samples you should be able to account for it. 

> 
> > However I am open to bumping up priority of ipolldevd a little.
> 
> Will this result in scheduling tha'ts as reliable as rearming timers
> from softirq? I saw claims to the contrary, but it it's true then I
> withdraw the first objection.

Probably not. But I still think that if system is so busy that it can't
get aroung to schedule one of workqueues it will not be able to part
the driver fast enough anyway.

> 
> > > Second, this is incompatible with the much-needed addition of a 2nd
> > > input device relying on the same data. The existing hdaps input device
> > > does "joystick emulation", i.e., reports values after calibration and
> > > fuzzing. Userspace programs that need the raw data, like hdapsd,
> > > currently have to poll the sysfs attribute, which is inefficient,
> > > lag-prone and induces unnecessary interrupts on tickless sytems. To
> > > solve this we'll have to add a 2nd input device to hdaps, for
> > > reporting the raw accelerometer data. (Michael Riepe and me are now
> > > working on such a patch.) But these two input devices need to share
> > > their polling of the underlying EC hardware, and this is impossible
> > > using input-polldev.
> >
> > I am curious why you can't use the current device, since the calibration
> > done in hdaps does not alter the scale but merely moves '0' point around.
> > And fuzz should only remove small jitters, not rapidly changing data
> > that you shoudl get when your box is falling.
> 
> Recent versions of the hdapsd daemons do much more than a simple
> threshold check: they gather some 2nd-order and decaying averages
> statistics to catch subtle abnormal movement (e.g., sliding off a
> surface) that's indicative of potential shock. As pointed out in IBM's
> HDAPS whitepaper, by the time the box is actually in free fall, it's
> too late to start parking the heads. Now, that kind of movement is not
> very far from the noise floor, so hdapsd needs all the accuracy it can
> get -- hence fuzzing is very disruptive. Calibration is currently
> harmless, but I can certainly imagine more advanced hdapsd that uses
> heuristics based, e.g., on the absolute orientation of the laptop, so
> let's not ruin this data.

If hdaps is the main consumer for the data it may be a good idea to
just remove the fuzz setting from input device. I don't have the hardware,
how bad is it without fuzz?

> 
> 
> > However nothing stops you from generating events for the 2nd input
> > device from the same polling function that generates events for the
> > first device.
> 
> You could one input device open, or the other, or both. How would you
> set up input-polldev to handle this?
> 

Have 2nd input device's ->open() method call input_open_device() for
the first one.

> 
> > > As for the mutex in atomic context issue, isn't it best addressed by
> > > making mutex_trylock() do the sensible thing in softirqt?
> 
> BTW, I think that's worth fixing in any case.
> 
>   Shem
> 

-- 
Dmitry
