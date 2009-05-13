Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbZEMFco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbZEMFco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 01:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbZEMFcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 01:32:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:54382 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbZEMFca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 01:32:30 -0400
Message-ID: <4A0A5AA9.707@kernel.org>
Date: Tue, 12 May 2009 22:29:13 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/3] x86: remove MEMORY_HOTPLUG_RESERVE related code
References: <4A05269D.8000701@kernel.org> <20090512111623.GG25923@csn.ul.ie>
In-Reply-To: <20090512111623.GG25923@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> On Fri, May 08, 2009 at 11:45:49PM -0700, Yinghai Lu wrote:
>> after
>> | commit b263295dbffd33b0fbff670720fa178c30e3392a
>> | Author: Christoph Lameter <clameter@sgi.com>
>> | Date:   Wed Jan 30 13:30:47 2008 +0100
>> |
>> |    x86: 64-bit, make sparsemem vmemmap the only memory model
>>
>> we don't have MEMORY_HOTPLUG_RESERVE anymore.
>>
>> remove related dead code.
>>
> 
> Good spot, this removes a nice amount of code. The changelog could say
> more though, how about?
> 
> =====
> Historically, x86-64 had an architecture-specific method for memory hotplug
> whereby it scanned the SRAT for physical memory ranges that could be
> potentially used for memory hot-add later. By reserving those ranges
> without physical memory, the memmap would be allocated and left dormant
> until needed. This depended on the DISCONTIG memory model which has been
> removed so the code implementing HOTPLUG_RESERVE is now dead.
> 
> This patch removes the dead code used by MEMORY_HOTPLUG_RESERVE
thanks will use that.
> =====
> 
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  arch/x86/include/asm/numa_64.h |    3 -
>>  arch/x86/mm/numa_64.c          |    5 --
>>  arch/x86/mm/srat_64.c          |   63 +++++++------------------------------
>>  include/linux/mm.h             |    2 -
>>  mm/page_alloc.c                |   69 -----------------------------------------
>>  5 files changed, 12 insertions(+), 130 deletions(-)
>>
>> Index: linux-2.6/arch/x86/include/asm/numa_64.h
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/include/asm/numa_64.h
>> +++ linux-2.6/arch/x86/include/asm/numa_64.h
>> @@ -17,9 +17,6 @@ extern int compute_hash_shift(struct boo
>>  extern void numa_init_array(void);
>>  extern int numa_off;
>>  
>> -extern void srat_reserve_add_area(int nodeid);
>> -extern int hotadd_percent;
>> -
>>  extern s16 apicid_to_node[MAX_LOCAL_APIC];
>>  
>>  extern unsigned long numa_free_all_bootmem(void);
>> Index: linux-2.6/arch/x86/mm/numa_64.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/mm/numa_64.c
>> +++ linux-2.6/arch/x86/mm/numa_64.c
>> @@ -272,9 +272,6 @@ void __init setup_node_bootmem(int nodei
>>  		reserve_bootmem_node(NODE_DATA(nodeid), bootmap_start,
>>  				 bootmap_pages<<PAGE_SHIFT, BOOTMEM_DEFAULT);
>>  
>> -#ifdef CONFIG_ACPI_NUMA
>> -	srat_reserve_add_area(nodeid);
>> -#endif
>>  	node_set_online(nodeid);
>>  }
>>  
>> @@ -608,8 +605,6 @@ static __init int numa_setup(char *opt)
>>  #ifdef CONFIG_ACPI_NUMA
>>  	if (!strncmp(opt, "noacpi", 6))
>>  		acpi_numa = -1;
>> -	if (!strncmp(opt, "hotadd=", 7))
>> -		hotadd_percent = simple_strtoul(opt+7, NULL, 10);
> 
> Documentation/x86/x86_64/boot-options.txt now needs to be updated to
> remove the documentation on hotadd=.
> 
> Instead of ignoring the option, should a warning now be printed saying the
> option is deprecated?

that is dead for 2.6.27 (?), 2.6.28, 2.6.29, ...
guess we could remove that directly...

> 
>>  #endif
>>  	return 0;
>>  }
>> Index: linux-2.6/arch/x86/mm/srat_64.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/mm/srat_64.c
>> +++ linux-2.6/arch/x86/mm/srat_64.c
>> @@ -31,8 +31,6 @@ static nodemask_t nodes_parsed __initdat
>>  static nodemask_t cpu_nodes_parsed __initdata;
>>  static struct bootnode nodes[MAX_NUMNODES] __initdata;
>>  static struct bootnode nodes_add[MAX_NUMNODES];
>> -static int found_add_area __initdata;
>> -int hotadd_percent __initdata = 0;
>>  
>>  static int num_node_memblks __initdata;
>>  static struct bootnode node_memblk_range[NR_NODE_MEMBLKS] __initdata;
>> @@ -66,9 +64,6 @@ static __init void cutoff_node(int i, un
>>  {
>>  	struct bootnode *nd = &nodes[i];
>>  
>> -	if (found_add_area)
>> -		return;
>> -
>>  	if (nd->start < start) {
>>  		nd->start = start;
>>  		if (nd->end < nd->start)
>> @@ -86,7 +81,6 @@ static __init void bad_srat(void)
>>  	int i;
>>  	printk(KERN_ERR "SRAT: SRAT not used.\n");
>>  	acpi_numa = -1;
>> -	found_add_area = 0;
>>  	for (i = 0; i < MAX_LOCAL_APIC; i++)
>>  		apicid_to_node[i] = NUMA_NO_NODE;
>>  	for (i = 0; i < MAX_NUMNODES; i++)
>> @@ -182,24 +176,21 @@ acpi_numa_processor_affinity_init(struct
>>  	       pxm, apic_id, node);
>>  }
>>  
>> -static int update_end_of_memory(unsigned long end) {return -1;}
>> -static int hotadd_enough_memory(struct bootnode *nd) {return 1;}
>>  #ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
>>  static inline int save_add_info(void) {return 1;}
>>  #else
>>  static inline int save_add_info(void) {return 0;}
>>  #endif
>>  /*
>> - * Update nodes_add and decide if to include add are in the zone.
>> - * Both SPARSE and RESERVE need nodes_add information.
>> - * This code supports one contiguous hot add area per node.
>> + * Update nodes_add[]
>> + * This code supports one contiguous hot add area per node
>>   */
>> -static int __init
>> -reserve_hotadd(int node, unsigned long start, unsigned long end)
>> +static void __init
>> +update_nodes_add(int node, unsigned long start, unsigned long end)
>>  {
> 
> It's now very unclear what the purpose of this function is. I'm guessing it
> should be something like
> 
> validate_hotadd_region()
> This validates that the region of memory described by SRAT as suitable
> for use with memory hot-add is sane
> 
> What it was for was to validate that the SRAT looked sane and then push out the
> end of the node boundaries so that the memmap would get allocated. However,
> because we are no longer pushing out the node boundaries, is this doing
> anything useful at all any more? For sparsemem, memory-hotadd allocates
> the memmap as it required.

but it does update nodes_add range.

YH
