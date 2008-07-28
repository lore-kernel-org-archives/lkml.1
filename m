Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbYG1PNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbYG1PNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbYG1PNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:13:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:39169 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbYG1PNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:13:37 -0400
Subject: Re: [PATCH] RCU: implement rcu_read_[un]lock_preempt()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: dipankar@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <487D98AC.3020005@kernel.org>
References: <487AEAC6.60307@kernel.org> <1216188469.5232.0.camel@twins>
	 <487D98AC.3020005@kernel.org>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 17:13:21 +0200
Message-Id: <1217258001.18049.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-16 at 15:43 +0900, Tejun Heo wrote:
> Peter Zijlstra wrote:
> > On Mon, 2008-07-14 at 14:57 +0900, Tejun Heo wrote:
> >> With the introduction of preemptible RCU, RCU doesn't gurantee that
> >> its critical section runs on the CPU it started to run.  As there are
> >> cases where non-preemptible RCU critical section makes sense, create
> >> new RCU read lock variants which turns of preemption -
> >> rcu_read_[un]lock_preempt() which are identical to rcu_read_[un]lock()
> >> for classic implementation and have enclosing preempt disable/enable
> >> for preemptible RCU.
> >>
> >> Signed-off-by: Tejun Heo <tj@kernel.org>
> > 
> > Sorry, NAK.
> > 
> > If you need preempt off you need it for other reasons than RCU, so
> > mixing it in the interface doesn't make sense to me.
> 
> Hmmm... the point of the interface is avoiding doing double preemption
> operations as on common configurations rcu_read_lock() disables
> preemption.

Should be really cheap then, because the cacheline is already hot.

>   Yes, it's for different purposes but we have two partially
> overlapping ops and implementing combined / collapsed ops for such cases
> is acceptable, I think.

They only overlap for !PREEMPT_RCU || !PREEMPT_RT

> Using get_cpu() or separate preempt_disable() wouldn't incur noticeable
> performance difference as preemption is really cheap to manipulate but
> both per-cpu and RCU are for performance optimization and I think having
> combined ops is a good idea.

I don't as its a nightmare to sort out on -rt, where get_cpu() can be
converted to get_cpu_locked(), and rcu_read_lock() never disables
preemption.

If you convert it to use get_cpu() the conversion is easy, if you
introduce this collapsed primitive we're up shit creek because it
doesn't map.

Nor does it tell us why you need preempt disabled. Making it just as bad
as open-coded preempt_disable()s.

