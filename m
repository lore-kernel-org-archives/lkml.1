Return-Path: <linux-kernel-owner+w=401wt.eu-S1760368AbXGWOjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760368AbXGWOjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 10:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbXGWOjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 10:39:06 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:50753 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbXGWOjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 10:39:03 -0400
Subject: Re: [PATCH -rt] drop spurious rcu unlock
From: Daniel Walker <dwalker@mvista.com>
To: paulmck@linux.vnet.ibm.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <20070723140623.GD9400@linux.vnet.ibm.com>
References: <1185124958.2573.13.camel@imap.mvista.com>
	 <20070723031359.GA25590@linux.vnet.ibm.com>
	 <1185197839.2573.32.camel@imap.mvista.com>
	 <20070723140623.GD9400@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 07:28:15 -0700
Message-Id: <1185200895.2573.46.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 07:06 -0700, Paul E. McKenney wrote:

> > I was wondering what kind of side effects would happen with the
> > preemptible RCU ..
> 
> Well, if you had only one rcu_read_lock() outstanding in the system,
> it would appear to be in a quiescent state, which would not be good.
> Given enough executions of that code, grace periods would cease and
> you would OOM.
> 
> I didn't see any OOMs despite overnight rcutorture runs -- which would
> definitely have spotted halted grace periods -- so perhaps I just happened
> to never invoke sched_yield?

Seems pretty unlikely that yield() wouldn't get called .. Isn't the
effect per-task since rcu_read_unlock() touches
current->rcu_read_lock_nesting?

> > > BUG: sleeping function called from invalid context cc1(29651) at kernel/rtmutex.c:636
> > > in_atomic():1 [00000001], irqs_disabled():0
> > >  [<c0119f50>] __might_sleep+0xf3/0xf9
> > >  [<c031600e>] __rt_spin_lock+0x21/0x3c
> > >  [<c014102c>] get_zone_pcp+0x20/0x29
> > >  [<c0141a40>] free_hot_cold_page+0xdc/0x167
> > >  [<c013a3f4>] add_preempt_count+0x12/0xcc
> > >  [<c0110d92>] pgd_dtor+0x0/0x1
> > >  [<c015d865>] quicklist_trim+0xb7/0xe3
> > >  [<c0111025>] check_pgt_cache+0x19/0x1c
> > >  [<c0148df5>] free_pgtables+0x54/0x12c
> > >  [<c013a3f4>] add_preempt_count+0x12/0xcc
> > >  [<c014e5be>] unmap_region+0xeb/0x13b
> > 
> > This looks a little like what Rui Nuno Capela is seeing , but his kernel
> > hangs.
> 
> Hmmm...  In this particular case, the test (kernbench) was fairly
> short, so maybe I just didn't let it run long enough.

Looks like quicklist_trim() disabled preemption to access the per-cpu
variable "quicklist" then calls free_pages() which takes a mutex.. Below
looks like the same deal ..

> 						Thanx, Paul
> 
> > > BUG: scheduling while atomic: cc1/0x00000002/29745, CPU#0
> > >  [<c03146c8>] __sched_text_start+0xb0/0x4fe
> > >  [<c0116432>] try_to_wake_up+0x31b/0x326
> > >  [<c013a3f4>] add_preempt_count+0x12/0xcc
> > >  [<c013a3f4>] add_preempt_count+0x12/0xcc
> > >  [<c0314bfc>] schedule+0xe6/0x100
> > >  [<c03158db>] rt_spin_lock_slowlock+0xc5/0x145
> > >  [<c0316027>] __rt_spin_lock+0x3a/0x3c
> > >  [<c014102c>] get_zone_pcp+0x20/0x29
> > >  [<c0141a40>] free_hot_cold_page+0xdc/0x167
> > >  [<c013a3f4>] add_preempt_count+0x12/0xcc
> > >  [<c0110d92>] pgd_dtor+0x0/0x1
> > >  [<c015d865>] quicklist_trim+0xb7/0xe3
> > >  [<c0111025>] check_pgt_cache+0x19/0x1c
> > >  [<c0148df5>] free_pgtables+0x54/0x12c
> > >  [<c013a3f4>] add_preempt_count+0x12/0xcc
> > >  [<c014e5be>] unmap_region+0xeb/0x13b
> > >  [<c014e861>] do_munmap+0xea/0xff
> > >  [<c014e8a7>] sys_munmap+0x31/0x40
> > >  [<c010276a>] syscall_call+0x7/0xb
> > >  [<c0310000>] _shift_data_right_pages+0xb9/0xd1
> > >  =======================
> > > ---------------------------
> > > | preempt count: 00000002 ]
> > > | 2-level deep critical section nesting:
> > > ----------------------------------------
> > > .. [<c015d7c8>] .... quicklist_trim+0x1a/0xe3
> > > .....[<00000000>] ..   ( <= _stext+0x3fefff50/0x14)
> > > .. [<c031462b>] .... __sched_text_start+0x13/0x4fe
> > > .....[<00000000>] ..   ( <= _stext+0x3fefff50/0x14)
> > > 
> > > > Signed-Off-By: Daniel Walker <dwalker@mvista.com>
> > > > 
> > > > Index: linux-2.6.22.1/kernel/sched.c
> > > > ===================================================================
> > > > --- linux-2.6.22.1.orig/kernel/sched.c	2007-07-22 16:47:37.000000000 +0000
> > > > +++ linux-2.6.22.1/kernel/sched.c	2007-07-22 16:16:48.000000000 +0000
> > > > @@ -4900,7 +4900,6 @@ asmlinkage long sys_sched_yield(void)
> > > >  	 * no need to preempt or enable interrupts:
> > > >  	 */
> > > >  	spin_unlock_no_resched(&rq->lock);
> > > > -	rcu_read_unlock();
> > > > 
> > > >  	__schedule();
> > > > 
> > > > 
> > > > 
> > > > -
> > > > To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 

