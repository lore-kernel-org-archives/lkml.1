Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbZIPF7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbZIPF7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 01:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752963AbZIPF7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 01:59:31 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:19769 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbZIPF7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 01:59:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ni6uwZEZgM79kLVIVdeCkLbh4aGvdjY2E82MBYn5FKpBttbo6JDuBx3X/xsMlX/SWz
         MdWQUVcgP2yKQZnKVZB4Ibkb/rq1ULI6M3ONewH1Yud3fMkoXcNZv+MJhb6Q5dJh9Kx7
         WkDkIEgtCefBhJA3AAJzsctHpiLcZDhvGlgb8=
Date: Wed, 16 Sep 2009 07:59:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ftrace: Add timer-source of walltime for ftrace
Message-ID: <20090916055928.GF5121@nowhere>
References: <alpine.DEB.2.00.0907272218480.30108@gandalf.stny.rr.com> <4A89213C.5090109@cn.fujitsu.com> <20090818215620.A63C.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0908181454090.727@gandalf.stny.rr.com> <4A939CDF.2000407@cn.fujitsu.com> <4AB076DE.10604@cn.fujitsu.com> <4AB077AF.6080800@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB077AF.6080800@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 01:29:19PM +0800, Zhaolei wrote:
> We can add a timer-source for ftrace to support wall-time display.
> It is based on Steven Rostedt <rostedt@goodmis.org>'s suggestion in:
> http://lkml.org/lkml/2009/7/24/103
> 
> It need to applys on my patch of:
> [PATCH v4 1/2] Add function to convert between calendar time and broken-down time for universal use
> 
> We can get following output:
>  # cd /mnt/debugfs/tracing/
>  # cat trace_clock
>  [local] global walltime
>  # echo sched_switch > current_tracer
>  # cat trace
>  # tracer: sched_switch
>  #
>  #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
>  #              | |       |          |         |
>              bash-3580  [000]  2916.188093:   3580:120:S   + [000]  3580:120:S bash
>              bash-3580  [000]  2916.188205:   3580:120:S   + [000]  3580:120:S bash
>              bash-3580  [000]  2916.188538:   3580:120:R   + [000]     5:115:S events/0
>              bash-3580  [000]  2916.188599:   3580:120:R ==> [000]     5:115:R events/0
>          events/0-5     [000]  2916.188669:      5:115:S ==> [000]  3580:120:R bash
>  ...
>  # echo walltime > trace_clock
>  # cat trace
>  # tracer: sched_switch
>  #
>  #           TASK-PID    CPU#           TIMESTAMP  FUNCTION
>  #              | |       |                        |         |




The headers seem a bit broken. Is it a copy paste effect or?



>              bash-3580  [000] 2009-08-24 18:03:16.500705:   3580:120:S   + [000]  3580:120:S bash
>              bash-3580  [000] 2009-08-24 18:03:16.500815:   3580:120:S   + [000]  3580:120:S bash
>              bash-3580  [000] 2009-08-24 18:03:16.500815:   3580:120:S   + [000]  3580:120:S bash
>              bash-3580  [000] 2009-08-24 18:03:16.500815:   3580:120:S ==> [000]     5:115:R events/0
>          events/0-5     [000] 2009-08-24 18:03:16.500815:      5:115:R   + [000]  3578:120:S sshd
>  ...


But nice result :)


