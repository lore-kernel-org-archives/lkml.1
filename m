Return-Path: <linux-kernel-owner+w=401wt.eu-S1763496AbYHFFhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763496AbYHFFhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 01:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYHFFaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 01:30:22 -0400
Received: from qb-out-0506.google.com ([72.14.204.235]:55858 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbYHFFaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 01:30:19 -0400
Message-ID: <489936E5.7020509@colorfullife.com>
Date: Wed, 06 Aug 2008 07:30:13 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       oleg@tv-sign.ru, dipankar@in.ibm.com, rostedt@goodmis.org,
       dvhltc@us.ibm.com, niv@us.ibm.com
Subject: Re: [PATCH tip/core/rcu] classic RCU locking and memory-barrier cleanups
References: <20080805162144.GA8297@linux.vnet.ibm.com>
In-Reply-To: <20080805162144.GA8297@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Paul E. McKenney wrote:
> This patch is in preparation for moving to a hierarchical
> algorithm to allow the very large SMP machines -- requested by some
> people at OLS, and there seem to have been a few recent patches in the
> 4096-CPU direction as well.

I thought about hierarchical RCU, but I never found the time to 
implement it.
Do you have a concept in mind?

Right now, I try to understand the current code first - and some of it 
doesn't make much sense.

There are three per-cpu lists:
->nxt
->cur
->done.

Obviously, there must be a quiescent state between cur and done.
But why does the code require a quiescent state between nxt and cur?
I think that's superflous. The only thing that is required is that all 
cpus have moved their callbacks from nxt to cur. That doesn't need a 
quiescent state, this operation could be done in hard interrupt as well.

Thus I think this should work:

1) A callback is inserted into ->nxt.
2) As soon as too many objects are sitting in the ->nxt lists, a new rcu 
cycle is started.
3) As soon as a cpu sees that a new rcu cycle is started, it moves it's 
callbacks from ->nxt to ->cur. No checks for hard_irq_count & friends 
necessary. Especially: same rule for _bh and normal.
4) As soon as all cpus have moved their lists from ->nxt to ->cur, the 
real grace period is started.
5) As soon as all cpus passed a quiescent state (i.e.: now with tests 
for hard_irq_count, different rules for _bh and normal), the list is 
moved from ->cur to ->completed. Once in completed, they can be 
destroyed by performing the callbacks.

What do you think? would that work? It doesn't make much sense that step 
3) tests for a quiescent state.

Step 2) could depend memory pressure.
Step 3) and 4) could be accelerated by force_quiescent_state(), if the 
memory pressure is too high.

--
    Manfred
-> nxt

