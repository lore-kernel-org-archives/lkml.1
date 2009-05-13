Return-Path: <linux-kernel-owner+w=401wt.eu-S1760522AbZEMQBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760522AbZEMQBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 12:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758316AbZEMQBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 12:01:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:46553 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756572AbZEMQBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 12:01:06 -0400
Message-ID: <4A0AEE39.8030704@kernel.org>
Date: Wed, 13 May 2009 08:58:49 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] x86: fix system without memory on node0
References: <4A05269D.8000701@kernel.org> <4A0527CB.4020807@kernel.org> <20090511175312.GA27905@sgi.com> <alpine.DEB.2.00.0905111218520.23739@chino.kir.corp.google.com> <4A0894A5.9000209@zytor.com> <alpine.DEB.2.00.0905111509570.2234@chino.kir.corp.google.com> <20090512150622.GA10015@sgi.com> <4A0A23A7.4080901@kernel.org> <20090513080010.GN19296@one.firstfloor.org>
In-Reply-To: <20090513080010.GN19296@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> +#if defined(CONFIG_X86_64) && defined(CONFIG_NUMA)
>> +	/*
>> +	 * make sure boot cpu node_number is right, when boot cpu is on the
>> +	 * node that doesn't have mem installed
>> +	 */
>> +	per_cpu(node_number, boot_cpu_id) = cpu_to_node(boot_cpu_id);
>> +#endif
> 
> Seems like a quite crappy hac^wpatch. Why is it ever set to the wrong
> value? And why is that only the case on NUMA and 64bit? 

two places touched that per_cpu(node_number,), 
1. in cpu/common.c::cpu_init() and it is not for BP
#ifdef CONFIG_NUMA
        if (cpu != 0 && percpu_read(node_number) == 0 &&
            cpu_to_node(cpu) != NUMA_NO_NODE)
                percpu_write(node_number, cpu_to_node(cpu));
#endif
for BP is traps_init ==> cpu_init
for AP is start_secondary ==> cpu_init

2. cpu/intel.c or amd.c::srat_detect_node via numa_set_node() and they are called via identify_cpu
for BP:
check_bugs ==> identify_boot_cpu ==> identify_cpu() that is rather later before numa_node_id() is used for BP...
for AP:
start_secondary=>smp_callin=>smp_store_cpu_info()=>identify_secondary_cpu ==> identify_cpu()

so only try to set that for BP more early in setup_per_cpu_areas, and don't bother set that for APs there.
(and don't want to mess the 0 before the copying BP per_cpu to APs)

or you check set the per_cpu(node_number) is early enough with setup_per_cpu_areas();


setup_percpu.c in arch/x86/kernel/ is used on lot of conf.

and in arch/x86/include/asm/topology.h, we have

#ifdef CONFIG_NUMA
#include <linux/cpumask.h>
#include <asm/mpspec.h>

#ifdef CONFIG_X86_32

/* Mappings between logical cpu number and node number */
extern int cpu_to_node_map[];

/* Returns the number of the node containing CPU 'cpu' */
static inline int cpu_to_node(int cpu)
{
        return cpu_to_node_map[cpu];
}
#define early_cpu_to_node(cpu)  cpu_to_node(cpu)

#else /* CONFIG_X86_64 */

/* Mappings between logical cpu number and node number */
DECLARE_EARLY_PER_CPU(int, x86_cpu_to_node_map);

/* Returns the number of the current Node. */
DECLARE_PER_CPU(int, node_number);
#define numa_node_id()          percpu_read(node_number)
...

so we need to for NUMA and 64 bit.


YH
