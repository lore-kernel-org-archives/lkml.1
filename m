Return-Path: <linux-kernel-owner+w=401wt.eu-S1754462AbXDTLF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbXDTLF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 07:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbXDTLF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 07:05:26 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35468 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462AbXDTLFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 07:05:25 -0400
Date: Fri, 20 Apr 2007 16:35:20 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, vatsa@in.ibm.com,
       paulmck@us.ibm.com, pavel@ucw.cz
Subject: Re: [RFC PATCH(experimental) 2/2] Fix freezer-kthread_stop race
Message-ID: <20070420110520.GB11290@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070419120131.GB13435@in.ibm.com> <20070419120419.GB17069@in.ibm.com> <20070419143133.a6c82ef8.akpm@linux-foundation.org> <200704201054.38037.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704201054.38037.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 10:54:36AM +0200, Rafael J. Wysocki wrote:
> 
> Hmm, can't we do something like this instead:
> 
> ---
>  kernel/kthread.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> Index: linux-2.6.21-rc7/kernel/kthread.c
> ===================================================================
> --- linux-2.6.21-rc7.orig/kernel/kthread.c
> +++ linux-2.6.21-rc7/kernel/kthread.c
> @@ -13,6 +13,7 @@
>  #include <linux/file.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>
> +#include <linux/freezer.h>
>  #include <asm/semaphore.h>
> 
>  /*
> @@ -232,6 +233,15 @@ int kthread_stop(struct task_struct *k)
> 
>  	/* Now set kthread_should_stop() to true, and wake it up. */
>  	kthread_stop_info.k = k;
> +	if (!(current->flags & PF_NOFREEZE)) {
> +		/* If we are freezable, the freezer will wait for us */
> +		task_lock(k);
> +		k->flags |= PF_NOFREEZE;
> +		if (frozen(k))
> +			k->flags &= ~PF_FROZEN;
> +
> +		task_unlock(k);
> +	}

Yes, we can do this for now since the tasks have only two freeze states,
namely Freezeable and Non Freezeable. 
But with more events like cpu-hotplug and kprobes using the process
freezer, the simple check

	if(!(current->flags & PF_NOFREEZE))

may not suffice and something like
	if(!(current->flags & PFE_ALL & global_freeze_mask))
 	/* global_freeze_mask is the mask of the events for which the system
	  is freezing. */

appears to be racy. Not that we cannot work it out ;-)

However, I was attempting to solve the generic problem where
A waits on B and B is frozen. If A is freezeable (under one of the
events) then the freezer will fail. So a solution would be for A to
somehow inform B of the dependency and postpone it's freezing.

Since akpm mentioned that flush_workqueue() needs to go, I guess, I am
ok with fixing only kthread_stop/kthread_should_stop for the moment.
Unless I can spot any other valid case :)


>  	wake_up_process(k);
>  	put_task_struct(k);
> 

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
