Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbZKVQhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbZKVQhP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 11:37:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755325AbZKVQhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 11:37:14 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:6003 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275AbZKVQhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 11:37:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e82Ei9LGQt96nWseTxgaRnfJd73UILS6pnbGQDCwTY0+aUPZZ7PI8ffJ6mBDUQ+4kV
         rZSDh06N/wXuW0zOy+l5ATiJ9O3PcPvvQTdsP8T920vsoGzMHkNF8vXfDASJtga1UWyc
         BsDc9xPSfsz6RfKbUDeqTjBEF695hi+fm6vyU=
Date: Sun, 22 Nov 2009 17:37:16 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH 1/4] tracing: Use the perf recursion protection from
	trace event
Message-ID: <20091122163714.GD5049@nowhere>
References: <1258863695-10464-1-git-send-email-fweisbec@gmail.com> <1258887614.28730.353.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258887614.28730.353.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 22, 2009 at 12:00:14PM +0100, Peter Zijlstra wrote:
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



I thought that putting that into a function would already do
the trick but that is notwithstanding the fact it could be inlined
as you said in another message.

Ok, I'll add them back.


 
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
> 
> Furthermore, its much cleaner if you simply use
> get_cpu_var(perf_cpu_context) in get_recursion_context, and
> put_cpu_var() in put_recursion_context.
> 
> That way you put the preempt_disable where it belongs, instead of:
> 
> > +static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
> > +                                   u64 nr, int nmi,
> > +                                   struct perf_sample_data *data,
> > +                                   struct pt_regs *regs)
> > +{
> > +       int *recursion;
> > +
> > +       preempt_disable();
> > +
> > +       if (perf_swevent_get_recursion_context(&recursion))
> > +               goto out;
> > +
> > +       __do_perf_sw_event(type, event_id, nr, nmi, data, regs);
> >  
> > +       perf_swevent_put_recursion_context(recursion);
> >  out:
> > -       put_cpu_var(perf_cpu_context);
> > +       preempt_enable();
> >  } 
> 
> mucking about like here, also it cleans up the code in that you don't
> have to drag that recursion variable around like so.
> 


That's cleaner but adds an unnecessary overhead in the trace event
path. We already disable the interrupts there. That's why I preferred
to let the caller decide.

