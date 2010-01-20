Return-Path: <linux-kernel-owner+w=401wt.eu-S1752032Ab0ATIqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab0ATIqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 03:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862Ab0ATIqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 03:46:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:50862 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab0ATIqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 03:46:33 -0500
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier (v5)
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20100120031323.GA15318@Krystal>
References: <20100113193603.GA27327@Krystal>
	 <1263460096.4244.282.camel@laptop> <20100114162609.GC3487@Krystal>
	 <1263488625.4244.333.camel@laptop> <20100114175449.GA15387@Krystal>
	 <20100114183739.GA18435@Krystal>
	 <1263495132.28171.3861.camel@gandalf.stny.rr.com>
	 <20100114193355.GA23436@Krystal> <1263926259.4283.757.camel@laptop>
	 <1263928006.4283.762.camel@laptop>  <20100120031323.GA15318@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 09:45:51 +0100
Message-ID: <1263977151.4283.816.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-19 at 22:13 -0500, Mathieu Desnoyers wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:
> > On Tue, 2010-01-19 at 19:37 +0100, Peter Zijlstra wrote:
> > > On Thu, 2010-01-14 at 14:33 -0500, Mathieu Desnoyers wrote:
> > > > It's a case where CPU 1 switches from our mm to another mm:
> > > > 
> > > >        CPU 0 (membarrier)                  CPU 1 (another mm -our mm)
> > > >        <user-space>                        <user-space>
> > > >                                            <buffered access C.S. data>
> > > >                                            urcu read unlock()
> > > >                                              barrier()
> > > >                                              store local gp
> > > >                                            <kernel-space>
> > > 
> > > OK, so the question is how we end up here, if its though interrupt
> > > preemption I think the interrupt delivery will imply an mb,
> > 
> > I keep thinking that, but I think we actually refuted that in an earlier
> > discussion on this patch.
> 
> Intel Architecture Software Developer's Manual Vol. 3: System
> Programming
> 7.4 Serializing Instructions
> 
> "MOV to control reg, MOV to debug reg, WRMSR, INVD, INVLPG, WBINDV, LGDT,
> LLDT, LIDT, LTR, CPUID, IRET, RSM"
> 
> So, this list does _not_ include: INT, SYSENTER, SYSEXIT.
> 
> Only IRET is included. So I don't think it is safe to assume that x86
> has serializing instructions when entering/leaving the kernel.

I got confused by 7.1.2.1 automatic locking on interrupt acknowledge.

But I already retracted that stmt.

> > 
> > >  if its a
> > > blocking syscall, the set_task_state() mb [*] should be there.
> > > 
> > > Then we also do:
> > > 
> > > 					clear_tsk_need_resched()
> > > 
> > > which is an atomic bitop (although does not imply a full barrier
> > > per-se).
> > > 
> > > >                                            rq->curr = next (1)
> > 
> > We could possibly look at placing that assignment in context_switch()
> > between switch_mm() and switch_to(), which should provide a mb before
> > and after I think, Ingo?
> 
> That's an interesting idea. It would indeed fix the problem of the
> missing barrier before the assignment, but would lack the appropriate
> barrier after the assignment. If the rq->curr = next; assignment is made
> after load_cr3, then we lack a memory barrier between the assignment and
> execution of following user-space code after returning with SYSEXIT (and
> we lack the appropriate barrier for other architectures too).

Well, 7.1.2.1 says that writing a segment register implies a LOCK, but
on second reading there are a number of qualifiers there, not sure we
satisfy that.

Peter, does our switch_to() imply a mb?

