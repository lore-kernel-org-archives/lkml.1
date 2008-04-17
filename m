Return-Path: <linux-kernel-owner+w=401wt.eu-S1764633AbYDQJMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764633AbYDQJMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758596AbYDQJK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:10:56 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:58873
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448AbYDQJKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:10:52 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 02/45] s390: KVM preparation: provide hook to enable pgstes in user pagetable
Date: Thu, 17 Apr 2008 12:10:07 +0300
Message-Id: <1208423450-29415-3-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

From: Carsten Otte <cotte@de.ibm.com>

The SIE instruction on s390 uses the 2nd half of the page table page to
virtualize the storage keys of a guest. This patch offers the s390_enable_sie
function, which reorganizes the page tables of a single-threaded process to
reserve space in the page table:
s390_enable_sie makes sure that the process is single threaded and then uses
dup_mm to create a new mm with reorganized page tables. The old mm is freed
and the process has now a page status extended field after every page table.

Code that wants to exploit pgstes should SELECT CONFIG_PGSTE.

This patch has a small common code hit, namely making dup_mm non-static.

Edit (Carsten): I've modified Martin's patch, following Jeremy Fitzhardinge's
review feedback. Now we do have the prototype for dup_mm in
include/linux/sched.h. Following Martin's suggestion, s390_enable_sie() does now
call task_lock() to prevent race against ptrace modification of mm_users.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Acked-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/s390/Kconfig              |    4 ++
 arch/s390/kernel/setup.c       |    4 ++
 arch/s390/mm/pgtable.c         |   65 ++++++++++++++++++++++++++++++++++++++--
 include/asm-s390/mmu.h         |    1 +
 include/asm-s390/mmu_context.h |    8 ++++-
 include/asm-s390/pgtable.h     |    1 +
 include/linux/sched.h          |    2 +
 kernel/fork.c                  |    2 +-
 8 files changed, 82 insertions(+), 5 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 1831833..3a6bfef 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -55,6 +55,10 @@ config GENERIC_LOCKBREAK
 	default y
 	depends on SMP && PREEMPT
 
+config PGSTE
+	bool
+	default y if KVM
+
 mainmenu "Linux Kernel Configuration"
 
 config S390
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 290e504..526c135 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -315,7 +315,11 @@ static int __init early_parse_ipldelay(char *p)
 early_param("ipldelay", early_parse_ipldelay);
 
 #ifdef CONFIG_S390_SWITCH_AMODE
+#ifdef CONFIG_PGSTE
+unsigned int switch_amode = 1;
+#else
 unsigned int switch_amode = 0;
+#endif
 EXPORT_SYMBOL_GPL(switch_amode);
 
 static void set_amode_and_uaccess(unsigned long user_amode,
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index fd07201..5c1aea9 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -30,11 +30,27 @@
 #define TABLES_PER_PAGE	4
 #define FRAG_MASK	15UL
 #define SECOND_HALVES	10UL
+
+void clear_table_pgstes(unsigned long *table)
+{
+	clear_table(table, _PAGE_TYPE_EMPTY, PAGE_SIZE/4);
+	memset(table + 256, 0, PAGE_SIZE/4);
+	clear_table(table + 512, _PAGE_TYPE_EMPTY, PAGE_SIZE/4);
+	memset(table + 768, 0, PAGE_SIZE/4);
+}
+
 #else
 #define ALLOC_ORDER	2
 #define TABLES_PER_PAGE	2
 #define FRAG_MASK	3UL
 #define SECOND_HALVES	2UL
+
+void clear_table_pgstes(unsigned long *table)
+{
+	clear_table(table, _PAGE_TYPE_EMPTY, PAGE_SIZE/2);
+	memset(table + 256, 0, PAGE_SIZE/2);
+}
+
 #endif
 
 unsigned long *crst_table_alloc(struct mm_struct *mm, int noexec)
@@ -153,7 +169,7 @@ unsigned long *page_table_alloc(struct mm_struct *mm)
 	unsigned long *table;
 	unsigned long bits;
 
-	bits = mm->context.noexec ? 3UL : 1UL;
+	bits = (mm->context.noexec || mm->context.pgstes) ? 3UL : 1UL;
 	spin_lock(&mm->page_table_lock);
 	page = NULL;
 	if (!list_empty(&mm->context.pgtable_list)) {
@@ -170,7 +186,10 @@ unsigned long *page_table_alloc(struct mm_struct *mm)
 		pgtable_page_ctor(page);
 		page->flags &= ~FRAG_MASK;
 		table = (unsigned long *) page_to_phys(page);
-		clear_table(table, _PAGE_TYPE_EMPTY, PAGE_SIZE);
+		if (mm->context.pgstes)
+			clear_table_pgstes(table);
+		else
+			clear_table(table, _PAGE_TYPE_EMPTY, PAGE_SIZE);
 		spin_lock(&mm->page_table_lock);
 		list_add(&page->lru, &mm->context.pgtable_list);
 	}
@@ -191,7 +210,7 @@ void page_table_free(struct mm_struct *mm, unsigned long *table)
 	struct page *page;
 	unsigned long bits;
 
-	bits = mm->context.noexec ? 3UL : 1UL;
+	bits = (mm->context.noexec || mm->context.pgstes) ? 3UL : 1UL;
 	bits <<= (__pa(table) & (PAGE_SIZE - 1)) / 256 / sizeof(unsigned long);
 	page = pfn_to_page(__pa(table) >> PAGE_SHIFT);
 	spin_lock(&mm->page_table_lock);
@@ -228,3 +247,43 @@ void disable_noexec(struct mm_struct *mm, struct task_struct *tsk)
 	mm->context.noexec = 0;
 	update_mm(mm, tsk);
 }
