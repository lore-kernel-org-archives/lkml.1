Return-Path: <linux-kernel-owner+w=401wt.eu-S934513AbZLPCJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934513AbZLPCJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 21:09:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934489AbZLPCI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 21:08:59 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43236 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934483AbZLPCI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 21:08:58 -0500
Date: Tue, 15 Dec 2009 18:08:55 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH RFC tip/core/rcu 18/18] rcu: add primitives to check
	for RCU read-side critical sections
Message-ID: <20091216020855.GI6783@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091215230213.GA9093@linux.vnet.ibm.com> <20091216010439.GD2408@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216010439.GD2408@feather>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 05:04:39PM -0800, Josh Triplett wrote:
> On Tue, Dec 15, 2009 at 03:02:41PM -0800, Paul E. McKenney wrote:
> > From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Proposed for 2.6.34, not for inclusion.
> > 
> > Create rcu_read_lock_held(), rcu_read_lock_bh_held(),
> > rcu_read_lock_sched_held(), and srcu_read_lock_held() primitives that
> > return non-zero if there might be the corresponding type of RCU read-side
> > critical section in effect at the time that they are invoked.  If there is
> > doubt, they report being in the critical section.  They give exact
> > answers if CONFIG_PROVE_LOCKING.
> > 
> > Also create rcu_dereference_check(), which takes a second boolean argument
> > into which one puts rcu_read_lock_held() or similar.  For example:
> > 
> > 	rcu_dereference_check(gp, rcu_read_lock_held() ||
> > 				  lockdep_is_held(my_lock));
> 
> Useful for the case where you do have an additional lock, but it seems
> like it would help to have variants for the most common cases;
> specifically:
> rcu_dereference_check(thing, rcu_read_lock_held())
> rcu_dereference_check(thing, rcu_read_lock_bh_held())
> and so on.

I figured that I would try applying rcu_dereference_check() to a few
places and see what the most common variants really are.  I briefly
considered defining the set, but choked on the possibility of code
that might be executed from within several different variants of RCU,
so decided to start with the single general-purpose variant.

> Even then, it seems painful to have to annotate each rcu_dereference.
> Ideally, I'd propose the reverse: annotate any rcu_dereference which
> *can* occur outside an RCU read-side critical section.  (Variants of RCU
> notwithstanding...)

I was completely with you to start with, but...

Peter Zijlstra reminded me that his earlier foray into this space turned
up a number of situations where the code containing rcu_dereference()
simply cannot know which combinations of locks and/or RCU flavors should
be in effect.  One example of this is the RCU-protected trie, which -can-
be RCU-protected on read, but -also- can be used with locks.  And each
caller of course would supply a different lock.

I would not be surprised to find that we end up wanting a shorthand
for rcu_dereference_check(thing, rcu_read_lock_held()), but am less sure
about the others.

							Thanx, Paul

PS. And thank you for looking these over!
