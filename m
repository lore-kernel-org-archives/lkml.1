Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbZCAHPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbZCAHPA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 02:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbZCAHOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 02:14:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:36377 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbZCAHOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 02:14:49 -0500
Message-ID: <49AA35CB.7070303@kernel.org>
Date: Sun, 01 Mar 2009 16:14:19 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
       Johannes Weiner <hannes@cmpxchg.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: [PATCH tj-percpu 3/3] bootmem, x86: further fixes for arch-specific
 bootmem wrapping
References: <49AA357C.3070006@kernel.org> <49AA35AF.8030302@kernel.org>
In-Reply-To: <49AA35AF.8030302@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 01 Mar 2009 07:14:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix new breakages introduced by previous fix

Commit c132937556f56ee4b831ef4b23f1846e05fde102 tried to clean up
bootmem arch wrapper but it wasn't quite correct.  Before the commit,
the followings were broken.

* Low level interface functions prefixed with __ ignored arch
  preference.

* reserve_bootmem(...) can't be mapped into
  reserve_bootmem_node(NODE_DATA(0)->bdata, ...) because the node is
  not preference here.  The region specified MUST fall into the
  specified region; otherwise, it will panic.

After the commit,

* If allocation fails for the arch preferred node, it should fallback
  to whatever is available.  Instead, it simply failed allocation.

There are too many internal details to allow generic wrapping and
still keep things simple for archs.  Plus, all that arch wants is a
way to prefer certain node over another.

This patch drops the generic wrapping around alloc_bootmem_core() and
add alloc_bootmem_core() instead.  If necessary, arch can define
bootmem_arch_referred_node() macro or function which takes all
allocation information and returns the preferred node.  bootmem
generic code will always try the preferred node first and then
fallback to other nodes as usual.

Breakages noted and changes reviewed by Johannes Weiner.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
---
 arch/x86/include/asm/mmzone_32.h |    8 +-----
 mm/bootmem.c                     |   45 +++++++++++++++++++++++++------------
 2 files changed, 32 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/mmzone_32.h b/arch/x86/include/asm/mmzone_32.h
index eeacf67..ede6998 100644
--- a/arch/x86/include/asm/mmzone_32.h
+++ b/arch/x86/include/asm/mmzone_32.h
@@ -92,12 +92,8 @@ static inline int pfn_valid(int pfn)
 
 #ifdef CONFIG_NEED_MULTIPLE_NODES
 /* always use node 0 for bootmem on this numa platform */
-#define alloc_bootmem_core(__bdata, size, align, goal, limit)		\
-({									\
-	bootmem_data_t __maybe_unused *	__abm_bdata_dummy = (__bdata);	\
-	__alloc_bootmem_core(NODE_DATA(0)->bdata,			\
-			     (size), (align), (goal), (limit));		\
-})
+#define bootmem_arch_preferred_node(__bdata, size, align, goal, limit)	\
+	(NODE_DATA(0)->bdata)
 #endif /* CONFIG_NEED_MULTIPLE_NODES */
 
 #endif /* _ASM_X86_MMZONE_32_H */
diff --git a/mm/bootmem.c b/mm/bootmem.c
index d7140c0..daf9271 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -37,16 +37,6 @@ static struct list_head bdata_list __initdata = LIST_HEAD_INIT(bdata_list);
 
 static int bootmem_debug;
 
-/*
- * If an arch needs to apply workarounds to bootmem allocation, it can
- * set CONFIG_HAVE_ARCH_BOOTMEM and define a wrapper around
- * __alloc_bootmem_core().
- */
-#ifndef CONFIG_HAVE_ARCH_BOOTMEM
-#define alloc_bootmem_core(bdata, size, align, goal, limit)		\
-	__alloc_bootmem_core((bdata), (size), (align), (goal), (limit))
-#endif
-
 static int __init bootmem_debug_setup(char *buf)
 {
 	bootmem_debug = 1;
@@ -436,9 +426,9 @@ static unsigned long align_off(struct bootmem_data *bdata, unsigned long off,
 	return ALIGN(base + off, align) - base;
 }
 
-static void * __init __alloc_bootmem_core(struct bootmem_data *bdata,
-				unsigned long size, unsigned long align,
-				unsigned long goal, unsigned long limit)
+static void * __init alloc_bootmem_core(struct bootmem_data *bdata,
+					unsigned long size, unsigned long align,
+					unsigned long goal, unsigned long limit)
 {
 	unsigned long fallback = 0;
 	unsigned long min, max, start, sidx, midx, step;
@@ -538,17 +528,34 @@ find_block:
 	return NULL;
 }
 
+static void * __init alloc_arch_preferred_bootmem(bootmem_data_t *bdata,
+					unsigned long size, unsigned long align,
+					unsigned long goal, unsigned long limit)
+{
+#ifdef CONFIG_HAVE_ARCH_BOOTMEM
+	bootmem_data_t *p_bdata;
+
+	p_bdata = bootmem_arch_preferred_node(bdata, size, align, goal, limit);
+	if (p_bdata)
+		return alloc_bootmem_core(p_bdata, size, align, goal, limit);
+#endif
+	return NULL;
+}
+
 static void * __init ___alloc_bootmem_nopanic(unsigned long size,
 					unsigned long align,
 					unsigned long goal,
 					unsigned long limit)
 {
 	bootmem_data_t *bdata;
+	void *region;
 
 restart:
-	list_for_each_entry(bdata, &bdata_list, list) {
-		void *region;
+	region = alloc_arch_preferred_bootmem(NULL, size, align, goal, limit);
+	if (region)
+		return region;
 
+	list_for_each_entry(bdata, &bdata_list, list) {
 		if (goal && bdata->node_low_pfn <= PFN_DOWN(goal))
 			continue;
 		if (limit && bdata->node_min_pfn >= PFN_DOWN(limit))
@@ -626,6 +633,10 @@ static void * __init ___alloc_bootmem_node(bootmem_data_t *bdata,
 {
 	void *ptr;
 
+	ptr = alloc_arch_preferred_bootmem(bdata, size, align, goal, limit);
+	if (ptr)
+		return ptr;
+
 	ptr = alloc_bootmem_core(bdata, size, align, goal, limit);
 	if (ptr)
 		return ptr;
@@ -682,6 +693,10 @@ void * __init __alloc_bootmem_node_nopanic(pg_data_t *pgdat, unsigned long size,
 {
 	void *ptr;
 
+	ptr = alloc_arch_preferred_bootmem(pgdat->bdata, size, align, goal, 0);
+	if (ptr)
+		return ptr;
+
 	ptr = alloc_bootmem_core(pgdat->bdata, size, align, goal, 0);
 	if (ptr)
 		return ptr;
-- 
1.6.0.2