> 
> Changelog:
> v1->v2: Rebase to top of tip tree.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  include/linux/trace_clock.h |    1 +
>  kernel/trace/trace.c        |   24 ++++++++++++++++-----
>  kernel/trace/trace.h        |    8 ++++++-
>  kernel/trace/trace_clock.c  |   48 +++++++++++++++++++++++++++++++++++++++++++
>  kernel/trace/trace_output.c |   21 +++++++++++++++---
>  5 files changed, 91 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/trace_clock.h b/include/linux/trace_clock.h
> index 7a81303..322707e 100644
> --- a/include/linux/trace_clock.h
> +++ b/include/linux/trace_clock.h
> @@ -15,5 +15,6 @@
>  extern u64 notrace trace_clock_local(void);
>  extern u64 notrace trace_clock(void);
>  extern u64 notrace trace_clock_global(void);
> +extern u64 notrace trace_clock_walltime(void);
>  
>  #endif /* _LINUX_TRACE_CLOCK_H */
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index fd52a19..160b6a8 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -335,9 +335,10 @@ static struct {
>  } trace_clocks[] = {
>  	{ trace_clock_local,	"local" },
>  	{ trace_clock_global,	"global" },
> +	{ trace_clock_walltime,	"walltime" },
>  };
>  
> -int trace_clock_id;
> +enum TRACE_CLOCK_TYPE trace_clock_type = TRACE_CLOCK_LOCAL;



Uppercase names are usually reserved for CPP macros.



>  
>  /*
>   * trace_parser_get_init - gets the buffer for trace parser
> @@ -1653,8 +1654,17 @@ static void print_lat_help_header(struct seq_file *m)
>  
>  static void print_func_help_header(struct seq_file *m)
>  {
> -	seq_puts(m, "#           TASK-PID    CPU#    TIMESTAMP  FUNCTION\n");
> -	seq_puts(m, "#              | |       |          |         |\n");
> +	if (trace_clock_type == TRACE_CLOCK_WALLTIME) {
> +		seq_puts(m, "#           TASK-PID    CPU# "
> +			"          TIMESTAMP  FUNCTION\n");
> +		seq_puts(m, "#              | |       |   "
> +			"                     |         |\n");
> +	} else {
> +		seq_puts(m, "#           TASK-PID    CPU# "
> +			"   TIMESTAMP  FUNCTION\n");
> +		seq_puts(m, "#              | |       |   "
> +			"       |         |\n");
> +	}
>  }
>  
>  
> @@ -3387,8 +3397,8 @@ static ssize_t tracing_clock_read(struct file *filp, char __user *ubuf,
>  	for (i = 0; i < ARRAY_SIZE(trace_clocks); i++)
>  		bufiter += snprintf(buf + bufiter, sizeof(buf) - bufiter,
>  			"%s%s%s%s", i ? " " : "",
> -			i == trace_clock_id ? "[" : "", trace_clocks[i].name,
> -			i == trace_clock_id ? "]" : "");
> +			i == trace_clock_type ? "[" : "", trace_clocks[i].name,
> +			i == trace_clock_type ? "]" : "");
>  	bufiter += snprintf(buf + bufiter, sizeof(buf) - bufiter, "\n");
>  
>  	return simple_read_from_buffer(ubuf, cnt, ppos, buf, bufiter);
> @@ -3418,7 +3428,7 @@ static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
>  	if (i == ARRAY_SIZE(trace_clocks))
>  		return -EINVAL;
>  
> -	trace_clock_id = i;
> +	trace_clock_type = i;
>  
>  	mutex_lock(&trace_types_lock);
>  
> @@ -3428,6 +3438,8 @@ static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
>  
>  	mutex_unlock(&trace_types_lock);
>  
> +	tracing_reset_online_cpus(&global_trace);
> +
>  	*fpos += cnt;
>  
>  	return cnt;
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index e747162..afee4de 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -475,7 +475,13 @@ int trace_array_printk(struct trace_array *tr,
>  
>  extern unsigned long trace_flags;
>  
> -extern int trace_clock_id;
> +enum TRACE_CLOCK_TYPE {
> +	TRACE_CLOCK_LOCAL,
> +	TRACE_CLOCK_GLOBAL,
> +	TRACE_CLOCK_WALLTIME,
> +};
> +
> +extern enum TRACE_CLOCK_TYPE trace_clock_type;
>  
>  /* Standard output formatting function used for function return traces */
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
> diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
> index b588fd8..2b23023 100644
> --- a/kernel/trace/trace_clock.c
> +++ b/kernel/trace/trace_clock.c
> @@ -19,6 +19,7 @@
>  #include <linux/sched.h>
>  #include <linux/ktime.h>
>  #include <linux/trace_clock.h>
> +#include <trace/events/xtime.h>
>  
>  /*
>   * trace_clock_local(): the simplest and least coherent tracing clock.
> @@ -107,3 +108,50 @@ u64 notrace trace_clock_global(void)
>  
>  	return now;
>  }
> +
> +/*
> + * the number of nanoseconds from 1970-1-1 00:00:00 to
> + * machine boots (trace_clock()==0)
> + */
> +static u64 base_walltime;
> +
> +static void sync_base_walltime(struct timespec *ts, u64 traceclock)
> +{
> +	base_walltime = (u64)ts->tv_sec * NSEC_PER_SEC + ts->tv_nsec -
> +			traceclock;
> +}
> +
> +static void probe_gtod_update_xtime(struct timespec *xtime,
> +				    struct timespec *wall_to_monotonic)
> +{
> +	unsigned long flags;
> +	u64 traceclock;
> +
> +	local_irq_save(flags);
> +	traceclock = trace_clock();
> +	sync_base_walltime(xtime, traceclock);
> +	local_irq_restore(flags);
> +}



