Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804Ab0ARCyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab0ARCyI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 21:54:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452Ab0ARCyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 21:54:06 -0500
Received: from mail1.radix.net ([207.192.128.31]:50634 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088Ab0ARCyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 21:54:03 -0500
Subject: Re: [PATCH 30/40] workqueue: implement work_busy()
From: Andy Walls <awalls@radix.net>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
In-Reply-To: <1263776272-382-31-git-send-email-tj@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
	 <1263776272-382-31-git-send-email-tj@kernel.org>
Content-Type: text/plain
Date: Sun, 17 Jan 2010 21:52:36 -0500
Message-Id: <1263783156.5220.66.camel@palomino.walls.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 09:57 +0900, Tejun Heo wrote:
> Implement work_busy() which tests whether a work is either pending or
> running.  The test isn't synchronized against workqueue operation and
> the result is only good as advisory hints or for debugging.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Hi Tejun,

>From a driver writer's perspective, this function not useful since it is
unreliable (false positives only?) and I have no way of

"ensuring the workqueue @work was last queued on stays valid until this
function returns."

I don't quite know how to check and enfore a workqueue's continuing
validity across the function call.  (Maybe you could clarify?)



As a driver writer, I'd do one of two things to reliably know when a
work is "not busy":

1. mark work objects which I submitted with an atomic_t or bit flags:

	struct foo_work {
		struct work_struct	work;
		atomic_t		dispatched;
		struct foo_instance	*foo;
	};

	struct foo_instance {
		...
		struct foo_work		work_object[5];
		...
	};

The irq_handler finds a work_object[] that is not dispatched, marks it
dispatched, and schedules the work.  The work handler will clear the
dispatched field when it is done with the work object.  A busy work
object will have dispatched set, a non-busy work will not, and
dispatched can be checked atomically.

This still can suffer from false positives for "busy", but it functions
as long as the work_object[] exists vs. the workqueue validity criterion
(which isn't clear to me).  The driver has direct control of when the
work_object[] array will be valid.

Or
2. Just schedule the work object and check the return value to see if
the submission suceeded.  If it did, the work was "not pending".  This
method can't check for "running" of course.



Is there some specific use case where this function is very useful
despite being unreliable?  I just think it's asking for abuse by someone
who would think "mostly reliable" is good enough, when it actually may
not be.

Regards,
Andy

> ---
>  include/linux/workqueue.h |    2 +-
>  kernel/workqueue.c        |   31 +++++++++++++++++++++++++++++++
>  2 files changed, 32 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
> index 265207d..4f8705f 100644
> --- a/include/linux/workqueue.h
> +++ b/include/linux/workqueue.h
> @@ -293,8 +293,8 @@ extern int keventd_up(void);
>  extern void init_workqueues(void);
>  int execute_in_process_context(work_func_t fn, struct execute_work *);
>  
> +extern bool work_busy(struct work_struct *work);
>  extern int flush_work(struct work_struct *work);
> -
>  extern int cancel_work_sync(struct work_struct *work);
>  
>  /*
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 233278c..882d4d8 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1960,6 +1960,37 @@ out_unlock:
>  EXPORT_SYMBOL_GPL(flush_workqueue);
>  
>  /**
> + * work_busy - test whether a work is currently pending or running
> + * @work: the work to be tested
> + *
> + * Test whether @work is currently pending or running.  There is no
> + * synchronization around this function and the test result is
> + * unreliable and only useful as advisory hints or for debugging.  The
> + * caller is responsible for ensuring the workqueue @work was last
> + * queued on stays valid until this function returns.
> + *
> + * RETURNS:
> + * %true if @work is currently running, %false otherwise.
> + */
> +bool work_busy(struct work_struct *work)
> +{
> +	struct cpu_workqueue_struct *cwq = get_wq_data(work);
> +	struct global_cwq *gcwq;
> +	unsigned long flags;
> +	bool ret;
> +
> +	if (!cwq)
> +		return false;
> +	gcwq = cwq->gcwq;
> +
> +	spin_lock_irqsave(&gcwq->lock, flags);
> +	ret = work_pending(work) || find_worker_executing_work(gcwq, work);
> +	spin_unlock_irqrestore(&gcwq->lock, flags);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(work_busy);
> +
> +/**
>   * flush_work - block until a work_struct's callback has terminated
>   * @work: the work which is to be flushed
>   *

