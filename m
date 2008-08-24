Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbYHXCoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbYHXCoS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 22:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbYHXCoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 22:44:08 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:36931 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbYHXCoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 22:44:06 -0400
Date: Sat, 23 Aug 2008 19:44:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org,
       akpm@linux-foundation.org, manfred@colorfullife.com,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, schamp@sgi.com,
       niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org
Subject: Re: [PATCH, RFC, tip/core/rcu] scalable classic RCU implementation
Message-ID: <20080824024406.GC6851@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080822043715.GD15212@elte.hu> <20080822134720.GG6875@linux.vnet.ibm.com> <20080822172221.GA9593@linux.vnet.ibm.com> <20080823160735.GC27974@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080823160735.GC27974@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2008 at 06:07:35PM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Is this a sufficient improvement?
> 
> yeah - looks much better. This was the block that meets the eye for the 
> first time in the patch so it stuck out.
> 
> just one more small pet peeve of mine: please use vertical alignment too 
> to improve readability. Instead of:
> 
> > #define MAX_RCU_LEVELS 3
> > #define RCU_FANOUT (CONFIG_RCU_FANOUT)
> > #define RCU_FANOUT_SQ (RCU_FANOUT * RCU_FANOUT)
> > #define RCU_FANOUT_CUBE (RCU_FANOUT_SQ * RCU_FANOUT)
> 
> this looks a bit more structured IMO:
> 
> > #define MAX_RCU_LEVELS	3
> > #define RCU_FANOUT		(CONFIG_RCU_FANOUT)
> > #define RCU_FANOUT_SQ		(RCU_FANOUT * RCU_FANOUT)
> > #define RCU_FANOUT_CUBE	(RCU_FANOUT_SQ * RCU_FANOUT)

Good point, fixed.

> maybe even this:
> 
> > #if (NR_CPUS) <= RCU_FANOUT
> > #  define NUM_RCU_LVLS	1
> > #  define NUM_RCU_LVL_0	1
> > #  define NUM_RCU_LVL_1	(NR_CPUS)
> > #  define NUM_RCU_LVL_2	0
> > #  define NUM_RCU_LVL_3	0
> > #elif (NR_CPUS) <= RCU_FANOUT_SQ
> > #  define NUM_RCU_LVLS	2
> > #  define NUM_RCU_LVL_0	1
> > #  define NUM_RCU_LVL_1	(((NR_CPUS) + RCU_FANOUT - 1) / RCU_FANOUT)
> > #  define NUM_RCU_LVL_2	(NR_CPUS)
> > #  define NUM_RCU_LVL_3	0
> > #elif (NR_CPUS) <= RCU_FANOUT_CUBE
> > #  define NUM_RCU_LVLS	3
> > #  define NUM_RCU_LVL_0	1
> > #  define NUM_RCU_LVL_1	(((NR_CPUS) + RCU_FANOUT_SQ - 1) / RCU_FANOUT_SQ)
> > #  define NUM_RCU_LVL_2	(((NR_CPUS) + (RCU_FANOUT) - 1) / (RCU_FANOUT))
> > #  define NUM_RCU_LVL_3	NR_CPUS
> > #else
> > # error "CONFIG_RCU_FANOUT insufficient for NR_CPUS"
> > #endif /* #if (NR_CPUS) <= RCU_FANOUT */
> 
> but no strong feelings on that one. (maybe inserting a space at the 
> right places helps too, no need for a full tab)

Yep, just like you, spaced it just enough to keep the longest one from
running over one line.  ;-)

I left the definitions for RCU_SUM and NUM_RCU_NODES compact, though:

#define RCU_SUM (NUM_RCU_LVL_0 + NUM_RCU_LVL_1 + NUM_RCU_LVL_2 + NUM_RCU_LVL_3)
#define NUM_RCU_NODES (RCU_SUM - NR_CPUS)

The other alternative would be to stack RCU_SUM as follows:

#define RCU_SUM		      (NUM_RCU_LVL_0 + NUM_RCU_LVL_1 + \
			       NUM_RCU_LVL_2 + NUM_RCU_LVL_3)

which seemed to me to add more ugly than enlightenment.

Testing is going well.  Having to occasionally restrain myself to keep
from going full-bore for 4096 CPU optimality -- but have to keep it
simple until/unless someone with that large of a machine shows where
improvements are needed.

							Thanx, Paul
