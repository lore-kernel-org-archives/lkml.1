Return-Path: <linux-kernel-owner+w=401wt.eu-S1760116AbYHHTtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116AbYHHTtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 15:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbYHHTto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 15:49:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41964 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbYHHTto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 15:49:44 -0400
Subject: Re: [PATCH] printk: robustify printk
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org,
       davem@davemloft.net, rostedt@goodmis.org, paulmck@linux.vnet.ibm.com
In-Reply-To: <20080808123747.0db1c5dd.akpm@linux-foundation.org>
References: <20080324122424.671168000@chello.nl>
	 <alpine.LFD.1.00.0803241021350.17905@woody.linux-foundation.org>
	 <1206382547.6437.131.camel@lappy>
	 <20080324115738.85c72bb5.akpm@linux-foundation.org>
	 <1218202249.8625.106.camel@twins>
	 <alpine.LFD.1.10.0808080931550.3462@nehalem.linux-foundation.org>
	 <1218215454.8625.133.camel@twins>
	 <alpine.LFD.1.10.0808081014240.3462@nehalem.linux-foundation.org>
	 <1218217257.29098.2.camel@lappy.programming.kicks-ass.net>
	 <alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org>
	 <1218219269.29098.5.camel@lappy.programming.kicks-ass.net>
	 <20080808121428.646a8b3c.akpm@linux-foundation.org>
	 <1218223269.29098.12.camel@lappy.programming.kicks-ass.net>
	 <20080808123747.0db1c5dd.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 21:49:27 +0200
Message-Id: <1218224967.29098.22.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-08 at 12:37 -0700, Andrew Morton wrote:
> On Fri, 08 Aug 2008 21:21:08 +0200
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Fri, 2008-08-08 at 12:14 -0700, Andrew Morton wrote:
> > > On Fri, 08 Aug 2008 20:14:28 +0200
> > > Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > 
> > > >  void wake_up_klogd(void)
> > > >  {
> > > > -	if (!oops_in_progress && waitqueue_active(&log_wait))
> > > > -		wake_up_interruptible(&log_wait);
> > > > +	unsigned long flags;
> > > > +	struct klogd_wakeup_state *kws;
> > > > +
> > > > +	if (!waitqueue_active(&log_wait))
> > > > +		return;
> > > > +
> > > > +	local_irq_save(flags);
> > > > +	kws = &__get_cpu_var(kws);
> > > > +	if (!kws->pending) {
> > > > +		kws->pending = 1;
> > > > +		call_rcu(&kws->head, __wake_up_klogd);
> > > > +	}
> > > > +	local_irq_restore(flags);
> > > >  }
> > > 
> > > Note that kernel/rcupreempt.c's flavour of call_rcu() takes
> > > RCU_DATA_ME().lock, so there are still code sites from which a printk
> > > can deadlock.  Only now, it is config-dependent.
> > > 
> > > From a quick look it appears that large amounts of kernel/rcupreempt.c
> > > are now a printk-free zone.
> > 
> > Drad, missed that bit, I did look at the calling end, but forgot the
> > call_rcu() end :-/
> > 
> > The initial printk_tick() based implementation didn't suffer this
> > problem, should we revert to that scheme?
> 
> Dunno.  Perhaps we could convert RCU_DATA_ME's spinlock_t into an
> rwlock and do read_lock() in call_rcu()?  Then we can should be able to
> call printk from inside that read_lock(), but not inside write_lock(),
> which, with suitable warning comments might be acceptable.
> 
> afacit everything in call_rcu()'s *rdp is cpu-local and is protected by
> local_irq_save().  rcu_ctrlblk.completed and rcu_flipped need some
> protection, but a) rdp->lock isn't sufficient anyway and b)
> read_lock protection would suffice.  Maybe other CPUs can alter *rdp
> while __rcu_advance_callbacks() is running.
> 
> Anyway, that's all handwaving.  My point is that making rcupreempt.c
> more robust and more concurrent might be an alternative fix, and might
> be beneficial in its own right.  Working out the details is what we
> have Pauls for ;)

Hehe :-)

Just in case Paul shows he's human and cannot work his way around it, I
just posted a new version of the printk_tick() stuff..

