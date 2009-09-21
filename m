Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbZIUMvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbZIUMvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 08:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbZIUMvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 08:51:48 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44506 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920AbZIUMvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 08:51:47 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu, agruen@suse.de,
       hch@lst.de, hugh.dickins@tiscali.co.uk, matthew@wil.cx
In-reply-to: <E1MpiJo-0005fv-2y@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Mon, 21 Sep 2009 14:48:36 +0200)
Subject: [PATCH 2/2] vfs: fix d_path() for unreachable paths
References: <E1MpiJo-0005fv-2y@pomaz-ex.szeredi.hu>
Message-Id: <E1MpiMo-0005h9-DG@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 21 Sep 2009 14:51:42 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(The two fixes have been folded into this one)

----
From: Miklos Szeredi <mszeredi@suse.cz>

John Johansen pointed out, that getcwd(2) will give a garbled result
if a bind mount of a non-filesystem-root directory is detached:

   > mkdir /mnt/foo
   > mount --bind /etc /mnt/foo
   > cd /mnt/foo/skel
   > umount -l /mnt/foo
   > /bin/pwd
   etcskel

If it was the root of the filesystem which was detached, it will give
a saner looking result, but it still won't be a valid absolute path by
which the CWD can be reached (assuming the process's root is not also
on the detached mount).

A similar issue happens if the CWD is outside the process's root or in
a different namespace.  These problems are relevant to symlinks under
/proc/<pid>/ and /proc/<pid>/fd/ as well.

This patch addresses all these issues, by prefixing such unreachable
paths with "(unreachable)".  This isn't perfect since the returned
path may still be a valid _relative_ path, and applications may not
check the result of getcwd() for starting with a '/' before using it.

For this reason Andreas Gruenbacher thinks getcwd(2) should return
ENOENT in these cases, but that breaks /bin/pwd and bash in the above
cases.

Hugh Dickins reported that an old version of gnome-vfs-daemon crashes
because it finds an entry in /proc/mounts where the mountpoint is
unreachable.  So revert /proc/mounts to the old behavior (or rather a
less crazy version of the old behavior).

Also revert the effect on /proc/${PID}/maps for memory maps set up
with shmem_file_setup() or hugetlb_file_setup().  These functions set
up unlinked files under a kernel-private vfsmount.  Since this
vfsmount is unreachable from userspace, these maps will be reported
with the "(unreachable)" prefix, which is undesirable, because it
changes the kernel ABI and might break applications for no good
reason.

Reported-by: John Johansen <jjohansen@suse.de>
CC: Matthew Wilcox <matthew@wil.cx>
CC: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

---
 fs/dcache.c          |   20 ++++++++++++++++-
 fs/hugetlbfs/inode.c |   17 +++++++++++++++
 fs/namespace.c       |   57 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 mm/shmem.c           |   17 +++++++++++++++
 4 files changed, 108 insertions(+), 3 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2009-09-21 14:31:35.000000000 +0200
+++ linux-2.6/fs/dcache.c	2009-09-21 14:31:37.000000000 +0200
@@ -1883,6 +1883,12 @@ static int prepend_name(char **buffer, i
 	return prepend(buffer, buflen, name->name, name->len);
 }
 
+static bool is_pseudo_root(struct dentry *dentry)
+{
+	return IS_ROOT(dentry) &&
+		(dentry->d_name.len != 1 || dentry->d_name.name[0] != '/');
+}
+
 /**
  * __d_path - return the path of a dentry
  * @path: the dentry/vfsmount to report
@@ -1950,8 +1956,18 @@ out:
 
 global_root:
 	retval += 1;	/* hit the slash */
-	if (prepend_name(&retval, &buflen, &dentry->d_name) != 0)
-		goto Elong;
+
+	if (is_pseudo_root(dentry)) {
+		/* Pseudo filesystem with "foo:" prefix */
+		if (prepend_name(&retval, &buflen, &dentry->d_name) != 0)
+			goto Elong;
+	} else {
+		/*
+		 * Unreachable (detached or outside root or outside namespace)
+		 */
+		if (prepend(&retval, &buflen, "(unreachable)/", 14) != 0)
+			goto Elong;
+	}
 	root->mnt = vfsmnt;
 	root->dentry = dentry;
 	goto out;
Index: linux-2.6/fs/hugetlbfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hugetlbfs/inode.c	2009-09-21 14:31:35.000000000 +0200
+++ linux-2.6/fs/hugetlbfs/inode.c	2009-09-21 14:31:37.000000000 +0200
@@ -931,6 +931,21 @@ static struct file_system_type hugetlbfs
 
 static struct vfsmount *hugetlbfs_vfsmount;
 
