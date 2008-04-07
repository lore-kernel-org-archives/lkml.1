Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbYDGUhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbYDGUhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 16:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbYDGUhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 16:37:00 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44698 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752111AbYDGUg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 16:36:59 -0400
Message-ID: <47FA85E4.5010005@sgi.com>
Date: Mon, 07 Apr 2008 13:36:52 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 01/10] x86_64: Cleanup non-smp usage of cpu maps v2
References: <20080325220650.835342000@polaris-admin.engr.sgi.com> <20080325220651.011213000@polaris-admin.engr.sgi.com> <20080326064045.GF18301@elte.hu>
In-Reply-To: <20080326064045.GF18301@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Cleanup references to the early cpu maps for the non-SMP configuration 
>> and remove some functions called for SMP configurations only.
> 
> thanks, applied.
> 
> one observation:
> 
>> +#ifdef CONFIG_SMP
>>  extern int x86_cpu_to_node_map_init[];
>>  extern void *x86_cpu_to_node_map_early_ptr;
>> +#else
>> +#define x86_cpu_to_node_map_early_ptr NULL
>> +#endif
> 
> Right now all these early_ptrs are in essence open-coded "early 
> per-cpu", right? But shouldnt we solve that in a much cleaner way: by 
> explicitly adding an early-per-cpu types and accessors, and avoid all 
> that #ifdeffery?
> 
> 	Ingo

How about something like the below? (I haven't tried compiling it yet.)

[I also thought about not restricting it to only NR_CPUS type variables
to allow for example, node-local node maps/variables.]

Thanks,
Mike
------------------------------------------------------------
include/linux/percpu.h:

#ifdef CONFIG_SMP
#define	DEFINE_EARLY_PER_CPU(type, name, initvalue)	\
	DEFINE_PER_CPU(type, name) = initvalue;		\
	type name##_early_map[NR_CPUS] __initdata =	\
		{ [0 ... NR_CPUS-1] = initvalue; }	\
	type *name##_early_ptr = name##_early_map

#define DECLARE_EARLY_PER_CPU(type, name)		\
	DECLARE_PER_CPU(type, name);			\
	extern type *name##_early_ptr;			\
	extern type  name##_early_map[]

#define EXPORT_EARLY_PER_CPU(name)			\
	EXPORT_PER_CPU(name)

/* rvalue only */
#define	early_per_cpu(name, cpu) 			\
	(name##ptr? name##ptr[cpu] : per_cpu(name, cpu))
#define	early_per_cpu_ptr(name) (name##_early_ptr)
#define	early_per_cpu_map(name, idx) (name##_early_map[idx])

#else	/* !CONFIG_SMP */
#define	DEFINE_EARLY_PER_CPU(type, name, initvalue)	\
	DEFINE_PER_CPU(type, name) = initvalue

#define DECLARE_EARLY_PER_CPU(name)			\
	DECLARE_PER_CPU(name)

#define EXPORT_EARLY_PER_CPU(name)			\
	EXPORT_PER_CPU(name)

#define	early_per_cpu(name, cpu) per_cpu(name, cpu) 
#define	early_per_cpu_ptr(name) NULL
/* no early_per_cpu_map() */

#endif	/* !CONFIG_SMP */


------------------------------------------------------------
include/asm-x86/smp.h:

DECLARE_EARLY_PER_CPU(u16, x86_cpu_to_apicid);
DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);

------------------------------------------------------------
arch/x86/kernel/setup.c:

/* which logical CPU number maps to which CPU (physical APIC ID) */
DEFINE_EARLY_PER_CPU(u16, x86_cpu_to_apicid, BAD_APICID);
DEFINE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid, BAD_APICID);
EXPORT_EARLY_PER_CPU(x86_cpu_to_apicid);
EXPORT_EARLY_PER_CPU(x86_bios_cpu_apicid);

#ifdef CONFIG_NUMA
DEFINE_EARLY_PER_CPU(int, x86_cpu_to_node, NUMA_NO_NODE);
EXPORT_EARLY_PER_CPU(x86_cpu_to_node);
#endif

...

#if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_SMP)
/*
 * Copy data used in early init routines from the initial arrays to the
 * per cpu data areas.  These arrays then become expendable and the
 * *_early_ptr's are zeroed indicating that the static arrays are gone.
 */
static void __init setup_per_cpu_maps(void)
{
	int cpu;

	for_each_possible_cpu(cpu) {
		per_cpu(x86_cpu_to_apicid, cpu) =
				early_per_cpu_map(x86_cpu_to_apicid, cpu);
		per_cpu(x86_bios_cpu_apicid, cpu) =
				early_per_cpu_map(x86_bios_cpu_apicid, cpu);
#ifdef CONFIG_NUMA
		per_cpu(x86_cpu_to_node_map, cpu) =
				early_per_cpu_map(x86_cpu_to_node_map, cpu);
#endif
	}

	/* indicate the early static arrays will soon be gone */
	early_per_cpu_ptr(x86_cpu_to_apicid) = NULL;
	early_per_cpu_ptr(x86_bios_cpu_apicid) = NULL;
#ifdef CONFIG_NUMA
	early_per_cpu_ptr(x86_cpu_to_node_map) = NULL;
#endif
	...

------------------------------------------------------------
arch/x86/mm/numa_64.c:

void __cpuinit numa_set_node(int cpu, int node)
{
	int *cpu_to_node_map = early_per_cpu_ptr(x86_cpu_to_node_map);

	if(cpu_to_node_map)
		cpu_to_node_map[cpu] = node;
	else if(per_cpu_offset(cpu))
		per_cpu(x86_cpu_to_node_map, cpu) = node;
...
void __init init_cpu_to_node(void)
{
	int i;

	for (i = 0; i < NR_CPUS; i++) {
		int node;
		u16 apicid = early_per_cpu(x86_cpu_to_apicid, i);

		if (apicid == BAD_APICID)
			continue;
...

------------------------------------------------------------
