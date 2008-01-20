Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbYATQro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbYATQro (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 11:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbYATQrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 11:47:36 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:4837 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298AbYATQrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 11:47:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dKERQsceiy4eZ5RU2Lv5BdKlS+4fqD8HY1+5tioqgiKeNi/0qgAx/n9iODqFYKYejlwPJJjsi7yAK4ApYvgj9kFDMfF9DDjbSsHc1ardL1MCiIusKyYTRmAF8RxDgjHP8Ho8a7tlKO6FVu3taMQ2hp+63IuZyjVzIK77VQPQ7/M=
Message-ID: <b647ffbd0801200847k76b3cf2en5b6b9e169d6aefe4@mail.gmail.com>
Date: Sun, 20 Jan 2008 17:47:31 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Arjan van de Ven" <arjan@linux.intel.com>
Subject: Re: [patch 1/3] LatencyTOP infrastructure patch
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080118093943.0048d0f7@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4790E3A6.7060807@linux.intel.com>
	 <20080118093943.0048d0f7@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arjan,

a few comments on the current locking scheme.

There is a single global lock and the locked section in
account_scheduler_latency() seems to be quite long:

(at worst case)

- get_wchan() ;
- account_global_scheduler_latency() which does up to MAXLR (128)
loops x2 strcmp() operations;
- up to LT_SAVECOUNT (32) x2 strcmp() operations by
account_scheduler_latency() itself.

That may induce a high latency for paths which call set_latency_reason_*().

Looking at the code, it looks like what really needs to be protected
is 'task->latency_reason'.

task->latency_record[] and a global latency_record[] are printed out
without any synchronization with account_scheduler_latency(). Is it
your intention?
That can be ok if we want to trade some preciseness for lower lock-contention.

If so,

- account_scheduler_latency() might take a snapshot of
'tsk->latency_reason' with the 'latency_lock' being held and do the
rest in a lock-less way.
Note, we have only a single writer to 'tsk->latency_record[]' at any
time due to the rq->lock to which 'tsk' belongs to being held ;

- yeah, this way the global 'latency_record[]' needs some sort of
protection as we may have concurrent writers here.

what do you think?

and a few minor comments below:

> +void __sched account_scheduler_latency(struct task_struct *tsk,
> +                                               int usecs, int inter)
> +{
>
>   [ ... ]
>
> +       spin_lock_irqsave(&latency_lock, flags);
> +       if (!tsk->latency_reason.reason) {
> +               static char str[KSYM_NAME_LEN];
> +               unsigned long EIPV = get_wchan(tsk);
> +               sprint_symbol(str, EIPV);
> +               tsk->latency_reason.reason = "Unknown reason";
> +               strncpy(tsk->latency_reason.argument, str, 23);
> +       }
> +

provided we hit a number of consequent "latencies" with explicitly
unspecified 'tsk->latency_reason', they all end up recorded in a
single 'tsk->latency_record' with "Unknown reason" and the _same_
'argument' which is the result of get_wchan() for the very _first_
"latency" in a row.

I think, it would make sense to record them separately with their
respective get_wchan() (so that they still could be identified).


> --- linux-2.6.24-rc7.orig/fs/proc/base.c
> +++ linux-2.6.24-rc7/fs/proc/base.c
> @@ -310,6 +310,60 @@ static int proc_pid_schedstat(struct tas
>  }
>  #endif
>
> +#ifdef CONFIG_LATENCYTOP
> +static int lstats_show_proc(struct seq_file *m, void *v)
> +{
> +       int i;
> +       struct task_struct *task = m->private;
> +       seq_puts(m, "Latency Top version : v0.1\n");
> +
> +       for (i = 0; i < 32; i++) {
> +               if (task->latency_record[i].reason)

for (i = 0; i < LT_SAVECOUNT; i++) {


-- 
Best regards,
Dmitry Adamushko
