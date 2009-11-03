Return-Path: <linux-kernel-owner+w=401wt.eu-S932173AbZKCHlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbZKCHlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 02:41:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755486AbZKCHlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 02:41:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42378 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853AbZKCHlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 02:41:07 -0500
Date: Tue, 3 Nov 2009 08:40:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric=5FWeisbecker?= <fweisbec@gmail.com>
Subject: Re: [RFC][PATCH 5/7] Adding general performance benchmarking
	subsystem to perf.
Message-ID: <20091103074055.GE19928@elte.hu>
References: <20091103.133824.590139143948085461.mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091103.133824.590139143948085461.mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> 
> Adding general performance benchmarking subsystem to perf.
> This patch adds builtin-bench.c
> 
> builtin-bench.c is general framework for benchmark suites.
> 
> Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Mike Galbraith <efault@gmx.de>
> ---
>  tools/perf/builtin-bench.c |   87 ++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 87 insertions(+), 0 deletions(-)
>  create mode 100644 tools/perf/builtin-bench.c
> 
> diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
> new file mode 100644
> index 0000000..85fa927
> --- /dev/null
> +++ b/tools/perf/builtin-bench.c
> @@ -0,0 +1,87 @@
> +/*
> + *
> + * builtin-bench.c
> + *
> + * General benchmarking subsystem provided by perf
> + *
> + * Copyright (C) 2009, Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> + *
> + */
> +
> +/*
> + *
> + * Available subsystem list:
> + *  sched ... scheduler and IPC mechanism
> + *
> + */
> +
> +#include "perf.h"
> +#include "util/util.h"
> +#include "util/parse-options.h"
> +#include "builtin.h"
> +#include "bench-suite.h"
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +
> +static const char * const bench_sched_usage[] = {
> +	"perf bench sched <options>",
> +	NULL
> +};
> +
> +struct bench_suite {
> +	const char *name;
> +	int (*fn)(int, const char **, const char *);
> +};
> +
> +static struct bench_suite sched_suite_array[] = {
> +	{ "messaging", bench_sched_messaging },
> +	{ "pipe", bench_sched_pipe },
> +	{ NULL, NULL }
> +};


ok, making it flexible on that level is a good thing - we'll likely want 
to add more tests so having an array is useful.

a really small style nit, we tend to write tools/perf array initializers 
like this:

static struct bench_suite sched_suite_array[] = {
	{ "messaging",		bench_sched_messaging	},
	{ "pipe",		bench_sched_pipe	},
	{ NULL,			NULL			}
};


> +	for (i = 0; subsys_array[i].name; i++) {
> +		if (!strcmp(subsys_array[i].name, argv[1])) {
> +			for (j = 0;
> +			     subsys_array[i].suite_array[j].name;
> +			     j++) {
> +				s = subsys_array[i].suite_array[j].name;
> +				if (!strcmp(s, argv[2])) {
> +					fn = subsys_array[i].suite_array[j].fn;
> +					status = fn(argc - 2,
> +						    argv + 2, prefix);
> +					goto end;
> +				}
> +			}
> +		}
> +	}

The 80 cols line limit is hurting the nested code above. You can avoid 
that problem and still have nice-looking code by doing something like:

	for (i = 0; subsys_array[i].name; i++) {
		if (strcmp(subsys_array[i].name, argv[1]))
			continue;

		for (j = 0; subsys_array[i].suite_array[j].name; j++) {
			s = subsys_array[i].suite_array[j].name;
			if (strcmp(s, argv[2]))
				continue;

			fn = subsys_array[i].suite_array[j].fn;

also, i'd suggest to shorten the subsys_array[i].suite_array[j] name. 
One trick you use for that is by naming it subsystems[i].suites[j] - 
it's very clear from that kind of plural usage that this is an array.

	Ingo
