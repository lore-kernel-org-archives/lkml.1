Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbYAUTuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbYAUTuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 14:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbYAUTtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 14:49:49 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41467 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbYAUTtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 14:49:45 -0500
Subject: Re: [RFC][PATCH] VFS: create /proc/<pid>/mountinfo
From: Ram Pai <linuxram@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, util-linux-ng@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org, a.p.zijlstra@chello.nl
In-Reply-To: <E1JGBVq-0002Or-H1@pomaz-ex.szeredi.hu>
References: <E1JGBVq-0002Or-H1@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Mon, 21 Jan 2008 11:48:05 -0800
Message-Id: <1200944886.2988.27.camel@ram.us.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Miklos,

	You have removed the code that checked if the peer or
	master mount was in the same namespace before reporting their
	corresponding mount-ids. One downside of that approach is the
	user will see an mount_id in the output with no corresponding
	line to explain the details of the mount_id.  

	And reporting the mount-id of a mount is some other namespace
	could subtly mean information-leak?


	One other comment I had received offline from Steve French was
	that the patch did not consider the following case:

	"Have you thought about whether this could handle the case in which cifs mounts with 
	a relative path e.g. currently
         	mount -t cifs //server/share /mnt

	can not be distinguished from
        	mount -t cifs //server/share/subdirectory /mnt

	when you run the mount command (ie the cifs "prefixpath" in this case 
	"/subdirectory" is not displayed)"


thanks for driving this patch further and sorry; have not been active on this work for a while,
RP


