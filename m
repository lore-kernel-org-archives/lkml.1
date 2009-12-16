Return-Path: <linux-kernel-owner+w=401wt.eu-S934472AbZLPCAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934472AbZLPCAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 21:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934444AbZLPCAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 21:00:09 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54384 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934442AbZLPCAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 21:00:01 -0500
Date: Tue, 15 Dec 2009 17:59:54 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH RFC tip/core/rcu 15/18] rcu: give different levels of
	the rcu_node hierarchy distinct lockdep names
Message-ID: <20091216015954.GH6783@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091215230213.GA9093@linux.vnet.ibm.com> <20091216005959.GC2408@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216005959.GC2408@feather>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 04:59:59PM -0800, Josh Triplett wrote:
> On Tue, Dec 15, 2009 at 03:02:38PM -0800, Paul E. McKenney wrote:
> > From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Proposed for 2.6.34, not for inclusion.
> > 
> > Previously, each level of the rcu_node hierarchy had the same rather
> > unimaginative name: "&rcu_node_class[i]".  This makes lockdep diagnostics
> > involving these lockdep classes less helpful than would be nice.  This
> > patch fixes this by giving each level of the rcu_node hierarchy a distinct
> > name: "rcu_node_level_0", "rcu_node_level_1", and so on.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcutree.c |    9 ++++++++-
> >  1 files changed, 8 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index 0a4c328..a6e45f6 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -1811,11 +1811,17 @@ static void __init rcu_init_levelspread(struct rcu_state *rsp)
> >   */
> >  static void __init rcu_init_one(struct rcu_state *rsp)
> >  {
> > +	static char *buf[] = { "rcu_node_level_0",
> > +			       "rcu_node_level_1",
> > +			       "rcu_node_level_2",
> > +			       "rcu_node_level_3" };  /* Match MAX_RCU_LVLS */
> >  	int cpustride = 1;
> >  	int i;
> >  	int j;
> >  	struct rcu_node *rnp;
> >  
> > +	WARN_ON_ONCE(MAX_RCU_LVLS > 4);  /* Fix buf[] initialization! */
> > +
> 
> BUILD_BUG_ON seems better.  For that matter, please consider moving
> these near the rest of the level-specific defines, making them const,
> and ideally not emitting the strings for levels you don't have.

Good point, I had forgotten about BUILD_BUG_ON().  And reviewing its
definition, I can see why one might be motivated to forget.  ;-)

The reason I put the definition of buf[] here and the reason that I am not
worried about the memory it consumes is that this is an __init function,
so its memory should be reused once the system boots.  And if __init
does not apply to the static variables in a function, it should!  ;-)

							Thanx, Paul
