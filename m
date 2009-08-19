Return-Path: <linux-kernel-owner+w=401wt.eu-S1752481AbZHSOLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbZHSOLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 10:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbZHSOLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 10:11:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:38023 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbZHSOLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 10:11:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=asby4Ty5GzMd1Zwj5GPiO2RQp2sQ2QLQFXP+e0W34GtFjGl6TvBrUItcjouLQt19/B
         JciL3vk5l7sjf+DdseR6GxB6AJU/xZ6VyYAsUdqaXJKcnvliV0HabLofwR3891Zc1ccv
         s9QWwZlEFrNoLCYylPvBv/yfG7fbek7xQ6h/E=
Message-ID: <4A8C0820.8060200@gmail.com>
Date: Wed, 19 Aug 2009 23:11:44 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Jens Axboe <jens.axboe@oracle.com>, Mark Lord <liml@rtr.ca>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] libata: use single threaded work queue
References: <20090819112554.GY12579@kernel.dk> <4A8BE932.5090300@garzik.org> <20090819120458.GZ12579@kernel.dk> <4A8BECC2.2060607@rtr.ca> <20090819122320.GA12579@kernel.dk> <4A8BFC79.1000004@garzik.org> <4A8BFDE2.1010904@garzik.org>
In-Reply-To: <4A8BFDE2.1010904@garzik.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

Jeff Garzik wrote:
>> Let people complain with code :) libata has two basic needs in this area:
>> (1) specifying a thread count other than "1" or "nr-cpus"
>> (2) don't start unneeded threads / idle out unused threads
> 
> To be even more general,
> 
> libata needs a workqueue or thread pool that can
> 
> (a) scale up to nr-drives-that-use-pio threads, on demand
> (b) scale down to zero threads, with lack of demand
> 
> That handles the worst case of each PIO-polling drive needing to sleep
> (thus massively impacting latency, if any other PIO-polling drive must
> wait for a free thread).
> 
> That also handles the best case of not needing any threads at all.

Heh... I've been trying to implement in-kernel media presence polling
and hit about the same problem.  The problem is quite widespread.  The
choice of multithreaded workqueue was intentional as Jeff explained.
There are many workqueues which are created in fear of blocking or
being blocked by other works although in most cases it shouldn't be a
problem then there's the newly added async mechanism, which I don't
quite get as it runs the worker function from different environment
depending on resource availability - the worker function might be
executed synchronously where it might have different context
w.r.t. locking or whatever.

So, I've spent some time thinking about alternative so that things can
be unified.

* Per-cpu binding is good.

* Managing the right level of concurrency isn't easy.  If we try to
  schedule works too soonish we can end up wasting resources and slow
  things down compared to the current somewhat confined work
  processing.  If works are scheduled too late, resources will be
  underutilized.

* Some workqueues are there to guarantee forward progress and avoid
  deadlocks around the work execution resource (workqueue threads).
  Similar mechanism needs to be in place.

* It would be nice to implement async execution in terms of workqueue
  or even replace it with workqueue.

My a bit crazy idea was like the followings.

* All works get queued on a single unified per-cpu work list.

* Perfect level of concurrency can be managed by hooking into
  scheduler and kicking a new worker thread iff the currently running
  worker is about to be scheduled out for whatever reason and there's
  no other worker ready to run.

* Thread pool of a few idle threads is always maintained per cpu and
  they get used by the above scheduler hooking.  When the thread pool
  gets exhausted, manager thread is scheduled instead and replenishes
  the pool.  When there are too many idle threads, the pool size is
  reduced slowly.

* Forward-progress can be guaranteed by reserving a single thread for
  any such group of works.  When there are such works pending and the
  manager is invoked to replenish the worker pook, all such works on
  the queue are dispatched to their respective reserved threads.
  Please note that this will happen only rarely as the worker pool
  size will be kept enough and stable most of the time.

* Async can be reimplemented as work which get assigned to cpus in
  round-robin manner.  This wouldn't be perfect but should be enough.

Managing the perfect level of concurrency would have benefits in
resource usages, cache footprint, bandwidth and responsiveness.  I
haven't actually tried to implement the above yet and am still
wondering whether the complexity is justified.

Thanks.

-- 
tejun
