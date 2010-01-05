Return-Path: <linux-kernel-owner+w=401wt.eu-S1754414Ab0AECzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab0AECzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 21:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084Ab0AECzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 21:55:43 -0500
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:35718 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab0AECzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 21:55:43 -0500
Date: Mon, 4 Jan 2010 18:28:15 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 2/3] rcu: add debug check for too many
 rcu_read_unlock()
Message-ID: <20100105022814.GA11554@feather>
References: <20100105000337.GA23307@linux.vnet.ibm.com>
 <20100105020307.GB11286@feather>
 <20100105021919.GN6748@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105021919.GN6748@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 04, 2010 at 06:19:19PM -0800, Paul E. McKenney wrote:
> On Mon, Jan 04, 2010 at 06:03:08PM -0800, Josh Triplett wrote:
> > On Mon, Jan 04, 2010 at 04:04:01PM -0800, Paul E. McKenney wrote:
> > > From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > 
> > > TREE_PREEMPT_RCU maintains an rcu_read_lock_nesting counter in the
> > > task structure, which happens to be a signed int.  So this patch adds a
> > > check for this counter being negative at the end of __rcu_read_unlock().
> > > This check is under CONFIG_PROVE_LOCKING, so can be thought of as being
> > > part of lockdep.
> > > 
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > ---
> > >  kernel/rcutree_plugin.h |    3 +++
> > >  1 files changed, 3 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> > > index f11ebd4..e77cdf3 100644
> > > --- a/kernel/rcutree_plugin.h
> > > +++ b/kernel/rcutree_plugin.h
> > > @@ -304,6 +304,9 @@ void __rcu_read_unlock(void)
> > >  	if (--ACCESS_ONCE(t->rcu_read_lock_nesting) == 0 &&
> > >  	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
> > >  		rcu_read_unlock_special(t);
> > > +#ifdef CONFIG_PROVE_LOCKING
> > > +	WARN_ON_ONCE(ACCESS_ONCE(t->rcu_read_lock_nesting) < 0);
> > > +#endif /* #ifdef CONFIG_PROVE_LOCKING */
> > >  }
> > >  EXPORT_SYMBOL_GPL(__rcu_read_unlock);
> > 
> > Given that you *already* need to access t->rcu_read_lock_nesting here,
> > why not just do the test all the time?  Ideally you could access
> > t->rcu_read_lock_nesting once, decrement it, and test for both 0 and
> > negative.
> 
> Because I was paranoid about the extra branch.  Perhaps needlessly
> paranoid, but this is rcu_read_unlock() we are talking about here.  ;-)
> 
> You seem to be suggesting making the first test be "<=", then
> sorting things out later, but given that both the equals-zero and the
> greater-than-zero cases are quite common, I couldn't figure out how to
> avoid the extra test and branch in the common case.  Hence the #ifdef.

No, I think you could simply read the predecremented value into a local
variable, test it once with == 0, then have the WARN_ON_ONCE, and hope
that the compiler figures out it can just test the register once and
then do multiple jumps on the same flags.

You could try it and see what code it generates.

- Josh Triplett
