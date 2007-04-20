Return-Path: <linux-kernel-owner+w=401wt.eu-S1161228AbXDTVlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161228AbXDTVlb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 17:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbXDTVla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 17:41:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51567 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510AbXDTVl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 17:41:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFC PATCH(experimental) 2/2] Fix freezer-kthread_stop race
Date: Fri, 20 Apr 2007 23:45:22 +0200
User-Agent: KMail/1.9.5
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, vatsa@in.ibm.com, paulmck@us.ibm.com, pavel@ucw.cz
References: <20070419120131.GB13435@in.ibm.com> <20070420110520.GB11290@in.ibm.com> <20070420212057.GB820@tv-sign.ru>
In-Reply-To: <20070420212057.GB820@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704202345.23823.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 20 April 2007 23:20, Oleg Nesterov wrote:
> On 04/20, Gautham R Shenoy wrote:
> >
> > On Fri, Apr 20, 2007 at 10:54:36AM +0200, Rafael J. Wysocki wrote:
> > > 
> > > Hmm, can't we do something like this instead:
> > > 
> > > ---
> > >  kernel/kthread.c |   10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > > 
> > > Index: linux-2.6.21-rc7/kernel/kthread.c
> > > ===================================================================
> > > --- linux-2.6.21-rc7.orig/kernel/kthread.c
> > > +++ linux-2.6.21-rc7/kernel/kthread.c
> > > @@ -13,6 +13,7 @@
> > >  #include <linux/file.h>
> > >  #include <linux/module.h>
> > >  #include <linux/mutex.h>
> > > +#include <linux/freezer.h>
> > >  #include <asm/semaphore.h>
> > > 
> > >  /*
> > > @@ -232,6 +233,15 @@ int kthread_stop(struct task_struct *k)
> > > 
> > >  	/* Now set kthread_should_stop() to true, and wake it up. */
> > >  	kthread_stop_info.k = k;
> > > +	if (!(current->flags & PF_NOFREEZE)) {
> > > +		/* If we are freezable, the freezer will wait for us */
> > > +		task_lock(k);
> > > +		k->flags |= PF_NOFREEZE;
> > > +		if (frozen(k))
> > > +			k->flags &= ~PF_FROZEN;
> > > +
> > > +		task_unlock(k);
> > > +	}
> > 
> > Yes, we can do this for now since the tasks have only two freeze states,
> > namely Freezeable and Non Freezeable. 
> 
> No, we can't change k->flags, k owns its ->flags, and it is not atomic.

Yes, but if we move PF_FROZEN to a separate field in task_struct with
appropriate locking, then it won't be a problem any more IMO.
 
> Rafael, may I suggest you to document task_lock() in thaw_process() ? This
> looks really confusing, as if task_lock() protects "p->flags &= ~PF_FROZEN".
> 
> Actually, task_lock() is needed to prevent the race with refrigerator()
> when the freezing fails, but this is not obvious.

Sure, I will.

Greetings,
Rafael
