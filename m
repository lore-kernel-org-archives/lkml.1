Return-Path: <linux-kernel-owner+w=401wt.eu-S965551AbXHaUrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965551AbXHaUrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 16:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759045AbXHaUrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 16:47:14 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36552 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710AbXHaUrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 16:47:13 -0400
Subject: Re: [PATCH] Fix discrepancy between VDSO based gettimeofday() and
	sys_gettimeofday().
From: john stultz <johnstul@us.ibm.com>
To: Tony Breeds <tony@bakeyournoodle.com>
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>
In-Reply-To: <20070831034134.GP10345@bakeyournoodle.com>
References: <20070831034134.GP10345@bakeyournoodle.com>
Content-Type: text/plain
Date: Fri, 31 Aug 2007 13:46:33 -0700
Message-Id: <1188593193.6479.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-31 at 13:41 +1000, Tony Breeds wrote:
> On platforms that copy sys_tz into the vdso (currently only x86_64, soon
> to include powerpc), it is possible for the vdso to get out of sync if a
> user calls (admittedly unusual) settimeofday(NULL, ptr).
> 
> This patch adds a hook for architectures that set CONFIG_GENERIC_TIME_VSYSCALL
> to ensure when sys_tz is updated they can also updater their copy in the vdso.

Ah. Yea, so after a sys_tz update, until the next timer tick, its
possible to get the stale value. Good catch.

One little comment below.

> Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: John Stultz <johnstul@us.ibm.com>
> ---
> 
> Only compile tested for IA64
> Testcase at: http://bakeyournoodle.com/~tony/settimeofday-0.0/
> I guess this is aimed at 2.6.24
> 
>  arch/ia64/kernel/time.c       |    5 +++++
>  arch/x86_64/kernel/vsyscall.c |   11 ++++++++++-
>  include/linux/clocksource.h   |    5 +++++
>  kernel/time.c                 |    2 ++
>  4 files changed, 22 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
> index 98cfc90..2bb8421 100644
> --- a/arch/ia64/kernel/time.c
> +++ b/arch/ia64/kernel/time.c
> @@ -371,6 +371,11 @@ ia64_setup_printk_clock(void)
>  		ia64_printk_clock = ia64_itc_printk_clock;
>  }
> 
> +/* IA64 doesn't cache the timezone */
> +void update_vsyscall_tz(void)
> +{
> +}
> +
>  void update_vsyscall(struct timespec *wall, struct clocksource *c)
>  {
>          unsigned long flags;
> diff --git a/arch/x86_64/kernel/vsyscall.c b/arch/x86_64/kernel/vsyscall.c
> index 06c3494..4ff78b0 100644
> --- a/arch/x86_64/kernel/vsyscall.c
> +++ b/arch/x86_64/kernel/vsyscall.c
> @@ -66,6 +66,16 @@ struct vsyscall_gtod_data __vsyscall_gtod_data __section_vsyscall_gtod_data =
>  	.sysctl_enabled = 1,
>  };
> 
> +void update_vsyscall_tz(void)
> +{
> +	unsigned long flags;
> +
> +	write_seqlock_irqsave(&vsyscall_gtod_data.lock, flags);
> +	/* sys_tz has changed */
> +	vsyscall_gtod_data.sys_tz = sys_tz;
> +	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
> +}
> +
>  void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
>  {
>  	unsigned long flags;
> @@ -79,7 +89,6 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
>  	vsyscall_gtod_data.clock.shift = clock->shift;
>  	vsyscall_gtod_data.wall_time_sec = wall_time->tv_sec;
>  	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
> -	vsyscall_gtod_data.sys_tz = sys_tz;
>  	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
>  	vsyscall_gtod_data.wall_to_monotonic = wall_to_monotonic;
>  	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);


Hmm.. I might just extend update_vsyscall() so it takes a timezone and
then it only updates bits that have non-null pointers. Then call it from
sys_settimeofday(). This cuts down the functions each arch has to
implement, and also makes sure we get the full update each tick.

Alternatively update_vsyscall_tz() could live in timekeeping.c, grab the
appropriate locks and static data and call update_vsyscall(), also
minimizing the per-arch logic.

But your way is correct, and fixes a bug, so I won't stand in the way of
it.

-john

