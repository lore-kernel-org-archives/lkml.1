Return-Path: <linux-kernel-owner+w=401wt.eu-S1752991AbXCMF3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbXCMF3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 01:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbXCMF3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 01:29:51 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:44523 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbXCMF3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 01:29:49 -0400
Date: Tue, 13 Mar 2007 10:57:16 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Anton Blanchard <anton@samba.org>, Andrew Morton <akpm@osdl.org>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [PATCH] kthread_should_stop_check_freeze (was: Re: [PATCH -mm 3/7] Freezer: Remove PF_NOFREEZE from rcutorture thread)
Message-ID: <20070313052716.GA11982@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <200702260800.49603.rjw@sisk.pl> <20070303005843.GG2373@linux.vnet.ibm.com> <20070303173240.GA249@tv-sign.ru> <200703111849.09966.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703111849.09966.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2007 at 06:49:08PM +0100, Rafael J. Wysocki wrote:
> On Saturday, 3 March 2007 18:32, Oleg Nesterov wrote:
> > On 03/02, Paul E. McKenney wrote:
> > >
> > > On Sat, Mar 03, 2007 at 02:33:37AM +0300, Oleg Nesterov wrote:
> > > > On 03/02, Paul E. McKenney wrote:
> > > > >
> > > > > One way to embed try_to_freeze() into kthread_should_stop() might be
> > > > > as follows:
> > > > > 
> > > > > 	int kthread_should_stop(void)
> > > > > 	{
> > > > > 		if (kthread_stop_info.k == current)
> > > > > 			return 1;
> > > > > 		try_to_freeze();
> > > > > 		return 0;
> > > > > 	}
> > > > 
> > > > I think this is dangerous. For example, worker_thread() will probably
> > > > need some special actions after return from refrigerator. Also, a kernel
> > > > thread may check kthread_should_stop() in the place where try_to_freeze()
> > > > is not safe.
> > > > 
> > > > Perhaps we should introduce a new helper which does this.
> > > 
> > > Good point -- the return value from try_to_freeze() is lost if one uses
> > > the above approach.  About one third of the calls to try_to_freeze()
> > > in 2.6.20 pay attention to the return value.
> > > 
> > > One approach would be to have a kthread_should_stop_nofreeze() for those
> > > cases, and let the default be to try to freeze.
> > 
> > I personally think we should do the opposite, add kthread_should_stop_check_freeze()
> > or something. kthread_should_stop() is like signal_pending(), we can use
> > it under spin_lock (and it is probably used this way by some out-of-tree
> > driver). The new helper is obviously "might_sleep()".
> 
> Something like this, perhaps:
> 
>  include/linux/kthread.h |    1 +
>  kernel/kthread.c        |   16 ++++++++++++++++
>  kernel/rcutorture.c     |    5 ++---
>  3 files changed, 19 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6.21-rc3-mm2/kernel/kthread.c
> ===================================================================
> --- linux-2.6.21-rc3-mm2.orig/kernel/kthread.c	2007-03-08 21:58:48.000000000 +0100
> +++ linux-2.6.21-rc3-mm2/kernel/kthread.c	2007-03-11 18:32:59.000000000 +0100
> @@ -13,6 +13,7 @@
>  #include <linux/file.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>
> +#include <linux/freezer.h>
>  #include <asm/semaphore.h>
> 
>  /*
> @@ -60,6 +61,21 @@ int kthread_should_stop(void)
>  }
>  EXPORT_SYMBOL(kthread_should_stop);
> 
> +/**
> + * kthread_should_stop_check_freeze - check if the thread should return now and
> + * if not, check if there is a freezing request pending for it.
> + */
> +int kthread_should_stop_check_freeze(void)
> +{
> +	might_sleep();
> +	if (kthread_stop_info.k == current)
> +		return 1;
> +
> +	try_to_freeze();
> +	return 0;
> +}
> +EXPORT_SYMBOL(kthread_should_stop_check_freeze);

I would prefer to have try_to_freeze() followed by the
kthread_stop_info.k check. Something like

if (try_to_freeze())
	/*some barrier ensuring all writes are completed */

if (kthread_stop_info.k == current)
		return 1;
return 0;

This would be helpful in situations (atleast for cpu-hotplug)
where we want to stop a frozen thread immediately after thawing it.
Something like

CPU_DEAD:
thaw_process(p);
kthread_stop(p);
p = NULL;

Is there a problem with this line of thinking ?

thanks and regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
