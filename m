Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbYG3Trl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbYG3Trl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 15:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757007AbYG3Tqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 15:46:50 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:49231 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756948AbYG3Tqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 15:46:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FOvQF+V6CZVOzrywWj0xhweXzHRRX5xBgnKYwTzPrlGVFf0bcwiQ2KQZKHMHbNUBr4
         XgJbiNgz47wyes5Rp1PJgIkgNLb6/ysNoZvLzlcqslsZNOp7BWobkd+jRv0MlGJmau/b
         zbI1zuTrba7kKSUR5AO/K+Wl3cj30B++8Nc0I=
Message-ID: <b647ffbd0807301246s1def837ar8c389a3d3f7ec2cc@mail.gmail.com>
Date: Wed, 30 Jul 2008 21:46:48 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/3] wait_task_inactive: don't use the dummy version when !SMP && PREEMPT
Cc: "Oleg Nesterov" <oleg@tv-sign.ru>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Roland McGrath" <roland@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0807301038170.3334@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080730170949.GA18682@tv-sign.ru>
	 <alpine.LFD.1.10.0807301038170.3334@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/30 Linus Torvalds <torvalds@linux-foundation.org>:
>
>
> On Wed, 30 Jul 2008, Oleg Nesterov wrote:
>>
>> The patch looks monstrous because it moves the (unchanged) definition
>> of wait_task_inactive() outside of "#ifdef CONFIG_SMP", but it is quite
>> trivial.
>
> Hmm. Doesn't this just deadlock in UP (PREEMPT) if wait_task_interactive()
> is ever called from a no-preempt context?
>
> And if that's never the case, the comment should be updated to reflect
> that (right now it says that it's only invalid to call it with interrupts
> disabled to avoid cross-IPI deadlocks).
>
> Oh, and shouldn't it do a "yield()" instead of a cpu_relax() on UP?

This part could have been skipped for UP. task_running(rq, p) just
can't give 'true' for UP (otherwise it's a bug). The only relevant
part is "on_rq = p->se.on_rq".

>
> Inquiring minds want to know. That function was very much expressly
> designed for SMP,

It looks so. Otherwise it's behavior is not symmetric and I think,
either [1] it shouldn't be a "nop" for !SMP or [2] there shouldn't be
a version for !SMP at all --> so no one can make false assumptions.

(if [1], then I think a separate function for PREEMPT would look
better, i.e. without parts with task_running())


e.g. consider this code from kthread_bind():

        /* Must have done schedule() in kthread() before we set_task_cpu */
        wait_task_inactive(k, 0);

        set_task_cpu(k, cpu);
        k->cpus_allowed = cpumask_of_cpu(cpu);
        k->rt.nr_cpus_allowed = 1;
        k->flags |= PF_THREAD_BOUND;

set_task_cpu(k, cpu) is safe _only_ if 'k' is not on the run-queue
(and can't be placed onto it behind our back -- heh, a bit subtle).

Now, for !SMP + PREEMPT it's not a case. set_task_cpu() may be called
while 'k' is still on the run-queue (more precisely, preempted in
kthread() between complete(&create->started); and schedule();).

Yes, set_task_cpu() is a "nop" for UP so that's ok in this particular
case. But let's suppose, another use-case would be introduced with
'false' assumptions causing troubles for !SMP.


> not for preemption, and I want to understand why it's
> ok (_if_ it's ok).
>
>                Linus


-- 
Best regards,
Dmitry Adamushko
