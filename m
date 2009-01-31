Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbZAaRtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbZAaRtV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 12:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbZAaRtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 12:49:14 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:17367 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbZAaRtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 12:49:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wb8bwc+PijSbd50Fj3WepE4lR6GsJfjvJV/wCnhNL19Yeyu+zPbT0+R0QxhTix2E1y
         q64+9flPVaneFxpGE+0yhBwLWuRY49P6FReixeHNtVwP/YHr5lu+0w48KFUVe/5aF99j
         Q2dVQjwTLZ0rFwfwYlgKb7BZF20FrgmyLds58=
MIME-Version: 1.0
In-Reply-To: <1233422632.4787.31.camel@laptop>
References: <20090130230936.GA7549@elte.hu> <1233421901.4787.27.camel@laptop>
	 <1233422632.4787.31.camel@laptop>
Date: Sat, 31 Jan 2009 20:49:10 +0300
Message-ID: <f19298770901310949m7aabf7bcp219ae4cc5d1b363b@mail.gmail.com>
Subject: Re: [git pull] scheduler fixes
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 31, 2009 at 20:23, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sat, 2009-01-31 at 18:11 +0100, Peter Zijlstra wrote:
>> > diff --git a/kernel/sched.c b/kernel/sched.c
>> > index 52bbf1c..5686bb5 100644
>> > --- a/kernel/sched.c
>> > +++ b/kernel/sched.c
>> > @@ -4440,7 +4450,7 @@ void __kprobes sub_preempt_count(int val)
>> >       /*
>> >        * Underflow?
>> >        */
>> > -     if (DEBUG_LOCKS_WARN_ON(val > preempt_count()))
>> > +       if (DEBUG_LOCKS_WARN_ON(val > preempt_count() - (!!kernel_locked())))
>> >               return;
>> >       /*
>> >        * Is the spinlock portion underflowing?
>
> Since the commit msg of 01e3eb8 says:
>
>    kernel_locked() is not a valid test in IRQ context (we update the
>    BKL's ->lock_depth and the preempt count separately and non-atomicalyy),
>    so we cannot put it into the generic preempt debugging checks which
>    can run in IRQ contexts too.
>

Is the comment actually valid? From arch/x86/kernel/irq_32.c:
do_softirq() actually does
                curctx = current_thread_info();
                irqctx = softirq_ctx[smp_processor_id()];
                irqctx->tinfo.task = curctx->task;

and so does execute_on_irq_stack().
So kernel_locked() should be valid. It corresponds to the thread
that is being interrupted.

And answering an earlier question, this happens only on i386 and only
with 4K stacks because x86_64 dosn't have a separate softirq stack,
so the preempt count diring the soft irq is at least IRQ_EXIT_OFFSET.

(If I understood the things correctly)

> Another possibility would be writing it like:
>
>  if (DEBUG_LOCKS_WARN_ON(val > preempt_count() -
>                          (in_interrupt() ? 0 : !!kernel_locked())))
>
> Which might just work because we're in sub_preempt_count, before we
> actually do the subtraction, so in_interrupt() will still be true.
>
>
>
>
