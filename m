Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbZEEDPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbZEEDPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 23:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbZEEDPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 23:15:06 -0400
Received: from mga10.intel.com ([192.55.52.92]:11002 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751570AbZEEDPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 23:15:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,294,1239001200"; 
   d="scan'208";a="454118894"
Subject: [PATCH] Fix early panic issue on machines with memless node
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Jack Steiner <steiner@sgi.com>, David Rientjes <rientjes@google.com>
Cc: alex.shi@intel.com, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 05 May 2009 11:15:26 +0800
Message-Id: <1241493327.27664.17.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel 2.6.30-rc4 panic with boot parameter mem=2G on Nehalem machine.
The machines has 2 nodes and every node has about 3G memory.

Alex Shi did a good bisect and located the bad patch.

commit dc098551918093901d8ac8936e9d1a1b891b56ed
Author: Jack Steiner <steiner@sgi.com>
Date:   Fri Apr 17 09:22:42 2009 -0500

    x86/uv: fix init of memory-less nodes
    
    Add support for nodes that have cpus but no memory.
    The current code was failing to add these nodes
    to the nodes_present_map.
    
    v2: Fixes case caught by David Rientjes - missed support
        for the x2apic SRAT table.
    
    [ Impact: fix potential boot crash on memory-less UV nodes. ]
    
    Reported-by: David Rientjes <rientjes@google.com>
    Signed-off-by: Jack Steiner <steiner@sgi.com>
    LKML-Reference: <20090417142242.GA23743@sgi.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>



With earlyprintk boot parameter, we captured below dump info.

<6>bootmem::alloc_bootmem_core nid=0 size=0 [0 pages] align=1000 goal=1000000 lim0
PANIC: early exception 06 rip 10:ffffffff80a2fbe4 error 0 cr2 0
Pid: 0, comm: swapper Not tainted 2.6.30-rc4-ymz #3
Call Trace:                                        
 [<ffffffff80a1a195>] ? early_idt_handler+0x55/0x68  
 [<ffffffff80a2fbe4>] ? alloc_bootmem_core+0x91/0x2ae
 [<ffffffff80a2fbdc>] ? alloc_bootmem_core+0x89/0x2ae     
 [<ffffffff80a2fe74>] ? ___alloc_bootmem_nopanic+0x73/0xab
 [<ffffffff80a2af73>] ? early_node_mem+0x54/0x78      
 [<ffffffff80a2b0ed>] ? setup_node_bootmem+0x156/0x282
 [<ffffffff80a2b880>] ? acpi_scan_nodes+0x207/0x303
 [<ffffffff80a2b255>] ? initmem_init+0x3c/0x14c
 [<ffffffff80a1e33b>] ? setup_arch+0x5ba/0x760       
 [<ffffffff80a2e904>] ? cgroup_init_subsys+0xfc/0x105
 [<ffffffff80a2ea5f>] ? cgroup_init_early+0x152/0x163
 [<ffffffff80a1a915>] ? start_kernel+0x84/0x35e      
 [<ffffffff80a1a37e>] ? x86_64_start_kernel+0xe5/0xeb
RIP alloc_bootmem_core+0x91/0x2ae

Consider below call chain:
acpi_scan_nodes =>
		﻿setup_node_bootmem
			﻿ (twice) => ﻿early_node_mem

At begining, acpi_scan_nodes filters out memless nodes by calling
unparse_node. Patch ﻿dc098551918 adds the node back actually.
﻿acpi_scan_nodes has many comments around ﻿unparse_node.

Below patch fixes it with node memory checking. Another method is just
to revert the bad patch.

﻿David Rientjes, ﻿Jack Steiner,
Would you check if below patch satisfy your original objective?


﻿﻿Signed-off-by: ﻿Shi Alex <alex.shi@intel.com>
﻿﻿Signed-off-by: ﻿Zhang Yanmin <yanmin.zhang@linux.intel.com>


---

--- linux-2.6.30-rc4/arch/x86/mm/numa_64.c	2009-05-05 09:20:05.000000000 +0800
+++ linux-2.6.30-rc4_memlessnode/arch/x86/mm/numa_64.c	2009-05-05 10:28:34.000000000 +0800
@@ -199,6 +199,10 @@ void __init setup_node_bootmem(int nodei
 	start_pfn = start >> PAGE_SHIFT;
 	last_pfn = end >> PAGE_SHIFT;
 
+	bootmap_pages = bootmem_bootmap_pages(last_pfn - start_pfn);
+	if (bootmap_pages == 0)
+		return;
+
 	node_data[nodeid] = early_node_mem(nodeid, start, end, pgdat_size,
 					   SMP_CACHE_BYTES);
 	if (node_data[nodeid] == NULL)
@@ -219,7 +223,6 @@ void __init setup_node_bootmem(int nodei
 	 * early_node_mem will get that with find_e820_area instead
 	 * of alloc_bootmem, that could clash with reserved range
 	 */
-	bootmap_pages = bootmem_bootmap_pages(last_pfn - start_pfn);
 	nid = phys_to_nid(nodedata_phys);
 	if (nid == nodeid)
 		bootmap_start = roundup(nodedata_phys + pgdat_size, PAGE_SIZE);


