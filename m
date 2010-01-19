Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394Ab0ASTnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab0ASTnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 14:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285Ab0ASTnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 14:43:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49548 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab0ASTnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 14:43:49 -0500
X-Authority-Analysis: v=1.0 c=1 a=r_nf4N-T2GkA:10 a=7U3hwN5JcxgA:10 a=xaSl2R8rfcS0pZdVIu0A:9 a=bepXwgT_aGvrAZsTRocA:7 a=LT-og1TQ2e_SfYGD-VUc8BjMyH0A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier (v5)
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org,
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
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 19 Jan 2010 14:43:44 -0500
Message-ID: <1263930224.31321.24.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-19 at 19:37 +0100, Peter Zijlstra wrote:

> So about that [*], Oleg, kernel/signal.c:SYSCALL_DEFINE0(pause) does:
> 
> SYSCALL_DEFINE0(pause)
> {
>         current->state = TASK_INTERRUPTIBLE;
>         schedule();
>         return -ERESTARTNOHAND;
> }
> 
> Isn't that ->state assignment buggy? If so, there appear to be quite a
> few such sites, which worries me.
> 

That looks buggy to me. Isn't this the reason we have
set_current_state()?

Although, since it is not checking any condition, it may not be buggy.
The check inside scheduler for state != TASK_RUNNING is protected inside
the rq locks, and any other task must grab the rq lock of the task
before it can change the task's state. schedule() also checks for
signals which would force schedule() to wake it up.

But that said, I still think that should be changed to
set_current_state(TASK_INTERRUPTIBLE).
	

-- Steve



