Return-Path: <linux-kernel-owner+w=401wt.eu-S1757377AbYBOPqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbYBOPqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 10:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbYBOPqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 10:46:14 -0500
Received: from relay2.sgi.com ([192.48.171.30]:43378 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752210AbYBOPqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 10:46:11 -0500
Message-ID: <47B5B3BD.8050205@sgi.com>
Date: Fri, 15 Feb 2008 07:46:05 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, Christoph Lameter <clameter@sgi.com>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: 2.6.24 git2/mm1: cpu_to_node mapping to non-existant nodes causing
 boot failure
References: <20080203171634.58ab668b.akpm@linux-foundation.org> <20080213175241.GA327@csn.ul.ie> <47B33ACF.5030700@sgi.com> <20080214201727.GC30841@csn.ul.ie> <47B4A774.7050509@sgi.com> <20080215020208.GA6500@csn.ul.ie>
In-Reply-To: <20080215020208.GA6500@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> On (14/02/08 12:41), Mike Travis didst pronounce:
>> Mel Gorman wrote:
>>> On (13/02/08 10:45), Mike Travis didst pronounce:
>>>> Mel Gorman wrote:
>>>>> On (03/02/08 17:16), Andrew Morton didst pronounce:
>>>>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24/2.6.24-mm1/
>>>>>>
>>>>> bl6-13 (4-way x86_64 machine) from test.kernel.org is failing to boot recent
>>>>> -mm and mainline trees. I noticed it when testing -mm before rebasing other
>>>>> patches but the oops on mainline looks the same. The full console log is
>>>>> below but the important difference between a working and non-working kernel
>>>>> is the following
>>>>>
>>>>> -PERCPU: Allocating 62512 bytes of per cpu data
>>>>> -Built 1 zonelists in Node order, mobility grouping on.  Total pages: 255875
>>>>> +PERCPU: Allocating 65560 bytes of per cpu data
>>>>> +cpu with no node 2, num_online_nodes 1
>>>>> +cpu with no node 3, num_online_nodes 1
>>>>> +Built 1 zonelists in Node order, mobility grouping on.  Total pages:
>>>>> 251257
>>>>>
>>>>> "cpu with no node 2" is actually saying that cpu 2 has no node and the
>>>>> message is a just misleading. The number of online nodes and cpu mappings
>>>>> are not adding up as I got this from a debugging patch
>>>> I'll take a closer look though I've not been able to duplicate your
>>>> error yet.  It does appear from the message text that the code is
>>>> out-of-date.  The latest "setup_per_cpu_areas()" should say:
>>>>
>>>>        "cpu %d has no node, num_online_nodes %d\n",
>>>>         i, num_online_nodes());
>>>>
>>>> There are a number of backed up patches in the queue.  I'm resubmitting
>>>> the whole set re-based on 2.6.25-rc1 shortly.  (I don't know though, that
>>>> any will address this problem.)
>>>>
>>> According to git-bisect, the problem patch is below. It doesn't back out
>>> cleanly so I haven't verified for sure the bisect is correct yet.
>> This might make sense.  This code is in preparation for the extended
>> apic's available on the new processors.  I've tested the code with
>> our simulator (with no errors) and I'm setting up to test on a real
>> machine that has multiple numa nodes.  I wonder if maybe BIOS is not
>> providing correct node data, or the ACPI parsing is in error?  You
>> might try adding "apic=debug" to the boot command line.
>>
> 
> I tried this, but the dmesg complained about a malformed option. I'll
> check out why tomorrow but it didn't appear particularly helpful.
> 
>> For the short term, we can remove this patch if it's causing the
>> problem.  A more complete patch will be available soon that contains
>> the entire set of x2apic changes.
>>
> 
> If you send me patches to apply on top of 2.6.25-rc1, I'll give them a spin
> on the machine in question. Reverting didn't work out very well as there are
> too many collisions with patches that were applied later. I eventually got
> the machine booting but it only succeeds because it only brings up one core
> on each processor.  The patch, which is pretty brain damaged is below in case
> it helps you guess what the real problem is. dmesg logs are attached of the
> vanilla failure with acpi=debug and the log with the patch applied showing
> "__cpu_up: bad cpu 1" and "__cpu_up: bad cpu3" (i.e. the second cores of
> each machine).
> 

