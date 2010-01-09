Return-Path: <linux-kernel-owner+w=401wt.eu-S1752218Ab0AIXFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab0AIXFe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 18:05:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400Ab0AIXFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 18:05:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38967 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab0AIXFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 18:05:33 -0500
X-Authority-Analysis: v=1.0 c=1 a=r_nf4N-T2GkA:10 a=7U3hwN5JcxgA:10 a=fZfgGA1oMRQixq_sI6AA:9 a=MrrdaXLRlCMDWBb4w4cA:7 a=P6kxWeydJ4iqz41AL36jx1DT7-MA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
In-Reply-To: <20100109192006.GA23672@Krystal>
References: <20100107191657.GN6764@linux.vnet.ibm.com>
	 <1262893243.28171.3753.camel@gandalf.stny.rr.com>
	 <20100107205830.GR6764@linux.vnet.ibm.com>
	 <1262900140.28171.3773.camel@gandalf.stny.rr.com>
	 <20100108235338.GA18050@Krystal> <20100109002043.GD6816@linux.vnet.ibm.com>
	 <20100109010231.GA25368@Krystal> <20100109012128.GF6816@linux.vnet.ibm.com>
	 <20100109023842.GA1696@Krystal> <20100109054215.GB9044@linux.vnet.ibm.com>
	 <20100109192006.GA23672@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Sat, 09 Jan 2010 18:05:27 -0500
Message-ID: <1263078327.28171.3792.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-09 at 14:20 -0500, Mathieu Desnoyers wrote:

> > > Using the spinlocks adds about 3s for 10,000,000 sys_membarrier() calls
> > > or a 8-core system, for an added 300 ns/core per call.
> > > 
> > > So the overhead of taking the task lock is about twice higher, per core,
> > > than the overhead of the IPIs. This is understandable if the
> > > architecture does an IPI broadcast: the scalability problem then boils
> > > down to exchange cache-lines to inform the ipi sender that the other
> > > cpus have completed. An atomic operation exchanging a cache-line would
> > > be expected to be within the irqoff+spinlock+spinunlock+irqon overhead.
> > 
> > Let me rephrase the question...  Isn't the vast bulk of the overhead
> > something other than the runqueue spinlocks?
> 
> I don't think so. What we have here is:
> 
> O(1)
> - a system call
> - cpumask allocation
> - IPI broadcast

> O(nr cpus)

Isn't this really O(tasks) ?

Don't you do the spinlock(task_rq(task)->rq->lock)?

So the scale is not with large boxes, but the number of tasks that must
be checked. Still, if you have 1000 threads, a rcu writer is bound to
take a bit of overhead. But the advantage is the readers are still fast.

RCU is known to be slow for writing. A user must be aware of this.

Then we should have O(tasks) for spinlocks taken, and 
O(min(tasks, CPUS)) for IPIs.

cpumask = 0;
foreach task {
	spin_lock(task_rq(task)->rq->lock);
	if (task_rq(task)->curr == task)
		cpu_set(task_cpu(task), cpumask);
	spin_unlock(task_rq(task)->rq->lock);
}
send_ipi(cpumask);

-- Steve


> - wait for IPI handlers to complete
> - runqueue spinlocks


