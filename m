Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab0BARf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 12:35:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752327Ab0BARfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 12:35:24 -0500
Date: Mon, 1 Feb 2010 09:34:18 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Steven Rostedt <rostedt@goodmis.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [patch 2/3] scheduler: add full memory barriers upon task switch
 at runqueue lock/unlock
In-Reply-To: <1265044392.29013.61.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.1002010926410.4206@localhost.localdomain>
References: <20100131205254.407214951@polymtl.ca>  <20100131210013.446503342@polymtl.ca>  <alpine.LFD.2.00.1002010722350.4206@localhost.localdomain>  <20100201160929.GA3032@Krystal>  <alpine.LFD.2.00.1002010816030.4206@localhost.localdomain> 
 <20100201164856.GA3486@Krystal> <1265044392.29013.61.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Feb 2010, Steven Rostedt wrote:

> On Mon, 2010-02-01 at 11:48 -0500, Mathieu Desnoyers wrote:
> 
> > What we have to be careful about here is that it's not enough to just
> > rely on switch_mm() containing a memory barrier. What we really need to
> > enforce is that switch_mm() issues memory barriers both _before_ and
> > _after_ mm_cpumask modification. The "after" part is usually dealt with
> > by the TLB context switch, but the "before" part usually isn't.
> 
> Then we add a smp_mb__before_clear_bit() in the switch_mm() on all archs
> that do not have clear_bit imply a smp_mb().

No. I want to get an _explanation_ first.

And no, "I want to do user-level RCU and I'm looking at mm_cpumask" is not 
an explanation.

In order to explain memory ordering rules, you need to actually show the 
actual accesses on the different cpu's and the ordering requirements 
between them, and explain them. IOW, you need to show

	thread1			thread2
	-------			-------

	some-particular-memop
				mm_cpumask access
	memory barrier
				memory barrier
	mm_cpumask access
				some-particular-memop	
	memory barrier

	some-other-particular-memop

and explain exactly why the memory barriers are needed.

In particular, now I've heard the INSANE statement that we need

  "memory barriers both _before_ and _after_ mm_cpumask modification."

and people need to realize that such statements are totally worthless. 

The fact is, a memory barrier with regards to a single location 
modification makes no sense. Not before, not after. Putting a barrier 
around a single access (even if that "single" access is then a 
read-modify-read one) is a meaningless operation - it has _zero_ semantic 
information.

Memory barriers need to be _between_ two operations, and even then they 
never make sense on their own - you need to have another actor that also 
has a memory barrier, and that you are ordering things with regards to.

Saying that they are "around" one operation is crazy talk. It's a 
nonsensical statement. It shows a total lack of understanding of what a 
barrier is about. You can't put a barrier 'around' anything at all.

So before we go any further, I want to see the graph of barriers AND THE 
THINGS THEY ARE BARRIERS BETWEEN. On both sides. I want to know that you 
guys even know _what_ you are protecting against, and I want it documented 
so that when people say "this would solve it", they can show that yes, you 
actually need barriers at both points.

			Linus
