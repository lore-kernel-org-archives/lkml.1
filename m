Return-Path: <linux-kernel-owner+w=401wt.eu-S965687AbXDCRLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965687AbXDCRLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965663AbXDCRLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:11:10 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:40974 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965687AbXDCRLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:11:08 -0400
Date: Tue, 3 Apr 2007 22:48:20 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@linux-foundation.org,
       paulmck@us.ibm.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       mingo@elte.hu, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 7/8] Clean up workqueue.c with respect to the freezer based cpu-hotplug
Message-ID: <20070403171820.GA8646@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070402053457.GA9076@in.ibm.com> <20070402054206.GG12962@in.ibm.com> <20070403114729.GA776@tv-sign.ru> <20070403135919.GB32444@in.ibm.com> <20070403150336.GA850@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070403150336.GA850@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 07:03:36PM +0400, Oleg Nesterov wrote:
> I think it would be nice to do. I believe we can cleanup ksoftirqd()
> and migration_thread() as well (kill wait_to_die: loop). Probably it

I doubt whether we can kill it in migration_thread, since that is
another thread which is unfrozen for hotplug (stop_machine relies on its
services while rest of the world is frozen).

> is better to introduce a new helper for that, kthread_thaw_stop() or
> something.

Will think of that.


> > Why?
> 
> What if is_single_threaded(wq) == true? In that case we should call
> flush_cpu_workqueue(cpu) only if cpu == singlethread_cpu, otherwise
> this is unneeded and wrong, because per_cpu_ptr(wq->cpu_wq, cpu) was
> not initialized.

Ah yes ..

> > kthread_stop(p)
> > {
> > 	int old_exempt_flags;
> > 
> > 	task_lock(p);
> > 	old_exempt_flags = p->flags;
> > 	p->flags |= PFE_ALL;	/* Exempt 'p' from being frozen? */
> 
> I agree, we should mark this thread as non-freezable, but we can't modify
> p->flags, this is racy. "current" owns its ->flags and it is not atomic.
> Note that thaw_process() checks frozen(p) when it clears PF_FROZEN.

I suspected that we cannot modify p->flags just like that. How abt
moving freezer exemption bits to a separate field, which is protected by
task_lock?

> Actually, we should do this before destroy_workqueue() calls flush_workqueue().
> Otherwise flush_cpu_workqueue() can hang forever in a similar manner.

Yep. I guess these are a class of freezer deadlocks very similar to vfork
parent waiting on child case. I get a feeling these should become common
outside of kthread too (A waits on B for something, B gets frozen, which
means A won't freeze causing freezer to fail). Can freezer detect this
dependency somehow and thaw B automatically? Probably not that easy ..

> Needs more thinking, I guess.

[snip]

> No, no, workqueue_mutex can't help. Just for example: CPU_UP_PREPARE completes
> and drops workqueue_mutex. __create_workqueue(wq) doesn't see the new cpu, it
> is not on cpu_online_map, so it doesn't create cwq->thread. CPU_ONLINE oopses.

Ok ..sure.

-- 
Regards,
vatsa
