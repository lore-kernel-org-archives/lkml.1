Return-Path: <linux-kernel-owner+w=401wt.eu-S1030693AbXCCRdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030693AbXCCRdt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 12:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030695AbXCCRdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 12:33:49 -0500
Received: from mail.screens.ru ([213.234.233.54]:56524 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030693AbXCCRds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 12:33:48 -0500
Date: Sat, 3 Mar 2007 20:32:40 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Anton Blanchard <anton@samba.org>,
       Andrew Morton <akpm@osdl.org>, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH -mm 3/7] Freezer: Remove PF_NOFREEZE from rcutorture thread
Message-ID: <20070303173240.GA249@tv-sign.ru>
References: <200702260800.49603.rjw@sisk.pl> <200703011609.43804.rjw@sisk.pl> <20070301193826.GA14587@kryten> <200703012054.26940.rjw@sisk.pl> <20070302213549.GC2373@linux.vnet.ibm.com> <20070302233337.GA267@tv-sign.ru> <20070303005843.GG2373@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070303005843.GG2373@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02, Paul E. McKenney wrote:
>
> On Sat, Mar 03, 2007 at 02:33:37AM +0300, Oleg Nesterov wrote:
> > On 03/02, Paul E. McKenney wrote:
> > >
> > > One way to embed try_to_freeze() into kthread_should_stop() might be
> > > as follows:
> > > 
> > > 	int kthread_should_stop(void)
> > > 	{
> > > 		if (kthread_stop_info.k == current)
> > > 			return 1;
> > > 		try_to_freeze();
> > > 		return 0;
> > > 	}
> > 
> > I think this is dangerous. For example, worker_thread() will probably
> > need some special actions after return from refrigerator. Also, a kernel
> > thread may check kthread_should_stop() in the place where try_to_freeze()
> > is not safe.
> > 
> > Perhaps we should introduce a new helper which does this.
> 
> Good point -- the return value from try_to_freeze() is lost if one uses
> the above approach.  About one third of the calls to try_to_freeze()
> in 2.6.20 pay attention to the return value.
> 
> One approach would be to have a kthread_should_stop_nofreeze() for those
> cases, and let the default be to try to freeze.

I personally think we should do the opposite, add kthread_should_stop_check_freeze()
or something. kthread_should_stop() is like signal_pending(), we can use
it under spin_lock (and it is probably used this way by some out-of-tree
driver). The new helper is obviously "might_sleep()".

Oleg.

