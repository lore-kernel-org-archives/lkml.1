Return-Path: <linux-kernel-owner+w=401wt.eu-S1764243AbXIUVdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764243AbXIUVdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 17:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762625AbXIUVdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 17:33:37 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:32934 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841AbXIUVdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 17:33:36 -0400
Date: Fri, 21 Sep 2007 17:32:08 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] Add CRC checksum for RCU lists
In-Reply-To: <20070921171256.GA9059@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.58.0709211550330.29857@gandalf.stny.rr.com>
References: <1190313251.4518.14.camel@localhost.localdomain>
 <20070921171256.GA9059@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



--
On Fri, 21 Sep 2007, Paul E. McKenney wrote:

> On Thu, Sep 20, 2007 at 02:34:11PM -0400, Steven Rostedt wrote:
> > In recent development of the RT kernel, some of our experimental code
> > corrupted the rcu header. But the side effect (crashing) didn't rear its
> > ugly head until way after the fact. Discussing this with Paul, he
> > suggested that RCU should have a "self checking" mechanism to detect
> > these kind of issues. He also suggested putting in a CRC into the
> > rcu_head structure.
> >
> > This patch does so.
>
> Very cool!!!

Thanks :-)



>
> > This patch also takes care to update the crc when rcu_head items are
> > moved from list to list and whenever the next pointer is modified due to
> > addition.
>
> We can only be thankful that it is not possible to cancel outstanding
> RCU callbacks...

true

> Looks good -- a few suggestions for better fault coverage interspersed
> below.  But would be useful as is.  (And it would be good to apply after
> the preempt/boost patches, which are currently undergoing integration
> with the CPU hotplug patches -- the good news is that this integration
> eliminates the need for patch #4!)
>
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Thanks, but this is still going to go through changes, from your comments
as well as your latest patches.

>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> >
> > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > index fe17d7d..baca7e6 100644
> > --- a/include/linux/rcupdate.h
> > +++ b/include/linux/rcupdate.h
> > @@ -50,13 +50,81 @@
> >  struct rcu_head {
> >  	struct rcu_head *next;
> >  	void (*func)(struct rcu_head *head);
> > +#ifdef CONFIG_RCU_CRC_HEADER_CHECK
> > +	/*
> > +	 * Checks are made in C files knowing that "next" is
> > +	 * the first element. So keep it the first element.
> > +	 */
> > +	unsigned long crc;
> > +	void *caller;
> > +#endif
> >  };
>
> Looks good, but one question -- why not include the caller in the CRC?
> Not a big deal either way, but would catch a few more cases of corruption.
> Also, as things stand, the caller pointer can be silently corrupted,
> which might causes confusion if someone had to examine the RCU callback
> lists from a crash dump.

One reason was that the caller was an addition. I originally didn't have
it, but during my tests, the output was basically useless. It didn't give
any hint to where things went wrong, so I added it. The CRC is to check
the rcu is working, not really the checker itself.

Note, it helped us out lately with Peter's latest file_table patches in
-rt. With this patch applied, it triggered corruption. That was due to the
union in the fs.h between the llist and rcu_head there was a dependency
in the llist where the rcu_head would not grow. The llist can still do a
spin lock on the lock _after_ the item was added to the call_rcu. Because
of that union, the locking of the lock corrupted the crc. Set it to one.

You'll see patches from Peter soon to get rid of that dependency.

>
> Interchanging the order of "crc" and "caller" would change the strategy,
> if I understand correctly.

yep.

>
> > -#define RCU_HEAD_INIT 	{ .next = NULL, .func = NULL }
> > +#ifdef CONFIG_RCU_CRC_HEADER_CHECK
> > +
> > +#define RCU_CRC_MAGIC 0xC4809168UL
>
> Very magic indeed -- Google doesn't find it, other than in your
> patch.  ;-)

Paul, I'm disappointed in you. That number doesn't ring a bell at all??

