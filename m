Return-Path: <linux-kernel-owner+w=401wt.eu-S1758349AbXFJOQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349AbXFJOQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 10:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754612AbXFJOQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 10:16:19 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:53358 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbXFJOQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 10:16:18 -0400
Date: Sun, 10 Jun 2007 16:16:17 +0200
From: Andreas Mohr <andi@rhlx01.hs-esslingen.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>, john stultz <johnstul@us.ibm.com>
Subject: Re: [patch-mm 07/23] Tick management: spread timer interrupt
Message-ID: <20070610141617.GA15173@rhlx01.hs-esslingen.de>
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de> <20070610092446.625214085@inhelltoy.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070610092446.625214085@inhelltoy.tec.linutronix.de>
User-Agent: Mutt/1.4.2.2i
X-Priority: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jun 10, 2007 at 09:44:05AM -0000, Thomas Gleixner wrote:
> From: john stultz <johnstul@us.ibm.com>
> 
> After discussing w/ Thomas over IRC, it seems the issue is the sched
> tick fires on every cpu at the same time, causing extra lock contention.

Hmm, the cpu-specific offset calculation isn't too expensive, hopefully?
(div/mul in patch, maybe this could be done differently)

And is it granted that the do_div() compiles into a nice plain void
on non-SMP? Would be good to verify this.

And calculation order? Do multiply before division to minimize calculation
error?
(for a timer tick it probably doesn't matter, however)
And of course OTOH doing it the other way might lead to overflows...

> This smaller change, adds an extra offset per cpu so the ticks don't
> line up. This patch also drops the idle latency from 40us down to under
> 20us.

Very nice, thanks!

> +	/* Get the next period (per cpu)*/
>  	ts->sched_timer.expires = tick_init_jiffy_update();
> +	offset = ktime_to_ns(tick_period) >> 1;
> +	do_div(offset, NR_CPUS);
> +	offset *= smp_processor_id();

Andreas Mohr
