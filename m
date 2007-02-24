Return-Path: <linux-kernel-owner+w=401wt.eu-S1752231AbXBXFwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbXBXFwq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 00:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbXBXFwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 00:52:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49138
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752230AbXBXFwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 00:52:45 -0500
Date: Fri, 23 Feb 2007 21:52:44 -0800 (PST)
Message-Id: <20070223.215244.66361188.davem@davemloft.net>
To: johnstul@us.ibm.com
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, peter.keilty@hp.com
Subject: Re: sparc generic time / clockevents
From: David Miller <davem@davemloft.net>
In-Reply-To: <1172278407.6261.56.camel@localhost>
References: <1172260279.6261.20.camel@localhost>
	<20070223.163428.104033815.davem@davemloft.net>
	<1172278407.6261.56.camel@localhost>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: john stultz <johnstul@us.ibm.com>
Date: Fri, 23 Feb 2007 16:53:27 -0800

> On Fri, 2007-02-23 at 16:34 -0800, David Miller wrote:
> > +	.shift          = 16,
> > 
> > These shift selections all seem rather arbitrary.
> > 
> > If it's not an arbitrary selection, it would be nice to have some
> > comments about how to go about choosing an appropriate shift.
> > I imagine the selections has to do with the possible range of
> > the frequencies the clocksource supports, and how much
> > accuracy you get for certain shift selections given that range.
> 
> Correct. The higher the shift value, the more precise NTP multiplier
> adjustment we can make.  However, too large w/ a high frequency
> clocksource and you'll risk overflowing 64bits on the mult.
> 
> Although that's not super critical anymore since Roman implemented the
> high-res error accounting, the net effect should be the same over the
> long term(we just have to work harder w/ courser adjustments - resulting
> in very small clock frequency oscillations).

While we were discussing this I was debugging my clocksource sparc64
implementation, a shift of 32 didn't work whereas one of 16 (as
in your version of sparc64 support) did. :-)

There is also a very unfortunate inconsistency between how the shift
and multiplier are used in clock sources vs. clock events.

You can initialize your clocksource multiplier using:

	mult = clocksource_hz2mult(ticks_per_hz, SHIFT);

but WOE BE TO HE who tries to use that for clockevents (like I
did initially) :-)  You have to instead use something like:

	mult = div_sc(ticks_per_hz, NSEC_PER_SEC, SHIFT);

I would have been done with the sparc64 dynticks support yesterday if
I didn't trip over all this stuff.

It also isn't clear from the comments that the first argument
to clocksource_hz2mult() and div_sc() is indeed "ticks_per_hz".
I had to gleen over the hpet and LAPIC drivers to kind of figure
this out.  Another potential improvement for the comments :-)
