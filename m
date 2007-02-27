Return-Path: <linux-kernel-owner+w=401wt.eu-S1752036AbXB0X3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbXB0X3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 18:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbXB0X3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 18:29:24 -0500
Received: from mail.screens.ru ([213.234.233.54]:49785 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbXB0X3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 18:29:23 -0500
Date: Wed, 28 Feb 2007 02:28:55 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Gautham R Shenoy <ego@in.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: Problem with freezable workqueues
Message-ID: <20070227232855.GA457@tv-sign.ru>
References: <200702272251.28844.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702272251.28844.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27, Rafael J. Wysocki wrote:
>
> We have a problem with freezable workqueues in 2.6.21-rc1 and in -mm
> (there are only two of them, in XFS, but still).  Namely, their worker threads
> deadlock with workqueue_cpu_callback() that gets called during the CPU hotplug,
> becuase workqueue_cpu_callback() tries to stop these threads while they are
> frozen (disable_nonboot_cpus() happens after we've frozen tasks).

Ugh. I know nothing, nothing, nothing about suspend. I'll try to guess.

   Commit: ed746e3b18f4df18afa3763155972c5835f284c5

   [PATCH] swsusp: Change code ordering in disk.c

   Change the ordering of code in kernel/power/disk.c so that device_suspend() is
   called before disable_nonboot_cpus() and platform_finish() is called after
   enable_nonboot_cpus() and before device_resume(), as indicated by the recent
   discussion on Linux-PM (cf.
   http://lists.osdl.org/pipermail/linux-pm/2006-November/004164.html).

   The changes here only affect the built-in swsusp.

Yes? with the patch above, _cpu_down() called _after_ freeze_processes() ???
Honestly, I can't understand this (yes, I know nothing, nothing, nothing...).

> For 2.6.21-rc1 I've invented the appended workaround (works for me, waiting for
> Johannes to confirm it works for him too), but I think we need something better
> for -mm and future kernels.

How about other kthread_stop()s ? For example, kernel/softirq.c:cpu_callback() ?

I think we need a general "cpu_down() after freeze" implementation, this is what
Gautham and Srivatsa are working on, right?

> --- linux-2.6.21-rc1.orig/kernel/workqueue.c	2007-02-24 10:17:57.000000000 +0100
> +++ linux-2.6.21-rc1/kernel/workqueue.c	2007-02-24 20:00:22.000000000 +0100
> @@ -376,8 +376,19 @@ static int worker_thread(void *__cwq)
>  
>  	set_current_state(TASK_INTERRUPTIBLE);
>  	while (!kthread_should_stop()) {
> -		if (cwq->freezeable)
> -			try_to_freeze();
> +		if (try_to_freeze()) {
> +			/* We've just left the refrigerator.  If our CPU is
> +			 * a nonboot one, we might have been replaced.
> +			 * The lock is taken to prevent the race with
> +			 * cleanup_workqueue_thread() from happening
> +			 */
> +			spin_lock_irq(&cwq->lock);

I'm afraid this is racy. We can't touch *cwq, it may be freed. Suppose
that another thread does destroy_workqueue(), and we thaw that thread
before cwq->thread.

Oleg.

