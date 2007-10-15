Return-Path: <linux-kernel-owner+w=401wt.eu-S1758911AbXJON07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911AbXJON07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 09:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764982AbXJON0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 09:26:44 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:48117 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764974AbXJON0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 09:26:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eUrcjfU09y7UO8XJxynBtGbi/inZbGWyp+Cj/GnnWNNXauSJvhh5zcvZybGUjqrJHfv6mOb67pCIrrN6Fn+oHmtA3fZnja3oGFEYOpRJhyYcT63EhQJsQW2D8Y5kR/zpoT2JNKkOUeEtoGTwpBB4fTyJBjA/b/rWS3RdU1BYhp0=
Message-ID: <b647ffbd0710150626v4273814esce681daa4467f173@mail.gmail.com>
Date: Mon, 15 Oct 2007 15:26:42 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH] sched: SCHED_FIFO watchdog timer
Cc: linux-kernel <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Mike Galbraith" <efault@gmx.de>,
       "Lennart Poettering" <mztabzr@0pointer.de>
In-Reply-To: <1192315867.5625.6.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192222309.5897.3.camel@lappy> <1192315867.5625.6.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/10/2007, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> The below patch is an idea proposed by tglx and depends on sched-devel +
> the hrtick patch previously posted.
>
> The current watchdog action is to demote the task to SCHED_NORMAL,
> however it might be wanted to deliver a signal instead (or have more per
> task configuration state). Which is why I added Lennart to the CC list
> as I gathered he would like something like this for PulseAudio.
>
> ---
> Subject: sched: SCHED_FIFO watchdog timer

Why only SHCED_FIFO and not SCHED_RR?
Their (mis)behavior is similar wrt SCHED_NORMAL tasks.


> +#ifdef CONFIG_SCHED_HRT_TICK
> +static int fifo_watchdog(struct rq *rq, struct task_struct *p, int queued)
> +{
> +       if (likely(!queued || p->policy != SCHED_FIFO))
> +               return 0;
> +
> +       /*
> +        * task has been naughty, turn into SCHED_NORMAL
> +        */
> +       printk(KERN_INFO "SCHED_FIFO task %s/%d exceeded his runtime quota,"
> +                       " demoting to regular task\n", p->comm, task_pid_nr(p));
> +       deactivate_task(rq, p, 0);
> +       __setscheduler(rq, p, SCHED_NORMAL, 0);
> +       activate_task(rq, p, 0);
> +       resched_task(p);

I guess, put_prev_task() / set_curr_task() should be called (for the
case of task_running(p)) to make it group-scheduler-friendly (as it's
done e.g. in sched_setscheduler()).

(normilize_task() should probably do the same)


-- 
Best regards,
Dmitry Adamushko
