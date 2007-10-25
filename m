Return-Path: <linux-kernel-owner+w=401wt.eu-S1761634AbXJYP2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761634AbXJYP2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 11:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757826AbXJYP20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 11:28:26 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:45646 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757747AbXJYP2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 11:28:25 -0400
Date: Thu, 25 Oct 2007 11:27:54 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [PATCH 3/3] RT: CPU priority management
In-Reply-To: <20071025144633.19876.10342.stgit@novell1.haskins.net>
Message-ID: <Pine.LNX.4.58.0710251124370.5639@gandalf.stny.rr.com>
References: <20071025144456.19876.94333.stgit@novell1.haskins.net>
 <20071025144633.19876.10342.stgit@novell1.haskins.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--

> +
> +struct cpu_priority {
> +	raw_spinlock_t lock;
> +	cpumask_t      pri_to_cpu[CPUPRI_NR_PRIORITIES];
> +	long           pri_active[CPUPRI_NR_PRIORITIES/BITS_PER_LONG];
> +	int            cpu_to_pri[NR_CPUS];
> +};
> +
> +static __cacheline_aligned_in_smp struct cpu_priority cpu_priority;
> +

[...]

> +int cpupri_find(int def_cpu, struct task_struct *p)
> +{
> +	int                  idx      = 0;
> +	struct cpu_priority *cp       = &cpu_priority;
> +	int                  this_cpu = smp_processor_id();
> +	int                  cpu      = def_cpu;
> +	int                  task_pri = convert_prio(p->prio);
> +
> +	for_each_cpupri_active(cp->pri_active, idx) {

[...]

> +void cpupri_set(int cpu, int newpri)
> +{
> +	struct cpu_priority *cp      = &cpu_priority;
> +	int                 *currpri = &cp->cpu_to_pri[cpu];
> +	int                  oldpri  = *currpri;
> +	unsigned long        flags;
> +
> +	newpri = convert_prio(newpri);
> +
> +	if (newpri == oldpri)
> +		return;
> +
> +	spin_lock_irqsave(&cp->lock, flags);

The cpu_priority and the cp->lock will be aboslutely horrible for
cacheline bouncing.  Ironically, this will kill performance for the very
machines this code is to help with.  The larger the number of CPUs you
have the more cacheline bouncing this code will create.

I still don't see the benefit from the cpupri code.

-- Steve

