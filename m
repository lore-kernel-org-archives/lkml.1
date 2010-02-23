Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab0BWQQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 11:16:11 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:42540 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297Ab0BWQQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 11:16:09 -0500
Date: Tue, 23 Feb 2010 08:16:02 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 0/21] v6 add lockdep-based diagnostics to
	rcu_dereference()
Message-ID: <20100223161602.GD6700@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100223010435.GA666@linux.vnet.ibm.com> <201002231359.07910.arnd@arndb.de> <20100223131543.GA19174@Krystal> <201002231654.09724.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002231654.09724.arnd@arndb.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 04:54:09PM +0100, Arnd Bergmann wrote:
> On Tuesday 23 February 2010, Mathieu Desnoyers wrote:
> > Just to make myself the devil's advocate: how should we consider
> > initialization of RCU pointers at boot time that happens before any
> > possible concurrent reader is allowed to run ? I think this case is an
> > example of valid RCU-pointer access that is not done through the RCU
> > primitives. It seems valid to perform these RCU-pointer accesses when
> > serialized by a different exclusion mechanism, in this case being the
> > guarantee that no concurrent reader are running at early boot.
> 
> Like the annotations adding __rcu to each rcu protected pointer, we'd
> also have to add annotations to static initialization of those. E.g.
> something like 
> 
> #define DEFINE_RCU_VAR(type, name, pointer) \
> 	type __rcu *name = (__force type)pointer
> 
> should do for simple initializations, and I guess I can come up
> with similar solutions if we need something more fancy.

We would also need something for initialization of structure fields.
Does __force work in that case as well?

> > The same applies to stop_machine(), and, as I come to think of it, we could
> > probably think of a scheme that dynamically switch from an RCU read-lock
> > to, e.g., a mutex for all users, wait for RCU quiescent state, and then
> > serialize all users on the mutex during the update. So while some of
> > these cases are a bit far-fetched, I think they are valid, and I wonder
> > how the address space validation would take them into account.
> 
> I assume that it's never wrong to do a pointer assignment using
> rcu_assign_pointer, or to do a dereference using rcu_dereference,
> even if you hold a mutex or stop_machine. I would also guess that
> the performance impact of doing so is not measurable. If both are
> true for all corner cases, we could just use the rcu primitives
> for any access on those variables for consistency reasons.

Seems like a good default position, but please see below.

> If there are cases where it does not work, we need to come up with
> names for new primitives that just do the assignment or dereference
> with __force but no actual synchronization.

Some data structures are shared by RCU and non-RCU code, with struct
list_head being the most prominent example.  Making the "next" pointer
as __rcu might be OK, but there are a -lot- of non-RCU uses of struct
list_head.  Would we really want to introduce rcu_dereference() to all
non-RCU list-traversal primitives, or do we need to do something else?

							Thanx, Paul
