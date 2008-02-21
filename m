Return-Path: <linux-kernel-owner+w=401wt.eu-S1765277AbYBUMCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765277AbYBUMCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 07:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbYBUMCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 07:02:41 -0500
Received: from mail.gmx.net ([213.165.64.20]:32845 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752966AbYBUMCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 07:02:40 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/8tfhloD387XMmbKE6fbtTVzSbM8O0aJjyUVPVna
	LoD6cyWHCiOVfX
Subject: Re: Make yield_task_fair more efficient
From: Mike Galbraith <efault@gmx.de>
To: balbir@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <47BD44FF.7070104@linux.vnet.ibm.com>
References: <20080221053321.GA26918@balbir.in.ibm.com>
	 <20080221060427.GA9159@elte.hu> <47BD1F75.5030506@linux.vnet.ibm.com>
	 <20080221070733.GA13694@elte.hu> <47BD2A99.3010608@linux.vnet.ibm.com>
	 <1203583439.6243.119.camel@lappy> <47BD3B56.3090404@linux.vnet.ibm.com>
	 <20080221090430.GA20055@elte.hu>  <47BD44FF.7070104@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 13:02:34 +0100
Message-Id: <1203595354.19641.5.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2008-02-21 at 15:01 +0530, Balbir Singh wrote:
> Ingo Molnar wrote:
> > * Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> >> If you insist that sched_yield() is bad, I might agree, but how does 
> >> my patch make things worse. [...]
> > 
> > it puts new instructions into the hotpath.
> > 
> >> [...] In my benchmarks, it has helped the sched_yield case, why is 
> >> that bad? [...]
> > 
> > I had the same cache for the rightmost task in earlier CFS (it's a 
> > really obvious thing) but removed it. It wasnt a bad idea, but it hurt 
> > the fastpath hence i removed it. Algorithms and implementations are a 
> > constant balancing act.
> 
> This is more convincing, was the code ever in git? How did you measure the
> overhead?

Counting enqueue/dequeue cycles on my 3GHz P4/HT running a 60 seconds
netperf test that does ~85k/s context switches  shows:

sched_cycles: 7198444348 unpatched
vs
sched_cycles: 8574036268 patched

	-Mike

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e217d18..a71edfe 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1262,6 +1262,7 @@ struct task_struct {
 	int latency_record_count;
 	struct latency_record latency_record[LT_SAVECOUNT];
 #endif
+	unsigned long long sched_cycles;
 };
 
 /*
diff --git a/kernel/exit.c b/kernel/exit.c
index 506a957..c5c3d5e 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -174,6 +174,8 @@ repeat:
 	}
 
 	write_unlock_irq(&tasklist_lock);
+	if (!strcmp("netperf", p->comm) || !strcmp("netserver", p->comm))
+		printk(KERN_WARNING "%s:%d sched_cycles: %Ld\n", p->comm, p->pid, p->sched_cycles);
 	release_thread(p);
 	call_rcu(&p->rcu, delayed_put_task_struct);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index f28f19e..d7c1b0b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1301,15 +1301,25 @@ static void set_load_weight(struct task_struct *p)
 
 static void enqueue_task(struct rq *rq, struct task_struct *p, int wakeup)
 {
+	unsigned long long then, now;
+
+	rdtscll(then);
 	sched_info_queued(p);
 	p->sched_class->enqueue_task(rq, p, wakeup);
 	p->se.on_rq = 1;
+	rdtscll(now);
+	p->sched_cycles += now - then;
 }
 
 static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
 {
+	unsigned long long then, now;
+
+	rdtscll(then);
 	p->sched_class->dequeue_task(rq, p, sleep);
 	p->se.on_rq = 0;
+	rdtscll(now);
+	p->sched_cycles += now - then;
 }
 
 /*
@@ -2009,6 +2019,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 	update_rq_clock(rq);
 
 	p->prio = effective_prio(p);
+	p->sched_cycles = 0;
 
 	if (!p->sched_class->task_new || !current->se.on_rq) {
 		activate_task(rq, p, 0);


