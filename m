Return-Path: <linux-kernel-owner+w=401wt.eu-S1757411AbZJ3TyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411AbZJ3TyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 15:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757393AbZJ3TyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 15:54:08 -0400
Received: from smtp-out.google.com ([216.239.45.13]:35848 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757391AbZJ3TyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 15:54:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=svGfJIHgZyZJHz3Z1oaGfizcvgrN9YeZuWhqjZsFc1br1LPJIr9Z/y5nVhTgY5TmK
	TlRnxA1vWjhIyL1bPPvRA==
Date: Fri, 30 Oct 2009 12:54:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mike Travis <travis@sgi.com>
cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: Limit the number of processor bootup messages
In-Reply-To: <4AEB3D95.50300@sgi.com>
Message-ID: <alpine.DEB.2.00.0910301248390.1090@chino.kir.corp.google.com>
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233746.128967000@alcatraz.americas.sgi.com> <87tyxmy6x6.fsf@basil.nowhere.org> <4AE5E48F.6020408@sgi.com> <20091026215544.GA3355@basil.fritz.box> <4AEB3D95.50300@sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Oct 2009, Mike Travis wrote:

> x86_64: Limit the number of processor bootup messages
> 
> With a large number of processors in a system there is an excessive amount
> of messages sent to the system console.  It's estimated that with 4096
> processors in a system, and the console baudrate set to 56K, the startup
> messages will take about 84 minutes to clear the serial port.
> 
> This set of patches limits the number of repetitious messages which contain
> no additional information.  Much of this information is obtainable from the
> /proc and /sysfs.   Most of the messages are also sent to the kernel log
> buffer as KERN_DEBUG messages so it can be used to examine more closely any
> details specific to a processor.
> 
> The list of message transformations....
> 
> For system_state == SYSTEM_BOOTING:
> 
> 	[   25.388280] Booting Processors 1-7,320-327, Node 0
> 	[   26.064742] Booting Processors 8-15,328-335, Node 1
> 	[   26.837006] Booting Processors 16-31,336-351, Nodes 2-3
> 	[   28.440427] Booting Processors 32-63,352-383, Nodes 4-7
> 	[   31.640450] Booting Processors 64-127,384-447, Nodes 8-15
> 	[   38.041430] Booting Processors 128-255,448-575, Nodes 16-31
> 	[   50.917504] Booting Processors 256-319,576-639, Nodes 32-39
> 	[   90.964169] Brought up 640 CPUs
> 
> The range of processors increases as a power of 2, so 4096 CPU's should
> only take 12 lines.
> 
> (QUESTION: print_summary_bootmsg() is in the __init section and is called
> from a __cpuinit function, but only when system is booting.  Is there a
> special flag to handle this case?)
> 

That's fine, init.text will still be valid as long as cpuinit.text is and 
there will be no hotplug considerations.

> For Processor Information printout:
> 
> 	[   90.968381] Summary Processor Information for CPUS: 0-639
> 	[   90.972033] Genuine Intel(R) CPU    0000 @ 2.13GHz stepping 04
> 	[   90.981402] CPU: L1 I cache: 32K, L1 D cache: 32K
> 	[   90.985888] CPU: L2 cache: 256K
> 	[   90.988032] CPU: L3 cache: 24576K
> 	[   90.992032] MIN 4266.68 BogoMIPS (lpj=8533371)
> 	[   91.000033] MAX 4267.89 BogoMIPS (lpj=8535789)
> 
> These lines have been moved to loglevel KERN_DEBUG:
> 
> 	CPU: Physical Processor ID:
> 	CPU: Processor Core ID:
> 	CPU %d/0x%x -> Node %d
> 	<cache line sizes per cpu>
> 	CPUx is down
> 
> This message has been changed to loglevel KERN_DEBUG if system is booting
> and KERN_INFO otherwise:
> 
> 	CPU %d is now offline
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> ---
> arch/x86/include/asm/processor.h           |    4
> arch/x86/kernel/cpu/addon_cpuid_features.c |    4 arch/x86/kernel/cpu/amd.c
> |    2 arch/x86/kernel/cpu/common.c               |   23 +++-
> arch/x86/kernel/cpu/intel.c                |    2
> arch/x86/kernel/cpu/intel_cacheinfo.c      |   22 +---
> arch/x86/kernel/smpboot.c                  |  154
> ++++++++++++++++++++++++++++-
> kernel/cpu.c                               |    2 8 files changed, 187
> insertions(+), 26 deletions(-)
> 
> --- linux.orig/arch/x86/include/asm/processor.h
> +++ linux/arch/x86/include/asm/processor.h
> @@ -111,6 +111,9 @@
> 	u16			cpu_core_id;
> 	/* Index into per_cpu list: */
> 	u16			cpu_index;
> +	/* Interior Cache Sizes: */
> +	u16			l1i, l1d, l2;
> +	u32			l3;
> #endif
> 	unsigned int		x86_hyper_vendor;
> } __attribute__((__aligned__(SMP_CACHE_BYTES)));
> @@ -169,6 +172,7 @@
> extern void identify_boot_cpu(void);
> extern void identify_secondary_cpu(struct cpuinfo_x86 *);
> extern void print_cpu_info(struct cpuinfo_x86 *);
> +extern void print_cache_info(struct cpuinfo_x86 *, char *msglvl);
> extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
> extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
> extern unsigned short num_cache_leaves;
> --- linux.orig/arch/x86/kernel/cpu/addon_cpuid_features.c
> +++ linux/arch/x86/kernel/cpu/addon_cpuid_features.c
> @@ -128,10 +128,10 @@
> 	c->x86_max_cores = (core_level_siblings / smp_num_siblings);
> 
> 
> -	printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
> +	printk(KERN_DEBUG  "CPU: Physical Processor ID: %d\n",
> 	       c->phys_proc_id);
> 	if (c->x86_max_cores > 1)
> -		printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
> +		printk(KERN_DEBUG  "CPU: Processor Core ID: %d\n",
> 		       c->cpu_core_id);
> 	return;
> #endif