Thanks Mel.  I'm heading up to MV today to debug on the NUMA machine.

-Mike
> 
> diff -ru linux-2.6/arch/x86/kernel/genapic_64.c linux-2.6-working/arch/x86/kernel/genapic_64.c
> --- linux-2.6/arch/x86/kernel/genapic_64.c	2008-02-14 16:32:55.000000000 -0600
> +++ linux-2.6-working/arch/x86/kernel/genapic_64.c	2008-02-14 15:46:18.000000000 -0600
> @@ -25,10 +25,10 @@
>  #endif
>  
>  /* which logical CPU number maps to which CPU (physical APIC ID) */
> -u16 x86_cpu_to_apicid_init[NR_CPUS] __initdata
> +u8 x86_cpu_to_apicid_init[NR_CPUS] __initdata
>  					= { [0 ... NR_CPUS-1] = BAD_APICID };
>  void *x86_cpu_to_apicid_early_ptr;
> -DEFINE_PER_CPU(u16, x86_cpu_to_apicid) = BAD_APICID;
> +DEFINE_PER_CPU(u8, x86_cpu_to_apicid) = BAD_APICID;
>  EXPORT_PER_CPU_SYMBOL(x86_cpu_to_apicid);
>  
>  struct genapic __read_mostly *genapic = &apic_flat;
> diff -ru linux-2.6/arch/x86/kernel/mpparse_64.c linux-2.6-working/arch/x86/kernel/mpparse_64.c
> --- linux-2.6/arch/x86/kernel/mpparse_64.c	2008-02-14 16:32:55.000000000 -0600
> +++ linux-2.6-working/arch/x86/kernel/mpparse_64.c	2008-02-14 15:45:44.000000000 -0600
> @@ -67,7 +67,7 @@
>  /* Bitmask of physically existing CPUs */
>  physid_mask_t phys_cpu_present_map = PHYSID_MASK_NONE;
>  
> -u16 x86_bios_cpu_apicid_init[NR_CPUS] __initdata
> +u8 x86_bios_cpu_apicid_init[NR_CPUS] __initdata
>  				= { [0 ... NR_CPUS-1] = BAD_APICID };
>  void *x86_bios_cpu_apicid_early_ptr;
>  DEFINE_PER_CPU(u16, x86_bios_cpu_apicid) = BAD_APICID;
> diff -ru linux-2.6/include/asm-x86/smp_64.h linux-2.6-working/include/asm-x86/smp_64.h
> --- linux-2.6/include/asm-x86/smp_64.h	2008-02-14 16:33:04.000000000 -0600
> +++ linux-2.6-working/include/asm-x86/smp_64.h	2008-02-14 15:43:01.000000000 -0600
> @@ -26,15 +26,16 @@
>  extern int smp_call_function_mask(cpumask_t mask, void (*func)(void *),
>  				  void *info, int wait);
>  
> -extern u16 __initdata x86_cpu_to_apicid_init[];
> -extern u16 __initdata x86_bios_cpu_apicid_init[];
> +extern u8 __initdata x86_cpu_to_apicid_init[];
> +extern u8 __initdata x86_bios_cpu_apicid_init[];
>  extern void *x86_cpu_to_apicid_early_ptr;
>  extern void *x86_bios_cpu_apicid_early_ptr;
> +DECLARE_PER_CPU(u8, x86_cpu_to_apicid); /* physical ID */
> +extern u8 bios_cpu_apicid[];
>  
>  DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
>  DECLARE_PER_CPU(cpumask_t, cpu_core_map);
>  DECLARE_PER_CPU(u16, cpu_llc_id);
> -DECLARE_PER_CPU(u16, x86_cpu_to_apicid);
>  DECLARE_PER_CPU(u16, x86_bios_cpu_apicid);
>  
>  static inline int cpu_present_to_apicid(int mps_cpu)
> 
> 

