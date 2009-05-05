Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbZEEDcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbZEEDcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 23:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbZEEDco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 23:32:44 -0400
Received: from smtp-out.google.com ([216.239.45.13]:47904 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbZEEDcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 23:32:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=MDUX6Dm+On2lE+c6VUjU3RrgnHUWW2GwbdcSkcqeDe8sfYBFJwZeZjkV2ZF9kCR6j
	OIEbhmuMH9LbwaNVMPDHA==
Date: Mon, 4 May 2009 20:32:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: Jack Steiner <steiner@sgi.com>, alex.shi@intel.com,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Fix early panic issue on machines with memless node
In-Reply-To: <1241493327.27664.17.camel@ymzhang>
Message-ID: <alpine.DEB.2.00.0905042026010.29856@chino.kir.corp.google.com>
References: <1241493327.27664.17.camel@ymzhang>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="497827084-1046729195-1241494359=:29856"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--497827084-1046729195-1241494359=:29856
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 5 May 2009, Zhang, Yanmin wrote:

> Kernel 2.6.30-rc4 panic with boot parameter mem=2G on Nehalem machine.
> The machines has 2 nodes and every node has about 3G memory.
> 
> Alex Shi did a good bisect and located the bad patch.
> 
> commit dc098551918093901d8ac8936e9d1a1b891b56ed
> Author: Jack Steiner <steiner@sgi.com>
> Date:   Fri Apr 17 09:22:42 2009 -0500
> 
>     x86/uv: fix init of memory-less nodes
>     
>     Add support for nodes that have cpus but no memory.
>     The current code was failing to add these nodes
>     to the nodes_present_map.
>     
>     v2: Fixes case caught by David Rientjes - missed support
>         for the x2apic SRAT table.
>     
>     [ Impact: fix potential boot crash on memory-less UV nodes. ]
>     
>     Reported-by: David Rientjes <rientjes@google.com>
>     Signed-off-by: Jack Steiner <steiner@sgi.com>
>     LKML-Reference: <20090417142242.GA23743@sgi.com>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> 
> With earlyprintk boot parameter, we captured below dump info.
> 
> <6>bootmem::alloc_bootmem_core nid=0 size=0 [0 pages] align=1000 goal=1000000 lim0
> PANIC: early exception 06 rip 10:ffffffff80a2fbe4 error 0 cr2 0
> Pid: 0, comm: swapper Not tainted 2.6.30-rc4-ymz #3
> Call Trace:                                        
>  [<ffffffff80a1a195>] ? early_idt_handler+0x55/0x68  
>  [<ffffffff80a2fbe4>] ? alloc_bootmem_core+0x91/0x2ae
>  [<ffffffff80a2fbdc>] ? alloc_bootmem_core+0x89/0x2ae     
>  [<ffffffff80a2fe74>] ? ___alloc_bootmem_nopanic+0x73/0xab
>  [<ffffffff80a2af73>] ? early_node_mem+0x54/0x78      
>  [<ffffffff80a2b0ed>] ? setup_node_bootmem+0x156/0x282
>  [<ffffffff80a2b880>] ? acpi_scan_nodes+0x207/0x303
>  [<ffffffff80a2b255>] ? initmem_init+0x3c/0x14c
>  [<ffffffff80a1e33b>] ? setup_arch+0x5ba/0x760       
>  [<ffffffff80a2e904>] ? cgroup_init_subsys+0xfc/0x105
>  [<ffffffff80a2ea5f>] ? cgroup_init_early+0x152/0x163
>  [<ffffffff80a1a915>] ? start_kernel+0x84/0x35e      
>  [<ffffffff80a1a37e>] ? x86_64_start_kernel+0xe5/0xeb
> RIP alloc_bootmem_core+0x91/0x2ae
> 
> Consider below call chain:
> acpi_scan_nodes =>
> 		﻿setup_node_bootmem
> 			﻿ (twice) => ﻿early_node_mem
> 
> At begining, acpi_scan_nodes filters out memless nodes by calling
> unparse_node. Patch ﻿dc098551918 adds the node back actually.
> ﻿acpi_scan_nodes has many comments around ﻿unparse_node.
> 
> Below patch fixes it with node memory checking. Another method is just
> to revert the bad patch.
> 
> ﻿David Rientjes, ﻿Jack Steiner,
> Would you check if below patch satisfy your original objective?
> 

Could you try this instead?


srat: do not register nodes beyond e820 map

The mem= option will truncate the memory map at a specified address so 
it's not possible to register nodes with memory beyond the e820 upper 
bound.

unparse_node() is only called when then node had memory associated with 
it, although with the mem= option it is no longer addressable.

Signed-off-by: David Rientjes <rientjes@google.com>
---
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -361,6 +361,7 @@ static void __init unparse_node(int node)
 {
 	int i;
 	node_clear(node, nodes_parsed);
+	node_clear(node, cpu_nodes_parsed);
 	for (i = 0; i < MAX_LOCAL_APIC; i++) {
 		if (apicid_to_node[i] == node)
 			apicid_to_node[i] = NUMA_NO_NODE;
--497827084-1046729195-1241494359=:29856--
