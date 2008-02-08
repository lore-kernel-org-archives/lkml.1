Return-Path: <linux-kernel-owner+w=401wt.eu-S1763673AbYBHRgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763673AbYBHRgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 12:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758349AbYBHRgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 12:36:41 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:2465 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbYBHRgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 12:36:40 -0500
Date: Fri, 8 Feb 2008 18:33:20 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: John Stultz <johnstul@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] correct inconsistent ntp interval/tick_length usage
In-Reply-To: <1201914175.6216.46.camel@jstultz-laptop>
Message-ID: <Pine.LNX.4.64.0802081718040.3378@scrub.home>
References: <1201142334.6383.40.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0801251349120.17507@scrub.home>  <1201573686.6766.13.camel@localhost>
  <Pine.LNX.4.64.0801290439480.17507@scrub.home>  <1201659263.6766.40.camel@localhost>
  <Pine.LNX.4.64.0801310251090.17507@scrub.home>  <1201745776.6195.14.camel@localhost.localdomain>
  <Pine.LNX.4.64.0801310404480.17507@scrub.home> <1201914175.6216.46.camel@jstultz-laptop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 1 Feb 2008, John Stultz wrote:

> > CLOCK_TICK_ADJUST is based on LATCH and HZ, if the update frequency isn't 
> > based on HZ, there is no point in using it!
> 
> Hey Roman,
> 
> Again, I'm sorry I don't seem to be following your objections. If you
> want to suggest a different patch to fix the issue, it might help.

I already gave you the necessary details for how to set 
NTP_INTERVAL_LENGTH and in the previous mail I explained the basis for it. 
I really don't understand what's your problem with it. Why do you try to 
make it more complex than necessary?

> The big issue for me, is that we have to initialize the clocksource
> cycle interval so it matches the base tick_length that NTP uses.
> 
> To be clear, the issue I'm trying to address is only this:
> Assuming there is no NTP adjustment yet to be made, if we initialize the
> clocksource interval to X, then compare it with Y when we accumulate, we
> introduce error if X and Y are not the same.
> 
> It really doesn't matter how long the length is, if we're including
> CLOCK_TICK_ADJUST, or if it really matches the actual HZ tick length or
> not. The issue is that we have to be consistent. If we're not, then we
> introduce error that ntpd has to additionally correct for.

You don't create consistency by adding corrections all over the place 
until it adds up to the right sum.
The current correction is already somewhat of a hack and I'd rather get 
rid of it than to let it spread all over the place (it's really only 
needed so that people with weird HZ settings don't hit the 500ppm limit 
and we're basically cheating to the ntpd by not telling it the real 
frequency). Please keep the knowledge about this crutch at a single place 
and don't spread it.
Anyway, for NO_HZ this correction is completely irrelevant, so again 
there's no point in adding random values all over the place until you get 
the correct result.

The only other alternative would be to calculate this correction 
dynamically. For this you leave NTP_INTERVAL_LENGTH as is and when 
changing clocks you check whether "abs(((cs->xtime_interval * 
NTP_INTERVAL_FREQ) >> cs->shift) - NSEC_PER_SEC)" exceeds a certain limit 
(e.g. 200usec) and in this case you print a warning message, that the 
clock has large base drift value and is a bad ntp source and apply a 
correction value. This way the correction only hits the very few system 
which might need it and it would be the prefered solution, but it also 
requires a few more changes.

bye, Roman
