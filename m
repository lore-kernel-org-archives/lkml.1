Return-Path: <linux-kernel-owner+w=401wt.eu-S1752659AbZHXPbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbZHXPbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 11:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbZHXPbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 11:31:16 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:54519 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750837AbZHXPbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 11:31:16 -0400
X-Trace: 251432752/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.64.107/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.64.107
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkwFAI9PkkpQKUBr/2dsb2JhbACBU9QlhBoFgVE
X-IronPort-AV: E=Sophos;i="4.44,266,1249254000"; 
   d="scan'208";a="251432752"
Date: Mon, 24 Aug 2009 16:30:28 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Stefan Huber <shuber2@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Meerwald <pmeerw@cosy.sbg.ac.at>,
       James Morris <jmorris@namei.org>, William Irwin <wli@movementarian.org>,
       Mel Gorman <mel@csn.ul.ie>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] mm: fix hugetlb bug due to user_shm_unlock call
In-Reply-To: <4A929BF5.2050105@gmail.com>
Message-ID: <Pine.LNX.4.64.0908241532470.9322@sister.anvils>
References: <alpine.LRH.2.00.0908241110420.21562@tundra.namei.org>
 <Pine.LNX.4.64.0908241258070.27704@sister.anvils> <4A929BF5.2050105@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@kernel.org
---
Stefan, thanks a lot for reporting and testing and reporting back.
No need for you to retest, but in preparing to send this out, I've
noticed another error here, dating back to 2.6.9 (see comment above),
so added in the fix to that (rare case) too.

 fs/hugetlbfs/inode.c    |   20 ++++++++++++--------
 include/linux/hugetlb.h |    6 ++++--
 ipc/shm.c               |    8 +++++---
 3 files changed, 21 insertions(+), 13 deletions(-)

--- 2.6.31-rc7/fs/hugetlbfs/inode.c	2009-06-25 05:18:06.000000000 +0100
+++ linux/fs/hugetlbfs/inode.c	2009-08-24 12:32:01.000000000 +0100
@@ -935,26 +935,28 @@ static int can_do_hugetlb_shm(void)
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
@@ -996,8 +998,10 @@ out_inode:
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
 
--- 2.6.31-rc7/include/linux/hugetlb.h	2009-06-25 05:18:08.000000000 +0100
+++ linux/include/linux/hugetlb.h	2009-08-24 12:32:01.000000000 +0100
@@ -10,6 +10,7 @@
 #include <asm/tlbflush.h>
 
 struct ctl_table;
+struct user_struct;
 
 int PageHuge(struct page *page);
 
@@ -146,7 +147,8 @@ static inline struct hugetlbfs_sb_info *
 
 extern const struct file_operations hugetlbfs_file_operations;
 extern struct vm_operations_struct hugetlb_vm_ops;
-struct file *hugetlb_file_setup(const char *name, size_t, int);
+struct file *hugetlb_file_setup(const char *name, size_t size, int acct,
+						struct user_struct **user);
 int hugetlb_get_quota(struct address_space *mapping, long delta);
 void hugetlb_put_quota(struct address_space *mapping, long delta);
 
@@ -168,7 +170,7 @@ static inline void set_file_hugepages(st
 
 #define is_file_hugepages(file)			0
 #define set_file_hugepages(file)		BUG()
-#define hugetlb_file_setup(name,size,acctflag)	ERR_PTR(-ENOSYS)
+#define hugetlb_file_setup(name,size,acct,user)	ERR_PTR(-ENOSYS)
 
 #endif /* !CONFIG_HUGETLBFS */
 
--- 2.6.31-rc7/ipc/shm.c	2009-06-25 05:18:09.000000000 +0100
+++ linux/ipc/shm.c	2009-08-24 16:06:30.000000000 +0100
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
@@ -410,6 +410,8 @@ static int newseg(struct ipc_namespace *
 	return error;
 
 no_id:
+	if (shp->mlock_user)	/* shmflg & SHM_HUGETLB case */
+		user_shm_unlock(size, shp->mlock_user);
 	fput(file);
 no_file:
 	security_shm_free(shp);
