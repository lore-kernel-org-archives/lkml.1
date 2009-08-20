Return-Path: <linux-kernel-owner+w=401wt.eu-S1752385AbZHTEV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbZHTEV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 00:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbZHTEV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 00:21:26 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41309 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbZHTEV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 00:21:26 -0400
Date: Wed, 19 Aug 2009 21:21:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       hugh.dickins@tiscali.co.uk, benh@kernel.crashing.org
Subject: Re: [PATCH -tip/core/rcu 3/6] Simplify RCU CPU-hotplug notification
Message-ID: <20090820042124.GC6847@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090815165153.GA8886@linux.vnet.ibm.com> <4A8CCAE4.4030707@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8CCAE4.4030707@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 12:02:44PM +0800, Lai Jiangshan wrote:
> Paul E. McKenney wrote:
> > From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Use the new cpu_notifier() API to simplify RCU's CPU-hotplug
> > notifiers, collapsing down to a single such notifier.  This
> > makes it trivial to provide the notifier-ordering guarantee
> > that rcu_barrier() depends on.  Also remove redundant
> > open_softirq() calls from Hierarchical RCU notifier.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcupdate.c   |   16 +++++++++++++++-
> >  kernel/rcupreempt.c |   25 ++-----------------------
> >  kernel/rcutree.c    |   17 +++++------------
> >  3 files changed, 22 insertions(+), 36 deletions(-)
> > 
> > diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> > index eae29c2..8df1156 100644
> > --- a/kernel/rcupdate.c
> > +++ b/kernel/rcupdate.c
> > @@ -217,9 +217,13 @@ static void rcu_migrate_callback(struct rcu_head *notused)
> >  		wake_up(&rcu_migrate_wq);
> >  }
> >  
> > +extern int rcu_cpu_notify(struct notifier_block *self,
> > +			  unsigned long action, void *hcpu);
> > +
> >  static int __cpuinit rcu_barrier_cpu_hotplug(struct notifier_block *self,
> >  		unsigned long action, void *hcpu)
> >  {
> > +	rcu_cpu_notify(self, action, hcpu);
> >  	if (action == CPU_DYING) {
> >  		/*
> >  		 * preempt_disable() in on_each_cpu() prevents stop_machine(),
> > @@ -244,8 +248,18 @@ static int __cpuinit rcu_barrier_cpu_hotplug(struct notifier_block *self,
> >  
> >  void __init rcu_init(void)
> >  {
> > +	int i;
> > +
> >  	__rcu_init();
> > -	hotcpu_notifier(rcu_barrier_cpu_hotplug, 0);
> > +	cpu_notifier(rcu_barrier_cpu_hotplug, 0);
> > +
> > +	/*
> > +	 * We don't need protection against CPU-hotplug here because
> > +	 * this is called early in boot, before either interrupts
> > +	 * or the scheduler are operational.
> > +	 */
> > +	for_each_online_cpu(i)
> > +		rcu_barrier_cpu_hotplug(NULL, CPU_UP_PREPARE, (void *)(long)i);
> 
> I think,
> There is only one cpu in cpu online map at early boot time,
> it is the current cpu.

Indeed there is.  But I wouldn't put it past the fast-boot guys to
parallelize early boot.  ;-)

							Thanx, Paul
