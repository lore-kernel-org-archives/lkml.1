Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340Ab0AGQ5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab0AGQ5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 11:57:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944Ab0AGQ5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 11:57:07 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42276 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923Ab0AGQ5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 11:57:04 -0500
Date: Thu, 7 Jan 2010 08:56:59 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100107165659.GF6764@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100107044007.GA22863@Krystal> <877hruxmzh.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877hruxmzh.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 10:50:26AM +0100, Andi Kleen wrote:
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
> 
> > Both the signal-based and the sys_membarrier userspace RCU schemes
> > permit us to remove the memory barrier from the userspace RCU
> > rcu_read_lock() and rcu_read_unlock() primitives, thus significantly
> > accelerating them. These memory barriers are replaced by compiler
> > barriers on the read-side, and all matching memory barriers on the
> > write-side are turned into an invokation of a memory barrier on all
> > active threads in the process. By letting the kernel perform this
> > synchronization rather than dumbly sending a signal to every process
> > threads (as we currently do), we diminish the number of unnecessary wake
> > ups and only issue the memory barriers on active threads. Non-running
> > threads do not need to execute such barrier anyway, because these are
> > implied by the scheduler context switches.
> 
> I'm not sure all this effort is really needed on architectures
> with strong memory ordering.

Even CPUs with strong memory ordering allow later reads to complete
prior to earlier writes, which is enough to cause problems.

That said, some of the lighter-weight schemes sampling ->mm might be
safe on TSO machines.

> > + * The current implementation simply executes a memory barrier in an IPI handler
> > + * on each active cpu. Going through the hassle of taking run queue locks and
> > + * checking if the thread running on each online CPU belongs to the current
> > + * thread seems more heavyweight than the cost of the IPI itself.
> > + */
> > +SYSCALL_DEFINE0(membarrier)
> > +{
> > +	on_each_cpu(membarrier_ipi, NULL, 1);
> 
> Can't you use mm->cpu_vm_mask?

Hmmm...  Acquiring the corresponding lock would certainly make this
safe.  Not sure about lock-less access to it, though.

							Thanx, Paul
