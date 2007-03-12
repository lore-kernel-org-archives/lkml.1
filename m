Return-Path: <linux-kernel-owner+w=401wt.eu-S964851AbXCLIQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964851AbXCLIQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 04:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965289AbXCLIQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 04:16:00 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56990 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964851AbXCLIP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 04:15:59 -0400
Date: Mon, 12 Mar 2007 09:14:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Oleg Nesterov <oleg@tv-sign.ru>,
       Anton Blanchard <anton@samba.org>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH] kthread_should_stop_check_freeze (was: Re: [PATCH -mm 3/7] Freezer: Remove PF_NOFREEZE from rcutorture thread)
Message-ID: <20070312081459.GI5242@elf.ucw.cz>
References: <200702260800.49603.rjw@sisk.pl> <20070303005843.GG2373@linux.vnet.ibm.com> <20070303173240.GA249@tv-sign.ru> <200703111849.09966.rjw@sisk.pl> <20070312043854.GA4124@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312043854.GA4124@linux.vnet.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > I personally think we should do the opposite, add kthread_should_stop_check_freeze()
> > > or something. kthread_should_stop() is like signal_pending(), we can use
> > > it under spin_lock (and it is probably used this way by some out-of-tree
> > > driver). The new helper is obviously "might_sleep()".
> > 
> > Something like this, perhaps:
> 
> Looks good to me!  The other kthread_should_stop() calls in
> rcutorture.c should also become kthread_should_top_check_freeze().
> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> >  include/linux/kthread.h |    1 +
> >  kernel/kthread.c        |   16 ++++++++++++++++
> >  kernel/rcutorture.c     |    5 ++---
> >  3 files changed, 19 insertions(+), 3 deletions(-)
> > 
> > Index: linux-2.6.21-rc3-mm2/kernel/kthread.c
> > ===================================================================
> > --- linux-2.6.21-rc3-mm2.orig/kernel/kthread.c	2007-03-08 21:58:48.000000000 +0100
> > +++ linux-2.6.21-rc3-mm2/kernel/kthread.c	2007-03-11 18:32:59.000000000 +0100
> > @@ -13,6 +13,7 @@
> >  #include <linux/file.h>
> >  #include <linux/module.h>
> >  #include <linux/mutex.h>
> > +#include <linux/freezer.h>
> >  #include <asm/semaphore.h>
> > 
> >  /*
> > @@ -60,6 +61,21 @@ int kthread_should_stop(void)
> >  }
> >  EXPORT_SYMBOL(kthread_should_stop);
> > 
> > +/**
> > + * kthread_should_stop_check_freeze - check if the thread should return now and
> > + * if not, check if there is a freezing request pending for it.
> > + */
> > +int kthread_should_stop_check_freeze(void)
> > +{
> > +	might_sleep();
> > +	if (kthread_stop_info.k == current)
> > +		return 1;
> > +
> > +	try_to_freeze();
> > +	return 0;
> > +}

Can we get better name for this function?

Why is it useful? Caller can do "try_to_freeze()" as well, no?

> >  		}
> >  		rcu_torture_current_version++;
> >  		oldbatch = cur_ops->completed();
> > -		try_to_freeze();
> > -	} while (!kthread_should_stop() && !fullstop);
> > +	} while (!kthread_should_stop_check_freeze() && !fullstop);
> >  	VERBOSE_PRINTK_STRING("rcu_torture_writer task stopping");
> > -	while (!kthread_should_stop())
> > +	while (!kthread_should_stop_check_freeze())
> >  		schedule_timeout_uninterruptible(1);
> >  	return 0;

Aha, I see, here it probably becomes handy.

Actually, no... I do not see it. Why don't you simply move first
try_to_freeze() to beggining of the loop and do

-   while (!kthread_should_stop()) {
             schedule_timeout_uninterruptible(1);
	     try_to_freeze()
}
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
