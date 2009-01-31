Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbZAaWPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbZAaWPl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 17:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbZAaWPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 17:15:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54732 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbZAaWPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 17:15:31 -0500
Date: Sat, 31 Jan 2009 23:15:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [git pull] scheduler fixes
Message-ID: <20090131221514.GB29364@elte.hu>
References: <20090130230936.GA7549@elte.hu> <1233421901.4787.27.camel@laptop> <1233422632.4787.31.camel@laptop> <f19298770901310949m7aabf7bcp219ae4cc5d1b363b@mail.gmail.com> <20090131175432.GA7635@elte.hu> <f19298770901311343u6c6f16d9u7ddcc5cda27bbf33@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f19298770901311343u6c6f16d9u7ddcc5cda27bbf33@mail.gmail.com>
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


* Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:

> On Sat, Jan 31, 2009 at 20:54, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
> >
> >> On Sat, Jan 31, 2009 at 20:23, Peter Zijlstra <peterz@infradead.org> wrote:
> >> > On Sat, 2009-01-31 at 18:11 +0100, Peter Zijlstra wrote:
> >> >> > diff --git a/kernel/sched.c b/kernel/sched.c
> >> >> > index 52bbf1c..5686bb5 100644
> >> >> > --- a/kernel/sched.c
> >> >> > +++ b/kernel/sched.c
> >> >> > @@ -4440,7 +4450,7 @@ void __kprobes sub_preempt_count(int val)
> >> >> >       /*
> >> >> >        * Underflow?
> >> >> >        */
> >> >> > -     if (DEBUG_LOCKS_WARN_ON(val > preempt_count()))
> >> >> > +       if (DEBUG_LOCKS_WARN_ON(val > preempt_count() - (!!kernel_locked())))
> >> >> >               return;
> >> >> >       /*
> >> >> >        * Is the spinlock portion underflowing?
> >> >
> >> > Since the commit msg of 01e3eb8 says:
> >> >
> >> >    kernel_locked() is not a valid test in IRQ context (we update the
> >> >    BKL's ->lock_depth and the preempt count separately and non-atomicalyy),
> >> >    so we cannot put it into the generic preempt debugging checks which
> >> >    can run in IRQ contexts too.
> >> >
> >>
> >> Is the comment actually valid? From arch/x86/kernel/irq_32.c:
> >> do_softirq() actually does
> >>                 curctx = current_thread_info();
> >>                 irqctx = softirq_ctx[smp_processor_id()];
> >>                 irqctx->tinfo.task = curctx->task;
> >>
> >> and so does execute_on_irq_stack().
> >> So kernel_locked() should be valid. It corresponds to the thread
> >> that is being interrupted.
> >>
> >> And answering an earlier question, this happens only on i386 and only
> >> with 4K stacks because x86_64 dosn't have a separate softirq stack,
> >> so the preempt count diring the soft irq is at least IRQ_EXIT_OFFSET.
> >>
> >> (If I understood the things correctly)
> >
> > Correct, on 64-bit we use the hardirq stack for softirqs too:
> 
> Is there actually a reason for a separate softirq stack on i386-4K, or 
> any other architecture?

Yes - it's just 4K so we have separate stacks for hardirqs, softirqs and 
for normal syscall activities. On 64-bit the IRQ stack is 16K - so it can 
embedd a softirq just fine.

Anyway, changing any detail there is a highly critical change not to be 
changed so late in the -rc cycles.

	Ingo
