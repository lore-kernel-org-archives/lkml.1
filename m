Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbZLCOl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbZLCOl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 09:41:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbZLCOlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 09:41:55 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43516 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbZLCOlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 09:41:55 -0500
Date: Thu, 3 Dec 2009 06:41:44 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 3/4] rcu: add expedited grace-period
	support for preemptible RCU
Message-ID: <20091203144144.GA6822@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091202200955.GA12950@linux.vnet.ibm.com> <4B178440.5020701@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B178440.5020701@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 05:26:24PM +0800, Lai Jiangshan wrote:
> Paul E. McKenney wrote:
> > From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Implement an synchronize_rcu_expedited() for preemptible RCU that actually
> > is expedited.  This uses synchronize_sched_expedited() to force all
> > threads currently running in a preemptible-RCU read-side critical section
> > onto the appropriate ->blocked_tasks[] list, then takes a snapshot of
> > all of these lists and waits for them to drain.
> > 
> 
> > 3.	Add an implementation of synchronize_rcu_expedited() that
> > 	actually expedites preemptible-RCU grace periods.
> 
> It's very nice.

I am glad you like it!

> But I don't understand all things.
> 
> 1) Why it can be speeded up (in theory)?
> synchronize_sched_expedited() does speed up, it is due to
> migration_threads are the most highest priority threads.
> 
> But for synchronize_rcu_expedited(), some preempted tasks in ->blocked_tasks[]
> may be waiting at runqueue for long long time because some other
> higher priority threads comes.
> 
> simply comparison:
> synchronize_sched_expedited()
> ==> wake_up_process(rq->migration_thread) to force schedule on cpus.
> 	which forces read-sides notify the end earlier,
> 	or we can say "it forces read-sides run to end faster"
> 
> synchronize_rcu_expedited()
> ==> Nothing to force preempted read-site run to end faster.

You are quite right, and this is one reason why one of the items on my
todo list is "RCU priority boosting".  I am currently doing some work
to prepare for this by simplifying force_quiescent_state().  The general
idea will be to traverse the ->blocked_tasks[] lists to raise priorities
if the grace period goes too long.

That said, the purpose of synchronize_rcu_expedited() is not to provide
real-time response, but rather to provide short -average- grace-period
durations.  In the common case, RCU read-side critical sections do not
get preempted to begin with, so in the common case, this implementation
of synchronize_sched_expedited() should provide short average grace-period
durations.

> 2) Why we introduce a API which no one use it.
> I remember that Net guys request a expedited synchronize_rcu().
> but currently there is still no one use it.

There have been several requests for it over the years, so I feel
justified providing it.  If it is still unused some years hence, it
is really easy to remove it, but it is really hard to provide it on a
moment's notice.

> Beware my thinking may be wrong!

That would apply to both of us!  ;-)

							Thanx, Paul
