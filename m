Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933604Ab0BYUFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 15:05:40 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57822 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933525Ab0BYUFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 15:05:39 -0500
Date: Thu, 25 Feb 2010 12:05:32 -0800
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
Message-ID: <20100225200532.GD6771@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100223180127.GF6700@linux.vnet.ibm.com> <20100224235958.GK6980@linux.vnet.ibm.com> <20100225170653.GA5715@linux.vnet.ibm.com> <201002251910.34938.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002251910.34938.arnd@arndb.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 07:10:34PM +0100, Arnd Bergmann wrote:
> On Thursday 25 February 2010, Paul E. McKenney wrote:
> > > 
> > > The nice thing about this is that we don't end up with the API explosion
> > > for the RCU list primitives.  However, it does require that a given
> > > rcu_list_head have a single synchronization-design rule for all uses.
> > > Of course, if there were multiple rules, one could construct a check
> > > that was simply the union of all the rules, but that would miss some
> > > types of errors.
> 
> What would it miss? E.g. having the module code check for
> (mutex_is_locked(&module_lock) || rcu_read_lock_held) should
> cover all cases as far as I can tell.

My concern is single data structures used in different parts of the code
with different update-side locks, perhaps also different flavors of RCU.
Some of the tree data structures in the Linux kernel can be protected by
either locking or RCU, for example.

> > > Of course, if this became a problem, there could be an argument to the
> > > ->check function that the normal list_for_each_entry_rcu() defaults to
> > > "no effect".
> 
> I've also been thinking about adding a list_for_each_entry_norcu()
> macro that takes an rcu_list_head but then just performs a simple
> list_for_each_entry().

We might need to do something like this, but if we do, we need to
minimize the need to use it.

> > > Or is there a better way to handle this?
> > 
> > One approach would be to use your original sparse-based approach, but
> > use an rcu_deference_const(ptr,lockdep_condition) for cases when the
> > value cannot change, for example, when the update-side lock is held.
> > This should eliminate most of the false positives, in particular,
> > eliminate the need for otherwise-useless rcu_read_lock()s  -- and also
> > for the compiler constraints in the normal rcu_dereference().
> 
> Right.
> 
> > Your pointer-to-function idea could be a really cool way to handle the
> > tree algorithms that can be protected either by RCU or by locking.
> > The tree nodes could have the pointer to check function, and the
> > current rcu_dereference_raw() calls could be replaced by an invocation
> > of rcu_dereference_check() that calls the check function.  A check
> > function for an RCU-protected tree would use "rcu_read_lock_held() ||
> > lockdep_is_held(&update_side_lock)", while a lock-protected tree would
> > just use "lockdep_is_held(&update_side_lock)".
> 
> I've postponed that problem for now, and updated my series to split
> the rculist annotations from the basic __rcu pointer annotations,
> as well as to apply on top of your patches in tip/core/rcu,
> see http://git.kernel.org/?p=linux/kernel/git/arnd/playground.git;\
> a=shortlog;h=refs/heads/rcu-annotate-tip.
> 
> Should we merge the simple annotations in this merge window and
> then think about rculist and trees separately?

I haven't given up on the possibility of getting the whole thing into
this merge window, but if that is not possible, it would be good to
start on the annotations.  Of course, the annotations would need to be
done so that they don't rain false positives on people who are not
actively looking to see them.

							Thanx, Paul
