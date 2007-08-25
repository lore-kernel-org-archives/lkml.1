Return-Path: <linux-kernel-owner+w=401wt.eu-S965043AbXHYUPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965043AbXHYUPh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 16:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934691AbXHYUP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 16:15:26 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:32119 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934690AbXHYUPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 16:15:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hcAS+vx4WgRY2GRgRAiSwrz7yAfe1W/tRasZRtfT2pklQdyKneis5GgpcbVHjuhUN26QAo12UIXivGA49Upgh6N0DAIEC6xa4qWnUZBYoUskCgNDyYJ38BxwajtDf9vgRpqFaEGcoGYQi9BU6lL0w5X0MdV/xQxLgbqTwNqhnQk=
Message-ID: <1946b54f0708251315u70c33b25r581ece6622f9b62c@mail.gmail.com>
Date: Sat, 25 Aug 2007 22:15:20 +0200
From: "David Rodriguez" <livuxman@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Problem with CFS V20 and Suspend2/tuxonice
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070825190142.GA15888@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1946b54f0708250423k75d5797fuc5b032be7e143f26@mail.gmail.com>
	 <1946b54f0708250429y570a1620y2796d0ff8abb02eb@mail.gmail.com>
	 <20070825190142.GA15888@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/8/25, Ingo Molnar <mingo@elte.hu>:
>
> * David Rodriguez <livuxman@gmail.com> wrote:
>
> > I'm using 2.6.22.5 with cfs v20.3 and suspend2 2.2.10.2. With that
> > combination, suspend is not working anymore (with cfs v19 was
> > working). Stops on suspend in "Suspending tasks" Looking at cfs patch,
> > I managed to change the migration_thread, adding again the
> > try_to_freeze() removed in last patch and now the suspend finished,
> > but resume not work. Of course I don't know why that was removed, and
> > rewriting it is not a solution, but I want to report it.
>
> could you try the patch below, does it fix this problem?
>
>         Ingo
>
> Index: linux-cfs-2.6.22.5.q/kernel/sched.c
> ===================================================================
> --- linux-cfs-2.6.22.5.q.orig/kernel/sched.c
> +++ linux-cfs-2.6.22.5.q/kernel/sched.c
> @@ -5043,6 +5043,8 @@ static int migration_thread(void *data)
>                 struct migration_req *req;
>                 struct list_head *head;
>
> +               try_to_freeze();
> +
>                 spin_lock_irq(&rq->lock);
>
>                 if (cpu_is_offline(cpu)) {
> @@ -5399,6 +5401,7 @@ migration_call(struct notifier_block *nf
>                 p = kthread_create(migration_thread, hcpu, "migration/%d", cpu);
>                 if (IS_ERR(p))
>                         return NOTIFY_BAD;
> +               p->flags |= PF_NOFREEZE;
>                 kthread_bind(p, cpu);
>                 /* Must be high prio: stop_machine expects to yield to it. */
>                 rq = task_rq_lock(p, &flags);
>



Yes, it fixes the problem. Thanks
