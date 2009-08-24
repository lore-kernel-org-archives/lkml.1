Return-Path: <linux-kernel-owner+w=401wt.eu-S1752757AbZHXP7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbZHXP7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 11:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbZHXP7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 11:59:12 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58575 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbZHXP7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 11:59:11 -0400
Date: Mon, 24 Aug 2009 08:59:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josht@linux.vnet.ibm.com,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       rostedt@goodmis.org
Subject: Re: [PATCH RFC -tip 0/4] v3 RCU cleanups and simplified
	preemptable RCU
Message-ID: <20090824155910.GF6677@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090727181401.GA14120@linux.vnet.ibm.com> <1251098519.7538.139.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251098519.7538.139.camel@twins>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 09:21:59AM +0200, Peter Zijlstra wrote:
> On Sat, 2009-08-22 at 13:52 -0700, Paul E. McKenney wrote:
> > 
> > o       Rename variables and functions so that RCU-sched is an
> >         underlying definition, along with RCU-bh and (when so
> >         configured) RCU-preempt.  RCU then maps to either RCU-sched
> >         or RCU-preempt, depending on configuration.
> 
> Nice, but we're not quite there yet it seems, since RCU-preempt isn't
> available outside of TREE_PREEMPT_RCU afaiks.
> 
> That is, I'm still hoping for the day that generic code can do:
> 
>   rcu_preempt_read_lock();
> 
> 
>   call_rcu_preempt(&my_rcu_thing);
>   rcu_preempt_read_unlock();
> 
> And have it work like expected, this would, I think, remove much of the
> need for SRCU.

Longer term, CONFIG_PREEMPT will imply CONFIG_TREE_PREEMPT_RCU and
!CONFIG_PREEMPT will imply CONFIG_TREE_RCU.  This will reduce the
number of combinations in need of testing.  So then the question is
"what does call_rcu_preempt() mean in !CONFIG_PREEMPT"?

If we permit things like mutex_lock(), we have the possibility of
indefinitely extended RCU read-side critical sections, which leads us to:

> The thing I've talked about earlier is an extension of this where you
> can create multiple RCU domains along the lines of:
> 
>   struct rcu_preempt_domain my_domain;
> 
>   rcu_preempt_init(&my_domain);
> 
> 
> and
> 
>   rcu_preempt_read_lock(&my_domain);
> 
>   call_rcu_preempt(&my_domain, &my_rcu_head);
>   rcu_preempt_read_unlock(&my_domain);

This is in fact what SRCU does.  Of course, it also requires
that the return value from rcu_preempt_read_lock() be passed into
rcu_preempt_read_unlock() (AKA srcu_read_lock() and srcu_read_unlock()),
in order to handle the case where there are a number of nested SRCU
read-side critical sections with different domains.  I suppose that we
could instead dynamically allocate space for this information, but...

> Which would allow you to create smaller RCU domains for when you want
> faster grace periods due to less interference of other rcu users.

The other thing in -tip for this purpose is synchronize_rcu_expedited().

> Anyway, enough rambling, the patch-set does look very nice, and if time
> permits I'll try and go through the preempt-tree-rcu thing.

I would very much appreciate that!!!  My next patch set (hopefully later
today Pacific time) will fix CPU hotplug for the single-node-tree case,
with full support later this week.

							Thanx, Paul