+/*
+ * Do a special d_dname function so that these are not prefixed by
+ * "(unreachable)".
+ */
+static char *hugetlb_unlinked_d_dname(struct dentry *dentry, char *buf,
+				      int buflen)
+{
+	return dynamic_dname(dentry, buf, buflen, "/%s (deleted)",
+			     dentry->d_name.name);
+}
+
+static struct dentry_operations hugetlb_unlinked_dentry_operations = {
+	.d_dname = hugetlb_unlinked_d_dname,
+};
+
 static int can_do_hugetlb_shm(void)
 {
 	return capable(CAP_IPC_LOCK) || in_group_p(sysctl_hugetlb_shm_group);
@@ -968,6 +983,8 @@ struct file *hugetlb_file_setup(const ch
 	if (!dentry)
 		goto out_shm_unlock;
 
+	dentry->d_op = &hugetlb_unlinked_dentry_operations;
+
 	error = -ENOSPC;
 	inode = hugetlbfs_get_inode(root->d_sb, current_fsuid(),
 				current_fsgid(), S_IFREG | S_IRWXUGO, 0);
Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c	2009-09-21 14:31:35.000000000 +0200
+++ linux-2.6/fs/namespace.c	2009-09-21 14:31:37.000000000 +0200
@@ -789,6 +789,61 @@ static void show_type(struct seq_file *m
 	}
 }
 
+/*
+ * Same as d_path() except it doesn't stick "(unreachable)" in front
+ * of unreachable paths.
+ */
+static char *d_path_compat(struct path *path, char *buf, int buflen)
+{
+	char *res;
+	struct path root;
+	struct path tmp;
+
+	read_lock(&current->fs->lock);
+	root = current->fs->root;
+	path_get(&root);
+	read_unlock(&current->fs->lock);
+	spin_lock(&dcache_lock);
+	tmp = root;
+	res = __d_path(path, &tmp, buf, buflen);
+	if (!IS_ERR(res) &&
+	    (tmp.mnt != root.mnt || tmp.dentry != root.dentry)) {
+		/*
+		 * Unreachable path found, redo with the global root
+		 * so we get a normal looking path.
+		 */
+		res = __d_path(path, &tmp, buf, buflen);
+	}
+	spin_unlock(&dcache_lock);
+	path_put(&root);
+
+	return res;
+}
+
+/*
+ * Some old programs break if /proc/mounts contains a mountpoint
+ * beginning with "(unreachable)".  Revert this back to the old way of
+ * displaying the path from the global root instead.
+ */
+static int show_path_old(struct seq_file *m, struct path *path, char *esc)
+{
+	char *buf;
+	size_t size = seq_get_buf(m, &buf);
+	int res = -1;
+
+	if (size) {
+		char *p = d_path_compat(path, buf, size);
+		if (!IS_ERR(p)) {
+			char *end = mangle_path(buf, p, esc);
+			if (end)
+				res = end - buf;
+		}
+	}
+	seq_commit(m, res);
+
+	return res;
+}
+
 static int show_vfsmnt(struct seq_file *m, void *v)
 {
 	struct vfsmount *mnt = list_entry(v, struct vfsmount, mnt_list);
@@ -797,7 +852,7 @@ static int show_vfsmnt(struct seq_file *
 
 	mangle(m, mnt->mnt_devname ? mnt->mnt_devname : "none");
 	seq_putc(m, ' ');
-	seq_path(m, &mnt_path, " \t\n\\");
+	show_path_old(m, &mnt_path, " \t\n\\");
 	seq_putc(m, ' ');
 	show_type(m, mnt->mnt_sb);
 	seq_puts(m, __mnt_is_readonly(mnt) ? " ro" : " rw");
Index: linux-2.6/mm/shmem.c
===================================================================
--- linux-2.6.orig/mm/shmem.c	2009-09-21 14:31:35.000000000 +0200
+++ linux-2.6/mm/shmem.c	2009-09-21 14:31:37.000000000 +0200
@@ -2601,6 +2601,21 @@ int shmem_unuse(swp_entry_t entry, struc
 
 /* common code */
 
+/*
+ * Do a special d_dname function so that these are not prefixed by
+ * "(unreachable)".
+ */
+static char *shmem_unlinked_d_dname(struct dentry *dentry, char *buf,
+				    int buflen)
+{
+	return dynamic_dname(dentry, buf, buflen, "/%s (deleted)",
+			     dentry->d_name.name);
+}
+
+static struct dentry_operations shmem_unlinked_dentry_operations = {
+	.d_dname = shmem_unlinked_d_dname,
+};
+
 /**
  * shmem_file_setup - get an unlinked file living in tmpfs
  * @name: name for dentry (to be seen in /proc/<pid>/maps
@@ -2633,6 +2648,8 @@ struct file *shmem_file_setup(const char
 	if (!dentry)
 		goto put_memory;
 
+	dentry->d_op = &shmem_unlinked_dentry_operations;
+
 	error = -ENFILE;
 	file = get_empty_filp();
 	if (!file)
