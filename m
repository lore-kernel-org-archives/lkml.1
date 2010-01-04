Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532Ab0ADP4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab0ADP4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 10:56:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463Ab0ADP4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 10:56:06 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60216 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441Ab0ADP4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 10:56:04 -0500
Date: Mon, 4 Jan 2010 07:55:59 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org, "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH] asynchronous page fault.
Message-ID: <20100104155559.GA6748@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091225105140.263180e8.kamezawa.hiroyu@jp.fujitsu.com> <1261915391.15854.31.camel@laptop> <20091228093606.9f2e666c.kamezawa.hiroyu@jp.fujitsu.com> <1261989047.7135.3.camel@laptop> <27db4d47e5a95e7a85942c0278892467.squirrel@webmail-b.css.fujitsu.com> <1261996258.7135.67.camel@laptop> <1261996841.7135.69.camel@laptop> <1262448844.6408.93.camel@laptop> <20100104030234.GF32568@linux.vnet.ibm.com> <1262591604.4375.4075.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262591604.4375.4075.camel@twins>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 04, 2010 at 08:53:23AM +0100, Peter Zijlstra wrote:
> On Sun, 2010-01-03 at 19:02 -0800, Paul E. McKenney wrote:
> > It would not be all that hard for me to make a call_srcu(), but...
> > 
> > 1.      How are you avoiding OOM by SRCU callback?  (I am sure you
> >         have this worked out, but I do have to ask!)
> 
> Well, I was thinking srcu to have this force quiescent state in
> call_srcu() much like you did for the preemptible rcu.

Ah, so the idea would be that you register a function with the srcu_struct
that is invoked when some readers are stuck for too long in their SRCU
read-side critical sections?  Presumably you also supply a time value for
"too long" as well.  Hmmm...  What do you do, cancel the corresponding
I/O or something?

This would not be hard once I get SRCU folded into the treercu
infrastructure.  However, at the moment, SRCU has no way of tracking
which tasks are holding things up.  So not 2.6.34 material, but definitely
doable longer term.

> Alternatively we could actively throttle the call_srcu() call when we've
> got too much pending work.

This could be done with the existing SRCU implementation.  This could be
a call to a function you registered.  In theory, it would be possible
to make call_srcu() refuse to enqueue a callback when there were too
many, but that really badly violates the spirit of the call_rcu() family
of functions.

> > 2.      How many srcu_struct data structures are you envisioning?
> >         One globally?  One per process?  One per struct vma?
> >         (Not necessary to know this for call_srcu(), but will be needed
> >         as I work out how to make SRCU scale with large numbers of CPUs.)
> 
> For this patch in particular, one global one, covering all vmas.

Whew!!!  ;-)

Then it would still be feasible for the CPU-hotplug code to scan all
SRCU structures, if need be.  (The reason that SRCU gets away without
worrying about CPU hotplug now is that it doesn't keep track of which
tasks are in read-side critical sections.)

> One reason to keep the vma RCU domain separate from other RCU objects is
> that these VMA thingies can have rather long quiescent periods due to
> this sleep stuff. So mixing that in with other RCU users which have much
> better defined periods will just degrade everything bringing that OOM
> scenario much closer.

Fair enough!

							Thanx, Paul
