Return-Path: <linux-kernel-owner+w=401wt.eu-S1757521AbZCCMK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521AbZCCMK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 07:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbZCCMKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 07:10:18 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:32772 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbZCCMKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 07:10:16 -0500
Subject: [PATCH] x86: set_highmem_pages_init() cleanup
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Date: Tue, 03 Mar 2009 14:10:12 +0200
Message-Id: <1236082212.2675.24.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Impact: cleanup

This patch moves set_highmem_pages_init() to arch/x86/mm/highmem_32.c. The
declaration of the function is kept in asm/numa_32.h because asm/highmem.h is
included only CONFIG_HIGHMEM is enabled so we can't put the empty static inline
function there.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/include/asm/numa_32.h |    6 +++++-
 arch/x86/mm/highmem_32.c       |   34 ++++++++++++++++++++++++++++++++++
 arch/x86/mm/init_32.c          |   12 ------------
 arch/x86/mm/numa_32.c          |   26 --------------------------
 4 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/numa_32.h b/arch/x86/include/asm/numa_32.h
index e9f5db7..a372290 100644
--- a/arch/x86/include/asm/numa_32.h
+++ b/arch/x86/include/asm/numa_32.h
@@ -4,8 +4,12 @@
 extern int pxm_to_nid(int pxm);
 extern void numa_remove_cpu(int cpu);
 
-#ifdef CONFIG_NUMA
+#ifdef CONFIG_HIGHMEM
 extern void set_highmem_pages_init(void);
+#else
+static inline void set_highmem_pages_init(void)
+{
+}
 #endif
 
 #endif /* _ASM_X86_NUMA_32_H */
diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index bcc079c..13a823c 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -1,5 +1,6 @@
 #include <linux/highmem.h>
 #include <linux/module.h>
+#include <linux/swap.h> /* for totalram_pages */
 
 void *kmap(struct page *page)
 {
@@ -156,3 +157,36 @@ EXPORT_SYMBOL(kmap);
 EXPORT_SYMBOL(kunmap);
 EXPORT_SYMBOL(kmap_atomic);
 EXPORT_SYMBOL(kunmap_atomic);
+
+#ifdef CONFIG_NUMA
+void __init set_highmem_pages_init(void)
+{
+	struct zone *zone;
+	int nid;
+
+	for_each_zone(zone) {
+		unsigned long zone_start_pfn, zone_end_pfn;
+
+		if (!is_highmem(zone))
+			continue;
+
+		zone_start_pfn = zone->zone_start_pfn;
+		zone_end_pfn = zone_start_pfn + zone->spanned_pages;
+
+		nid = zone_to_nid(zone);
+		printk(KERN_INFO "Initializing %s for node %d (%08lx:%08lx)\n",
+				zone->name, nid, zone_start_pfn, zone_end_pfn);
+
+		add_highpages_with_active_regions(nid, zone_start_pfn,
+				 zone_end_pfn);
+	}
+	totalram_pages += totalhigh_pages;
+}
+#else
+static void __init set_highmem_pages_init(void)
+{
+	add_highpages_with_active_regions(0, highstart_pfn, highend_pfn);
+
+	totalram_pages += totalhigh_pages;
+}
+#endif /* CONFIG_NUMA */
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 6fbf39f..11b827d 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -468,22 +468,10 @@ void __init add_highpages_with_active_regions(int nid, unsigned long start_pfn,
 	work_with_active_regions(nid, add_highpages_work_fn, &data);
 }
 
-#ifndef CONFIG_NUMA
-static void __init set_highmem_pages_init(void)
-{
-	add_highpages_with_active_regions(0, highstart_pfn, highend_pfn);
-
-	totalram_pages += totalhigh_pages;
-}
-#endif /* !CONFIG_NUMA */
-
 #else
 static inline void permanent_kmaps_init(pgd_t *pgd_base)
 {
 }
-static inline void set_highmem_pages_init(void)
-{
-}
 #endif /* CONFIG_HIGHMEM */
 
 void __init native_pagetable_setup_start(pgd_t *base)
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index d1f7439..a04092a 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -423,32 +423,6 @@ void __init initmem_init(unsigned long start_pfn,
 	setup_bootmem_allocator();
 }
 
-void __init set_highmem_pages_init(void)
-{
-#ifdef CONFIG_HIGHMEM
-	struct zone *zone;
-	int nid;
-
-	for_each_zone(zone) {
-		unsigned long zone_start_pfn, zone_end_pfn;
-
-		if (!is_highmem(zone))
-			continue;
-
-		zone_start_pfn = zone->zone_start_pfn;
-		zone_end_pfn = zone_start_pfn + zone->spanned_pages;
-
-		nid = zone_to_nid(zone);
-		printk(KERN_INFO "Initializing %s for node %d (%08lx:%08lx)\n",
-				zone->name, nid, zone_start_pfn, zone_end_pfn);
-
-		add_highpages_with_active_regions(nid, zone_start_pfn,
-				 zone_end_pfn);
-	}
-	totalram_pages += totalhigh_pages;
-#endif
-}
-
 #ifdef CONFIG_MEMORY_HOTPLUG
 static int paddr_to_nid(u64 addr)
 {
-- 
1.5.4.3



