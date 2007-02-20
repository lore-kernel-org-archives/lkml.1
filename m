Return-Path: <linux-kernel-owner+w=401wt.eu-S964953AbXBTOwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964953AbXBTOwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 09:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964960AbXBTOwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 09:52:15 -0500
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:50101 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964953AbXBTOwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 09:52:13 -0500
To: shaggy@linux.vnet.ibm.com
CC: hlein@korelogic.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <1171979013.28491.16.camel@kleikamp.austin.ibm.com> (message from
	Dave Kleikamp on Tue, 20 Feb 2007 07:43:33 -0600)
Subject: Re: Accessing file-offset info for fds in /proc?
References: <20070220073130.GV5752@timmy.spinoli.org> <1171979013.28491.16.camel@kleikamp.austin.ibm.com>
Message-Id: <E1HJWLP-0000Vy-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 20 Feb 2007 15:51:51 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2007-02-20 at 02:31 -0500, Hank Leininger wrote:
> > Is there anything provided by the kernel that would let you see the
> > current offset of an existing filehandle?
> > 
> > Sometimes when processing a very large file (grepping a log, bzip2'ing
> > or gpg'ing a file, or whatever), I'd really like to know how far along
> > it is, because I'm impatient.  lsof has an -o flag to show offsets for
> > file descriptors it lists, but it appears that's not supported under
> > Linux.  It looks like all of the information lsof and fuser print about 
> > files in use, etc can be gotten from /proc/*/fd/* (and /proc/*/maps, but
> > I'm not really concerned with mmap'ed files, just positions on fds).
> > Sometimes I'll resort to strace -s4096'ing the process to see what chunk
> > of text it's currently reading, and try to guess from that.  Silly.
> > 
> > Has anybody ever developed a patch to implement this?  I realize this
> > could create a variety of information-leakage problems; the information
> > probably would need to be restricted, such as by the same rules as
> > dumpable.  Are there any horribly painful reasons why this couldn't be
> > done?
> 
> It shouldn't be too painful.  The code to populate /proc/*/fd/ has the
> file struct.  It just doesn't have a place pass the offset to user-space
> since it's basically creating a symlink.  In proc_fd_link(), it has the
> file struct.  The offset is file->f_pos.
> 
> One could create something like /proc/*/fd_offsets, whose read method
> could list the file descriptor, path, and offset for each open file.

I have an old patch, that does something like this.  Not much of it
applies now, but maybe it can be dusted off.

Miklos

----
This patch adds support for finding out the current file position of
an open file through the proc filesystem.  These new entries are
added:

  /proc/PID/fdinfo/FD/pos
  /proc/PID/task/TID/fdinfo/FD/pos

Various other (simpler) approaches are possible:

  a) return file position in st_size if lstat() is called on
     /proc/PID/fd/FD (suggested by lsof FAQ)

  b) list the open files and current positions in a single proc file
     (e.g. /proc/PID/fdpos)

I don't really like a) because it uses the file size information for
something else.  b) has the problem of not scaling well to large
number of file descriptors, if the user only wants information for a
single descriptor.

The 'fdinfo' approach also has the advantage of being easily
extensible.  For example if the "autonomous mount trees" patch makes
it to the kernel, there would be a need to get mount tree information
for each open file.

The inode number assignment looks like this:

  procfile                          ino
  --------                          ---
  /proc/PID/fd/FD                   (PID << 16) + 0x8000 + FD
  /proc/PID/fdinfo/FD               (PID << 16) + 0xc000 + FD * 8
  /proc/PID/fdinfo/FD/pos           (PID << 16) + 0xc000 + FD * 8 + 1

It is obvious that if a process has large number of file descriptors
(or just a large maximal fd) then inode numbers will clash.  This is
nothing new, the previous limit of 32768 file descriptors can easily
be exceeded with appropriate limits.  Now this goes down to 2048 fds,
before possible clashing.

If there is an inode number clash, nothing bad happens, just the inums
won't be unique anymore.  I really can't think of solving this in a
fundamentally better way.  Suggestions welcome.

Patch is against 2.6.12-rc5, but applies to any not very old kernel.

Index: linux/fs/proc/base.c
===================================================================
--- linux.orig/fs/proc/base.c	2005-08-19 14:47:36.000000000 +0200
+++ linux/fs/proc/base.c	2005-08-19 14:47:37.000000000 +0200
@@ -122,6 +122,7 @@ enum pid_directory_inos {
 #endif
 	PROC_TGID_OOM_SCORE,
 	PROC_TGID_OOM_ADJUST,
+	PROC_TGID_FDINFO,
 	PROC_TID_INO,
 	PROC_TID_STATUS,
 	PROC_TID_MEM,
@@ -160,11 +161,17 @@ enum pid_directory_inos {
 #endif
 	PROC_TID_OOM_SCORE,
 	PROC_TID_OOM_ADJUST,
+	PROC_TID_FDINFO,
 
 	/* Add new entries before this */
