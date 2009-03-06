Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbZCFPpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbZCFPpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:45:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbZCFPo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:44:59 -0500
Received: from mx2.redhat.com ([66.187.237.31]:32849 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168AbZCFPo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:44:59 -0500
Date: Fri, 6 Mar 2009 16:41:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <npiggin@suse.de>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH]: wait: don't resched in prepare_to_wait()
Message-ID: <20090306154144.GA7841@redhat.com>
References: <1236350377.6326.389.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236350377.6326.389.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06, Peter Zijlstra wrote:
>
> After prepare to wait, we either call schedule() or find !cond in which
> case we'll call finish_wait() which contains another preemption check.
>
> @@ -73,7 +73,9 @@ prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state)
>  	if (list_empty(&wait->task_list))
>  		__add_wait_queue(q, wait);
>  	set_current_state(state);
> +	preempt_disable();
>  	spin_unlock_irqrestore(&q->lock, flags);
> +	preempt_enable_no_resched();

But this only helps if the task gets TIF_NEED_RESCHED while it was in
spin_lock_irqsave() section, right? This window should be very small
unless we have the contention.

Or do you have something else in mind?

Oleg.

