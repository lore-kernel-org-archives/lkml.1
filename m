Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302Ab0AQVx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab0AQVx2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 16:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847Ab0AQVx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 16:53:27 -0500
Received: from smtp-out.google.com ([216.239.33.17]:2524 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab0AQVx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 16:53:27 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=CQw6n4EIW7BoFFIbVh9N8wMIdGpZ1WWM94ORxIjXoYtFuB3JEDB3CdNPqoWikpdfH
	fMNP0Lvu3j8pYlLwEjHAQ==
Date: Sun, 17 Jan 2010 13:53:18 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Haicheng Li <haicheng.li@linux.intel.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mm/srat_64.c: nodes_parsed should include all nodes
 detected by ACPI.
In-Reply-To: <4B501C4D.4080907@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1001171338170.16238@chino.kir.corp.google.com>
References: <4B501C4D.4080907@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jan 2010, Haicheng Li wrote:

> This is to fix the bug discussed in email thread:
> http://patchwork.kernel.org/patch/69499/.
> 

It would be better to include a brief synopsis of the problem in the 
changelog instead of a citation, otherwise it obfuscates the issue it 
solves.

> Currently node_possible_map won't include the offlined node that has neither
> CPU onlined nor MEM onlined at booting time. As a result, nr_node_ids won't be
> equal to possible nodes.
> 
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: H. Peter Anvin <hpa@zytor.com>
> CC: Andi Kleen <andi@firstfloor.org>
> Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
> ---
>  arch/x86/mm/srat_64.c |   10 ++--------
>  1 files changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
> index a271241..a5bc297 100644
> --- a/arch/x86/mm/srat_64.c
> +++ b/arch/x86/mm/srat_64.c
> @@ -238,7 +238,7 @@ update_nodes_add(int node, unsigned long start, unsigned
> long end)
>  void __init
>  acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
>  {
> -	struct bootnode *nd, oldnode;
> +	struct bootnode *nd;
>  	unsigned long start, end;
>  	int node, pxm;
>  	int i;
> @@ -277,7 +277,6 @@ acpi_numa_memory_affinity_init(struct
> acpi_srat_mem_affinity *ma)
>  		return;
>  	}
>  	nd = &nodes[node];
> -	oldnode = *nd;
>  	if (!node_test_and_set(node, nodes_parsed)) {
>  		nd->start = start;
>  		nd->end = end;
> @@ -291,13 +290,8 @@ acpi_numa_memory_affinity_init(struct
> acpi_srat_mem_affinity *ma)
>  	printk(KERN_INFO "SRAT: Node %u PXM %u %lx-%lx\n", node, pxm,
>  	       start, end);
> 
> -	if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) {
> +	if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE)
>  		update_nodes_add(node, start, end);
> -		/* restore nodes[node] */
> -		*nd = oldnode;
> -		if ((nd->start | nd->end) == 0)
> -			node_clear(node, nodes_parsed);
> -	}
> 
>  	node_memblk_range[num_node_memblks].start = start;
>  	node_memblk_range[num_node_memblks].end = end;

There're a couple of issues with this patch:

 - it breaks CONFIG_MEMORY_HOTPLUG_SPARSE kernels when the SRAT reports 
   more than one entry for a single node id and the later entry does not
   specify an address range, and

 - carrying the bit for the node over in nodes_parsed is inappropriate
   since other x86 code depends on that map including only nodes with
   memory such as e820_register_active_regions() and nodes_cover_memory().

    [ The existing naming is admittedly convoluted since nodes_parsed
      represents nodes with memory and cpu_nodes_parsed represents nodes
      with only cpus; in actuality, they should probably be
      mem_nodes_parsed and no_mem_nodes_parsed, respectively, since the
      latter will now include hotpluggable nodes. ]

To fix both of these issues simultaneously, I think it would be better to 
set the bit in no_mem_nodes_parsed so that it gets unioned in 
acpi_scan_nodes() when nodes_possible_map is actually formed.