Perhaps an opporunity to move these to pr_debug() instead?

> --- linux.orig/arch/x86/kernel/cpu/amd.c
> +++ linux/arch/x86/kernel/cpu/amd.c
> @@ -376,7 +376,7 @@
> 	}
> 	numa_set_node(cpu, node);
> 
> -	printk(KERN_INFO "CPU %d/0x%x -> Node %d\n", cpu, apicid, node);
> +	printk(KERN_DEBUG "CPU %d/0x%x -> Node %d\n", cpu, apicid, node);
> #endif
> }
> 
> --- linux.orig/arch/x86/kernel/cpu/common.c
> +++ linux/arch/x86/kernel/cpu/common.c
> @@ -475,9 +475,9 @@
> 
> out:
> 	if ((c->x86_max_cores * smp_num_siblings) > 1) {
> -		printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
> +		printk(KERN_DEBUG  "CPU: Physical Processor ID: %d\n",
> 		       c->phys_proc_id);
> -		printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
> +		printk(KERN_DEBUG  "CPU: Processor Core ID: %d\n",
> 		       c->cpu_core_id);
> 	}
> #endif
> @@ -967,6 +967,23 @@
> #endif
> }
> 
> +void __cpuinit print_cache_info(struct cpuinfo_x86 *c, char *lvl)
> +{
> +	if (c->l1i)
> +		printk("%sCPU: L1 I cache: %dK", lvl, c->l1i);
> +
> +	if (c->l1d)
> +		printk(KERN_CONT ", L1 D cache: %dK\n", c->l1d);
> +	else
> +		printk(KERN_CONT "\n");
> +
> +	if (c->l2)
> +		printk("%sCPU: L2 cache: %dK\n", lvl, c->l2);
> +
> +	if (c->l3)
> +		printk("%sCPU: L3 cache: %dK\n", lvl, c->l3);
> +}
> +
> static __init int setup_disablecpuid(char *arg)
> {
> 	int bit;
> @@ -1115,7 +1132,7 @@
> 	if (cpumask_test_and_set_cpu(cpu, cpu_initialized_mask))
> 		panic("CPU#%d already initialized!\n", cpu);
> 
> -	printk(KERN_INFO "Initializing CPU#%d\n", cpu);
> +	printk(KERN_DEBUG "Initializing CPU#%d\n", cpu);
> 
> 	clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
> 
> --- linux.orig/arch/x86/kernel/cpu/intel.c
> +++ linux/arch/x86/kernel/cpu/intel.c
> @@ -267,7 +267,7 @@
> 		node = first_node(node_online_map);
> 	numa_set_node(cpu, node);
> 
> -	printk(KERN_INFO "CPU %d/0x%x -> Node %d\n", cpu, apicid, node);
> +	printk(KERN_DEBUG "CPU %d/0x%x -> Node %d\n", cpu, apicid, node);
> #endif
> }
> 
> --- linux.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
> +++ linux/arch/x86/kernel/cpu/intel_cacheinfo.c
> @@ -489,23 +489,17 @@
> 	}
> 
> 	if (trace)
> -		printk(KERN_INFO "CPU: Trace cache: %dK uops", trace);
> -	else if (l1i)
> -		printk(KERN_INFO "CPU: L1 I cache: %dK", l1i);
> -
> -	if (l1d)
> -		printk(KERN_CONT ", L1 D cache: %dK\n", l1d);
> -	else
> -		printk(KERN_CONT "\n");
> -
> -	if (l2)
> -		printk(KERN_INFO "CPU: L2 cache: %dK\n", l2);
> -
> -	if (l3)
> -		printk(KERN_INFO "CPU: L3 cache: %dK\n", l3);
> +		printk(KERN_DEBUG "CPU: Trace cache: %dK uops", trace);
> 
> +	c->l1i = l1i;
> +	c->l1d = l1d;
> +	c->l2 = l2;
> +	c->l3 = l3;
> 	c->x86_cache_size = l3 ? l3 : (l2 ? l2 : (l1i+l1d));
> 
> +	print_cache_info(c,
> +		system_state == SYSTEM_BOOTING? KERN_DEBUG : KERN_INFO);
> +
> 	return l2;
> }
> 
> --- linux.orig/arch/x86/kernel/smpboot.c
> +++ linux/arch/x86/kernel/smpboot.c
> @@ -442,6 +442,94 @@
> 		return c->llc_shared_map;
> }
> 
> +/* Summarize Processor Information */
> +static void __init summarize_cpu_info(void)
> +{
> +	cpumask_var_t cpulist, cpusdone;
> +	int cpu;
> +	int err = 0;
> +
> +	if (!alloc_cpumask_var(&cpulist, GFP_KERNEL))
> +		err = 1;
> +
> +	else if (!alloc_cpumask_var(&cpusdone, GFP_KERNEL)) {
> +		free_cpumask_var(cpulist);
> +		err = 1;
> +	}
> +
> +	if (err) {
> +		printk(KERN_INFO "Can't print processor summaries\n");
> +		return;
> +	}
> +
> +	cpumask_clear(cpusdone);
> +	for (cpu = 0; cpu < nr_cpu_ids; cpu++) {
> +		struct cpuinfo_x86 *c;
> +		int l1i, l1d, l2, l3;
> +		int x86, x86_vendor, x86_model, x86_mask;
> +		char buf[64];
> +		int ncpu;
> +		unsigned long minlpj, maxlpj;
> +
> +		/* skip if cpu has already been displayed */
> +		if (cpumask_test_cpu(cpu, cpusdone))
> +			continue;
> +
> +		c = &cpu_data(cpu);
> +		l1i = c->l1i;
> +		l1d = c->l1d;
> +		l2 = c->l2;
> +		l3 = c->l3;
> +		x86 = c->x86;
> +		x86_vendor = c->x86_vendor;
> +		x86_model = c->x86_model;
> +		x86_mask = c->x86_mask;
> +		minlpj = ULONG_MAX;
> +		maxlpj = 0;
> +
> +		cpumask_clear(cpulist);
> +
> +		/* collate all cpus with same specifics */
> +		for (ncpu = cpu; ncpu < nr_cpu_ids; ncpu++) {
> +			if (l1i != cpu_data(ncpu).l1i ||
> +			    l1d != cpu_data(ncpu).l1d ||
> +			    l2 != cpu_data(ncpu).l2 ||
> +			    l3 != cpu_data(ncpu).l3 ||
> +			    x86 != cpu_data(ncpu).x86 ||
> +			    x86_vendor != cpu_data(ncpu).x86_vendor ||
> +			    x86_model != cpu_data(ncpu).x86_model ||
> +			    x86_mask != cpu_data(ncpu).x86_mask)
> +			    	continue;
> +
> +			cpumask_set_cpu(ncpu, cpulist);
> +			cpumask_set_cpu(ncpu, cpusdone);
> +
> +			if (cpu_data(ncpu).loops_per_jiffy < minlpj)
> +				minlpj = cpu_data(ncpu).loops_per_jiffy;
> +
> +			if (cpu_data(ncpu).loops_per_jiffy > maxlpj)
> +				maxlpj = cpu_data(ncpu).loops_per_jiffy;
> +		}
> +
> +		cpulist_scnprintf(buf, sizeof(buf), cpulist);
> +		printk(KERN_INFO
> +			"Summary Processor Information for CPUS: %s\n", buf);
> +
> +		printk(KERN_INFO);
> +		print_cpu_info(c);
> +		print_cache_info(c, KERN_INFO);
> +
> +		printk(KERN_INFO "MIN %lu.%02lu BogoMIPS (lpj=%lu)\n",
> +			minlpj/(500000/HZ), (minlpj/(5000/HZ)) % 100, minlpj);
> +
> +		printk(KERN_INFO "MAX %lu.%02lu BogoMIPS (lpj=%lu)\n",
> +			maxlpj/(500000/HZ), (maxlpj/(5000/HZ)) % 100, maxlpj);
> +	}
> +
> +	free_cpumask_var(cpusdone);
> +	free_cpumask_var(cpulist);
> +}
> +
> static void impress_friends(void)
> {
> 	int cpu;
> @@ -671,6 +759,50 @@
> 	complete(&c_idle->done);
> }
> 
> +/* Summarize the "Booting processor ..." startup messages */
> +static void __init print_summary_bootmsg(int cpu)
> +{
> +	static int next_node, node_shift;
> +	int node = cpu_to_node(cpu);
> +
> +	if (node >= next_node) {
> +		cpumask_var_t cpulist;
> +
> +		node = next_node;
> +		next_node = 1 << node_shift;
> +		node_shift++;
> +
> +		if (alloc_cpumask_var(&cpulist, GFP_KERNEL)) {
> +			int i, tmp, last_node = node;
> +			char buf[32];
> +
> +			cpumask_clear(cpulist);
> +			for_each_present_cpu(i) {
> +				if (i == 0)	/* boot cpu */
> +					continue;
> +
> +				tmp = cpu_to_node(i);
> +				if (node <= tmp && tmp < next_node) {
> +					cpumask_set_cpu(i, cpulist);
> +					if (last_node < tmp)
> +						last_node = tmp;
> +				}
> +			}
> +			if (cpumask_weight(cpulist)) {
> +				cpulist_scnprintf(buf, sizeof(buf), cpulist);
> +				printk(KERN_INFO "Booting Processors %s,",
> buf);
> +
> +				if (node == last_node)
> +					printk(KERN_CONT " Node %d\n", node);
> +				else
> +					printk(KERN_CONT " Nodes %d-%d\n",
> +						node, last_node);
> +			}
> +			free_cpumask_var(cpulist);
> +		}
> +	}
> +}
> +
> /*
>  * NOTE - on most systems this is a PHYSICAL apic ID, but on multiquad
>  * (ie clustered apic addressing mode), this is a LOGICAL apic ID.

Why isn't cpumask_of_node() available yet?
