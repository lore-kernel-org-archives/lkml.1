Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151AbYJOKic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbYJOKic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 06:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbYJOKiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 06:38:22 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:54115 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581AbYJOKiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 06:38:20 -0400
Date: Wed, 15 Oct 2008 14:37:53 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] fastboot: Introduce an asynchronous function call mechanism
Message-ID: <20081015103753.GA20300@2ka.mipt.ru>
References: <20081012194427.2e21c22e@infradead.org> <20081015014117.faff3a61.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081015014117.faff3a61.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew, Arjan.

Actually Arjan will not see my reply, since he added my mail to the
blacklist :)

On Wed, Oct 15, 2008 at 01:41:17AM -0700, Andrew Morton (akpm@linux-foundation.org) wrote:
> > On Sun, 12 Oct 2008 19:44:27 -0400 Arjan van de Ven <arjan@infradead.org> wrote:
> > after the discussion on fastboot I came up with the following patch
> > (this was all done at 35000 feet so if it's h0rked .. I'll claim lack of oxygen)
> > 
> > I'll also reply to this email with 2 users of the new infrastructure just to show how it'd be used.
> > 
> > 
> > 
> > >From c5fd398d7210bcdc726dc813523d8b4c58481553 Mon Sep 17 00:00:00 2001
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Date: Sun, 12 Oct 2008 15:27:22 -0400
> > Subject: [PATCH] fastboot: Introduce an asynchronous function call mechanism
> > 
> > During the system boot there are many things that take a long time
> > and also can be done asynchronous; this patch introduces a call_async()
> > function that implements a pool of threads to execute the asynchronous
> > calls.
> > 
> > The calls are divided into pools, and within a pool the calls are processed
> > in order; this is done to preserve stable device numbers.
> >
> > ...
> > 
> > +#include <linux/list.h>
> > +#include <linux/workqueue.h>
> > +#include <linux/wait.h>
> > +#include <linux/hrtimer.h>
> > +#include <linux/slab.h>
> > +#include <linux/kthread.h>
> > +#include <linux/module.h>
> > +#include <linux/spinlock.h>
> > +
> > +#include <stdarg.h>
> > +
> > +static int async_active = 0;
> 
> ?

That's to prevent users of this system, which were registered earlier,
to access yet uninitialized memory and fail.

> > +void init_async_calls(void)
> > +{
> > +	unsigned long i;
> > +	spin_lock_init(&pool_lock);
> > +	for (i = 0; i <= ASYNC_MAX_POOL; i++) {
> > +		INIT_LIST_HEAD(&list_pool[i]);
> > +		init_waitqueue_head(&waitqueue_pool[i]);
> > +		thread_pool[i] = kthread_run(&async_thread, (void *)i, "kasyncd/%li", i);
> > +	}
> > +	async_active = 1;
> > +}
> 
> Please talk to Evgeniy about his new thread_pool stuff which I've suggested
> become a generic library.
> 
> (looks at changelog, doesn't really understand the need for the thread pool
> thing, doesn't understand the comment about device numbers)

Well, yes, this case can be implemented via my thread pool code in DST.

> > +
> > +void call_async(int pool_number, int argc, ...)
> 
> This looks like schedule_work().  Why cannot that be used (perhaps after
> suitable modification)?

Thread pool is a better way than a workqueue, when we have number of
tasks to be completed on behalf of some process we do not care which.
With workqueue you either have to have one workqueue per requested work,
or implement non-trivial policy on adding workqueues on demand. With
thread pool you can add new thread and schedule new work, if all other
threads are used. When all event threads are used, no new work can be
executed, since there is no way to extend number of those threads on
demand.

-- 
	Evgeniy Polyakov