+
+/*
+ * switch on pgstes for its userspace process (for kvm)
+ */
+int s390_enable_sie(void)
+{
+	struct task_struct *tsk = current;
+	struct mm_struct *mm;
+	int rc;
+
+	task_lock(tsk);
+
+	rc = 0;
+	if (tsk->mm->context.pgstes)
+		goto unlock;
+
+	rc = -EINVAL;
+	if (!tsk->mm || atomic_read(&tsk->mm->mm_users) > 1 ||
+	    tsk->mm != tsk->active_mm || tsk->mm->ioctx_list)
+		goto unlock;
+
+	tsk->mm->context.pgstes = 1;	/* dirty little tricks .. */
+	mm = dup_mm(tsk);
+	tsk->mm->context.pgstes = 0;
+
+	rc = -ENOMEM;
+	if (!mm)
+		goto unlock;
+	mmput(tsk->mm);
+	tsk->mm = tsk->active_mm = mm;
+	preempt_disable();
+	update_mm(mm, tsk);
+	cpu_set(smp_processor_id(), mm->cpu_vm_mask);
+	preempt_enable();
+	rc = 0;
+unlock:
+	task_unlock(tsk);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(s390_enable_sie);
diff --git a/include/asm-s390/mmu.h b/include/asm-s390/mmu.h
index 1698e29..5dd5e7b 100644
--- a/include/asm-s390/mmu.h
+++ b/include/asm-s390/mmu.h
@@ -7,6 +7,7 @@ typedef struct {
 	unsigned long asce_bits;
 	unsigned long asce_limit;
 	int noexec;
+	int pgstes;
 } mm_context_t;
 
 #endif
diff --git a/include/asm-s390/mmu_context.h b/include/asm-s390/mmu_context.h
index b5a34c6..4c2fbf4 100644
--- a/include/asm-s390/mmu_context.h
+++ b/include/asm-s390/mmu_context.h
@@ -20,7 +20,13 @@ static inline int init_new_context(struct task_struct *tsk,
 #ifdef CONFIG_64BIT
 	mm->context.asce_bits |= _ASCE_TYPE_REGION3;
 #endif
-	mm->context.noexec = s390_noexec;
+	if (current->mm->context.pgstes) {
+		mm->context.noexec = 0;
+		mm->context.pgstes = 1;
+	} else {
+		mm->context.noexec = s390_noexec;
+		mm->context.pgstes = 0;
+	}
 	mm->context.asce_limit = STACK_TOP_MAX;
 	crst_table_init((unsigned long *) mm->pgd, pgd_entry_type(mm));
 	return 0;
diff --git a/include/asm-s390/pgtable.h b/include/asm-s390/pgtable.h
index 65154dc..8e9a629 100644
--- a/include/asm-s390/pgtable.h
+++ b/include/asm-s390/pgtable.h
@@ -966,6 +966,7 @@ static inline pte_t mk_swap_pte(unsigned long type, unsigned long offset)
 
 extern int add_shared_memory(unsigned long start, unsigned long size);
 extern int remove_shared_memory(unsigned long start, unsigned long size);
+extern int s390_enable_sie(void);
 
 /*
  * No page table caches to initialise
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6a1e7af..cb67356 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1765,6 +1765,8 @@ extern void mmput(struct mm_struct *);
 extern struct mm_struct *get_task_mm(struct task_struct *task);
 /* Remove the current tasks stale references to the old mm_struct */
 extern void mm_release(struct task_struct *, struct mm_struct *);
+/* Allocate a new mm structure and copy contents from tsk->mm */
+extern struct mm_struct *dup_mm(struct task_struct *tsk);
 
 extern int  copy_thread(int, unsigned long, unsigned long, unsigned long, struct task_struct *, struct pt_regs *);
 extern void flush_thread(void);
diff --git a/kernel/fork.c b/kernel/fork.c
index 9c042f9..4ca580a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -498,7 +498,7 @@ void mm_release(struct task_struct *tsk, struct mm_struct *mm)
  * Allocate a new mm structure and copy contents from the
  * mm structure of the passed in task structure.
  */
-static struct mm_struct *dup_mm(struct task_struct *tsk)
+struct mm_struct *dup_mm(struct task_struct *tsk)
 {
 	struct mm_struct *mm, *oldmm = current->mm;
 	int err;
-- 
1.5.5

