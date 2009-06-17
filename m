Return-Path: <linux-kernel-owner+w=401wt.eu-S933401AbZFQM3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933401AbZFQM3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 08:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933279AbZFQM2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 08:28:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:57532 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933247AbZFQM2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 08:28:50 -0400
Subject: Re: [PATCH] TOMOYO: Add garbage collector support. (v3)
From: Peter Zijlstra <peterz@infradead.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200906172019.EAE00032.OLOJFQVMtFOFSH@I-love.SAKURA.ne.jp>
References: <200906172019.EAE00032.OLOJFQVMtFOFSH@I-love.SAKURA.ne.jp>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 14:28:43 +0200
Message-Id: <1245241723.6704.10.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 20:19 +0900, Tetsuo Handa wrote:
> Paul E. McKenney wrote ( http://lkml.org/lkml/2009/5/27/2 ) :
> > I would also recommend the three-part LWN series as a starting point:
> > 
> > #       http://lwn.net/Articles/262464/ (What is RCU, Fundamentally?)
> > #       http://lwn.net/Articles/263130/ (What is RCU's Usage?)
> > #       http://lwn.net/Articles/264090/ (What is RCU's API?)
> I've read these articles. They are very good.
> 
> I came up with an idea that we may be able to implement GC while readers are
> permitted to sleep but no read locks are required.
> 
> The idea is to have two counters which hold the number of readers currently
> reading the list, one is active and the other is inactive. Reader increments
> the currently active counter before starts reading and decrements that counter
> after finished reading. GC swaps active counter and inactive counter and waits
> for previously active counter's count to become 0 before releasing elements
> removed from the list.
> Code is shown below.
> 
> atomic_t users_counter[2];
> atomic_t users_counter_idx;
> DEFINE_MUTEX(updator_mutex);
> DEFINE_MUTEX(gc_mutex);

Sounds like an utter scalability nightmare to me though.

Why not 'simply' use SRCU or always provide an preemptible RCU domain
using:

rcu_read_lock_preempt()
rcu_read_unlock_preempt()
call_rcu_preempt()
etc.

along with the already existing

*{,_bh,_sched} variants

That way PREEMPT_RCU would only affect the implementation of the regular
RCU implementation, it being either _sched or _preempt.

