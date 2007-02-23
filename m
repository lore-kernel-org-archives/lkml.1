Return-Path: <linux-kernel-owner+w=401wt.eu-S933230AbXBWWDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230AbXBWWDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 17:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933232AbXBWWDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 17:03:54 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36999
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933230AbXBWWDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 17:03:53 -0500
Date: Fri, 23 Feb 2007 14:03:28 -0800 (PST)
Message-Id: <20070223.140328.74752162.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
Subject: Re: radeon breaks with clocksource_jiffies
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070223.134505.74749340.davem@davemloft.net>
References: <20070223.134505.74749340.davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Fri, 23 Feb 2007 13:45:05 -0800 (PST)

> While probeing PLL information via radeon_get_pllinfo(), it does a
> "gettimeofday(); do_something(); gettimeofday();" type sequence
> explicitly with interrupts disabled, so ends up with a zero
> measurement which then results in a bunch of divisions by zero.
> 
> We should decide whether gettimeofday() can be expected to advance with
> interrupts disabled, or that clocksource_jiffies is simply invalid because
> of this behavior.

Actually, with clocksource based gettimeofday(), radeon built-in cannot
work at all.

The reason is that the clocksource code will not jump over to a
clock source other than clocksource_jiffies until the late initcalls
are run, because of this code:

/* clocksource_done_booting - Called near the end of bootup
 *
 * Hack to avoid lots of clocksource churn at boot time
 */
static int __init clocksource_done_booting(void)
{
	finished_booting = 1;
	return 0;
}
late_initcall(clocksource_done_booting);
 ...
struct clocksource *clocksource_get_next(void)
{
	unsigned long flags;

	spin_lock_irqsave(&clocksource_lock, flags);
	if (next_clocksource && finished_booting) {
		curr_clocksource = next_clocksource;
		next_clocksource = NULL;
	}
	spin_unlock_irqrestore(&clocksource_lock, flags);

	return curr_clocksource;
}

So even if other clock sources are provided, they'll never show up until
after the radeon driver tries to initialize.

I understand the intention of the clocksource_get_next() code, it doesn't
want to hop onto several different clocksource implementations as the
drivers for those startup, but going through all the module_init() calls
for various drivers without a sane clocksource is just as bad of a problem
and is in fact fatal in this radeon case.
