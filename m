Return-Path: <linux-kernel-owner+w=401wt.eu-S932913AbXGKW0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913AbXGKW0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757621AbXGKW0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:26:35 -0400
Received: from mail.screens.ru ([213.234.233.54]:54503 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667AbXGKW0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:26:35 -0400
Date: Thu, 12 Jul 2007 02:26:53 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: destroy_workqueue can livelock
Message-ID: <20070711222652.GA287@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Schmidt wrote:
>
> While using SystemTap I noticed an interesting situation. When my stap
> probe was exiting, there was a several seconds long delay, during which
> the CPU was 100% loaded. I narrowed the problem down to destroy_workqueue.
>
> The attached module is a minimized testcase. To reproduce it, load the
> module and then try to rmmod it from a higher priority process:
>  nice -n -10 rmmod wqtest.ko  # that's how SystemTap's staprun behaves
> or:
>  chrt -f  90 rmmod wqtest.ko  # this may be more reliably reproducible
>
> I tested it (with "nice") on Linux 2.6.22. The rmmod process took about
> 55% CPU, the workqueue thread consumed the rest. This situation can last
> for minutes. As soon as the rmmod process is reniced to 0, the workqueue
> is destroyed successfully and the module is unloaded.
>
> Here's what happens in detail:
>
> When rmmod executes cancel_rearming_delayed_workqueue() ->
> wait_on_work() -> wait_on_cpu_work(), the work is the current_work on
> the workqueue (it's in ssleep(1)). So wait_on_cpu_work() inserts a
> wq_barrier on the workqueue and waits for the completion. As soon as
> wq_barrier_func signals the completion, it is most likely preempted by
> the rmmod process. At this moment, the worklist is already empty, but
> cwq->current_work still points to the barrier. run_workqueue() didn't
> get to reset it to NULL yet.
>
> Now rmmod calls destroy_workqueue() -> cleanup_workqueue_thread() ->
> flush_cpu_workqueue(). Because cwq->current_work!=NULL it decides to
> insert another wq_barrier and wait for it to complete. But
> cwq->current_work will never be reset to NULL, so
> cleanup_workqueue_thread() keeps trying flush_cpu_workqueue()
> indefinitely, inserting wq_barriers and waiting for them.

In short: "while (flush_cpu_workqueue(cwq))" can livelock because a re-niced
caller can add a new barrier before the lower-priority cwq->thread clears
->current_work.

> Can this be fixed?

Yes, and the fix is very simple. In fact cleanup_workqueue_thread() doesn't
need the "while" loop. I did it that way to avoid a subtle dependency with
run_workqueue(), and because I failed to invent a good comment which explains
why it is safe to do flush_cpu_workqueue() once.

In short, if we have another barrier when flush_cpu_workqueue() returns,
cwq->thread must be "inside" run_workqueue() which can't return until
cwq->worklist becomes empty. This means we can do kthread_stop() right now,
kthread_should_stop() won't be checked until run_workqueue() returns.

(Another option is to clear cwq->current_work in wq_barrier_func(), before
 complete(). This is possible because nobody can "see" this barrier except
 flush_cpu_workqueue()).

I'll re-check my thinking and send a patch tomorrow.

Thanks a lot, Michal.

Oleg.

