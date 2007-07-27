Return-Path: <linux-kernel-owner+w=401wt.eu-S934815AbXG0H6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934815AbXG0H6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 03:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762715AbXG0H6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 03:58:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:21093 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762145AbXG0H6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 03:58:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,587,1175497200"; 
   d="scan'208";a="110532993"
Subject: [PATCH] remove hugetlb_instantiation_mutex
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: agl@us.ibm.com
Content-Type: text/plain; charset=utf-8
Date: Fri, 27 Jul 2007 15:57:49 +0800
Message-Id: <1185523069.4688.115.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hugetlb_instantiation_mutex is a big lock in function hugetlb_fault. It serializes
all hugetlb page faults, no matter if the faults happen in the same address space,
and no matter if the faults are related to the same inode.

Why is there such a big lock? Huge pages are limited resources. When the free huge
pages are not many, for example only 1 is left, if many threads/processes trigger page
faults on the same logical huge page of the same inode at the same time, they compete
to apply for free huge page for the same index. So some of them couldn't get the huge
page and are killed by kernel. The root cause is when a huge page is dequeued from
the free list, just before being added to the page cache tree or mapping to page table,
other threads/processes might also apply for the huge page. Because the huge page is on
flight, neither in page cache tree, nor in page table mapping, so the late threads/processes
couldn't get the last free huge page and be killed. hugetlb_instantiation_mutex
prevents such behavior.

To remove the big lock, I worked out the patch against kernel 2.6.22.
1) Add flight_blocks in struct hugetlbfs_sb_info to record the quota in flight;
2) Add flight_huge_pages to record the huge pages in flight;
3) Add function hugetlb_commit_quota and hugetlb_rollback_quota. When a quota becomes
non-flight from flight, call hugetlb_commit_quota or hugetlb_rollback_quota, based on
if the fault succeeds.
4) Add function hugetlb_commit_page and hugetlb_rollback_page. When a huge page becomes
non-flight from flight, call hugetlb_commit_page or hugetlb_rollback_page, based on
if the fault succeeds.
5) When there is a flight page/quota, if the thread couldn't get a free page/quota, but
there is a flight page/quota, the thread will go back to retry.

My patch also fixed a bug in function hugetlb_no_page about quota. If a huge page
is in page cache, but 2 threads of a process fault on it at the same time, the late one
will call hugetlb_rollback_quota at the backout path incorrectly.

If there is no contention, the patch won't add much overhead. If there are many contentions,
mostly, the performance could be improved.

I have a hugetlb test suite. I ran it in a loop for a couple of hours and didn't
find anything bad.

Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>

---

