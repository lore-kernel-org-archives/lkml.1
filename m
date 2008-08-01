Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbYHAXFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbYHAXFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 19:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbYHAXFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 19:05:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58846 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbYHAXFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 19:05:44 -0400
Subject: Re: [patch 01/17] RCU read sched
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <20080801211025.GR14851@linux.vnet.ibm.com>
References: <20080715222604.331269462@polymtl.ca>
	 <20080715222746.136282703@polymtl.ca>
	 <20080801211025.GR14851@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Sat, 02 Aug 2008 01:04:29 +0200
Message-Id: <1217631869.9016.16.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-01 at 14:10 -0700, Paul E. McKenney wrote:
> On Tue, Jul 15, 2008 at 06:26:05PM -0400, Mathieu Desnoyers wrote:
> > Add rcu_read_lock_sched() and rcu_read_unlock_sched() to rcupdate.h to match the
> > recently added write-side call_rcu_sched() and rcu_barrier_sched(). They also
> > match the no-so-recently-added synchronize_sched().
> > 
> > It will help following matching use of the update/read lock primitives. Those
> > new read lock will replace preempt_disable()/enable() used in pair with
> > RCU-classic synchronization.
> 
> Looks good, but...
> 
> synchronize_sched(), call_rcu_sched(), and rcu_barrier_sched() can also
> pair up with:
> 
> o	local_irq_save() and local_irq_restore()
> o	local_irq_disable() and local_irq_enable()

> o	spin_lock_irqsave() and spin_lock_irqrestore()

You can't actually, as on PREEMP_RT these will not actuall disable
preemption.

> o	etc. etc.
> 
> I do very much like the idea of marking the intent of matching with
> RCU, but am getting a bit queasy about adding rcu_read_lock_sched_irq()
> and so on.

I'm thinking that if you disable interrupts, you're doing that for
another reason than RCU, so I'm not seeing the need for
rcu_read_lock_sched_irq variants.

Also, we should be very careful with using the *sched* RCU variant as it
really relies on disabling preemption - we should only use it when there
really is no other option, as we generally prefer to keep stuff
preemptable.

> Thoughts?  Other than having an rcu_read_lock_sched_nop() or some
> other window-dressing macro that doesn't really do anything?  (Which
> might really be the right thing to do...)

Afraid you lost me here..

