Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbZLCH51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbZLCH51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 02:57:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755040AbZLCH50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 02:57:26 -0500
Received: from mail-vw0-f197.google.com ([209.85.212.197]:37614 "EHLO
	mail-vw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbZLCH50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 02:57:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jOQ8OCfSUUwHv/81d4Il6s3VyFgiNWJgbT7ASMYxHnBxVQ2ZKoFqaiCNnGQNjChuEm
         Fiayw4zfXqg4Iqtguboy9AYB9mk2U2Xl6GsSsHnNtprc3M9E539+qkiPOvQsjkkiIHqX
         u/T6bGfsgYZWrlxRbXanHARXErBHEmlgGNbKU=
MIME-Version: 1.0
In-Reply-To: <563a732e0912022249y1e831c6cv7f2d5d376b8a5f63@mail.gmail.com>
References: <563a732e0912022249y1e831c6cv7f2d5d376b8a5f63@mail.gmail.com>
Date: Thu, 3 Dec 2009 08:57:32 +0100
Message-ID: <b647ffbd0912022357w640bea4embe42f2a83b54220d@mail.gmail.com>
Subject: Re: Should we use preempt_disable() in sleep_on_common()?
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: liu pf <kernelfans@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/3 liu pf <kernelfans@gmail.com>:
> Hi:
>
> I am puzzled with the following scenario. Could anyone enlighten me?
>
> Thanks
> pfliu
>
>
> static long __sched
> sleep_on_common(wait_queue_head_t *q, int state, long timeout)
> {
>    unsigned long flags;
>    wait_queue_t wait;
>
>    init_waitqueue_entry(&wait, current);
>
>    __set_current_state(state);
>
>    ==========>suppose that after task A  set state=TASK_INTERRUPTIBLE
> , it is preempted by task B.
>
>    spin_lock_irqsave(&q->lock, flags);
> ...............................................................
> }
>
> asmlinkage void __sched schedule(void)
> {
> .......................................................................................................
>    if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
>        if (unlikely(signal_pending_state(prev->state, prev)))
>            prev->state = TASK_RUNNING;
>        else
>            deactivate_task(rq, prev, 1);
>       =============>This will remove task A from rq, but there are no
> wait queue referring to A, so we lose A.
>        switch_count = &prev->nvcsw;
>    }

In this case, (preempt_count() & PREEMPT_ACTIVE) == 1(see
preempt_schedule_irq() and other use-cases of PREEMPT_ACTIVE) so we
don't  enter this block.

i.e. a preempted task stays on its queue (with state != TASK_RUNNING
but that doesn't really matter).


-- Dmitry
