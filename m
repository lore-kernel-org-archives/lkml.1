Return-Path: <linux-kernel-owner+w=401wt.eu-S1752498AbZEAXET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbZEAXET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 19:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760757AbZEAXEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 19:04:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51975 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577AbZEAXEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 19:04:02 -0400
Date: Fri, 1 May 2009 19:03:58 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Tim Bird <tim.bird@am.sony.com>
cc: linux kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 1/2]  ftrace: add notrace to ARM sched_clock routines
In-Reply-To: <49FB77ED.3010800@am.sony.com>
Message-ID: <alpine.DEB.2.00.0905011902160.20374@gandalf.stny.rr.com>
References: <49FB77ED.3010800@am.sony.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 1 May 2009, Tim Bird wrote:

> Add notrace attribute to sched_clock, to avoid
> recursion with ftrace function_graph tracing.

If there's nothing in those files that you don't really want to trace 
anyway, you could just disable the tracing from those files:

For example, in the Makefile add:

	CFLAGS_REMOVE_time.o := -pg

-- Steve

> 
> Signed-off-by: Tim Bird <tim.bird@am.sony.com>
> ---
>  arch/arm/mach-mmp/time.c       |    2 +-
>  arch/arm/mach-pxa/time.c       |    2 +-
>  arch/arm/mach-realview/core.c  |    2 +-
>  arch/arm/mach-sa1100/generic.c |    2 +-
>  arch/arm/mach-versatile/core.c |    2 +-
>  arch/arm/plat-omap/common.c    |    4 ++--
>  6 files changed, 7 insertions(+), 7 deletions(-)
> 
> --- a/arch/arm/mach-mmp/time.c
> +++ b/arch/arm/mach-mmp/time.c
> @@ -72,7 +72,7 @@ static inline uint32_t timer_read(void)
>  	return __raw_readl(TIMERS_VIRT_BASE + TMR_CVWR(0));
>  }
> 
> -unsigned long long sched_clock(void)
> +unsigned long long notrace sched_clock(void)
>  {
>  	unsigned long long v = cnt32_to_63(timer_read());
>  	return (v * tcr2ns_scale) >> TCR2NS_SCALE_FACTOR;
> --- a/arch/arm/mach-pxa/time.c
> +++ b/arch/arm/mach-pxa/time.c
> @@ -51,7 +51,7 @@ static void __init set_oscr2ns_scale(uns
>  		oscr2ns_scale++;
>  }
> 
> -unsigned long long sched_clock(void)
> +unsigned long long notrace sched_clock(void)
>  {
>  	unsigned long long v = cnt32_to_63(OSCR);
>  	return (v * oscr2ns_scale) >> OSCR2NS_SCALE_FACTOR;
> --- a/arch/arm/mach-realview/core.c
> +++ b/arch/arm/mach-realview/core.c
> @@ -60,7 +60,7 @@ void __iomem *gic_cpu_base_addr;
>   * This is the RealView sched_clock implementation.  This has
>   * a resolution of 41.7ns, and a maximum value of about 179s.
>   */
> -unsigned long long sched_clock(void)
> +unsigned long long notrace sched_clock(void)
>  {
>  	unsigned long long v;
> 
> --- a/arch/arm/mach-sa1100/generic.c
> +++ b/arch/arm/mach-sa1100/generic.c
> @@ -131,7 +131,7 @@ EXPORT_SYMBOL(cpufreq_get);
>   *
>   *  ( * 1E9 / 3686400 => * 78125 / 288)
>   */
> -unsigned long long sched_clock(void)
> +unsigned long long notrace sched_clock(void)
>  {
>  	unsigned long long v = cnt32_to_63(OSCR);
> 
> --- a/arch/arm/mach-versatile/core.c
> +++ b/arch/arm/mach-versatile/core.c
> @@ -237,7 +237,7 @@ void __init versatile_map_io(void)
>   * long as there is always less than 89 seconds between successive
>   * calls to this function.
>   */
> -unsigned long long sched_clock(void)
> +unsigned long long notrace sched_clock(void)
>  {
>  	unsigned long long v = cnt32_to_63(readl(VERSATILE_REFCOUNTER));
> 
> --- a/arch/arm/plat-omap/common.c
> +++ b/arch/arm/plat-omap/common.c
> @@ -185,7 +185,7 @@ console_initcall(omap_add_serial_console
> 
>  #include <linux/clocksource.h>
> 
> -static cycle_t omap_32k_read(struct clocksource *cs)
> +static cycle_t notrace omap_32k_read(struct clocksource *cs)
>  {
>  	return omap_readl(TIMER_32K_SYNCHRONIZED);
>  }
> @@ -203,7 +203,7 @@ static struct clocksource clocksource_32
>   * Returns current time from boot in nsecs. It's OK for this to wrap
>   * around for now, as it's just a relative time stamp.
>   */
> -unsigned long long sched_clock(void)
> +unsigned long long notrace sched_clock(void)
>  {
>  	unsigned long long ret;
> 
> 
> 
