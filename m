Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbZAaRy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbZAaRy5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 12:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbZAaRyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 12:54:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41981 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbZAaRyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 12:54:46 -0500
Date: Sat, 31 Jan 2009 18:54:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [git pull] scheduler fixes
Message-ID: <20090131175432.GA7635@elte.hu>
References: <20090130230936.GA7549@elte.hu> <1233421901.4787.27.camel@laptop> <1233422632.4787.31.camel@laptop> <f19298770901310949m7aabf7bcp219ae4cc5d1b363b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f19298770901310949m7aabf7bcp219ae4cc5d1b363b@mail.gmail.com>
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

> On Sat, Jan 31, 2009 at 20:23, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Sat, 2009-01-31 at 18:11 +0100, Peter Zijlstra wrote:
> >> > diff --git a/kernel/sched.c b/kernel/sched.c
> >> > index 52bbf1c..5686bb5 100644
> >> > --- a/kernel/sched.c
> >> > +++ b/kernel/sched.c
> >> > @@ -4440,7 +4450,7 @@ void __kprobes sub_preempt_count(int val)
> >> >       /*
> >> >        * Underflow?
> >> >        */
> >> > -     if (DEBUG_LOCKS_WARN_ON(val > preempt_count()))
> >> > +       if (DEBUG_LOCKS_WARN_ON(val > preempt_count() - (!!kernel_locked())))
> >> >               return;
> >> >       /*
> >> >        * Is the spinlock portion underflowing?
> >
> > Since the commit msg of 01e3eb8 says:
> >
> >    kernel_locked() is not a valid test in IRQ context (we update the
> >    BKL's ->lock_depth and the preempt count separately and non-atomicalyy),
> >    so we cannot put it into the generic preempt debugging checks which
> >    can run in IRQ contexts too.
> >
> 
> Is the comment actually valid? From arch/x86/kernel/irq_32.c:
> do_softirq() actually does
>                 curctx = current_thread_info();
>                 irqctx = softirq_ctx[smp_processor_id()];
>                 irqctx->tinfo.task = curctx->task;
> 
> and so does execute_on_irq_stack().
> So kernel_locked() should be valid. It corresponds to the thread
> that is being interrupted.
> 
> And answering an earlier question, this happens only on i386 and only
> with 4K stacks because x86_64 dosn't have a separate softirq stack,
> so the preempt count diring the soft irq is at least IRQ_EXIT_OFFSET.
> 
> (If I understood the things correctly)

Correct, on 64-bit we use the hardirq stack for softirqs too:

ENTRY(call_softirq)
        CFI_STARTPROC
        push %rbp
        CFI_ADJUST_CFA_OFFSET   8
        CFI_REL_OFFSET rbp,0
        mov  %rsp,%rbp
        CFI_DEF_CFA_REGISTER rbp
        incl PER_CPU_VAR(irq_count)
        cmove PER_CPU_VAR(irq_stack_ptr),%rsp
        push  %rbp                      # backlink for old unwinder
        call __do_softirq

	Ingo
