Return-Path: <linux-kernel-owner+w=401wt.eu-S1752757AbXGIFo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbXGIFo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 01:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbXGIFos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 01:44:48 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:35169 "EHLO
	asav13.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbXGIFor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 01:44:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkZALBokUZKhRO4R2dsb2JhbACBTIVdiAQBARsNBhEB
From: Dmitry Torokhov <dtor@insightbb.com>
To: Shem Multinymous <multinymous@gmail.com>
Subject: Re: [Hdaps-devel] [PATCH] hdaps - switch to using input-polldev
Date: Mon, 9 Jul 2007 01:44:43 -0400
User-Agent: KMail/1.9.3
Cc: hdaps-devel@lists.sourceforge.net, rlove@rlove.org,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Michael Riepe <michael@mr511.de>,
       Henrique de Moraes Holschuh <hmh@debian.org>
References: <200705252354.43730.dtor@insightbb.com> <200707090053.03228.dtor@insightbb.com> <41840b750707082229k7672ef8bma050289d3cde93ee@mail.gmail.com>
In-Reply-To: <41840b750707082229k7672ef8bma050289d3cde93ee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707090144.45557.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 July 2007 01:29, Shem Multinymous wrote:
> On 7/9/07, Dmitry Torokhov <dtor@insightbb.com> wrote:
> > > > input-polldev uses a separate workqueue, not keventd, and so should not
> > > > suffer from other workqueue users loading keventd. But if entire box
> > > > is under stress then workqueue vs timer context does not matter much -
> > > > your daemon which is in userspace may not get to run in a timely manner
> > > > anyway.
> > >
> > > The daemon itself typically runs with a higher priority (and sleeps a
> > > lot so it gets further dumped). More importantly, the daemon depends
> > > not only on the latest measurement, but also on recent measurements
> > > have been obtained from the hardware in a regular fashion and with
> > > reasonably accurate timestamps. And *this* depends solely on the hdaps
> > > driver.
> > >
> >
> > Every input event carries a timestamp so even if there are irregularities
> > in taking the samples you should be able to account for it.
> 
> The issue is how good are the input event timestamps. The way it works
> is that the EC samples the analog sensor at some fixed rate and makes
> them available over the LPC bus. If the hdaps driver consumes these
> samples at the same rate then the timestamps will be accurate up to a
> small phase difference, which is mostly inconsequential. But if the
> hdaps driver gets scheduled irregularly, its timestamps will be offset
> by varying amounts, which will completely throw off computation (e.g.,
> think of estimating the angular velocity).
>

Timers do not guarantee you that they will be fired at the exact time.
If system is under load and there are hard IRQs they will also be
delayed.

> 
> > > > However I am open to bumping up priority of ipolldevd a little.
> > >
> > > Will this result in scheduling tha'ts as reliable as rearming timers
> > > from softirq? I saw claims to the contrary, but it it's true then I
> > > withdraw the first objection.
> >
> > Probably not. But I still think that if system is so busy that it can't
> > get aroung to schedule one of workqueues it will not be able to part
> > the driver fast enough anyway.
> 
> A delay of 20ms in invoking the userspace daemon is negligible, but a
> timing variance of 20ms in the driver's measurements is devastating.
>

Even if you know that there is such variance?
 
> 
> > > > I am curious why you can't use the current device, since the calibration
> > > > done in hdaps does not alter the scale but merely moves '0' point around.
> > > > And fuzz should only remove small jitters, not rapidly changing data
> > > > that you shoudl get when your box is falling.
> > >
> > > Recent versions of the hdapsd daemons do much more than a simple
> > > threshold check: they gather some 2nd-order and decaying averages
> > > statistics to catch subtle abnormal movement (e.g., sliding off a
> > > surface) that's indicative of potential shock. As pointed out in IBM's
> > > HDAPS whitepaper, by the time the box is actually in free fall, it's
> > > too late to start parking the heads. Now, that kind of movement is not
> > > very far from the noise floor, so hdapsd needs all the accuracy it can
> > > get -- hence fuzzing is very disruptive. Calibration is currently
> > > harmless, but I can certainly imagine more advanced hdapsd that uses
> > > heuristics based, e.g., on the absolute orientation of the laptop, so
> > > let's not ruin this data.
> >
> > If hdaps is the main consumer for the data it may be a good idea to
> > just remove the fuzz setting from input device. I don't have the hardware,
> > how bad is it without fuzz?
> 
> People are using the existing input device as a joystick input for
> things like Neverball. Current fuzz is 4 and the observed std dev is
> roughly 2, so eliminating fuzz will certainly affect the values. The
> implications are app-specific, but I guess some apps do care about
> such noise, otherwise we wouldn't have fuzz built into the input
> infrastructure.
>

OK.
 
> 
> > > You could one input device open, or the other, or both. How would you
> > > set up input-polldev to handle this?
> >
> > Have 2nd input device's ->open() method call input_open_device() for
> > the first one.
> 
> Won't that create an overhead by the redundant, unused notifications?
> 

They won't leave input core so nothing really noticeable.


>   Shem
> 

-- 
Dmitry
