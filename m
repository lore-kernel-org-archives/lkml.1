Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838Ab0BYRHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 12:07:01 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50575 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759440Ab0BYRG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 12:06:59 -0500
Date: Thu, 25 Feb 2010 09:06:53 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
Subject: Re: [PATCH 07/10] module: __rcu annotations
Message-ID: <20100225170653.GA5715@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100223180127.GF6700@linux.vnet.ibm.com> <201002242126.09994.arnd@arndb.de> <20100224221749.GI6980@linux.vnet.ibm.com> <201002250007.47563.arnd@arndb.de> <20100224235958.GK6980@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100224235958.GK6980@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 03:59:58PM -0800, Paul E. McKenney wrote:
> On Thu, Feb 25, 2010 at 12:07:47AM +0100, Arnd Bergmann wrote:
> > On Wednesday 24 February 2010 23:17:49 Paul E. McKenney wrote:
> > > > Ok, this is a significant limitation of the list rcu annotation
> > > > then, it's not possible to pass the same list into list_for_each_entry
> > > > and list_for_each_entry_rcu with the way I changed the rcu list
> > > > definition. I would be possible to do a __list_for_each_entry_rcu
> > > > macro that takes an rcu_list_head but does not actually use
> > > > rcu_dereference, but I'm not sure if that's good enough.
> > > 
> > > Hmmm...  If the __rcu annotation was visible at runtime, it would be
> > > easy provide an annotated version of list_for_each_entry_rcu() that
> > > checks for module_mutex being held under lockdep.
> > 
> > Well, if we keep the struct rcu_list_head and make it mandatory for
> > rcu protected lists, it could be defined as
> > 
> > struct rcu_list_head {
> > 	struct list_head head;
> > #ifdef CONFIG_PROVE_RCU
> > 	bool (*check)(void);
> > #endif
> > };
> > 
> > #ifdef CONFIG_PROVE_RCU
> > #define RCU_LIST_HEAD_INIT_CHECK(__head, __check) \
> > 	{ .head = LIST_HEAD_INIT((__head).head), .check = (__check) }
> > #else
> > #define RCU_LIST_HEAD_INIT_CHECK(__list,__check) {.head = LIST_HEAD_INIT((__head).head) }
> > #endif
> > 
> > #define RCU_LIST_HEAD_INIT(head) RCU_LIST_HEAD_INIT_CHECK(head,&rcu_read_lock_held)
> > #define RCU_LIST_HEAD_INIT_BH(head) RCU_LIST_HEAD_INIT_CHECK(head,&rcu_read_lock_bh_held)
> > 
> > #define list_entry_rcu_check(ptr, type, member, check) \
> >         container_of(rcu_dereference_check((void __rcu __force *)(ptr), check), type, member)
> > 
> > #define list_for_each_entry_rcu(pos, __head, member) \
> >         for (pos = list_entry_rcu_check((__head)->head.next, typeof(*pos), \
> > 					 member, (__head)->check); \
> >                 prefetch(pos->member.next), &pos->member != (head); \
> >                 pos = list_entry_rcu_check(pos->member.next, typeof(*pos), \
> > 					 member, (__head)->check)))
> > 
> > That would let us check all the heads for correct usage, and at the same
> > time avoid having to annotate all the list entries.
> 
> Cool!!!
> 
> The nice thing about this is that we don't end up with the API explosion
> for the RCU list primitives.  However, it does require that a given
> rcu_list_head have a single synchronization-design rule for all uses.
> Of course, if there were multiple rules, one could construct a check
> that was simply the union of all the rules, but that would miss some
> types of errors.
> 
> Of course, if this became a problem, there could be an argument to the
> ->check function that the normal list_for_each_entry_rcu() defaults to
> "no effect".
> 
> Or is there a better way to handle this?

One approach would be to use your original sparse-based approach, but
use an rcu_deference_const(ptr,lockdep_condition) for cases when the
value cannot change, for example, when the update-side lock is held.
This should eliminate most of the false positives, in particular,
eliminate the need for otherwise-useless rcu_read_lock()s  -- and also
for the compiler constraints in the normal rcu_dereference().

Your pointer-to-function idea could be a really cool way to handle the
tree algorithms that can be protected either by RCU or by locking.
The tree nodes could have the pointer to check function, and the
current rcu_dereference_raw() calls could be replaced by an invocation
of rcu_dereference_check() that calls the check function.  A check
function for an RCU-protected tree would use "rcu_read_lock_held() ||
lockdep_is_held(&update_side_lock)", while a lock-protected tree would
just use "lockdep_is_held(&update_side_lock)".

Thoughts?

							Thanx, Paul
