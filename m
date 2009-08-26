Return-Path: <linux-kernel-owner+w=401wt.eu-S1752777AbZHZSmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbZHZSmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 14:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbZHZSmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 14:42:36 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:1850 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbZHZSmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 14:42:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAF8elUqrR7MV/2dsb2JhbADAQog5kDYFhBo
X-IronPort-AV: E=Sophos;i="4.44,281,1249257600"; 
   d="scan'208";a="375861321"
From: Roland Dreier <rdreier@cisco.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: Is adding requeue_delayed_work() a good idea
References: <adazl9uw3w1.fsf@cisco.com> <20090821115547.GA6901@redhat.com>
	<adaab1sx29p.fsf@cisco.com> <20090824180112.GC16202@redhat.com>
	<ada4orwvrx7.fsf@cisco.com> <20090825093906.GA3020@redhat.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 26 Aug 2009 11:42:36 -0700
In-Reply-To: <20090825093906.GA3020@redhat.com> (Oleg Nesterov's message of
	"Tue, 25 Aug 2009 11:39:06 +0200")
Message-ID: <ada7hwqto0z.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Aug 2009 18:42:37.0395 (UTC) FILETIME=[FBB0D230:01CA267C]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > OK, in this case I think we have a simple solution,
 > 
 > 	// like cancel_delayed_work, but uses del_timer().
 > 	// this means, if it returns 0 the timer function may be
 > 	// running and the queueing is in progress. The caller
 > 	// can't rely on flush_workqueue/etc
 > 	static inline int __cancel_delayed_work(struct delayed_work *work)
 > 	{
 > 		int ret;
 > 
 > 		ret = del_timer(&work->timer);
 > 		if (ret)
 > 			work_clear_pending(&work->work);
 > 		return ret;
 > 	}
 > 
 > Now, you can do
 > 
 > 	spin_lock_irqsave(&mydata_lock);
 > 	new_timeout = add_item_to_timeout_list();
 > 
 > 	__cancel_delayed_work(&process_timeout_list_work);
 > 	queue_delayed_work(wq, &process_timeout_list_work, new_timeout);
 > 
 > 	spin_unlock_irqsave(&mydata_lock);
 > 
 > If queue_delayed_work() fails, this means that WORK_STRUCT_PENDING is set,
 > dwork->work is already queued or the queueing is in progress. In both
 > cases it will run "soon" as if we just called queue_work(&dwork->work).

This looks like it would work well.  If we can get this into 2.6.32 then
I will drop my patch and switch to this approach instead.

 > But this assumes nobody else does queue_delayed_work(dwork, HUGE_DELAY) in
 > parallel, otherwise we can lose the race and another caller can setup
 > HUGE_DELAY timeout.

In my case this is fine -- all uses of queue_delayed_work() are
synchronized with the same lock.  So any place that tries to shorten the
timeout will succeed.

 > In particular, if process_timeout_list_work->func() itself uses
 > queue_delay_work() to re-arm itself we can race. Bu t I think it is always
 > possible to do something to synchronize with work->func, for example
 > work->func() can re-arm itself _before_ it scans timeout_list (under the
 > same lock). This way, if re-queue code above fails because work->func()
 > wins, work->func() must see the new additions to timeout_list.

In my case, work function does do queue_delayed_work(), but with the
same lock as everyone else held.  So there should be no race.

Thanks,
  Roland

