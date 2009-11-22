Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614AbZKVLXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbZKVLXK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 06:23:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbZKVLXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 06:23:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36089 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbZKVLXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 06:23:08 -0500
Date: Sun, 22 Nov 2009 12:22:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH 1/4] tracing: Use the perf recursion protection from
 trace event
Message-ID: <20091122112259.GA24741@elte.hu>
References: <1258863695-10464-1-git-send-email-fweisbec@gmail.com>
 <1258887614.28730.353.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258887614.28730.353.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Sun, 2009-11-22 at 05:21 +0100, Frederic Weisbecker wrote:
> > diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> > index 718fa93..aba8227 100644
> > --- a/kernel/perf_event.c
> > +++ b/kernel/perf_event.c
> > @@ -3880,34 +3880,42 @@ static void perf_swevent_ctx_event(struct perf_event_context *ctx,
> >         }
> >  }
> >  
> > -static int *perf_swevent_recursion_context(struct perf_cpu_context *cpuctx)
> > +/*
> > + * Must be called with preemption disabled
> > + */
> > +int perf_swevent_get_recursion_context(int **recursion)
> >  {
> > +       struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
> > +
> >         if (in_nmi())
> > -               return &cpuctx->recursion[3];
> > +               *recursion = &cpuctx->recursion[3];
> > +       else if (in_irq())
> > +               *recursion = &cpuctx->recursion[2];
> > +       else if (in_softirq())
> > +               *recursion = &cpuctx->recursion[1];
> > +       else
> > +               *recursion = &cpuctx->recursion[0];
> >  
> > -       if (in_irq())
> > -               return &cpuctx->recursion[2];
> > +       if (**recursion)
> > +               return -1;
> >  
> > -       if (in_softirq())
> > -               return &cpuctx->recursion[1];
> > +       (**recursion)++;
> >  
> > -       return &cpuctx->recursion[0];
> > +       return 0;
> >  }
> 
> You lost the barrier();
> 
> > -static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
> > -                                   u64 nr, int nmi,
> > -                                   struct perf_sample_data *data,
> > -                                   struct pt_regs *regs)
> > +void perf_swevent_put_recursion_context(int *recursion)
> >  {
> > -       struct perf_cpu_context *cpuctx = &get_cpu_var(perf_cpu_context);
> > -       int *recursion = perf_swevent_recursion_context(cpuctx);
> > -       struct perf_event_context *ctx;
> > -
> > -       if (*recursion)
> > -               goto out;
> > +       (*recursion)--;
> > +}
> 
> And here as well.

Global functions are in essence a barrier() to GCC but yeah.

	Ingo
