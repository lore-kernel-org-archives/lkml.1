Return-Path: <linux-kernel-owner+w=401wt.eu-S965292AbXIGLUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965292AbXIGLUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 07:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965172AbXIGLT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 07:19:57 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:36380 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965157AbXIGLT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 07:19:56 -0400
Message-ID: <46E1337D.3090005@linux.vnet.ibm.com>
Date: Fri, 07 Sep 2007 16:48:21 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: travis@sgi.com
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ppc64: Convert cpu_sibling_map to a per_cpu data
 array
References: <20070907040943.467530005@sgi.com> <20070907040944.380253345@sgi.com>
In-Reply-To: <20070907040944.380253345@sgi.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

travis@sgi.com wrote:
> Convert cpu_sibling_map to a per_cpu cpumask_t array for the ppc64
> architecture.
>
> Note: these changes have not been built nor tested.
>
> Note: I also don't know if these changes are particularly
> relevant for the ppc64 architecture.
>
> Signed-off-by: Mike Travis <travis@sgi.com>
> ---
>  arch/powerpc/kernel/setup-common.c        |    4 ++--
>  arch/powerpc/kernel/smp.c                 |    4 ++--
>  arch/powerpc/platforms/cell/cbe_cpufreq.c |    2 +-
>  include/asm-powerpc/smp.h                 |    3 ++-
>  include/asm-powerpc/topology.h            |    2 +-
>  5 files changed, 8 insertions(+), 7 deletions(-)
>
> --- a/arch/powerpc/kernel/setup-common.c
> +++ b/arch/powerpc/kernel/setup-common.c
> @@ -415,9 +415,9 @@
>  	 * Do the sibling map; assume only two threads per processor.
>  	 */
>  	for_each_possible_cpu(cpu) {
> -		cpu_set(cpu, cpu_sibling_map[cpu]);
> +		cpu_set(cpu, cpu_sibling_map(cpu));
>  		if (cpu_has_feature(CPU_FTR_SMT))
> -			cpu_set(cpu ^ 0x1, cpu_sibling_map[cpu]);
> +			cpu_set(cpu ^ 0x1, cpu_sibling_map(cpu));
>  	}
>
>  	vdso_data->processorCount = num_present_cpus();
> --- a/arch/powerpc/kernel/smp.c
> +++ b/arch/powerpc/kernel/smp.c
> @@ -61,11 +61,11 @@
>
>  cpumask_t cpu_possible_map = CPU_MASK_NONE;
>  cpumask_t cpu_online_map = CPU_MASK_NONE;
> -cpumask_t cpu_sibling_map[NR_CPUS] = { [0 ... NR_CPUS-1] = CPU_MASK_NONE };
> +DEFINE_PER_CPU(cpumask_t, cpu_sibling_map) = CPU_MASK_NONE;
>
>  EXPORT_SYMBOL(cpu_online_map);
>  EXPORT_SYMBOL(cpu_possible_map);
> -EXPORT_SYMBOL(cpu_sibling_map);
> +EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
>
>  /* SMP operations for this machine */
>  struct smp_ops_t *smp_ops;
> --- a/arch/powerpc/platforms/cell/cbe_cpufreq.c
> +++ b/arch/powerpc/platforms/cell/cbe_cpufreq.c
> @@ -117,7 +117,7 @@
>  	policy->cur = cbe_freqs[cur_pmode].frequency;
>
>  #ifdef CONFIG_SMP
> -	policy->cpus = cpu_sibling_map[policy->cpu];
> +	policy->cpus = cpu_sibling_map(policy->cpu);
>  #endif
>
>  	cpufreq_frequency_table_get_attr(cbe_freqs, policy->cpu);
> --- a/include/asm-powerpc/smp.h
> +++ b/include/asm-powerpc/smp.h
> @@ -58,7 +58,8 @@
>  					(smp_hw_index[(cpu)] = (phys))
>  #endif
>
> -extern cpumask_t cpu_sibling_map[NR_CPUS];
> +DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
> +#define cpu_sibling_map(cpu) per_cpu(cpu_sibling_map, cpu)
>
>  /* Since OpenPIC has only 4 IPIs, we use slightly different message numbers.
>   *
> --- a/include/asm-powerpc/topology.h
> +++ b/include/asm-powerpc/topology.h
> @@ -108,7 +108,7 @@
>  #ifdef CONFIG_PPC64
>  #include <asm/smp.h>
>
> -#define topology_thread_siblings(cpu)	(cpu_sibling_map[cpu])
> +#define topology_thread_siblings(cpu)	(cpu_sibling_map(cpu))
>  #endif
>  #endif
>
>
>   
Hi Mike,

After applying the patch, the build fails with following error

CHK include/linux/version.h
CHK include/linux/utsrelease.h
CC arch/powerpc/kernel/asm-offsets.s
In file included from include/linux/smp.h:19,
from include/linux/topology.h:33,
from include/linux/mmzone.h:660,
from include/linux/gfp.h:4,
from include/linux/slab.h:14,
from include/linux/percpu.h:5,
from include/asm/time.h:18,
from include/asm/cputime.h:26,
from include/linux/sched.h:65,
from arch/powerpc/kernel/asm-offsets.c:17:
include/asm/smp.h:61: error: expected declaration specifiers or ‘...’ 
before ‘cpu_sibling_map’
include/asm/smp.h:61: warning: data definition has no type or storage class
include/asm/smp.h:61: warning: type defaults to ‘int’ in declaration of 
‘DECLARE_PER_CPU’
make[1]: *** [arch/powerpc/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2

Thanks & Regards,
Kamalesh Babulal.
