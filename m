Return-Path: <linux-kernel-owner+w=401wt.eu-S1752063AbXGIF31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbXGIF31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 01:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbXGIF3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 01:29:20 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:40054 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbXGIF3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 01:29:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OOqGzYUwN0Z3YLfyNLJDEgrss4HWoz0jnGHWguOYUr34QHtDTS/K6olHjtgPWltbHdFAsAxBLXUlxs3JvzPA2msjOE+UTlvLlL3f2fgVp09houab5gAPDvfu9NfqkehIiv+idneWCII15mPfjap5BaXoa6PK+qeaECy072LKR/0=
Message-ID: <41840b750707082229k7672ef8bma050289d3cde93ee@mail.gmail.com>
Date: Mon, 9 Jul 2007 01:29:18 -0400
From: "Shem Multinymous" <multinymous@gmail.com>
To: "Dmitry Torokhov" <dtor@insightbb.com>
Subject: Re: [Hdaps-devel] [PATCH] hdaps - switch to using input-polldev
Cc: hdaps-devel@lists.sourceforge.net, rlove@rlove.org,
       "Linux Kernel ML" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, "Michael Riepe" <michael@mr511.de>,
       "Henrique de Moraes Holschuh" <hmh@debian.org>
In-Reply-To: <200707090053.03228.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705252354.43730.dtor@insightbb.com>
	 <200707082324.11315.dtor@insightbb.com>
	 <41840b750707082131n66382908o94790ac608bbf775@mail.gmail.com>
	 <200707090053.03228.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/9/07, Dmitry Torokhov <dtor@insightbb.com> wrote:
> > > input-polldev uses a separate workqueue, not keventd, and so should not
> > > suffer from other workqueue users loading keventd. But if entire box
> > > is under stress then workqueue vs timer context does not matter much -
> > > your daemon which is in userspace may not get to run in a timely manner
> > > anyway.
> >
> > The daemon itself typically runs with a higher priority (and sleeps a
> > lot so it gets further dumped). More importantly, the daemon depends
> > not only on the latest measurement, but also on recent measurements
> > have been obtained from the hardware in a regular fashion and with
> > reasonably accurate timestamps. And *this* depends solely on the hdaps
> > driver.
> >
>
> Every input event carries a timestamp so even if there are irregularities
> in taking the samples you should be able to account for it.

The issue is how good are the input event timestamps. The way it works
is that the EC samples the analog sensor at some fixed rate and makes
them available over the LPC bus. If the hdaps driver consumes these
samples at the same rate then the timestamps will be accurate up to a
small phase difference, which is mostly inconsequential. But if the
hdaps driver gets scheduled irregularly, its timestamps will be offset
by varying amounts, which will completely throw off computation (e.g.,
think of estimating the angular velocity).


> > > However I am open to bumping up priority of ipolldevd a little.
> >
> > Will this result in scheduling tha'ts as reliable as rearming timers
> > from softirq? I saw claims to the contrary, but it it's true then I
> > withdraw the first objection.
>
> Probably not. But I still think that if system is so busy that it can't
> get aroung to schedule one of workqueues it will not be able to part
> the driver fast enough anyway.

A delay of 20ms in invoking the userspace daemon is negligible, but a
timing variance of 20ms in the driver's measurements is devastating.


> > > I am curious why you can't use the current device, since the calibration
> > > done in hdaps does not alter the scale but merely moves '0' point around.
> > > And fuzz should only remove small jitters, not rapidly changing data
> > > that you shoudl get when your box is falling.
> >
> > Recent versions of the hdapsd daemons do much more than a simple
> > threshold check: they gather some 2nd-order and decaying averages
> > statistics to catch subtle abnormal movement (e.g., sliding off a
> > surface) that's indicative of potential shock. As pointed out in IBM's
> > HDAPS whitepaper, by the time the box is actually in free fall, it's
> > too late to start parking the heads. Now, that kind of movement is not
> > very far from the noise floor, so hdapsd needs all the accuracy it can
> > get -- hence fuzzing is very disruptive. Calibration is currently
> > harmless, but I can certainly imagine more advanced hdapsd that uses
> > heuristics based, e.g., on the absolute orientation of the laptop, so
> > let's not ruin this data.
>
> If hdaps is the main consumer for the data it may be a good idea to
> just remove the fuzz setting from input device. I don't have the hardware,
> how bad is it without fuzz?

People are using the existing input device as a joystick input for
things like Neverball. Current fuzz is 4 and the observed std dev is
roughly 2, so eliminating fuzz will certainly affect the values. The
implications are app-specific, but I guess some apps do care about
such noise, otherwise we wouldn't have fuzz built into the input
infrastructure.


> > You could one input device open, or the other, or both. How would you
> > set up input-polldev to handle this?
>
> Have 2nd input device's ->open() method call input_open_device() for
> the first one.

Won't that create an overhead by the redundant, unused notifications?

  Shem
