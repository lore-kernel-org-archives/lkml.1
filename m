Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbYBYOoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbYBYOoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 09:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbYBYOoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 09:44:01 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:59419 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419AbYBYOoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 09:44:00 -0500
Date: Mon, 25 Feb 2008 15:44:57 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: john stultz <johnstul@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] correct inconsistent ntp interval/tick_length usage
In-Reply-To: <1203647951.6150.80.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0802251416340.2723@scrub.home>
References: <1201142334.6383.40.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0801251349120.17507@scrub.home>  <1201573686.6766.13.camel@localhost>
  <Pine.LNX.4.64.0801290439480.17507@scrub.home>  <1201659263.6766.40.camel@localhost>
  <Pine.LNX.4.64.0801310251090.17507@scrub.home>  <1201745776.6195.14.camel@localhost.localdomain>
  <Pine.LNX.4.64.0801310404480.17507@scrub.home>  <1201914175.6216.46.camel@jstultz-laptop>
  <Pine.LNX.4.64.0802081718040.3378@scrub.home>  <1202523452.6174.45.camel@localhost.localdomain>
  <Pine.LNX.4.64.0802101917030.3378@scrub.home>  <1202774999.5984.106.camel@localhost>
  <Pine.LNX.4.64.0802120335170.3378@scrub.home>  <1202963796.6195.141.camel@localhost.localdomain>
  <Pine.LNX.4.64.0802150436300.1822@scrub.home>  <1203382940.5984.242.camel@localhost>
  <Pine.LNX.4.64.0802190219360.2723@scrub.home>  <1203472250.6123.98.camel@localhost>
  <Pine.LNX.4.64.0802200348230.2723@scrub.home> <1203647951.6150.80.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 21 Feb 2008, john stultz wrote:

> > Again, what kind of crappy hardware do you expect? Aren't clocks supposed 
> > to get better and not worse?
> 
> Well, while I've seen much worse, I consider crappy hardware to be 100
> +ppm error. So if the hardware is perfect and the system results in
> 153ppm error, I'd consider that pretty crappy, especially if its not the
> hardware's fault.

Nevertheless this error is real, why are you trying to hide it?
This is isn't an error we can't handle, it's still perfectly within the 
limit and except that NTP reports a somewhat larger drift than you'd like 
to see, everything works fine.

> > Where do you get this idea that the 500ppm are exclusively for hardware 
> > errors? If you have such bad hardware, there is another simple solution: 
> > change HZ to 100 and the error is reduced to 15ppm.
> 
> True its not exclusively for hardware errors, and if we were talking
> about only 15ppm I wouldn't really worry about it. But when we're saying
> the system is adding 30% of the maximum error, that's just not good.

Another 30% is required for normal to crappy hardware clocks and then 
there is still enough room left.

> > I would see the point if this problem had actually any practically 
> > relevance, but this error is not a problem for pretty much all existing 
> > standard hardware. Why are you insisting on redesigning timekeeping for 
> > broken hardware?
> 
> Remember my earlier data? Where I was talking about the acpi_pm being a
> multiple of the PIT frequency? By removing CLOCK_TICK_ADJUST we got a
> 127ppm error when HZ=1000. NO_HZ drops that down to where we don't care,
> but this _does_ effect current hardware, so I'd call it relevant.

How exactly does it effect current hardware in a way that it breaks them? 
Despite this error everything still works fine, the hardware doesn't care.

> > There's nothing 'injected', that resolution error is very real and the 
> > 500ppm limit is more than enough to deal with this. _Nobody_ is hurt by 
> > this.
> 
> Sure, 500ppm is enough for most people with good hardware. But remember
> the alpha example you brought up earlier? The HZ=1200 case, with the
> CLOCK_TICK_RATE=32768? If we don't take CLOCK_TICK_ADJUST into account,
> we end up with a **11230ppm** error from the granularity issue. NTP just
> won't work on those systems.
> 
> Now granted, the three types of alpha systems that actually use that HZ
> value is probably as close to "nobody" as you're going to get, but I
> don't think we can just throw the granularity issue aside.

That's actually a good example, why it's irrelevant. First it's using a 
cycle based clock, thus the rounding error is irrelevant. Second in the 
common case they already use 1024 as HZ to reduce this error, so something 
similiar could be done for the HZ=1200 case and I suspect that it was 
already done and only CLOCK_TICK_RATE is just wrong. This mail 
http://consortiumlibrary.org/axp-list/archive/2002-11/0101.html suggest 
that this is the right thing to do.

There is _no_ reason to artificially optimize this error value, there are 
still enough other ways to improve timekeeping. The granularity error is 
there no matter what you do and as long as it's within a reasonable limit 
there is nothing that needs fixing.

bye, Roman
