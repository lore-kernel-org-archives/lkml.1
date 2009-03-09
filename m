Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbZCIPzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbZCIPzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 11:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbZCIPzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 11:55:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33410 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176AbZCIPzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 11:55:22 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: linux-aio <linux-aio@kvack.org>, bos@pathscale.com
Cc: zach.brown@oracle.com, bcrl@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [patch] factor out checks against the memlock rlimit
References: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 09 Mar 2009 11:54:39 -0400
In-Reply-To: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
	message of "Mon, 09 Mar 2009 11:49:57 -0400")
Message-ID: <x497i2yelog.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There are several places in the kernel where the memlock rlimit is
checked, all duplicating code.  I added another in a recent patch and it
made me feel dirty, so this patch factors all of that into a single
function, can_mlock_pages.

The infiniband implementation of the rlimit check was actually broken.
Weeding through changelogs showed that the initial implementation was
wrong, code was #if 0'd out because it didn't work, and instead of
fixing things, they just removed the code all together.  If my
assessment of that is wrong, please let me know!  ;-)

Comments, as always, are encouraged.

Cheers,
Jeff

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 6f7c096..c4d4f1b 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -135,14 +135,11 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 
 	down_write(&current->mm->mmap_sem);
 
-	locked     = npages + current->mm->locked_vm;
-	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
-
-	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
+	if (!can_mlock_pages(npages)) {
 		ret = -ENOMEM;
 		goto out;
 	}
-
+	locked = npages + current->mm->locked_vm;
 	cur_base = addr & PAGE_MASK;
 
 	ret = 0;
diff --git a/drivers/infiniband/hw/ipath/ipath_user_pages.c b/drivers/infiniband/hw/ipath/ipath_user_pages.c
index 0190edc..9ab17e3 100644
--- a/drivers/infiniband/hw/ipath/ipath_user_pages.c
+++ b/drivers/infiniband/hw/ipath/ipath_user_pages.c
@@ -58,10 +58,7 @@ static int __get_user_pages(unsigned long start_page, size_t num_pages,
 	size_t got;
 	int ret;
 
-	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >>
-		PAGE_SHIFT;
-
-	if (num_pages > lock_limit) {
+	if (!can_mlock_pages(num_pages)) {
 		ret = -ENOMEM;
 		goto bail;
 	}
diff --git a/fs/aio.c b/fs/aio.c
index 3bbda9d..0ca64eb 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -136,10 +136,7 @@ static int aio_setup_ring(struct kioctx *ctx)
 	 * Check that the memory reserved for the completion ring does
 	 * not exceed the memlock memory limit.
 	 */
-	locked = nr_pages + ctx->mm->locked_vm;
-	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
-	lock_limit >>= PAGE_SHIFT;
-	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
+	if (!can_mlock_pages(nr_pages)) {
 		up_write(&ctx->mm->mmap_sem);
 		info->mmap_size = 0;
 		aio_free_ring(ctx);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 065cdf8..79c1127 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -737,6 +737,7 @@ extern unsigned long shmem_get_unmapped_area(struct file *file,
 #endif
 
 extern int can_do_mlock(void);
+extern int can_mlock_pages(unsigned long);
 extern int user_shm_lock(size_t, struct user_struct *);
 extern void user_shm_unlock(size_t, struct user_struct *);
 
diff --git a/mm/mlock.c b/mm/mlock.c
index cbe9e05..4ec96c2 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -31,6 +31,33 @@ int can_do_mlock(void)
 }
 EXPORT_SYMBOL(can_do_mlock);
 
+/**
+ * can_mlock_pages() - tell whether mlocking nr_pages is possible
+ * @nr_pages:	Number of pages to be locked in memory
+ *
+ * Boolean function which tells whether the MEMLOCK rlimit will prevent
+ * locking nr_pages pages.
+ */
+int can_mlock_pages(unsigned long nr_pages)
+{
+	unsigned long locked, lock_limit;
+
+	if (capable(CAP_IPC_LOCK))
+		return 1;
+
+	locked = nr_pages;
+	locked += current->mm->locked_vm;
+
+	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
+	lock_limit >>= PAGE_SHIFT;
+
+	/* check against resource limits */
+	if (locked <= lock_limit)
+		return 1;
+	return 0;
+}
+EXPORT_SYMBOL(can_mlock_pages);
+
 #ifdef CONFIG_UNEVICTABLE_LRU
 /*
  * Mlocked pages are marked with PageMlocked() flag for efficient testing
@@ -505,14 +532,8 @@ SYSCALL_DEFINE2(mlock, unsigned long, start, size_t, len)
 	len = PAGE_ALIGN(len + (start & ~PAGE_MASK));
 	start &= PAGE_MASK;
 
-	locked = len >> PAGE_SHIFT;
-	locked += current->mm->locked_vm;
-
-	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
-	lock_limit >>= PAGE_SHIFT;
-
 	/* check against resource limits */
-	if ((locked <= lock_limit) || capable(CAP_IPC_LOCK))
+	if (can_mlock_pages(len >> PAGE_SHIFT))
 		error = do_mlock(start, len, 1);
 	up_write(&current->mm->mmap_sem);
 	return error;
diff --git a/mm/mmap.c b/mm/mmap.c
index 00ced3e..52d1c32 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -975,12 +975,7 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 
 	/* mlock MCL_FUTURE? */
 	if (vm_flags & VM_LOCKED) {
-		unsigned long locked, lock_limit;
-		locked = len >> PAGE_SHIFT;
-		locked += mm->locked_vm;
-		lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
-		lock_limit >>= PAGE_SHIFT;
-		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
+		if (!can_mlock_pages(len >> PAGE_SHIFT))
 			return -EAGAIN;
 	}
 
@@ -2006,12 +2001,7 @@ unsigned long do_brk(unsigned long addr, unsigned long len)
 	 * mlock MCL_FUTURE?
 	 */
 	if (mm->def_flags & VM_LOCKED) {
-		unsigned long locked, lock_limit;
-		locked = len >> PAGE_SHIFT;
-		locked += mm->locked_vm;
-		lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
-		lock_limit >>= PAGE_SHIFT;
-		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
+		if (!can_mlock_pages(len>>PAGE_SHIFT))
 			return -EAGAIN;
 	}
 
diff --git a/mm/mremap.c b/mm/mremap.c
index a39b7b9..6fb50e2 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -342,12 +342,8 @@ unsigned long do_mremap(unsigned long addr,
 			goto out;
 	}
 	if (vma->vm_flags & VM_LOCKED) {
-		unsigned long locked, lock_limit;
-		locked = mm->locked_vm << PAGE_SHIFT;
-		lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
-		locked += new_len - old_len;
 		ret = -EAGAIN;
-		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
+		if (!can_mlock_pages((new_len - old_len)>>PAGE_SHIFT))
 			goto out;
 	}
 	if (!may_expand_vm(mm, (new_len - old_len) >> PAGE_SHIFT)) {
