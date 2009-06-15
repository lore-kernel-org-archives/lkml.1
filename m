Return-Path: <linux-kernel-owner+w=401wt.eu-S935808AbZFOV4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935808AbZFOV4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 17:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbZFOV4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 17:56:03 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46827 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbZFOV4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 17:56:02 -0400
Subject: Re: [PATCH] clocksource: setup mult_orig in clocksource_enable()
From: john stultz <johnstul@us.ibm.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, akpm@linux-foundation.org
In-Reply-To: <20090615200456.GA31202@linux-sh.org>
References: <20090501054546.8193.10688.sendpatchset@rx1.opensource.se>
	 <1244667895.8085.20.camel@localhost.localdomain>
	 <aec7e5c30906102251n36bbe6f9x9b384131f332d4d9@mail.gmail.com>
	 <1244850967.7231.26.camel@localhost.localdomain>
	 <aec7e5c30906140320r4d24c9efqb2bc2e30d715de02@mail.gmail.com>
	 <1245092917.7505.4.camel@localhost.localdomain>
	 <20090615200456.GA31202@linux-sh.org>
Content-Type: text/plain
Date: Mon, 15 Jun 2009 14:55:42 -0700
Message-Id: <1245102942.7505.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-16 at 05:04 +0900, Paul Mundt wrote:
> On Mon, Jun 15, 2009 at 12:08:37PM -0700, john stultz wrote:
> > On Sun, 2009-06-14 at 19:20 +0900, Magnus Damm wrote:
> > > On Sat, Jun 13, 2009 at 8:56 AM, john stultz<johnstul@us.ibm.com> wrote:
> > > > On Thu, 2009-06-11 at 14:51 +0900, Magnus Damm wrote:
> > > >> I can't think of any way that would work. The clock frequency can be
> > > >> changed while the clock is disabled. And we can only know the rate
> > > >> after enabling the clock, see these lines from include/linux/clk.h:
> > > >>
> > > >> /**
> > > >>  * clk_get_rate - obtain the current clock rate (in Hz) for a clock source.
> > > >>  *              This is only valid once the clock source has been enabled.
> > > >>  * @clk: clock source
> > > >>  */
> > > >> unsigned long clk_get_rate(struct clk *clk);
> > > >
> > > > Hrmm.. Yuck.
> > > >
> > > > Is this really expected behavior that a clk would change frequencies
> > > > between uses as a clocksource?
> > > 
> > > Yes, I think so. The clock frequency can change through cpufreq or
> > > clk_set_rate().
> > 
> > But they do not change freq (through cpufreq or anything else) after the
> > enable() call, right? That would be pretty critical. Otherwise they'd
> > need to be disqualified like we do the TSC on x86.
> > 
> This is a bit tricky, the clock needs to be able to adjust its parent
> divisors/multipliers in order to maintain its current frequency if a
> parent clock changes frequency. We do not presently prohibit a frequency
> change that deviates from the current frequency on these clocks, but
> this would be trivially handled by setting a fixed rate flag for those
> clocks. This sort of logic is necessary to block frequency changes in the
> parent clock topology that would throw the child clock's frequency out of
> sync. Note that in the general case we do not want to disable frequency
> changes on enabled clocks, enabled clocks only need to know whether they
> can handle a frequency change or not without destabilizing the system.

Any change to the freq mult value in the clocksource would be
destabilizing. So I'd advise pretty strongly to make sure that clk's
being used as clocksources cannot change frequency once they're enabled
and in use.

thanks
-john

