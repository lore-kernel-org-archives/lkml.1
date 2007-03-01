Return-Path: <linux-kernel-owner+w=401wt.eu-S1161257AbXCAXqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161257AbXCAXqO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 18:46:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161256AbXCAXqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 18:46:13 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36986 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161187AbXCAXqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 18:46:11 -0500
From: Adam Litke <agl@us.ibm.com>
Subject: [PATCH] Fix get_unmapped_area and fsync for hugetlb shm segments
Date: Thu, 01 Mar 2007 15:46:08 -0800
To: torvalds@linux-foundation.org
Cc: agl@us.ibm.com, ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Message-Id: <20070301234608.29532.66932.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch provides the following hugetlb-related fixes to the recent stacked
shm files changes:
 - Update is_file_hugepages() so it will reconize hugetlb shm segments.
 - get_unmapped_area must be called with the nested file struct to handle
   the sfd->file->f_ops->get_unmapped_area == NULL case.
 - The fsync f_op must be wrapped since it is specified in the hugetlbfs
   f_ops.

This is based on proposed fixes from Eric Biederman that were debugged and
tested by me.  Without it, attempting to use hugetlb shared memory segments
on powerpc (and likely ia64) will kill your box.

Please Apply.

Signed-off-by: Adam Litke <agl@us.ibm.com>
---

 include/linux/hugetlb.h |    8 +++++++-
 include/linux/shm.h     |    5 +++++
 ipc/shm.c               |   32 ++++++++++++++++++++++++++------
 3 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index a60995a..3f3e7a6 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -4,6 +4,7 @@
 #ifdef CONFIG_HUGETLB_PAGE
 
 #include <linux/mempolicy.h>
+#include <linux/shm.h>
 #include <asm/tlbflush.h>
 
 struct ctl_table;
@@ -168,7 +169,12 @@ void hugetlb_put_quota(struct address_space *mapping);
 
 static inline int is_file_hugepages(struct file *file)
 {
-	return file->f_op == &hugetlbfs_file_operations;
+	if (file->f_op == &hugetlbfs_file_operations)
+		return 1;
+	if (is_file_shm_hugepages(file))
+		return 1;
+
+	return 0;
 }
 
 static inline void set_file_hugepages(struct file *file)
diff --git a/include/linux/shm.h b/include/linux/shm.h
index a2c896a..ad2e3af 100644
--- a/include/linux/shm.h
+++ b/include/linux/shm.h
@@ -96,12 +96,17 @@ struct shmid_kernel /* private to the kernel */
 
 #ifdef CONFIG_SYSVIPC
 long do_shmat(int shmid, char __user *shmaddr, int shmflg, unsigned long *addr);
+extern int is_file_shm_hugepages(struct file *file);
 #else
 static inline long do_shmat(int shmid, char __user *shmaddr,
 				int shmflg, unsigned long *addr)
 {
 	return -ENOSYS;
 }
+static inline int is_file_shm_hugepages(struct file *file)
+{
+	return 0;
+}
 #endif
 
 #endif /* __KERNEL__ */
diff --git a/ipc/shm.c b/ipc/shm.c
index eb57e22..abf864d 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -285,21 +285,41 @@ static int shm_release(struct inode *ino, struct file *file)
 	return 0;
 }
 
-#ifndef CONFIG_MMU
+static int shm_fsync(struct file *file, struct dentry *dentry, int datasync)
+{
+	int (*fsync) (struct file *, struct dentry *, int datasync);
+	struct shm_file_data *sfd = shm_file_data(file);
+	int ret = -EINVAL;
+
+	fsync = sfd->file->f_op->fsync;
+	if (fsync)
+		ret = fsync(sfd->file, sfd->file->f_path.dentry, datasync);
+	return ret;
+}
+
 static unsigned long shm_get_unmapped_area(struct file *file,
 	unsigned long addr, unsigned long len, unsigned long pgoff,
 	unsigned long flags)
 {
 	struct shm_file_data *sfd = shm_file_data(file);
-	return sfd->file->f_op->get_unmapped_area(sfd->file, addr, len, pgoff,
-							flags);
+	return get_unmapped_area(sfd->file, addr, len, pgoff, flags);
+}
+
+int is_file_shm_hugepages(struct file *file)
+{
+	int ret = 0;
+
+	if (file->f_op == &shm_file_operations) {
+		struct shm_file_data *sfd;
+		sfd = shm_file_data(file);
+		ret = is_file_hugepages(sfd->file);
+	}
+	return ret;
 }
-#else
-#define shm_get_unmapped_area NULL
-#endif
 
 static const struct file_operations shm_file_operations = {
 	.mmap		= shm_mmap,
+	.fsync		= shm_fsync,
 	.release	= shm_release,
 	.get_unmapped_area	= shm_get_unmapped_area,
 };
