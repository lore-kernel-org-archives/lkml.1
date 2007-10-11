Return-Path: <linux-kernel-owner+w=401wt.eu-S1757799AbXJKCdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799AbXJKCdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 22:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbXJKCdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 22:33:39 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54660 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755775AbXJKCdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 22:33:38 -0400
Date: Wed, 10 Oct 2007 19:29:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Jackson <pj@sgi.com>
Cc: Dinakar Guniguntala <dino@in.ibm.com>, Cliff Wickman <cpw@sgi.com>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] cpuset sched_load_balance flag
Message-Id: <20071010192957.78d3668f.akpm@linux-foundation.org>
In-Reply-To: <20071006094747.17518.44098.sendpatchset@jackhammer.engr.sgi.com>
References: <20071006094747.17518.44098.sendpatchset@jackhammer.engr.sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 06 Oct 2007 02:47:47 -0700 Paul Jackson <pj@sgi.com> wrote:

> From: Paul Jackson <pj@sgi.com>
> 
> Add a new per-cpuset flag called 'sched_load_balance'.
> 
> When enabled in a cpuset (the default value) it tells the kernel
> scheduler that the scheduler should provide the normal load
> balancing on the CPUs in that cpuset, sometimes moving tasks
> from one CPU to a second CPU if the second CPU is less loaded
> and if that task is allowed to run there.
> 
> When disabled (write "0" to the file) then it tells the kernel
> scheduler that load balancing is not required for the CPUs in
> that cpuset.
> 
> Now even if this flag is disabled for some cpuset, the kernel
> may still have to load balance some or all the CPUs in that
> cpuset, if some overlapping cpuset has its sched_load_balance
> flag enabled.
> 
> If there are some CPUs that are not in any cpuset whose
> sched_load_balance flag is enabled, the kernel scheduler will
> not load balance tasks to those CPUs.
> 
> Moreover the kernel will partition the 'sched domains'
> (non-overlapping sets of CPUs over which load balancing is
> attempted) into the finest granularity partition that it can
> find, while still keeping any two CPUs that are in the same
> shed_load_balance enabled cpuset in the same element of the
> partition.
> 
> This serves two purposes:
>  1) It provides a mechanism for real time isolation of some CPUs, and
>  2) it can be used to improve performance on systems with many CPUs
>     by supporting configurations in which load balancing is not done
>     across all CPUs at once, but rather only done in several smaller
>     disjoint sets of CPUs.
> 
> This mechanism replaces the earlier overloading of the per-cpuset
> flag 'cpu_exclusive', which overloading was removed in an earlier
> patch: cpuset-remove-sched-domain-hooks-from-cpusets
> 
> See further the Documentation and comments in the code itself.
> 
> ...
>
> +static void rebuild_sched_domains(void)
> +{
> +	struct kfifo *q;	/* queue of cpusets to be scanned */
> +	struct cpuset *cp;	/* scans q */
> +	struct cpuset **csa;	/* array of all cpuset ptrs */
> +	int csn;		/* how many cpuset ptrs in csa so far */
> +	int i, j, k;		/* indices for partition finding loops */
> +	cpumask_t *doms;	/* resulting partition; i.e. sched domains */
> +	int ndoms;		/* number of sched domains in result */
> +	int nslot;		/* next empty doms[] cpumask_t slot */
> +
> +	q = NULL;
> +	csa = NULL;
> +	doms = NULL;
> +
> +	/* Special case for the 99% of systems with one, full, sched domain */
> +	if (is_sched_load_balance(&top_cpuset)) {
> +		ndoms = 1;
> +		doms = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
> +		*doms = top_cpuset.cpus_allowed;

We generally only excuse failure to check kmalloc return value when the
code is called on the bootup path.  But this code is called at other times.

>
>  static int arch_init_sched_domains(const cpumask_t *cpu_map)
>  {
> -	cpumask_t cpu_default_map;
> -	int err;
> -
> -	/*
> -	 * Setup mask for cpus without special case scheduling requirements.
> -	 * For now this just excludes isolated cpus, but could be used to
> -	 * exclude other special cases in the future.
> -	 */
> -	cpus_andnot(cpu_default_map, *cpu_map, cpu_isolated_map);
> +	ndoms_cur = 1;
> +	doms_cur =  kmalloc(sizeof(cpumask_t), GFP_KERNEL);
> +	cpus_andnot(*doms_cur, *cpu_map, cpu_isolated_map);

> -	err = build_sched_domains(&cpu_default_map);
> -
> -	return err;
> +	return build_sched_domains(doms_cur);
>  }

Ditto


I't s a fairly minor thing really, but children might be watching..
