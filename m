Return-Path: <linux-kernel-owner+w=401wt.eu-S1757087AbZEEQgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087AbZEEQgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 12:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbZEEQgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 12:36:15 -0400
Received: from relay1.sgi.com ([192.48.179.29]:55259 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754791AbZEEQgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 12:36:14 -0400
Date: Tue, 5 May 2009 11:36:08 -0500
From: Jack Steiner <steiner@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, alex.shi@intel.com,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Fix early panic issue on machines with memless node
Message-ID: <20090505163608.GA20385@sgi.com>
References: <1241493327.27664.17.camel@ymzhang> <alpine.DEB.2.00.0905042026010.29856@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905042026010.29856@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 08:32:36PM -0700, David Rientjes wrote:
> On Tue, 5 May 2009, Zhang, Yanmin wrote:
> 
> > Kernel 2.6.30-rc4 panic with boot parameter mem=2G on Nehalem machine.
> > The machines has 2 nodes and every node has about 3G memory.
> > 
> > Alex Shi did a good bisect and located the bad patch.
> > 
> > commit dc098551918093901d8ac8936e9d1a1b891b56ed
> > Author: Jack Steiner <steiner@sgi.com>
> > Date:   Fri Apr 17 09:22:42 2009 -0500
> > 
> >     x86/uv: fix init of memory-less nodes
> >     
> >     Add support for nodes that have cpus but no memory.
> >     The current code was failing to add these nodes
> >     to the nodes_present_map.
> >     
> >     v2: Fixes case caught by David Rientjes - missed support
> >         for the x2apic SRAT table.
> >     
> >     [ Impact: fix potential boot crash on memory-less UV nodes. ]
> >     
> >     Reported-by: David Rientjes <rientjes@google.com>
> >     Signed-off-by: Jack Steiner <steiner@sgi.com>
> >     LKML-Reference: <20090417142242.GA23743@sgi.com>
> >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > 
> > 
> > With earlyprintk boot parameter, we captured below dump info.
> > 
> > <6>bootmem::alloc_bootmem_core nid=0 size=0 [0 pages] align=1000 goal=1000000 lim0
> > PANIC: early exception 06 rip 10:ffffffff80a2fbe4 error 0 cr2 0
> > Pid: 0, comm: swapper Not tainted 2.6.30-rc4-ymz #3
> > Call Trace:                                        
> >  [<ffffffff80a1a195>] ? early_idt_handler+0x55/0x68  
> >  [<ffffffff80a2fbe4>] ? alloc_bootmem_core+0x91/0x2ae
> >  [<ffffffff80a2fbdc>] ? alloc_bootmem_core+0x89/0x2ae     
> >  [<ffffffff80a2fe74>] ? ___alloc_bootmem_nopanic+0x73/0xab
> >  [<ffffffff80a2af73>] ? early_node_mem+0x54/0x78      
> >  [<ffffffff80a2b0ed>] ? setup_node_bootmem+0x156/0x282
> >  [<ffffffff80a2b880>] ? acpi_scan_nodes+0x207/0x303
> >  [<ffffffff80a2b255>] ? initmem_init+0x3c/0x14c
> >  [<ffffffff80a1e33b>] ? setup_arch+0x5ba/0x760       
> >  [<ffffffff80a2e904>] ? cgroup_init_subsys+0xfc/0x105
> >  [<ffffffff80a2ea5f>] ? cgroup_init_early+0x152/0x163
> >  [<ffffffff80a1a915>] ? start_kernel+0x84/0x35e      
> >  [<ffffffff80a1a37e>] ? x86_64_start_kernel+0xe5/0xeb
> > RIP alloc_bootmem_core+0x91/0x2ae
> > 
> > Consider below call chain:
> > acpi_scan_nodes =>
> > 		???setup_node_bootmem
> > 			??? (twice) => ???early_node_mem
> > 
> > At begining, acpi_scan_nodes filters out memless nodes by calling
> > unparse_node. Patch ???dc098551918 adds the node back actually.
> > ???acpi_scan_nodes has many comments around ???unparse_node.
> > 
> > Below patch fixes it with node memory checking. Another method is just
> > to revert the bad patch.
> > 
> > ???David Rientjes, ???Jack Steiner,
> > Would you check if below patch satisfy your original objective?
> > 
> 
> Could you try this instead?

I was able to duplicate your original problem. Your patch below solves the
problem. AFAICT, it causes no new reqgressions to the various configurations
that I'm testing. (I'll add the "mem=2G" to my configs that I test).

However, I see a new regression that was not present a couple of weeks ago.
Configurations that have nodes with cpus and no memory panic during
boot. This occurs both with and without your patch and is not related to "mem=".

I need to isolate the problem but here is the stack trace. :
	Pid: 0, comm: swapper Not tainted 2.6.30-rc4-next-20090505-medusa #12
	Call Trace:
	 [<ffffffff806b919e>] early_idt_handler+0x5e/0x71
	 [<ffffffff802920fe>] ? build_zonelists_node+0x4c/0x8d
	 [<ffffffff8029333f>] __build_all_zonelists+0x1ae/0x55a
	 [<ffffffff80293932>] build_all_zonelists+0x1b5/0x263
	 [<ffffffff806b9b6e>] start_kernel+0x17a/0x3c5
	 [<ffffffff806b9140>] ? early_idt_handler+0x0/0x71
	 [<ffffffff806b92a7>] x86_64_start_reservations+0xae/0xb2
	 [<ffffffff806b93fd>] x86_64_start_kernel+0x152/0x161



> 
> 
> srat: do not register nodes beyond e820 map
> 
> The mem= option will truncate the memory map at a specified address so 
> it's not possible to register nodes with memory beyond the e820 upper 
> bound.
> 
> unparse_node() is only called when then node had memory associated with 
> it, although with the mem= option it is no longer addressable.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
> diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
> --- a/arch/x86/mm/srat_64.c
> +++ b/arch/x86/mm/srat_64.c
> @@ -361,6 +361,7 @@ static void __init unparse_node(int node)
>  {
>  	int i;
>  	node_clear(node, nodes_parsed);
> +	node_clear(node, cpu_nodes_parsed);
>  	for (i = 0; i < MAX_LOCAL_APIC; i++) {
>  		if (apicid_to_node[i] == node)
>  			apicid_to_node[i] = NUMA_NO_NODE;
