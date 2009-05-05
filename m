Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbZEEFz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbZEEFz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 01:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbZEEFzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 01:55:19 -0400
Received: from mga10.intel.com ([192.55.52.92]:43879 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751965AbZEEFzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 01:55:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,295,1239001200"; 
   d="scan'208";a="687534908"
Subject: Re: [PATCH] Fix early panic issue on machines with memless node
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: David Rientjes <rientjes@google.com>
Cc: Jack Steiner <steiner@sgi.com>, alex.shi@intel.com,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <alpine.DEB.2.00.0905042026010.29856@chino.kir.corp.google.com>
References: <1241493327.27664.17.camel@ymzhang>
	 <alpine.DEB.2.00.0905042026010.29856@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 05 May 2009 13:55:41 +0800
Message-Id: <1241502941.27664.19.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-04 at 20:32 -0700, David Rientjes wrote:
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
> > 		﻿setup_node_bootmem
> > 			﻿ (twice) => ﻿early_node_mem
> > 
> > At begining, acpi_scan_nodes filters out memless nodes by calling
> > unparse_node. Patch ﻿dc098551918 adds the node back actually.
> > ﻿acpi_scan_nodes has many comments around ﻿unparse_node.
> > 
> > Below patch fixes it with node memory checking. Another method is just
> > to revert the bad patch.
> > 
> > ﻿David Rientjes, ﻿Jack Steiner,
> > Would you check if below patch satisfy your original objective?
> > 
> 
> Could you try this instead?
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
Your patch does fix the hang issue.



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

