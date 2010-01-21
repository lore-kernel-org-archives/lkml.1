Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524Ab0AUHcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab0AUHcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 02:32:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652Ab0AUHcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 02:32:11 -0500
Received: from mga10.intel.com ([192.55.52.92]:15136 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750941Ab0AUHcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 02:32:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,316,1262592000"; 
   d="scan'208";a="533161909"
Message-ID: <4B5802EF.6040603@linux.intel.com>
Date: Thu, 21 Jan 2010 15:31:59 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Ingo Molnar <mingo@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: set hotpluggable nodes in nodes_possible_map
References: <4B501C4D.4080907@linux.intel.com> <alpine.DEB.2.00.1001171338170.16238@chino.kir.corp.google.com> <86802c441001172230y137b4916h7d744a96ab75873d@mail.gmail.com> <alpine.DEB.2.00.1001180231430.20677@chino.kir.corp.google.com> <4B5592B1.9030800@linux.intel.com> <alpine.DEB.2.00.1001191513010.24223@chino.kir.corp.google.com> <4B5731E2.4040207@linux.intel.com> <alpine.DEB.2.00.1001201152040.30528@chino.kir.corp.google.com> <4B57C2DD.3050402@linux.intel.com> <alpine.DEB.2.00.1001202252320.22343@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1001202252320.22343@chino.kir.corp.google.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Thu, 21 Jan 2010, Haicheng Li wrote:
> 
>> diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
>> index a271241..c5552ae 100644
>> --- a/arch/x86/mm/srat_64.c
>> +++ b/arch/x86/mm/srat_64.c
>> @@ -27,8 +27,18 @@ int acpi_numa __initdata;
>>
>>  static struct acpi_table_slit *acpi_slit;
>>
>> +/* nodes_parsed:
>> + *  - nodes with memory on
>> + * cpu_nodes_parsed:
>> + *  - nodes with cpu on
>> + * hp_nodes_parsed:
>> + *  - nodes with hotpluggable memory region
>> + *
>> + * We union these tree nodemasks to get node_possible_map.
>> + */
>>  static nodemask_t nodes_parsed __initdata;
>>  static nodemask_t cpu_nodes_parsed __initdata;
>> +static nodemask_t hp_nodes_parsed __initdata;
>>  static struct bootnode nodes[MAX_NUMNODES] __initdata;
>>  static struct bootnode nodes_add[MAX_NUMNODES];
>>
>> @@ -229,9 +239,11 @@ update_nodes_add(int node, unsigned long start, unsigned
>> long end)
>>  			printk(KERN_ERR "SRAT: Hotplug zone not continuous.
>> Partly ignored\n");
>>  	}
>>
>> -	if (changed)
>> +	if (changed) {
>> +		node_set(node, hp_nodes_parsed);
>>  		printk(KERN_INFO "SRAT: hot plug zone found %Lx - %Lx\n",
>>  				 nd->start, nd->end);
>> +	}
>>  }
>>
>>  /* Callback for parsing of the Proximity Domain <-> Memory Area mappings */
>> @@ -380,8 +392,10 @@ int __init acpi_scan_nodes(unsigned long start, unsigned
>> long end)
>>  		return -1;
>>  	}
>>
>> -	/* Account for nodes with cpus and no memory */
>> +	/* Account for nodes with memory and cpus */
>>  	nodes_or(node_possible_map, nodes_parsed, cpu_nodes_parsed);
>> +	/* Account for nodes with hotpluggable memory regions */
>> +	nodes_or(node_possible_map, node_possible_map, hp_nodes_parsed);
>>
>>  	/* Finally register nodes */
>>  	for_each_node_mask(i, node_possible_map)
>>
>>
> 
> Nack, we don't need to add yet another nodemask because you're having 
> trouble finding a new name for a cpu_nodes_parsed.  It would be perfectly 
Hey Dave, why do you think it's just a naming issue?

What I'm concerning is that your assumption of cpu_nodes_parsed use is wrong,
cpu_nodes_parsed is needed anyway since its semantics represent the node with cpu affinity rather 
than memless node, that's also why I originally doubted cpu_node_parsed cannot handle hotplug node.
we also need hp_nodes_parsed to represent the node with hotpluggable memory region, just like why we 
need nodes_parsed to repsent node with mem on.

The code could be straightforward and easy to undertand in this way.

> acceptable to rename nodes_parsed to mem_nodes and cpu_nodes_parsed to 
> no_mem_nodes, which are even shorter.  But we definitely don't need 
> another nodemask and I think we're convoluting the bug fix here way too 
> much.  Regardless of the future nomenclature, let's please merge my patch 
> to fix the outstanding kernel issue and then propose an alternative naming 
It's important to fix the outstanding kernel issue, that's also why I keep shooting down this issue. 
I wanna fix it thru a right way rather than just get it fixed.


