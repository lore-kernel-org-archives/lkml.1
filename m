Return-Path: <linux-kernel-owner+w=401wt.eu-S1751128AbZHXBMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751128AbZHXBMI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 21:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbZHXBMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 21:12:07 -0400
Received: from tundra.namei.org ([65.99.196.166]:41846 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZHXBMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 21:12:06 -0400
Date: Mon, 24 Aug 2009 11:11:31 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: linux-kernel@vger.kernel.org
cc: Andrew Morton <akpm@linux-foundation.org>,
       Stefan Huber <shuber2@gmail.com>,
       Peter Meerwald <pmeerw@cosy.sbg.ac.at>
Subject: [PATCH] mm: fix hugetlb bug due to user_shm_unlock call (fwd)
Message-ID: <alpine.LRH.2.00.0908241110420.21562@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/Mixed; BOUNDARY=------------060907000900030006010200
Content-ID: <alpine.LRH.2.00.0908241110421.21562@tundra.namei.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--------------060907000900030006010200
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <alpine.LRH.2.00.0908241110422.21562@tundra.namei.org>

---------- Forwarded message ----------
Date: Sun, 23 Aug 2009 11:03:11 +0200
From: Stefan Huber <shuber2@gmail.com>
To: William Irwin <wli@holomorphy.com>
Cc: James Morris <jmorris@namei.org>, Peter Meerwald <pmeerw@cosy.sbg.ac.at>
Subject: [PATCH] mm: fix hugetlb bug due to user_shm_unlock call

This is a multi-part message in MIME format.
--------------060907000900030006010200
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Dear maintainer!

We have recently detected a kernel oops bug in the hugetlb code. The bug
is still present in the current linux-2.6 git branch (tested until [1]).
We have attached a 'git format-patch'-file that solved problem for us.
The commit message should describe the logic of the bug. Please contact
me if you have further questions or comments.

Sincerely,
Stefan Huber.


[1]  linux/kernel/git/torvalds/linux-2.6.git (commit
     429966b8f644dda2afddb4f834a944e9b46a7645)

--------------060907000900030006010200
Content-Type: text/plain;
 name="0001-mm-fix-hugetlb-bug-due-to-user_shm_unlock-call.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename*0="0001-mm-fix-hugetlb-bug-due-to-user_shm_unlock-call.patch"

=46rom cc3cc9a467680c6c5911fc0e669b3c33f55078a4 Mon Sep 17 00:00:00 2001
From: Stefan Huber <shuber2@gmail.com>
Date: Fri, 21 Aug 2009 16:18:00 +0200
Subject: [PATCH] mm: fix hugetlb bug due to user_shm_unlock call

The commit 8a0bdec194c21c8fdef840989d0d7b742bb5d4bc removed
user_shm_lock() calls in hugetlb_file_setup() but left the
user_shm_unlock call in shm_destroy().

In detail:
Assume that can_do_hugetlb_shm() returns true and hence user_shm_lock()
is not called in hugetlb_file_setup(). However, user_shm_unlock() is
called in any case in in shm_destroy() and in the following
atomic_dec_and_lock(&up->__count) in free_uid() is executed and if
up->__count gets zero, also cleanup_user_struct() is scheduled.

Note that sched_destroy_user() is empty if CONFIG_USER_SCHED is not set.
However, the ref counter up->__count gets unexpectedly non-positive and
the corresponding structs are freed even though there are live
references to them, resulting in a kernel oops after a lots of
shmget(SHM_HUGETLB)/shmctl(IPC_RMID) cycles and CONFIG_USER_SCHED set.

Reviewed-by: Peter Meerwald <pmeerw@pmeerw.net>
---
 fs/hugetlbfs/inode.c    |    2 +-
 include/linux/hugetlb.h |    2 ++
 ipc/shm.c               |    2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 941c842..8712a58 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -930,7 +930,7 @@ static struct file_system_type hugetlbfs_fs_type =3D =
{
=20
 static struct vfsmount *hugetlbfs_vfsmount;
=20
-static int can_do_hugetlb_shm(void)
+int can_do_hugetlb_shm(void)
 {
 	return capable(CAP_IPC_LOCK) || in_group_p(sysctl_hugetlb_shm_group);
 }
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 2723513..eda7dce 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -146,6 +146,7 @@ static inline struct hugetlbfs_sb_info *HUGETLBFS_SB(=
struct super_block *sb)
=20
 extern const struct file_operations hugetlbfs_file_operations;
 extern struct vm_operations_struct hugetlb_vm_ops;
+int can_do_hugetlb_shm(void);
 struct file *hugetlb_file_setup(const char *name, size_t, int);
 int hugetlb_get_quota(struct address_space *mapping, long delta);
 void hugetlb_put_quota(struct address_space *mapping, long delta);
@@ -168,6 +169,7 @@ static inline void set_file_hugepages(struct file *fi=
le)
=20
 #define is_file_hugepages(file)			0
 #define set_file_hugepages(file)		BUG()
+#define can_do_hugetlb_shm()			0
 #define hugetlb_file_setup(name,size,acctflag)	ERR_PTR(-ENOSYS)
=20
 #endif /* !CONFIG_HUGETLBFS */
diff --git a/ipc/shm.c b/ipc/shm.c
index 15dd238..9e50e6f 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -174,7 +174,7 @@ static void shm_destroy(struct ipc_namespace *ns, str=
uct shmid_kernel *shp)
 	shm_unlock(shp);
 	if (!is_file_hugepages(shp->shm_file))
 		shmem_lock(shp->shm_file, 0, shp->mlock_user);
-	else
+	else if(!can_do_hugetlb_shm())
 		user_shm_unlock(shp->shm_file->f_path.dentry->d_inode->i_size,
 						shp->mlock_user);
 	fput (shp->shm_file);
--=20
1.6.3.3


--------------060907000900030006010200--
--------------060907000900030006010200
Content-Type: TEXT/PLAIN; NAME=0001-mm-fix-hugetlb-bug-due-to-user_shm_unlock-call.patch
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.LRH.2.00.0908241110423.21562@tundra.namei.org>
Content-Description: 
Content-Disposition: INLINE; FILENAME*0=0001-mm-fix-hugetlb-bug-due-to-user_shm_unlock-call.patch

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEAREIAAYFAkqRBc8ACgkQluL3b44/h0qFKACgkHbmc+GTgZ+BFY+1VD3JJLSp
qaUAnA/WXTcCCIp4GKddbYvB7TMQHkj6
=1W8C
-----END PGP SIGNATURE-----

--------------060907000900030006010200--
