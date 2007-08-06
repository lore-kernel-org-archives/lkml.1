Return-Path: <linux-kernel-owner+w=401wt.eu-S1761532AbXHFCwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761532AbXHFCwg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 22:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757060AbXHFCw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 22:52:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:43757 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbXHFCw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 22:52:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,223,1183359600"; 
   d="scan'208";a="113986290"
Subject: Re: [PATCH] remove hugetlb_instantiation_mutex
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Nish Aravamudan <nish.aravamudan@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <29495f1d0708030953q7767ea77jec641e53cfe04944@mail.gmail.com>
References: <1185523069.4688.115.camel@ymzhang>
	 <1185554277.23817.18.camel@localhost.localdomain>
	 <1185779758.4688.177.camel@ymzhang>
	 <1186159163.23817.32.camel@localhost.localdomain>
	 <29495f1d0708030953q7767ea77jec641e53cfe04944@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 06 Aug 2007 10:51:37 +0800
Message-Id: <1186368697.4688.203.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-03 at 09:53 -0700, Nish Aravamudan wrote:
> On 8/3/07, Adam Litke <agl@us.ibm.com> wrote:
> > On Mon, 2007-07-30 at 15:15 +0800, Zhang, Yanmin wrote:
> > > On Fri, 2007-07-27 at 11:37 -0500, Adam Litke wrote:
> > > > Hey... I am amazed at how quickly you came back with a patch for this :)
> > > > Thanks for looking at it.  Unfortunately there is one show-stopper and I
> > > > have some reservations (pun definitely intended) with your approach:
> > > Thanks for your great comments.
> >
> > Sorry for such a long delay in responding.  I have been pretty busy
> > lately.
> >
> > > > First, your patch does not pass the libhugetlbfs test
> > > > 'alloc-instantiate-race' which was written to tickle the the race which
> > > > the mutex was introduced to solve.  Your patch works for shared
> > > > mappings, but not for the private case.
> > > My testing about private might not be thorough. Function hugetlb_cow has a race
> > > for multi-thread to fault on the same private page index. But after I fixed it,
> > > alloc-instantiate-race still failed.
> > >
> > > I tried to google the source code tarball of libhugetlbfs test suite, but couldn't
> > > find it. Would you like to send me a copy of the test source codes?
> >
> > http://libhugetlbfs.ozlabs.org/releases/libhugetlbfs-1.2-pre1.tar.gz
> >
> > The tarball will contain a test called alloc-instantiate-race.  Make
> > sure to run it in private and shared mode.  Let me know what you find
> > out.
> 
> Actually, please use
> http://libhugetlbfs.ozlabs.org/snapshots/libhugetlbfs-dev-20070718.tar.gz.
> 1.2-pre1 had a build error that is fixed in the development snapshot.
Sorry for replying late. I got a fever last week.

The test case is very nice. I located the root cause.

In function hugetlb_no_page, if the thread couldn't get a quota/huge page while there
is no flight page, it will return VM_FAULT_SIGBUS or VM_FAULT_OOM. If the mapping
is private, there might be a narrow race for multi-thread fault on the same private
mapping index.

I added a checking "if (!pte_none(*ptep))" if the thread couldn't get a quota/huge page
while there is no flight page.

alloc-instantiate-race's both private and shared could pass now.

Thank all of you guys for the good pointer!

--Yanmin

----------------The 3nd version of the patch-------------

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
+++ linux-2.6.22_hugetlb/mm/hugetlb.c	2007-08-06 10:13:06.000000000 +0800
@@ -22,15 +22,16 @@
 #include "internal.h"
 
 const unsigned long hugetlb_zero = 0, hugetlb_infinity = ~0UL;
+/*
+ * Protects updates to hugepage_freelists, nr_huge_pages, and free_huge_pages
+ */
+static DEFINE_SPINLOCK(hugetlb_lock);
 static unsigned long nr_huge_pages, free_huge_pages, resv_huge_pages;
+static unsigned long flight_huge_pages;
 unsigned long max_huge_pages;
 static struct list_head hugepage_freelists[MAX_NUMNODES];
 static unsigned int nr_huge_pages_node[MAX_NUMNODES];
 static unsigned int free_huge_pages_node[MAX_NUMNODES];
-/*
- * Protects updates to hugepage_freelists, nr_huge_pages, and free_huge_pages
- */
-static DEFINE_SPINLOCK(hugetlb_lock);
 
 static void clear_huge_page(struct page *page, unsigned long addr)
 {
@@ -123,27 +124,43 @@ static int alloc_fresh_huge_page(void)
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
+	} else if (free_huge_pages <= resv_huge_pages + flight_huge_pages)
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
+
+static int hugetlb_acct_memory(long resv_delta, long flight_delta)
+{
+	int ret = -ENOMEM;
 
-fail:
-	if (vma->vm_flags & VM_MAYSHARE)
-		resv_huge_pages++;
+	spin_lock(&hugetlb_lock);
+	if ((resv_delta + resv_huge_pages) <= free_huge_pages) {
+		resv_huge_pages += resv_delta;
+		ret = 0;
+	}
+	flight_huge_pages += flight_delta;
 	spin_unlock(&hugetlb_lock);
-	return NULL;
+	return ret;
 }
 
 static int __init hugetlb_init(void)
