Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbZEIHF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbZEIHF3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 03:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbZEIHFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 03:05:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:57283 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbZEIHFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 03:05:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vi8qn+mH/3ZAgf2kDQO61iBrsWIh9S4JIkhKoDU+ntmzFHpiow60IgoYcPFn+cMclZ
         XbR/TcawoDdYafbN4JfZWaQDdzlmLl10A6EDUYwOlLfrbiVXaxQb0/J3Q3u52zOAH86n
         tMyhPcQ88WC/2k8rV4yPl159nQPzNtX1b/bbw=
Subject: Re: [PATCH 2/3] x86: add numa_move_cpus_to_node
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <4A052721.4010201@kernel.org>
References: <4A05269D.8000701@kernel.org>  <4A052721.4010201@kernel.org>
Content-Type: text/plain
Date: Sat, 09 May 2009 00:05:24 -0700
Message-Id: <1241852724.1876.5.camel@unix>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-08 at 23:48 -0700, Yinghai Lu wrote:

> 
> when node only have hot add range and don't have other static range.

when the node only has "hot add range", then don't have other "static
ranges".

> that node will not be onlined, and cpus on that will be linked to nearby
> node with memory.
> then when that host add range is added later, we need to linked those cpus
Then
> back.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/include/asm/numa_64.h |   10 ++++---
>  arch/x86/mm/init_64.c          |    3 ++
>  arch/x86/mm/numa_64.c          |   52 +++++++++++++++++++++++++++++++++++------
>  3 files changed, 54 insertions(+), 11 deletions(-)
> 
> Index: linux-2.6/arch/x86/include/asm/numa_64.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/numa_64.h
> +++ linux-2.6/arch/x86/include/asm/numa_64.h
> @@ -25,16 +25,18 @@ extern void setup_node_bootmem(int nodei
>  
>  #ifdef CONFIG_NUMA
>  extern void __init init_cpu_to_node(void);
> -extern void __cpuinit numa_set_node(int cpu, int node);
> -extern void __cpuinit numa_clear_node(int cpu);
> -extern void __cpuinit numa_add_cpu(int cpu);
> -extern void __cpuinit numa_remove_cpu(int cpu);
> +extern void numa_set_node(int cpu, int node);
> +extern void numa_clear_node(int cpu);
> +extern void numa_add_cpu(int cpu);
> +extern void numa_remove_cpu(int cpu);
> +extern void numa_move_cpus_to_node(int nid);
>  #else
>  static inline void init_cpu_to_node(void)		{ }
>  static inline void numa_set_node(int cpu, int node)	{ }
>  static inline void numa_clear_node(int cpu)		{ }
>  static inline void numa_add_cpu(int cpu, int node)	{ }
>  static inline void numa_remove_cpu(int cpu)		{ }
> +static inline void numa_move_cpus_to_node(int nid)	{ }
>  #endif
>  
>  #endif /* _ASM_X86_NUMA_64_H */
> Index: linux-2.6/arch/x86/mm/numa_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/numa_64.c
> +++ linux-2.6/arch/x86/mm/numa_64.c
> @@ -12,6 +12,7 @@
>  #include <linux/module.h>
>  #include <linux/nodemask.h>
>  #include <linux/sched.h>
> +#include <linux/node.h>
>  
>  #include <asm/e820.h>
>  #include <asm/proto.h>
> @@ -660,7 +661,7 @@ void __init init_cpu_to_node(void)
>  #endif
>  
> 
> -void __cpuinit numa_set_node(int cpu, int node)
> +void numa_set_node(int cpu, int node)
>  {
>  	int *cpu_to_node_map = early_per_cpu_ptr(x86_cpu_to_node_map);
>  
> @@ -683,19 +684,56 @@ void __cpuinit numa_set_node(int cpu, in
>  		per_cpu(node_number, cpu) = node;
>  }
>  
> -void __cpuinit numa_clear_node(int cpu)
> +void numa_clear_node(int cpu)
>  {
>  	numa_set_node(cpu, NUMA_NO_NODE);
>  }
>  
> +static int real_cpu_to_node(int cpu)
> +{
> +	int apicid, nodeid = -1;
> +
> +	/*
> +	 * when the node doesn't have memory before, cpu_to_node(cpu) is
> +	 * point to other node, but apicid_to_node still hold the real nodeid
> +	 */
> +	apicid = per_cpu(x86_cpu_to_apicid, cpu);
> +	if (apicid == BAD_APICID)
> +		return nodeid;
> +
> +	nodeid = apicid_to_node[apicid];
> +	return nodeid;
> +}
> +
> +void numa_move_cpus_to_node(int nid)
> +{
> +	int cpu;
> +
> +	for_each_present_cpu(cpu) {
> +		int nodeid;
> +
> +		nodeid = real_cpu_to_node(cpu);
> +		if (nodeid != nid)
> +			continue;
> +
> +		nodeid = cpu_to_node(cpu);
> +		if (nodeid != nid) {
> +			unregister_cpu_under_node(cpu, nodeid);
> +			numa_remove_cpu(cpu);
> +			numa_set_node(cpu, nid);
> +			numa_add_cpu(cpu);
> +		}
> +	}
> +}
> +
>  #ifndef CONFIG_DEBUG_PER_CPU_MAPS
>  
> -void __cpuinit numa_add_cpu(int cpu)
> +void numa_add_cpu(int cpu)
>  {
>  	cpumask_set_cpu(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
>  }
>  
> -void __cpuinit numa_remove_cpu(int cpu)
> +void numa_remove_cpu(int cpu)
>  {
>  	cpumask_clear_cpu(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
>  }
> @@ -705,7 +743,7 @@ void __cpuinit numa_remove_cpu(int cpu)
>  /*
>   * --------- debug versions of the numa functions ---------
>   */
> -static void __cpuinit numa_set_cpumask(int cpu, int enable)
> +static void numa_set_cpumask(int cpu, int enable)
>  {
>  	int node = early_cpu_to_node(cpu);
>  	struct cpumask *mask;
> @@ -728,12 +766,12 @@ static void __cpuinit numa_set_cpumask(i
>  		enable ? "numa_add_cpu" : "numa_remove_cpu", cpu, node, buf);
>  }
>  
> -void __cpuinit numa_add_cpu(int cpu)
> +void numa_add_cpu(int cpu)
>  {
>  	numa_set_cpumask(cpu, 1);
>  }
>  
> -void __cpuinit numa_remove_cpu(int cpu)
> +void numa_remove_cpu(int cpu)
>  {
>  	numa_set_cpumask(cpu, 0);
>  }
> Index: linux-2.6/arch/x86/mm/init_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/init_64.c
> +++ linux-2.6/arch/x86/mm/init_64.c
> @@ -631,6 +631,9 @@ int arch_add_memory(int nid, u64 start,
>  	ret = __add_pages(nid, zone, start_pfn, nr_pages);
>  	WARN_ON_ONCE(ret);
>  
> +	if (!ret)
> +		numa_move_cpus_to_node(nid);
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(arch_add_memory);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

This way it sounds better(correct me if I'm wrong).

regards,

Justin P. Mattock

