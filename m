Return-Path: <linux-kernel-owner+w=401wt.eu-S1752650AbXB0Xz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbXB0Xz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 18:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbXB0Xz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 18:55:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38775 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbXB0Xz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 18:55:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>
Subject: Re: Problem with freezable workqueues
Date: Wed, 28 Feb 2007 00:57:35 +0100
User-Agent: KMail/1.9.5
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
References: <200702272251.28844.rjw@sisk.pl> <20070227232855.GA457@tv-sign.ru>
In-Reply-To: <20070227232855.GA457@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702280057.36198.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 28 February 2007 00:28, Oleg Nesterov wrote:
> On 02/27, Rafael J. Wysocki wrote:
> >
> > We have a problem with freezable workqueues in 2.6.21-rc1 and in -mm
> > (there are only two of them, in XFS, but still).  Namely, their worker threads
> > deadlock with workqueue_cpu_callback() that gets called during the CPU hotplug,
> > becuase workqueue_cpu_callback() tries to stop these threads while they are
> > frozen (disable_nonboot_cpus() happens after we've frozen tasks).
> 
> Ugh. I know nothing, nothing, nothing about suspend. I'll try to guess.
> 
>    Commit: ed746e3b18f4df18afa3763155972c5835f284c5

Yes, but not only this one.  Please see:

http://kernel.org/git/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e3c7db621bed4afb8e231cb005057f2feb5db557

>    [PATCH] swsusp: Change code ordering in disk.c
> 
>    Change the ordering of code in kernel/power/disk.c so that device_suspend() is
>    called before disable_nonboot_cpus() and platform_finish() is called after
>    enable_nonboot_cpus() and before device_resume(), as indicated by the recent
>    discussion on Linux-PM (cf.
>    http://lists.osdl.org/pipermail/linux-pm/2006-November/004164.html).
> 
>    The changes here only affect the built-in swsusp.
> 
> Yes? with the patch above, _cpu_down() called _after_ freeze_processes() ???

Yes, that's what we want to do.

> Honestly, I can't understand this (yes, I know nothing, nothing, nothing...).

Well, we used the CPU hotplug for disabling nonboot CPUs before
freeze_processes() was called, because the freezer used to be totally unsafe
on SMP.  However, what we wanted from the beginning was to freeze tasks with
all CPUs on line (this way, for example, userland tasks should not notice that
we have played with the CPUs under them, but there are other reasons).

> > For 2.6.21-rc1 I've invented the appended workaround (works for me, waiting for
> > Johannes to confirm it works for him too), but I think we need something better
> > for -mm and future kernels.
> 
> How about other kthread_stop()s ? For example, kernel/softirq.c:cpu_callback() ?

They all are PF_NOFREEZE, I suppose.  If we make all workqueues nonfreezable
(as they were before), the problem won't appear.

> I think we need a general "cpu_down() after freeze" implementation, this is what
> Gautham and Srivatsa are working on, right?

Yes, certainly.

> > --- linux-2.6.21-rc1.orig/kernel/workqueue.c	2007-02-24 10:17:57.000000000 +0100
> > +++ linux-2.6.21-rc1/kernel/workqueue.c	2007-02-24 20:00:22.000000000 +0100
> > @@ -376,8 +376,19 @@ static int worker_thread(void *__cwq)
> >  
> >  	set_current_state(TASK_INTERRUPTIBLE);
> >  	while (!kthread_should_stop()) {
> > -		if (cwq->freezeable)
> > -			try_to_freeze();
> > +		if (try_to_freeze()) {
> > +			/* We've just left the refrigerator.  If our CPU is
> > +			 * a nonboot one, we might have been replaced.
> > +			 * The lock is taken to prevent the race with
> > +			 * cleanup_workqueue_thread() from happening
> > +			 */
> > +			spin_lock_irq(&cwq->lock);
> 
> I'm afraid this is racy. We can't touch *cwq, it may be freed. Suppose
> that another thread does destroy_workqueue(), and we thaw that thread
> before cwq->thread.

Okay, in that case I'd suggest removing create_freezeable_workqueue() and
make all workqueues nonfreezable once again for 2.6.21 (as far as I know, only
the two XFS workqueues are affected).

Pavel, would that be acceptable?

Rafael
