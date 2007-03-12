Return-Path: <linux-kernel-owner+w=401wt.eu-S965618AbXCLLQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965618AbXCLLQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 07:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965639AbXCLLQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 07:16:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43154 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965618AbXCLLQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 07:16:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] kthread_should_stop_check_freeze (was: Re: [PATCH -mm 3/7] Freezer: Remove PF_NOFREEZE from rcutorture thread)
Date: Mon, 12 Mar 2007 12:19:11 +0100
User-Agent: KMail/1.9.5
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Anton Blanchard <anton@samba.org>,
       Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
References: <200702260800.49603.rjw@sisk.pl> <20070312043854.GA4124@linux.vnet.ibm.com> <20070312081459.GI5242@elf.ucw.cz>
In-Reply-To: <20070312081459.GI5242@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703121219.12072.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday, 12 March 2007 09:14, Pavel Machek wrote:
> Hi!
> 
> > > > I personally think we should do the opposite, add kthread_should_stop_check_freeze()
> > > > or something. kthread_should_stop() is like signal_pending(), we can use
> > > > it under spin_lock (and it is probably used this way by some out-of-tree
> > > > driver). The new helper is obviously "might_sleep()".
> > > 
> > > Something like this, perhaps:
> > 
> > Looks good to me!  The other kthread_should_stop() calls in
> > rcutorture.c should also become kthread_should_top_check_freeze().
> > 
> > Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > >  include/linux/kthread.h |    1 +
> > >  kernel/kthread.c        |   16 ++++++++++++++++
> > >  kernel/rcutorture.c     |    5 ++---
> > >  3 files changed, 19 insertions(+), 3 deletions(-)
> > > 
> > > Index: linux-2.6.21-rc3-mm2/kernel/kthread.c
> > > ===================================================================
> > > --- linux-2.6.21-rc3-mm2.orig/kernel/kthread.c	2007-03-08 21:58:48.000000000 +0100
> > > +++ linux-2.6.21-rc3-mm2/kernel/kthread.c	2007-03-11 18:32:59.000000000 +0100
> > > @@ -13,6 +13,7 @@
> > >  #include <linux/file.h>
> > >  #include <linux/module.h>
> > >  #include <linux/mutex.h>
> > > +#include <linux/freezer.h>
> > >  #include <asm/semaphore.h>
> > > 
> > >  /*
> > > @@ -60,6 +61,21 @@ int kthread_should_stop(void)
> > >  }
> > >  EXPORT_SYMBOL(kthread_should_stop);
> > > 
> > > +/**
> > > + * kthread_should_stop_check_freeze - check if the thread should return now and
> > > + * if not, check if there is a freezing request pending for it.
> > > + */
> > > +int kthread_should_stop_check_freeze(void)
> > > +{
> > > +	might_sleep();
> > > +	if (kthread_stop_info.k == current)
> > > +		return 1;
> > > +
> > > +	try_to_freeze();
> > > +	return 0;
> > > +}
> 
> Can we get better name for this function?

Well, I took the name from the Oleg's message.  Can you please suggest
something?

> Why is it useful?

Because we want to avoid repeating

while (!kthread_should_stop()) {
	try_to_freeze();
	...
}

in many places?

> Caller can do "try_to_freeze()" as well, no? 

Sure, it just eliminates one line of code.

> > >  		}
> > >  		rcu_torture_current_version++;
> > >  		oldbatch = cur_ops->completed();
> > > -		try_to_freeze();
> > > -	} while (!kthread_should_stop() && !fullstop);
> > > +	} while (!kthread_should_stop_check_freeze() && !fullstop);
> > >  	VERBOSE_PRINTK_STRING("rcu_torture_writer task stopping");
> > > -	while (!kthread_should_stop())
> > > +	while (!kthread_should_stop_check_freeze())
> > >  		schedule_timeout_uninterruptible(1);
> > >  	return 0;
> 
> Aha, I see, here it probably becomes handy.
> 
> Actually, no... I do not see it. Why don't you simply move first
> try_to_freeze() to beggining of the loop and do
> 
> -   while (!kthread_should_stop()) {
>              schedule_timeout_uninterruptible(1);
> 	     try_to_freeze()
> }

Yes, but then the second loop will contain one more line of code.

Greetings,
Rafael
