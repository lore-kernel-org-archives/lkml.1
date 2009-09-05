Return-Path: <linux-kernel-owner+w=401wt.eu-S934604AbZIEAUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934604AbZIEAUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934589AbZIEAUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:20:47 -0400
Received: from kroah.org ([198.145.64.141]:42061 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934559AbZIEAUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:20:36 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:49 2009
Message-Id: <20090905001448.898106854@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:13:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: [patch 10/71] mm: fix hugetlb bug due to user_shm_unlock call
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=mm-fix-hugetlb-bug-due-to-user_shm_unlock-call.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

commit 353d5c30c666580347515da609dd74a2b8e9b828 upstream.

2.6.30's commit 8a0bdec194c21c8fdef840989d0d7b742bb5d4bc removed
user_shm_lock() calls in hugetlb_file_setup() but left the
user_shm_unlock call in shm_destroy().

In detail:
Assume that can_do_hugetlb_shm() returns true and hence user_shm_lock()
is not called in hugetlb_file_setup(). However, user_shm_unlock() is
called in any case in shm_destroy() and in the following
atomic_dec_and_lock(&up->__count) in free_uid() is executed and if
up->__count gets zero, also cleanup_user_struct() is scheduled.

Note that sched_destroy_user() is empty if CONFIG_USER_SCHED is not set.
However, the ref counter up->__count gets unexpectedly non-positive and
the corresponding structs are freed even though there are live
references to them, resulting in a kernel oops after a lots of
shmget(SHM_HUGETLB)/shmctl(IPC_RMID) cycles and CONFIG_USER_SCHED set.

Hugh changed Stefan's suggested patch: can_do_hugetlb_shm() at the
time of shm_destroy() may give a different answer from at the time
of hugetlb_file_setup().  And fixed newseg()'s no_id error path,
which has missed user_shm_unlock() ever since it came in 2.6.9.

Reported-by: Stefan Huber <shuber2@gmail.com>
Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Tested-by: Stefan Huber <shuber2@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/hugetlbfs/inode.c    |   20 ++++++++++++--------
 include/linux/hugetlb.h |    6 ++++--
 ipc/shm.c               |    8 +++++---
 3 files changed, 21 insertions(+), 13 deletions(-)

--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -934,26 +934,28 @@ static int can_do_hugetlb_shm(void)
 	return capable(CAP_IPC_LOCK) || in_group_p(sysctl_hugetlb_shm_group);
 }
 
-struct file *hugetlb_file_setup(const char *name, size_t size, int acctflag)
+struct file *hugetlb_file_setup(const char *name, size_t size, int acctflag,
+						struct user_struct **user)
 {
 	int error = -ENOMEM;
-	int unlock_shm = 0;
 	struct file *file;
 	struct inode *inode;
 	struct dentry *dentry, *root;
 	struct qstr quick_string;
-	struct user_struct *user = current_user();
 
+	*user = NULL;
 	if (!hugetlbfs_vfsmount)
 		return ERR_PTR(-ENOENT);
 
 	if (!can_do_hugetlb_shm()) {
-		if (user_shm_lock(size, user)) {
-			unlock_shm = 1;
+		*user = current_user();
+		if (user_shm_lock(size, *user)) {
 			WARN_ONCE(1,
 			  "Using mlock ulimits for SHM_HUGETLB deprecated\n");
-		} else
+		} else {
+			*user = NULL;
 			return ERR_PTR(-EPERM);
+		}
 	}
 
 	root = hugetlbfs_vfsmount->mnt_root;
@@ -994,8 +996,10 @@ out_inode:
 out_dentry:
 	dput(dentry);
 out_shm_unlock:
-	if (unlock_shm)
-		user_shm_unlock(size, user);
+	if (*user) {
+		user_shm_unlock(size, *user);
+		*user = NULL;
+	}
 	return ERR_PTR(error);
 }
 
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -10,6 +10,7 @@
 #include <asm/tlbflush.h>
 
 struct ctl_table;
+struct user_struct;
 
 static inline int is_vm_hugetlb_page(struct vm_area_struct *vma)
 {
@@ -139,7 +140,8 @@ static inline struct hugetlbfs_sb_info *
 
 extern const struct file_operations hugetlbfs_file_operations;
 extern struct vm_operations_struct hugetlb_vm_ops;
-struct file *hugetlb_file_setup(const char *name, size_t, int);
+struct file *hugetlb_file_setup(const char *name, size_t size, int acct,
+						struct user_struct **user);
 int hugetlb_get_quota(struct address_space *mapping, long delta);
 void hugetlb_put_quota(struct address_space *mapping, long delta);
 
@@ -161,7 +163,7 @@ static inline void set_file_hugepages(st
 
 #define is_file_hugepages(file)			0
 #define set_file_hugepages(file)		BUG()
-#define hugetlb_file_setup(name,size,acctflag)	ERR_PTR(-ENOSYS)
+#define hugetlb_file_setup(name,size,acct,user)	ERR_PTR(-ENOSYS)
 
 #endif /* !CONFIG_HUGETLBFS */
 
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -174,7 +174,7 @@ static void shm_destroy(struct ipc_names
 	shm_unlock(shp);
 	if (!is_file_hugepages(shp->shm_file))
 		shmem_lock(shp->shm_file, 0, shp->mlock_user);
-	else
+	else if (shp->mlock_user)
 		user_shm_unlock(shp->shm_file->f_path.dentry->d_inode->i_size,
 						shp->mlock_user);
 	fput (shp->shm_file);
@@ -369,8 +369,8 @@ static int newseg(struct ipc_namespace *
 		/* hugetlb_file_setup applies strict accounting */
 		if (shmflg & SHM_NORESERVE)
 			acctflag = VM_NORESERVE;
-		file = hugetlb_file_setup(name, size, acctflag);
-		shp->mlock_user = current_user();
+		file = hugetlb_file_setup(name, size, acctflag,
+							&shp->mlock_user);
 	} else {
 		/*
 		 * Do not allow no accounting for OVERCOMMIT_NEVER, even
@@ -411,6 +411,8 @@ static int newseg(struct ipc_namespace *
 	return error;
 
 no_id:
+	if (shp->mlock_user)	/* shmflg & SHM_HUGETLB case */
+		user_shm_unlock(size, shp->mlock_user);
 	fput(file);
 no_file:
 	security_shm_free(shp);


