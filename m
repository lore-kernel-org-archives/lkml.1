Return-Path: <linux-kernel-owner+w=401wt.eu-S1757028Ab0ANSur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab0ANSur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 13:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756818Ab0ANSuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 13:50:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64143 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab0ANSul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 13:50:41 -0500
X-Authority-Analysis: v=1.0 c=1 a=r_nf4N-T2GkA:10 a=7U3hwN5JcxgA:10 a=JfrnYn6hAAAA:8 a=janDXopcNaOkoCyVAv0A:9 a=jVOpznDCxVTdsWYommxkIIUvA0gA:4 a=3Rfx1nUSh_UA:10
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
In-Reply-To: <20100114175449.GA15387@Krystal>
References: <20100113013757.GA29314@Krystal>
	 <1263400738.4244.242.camel@laptop> <20100113193603.GA27327@Krystal>
	 <1263460096.4244.282.camel@laptop> <20100114162609.GC3487@Krystal>
	 <1263488625.4244.333.camel@laptop>  <20100114175449.GA15387@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 14 Jan 2010 13:50:37 -0500
Message-ID: <1263495037.28171.3860.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-14 at 12:54 -0500, Mathieu Desnoyers wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:
> > On Thu, 2010-01-14 at 11:26 -0500, Mathieu Desnoyers wrote:
> > 
> > > It's this scenario that is causing problem. Let's consider this
> > > execution:
> > > 
> 
> (slightly augmented)
> 
>        CPU 0 (membarrier)                  CPU 1 (another mm -> our mm)
>        <user-space>
>                                            <kernel-space>
>                                            switch_mm()
>                                              smp_mb()
>                                              clear_mm_cpumask()
>                                              set_mm_cpumask()
>                                              smp_mb() (by load_cr3() on x86)
>                                            switch_to()
>        memory access before membarrier
>        <call sys_membarrier()>
>        smp_mb()
>        mm_cpumask includes CPU 1
>        rcu_read_lock()
>        if (CPU 1 mm != our mm)

			But here, CPU 1 updated its mm already and did a
			smp_mb, won't that make us send the smp_mb
			anyway?

-- Steve

>          skip CPU 1.
>        rcu_read_unlock()
>        smp_mb()
>        <return to user-space>
>                                              current = next (1)
>                                            <switch back to user-space>
>                                            urcu read lock()
>                                              read gp
>                                              store local gp (2)
>                                              barrier()
>                                              access critical section data (3)
>        memory access after membarrier


