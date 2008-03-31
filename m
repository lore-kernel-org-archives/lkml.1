Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbYCaHSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbYCaHSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 03:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbYCaHSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 03:18:18 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:48167 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbYCaHSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 03:18:17 -0400
To: Tim Ricketts <tr@earth.li>
Cc: Michael Smith <msmith@xiph.org>, linux-kernel@vger.kernel.org,
       Andy Wingo <wingo@fluendo.com>, tglx@linutronix.de
Subject: Re: gettimeofday() jumping into the future
References: <3c1737210708230408i7a8049a9m5db49e6c4d89ab62@mail.gmail.com>
	<Pine.LNX.4.64.0803302210060.3056@falcon.foo>
From: Andi Kleen <andi@firstfloor.org>
Date: 31 Mar 2008 09:18:12 +0200
In-Reply-To: <Pine.LNX.4.64.0803302210060.3056@falcon.foo>
Message-ID: <87r6dr8iq3.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 31 Mar 2008 07:11:35.0223 (UTC) FILETIME=[7465B470:01C892FE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Ricketts <tr@earth.li> writes:

[adding right people to cc just in case it slipped past their filters,
keeping enough quote for context]

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

[...]
> +static inline u64 __get_nsec_offset(void)
>   {
>   	cycle_t cycle_now, cycle_delta;
> -	s64 ns_offset;
> +	u64 ns_offset;
> 
>   	/* read clocksource: */
>   	cycle_now = clocksource_read(clock);
> 
> +	if (cycle_now < clock->cycle_last)
> +		return 0;

The old x86-64 pre-clocksource gettimeofday() implementation had a similar
check. It came from painful experience.

-Andi
