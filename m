Return-Path: <linux-kernel-owner+w=401wt.eu-S1758758AbZLPPNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758AbZLPPNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 10:13:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758632AbZLPPNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 10:13:51 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49002 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758620AbZLPPNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 10:13:51 -0500
Date: Wed, 16 Dec 2009 07:13:45 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH RFC tip/core/rcu 15/18] rcu: give different levels of
	the rcu_node hierarchy distinct lockdep names
Message-ID: <20091216151345.GB6744@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091215230213.GA9093@linux.vnet.ibm.com> <1260959160.17860.39.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260959160.17860.39.camel@laptop>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 11:26:00AM +0100, Peter Zijlstra wrote:
> On Tue, 2009-12-15 at 15:02 -0800, Paul E. McKenney wrote:
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
> 
> So you're going to WARN here,
> 
> >  	/* Initialize the level-tracking arrays. */
> >  
> >  	for (i = 1; i < NUM_RCU_LVLS; i++)
> > @@ -1829,7 +1835,8 @@ static void __init rcu_init_one(struct rcu_state *rsp)
> >  		rnp = rsp->level[i];
> >  		for (j = 0; j < rsp->levelcnt[i]; j++, rnp++) {
> >  			spin_lock_init(&rnp->lock);
> > -			lockdep_set_class(&rnp->lock, &rcu_node_class[i]);
> > +			lockdep_set_class_and_name(&rnp->lock,
> > +						   &rcu_node_class[i], buf[i]);
> 
> and segfault here because i overruns its bounds?

Might or might not, depending on memory layout.

> Might as well BUG_ON then.

I will give BUILD_BUG_ON() a try, but with the array size computed at
compile time as you suggest elsewhere.

							Thanx, Paul
