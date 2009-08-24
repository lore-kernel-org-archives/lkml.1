Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbZHXVLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbZHXVLB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 17:11:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbZHXVK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 17:10:59 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:6717 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbZHXVK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 17:10:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEADufkkqrR7O6/2dsb2JhbADAE4g3jmwFhBo
X-IronPort-AV: E=Sophos;i="4.44,267,1249257600"; 
   d="scan'208";a="232361381"
From: Roland Dreier <rdreier@cisco.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Is adding requeue_delayed_work() a good idea
References: <adazl9uw3w1.fsf@cisco.com> <20090821115547.GA6901@redhat.com>
	<adaab1sx29p.fsf@cisco.com> <20090824180112.GC16202@redhat.com>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 24 Aug 2009 14:11:00 -0700
In-Reply-To: <20090824180112.GC16202@redhat.com> (Oleg Nesterov's message of
	"Mon, 24 Aug 2009 20:01:12 +0200")
Message-ID: <ada4orwvrx7.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Aug 2009 21:11:00.0602 (UTC) FILETIME=[6196E5A0:01CA24FF]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > > In my particular case it doesn't really matter.  In the queued case it
 > > could leave it to run whenever it gets to the head of the workqueue.  In
 > > the already running case then I think the timer should be reset.  The
 > > main point is that if I do requeue_delayed_work() I want to make sure
 > > the work runs all the way through from the beginning at some point in
 > > the future.  The pattern I have in mind is something like:
 > >
 > > 	spin_lock_irqsave(&mydata_lock);
 > > 	new_timeout = add_item_to_timeout_list();
 > > 	requeue_delayed_work(wq, &process_timeout_list_work, new_timeout);
 > > 	spin_unlock_irqsave(&mydata_lock);
 > >
 > > so if the process_timeout_list_work runs early or twice it doesn't
 > > matter; I just want to make sure that the work runs from the beginning
 > > and sees the new item I added to the list at some point after the
 > > requeue.
 > 
 > Hmm. But, asuming that process_timeout_list_work->func() takes mydata_lock
 > too, you can just use queue_delayed_work() ?
 > 
 > process_timeout_list_work can't miss new items, queue_delayed_work()
 > can only fail if dwork is pending and its ->func has not started yet.

Maybe I misunderstand the code or misunderstand you, but looking at it:

	int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
				struct delayed_work *dwork, unsigned long delay)
	{
		int ret = 0;
		struct timer_list *timer = &dwork->timer;
		struct work_struct *work = &dwork->work;
	
		if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
			BUG_ON(timer_pending(timer));
			BUG_ON(!list_empty(&work->entry));
			//...
		}
		return ret;
	}

if I have dwork already queued and try to requeue it for earlier it
seems that this will just silently return with the later expiration
still in effect.

Maybe I wasn't totally clear on what I want to happen; an example would
be if, say, I have delayed work queued with timer set to expire in 100
seconds and then a new piece of work is added that needs to expire in 1
second.  So I want to requeue delayed work to run in 1 second, not wait
the 100 seconds for the original timeout work.

 > I think we need requeue_xxx helper(s), but the exact semantics is not
 > clear to me.

Not clear to me either unfortunately.

 - R.
