Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818Ab0ANSwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab0ANSwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 13:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448Ab0ANSwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 13:52:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38569 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab0ANSwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 13:52:14 -0500
X-Authority-Analysis: v=1.0 c=1 a=r_nf4N-T2GkA:10 a=7U3hwN5JcxgA:10 a=cla1Sq0BbVe8qI2ljCwA:9 a=8_E6Mt91AnTyI4HEVtzKeR613vYA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier (v5)
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
In-Reply-To: <20100114183739.GA18435@Krystal>
References: <20100113013757.GA29314@Krystal>
	 <1263400738.4244.242.camel@laptop> <20100113193603.GA27327@Krystal>
	 <1263460096.4244.282.camel@laptop> <20100114162609.GC3487@Krystal>
	 <1263488625.4244.333.camel@laptop> <20100114175449.GA15387@Krystal>
	 <20100114183739.GA18435@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 14 Jan 2010 13:52:12 -0500
Message-ID: <1263495132.28171.3861.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-14 at 13:37 -0500, Mathieu Desnoyers wrote:

> To make this painfully clear, I'll reorder the accesses to match that of
> the CPU to memory:
> 
>        CPU 0 (membarrier)                  CPU 1 (another mm -our mm)
>        <user-space>
>                                            <kernel-space>
>                                            switch_mm()
>                                              smp_mb()
>                                              clear_mm_cpumask()
>                                              set_mm_cpumask()
>                                              smp_mb() (by load_cr3() on x86)
>                                            switch_to()
>                                              <buffered current = next>
>                                            <switch back to user-space>
>                                            urcu read lock()
>                                              access critical section data (3)
>        memory access before membarrier
>        <call sys_membarrier()>
>        smp_mb()
>        mm_cpumask includes CPU 1
>        rcu_read_lock()
>        if (CPU 1 mm != our mm)
>          skip CPU 1.

I still don't see how the above conditional fails?

-- Steve

>        rcu_read_unlock()
>        smp_mb()
>        <return to user-space>
>        memory access after membarrier
>                                              current = next (1) (buffer flush)
>                                              read gp
>                                              store local gp (2)
> 
> This should make the problem a bit more evident. Access (3) is done
> outside of the read-side C.S. as far as the userspace synchronize_rcu()
> is concerned.
> 
> Thanks,
> 
> Mathieu
> 
> 


