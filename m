Return-Path: <linux-kernel-owner+w=401wt.eu-S1758310AbYAKKlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310AbYAKKlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 05:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbYAKKlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 05:41:36 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:31023 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751260AbYAKKlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 05:41:35 -0500
X-IronPort-AV: E=Sophos;i="4.24,271,1196636400"; 
   d="scan'208";a="6531996"
Date: Fri, 11 Jan 2008 11:41:32 +0100
From: Guillaume Chazarain <guichaz@yahoo.fr>
To: mingo@redhat.com
Cc: David Dillow <dillowda@ornl.gov>, linux-kernel@vger.kernel.org,
       linux-btrace@vger.kernel.org, tglx@linutronix.de,
       Jens Axboe <jens.axboe@oracle.com>, nigel@suspend2.net
Subject: Re: CONFIG_NO_HZ breaks blktrace timestamps
Message-ID: <20080111114132.084036f2@cheypa.inria.fr>
In-Reply-To: <20080110234438.4826f658@inria.fr>
References: <1199918912.8388.13.camel@lap75545.ornl.gov>
	<1199996752.9159.46.camel@lap75545.ornl.gov>
	<20080110234438.4826f658@inria.fr>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Dillow <dillowda@ornl.gov> wrote:

> Patched kernel, nohz=off:
>   .clock_underflows              : 213887

A little bit of warning about these patches, they are WIP, that's why I
did not send them earlier. It regress nohz=off.

A bit of context: these patches aim at making sure cpu_clock() on my
laptop (cpufreq enabled) never overflows/underflows/warps with
CONFIG_NOHZ enabled. With these patches, I have a few hundreds
overflows and underflows during early bootup, and then nothing :-)

Ingo Molnar <mingo@elte.hu> wrote:

> they are from the scheduler git tree (except the first debug patch), but 
> queued up for v2.6.25 at the moment.

You are talking about "x86: scale cyc_2_nsec according to CPU
frequency" here, but I don't think it is at stakes here as David has:

> CONFIG_CPU_FREQ is not set

Let me review my patches myself to give a bit of context:

>     sched: monitor clock underflows in /proc/sched_debug

This, I'd like to have it in .25 just for convenience.

>         x86: scale cyc_2_nsec according to CPU frequency

You already know that one ;-)

>     sched: fix rq->clock warps on frequency changes

This is a bugfix for .25 once the previous patch is applied. I don't
think it helps David, but it could help blktrace users with cpufreq
enabled.

>     sched: Fix rq->clock overflows detection with CONFIG_NO_HZ

I think this one is the most important for David, but unfortunately it
has some problems.

> +static inline u64 max_skipped_ticks(struct rq *rq)
> +{
> +	return nohz_on(cpu_of(rq)) ? jiffies - rq->last_tick_seen + 2 : 1;
> +}

Here, I initially wrote rq->last_tick_seen + 1 but experiments showed
that +2 was needed as I really saw deltas of 2 milliseconds.

These patches have two objectives:
 - taking into account that jiffies are not always incremented by 1
thanks to nohz
 - as the tick is stopped and restarted it may not tick at the exact
expected moment, so allow a window of 1 jiffie. If the tick occurs
during the right jiffy, we know the TSC is more precise than the tick
so don't correct the clock.

And the problem is that I seem to need a window of 2 jiffies, so I need
some help.

>     sched: make sure jiffies is up to date before calling __update_rq_clock()

This is one is needed too but I'm less confident in its validity.

>     scheduler_tick() is not called every jiffies

This one is a bit ugly and seems to break nohz=off.

> -	if (unlikely(rq->clock < next_tick)) {
> +	if (unlikely(rq->clock < next_tick - nohz_on(cpu) * TICK_NSEC)) {

No, I'm not proud of this :-(

Thanks.

-- 
Guillaume
