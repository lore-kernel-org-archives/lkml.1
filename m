Return-Path: <linux-kernel-owner+w=401wt.eu-S1760833AbXHCS7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760833AbXHCS7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 14:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbXHCS7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 14:59:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:45603 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbXHCS7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 14:59:32 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: trenn@suse.de
Subject: Re: 2.6.22 regression: thermal trip points
Date: Fri, 3 Aug 2007 14:59:06 -0400
User-Agent: KMail/1.9.5
Cc: Andi Kleen <andi@firstfloor.org>, Pavel Machek <pavel@ucw.cz>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org
References: <46B1988C.3090302@t-online.de> <20070802183830.GA4192@one.firstfloor.org> <1186139818.18821.590.camel@queen.suse.de>
In-Reply-To: <1186139818.18821.590.camel@queen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708031459.07108.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 August 2007 07:16, Thomas Renninger wrote:
> On Thu, 2007-08-02 at 20:38 +0200, Andi Kleen wrote:
> > On Thu, Aug 02, 2007 at 03:57:54PM +0000, Pavel Machek wrote:
> > > On Thu 2007-08-02 15:16:22, Andi Kleen wrote:
> > > > On Thu, Aug 02, 2007 at 02:04:42PM +0100, Alan Cox wrote:
> > > > > > > Set a taint flag, 
> > > > > > That's hardly any useful if the machine is dead afterwards.
> > > > > 
> > > > > It won't be the hardware will do a failsafe shutdown first.
> > > > 
> > > > Not necessarily. At SUSE we had at least one broken laptop
> > > > with wrong trip points. The machine ran very hot for some time
> > > > and afterwards the hard disk was dead.
> > > 
> > > Yes, but it was original BIOS trip points that were wrong. And yes,
> > > its failsafe shutdown was too late. At least lowering the trip points
> > > would allow me to run it safely.
> > 
> > I have no problem with lowering them (in fact I proposed this
> > to Thomas as a possible solution at some point). Just rising 
> > is a bad idea.
> 
> Ok.
> If nobody screams (especially Len who has to accept this in the end, I
> don't want to do work for nothing..), I'll try an implementation that:
>   - Allows lowering trip points
>   - If BIOS modifies trip points, the overridden ones might also
>     get lowered if they are even lower
>   - Allow the definition of a passive trip point (with some default
>     values for hysteresis), even if the thermal zone does not
>     provide one
> 
> If we have something like this, we could still discuss a config option,
> that also allows to increase trip points, marking it with "If you set
> this you can destroy your machine, you have been warned...". While this
> would not be an option for distributions to compile in, some people may
> come around the biggest hammer -> overriding DSDT.
> 
> I cannot promise, but I try to get this for 2.6.24.

I think if you are enamored with overriding trip points at SuSE,
that you should simply restore the original scheme as the "value add"
for SuSE kernels.  Seriously, I'm totally fine with that.

You should be aware, however, that (one of) the fundamental flaws
with that scheme, shared with what you describe above, is that the OS
can not actually change the trip points in the thermal sensor.
The sensor is going to trip at the temperature that _it_ thinks
the trip point is at -- not the trip point that you are letting
the user think it is at.  Ie. what is advertised as a trip-point
override actually defeats the entire concept of trip-points,
and it is mandatory that you enable periodic polling of the
current temperature to compare with your new thresholds
to work-around that.

This faking out the user, plus the fact that the BIOS does change
trip-points at run-time, made the original scheme fundamentally
unsound.  Further, I've not yet found a single system where use
of this scheme wasn't papering over some other problem.  For the
upstream kernel, I think it is more appropriate to expose and fix
the fundamental problems.  For distro kernels, I'm less concerned
if you hide bugs instead of fixing them.

We had quite a long discussion when I deleted the trip-point-override
scheme in -mm.  Then it rode through the entire 2.6.22 release cycle.
However, I have yet to see a single bug report filed that has shown
that Linux should be doing this, or something like it.  I'm hopeful
that Knut's or Adrian's will be the first -- but I'm still waiting.

-Len
