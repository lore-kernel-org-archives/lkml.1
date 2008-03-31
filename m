Return-Path: <linux-kernel-owner+w=401wt.eu-S1755785AbYCaI4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbYCaI4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 04:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbYCaIz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 04:55:56 -0400
Received: from www.tglx.de ([62.245.132.106]:57133 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192AbYCaIzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 04:55:55 -0400
Date: Mon, 31 Mar 2008 10:55:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tim Ricketts <tr@earth.li>
cc: Michael Smith <msmith@xiph.org>, LKML <linux-kernel@vger.kernel.org>,
       Andy Wingo <wingo@fluendo.com>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: gettimeofday() jumping into the future
In-Reply-To: <Pine.LNX.4.64.0803302210060.3056@falcon.foo>
Message-ID: <alpine.LFD.1.10.0803311048170.3219@apollo.tec.linutronix.de>
References: <3c1737210708230408i7a8049a9m5db49e6c4d89ab62@mail.gmail.com> <Pine.LNX.4.64.0803302210060.3056@falcon.foo>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Mar 2008, Tim Ricketts wrote:
> On Thu, 23 Aug 2007, Michael Smith wrote:
> 
> > We've been seeing some strange behaviour on some of our applications
> > recently. I've tracked this down to gettimeofday() returning spurious
> > values occasionally.
> > 
> > Specifically, gettimeofday() will suddenly, for a single call, return
> > a value about 4398 seconds (~1 hour 13 minutes) in the future. The
> > following call goes back to a normal value.
> 
> I have also seen this.
> 
> > This seems to be occurring when the clock source goes slightly
> > backwards for a single call. In
> > kernel/time/timekeeping.c:__get_nsec_offset(), we have this:
> > cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> > 
> > So a small decrease in time here will (this is all unsigned
> > arithmetic) give us a very large cycle_delta. cyc2ns() then multiplies
> > this by some value, then right shifts by 22. The resulting value (in
> > nanoseconds) is approximately 4398 seconds; this gets added on to the
> > xtime value, giving us our jump into the future. The next call to
> > gettimeofday() returns to normal as we don't have this huge nanosecond
> > offset.
> 
> Indeed.  I don't know where the suggestion of off by 2^32us came in
> later in this thread.  As you've already pointed out, it's off by
> 2^42ns.
> 
> I've no idea why the TSC might go backwards, but perhaps we should not
> break horribly if it does.  How about treating it as zero?
 
> +	if (cycle_now < clock->cycle_last)
> +		return 0;
> +

No, this breaks wrapping clocksources e.g. pmtimer. We need a
different sanity check for that TSC crap.

Thanks,

	tglx
