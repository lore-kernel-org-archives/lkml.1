Return-Path: <linux-kernel-owner+w=401wt.eu-S1758512AbXETUnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512AbXETUnQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 16:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756260AbXETUnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 16:43:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44481 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756165AbXETUnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 16:43:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: Freezeable workqueues [Was: 2.6.22-rc1: Broken suspend on SMP with tifm]
Date: Sun, 20 May 2007 22:48:04 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Alex Dubov <oakad@yahoo.com>, Pierre Ossman <drzeus@drzeus.cx>,
       Pavel Machek <pavel@ucw.cz>, Gautham R Shenoy <ego@in.ibm.com>
References: <200705132132.08546.rjw@sisk.pl> <200705152254.34402.rjw@sisk.pl> <20070520195417.GB83@tv-sign.ru>
In-Reply-To: <20070520195417.GB83@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705202248.05857.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 20 May 2007 21:54, Oleg Nesterov wrote:
> On 05/15, Rafael J. Wysocki wrote:
> >
> > On Monday, 14 May 2007 23:48, Oleg Nesterov wrote:
> > > 
> > > So, in the long term, should we change this only user, or we think we better fix
> > > freezeable wqs again?
> > 
> > Long term, I'd like to have freezable workqueues, so that people don't have to
> > use "raw" kernel threads only because they need some synchronization with
> > hibertnation/suspend.  Plus some cases in which workqueues are used by
> > fs-related code make me worry.
> 
> OK, so we should fix them. It would be great to also fix the last known problem
> as well (work->func() vs hotplug callback deadlocks).
> 
> I am a bit afraid of too many yes/no options for the freezer, a couple of naive
> questions.
> 
> 1. Can't we make all wqs freezable? I still can't see the reason to have both
>    freezable and not freezable wqs.

The reason might be the same as for having freezable and nonfreezable kernel
threads in general.  For example, there are some kernel threads that we need
for saving the image and I don't see why there shouldn't be any such
workqueues.
 
> 2. Why do we need CPU_TASKS_FROZEN? Can't we change cpu-hotplug to always
>    freeze tasks right now, without any additional changes?

In principle, we can, but for this purpose we'd have to modify all NOFREEZE
tasks.  That wouldn't fly, I'm afraid.

>    Any subsystem should handle correctly the case when _cpu_down() (say)
>    is called with tasks_frozen == 1 anyway. So, why can't we simplify
>    things and do
> 
>    	_cpu_down(int tasks_frozen)
> 
>  		if (!tasks_frozen)
>  			freeze_processes();
>  		...
> 
>   right now?

But we call _cpu_down() after device_suspend(), so many tasks are already
frozen at this point.  We'd only need to freeze those that are not frozen and
in _cpu_up() we'd have to thaw them.

> > [*] The problem is, though, that freezable workqueus have some potential to fail
> > the freezer.  Namely, suppose task A calls flush_workqueue() on a freezable
> > workqueue, finds some work items in there, inserts the barrier and waits for
> > completion (TASK_UNINTERRUPTIBLE).  In the meantime, TIF_FREEZE is set on
> > the worker thread, which is then woken up and goes to the refrigerator.  Thus
> > if A is not NOFREEZE, the freezing of tasks will fail (A must be a kernel
> > thread for this to happen, but still).  Worse yet, if A is NOFREEZE, it will be
> > blocked until the worker thread is woken up.
> 
> Yes, this is yet another dependency which freezer can't handle. Probably it is
> better to ignore this problem for now.
> 
> > To avoid this, I think, we may need to redesign the freezer, so that freezable
> > worker threads are frozen after all of the other kernel threads.
> 
> I doubt we can find a very clean way to do this. Besides, what if work->func()
> does flush_workqueue(another_wq) ? How can we decide which wq to freeze first?

We can't.

I think it would be a mistake to even try to remove all limitations from the
freezer.  Any other synchronization mechanisms have some limitations as well.

The code that uses these mechanisms is usually expected to use them in a sane
way and I don't see why we shouldn't expect the freezer users to do the same. ;-)
 
> >                                                                   Additionally,
> > we'd need to make a rule that NOFREEZE kernel threads must not call
> > flush_workqueue() or cancel_work_sync() on freezable workqueues.
> 
> cancel_work_sync() is OK, it can be used safely even if workqueue is frozen.
> flush_workqueue() and destroy_workqueue() are not.

Yes, you're right.

Greetings,
Rafael
