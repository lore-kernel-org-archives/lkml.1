Return-Path: <linux-kernel-owner+w=401wt.eu-S1030307AbXCBVqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030307AbXCBVqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 16:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933374AbXCBVqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 16:46:17 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35689 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933368AbXCBVqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 16:46:16 -0500
Date: Fri, 2 Mar 2007 13:46:08 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andrew Morton <akpm@osdl.org>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Aneesh Kumar <aneesh.kumar@gmail.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [PATCH -mm 3/7] Freezer: Remove PF_NOFREEZE from rcutorture thread
Message-ID: <20070302214608.GD2373@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <200702260800.49603.rjw@sisk.pl> <200703011605.46692.rjw@sisk.pl> <200703011609.43804.rjw@sisk.pl> <20070302065729.GA22085@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302065729.GA22085@in.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 12:27:30PM +0530, Gautham R Shenoy wrote:
> > From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Remove PF_NOFREEZE from the rcutorture thread, adding a try_to_freeze() call as
> > required.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > Acked-by: Pavel Machek <pavel@ucw.cz>
> > ---
> >  kernel/rcutorture.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > Index: linux-2.6.20-mm2/kernel/rcutorture.c
> > ===================================================================
> > --- linux-2.6.20-mm2.orig/kernel/rcutorture.c	2007-02-25 12:07:15.000000000 +0100
> > +++ linux-2.6.20-mm2/kernel/rcutorture.c	2007-02-25 12:49:23.000000000 +0100
> > @@ -46,6 +46,7 @@
> >  #include <linux/byteorder/swabb.h>
> >  #include <linux/stat.h>
> >  #include <linux/srcu.h>
> > +#include <linux/freezer.h>
> > 
> >  MODULE_LICENSE("GPL");
> >  MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and "
> > @@ -585,7 +586,6 @@ rcu_torture_writer(void *arg)
> > 
> >  	VERBOSE_PRINTK_STRING("rcu_torture_writer task started");
> >  	set_user_nice(current, 19);
> > -	current->flags |= PF_NOFREEZE;
> > 
> >  	do {
> >  		schedule_timeout_uninterruptible(1);
> > @@ -607,6 +607,7 @@ rcu_torture_writer(void *arg)
> >  		}
> >  		rcu_torture_current_version++;
> >  		oldbatch = cur_ops->completed();
> > +		try_to_freeze();
> >  	} while (!kthread_should_stop() && !fullstop);
> >  	VERBOSE_PRINTK_STRING("rcu_torture_writer task stopping");
> >  	while (!kthread_should_stop())
> 
> Paul, 
> Any reasons for not try_to_freeze()'ing the fakewriter and the reader
> threads?? (Ok, I admit, I haven't looked into the code for the reason
> which might be obvious.)

None that I know of -- though I do like Anton's idea of burying a
try_to_freeze() in kthread_should_stop(), which would get rid of all
try_to_freeze() calls in rcutorture, and many other places as well.

						Thanx, Paul
