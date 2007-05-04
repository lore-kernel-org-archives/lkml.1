Return-Path: <linux-kernel-owner+w=401wt.eu-S1161404AbXEDSTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161404AbXEDSTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161386AbXEDSTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:19:38 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59853 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031510AbXEDSSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:18:55 -0400
Subject: Re: Broken process startup times after suspend (regression)
From: john stultz <johnstul@us.ibm.com>
To: Tomas Janousek <tjanouse@redhat.com>
Cc: linux-kernel@vger.kernel.org, tsmetana@redhat.com, riel@redhat.com
In-Reply-To: <20070504161302.GA8962@redhat.com>
References: <20070503150320.GA21471@redhat.com>
	 <1178222360.6085.14.camel@localhost.localdomain>
	 <20070504161302.GA8962@redhat.com>
Content-Type: text/plain
Date: Fri, 04 May 2007 11:18:52 -0700
Message-Id: <1178302732.5929.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-04 at 18:13 +0200, Tomas Janousek wrote:
> Hi,
> 
> On Thu, May 03, 2007 at 12:59:20PM -0700, john stultz wrote:
> > Indeed. The monotonic clock's behavior around suspend and resume is
> > poorly defined. When we increased it, folks didn't like the fact that
> > uptime would increase while a system was suspended. 
> 
> Seems like your change also made accounting and OOM calculations behave more
> correctly. And my previous patch broke that completely, because they would use
> "your" uptime and "my" process start time, resulting in negative numbers when
> calculating the process uptime. Therefore, I had to create another start_time
> in the task_struct.
> 
> > > I was thinking about a solution and I am posting the least intrusive one I
> > > found. I add a total_sleep_time variable which is to be added to
> > > wall_to_monotonic when one wants the proper boot time. I do by no means say
> > > it's the best one, I expect comments.
> > 
> > While I'd prefer wrapping it in a interface and keeping it in
> > timekeeping (rather then exporting a collection of values that should be
> > combined in varying ways), I think this approach is probably the best.
> > Rather then forcing one behavior or the other we can provide both smooth
> > monotonic and monotonic w/ sleep.
> 
> Ok, thanks for the comment, I did so.

Looks great! Just a few minor comments.


