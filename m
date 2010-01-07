Return-Path: <linux-kernel-owner+w=401wt.eu-S1753122Ab0AGPMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab0AGPMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 10:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001Ab0AGPMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 10:12:16 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:37870 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752432Ab0AGPMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 10:12:16 -0500
Date: Thu, 7 Jan 2010 10:12:14 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100107151214.GC14259@Krystal>
References: <20100107044007.GA22863@Krystal> <877hruxmzh.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <877hruxmzh.fsf@basil.nowhere.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:10:37 up 21 days, 23:29,  6 users,  load average: 0.15, 0.23,
	0.15
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
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

Do we still have many out there that support SMP ? Even newer ARM now
need memory barriers.

> 
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

I'll go for PeterZ scheme, which is based on cpu_vm_mask.

Thanks,

Mathieu


> 
> -Andi

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
