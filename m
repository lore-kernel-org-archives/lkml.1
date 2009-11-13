Return-Path: <linux-kernel-owner+w=401wt.eu-S1756068AbZKMJyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbZKMJyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 04:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbZKMJyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 04:54:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56804 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756032AbZKMJyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 04:54:49 -0500
Date: Fri, 13 Nov 2009 10:53:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: reduce srat verbosity in the kernel log
Message-ID: <20091113095350.GC1364@elte.hu>
References: <20091112171934.584037000@alcatraz.americas.sgi.com>
 <alpine.DEB.2.00.0911121247420.9544@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0911121247420.9544@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Rientjes <rientjes@google.com> wrote:

> It's possible to reduce the number of SRAT messages emitted to the kernel
> log by printing each valid pxm once and then creating bitmaps to represent
> the apic ids that map to the same node.
> 
> This reduces lines such as
> 
> 	SRAT: PXM 0 -> APIC 0 -> Node 0
> 	SRAT: PXM 0 -> APIC 1 -> Node 0
> 	SRAT: PXM 1 -> APIC 2 -> Node 1
> 	SRAT: PXM 1 -> APIC 3 -> Node 1
> 
> to
> 
> 	SRAT: PXM 0 -> APIC {0-1} -> Node 0
> 	SRAT: PXM 1 -> APIC {2-3} -> Node 1
> 
> The buffer used to store the apic id list is 128 characters in length.
> If that is too small to represent all the apic id ranges that are bound
> to a single pxm, a trailing "..." is added.  APICID_LIST_LEN should be
> manually increased for such configurations.
> 
> Acked-by: Mike Travis <travis@sgi.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  arch/x86/mm/srat_64.c |   41 +++++++++++++++++++++++++++++++++++++----
>  drivers/acpi/numa.c   |    5 +++++
>  include/linux/acpi.h  |    3 ++-
>  3 files changed, 44 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
> --- a/arch/x86/mm/srat_64.c
> +++ b/arch/x86/mm/srat_64.c
> @@ -36,6 +36,9 @@ static int num_node_memblks __initdata;
>  static struct bootnode node_memblk_range[NR_NODE_MEMBLKS] __initdata;
>  static int memblk_nodeid[NR_NODE_MEMBLKS] __initdata;
>  
> +static DECLARE_BITMAP(apicid_map, MAX_LOCAL_APIC) __initdata;
> +#define APICID_LIST_LEN	(128)
> +
>  static __init int setup_node(int pxm)
>  {
>  	return acpi_map_pxm_to_node(pxm);
> @@ -136,8 +139,6 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
>  	apicid_to_node[apic_id] = node;
>  	node_set(node, cpu_nodes_parsed);
>  	acpi_numa = 1;
> -	printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
> -	       pxm, apic_id, node);
>  }
>  
>  /* Callback for Proximity Domain -> LAPIC mapping */
> @@ -170,8 +171,40 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
>  	apicid_to_node[apic_id] = node;
>  	node_set(node, cpu_nodes_parsed);
>  	acpi_numa = 1;
> -	printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
> -	       pxm, apic_id, node);
> +}
> +
> +void __init acpi_numa_print_srat_mapping(void)
> +{
> +	char apicid_list[APICID_LIST_LEN];
> +	int i, j;
> +
> +	for (i = 0; i < MAX_PXM_DOMAINS; i++) {
> +		int len;
> +		int nid;
> +
> +		nid = pxm_to_node(i);
> +		if (nid == NUMA_NO_NODE)
> +			continue;
> +
> +		bitmap_zero(apicid_map, MAX_LOCAL_APIC);
> +		for (j = 0; j < MAX_LOCAL_APIC; j++)
> +			if (apicid_to_node[j] == nid)
> +				set_bit(j, apicid_map);
> +
> +		if (bitmap_empty(apicid_map, MAX_LOCAL_APIC))
> +			continue;
> +
> +		/*
> +		 * If the bitmap cannot be listed in a buffer of length
> +		 * APICID_LIST_LEN, then it is suffixed with "...".
> +		 */
> +		len = bitmap_scnlistprintf(apicid_list, APICID_LIST_LEN,
> +					   apicid_map, MAX_LOCAL_APIC);
> +		pr_info("SRAT: PXM %u -> APIC {%s%s} -> Node %u\n",
> +			i, apicid_list,
> +			(len == APICID_LIST_LEN - 1) ? "..." : "",
> +			nid);
> +	}
>  }

No. As i suggested many times before, just get rid of the printouts or 
make them boot-debug-flag dependent.

	Ingo
