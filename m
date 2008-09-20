Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbYITQbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbYITQbW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 12:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbYITQbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 12:31:14 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:35164 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbYITQbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 12:31:12 -0400
Date: Sat, 20 Sep 2008 17:12:33 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: David Howells <dhowells@redhat.com>, Matt Mackall <mpm@selenic.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [patch] mm: tiny-shmem fix lor, mmap_sem vs i_mutex
In-Reply-To: <1221877119.8533.2.camel@nimitz>
Message-ID: <Pine.LNX.4.64.0809201649400.13926@blonde.site>
References: <20080910121217.GA16013@elte.hu>  <20080910144812.GB18644@wotan.suse.de>
  <1221058864.30429.291.camel@twins.programming.kicks-ass.net> 
 <20080910152651.GE18644@wotan.suse.de> <20080911082709.GA14378@elte.hu> 
 <20080914073906.GA6184@elte.hu>  <20080914004442.4f8e851f.akpm@linux-foundation.org>
  <20080914080631.GA10720@elte.hu> <20080914221231.GG27080@wotan.suse.de> 
 <20080917131419.e6b7622e.akpm@linux-foundation.org>  <20080918111226.GD29968@elte.hu>
  <48D2ABFD.3040103@goop.org>  <1221772310.4779.29.camel@calx>
 <1221877119.8533.2.camel@nimitz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please read on, the story takes a twist...

On Fri, 19 Sep 2008, Dave Hansen wrote:
> On Thu, 2008-09-18 at 14:11 -0700, Matt Mackall wrote:
> > On Thu, 2008-09-18 at 12:29 -0700, Jeremy Fitzhardinge wrote:
> > > Ingo Molnar wrote:
> > > > in 7 days that's about 7000 random bootups, 20% of which had TINY_SHMEM 
> > > > enabled, half 32-bit, half 64-bit x86. It did not blow up in any way 
> > > > that would have prevented the kernel from building its next random 
> > > > version from within itself and it did not produce any kernel messages 
> > > > with various random kernel debug, compile and boot options.
> > > 
> > > Does anything in that workload actually use shared memory?
> > 
> > [adding Dave]
> > 
> > For the record, Hugh tracked down the history of this bug and it went
> > something like this:
> > 
> > - I forked shmem.c and trimmed it down, keeping the function in question
> > intact
> > - Dave Hansen made divergent changes to shmem and tiny-shmem for reasons
> > that aren't immediately obvious
> 
> Man, my memory sucks.  All I see that 'git blame' can pin on me are some
> of the i_nlink helper additions.  Those weren't made in tiny-shmem.c
> simply because it doesn't manipulate i_nlink like shmem.c does.  Was
> there something else you had in mind?

Below is the commit I meant: prior to this, the shmem_file_read()s in
mm/shmem.c and mm/tiny-shmem.c were much the same, as Matt intended;
but in this commit you made a minor change in mm/shmem.c, but a
rearrangement in tiny-shmem.c (perhaps following your rearrangement
in fs/hugetlbfs/inode.c).  Later Al Viro fixed the double dput() on
failure which came from that rearrangement (is hugetlbfs okay?).

It's not immediately obvious why two such similar functions needed
two such dissimilar patches; and we'd all (Nick, Matt and I) prefer
to restore the similarity, especially now the tiny-shmem.c variant
has shown a locking problem.  Do you see any reason against that?

But now looking into it further, I see this is all a red herring,
your rearrangement is not the significant difference: before that
there was David Howells' Jan 2006 commit
b0e15190ead07056ab0c3844a499ff35e66d27cc
[PATCH] NOMMU: Make SYSV IPC SHM use ramfs facilities on NOMMU
which is the one which adds do_truncate() into tiny-shmem.c's
shmem_file_setup() but not into shmem.c's - presumably because
config SHMEM depends on MMU so it was irrelevant in shmem.c.

*That* is the relevant commit, which introduced the bad i_mutex
within mmap_sem lock ordering, and it seems that Nick's current
patch is wrong just to remove that do_truncate(), a significant
change hidden inside his restoration of the original arrangement.

