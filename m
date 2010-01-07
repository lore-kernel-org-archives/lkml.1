Return-Path: <linux-kernel-owner+w=401wt.eu-S1751573Ab0AGJud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573Ab0AGJud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 04:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355Ab0AGJuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 04:50:32 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59446 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab0AGJub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 04:50:31 -0500
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory barrier
From: Andi Kleen <andi@firstfloor.org>
References: <20100107044007.GA22863@Krystal>
Date: Thu, 07 Jan 2010 10:50:26 +0100
In-Reply-To: <20100107044007.GA22863@Krystal> (Mathieu Desnoyers's message of "Wed, 6 Jan 2010 23:40:07 -0500")
Message-ID: <877hruxmzh.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:

> Both the signal-based and the sys_membarrier userspace RCU schemes
> permit us to remove the memory barrier from the userspace RCU
> rcu_read_lock() and rcu_read_unlock() primitives, thus significantly
> accelerating them. These memory barriers are replaced by compiler
> barriers on the read-side, and all matching memory barriers on the
> write-side are turned into an invokation of a memory barrier on all
> active threads in the process. By letting the kernel perform this
> synchronization rather than dumbly sending a signal to every process
> threads (as we currently do), we diminish the number of unnecessary wake
> ups and only issue the memory barriers on active threads. Non-running
> threads do not need to execute such barrier anyway, because these are
> implied by the scheduler context switches.

I'm not sure all this effort is really needed on architectures
with strong memory ordering.

> + * The current implementation simply executes a memory barrier in an IPI handler
> + * on each active cpu. Going through the hassle of taking run queue locks and
> + * checking if the thread running on each online CPU belongs to the current
> + * thread seems more heavyweight than the cost of the IPI itself.
> + */
> +SYSCALL_DEFINE0(membarrier)
> +{
> +	on_each_cpu(membarrier_ipi, NULL, 1);

Can't you use mm->cpu_vm_mask?

-Andi
