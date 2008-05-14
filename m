Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777AbYENVoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbYENVoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbYENVoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:44:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41587 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757465AbYENVoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:44:20 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] mm: Fix atomic_t overflow in vm
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org
Date: Wed, 14 May 2008 22:33:03 +0100
Message-ID: <20080514213302.5631.54560.stgit@core>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

The atomic_t type is 32bit but a 64bit system can have more than 2^32
pages of virtual address space available. Without this we overflow on
ludicrously large mappings
---

 fs/proc/proc_misc.c  |    2 +-
 include/linux/mman.h |    4 ++--
 mm/mmap.c            |    4 ++--
 mm/nommu.c           |    4 ++--
 mm/swap.c            |    4 ++--
 5 files changed, 9 insertions(+), 9 deletions(-)


diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 74a323d..32dc14c 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -139,7 +139,7 @@ static int meminfo_read_proc(char *page, char **start, off_t off,
 #define K(x) ((x) << (PAGE_SHIFT - 10))
 	si_meminfo(&i);
 	si_swapinfo(&i);
-	committed = atomic_read(&vm_committed_space);
+	committed = atomic_long_read(&vm_committed_space);
 	allowed = ((totalram_pages - hugetlb_total_pages())
 		* sysctl_overcommit_ratio / 100) + total_swap_pages;
 
diff --git a/include/linux/mman.h b/include/linux/mman.h
index 87920a0..dab8892 100644
--- a/include/linux/mman.h
+++ b/include/linux/mman.h
@@ -17,14 +17,14 @@
 
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
-extern atomic_t vm_committed_space;
+extern atomic_long_t vm_committed_space;
 
 #ifdef CONFIG_SMP
 extern void vm_acct_memory(long pages);
 #else
 static inline void vm_acct_memory(long pages)
 {
-	atomic_add(pages, &vm_committed_space);
+	atomic_long_add(pages, &vm_committed_space);
 }
 #endif
 
diff --git a/mm/mmap.c b/mm/mmap.c
index fac6633..669499e 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -80,7 +80,7 @@ EXPORT_SYMBOL(vm_get_page_prot);
 int sysctl_overcommit_memory = OVERCOMMIT_GUESS;  /* heuristic overcommit */
 int sysctl_overcommit_ratio = 50;	/* default is 50% */
 int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
-atomic_t vm_committed_space = ATOMIC_INIT(0);
+atomic_long_t vm_committed_space = ATOMIC_LONG_INIT(0);
 
 /*
  * Check that a process has enough memory to allocate a new virtual
@@ -177,7 +177,7 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 	 * cast `allowed' as a signed long because vm_committed_space
 	 * sometimes has a negative value
 	 */
-	if (atomic_read(&vm_committed_space) < (long)allowed)
+	if (atomic_long_read(&vm_committed_space) < (long)allowed)
 		return 0;
 error:
 	vm_unacct_memory(pages);
diff --git a/mm/nommu.c b/mm/nommu.c
index ef8c62c..dca93fc 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -39,7 +39,7 @@ struct page *mem_map;
 unsigned long max_mapnr;
 unsigned long num_physpages;
 unsigned long askedalloc, realalloc;
-atomic_t vm_committed_space = ATOMIC_INIT(0);
+atomic_long_t vm_committed_space = ATOMIC_LONG_INIT(0);
 int sysctl_overcommit_memory = OVERCOMMIT_GUESS; /* heuristic overcommit */
 int sysctl_overcommit_ratio = 50; /* default is 50% */
 int sysctl_max_map_count = DEFAULT_MAX_MAP_COUNT;
@@ -1410,7 +1410,7 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 	 * cast `allowed' as a signed long because vm_committed_space
 	 * sometimes has a negative value
 	 */
-	if (atomic_read(&vm_committed_space) < (long)allowed)
+	if (atomic_long_read(&vm_committed_space) < (long)allowed)
 		return 0;
 error:
 	vm_unacct_memory(pages);
diff --git a/mm/swap.c b/mm/swap.c
index 91e1944..45c9f25 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -503,7 +503,7 @@ void vm_acct_memory(long pages)
 	local = &__get_cpu_var(committed_space);
 	*local += pages;
 	if (*local > ACCT_THRESHOLD || *local < -ACCT_THRESHOLD) {
-		atomic_add(*local, &vm_committed_space);
+		atomic_long_add(*local, &vm_committed_space);
 		*local = 0;
 	}
 	preempt_enable();
@@ -520,7 +520,7 @@ static int cpu_swap_callback(struct notifier_block *nfb,
 
 	committed = &per_cpu(committed_space, (long)hcpu);
 	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
-		atomic_add(*committed, &vm_committed_space);
+		atomic_long_add(*committed, &vm_committed_space);
 		*committed = 0;
 		drain_cpu_pagevecs((long)hcpu);
 	}