On Sat, 2008-01-19 at 12:05 +0100, Miklos Szeredi wrote:
> Seems, most people would be happier with a new file, instead of
> extending /proc/mounts.
> 
> This patch is the first attempt at doing that, as well as fixing the
> issues found in the previous submission.
> 
> Thanks,
> Miklos
> 
> ---
> From: Ram Pai <linuxram@us.ibm.com>
> 
> /proc/mounts in its current state fail to disambiguate bind mounts, especially
> when the bind mount is subrooted. Also it does not capture propagation state of
> the mounts(shared-subtree). The following patch addresses the problem.
> 
> The patch adds '/proc/<pid>/mountinfo' which contains a superset of
> the fields in '/proc/<pid>/mounts'. The following additional fields
> are added:
> 
> mntid -- is a unique identifier of the mount
> parent -- the id of the parent mount
> major:minor -- value of st_dev for files on that filesystem
> dir -- the subdir in the filesystem which forms the root of this mount
> propagation-type in the form of <propagation_flag>[:<mntid>][,...]
> 	note: 'shared' flag is followed by the mntid of its peer mount
> 	      'slave' flag is followed by the mntid of its master mount
> 	      'private' flag stands by itself
> 	      'unbindable' flag stands by itself
> 
> Also mount options are split into two fileds, the first containing the
> per mount flags, the second the per super block options.
> 
> Here is a sample cat /proc/mounts after execution the following commands:
> 
> mount --bind /mnt /mnt
> mount --make-shared /mnt
> mount --bind /mnt/1 /var
> mount --make-slave /var
> mount --make-shared /var
> mount --bind /var/abc /tmp
> mount --make-unbindable /proc
> 
> 2 2 0:1 rootfs rootfs / / rw rw private
> 16 2 98:0 ext2 /dev/root / / rw rw private
> 17 16 0:3 proc /proc / /proc rw rw unbindable
> 18 16 0:10 devpts devpts /dev/pts / rw rw private
> 19 16 98:0 ext2 /dev/root /mnt /mnt rw rw shared:19
> 20 16 98:0 ext2 /dev/root /mnt/1 /var rw rw shared:21,slave:19
> 21 16 98:0 ext2 /dev/root /mnt/1/abc /tmp rw rw shared:20,slave:19
> 
> For example, the last line indicates that:
> 
> 1) The mount is a shared mount.
> 2) Its peer mount of mount with id 20
> 3) It is also a slave mount of the master-mount with the id  19
> 4) The filesystem on device with major/minor number 98:0 and subdirectory
> 	mnt/1/abc makes the root directory of this mount.
> 5) And finally the mount with id 16 is its parent.
> 
> 
> [mszeredi@suse.cz]:
> 
> - new file, rearrange fields
> - for mount ID's use IDA (from the IDR library) instead of a 32bit
>   counter, which could overflow
> - print canonical ID's (smallest one within the peer group) for peers
>   and master, this is more useful, than a random ID within the same namespace
> - fix a couple of small bugs
> - remove inlines
> - style fixes
> 
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
> 
> Index: linux/fs/dcache.c
> ===================================================================
> --- linux.orig/fs/dcache.c	2008-01-18 19:21:38.000000000 +0100
> +++ linux/fs/dcache.c	2008-01-18 19:22:27.000000000 +0100
> @@ -1890,6 +1890,60 @@ char *dynamic_dname(struct dentry *dentr
>  	return memcpy(buffer, temp, sz);
>  }
> 
> +static int prepend(char **buffer, int *buflen, const char *str,
> +			  int namelen)
> +{
> +	*buflen -= namelen;
> +	if (*buflen < 0)
> +		return 1;
> +	*buffer -= namelen;
> +	memcpy(*buffer, str, namelen);
> +	return 0;
> +}
> +
> +/*
> + * Write full pathname from the root of the filesystem into the buffer.
> + */
> +char *dentry_path(struct dentry *dentry, char *buf, int buflen)
> +{
> +	char *end = buf + buflen;
> +	char *retval;
> +
> +	spin_lock(&dcache_lock);
> +	prepend(&end, &buflen, "\0", 1);
> +	if (!IS_ROOT(dentry) && d_unhashed(dentry)) {
> +		if (prepend(&end, &buflen, "//deleted", 9))
> +			goto Elong;
> +	}
> +	if (buflen < 1)
> +		goto Elong;
> +	/* Get '/' right */
> +	retval = end-1;
> +	*retval = '/';
> +
> +	for (;;) {
> +		struct dentry *parent;
> +		if (IS_ROOT(dentry))
> +			break;
> +
> +		parent = dentry->d_parent;
> +		prefetch(parent);
> +
> +		if (prepend(&end, &buflen, dentry->d_name.name,
> +				dentry->d_name.len) ||
> +		    prepend(&end, &buflen, "/", 1))
> +			goto Elong;
> +
> +		retval = end;
> +		dentry = parent;
> +	}
> +	spin_unlock(&dcache_lock);
> +	return retval;
> +Elong:
> +	spin_unlock(&dcache_lock);
> +	return ERR_PTR(-ENAMETOOLONG);
> +}
> +
>  /*
>   * NOTE! The user-level library version returns a
>   * character pointer. The kernel system call just
> Index: linux/fs/namespace.c
> ===================================================================
> --- linux.orig/fs/namespace.c	2008-01-18 19:21:38.000000000 +0100
> +++ linux/fs/namespace.c	2008-01-18 23:39:35.000000000 +0100
> @@ -27,6 +27,7 @@
>  #include <linux/mount.h>
>  #include <linux/ramfs.h>
>  #include <linux/log2.h>
> +#include <linux/idr.h>
>  #include <asm/uaccess.h>
>  #include <asm/unistd.h>
>  #include "pnode.h"
> @@ -39,6 +40,7 @@
>  __cacheline_aligned_in_smp DEFINE_SPINLOCK(vfsmount_lock);
> 
>  static int event;
> +static DEFINE_IDA(mnt_id_ida);
> 
>  static struct list_head *mount_hashtable __read_mostly;
>  static struct kmem_cache *mnt_cache __read_mostly;
> @@ -58,10 +60,41 @@ static inline unsigned long hash(struct 
> 
>  #define MNT_WRITER_UNDERFLOW_LIMIT -(1<<16)
> 
> +static int mnt_alloc_id(struct vfsmount *mnt)
> +{
> +	int res;
> +
> + retry:
> +	spin_lock(&vfsmount_lock);
> +	res = ida_get_new(&mnt_id_ida, &mnt->mnt_id);
> +	spin_unlock(&vfsmount_lock);
> +	if (res == -EAGAIN) {
> +		if (ida_pre_get(&mnt_id_ida, GFP_KERNEL))
> +			goto retry;
> +		res = -ENOMEM;
> +	}
> +	return res;
> +}
> +
> +static void mnt_free_id(struct vfsmount *mnt)
> +{
> +	spin_lock(&vfsmount_lock);
> +	ida_remove(&mnt_id_ida, mnt->mnt_id);
> +	spin_unlock(&vfsmount_lock);
> +}
> +
>  struct vfsmount *alloc_vfsmnt(const char *name)
>  {
>  	struct vfsmount *mnt = kmem_cache_zalloc(mnt_cache, GFP_KERNEL);
>  	if (mnt) {
> +		int err;
> +
> +		err = mnt_alloc_id(mnt);
> +		if (err) {
> +			kmem_cache_free(mnt_cache, mnt);
> +			return NULL;
> +		}
> +
>  		atomic_set(&mnt->mnt_count, 1);
>  		INIT_LIST_HEAD(&mnt->mnt_hash);
>  		INIT_LIST_HEAD(&mnt->mnt_child);
> @@ -338,6 +371,7 @@ EXPORT_SYMBOL(simple_set_mnt);
>  void free_vfsmnt(struct vfsmount *mnt)
>  {
>  	kfree(mnt->mnt_devname);
> +	mnt_free_id(mnt);
>  	kmem_cache_free(mnt_cache, mnt);
>  }
> 
> @@ -601,28 +635,29 @@ static inline void mangle(struct seq_fil
>  	seq_escape(m, s, " \t\n\\");
>  }
> 
> +static struct proc_fs_info {
> +	int flag;
> +	char *str;
> +} fs_info[] = {
> +	{ MS_SYNCHRONOUS, ",sync" },
> +	{ MS_DIRSYNC, ",dirsync" },
> +	{ MS_MANDLOCK, ",mand" },
> +	{ 0, NULL }
> +};
> +static struct proc_fs_info mnt_info[] = {
> +	{ MNT_NOSUID, ",nosuid" },
> +	{ MNT_NODEV, ",nodev" },
> +	{ MNT_NOEXEC, ",noexec" },
> +	{ MNT_NOATIME, ",noatime" },
> +	{ MNT_NODIRATIME, ",nodiratime" },
> +	{ MNT_RELATIME, ",relatime" },
> +	{ 0, NULL }
> +};
> +
>  static int show_vfsmnt(struct seq_file *m, void *v)
>  {
>  	struct vfsmount *mnt = list_entry(v, struct vfsmount, mnt_list);
>  	int err = 0;
> -	static struct proc_fs_info {
> -		int flag;
> -		char *str;
> -	} fs_info[] = {
> -		{ MS_SYNCHRONOUS, ",sync" },
> -		{ MS_DIRSYNC, ",dirsync" },
> -		{ MS_MANDLOCK, ",mand" },
> -		{ 0, NULL }
> -	};
> -	static struct proc_fs_info mnt_info[] = {
> -		{ MNT_NOSUID, ",nosuid" },
> -		{ MNT_NODEV, ",nodev" },
> -		{ MNT_NOEXEC, ",noexec" },
> -		{ MNT_NOATIME, ",noatime" },
> -		{ MNT_NODIRATIME, ",nodiratime" },
> -		{ MNT_RELATIME, ",relatime" },
> -		{ 0, NULL }
> -	};
>  	struct proc_fs_info *fs_infop;
>  	struct path mnt_path = { .dentry = mnt->mnt_root, .mnt = mnt };
> 
> @@ -657,6 +692,63 @@ struct seq_operations mounts_op = {
>  	.show	= show_vfsmnt
>  };
> 
> +static int show_mountinfo(struct seq_file *m, void *v)
> +{
> +	struct vfsmount *mnt = list_entry(v, struct vfsmount, mnt_list);
> +	struct super_block *sb = mnt->mnt_sb;
> +	struct path mnt_path = { .dentry = mnt->mnt_root, .mnt = mnt };
> +	struct proc_fs_info *fs_infop;
> +	int err = 0;
> +
> +	seq_printf(m, "%i %i %u:%u ", mnt->mnt_id, mnt->mnt_parent->mnt_id,
> +		   MAJOR(sb->s_dev), MINOR(sb->s_dev));
> +	mangle(m, sb->s_type->name);
> +	if (sb->s_subtype && sb->s_subtype[0]) {
> +		seq_putc(m, '.');
> +		mangle(m, sb->s_subtype);
> +	}
> +	seq_putc(m, ' ');
> +	mangle(m, mnt->mnt_devname ? mnt->mnt_devname : "none");
> +	seq_putc(m, ' ');
> +	seq_dentry(m, mnt->mnt_root, " \t\n\\");
> +	seq_putc(m, ' ');
> +	seq_path(m, &mnt_path, " \t\n\\");
> +	seq_putc(m, ' ');
> +	seq_puts(m, mnt->mnt_flags & MNT_READONLY ? "ro" : "rw");
> +	for (fs_infop = mnt_info; fs_infop->flag; fs_infop++) {
> +		if (mnt->mnt_flags & fs_infop->flag)
> +			seq_puts(m, fs_infop->str);
> +	}
> +	seq_putc(m, ' ');
> +	seq_puts(m, sb->s_flags & MS_RDONLY ? "ro" : "rw");
> +	for (fs_infop = fs_info; fs_infop->flag; fs_infop++) {
> +		if (sb->s_flags & fs_infop->flag)
> +			seq_puts(m, fs_infop->str);
> +	}
> +	if (sb->s_op->show_options)
> +		err = sb->s_op->show_options(m, mnt);
> +	if (IS_MNT_SHARED(mnt)) {
> +		seq_printf(m, " shared:%i", get_peer_group_id(mnt));
> +		if (IS_MNT_SLAVE(mnt))
> +			seq_printf(m, ",slave:%i", get_master_id(mnt));
> +	} else if (IS_MNT_SLAVE(mnt)) {
> +		seq_printf(m, " slave:%i", get_master_id(mnt));
> +	} else if (IS_MNT_UNBINDABLE(mnt)) {
> +		seq_printf(m, " unbindable");
> +	} else {
> +		seq_printf(m, " private");
> +	}
> +	seq_putc(m, '\n');
> +	return err;
> +}
> +
> +struct seq_operations mountinfo_op = {
> +	.start	= m_start,
> +	.next	= m_next,
> +	.stop	= m_stop,
> +	.show	= show_mountinfo,
> +};
> +
>  static int show_vfsstat(struct seq_file *m, void *v)
>  {
>  	struct vfsmount *mnt = list_entry(v, struct vfsmount, mnt_list);
> Index: linux/fs/seq_file.c
> ===================================================================
> --- linux.orig/fs/seq_file.c	2008-01-18 19:21:38.000000000 +0100
> +++ linux/fs/seq_file.c	2008-01-18 19:22:27.000000000 +0100
> @@ -349,28 +349,40 @@ int seq_printf(struct seq_file *m, const
>  }
>  EXPORT_SYMBOL(seq_printf);
> 
> +static char *mangle_path(char *s, char *p, char *esc)
> +{
> +	while (s <= p) {
> +		char c = *p++;
> +		if (!c) {
> +			return s;
> +		} else if (!strchr(esc, c)) {
> +			*s++ = c;
> +		} else if (s + 4 > p) {
> +			break;
> +		} else {
> +			*s++ = '\\';
> +			*s++ = '0' + ((c & 0300) >> 6);
> +			*s++ = '0' + ((c & 070) >> 3);
> +			*s++ = '0' + (c & 07);
> +		}
> +	}
> +	return NULL;
> +}
> +
> +/*
> + * return the absolute path of 'dentry' residing in mount 'mnt'.
> + */
>  int seq_path(struct seq_file *m, struct path *path, char *esc)
>  {
>  	if (m->count < m->size) {
>  		char *s = m->buf + m->count;
>  		char *p = d_path(path, s, m->size - m->count);
>  		if (!IS_ERR(p)) {
> -			while (s <= p) {
> -				char c = *p++;
> -				if (!c) {
> -					p = m->buf + m->count;
> -					m->count = s - m->buf;
> -					return s - p;
> -				} else if (!strchr(esc, c)) {
> -					*s++ = c;
> -				} else if (s + 4 > p) {
> -					break;
> -				} else {
> -					*s++ = '\\';
> -					*s++ = '0' + ((c & 0300) >> 6);
> -					*s++ = '0' + ((c & 070) >> 3);
> -					*s++ = '0' + (c & 07);
> -				}
> +			s = mangle_path(s, p, esc);
> +			if (s) {
> +				p = m->buf + m->count;
> +				m->count = s - m->buf;
> +				return s - p;
>  			}
>  		}
>  	}
> @@ -379,6 +391,28 @@ int seq_path(struct seq_file *m, struct 
>  }
>  EXPORT_SYMBOL(seq_path);
> 
> +/*
> + * returns the path of the 'dentry' from the root of its filesystem.
> + */
> +int seq_dentry(struct seq_file *m, struct dentry *dentry, char *esc)
> +{
> +	if (m->count < m->size) {
> +		char *s = m->buf + m->count;
> +		char *p = dentry_path(dentry, s, m->size - m->count);
> +		if (!IS_ERR(p)) {
> +			s = mangle_path(s, p, esc);
> +			if (s) {
> +				p = m->buf + m->count;
> +				m->count = s - m->buf;
> +				return s - p;
> +			}
> +		}
> +	}
> +	m->count = m->size;
> +	return -1;
> +}
> +EXPORT_SYMBOL(seq_dentry);
> +
>  static void *single_start(struct seq_file *p, loff_t *pos)
>  {
>  	return NULL + (*pos == 0);
> Index: linux/include/linux/dcache.h
> ===================================================================
> --- linux.orig/include/linux/dcache.h	2008-01-18 19:21:38.000000000 +0100
> +++ linux/include/linux/dcache.h	2008-01-18 19:22:27.000000000 +0100
> @@ -302,6 +302,7 @@ extern int d_validate(struct dentry *, s
>  extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
> 
>  extern char *d_path(struct path *, char *, int);
> +extern char *dentry_path(struct dentry *, char *, int);
> 
>  /* Allocation counts.. */
> 
> Index: linux/include/linux/seq_file.h
> ===================================================================
> --- linux.orig/include/linux/seq_file.h	2008-01-18 19:21:38.000000000 +0100
> +++ linux/include/linux/seq_file.h	2008-01-18 19:22:27.000000000 +0100
> @@ -10,6 +10,7 @@ struct seq_operations;
>  struct file;
>  struct path;
>  struct inode;
> +struct dentry;
> 
>  struct seq_file {
>  	char *buf;
> @@ -43,6 +44,7 @@ int seq_printf(struct seq_file *, const 
>  	__attribute__ ((format (printf,2,3)));
> 
>  int seq_path(struct seq_file *, struct path *, char *);
> +int seq_dentry(struct seq_file *, struct dentry *, char *);
> 
>  int single_open(struct file *, int (*)(struct seq_file *, void *), void *);
>  int single_release(struct inode *, struct file *);
> Index: linux/fs/pnode.c
> ===================================================================
> --- linux.orig/fs/pnode.c	2008-01-18 19:21:38.000000000 +0100
> +++ linux/fs/pnode.c	2008-01-18 19:22:27.000000000 +0100
> @@ -27,6 +27,41 @@ static inline struct vfsmount *next_slav
>  	return list_entry(p->mnt_slave.next, struct vfsmount, mnt_slave);
>  }
> 
> +static int __peer_group_id(struct vfsmount *mnt)
> +{
> +	struct vfsmount *m;
> +	int id = mnt->mnt_id;
> +
> +	for (m = next_peer(mnt); m != mnt; m = next_peer(m))
> +		id = min(id, m->mnt_id);
> +
> +	return id;
> +}
> +
> +/* return the smallest ID within the peer group */
> +int get_peer_group_id(struct vfsmount *mnt)
> +{
> +	int id;
> +
> +	spin_lock(&vfsmount_lock);
> +	id = __peer_group_id(mnt);
> +	spin_unlock(&vfsmount_lock);
> +
> +	return id;
> +}
> +
> +/* return the smallest ID within the master's peer group */
> +int get_master_id(struct vfsmount *mnt)
> +{
> +	int id;
> +
> +	spin_lock(&vfsmount_lock);
> +	id = __peer_group_id(mnt->mnt_master);
> +	spin_unlock(&vfsmount_lock);
> +
> +	return id;
> +}
> +
>  static int do_make_slave(struct vfsmount *mnt)
>  {
>  	struct vfsmount *peer_mnt = mnt, *master = mnt->mnt_master;
> Index: linux/fs/pnode.h
> ===================================================================
> --- linux.orig/fs/pnode.h	2008-01-18 19:21:38.000000000 +0100
> +++ linux/fs/pnode.h	2008-01-18 23:39:35.000000000 +0100
> @@ -35,4 +35,6 @@ int propagate_mnt(struct vfsmount *, str
>  		struct list_head *);
>  int propagate_umount(struct list_head *);
>  int propagate_mount_busy(struct vfsmount *, int);
> +int get_peer_group_id(struct vfsmount *);
> +int get_master_id(struct vfsmount *);
>  #endif /* _LINUX_PNODE_H */
> Index: linux/include/linux/mount.h
> ===================================================================
> --- linux.orig/include/linux/mount.h	2008-01-18 19:21:38.000000000 +0100
> +++ linux/include/linux/mount.h	2008-01-18 23:39:35.000000000 +0100
> @@ -56,6 +56,7 @@ struct vfsmount {
>  	struct list_head mnt_slave;	/* slave list entry */
>  	struct vfsmount *mnt_master;	/* slave is on master->mnt_slave_list */
>  	struct mnt_namespace *mnt_ns;	/* containing namespace */
> +	int mnt_id;			/* mount identifier */
>  	/*
>  	 * We put mnt_count & mnt_expiry_mark at the end of struct vfsmount
>  	 * to let these frequently modified fields in a separate cache line
> Index: linux/fs/proc/base.c
> ===================================================================
> --- linux.orig/fs/proc/base.c	2008-01-18 19:21:38.000000000 +0100
> +++ linux/fs/proc/base.c	2008-01-18 19:22:27.000000000 +0100
> @@ -435,13 +435,13 @@ static const struct inode_operations pro
>  	.setattr	= proc_setattr,
>  };
> 
> -extern struct seq_operations mounts_op;
>  struct proc_mounts {
>  	struct seq_file m;
>  	int event;
>  };
> 
> -static int mounts_open(struct inode *inode, struct file *file)
> +static int mounts_open_common(struct inode *inode, struct file *file,
> +			      struct seq_operations *op)
>  {
>  	struct task_struct *task = get_proc_task(inode);
>  	struct nsproxy *nsp;
> @@ -467,7 +467,7 @@ static int mounts_open(struct inode *ino
>  		p = kmalloc(sizeof(struct proc_mounts), GFP_KERNEL);
>  		if (p) {
>  			file->private_data = &p->m;
> -			ret = seq_open(file, &mounts_op);
> +			ret = seq_open(file, op);
>  			if (!ret) {
>  				p->m.private = ns;
>  				p->event = ns->event;
> @@ -506,6 +506,11 @@ static unsigned mounts_poll(struct file 
>  	return res;
>  }
> 
> +static int mounts_open(struct inode *inode, struct file *file)
> +{
> +	return mounts_open_common(inode, file, &mounts_op);
> +}
> +
>  static const struct file_operations proc_mounts_operations = {
>  	.open		= mounts_open,
>  	.read		= seq_read,
> @@ -514,38 +519,22 @@ static const struct file_operations proc
>  	.poll		= mounts_poll,
>  };
> 
> -extern struct seq_operations mountstats_op;
> -static int mountstats_open(struct inode *inode, struct file *file)
> +static int mountinfo_open(struct inode *inode, struct file *file)
>  {
> -	int ret = seq_open(file, &mountstats_op);
> -
> -	if (!ret) {
> -		struct seq_file *m = file->private_data;
> -		struct nsproxy *nsp;
> -		struct mnt_namespace *mnt_ns = NULL;
> -		struct task_struct *task = get_proc_task(inode);
> -
> -		if (task) {
> -			rcu_read_lock();
> -			nsp = task_nsproxy(task);
> -			if (nsp) {
> -				mnt_ns = nsp->mnt_ns;
> -				if (mnt_ns)
> -					get_mnt_ns(mnt_ns);
> -			}
> -			rcu_read_unlock();
> +	return mounts_open_common(inode, file, &mountinfo_op);
> +}
> 
> -			put_task_struct(task);
> -		}
> +static const struct file_operations proc_mountinfo_operations = {
> +	.open		= mountinfo_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= mounts_release,
> +	.poll		= mounts_poll,
> +};
> 
> -		if (mnt_ns)
> -			m->private = mnt_ns;
> -		else {
> -			seq_release(inode, file);
> -			ret = -EINVAL;
> -		}
> -	}
> -	return ret;
> +static int mountstats_open(struct inode *inode, struct file *file)
> +{
> +	return mounts_open_common(inode, file, &mountstats_op);
>  }
> 
>  static const struct file_operations proc_mountstats_operations = {
> @@ -2220,6 +2209,7 @@ static const struct pid_entry tgid_base_
>  	LNK("root",       root),
>  	LNK("exe",        exe),
>  	REG("mounts",     S_IRUGO, mounts),
> +	REG("mountinfo",  S_IRUGO, mountinfo),
>  	REG("mountstats", S_IRUSR, mountstats),
>  #ifdef CONFIG_PROC_PAGE_MONITOR
>  	REG("clear_refs", S_IWUSR, clear_refs),
> @@ -2548,6 +2538,7 @@ static const struct pid_entry tid_base_s
>  	LNK("root",      root),
>  	LNK("exe",       exe),
>  	REG("mounts",    S_IRUGO, mounts),
> +	REG("mountinfo",  S_IRUGO, mountinfo),
>  #ifdef CONFIG_PROC_PAGE_MONITOR
>  	REG("clear_refs", S_IWUSR, clear_refs),
>  	REG("smaps",     S_IRUGO, smaps),
> Index: linux/include/linux/mnt_namespace.h
> ===================================================================
> --- linux.orig/include/linux/mnt_namespace.h	2008-01-18 19:21:38.000000000 +0100
> +++ linux/include/linux/mnt_namespace.h	2008-01-18 19:22:27.000000000 +0100
> @@ -37,5 +37,9 @@ static inline void get_mnt_ns(struct mnt
>  	atomic_inc(&ns->count);
>  }
> 
> +extern struct seq_operations mounts_op;
> +extern struct seq_operations mountinfo_op;
> +extern struct seq_operations mountstats_op;
> +
>  #endif
>  #endif
> Index: linux/fs/proc/proc_misc.c
> ===================================================================
> --- linux.orig/fs/proc/proc_misc.c	2008-01-18 19:21:38.000000000 +0100
> +++ linux/fs/proc/proc_misc.c	2008-01-19 11:56:33.000000000 +0100
> @@ -980,6 +980,7 @@ void __init proc_misc_init(void)
>  		create_proc_read_entry(p->name, 0, NULL, p->read_proc, NULL);
> 
>  	proc_symlink("mounts", NULL, "self/mounts");
> +	proc_symlink("mountinfo", NULL, "self/mountinfo");
> 
>  	/* And now for trickier ones */
>  #ifdef CONFIG_PRINTK

