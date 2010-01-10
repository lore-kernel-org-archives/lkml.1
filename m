Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758Ab0AJADV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab0AJADV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 19:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995Ab0AJADT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 19:03:19 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44274 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab0AJADS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 19:03:18 -0500
Date: Sat, 9 Jan 2010 16:03:18 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100110000318.GD9044@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1262900140.28171.3773.camel@gandalf.stny.rr.com> <20100108235338.GA18050@Krystal> <20100109002043.GD6816@linux.vnet.ibm.com> <20100109010231.GA25368@Krystal> <20100109012128.GF6816@linux.vnet.ibm.com> <20100109023842.GA1696@Krystal> <20100109054215.GB9044@linux.vnet.ibm.com> <20100109192006.GA23672@Krystal> <1263078327.28171.3792.camel@gandalf.stny.rr.com> <1263079000.28171.3795.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263079000.28171.3795.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 09, 2010 at 06:16:40PM -0500, Steven Rostedt wrote:
> On Sat, 2010-01-09 at 18:05 -0500, Steven Rostedt wrote:
> 
> > Then we should have O(tasks) for spinlocks taken, and 
> > O(min(tasks, CPUS)) for IPIs.
> 
> And for nr tasks >> CPUS, this may help too:
> 
> > cpumask = 0;
> > foreach task {
> 
> 	if (cpumask == online_cpus)
> 		break;
> 
> > 	spin_lock(task_rq(task)->rq->lock);
> > 	if (task_rq(task)->curr == task)
> > 		cpu_set(task_cpu(task), cpumask);
> > 	spin_unlock(task_rq(task)->rq->lock);
> > }
> > send_ipi(cpumask);

Good point, erring on the side of sending too many IPIs is safe.  One
might even be able to just send the full set if enough of the CPUs were
running the current process and none of the remainder were running
real-time threads.  And yes, it would then be necessary to throttle
calls to sys_membarrier().

Quickly hiding behind a suitable boulder...  ;-)

							Thanx, Paul