@@ -438,6 +455,7 @@ static int hugetlb_cow(struct mm_struct 
 {
 	struct page *old_page, *new_page;
 	int avoidcopy;
+	int ret = VM_FAULT_MINOR;
 
 	old_page = pte_page(pte);
 
@@ -446,38 +464,51 @@ static int hugetlb_cow(struct mm_struct 
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
+		if (likely(pte_same(*ptep, pte)))
+			ret = VM_FAULT_OOM;
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
+			hugetlb_acct_memory(0, -1);
+			new_page = old_page;
+		} else
+			hugetlb_acct_memory(0, -1);
 
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
@@ -493,19 +524,64 @@ int hugetlb_no_page(struct mm_struct *mm
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
+			/*
+			 * As for private mapping, another thread might already
+			 * allocates a page and maps it.
+			 */
+			if (!pte_none(*ptep))
+				ret = VM_FAULT_MINOR;
+			else
+				ret = VM_FAULT_OOM;
 			goto out;
+		}
+
+		/* To prevent too much cache miss, do some checking firstly */
+		if ( (!free_huge_pages && flight_huge_pages) ||
+			(!(vma->vm_flags & VM_MAYSHARE) &&
+			free_huge_pages <= resv_huge_pages &&
+			flight_huge_pages) ) {
+				hugetlb_rollback_quota(mapping);
+				cond_resched();
+				goto retry;
+		}
 		page = alloc_huge_page(vma, address);
-		if (!page) {
-			hugetlb_put_quota(mapping);
-			ret = VM_FAULT_OOM;
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
+			/*
+			 * As for private mapping, another thread might already
+			 * allocates a page and maps it.
+			 */
+			if (!pte_none(*ptep))
+				ret = VM_FAULT_MINOR;
+			else
+				ret = VM_FAULT_OOM;
 			goto out;
 		}
+		page_allocated = 1;
 		clear_huge_page(page, address);
 
 		if (vma->vm_flags & VM_SHARED) {
@@ -514,15 +590,22 @@ retry:
 			err = add_to_page_cache(page, mapping, idx, GFP_KERNEL);
 			if (err) {
 				put_page(page);
-				hugetlb_put_quota(mapping);
+				hugetlb_acct_memory(1, -1);
+				hugetlb_rollback_quota(mapping);
 				if (err == -EEXIST)
 					goto retry;
 				goto out;
+			} else {
+				hugetlb_acct_memory(0, -1);
+				hugetlb_commit_quota(mapping);
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
@@ -536,6 +619,16 @@ retry:
 				&& (vma->vm_flags & VM_SHARED)));
 	set_huge_pte_at(mm, address, ptep, new_pte);
 
+	/*
+	 * If a new huge page is allocated for private mapping,
+	 * need commit quota and page here
+	 */
+	if (page_allocated)
+		hugetlb_acct_memory(0, -1);
+	if (!result)
+		hugetlb_commit_quota(mapping);
+
+	page_allocated = 0;
 	if (write_access && !(vma->vm_flags & VM_SHARED)) {
 		/* Optimization, do the COW without a second fault */
 		ret = hugetlb_cow(mm, vma, address, ptep, new_pte);
@@ -548,9 +641,13 @@ out:
 
 backout:
 	spin_unlock(&mm->page_table_lock);
-	hugetlb_put_quota(mapping);
 	unlock_page(page);
 	put_page(page);
+	if (page_allocated)
+		hugetlb_acct_memory(0, -1);
+	if (!result)
+		hugetlb_rollback_quota(mapping);
+
 	goto out;
 }
 
@@ -560,7 +657,6 @@ int hugetlb_fault(struct mm_struct *mm, 
 	pte_t *ptep;
 	pte_t entry;
 	int ret;
-	static DEFINE_MUTEX(hugetlb_instantiation_mutex);
 
 	ptep = huge_pte_alloc(mm, address);
 	if (!ptep)
@@ -571,11 +667,9 @@ int hugetlb_fault(struct mm_struct *mm, 
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
 
@@ -587,7 +681,6 @@ int hugetlb_fault(struct mm_struct *mm, 
 		if (write_access && !pte_write(entry))
 			ret = hugetlb_cow(mm, vma, address, ptep, entry);
 	spin_unlock(&mm->page_table_lock);
-	mutex_unlock(&hugetlb_instantiation_mutex);
 
 	return ret;
 }
@@ -811,19 +904,6 @@ static long region_truncate(struct list_
 	return chg;
 }
 
-static int hugetlb_acct_memory(long delta)
-{
-	int ret = -ENOMEM;
-
-	spin_lock(&hugetlb_lock);
-	if ((delta + resv_huge_pages) <= free_huge_pages) {
-		resv_huge_pages += delta;
-		ret = 0;
-	}
-	spin_unlock(&hugetlb_lock);
-	return ret;
-}
-
 int hugetlb_reserve_pages(struct inode *inode, long from, long to)
 {
 	long ret, chg;
@@ -851,7 +931,7 @@ int hugetlb_reserve_pages(struct inode *
 	if (chg > cpuset_mems_nr(free_huge_pages_node))
 		return -ENOMEM;
 
-	ret = hugetlb_acct_memory(chg);
+	ret = hugetlb_acct_memory(chg, 0);
 	if (ret < 0)
 		return ret;
 	region_add(&inode->i_mapping->private_list, from, to);
@@ -861,5 +941,6 @@ int hugetlb_reserve_pages(struct inode *
 void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed)
 {
 	long chg = region_truncate(&inode->i_mapping->private_list, offset);
-	hugetlb_acct_memory(freed - chg);
+	hugetlb_acct_memory(freed - chg, 0);
 }
+
