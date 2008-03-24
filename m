Return-Path: <linux-kernel-owner+w=401wt.eu-S1760231AbYCXOAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760231AbYCXOAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 10:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757449AbYCXN74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 09:59:56 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:40313 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591AbYCXN7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 09:59:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhUHADZR50dMQWoK/2dsb2JhbACBW6VA
Date: Mon, 24 Mar 2008 09:59:53 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       hch@infradead.org, mmlnx@us.ibm.com, dipankar@in.ibm.com,
       dsmith@redhat.com, rostedt@goodmis.org, adrian.bunk@movial.fi,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, rusty@au1.ibm.com, jkenisto@linux.vnet.ibm.com,
       oleg@tv-sign.ru
Subject: Re: [PATCH,RFC] Add call_rcu_sched()
Message-ID: <20080324135952.GA14908@Krystal>
References: <20080321143615.GA936@linux.vnet.ibm.com> <20080321224026.GA10169@linux.vnet.ibm.com> <20080324050652.GA4906@Krystal> <20080324054630.GE4555@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080324054630.GE4555@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:50:03 up 24 days, 10:01,  4 users,  load average: 0.50, 0.79,
	0.75
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Mon, Mar 24, 2008 at 01:06:53AM -0400, Mathieu Desnoyers wrote:
> > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
[...]
> > > o	Interaction of this patch with CPU hotplug should be viewed
> > > 	with great suspicion.
> > 
> > Fix call_rcu_sched wait
> 
> There are definitely some problems here...  Though I am seeing them
> in the sched_setaffinity() call rather than in the wait processing.
> 

Sorry for the misleading line : "Fix call_rcu_sched wait" was the title
of the patch addressing the rcu_sched_grace:924 blocked ... problem below.

> > > o If there are no synchronize_sched() calls for more than two
> > >   minutes, one can see messages of the form "INFO: task
> > >   rcu_sched_grace:924 blocked for more than 120 seconds."
> > >   Any thoughts on how to avoid this message?  Should I be using
> > >   something other than __wait_event() and wake_up(), which sleep
> > >   uninterruptibly, thus triggering this message?
> > > 
> > 
[...]
> > Could you use __wait_event_interruptible and wake_up_interruptible
> > instead ? softlockup.c only seems to complain when uninterruptible tasks
> > are not scheduled for 2 minutes. I guess that when we receive a signal
> > we could simply go through another loop.
> 
> I will give these a try.
> 
> > +		ret = 0;
> > +		__wait_event_interruptible(rcu_ctrlblk.sched_wq,
> > +			     rcu_ctrlblk.sched_sleep != rcu_sched_sleeping,
> > +			     ret);
> 
> Don't we have to do something here to clear signal state if we are
> ever to block again?  Maybe something like the following?
> 
> 		flush_signals(current):
> 
> Or am I missing something?
> 

Good point, I would add
if (ret < 0)
  flush_signals(current);

[...]
> > 
> > That's always good :)
> 
> Fixing the bug or losing track?  ;-)
> 

Fixing it of course :)

New version of the fix-call-rcu-sched-wait.patch file below.

Mathieu


Fix call_rcu_sched wait

> o If there are no synchronize_sched() calls for more than two
>   minutes, one can see messages of the form "INFO: task
>   rcu_sched_grace:924 blocked for more than 120 seconds."
>   Any thoughts on how to avoid this message?  Should I be using
>   something other than __wait_event() and wake_up(), which sleep
>   uninterruptibly, thus triggering this message?
> 

Could you use __wait_event_interruptible and wake_up_interruptible
instead ? softlockup.c only seems to complain when uninterruptible tasks
are not scheduled for 2 minutes. I guess that when we receive a signal
we could simply go through another loop.

- Changelog
Reset signal state upon wakeup.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 kernel/rcupreempt.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/kernel/rcupreempt.c
===================================================================
--- linux-2.6-lttng.orig/kernel/rcupreempt.c	2008-03-24 00:26:27.000000000 -0400
+++ linux-2.6-lttng/kernel/rcupreempt.c	2008-03-24 09:57:28.000000000 -0400
@@ -1074,7 +1074,7 @@ void call_rcu_sched(struct rcu_head *hea
 		rcu_ctrlblk.sched_sleep = rcu_sched_not_sleeping;
 		spin_unlock_irqrestore(&rcu_ctrlblk.schedlock, flags);
 		if (wake_gp)
-			wake_up(&rcu_ctrlblk.sched_wq);
+			wake_up_interruptible(&rcu_ctrlblk.sched_wq);
 	}
 }
 EXPORT_SYMBOL_GPL(call_rcu_sched);
@@ -1097,6 +1097,7 @@ rcu_sched_grace_period(void *arg)
 	int couldsleep;		/* might sleep after current pass. */
 	int couldsleepnext = 0; /* might sleep after next pass. */
 	int cpu;
+	int ret;
 	long err;
 	unsigned long flags;
 	int needsoftirq;
@@ -1242,8 +1243,12 @@ retry:
 
 		rcu_ctrlblk.sched_sleep = rcu_sched_sleeping;
 		spin_unlock_irqrestore(&rcu_ctrlblk.schedlock, flags);
-		__wait_event(rcu_ctrlblk.sched_wq,
-			     rcu_ctrlblk.sched_sleep != rcu_sched_sleeping);
+		ret = 0;
+		__wait_event_interruptible(rcu_ctrlblk.sched_wq,
+			     rcu_ctrlblk.sched_sleep != rcu_sched_sleeping,
+			     ret);
+		if (ret < 0)
+			flush_signals(current);
 		couldsleepnext = 0;
 
 	} while (!kthread_should_stop());

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
