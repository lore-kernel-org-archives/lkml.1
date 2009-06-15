Return-Path: <linux-kernel-owner+w=401wt.eu-S1751245AbZFOEE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245AbZFOEE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 00:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750743AbZFOEEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 00:04:20 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:39601 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbZFOEET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 00:04:19 -0400
Date: Mon, 15 Jun 2009 09:34:09 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, rusty@rustcorp.com.au,
       mingo@elte.hu, linux-kernel@vger.kernel.org, peterz@infradead.org,
       oleg@redhat.com, dipankar@in.ibm.com
Subject: Re: [PATCH -mm resend] cpuhotplug: introduce try_get_online_cpus()
	take 3
Message-ID: <20090615040409.GA30979@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20090605153714.GB6778@linux.vnet.ibm.com> <20090608041934.GB17979@in.ibm.com> <20090608142520.GA6961@linux.vnet.ibm.com> <4A2E506D.9090107@cn.fujitsu.com> <20090609123438.b936137e.akpm@linux-foundation.org> <20090609234757.GH16117@linux.vnet.ibm.com> <4A2F08D6.6060309@cn.fujitsu.com> <20090609184238.06b38c3e.akpm@linux-foundation.org> <4A30C346.8070406@cn.fujitsu.com> <20090611185014.GJ6727@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611185014.GJ6727@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 11:50:15AM -0700, Paul E. McKenney wrote:
> On Thu, Jun 11, 2009 at 04:41:42PM +0800, Lai Jiangshan wrote:
> > Andrew Morton wrote:
> > > 
> > > I still think we should really avoid having to do this.  trylocks are
> > > nasty things.
> > > 
> > > Looking at the above, one would think that a correct fix would be to fix
> > > the bug in "thread 2": take the locks in the correct order?  As
> > > try_get_online_cpus() doesn't actually have any callers, it's hard to
> > > take that thought any further.
> > 
> > Sometimes, we can not reorder the locks' order.
> > try_get_online_cpus() is really needless when no one uses it.
> > 
> > Paul's expedited RCU V7 may need it:
> > http://lkml.org/lkml/2009/5/22/332
> > 
> > So this patch can be omitted when Paul does not use it.
> > It's totally OK for me.
> 
> Although my patch does not need it in and of itself, if someone were
> to hold a kernel mutex across synchronize_sched_expedited(), and also
> acquire that same kernel mutex in a hotplug notifier, the deadlock that
> Lai calls out would occur.
> 
> Even if no one uses synchronize_sched_expedited() in this manner, I feel
> that it is good to explore the possibility of dealing with it.  As
> Andrew Morton pointed out, CPU-hotplug locking is touchy, so on-the-fly
> fixes are to be avoided if possible.

Agreed. Though I like the atomic refcount version of
get_online_cpus()/put_online_cpus() that Lai has proposed.

Anyways, to quote the need for try_get_online_cpus() when it was
proposed last year, it was to be used in worker thread context.

Because in those times we could not do a get_online_cpus() from
the worker thread context fearing the follwing deadlock during
a cpu-hotplug.

Thread 1:(cpu_offline)            |    Thread 2 ( worker_thread)
-----------------------------------------------------------------------
cpu_hotplug_begin();		  |
.				  |
.				  |    get_online_cpus(); /*Blocks */
.				  |
.				  |
CPU_DEAD:			  |
  workqueue_cpu_callback();	  |
     cleanup_workqueue_thread()	  |
     /* Waits for worker thread
      * to finish.
      * Hence a deadlock.
      */

This was fixed by introducing the CPU_POST_DEAD event, the notification

> 
> 							Thanx, Paul

-- 
Thanks and Regards
gautham
