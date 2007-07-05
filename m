Return-Path: <linux-kernel-owner+w=401wt.eu-S1760954AbXGEObU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760954AbXGEObU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 10:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbXGEObN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 10:31:13 -0400
Received: from mail.screens.ru ([213.234.233.54]:50236 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756295AbXGEObM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 10:31:12 -0400
Date: Thu, 5 Jul 2007 18:32:17 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2] workqueue: debug flushing deadlocks with lockdep
Message-ID: <20070705143217.GA170@tv-sign.ru>
References: <20070705110744.564273000@sipsolutions.net> <20070705110820.304578000@sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070705110820.304578000@sipsolutions.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05, Johannes Berg wrote:
>
> @@ -257,7 +261,9 @@ static void run_workqueue(struct cpu_wor
>  
>  		BUG_ON(get_wq_data(work) != cwq);
>  		work_clear_pending(work);
> +		lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
>  		f(work);
> +		lock_release(&cwq->wq->lockdep_map, 1, _THIS_IP_);

Johannes, my apologies. You were worried about recursion, and you were right,
sorry!

Currently it is allowed that work->func() does flush_workqueue() on its own
workqueue. So we have

	run_workqueue()
		work->func()
			flush_workqueue()
				run_workqueue()

All but work->func() take wq->lockdep_map, I guess check_deadlock() won't be
happy.

In your initial patch, wq->lockdep_map was taken in flush_cpu_workqueue() when
cwq->thread != current, but this is still not enough. Because we take the same
lock when flush_workqueue() does flush_cpu_workqueue() on another CPU.

run_workqueue() is easy, it can check cwq->run_depth == 1 before lock/unlock.

Anybody sees a simple soultion? Perhaps, some clever trick with LOCKDEP ?


OTOH. Perhaps we can can forbid such a behaviour? Andrew, do you know any
good example of "keventd trying to flush its own queue" ?

In any case, I think both patches are great, thanks for doing this!

Oleg.

