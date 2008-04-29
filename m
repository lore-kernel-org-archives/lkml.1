Return-Path: <linux-kernel-owner+w=401wt.eu-S1763066AbYD2NNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763066AbYD2NNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756228AbYD2NN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:13:26 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:49232 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828AbYD2NNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:13:25 -0400
Date: Tue, 29 Apr 2008 17:13:22 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <npiggin@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: futex code and barriers
Message-ID: <20080429131322.GB128@tv-sign.ru>
References: <1209470236.13978.55.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209470236.13978.55.camel@twins>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29, Peter Zijlstra wrote:
> Hi All,
> 
> While looking through the futex code I stumbled upon the following bit:
> 
> kernel/futex.c:
> 
> 	/* add_wait_queue is the barrier after __set_current_state. */

As for me, the comment is very confusing at least.

> 	__set_current_state(TASK_INTERRUPTIBLE);
> 	add_wait_queue(&q.waiters, &wait);

Not sure I understand this code, but probably it is correct.

Yes, add_wait_queue() is not a barrier, and both __set_current_state()
and the "!plist_node_empty()" check below can leak into the
add_wait_queue's critical section.

But wake_futex()->wake_up_all() has to lock/unlock the same q->lock,
so I think we can't miss the event.

IOW, when wake_futex()->wake_up_all() takes q->lock, it must see
TASK_INTERRUPTIBLE.

If wake_futex() takes q->lock before us, we must see the result
of plist_del() after add_wait_queue() (more precisely, after
add_wait_queue()->spin_lock(q->lock).

But I'd like to know maintainer's opinion, I don't trust myself ;)

Oleg.

