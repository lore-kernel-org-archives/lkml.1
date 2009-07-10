Return-Path: <linux-kernel-owner+w=401wt.eu-S1754269AbZGJJPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbZGJJPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 05:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbZGJJOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 05:14:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48669 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbZGJJOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 05:14:52 -0400
Date: Fri, 10 Jul 2009 11:14:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Erdem Aktas <eaktas1@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [patch] perf_counter : breaking parameter parsing when the
	command is reached
Message-ID: <20090710091445.GC27445@elte.hu>
References: <3fee128b0907052244n1c5fe000me5ca087918f6fa41@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fee128b0907052244n1c5fe000me5ca087918f6fa41@mail.gmail.com>
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

>     Once the perf parameter parser reaches a non-parameter word, that means
>     the command is already found and the rest of the string is the parameter
>     of this command so no need to parse more.
> 
>     As an example, when we want to run
>     perf stat -- ls -al
>     it is obvious that the -al is the parameter of the ls command, so we
>     should able to run this like
>     perf stat ls -al
> 
>     Signed-off-by: eaktas <eaktas1@gmail.com>
> 
> diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
> index 1bf6719..4ad4962 100644
> --- a/tools/perf/util/parse-options.c
> +++ b/tools/perf/util/parse-options.c
> @@ -284,6 +284,11 @@ int parse_options_step(struct parse_opt_ctx_t *ctx,
>  			if (ctx->flags & PARSE_OPT_STOP_AT_NON_OPTION)
>  				break;
>  			ctx->out[ctx->cpidx++] = ctx->argv[0];
> +			while (--(ctx->argc)) {
> +				ctx->argv++;
> +				ctx->out[ctx->cpidx++] = ctx->argv[0];
> +			}
> +			ctx->argc++;

I think there might be a simpler solution: pass in 
PARSE_OPT_STOP_AT_NON_OPTION.

Then we'll trigger this existing code in parse_options_end():

        memmove(ctx->out + ctx->cpidx, ctx->argv, ctx->argc * sizeof(*ctx->out));
        ctx->out[ctx->cpidx + ctx->argc] = NULL;
        return ctx->cpidx + ctx->argc;

which should solve the issue just as well, correct?

	Ingo
