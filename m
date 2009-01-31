Return-Path: <linux-kernel-owner+w=401wt.eu-S1752998AbZAaVoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbZAaVoD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 16:44:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbZAaVnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 16:43:52 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:38234 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbZAaVnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 16:43:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FMPG6Fvs0CU+SGEDlIze+N/4Hn1zgbBcD8OGAnWPBcJ+J7kGy0L6Et0Ee+hXuxF7q1
         y25Jt0RhJ+zr4t/Jhyl6R+0GYfaUNANPlUUi/PsY8UYGpHpBKEpJdCaUiaw3FJWjazKF
         KFv3W5iABu9hpU906CVGUjiAGPEy/B9Wm27Io=
MIME-Version: 1.0
In-Reply-To: <20090131175432.GA7635@elte.hu>
References: <20090130230936.GA7549@elte.hu> <1233421901.4787.27.camel@laptop>
	 <1233422632.4787.31.camel@laptop>
	 <f19298770901310949m7aabf7bcp219ae4cc5d1b363b@mail.gmail.com>
	 <20090131175432.GA7635@elte.hu>
Date: Sun, 1 Feb 2009 00:43:49 +0300
Message-ID: <f19298770901311343u6c6f16d9u7ddcc5cda27bbf33@mail.gmail.com>
Subject: Re: [git pull] scheduler fixes
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 31, 2009 at 20:54, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
>
>> On Sat, Jan 31, 2009 at 20:23, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Sat, 2009-01-31 at 18:11 +0100, Peter Zijlstra wrote:
>> >> > diff --git a/kernel/sched.c b/kernel/sched.c
>> >> > index 52bbf1c..5686bb5 100644
>> >> > --- a/kernel/sched.c
>> >> > +++ b/kernel/sched.c
>> >> > @@ -4440,7 +4450,7 @@ void __kprobes sub_preempt_count(int val)
>> >> >       /*
>> >> >        * Underflow?
>> >> >        */
>> >> > -     if (DEBUG_LOCKS_WARN_ON(val > preempt_count()))
>> >> > +       if (DEBUG_LOCKS_WARN_ON(val > preempt_count() - (!!kernel_locked())))
>> >> >               return;
>> >> >       /*
>> >> >        * Is the spinlock portion underflowing?
>> >
>> > Since the commit msg of 01e3eb8 says:
>> >
>> >    kernel_locked() is not a valid test in IRQ context (we update the
>> >    BKL's ->lock_depth and the preempt count separately and non-atomicalyy),
>> >    so we cannot put it into the generic preempt debugging checks which
>> >    can run in IRQ contexts too.
>> >
>>
>> Is the comment actually valid? From arch/x86/kernel/irq_32.c:
>> do_softirq() actually does
>>                 curctx = current_thread_info();
>>                 irqctx = softirq_ctx[smp_processor_id()];
>>                 irqctx->tinfo.task = curctx->task;
>>
>> and so does execute_on_irq_stack().
>> So kernel_locked() should be valid. It corresponds to the thread
>> that is being interrupted.
>>
>> And answering an earlier question, this happens only on i386 and only
>> with 4K stacks because x86_64 dosn't have a separate softirq stack,
>> so the preempt count diring the soft irq is at least IRQ_EXIT_OFFSET.
>>
>> (If I understood the things correctly)
>
> Correct, on 64-bit we use the hardirq stack for softirqs too:

Is there actually a reason for a separate softirq stack on i386-4K, or
any other architecture?
