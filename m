Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbZBJOCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbZBJOCj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 09:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbZBJOCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 09:02:31 -0500
Received: from gir.skynet.ie ([193.1.99.77]:53474 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188AbZBJOCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:02:30 -0500
Date: Tue, 10 Feb 2009 14:02:27 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Hugh Dickins <hugh@veritas.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Greg KH <gregkh@suse.de>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mikos Szeredi <miklos@szeredi.hu>, Andy Whitcroft <apw@canonical.com>,
       wli@movementarian.org
Subject: [PATCH] Do not account for the address space used by hugetlbfs
	using VM_ACCOUNT V2 (Was Linus 2.6.29-rc4)
Message-ID: <20090210140227.GC4023@csn.ul.ie>
References: <alpine.LFD.2.00.0902081251090.3048@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902081251090.3048@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 08, 2009 at 01:01:04PM -0800, Linus Torvalds wrote:
> 
> Another week (and a half), another -rc.
> 
> Arch updates (sparc, blackfin), driver updates (dvb, mmc, ide), ACPI 
> updates, FS updates (ubifs, btrfs), you name it. It's all there.
> 
> But more importantly, people really have been working on regressions, and 
> hopefully this closes a nice set of the top one, and hopefully without 
> introducing too many new ones.
> 

Hugepages are currently busted due to commit
fc8744adc870a8d4366908221508bb113d8b72ee and the problem is in
2.6.29-rc4. There was a bit of a discussion but it didn't get very far and
then I went offline for the weekend. Here is a revised patch that tries to
bring hugetlbfs more in line with what the core VM is doing by dealing with
VM_ACCOUNT and VM_NORESERVE.

=============
Do not account for the address space used by hugetlbfs using VM_ACCOUNT

When overcommit is disabled, the core VM accounts for pages used by anonymous
shared, private mappings and special mappings. It keeps track of VMAs that
should be accounted for with VM_ACCOUNT and VMAs that never had a reserve
with VM_NORESERVE.

Overcommit for hugetlbfs is much riskier than overcommit for base pages
due to contiguity requirements. It avoids overcommiting on both shared and
private mappings using reservation counters that are checked and updated
during mmap(). This ensures (within limits) that hugepages exist in the
future when faults occurs or it is too easy to applications to be SIGKILLed.

As hugetlbfs makes its own reservations of a different unit to the base page
size, VM_ACCOUNT should never be set. Even if the units were correct, we would
double account for the usage in the core VM and hugetlbfs. VM_NORESERVE may
be set because an application can request no reserves be made for hugetlbfs
at the risk of getting killed later.

With commit fc8744adc870a8d4366908221508bb113d8b72ee, VM_NORESERVE and
VM_ACCOUNT are getting unconditionally set for hugetlbfs-backed mappings. This
breaks the accounting for both the core VM and hugetlbfs, can trigger an
OOM storm when hugepage pools are too small lockups and corrupted counters
otherwise are used. This patch brings hugetlbfs more in line with how the
core VM treats VM_NORESERVE but prevents VM_ACCOUNT being set.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
--- 
 fs/hugetlbfs/inode.c    |    8 +++++---
 include/linux/hugetlb.h |    5 +++--
 include/linux/mm.h      |    3 +--
 ipc/shm.c               |    8 +++++---
 mm/fremap.c             |    2 +-
 mm/hugetlb.c            |   39 +++++++++++++++++++++++++--------------
 mm/mmap.c               |   38 ++++++++++++++++++++++----------------
 mm/mprotect.c           |    5 +++--
 8 files changed, 65 insertions(+), 43 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 6903d37..9b800d9 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -108,7 +108,8 @@ static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 
 	if (hugetlb_reserve_pages(inode,
 				vma->vm_pgoff >> huge_page_order(h),
-				len >> huge_page_shift(h), vma))
+				len >> huge_page_shift(h), vma,
+				vma->vm_flags))
 		goto out;
 
 	ret = 0;
@@ -947,7 +948,7 @@ static int can_do_hugetlb_shm(void)
 			can_do_mlock());
 }
 
-struct file *hugetlb_file_setup(const char *name, size_t size)
+struct file *hugetlb_file_setup(const char *name, size_t size, int acctflag)
 {
 	int error = -ENOMEM;
 	struct file *file;
@@ -981,7 +982,8 @@ struct file *hugetlb_file_setup(const char *name, size_t size)
 
 	error = -ENOMEM;
 	if (hugetlb_reserve_pages(inode, 0,
-			size >> huge_page_shift(hstate_inode(inode)), NULL))
+			size >> huge_page_shift(hstate_inode(inode)), NULL,
+			acctflag))
 		goto out_inode;
 
 	d_instantiate(dentry, inode);
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index f1d2fba..af09660 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -33,7 +33,8 @@ unsigned long hugetlb_total_pages(void);
 int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, int write_access);
 int hugetlb_reserve_pages(struct inode *inode, long from, long to,
-						struct vm_area_struct *vma);
+						struct vm_area_struct *vma,
+						int acctflags);
 void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed);
 
 extern unsigned long hugepages_treat_as_movable;
