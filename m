Return-Path: <linux-kernel-owner+w=401wt.eu-S1760046AbXEMUao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760046AbXEMUao (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 16:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbXEMUah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 16:30:37 -0400
Received: from mail.screens.ru ([213.234.233.54]:55810 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154AbXEMUag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 16:30:36 -0400
Date: Mon, 14 May 2007 00:30:39 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Alex Dubov <oakad@yahoo.com>, Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: 2.6.22-rc1: Broken suspend on SMP with tifm
Message-ID: <20070513203039.GA3143@tv-sign.ru>
References: <200705132132.08546.rjw@sisk.pl> <20070513200845.GA3078@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070513200845.GA3078@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14, Oleg Nesterov wrote:
>
> On 05/13, Rafael J. Wysocki wrote:
> > 
> > The suspend/hibernation is broken on SMP due to:
> > 
> > commit 3540af8ffddcdbc7573451ac0b5cd57a2eaf8af5
> > tifm: replace per-adapter kthread with freezeable workqueue
> > 
> > Well, it looks like freezable worqueues still deadlock with CPU hotplug
> > when worker threads are frozen.
> 
> Ugh. I thought we deprecated create_freezeable_workqueue(), exactly
> because suspend was changed to call _cpu_down() after freeze().
> 
> It is not that "looks like freezable worqueues still deadlock", it
> is "of course, freezable worqueues deadlocks" on CPU_DEAD.
> 
> The ->freezeable is still here just because of incoming "cpu-hotplug
> using freezer" rework.
> 
> No?
> 
> > --- linux-2.6.22-rc1.orig/kernel/workqueue.c
> > +++ linux-2.6.22-rc1/kernel/workqueue.c
> > @@ -799,9 +799,7 @@ static int __devinit workqueue_cpu_callb
> >  	struct cpu_workqueue_struct *cwq;
> >  	struct workqueue_struct *wq;
> >  
> > -	action &= ~CPU_TASKS_FROZEN;
> > -
> > -	switch (action) {
> > +	switch (action & ~CPU_TASKS_FROZEN) {
> 
> Confused. How can we see, say CPU_UP_PREPARE_FROZEN, if we cleared
> CPU_TASKS_FROZEN bit?

So, unless I missed something stupid, this patch is not 100% right.

I think the better fix (at least for now) is

	- #define create_freezeable_workqueue(name) __create_workqueue((name), 0, 1)
	+ #define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1)

Alex, do you really need a multithreaded wq?

Rafael, what do you think?

Oleg.

