Return-Path: <linux-kernel-owner+w=401wt.eu-S1756735AbZCFGts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbZCFGts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:49:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756267AbZCFGrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:47:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:56807 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755595AbZCFGrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:47:09 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, efault@gmx.de,
       jaswinder@kernel.org, cooloney@kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 8/8] x86, percpu: setup reserved percpu area for x86_64
Date: Fri,  6 Mar 2009 15:46:28 +0900
Message-Id: <1236321988-19457-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1236321988-19457-1-git-send-email-tj@kernel.org>
References: <1236321988-19457-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 06:46:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix relocation overflow during module load

x86_64 uses 32bit relocations for symbol access and static percpu
symbols whether in core or modules must be inside 2GB of the percpu
segement base which the dynamic percpu allocator doesn't guarantee.
This patch makes x86_64 reserve PERCPU_MODULE_RESERVE bytes in the
first chunk so that module percpu areas are always allocated from the
first chunk which is always inside the relocatable range.

This problem exists for any percpu allocator but is easily triggered
when using the embedding allocator because the second chunk is located
beyond 2GB on it.

This patch also changes the meaning of PERCPU_DYNAMIC_RESERVE such
that it only indicates the size of the area to reserve for dynamic
allocation as static and dynamic areas can be separate.  New
PERCPU_DYNAMIC_RESERVED is increased by 4k for both 32 and 64bits as
the reserved area separation eats away some allocatable space and
having slightly more headroom (currently between 4 and 8k after
minimal boot sans module area) makes sense for common case
performance.

x86_32 can address anywhere from anywhere and doesn't need reserving.

Mike Galbraith first reported the problem first and bisected it to the
embedding percpu allocator commit.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Mike Galbraith <efault@gmx.de>
Reported-by: Jaswinder Singh Rajput <jaswinder@kernel.org>
---
 arch/x86/kernel/setup_percpu.c |   37 ++++++++++++++++++++++++++++---------
 include/linux/percpu.h         |   35 ++++++++++++-----------------------
 2 files changed, 40 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index dd4eabc..efa615f 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -42,6 +42,19 @@ unsigned long __per_cpu_offset[NR_CPUS] __read_mostly = {
 };
 EXPORT_SYMBOL(__per_cpu_offset);
 
+/*
+ * On x86_64 symbols referenced from code should be reachable using
+ * 32bit relocations.  Reserve space for static percpu variables in
+ * modules so that they are always served from the first chunk which
+ * is located at the percpu segment base.  On x86_32, anything can
+ * address anywhere.  No need to reserve space in the first chunk.
+ */
+#ifdef CONFIG_X86_64
+#define PERCPU_FIRST_CHUNK_RESERVE	PERCPU_MODULE_RESERVE
+#else
+#define PERCPU_FIRST_CHUNK_RESERVE	0
+#endif
+
 /**
  * pcpu_need_numa - determine percpu allocation needs to consider NUMA
  *
@@ -141,7 +154,7 @@ static ssize_t __init setup_pcpu_remap(size_t static_size)
 {
 	static struct vm_struct vm;
 	pg_data_t *last;
-	size_t ptrs_size;
+	size_t ptrs_size, dyn_size;
 	unsigned int cpu;
 	ssize_t ret;
 
@@ -169,12 +182,14 @@ proceed:
 	 * Currently supports only single page.  Supporting multiple
 	 * pages won't be too difficult if it ever becomes necessary.
 	 */
-	pcpur_size = PFN_ALIGN(static_size + PERCPU_DYNAMIC_RESERVE);
+	pcpur_size = PFN_ALIGN(static_size + PERCPU_MODULE_RESERVE +
+			       PERCPU_DYNAMIC_RESERVE);
 	if (pcpur_size > PMD_SIZE) {
 		pr_warning("PERCPU: static data is larger than large page, "
 			   "can't use large page\n");
 		return -EINVAL;
 	}
+	dyn_size = pcpur_size - static_size - PERCPU_FIRST_CHUNK_RESERVE;
 
 	/* allocate pointer array and alloc large pages */
 	ptrs_size = PFN_ALIGN(num_possible_cpus() * sizeof(pcpur_ptrs[0]));
@@ -217,8 +232,9 @@ proceed:
 	pr_info("PERCPU: Remapped at %p with large pages, static data "
 		"%zu bytes\n", vm.addr, static_size);
 
