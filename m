Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbZBCFaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbZBCFaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 00:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbZBCF3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 00:29:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38457 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbZBCF3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 00:29:53 -0500
Date: Tue, 3 Feb 2009 06:29:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/3] trace: fix default boot up tracer
Message-ID: <20090203052913.GC28361@elte.hu>
References: <20090203023830.440860800@goodmis.org> <20090203024358.332574797@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203024358.332574797@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> Peter Zijlstra started the functionality to start up a default
> tracing at bootup. This patch finishes the work.
> 
> Now if you add 'ftrace=<tracer>' to the command line, when that tracer
> is registered on bootup, that tracer is selected and starts tracing.
> 
> Note, all selftests for tracers that are registered after this tracer
> is disabled. This prevents the selftests from disturbing the running
> tracer, or the running tracer from disturbing the selftest.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/trace.c |   60 +++++++++++++++++++++++++++++++++++++++++++++-----
>  1 files changed, 54 insertions(+), 6 deletions(-)

applied to tip/tracing/ftrace, thanks Steve!

This portion is a bit ugly:

> -	lock_kernel();
>  
> +	if (!ret && default_bootup_tracer) {
> +		if (!strncmp(default_bootup_tracer, type->name,
> +			     BOOTUP_TRACER_SIZE)) {
> +			printk(KERN_INFO "Starting tracer '%s'\n",
> +			       type->name);
> +			/* Do we want this tracer to start on bootup? */
> +			tracing_set_tracer(type->name);
> +			default_bootup_tracer = NULL;
> +			/* disable other selftests, since this will break it. */
> +			tracing_selftest_disabled = 1;
> +#ifdef CONFIG_FTRACE_STARTUP_TEST
> +			printk(KERN_INFO "Disabling FTRACE selftests due"
> +			       " to running tracer '%s'\n", type->name);
> +#endif
> +		}
> +	}
> +
> +	lock_kernel();
>  	return ret;

This could be done as:

	if (ret || default_bootup_tracer)
		goto out_relock;

	if (strncmp(default_bootup_tracer, type->name, BOOTUP_TRACER_SIZE)) 
		goto out_relock;

	...

 out_relock:
	lock_kernel();
	return ret;

And we lose a lot of crappy linebreaks that way as well - beyond making the 
purpose of the BKL bits clearer. Hm?

	Ingo

