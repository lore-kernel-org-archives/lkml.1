Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbYFUT1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbYFUT1K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 15:27:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbYFUT0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 15:26:55 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:41344 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbYFUT0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 15:26:54 -0400
Date: Sat, 21 Jun 2008 12:26:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH]rcu,alpha: avoid smp_read_barrier_depends in rcu_dereference when pointer==NULL
Message-ID: <20080621192646.GA22569@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <485CCFB9.9050208@cn.fujitsu.com> <1214052746.3223.218.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214052746.3223.218.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2008 at 02:52:25PM +0200, Peter Zijlstra wrote:
> On Sat, 2008-06-21 at 17:54 +0800, Lai Jiangshan wrote:
> > Hi, Paul and Alpha hackers
> > 
> > memory barrier is expensive, I think it's worth that adding an if-statement
> > to avoid it when pointer == NULL.
> > 
> > This patch change nothing in UP or in other architectures for compiler's
> > optimization.
> 
> I suspect this optimization is invalid in the case where the loaded
> value is used as an offset (either pointer or array index). But I'm
> afraid I'll have to defer to Paul for explanations..

What Peter said!

There are cases where the argument to rcu_dereference() is an array
index rather than a pointer.  In that case, zero is a perfectly valid
array index and requires a memory barrier on Alpha.  Given that the
smp_read_barrier_depends() primitive is very nearly (but not quite)
a no-op on non-Alpha machines, it will also be necessary to carefully
check the generated code to make sure that we are not slowing down the
common non-Alpha machines to help out the very rare Alpha machines.

Some months ago, we attempted to add a similar check to
rcu_assign_pointer(), but we were unable to find an approach that handled
all the cases currently in the Linux kernel, even when we introduced a
special-case primitive for array indexes.  Please note that we did not
prove it impossible, but rather decided that it was consuming more time
and energy than was warranted.

							Thanx, Paul

PS.  I have not forgotten about your earlier patch to the list structures
     used by classic RCU -- but I am still curious to know the results
     of the more-harsh testing that I suggested.

> > 			Thanks, Lai Jiangshan
> > 
> > 
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > ---
> > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > index d42dbec..8979f29 100644
> > --- a/include/linux/rcupdate.h
> > +++ b/include/linux/rcupdate.h
> > @@ -143,7 +143,8 @@ struct rcu_head {
> >  
> >  #define rcu_dereference(p)     ({ \
> >  				typeof(p) _________p1 = ACCESS_ONCE(p); \
> > -				smp_read_barrier_depends(); \
> > +				if (_________p1) \
> > +					smp_read_barrier_depends(); \
> >  				(_________p1); \
> >  				})
> >  
> > 
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
