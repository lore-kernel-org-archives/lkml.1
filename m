Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbYKFOet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbYKFOet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 09:34:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbYKFOek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 09:34:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45822 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbYKFOej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 09:34:39 -0500
Date: Thu, 6 Nov 2008 15:34:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: sys_sched_yield keeps locked irq before call of schedule()
Message-ID: <20081106143428.GE13023@elte.hu>
References: <c4e36d110811050457m36346fe1m63ffbb143f684637@mail.gmail.com> <20081105130113.GB29548@elte.hu> <c4e36d110811050509t51719671saa7eb337fca39656@mail.gmail.com> <20081106075754.GE8459@elte.hu> <alpine.DEB.1.10.0811060845340.31011@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811060845340.31011@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Thu, 6 Nov 2008, Ingo Molnar wrote:
> > 
> > * Zdenek Kabelac <zdenek.kabelac@gmail.com> wrote:
> > 
> > > > is this some special warning you added? The stock kernel certainly 
> > > > does not emit this warning.
> > > 
> > > Yes - it's my personal debug checker that tries to watch wether irq 
> > > & irqsafe are running in pair. So it shows a warning if there is a 
> > > call of spin_lock_irq and irq is already dissabled.
> > 
> > btw., i have added lockdep instrumentation for this two years ago, 
> > it's in the upstream kernel:
> > 
> > /proc/lockdep_stats: redundant hardirq ons:                7744
> > /proc/lockdep_stats: redundant hardirq offs:            1873736
> > /proc/lockdep_stats: redundant softirq ons:                   0
> > /proc/lockdep_stats: redundant softirq offs:                  0
> > 
> > you could extend the code to trace it. See 
> > kernel/lockdep.c:trace_hardirqs_on_caller(). This bit does it:
> > 
> >         if (unlikely(curr->hardirqs_enabled)) {
> >                 debug_atomic_inc(&redundant_hardirqs_on);
> >                 return;
> >         }
> > 
> > you could add a ftrace_printk("redundant hardirq") call right there, 
> > enable ftrace, and enable stack tracing of each trace entry:
> 
> Quick note. Currently ftrace_printk only shows up if it is set in the 
> iter_ctrl.
> 
>   echo trace_printk > /debug/tracing/iter_ctrl
> 
> I'll send out a patch to have it on by default.

ok, agreed - but in that case please make the NOP tracer 
tracing_enabled=0 by default. (we'll get a lot of ftrace_printk 
tracepoints by default otherwise)

	Ingo
