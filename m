Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbZGJJK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbZGJJK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 05:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbZGJJKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 05:10:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44752 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbZGJJKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 05:10:18 -0400
Date: Fri, 10 Jul 2009 11:10:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Erdem Aktas <eaktas1@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [patch] perf_counter : add new parameter to set cpu affinity
Message-ID: <20090710091004.GB27445@elte.hu>
References: <3fee128b0907052241k103df985g5d2222c72b6aa22d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fee128b0907052241k103df985g5d2222c72b6aa22d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Erdem Aktas <eaktas1@gmail.com> wrote:

>     new parameter to set cpu affinity
>     when tracing the cache related performance counters, task migration
>     might cause unpredicted cache events. We can use the cpu affinity to
>     limit which cpus can be used to migrate the current task. I am
>     suggesting -c parameter as in
>     ./perf stat -c 1 -- ls -al
>     ./perf stat -c 1,2 -- ls -al
>     ./perf stat -c 1-3 -- ls -al
> 
>     Signed-off-by: eaktas <eaktas1@gmail.com>

thanks Erdem, this patch looks really useful.

Note, the first patch is line-wrapped: please take a look at 
Documentation/email-clients.txt to set up your mailer properly for 
plain-text patches.

The code looks fine, with a few minor things that need to be 
fixed before i can apply it:

> @@ -511,6 +520,7 @@ int cmd_stat(int argc, const char **argv, const
> char *prefix __used)
>  {
>  	int status;
> 
> +  enableaffinity = 0;

please use a tab, not two spaces.

Also, please rename enableaffinity to affinity_enabled - that is 
more readable.

Note, this initialization is probably not needed at all, as the 
variable is global and gets initialized to zero already.

> @@ -9,6 +10,8 @@
>  extern char *strcasestr(const char *haystack, const char *needle);
> 
>  int					nr_counters;
> +cpu_set_t affinity_mask;
> +int enableaffinity;

Please fix the style here, to match the style of existing 
variables:

int					nr_counters;
cpu_set_t				affinity_mask;
int					affinity_enabled;


> 
>  struct perf_counter_attr		attrs[MAX_COUNTERS];
> 
> @@ -474,3 +477,49 @@ void print_events(void)
> 
>  	exit(129);
>  }
> +
> +/*
> + * Set cpu affinity
> + * Sets which cpus this task can be assigned.
> + * usage can be 1   1,2   1,2,4-8
> + */
> +int set_cpu_affinity(const struct option *opt, const char *str, int unset)
> +{
> +	char *str_dup, *token, *paramlist[30];
> +	int paramcount = 0;
> +
> +	/*I need this dumy if statement, otherwise the compiler gives error */
> +	if (opt == NULL && unset == 0) {
> +	}

please add __used tags to 'opt' and 'unset' - that is how we 
annotate unused parameters. (then you can remove this hack)

> +	str_dup = strdup(str);
> +	token = strtok(str_dup, ",");
> +	CPU_ZERO(&affinity_mask);
> +	while (token) {
> +		paramlist[paramcount++] = token;
> +		token = strtok(NULL, ",");
> +	}

this will overflow the paramlist[] array if we have more than 30 
elements in the parameter string.

Please add a PARAM_LIMIT define and bail out with an error if that 
ever gets hit.

> +	while (paramcount > 0) {
> +		int number;
> +
> +		token = strtok(paramlist[--paramcount], "-");
> +		number = -1;
> +		while (token != NULL) {
> +			if (number != -1) {
> +				int number2;
> +				number2 = atoi(token);

you can initialize number2 in the line of definition.

Also, please put an extra newline after local variable definitions.

> +				while (number < number2) {
> +					CPU_SET(++number, &affinity_mask);
> +				}
> +			} else {
> +				number = atoi(token);
> +				CPU_SET(number, &affinity_mask);
> +			}
> +			token = strtok(NULL, "-");
> +		}
> +	}
> +	free(str_dup);
> +	enableaffinity = 1;
> +	return 0;
> +}
> +
> +
> diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
> index e3d5529..c94f0ac 100644
> --- a/tools/perf/util/parse-events.h
> +++ b/tools/perf/util/parse-events.h
> @@ -3,6 +3,12 @@
>   * Parse symbolic events/counts passed in as options:
>   */
> 
> +#include <sched.h>
> +
> +extern cpu_set_t affinity_mask;
> +
> +extern int			enableaffinity;
> +
>  extern int			nr_counters;


please align this consistently too.

> 
>  extern struct perf_counter_attr attrs[MAX_COUNTERS];
> @@ -15,3 +21,5 @@ extern int parse_events(const struct option *opt,
> const char *str, int unset);
> 
>  extern void print_events(void);
> 
> +extern int set_cpu_affinity(const struct option *opt,
> +						const char *str, int unset);
> diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
> index b4be607..6db141d 100644
> --- a/tools/perf/util/util.h
> +++ b/tools/perf/util/util.h
> @@ -44,6 +44,7 @@
>  #define _XOPEN_SOURCE_EXTENDED 1 /* AIX 5.3L needs this */
>  #endif
>  #define _ALL_SOURCE 1
> +#undef _GNU_SOURCE
>  #define _GNU_SOURCE 1
>  #define _BSD_SOURCE 1

Why do we undefine _GNU_SOURCE just to define it again in (some) .c 
files?

	Ingo
