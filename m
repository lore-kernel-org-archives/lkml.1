Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbYKYRjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbYKYRjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 12:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbYKYRjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 12:39:00 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59695 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240AbYKYRi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 12:38:59 -0500
Date: Tue, 25 Nov 2008 18:30:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Eric Van Hensbergen <ericvh@gmail.com>, Ron Minnich <rminnich@sandia.gov>,
       Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       Miklos Szeredi <mszeredi@suse.cz>,
       Davide Libenzi <davidel@xmailserver.org>,
       Brad Boyer <flar@allandria.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Roland McGrath <roland@redhat.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + poll-allow-f_op-poll-to-sleep-take-4.patch added to -mm tree
Message-ID: <20081125173032.GA21539@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Minor question about mbs, just trying to understand the patch...

> +static int pollwake(wait_queue_t *wait, unsigned mode, int sync, void *key)
> +{
> +	struct poll_wqueues *pwq = wait->private;
> +	DECLARE_WAITQUEUE(dummy_wait, pwq->polling_task);
> +
> +	set_mb(pwq->triggered, 1);
> +
> +	/*
> +	 * Perform the default wake up operation using a dummy
> +	 * waitqueue.
> +	 *
> +	 * TODO: This is hacky but there currently is no interface to
> +	 * pass in @sync.  @sync is scheduled to be removed and once
> +	 * that happens, wake_up_process() can be used directly.
> +	 */
> +	return default_wake_function(&dummy_wait, mode, sync, key);
> +}
> +
> +int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
> +			  ktime_t *expires, unsigned long slack)
> +{
> +	int rc = -EINTR;
> +
> +	set_current_state(state);
> +	if (!pwq->triggered)
> +		rc = schedule_hrtimeout_range(expires, slack, HRTIMER_MODE_ABS);
> +	__set_current_state(TASK_RUNNING);

So, why do we need this mb() in pollwake() ?

try_to_wake_up() has a full barrier semantics, note the wmb() before
task_rq_lock(). Since spin_lock() itself is STORE, the setting of
pwq->triggered can't be further re-ordered with the reading of p->state.

Or any other reason ?

> +	/* clear triggered for the next iteration */
> +	pwq->triggered = 0;

And don't we (in theory) actually need the mb() here instead?

Let's suppose do_poll() starts the next iteration, so we are doing

	pwq->triggered = 0;

	->poll(file)
		if (!check_file(file))
			return 0;

		return POLLXXX;

We don't have any barriers in between (unless fget_light bumps
->f_count), so this can be reordered as

	->poll(file)
		if (!check_file(file))
			return 0;

		pwq->triggered = 0;

And, if pollwake() happens in between we can miss the event, no?

Oleg.

