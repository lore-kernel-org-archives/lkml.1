Return-Path: <linux-kernel-owner+w=401wt.eu-S1755702AbYHKQKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbYHKQKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbYHKQKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:10:00 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59016 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbYHKQJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:09:59 -0400
Date: Mon, 11 Aug 2008 09:09:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tglx@linutronix.de,
       marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org,
       davem@davemloft.net, rostedt@goodmis.org
Subject: Re: [PATCH] printk: robustify printk
Message-ID: <20080811160956.GA9069@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1218215454.8625.133.camel@twins> <alpine.LFD.1.10.0808081014240.3462@nehalem.linux-foundation.org> <1218217257.29098.2.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org> <1218219269.29098.5.camel@lappy.programming.kicks-ass.net> <20080808121428.646a8b3c.akpm@linux-foundation.org> <1218223269.29098.12.camel@lappy.programming.kicks-ass.net> <1218224829.29098.19.camel@lappy.programming.kicks-ass.net> <20080811104526.GA15186@elte.hu> <1218452640.10800.58.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218452640.10800.58.camel@twins>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 01:04:00PM +0200, Peter Zijlstra wrote:
> On Mon, 2008-08-11 at 12:45 +0200, Ingo Molnar wrote:
> > ( But that's for a separate cleanup patch i think. )
> > 
> > No strong feelings though. Peter, which one do you prefer?
> 
> I personally prefer this printk_tick() driven one over the RCU driven
> one because it doesn't trade deadlocks.

One way to break the deadlock within the RCU subsystem would be something
similar to the following untested (known not to compile) patch.  The
idea is that RCU detects that call_rcu() is being called from printk(), and
simply enqueues the callback in this case.  For this to really work, RCU
needs something exported from printk() to allow it to make this
decision.  I chose the static variable printk_cpu below just to present
the general idea.

Thoughts?

Buggy, but otherwise:

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcupreempt.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -urpNa -X dontdiff linux-2.6.27-rc1/kernel/rcupreempt.c linux-2.6.27-rc1-printk/kernel/rcupreempt.c
--- linux-2.6.27-rc1/kernel/rcupreempt.c	2008-07-30 08:48:17.000000000 -0700
+++ linux-2.6.27-rc1-printk/kernel/rcupreempt.c	2008-08-11 09:02:03.000000000 -0700
@@ -1118,17 +1118,22 @@ void call_rcu(struct rcu_head *head, voi
 {
 	unsigned long flags;
 	struct rcu_data *rdp;
+	int this_cpu = smp_processor_id();
 
 	head->func = func;
 	head->next = NULL;
 	local_irq_save(flags);
 	rdp = RCU_DATA_ME();
-	spin_lock(&rdp->lock);
-	__rcu_advance_callbacks(rdp);
+	if (this_cpu == printk_cpu) {
+		spin_lock(&rdp->lock);
+		__rcu_advance_callbacks(rdp);
+	}
 	*rdp->nexttail = head;
 	rdp->nexttail = &head->next;
 	RCU_TRACE_RDP(rcupreempt_trace_next_add, rdp);
-	spin_unlock_irqrestore(&rdp->lock, flags);
+	if (this_cpu == printk_cpu) {
+		spin_unlock_irqrestore(&rdp->lock, flags);
+	}
 }
 EXPORT_SYMBOL_GPL(call_rcu);
 
