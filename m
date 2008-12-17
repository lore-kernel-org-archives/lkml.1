Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753264AbYLQWyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbYLQWyc (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 17:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbYLQWyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 17:54:22 -0500
Received: from relay3.sgi.com ([192.48.171.31]:38550 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751971AbYLQWyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 17:54:21 -0500
Message-ID: <4949831B.2000809@sgi.com>
Date: Wed, 17 Dec 2008 14:54:19 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Jack Steiner <steiner@sgi.com>
Subject: Re: [PATCH 1/4] cpumask: cpu_coregroup_mask(): x86
References: <200812011646.35018.rusty@rustcorp.com.au>
In-Reply-To: <200812011646.35018.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Like cpu_coregroup_map, but returns a (const) pointer.
> 
> (This will go to Ingo separately as part of the x86 series, just
> airing it here for thoroughness).
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Mike Travis <travis@sgi.com>
> Cc: Ingo Molnar <mingo@redhat.com>

I've pulled this patch into the queue for my cpus4096-for-ingo tree.

	[PATCH 1/4] cpumask: cpu_coregroup_mask(): x86

I can also line up a queue for sched related changes:

	[PATCH 4/4] cpumask: Replace cpu_coregroup_map with cpu_coregroup_map()

Is there any status on the corresponding changes for sparc, s390?  (I assume
that they'll need to be merged into linux-next?)

	[PATCH 2/4] cpumask: cpu_coregroup_mask(): sparc
	[PATCH 3/4] cpumask: cpu_coregroup_mask(): s390

Thanks,
Mike

> ---
>  arch/x86/include/asm/topology.h |    1 +
>  arch/x86/kernel/smpboot.c       |   11 ++++++++---
>  2 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff -r 11a884ebd99b arch/x86/include/asm/topology.h
> --- a/arch/x86/include/asm/topology.h	Thu Nov 20 13:54:24 2008 +1030
> +++ b/arch/x86/include/asm/topology.h	Thu Nov 20 13:55:44 2008 +1030
> @@ -231,6 +231,7 @@
>  #endif
>  
>  extern cpumask_t cpu_coregroup_map(int cpu);
> +extern const struct cpumask *cpu_coregroup_mask(int cpu);
>  
>  #ifdef ENABLE_TOPO_DEFINES
>  #define topology_physical_package_id(cpu)	(cpu_data(cpu).phys_proc_id)
> diff -r 11a884ebd99b arch/x86/kernel/smpboot.c
> --- a/arch/x86/kernel/smpboot.c	Thu Nov 20 13:54:24 2008 +1030
> +++ b/arch/x86/kernel/smpboot.c	Thu Nov 20 13:55:44 2008 +1030
> @@ -497,7 +497,7 @@
>  }
>  
>  /* maps the cpu to the sched domain representing multi-core */
> -cpumask_t cpu_coregroup_map(int cpu)
> +const struct cpumask *cpu_coregroup_mask(int cpu)
>  {
>  	struct cpuinfo_x86 *c = &cpu_data(cpu);
>  	/*
> @@ -505,9 +505,14 @@
>  	 * And for power savings, we return cpu_core_map
>  	 */
>  	if (sched_mc_power_savings || sched_smt_power_savings)
> -		return per_cpu(cpu_core_map, cpu);
> +		return &per_cpu(cpu_core_map, cpu);
>  	else
> -		return c->llc_shared_map;
> +		return &c->llc_shared_map;
> +}
> +
> +cpumask_t cpu_coregroup_map(int cpu)
> +{
> +	return *cpu_coregroup_mask(cpu);
>  }
>  
>  static void impress_friends(void)
> 

