Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbZKSI7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbZKSI7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 03:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbZKSI7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 03:59:41 -0500
Received: from ozlabs.org ([203.10.76.45]:46490 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253AbZKSI7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 03:59:41 -0500
Cc: Ingo Molnar <mingo@redhat.com>, Mike Travis <travis@sgi.com>
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Message-Id: <200911191929.44865.rusty@rustcorp.com.au>
Date: Thu, 19 Nov 2009 19:29:44 +1030
Subject: [PATCH 1/6] cpumask: truncate mm_struct.cpu_vm_mask for CONFIG_CPUMASK_OFFSTACK
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Turns cpu_vm_mask into a bitmap, and truncate it to nr_cpu_ids if
CONFIG_CPUMASK_OFFSTACK is set.

I do this rather than the classic [0] dangling array trick, because of
init_mm, which is static and widely referenced.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/kernel/tboot.c  |    2 +-
 include/linux/mm_types.h |    8 +++++---
 kernel/fork.c            |   19 ++++++++++++++++++-
 mm/init-mm.c             |    2 +-
 4 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -242,8 +242,6 @@ struct mm_struct {
 
 	s8 oom_adj;	/* OOM kill score adjustment (bit shift) */
 
-	cpumask_t cpu_vm_mask;
-
 	/* Architecture-specific MM context */
 	mm_context_t context;
 
@@ -288,9 +286,13 @@ struct mm_struct {
 #ifdef CONFIG_MMU_NOTIFIER
 	struct mmu_notifier_mm *mmu_notifier_mm;
 #endif
+
+	/* This has to go at the end: if CONFIG_CPUMASK_OFFSTACK=y, only
+	 * nr_cpu_ids bits will actually be allocated. */
+	DECLARE_BITMAP(cpu_vm_mask, CONFIG_NR_CPUS);
 };
 
 /* Future-safe accessor for struct mm_struct's cpu_vm_mask. */
-#define mm_cpumask(mm) (&(mm)->cpu_vm_mask)
+#define mm_cpumask(mm) (to_cpumask((mm)->cpu_vm_mask))
 
 #endif /* _LINUX_MM_TYPES_H */
diff --git a/kernel/fork.c b/kernel/fork.c
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1468,6 +1468,23 @@ static void sighand_ctor(void *data)
 
 void __init proc_caches_init(void)
 {
+	unsigned int mm_size;
+
+#ifdef CONFIG_CPUMASK_OFFSTACK
+	/*
+	 * Restrict mm_struct allocations so cpu_vm_mask is only
+	 * nr_cpu_ids long.  cpu_vm_mask must be a NR_CPUS bitmap at
+	 * end for this to work.
+	 */
+	BUILD_BUG_ON(offsetof(struct mm_struct, cpu_vm_mask)
+		     + BITS_TO_LONGS(CONFIG_NR_CPUS)*sizeof(long)
+		     != sizeof(struct mm_struct));
+	mm_size = offsetof(struct mm_struct, cpu_vm_mask) +
+		BITS_TO_LONGS(nr_cpu_ids) * sizeof(long);
+#else
+	mm_size = sizeof(struct mm_struct);
+#endif
+
 	sighand_cachep = kmem_cache_create("sighand_cache",
 			sizeof(struct sighand_struct), 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_DESTROY_BY_RCU|
@@ -1482,7 +1499,7 @@ void __init proc_caches_init(void)
 			sizeof(struct fs_struct), 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
 	mm_cachep = kmem_cache_create("mm_struct",
-			sizeof(struct mm_struct), ARCH_MIN_MMSTRUCT_ALIGN,
+			mm_size, ARCH_MIN_MMSTRUCT_ALIGN,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
 	vm_area_cachep = KMEM_CACHE(vm_area_struct, SLAB_PANIC);
 	mmap_init();
diff --git a/mm/init-mm.c b/mm/init-mm.c
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -16,5 +16,5 @@ struct mm_struct init_mm = {
 	.mmap_sem	= __RWSEM_INITIALIZER(init_mm.mmap_sem),
 	.page_table_lock =  __SPIN_LOCK_UNLOCKED(init_mm.page_table_lock),
 	.mmlist		= LIST_HEAD_INIT(init_mm.mmlist),
-	.cpu_vm_mask	= CPU_MASK_ALL,
+	.cpu_vm_mask	= CPU_BITS_ALL,
 };
diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -109,7 +109,7 @@ static struct mm_struct tboot_mm = {
 	.mmap_sem       = __RWSEM_INITIALIZER(init_mm.mmap_sem),
 	.page_table_lock =  __SPIN_LOCK_UNLOCKED(init_mm.page_table_lock),
 	.mmlist         = LIST_HEAD_INIT(init_mm.mmlist),
-	.cpu_vm_mask    = CPU_MASK_ALL,
+	.cpu_vm_mask    = CPU_BITS_ALL,
 };
 
 static inline void switch_to_tboot_pt(void)