> And here's new patch:
> 
> 
> From: Tomas Janousek <tjanouse@redhat.com>
> Subject: [PATCH] Fix boot time and process startup times after suspend
> 
> The commits
>   411187fb05cd11676b0979d9fbf3291db69dbce2 (GTOD: persistent clock support)
>   c1d370e167d66b10bca3b602d3740405469383de (i386: use GTOD persistent clock
>     support)
> changed the monotonic time so that it no longer jumps after resume, but it's
> not possible to use it for boot time and process start time calculations then.
> 
> I add a getboottime function to get the real boot time and a boot-based time
> concept. Because we need a process start time corresponding to the monotonic
> time, I add real_start_time to the task_struct which is then used in
> /proc/pid/stat. The /proc/stat's btime uses getboottime instead of the
> monotonic time offset as well.
> 
> Signed-off-by: Tomas Janousek <tjanouse@redhat.com>
> Cc: Tomas Smetana <tsmetana@redhat.com>
> ---
>  fs/proc/array.c       |    5 +++--
>  fs/proc/proc_misc.c   |    8 +++++---
>  include/linux/ktime.h |    2 ++
>  include/linux/sched.h |    2 +-
>  include/linux/time.h  |    2 ++
>  kernel/fork.c         |    1 +
>  kernel/hrtimer.c      |   27 +++++++++++++++++++++++++++
>  kernel/timer.c        |   21 +++++++++++++++++++++
>  8 files changed, 62 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index 07c9cdb..831734c 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -405,8 +405,9 @@ static int do_task_stat(struct task_struct *task, char * buffer, int whole)
>  
>  	/* Temporary variable needed for gcc-2.96 */
>  	/* convert timespec -> nsec*/
> -	start_time = (unsigned long long)task->start_time.tv_sec * NSEC_PER_SEC
> -				+ task->start_time.tv_nsec;
> +	start_time =
> +		(unsigned long long)task->real_start_time.tv_sec * NSEC_PER_SEC
> +				+ task->real_start_time.tv_nsec;
>  	/* convert nsec -> ticks */
>  	start_time = nsec_to_clock_t(start_time);
>  
> diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
> index e2c4c0a..b1791a0 100644
> --- a/fs/proc/proc_misc.c
> +++ b/fs/proc/proc_misc.c
> @@ -453,12 +453,14 @@ static int show_stat(struct seq_file *p, void *v)
>  	unsigned long jif;
>  	cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
>  	u64 sum = 0;
> +	struct timespec boottime;
>  
>  	user = nice = system = idle = iowait =
>  		irq = softirq = steal = cputime64_zero;
> -	jif = - wall_to_monotonic.tv_sec;
> -	if (wall_to_monotonic.tv_nsec)
> -		--jif;
> +	getboottime(&boottime);
> +	jif = boottime.tv_sec;
> +	if (boottime.tv_nsec)
> +		++jif;
>  
>  	for_each_possible_cpu(i) {
>  		int j;
> diff --git a/include/linux/ktime.h b/include/linux/ktime.h
> index 248305b..346c1e1 100644
> --- a/include/linux/ktime.h
> +++ b/include/linux/ktime.h
> @@ -269,6 +269,8 @@ static inline s64 ktime_to_ns(const ktime_t kt)
>  
>  /* Get the monotonic time in timespec format: */
>  extern void ktime_get_ts(struct timespec *ts);
> +/* Get the boot based time in timespec format: */
> +extern void bbtime_get_ts(struct timespec *ts);
>  
>  /* Get the real (wall-) time in timespec format: */
>  #define ktime_get_real_ts(ts)	getnstimeofday(ts)
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 49fe299..0845bde 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -884,7 +884,7 @@ struct task_struct {
>  	unsigned long rt_priority;
>  	cputime_t utime, stime;
>  	unsigned long nvcsw, nivcsw; /* context switch counts */
> -	struct timespec start_time;
> +	struct timespec start_time, real_start_time;
>  /* mm fault and swap info: this can arguably be seen as either mm-specific or thread-specific */
>  	unsigned long min_flt, maj_flt;
>  
> diff --git a/include/linux/time.h b/include/linux/time.h
> index 8ea8dea..a52f481 100644
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
> @@ -116,6 +117,7 @@ extern int do_setitimer(int which, struct itimerval *value,
>  extern unsigned int alarm_setitimer(unsigned int seconds);
>  extern int do_getitimer(int which, struct itimerval *value);
>  extern void getnstimeofday(struct timespec *tv);
> +extern void getboottime(struct timespec *ts);
>  
>  extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
>  extern int timekeeping_is_continuous(void);
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 6af959c..b10d9b7 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1056,6 +1056,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  
>  	p->lock_depth = -1;		/* -1 = no lock */
>  	do_posix_clock_monotonic_gettime(&p->start_time);
> +	bbtime_get_ts(&p->real_start_time);
>  	p->security = NULL;
>  	p->io_context = NULL;
>  	p->io_wait = NULL;

Since both do_posix_clock_monotonic_gettime and bbtime_get_ts actually
read the timekeeping hardware (which could cost around 1.5us each), we
probably will want to optimize this down to a single read, or just avoid
the hardware read and take lower-granularity xtime value.

However, I'm not sure how fine-grained the start_time values need to be.

> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index b74860a..cd744a1 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -128,6 +128,33 @@ void ktime_get_ts(struct timespec *ts)
>  }
>  EXPORT_SYMBOL_GPL(ktime_get_ts);
>  
> +/**
> + * bbtime_get_ts - get the boot based clock in timespec format
> + * @ts:		pointer to timespec variable
> + *
> + * The function calculates the boot based clock from the realtime
> + * clock, the wall_to_monotonic offset and the total sleep time and
> + * stores the result in normalized timespec format in the variable
> + * pointed to by @ts.

You might want to clarify this as being the "monotonic boot time", or
the time the system has been running including sleep time and that calls
to settimeofday() will not affect this value.

> + */
> +void bbtime_get_ts(struct timespec *ts)

Any reason you added this in hrtimer.c instead of timer.c? I think
keeping the new functions closer together would make the subtle
difference between them more clear, and would allow total_sleep_time to
be static to one file.

> +{
> +	struct timespec tobb;
> +	unsigned long seq;
> +
> +	do {
> +		seq = read_seqbegin(&xtime_lock);
> +		getnstimeofday(ts);
> +		tobb = wall_to_monotonic;
> +		tobb.tv_sec += total_sleep_time;
> +
> +	} while (read_seqretry(&xtime_lock, seq));
> +
> +	set_normalized_timespec(ts, ts->tv_sec + tobb.tv_sec,
> +				ts->tv_nsec + tobb.tv_nsec);
> +}
> +EXPORT_SYMBOL_GPL(bbtime_get_ts);
> +
>  /*
>   * Get the coarse grained time at the softirq based on xtime and
>   * wall_to_monotonic.
> diff --git a/kernel/timer.c b/kernel/timer.c
> index dd6c2c1..a1a8ccb 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -759,9 +759,13 @@ unsigned long next_timer_interrupt(void)
>   * at zero at system boot time, so wall_to_monotonic will be negative,
>   * however, we will ALWAYS keep the tv_nsec part positive so we can use
>   * the usual normalization.
> + *
> + * We need to add total_sleep_time to wall_to_monotonic to get the real boot
> + * time.
>   */
>  struct timespec xtime __attribute__ ((aligned (16)));
>  struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
> +unsigned long total_sleep_time;
>  
>  EXPORT_SYMBOL(xtime);
>  
> @@ -832,6 +836,21 @@ void getnstimeofday(struct timespec *ts)
>  EXPORT_SYMBOL(getnstimeofday);
>  
>  /**
> + * getboottime - Return the real time of system boot.
> + * @ts: 	pointer to the timespec to be set

Might want to clarify this as being the "boot time" based on the current
CLOCK_REALTIME clock, noting that calls to settimeofday() would affect
this value.

> + * Returns the time of day in a timespec.
> + */
> +void getboottime(struct timespec *ts)
> +{
> +	set_normalized_timespec(ts,
> +		- (wall_to_monotonic.tv_sec + total_sleep_time),
> +		- wall_to_monotonic.tv_nsec);
> +}
> +
> +EXPORT_SYMBOL(getboottime);
> +
> +/**
>   * do_gettimeofday - Returns the time of day in a timeval
>   * @tv:		pointer to the timeval to be set
>   *
> @@ -975,6 +994,7 @@ void __init timekeeping_init(void)
>  	xtime.tv_nsec = 0;
>  	set_normalized_timespec(&wall_to_monotonic,
>  		-xtime.tv_sec, -xtime.tv_nsec);
> +	total_sleep_time = 0;
>  
>  	write_sequnlock_irqrestore(&xtime_lock, flags);
>  }
> @@ -1004,6 +1024,7 @@ static int timekeeping_resume(struct sys_device *dev)
>  
>  		xtime.tv_sec += sleep_length;
>  		wall_to_monotonic.tv_sec -= sleep_length;
> +		total_sleep_time += sleep_length;
>  	}
>  	/* re-base the last cycle value */
>  	clock->cycle_last = clocksource_read(clock);


The only other gotcha is that this patch conflicts with a 2.6.22 queued
patch in -mm that moves the majority of timekeeping code in
kernel/timer.c to kernel/time/timekeeping.c

So it might be easiest to re-diff this against -mm and send it to Andrew
for inclusion along with the cleanups. However, since this is a fix, it
should have priority over cleanups. I just don't want to upset Andrew's
tree too much :)

Your thoughts?
-john

