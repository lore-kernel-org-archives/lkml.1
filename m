Return-Path: <linux-kernel-owner+w=401wt.eu-S1755116AbZEGOJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbZEGOJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 10:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbZEGOJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 10:09:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:56576 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbZEGOJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 10:09:01 -0400
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to use a different sched_clock() for ftrace on omap?
References: <cyZbZ-7Eg-9@gated-at.bofh.it>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Thu, 07 May 2009 07:08:58 -0700
In-Reply-To: <cyZbZ-7Eg-9@gated-at.bofh.it> (Tim Bird's message of "Thu\, 07 May 2009 02\:00\:11 +0200")
Message-ID: <8763gdt37p.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Bird <tim.bird@am.sony.com> writes:

> Hi all,
>
> I've worked up a replacement sched_clock for ftrace on my omap platform.
> The current sched_clock, based on the 32K timer, has low resolution and
> doesn't provide very useful results.
>
> Unfortunately, I'm not sure the best way to use my special one, in place
> of a common one in arch/arm/plat-omap/common.c

Hi Tim,

If you're comiling mach-omap1/time.c than you've enabled the
higher-resolution MPU timer with CONFIG_OMAP_MPU_TIMER, right?

In that case, you could make the one in plat-omap/common.c inside and
#ifndef CONFIG_OMAP_MPU_TIMER and put the new one in the MPU_TIMER
code.

To be complete, you should add the same to the mach-omap2/timer-gp.c
as well.

Kevin

> Here's a patch:
>
> ---
>  arch/arm/mach-omap1/time.c  |    9 +++++++++
>  arch/arm/plat-omap/common.c |    2 +-
>  2 files changed, 10 insertions(+), 1 deletion(-)
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
> +	ret = (ret * clocksource_mpu.mult_orig) >>clocksource_mpu.shift;
> +	return ret;
> +}
> +
>  static void __init omap_init_clocksource(unsigned long rate)
>  {
>  	static char err[] __initdata = KERN_ERR
> --- a/arch/arm/plat-omap/common.c
> +++ b/arch/arm/plat-omap/common.c
> @@ -203,7 +203,7 @@ static struct clocksource clocksource_32
>   * Returns current time from boot in nsecs. It's OK for this to wrap
>   * around for now, as it's just a relative time stamp.
>   */
> -unsigned long long notrace sched_clock(void)
> +__attribute__((weak)) unsigned long long notrace sched_clock_old(void)
>  {
>  	unsigned long long ret;
>
>
> Obviously, renaming the common sched_clock() to sched_clock_old() is
> a hack.
>
> I thought the __attribute__ ((weak)) would be enough to have the
> sched_clock() in common.c get out of the way, and allow my board-specific
> sched_clock() to be used.  But that didn't work.  What is the recommended
> way to specify a board-specific function at compile time?
>
> Thanks,
>  -- Tim
>
> =============================
> Tim Bird
> Architecture Group Chair, CE Linux Forum
> Senior Staff Engineer, Sony Corporation of America
> =============================
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
