Return-Path: <linux-kernel-owner+w=401wt.eu-S1030185AbXDSXyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030185AbXDSXyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 19:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbXDSXyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 19:54:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36616 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333AbXDSXyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 19:54:51 -0400
Message-Id: <20070419234704.448790135@schurl.suse.de>
User-Agent: quilt/0.46-1
Date: Fri, 20 Apr 2007 01:23:09 +0200
From: Andreas Gruenbacher <agruen@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Andrew Morton <akpm@linux-foundation.org>
References: <20070412090809.917795000@suse.de> <200704170335.21805.agruen@suse.de> <20070417182126.2327d89d@the-village.bc.nu> <20070419232303.300441585@schurl.suse.de>
In-Reply-To: <20070417182126.2327d89d@the-village.bc.nu>
Subject: [d_path 6/7] Filter out disconnected paths from /proc/mounts
Content-Disposition: inline; filename=proc-mounts-check-d_path-result.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use d_path() instead of seq_path when generating /proc/mounts and
/proc/$id/mountstats, reuse the same buffer for all mounts, and filter out
disconnected paths.

This path has no net effect in itself because d_path() so far doesn't
distinguish sconnected and disconnected paths yet. The next patch fixes that
though; without this patch, the next patch would break /proc/mounts and
/proc/$id/mountstats.

There is some disagreement what /proc/mounts should include. Currently it
reports all mounts from the current namespace and doesn't include lazy
unmounts. This leads to ambiguities with the rootfs (which is an internal mount
irrelevant to user-space except in the initrd), and in chroots.

With this and the next patch, /proc/mounts only reports the mounts reachable
for the current process, which makes a lot more sense IMO.  If the current
process is rooted in the namespace root (which it usually is), it will see all
mounts except for the rootfs.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

---
 fs/namespace.c |   23 +++++++++++++++++++++--
 fs/proc/base.c |   10 +++++++++-
 2 files changed, 30 insertions(+), 3 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -348,8 +348,16 @@ static inline void mangle(struct seq_fil
 	seq_escape(m, s, " \t\n\\");
 }
 
+/* Keep in sync with fs/proc/base.c! */
+struct proc_mounts {
+	struct seq_file m;
+	void *page;
+	int event;
+};
+
 static int show_vfsmnt(struct seq_file *m, void *v)
 {
+	void *page = container_of(m, struct proc_mounts, m)->page;
 	struct vfsmount *mnt = v;
 	int err = 0;
 	static struct proc_fs_info {
@@ -371,10 +379,15 @@ static int show_vfsmnt(struct seq_file *
 		{ 0, NULL }
 	};
 	struct proc_fs_info *fs_infop;
+	char *path;
+
+	path = d_path(mnt->mnt_root, mnt, page, PAGE_SIZE);
+	if (IS_ERR(path) || *path != '/')
+		return err;
 
 	mangle(m, mnt->mnt_devname ? mnt->mnt_devname : "none");
 	seq_putc(m, ' ');
-	seq_path(m, mnt, mnt->mnt_root, " \t\n\\");
+	mangle(m, path);
 	seq_putc(m, ' ');
 	mangle(m, mnt->mnt_sb->s_type->name);
 	seq_puts(m, mnt->mnt_sb->s_flags & MS_RDONLY ? " ro" : " rw");
@@ -401,8 +414,14 @@ struct seq_operations mounts_op = {
 
 static int show_vfsstat(struct seq_file *m, void *v)
 {
+	void *page = container_of(m, struct proc_mounts, m)->page;
 	struct vfsmount *mnt = v;
 	int err = 0;
+	char *path;
+
+	path = d_path(mnt->mnt_root, mnt, page, PAGE_SIZE);
+	if (IS_ERR(path) || *path != '/')
+		return err; /* error or path unreachable from chroot */
 
 	/* device */
 	if (mnt->mnt_devname) {
@@ -413,7 +432,7 @@ static int show_vfsstat(struct seq_file 
 
 	/* mount point */
 	seq_puts(m, " mounted on ");
-	seq_path(m, mnt, mnt->mnt_root, " \t\n\\");
+	mangle(m, path);
 	seq_putc(m, ' ');
 
 	/* file system type */
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -354,8 +354,11 @@ static const struct inode_operations pro
 };
 
 extern struct seq_operations mounts_op;
+
+/* Keep in sync with fs/namespace.c! */
 struct proc_mounts {
 	struct seq_file m;
+	void *page;
 	int event;
 };
 
@@ -383,12 +386,16 @@ static int __mounts_open(struct inode *i
 		p = kmalloc(sizeof(struct proc_mounts), GFP_KERNEL);
 		if (p) {
 			file->private_data = &p->m;
-			ret = seq_open(file, seq_ops);
+			p->page = (void *)__get_free_page(GFP_KERNEL);
+			if (p->page)
+				ret = seq_open(file, seq_ops);
 			if (!ret) {
 				p->m.private = ns;
 				p->event = ns->event;
 				return 0;
 			}
+			if (p->page)
+				free_page((unsigned long)p->page);
 			kfree(p);
 		}
 		put_mnt_ns(ns);
@@ -407,6 +414,7 @@ static int mounts_release(struct inode *
 		container_of(file->private_data, struct proc_mounts, m);
 	struct mnt_namespace *ns = p->m.private;
 
+	free_page((unsigned long)p->page);
 	put_mnt_ns(ns);
 	return seq_release(inode, file);
 }

-- 
Andreas Gruenbacher <agruen@suse.de>
SUSE Labs, SUSE LINUX Products GmbH
GF: Markus Rex, HRB 16746 (AG Nuernberg)

GPG: AF77 FAD1 1819 D442 400F  4BC8 409A 6903 4FDD EE02

