Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab0BITeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 14:34:08 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:40012 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab0BITdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 14:33:46 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 09 Feb 2010 11:32:34 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 23/35] x86: make 32bit support NO_BOOTMEM
In-reply-to: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1265743966-17065-24-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

let's make 32bit consistent with 64bit

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/Kconfig            |    1 -
 arch/x86/kernel/early_res.c |    3 +++
 arch/x86/mm/init_32.c       |    6 ++++++
 arch/x86/mm/numa_32.c       |    3 +++
 4 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a6fedb8..24c2908 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -571,7 +571,6 @@ config PARAVIRT_DEBUG
 config NO_BOOTMEM
 	default y
 	bool "Disable Bootmem code"
-	depends on X86_64
 	---help---
 	  use early_res directly instead of bootmem before slab is ready.
 
diff --git a/arch/x86/kernel/early_res.c b/arch/x86/kernel/early_res.c
index 52804e9..38a0c61 100644
--- a/arch/x86/kernel/early_res.c
+++ b/arch/x86/kernel/early_res.c
@@ -354,6 +354,9 @@ int __init get_free_all_memory_range(struct range **rangep, int nodeid)
 
 	/* need to go over early_node_map to find out good range for node */
 	nr_range = add_from_early_node_map(range, count, nr_range, nodeid);
+#ifdef CONFIG_X86_32
+	subtract_range(range, count, max_low_pfn, -1UL);
+#endif
 	subtract_early_res(range, count);
 	nr_range = clean_sort_range(range, count);
 
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 2dccde0..262867a 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -748,6 +748,7 @@ static void __init zone_sizes_init(void)
 	free_area_init_nodes(max_zone_pfns);
 }
 
+#ifndef CONFIG_NO_BOOTMEM
 static unsigned long __init setup_node_bootmem(int nodeid,
 				 unsigned long start_pfn,
 				 unsigned long end_pfn,
@@ -767,9 +768,11 @@ static unsigned long __init setup_node_bootmem(int nodeid,
 
 	return bootmap + bootmap_size;
 }
+#endif
 
 void __init setup_bootmem_allocator(void)
 {
+#ifndef CONFIG_NO_BOOTMEM
 	int nodeid;
 	unsigned long bootmap_size, bootmap;
 	/*
@@ -781,11 +784,13 @@ void __init setup_bootmem_allocator(void)
 	if (bootmap == -1L)
 		panic("Cannot find bootmem map of size %ld\n", bootmap_size);
 	reserve_early(bootmap, bootmap + bootmap_size, "BOOTMAP");
+#endif
 
 	printk(KERN_INFO "  mapped low ram: 0 - %08lx\n",
 		 max_pfn_mapped<<PAGE_SHIFT);
 	printk(KERN_INFO "  low ram: 0 - %08lx\n", max_low_pfn<<PAGE_SHIFT);
 
+#ifndef CONFIG_NO_BOOTMEM
 	for_each_online_node(nodeid) {
 		 unsigned long start_pfn, end_pfn;
 
@@ -803,6 +808,7 @@ void __init setup_bootmem_allocator(void)
 		bootmap = setup_node_bootmem(nodeid, start_pfn, end_pfn,
 						 bootmap);
 	}
+#endif
 
 	after_bootmem = 1;
 }
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index b20760c..809baaa 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -418,7 +418,10 @@ void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
 
 	for_each_online_node(nid) {
 		memset(NODE_DATA(nid), 0, sizeof(struct pglist_data));
+		NODE_DATA(nid)->node_id = nid;
+#ifndef CONFIG_NO_BOOTMEM
 		NODE_DATA(nid)->bdata = &bootmem_node_data[nid];
+#endif
 	}
 
 	setup_bootmem_allocator();
-- 
1.6.4.2