(hint, ignore the 'C' that was added by me).

>
> > +static inline unsigned long rcu_crc_calc(struct rcu_head *head)
> > +{
> > +	unsigned int *p = (unsigned int*)head; /* 32 bit */
> > +	unsigned long crc = RCU_CRC_MAGIC;
> > +
> > +	for (p=(void *)head; (void*)p < (void*)&head->crc; p++)
> > +		crc ^= *p;
> > +	return crc;
> > +}
>
> Why initialize "p" twice?  (Once in the declaration, and once in the
> "for" loop, but with different casts.)

Why? probably because I was half asleep when writing it ;-)
Will fix.

>
> > +static inline void rcu_crc_check(struct rcu_head *head)
> > +{
> > +	static int once;
> > +	if (unlikely(head->crc != rcu_crc_calc(head)) && !once) {
> > +		once++;
>
> Do we want exactly one (give or take concurrent checks), or do we want
> the first ten or so?  Sometimes having a modest sample rather than
> exactly one is helpful.

I added that because during testing, it would flood the serial console. I
can modify this to whatever deems fit.  Perhaps more hits will give a
better clue to what went wrong. I could also just add a print_ratelimit to
it too.


>
> And I know that it doesn't matter in this case, but I cannot stop myself
> from pointing out the possibility of making "once" be an atomic_t
> that is initialized to (say) -10, then making the !once check be an
> atomic_add_return().  (Whew!  Good to get that off my chest!!!)

Would you prefer the above or the print_ratelimit? Maybe 10 would be best.
I really don't have a preference.

>
> Now back to real problems.  ;-)
>
> (Note to self...)  The way this is coded could possibly result in false
> positives.  Suppose that the last element in a given callback list has
> its CRC correctly calculated.  Now suppose that a new callback is being
> added to the end of the list.  This addition is non-atomic, so the of
> the old last element will be momentarily incorrect.  So, need to check
> that all list checks are protected by some lock.  (And all the cases
> I saw below are in fact OK.)

I believe that I tried to keep all the checks done in the same locations
that could possible modify the lists. So they should be protect by the
same mechanism.  On the rcupreempt side, I made the checks within the
holding of the data lock (for when you see that patch ;-)

>
> > +		printk("BUG: RCU check failed!");
> > +		if (head->caller)
> > +			printk(" (caller=%p)",
> > +			       head->caller);
> > +		printk("\n");
> > +		printk("  CRC was %08lx, expected %08lx\n",
> > +		       head->crc, rcu_crc_calc(head));
>
> I suggest also printing head->crc^rcu_crc_calc(head) to make cases
> where a single bit is being corrupted more obvious.

OK, will do.

>
> > +		printk("  %p %p\n",
> > +		       head->next, head->func);
> > +		dump_stack();
> > +	}
> > +}
> > +
> > +static inline void rcu_assign_crc(struct rcu_head *head)
> > +{
> > +	head->crc = rcu_crc_calc(head);
> > +	head->caller = __builtin_return_address(0);
> > +}
>
> If you do decide to move the caller into the CRC calculation, it
> will be necessary to reverse the above pair of lines.

Noted.

>
> > +static inline void rcu_check_list(struct rcu_head *head)
> > +{
> > +	int loop;
> > +	for (loop = 0;
> > +	     head != NULL && loop < 100;
> > +	     head=head->next, loop++)
> > +		rcu_crc_check(head);
> > +}
> > +
> > +# define RCU_CRC_INIT , .crc = RCU_CRC_MAGIC
>
> Would need to initialize caller here if you add it to the CRC.
>
> > +# define RCU_CRC_SET(ptr) (ptr)->crc = RCU_CRC_MAGIC
>
> And here as well.
>
> But this has the effect of causing the CRC to be born correct.  Do we
> really want that?  Suppose someone incorrectly re-initialized a callback
> that was still on a list.  Wouldn't it be better to get a CRC warning than
> a NULL pointer exception?  So suggest something like RCU_CRC_MAGIC+1 --
> perhaps with a RCU_CRC_BAD_MAGIC symbol.

