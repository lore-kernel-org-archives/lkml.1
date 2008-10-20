Return-Path: <linux-kernel-owner+w=401wt.eu-S1752932AbYJTNlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbYJTNlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 09:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbYJTNlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 09:41:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36794 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbYJTNlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 09:41:31 -0400
Date: Mon, 20 Oct 2008 15:41:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] rcupdate: fix bug of rcu_barrier*()
Message-ID: <20081020134109.GC32363@elte.hu>
References: <48F8335E.5060401@cn.fujitsu.com> <20081017145854.GD6706@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017145854.GD6706@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Fri, Oct 17, 2008 at 02:40:30PM +0800, Lai Jiangshan wrote:
> > 
> > current rcu_barrier_bh() is like this:
> > 
> > void rcu_barrier_bh(void)
> > {
> > 	BUG_ON(in_interrupt());
> > 	/* Take cpucontrol mutex to protect against CPU hotplug */
> > 	mutex_lock(&rcu_barrier_mutex);
> > 	init_completion(&rcu_barrier_completion);
> > 	atomic_set(&rcu_barrier_cpu_count, 0);
> > 	/*
> > 	 * The queueing of callbacks in all CPUs must be atomic with
> > 	 * respect to RCU, otherwise one CPU may queue a callback,
> > 	 * wait for a grace period, decrement barrier count and call
> > 	 * complete(), while other CPUs have not yet queued anything.
> > 	 * So, we need to make sure that grace periods cannot complete
> > 	 * until all the callbacks are queued.
> > 	 */
> > 	rcu_read_lock();
> > 	on_each_cpu(rcu_barrier_func, (void *)RCU_BARRIER_BH, 1);
> > 	rcu_read_unlock();
> > 	wait_for_completion(&rcu_barrier_completion);
> > 	mutex_unlock(&rcu_barrier_mutex);
> > }
> > 
> > The inconsistency of the code and the comments show a bug here.
> > rcu_read_lock() cannot make sure that "grace periods for RCU_BH
> > cannot complete until all the callbacks are queued".
> > it only make sure that race periods for RCU cannot complete
> > until all the callbacks are queued.
> > 
> > so we must use rcu_read_lock_bh() for rcu_barrier_bh().
> > like this:
> > 
> > void rcu_barrier_bh(void)
> > {
> > 	......
> > 	rcu_read_lock_bh();
> > 	on_each_cpu(rcu_barrier_func, (void *)RCU_BARRIER_BH, 1);
> > 	rcu_read_unlock_bh();
> > 	......
> > }
> > 
> > and also rcu_barrier() rcu_barrier_sched() are implemented like this.
> > it will bring a lot of duplicate code. My patch uses another way to
> > fix this bug, please see the comment of my patch.
> > Thank Paul E. McKenney for he rewrote the comment.
> 
> Still looks good to me!  Thank you again, Jiangshan, for finding and
> fixing this one!!!
> 
> 							Thanx, Paul
> 
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

applied to tip/core/urgent, thanks!

	Ingo
