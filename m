Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbYIGUrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbYIGUrF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 16:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755720AbYIGUqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 16:46:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:50201 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571AbYIGUqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 16:46:53 -0400
Subject: Re: update on hrtimer based select/poll and range-hrtimers
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de,
       torvalds@linux-foundation.org
In-Reply-To: <20080907111137.76a10b1e@infradead.org>
References: <20080907111137.76a10b1e@infradead.org>
Content-Type: text/plain
Date: Sun, 07 Sep 2008 22:46:39 +0200
Message-Id: <1220820399.8687.103.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 (2.23.91-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-09-07 at 11:11 -0700, Arjan van de Ven wrote:
> Hi,
> 
> since the last lkml posting I've merged a few fixes and added comments
> from Peter, and I've redone the "estimate_accuracy" function.
> 
> Rather than reposting the entire series, I'll point to the git tree at
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-hrtimer.git
> 
> and I've pasted the new function below.
> Rather than having the hardcoded steps from the "Linus" function, I've
> turned it into:
> 0 for realtime tasks
> "0.1% of the time" for not-nice, not realtime tasks
> "0.5% of the time" for nice, not realtime tasks
> with a cap of 100msec for both.
> 
> I would like to request feedback on this approach; I think this is
> better than the "hardcoded steps" as before, but maybe someone can come
> up with an ever better idea....

logarithms pop to mind (again :-)

> static unsigned long __estimate_accuracy(struct timespec *tv)
> {
>         unsigned long slack;
>         int divfactor = 1000;
>   
>         if (task_nice(current))

This triggers for both -nice and +nice tasks, it might be worth
differentiating between those.

>                 divfactor = divfactor / 5;
> 
>         slack = tv->tv_nsec / divfactor; 
>         slack += tv->tv_sec * (NSEC_PER_SEC/divfactor);
> 
>         if (slack > 100 * NSEC_PER_MSEC)
>                 slack =  100 * NSEC_PER_MSEC;
>         return slack;
> }
> 
> static unsigned long estimate_accuracy(struct timespec *tv)
> {
>         unsigned long ret;
>         struct timespec now;
> 
>         /*
>          * Realtime tasks get a slack of 0 for obvious reasons.
>          */
> 
>         if (current->policy == SCHED_FIFO ||
>                 current->policy == SCHED_RR)
>                 return 0;

rt_task(current) ?

>         ktime_get_ts(&now);
>         now = timespec_sub(*tv, now);
>         ret = __estimate_accuracy(&now);
>         if (ret < current->timer_slack_ns)
>                 return current->timer_slack_ns;

pull out the max from __estimate_accuracy() and use clamp() here?

>         return ret;
> }


