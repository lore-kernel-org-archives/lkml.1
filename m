Return-Path: <linux-kernel-owner+w=401wt.eu-S1765033AbYARSd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765033AbYARSd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932075AbYARSaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:30:15 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60745 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763679AbYARSaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:30:12 -0500
Message-Id: <20080118183011.527888000@sgi.com>
References: <20080118183011.354965000@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Jan 2008 10:30:12 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu
Cc: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Eric Dumazet <dada1@cosmosbay.com>
Subject: [PATCH 1/5] x86: Change size of node ids from u8 to u16 fixup
Content-Disposition: inline; filename=big_nodeids-fixup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the size of node ids for X86_64 from 8 bits to 16 bits
to accomodate more than 256 nodes.

Introduce a "numanode_t" type for x86-generic usage.

Cc: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Christoph Lameter <clameter@sgi.com>
---
Fixup:

Size of memnode.embedded_map needs to be changed to
accomodate 16-bit node ids as suggested by Eric.

V2->V3:
    - changed memnode.embedded_map from [64-16] to [64-8]
      (and size comment to 128 bytes)

V1->V2:
    - changed pxm_to_node_map to u16
    - changed memnode map entries to u16
---
 arch/x86/mm/numa_64.c       |    2 +-
 drivers/acpi/numa.c         |    2 +-
 include/asm-x86/mmzone_64.h |    6 +++---
 include/linux/numa.h        |    6 ++++++
 4 files changed, 11 insertions(+), 5 deletions(-)

--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -88,7 +88,7 @@ static int __init allocate_cachealigned_
 	unsigned long pad, pad_addr;
 
 	memnodemap = memnode.embedded_map;
-	if (memnodemapsize <= 48)
+	if (memnodemapsize <= ARRAY_SIZE(memnode.embedded_map))
 		return 0;
 
 	pad = L1_CACHE_BYTES - 1;
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -38,7 +38,7 @@ ACPI_MODULE_NAME("numa");
 static nodemask_t nodes_found_map = NODE_MASK_NONE;
 
 /* maps to convert between proximity domain and logical node ID */
-static int pxm_to_node_map[MAX_PXM_DOMAINS]
+static numanode_t pxm_to_node_map[MAX_PXM_DOMAINS]
 				= { [0 ... MAX_PXM_DOMAINS - 1] = NID_INVAL };
 static int node_to_pxm_map[MAX_NUMNODES]
 				= { [0 ... MAX_NUMNODES - 1] = PXM_INVAL };
--- a/include/asm-x86/mmzone_64.h
+++ b/include/asm-x86/mmzone_64.h
@@ -15,9 +15,9 @@
 struct memnode {
 	int shift;
 	unsigned int mapsize;
-	u8 *map;
-	u8 embedded_map[64-16];
-} ____cacheline_aligned; /* total size = 64 bytes */
+	u16 *map;
+	u16 embedded_map[64-8];
+} ____cacheline_aligned; /* total size = 128 bytes */
 extern struct memnode memnode;
 #define memnode_shift memnode.shift
 #define memnodemap memnode.map
--- a/include/linux/numa.h
+++ b/include/linux/numa.h
@@ -10,4 +10,10 @@
 
 #define MAX_NUMNODES    (1 << NODES_SHIFT)
 
+#if MAX_NUMNODES > 256
+typedef u16 numanode_t;
+#else
+typedef u8 numanode_t;
+#endif
+
 #endif /* _LINUX_NUMA_H */

-- 
