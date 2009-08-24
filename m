Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbZHXSEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbZHXSEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 14:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbZHXSEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 14:04:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbZHXSEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 14:04:46 -0400
Date: Mon, 24 Aug 2009 20:01:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Is adding requeue_delayed_work() a good idea
Message-ID: <20090824180112.GC16202@redhat.com>
References: <adazl9uw3w1.fsf@cisco.com> <20090821115547.GA6901@redhat.com> <adaab1sx29p.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaab1sx29p.fsf@cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21, Roland Dreier wrote:
>
>  > The main question is: what should requeue_delayed_work(dwork) do when
>  > dwork->timer is not pending but dwork->work is queued or running?
>  > Should it cancel dwork->work is this case?
>
> In my particular case it doesn't really matter.  In the queued case it
> could leave it to run whenever it gets to the head of the workqueue.  In
> the already running case then I think the timer should be reset.  The
> main point is that if I do requeue_delayed_work() I want to make sure
> the work runs all the way through from the beginning at some point in
> the future.  The pattern I have in mind is something like:
>
> 	spin_lock_irqsave(&mydata_lock);
> 	new_timeout = add_item_to_timeout_list();
> 	requeue_delayed_work(wq, &process_timeout_list_work, new_timeout);
> 	spin_unlock_irqsave(&mydata_lock);
>
> so if the process_timeout_list_work runs early or twice it doesn't
> matter; I just want to make sure that the work runs from the beginning
> and sees the new item I added to the list at some point after the
> requeue.

Hmm. But, asuming that process_timeout_list_work->func() takes mydata_lock
too, you can just use queue_delayed_work() ?

process_timeout_list_work can't miss new items, queue_delayed_work()
can only fail if dwork is pending and its ->func has not started yet.

No?

> Perhaps the semantics are sufficiently fuzzy and not general enough, so
> that the best answer is my special-case open coded change for my
> specific case.  I don't know whether other places would even want a
> requeue_delayed_work() ... I simply raise this point because when I find
> myself reimplementing the structure of work_struct + timer because
> delayed_work API is lacking, then it seems prudent to consider extending
> delayed_work API instead.

Yes, I completely agree with you.

I think we need requeue_xxx helper(s), but the exact semantics is not
clear to me.

Oleg.

