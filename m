Return-Path: <linux-kernel-owner+w=401wt.eu-S932937AbZHUVxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937AbZHUVxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932413AbZHUVxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:53:07 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:53656 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254AbZHUVxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:53:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAJO0jkqrR7PD/2dsb2JhbAC9OYg3kFMFhBo
X-IronPort-AV: E=Sophos;i="4.44,252,1249257600"; 
   d="scan'208";a="372586948"
From: Roland Dreier <rdreier@cisco.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Is adding requeue_delayed_work() a good idea
References: <adazl9uw3w1.fsf@cisco.com> <20090821115547.GA6901@redhat.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 21 Aug 2009 14:53:06 -0700
In-Reply-To: <20090821115547.GA6901@redhat.com> (Oleg Nesterov's message of
	"Fri, 21 Aug 2009 13:55:47 +0200")
Message-ID: <adaab1sx29p.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Aug 2009 21:53:06.0926 (UTC) FILETIME=[C42818E0:01CA22A9]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > We need some simple changes in timer.c. __mod_timer() already has
 > pending_only, but requeue_delayed_work() needs another flag to prevent
 > migrating to another CPU. Again, this is simple, let's suppose we have
 > requeue_timer(timer) which works like mod_timer(pending_only => true)
 > but never changes timer->base.

Yes... in my case I don't particularly care about which CPU the timer or
work runs on, so I ignored that.

 > The main question is: what should requeue_delayed_work(dwork) do when
 > dwork->timer is not pending but dwork->work is queued or running?
 > Should it cancel dwork->work is this case?

In my particular case it doesn't really matter.  In the queued case it
could leave it to run whenever it gets to the head of the workqueue.  In
the already running case then I think the timer should be reset.  The
main point is that if I do requeue_delayed_work() I want to make sure
the work runs all the way through from the beginning at some point in
the future.  The pattern I have in mind is something like:

	spin_lock_irqsave(&mydata_lock);
	new_timeout = add_item_to_timeout_list();
	requeue_delayed_work(wq, &process_timeout_list_work, new_timeout);
	spin_unlock_irqsave(&mydata_lock);

so if the process_timeout_list_work runs early or twice it doesn't
matter; I just want to make sure that the work runs from the beginning
and sees the new item I added to the list at some point after the
requeue.

 > OK, suppose that we s/cancel_delayed_work/requeue_delayed_work/,
 > then we seem to have the same deadlock
 > 
 >   A: holding cm_id_priv->lock, waiting for mad_agent_priv->lock
 >   B: holding mad_agent_priv->lock, waiting for requeue_delayed_work()
 >      which found !timer_pending() && queued work
 >   C: interrupt during work->func() that takes cm_id_priv->lock

Yes, I agree that if requeue_delayed_work() ever waits then we run into
the same deadlock as before.  It only works if requeue_delayed_work() is
the rough equivalent of mod_timer(), which never waits.

 > Perhaps, requeue_delayed_work() should cancel the pending work, but do
 > not wait_on_work(). This is not trivial, we have to avoid livelocks if
 > cancel_work_no_sync() races with queue_work()/etc. Perhaps,
 > requeue_delayed_work() could return the error if it can't update the
 > timer and can't cancel the work without spinning ?

I guess returning an error is possible ... although I wonder what the
caller would do to handle the error?

Perhaps the semantics are sufficiently fuzzy and not general enough, so
that the best answer is my special-case open coded change for my
specific case.  I don't know whether other places would even want a
requeue_delayed_work() ... I simply raise this point because when I find
myself reimplementing the structure of work_struct + timer because
delayed_work API is lacking, then it seems prudent to consider extending
delayed_work API instead.

Thanks,
  Roland
