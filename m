Return-Path: <linux-kernel-owner+w=401wt.eu-S1753525Ab0AJQXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab0AJQXN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 11:23:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379Ab0AJQXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 11:23:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53109 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab0AJQXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 11:23:12 -0500
X-Authority-Analysis: v=1.0 c=1 a=r_nf4N-T2GkA:10 a=meVymXHHAAAA:8 a=XXg12Rh2yQQMmAumXaoA:9 a=blUPe3KoOV43lzd37gQA:7 a=H7ELfBgnJnxDudvBdYjT_UbtvtIA:4 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: paulmck@linux.vnet.ibm.com, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
In-Reply-To: <20100110160314.GA10587@Krystal>
References: <20100109054215.GB9044@linux.vnet.ibm.com>
	 <20100109192006.GA23672@Krystal>
	 <1263078327.28171.3792.camel@gandalf.stny.rr.com>
	 <1263079000.28171.3795.camel@gandalf.stny.rr.com>
	 <20100110000318.GD9044@linux.vnet.ibm.com> <1263084099.2231.5.camel@frodo>
	 <20100110014456.GG25790@Krystal> <1263089578.2231.22.camel@frodo>
	 <20100110052508.GG9044@linux.vnet.ibm.com>
	 <1263124209.28171.3798.camel@gandalf.stny.rr.com>
	 <20100110160314.GA10587@Krystal>
Content-Type: text/plain
Date: Sun, 10 Jan 2010 11:21:20 -0500
Message-Id: <1263140480.4561.7.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-10 at 11:03 -0500, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:

> The way I see it, TLB can be seen as read-only elements (a local
> read-only cache) on the processors. Therefore, we don't care if they are
> in a stale state while performing the cpumask update, because the fact
> that we are executing switch_mm() means that these TLB entries are not
> being used locally anyway and will be dropped shortly. So we have the
> equivalent of a full memory barrier (load_cr3()) _after_ the cpumask
> updates.
> 
> However, in sys_membarrier(), we also need to flush the write buffers
> present on each processor running threads which belong to our current
> process. Therefore, we would need, in addition, a smp_mb() before the
> mm cpumask modification. For x86, cpumask_clear_cpu/cpumask_set_cpu
> implies a LOCK-prefixed operation, and hence does not need any added
> barrier, but this could be different for other architectures.
> 
> So, AFAIK, doing a flush_tlb() would not guarantee the kind of
> synchronization we are looking for because an uncommitted write buffer
> could still sit on the remote CPU when we return from sys_membarrier().

Ah, so you are saying we can have this:


	CPU 0			CPU 1
     ----------		    --------------
	obj = list->obj;
				<user space>
				rcu_read_lock();
				obj = rcu_dereference(list->obj);
				obj->foo = bar;

				<preempt>
				<kernel space>

				schedule();
				cpumask_clear(mm_cpumask, cpu);

	sys_membarrier();
	free(obj);

				<store to obj->foo goes to memory>  <- corruption

		

So, if there's no smp_wmb() between the <preempt> and cpumask_clear()
then we have an issue?

-- Steve


