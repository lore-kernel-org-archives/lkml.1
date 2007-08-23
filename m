Return-Path: <linux-kernel-owner+w=401wt.eu-S1763644AbXHWM0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763644AbXHWM0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 08:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763310AbXHWMZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 08:25:56 -0400
Received: from eldorado.sekrit.org ([72.5.28.212]:60311 "EHLO
	eldorado.sekrit.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763280AbXHWMZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 08:25:54 -0400
X-Greylist: delayed 2944 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Aug 2007 08:25:54 EDT
Date: Thu, 23 Aug 2007 07:36:48 -0400
From: Gerald Britton <gbritton@doomcom.org>
To: Michael Smith <msmith@xiph.org>
Cc: linux-kernel@vger.kernel.org, Andy Wingo <wingo@fluendo.com>
Subject: Re: gettimeofday() jumping into the future
Message-ID: <20070823113648.GA5405@zante.sekrit.org>
References: <3c1737210708230408i7a8049a9m5db49e6c4d89ab62@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c1737210708230408i7a8049a9m5db49e6c4d89ab62@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 01:08:27PM +0200, Michael Smith wrote:
> Hi,
> 
> We've been seeing some strange behaviour on some of our applications
> recently. I've tracked this down to gettimeofday() returning spurious
> values occasionally.
> 
> Specifically, gettimeofday() will suddenly, for a single call, return
> a value about 4398 seconds (~1 hour 13 minutes) in the future. The
> following call goes back to a normal value.

I have seen this as well (on a 2.6.20.4 kernel).  The value returned was
always identical each time the glitch occured (just a little over 4398
seconds).  I saw it watching packet receive timestamps and on the system in
question, it would generally hit this problem around once a minute.  When
moving forward to a 2.6.21 kernel, the problem seemed to go away (also back
to 2.6.17, unfortunately I didn't have any sample points inbetween).
I didn't have free time to spend bisecting attempting to find when the
behavior started or stopped.

The hardware in this case was an HP Proliant DL380 G5 with two dueal-core
Core2 processors and was using the tsc as timesource.

				-- Gerald

> This seems to be occurring when the clock source goes slightly
> backwards for a single call. In
> kernel/time/timekeeping.c:__get_nsec_offset(), we have this:
>  cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> 
> So a small decrease in time here will (this is all unsigned
> arithmetic) give us a very large cycle_delta. cyc2ns() then multiplies
> this by some value, then right shifts by 22. The resulting value (in
> nanoseconds) is approximately 4398 seconds; this gets added on to the
> xtime value, giving us our jump into the future. The next call to
> gettimeofday() returns to normal as we don't have this huge nanosecond
> offset.
> 
> This system is a 2-socket core 2 quad machine (8 cpus), running 32 bit
> mode. It's a dell poweredge 1950. The kernel selects the TSC as the
> clock source, having determined that the tsc runs synchronously on
> this system. Switching the systems to use a different time source
> seems to make the problem go away (which is fine for us, but we'd like
> to get this fixed properly upstream).
> 
> We've also seen this behaviour with a synthetic test program (which
> just runs 4 threads all calling gettimeofday() in a loop as fast as
> possible and testing that it doesn't jump) on an older machine, a dell
> poweredge SC1425 with two p4 hyperthreaded xeons.
> 
> Can anyone advise on what's going wrong here? I can't find much in the
> way of documentation on whether the TSC is guaranteed to be
> monotonically increasing on intel systems. Should the code choose not
> to use the TSC? Or should the TSC reading code ensure that the
> returned values are monotonic?
> 
> Is there any more information that would be useful? I'll be on a plane
> for most of tomorrow, so might be a little slow responding.
> 
> Thanks,
> 
> Mike
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
