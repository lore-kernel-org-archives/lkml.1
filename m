Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbYATLU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbYATLU0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 06:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbYATLUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 06:20:07 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:43292 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbYATLUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 06:20:04 -0500
Date: Sun, 20 Jan 2008 12:20:02 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, util-linux-ng@vger.kernel.org,
       linuxram@us.ibm.com, viro@ftp.linux.org.uk, hch@infradead.org,
       a.p.zijlstra@chello.nl
Subject: Re: [RFC][PATCH] VFS: create /proc/<pid>/mountinfo
In-Reply-To: <E1JGBVq-0002Or-H1@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.64.0801201207360.14598@fbirervta.pbzchgretzou.qr>
References: <E1JGBVq-0002Or-H1@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Jan 19 2008 12:05, Miklos Szeredi wrote:
>+
>+/*
>+ * Write full pathname from the root of the filesystem into the buffer.
>+ */
>+char *dentry_path(struct dentry *dentry, char *buf, int buflen)

Hm, this functions looks very much like __d_path(). Is it
an unintentional copy?

>+{
>+	char *end = buf + buflen;
>+	char *retval;
>+
>+	spin_lock(&dcache_lock);
>+	prepend(&end, &buflen, "\0", 1);
>+	if (!IS_ROOT(dentry) && d_unhashed(dentry)) {
>+		if (prepend(&end, &buflen, "//deleted", 9))
>+			goto Elong;
>+	}
>+	if (buflen < 1)
>+		goto Elong;
>+	/* Get '/' right */
>+	retval = end-1;
>+	*retval = '/';
>+
>+	for (;;) {
>+		struct dentry *parent;
>+		if (IS_ROOT(dentry))
>+			break;
>+
>+		parent = dentry->d_parent;
>+		prefetch(parent);
>+
>+		if (prepend(&end, &buflen, dentry->d_name.name,
>+				dentry->d_name.len) ||
>+		    prepend(&end, &buflen, "/", 1))
>+			goto Elong;
>+
>+		retval = end;
>+		dentry = parent;
>+	}
>+	spin_unlock(&dcache_lock);
>+	return retval;
>+Elong:
>+	spin_unlock(&dcache_lock);
>+	return ERR_PTR(-ENAMETOOLONG);
>+}
>+
> /*
>  * NOTE! The user-level library version returns a
>  * character pointer. The kernel system call just
>===================================================================
>--- linux.orig/fs/namespace.c	2008-01-18 19:21:38.000000000 +0100
>+++ linux/fs/namespace.c	2008-01-18 23:39:35.000000000 +0100
>@@ -27,6 +27,7 @@
> #include <linux/mount.h>
> #include <linux/ramfs.h>
> #include <linux/log2.h>
>+#include <linux/idr.h>
> #include <asm/uaccess.h>
> #include <asm/unistd.h>
> #include "pnode.h"

(IDR numbers are IMO fine.)

>@@ -601,28 +635,29 @@ static inline void mangle(struct seq_fil
> 	seq_escape(m, s, " \t\n\\");
> }
> 
>+static struct proc_fs_info {

These do not seem to be static data. Please mark them as const.

static const struct proc_fs_info.

>+	int flag;
>+	char *str;

const char *str.

>+} fs_info[] = {
>+	{ MS_SYNCHRONOUS, ",sync" },
>+	{ MS_DIRSYNC, ",dirsync" },
>+	{ MS_MANDLOCK, ",mand" },
>+	{ 0, NULL }
>+};
>+static struct proc_fs_info mnt_info[] = {
      const
>+	{ MNT_NOSUID, ",nosuid" },
>+	{ MNT_NODEV, ",nodev" },
>+	{ MNT_NOEXEC, ",noexec" },
>+	{ MNT_NOATIME, ",noatime" },
>+	{ MNT_NODIRATIME, ",nodiratime" },
>+	{ MNT_RELATIME, ",relatime" },
>+	{ 0, NULL }
>+};
>+
> static int show_vfsmnt(struct seq_file *m, void *v)
> {
> 	struct vfsmount *mnt = list_entry(v, struct vfsmount, mnt_list);
> 	int err = 0;
>-	static struct proc_fs_info {
>-		int flag;
>-		char *str;
>-	} fs_info[] = {
>-		{ MS_SYNCHRONOUS, ",sync" },
>-		{ MS_DIRSYNC, ",dirsync" },
>-		{ MS_MANDLOCK, ",mand" },
>-		{ 0, NULL }
>-	};
>-	static struct proc_fs_info mnt_info[] = {
>-		{ MNT_NOSUID, ",nosuid" },
>-		{ MNT_NODEV, ",nodev" },
>-		{ MNT_NOEXEC, ",noexec" },
>-		{ MNT_NOATIME, ",noatime" },
>-		{ MNT_NODIRATIME, ",nodiratime" },
>-		{ MNT_RELATIME, ",relatime" },
>-		{ 0, NULL }
>-	};
> 	struct proc_fs_info *fs_infop;
>@@ -657,6 +692,63 @@ struct seq_operations mounts_op = {
> 	.show	= show_vfsmnt
> };
> 
>+static int show_mountinfo(struct seq_file *m, void *v)
>+{
>+	struct vfsmount *mnt = list_entry(v, struct vfsmount, mnt_list);
>+	struct super_block *sb = mnt->mnt_sb;
>+	struct path mnt_path = { .dentry = mnt->mnt_root, .mnt = mnt };
>+	struct proc_fs_info *fs_infop;
>+	int err = 0;
>+
>+	seq_printf(m, "%i %i %u:%u ", mnt->mnt_id, mnt->mnt_parent->mnt_id,
>+		   MAJOR(sb->s_dev), MINOR(sb->s_dev));
>+	mangle(m, sb->s_type->name);
>+	if (sb->s_subtype && sb->s_subtype[0]) {
>+		seq_putc(m, '.');
>+		mangle(m, sb->s_subtype);
>+	}
>+	seq_putc(m, ' ');
>+	mangle(m, mnt->mnt_devname ? mnt->mnt_devname : "none");
>+	seq_putc(m, ' ');
>+	seq_dentry(m, mnt->mnt_root, " \t\n\\");
>+	seq_putc(m, ' ');
>+	seq_path(m, &mnt_path, " \t\n\\");
>+	seq_putc(m, ' ');
>+	seq_puts(m, mnt->mnt_flags & MNT_READONLY ? "ro" : "rw");
>+	for (fs_infop = mnt_info; fs_infop->flag; fs_infop++) {
>+		if (mnt->mnt_flags & fs_infop->flag)
>+			seq_puts(m, fs_infop->str);
>+	}

>+	seq_putc(m, ' ');
>+	seq_puts(m, sb->s_flags & MS_RDONLY ? "ro" : "rw");
>+	for (fs_infop = fs_info; fs_infop->flag; fs_infop++) {
>+		if (sb->s_flags & fs_infop->flag)
>+			seq_puts(m, fs_infop->str);
>+	}

{} could go.

>+	if (sb->s_op->show_options)
>+		err = sb->s_op->show_options(m, mnt);
>+	if (IS_MNT_SHARED(mnt)) {
>+		seq_printf(m, " shared:%i", get_peer_group_id(mnt));
>+		if (IS_MNT_SLAVE(mnt))
>+			seq_printf(m, ",slave:%i", get_master_id(mnt));
>+	} else if (IS_MNT_SLAVE(mnt)) {
>+		seq_printf(m, " slave:%i", get_master_id(mnt));
>+	} else if (IS_MNT_UNBINDABLE(mnt)) {
>+		seq_printf(m, " unbindable");
>+	} else {
>+		seq_printf(m, " private");
>+	}
>+	seq_putc(m, '\n');
>+	return err;
>+}
>+
>+struct seq_operations mountinfo_op = {
I think this can go const.

>+	.start	= m_start,
>+	.next	= m_next,
>+	.stop	= m_stop,
>+	.show	= show_mountinfo,
>+};
>+
> static int show_vfsstat(struct seq_file *m, void *v)
> {
> 	struct vfsmount *mnt = list_entry(v, struct vfsmount, mnt_list);
>Index: linux/fs/seq_file.c
>===================================================================
>--- linux.orig/fs/seq_file.c	2008-01-18 19:21:38.000000000 +0100
>+++ linux/fs/seq_file.c	2008-01-18 19:22:27.000000000 +0100
>@@ -349,28 +349,40 @@ int seq_printf(struct seq_file *m, const
> }
> EXPORT_SYMBOL(seq_printf);
> 
>+static char *mangle_path(char *s, char *p, char *esc)
                                    const char *p, const char *esc
>+{
>+	while (s <= p) {
>+		char c = *p++;
>+		if (!c) {
>+			return s;
>+		} else if (!strchr(esc, c)) {
>+			*s++ = c;
>+		} else if (s + 4 > p) {
>+			break;
>+		} else {
>+			*s++ = '\\';
>+			*s++ = '0' + ((c & 0300) >> 6);
>+			*s++ = '0' + ((c & 070) >> 3);
>+			*s++ = '0' + (c & 07);
>+		}
>+	}
>+	return NULL;
>+}
>+
>+/*
>+ * return the absolute path of 'dentry' residing in mount 'mnt'.
>+ */
> int seq_path(struct seq_file *m, struct path *path, char *esc)
> {
> 	if (m->count < m->size) {
>@@ -379,6 +391,28 @@ int seq_path(struct seq_file *m, struct 
> }
> EXPORT_SYMBOL(seq_path);
> 
>+/*
>+ * returns the path of the 'dentry' from the root of its filesystem.
>+ */
>+int seq_dentry(struct seq_file *m, struct dentry *dentry, char *esc)
                                                           const char *esc
>+{
>+	if (m->count < m->size) {
>+		char *s = m->buf + m->count;
>+		char *p = dentry_path(dentry, s, m->size - m->count);
>+		if (!IS_ERR(p)) {
>+			s = mangle_path(s, p, esc);
>+			if (s) {
>+				p = m->buf + m->count;
>+				m->count = s - m->buf;
>+				return s - p;
>+			}
>+		}
>+	}
>+	m->count = m->size;
>+	return -1;
>+}
>+EXPORT_SYMBOL(seq_dentry);
>+
> static void *single_start(struct seq_file *p, loff_t *pos)
> {
> 	return NULL + (*pos == 0);
>===================================================================
>--- linux.orig/include/linux/mount.h	2008-01-18 19:21:38.000000000 +0100
>+++ linux/include/linux/mount.h	2008-01-18 23:39:35.000000000 +0100
>@@ -56,6 +56,7 @@ struct vfsmount {
> 	struct list_head mnt_slave;	/* slave list entry */
> 	struct vfsmount *mnt_master;	/* slave is on master->mnt_slave_list */
> 	struct mnt_namespace *mnt_ns;	/* containing namespace */
>+	int mnt_id;			/* mount identifier */
> 	/*
> 	 * We put mnt_count & mnt_expiry_mark at the end of struct vfsmount
> 	 * to let these frequently modified fields in a separate cache line

Should/could it be unsigned int, or does it need to store -1?

