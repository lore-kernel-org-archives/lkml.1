Return-Path: <linux-kernel-owner+w=401wt.eu-S1765680AbZFOUFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765680AbZFOUFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 16:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756248AbZFOUFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 16:05:44 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:34507 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbZFOUFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 16:05:43 -0400
Date: Tue, 16 Jun 2009 05:04:57 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, akpm@linux-foundation.org
Subject: Re: [PATCH] clocksource: setup mult_orig in clocksource_enable()
Message-ID: <20090615200456.GA31202@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	john stultz <johnstul@us.ibm.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
	mingo@elte.hu, tglx@linutronix.de, akpm@linux-foundation.org
References: <20090501054546.8193.10688.sendpatchset@rx1.opensource.se> <1244667895.8085.20.camel@localhost.localdomain> <aec7e5c30906102251n36bbe6f9x9b384131f332d4d9@mail.gmail.com> <1244850967.7231.26.camel@localhost.localdomain> <aec7e5c30906140320r4d24c9efqb2bc2e30d715de02@mail.gmail.com> <1245092917.7505.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245092917.7505.4.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 12:08:37PM -0700, john stultz wrote:
> On Sun, 2009-06-14 at 19:20 +0900, Magnus Damm wrote:
> > On Sat, Jun 13, 2009 at 8:56 AM, john stultz<johnstul@us.ibm.com> wrote:
> > > On Thu, 2009-06-11 at 14:51 +0900, Magnus Damm wrote:
> > >> I can't think of any way that would work. The clock frequency can be
> > >> changed while the clock is disabled. And we can only know the rate
> > >> after enabling the clock, see these lines from include/linux/clk.h:
> > >>
> > >> /**
> > >>  * clk_get_rate - obtain the current clock rate (in Hz) for a clock source.
> > >>  *              This is only valid once the clock source has been enabled.
> > >>  * @clk: clock source
> > >>  */
> > >> unsigned long clk_get_rate(struct clk *clk);
> > >
> > > Hrmm.. Yuck.
> > >
> > > Is this really expected behavior that a clk would change frequencies
> > > between uses as a clocksource?
> > 
> > Yes, I think so. The clock frequency can change through cpufreq or
> > clk_set_rate().
> 
> But they do not change freq (through cpufreq or anything else) after the
> enable() call, right? That would be pretty critical. Otherwise they'd
> need to be disqualified like we do the TSC on x86.
> 
This is a bit tricky, the clock needs to be able to adjust its parent
divisors/multipliers in order to maintain its current frequency if a
parent clock changes frequency. We do not presently prohibit a frequency
change that deviates from the current frequency on these clocks, but
this would be trivially handled by setting a fixed rate flag for those
clocks. This sort of logic is necessary to block frequency changes in the
parent clock topology that would throw the child clock's frequency out of
sync. Note that in the general case we do not want to disable frequency
changes on enabled clocks, enabled clocks only need to know whether they
can handle a frequency change or not without destabilizing the system.

The only thing the usecount presently disables on an enabled clock is
reparenting it. ie, migrating between different parent PLLs while in
active use.

There is no fundamental limitation as with the TSC, we can have as much
or as little flexibility as we like.