@@ -138,7 +139,7 @@ static inline struct hugetlbfs_sb_info *HUGETLBFS_SB(struct super_block *sb)
 
 extern const struct file_operations hugetlbfs_file_operations;
 extern struct vm_operations_struct hugetlb_vm_ops;
-struct file *hugetlb_file_setup(const char *name, size_t);
+struct file *hugetlb_file_setup(const char *name, size_t, int);
 int hugetlb_get_quota(struct address_space *mapping, long delta);
 void hugetlb_put_quota(struct address_space *mapping, long delta);
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index e8ddc98..3235615 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1129,8 +1129,7 @@ extern unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 	unsigned long flag, unsigned long pgoff);
 extern unsigned long mmap_region(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long flags,
-	unsigned int vm_flags, unsigned long pgoff,
-	int accountable);
+	unsigned int vm_flags, unsigned long pgoff);
 
 static inline unsigned long do_mmap(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot,
diff --git a/ipc/shm.c b/ipc/shm.c
index f8f69fa..05d51d2 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -340,6 +340,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	struct file * file;
 	char name[13];
 	int id;
+	int acctflag = 0;
 
 	if (size < SHMMIN || size > ns->shm_ctlmax)
 		return -EINVAL;
@@ -364,11 +365,12 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 
 	sprintf (name, "SYSV%08x", key);
 	if (shmflg & SHM_HUGETLB) {
-		/* hugetlb_file_setup takes care of mlock user accounting */
-		file = hugetlb_file_setup(name, size);
+		/* hugetlb_file_setup applies strict accounting */
+		if (shmflg & SHM_NORESERVE)
+			acctflag = VM_NORESERVE;
+		file = hugetlb_file_setup(name, size, acctflag);
 		shp->mlock_user = current_user();
 	} else {
-		int acctflag = 0;
 		/*
 		 * Do not allow no accounting for OVERCOMMIT_NEVER, even
 	 	 * if it's asked for.
diff --git a/mm/fremap.c b/mm/fremap.c
index 736ba7f..b6ec85a 100644
--- a/mm/fremap.c
+++ b/mm/fremap.c
@@ -198,7 +198,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 			flags &= MAP_NONBLOCK;
 			get_file(file);
 			addr = mmap_region(file, start, size,
-					flags, vma->vm_flags, pgoff, 1);
+					flags, vma->vm_flags, pgoff);
 			fput(file);
 			if (IS_ERR_VALUE(addr)) {
 				err = addr;
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 618e983..2074642 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2269,14 +2269,12 @@ void hugetlb_change_protection(struct vm_area_struct *vma,
 
 int hugetlb_reserve_pages(struct inode *inode,
 					long from, long to,
-					struct vm_area_struct *vma)
+					struct vm_area_struct *vma,
+					int acctflag)
 {
-	long ret, chg;
+	long ret = 0, chg;
 	struct hstate *h = hstate_inode(inode);
 
-	if (vma && vma->vm_flags & VM_NORESERVE)
-		return 0;
-
 	/*
 	 * Shared mappings base their reservation on the number of pages that
 	 * are already allocated on behalf of the file. Private mappings need
@@ -2285,22 +2283,25 @@ int hugetlb_reserve_pages(struct inode *inode,
 	 */
 	if (!vma || vma->vm_flags & VM_SHARED)
 		chg = region_chg(&inode->i_mapping->private_list, from, to);
-	else {
-		struct resv_map *resv_map = resv_map_alloc();
-		if (!resv_map)
-			return -ENOMEM;
-
+	else
 		chg = to - from;
 
-		set_vma_resv_map(vma, resv_map);
-		set_vma_resv_flags(vma, HPAGE_RESV_OWNER);
-	}
-
 	if (chg < 0)
 		return chg;
 
 	if (hugetlb_get_quota(inode->i_mapping, chg))
 		return -ENOSPC;
+
+	/*
+	 * Only apply hugepage reservation if asked. We still have to
+	 * take the filesystem quota because it is an upper limit
+	 * defined for the mount and not necessarily memory as a whole
+	 */
+	if (acctflag & VM_NORESERVE) {
+		reset_vma_resv_huge_pages(vma);
+		return 0;
+	}
+
 	ret = hugetlb_acct_memory(h, chg);
 	if (ret < 0) {
 		hugetlb_put_quota(inode->i_mapping, chg);
@@ -2308,6 +2309,16 @@ int hugetlb_reserve_pages(struct inode *inode,
 	}
 	if (!vma || vma->vm_flags & VM_SHARED)
 		region_add(&inode->i_mapping->private_list, from, to);
+	else {
+		struct resv_map *resv_map = resv_map_alloc();
+
+		if (!resv_map)
+			return -ENOMEM;
+
+		set_vma_resv_map(vma, resv_map);
+		set_vma_resv_flags(vma, HPAGE_RESV_OWNER);
+	}
+
 	return 0;
 }
 
diff --git a/mm/mmap.c b/mm/mmap.c
index 214b6a2..6f70db8 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -918,7 +918,6 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 	struct inode *inode;
 	unsigned int vm_flags;
 	int error;
-	int accountable = 1;
 	unsigned long reqprot = prot;
 
 	/*
@@ -1019,8 +1018,6 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 					return -EPERM;
 				vm_flags &= ~VM_MAYEXEC;
 			}
-			if (is_file_hugepages(file))
-				accountable = 0;
 
 			if (!file->f_op || !file->f_op->mmap)
 				return -ENODEV;
@@ -1053,8 +1050,7 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 	if (error)
 		return error;
 
-	return mmap_region(file, addr, len, flags, vm_flags, pgoff,
-			   accountable);
+	return mmap_region(file, addr, len, flags, vm_flags, pgoff);
 }
 EXPORT_SYMBOL(do_mmap_pgoff);
 
@@ -1092,17 +1088,23 @@ int vma_wants_writenotify(struct vm_area_struct *vma)
 
 /*
  * We account for memory if it's a private writeable mapping,
- * and VM_NORESERVE wasn't set.
+ * not hugepages and VM_NORESERVE wasn't set.
  */
-static inline int accountable_mapping(unsigned int vm_flags)
+static inline int accountable_mapping(struct file *file, unsigned int vm_flags)
 {
+	/*
+	 * hugetlb has its own accounting separate from the core VM
+	 * VM_HUGETLB may not be set yet so we cannot check for that flag.
+	 */
+	if (file && is_file_hugepages(file))
+		return 0;
+
 	return (vm_flags & (VM_NORESERVE | VM_SHARED | VM_WRITE)) == VM_WRITE;
 }
 
 unsigned long mmap_region(struct file *file, unsigned long addr,
 			  unsigned long len, unsigned long flags,
-			  unsigned int vm_flags, unsigned long pgoff,
-			  int accountable)
+			  unsigned int vm_flags, unsigned long pgoff)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev;
@@ -1128,18 +1130,22 @@ munmap_back:
 
 	/*
 	 * Set 'VM_NORESERVE' if we should not account for the
-	 * memory use of this mapping. We only honor MAP_NORESERVE
-	 * if we're allowed to overcommit memory.
+	 * memory use of this mapping.
 	 */
-	if ((flags & MAP_NORESERVE) && sysctl_overcommit_memory != OVERCOMMIT_NEVER)
-		vm_flags |= VM_NORESERVE;
-	if (!accountable)
-		vm_flags |= VM_NORESERVE;
+	if ((flags & MAP_NORESERVE)) {
+	 	/* * We honor MAP_NORESERVE if allowed to overcommit */
+		if (sysctl_overcommit_memory != OVERCOMMIT_NEVER)
+			vm_flags |= VM_NORESERVE;
+
+		/* hugetlb applies strict overcommit unless MAP_NORESERVE */
+		if (file && is_file_hugepages(file))
+			vm_flags |= VM_NORESERVE;
+	}
 
 	/*
 	 * Private writable mapping: check memory availability
 	 */
-	if (accountable_mapping(vm_flags)) {
+	if (accountable_mapping(file, vm_flags)) {
 		charged = len >> PAGE_SHIFT;
 		if (security_vm_enough_memory(charged))
 			return -ENOMEM;
diff --git a/mm/mprotect.c b/mm/mprotect.c
index abe2694..258197b 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -151,10 +151,11 @@ mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
 	/*
 	 * If we make a private mapping writable we increase our commit;
 	 * but (without finer accounting) cannot reduce our commit if we
-	 * make it unwritable again.
+	 * make it unwritable again. hugetlb mapping were accounted for
+	 * even if read-only so there is no need to account for them here
 	 */
 	if (newflags & VM_WRITE) {
-		if (!(oldflags & (VM_ACCOUNT|VM_WRITE|
+		if (!(oldflags & (VM_ACCOUNT|VM_WRITE|VM_HUGETLB|
 						VM_SHARED|VM_NORESERVE))) {
 			charged = nrpages;
 			if (security_vm_enough_memory(charged))

