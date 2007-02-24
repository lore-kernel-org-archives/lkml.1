Return-Path: <linux-kernel-owner+w=401wt.eu-S933296AbXBXAxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933296AbXBXAxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 19:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933298AbXBXAxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 19:53:33 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:45167 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933296AbXBXAxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 19:53:32 -0500
Subject: Re: sparc generic time / clockevents
From: john stultz <johnstul@us.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, peter.keilty@hp.com
In-Reply-To: <20070223.163428.104033815.davem@davemloft.net>
References: <1172224579.25076.219.camel@localhost.localdomain>
	 <20070223.015520.125893182.davem@davemloft.net>
	 <1172260279.6261.20.camel@localhost>
	 <20070223.163428.104033815.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 23 Feb 2007 16:53:27 -0800
Message-Id: <1172278407.6261.56.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-23 at 16:34 -0800, David Miller wrote:
> From: john stultz <johnstul@us.ibm.com>
> Date: Fri, 23 Feb 2007 11:51:18 -0800
> 
> > Yea. I actually have some in-progress patches from Peter Keilty that
> > convert ia64 and sparc64 time_interpolators to clocksources, then
> > removes the time_interpolator code.
> > 
> > The ia64 conversion is more complicated due to the fsyscall asm, but I
> > think the sparc64 conversion (below) is pretty straight forward. I've
> > only built tested this, so I have no clue if it actually works. 
> > 
> > Any thoughts?
> 
> Hey John, I had to do this already in order to do the dynticks
> port to sparc64, but nice to see another attempt :-)

Oh! Well, sorry for not sending it out earlier, then!

> Two things I did on my side:
> 
> +	.mask           = 0xffffffffffffffffLL,
> 
> I used CLOCKSOURCE_MASK(64) here.

Yep. That's better.

> +static cycle_t read_sparc64_cpuclock(void)
> +{
> +        return (cycle_t)get_cycles();
> +}
>  ...
> +	.read           = read_sparc64_cpuclock,
> 
> You can just directly assign tick_ops->get_tick to .read at run-time
> to avoid a stack frame and function call/return.

Cool.

> +	.shift          = 16,
> 
> These shift selections all seem rather arbitrary.
> 
> If it's not an arbitrary selection, it would be nice to have some
> comments about how to go about choosing an appropriate shift.
> I imagine the selections has to do with the possible range of
> the frequencies the clocksource supports, and how much
> accuracy you get for certain shift selections given that range.

Correct. The higher the shift value, the more precise NTP multiplier
adjustment we can make.  However, too large w/ a high frequency
clocksource and you'll risk overflowing 64bits on the mult.

Although that's not super critical anymore since Roman implemented the
high-res error accounting, the net effect should be the same over the
long term(we just have to work harder w/ courser adjustments - resulting
in very small clock frequency oscillations).

I do need to get some documentation going. I had some back when I first
started pushing the changes, but so much was revised and rewritten it
stopped being correct.

-john