-	PROC_TID_FD_DIR = 0x8000,	/* 0x8000-0xffff */
+	PROC_TID_FD_DIR = 0x8000,		/* /proc/PID/fd/FD     */
+	PROC_TID_FDINFO_DIR = 0xc000,		/* /proc/PID/fdinfo/FD */
+
+	PROC_FDINFO_POS = 1,			/* /proc/PID/fdinfo/FD/pos */
 };
 
+#define PROC_TID_FDINFO_MUL 8
+
 struct pid_entry {
 	int type;
 	int len;
@@ -177,6 +184,7 @@ struct pid_entry {
 static struct pid_entry tgid_base_stuff[] = {
 	E(PROC_TGID_TASK,      "task",    S_IFDIR|S_IRUGO|S_IXUGO),
 	E(PROC_TGID_FD,        "fd",      S_IFDIR|S_IRUSR|S_IXUSR),
+	E(PROC_TGID_FDINFO,    "fdinfo",  S_IFDIR|S_IRUSR|S_IXUSR),
 	E(PROC_TGID_ENVIRON,   "environ", S_IFREG|S_IRUSR),
 	E(PROC_TGID_AUXV,      "auxv",	  S_IFREG|S_IRUSR),
 	E(PROC_TGID_STATUS,    "status",  S_IFREG|S_IRUGO),
@@ -217,6 +225,7 @@ static struct pid_entry tgid_base_stuff[
 };
 static struct pid_entry tid_base_stuff[] = {
 	E(PROC_TID_FD,         "fd",      S_IFDIR|S_IRUSR|S_IXUSR),
+	E(PROC_TID_FDINFO,     "fdinfo",  S_IFDIR|S_IRUSR|S_IXUSR),
 	E(PROC_TID_ENVIRON,    "environ", S_IFREG|S_IRUSR),
 	E(PROC_TID_AUXV,       "auxv",	  S_IFREG|S_IRUSR),
 	E(PROC_TID_STATUS,     "status",  S_IFREG|S_IRUGO),
@@ -273,22 +282,52 @@ static struct pid_entry tid_attr_stuff[]
 };
 #endif
 
+static struct pid_entry fdinfo_base_stuff[] = {
+	E(PROC_FDINFO_POS,     "pos",     S_IFREG|S_IRUGO),
+	{0,0,NULL,0}
+};
+
 #undef E
 
-static int proc_fd_link(struct inode *inode, struct dentry **dentry, struct vfsmount **mnt)
+static struct pid_entry *proc_pident_find(struct pid_entry *ents,
+					  struct task_struct *task,
+					  struct dentry *dentry)
+{
+	struct pid_entry *p;
+
+	if (!pid_alive(task))
+		return NULL;
+
+	for (p = ents; p->name; p++) {
+		if (p->len != dentry->d_name.len)
+			continue;
+		if (!memcmp(dentry->d_name.name, p->name, p->len))
+			break;
+	}
+	if (!p->name)
+		return NULL;
+
+	return p;
+}
+
+static int proc_fd_info(struct inode *inode, int fd, struct dentry **dentry,
+			struct vfsmount **mnt, loff_t *pos)
 {
 	struct task_struct *task = proc_task(inode);
 	struct files_struct *files;
 	struct file *file;
-	int fd = proc_type(inode) - PROC_TID_FD_DIR;
 
 	files = get_files_struct(task);
 	if (files) {
 		rcu_read_lock();
 		file = fcheck_files(files, fd);
 		if (file) {
-			*mnt = mntget(file->f_vfsmnt);
-			*dentry = dget(file->f_dentry);
+			if (mnt)
+				*mnt = mntget(file->f_vfsmnt);
+			if (dentry)
+				*dentry = dget(file->f_dentry);
+			if (pos)
+				*pos = file->f_pos;
 			rcu_read_unlock();
 			put_files_struct(files);
 			return 0;
@@ -299,6 +338,13 @@ static int proc_fd_link(struct inode *in
 	return -ENOENT;
 }
 
+static int proc_fd_link(struct inode *inode, struct dentry **dentry,
+			struct vfsmount **mnt)
+{
+	int fd = proc_type(inode) - PROC_TID_FD_DIR;
+	return proc_fd_info(inode, fd, dentry, mnt, NULL);
+}
+
 static struct fs_struct *get_fs_struct(struct task_struct *task)
 {
 	struct fs_struct *fs;
@@ -1032,7 +1078,24 @@ static struct inode_operations proc_pid_
 
 #define NUMBUF 10
 
-static int proc_readfd(struct file * filp, void * dirent, filldir_t filldir)
+static int get_fd_ino(unsigned int fd, int isfdinfo)
+{
+	if (isfdinfo)
+		return PROC_TID_FDINFO_DIR + fd * PROC_TID_FDINFO_MUL;
+	else
+		return PROC_TID_FD_DIR + fd;
+}
+
+static int get_ino_fd(int ino, int isfdinfo)
+{
+	if (isfdinfo)
+		return (ino - PROC_TID_FDINFO_DIR) / PROC_TID_FDINFO_MUL;
+	else
+		return ino - PROC_TID_FD_DIR;
+}
+
+static int proc_readfd_common(struct file * filp, void * dirent,
+			      filldir_t filldir, int isfdinfo)
 {
 	struct inode *inode = filp->f_dentry->d_inode;
 	struct task_struct *p = proc_task(inode);
@@ -1082,8 +1145,8 @@ static int proc_readfd(struct file * fil
 					i /= 10;
 				} while (i);
 
-				ino = fake_ino(tid, PROC_TID_FD_DIR + fd);
-				if (filldir(dirent, buf+j, NUMBUF-j, fd+2, ino, DT_LNK) < 0) {
+				ino = fake_ino(tid, get_fd_ino(fd, isfdinfo));
+				if (filldir(dirent, buf+j, NUMBUF-j, fd+2, ino, isfdinfo ? DT_DIR : DT_LNK) < 0) {
 					rcu_read_lock();
 					break;
 				}
@@ -1096,9 +1159,37 @@ out:
 	return retval;
 }
 
+static int proc_readfd(struct file * filp, void * dirent, filldir_t filldir)
+{
+	return proc_readfd_common(filp, dirent, filldir, 0);
+}
+
+static int proc_readfdinfo(struct file * filp, void * dirent, filldir_t filldir)
+{
+	return proc_readfd_common(filp, dirent, filldir, 1);
+}
+
+static int get_num_fd(struct task_struct *task)
+{
+	int num_fd = 0;
+	struct files_struct *files = get_files_struct(task);
+	if (files) {
+		int fd;
+		struct fdtable *fdt;
+		rcu_read_lock();
+		fdt = files_fdtable(files);
+		for (fd = 0; fd < fdt->max_fds; fd++)
+			if (fcheck_files(files, fd))
+				num_fd++;
+		rcu_read_unlock();
+		put_files_struct(files);
+	}
+	return num_fd;
+}
+
 static int proc_pident_readdir(struct file *filp,
 		void *dirent, filldir_t filldir,
-		struct pid_entry *ents, unsigned int nents)
+		struct pid_entry *ents, unsigned int nents, int offset)
 {
 	int i;
 	int pid;
@@ -1139,7 +1230,8 @@ static int proc_pident_readdir(struct fi
 		p = ents + i;
 		while (p->name) {
 			if (filldir(dirent, p->name, p->len, filp->f_pos,
-				    fake_ino(pid, p->type), p->mode >> 12) < 0)
+				    fake_ino(pid, p->type + offset),
+				    p->mode >> 12) < 0)
 				goto out;
 			filp->f_pos++;
 			p++;
@@ -1154,15 +1246,15 @@ out:
 static int proc_tgid_base_readdir(struct file * filp,
 			     void * dirent, filldir_t filldir)
 {
-	return proc_pident_readdir(filp,dirent,filldir,
-				   tgid_base_stuff,ARRAY_SIZE(tgid_base_stuff));
+	return proc_pident_readdir(filp, dirent, filldir, tgid_base_stuff,
+				   ARRAY_SIZE(tgid_base_stuff), 0);
 }
 
 static int proc_tid_base_readdir(struct file * filp,
 			     void * dirent, filldir_t filldir)
 {
-	return proc_pident_readdir(filp,dirent,filldir,
-				   tid_base_stuff,ARRAY_SIZE(tid_base_stuff));
+	return proc_pident_readdir(filp, dirent, filldir, tid_base_stuff,
+				   ARRAY_SIZE(tid_base_stuff), 0);
 }
 
 /* building an inode */
@@ -1259,7 +1351,8 @@ static int tid_fd_revalidate(struct dent
 {
 	struct inode *inode = dentry->d_inode;
 	struct task_struct *task = proc_task(inode);
-	int fd = proc_type(inode) - PROC_TID_FD_DIR;
+	struct proc_inode *ei = PROC_I(inode);
+	int fd = get_ino_fd(proc_type(inode), ei->op.proc_get_link == NULL);
 	struct files_struct *files;
 
 	files = get_files_struct(task);
@@ -1347,8 +1440,84 @@ out:
 	return ~0U;
 }
 
+static ssize_t proc_fdinfo_pos_read(struct file * file, char __user * buf,
+				    size_t count, loff_t *ppos)
+{
+	struct inode * inode = file->f_dentry->d_inode;
+	int fd = get_ino_fd(proc_type(inode), 1);
+	loff_t pos;
+	int res = proc_fd_info(inode, fd, NULL, NULL, &pos);
+	if (!res) {
+		char tmpbuf[32];
+		unsigned int len = sprintf(tmpbuf, "%lli\n", pos);
+		res = simple_read_from_buffer(buf, count, ppos, tmpbuf, len);
+	}
+	return res;
+}
+
+static struct file_operations proc_fdinfo_pos_file_operations = {
+	.read		= proc_fdinfo_pos_read,
+};
+
+static struct dentry *proc_fdinfo_base_lookup(struct inode *dir,
+					      struct dentry *dentry,
+					      struct nameidata *nd)
+{
+	struct inode *inode;
+	int error;
+	struct task_struct *task = proc_task(dir);
+	struct pid_entry *p;
+	struct proc_inode *ei;
+	int dirino;
+
+	error = -ENOENT;
+	p = proc_pident_find(fdinfo_base_stuff, task, dentry);
+	if (!p)
+		goto out;
+
+	error = -EINVAL;
+	dirino = proc_type(dir);
+	inode = proc_pid_make_inode(dir->i_sb, task, dirino + p->type);
+	if (!inode)
+		goto out;
+
+	ei = PROC_I(inode);
+	inode->i_mode = p->mode;
+
+	switch (p->type) {
+	case PROC_FDINFO_POS:
+		inode->i_fop = &proc_fdinfo_pos_file_operations;
+		break;
+	default:
+		BUG();
+	}
+	dentry->d_op = &tid_fd_dentry_operations;
+	d_add(dentry, inode);
+	return NULL;
+
+out:
+	return ERR_PTR(error);
+}
+
+static struct inode_operations proc_fdinfo_base_inode_operations = {
+	.lookup		= proc_fdinfo_base_lookup,
+};
+
+static int proc_fdinfo_base_readdir(struct file * filp,
+				    void * dirent, filldir_t filldir)
+{
+	int base_ino = filp->f_dentry->d_inode->i_ino;
+	return proc_pident_readdir(filp, dirent, filldir, fdinfo_base_stuff,
+				   ARRAY_SIZE(fdinfo_base_stuff), base_ino);
+}
+
+static struct file_operations proc_fdinfo_base_operations = {
+	.read		= generic_read_dir,
+	.readdir	= proc_fdinfo_base_readdir,
+};
+
 /* SMP-safe */
-static struct dentry *proc_lookupfd(struct inode * dir, struct dentry * dentry, struct nameidata *nd)
+static struct dentry *proc_lookupfd_common(struct inode * dir, struct dentry * dentry, int isfdinfo)
 {
 	struct task_struct *task = proc_task(dir);
 	unsigned fd = name_to_int(dentry);
@@ -1362,27 +1531,38 @@ static struct dentry *proc_lookupfd(stru
 	if (!pid_alive(task))
 		goto out;
 
-	inode = proc_pid_make_inode(dir->i_sb, task, PROC_TID_FD_DIR+fd);
+	inode = proc_pid_make_inode(dir->i_sb, task, get_fd_ino(fd, isfdinfo));
 	if (!inode)
 		goto out;
 	ei = PROC_I(inode);
 	files = get_files_struct(task);
 	if (!files)
 		goto out_unlock;
-	inode->i_mode = S_IFLNK;
 	rcu_read_lock();
 	file = fcheck_files(files, fd);
 	if (!file)
 		goto out_unlock2;
-	if (file->f_mode & 1)
-		inode->i_mode |= S_IRUSR | S_IXUSR;
-	if (file->f_mode & 2)
-		inode->i_mode |= S_IWUSR | S_IXUSR;
+	if (isfdinfo)
+		inode->i_mode = S_IFDIR | S_IRUGO | S_IXUGO;
+	else {
+		inode->i_mode = S_IFLNK;
+		if (file->f_mode & 1)
+			inode->i_mode |= S_IRUSR | S_IXUSR;
+		if (file->f_mode & 2)
+			inode->i_mode |= S_IWUSR | S_IXUSR;
+	}
 	rcu_read_unlock();
 	put_files_struct(files);
-	inode->i_op = &proc_pid_link_inode_operations;
-	inode->i_size = 64;
-	ei->op.proc_get_link = proc_fd_link;
+	if (isfdinfo) {
+		inode->i_op = &proc_fdinfo_base_inode_operations;
+		inode->i_fop = &proc_fdinfo_base_operations;
+		inode->i_nlink = 2;
+		inode->i_flags |= S_IMMUTABLE;
+	} else {
+		inode->i_op = &proc_pid_link_inode_operations;
+		inode->i_size = 64;
+		ei->op.proc_get_link = proc_fd_link;
+	}
 	dentry->d_op = &tid_fd_dentry_operations;
 	d_add(dentry, inode);
 	return NULL;
@@ -1396,6 +1576,19 @@ out:
 	return ERR_PTR(-ENOENT);
 }
 
+static struct dentry *proc_lookupfd(struct inode * dir, struct dentry * dentry,
+				    struct nameidata *nd)
+{
+	return proc_lookupfd_common(dir, dentry, 0);
+}
+
+static struct dentry *proc_lookupfdinfo(struct inode * dir,
+					struct dentry * dentry,
+					struct nameidata *nd)
+{
+	return proc_lookupfd_common(dir, dentry, 1);
+}
+
 static int proc_task_readdir(struct file * filp, void * dirent, filldir_t filldir);
 static struct dentry *proc_task_lookup(struct inode *dir, struct dentry * dentry, struct nameidata *nd);
 
@@ -1404,6 +1597,11 @@ static struct file_operations proc_fd_op
 	.readdir	= proc_readfd,
 };
 
+static struct file_operations proc_fdinfo_operations = {
+	.read		= generic_read_dir,
+	.readdir	= proc_readfdinfo,
+};
+
 static struct file_operations proc_task_operations = {
 	.read		= generic_read_dir,
 	.readdir	= proc_task_readdir,
@@ -1417,6 +1615,11 @@ static struct inode_operations proc_fd_i
 	.permission	= proc_permission,
 };
 
+static struct inode_operations proc_fdinfo_inode_operations = {
+	.lookup		= proc_lookupfdinfo,
+	.permission	= proc_permission,
+};
+
 static struct inode_operations proc_task_inode_operations = {
 	.lookup		= proc_task_lookup,
 	.permission	= proc_permission,
@@ -1488,7 +1691,7 @@ static struct inode_operations proc_tgid
 static int get_tid_list(int index, unsigned int *tids, struct inode *dir);
 
 /* SMP-safe */
-static struct dentry *proc_pident_lookup(struct inode *dir, 
+static struct dentry *proc_pident_lookup(struct inode *dir,
 					 struct dentry *dentry,
 					 struct pid_entry *ents)
 {
@@ -1499,18 +1702,8 @@ static struct dentry *proc_pident_lookup
 	struct proc_inode *ei;
 
 	error = -ENOENT;
-	inode = NULL;
-
-	if (!pid_alive(task))
-		goto out;
-
-	for (p = ents; p->name; p++) {
-		if (p->len != dentry->d_name.len)
-			continue;
-		if (!memcmp(dentry->d_name.name, p->name, p->len))
-			break;
-	}
-	if (!p->name)
+	p = proc_pident_find(ents, task, dentry);
+	if (!p)
 		goto out;
 
 	error = -EINVAL;
@@ -1536,6 +1729,12 @@ static struct dentry *proc_pident_lookup
 			inode->i_op = &proc_fd_inode_operations;
 			inode->i_fop = &proc_fd_operations;
 			break;
+		case PROC_TID_FDINFO:
+		case PROC_TGID_FDINFO:
+			inode->i_nlink = 2 + get_num_fd(task);
+			inode->i_op = &proc_fdinfo_inode_operations;
+			inode->i_fop = &proc_fdinfo_operations;
+			break;
 		case PROC_TID_EXE:
 		case PROC_TGID_EXE:
 			inode->i_op = &proc_pid_link_inode_operations;
@@ -1713,15 +1912,15 @@ static struct inode_operations proc_tid_
 static int proc_tgid_attr_readdir(struct file * filp,
 			     void * dirent, filldir_t filldir)
 {
-	return proc_pident_readdir(filp,dirent,filldir,
-				   tgid_attr_stuff,ARRAY_SIZE(tgid_attr_stuff));
+	return proc_pident_readdir(filp, dirent, filldir, tgid_attr_stuff,
+				   ARRAY_SIZE(tgid_attr_stuff), 0);
 }
 
 static int proc_tid_attr_readdir(struct file * filp,
 			     void * dirent, filldir_t filldir)
 {
-	return proc_pident_readdir(filp,dirent,filldir,
-				   tid_attr_stuff,ARRAY_SIZE(tid_attr_stuff));
+	return proc_pident_readdir(filp, dirent, filldir, tid_attr_stuff,
+				   ARRAY_SIZE(tid_attr_stuff), 0);
 }
 
 static struct file_operations proc_tgid_attr_operations = {
@@ -1880,9 +2079,9 @@ struct dentry *proc_pid_lookup(struct in
 	inode->i_fop = &proc_tgid_base_operations;
 	inode->i_flags|=S_IMMUTABLE;
 #ifdef CONFIG_SECURITY
-	inode->i_nlink = 5;
+	inode->i_nlink = 6;
 #else
-	inode->i_nlink = 4;
+	inode->i_nlink = 5;
 #endif
 
 	dentry->d_op = &pid_base_dentry_operations;
@@ -1939,9 +2138,9 @@ static struct dentry *proc_task_lookup(s
 	inode->i_fop = &proc_tid_base_operations;
 	inode->i_flags|=S_IMMUTABLE;
 #ifdef CONFIG_SECURITY
-	inode->i_nlink = 4;
+	inode->i_nlink = 5;
 #else
-	inode->i_nlink = 3;
+	inode->i_nlink = 4;
 #endif
 
 	dentry->d_op = &pid_base_dentry_operations;
