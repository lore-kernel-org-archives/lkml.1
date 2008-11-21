Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbYKUQn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbYKUQn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbYKUQnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:43:11 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43831 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885AbYKUQnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:43:10 -0500
To: tj@kernel.org
CC: torvalds@linux-foundation.org, miklos@szeredi.hu, hch@infradead.org,
       mingo@elte.hu, rminnich@sandia.gov, ericvh@gmail.com,
       linux-kernel@vger.kernel.org
In-reply-to: <49256CCE.9060107@kernel.org> (message from Tejun Heo on Thu, 20
	Nov 2008 22:57:34 +0900)
Subject: Re: [PATCH RESEND] poll: allow f_op->poll to sleep, take #2
References: <491BA16C.30606@kernel.org> <alpine.LFD.2.00.0811151208430.3468@nehalem.linux-foundation.org> <49256CCE.9060107@kernel.org>
Message-Id: <E1L3Z5h-0008J7-QN@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 Nov 2008 17:42:45 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2008, Tejun Heo wrote:

[snip]

> +int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
> +			  ktime_t *expires, unsigned long slack)

The 'state' parameter is unused, and is always called with the
TASK_INTERRUPTIBLE value.  Shouldn't it be removed?

> +{
> +	int rc = -EINTR;
> +
> +	set_current_state(TASK_INTERRUPTIBLE);
> +	if (!pwq->triggered)
> +		rc = schedule_hrtimeout_range(expires, slack, HRTIMER_MODE_ABS);
> +	__set_current_state(TASK_RUNNING);
> +
> +	/* clear triggered for the next iteration */
> +	pwq->triggered = 0;
> +
> +	return rc;
> +}
> +
> +EXPORT_SYMBOL(poll_schedule_timeout);

Checkpatch warning:

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#118: FILE: fs/select.c:216:
+EXPORT_SYMBOL(poll_schedule_timeout);

[snip]

> Index: work/include/linux/poll.h
> ===================================================================
> --- work.orig/include/linux/poll.h
> +++ work/include/linux/poll.h
> @@ -57,6 +57,8 @@ struct poll_table_entry {
>  struct poll_wqueues {
>  	poll_table pt;
>  	struct poll_table_page * table;
> +	struct task_struct * polling_task;
> +	int triggered;

Checkpatch error:

ERROR: "foo * bar" should be "foo *bar"
#173: FILE: include/linux/poll.h:60:
+       struct task_struct * polling_task;

Miklos
