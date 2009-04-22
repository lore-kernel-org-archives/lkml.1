Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbZDVVUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbZDVVUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 17:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288AbZDVVUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 17:20:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:38962 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454AbZDVVT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 17:19:59 -0400
Message-ID: <49EF89DF.9090404@kernel.org>
Date: Wed, 22 Apr 2009 14:19:27 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jack Steiner <steiner@sgi.com>
Subject: [PATCH] x86: check boundry in setup_node_bootmem()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


|commit dc098551918093901d8ac8936e9d1a1b891b56ed
|Author: Jack Steiner <steiner@sgi.com>
|Date:   Fri Apr 17 09:22:42 2009 -0500
|
|    x86/uv: fix init of memory-less nodes
|    
|    Add support for nodes that have cpus but no memory.
|    The current code was failing to add these nodes
|    to the nodes_present_map.
|    
|    v2: Fixes case caught by David Rientjes - missed support
|        for the x2apic SRAT table.
|    
|    [ Impact: fix potential boot crash on memory-less UV nodes. ]

cause one two sockets system that node1 doesn't have ram install crash.

becuase that patch make node_possible include cpu nodes do not have memory.

so try to check bounday in setup_node_bootmem

[Impact: fix boot panic caused by node_possible_node change]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index d73aaa8..b311a1e 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -188,6 +188,9 @@ void __init setup_node_bootmem(int nodeid, unsigned long start,
 	const int pgdat_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
 	int nid;
 
+	if (!end)
+		return;
+
 	start = roundup(start, ZONE_ALIGN);
 
 	printk(KERN_INFO "Bootmem setup node %d %016lx-%016lx\n", nodeid,
