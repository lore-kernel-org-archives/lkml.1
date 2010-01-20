Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815Ab0ATWsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab0ATWsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 17:48:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781Ab0ATWsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 17:48:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:59686 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab0ATWsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 17:48:12 -0500
Message-ID: <4B578797.3040908@kernel.org>
Date: Wed, 20 Jan 2010 14:45:43 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Haicheng Li <haicheng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: set hotpluggable nodes in nodes_possible_map
References: <4B501C4D.4080907@linux.intel.com> <alpine.DEB.2.00.1001171338170.16238@chino.kir.corp.google.com> <86802c441001172230y137b4916h7d744a96ab75873d@mail.gmail.com> <alpine.DEB.2.00.1001180231430.20677@chino.kir.corp.google.com> <4B5592B1.9030800@linux.intel.com> <alpine.DEB.2.00.1001191513010.24223@chino.kir.corp.google.com> <4B5731E2.4040207@linux.intel.com> <alpine.DEB.2.00.1001201152040.30528@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1001201152040.30528@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2010 12:10 PM, David Rientjes wrote:
> On Thu, 21 Jan 2010, Haicheng Li wrote:
> 
>> let's add more changes to fix naming issue as well since it's too confusing
>> for people to understand
>> the code logic. how about below patch?
> 
> That should be a seperate change; there's a bugfix here (my patch) and 
> then a cleanup patch that you could make incrementally on mine.  I don't 
> personally like the name "rest_nodes_parsed" since it's poor English, I 
> suggest renaming nodes_parsed to mem_nodes_parsed as I originally asked 
> and then cpu_nodes_parsed to acpi_nodes_parsed or something similiar.
> 
> Ingo, the following is my bugfix patch that addresses the issue at 
> http://patchwork.kernel.org/patch/69499.  Haicheng, can we add your 
> tested-by line?
> 
> 
> 
> x86: set hotpluggable nodes in nodes_possible_map
> 
> nodes_possible_map does not currently include nodes that have SRAT
> entries that are all ACPI_SRAT_MEM_HOT_PLUGGABLE since the bit is cleared
> in nodes_parsed if it does not have an online address range.
> 
> Unequivocally setting the bit in nodes_parsed is insufficient since
> existing code, such as acpi_get_nodes(), assumes all nodes in the map
> have online address ranges.  In fact, all code using nodes_parsed assumes
> such nodes represent an address range of online memory.
> 
> nodes_possible_map is created by unioning nodes_parsed and
> cpu_nodes_parsed; the former represents nodes with online memory and the
> latter represents memoryless nodes.  We now set the bit for hotpluggable
> nodes in cpu_nodes_parsed so that it also gets set in nodes_possible_map.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  arch/x86/mm/srat_64.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
> --- a/arch/x86/mm/srat_64.c
> +++ b/arch/x86/mm/srat_64.c
> @@ -229,9 +229,11 @@ update_nodes_add(int node, unsigned long start, unsigned long end)
>  			printk(KERN_ERR "SRAT: Hotplug zone not continuous. Partly ignored\n");
>  	}
>  
> -	if (changed)
> +	if (changed) {
> +		node_set(node, cpu_nodes_parsed);
>  		printk(KERN_INFO "SRAT: hot plug zone found %Lx - %Lx\n",
>  				 nd->start, nd->end);
> +	}
>  }
>  
>  /* Callback for parsing of the Proximity Domain <-> Memory Area mappings */

        if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) {
                update_nodes_add(node, start, end);
                /* restore nodes[node] */
                *nd = oldnode;
                if ((nd->start | nd->end) == 0)
                        node_clear(node, nodes_parsed);
        }

removing clearing with nodes_parsed is not working?

YH

