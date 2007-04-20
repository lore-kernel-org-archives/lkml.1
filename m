Return-Path: <linux-kernel-owner+w=401wt.eu-S2992578AbXDTL4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992578AbXDTL4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 07:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992588AbXDTL4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 07:56:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49699 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992578AbXDTL4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 07:56:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ego@in.ibm.com
Subject: Re: [RFC PATCH(experimental) 2/2] Fix freezer-kthread_stop race
Date: Fri, 20 Apr 2007 13:59:29 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, vatsa@in.ibm.com,
       paulmck@us.ibm.com, pavel@ucw.cz
References: <20070419120131.GB13435@in.ibm.com> <200704201054.38037.rjw@sisk.pl> <20070420110520.GB11290@in.ibm.com>
In-Reply-To: <20070420110520.GB11290@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704201359.30490.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 20 April 2007 13:05, Gautham R Shenoy wrote:
> On Fri, Apr 20, 2007 at 10:54:36AM +0200, Rafael J. Wysocki wrote:
> > 
> > Hmm, can't we do something like this instead:
> > 
> > ---
> >  kernel/kthread.c |   10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > Index: linux-2.6.21-rc7/kernel/kthread.c
> > ===================================================================
> > --- linux-2.6.21-rc7.orig/kernel/kthread.c
> > +++ linux-2.6.21-rc7/kernel/kthread.c
> > @@ -13,6 +13,7 @@
> >  #include <linux/file.h>
> >  #include <linux/module.h>
> >  #include <linux/mutex.h>
> > +#include <linux/freezer.h>
> >  #include <asm/semaphore.h>
> > 
> >  /*
> > @@ -232,6 +233,15 @@ int kthread_stop(struct task_struct *k)
> > 
> >  	/* Now set kthread_should_stop() to true, and wake it up. */
> >  	kthread_stop_info.k = k;
> > +	if (!(current->flags & PF_NOFREEZE)) {
> > +		/* If we are freezable, the freezer will wait for us */
> > +		task_lock(k);
> > +		k->flags |= PF_NOFREEZE;
> > +		if (frozen(k))
> > +			k->flags &= ~PF_FROZEN;
> > +
> > +		task_unlock(k);
> > +	}
> 
> Yes, we can do this for now since the tasks have only two freeze states,
> namely Freezeable and Non Freezeable. 
> But with more events like cpu-hotplug and kprobes using the process
> freezer, the simple check
> 
> 	if(!(current->flags & PF_NOFREEZE))
> 
> may not suffice and something like
> 	if(!(current->flags & PFE_ALL & global_freeze_mask))
>  	/* global_freeze_mask is the mask of the events for which the system
> 	  is freezing. */
> 
> appears to be racy. Not that we cannot work it out ;-)

Actually, I thought about it for a while.  The thread that is going to stop
another one may temporarily mark itself as freezable in all cases, which
will have no effect on it, since it's not going to cally try_to_freeze(), but
will make the freezer wait for it.  Next, after returning from
wait_for_completion(), it should restore its old freezability status and that
should make the freezer finish.

> However, I was attempting to solve the generic problem where
> A waits on B and B is frozen. If A is freezeable (under one of the
> events) then the freezer will fail. So a solution would be for A to
> somehow inform B of the dependency and postpone it's freezing.

Well, I think it might be simpler to consider each case separately.  This way
we may be able to avoid introducing the additional TIF_ flag.

> Since akpm mentioned that flush_workqueue() needs to go, I guess, I am
> ok with fixing only kthread_stop/kthread_should_stop for the moment.
> Unless I can spot any other valid case :)

Sure. :-)

BTW, if it turns out that we need to introduce yet another freezer-related
TIF_ flag, it may be acceptable (?) to move all of the freezer-related flags
into a separate member of task_struct (eg. freezer_flags) that can only be
manipulated under task_lock().

I mean, we already have four of them (PF_NOFREEZE, PF_FROZEN,
PF_FREEZER_SKIP, TIF_FREEZE), and you will need to introduce two more for
the freezer-based CPU hotplug, so if yet another one is needed, that will make
up almost a separate u8 field ...

Greetings,
Rafael
