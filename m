Return-Path: <linux-kernel-owner+w=401wt.eu-S1755656AbZHUOWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbZHUOWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 10:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755647AbZHUOWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 10:22:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56091 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898AbZHUOWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 10:22:21 -0400
Date: Fri, 21 Aug 2009 16:21:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, James Morris <jmorris@namei.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/4] perf_counter: Default to higher paranoia level
Message-ID: <20090821142151.GC11098@elte.hu>
References: <20090819091823.916851355@chello.nl> <20090819092023.728070630@chello.nl> <1250690853.8282.59.camel@twins> <1250769606.8282.181.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250769606.8282.181.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2009-08-19 at 16:07 +0200, Peter Zijlstra wrote:
> > On Wed, 2009-08-19 at 11:18 +0200, Peter Zijlstra wrote:
> > 
> > > +static inline bool perf_paranoid_anon(void)
> > > +{
> > > +	return !capable(CAP_SYS_ADMIN) && sysctl_perf_counter_paranoid > 1;
> > >  }
> > >  
> > >  static inline bool perf_paranoid_kernel(void)
> > >  {
> > > -	return sysctl_perf_counter_paranoid > 1;
> > > +	return !capable(CAP_SYS_ADMIN) && sysctl_perf_counter_paranoid > 2;
> > > +}
> > 
> > OK, this is buggy:
> > 
> >  - capable() uses current, which is unlikely to be counter->owner,
> >  - but even security_real_capable(counter->owner, ...) wouldn't
> >    work, since the ->capable() callback isn't NMI safe
> >    (selinux takes locks and does allocations in that path).
> > 
> > This puts a severe strain on more complex anonymizers since its
> > basically impossible to tell if counter->owner has permissions on
> > current from NMI context.
> > 
> > I'll fix up this patch to pre-compute the perf_paranoid_anon_ip() per
> > counter based on creation time state, unless somebody has a better idea.
> > 
> > I could possibly only anonymize IRQ context (SoftIRQ context is
> > difficult since in_softirq() means both in-softirq and
> > softirq-disabled).
> 
> Something like the below maybe.. its 3 patches folded and I've no clue
> how to adapt the ppc code, what do people think?
> 
> compile tested on x86-64 only.
> 
> ---
>  arch/x86/include/asm/stacktrace.h  |   14 +++++--
>  arch/x86/kernel/cpu/perf_counter.c |   66 +++++++++++++++++++++++++++++++----
>  arch/x86/kernel/dumpstack.c        |   10 +++--
>  arch/x86/kernel/dumpstack_32.c     |    8 +----
>  arch/x86/kernel/dumpstack_64.c     |   13 ++-----
>  arch/x86/kernel/stacktrace.c       |    8 +++--
>  arch/x86/oprofile/backtrace.c      |    5 ++-
>  include/linux/perf_counter.h       |    5 ++-
>  kernel/perf_counter.c              |   30 ++++++++++++----
>  kernel/trace/trace_sysprof.c       |    5 ++-
>  10 files changed, 117 insertions(+), 47 deletions(-)
> 
> diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
> index cf86a5e..7066caa 100644
> --- a/arch/x86/include/asm/stacktrace.h
> +++ b/arch/x86/include/asm/stacktrace.h
> @@ -3,17 +3,23 @@
>  
>  extern int kstack_depth_to_print;
>  
> -int x86_is_stack_id(int id, char *name);
> -
>  /* Generic stack tracer with callbacks */
>  
> +enum stack_type {
> +	STACK_UNKNOWN	= -1,
> +	STACK_PROCESS   = 0,
> +	STACK_INTERRUPT = 1,
> +	STACK_EXCEPTION = 2,
> +};
> +
>  struct stacktrace_ops {
>  	void (*warning)(void *data, char *msg);
>  	/* msg must contain %s for the symbol */
>  	void (*warning_symbol)(void *data, char *msg, unsigned long symbol);
> -	void (*address)(void *data, unsigned long address, int reliable);
> +	void (*address)(void *data, unsigned long stack,
> +			unsigned long address, int reliable);
>  	/* On negative return stop dumping */
> -	int (*stack)(void *data, char *name);
> +	int (*stack)(void *data, int type, char *name);
>  };

nice generalization ...

> diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
> index 9ba1822..2b0528f 100644
> --- a/include/linux/perf_counter.h
> +++ b/include/linux/perf_counter.h
> @@ -439,6 +439,7 @@ enum perf_callchain_context {
>  struct perf_callchain_entry {
>  	__u64				nr;
>  	__u64				ip[PERF_MAX_STACK_DEPTH];
> +	int				restricted;
>  };

i'd love to have something more specific here - i.e. a context type 
ID that identifies these basic types:

 - process
 - softirq
 - hardirq
 - NMI

and then let it be up to upper layers to decide what they do with a 
restricted entry, and how to further process this information.

And it's not just security: for example it would be interesting to 
sample pure, non-irq overhead - as IRQ overhead is often unrelated 
to the process being measured.

	Ingo
