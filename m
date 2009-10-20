Return-Path: <linux-kernel-owner+w=401wt.eu-S1751864AbZJTWH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbZJTWH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 18:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZJTWH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 18:07:26 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59366 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbZJTWHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 18:07:25 -0400
Date: Tue, 20 Oct 2009 15:07:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel RCU: shrink the size of the struct rcu_head
Message-ID: <20091020220728.GA6174@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091018232918.GA7385@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091018232918.GA7385@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 18, 2009 at 07:29:18PM -0400, Mathieu Desnoyers wrote:
> Hi Paul,
> 
> I noticed that you already discussed the possibility of shrinking the
> struct rcu_head by removing the function pointer.
> (http://kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html)
> 
> The ideas brought in so far require having per-callback lists, which
> involves a bit of management overhead and don't permit keeping the
> call_rcu() in cpu order.

But please note that this is on the "Possibly Dubious Changes" list.  ;-)

> You might want to look into the Userspace RCU urcu-defer.c
> implementation, where I perform pointer encoding to compact the usual
> case, expected to be the same callback passed as parameter multiple
> times in a row to call_rcu(). This is very typical with multiple free()
> calls for different data structures next to each other.
> 
> This typically keeps the size of the information to encode per callback
> down to a minimum: the size of a single pointer. It would be good to
> trace the kernel usage of call_rcu() to see if my assumption holds.
> 
> I just thought I should tell you before you start looking at this
> issue further.

So the idea is to maintain a per-CPU queue of function pointers, but
with the pointers on this queue encoded to save space, correct?  If I
understand correctly, the user-level rcu-defer implementation relies on
the following:

1.	It is illegal to call _rcu_defer_queue() within an RCU read-side
	critical section (due to the call to rcu_defer_barrier_thread()
	which in turn calls synchronize_rcu().  This is necessary to
	handle queue overflow.  (Which appears to be why you introduce
	a new API, as it is legal to invoke call_rcu() from within an
	RCU read-side critical section.)

2.	It is OK to wait for a grace period when a thread calls
	rcu_defer_unregister_thread() while exiting.  In the kernel,
	this is roughly equivalent to the CPU_DYING notifier, which
	cannot block, thus cannot wait for a grace period.

	I could imagine copying the per-CPU buffer somewhere, though
	my experience with the RCU/CPU-hotplug interface does not
	encourage me in this direction.  ;-)

							Thanx, Paul
