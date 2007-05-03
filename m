Return-Path: <linux-kernel-owner+w=401wt.eu-S1752140AbXECT70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbXECT70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 15:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbXECT70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 15:59:26 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:44447 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbXECT7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 15:59:25 -0400
Subject: Re: Broken process startup times after suspend (regression)
From: john stultz <johnstul@us.ibm.com>
To: Tomas Janousek <tjanouse@redhat.com>
Cc: linux-kernel@vger.kernel.org, tsmetana@redhat.com, riel@redhat.com
In-Reply-To: <20070503150320.GA21471@redhat.com>
References: <20070503150320.GA21471@redhat.com>
Content-Type: text/plain
Date: Thu, 03 May 2007 12:59:20 -0700
Message-Id: <1178222360.6085.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-03 at 17:03 +0200, Tomas Janousek wrote:
> Hi,
> 
> the commits
>   411187fb05cd11676b0979d9fbf3291db69dbce2 (GTOD: persistent clock support)
>   c1d370e167d66b10bca3b602d3740405469383de (i386: use GTOD persistent clock
>     support)
> caused a change in the way uptime is measured and introduced a regression such
> that it's no longer possible to obtain a correct process start time or the
> system boot time.
> 
> These two commits make the monotonic time not jump by hudreds of seconds after
> the kernel resumes from suspend, but they achieve it by moving the
> wall_to_monotonic offset, which is used for all boot time / uptime
> calculations. It's not possible to read the real boot time / process start
> time then.

Indeed. The monotonic clock's behavior around suspend and resume is
poorly defined. When we increased it, folks didn't like the fact that
uptime would increase while a system was suspended. 

> I was thinking about a solution and I am posting the least intrusive one I
> found. I add a total_sleep_time variable which is to be added to
> wall_to_monotonic when one wants the proper boot time. I do by no means say
> it's the best one, I expect comments.

While I'd prefer wrapping it in a interface and keeping it in
timekeeping (rather then exporting a collection of values that should be
combined in varying ways), I think this approach is probably the best.
Rather then forcing one behavior or the other we can provide both smooth
monotonic and monotonic w/ sleep.

> This requires a patch to procps that makes it use /proc/stat's btime instead
> of "now - uptime". This was written by Tomas Smetana and I'm attaching it as
> well. (It was posted upstream as it fixes another bug in ps as well.) Or we
> could just make the /proc/uptime contain "now - btime" like it used to before
> those two commits.
> 
> ---
>  fs/proc/proc_misc.c  |    2 +-
>  include/linux/time.h |    1 +
>  kernel/fork.c        |    1 +
>  kernel/timer.c       |    6 ++++++
>  4 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
> index e2c4c0a..a29309e 100644
> --- a/fs/proc/proc_misc.c
> +++ b/fs/proc/proc_misc.c
> @@ -456,7 +456,7 @@ static int show_stat(struct seq_file *p, void *v)
> 
>  	user = nice = system = idle = iowait =
>  		irq = softirq = steal = cputime64_zero;
> -	jif = - wall_to_monotonic.tv_sec;
> +	jif = - (wall_to_monotonic.tv_sec + total_sleep_time);
>  	if (wall_to_monotonic.tv_nsec)
>  		--jif;

As I said, could we wrap this in a function? 

Maybe something like get_monotonicwithsleep_time() (feel free to come up
with a better name :).

> diff --git a/include/linux/time.h b/include/linux/time.h
> index 8ea8dea..cb87616 100644
> --- a/include/linux/time.h
> +++ b/include/linux/time.h
> @@ -90,6 +90,7 @@ static inline struct timespec timespec_sub(struct timespec lhs,
> 
>  extern struct timespec xtime;
>  extern struct timespec wall_to_monotonic;
> +extern unsigned long total_sleep_time;
>  extern seqlock_t xtime_lock __attribute__((weak));
> 
>  extern unsigned long read_persistent_clock(void);
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 6af959c..c051f17 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1056,6 +1056,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
> 
>  	p->lock_depth = -1;		/* -1 = no lock */
>  	do_posix_clock_monotonic_gettime(&p->start_time);
> +	p->start_time.tv_sec += total_sleep_time;
>  	p->security = NULL;
>  	p->io_context = NULL;
>  	p->io_wait = NULL;
> diff --git a/kernel/timer.c b/kernel/timer.c
> index dd6c2c1..13eb201 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -759,9 +759,13 @@ unsigned long next_timer_interrupt(void)
>   * at zero at system boot time, so wall_to_monotonic will be negative,
>   * however, we will ALWAYS keep the tv_nsec part positive so we can use
>   * the usual normalization.
> + *
> + * One needs to add total_sleep_time to wall_to_monotonic to get the real boot
> + * time.
>   */
>  struct timespec xtime __attribute__ ((aligned (16)));
>  struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
> +unsigned long total_sleep_time;
> 
>  EXPORT_SYMBOL(xtime);
> 
> @@ -975,6 +979,7 @@ void __init timekeeping_init(void)
>  	xtime.tv_nsec = 0;
>  	set_normalized_timespec(&wall_to_monotonic,
>  		-xtime.tv_sec, -xtime.tv_nsec);
> +	total_sleep_time = 0;
> 
>  	write_sequnlock_irqrestore(&xtime_lock, flags);
>  }
> @@ -1004,6 +1009,7 @@ static int timekeeping_resume(struct sys_device *dev)
> 
>  		xtime.tv_sec += sleep_length;
>  		wall_to_monotonic.tv_sec -= sleep_length;
> +		total_sleep_time += sleep_length;
>  	}
>  	/* re-base the last cycle value */
>  	clock->cycle_last = clocksource_read(clock);

Otherwise it looks good.

Thanks for bringing this up!
-john


