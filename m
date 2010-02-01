Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab0BAPXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 10:23:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755085Ab0BAPXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 10:23:42 -0500
Date: Mon, 1 Feb 2010 07:22:01 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [patch 1/3] Create spin lock/spin unlock with distinct memory
 barrier
In-Reply-To: <20100131210013.265317204@polymtl.ca>
Message-ID: <alpine.LFD.2.00.1002010701270.4206@localhost.localdomain>
References: <20100131205254.407214951@polymtl.ca> <20100131210013.265317204@polymtl.ca>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 31 Jan 2010, Mathieu Desnoyers wrote:
>
> Create the primitive family:
> 
> spin_lock__no_acquire
> spin_unlock__no_release
> spin_lock_irq__no_acquire
> spin_unlock_irq__no_release

I really really hate this patch.

Locking is really hard to get right anyway, you already had one bug in 
this, and on the major architectures, none of this will matter _anyway_, 
since you cannot split the acquire from the lock and the release from the 
unlock.

So the only operation that actually makes any sense at all would be 
"smp_mb__after_spin_lock" (and no new spinlock primitives at all), since 
it can be optimized away on x86 (and then add "smp_mb__before_spin_unlock" 
just to make them symmetric). But even that one is very dubious:

  "The first user of these primitives is the scheduler code, where a full 
   memory barrier is wanted before and after runqueue data structure 
   modifications so these can be read safely by sys_membarrier without 
   holding the rq lock."

what kind of crazy model is this? That sounds insane. Locking together 
with some new random optimistic usage that we don't even know how 
performance-critical it is? Mixing locking and non-locking is simply 
wrong. Why would it be any safer to read whatever that the lock protects 
by adding smp barriers at the lock?

If you need other smp barriers at the lock, then what about the non-locked 
accesses _while_ the lock is held? You get no ordering guarantees there. 
The whole thing sounds highly dubious. 

And all of this for something that is a new system call that nobody 
actually uses? To optimize the new and experimental path with some insane 
lockfree model, while making the core kernel more complex?  A _very_ 
strong NAK from me.

			Linus
