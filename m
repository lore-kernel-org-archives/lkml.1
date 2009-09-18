Return-Path: <linux-kernel-owner+w=401wt.eu-S933311AbZIRThv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311AbZIRThv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 15:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758069AbZIRTht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 15:37:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36633 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758074AbZIRTht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 15:37:49 -0400
Subject: Re: [git pull] timechart for -tip
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       lizf@cn.fujitsu.com
In-Reply-To: <20090918212636.627cf799@infradead.org>
References: <20090917221337.7a7b3c81@infradead.org>
	 <20090918212636.627cf799@infradead.org>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 21:37:45 +0200
Message-Id: <1253302665.10538.54.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 21:26 +0200, Arjan van de Ven wrote:

> @@ -3098,7 +3102,10 @@ static void perf_counter_task_output(struct perf_counter *counter,
>  	task_event->event.tid = perf_counter_tid(counter, task);
>  	task_event->event.ptid = perf_counter_tid(counter, current);
>  
> +	task_event->event.time = sched_clock();
> +
>  	perf_output_put(&handle, task_event->event);
> +
>  	perf_output_end(&handle);
>  }
>  

That's supposed to be perf_clock(), someone made me change that just
now :-)

> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 2459e5a..7ac1968 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -47,6 +47,7 @@ static int			append_file			= 0;
>  static int			call_graph			= 0;
>  static int			inherit_stat			= 0;
>  static int			no_samples			= 0;
> +static int			timechart			= 0;
>  static int			sample_address			= 0;
>  static int			multiplex			= 0;
>  static int			multiplex_fd			= -1;
> @@ -387,6 +388,12 @@ static void create_counter(int counter, int cpu, pid_t pid)
>  
>  	attr->sample_type	|= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
>  
> +	if (timechart) {
> +		attr->sample_type |= PERF_SAMPLE_CPU;
> +		attr->sample_type |= PERF_SAMPLE_TIME;
> +		attr->sample_type |= PERF_SAMPLE_RAW;
> +	}
> +
>  	if (freq) {
>  		attr->sample_type	|= PERF_SAMPLE_PERIOD;
>  		attr->freq		= 1;
> @@ -661,6 +668,24 @@ static int __cmd_record(int argc, const char **argv)
>  	return 0;
>  }
>  
> +static int do_timechart(const struct option *opt __used, const char *str __used, int unset __used)
> +{
> +	parse_events(NULL, "power:power_start", 0);
> +	parse_events(NULL, "power:power_end", 0);
> +	parse_events(NULL, "power:power_frequency", 0);
> +	parse_events(NULL, "sched:sched_wakeup", 0);
> +	parse_events(NULL, "sched:sched_switch", 0);
> +	default_interval = 1;
> +	system_wide = 1;
> +	timechart = 1;
> +	if (!nr_counters) {
> +		printf("No counters found.. is debugfs mounted?\n");
> +		exit(0);
> +	}
> +	return 0;
> +}
> +
> +
>  static const char * const record_usage[] = {
>  	"perf record [<options>] [<command>]",
>  	"perf record [<options>] -- <command> [<options>]",
> @@ -707,6 +732,9 @@ static const struct option options[] = {
>  		    "don't sample"),
>  	OPT_BOOLEAN('M', "multiplex", &multiplex,
>  		    "multiplex counter output in a single channel"),
> +	OPT_CALLBACK_NOOPT('t', "timechart", NULL, NULL,
> +		     "create a timechart recording",
> +		     do_timechart),
>  	OPT_END()
>  };


Now that we have perf sched record, should this not look like perf
timechart record?

Otherwise they look good. Great work!

