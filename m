Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbYHAXGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbYHAXGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 19:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYHAXGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 19:06:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:56615 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbYHAXGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 19:06:44 -0400
Subject: Re: [PATCH] RCU: implement rcu_read_[un]lock_preempt()
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Tejun Heo <tj@kernel.org>, dipankar@in.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080801211029.GS14851@linux.vnet.ibm.com>
References: <487AEAC6.60307@kernel.org> <1216188469.5232.0.camel@twins>
	 <20080801211029.GS14851@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Sat, 02 Aug 2008 01:06:13 +0200
Message-Id: <1217631973.9016.19.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-01 at 14:10 -0700, Paul E. McKenney wrote:
> On Wed, Jul 16, 2008 at 08:07:49AM +0200, Peter Zijlstra wrote:
> > On Mon, 2008-07-14 at 14:57 +0900, Tejun Heo wrote:
> > > With the introduction of preemptible RCU, RCU doesn't gurantee that
> > > its critical section runs on the CPU it started to run.  As there are
> > > cases where non-preemptible RCU critical section makes sense, create
> > > new RCU read lock variants which turns of preemption -
> > > rcu_read_[un]lock_preempt() which are identical to rcu_read_[un]lock()
> > > for classic implementation and have enclosing preempt disable/enable
> > > for preemptible RCU.
> > > 
> > > Signed-off-by: Tejun Heo <tj@kernel.org>
> > 
> > Sorry, NAK.
> > 
> > If you need preempt off you need it for other reasons than RCU, so
> > mixing it in the interface doesn't make sense to me.
> 
> What Peter said.
> 
> For example, you could simply use preempt_disable() and preempt_enable()
> to guard the read side (or wrapper these as Mathieu suggests in
> http://lkml.org/lkml/2008/7/15/605, though Mathieu has not yet
> convinced me that these wrappers are a good idea), and then use either
> call_rcu_sched() or synchronize_sched() for the update side.
> 
> To summarize:
> 
> o	Replace your rcu_read_lock_preempt() with preempt_disable().
> 
> o	Replace your rcu_read_unlock_preempt() with preempt_enable().
> 
> o	Replace your use of call_rcu() with call_rcu_sched().
> 
> o	Replace your use of synchronize_rcu() with synchronize_sched().
> 
> And then you don't need these new primitives.
> 
> However!!!  This must be done carefully, as long sections of code
> with preemption disabled are really bad for realtime response.

Right - what I said in the other mail, we should really not use the
sched-RCU variant if we can avoid it.

