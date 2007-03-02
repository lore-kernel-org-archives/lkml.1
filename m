Return-Path: <linux-kernel-owner+w=401wt.eu-S1030181AbXCBVf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030181AbXCBVf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 16:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030185AbXCBVf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 16:35:56 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:56234 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030181AbXCBVfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 16:35:55 -0500
Date: Fri, 2 Mar 2007 13:35:49 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Anton Blanchard <anton@samba.org>, Andrew Morton <akpm@osdl.org>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Aneesh Kumar <aneesh.kumar@gmail.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH -mm 3/7] Freezer: Remove PF_NOFREEZE from rcutorture thread
Message-ID: <20070302213549.GC2373@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <200702260800.49603.rjw@sisk.pl> <200703011609.43804.rjw@sisk.pl> <20070301193826.GA14587@kryten> <200703012054.26940.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703012054.26940.rjw@sisk.pl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 08:54:25PM +0100, Rafael J. Wysocki wrote:
> On Thursday, 1 March 2007 20:38, Anton Blanchard wrote:
> > 
> > Hi,
> > 
> > > Remove PF_NOFREEZE from the rcutorture thread, adding a
> > > try_to_freeze() call as required.
> > 
> > ...
> > 
> > > @@ -607,6 +607,7 @@ rcu_torture_writer(void *arg)
> > >  		}
> > >  		rcu_torture_current_version++;
> > >  		oldbatch = cur_ops->completed();
> > > +		try_to_freeze();
> > >  	} while (!kthread_should_stop() && !fullstop);
> > >  	VERBOSE_PRINTK_STRING("rcu_torture_writer task stopping");
> > >  	while (!kthread_should_stop())
> > 
> > I wonder if it makes sense to embed try_to_freeze() into the kthread
> > API somewhere. Short of that we should document the try_to_freeze()
> > requirement in the kthread documentation... Unfortunately I cant find
> > any kthread docs in Documentation/ :)
> 
> Well, the patch is from Paul, so I think he'll be able to comment. :-)

We certainly either need to embed try_to_freeze() into kthread_should_stop()
or add back the rcu_torture_fakewriter(), and rcu_torture_reader()
components of this patch.  ;-)

One way to embed try_to_freeze() into kthread_should_stop() might be
as follows:

	int kthread_should_stop(void)
	{
		if (kthread_stop_info.k == current)
			return 1;
		try_to_freeze();
		return 0;
	}

Does this seem reasonable?  It certainly would cut down some of the
code required for freezing -- and reduce the potential for bugs.

							Thanx, Paul
