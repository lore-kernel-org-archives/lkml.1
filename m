Return-Path: <linux-kernel-owner+w=401wt.eu-S965329AbXGLAba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965329AbXGLAba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935935AbXGLASp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:18:45 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47412 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936787AbXGLARU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:17:20 -0400
Subject: [PATCH 03/23] filesystem helpers for custom 'struct file's
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Wed, 11 Jul 2007 17:17:13 -0700
References: <20070712001710.654CD9ED@kernel>
In-Reply-To: <20070712001710.654CD9ED@kernel>
Message-Id: <20070712001713.27376AD1@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Christoph H. says this stands on its own and can go in before the
rest of the r/o bind mount set.  

---

Some filesystems forego the vfs and may_open() and create their
own 'struct file's.

This patch creates a couple of helper functions which can be
used by these filesystems, and will provide a unified place
which the r/o bind mount code may patch.

Also, rename an existing, static-scope init_file() to a less
generic name.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/configfs/dir.c    |    5 +++--
 lxc-dave/fs/file_table.c      |   34 ++++++++++++++++++++++++++++++++++
 lxc-dave/fs/hugetlbfs/inode.c |   22 +++++++++-------------
 lxc-dave/include/linux/file.h |    9 +++++++++
 lxc-dave/ipc/shm.c            |   13 +++++--------
 lxc-dave/mm/shmem.c           |    7 ++-----
 lxc-dave/mm/tiny-shmem.c      |   19 +++++++------------
 lxc-dave/net/socket.c         |   18 +++++++++---------
 8 files changed, 78 insertions(+), 49 deletions(-)

diff -puN fs/configfs/dir.c~filesystem-helpers-for-custom-struct-file-s fs/configfs/dir.c
--- lxc/fs/configfs/dir.c~filesystem-helpers-for-custom-struct-file-s	2007-07-10 12:46:03.000000000 -0700
+++ lxc-dave/fs/configfs/dir.c	2007-07-10 12:46:03.000000000 -0700
@@ -142,7 +142,7 @@ static int init_dir(struct inode * inode
 	return 0;
 }
 
