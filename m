Return-Path: <linux-kernel-owner+w=401wt.eu-S932078Ab0AMLH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab0AMLH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 06:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259Ab0AMLH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 06:07:28 -0500
Received: from mtagate5.de.ibm.com ([195.212.17.165]:51947 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478Ab0AMLH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 06:07:27 -0500
Date: Wed, 13 Jan 2010 12:07:23 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier (v5)
Message-ID: <20100113110723.GA4181@osiris.boeblingen.de.ibm.com>
References: <20100113013757.GA29314@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100113013757.GA29314@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 08:37:57PM -0500, Mathieu Desnoyers wrote:
> +static void membarrier_retry(void)
> +{
> +	struct mm_struct *mm;
> +	int cpu;
> +
> +	for_each_cpu(cpu, mm_cpumask(current->mm)) {
> +		spin_lock_irq(&cpu_rq(cpu)->lock);
> +		mm = cpu_curr(cpu)->mm;
> +		spin_unlock_irq(&cpu_rq(cpu)->lock);
> +		if (current->mm == mm)
> +			smp_call_function_single(cpu, membarrier_ipi, NULL, 1);
> +	}

You would need to disable cpu unplug operations while doing this
or you might end up sending IPIs to offline cpus.

> +	cpumask_copy(tmpmask, mm_cpumask(current->mm));
> +	preempt_disable();
> +	cpumask_clear_cpu(smp_processor_id(), tmpmask);
> +	for_each_cpu(cpu, tmpmask) {
> +		spin_lock_irq(&cpu_rq(cpu)->lock);
> +		mm = cpu_curr(cpu)->mm;

This might access the rq of an offline cpu.
But maybe it's intended since offline cpus "run" idle?
