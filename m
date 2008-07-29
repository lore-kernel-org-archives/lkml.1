Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbYG2GQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbYG2GQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 02:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYG2GQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 02:16:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43084 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbYG2GQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 02:16:31 -0400
Subject: Re: [PATCH] RCU: implement rcu_read_[un]lock_preempt()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: dipankar@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <488E76A2.9050804@kernel.org>
References: <487AEAC6.60307@kernel.org> <1216188469.5232.0.camel@twins>
	 <487D98AC.3020005@kernel.org> <1217258001.18049.7.camel@twins>
	 <488E76A2.9050804@kernel.org>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 08:15:29 +0200
Message-Id: <1217312129.18049.44.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-29 at 10:47 +0900, Tejun Heo wrote:
> Peter Zijlstra wrote:
> >>> If you need preempt off you need it for other reasons than RCU, so
> >>> mixing it in the interface doesn't make sense to me.
> >> Hmmm... the point of the interface is avoiding doing double preemption
> >> operations as on common configurations rcu_read_lock() disables
> >> preemption.
> > 
> > Should be really cheap then, because the cacheline is already hot.
> 
> Yeah, it is, so it is eventually a peripheral issue.
> 
> >>   Yes, it's for different purposes but we have two partially
> >> overlapping ops and implementing combined / collapsed ops for such cases
> >> is acceptable, I think.
> > 
> > They only overlap for !PREEMPT_RCU || !PREEMPT_RT
> 
> That part is pretty large tho.

But the fact is that PREEMPT_RCU is upstream now..

> >> Using get_cpu() or separate preempt_disable() wouldn't incur noticeable
> >> performance difference as preemption is really cheap to manipulate but
> >> both per-cpu and RCU are for performance optimization and I think having
> >> combined ops is a good idea.
> > 
> > I don't as its a nightmare to sort out on -rt, where get_cpu() can be
> > converted to get_cpu_locked(), and rcu_read_lock() never disables
> > preemption.
> > 
> > If you convert it to use get_cpu() the conversion is easy, if you
> > introduce this collapsed primitive we're up shit creek because it
> > doesn't map.
> 
> I don't get it.  So, rcu_read_lock(); preempt_disable(); doesn't map for RT?

Nope, we'd want something like:

  rcu_read_lock();

  cpu = get_cpu();
  data = percpu_ptr(ptr, cpu);
  fiddle_per_cpu_data();
  put_cpu();

  do_more_rcu_protected_stuff();

  rcu_read_unlock();

This clearly shows the intent - on -rt we can then easily convert the
per-cpu stuff to use a lock instead of disabling preemption. Making the
whole code sequence preemptible.

If you would have mixed it into the rcu ops, its unclear what code needs
protection from what.

> > Nor does it tell us why you need preempt disabled. Making it just as bad
> > as open-coded preempt_disable()s.
> 
> Heh.. the code probably would have used preempt_disable() if it were not
> for the combined ops, so the objection is about using preempt_disable()?

preempt_disable() is just like the BKL, its opaque in that it isn't
bound to some data and doesn't tell you what it protects. So getting rid
of them afterwards is pain.

Therefore we prefer APIs such as, get_cpu() etc.. that show intent and
don;t like stuff you just now proposed of mixing intents. Because when
changing the preemption model you might need different solution for
different intents.

