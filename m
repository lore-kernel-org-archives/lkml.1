Return-Path: <linux-kernel-owner+w=401wt.eu-S1751694AbZH1SEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbZH1SEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 14:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbZH1SEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 14:04:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbZH1SEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 14:04:00 -0400
Date: Fri, 28 Aug 2009 19:59:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 0/1] introduce __cancel_delayed_work()
Message-ID: <20090828175931.GA19326@redhat.com>
References: <adazl9uw3w1.fsf@cisco.com> <20090821115547.GA6901@redhat.com> <adaab1sx29p.fsf@cisco.com> <20090824180112.GC16202@redhat.com> <ada4orwvrx7.fsf@cisco.com> <20090825093906.GA3020@redhat.com> <ada7hwqto0z.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada7hwqto0z.fsf@cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26, Roland Dreier wrote:
>
>  > OK, in this case I think we have a simple solution,
>  >
>  > 	// like cancel_delayed_work, but uses del_timer().
>  > 	// this means, if it returns 0 the timer function may be
>  > 	// running and the queueing is in progress. The caller
>  > 	// can't rely on flush_workqueue/etc
>  > 	static inline int __cancel_delayed_work(struct delayed_work *work)
>  > 	{
>  > 		int ret;
>  >
>  > 		ret = del_timer(&work->timer);
>  > 		if (ret)
>  > 			work_clear_pending(&work->work);
>  > 		return ret;
>  > 	}
>
> This looks like it would work well.  If we can get this into 2.6.32 then
> I will drop my patch and switch to this approach instead.

I am not sure how can I push this patch into 2.6.32, so I am just sending
it to Andrew.

Or. Please feel free to embed this change in mad.c fixes and send the patch
yourself (if it is not too late, I have to apologize for delay again).


As for requeue, perhaps we should add two helpers. The first is simple,

	if (!mod_timer_pending(dwork->timer, new_delay))
		queue_delayed_work(dwork, new_delay);

and I think this is what we need for mad.c. Another one is not "atomic"
but also cancells dwork. But this we we can't decide what exactly these
helpers should do, it is "safer" to add the trivial __cancel_delayed_work()
which hopefully can have other users.

Oleg.

