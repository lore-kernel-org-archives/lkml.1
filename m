Return-Path: <linux-kernel-owner+w=401wt.eu-S933408AbXBJMCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408AbXBJMCG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 07:02:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932112AbXBJMBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 07:01:49 -0500
Received: from ns.suse.de ([195.135.220.2]:50232 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933367AbXBJLu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:50:28 -0500
From: Andi Kleen <ak@suse.de>
References: <200702101250.142420000@suse.de>
In-Reply-To: <200702101250.142420000@suse.de>
To: Amul Shah <amul.shah@unisys.com>, Andi Kleen <ak@suse.de>,
       Rohit Seth <rohitseth@google.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.21 review I] [12/25] x86_64: x86_64-make-the-numa-hash-function-nodemap-allocation fix fix
Message-Id: <20070210115024.DFED013E04@wotan.suse.de>
Date: Sat, 10 Feb 2007 12:50:24 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Amul Shah <amul.shah@unisys.com>

- Removed an extraneous debug message from allocate_cachealigned_map

- Changed extract_lsb_from_nodes to return 63 for the case where there was
  only one memory node.  The prevents the creation of the dynamic hashmap.

- Changed extract_lsb_from_nodes to use only the starting memory address of
  a node.  On an ES7000, our nodes overlap the starting and ending address,
  meaning, that we see nodes like

	00000 - 10000
	10000 - 20000

  But other systems have nodes whose start and end addresses do not overlap.
   For example:

	00000 - 0FFFF
	10000 - 1FFFF

  In this case, using the ending address will result in an LSB much lower
  than what is possible.  In this case an LSB of 1 when in reality it should
  be 16.  

Cc: Andi Kleen <ak@suse.de>
Cc: Rohit Seth <rohitseth@google.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/x86_64/mm/numa.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

Index: linux/arch/x86_64/mm/numa.c
===================================================================
--- linux.orig/arch/x86_64/mm/numa.c
+++ linux/arch/x86_64/mm/numa.c
@@ -78,11 +78,8 @@ static int __init allocate_cachealigned_
 	unsigned long pad, pad_addr;
 
 	memnodemap = memnode.embedded_map;
-	if (memnodemapsize <= 48) {
-		printk(KERN_DEBUG "NUMA: Allocated memnodemap from %lx - %lx\n",
-		       nodemap_addr, nodemap_addr + nodemap_size);
+	if (memnodemapsize <= 48)
 		return 0;
-	}
 
 	pad = L1_CACHE_BYTES - 1;
 	pad_addr = 0x8000;
@@ -110,7 +107,7 @@ static int __init allocate_cachealigned_
 static int __init
 extract_lsb_from_nodes (const struct bootnode *nodes, int numnodes)
 {
-	int i;
+	int i, nodes_used = 0;
 	unsigned long start, end;
 	unsigned long bitfield = 0, memtop = 0;
 
@@ -119,11 +116,15 @@ extract_lsb_from_nodes (const struct boo
 		end = nodes[i].end;
 		if (start >= end)
 			continue;
-		bitfield |= start | end;
+		bitfield |= start;
+		nodes_used++;
 		if (end > memtop)
 			memtop = end;
 	}
-	i = find_first_bit(&bitfield, sizeof(unsigned long)*8);
+	if (nodes_used <= 1)
+		i = 63;
+	else
+		i = find_first_bit(&bitfield, sizeof(unsigned long)*8);
 	memnodemapsize = (memtop >> i)+1;
 	return i;
 }
