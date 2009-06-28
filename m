Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbZF1Fcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbZF1Fcz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 01:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbZF1Fcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 01:32:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:53683 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbZF1Fcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 01:32:46 -0400
Subject: Re: [PATCH -tip] perf stat: memcpy is only required if no event is
 selected and !null_run
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246126749.32198.16.camel@hpdv5.satnam>
References: <1246126749.32198.16.camel@hpdv5.satnam>
Content-Type: text/plain
Date: Sun, 28 Jun 2009 11:01:29 +0530
Message-Id: <1246167089.4497.8.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If You want can also add Impact Line.

Impact: Speedup, reduce binary size.


On Sat, 2009-06-27 at 23:49 +0530, Jaswinder Singh Rajput wrote:
> Set attrs and nr_counters if no event is selected and !null_run
> 
> Setting of attrs should depend on number of counters,
> so we need to memcpy only for sizeof(default_attrs)
> 
> and set nr_counters as ARRAY_SIZE(default_attrs) in place of hardcoded value
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  tools/perf/builtin-stat.c |   11 ++++++-----
>  1 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index 3840a70..3e5ea4e 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -46,7 +46,7 @@
>  #include <sys/prctl.h>
>  #include <math.h>
>  
> -static struct perf_counter_attr default_attrs[MAX_COUNTERS] = {
> +static struct perf_counter_attr default_attrs[] = {
>  
>    { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_TASK_CLOCK	},
>    { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CONTEXT_SWITCHES},
> @@ -477,16 +477,17 @@ int cmd_stat(int argc, const char **argv, const char *prefix)
>  {
>  	int status;
>  
> -	memcpy(attrs, default_attrs, sizeof(attrs));
> -
>  	argc = parse_options(argc, argv, options, stat_usage, 0);
>  	if (!argc)
>  		usage_with_options(stat_usage, options);
>  	if (run_count <= 0 || run_count > MAX_RUN)
>  		usage_with_options(stat_usage, options);
>  
> -	if (!null_run && !nr_counters)
> -		nr_counters = 8;
> +	/* Set attrs and nr_counters if no event is selected and !null_run */
> +	if (!null_run && !nr_counters) {
> +		memcpy(attrs, default_attrs, sizeof(default_attrs));
> +		nr_counters = ARRAY_SIZE(default_attrs);
> +	}
>  
>  	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
>  	assert(nr_cpus <= MAX_NR_CPUS);

