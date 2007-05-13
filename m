Return-Path: <linux-kernel-owner+w=401wt.eu-S1759376AbXEMU3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376AbXEMU3J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 16:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbXEMU26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 16:28:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38909 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890AbXEMU25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 16:28:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: 2.6.22-rc1: Broken suspend on SMP with tifm
Date: Sun, 13 May 2007 22:33:49 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Alex Dubov <oakad@yahoo.com>, Pierre Ossman <drzeus@drzeus.cx>
References: <200705132132.08546.rjw@sisk.pl> <20070513200845.GA3078@tv-sign.ru>
In-Reply-To: <20070513200845.GA3078@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705132233.49845.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 13 May 2007 22:08, Oleg Nesterov wrote:
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

Well, apparently no one has told it to Alex ...

> It is not that "looks like freezable worqueues still deadlock", it
> is "of course, freezable worqueues deadlocks" on CPU_DEAD.
> 
> The ->freezeable is still here just because of incoming "cpu-hotplug
> using freezer" rework.
> 
> No?

Yes, but we failed to communicate that to the others clearly enough.

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

There's another 'switch ()' in there where the flag is not cleared
(that's why I removed the 'action &= ~CPU_TASKS_FROZEN' above).

> >  	case CPU_LOCK_ACQUIRE:
> >  		mutex_lock(&workqueue_mutex);
> >  		return NOTIFY_OK;
> > @@ -819,20 +817,29 @@ static int __devinit workqueue_cpu_callb
> >  
> >  		switch (action) {
> >  		case CPU_UP_PREPARE:
> > +		case CPU_UP_PREPARE_FROZEN:
> >  			if (!create_workqueue_thread(cwq, cpu))
> >  				break;
> >  			printk(KERN_ERR "workqueue for %i failed\n", cpu);
> >  			return NOTIFY_BAD;
> >  
> >  		case CPU_ONLINE:
> > +		case CPU_ONLINE_FROZEN:
> >  			start_workqueue_thread(cwq, cpu);
> >  			break;
> >  
> >  		case CPU_UP_CANCELED:
> > +		case CPU_UP_CANCELED_FROZEN:
> >  			start_workqueue_thread(cwq, -1);
> >  		case CPU_DEAD:
> >  			cleanup_workqueue_thread(cwq, cpu);
> >  			break;
> > +
> > +		case CPU_DEAD_FROZEN:
> > +			if (wq->freezeable)
> > +				thaw_process(cwq->thread);
> > +			cleanup_workqueue_thread(cwq, cpu);
> > +			break;
> >  		}
> >  	}
> 
> Minor, but can't we do
> 
> 		...
> 		case CPU_UP_CANCELED:
> 		case CPU_UP_CANCELED_FROZEN:
> 			start_workqueue_thread(cwq, -1);
> 		case CPU_DEAD_FROZEN:
> 			if (wq->freezeable)
> 				// we can't see PF_FROZEN if it was CPU_UP_CANCELED
> 				thaw_process(cwq->thread);
> 		case CPU_DEAD:
> 			cleanup_workqueue_thread(cwq, cpu);
> 			break;
> 
> ?

Yes, we can, but that means one redundant check more in the CPU_UP_CANCELLED
path.  Besides, I prefer having different cases clearly separated if that makes
sense.

Greetings,
Rafael
