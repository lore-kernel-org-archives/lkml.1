Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbYHVRWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbYHVRWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 13:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbYHVRWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 13:22:31 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:52336 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbYHVRWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 13:22:30 -0400
Date: Fri, 22 Aug 2008 10:22:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org,
       akpm@linux-foundation.org, manfred@colorfullife.com,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, schamp@sgi.com,
       niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org
Subject: Re: [PATCH, RFC, tip/core/rcu] scalable classic RCU implementation
Message-ID: <20080822172221.GA9593@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080822043715.GD15212@elte.hu> <20080822134720.GG6875@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822134720.GG6875@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 06:47:20AM -0700, Paul E. McKenney wrote:
> On Fri, Aug 22, 2008 at 06:37:15AM +0200, Ingo Molnar wrote:
> > 
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > +#define MAX_RCU_LEVELS 3
> > > +#if NR_CPUS <= CONFIG_RCU_FANOUT
> > > +#define NUM_RCU_LEVELS 1
> > > +#define NUM_RCU_LEVEL_1 1
> > > +#define NUM_RCU_LEVEL_2 NR_CPUS
> > > +#define NUM_RCU_LEVEL_3 0
> > > +#define NUM_RCU_LEVEL_4 0
> > > +#define NUM_RCU_NODES NUM_RCU_LEVEL_1
> > > +#elif NR_CPUS <= CONFIG_RCU_FANOUT * CONFIG_RCU_FANOUT
> > > +#define NUM_RCU_LEVELS 2
> > > +#define NUM_RCU_LEVEL_1 1
> > > +#define NUM_RCU_LEVEL_2 \
> > > +	(((NR_CPUS) + (CONFIG_RCU_FANOUT) - 1) / (CONFIG_RCU_FANOUT))
> > > +#define NUM_RCU_LEVEL_3 NR_CPUS
> > > +#define NUM_RCU_LEVEL_4 0
> > > +#define NUM_RCU_NODES \
> > > +	((NUM_RCU_LEVEL_1) + (NUM_RCU_LEVEL_2))
> > > +#elif NR_CPUS <= CONFIG_RCU_FANOUT * CONFIG_RCU_FANOUT * CONFIG_RCU_FANOUT
> > > +#define NUM_RCU_LEVELS 3
> > > +#define RCU_FANOUT_SQ ((CONFIG_RCU_FANOUT) * (CONFIG_RCU_FANOUT))
> > > +#define NUM_RCU_LEVEL_1 1
> > > +#define NUM_RCU_LEVEL_2 \
> > > +	(((NR_CPUS) + (RCU_FANOUT_SQ) - 1) / (RCU_FANOUT_SQ))
> > > +#define NUM_RCU_LEVEL_3 \
> > > +	((NR_CPUS) + (CONFIG_RCU_FANOUT) - 1) / (CONFIG_RCU_FANOUT)
> > > +#define NUM_RCU_LEVEL_4 NR_CPUS
> > > +#define NUM_RCU_NODES \
> > > +	((NUM_RCU_LEVEL_1) + \
> > > +	 (NUM_RCU_LEVEL_2) + \
> > > +	 (NUM_RCU_LEVEL_3))
> > > +#else
> > > +#error "CONFIG_RCU_FANOUT insufficient for NR_CPUS"
> > > +#endif
> > 
> > just a quick stylistic suggestion: if feasible then such sizing ugliness 
> > should be hidden in a Kconfig file. (if Kconfig is capable enough for 
> > this that is)
> 
> I have no idea if Kconfig can do it, but I will check.

OK, Kconfig does not currently support arithmetic, based on zconf.y:

expr:	  symbol				{ $$ = expr_alloc_symbol($1); }
	| symbol T_EQUAL symbol			{ $$ = expr_alloc_comp(E_EQUAL, $1, $3); }
	| symbol T_UNEQUAL symbol		{ $$ = expr_alloc_comp(E_UNEQUAL, $1, $3); }
	| T_OPEN_PAREN expr T_CLOSE_PAREN	{ $$ = $2; }
	| T_NOT expr				{ $$ = expr_alloc_one(E_NOT, $2); }
	| expr T_OR expr			{ $$ = expr_alloc_two(E_OR, $1, $3); }
	| expr T_AND expr			{ $$ = expr_alloc_two(E_AND, $1, $3); }
;

All we currently get is basic comparison and logical operators.  It would
not be all -that- hard to add general arithmetic (famous last words),
but when I tried mapping out what the sizing code would look like in
such an augmented Kconfig, it was even uglier than the above.

So I took a hard look at the current mess, and prettied it as shown below.
Is this a sufficient improvement?

Another alternative I am considering is moving this to a separate
include file.

Thoughts?

							Thanx, Paul

#define MAX_RCU_LEVELS 3
#define RCU_FANOUT (CONFIG_RCU_FANOUT)
#define RCU_FANOUT_SQ (RCU_FANOUT * RCU_FANOUT)
#define RCU_FANOUT_CUBE (RCU_FANOUT_SQ * RCU_FANOUT)

#if (NR_CPUS) <= RCU_FANOUT
#  define NUM_RCU_LVLS 1
#  define NUM_RCU_LVL_0 1
#  define NUM_RCU_LVL_1 (NR_CPUS)
#  define NUM_RCU_LVL_2 0
#  define NUM_RCU_LVL_3 0
#elif (NR_CPUS) <= RCU_FANOUT_SQ
#  define NUM_RCU_LVLS 2
#  define NUM_RCU_LVL_0 1
#  define NUM_RCU_LVL_1 (((NR_CPUS) + RCU_FANOUT - 1) / RCU_FANOUT)
#  define NUM_RCU_LVL_2 (NR_CPUS)
#  define NUM_RCU_LVL_3 0
#elif (NR_CPUS) <= RCU_FANOUT_CUBE
#  define NUM_RCU_LVLS 3
#  define NUM_RCU_LVL_0 1
#  define NUM_RCU_LVL_1 (((NR_CPUS) + RCU_FANOUT_SQ - 1) / RCU_FANOUT_SQ)
#  define NUM_RCU_LVL_2 (((NR_CPUS) + (RCU_FANOUT) - 1) / (RCU_FANOUT))
#  define NUM_RCU_LVL_3 NR_CPUS
#else
# error "CONFIG_RCU_FANOUT insufficient for NR_CPUS"
#endif /* #if (NR_CPUS) <= RCU_FANOUT */

#define RCU_SUM (NUM_RCU_LVL_0 + NUM_RCU_LVL_1 + NUM_RCU_LVL_2 + NUM_RCU_LVL_3)
#define NUM_RCU_NODES (RCU_SUM - NR_CPUS)
