Return-Path: <linux-kernel-owner+w=401wt.eu-S1756487Ab0AMVxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487Ab0AMVxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 16:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609Ab0AMVxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 16:53:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751733Ab0AMVxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 16:53:05 -0500
Date: Wed, 13 Jan 2010 13:52:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, tglx@tglx.de, mingo@elte.hu,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] timers: Introduce the concept of timer slack for legacy
 timers
Message-Id: <20100113135219.f7e8a2f9.akpm@linux-foundation.org>
In-Reply-To: <20100109133744.29829988@infradead.org>
References: <20100109133744.29829988@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jan 2010 13:37:44 -0800
Arjan van de Ven <arjan@infradead.org> wrote:

> While HR timers have had the concept of timer slack for quite some time
> now, the legacy timers lacked this concept, and had to make do with
> round_jiffies() and friends.
> 
> Timer slack is important for power management; grouping timers reduces
> the number of wakeups which in turn reduces power consumption.
> 
> This patch introduces timer slack to the legacy timers using the following
> pieces:
> * A slack field in the timer struct
> * An api (set_timer_slack) that callers can use to set explicit timer slack
> * A default slack of 0.4% of the requested delay for callers that do not set
>   any explicit slack
> * Rounding code that is part of mod_timer() that tries to
>   group timers around jiffies values every 'power of two'
>   (so quick timers will group around every 2, but longer timers
>   will group around every 4, 8, 16, 32 etc)
> 
> ...
>
> +/**
> + * set_timer_slack - set the allowed slack for a timer
> + * @slack_hz: the amount of time (in jiffies) allowed for rounding
> + *
> + * Set the amount of time, in jiffies, that a certain timer has
> + * in terms of slack. By setting this value, the timer subsystem
> + * will schedule the actual timer somewhere between
> + * the time mod_timer() asks for, and that time plus the slack.
> + *
> + * By setting the slack to -1, a percentage of the delay is used
> + * instead.
> + */
> +void set_timer_slack(struct timer_list *timer, int slack_hz)
> +{
> +	timer->slack = slack_hz;
> +}
> +EXPORT_SYMBOL_GPL(set_timer_slack);

I suppose this could be inlined.

>  }
>  EXPORT_SYMBOL(mod_timer_pending);
>  
> +/*
> + * Decide where to put the timer while taking the slack into account
> + *
> + * Algorithm:
> + *   1) calculate the maximum (absolute) time
> + *   2) calculate the highest bit where the expires and new max are different
> + *   3) use this bit to make a mask
> + *   4) use the bitmask to round down the maximum time, so that all last
> + *      bits are zeros
> + */
> +static inline
> +unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
> +{
> +	unsigned long expires_limit, mask;
> +	int bit;
> +
> +	expires_limit = expires + timer->slack;
> +
> +	if (timer->slack < 0) /* auto slack: use 0.4% */
> +		expires_limit = expires + (expires - jiffies)/256;
> +
> +	mask = expires ^ expires_limit;
> +
> +	if (mask == 0)
> +		return expires;
> +
> +	bit = find_last_bit(&mask, BITS_PER_LONG);
> +
> +	mask = (1 << bit) - 1;
> +
> +	expires_limit = expires_limit & ~(mask);
> +
> +	return expires_limit;
> +}

OK, so by default this causes every timer in the system to have a bit
of slack (unless they're really short-term?), so the feature does get
runtime tested.

But the set_timer_slack() interface has no callers.  Perhaps it should?
