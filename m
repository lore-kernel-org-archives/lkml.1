Return-Path: <linux-kernel-owner+w=401wt.eu-S933335AbZLPKdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933335AbZLPKdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 05:33:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbZLPKdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 05:33:44 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58255 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbZLPKdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 05:33:43 -0500
Subject: Re: [PATCH RFC tip/core/rcu 15/18] rcu: give different levels of
 the rcu_node hierarchy distinct lockdep names
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
In-Reply-To: <1260959160.17860.39.camel@laptop>
References: <20091215230213.GA9093@linux.vnet.ibm.com>
	 <12609181611666-git-send-email->  <1260959160.17860.39.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Dec 2009 11:33:06 +0100
Message-ID: <1260959586.17860.50.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 11:26 +0100, Peter Zijlstra wrote:
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

An even better option:

 BUILD_BUG_ON(MAX_RCU_LVLS > array_size(buf));

That way it'll fail to even build when these two get out of whack.