-	ret = pcpu_setup_first_chunk(pcpur_get_page, static_size, 0, PMD_SIZE,
-				     pcpur_size - static_size, vm.addr, NULL);
+	ret = pcpu_setup_first_chunk(pcpur_get_page, static_size,
+				     PERCPU_FIRST_CHUNK_RESERVE,
+				     PMD_SIZE, dyn_size, vm.addr, NULL);
 	goto out_free_ar;
 
 enomem:
@@ -276,9 +292,10 @@ static ssize_t __init setup_pcpu_embed(size_t static_size)
 		return -EINVAL;
 
 	/* allocate and copy */
-	pcpue_size = PFN_ALIGN(static_size + PERCPU_DYNAMIC_RESERVE);
+	pcpue_size = PFN_ALIGN(static_size + PERCPU_MODULE_RESERVE +
+			       PERCPU_DYNAMIC_RESERVE);
 	pcpue_unit_size = max_t(size_t, pcpue_size, PCPU_MIN_UNIT_SIZE);
-	dyn_size = pcpue_size - static_size;
+	dyn_size = pcpue_size - static_size - PERCPU_FIRST_CHUNK_RESERVE;
 
 	pcpue_ptr = pcpu_alloc_bootmem(0, num_possible_cpus() * pcpue_unit_size,
 				       PAGE_SIZE);
@@ -297,7 +314,8 @@ static ssize_t __init setup_pcpu_embed(size_t static_size)
 	pr_info("PERCPU: Embedded %zu pages at %p, static data %zu bytes\n",
 		pcpue_size >> PAGE_SHIFT, pcpue_ptr, static_size);
 
-	return pcpu_setup_first_chunk(pcpue_get_page, static_size, 0,
+	return pcpu_setup_first_chunk(pcpue_get_page, static_size,
+				      PERCPU_FIRST_CHUNK_RESERVE,
 				      pcpue_unit_size, dyn_size,
 				      pcpue_ptr, NULL);
 }
@@ -356,8 +374,9 @@ static ssize_t __init setup_pcpu_4k(size_t static_size)
 	pr_info("PERCPU: Allocated %d 4k pages, static data %zu bytes\n",
 		pcpu4k_nr_static_pages, static_size);
 
-	ret = pcpu_setup_first_chunk(pcpu4k_get_page, static_size, 0, -1, -1,
-				     NULL, pcpu4k_populate_pte);
+	ret = pcpu_setup_first_chunk(pcpu4k_get_page, static_size,
+				     PERCPU_FIRST_CHUNK_RESERVE, -1, -1, NULL,
+				     pcpu4k_populate_pte);
 	goto out_free_ar;
 
 enomem:
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 8ff1515..54a968b 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -85,31 +85,20 @@
 
 /*
  * PERCPU_DYNAMIC_RESERVE indicates the amount of free area to piggy
- * back on the first chunk if arch is manually allocating and mapping
- * it for faster access (as a part of large page mapping for example).
- * Note that dynamic percpu allocator covers both static and dynamic
- * areas, so these values are bigger than PERCPU_MODULE_RESERVE.
+ * back on the first chunk for dynamic percpu allocation if arch is
+ * manually allocating and mapping it for faster access (as a part of
+ * large page mapping for example).
  *
- * On typical configuration with modules, the following values leave
- * about 8k of free space on the first chunk after boot on both x86_32
- * and 64 when module support is enabled.  When module support is
- * disabled, it's much tighter.
+ * The following values give between one and two pages of free space
+ * after typical minimal boot (2-way SMP, single disk and NIC) with
+ * both defconfig and a distro config on x86_64 and 32.  More
+ * intelligent way to determine this would be nice.
  */
-#ifndef PERCPU_DYNAMIC_RESERVE
-#  if BITS_PER_LONG > 32
-#    ifdef CONFIG_MODULES
-#      define PERCPU_DYNAMIC_RESERVE	(24 << 10)
-#    else
-#      define PERCPU_DYNAMIC_RESERVE	(16 << 10)
-#    endif
-#  else
-#    ifdef CONFIG_MODULES
-#      define PERCPU_DYNAMIC_RESERVE	(16 << 10)
-#    else
-#      define PERCPU_DYNAMIC_RESERVE	(8 << 10)
-#    endif
-#  endif
-#endif	/* PERCPU_DYNAMIC_RESERVE */
+#if BITS_PER_LONG > 32
+#define PERCPU_DYNAMIC_RESERVE		(20 << 10)
+#else
+#define PERCPU_DYNAMIC_RESERVE		(12 << 10)
+#endif
 
 extern void *pcpu_base_addr;
 
-- 
1.6.0.2

