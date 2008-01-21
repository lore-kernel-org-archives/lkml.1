Return-Path: <linux-kernel-owner+w=401wt.eu-S1757282AbYAUVSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282AbYAUVSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 16:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756395AbYAUVQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 16:16:23 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57300 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756136AbYAUVQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 16:16:19 -0500
Message-Id: <20080121211619.044757000@sgi.com>
References: <20080121211618.599818000@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 21 Jan 2008 13:16:21 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu
Cc: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] x86: Add debug of invalid per_cpu map accesses fixup V2 with git-x86
Content-Disposition: inline; filename=debug-cpu_to_node
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a means to trap usages of per_cpu map variables before
they are setup.  Define CONFIG_DEBUG_PER_CPU_MAPS to activate.

Based on 2.6.24-rc8-mm1 + latest (08/1/21) git-x86

Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/asm-x86/topology.h |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

--- a/include/asm-x86/topology.h
+++ b/include/asm-x86/topology.h
@@ -58,7 +58,7 @@ static inline int early_cpu_to_node(int 
 
 	if (cpu_to_node_map)
 		return cpu_to_node_map[cpu];
-	else if(per_cpu_offset(cpu))
+	else if (per_cpu_offset(cpu))
 		return per_cpu(x86_cpu_to_node_map, cpu);
 	else
 		return NUMA_NO_NODE;
@@ -71,7 +71,7 @@ static inline int cpu_to_node(int cpu)
 		printk("KERN_NOTICE cpu_to_node(%d): usage too early!\n",
 			(int)cpu);
 		dump_stack();
-		return ((u16 *)x86_cpu_to_node_map_early_ptr)[cpu];
+		return ((int *)x86_cpu_to_node_map_early_ptr)[cpu];
 	}
 #endif
 	if (per_cpu_offset(cpu))
@@ -81,15 +81,6 @@ static inline int cpu_to_node(int cpu)
 }
 #endif /* CONFIG_X86_64 */
 
-static inline int cpu_to_node(int cpu)
-{
-	if(per_cpu_offset(cpu))
-		return per_cpu(x86_cpu_to_node_map, cpu);
-	else
-		return NUMA_NO_NODE;
-}
-#endif /* CONFIG_X86_64 */
-
 /*
  * Returns the number of the node containing Node 'node'. This
  * architecture is flat, so it is a pretty simple function!

-- 
