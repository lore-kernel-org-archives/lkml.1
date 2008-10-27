Return-Path: <linux-kernel-owner+w=401wt.eu-S1752931AbYJ0S2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbYJ0S2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 14:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYJ0S20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 14:28:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47621 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbYJ0S2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 14:28:25 -0400
Date: Mon, 27 Oct 2008 19:28:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RESEND v2] tracing/ftrace: Introduce the big kernel
	lock tracer
Message-ID: <20081027182819.GB11494@elte.hu>
References: <48FF928F.1010300@gmail.com> <48FF93D1.4090008@gmail.com> <20081027154301.GM5704@elte.hu> <c62985530810270851l11fc6f66pb4db9f1f44467c26@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530810270851l11fc6f66pb4db9f1f44467c26@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2008/10/27 Ingo Molnar <mingo@elte.hu>:
> >
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >
> >> diff --git a/lib/kernel_lock.c b/lib/kernel_lock.c
> >> index 01a3c22..45828b2 100644
> >> --- a/lib/kernel_lock.c
> >> +++ b/lib/kernel_lock.c
> >> @@ -9,6 +9,7 @@
> >>  #include <linux/module.h>
> >>  #include <linux/kallsyms.h>
> >>  #include <linux/semaphore.h>
> >> +#include <trace/bkl.h>
> >>
> >>  /*
> >>   * The 'big kernel lock'
> >> @@ -107,6 +108,37 @@ static inline void __unlock_kernel(void)
> >>       preempt_enable();
> >>  }
> >>
> >> +#ifdef CONFIG_BKL_TRACER
> >> +static void lock_kernel_trace(void)
> >> +{
> >> +     int cpu;
> >> +     struct bkl_trace_acquire trace;
> >> +
> >> +     preempt_disable();
> >> +     cpu = raw_smp_processor_id();
> >> +     preempt_enable();
> >> +
> >> +     trace.acquire_req_time = cpu_clock(cpu);
> >> +     __lock_kernel();
> >> +     trace.acquire_time = cpu_clock(cpu);
> >> +     trace_bkl_acquire(&trace);
> >> +}
> >> +
> >> +static void unlock_kernel_trace(void)
> >> +{
> >> +     struct bkl_trace_release trace;
> >> +     trace.release_time = cpu_clock(raw_smp_processor_id());
> >> +     trace_bkl_release(&trace);
> >> +     __unlock_kernel();
> >> +}
> >> +
> >> +#else
> >> +
> >> +#define lock_kernel_trace() __lock_kernel()
> >> +#define unlock_kernel_trace() __unlock_kernel()
> >> +
> >> +#endif
> >
> > hm, this looks a bit ugly.
> >
> > are you aware of the tip/kill-the-BKL branch? It's an old-ish but
> > otherwise sane branch that needs some refreshing (hence it's not part
> > of tip/master).
> >
> > Once we have that "kill the BKL by turning it into a mutex" feature
> > alive, and have fixed the places that rely on odd properties of the
> > BKL, the BKL becomes just an ordinary mutex and we could trace its
> > latencies via the existing lockdep/lockstat callbacks.
> >
> > and we could trace all the other mutexes as well.
> 
> 
> No problem, we can forget about it. My goal was to produce some 
> statistics to locate the points that most often hold the bkl. That 
> would help to define some priorities on which bkl holding is to 
> remove first.
> 
> But if that would be better to rather invest the time on the 
> kill-the-bkl tree (which I thought was dead), so I would be pleased 
> to help.

the kill-the-BKL tree is not dead, just inactive. Looking for a brave 
volunteer to merge it up to latest, to boot it with 
CONFIG_PROVE_LOCKING=y and to have a good look at all the BKL locking 
output that lockdep might disable.

	Ingo
