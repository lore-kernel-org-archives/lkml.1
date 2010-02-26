Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935010Ab0BZCMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 21:12:17 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:34597 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934980Ab0BZCMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 21:12:16 -0500
Date: Thu, 25 Feb 2010 18:12:13 -0800
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
Message-ID: <20100226021213.GA15551@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100223180127.GF6700@linux.vnet.ibm.com> <20100224235958.GK6980@linux.vnet.ibm.com> <20100225170653.GA5715@linux.vnet.ibm.com> <201002251910.34938.arnd@arndb.de> <20100225200532.GD6771@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100225200532.GD6771@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 12:05:32PM -0800, Paul E. McKenney wrote:
> On Thu, Feb 25, 2010 at 07:10:34PM +0100, Arnd Bergmann wrote:

[ . . . ]

> > I've postponed that problem for now, and updated my series to split
> > the rculist annotations from the basic __rcu pointer annotations,
> > as well as to apply on top of your patches in tip/core/rcu,
> > see http://git.kernel.org/?p=linux/kernel/git/arnd/playground.git;\
> > a=shortlog;h=refs/heads/rcu-annotate-tip.

At first glance, this looks reasonably sane.  I have looked up through
the "scheduler: __rcu annotations" commit.

Some comments:

o	The name rcu_dereference_const() makes more sense to me than
	does __rcu_dereference(), as it documents when you can safely
	use it -- when something is preventing the RCU-protected
	pointer in question from changing.

o	Uses of __rcu_dereference() in your playground.git that are
	safe because some lock is held should be changed to
	rcu_dereference_check(), mentioning that lock.  Ditto zero
	reference counts.

	For example, in your first change to put_ctx() in
	kernel/perf_event.c, the:

		put_ctx(__rcu_dereference(ctx->parent_ctx));

	should instead be:

		put_ctx(rcu_dereference_check(ctx->parent_ctx,
					      ctx->refcount == 0));

	This does take a bit more space, but very clearly documents
	the synchronization design and enables the combination of
	sparse and lockdep to enforce it.  And yes, this example has
	the "if" right above the use, but many other cases are not
	so easy to see so quickly.  And a future change might well
	rearrange the code so that the "if" is a long ways away from
	the dereference.

o	Whatever we choose for the name of what is __rcu_dereference()
	in your tree, uses should be commented, just as things like
	smp_mb() are commented.  For example:

		q = __rcu_dereference(p->next); /* Initialization. */

	to indicate that the structure is still being initialized so
	that no other CPU or task has access to it.

Again, looks promising!

							Thanx, Paul

> > Should we merge the simple annotations in this merge window and
> > then think about rculist and trees separately?
> 
> I haven't given up on the possibility of getting the whole thing into
> this merge window, but if that is not possible, it would be good to
> start on the annotations.  Of course, the annotations would need to be
> done so that they don't rain false positives on people who are not
> actively looking to see them.
> 
> 							Thanx, Paul
