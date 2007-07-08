Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbXGHMA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbXGHMA0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 08:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbXGHLz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 07:55:26 -0400
Received: from il.qumranet.com ([82.166.9.18]:38407 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbXGHLyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 07:54:46 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>,
       Davide Libenzi <davidel@xmailserver.org>
Subject: [PATCH 12/20] KVM: Remove kvmfs in favor of the anonymous inodes source
Date: Sun,  8 Jul 2007 14:54:41 +0300
Message-Id: <11838956893490-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11838956891287-git-send-email-avi@qumranet.com>
References: <11838956891287-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kvm uses a pseudo filesystem, kvmfs, to generate inodes, a job that the
new anonymous inodes source does much better.

Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |  143 ++++--------------------------------------------
 fs/anon_inodes.c       |    1 +
 include/linux/magic.h  |    1 -
 3 files changed, 12 insertions(+), 133 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 5603000..26ca90f 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -43,6 +43,7 @@
 #include <linux/sched.h>
 #include <linux/cpumask.h>
 #include <linux/smp.h>
+#include <linux/anon_inodes.h>
 
 #include "x86_emulate.h"
 #include "segment_descriptor.h"
@@ -81,8 +82,6 @@ static struct kvm_stats_debugfs_item {
 
 static struct dentry *debugfs_dir;
 
-struct vfsmount *kvmfs_mnt;
-
 #define MAX_IO_MSRS 256
 
 #define CR0_RESEVED_BITS 0xffffffff1ffaffc0ULL
@@ -104,55 +103,6 @@ struct segment_descriptor_64 {
 static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
 			   unsigned long arg);
 
-static struct inode *kvmfs_inode(struct file_operations *fops)
-{
-	int error = -ENOMEM;
-	struct inode *inode = new_inode(kvmfs_mnt->mnt_sb);
-
-	if (!inode)
-		goto eexit_1;
-
-	inode->i_fop = fops;
-
-	/*
-	 * Mark the inode dirty from the very beginning,
-	 * that way it will never be moved to the dirty
-	 * list because mark_inode_dirty() will think
-	 * that it already _is_ on the dirty list.
-	 */
-	inode->i_state = I_DIRTY;
-	inode->i_mode = S_IRUSR | S_IWUSR;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
-	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
-	return inode;
-
-eexit_1:
-	return ERR_PTR(error);
-}
-
-static struct file *kvmfs_file(struct inode *inode, void *private_data)
-{
-	struct file *file = get_empty_filp();
-
-	if (!file)
-		return ERR_PTR(-ENFILE);
-
-	file->f_path.mnt = mntget(kvmfs_mnt);
-	file->f_path.dentry = d_alloc_anon(inode);
-	if (!file->f_path.dentry)
-		return ERR_PTR(-ENOMEM);
-	file->f_mapping = inode->i_mapping;
-
-	file->f_pos = 0;
-	file->f_flags = O_RDWR;
-	file->f_op = inode->i_fop;
-	file->f_mode = FMODE_READ | FMODE_WRITE;
-	file->f_version = 0;
-	file->private_data = private_data;
-	return file;
-}
-
 unsigned long segment_base(u16 selector)
 {
 	struct descriptor_table gdt;
@@ -2413,34 +2363,12 @@ static int create_vcpu_fd(struct kvm_vcpu *vcpu)
 	struct inode *inode;
 	struct file *file;
 
+	r = anon_inode_getfd(&fd, &inode, &file,
+			     "kvm-vcpu", &kvm_vcpu_fops, vcpu);
+	if (r)
+		return r;
 	atomic_inc(&vcpu->kvm->filp->f_count);
-	inode = kvmfs_inode(&kvm_vcpu_fops);
-	if (IS_ERR(inode)) {
-		r = PTR_ERR(inode);
-		goto out1;
-	}
-
-	file = kvmfs_file(inode, vcpu);
-	if (IS_ERR(file)) {
-		r = PTR_ERR(file);
-		goto out2;
-	}
-
-	r = get_unused_fd();
-	if (r < 0)
-		goto out3;
-	fd = r;
-	fd_install(fd, file);
-
 	return fd;
-
-out3:
-	fput(file);
-out2:
-	iput(inode);
-out1:
-	fput(vcpu->kvm->filp);
-	return r;
 }
 
 /*
@@ -2905,41 +2833,18 @@ static int kvm_dev_ioctl_create_vm(void)
 	struct file *file;
 	struct kvm *kvm;
 
-	inode = kvmfs_inode(&kvm_vm_fops);
-	if (IS_ERR(inode)) {
-		r = PTR_ERR(inode);
-		goto out1;
-	}
-
 	kvm = kvm_create_vm();
-	if (IS_ERR(kvm)) {
-		r = PTR_ERR(kvm);
-		goto out2;
+	if (IS_ERR(kvm))
+		return PTR_ERR(kvm);
+	r = anon_inode_getfd(&fd, &inode, &file, "kvm-vm", &kvm_vm_fops, kvm);
+	if (r) {
+		kvm_destroy_vm(kvm);
+		return r;
 	}
 
-	file = kvmfs_file(inode, kvm);
-	if (IS_ERR(file)) {
-		r = PTR_ERR(file);
-		goto out3;
-	}
 	kvm->filp = file;
 
-	r = get_unused_fd();
-	if (r < 0)
-		goto out4;
-	fd = r;
-	fd_install(fd, file);
-
 	return fd;
-
-out4:
-	fput(file);
-out3:
-	kvm_destroy_vm(kvm);
-out2:
-	iput(inode);
-out1:
-	return r;
 }
 
 static long kvm_dev_ioctl(struct file *filp,
@@ -3211,18 +3116,6 @@ static struct sys_device kvm_sysdev = {
 
 hpa_t bad_page_address;
 
-static int kvmfs_get_sb(struct file_system_type *fs_type, int flags,
-			const char *dev_name, void *data, struct vfsmount *mnt)
-{
-	return get_sb_pseudo(fs_type, "kvm:", NULL, KVMFS_SUPER_MAGIC, mnt);
-}
-
-static struct file_system_type kvm_fs_type = {
-	.name		= "kvmfs",
-	.get_sb		= kvmfs_get_sb,
-	.kill_sb	= kill_anon_super,
-};
-
 int kvm_init_arch(struct kvm_arch_ops *ops, struct module *module)
 {
 	int r;
@@ -3307,14 +3200,6 @@ static __init int kvm_init(void)
 	if (r)
 		goto out4;
 
-	r = register_filesystem(&kvm_fs_type);
-	if (r)
-		goto out3;
-
-	kvmfs_mnt = kern_mount(&kvm_fs_type);
-	r = PTR_ERR(kvmfs_mnt);
-	if (IS_ERR(kvmfs_mnt))
-		goto out2;
 	kvm_init_debug();
 
 	kvm_init_msr_list();
@@ -3331,10 +3216,6 @@ static __init int kvm_init(void)
 
 out:
 	kvm_exit_debug();
-	mntput(kvmfs_mnt);
-out2:
-	unregister_filesystem(&kvm_fs_type);
-out3:
 	kvm_mmu_module_exit();
 out4:
 	return r;
@@ -3344,8 +3225,6 @@ static __exit void kvm_exit(void)
 {
 	kvm_exit_debug();
 	__free_page(pfn_to_page(bad_page_address >> PAGE_SHIFT));
-	mntput(kvmfs_mnt);
-	unregister_filesystem(&kvm_fs_type);
 	kvm_mmu_module_exit();
 }
 
diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 40fe3a3..edc6748 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -139,6 +139,7 @@ err_put_filp:
 	put_filp(file);
 	return error;
 }
+EXPORT_SYMBOL_GPL(anon_inode_getfd);
 
 /*
  * A single inode exist for all anon_inode files. Contrary to pipes,
diff --git a/include/linux/magic.h b/include/linux/magic.h
index 9d713c0..36cc20d 100644
--- a/include/linux/magic.h
+++ b/include/linux/magic.h
@@ -13,7 +13,6 @@
 #define HPFS_SUPER_MAGIC	0xf995e849
 #define ISOFS_SUPER_MAGIC	0x9660
 #define JFFS2_SUPER_MAGIC	0x72b6
-#define KVMFS_SUPER_MAGIC	0x19700426
 #define ANON_INODE_FS_MAGIC	0x09041934
 
 #define MINIX_SUPER_MAGIC	0x137F		/* original minix fs */
-- 
1.5.2.2