I don't know how much we want a high level of precision but
if we are in the local clock, traceclock may have a small
imprecision basis across cpus.

Well, I guess that's not a big deal though.



> +
> +static int __init walltime_init(void)
> +{
> +	unsigned long flags;
> +	struct timespec ts;
> +	u64 traceclock;
> +
> +	local_irq_save(flags);
> +	getnstimeofday(&ts);
> +	traceclock = trace_clock();
> +	sync_base_walltime(&ts, traceclock);
> +	local_irq_restore(flags);
> +
> +	register_trace_gtod_update_xtime(probe_gtod_update_xtime);
> +
> +	return 0;
> +}
> +device_initcall_sync(walltime_init);
> +
> +u64 notrace trace_clock_walltime(void)
> +{
> +	return base_walltime + trace_clock();
> +}
> diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> index f572f44..2116c5f 100644
> --- a/kernel/trace/trace_output.c
> +++ b/kernel/trace/trace_output.c
> @@ -527,15 +527,28 @@ int trace_print_context(struct trace_iterator *iter)
>  {
>  	struct trace_seq *s = &iter->seq;
>  	struct trace_entry *entry = iter->ent;
> -	unsigned long long t = ns2usecs(iter->ts);
> -	unsigned long usec_rem = do_div(t, USEC_PER_SEC);
> -	unsigned long secs = (unsigned long)t;
>  	char comm[TASK_COMM_LEN];
>  
>  	trace_find_cmdline(entry->pid, comm);
>  
> -	return trace_seq_printf(s, "%16s-%-5d [%03d] %5lu.%06lu: ",
> +	if (trace_clock_type == TRACE_CLOCK_WALLTIME) {
> +		struct tm tm;
> +		u32 remainder;
> +		time_to_tm(div_u64_rem(iter->ts, NSEC_PER_SEC, &remainder),
> +				-sys_tz.tz_minuteswest * 60, &tm);
> +		return trace_seq_printf(s, "%16s-%-5d [%03d] "
> +				"%04ld-%02d-%02d %02d:%02d:%02d.%06llu: ",
> +				comm, entry->pid, iter->cpu,
> +				tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
> +				tm.tm_hour, tm.tm_min, tm.tm_sec,
> +				ns2usecs(remainder));
> +	} else {
> +		unsigned long long t = ns2usecs(iter->ts);
> +		unsigned long usec_rem = do_div(t, USEC_PER_SEC);
> +		unsigned long secs = (unsigned long)t;
> +		return trace_seq_printf(s, "%16s-%-5d [%03d] %5lu.%06lu: ",
>  				comm, entry->pid, iter->cpu, secs, usec_rem);
> +	}
>  }
>  
>  int trace_print_lat_context(struct trace_iterator *iter)
> -- 
> 1.5.5.3
> 
> 


Other than that, that looks good!

Thanks.

