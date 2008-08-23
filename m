Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbYHWBgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbYHWBgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 21:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbYHWBgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 21:36:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38946 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbYHWBgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 21:36:22 -0400
Date: Fri, 22 Aug 2008 21:36:21 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: John Kacur <jkacur@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.26.3-rt3
In-Reply-To: <alpine.DEB.1.10.0808222123370.5290@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0808222134310.5686@gandalf.stny.rr.com>
References: <1219441175.22710.22.camel@localhost.localdomain> <520f0cf10808221639k5c58dcc1p36e85f4da8f025d1@mail.gmail.com> <alpine.DEB.1.10.0808222123370.5290@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 22 Aug 2008, Steven Rostedt wrote:

> 
> 
> On Sat, 23 Aug 2008, John Kacur wrote:
> > 
> > One more patch that was missed - it was discussed here
> > http://marc.info/?l=linux-rt-users&m=121846031913931&w=2
> > 
> > I am resending it, please consider for -rt4.
> > Without it I continue to get the following type of message.
> > 
> 
> Actually this was left out intentionally. The quick fix would be the one 
> that Gregory Haskins suggested about not reporting when the task is bound 
> to one CPU. This bothers me a little, but is probably OK for now. A task 
> can still migrate from one cpu to another by the user, and this can cause 
> havic if a smp_processor_id is used.
> 
> I needed to examine this a bit closer before coming up with a proper fix.


This patch below should be sufficient. I just changed your local_irqs_save 
to preempt_disabled: I have this queued for -rt4, but that is where I also 
plan on adding the latest ftrace updates so it may take a bit to get it 
out.

-- Steve


=======
From: Steven Rostedt <srostedt@redhat.com>
Subject: suppress warning of smp_processor_id use.

John Kacur pointed out that the get_cpu_var used in net/sched/sch_generic.c
would trigger warnings. This was happing on a statistic variable and
by a softirq which is bound to a single thread.

John sent a patch that used local_irq_save which is a little bit of
overkill. This version uses preempt disable, but we still need to create
a preempt_disable_rt API that is only activated when PREEMPT_RT is configured.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 net/sched/sch_generic.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.26.3-rt3/net/sched/sch_generic.c
===================================================================
--- linux-2.6.26.3-rt3.orig/net/sched/sch_generic.c	2008-08-22 21:28:50.000000000 -0400
+++ linux-2.6.26.3-rt3/net/sched/sch_generic.c	2008-08-22 21:29:38.000000000 -0400
@@ -112,7 +112,9 @@ static inline int handle_dev_cpu_collisi
 		 * Another cpu is holding lock, requeue & delay xmits for
 		 * some time.
 		 */
+		preempt_disable(); /* FIXME: we need an _rt version of this */
 		__get_cpu_var(netdev_rx_stat).cpu_collision++;
+		preempt_enable();
 		ret = dev_requeue_skb(skb, dev, q);
 	}
 
