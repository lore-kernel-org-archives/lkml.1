Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560Ab0ATDN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab0ATDN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 22:13:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015Ab0ATDN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 22:13:26 -0500
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:52484 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753122Ab0ATDN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 22:13:26 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsgEAPYAVkuuWOiG/2dsb2JhbACBRtUyhDME
Date: Tue, 19 Jan 2010 22:13:23 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier (v5)
Message-ID: <20100120031323.GA15318@Krystal>
References: <20100113193603.GA27327@Krystal> <1263460096.4244.282.camel@laptop> <20100114162609.GC3487@Krystal> <1263488625.4244.333.camel@laptop> <20100114175449.GA15387@Krystal> <20100114183739.GA18435@Krystal> <1263495132.28171.3861.camel@gandalf.stny.rr.com> <20100114193355.GA23436@Krystal> <1263926259.4283.757.camel@laptop> <1263928006.4283.762.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1263928006.4283.762.camel@laptop>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 21:59:04 up 34 days, 11:17,  4 users,  load average: 0.31, 0.17,
	0.13
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Tue, 2010-01-19 at 19:37 +0100, Peter Zijlstra wrote:
> > On Thu, 2010-01-14 at 14:33 -0500, Mathieu Desnoyers wrote:
> > > It's a case where CPU 1 switches from our mm to another mm:
> > > 
> > >        CPU 0 (membarrier)                  CPU 1 (another mm -our mm)
> > >        <user-space>                        <user-space>
> > >                                            <buffered access C.S. data>
> > >                                            urcu read unlock()
> > >                                              barrier()
> > >                                              store local gp
> > >                                            <kernel-space>
> > 
> > OK, so the question is how we end up here, if its though interrupt
> > preemption I think the interrupt delivery will imply an mb,
> 
> I keep thinking that, but I think we actually refuted that in an earlier
> discussion on this patch.

Intel Architecture Software Developer's Manual Vol. 3: System
Programming
7.4 Serializing Instructions

"MOV to control reg, MOV to debug reg, WRMSR, INVD, INVLPG, WBINDV, LGDT,
LLDT, LIDT, LTR, CPUID, IRET, RSM"

So, this list does _not_ include: INT, SYSENTER, SYSEXIT.

Only IRET is included. So I don't think it is safe to assume that x86
has serializing instructions when entering/leaving the kernel.

> 
> >  if its a
> > blocking syscall, the set_task_state() mb [*] should be there.
> > 
> > Then we also do:
> > 
> > 					clear_tsk_need_resched()
> > 
> > which is an atomic bitop (although does not imply a full barrier
> > per-se).
> > 
> > >                                            rq->curr = next (1)
> 
> We could possibly look at placing that assignment in context_switch()
> between switch_mm() and switch_to(), which should provide a mb before
> and after I think, Ingo?

That's an interesting idea. It would indeed fix the problem of the
missing barrier before the assignment, but would lack the appropriate
barrier after the assignment. If the rq->curr = next; assignment is made
after load_cr3, then we lack a memory barrier between the assignment and
execution of following user-space code after returning with SYSEXIT (and
we lack the appropriate barrier for other architectures too).

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
