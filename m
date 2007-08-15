Return-Path: <linux-kernel-owner+w=401wt.eu-S936035AbXHOXE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936035AbXHOXE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 19:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760628AbXHOXEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 19:04:47 -0400
Received: from www.osadl.org ([213.239.205.134]:38988 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759900AbXHOXEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 19:04:46 -0400
Subject: Re: [PATCH] Use num_possible_cpus() instead of NR_CPUS for timer
	distribution
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1187217977.6062.23.camel@localhost.localdomain>
References: <1187217977.6062.23.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 16 Aug 2007 01:04:43 +0200
Message-Id: <1187219083.7007.3.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-15 at 15:46 -0700, john stultz wrote:
> Andrew requested this fixup awhile back, and I just now got to it
> (apologies for being slow).
> 
> To avoid lock contention, we distribute the sched_timer calls across the
> cpus so they do not trigger at the same instant. However, I used
> NR_CPUS, which can cause needless grouping on small smp systems
> depending on your kernel config. This patch converts to using
> num_possible_cpus() so we spread it as evenly as possible on every
> machine.
> 
> Briefly tested w/ NR_CPUS=255 and verified reduced contention.
>
> Signed-off-by: John Stultz <johnstul@us.ibm.com>

Doh, I missed this as well

Acked-by: Thomas Gleixner <tglx@linutronix,de>

> 
> Index: 2.6-rt/kernel/time/tick-sched.c
> ===================================================================
> --- 2.6-rt.orig/kernel/time/tick-sched.c
> +++ 2.6-rt/kernel/time/tick-sched.c
> @@ -586,7 +586,7 @@ void tick_setup_sched_timer(void)
>  	/* Get the next period (per cpu) */
>  	ts->sched_timer.expires = tick_init_jiffy_update();
>  	offset = ktime_to_ns(tick_period) >> 1;
> -	do_div(offset, NR_CPUS);
> +	do_div(offset, num_possible_cpus());
>  	offset *= smp_processor_id();
>  	ts->sched_timer.expires = ktime_add_ns(ts->sched_timer.expires, offset);