Yeah, I can scrap those initialization macros. That came about my first
attempt where I forgot to add the assignment to the call_rcu and it
obviously failed.  So I added these macros, and it stilled failed. Then I
saw the mistake I made, fixed it, and it worked. But I never removed these
macros.  I think we can just keep the crc as zero. That would also fail
the test. Hmm, maybe we should add a BAD_CRC number so that it will give
us a hint that something was initiazed incorrectly.

>
> > +#else
> > +# define rcu_crc_calc(head) 0
> > +# define rcu_crc_check(head) do { } while(0)
> > +# define rcu_assign_crc(head) do { } while(0)
> > +# define rcu_check_list(head) do { } while(0)
> > +# define RCU_CRC_INIT
> > +# define RCU_CRC_SET(ptr) do { } while(0)
> > +#endif /* CONFIG_RCU_CRC_HEADER_CHECK */
> > +
> > +#define RCU_HEAD_INIT 	{ .next = NULL, .func = NULL RCU_CRC_INIT }
> >  #define RCU_HEAD(head) struct rcu_head head = RCU_HEAD_INIT
> > -#define INIT_RCU_HEAD(ptr) do { \
> > -       (ptr)->next = NULL; (ptr)->func = NULL; \
> > -} while (0)
> > +#define INIT_RCU_HEAD(ptr) do {				\
> > +		(ptr)->next = NULL; (ptr)->func = NULL; \
> > +		RCU_CRC_SET(ptr);			\
> > +	} while (0)
> >
> >
> >
> > diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> > index 2c2dd84..4c3cc9c 100644
> > --- a/kernel/rcupdate.c
> > +++ b/kernel/rcupdate.c
> > @@ -76,6 +76,23 @@ static atomic_t rcu_barrier_cpu_count;
> >  static DEFINE_MUTEX(rcu_barrier_mutex);
> >  static struct completion rcu_barrier_completion;
> >
> > +#ifdef CONFIG_RCU_CRC_HEADER_CHECK
> > +#define rcu_check_rdp(rdp)			\
> > +	do {					\
> > +		rcu_check_list(rdp->nxtlist);	\
> > +		rcu_check_list(rdp->curlist);	\
> > +		rcu_check_list(rdp->donelist);	\
> > +	} while(0)
> > +#define rcu_crc_update_tail(rdp, tail, list)				\
> > +	do {								\
> > +		if ((rdp)->tail != &(rdp)->list)			\
> > +			rcu_assign_crc((struct rcu_head*)(rdp)->tail);	\
> > +	} while(0)
> > +#else
> > +# define rcu_check_rdp(rdp) do { } while(0)
> > +# define rcu_crc_update_tail(rdp, tail, list) do { } while(0)
> > +#endif
> > +
> >  #ifdef CONFIG_SMP
> >  static void force_quiescent_state(struct rcu_data *rdp,
> >  			struct rcu_ctrlblk *rcp)
> > @@ -122,14 +139,19 @@ void fastcall call_rcu(struct rcu_head *head,
> >
> >  	head->func = func;
> >  	head->next = NULL;
> > +	rcu_assign_crc(head);
> >  	local_irq_save(flags);
> >  	rdp = &__get_cpu_var(rcu_data);
> >  	*rdp->nxttail = head;
>
> The CRC of the tail element is incorrect at this point, but that is OK
> because we have interrupts disabled and no other CPU can access our list
> in the meantime.

Yep, that was planned.

>
> > +	rcu_crc_update_tail(rdp, nxttail, nxtlist);
> >  	rdp->nxttail = &head->next;
> >  	if (unlikely(++rdp->qlen > qhimark)) {
> >  		rdp->blimit = INT_MAX;
> >  		force_quiescent_state(rdp, &rcu_ctrlblk);
> >  	}
> > +
> > +	rcu_check_rdp(rdp);
>
> This check is OK -- no other CPU should be able to manipulate our
> rdp, and we have interrupts disabled.  Same situation for call_rcu_bh()
> below.
>
> >  	local_irq_restore(flags);
> >  }
> >
> > @@ -157,9 +179,11 @@ void fastcall call_rcu_bh(struct rcu_head *head,
> >
> >  	head->func = func;
> >  	head->next = NULL;
> > +	rcu_assign_crc(head);
> >  	local_irq_save(flags);
> >  	rdp = &__get_cpu_var(rcu_bh_data);
> >  	*rdp->nxttail = head;
> > +	rcu_crc_update_tail(rdp, nxttail, nxtlist);
> >  	rdp->nxttail = &head->next;
> >
> >  	if (unlikely(++rdp->qlen > qhimark)) {
> > @@ -167,6 +191,8 @@ void fastcall call_rcu_bh(struct rcu_head *head,
> >  		force_quiescent_state(rdp, &rcu_bh_ctrlblk);
> >  	}
> >
> > +	rcu_check_rdp(rdp);
> > +
> >  	local_irq_restore(flags);
> >  }
> >
> > @@ -233,6 +259,8 @@ static void rcu_do_batch(struct rcu_data *rdp)
> >  	struct rcu_head *next, *list;
> >  	int count = 0;
> >
> > +	rcu_check_rdp(rdp);
>
> OK, interrupts disabled here.
>
> >  	list = rdp->donelist;
> >  	while (list) {
> >  		next = list->next;
>
> Why not invalidate the CRC of the element that we just removed?  This
> would catch some cases of list mangling.

Good idea, will add.

>
> > @@ -373,6 +401,7 @@ static void rcu_move_batch(struct rcu_data *this_rdp, struct rcu_head *list,
> >  {
> >  	local_irq_disable();
> >  	*this_rdp->nxttail = list;
>
> Momentarily wrong CRC OK, interrupts disabled here.  Ditto for
> __rcu_process_callbacks() below.

yep

>
> > +	rcu_crc_update_tail(this_rdp, nxttail, nxtlist);
> >  	if (list)
> >  		this_rdp->nxttail = tail;
> >  	local_irq_enable();
> > @@ -424,6 +453,7 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp,
> >  {
> >  	if (rdp->curlist && !rcu_batch_before(rcp->completed, rdp->batch)) {
> >  		*rdp->donetail = rdp->curlist;
> > +		rcu_crc_update_tail(rdp, donetail, donelist);
> >  		rdp->donetail = rdp->curtail;
> >  		rdp->curlist = NULL;
> >  		rdp->curtail = &rdp->curlist;
> > diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > index 50a94ee..981fc93 100644
> > --- a/lib/Kconfig.debug
> > +++ b/lib/Kconfig.debug
> > @@ -424,6 +424,17 @@ config RCU_TORTURE_TEST
> >  	  Say M if you want the RCU torture tests to build as a module.
> >  	  Say N if you are unsure.
> >
> > +config RCU_CRC_HEADER_CHECK
> > +	bool "RCU header self check"
> > +	depends on DEBUG_KERNEL
> > +	help
> > +	  This option enables CRC verification of RCU lists to catch
> > +	  possible corruption to the RCU list by improper application
> > +	  of RCU callbacks. This adds overhead to the running system
> > +	  so only enable it if you suspect RCU corruption is occurring.
> > +
> > +	  If unsure, say N.
> > +
> >  config LKDTM
> >  	tristate "Linux Kernel Dump Test Tool Module"
> >  	depends on DEBUG_KERNEL
> >
> >
>

Paul, thanks for all the comments. I'll put out a new round of patches
after yours becomes offical (no "not for inclussion" statements).

-- Steve

