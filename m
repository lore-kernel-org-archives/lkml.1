Return-Path: <linux-kernel-owner+w=401wt.eu-S1757427AbXEYIJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbXEYIJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbXEYIJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:09:38 -0400
Received: from mx2.go2.pl ([193.17.41.42]:33989 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751565AbXEYIJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:09:37 -0400
Date: Fri, 25 May 2007 10:16:31 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.21 hang in cancel_rearming_delayed_workqueue()
Message-ID: <20070525081631.GB985@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4656564D.5030307@windriver.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 25-05-2007 05:21, Jason Wessel wrote:
> There is a problem with the calling cancel_rearming_delayed_work if the 
> timer was not yet active.
> 
> I see this problem when netpoll_cleanup() is called without having done 
> any work because it had not processed any packets yet.  The problem 
> appears to be a result of the loop check 
> while(!cancel_delayed_work(dwork)).    This endlessly loops because 
> del_timer_sync() can return 0 or 1 for success which is passed back as a 
> result to the final invariant check for the loop.  In this particular 
> case zero will always be returned because the timer is not active.
> 
> It is possible that the problem exists else where, but I thought I would 
> ask if this is expected?
> 
> #0  del_timer_sync (timer=0xc7ed90f8) at kernel/timer.c:530
> #1  0xc012f08e in cancel_rearming_delayed_workqueue (wq=0xc7fee800,
>   dwork=0xc7ed90e8) at include/linux/workqueue.h:201
> #2  0xc012f0af in cancel_rearming_delayed_work (dwork=0x20)
>   at kernel/workqueue.c:680
> #3  0xc0312f78 in netpoll_cleanup (np=0xc880bf40) at net/core/netpoll.c:784
> 
> Possible fix.
> 
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> 
> Index: linux-2.6.21/kernel/workqueue.c
> ===================================================================
> --- linux-2.6.21.orig/kernel/workqueue.c
> +++ linux-2.6.21/kernel/workqueue.c
> @@ -666,7 +666,7 @@ EXPORT_SYMBOL(flush_scheduled_work);
> void cancel_rearming_delayed_workqueue(struct workqueue_struct *wq,
>                                      struct delayed_work *dwork)
> {
> -       while (!cancel_delayed_work(dwork))
> +       while (cancel_delayed_work(dwork) > 0)
>               flush_workqueue(wq);
> }
> EXPORT_SYMBOL(cancel_rearming_delayed_workqueue);

It's very optimistic change...

I wonder, how this all could work so long (or how it is supposed
to work now without breaking other callers) with (almost) reversed
condition?

According to this comment:

" * cancel_rearming_delayed_workqueue - reliably kill off a delayed
 work whose handler rearms the delayed work."

So, it cannot be used in netpoll_cleanup() if there is no rearming
during this cancel at all. This is a tricky behaviour of course,
and is changed in 2.6.22-rc.

Regards,
Jarek P.
