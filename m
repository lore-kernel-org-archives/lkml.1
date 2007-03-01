Return-Path: <linux-kernel-owner+w=401wt.eu-S932844AbXCAA62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844AbXCAA62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 19:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932863AbXCAA61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 19:58:27 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53332 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932844AbXCAA60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 19:58:26 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Adam Litke <agl@us.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: Kernel Oops with shm namespace cleanups
References: <1172693610.12805.16.camel@localhost.localdomain>
Date: Wed, 28 Feb 2007 17:57:52 -0700
In-Reply-To: <1172693610.12805.16.camel@localhost.localdomain> (Adam Litke's
	message of "Wed, 28 Feb 2007 14:13:29 -0600")
Message-ID: <m1bqjdg4q7.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adam Litke <agl@us.ibm.com> writes:

> Hey.  While testing 2.6.21-rc2 with libhugetlbfs, the shm-fork test case
> causes the kernel to oops.  To reproduce:  Execute 'make check' in the
> latest libhugetlbfs source on a 2.6.21-rc2 kernel with 100 huge pages
> allocated.  Using fewer huge pages will likely also trigger the oops.
> Libhugetlbfs can be downloaded from:
> http://libhugetlbfs.ozlabs.org/snapshots/libhugetlbfs-dev-20070228.tar.gz
>
> I have collected the following information:

Thanks.  I'm going to be offline starting early tomorrow so I'm
unfortunately not going to be timely in tracing this one down.

Ok. Looking at the code I have a clue what is going on.  I think
I must have been out of it the day I wrote this patch.  I don't have
fsync or get_unmapped_area methods appropriately wrapped.  I clearly
did not do a close audit of the filesystem methods that hugetlbfs
inodes use.  I may have just gotten luck on other architectures.

get_unmapped_area looks like it will be a bit of a trick.

If it is just failing to wrap the methods a couple of file methods
then the patch below should fix it or come close.  That's the best
I can do before I leave.

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index a60995a..44f1f05 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -168,7 +168,9 @@ void hugetlb_put_quota(struct address_space *mapping);
 
 static inline int is_file_hugepages(struct file *file)
 {
-	return file->f_op == &hugetlbfs_file_operations;
+	return (file->f_op == &hugetlbfs_file_operations) ||
+		is_file_shm_hugepages(file);
+		
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
index 26b935b..93cfa35 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -235,7 +235,7 @@ struct page *shm_nopage(struct vm_area_struct *vma, unsigned long address, int *
 }
 
 #ifdef CONFIG_NUMA
-int shm_set_policy(struct vm_area_struct *vma, struct mempolicy *new)
+static int shm_set_policy(struct vm_area_struct *vma, struct mempolicy *new)
 {
 	struct file *file = vma->vm_file;
 	struct shm_file_data *sfd = shm_file_data(file);
@@ -245,7 +245,7 @@ int shm_set_policy(struct vm_area_struct *vma, struct mempolicy *new)
 	return err;
 }
 
-struct mempolicy *shm_get_policy(struct vm_area_struct *vma, unsigned long addr)
+static struct mempolicy *shm_get_policy(struct vm_area_struct *vma, unsigned long addr)
 {
 	struct file *file = vma->vm_file;
 	struct shm_file_data *sfd = shm_file_data(file);
@@ -284,21 +284,41 @@ static int shm_release(struct inode *ino, struct file *file)
 	return 0;
 }
 
-#ifndef CONFIG_MMU
+static int shm_fsync(struct file *file, struct dentry *dentry, int datasync)
+{
+	int (*fsync) (struct file *, struct dentry *, int datasync);
+	struct shm_file_data *sfd;
+	int ret;
+	ret = -EINVAL;
+	sfd = shm_file_data(file);
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
+	return get_unmapped_area(file, addr, len, pgoff, flags);
+}
+
+int is_file_shm_hugepages(struct file *file)
+{
+	int ret = 0;
+	if (file->f_op == &shm_file_operations) {
+		struct shm_file_data *sfd;
+		sfd = shm_file_data(file);
+		ret = is_file_hugepages(file);
+	}
+	return ret;
 }
-#else
-#define shm_get_unmapped_area NULL
-#endif
 
 static struct file_operations shm_file_operations = {
 	.mmap		= shm_mmap,
+	.fsync		= shm_fsync,
 	.release	= shm_release,
 	.get_unmapped_area	= shm_get_unmapped_area,
 };


