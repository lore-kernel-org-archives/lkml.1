Return-Path: <linux-kernel-owner+w=401wt.eu-S1759706AbXEMUpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759706AbXEMUpc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 16:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757459AbXEMUp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 16:45:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38960 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755280AbXEMUpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 16:45:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: 2.6.22-rc1: Broken suspend on SMP with tifm
Date: Sun, 13 May 2007 22:50:25 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Alex Dubov <oakad@yahoo.com>, Pierre Ossman <drzeus@drzeus.cx>
References: <200705132132.08546.rjw@sisk.pl> <20070513200845.GA3078@tv-sign.ru> <20070513203039.GA3143@tv-sign.ru>
In-Reply-To: <20070513203039.GA3143@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705132250.26277.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 13 May 2007 22:30, Oleg Nesterov wrote:
> On 05/14, Oleg Nesterov wrote:
> >
> > On 05/13, Rafael J. Wysocki wrote:
> > > 
> > > The suspend/hibernation is broken on SMP due to:
> > > 
> > > commit 3540af8ffddcdbc7573451ac0b5cd57a2eaf8af5
> > > tifm: replace per-adapter kthread with freezeable workqueue
> > > 
> > > Well, it looks like freezable worqueues still deadlock with CPU hotplug
> > > when worker threads are frozen.
> > 
> > Ugh. I thought we deprecated create_freezeable_workqueue(), exactly
> > because suspend was changed to call _cpu_down() after freeze().
> > 
> > It is not that "looks like freezable worqueues still deadlock", it
> > is "of course, freezable worqueues deadlocks" on CPU_DEAD.
> > 
> > The ->freezeable is still here just because of incoming "cpu-hotplug
> > using freezer" rework.
> > 
> > No?
> > 
> > > --- linux-2.6.22-rc1.orig/kernel/workqueue.c
> > > +++ linux-2.6.22-rc1/kernel/workqueue.c
> > > @@ -799,9 +799,7 @@ static int __devinit workqueue_cpu_callb
> > >  	struct cpu_workqueue_struct *cwq;
> > >  	struct workqueue_struct *wq;
> > >  
> > > -	action &= ~CPU_TASKS_FROZEN;
> > > -
> > > -	switch (action) {
> > > +	switch (action & ~CPU_TASKS_FROZEN) {
> > 
> > Confused. How can we see, say CPU_UP_PREPARE_FROZEN, if we cleared
> > CPU_TASKS_FROZEN bit?
> 
> So, unless I missed something stupid, this patch is not 100% right.

Well, it isn't, but for a different reason (see [*] below).

> I think the better fix (at least for now) is
> 
> 	- #define create_freezeable_workqueue(name) __create_workqueue((name), 0, 1)
> 	+ #define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1)
> 
> Alex, do you really need a multithreaded wq?
> 
> Rafael, what do you think?

That would be misleading if the driver needs the threads to be frozen.

I would prefer to revert the commit that caused the problem to appear, but it
doesn't revert cleanly and I hate to invalidate someone else's work becuase of
my own mistakes.

[*] Getting back to the patch, it seems to me that we should do something like
take_over_work() before thawing the frozen thread, because there may be a queue
to process and the device is suspended at that point.

Greetings,
Rafael
