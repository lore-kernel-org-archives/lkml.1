Return-Path: <linux-kernel-owner+w=401wt.eu-S1752780AbZCGPoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbZCGPoz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 10:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755423AbZCGPop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 10:44:45 -0500
Received: from www.tglx.de ([62.245.132.106]:40976 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755282AbZCGPoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 10:44:44 -0500
Date: Sat, 7 Mar 2009 16:44:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhltc@us.ibm.com>
cc: "lkml, " <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [TIP][RFC 5/7] rt_mutex: add proxy lock routines
In-Reply-To: <49AC76EF.4030402@us.ibm.com>
Message-ID: <alpine.LFD.2.00.0903071631060.29264@localhost.localdomain>
References: <49AC73A9.4040804@us.ibm.com> <49AC76EF.4030402@us.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009, Darren Hart wrote:
> /**
> + * rt_mutex_start_proxy_lock - prepare another task to take the lock

Hmm. _start_ sounds weird. Also we do not prepare another task to take
the lock. We either take the lock on behalf on another task or block
that task on the lock.

> + * @lock:		the rt_mutex to take
> + * @waiter:		the rt_mutex_waiter initialized by the waiter

  initialized by the caller perhaps ?

> + * @task:		the task to prepare
> + * @detext_deadlock:	passed to task_blocks_on_rt_mutex

That's not interesting where it is passed to. The argument tells us,
whether deadlock detection needs to be done or not.

> + * The lock should have an owner, and it should not be task.

Why ? The lock can have no owner, if the previous owner released it
before we took lock->wait_lock.

> + * Special API call for FUTEX_REQUEUE_PI support.
> + */
> +int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
> +			      struct rt_mutex_waiter *waiter,
> +			      struct task_struct *task, int detect_deadlock)
> +{
> +	int ret;
> +
> +	spin_lock(&lock->wait_lock);

You need to try to take the lock on behalf of task here under
lock->wait_lock to avoid an enqueue on an ownerless rtmutex.

> +
> +/**
> + * rt_mutex_finish_proxy_lock - Complete the taking of the lock initialized
> on
> + *                              our behalf by another thread.

IIRC this needs to be a single line. Or does kerneldoc support this now ?

> + * @lock: the rt_mutex we were woken on
> + * @to: the timeout, null if none. hrtimer should already have been started.
> + * @waiter: the pre-initialized rt_mutex_waiter
> + * @detect_deadlock: for use by __rt_mutex_slowlock

See above.

Thanks,

	tglx
