Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518Ab0AURBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab0AURBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 12:01:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948Ab0AURBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 12:01:13 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:55244 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752700Ab0AURBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 12:01:13 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArEEAGsSWEuuWOiG/2dsb2JhbACBRthUgjGCCwQ
Date: Thu, 21 Jan 2010 12:01:09 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier (v5)
Message-ID: <20100121170109.GB15761@Krystal>
References: <1263488625.4244.333.camel@laptop> <20100114175449.GA15387@Krystal> <20100114183739.GA18435@Krystal> <1263495132.28171.3861.camel@gandalf.stny.rr.com> <20100114193355.GA23436@Krystal> <1263926259.4283.757.camel@laptop> <1263928006.4283.762.camel@laptop> <1264073212.4283.1158.camel@laptop> <20100121160729.GB12842@Krystal> <1264090637.4283.1178.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1264090637.4283.1178.camel@laptop>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:22:59 up 36 days, 41 min,  5 users,  load average: 0.06, 0.19,
	0.18
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Thu, 2010-01-21 at 11:07 -0500, Mathieu Desnoyers wrote:
> > 
> > One efficient way to fit the requirement of sys_membarrier() would be to
> > create spin_lock_mb()/spin_unlock_mb(), which would have full memory
> > barriers rather than the acquire/release semantic. These could be used
> > within schedule() execution. On UP, they would turn into preempt off/on
> > and a compiler barrier, just like normal spin locks.
> > 
> > On architectures like x86, the atomic instructions already imply a full
> > memory barrier, so we have a direct mapping and no overhead. On
> > architecture where the spin lock only provides acquire semantic (e.g.
> > powerpc using lwsync and isync), then we would have to create an
> > alternate implementation with "sync". 
> 
> There's also clear_tsk_need_resched() which is an atomic op.

But clear_bit() only acts as a full memory barrier on x86 due to the
lock-prefix side-effect.

Ideally, if we add some kind of synchronization, it would be good to
piggy-back on spin lock/unlock, because these already identify
synchronization points (acquire/release semantic). It also surrounds the
scheduler execution. As we need memory barriers before and after the
data modification, this looks like a sane way to proceed: if data update
is protected by the spinlock, then we are sure that we have the matching
full memory barriers.

> 
> The thing I'm worrying about is not making schedule() more expensive for
> a relatively rare operation like sys_membarrier(), while at the same
> time trying to not make while (1) sys_membarrier() ruin your system.

Yep, I share your concern.

> 
> On x86 there is plenty that implies a full mb before rq->curr = next,
> the thing to figure out is what is generally the cheapest place to force
> one for other architectures.

Yep.

> 
> Not sure where that leaves us, since I'm not too familiar with !x86.
> 

As I proposed above, I think what we have to look for is: where do we
already have some weak memory barriers already required ? And then
upgrade these memory barriers to full memory barriers. The spinlock
approach is one possible solution.

The problem with piggy-backing on clear_flag/set_flag is that these
operations don't semantically imply memory barriers at all. So adding
an additional full mb() around these would be much more costly than
"upgrading" an already-existing barrier.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
