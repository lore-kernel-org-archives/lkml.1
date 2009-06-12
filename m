Return-Path: <linux-kernel-owner+w=401wt.eu-S1753103AbZFLX4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbZFLX4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 19:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbZFLX43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 19:56:29 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:52756 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbZFLX42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 19:56:28 -0400
Subject: Re: [PATCH] clocksource: setup mult_orig in clocksource_enable()
From: john stultz <johnstul@us.ibm.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, lethal@linux-sh.org,
       tglx@linutronix.de, akpm@linux-foundation.org
In-Reply-To: <aec7e5c30906102251n36bbe6f9x9b384131f332d4d9@mail.gmail.com>
References: <20090501054546.8193.10688.sendpatchset@rx1.opensource.se>
	 <1244667895.8085.20.camel@localhost.localdomain>
	 <aec7e5c30906102251n36bbe6f9x9b384131f332d4d9@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 16:56:07 -0700
Message-Id: <1244850967.7231.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-11 at 14:51 +0900, Magnus Damm wrote:
> Hi John,
> 
> On Thu, Jun 11, 2009 at 6:04 AM, john stultz<johnstul@us.ibm.com> wrote:
> > On Fri, 2009-05-01 at 14:45 +0900, Magnus Damm wrote:
> >> From: Magnus Damm <damm@igel.co.jp>
> >>
> >> Setup clocksource mult_orig in clocksource_enable().
> >
> > Hey Magnus,
> > Sorry I missed this earlier, I just noticed it in the -tip tree.
> 
> No worries!
> 
> > I've some concerns below.
> >
> >> Clocksource drivers can save power by using keeping the
> >> device clock disabled while the clocksource is unused.
> >>
> >> In practice this means that the enable() and disable()
> >> callbacks perform clk_enable() and clk_disable().
> >>
> >> The enable() callback may also use clk_get_rate() to get
> >> the clock rate from the clock framework. This information
> >> can then be used to calculate the shift and mult variables.
> >
> > Hrmmm.. So when the clocksource code was designed, it was expected that
> > the clocksource mult value would be set prior to registration, and then
> > would not be modified by any user other then the timekeeping core. As
> > changing the mult value directly (on a clocksource thats being used)
> > could cause time inconsistencies.
> 
> But no one is changing the mult value on a clocksource that is being
> used in this case, no? I may remember wrong, but isn't
> clocksource_enable() called on unused clocksources that soon will
> become used?

True, but having mult change after registration is still somewhat
unexpected behavior (to me at least).

> >> Currently the mult_orig variable is setup from mult at
> >> registration time only. This is conflicting with the above
> >> case since the clock is disabled and the mult variable is
> >> not yet calculated at the time of registration.
> >
> > Is there really no way to calculate the mult value prior to
> > registration? Maybe quickly enabling, getting the freq, and then
> > disabling?
> 
> I can't think of any way that would work. The clock frequency can be
> changed while the clock is disabled. And we can only know the rate
> after enabling the clock, see these lines from include/linux/clk.h:
> 
> /**
>  * clk_get_rate - obtain the current clock rate (in Hz) for a clock source.
>  *		  This is only valid once the clock source has been enabled.
>  * @clk: clock source
>  */
> unsigned long clk_get_rate(struct clk *clk);

Hrmm.. Yuck. 

Is this really expected behavior that a clk would change frequencies
between uses as a clocksource?

Do you have some examples where this code is actually used? 


> >> --- 0001/include/linux/clocksource.h
> >> +++ work/include/linux/clocksource.h  2009-05-01 12:59:27.000000000 +0900
> >> @@ -288,7 +288,15 @@ static inline cycle_t clocksource_read(s
> >>   */
> >>  static inline int clocksource_enable(struct clocksource *cs)
> >>  {
> >> -     return cs->enable ? cs->enable(cs) : 0;
> >> +     int ret = 0;
> >> +
> >> +     if (cs->enable)
> >> +             ret = cs->enable(cs);
> >> +
> >> +     /* save mult_orig on enable */
> >> +     cs->mult_orig = cs->mult;
> >> +
> >> +     return ret;
> >>  }
> >
> > So this seems like it will break if a clocksource is switched away from
> > and then back to (the reason we added mult_orig in the first place).
> > Since the re-enabled clocksource would then save off its modified mult
> > value into mult_orig.
> 
> Oh, I see. Sorry about that. I wonder if adding a "cs->mult =
> cs->orig_mult;" to clock_disable() would help?

Technically it would. Although we lose the corrective factor that had
already been applied, but that should readjust fairly quickly.

So yea, at a minimum setting mult back to orig_mult would be needed for
this patch to work.  

However, its just ugly. I don't really like the idea of clocksources
freq changes under us (even if they're not actively in use). But I may
have to just deal with the reality. :(

thanks
-john


