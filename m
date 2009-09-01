Return-Path: <linux-kernel-owner+w=401wt.eu-S1752527AbZIAAoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbZIAAoj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 20:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbZIAAoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 20:44:39 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:11369 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbZIAAoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 20:44:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=lIPuOsp5syHAveytZKSYLXf5iObwuVPqCjPB/juM5FN1VdMi0CAgVn9chJd5yLLdlI
         X09dmHH0IviOb5EzzLfWd2lDSQ2FS2QyfZ1rGSvfT8P5Rw20VkhuCbKcC2Ap8DpHHeEt
         L2T4zDR9YAuV6ehUnqU3TAuFp+Etek1hbIWRY=
Date: Mon, 31 Aug 2009 17:44:31 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Is adding requeue_delayed_work() a good idea
References: <adazl9uw3w1.fsf@cisco.com> <20090821115547.GA6901@redhat.com> <adaab1sx29p.fsf@cisco.com> <20090824180112.GC16202@redhat.com> <ada4orwvrx7.fsf@cisco.com> <20090825093906.GA3020@redhat.com> <ada7hwqto0z.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada7hwqto0z.fsf@cisco.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090901011714.4F6B6526EA5@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 11:42:36AM -0700, Roland Dreier wrote:
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
>  > 
>  > Now, you can do
>  > 
>  > 	spin_lock_irqsave(&mydata_lock);
>  > 	new_timeout = add_item_to_timeout_list();
>  > 
>  > 	__cancel_delayed_work(&process_timeout_list_work);
>  > 	queue_delayed_work(wq, &process_timeout_list_work, new_timeout);
>  > 
>  > 	spin_unlock_irqsave(&mydata_lock);
>  > 
>  > If queue_delayed_work() fails, this means that WORK_STRUCT_PENDING is set,
>  > dwork->work is already queued or the queueing is in progress. In both
>  > cases it will run "soon" as if we just called queue_work(&dwork->work).
> 
> This looks like it would work well.  If we can get this into 2.6.32 then
> I will drop my patch and switch to this approach instead.
> 
>  > But this assumes nobody else does queue_delayed_work(dwork, HUGE_DELAY) in
>  > parallel, otherwise we can lose the race and another caller can setup
>  > HUGE_DELAY timeout.
> 
> In my case this is fine -- all uses of queue_delayed_work() are
> synchronized with the same lock.  So any place that tries to shorten the
> timeout will succeed.
> 

I can add the necessary locking in my case - I think it is actually needed
there even without this particular change.

-- 
Dmitry
