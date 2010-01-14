Return-Path: <linux-kernel-owner+w=401wt.eu-S1757353Ab0ANRER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab0ANRER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 12:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757344Ab0ANREQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 12:04:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:60132 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788Ab0ANREQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 12:04:16 -0500
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier (v5)
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
In-Reply-To: <20100114162609.GC3487@Krystal>
References: <20100113013757.GA29314@Krystal>
	 <1263400738.4244.242.camel@laptop> <20100113193603.GA27327@Krystal>
	 <1263460096.4244.282.camel@laptop>  <20100114162609.GC3487@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 18:03:45 +0100
Message-ID: <1263488625.4244.333.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-14 at 11:26 -0500, Mathieu Desnoyers wrote:

> It's this scenario that is causing problem. Let's consider this
> execution:
> 
>        CPU 0 (membarrier)                  CPU 1 (another mm -> our mm)
>        <kernel-space>                      <kernel-space>
>                                            switch_mm()
>                                              smp_mb()
>                                              clear_mm_cpumask()
>                                              set_mm_cpumask()
>                                              smp_mb() (by load_cr3() on x86)
>                                            switch_to()
>        mm_cpumask includes CPU 1
>        rcu_read_lock()
>        if (CPU 1 mm != our mm)
>          skip CPU 1.
>        rcu_read_unlock()
>                                              current = next (1)
>                                            <switch back to user-space>
>                                            read-lock()
>                                              read gp, store local gp
>                                              barrier()
>                                              access critical section (2)
> 
> So if we don't have any memory barrier between (1) and (2), the memory
> operations can be reordered in such a way that CPU 0 will not send IPI
> to a CPU that would need to have it's barrier() promoted into a
> smp_mb().

I'm still not getting it, sure we don't send an IPI, but it will have
done an mb() in switch_mm() to become our mm, so even without the IPI it
will have executed that mb we were after.



