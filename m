Return-Path: <linux-kernel-owner+w=401wt.eu-S1760665AbZADTtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760665AbZADTtE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 14:49:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758316AbZADTsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 14:48:53 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:45762 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756950AbZADTsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 14:48:52 -0500
Date: Sun, 4 Jan 2009 11:48:51 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Manfred Spraul <manfred@colorfullife.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [RFC, PATCH] kernel/rcu: add kfree_rcu
Message-ID: <20090104194851.GM6958@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <200901021159.n02BxDLg024728@mail.q-ag.de> <20090102185543.GE6842@linux.vnet.ibm.com> <49604E19.8040502@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49604E19.8040502@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 01:50:17PM +0800, Lai Jiangshan wrote:
> Paul E. McKenney wrote:
> > On Fri, Jan 02, 2009 at 12:25:58PM +0100, Manfred Spraul wrote:
> >> Based on the idea from Lai Jiangshan:
> >>
> >> There are 23 instances where the rcu callback just does
> >>
> >> 	kfree(containerof(rcu_member,struct whatever_struct,head));
> >>
> >> The 23 instances exist because there are 23 'struct whatever_struct' with
> >> their individual rcu_member.
> >>
> >> The attached patch creates a generic kfree_rcu function that removes the need
> >> for these 23 helpers: The offset from the container struct to the rcu member
> >> is calculated at compile time and stored in head->func instead of the
> >> function pointer.
> > 
> > OK, these seem to me to avoid Nick Piggin's vfree() question in response
> > to a roughly similar posting from Lai Jiangshan on November 18th
> > (http://lkml.org/lkml/2008/11/18/83).
> 
> Why?

Nick seemed to me to be objecting to vfree() being involved, and
Manfred's patch does not do vfree().  Hence "avoid" rather than "fix".

> I think these two are different questions.
> vfree() still can not be called from softirq context now.
> And I proposed vfree_atomic() for RCU, but it can not be accepted.

And one would indeed either need to have a vfree_atomic() or have some
mechanism that sent the vfree() to a workqueue or some such.

In any case, I do apologize -- since I didn't see anything from you I
incorrectly assumed that you had given up on this patch.  Please accept
my apologies!

Would it be possible for you and Manfred to agree on a common patch, and
to have one of you submit it with both of you having Signed-off-by on it?

							Thanx, Paul

> Lai
> 
> > 
> >> Effect on .text: (x86_64)
> >> +23 bytes in rcutree.c
> >> - 9 bytes in ipc/sem.c
> >>
> >> Depending on the number of call_rcu instances in the .config, adding
> >> kfree_rcu should save between 100 and 200 bytes in .text.
> >>
> >> What do you think?
> > 
> > I am in favor, given changes noted below.  This is a much nicer way to
> > implement some function in the original RCU patch for Linux.
> > 
> >> Is the interface ok? Incorrect use should generate compile time errors.
> >> Is it ok to use IS_ERR(p)?
> > 
> > I would suggest instead using the bottom bit to differentiate between
> > these two cases, especially given that your approach makes it impossible
> > for callback processing to notice a NULL function pointer.  In addition,
> > this approach would allow different types of allocators to be specified
> > should this later prove to be helpful.  You should not have to shift the
> > offset because the rcu_head offset should always be a multiple of four
> > (or eight on 64-bit architectures).
> > 
> > And we really are running into bugs that are detected by RCU's seeing a
> > null function pointer in the rcu_head structure at callback-invocation
> > time.  So, whatever encoding you choose, please leave a function-pointer
> > value of zero as an invalid value!
> > 
> >> And: How many seperate patches should I create?
> >> I would propose 24 patches: one with the interface, 23 that
> >> replace the individual callbacks.
> > 
> > I defer to the various maintainers on this one.  ;-)
> > 
> > 							Thanx, Paul
> > 
> >> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> >> ---
> >>  include/linux/rcupdate.h |   33 +++++++++++++++++++++++++++++++++
> >>  ipc/sem.c                |   10 ++--------
> >>  kernel/rcuclassic.c      |    2 +-
> >>  kernel/rcupreempt.c      |    2 +-
> >>  kernel/rcutree.c         |    2 +-
> >>  5 files changed, 38 insertions(+), 11 deletions(-)
> >>
> >> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> >> index 1168fbc..d120014 100644
> >> --- a/include/linux/rcupdate.h
> >> +++ b/include/linux/rcupdate.h
> >> @@ -269,6 +269,29 @@ extern void call_rcu(struct rcu_head *head,
> >>  extern void call_rcu_bh(struct rcu_head *head,
> >>  			void (*func)(struct rcu_head *head));
> >>
> >> +/**
> >> + * kfree_rcu - kfree after a grace period
> >> + * @ptr: pointer to kfree
> >> + * @rcu_member: name of the struct rcu_head member.
> >> + *
> >> + * Many rcu callbacks just call kfree() on the base structure. This helper
> >> + * function calls kfree internally. The rcu_head structure must be embedded
> >> + * in the to be freed structure.
> >> + */
> >> +
> >> +static inline void __kfree_rcu(void *prcu, unsigned long offset)
> >> +{
> >> +	void (*pfnc)(struct rcu_head *head) = (void (*)(struct rcu_head *head))offset;
> >> +
> >> +	BUILD_BUG_ON(!__builtin_constant_p(-offset));
> >> +	BUILD_BUG_ON(!IS_ERR(pfnc));
> > 
> > This allows us to drop the above check in favor of something like the
> > following above (though a symbolic value in place of 0x1 would be nice):
> > 
> > 	void (*pfnc)(struct rcu_head *head) = (void (*)(struct rcu_head *head))(offset | 0x1);
> > 
> >> +	call_rcu(prcu, pfnc);
> >> +}
> >> +
> >> +#define kfree_rcu(pobj, entry) \
> >> +	__kfree_rcu(&((pobj)->entry), -offsetof(typeof(*(pobj)), entry))
> >> +
> >>  /* Exported common interfaces */
> >>  extern void synchronize_rcu(void);
> >>  extern void rcu_barrier(void);
> >> @@ -279,4 +302,14 @@ extern void rcu_barrier_sched(void);
> >>  extern void rcu_init(void);
> >>  extern int rcu_needs_cpu(int cpu);
> >>
> >> +/* helper functions */
> >> +static inline void rcu_docallback(struct rcu_head *head)
> >> +{
> > 
> > Experience indicates that we should have some sort of WARN_ON() in
> > the case of a NULL rcu_head, either here or where this is called.  :-/
> > 
> >> +	if (IS_ERR(head->func)) {
> > 
> > And in this "if" statement, just check the bottom bit.
> > 
> >> +		kfree(((char *)head) + (unsigned long)head->func);
> >> +	} else {
> >> +		head->func(head);
> >> +	}
> >> +}
> >> +
> >>  #endif /* __LINUX_RCUPDATE_H */
> >> diff --git a/ipc/sem.c b/ipc/sem.c
> >> index 0821224..4a68cf2 100644
> >> --- a/ipc/sem.c
> >> +++ b/ipc/sem.c
> >> @@ -504,12 +504,6 @@ static int count_semzcnt (struct sem_array * sma, ushort semnum)
> >>  	return semzcnt;
> >>  }
> >>
> >> -static void free_un(struct rcu_head *head)
> >> -{
> >> -	struct sem_undo *un = container_of(head, struct sem_undo, rcu);
> >> -	kfree(un);
> >> -}
> >> -
> >>  /* Free a semaphore set. freeary() is called with sem_ids.rw_mutex locked
> >>   * as a writer and the spinlock for this semaphore set hold. sem_ids.rw_mutex
> >>   * remains locked on exit.
> >> @@ -528,7 +522,7 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
> >>  		un->semid = -1;
> >>  		list_del_rcu(&un->list_proc);
> >>  		spin_unlock(&un->ulp->lock);
> >> -		call_rcu(&un->rcu, free_un);
> >> +		kfree_rcu(un, rcu);
> > 
> > This -is- nice!  Short and sweet!!!
> > 
> >>  	}
> >>
> >>  	/* Wake up all pending processes and let them fail with EIDRM. */
> >> @@ -1347,7 +1341,7 @@ void exit_sem(struct task_struct *tsk)
> >>  		update_queue(sma);
> >>  		sem_unlock(sma);
> >>
> >> -		call_rcu(&un->rcu, free_un);
> >> +		kfree_rcu(un, rcu);
> >>  	}
> >>  	kfree(ulp);
> >>  }
> >> diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
> >> index e503a00..b2f97d2 100644
> >> --- a/kernel/rcuclassic.c
> >> +++ b/kernel/rcuclassic.c
> >> @@ -336,7 +336,7 @@ static void rcu_do_batch(struct rcu_data *rdp)
> >>  	while (list) {
> >>  		next = list->next;
> >>  		prefetch(next);
> >> -		list->func(list);
> >> +		rcu_docallback(list);
> >>  		list = next;
> >>  		if (++count >= rdp->blimit)
> >>  			break;
> >> diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
> >> index 0498265..8440dac 100644
> >> --- a/kernel/rcupreempt.c
> >> +++ b/kernel/rcupreempt.c
> >> @@ -1110,7 +1110,7 @@ static void rcu_process_callbacks(struct softirq_action *unused)
> >>  	spin_unlock_irqrestore(&rdp->lock, flags);
> >>  	while (list) {
> >>  		next = list->next;
> >> -		list->func(list);
> >> +		rcu_docallback(list);
> >>  		list = next;
> >>  		RCU_TRACE_ME(rcupreempt_trace_invoke);
> >>  	}
> >> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> >> index a342b03..29c88ce 100644
> >> --- a/kernel/rcutree.c
> >> +++ b/kernel/rcutree.c
> >> @@ -901,7 +901,7 @@ static void rcu_do_batch(struct rcu_data *rdp)
> >>  	while (list) {
> >>  		next = list->next;
> >>  		prefetch(next);
> >> -		list->func(list);
> >> +		rcu_docallback(list);
> > 
> > Good, you got all three of them!  ;-)
> > 
> >>  		list = next;
> >>  		if (++count >= rdp->blimit)
> >>  			break;
> >> -- 
> >> 1.6.0.6
> >>
> > 
> > 
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
