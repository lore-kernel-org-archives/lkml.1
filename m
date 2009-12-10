Return-Path: <linux-kernel-owner+w=401wt.eu-S1759477AbZLJC21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759477AbZLJC21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 21:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759254AbZLJC2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 21:28:23 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35347 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759217AbZLJC2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 21:28:22 -0500
Date: Wed, 9 Dec 2009 18:28:25 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Dipankar Sarma <dipankar@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Al Viro <viro@zeniv.linux.org.uk>,
       James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/9] Fix various __task_cred related invalid RCU
	assumptions
Message-ID: <20091210022825.GG6938@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091210001308.247025548@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210001308.247025548@linutronix.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 12:52:46AM -0000, Thomas Gleixner wrote:
> While auditing the read_lock(&tasklist_lock) sites for a possible
> conversion to rcu-read_lock() I stumbled over an unprotected user of
> __task_cred in kernel/sys.c
> 
> That caused me to audit all the __task_cred usage sites except in
> kernel/exit.c.
> 
> Most of the usage sites are correct, but some of them trip over
> invalid assumptions about the protection which is given by RCU.
> 
> - spinlocked/preempt_disabled regions are equivalent to rcu_read_lock():
> 
>    That's wrong. RCU does not guarantee that. 
> 
>    It has been that way due to implementation details and it still is
>    valid for CONFIG_TREE_PREEMPT_RCU=n, but there is no guarantee that
>    this will be the case forever.

To back this up, item #2 from Documentation/RCU/checklist.txt says:

2.	Do the RCU read-side critical sections make proper use of
	rcu_read_lock() and friends?  These primitives are needed
	to prevent grace periods from ending prematurely, which
	could result in data being unceremoniously freed out from
	under your read-side code, which can greatly increase the
	actuarial risk of your kernel.

	As a rough rule of thumb, any dereference of an RCU-protected
	pointer must be covered by rcu_read_lock() or rcu_read_lock_bh()
	or by the appropriate update-side lock.

> - interrupt disabled regions are equivalent to rcu_read_lock():
> 
>   Wrong again. RCU does not guarantee that.
> 
>   It's true for current mainline, but again this is an implementation
>   detail and there is no guarantee by the RCU semantics.
> 
>   Indeed we want to get rid of that to avoid scalability issues on
>   large systems and preempt-rt got already rid of it to a certain
>   extent.

Same item #2 above covers this.

The only exception is when you use synchronize_sched(), as described
in the "Defer"/"Protect" list near line 323 of the 2.6.32 version of
Documentation/RCU/whatisRCU.txt:

	Defer			Protect

a.	synchronize_rcu()	rcu_read_lock() / rcu_read_unlock()
	call_rcu()

b.	call_rcu_bh()		rcu_read_lock_bh() / rcu_read_unlock_bh()

c.	synchronize_sched()	preempt_disable() / preempt_enable()
				local_irq_save() / local_irq_restore()
				hardirq enter / hardirq exit
				NMI enter / NMI exit

And yes, I need to update this based on the addition of
rcu_read_lock_sched() and friends.  I will be doing another
documentation update soon.

> I'm sure we are lucky that CONFIG_TREE_PREEMPT_RCU=y is not yet wide
> spread and the code pathes are esoteric enough not to trigger that
> subtle races (some of them might just error out silently).
> 
> Nevertheless we need to fix all invalid assumptions about RCU
> protection.

Agreed!!!

> The following patch series fixes all yet known affected __task_cred()
> sites, but there is more auditing of all other rcu users necessary.

Thank you very much for putting this series together -- I will take
a quick look at them.

							Thanx, Paul
