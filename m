Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbZFLSmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbZFLSmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 14:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbZFLSmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 14:42:10 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58624 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbZFLSmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 14:42:09 -0400
Subject: Re: [PATCH] Convert alpha to use arch_gettimeoffset()
From: john stultz <johnstul@us.ibm.com>
To: Richard Henderson <rth7680@gmail.com>
Cc: ink@jurassic.park.msu.ru, lkml <linux-kernel@vger.kernel.org>,
       linux-alpha@vger.kernel.org
In-Reply-To: <4A31FDBE.3030506@gmail.com>
References: <1244758210.7192.5.camel@localhost.localdomain>
	 <4A31FDBE.3030506@gmail.com>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 11:41:52 -0700
Message-Id: <1244832112.7231.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 00:03 -0700, Richard Henderson wrote:
> john stultz wrote:
> > I suspect the alpha arch could even be further improved to provide and
> > rpcc() based clocksource, but not having the hardware, I don't feel
> > comfortable attempting the more complicated conversion (but I'd be glad
> > to help if anyone else is interested).
> 
> Unfortunately this isn't possible.  The rpcc value is only 32-bits wide,
> and so rolls over in approx 3 to 4 seconds.  Thus all the contortions to
> try and use the truncated value for sub 1 second adjustments.

That's actually ok. The ACPI PM clocksource on x86 is only 24 bits wide
and wraps every 5 seconds. The generic timekeeping code handles the
wrapping and accumulation for you.


> > +	delta_cycles = rpcc() - state.last_time;
> > +	partial_tick = state.partial_tick;
> >  	/*
> >  	 * usec = cycles * ticks_per_cycle * 2**48 * 1e6 / (2**48 * ticks)
> >  	 *	= cycles * (s_t_p_c) * 1e6 / (2**48 * ticks)
> > @@ -448,62 +437,9 @@ do_gettimeofday(struct timeval *tv)
> >  	delta_usec = ((delta_usec / ((1UL << (FIX_SHIFT-6-1)) * HZ)) + 1) / 2;
> >  #endif
> ...
> > +	return delta_usec * 1000;
> 
> If we're going to be computing nsec now, we might as well adjust
> the computation here.
> 
>    nsec = cycles * ticks_per_cycle * 1e9 / HZ
>         = cycles * s_t_p_c * 1e9 / (2**48 * HZ)
>         = cycles * s_t_p_c * 1953125 / (2**39 * HZ)
> 
>    delta_nsec = delta_cycles*state.scaled_ticks_per_cycle + partial_tick;
>    delta_nsec *= 1953125
>    delta_nsec /= HZ << (FIX_SHIFT - 9 - 1);
>    delta_nsec = (delta_nsec + 1) / 2;
> 
> As far as I can tell, the range of the dividend is about 7e17,
> which still fits in an unsigned long.

That seems like a good optimization, although I'm hesitant to submit
anything but structural, but equivalent code changes since I don't have
the hardware to test with.

Might you create a patch that does this conversion and apply it on top
of mine? 

thanks
-john

