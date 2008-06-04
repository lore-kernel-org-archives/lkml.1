Return-Path: <linux-kernel-owner+w=401wt.eu-S1759760AbYFDLJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759760AbYFDLJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 07:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbYFDLJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 07:09:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:61311 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbYFDLJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 07:09:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bLSad4zFYgJBsSpJ9TYt0b15SLMXYSGbxQ5fbc7vVQ3I04l7nC7sHy6OCLtHD6KPRi
         a242ozONObkLxNhJuAucjlb7JLfVnw6euVBvMOG0ZIC7aTEOyM77gdjbApFzAT7A0Pp7
         Te6dDV3v53XnUo0ou/YOmhngrFKRNNRerupTo=
Message-ID: <b647ffbd0806040409i77dc70bci6a26251ccf76d906@mail.gmail.com>
Date: Wed, 4 Jun 2008 13:09:18 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Oleg Nesterov" <oleg@tv-sign.ru>
Subject: Re: Q: down_killable() is racy? or schedule() is not right?
Cc: "Ingo Molnar" <mingo@elte.hu>, "Matthew Wilcox" <matthew@wil.cx>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
In-Reply-To: <20080603123309.GA472@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080603123309.GA472@tv-sign.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/3 Oleg Nesterov <oleg@tv-sign.ru>:
> I just noticed we have generic semaphores, a couple of questions.
>
>        down():
>
>                spin_lock_irqsave(&sem->lock, flags);
>                ...
>                __down(sem);
>
> Why _irqsave ? we must not do down() with irqs disabled, and of course
> __down() restores/clears irqs unconditionally.
>
>
> Another question,
>
>        __down_common(TASK_KILLABLE):
>
>                        if (state == TASK_KILLABLE && fatal_signal_pending(task))
>                                goto interrupted;
>
>                        /* --- WINDOW --- */
>
>                        __set_task_state(task, TASK_KILLABLE);
>                        schedule_timeout(timeout);
>
> This looks racy. If SIGKILL comes in the WINDOW above, the event is lost.
> The task will wait for up() or timeout with the fatal signal pending, and
> it is not possible to wakeup it via kill() again.
>
> This is easy to fix, but I wonder if we should change schedule() instead.

[ for what it's worth ] I think, you are definitely right here.

The schedule() would be the right place to fix it. At the very least,
because otherwise callers are obliged to always check for
fatal_signal_pending(task) before scheduling with state ==
TASK_KILLABLE. e.g. schedule_timeout_killable().

Not very nice, IMHO.


>        int signal_pending_state(struct task_struct *tsk)
>        {
>                if (!(state & (TASK_INTERRUPTIBLE | TASK_WAKEKILL)))
>                        return 0;
>                if (signal_pending(tsk))
>                        return 0;

I guess, it should be ! signal_pending(tsk).


>
>                return (state & TASK_INTERRUPTIBLE) ||
>                        __fatal_signal_pending(tsk);
>        }
>
>                if (state == TASK_INTERRUPTIBLE && signal_pending(task))
>                        goto interrupted;
>                if (state == TASK_KILLABLE && fatal_signal_pending(task))


>
> Oleg.
>

-- 
Best regards,
Dmitry Adamushko
