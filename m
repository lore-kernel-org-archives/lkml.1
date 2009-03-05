Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbZCEUG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbZCEUG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 15:06:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbZCEUGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 15:06:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:53280 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099AbZCEUGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 15:06:12 -0500
Message-ID: <49B03069.80001@kernel.org>
Date: Thu, 05 Mar 2009 12:04:57 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix warning about nodeid
References: <20090305141424.GA9294@elte.hu>
In-Reply-To: <20090305141424.GA9294@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

Ingo found there warning about nodeid with some configs.
try to use for_each_online_node for non numa too. in that case nodeid will be 0.
also move out boundary checking from setup_node_bootmem(), so non-numa config
will not check it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/init_32.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c
+++ linux-2.6/arch/x86/mm/init_32.c
@@ -806,11 +806,6 @@ static unsigned long __init setup_node_b
 {
 	unsigned long bootmap_size;
 
-	if (start_pfn > max_low_pfn)
-		return bootmap;
-	if (end_pfn > max_low_pfn)
-		end_pfn = max_low_pfn;
-
 	/* don't touch min_low_pfn */
 	bootmap_size = init_bootmem_node(NODE_DATA(nodeid),
 					 bootmap >> PAGE_SHIFT,
@@ -843,13 +838,23 @@ void __init setup_bootmem_allocator(void
 		 max_pfn_mapped<<PAGE_SHIFT);
 	printk(KERN_INFO "  low ram: 0 - %08lx\n", max_low_pfn<<PAGE_SHIFT);
 
+	for_each_online_node(nodeid) {
+		 unsigned long start_pfn, end_pfn;
+
 #ifdef CONFIG_NEED_MULTIPLE_NODES
-	for_each_online_node(nodeid)
-		bootmap = setup_node_bootmem(nodeid, node_start_pfn[nodeid],
-					node_end_pfn[nodeid], bootmap);
+		start_pfn = node_start_pfn[nodeid];
+		end_pfn = node_end_pfn[nodeid];
+		if (start_pfn > max_low_pfn)
+			continue;
+		if (end_pfn > max_low_pfn)
+			end_pfn = max_low_pfn;
 #else
-	bootmap = setup_node_bootmem(0, 0, max_low_pfn, bootmap);
+		start_pfn = 0;
+		end_pfn = max_low_pfn;
 #endif
+		bootmap = setup_node_bootmem(nodeid, start_pfn, end_pfn,
+						 bootmap);
+	}
 
 	after_bootmem = 1;
 }
