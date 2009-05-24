Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbZEXLdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbZEXLdo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 07:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbZEXLdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 07:33:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36377 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbZEXLde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 07:33:34 -0400
Date: Sun, 24 May 2009 13:33:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: Optimize context switch
	between identical inherited contexts
Message-ID: <20090524113315.GA16151@elte.hu>
References: <18966.10666.517218.332164@cargo.ozlabs.ibm.com> <tip-564c2b210add41df9a3a5aaa365c1d97cff6110d@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-564c2b210add41df9a3a5aaa365c1d97cff6110d@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Paul Mackerras <paulus@samba.org> wrote:

> @@ -885,6 +934,16 @@ void perf_counter_task_sched_out(struct task_struct *task, int cpu)
>  
>  	regs = task_pt_regs(task);
>  	perf_swcounter_event(PERF_COUNT_CONTEXT_SWITCHES, 1, 1, regs, 0);
> +
> +	next_ctx = next->perf_counter_ctxp;
> +	if (next_ctx && context_equiv(ctx, next_ctx)) {
> +		task->perf_counter_ctxp = next_ctx;
> +		next->perf_counter_ctxp = ctx;
> +		ctx->task = next;
> +		next_ctx->task = task;
> +		return;
> +	}

there's one complication that this trick is causing - the migration 
counter relies on ctx->task to get per task migration stats:

 static inline u64 get_cpu_migrations(struct perf_counter *counter)
 {
        struct task_struct *curr = counter->ctx->task;

        if (curr)
                return curr->se.nr_migrations;
        return cpu_nr_migrations(smp_processor_id());
 }

as ctx->task is now jumping (while we keep the context), the 
migration stats are out of whack.

	Ingo
