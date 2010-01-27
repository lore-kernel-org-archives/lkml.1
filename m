Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100Ab0A0KEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab0A0KEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 05:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748Ab0A0KEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 05:04:39 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41139 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab0A0KEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 05:04:38 -0500
Date: Wed, 27 Jan 2010 02:04:34 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
Subject: Re: [PATCH RFC tip/core/rcu] accelerate grace period if last
	non-dynticked CPU
Message-ID: <20100127100434.GN6807@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100125034816.GA14043@linux.vnet.ibm.com> <873a1sft9q.fsf@basil.nowhere.org> <20100127052050.GC6807@linux.vnet.ibm.com> <20100127094336.GA12522@basil.fritz.box> <1264585850.4283.1992.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264585850.4283.1992.camel@laptop>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 10:50:50AM +0100, Peter Zijlstra wrote:
> On Wed, 2010-01-27 at 10:43 +0100, Andi Kleen wrote:
> > 
> > Can't you simply check that at runtime then?
> > 
> > if (num_possible_cpus() > 20) 
> >         ...
> > 
> > BTW the new small is large. This years high end desktop PC will come with 
> > upto 12 CPU threads. It would likely be challenging to find a good
> > number for 20 that holds up with the future. 
> 
> If only scalability were that easy :/
> 
> These massive core/thread count things are causing more problems as
> well, the cpus/node ratios are constantly growing, giving grief in the
> page allocator as well as other places that used to scale per node.
> 
> As to the current problem, the call_rcu() interface doesn't make a hard
> promise that the callback will be done on the same cpu, right? So why
> not simply move the callback list over to a more active cpu?

I could indeed do that.  However, there is nothing stopping the
more-active CPU from going into dynticks-idle mode between the time
that I decide to push the callback to it and the time I actually do
the pushing.  :-(

I considered pushing the callbacks to the orphanage, but that is a
global lock that I would rather not acquire on each dyntick-idle
transition.

This conversation is having the effect of making me much more comfortable
adding a kernel configuration parameter.  Might not have been the intent,
but there you have it!  ;-)

							Thanx, Paul
