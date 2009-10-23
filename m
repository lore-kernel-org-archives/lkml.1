Return-Path: <linux-kernel-owner+w=401wt.eu-S1751797AbZJWKu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbZJWKu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 06:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbZJWKu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 06:50:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47208 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbZJWKu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 06:50:58 -0400
Date: Fri, 23 Oct 2009 12:50:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Soeren Sandmann <sandmann@daimi.au.dk>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] x86: Get bp from the IRQ regs instead of directly from
	the CPU
Message-ID: <20091023105047.GA10071@elte.hu>
References: <ye8vdi7mluz.fsf@camel16.daimi.au.dk> <ye8ljj3mlj5.fsf@camel16.daimi.au.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ye8ljj3mlj5.fsf@camel16.daimi.au.dk>
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


* Soeren Sandmann <sandmann@daimi.au.dk> wrote:

> Passing 0 for bp causes dump_trace() to get bp directly from the
> hardware register. This leads to the IRQ stack being included in the
> generated call chains, which means the stack looks something like
> this:
> 
> 	[ ip ] [ IRQ stack ] [ rest of stack trace ]
> 
> which is incorrect and confusing to user space.
> 
> Getting bp from the IRQ regs instead makes the tracing start after the
> IRQ stack:
> 
> 	[ ip ] [ rest of stack trace ]
> 
> Signed-off-by: Søren Sandmann Pedersen <sandmann@redhat.com>

Indeed, nice catch!

> ---
>  arch/x86/kernel/cpu/perf_event.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index b5801c3..39b1d0c 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -2177,10 +2177,18 @@ static const struct stacktrace_ops backtrace_ops = {
>  static void
>  perf_callchain_kernel(struct pt_regs *regs, struct perf_callchain_entry *entry)
>  {
> +	unsigned long bp;
> +    
>  	callchain_store(entry, PERF_CONTEXT_KERNEL);
>  	callchain_store(entry, regs->ip);
>  
> -	dump_trace(NULL, regs, NULL, 0, &backtrace_ops, entry);
> +#ifdef CONFIG_FRAME_POINTER
> +	bp = regs->bp;
> +#else
> +	bp = 0;
> +#endif
> +	
> +	dump_trace(NULL, regs, NULL, bp, &backtrace_ops, entry);
>  }

Wouldnt it be better to push this logic into dump_trace() itself? That 
way other ways of backtrace generation would be improved as well, not 
just perf events call-chains.

	Ingo