I confess I've made no effort to work what the right answer is
(an #ifndef CONFIG_MMU might hack it for now, but hardly satisfies),
and I'm about to vanish for a couple of days: so please,
don't wait on a reply from me...

Hugh

commit ce8d2cdf3d2b73e346c82e6f0a46da331df6364c
Author: Dave Hansen <haveblue@us.ibm.com>
Date:   Tue Oct 16 23:31:13 2007 -0700

    r/o bind mounts: filesystem helpers for custom 'struct file's
    
    Why do we need r/o bind mounts?
    
    This feature allows a read-only view into a read-write filesystem.  In the
    process of doing that, it also provides infrastructure for keeping track of
    the number of writers to any given mount.
    
    This has a number of uses.  It allows chroots to have parts of filesystems
    writable.  It will be useful for containers in the future because users may
    have root inside a container, but should not be allowed to write to
    somefilesystems.  This also replaces patches that vserver has had out of the
    tree for several years.
    
    It allows security enhancement by making sure that parts of your filesystem
    read-only (such as when you don't trust your FTP server), when you don't want
    to have entire new filesystems mounted, or when you want atime selectively
    updated.  I've been using the following script to test that the feature is
    working as desired.  It takes a directory and makes a regular bind and a r/o
    bind mount of it.  It then performs some normal filesystem operations on the
    three directories, including ones that are expected to fail, like creating a
    file on the r/o mount.
    
    This patch:
    
    Some filesystems forego the vfs and may_open() and create their own 'struct
    file's.
    
    This patch creates a couple of helper functions which can be used by these
    filesystems, and will provide a unified place which the r/o bind mount code
    may patch.
    
    Also, rename an existing, static-scope init_file() to a less generic name.
    
    Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
    Cc: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 2f436d4..50ed691 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -142,7 +142,7 @@ static int init_dir(struct inode * inode)
 	return 0;
 }
 
-static int init_file(struct inode * inode)
+static int configfs_init_file(struct inode * inode)
 {
 	inode->i_size = PAGE_SIZE;
 	inode->i_fop = &configfs_file_operations;
@@ -283,7 +283,8 @@ static int configfs_attach_attr(struct configfs_dirent * sd, struct dentry * den
 
 	dentry->d_fsdata = configfs_get(sd);
 	sd->s_dentry = dentry;
-	error = configfs_create(dentry, (attr->ca_mode & S_IALLUGO) | S_IFREG, init_file);
+	error = configfs_create(dentry, (attr->ca_mode & S_IALLUGO) | S_IFREG,
+				configfs_init_file);
 	if (error) {
 		configfs_put(sd);
 		return error;
diff --git a/fs/file_table.c b/fs/file_table.c
index ce3f39a..3176fef 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -137,6 +137,66 @@ fail:
 
 EXPORT_SYMBOL(get_empty_filp);
 
+/**
+ * alloc_file - allocate and initialize a 'struct file'
+ * @mnt: the vfsmount on which the file will reside
+ * @dentry: the dentry representing the new file
+ * @mode: the mode with which the new file will be opened
+ * @fop: the 'struct file_operations' for the new file
+ *
+ * Use this instead of get_empty_filp() to get a new
+ * 'struct file'.  Do so because of the same initialization
+ * pitfalls reasons listed for init_file().  This is a
+ * preferred interface to using init_file().
+ *
+ * If all the callers of init_file() are eliminated, its
+ * code should be moved into this function.
+ */
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
+/**
+ * init_file - initialize a 'struct file'
+ * @file: the already allocated 'struct file' to initialized
+ * @mnt: the vfsmount on which the file resides
+ * @dentry: the dentry representing this file
+ * @mode: the mode the file is opened with
+ * @fop: the 'struct file_operations' for this file
+ *
+ * Use this instead of setting the members directly.  Doing so
+ * avoids making mistakes like forgetting the mntget() or
+ * forgetting to take a write on the mnt.
+ *
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
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 0f5df73..12aca8e 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -933,16 +933,11 @@ struct file *hugetlb_file_setup(const char *name, size_t size)
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
@@ -951,17 +946,18 @@ struct file *hugetlb_file_setup(const char *name, size_t size)
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
diff --git a/include/linux/file.h b/include/linux/file.h
index 0114fbc..56023c7 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
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
diff --git a/ipc/shm.c b/ipc/shm.c
index b8884c2..5fc5cf5 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -907,7 +907,7 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
 		goto out_unlock;
 
 	path.dentry = dget(shp->shm_file->f_path.dentry);
-	path.mnt    = mntget(shp->shm_file->f_path.mnt);
+	path.mnt    = shp->shm_file->f_path.mnt;
 	shp->shm_nattch++;
 	size = i_size_read(path.dentry->d_inode);
 	shm_unlock(shp);
@@ -915,18 +915,16 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
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
@@ -977,9 +975,8 @@ out_unlock:
 
 out_free:
 	kfree(sfd);
-out_put_path:
+out_put_dentry:
 	dput(path.dentry);
-	mntput(path.mnt);
 	goto out_nattch;
 }
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 6fa20a8..289dbb0 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2543,11 +2543,8 @@ struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags)
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
diff --git a/mm/tiny-shmem.c b/mm/tiny-shmem.c
index 8803471..d436a9c 100644
--- a/mm/tiny-shmem.c
+++ b/mm/tiny-shmem.c
@@ -66,24 +66,19 @@ struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags)
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
diff --git a/net/socket.c b/net/socket.c
index 3cd96fe..540013e 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -364,26 +364,26 @@ static int sock_alloc_fd(struct file **filep)
 
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
