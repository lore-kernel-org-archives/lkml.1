Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335Ab0ASTHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab0ASTHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 14:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278Ab0ASTHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 14:07:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:45639 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab0ASTHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 14:07:40 -0500
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier (v5)
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
In-Reply-To: <1263926259.4283.757.camel@laptop>
References: <20100113013757.GA29314@Krystal>
	 <1263400738.4244.242.camel@laptop> <20100113193603.GA27327@Krystal>
	 <1263460096.4244.282.camel@laptop> <20100114162609.GC3487@Krystal>
	 <1263488625.4244.333.camel@laptop> <20100114175449.GA15387@Krystal>
	 <20100114183739.GA18435@Krystal>
	 <1263495132.28171.3861.camel@gandalf.stny.rr.com>
	 <20100114193355.GA23436@Krystal>  <1263926259.4283.757.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jan 2010 20:06:46 +0100
Message-ID: <1263928006.4283.762.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-19 at 19:37 +0100, Peter Zijlstra wrote:
> On Thu, 2010-01-14 at 14:33 -0500, Mathieu Desnoyers wrote:
> > It's a case where CPU 1 switches from our mm to another mm:
> > 
> >        CPU 0 (membarrier)                  CPU 1 (another mm -our mm)
> >        <user-space>                        <user-space>
> >                                            <buffered access C.S. data>
> >                                            urcu read unlock()
> >                                              barrier()
> >                                              store local gp
> >                                            <kernel-space>
> 
> OK, so the question is how we end up here, if its though interrupt
> preemption I think the interrupt delivery will imply an mb,

I keep thinking that, but I think we actually refuted that in an earlier
discussion on this patch.

>  if its a
> blocking syscall, the set_task_state() mb [*] should be there.
> 
> Then we also do:
> 
> 					clear_tsk_need_resched()
> 
> which is an atomic bitop (although does not imply a full barrier
> per-se).
> 
> >                                            rq->curr = next (1)

We could possibly look at placing that assignment in context_switch()
between switch_mm() and switch_to(), which should provide a mb before
and after I think, Ingo?

