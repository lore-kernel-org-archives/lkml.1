Return-Path: <linux-kernel-owner+w=401wt.eu-S1757460AbZEVUmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460AbZEVUmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 16:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756936AbZEVUmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 16:42:00 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:43582 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbZEVUl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 16:41:59 -0400
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-omap-open-source@linux.omap.com
Subject: Re: [PATCH] omap: add sched_clock for omap1 based on MPU timer
References: <4A17014C.7080305@am.sony.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Fri, 22 May 2009 13:41:58 -0700
In-Reply-To: <4A17014C.7080305@am.sony.com> (Tim Bird's message of "Fri\, 22 May 2009 12\:47\:24 -0700")
Message-ID: <87eiug50q1.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Bird <tim.bird@am.sony.com> writes:

> Define a higher-resolution sched_clock for OMAP
> using the MPU timer, when it is configured on.
>
> This produces better results from ftrace.
>
> Signed-off-by: Tim Bird <tim.bird@am.sony.com>
> ---
>  arch/arm/mach-omap1/time.c  |    9 +++++++++
>  arch/arm/plat-omap/common.c |    2 ++
>  2 files changed, 11 insertions(+)
>
> --- a/arch/arm/mach-omap1/time.c
> +++ b/arch/arm/mach-omap1/time.c
> @@ -212,6 +212,15 @@ static struct clocksource clocksource_mp
>  	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
>  };
>
> +unsigned long long notrace sched_clock(void)
> +{
> +	unsigned long long ret;
> +
> +	ret = (unsigned long long) ~omap_mpu_timer_read(1);
> +	ret = (ret * clocksource_mpu.mult_orig) >> clocksource_mpu.shift;
> +	return ret;
> +}
> +

Minor nit: I think this should rather look something like:

     cycle_t c;

     c = clocksource_read(&clocksource_mpu);
     return cyc2ns(&clocksource_mpu, c);

This way, if the clocksource implementation is changed (to use a
different timer for example) this doesn't have to be changed as well.

Kevin

>  static void __init omap_init_clocksource(unsigned long rate)
>  {
>  	static char err[] __initdata = KERN_ERR
> --- a/arch/arm/plat-omap/common.c
> +++ b/arch/arm/plat-omap/common.c
> @@ -199,6 +199,7 @@ static struct clocksource clocksource_32
>  	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
>  };
>
> +#ifndef CONFIG_OMAP_MPU_TIMER
>  /*
>   * Returns current time from boot in nsecs. It's OK for this to wrap
>   * around for now, as it's just a relative time stamp.
> @@ -211,6 +212,7 @@ unsigned long long notrace sched_clock(v
>  	ret = (ret * clocksource_32k.mult_orig) >> clocksource_32k.shift;
>  	return ret;
>  }
> +#endif
>
>  static int __init omap_init_clocksource_32k(void)
>  {

