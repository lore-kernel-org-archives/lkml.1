Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497Ab0AMOrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab0AMOrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 09:47:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351Ab0AMOrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 09:47:01 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:64488 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab0AMOrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 09:47:00 -0500
Date: Wed, 13 Jan 2010 09:46:59 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier (v5)
Message-ID: <20100113144659.GD30875@Krystal>
References: <20100113013757.GA29314@Krystal> <20100113110723.GA4181@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100113110723.GA4181@osiris.boeblingen.de.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 09:40:02 up 27 days, 22:58,  4 users,  load average: 0.12, 0.08,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Heiko Carstens (heiko.carstens@de.ibm.com) wrote:
> On Tue, Jan 12, 2010 at 08:37:57PM -0500, Mathieu Desnoyers wrote:
> > +static void membarrier_retry(void)
> > +{
> > +	struct mm_struct *mm;
> > +	int cpu;
> > +
> > +	for_each_cpu(cpu, mm_cpumask(current->mm)) {
> > +		spin_lock_irq(&cpu_rq(cpu)->lock);
> > +		mm = cpu_curr(cpu)->mm;
> > +		spin_unlock_irq(&cpu_rq(cpu)->lock);
> > +		if (current->mm == mm)
> > +			smp_call_function_single(cpu, membarrier_ipi, NULL, 1);
> > +	}
> 
> You would need to disable cpu unplug operations while doing this
> or you might end up sending IPIs to offline cpus.

smp_call_function_single() checks for cpu_online(cpu), and returns
-ENXIO if the cpu is not online. So I think disabling cpu hotplug would
be redundant with this test.

smp_call_function_many uses cpumask_next_and(cpu, mask, cpu_online_mask)
to alter the mask, so no cpu hotplug disabling needed there neither.

These checks are protected by preemption disabling.

> 
> > +	cpumask_copy(tmpmask, mm_cpumask(current->mm));
> > +	preempt_disable();
> > +	cpumask_clear_cpu(smp_processor_id(), tmpmask);
> > +	for_each_cpu(cpu, tmpmask) {
> > +		spin_lock_irq(&cpu_rq(cpu)->lock);
> > +		mm = cpu_curr(cpu)->mm;
> 
> This might access the rq of an offline cpu.
> But maybe it's intended since offline cpus "run" idle?

In a rare race with hotunplug vs lazy TLB shootdown, yes. Although even
then, as you point out, ->mm will be NULL, so we won't even consider the
CPU for IPI. In any case, I think adding a cpumask online "and" would be
an added performance overhead for the common case compared to the
performance gain in the rare cpu hotunplug race window.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