-static int init_file(struct inode * inode)
+static int configfs_init_file(struct inode * inode)
 {
 	inode->i_size = PAGE_SIZE;
 	inode->i_fop = &configfs_file_operations;
@@ -283,7 +283,8 @@ static int configfs_attach_attr(struct c
 
 	dentry->d_fsdata = configfs_get(sd);
 	sd->s_dentry = dentry;
-	error = configfs_create(dentry, (attr->ca_mode & S_IALLUGO) | S_IFREG, init_file);
+	error = configfs_create(dentry, (attr->ca_mode & S_IALLUGO) | S_IFREG,
+				configfs_init_file);
 	if (error) {
 		configfs_put(sd);
 		return error;
diff -puN fs/file_table.c~filesystem-helpers-for-custom-struct-file-s fs/file_table.c
--- lxc/fs/file_table.c~filesystem-helpers-for-custom-struct-file-s	2007-07-10 12:46:03.000000000 -0700
+++ lxc-dave/fs/file_table.c	2007-07-10 12:46:03.000000000 -0700
@@ -138,6 +138,40 @@ fail:
 
 EXPORT_SYMBOL(get_empty_filp);
 
+struct file *alloc_file(struct vfsmount *mnt, struct dentry *dentry,
+		mode_t mode, const struct file_operations *fop)
+{
+	struct file *file;
+	struct path;
+
+	file = get_empty_filp();
+	if (!file)
+		return NULL;
+
+	init_file(file, mnt, dentry, mode, fop);
+	return file;
+}
+EXPORT_SYMBOL(alloc_file);
+
+/*
+ * Note: This is a crappy interface.  It is here to make
+ * merging with the existing users of get_empty_filp()
+ * who have complex failure logic easier.  All users
+ * of this should be moving to alloc_file().
+ */
+int init_file(struct file *file, struct vfsmount *mnt, struct dentry *dentry,
+	   mode_t mode, const struct file_operations *fop)
+{
+	int error = 0;
+	file->f_path.dentry = dentry;
+	file->f_path.mnt = mntget(mnt);
+	file->f_mapping = dentry->d_inode->i_mapping;
+	file->f_mode = mode;
+	file->f_op = fop;
+	return error;
+}
+EXPORT_SYMBOL(init_file);
+
 void fastcall fput(struct file *file)
 {
 	if (atomic_dec_and_test(&file->f_count))
diff -puN fs/hugetlbfs/inode.c~filesystem-helpers-for-custom-struct-file-s fs/hugetlbfs/inode.c
--- lxc/fs/hugetlbfs/inode.c~filesystem-helpers-for-custom-struct-file-s	2007-07-10 12:46:03.000000000 -0700
+++ lxc-dave/fs/hugetlbfs/inode.c	2007-07-10 12:46:03.000000000 -0700
@@ -761,16 +761,11 @@ struct file *hugetlb_file_setup(const ch
 	if (!dentry)
 		goto out_shm_unlock;
 
-	error = -ENFILE;
-	file = get_empty_filp();
-	if (!file)
-		goto out_dentry;
-
 	error = -ENOSPC;
 	inode = hugetlbfs_get_inode(root->d_sb, current->fsuid,
 				current->fsgid, S_IFREG | S_IRWXUGO, 0);
 	if (!inode)
-		goto out_file;
+		goto out_dentry;
 
 	error = -ENOMEM;
 	if (hugetlb_reserve_pages(inode, 0, size >> HPAGE_SHIFT))
@@ -779,17 +774,18 @@ struct file *hugetlb_file_setup(const ch
 	d_instantiate(dentry, inode);
 	inode->i_size = size;
 	inode->i_nlink = 0;
-	file->f_path.mnt = mntget(hugetlbfs_vfsmount);
-	file->f_path.dentry = dentry;
-	file->f_mapping = inode->i_mapping;
-	file->f_op = &hugetlbfs_file_operations;
-	file->f_mode = FMODE_WRITE | FMODE_READ;
+
+	error = -ENFILE;
+	file = alloc_file(hugetlbfs_vfsmount, dentry,
+			FMODE_WRITE | FMODE_READ,
+			&hugetlbfs_file_operations);
+	if (!file)
+		goto out_inode;
+
 	return file;
 
 out_inode:
 	iput(inode);
-out_file:
-	put_filp(file);
 out_dentry:
 	dput(dentry);
 out_shm_unlock:
diff -puN include/linux/file.h~filesystem-helpers-for-custom-struct-file-s include/linux/file.h
--- lxc/include/linux/file.h~filesystem-helpers-for-custom-struct-file-s	2007-07-10 12:46:03.000000000 -0700
+++ lxc-dave/include/linux/file.h	2007-07-10 12:46:03.000000000 -0700
@@ -62,6 +62,15 @@ extern struct kmem_cache *filp_cachep;
 extern void FASTCALL(__fput(struct file *));
 extern void FASTCALL(fput(struct file *));
 
+struct file_operations;
+struct vfsmount;
+struct dentry;
+extern int init_file(struct file *, struct vfsmount *mnt,
+		struct dentry *dentry, mode_t mode,
+		const struct file_operations *fop);
+extern struct file *alloc_file(struct vfsmount *, struct dentry *dentry,
+		mode_t mode, const struct file_operations *fop);
+
 static inline void fput_light(struct file *file, int fput_needed)
 {
 	if (unlikely(fput_needed))
diff -puN ipc/shm.c~filesystem-helpers-for-custom-struct-file-s ipc/shm.c
--- lxc/ipc/shm.c~filesystem-helpers-for-custom-struct-file-s	2007-07-10 12:46:03.000000000 -0700
+++ lxc-dave/ipc/shm.c	2007-07-10 12:46:03.000000000 -0700
@@ -906,7 +906,7 @@ long do_shmat(int shmid, char __user *sh
 		goto out_unlock;
 
 	path.dentry = dget(shp->shm_file->f_path.dentry);
-	path.mnt    = mntget(shp->shm_file->f_path.mnt);
+	path.mnt    = shp->shm_file->f_path.mnt;
 	shp->shm_nattch++;
 	size = i_size_read(path.dentry->d_inode);
 	shm_unlock(shp);
@@ -914,18 +914,16 @@ long do_shmat(int shmid, char __user *sh
 	err = -ENOMEM;
 	sfd = kzalloc(sizeof(*sfd), GFP_KERNEL);
 	if (!sfd)
-		goto out_put_path;
+		goto out_put_dentry;
 
 	err = -ENOMEM;
-	file = get_empty_filp();
+
+	file = alloc_file(path.mnt, path.dentry, f_mode, &shm_file_operations);
 	if (!file)
 		goto out_free;
 
-	file->f_op = &shm_file_operations;
 	file->private_data = sfd;
-	file->f_path = path;
 	file->f_mapping = shp->shm_file->f_mapping;
-	file->f_mode = f_mode;
 	sfd->id = shp->id;
 	sfd->ns = get_ipc_ns(ns);
 	sfd->file = shp->shm_file;
@@ -976,9 +974,8 @@ out_unlock:
 
 out_free:
 	kfree(sfd);
-out_put_path:
+out_put_dentry:
 	dput(path.dentry);
-	mntput(path.mnt);
 	goto out_nattch;
 }
 
diff -puN mm/shmem.c~filesystem-helpers-for-custom-struct-file-s mm/shmem.c
--- lxc/mm/shmem.c~filesystem-helpers-for-custom-struct-file-s	2007-07-10 12:46:03.000000000 -0700
+++ lxc-dave/mm/shmem.c	2007-07-10 12:46:03.000000000 -0700
@@ -2566,11 +2566,8 @@ struct file *shmem_file_setup(char *name
 	d_instantiate(dentry, inode);
 	inode->i_size = size;
 	inode->i_nlink = 0;	/* It is unlinked */
-	file->f_path.mnt = mntget(shm_mnt);
-	file->f_path.dentry = dentry;
-	file->f_mapping = inode->i_mapping;
-	file->f_op = &shmem_file_operations;
-	file->f_mode = FMODE_WRITE | FMODE_READ;
+	init_file(file, shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
+			&shmem_file_operations);
 	return file;
 
 close_file:
diff -puN mm/tiny-shmem.c~filesystem-helpers-for-custom-struct-file-s mm/tiny-shmem.c
--- lxc/mm/tiny-shmem.c~filesystem-helpers-for-custom-struct-file-s	2007-07-10 12:46:03.000000000 -0700
+++ lxc-dave/mm/tiny-shmem.c	2007-07-10 12:46:03.000000000 -0700
@@ -66,24 +66,19 @@ struct file *shmem_file_setup(char *name
 	if (!dentry)
 		goto put_memory;
 
-	error = -ENFILE;
-	file = get_empty_filp();
-	if (!file)
-		goto put_dentry;
-
 	error = -ENOSPC;
 	inode = ramfs_get_inode(root->d_sb, S_IFREG | S_IRWXUGO, 0);
 	if (!inode)
-		goto close_file;
+		goto put_dentry;
 
 	d_instantiate(dentry, inode);
-	inode->i_nlink = 0;	/* It is unlinked */
+	error = -ENFILE;
+	file = alloc_file(shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
+			&ramfs_file_operations);
+	if (!file)
+		goto put_dentry;
 
-	file->f_path.mnt = mntget(shm_mnt);
-	file->f_path.dentry = dentry;
-	file->f_mapping = inode->i_mapping;
-	file->f_op = &ramfs_file_operations;
-	file->f_mode = FMODE_WRITE | FMODE_READ;
+	inode->i_nlink = 0;	/* It is unlinked */
 
 	/* notify everyone as to the change of file size */
 	error = do_truncate(dentry, size, 0, file);
diff -puN net/socket.c~filesystem-helpers-for-custom-struct-file-s net/socket.c
--- lxc/net/socket.c~filesystem-helpers-for-custom-struct-file-s	2007-07-10 12:46:03.000000000 -0700
+++ lxc-dave/net/socket.c	2007-07-10 12:46:03.000000000 -0700
@@ -364,26 +364,26 @@ static int sock_alloc_fd(struct file **f
 
 static int sock_attach_fd(struct socket *sock, struct file *file)
 {
+	struct dentry *dentry;
 	struct qstr name = { .name = "" };
 
-	file->f_path.dentry = d_alloc(sock_mnt->mnt_sb->s_root, &name);
-	if (unlikely(!file->f_path.dentry))
+	dentry = d_alloc(sock_mnt->mnt_sb->s_root, &name);
+	if (unlikely(!dentry))
 		return -ENOMEM;
 
-	file->f_path.dentry->d_op = &sockfs_dentry_operations;
+	dentry->d_op = &sockfs_dentry_operations;
 	/*
 	 * We dont want to push this dentry into global dentry hash table.
 	 * We pretend dentry is already hashed, by unsetting DCACHE_UNHASHED
 	 * This permits a working /proc/$pid/fd/XXX on sockets
 	 */
-	file->f_path.dentry->d_flags &= ~DCACHE_UNHASHED;
-	d_instantiate(file->f_path.dentry, SOCK_INODE(sock));
-	file->f_path.mnt = mntget(sock_mnt);
-	file->f_mapping = file->f_path.dentry->d_inode->i_mapping;
+	dentry->d_flags &= ~DCACHE_UNHASHED;
+	d_instantiate(dentry, SOCK_INODE(sock));
 
 	sock->file = file;
-	file->f_op = SOCK_INODE(sock)->i_fop = &socket_file_ops;
-	file->f_mode = FMODE_READ | FMODE_WRITE;
+	init_file(file, sock_mnt, dentry, FMODE_READ | FMODE_WRITE,
+		  &socket_file_ops);
+	SOCK_INODE(sock)->i_fop = &socket_file_ops;
 	file->f_flags = O_RDWR;
 	file->f_pos = 0;
 	file->private_data = sock;
_
