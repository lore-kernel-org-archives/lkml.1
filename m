Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbZEXH5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbZEXH5e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 03:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbZEXH5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 03:57:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53035 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbZEXH5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 03:57:25 -0400
Subject: Re: [PATCH] U300 sched_clock implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <63386a3d0905231446h245bb4a9gec111f68a74a44e4@mail.gmail.com>
References: <63386a3d0905112337p2d426481o5f9bf9b9489cc57e@mail.gmail.com>
	 <63386a3d0905231446h245bb4a9gec111f68a74a44e4@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 24 May 2009 09:57:18 +0200
Message-Id: <1243151839.26820.642.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-23 at 23:46 +0200, Linus Walleij wrote:

> This overrides the global sched_clock() symbol in the Linux
> scheduler with a local implementation which takes advantage of
> the timesource in U300 giving a scheduling resolution of 1us. The
> solution is the same as found in the OMAP2 core code.

We assume sched_clock() to return time in ns (e-9) resolution.

> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
>  arch/arm/mach-u300/timer.c |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-u300/timer.c b/arch/arm/mach-u300/timer.c
> index 4bf82f8..222de18 100644
> --- a/arch/arm/mach-u300/timer.c
> +++ b/arch/arm/mach-u300/timer.c
> @@ -346,6 +346,22 @@ static struct clocksource clocksource_u300_1mhz = {
>        .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
>  };
> 
> +/*
> + * Override the global weak sched_clock symbol with this
> + * local implementation which uses the clocksource to get some
> + * better resolution when scheduling the kernel. We accept that
> + * this wraps around for now, since it is just a relative time
> + * stamp. (Inspired by OMAP implementation.)
> + */
> +unsigned long long sched_clock(void)
> +{
> +       unsigned long long ret;
> +
> +       ret = (unsigned long long) u300_get_cycles();
> +       ret = (ret * clocksource_u300_1mhz.mult_orig) >>
> +               clocksource_u300_1mhz.shift;
> +       return ret;
> +}
> 
>  /*
>  * This sets up the system timers, clock source and clock event.
> --
> 1.6.2.1