--- linux-2.6.22/fs/hugetlbfs/inode.c	2007-07-09 07:32:17.000000000 +0800
+++ linux-2.6.22_hugetlb/fs/hugetlbfs/inode.c	2007-07-26 14:52:04.000000000 +0800
@@ -662,6 +662,7 @@ hugetlbfs_fill_super(struct super_block 
 	spin_lock_init(&sbinfo->stat_lock);
 	sbinfo->max_blocks = config.nr_blocks;
 	sbinfo->free_blocks = config.nr_blocks;
+	sbinfo->flight_blocks = 0;
 	sbinfo->max_inodes = config.nr_inodes;
 	sbinfo->free_inodes = config.nr_inodes;
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
@@ -694,8 +695,11 @@ int hugetlb_get_quota(struct address_spa
 
 	if (sbinfo->free_blocks > -1) {
 		spin_lock(&sbinfo->stat_lock);
-		if (sbinfo->free_blocks > 0)
+		if (sbinfo->free_blocks > 0) {
 			sbinfo->free_blocks--;
+			sbinfo->flight_blocks ++;
+		} else if (sbinfo->flight_blocks)
+			ret = -EAGAIN;
 		else
 			ret = -ENOMEM;
 		spin_unlock(&sbinfo->stat_lock);
@@ -710,7 +714,30 @@ void hugetlb_put_quota(struct address_sp
 
 	if (sbinfo->free_blocks > -1) {
 		spin_lock(&sbinfo->stat_lock);
-		sbinfo->free_blocks++;
+		sbinfo->free_blocks ++;
+		spin_unlock(&sbinfo->stat_lock);
+	}
+}
+
+void hugetlb_commit_quota(struct address_space *mapping)
+{
+	struct hugetlbfs_sb_info *sbinfo = HUGETLBFS_SB(mapping->host->i_sb);
+
+	if (sbinfo->free_blocks > -1) {
+		spin_lock(&sbinfo->stat_lock);
+		sbinfo->flight_blocks --;
+		spin_unlock(&sbinfo->stat_lock);
+	}
+}
+
+void hugetlb_rollback_quota(struct address_space *mapping)
+{
+	struct hugetlbfs_sb_info *sbinfo = HUGETLBFS_SB(mapping->host->i_sb);
+
+	if (sbinfo->free_blocks > -1) {
+		spin_lock(&sbinfo->stat_lock);
+		sbinfo->free_blocks ++;
+		sbinfo->flight_blocks --;
 		spin_unlock(&sbinfo->stat_lock);
 	}
 }
--- linux-2.6.22/include/linux/hugetlb.h	2007-07-09 07:32:17.000000000 +0800
+++ linux-2.6.22_hugetlb/include/linux/hugetlb.h	2007-07-24 16:54:39.000000000 +0800
@@ -140,6 +140,7 @@ struct hugetlbfs_config {
 struct hugetlbfs_sb_info {
 	long	max_blocks;   /* blocks allowed */
 	long	free_blocks;  /* blocks free */
+	long	flight_blocks;/* blocks allocated but still not be used */
 	long	max_inodes;   /* inodes allowed */
 	long	free_inodes;  /* inodes free */
 	spinlock_t	stat_lock;
@@ -166,6 +167,8 @@ extern struct vm_operations_struct huget
 struct file *hugetlb_file_setup(const char *name, size_t);
 int hugetlb_get_quota(struct address_space *mapping);
 void hugetlb_put_quota(struct address_space *mapping);
+void hugetlb_commit_quota(struct address_space *mapping);
+void hugetlb_rollback_quota(struct address_space *mapping);
 
 static inline int is_file_hugepages(struct file *file)
 {
--- linux-2.6.22/mm/hugetlb.c	2007-07-09 07:32:17.000000000 +0800
+++ linux-2.6.22_hugetlb/mm/hugetlb.c	2007-07-27 14:03:48.000000000 +0800
@@ -23,6 +23,7 @@
 
 const unsigned long hugetlb_zero = 0, hugetlb_infinity = ~0UL;
 static unsigned long nr_huge_pages, free_huge_pages, resv_huge_pages;
+static unsigned long flight_huge_pages;
 unsigned long max_huge_pages;
 static struct list_head hugepage_freelists[MAX_NUMNODES];
 static unsigned int nr_huge_pages_node[MAX_NUMNODES];
@@ -123,27 +124,47 @@ static int alloc_fresh_huge_page(void)
 static struct page *alloc_huge_page(struct vm_area_struct *vma,
 				    unsigned long addr)
 {
-	struct page *page;
+	struct page *page = NULL;
 
 	spin_lock(&hugetlb_lock);
-	if (vma->vm_flags & VM_MAYSHARE)
-		resv_huge_pages--;
-	else if (free_huge_pages <= resv_huge_pages)
-		goto fail;
+	if (vma->vm_flags & VM_MAYSHARE) {
+		if (resv_huge_pages)
+			resv_huge_pages --;
+		else 
+			goto out;
+	} else if (free_huge_pages <= resv_huge_pages)
+		goto out;
 
 	page = dequeue_huge_page(vma, addr);
-	if (!page)
-		goto fail;
+	if (page) {
+		set_page_refcounted(page);
+		flight_huge_pages ++;
+	} else if (vma->vm_flags & VM_MAYSHARE)
+			resv_huge_pages ++;
 
+out:
+	if (!page && flight_huge_pages)
+		page = ERR_PTR(-EAGAIN);
 	spin_unlock(&hugetlb_lock);
-	set_page_refcounted(page);
 	return page;
+}
 
-fail:
+static inline void hugetlb_commit_page(void)
+{
+	spin_lock(&hugetlb_lock);
+	flight_huge_pages --;
+	spin_unlock(&hugetlb_lock);
+	return;
+}
+
+static inline void hugetlb_rollback_page(struct vm_area_struct *vma)
+{
+	spin_lock(&hugetlb_lock);
+	flight_huge_pages --;
 	if (vma->vm_flags & VM_MAYSHARE)
-		resv_huge_pages++;
+		resv_huge_pages ++;
 	spin_unlock(&hugetlb_lock);
-	return NULL;
+	return;
 }
 
 static int __init hugetlb_init(void)
@@ -438,6 +459,7 @@ static int hugetlb_cow(struct mm_struct 
 {
 	struct page *old_page, *new_page;
 	int avoidcopy;
+	int ret = VM_FAULT_MINOR;
 
 	old_page = pte_page(pte);
 
@@ -446,38 +468,50 @@ static int hugetlb_cow(struct mm_struct 
 	avoidcopy = (page_count(old_page) == 1);
 	if (avoidcopy) {
 		set_huge_ptep_writable(vma, address, ptep);
-		return VM_FAULT_MINOR;
+		return ret;
 	}
 
 	page_cache_get(old_page);
+
+	spin_unlock(&mm->page_table_lock);
+retry:
 	new_page = alloc_huge_page(vma, address);
 
-	if (!new_page) {
-		page_cache_release(old_page);
-		return VM_FAULT_OOM;
-	}
+	if (PTR_ERR(new_page) == -EAGAIN) {
+		if (likely(pte_same(*ptep, pte)) ) {
+			cond_resched();
+			goto retry;
+		} else
+			spin_lock(&mm->page_table_lock);
+	} else if (!new_page) {
+		spin_lock(&mm->page_table_lock);
+		ret = VM_FAULT_OOM;
+	} else {
+		copy_huge_page(new_page, old_page, address, vma);
+		spin_lock(&mm->page_table_lock);
 
-	spin_unlock(&mm->page_table_lock);
-	copy_huge_page(new_page, old_page, address, vma);
-	spin_lock(&mm->page_table_lock);
+		ptep = huge_pte_offset(mm, address & HPAGE_MASK);
+		if (likely(pte_same(*ptep, pte))) {
+			/* Break COW */
+			set_huge_pte_at(mm, address, ptep,
+					make_huge_pte(vma, new_page, 1));
+			hugetlb_commit_page();
+			new_page = old_page;
+		} else
+			hugetlb_rollback_page(vma);
 
-	ptep = huge_pte_offset(mm, address & HPAGE_MASK);
-	if (likely(pte_same(*ptep, pte))) {
-		/* Break COW */
-		set_huge_pte_at(mm, address, ptep,
-				make_huge_pte(vma, new_page, 1));
-		/* Make the old page be freed below */
-		new_page = old_page;
+		page_cache_release(new_page);
 	}
-	page_cache_release(new_page);
+
 	page_cache_release(old_page);
-	return VM_FAULT_MINOR;
+	return ret;
 }
 
 int hugetlb_no_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, pte_t *ptep, int write_access)
 {
 	int ret = VM_FAULT_SIGBUS;
+	int result, page_allocated;
 	unsigned long idx;
 	unsigned long size;
 	struct page *page;
@@ -493,19 +527,39 @@ int hugetlb_no_page(struct mm_struct *mm
 	 * before we get page_table_lock.
 	 */
 retry:
+	result = -ENOMEM;
+	page_allocated = 0;
 	page = find_lock_page(mapping, idx);
 	if (!page) {
 		size = i_size_read(mapping->host) >> HPAGE_SHIFT;
 		if (idx >= size)
 			goto out;
-		if (hugetlb_get_quota(mapping))
+		result = hugetlb_get_quota(mapping);
+		if (result == -EAGAIN) {
+			cond_resched();
+			goto retry;
+		} else if (result) {
+			page = find_lock_page(mapping, idx);
+			if (page)
+				goto get_page;
 			goto out;
+		}
 		page = alloc_huge_page(vma, address);
-		if (!page) {
-			hugetlb_put_quota(mapping);
+		if (IS_ERR(page) || !page) {
+			hugetlb_rollback_quota(mapping);
+			result = -ENOMEM;
+			if (PTR_ERR(page) == -EAGAIN) {
+				cond_resched();
+				goto retry;
+			}
+
+			page = find_lock_page(mapping, idx);
+			if (page)
+				goto get_page;
 			ret = VM_FAULT_OOM;
 			goto out;
 		}
+		page_allocated = 1;
 		clear_huge_page(page, address);
 
 		if (vma->vm_flags & VM_SHARED) {
@@ -514,15 +568,22 @@ retry:
 			err = add_to_page_cache(page, mapping, idx, GFP_KERNEL);
 			if (err) {
 				put_page(page);
-				hugetlb_put_quota(mapping);
+				hugetlb_rollback_page(vma);
+				hugetlb_rollback_quota(mapping);
 				if (err == -EEXIST)
 					goto retry;
 				goto out;
+			} else {
+				hugetlb_commit_quota(mapping);
+				hugetlb_commit_page();
+				result = -ENOMEM;
+				page_allocated = 0;
 			}
 		} else
 			lock_page(page);
 	}
 
+get_page:
 	spin_lock(&mm->page_table_lock);
 	size = i_size_read(mapping->host) >> HPAGE_SHIFT;
 	if (idx >= size)
@@ -536,6 +597,16 @@ retry:
 				&& (vma->vm_flags & VM_SHARED)));
 	set_huge_pte_at(mm, address, ptep, new_pte);
 
+	/*
+	 * If a new huge page is allocated for private mapping,
+	 * need commit quota and page here
+	 */
+	if (page_allocated)
+		hugetlb_commit_page();
+	if (!result)
+		hugetlb_commit_quota(mapping);
+
+	page_allocated = 0;
 	if (write_access && !(vma->vm_flags & VM_SHARED)) {
 		/* Optimization, do the COW without a second fault */
 		ret = hugetlb_cow(mm, vma, address, ptep, new_pte);
@@ -548,9 +619,13 @@ out:
 
 backout:
 	spin_unlock(&mm->page_table_lock);
-	hugetlb_put_quota(mapping);
 	unlock_page(page);
 	put_page(page);
+	if (page_allocated)
+		hugetlb_rollback_page(vma);
+	if (!result)
+		hugetlb_rollback_quota(mapping);
+
 	goto out;
 }
 
@@ -560,7 +635,6 @@ int hugetlb_fault(struct mm_struct *mm, 
 	pte_t *ptep;
 	pte_t entry;
 	int ret;
-	static DEFINE_MUTEX(hugetlb_instantiation_mutex);
 
 	ptep = huge_pte_alloc(mm, address);
 	if (!ptep)
@@ -571,11 +645,9 @@ int hugetlb_fault(struct mm_struct *mm, 
 	 * get spurious allocation failures if two CPUs race to instantiate
 	 * the same page in the page cache.
 	 */
-	mutex_lock(&hugetlb_instantiation_mutex);
 	entry = *ptep;
 	if (pte_none(entry)) {
 		ret = hugetlb_no_page(mm, vma, address, ptep, write_access);
-		mutex_unlock(&hugetlb_instantiation_mutex);
 		return ret;
 	}
 
@@ -587,7 +659,6 @@ int hugetlb_fault(struct mm_struct *mm, 
 		if (write_access && !pte_write(entry))
 			ret = hugetlb_cow(mm, vma, address, ptep, entry);
 	spin_unlock(&mm->page_table_lock);
-	mutex_unlock(&hugetlb_instantiation_mutex);
 
 	return ret;
 }
