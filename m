Return-Path: <linux-kernel-owner+w=401wt.eu-S1762156AbZFJVFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762156AbZFJVFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762065AbZFJVFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:05:18 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:45034 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758941AbZFJVFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:05:14 -0400
Subject: Re: [PATCH] clocksource: setup mult_orig in clocksource_enable()
From: john stultz <johnstul@us.ibm.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, lethal@linux-sh.org,
       tglx@linutronix.de, akpm@linux-foundation.org
In-Reply-To: <20090501054546.8193.10688.sendpatchset@rx1.opensource.se>
References: <20090501054546.8193.10688.sendpatchset@rx1.opensource.se>
Content-Type: text/plain
Date: Wed, 10 Jun 2009 14:04:55 -0700
Message-Id: <1244667895.8085.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-01 at 14:45 +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@igel.co.jp>
> 
> Setup clocksource mult_orig in clocksource_enable().

Hey Magnus,
Sorry I missed this earlier, I just noticed it in the -tip tree.

I've some concerns below.

> Clocksource drivers can save power by using keeping the
> device clock disabled while the clocksource is unused.
> 
> In practice this means that the enable() and disable()
> callbacks perform clk_enable() and clk_disable().
> 
> The enable() callback may also use clk_get_rate() to get
> the clock rate from the clock framework. This information
> can then be used to calculate the shift and mult variables.

Hrmmm.. So when the clocksource code was designed, it was expected that
the clocksource mult value would be set prior to registration, and then
would not be modified by any user other then the timekeeping core. As
changing the mult value directly (on a clocksource thats being used)
could cause time inconsistencies.


> Currently the mult_orig variable is setup from mult at
> registration time only. This is conflicting with the above
> case since the clock is disabled and the mult variable is
> not yet calculated at the time of registration.

Is there really no way to calculate the mult value prior to
registration? Maybe quickly enabling, getting the freq, and then
disabling?

> Moving the mult_orig setup code to clocksource_enable()
> allows us to both handle the common case with no enable()
> callback and the mult-changed-after-enable() case.
> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> ---
> 
>  include/linux/clocksource.h |   10 +++++++++-
>  kernel/time/clocksource.c   |    3 ---
>  2 files changed, 9 insertions(+), 4 deletions(-)
> 
> --- 0001/include/linux/clocksource.h
> +++ work/include/linux/clocksource.h	2009-05-01 12:59:27.000000000 +0900
> @@ -288,7 +288,15 @@ static inline cycle_t clocksource_read(s
>   */
>  static inline int clocksource_enable(struct clocksource *cs)
>  {
> -	return cs->enable ? cs->enable(cs) : 0;
> +	int ret = 0;
> +
> +	if (cs->enable)
> +		ret = cs->enable(cs);
> +
> +	/* save mult_orig on enable */
> +	cs->mult_orig = cs->mult;
> +
> +	return ret;
>  }

So this seems like it will break if a clocksource is switched away from
and then back to (the reason we added mult_orig in the first place).
Since the re-enabled clocksource would then save off its modified mult
value into mult_orig.

thanks
-john

