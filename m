Return-Path: <linux-kernel-owner+w=401wt.eu-S1754280AbZHUL7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbZHUL7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 07:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbZHUL7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 07:59:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444AbZHUL7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 07:59:19 -0400
Date: Fri, 21 Aug 2009 13:55:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Is adding requeue_delayed_work() a good idea
Message-ID: <20090821115547.GA6901@redhat.com>
References: <adazl9uw3w1.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adazl9uw3w1.fsf@cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20, Roland Dreier wrote:
>
> My patch goes back to an open-coded version of delayed work that splits
> the timer and the work struct.  However it occurs to me that an API like
> requeue_delayed_work() that does a mod_timer() on the delayed work
> struct might be useful -- OTOH making this fully general and keeping
> track of the work's pending bit etc seems perhaps a bit dicy.

Completely agreed.

We need some simple changes in timer.c. __mod_timer() already has
pending_only, but requeue_delayed_work() needs another flag to prevent
migrating to another CPU. Again, this is simple, let's suppose we have
requeue_timer(timer) which works like mod_timer(pending_only => true)
but never changes timer->base.

The main question is: what should requeue_delayed_work(dwork) do when
dwork->timer is not pending but dwork->work is queued or running?
Should it cancel dwork->work is this case?

If yes, then I don't understand how this new helper (which is good
anyway) can help with this particular problem,

> happens because the mad module does
>
> 	cancel_delayed_work(&mad_agent_priv->timed_work);
>
> while holding mad_agent_priv->lock.  cancel_delayed_work() internally
> does del_timer_sync(&mad_agent_priv->timed_work.timer).
>
> This can turn into a deadlock because mad_agent_priv->lock is taken
> inside cm_id_priv->lock, so we can get the following set of contexts
> that deadlock each other:
>
>  A: holding cm_id_priv->lock, waiting for mad_agent_priv->lock
>  B: holding mad_agent_priv->lock, waiting for del_timer_sync()
>  C: interrupt during mad_agent_priv->timed_work.timer that takes
>     cm_id_priv->lock

OK, suppose that we s/cancel_delayed_work/requeue_delayed_work/,
then we seem to have the same deadlock

  A: holding cm_id_priv->lock, waiting for mad_agent_priv->lock
  B: holding mad_agent_priv->lock, waiting for requeue_delayed_work()
     which found !timer_pending() && queued work
  C: interrupt during work->func() that takes cm_id_priv->lock

Perhaps, requeue_delayed_work() should cancel the pending work, but do
not wait_on_work(). This is not trivial, we have to avoid livelocks if
cancel_work_no_sync() races with queue_work()/etc. Perhaps,
requeue_delayed_work() could return the error if it can't update the
timer and can't cancel the work without spinning ?

What dou you think?

Oleg.

