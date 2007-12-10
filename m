Return-Path: <linux-kernel-owner+w=401wt.eu-S1756979AbXLJTgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979AbXLJTgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 14:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbXLJTgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 14:36:32 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:37285 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbXLJTgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 14:36:31 -0500
Message-ID: <475D952D.9070207@linux.vnet.ibm.com>
Date: Tue, 11 Dec 2007 01:06:13 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC (Take 2)
References: <20071207223714.11448.91386.sendpatchset@balbir-laptop>
In-Reply-To: <20071207223714.11448.91386.sendpatchset@balbir-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> Changelog
> 
> 1. Get rid of the constant 5 (based on comments from
>                                 Geert.Uytterhoeven@sonycom.com)
> 2. Implement suggestions from Olof Johannson
> 3. Check if cmdline is NULL in fake_numa_create_new_node()
> 
> Tested with additional parameters from Olof
> 
> numa=debug,fake=
> numa=foo,fake=bar
> 
> 
> Here's a dumb simple implementation of fake NUMA nodes for PowerPC. Fake
> NUMA nodes can be specified using the following command line option
> 
> numa=fake=<node range>
> 
> node range is of the format <range1>,<range2>,...<rangeN>
> 
> Each of the rangeX parameters is passed using memparse(). I find the patch
> useful for fake NUMA emulation on my simple PowerPC machine. I've tested it
> on a non-numa box with the following arguments
> 
> numa=fake=1G
> numa=fake=1G,2G
> name=fake=1G,512M,2G
> numa=fake=1500M,2800M mem=3500M
> numa=fake=1G mem=512M
> numa=fake=1G mem=1G
> 
> This patch applies on top of 2.6.24-rc4.
> 
> All though I've tried my best to handle some of the architecture specific
> details of PowerPC, I might have overlooked something obvious, like the usage
> of an API or some architecture tweaks. The patch depends on CONFIG_NUMA and
> I decided against creating a separate config option for fake NUMA to keep
> the code simple.
> 
> Comments are as always welcome!
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> ---
> 
>  arch/powerpc/mm/numa.c |   59 ++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 54 insertions(+), 5 deletions(-)
> 
> diff -puN arch/powerpc/mm/numa.c~ppc-fake-numa-easy arch/powerpc/mm/numa.c
> --- linux-2.6.24-rc4-mm1/arch/powerpc/mm/numa.c~ppc-fake-numa-easy	2007-12-07 21:25:55.000000000 +0530
> +++ linux-2.6.24-rc4-mm1-balbir/arch/powerpc/mm/numa.c	2007-12-08 03:19:46.000000000 +0530
> @@ -24,6 +24,8 @@
> 
>  static int numa_enabled = 1;
> 
> +static char *cmdline __initdata;
> +
>  static int numa_debug;
>  #define dbg(args...) if (numa_debug) { printk(KERN_INFO args); }
> 
> @@ -39,6 +41,43 @@ static bootmem_data_t __initdata plat_no
>  static int min_common_depth;
>  static int n_mem_addr_cells, n_mem_size_cells;
> 
> +static int __cpuinit fake_numa_create_new_node(unsigned long end_pfn,
> +						unsigned int *nid)
> +{
> +	unsigned long long mem;
> +	char *p = cmdline;
> +	static unsigned int fake_nid = 0;
> +	static unsigned long long curr_boundary = 0;
> +
> +	*nid = fake_nid;
> +	if (!p)
> +		return 0;
> +
> +	mem = memparse(p, &p);
> +	if (!mem)
> +		return 0;
> +
> +	if (mem < curr_boundary)
> +		return 0;
> +
> +	curr_boundary = mem;
> +
> +	if ((end_pfn << PAGE_SHIFT) > mem) {
> +		/*
> +		 * Skip commas and spaces
> +		 */
> +		while (*p == ',' || *p == ' ' || *p == '\t')
> +			p++;
> +
> +		cmdline = p;
> +		fake_nid++;
> +		*nid = fake_nid;
> +		dbg("created new fake_node with id %d\n", fake_nid);
> +		return 1;
> +	}
> +	return 0;
> +}
> +
>  static void __cpuinit map_cpu_to_node(int cpu, int node)
>  {
>  	numa_cpu_lookup_table[cpu] = node;
> @@ -344,12 +383,14 @@ static void __init parse_drconf_memory(s
>  			if (nid == 0xffff || nid >= MAX_NUMNODES)
>  				nid = default_nid;
>  		}
> -		node_set_online(nid);
> 
>  		size = numa_enforce_memory_limit(start, lmb_size);
>  		if (!size)
>  			continue;
> 
> +		fake_numa_create_new_node(((start + size) >> PAGE_SHIFT), &nid);
> +		node_set_online(nid);
> +
>  		add_active_range(nid, start >> PAGE_SHIFT,
>  				 (start >> PAGE_SHIFT) + (size >> PAGE_SHIFT));
>  	}
> @@ -429,7 +470,6 @@ new_range:
>  		nid = of_node_to_nid_single(memory);
>  		if (nid < 0)
>  			nid = default_nid;
> -		node_set_online(nid);
> 
>  		if (!(size = numa_enforce_memory_limit(start, size))) {
>  			if (--ranges)
> @@ -438,6 +478,9 @@ new_range:
>  				continue;
>  		}
> 
> +		fake_numa_create_new_node(((start + size) >> PAGE_SHIFT), &nid);
> +		node_set_online(nid);
> +
>  		add_active_range(nid, start >> PAGE_SHIFT,
>  				(start >> PAGE_SHIFT) + (size >> PAGE_SHIFT));
> 
> @@ -461,7 +504,7 @@ static void __init setup_nonnuma(void)
>  	unsigned long top_of_ram = lmb_end_of_DRAM();
>  	unsigned long total_ram = lmb_phys_mem_size();
>  	unsigned long start_pfn, end_pfn;
> -	unsigned int i;
> +	unsigned int i, nid = 0;
> 
>  	printk(KERN_DEBUG "Top of RAM: 0x%lx, Total RAM: 0x%lx\n",
>  	       top_of_ram, total_ram);
> @@ -471,9 +514,11 @@ static void __init setup_nonnuma(void)
>  	for (i = 0; i < lmb.memory.cnt; ++i) {
>  		start_pfn = lmb.memory.region[i].base >> PAGE_SHIFT;
>  		end_pfn = start_pfn + lmb_size_pages(&lmb.memory, i);
> -		add_active_range(0, start_pfn, end_pfn);
> +
> +		fake_numa_create_new_node(end_pfn, &nid);
> +		add_active_range(nid, start_pfn, end_pfn);
> +		node_set_online(nid);
>  	}
> -	node_set_online(0);
>  }
> 
>  void __init dump_numa_cpu_topology(void)
> @@ -702,6 +747,10 @@ static int __init early_numa(char *p)
>  	if (strstr(p, "debug"))
>  		numa_debug = 1;
> 
> +	p = strstr(p, "fake=");
> +	if (p)
> +		cmdline = p + strlen("fake=");
> +
>  	return 0;
>  }
>  early_param("numa", early_numa);
> _
> 


If there are no other major objections, could we get this infrastructure
into -mm?


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
