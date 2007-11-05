Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbXKEQfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbXKEQfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 11:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755839AbXKEQem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 11:34:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:39354 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756559AbXKEQej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 11:34:39 -0500
Message-Id: <20071105163234.466356640@hasse.suse.de>
User-Agent: quilt/0.46-1
Date: Mon, 05 Nov 2007 17:32:40 +0100
From: Jan Blunck <jblunck@suse.de>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 8/9] d_path: Make seq_path() use a struct path argument
References: <20071105163232.550298985@hasse.suse.de>
Content-Disposition: inline; filename=vfs/d_path-Make_seq_path_use_a_struct_path_argument.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

seq_path() is always called with a dentry and a vfsmount from a struct
path. Make seq_path() take it directly as an argument.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 drivers/md/md.c          |    3 +--
 fs/namespace.c           |    6 ++++--
 fs/nfsd/export.c         |    4 ++--
 fs/proc/nommu.c          |    2 +-
 fs/proc/task_mmu.c       |    2 +-
 fs/seq_file.c            |    7 +++----
 include/linux/seq_file.h |    5 ++---
 mm/mempolicy.c           |    2 +-
 mm/swapfile.c            |    2 +-
 9 files changed, 16 insertions(+), 17 deletions(-)

Index: b/drivers/md/md.c
===================================================================
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5011,8 +5011,7 @@ static int md_seq_show(struct seq_file *
 				chunk_kb ? "KB" : "B");
 			if (bitmap->file) {
 				seq_printf(seq, ", file: ");
-				seq_path(seq, bitmap->file->f_path.mnt,
-					 bitmap->file->f_path.dentry," \t\n");
+				seq_path(seq, &bitmap->file->f_path, " \t\n");
 			}
 
 			seq_printf(seq, "\n");
Index: b/fs/namespace.c
===================================================================
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -684,10 +684,11 @@ static int show_vfsmnt(struct seq_file *
 		{ 0, NULL }
 	};
 	struct proc_fs_info *fs_infop;
+	struct path mnt_path = { .dentry = mnt->mnt_root, .mnt = mnt };
 
 	mangle(m, mnt->mnt_devname ? mnt->mnt_devname : "none");
 	seq_putc(m, ' ');
-	seq_path(m, mnt, mnt->mnt_root, " \t\n\\");
+	seq_path(m, &mnt_path, " \t\n\\");
 	seq_putc(m, ' ');
 	mangle(m, mnt->mnt_sb->s_type->name);
 	if (mnt->mnt_sb->s_subtype && mnt->mnt_sb->s_subtype[0]) {
@@ -721,6 +722,7 @@ struct seq_operations mounts_op = {
 static int show_vfsstat(struct seq_file *m, void *v)
 {
 	struct vfsmount *mnt = list_entry(v, struct vfsmount, mnt_list);
+	struct path mnt_path = { .dentry = mnt->mnt_root, .mnt = mnt };
 	int err = 0;
 
 	/* device */
@@ -732,7 +734,7 @@ static int show_vfsstat(struct seq_file 
 
 	/* mount point */
 	seq_puts(m, " mounted on ");
-	seq_path(m, mnt, mnt->mnt_root, " \t\n\\");
+	seq_path(m, &mnt_path, " \t\n\\");
 	seq_putc(m, ' ');
 
 	/* file system type */
Index: b/fs/nfsd/export.c
===================================================================
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -203,7 +203,7 @@ static int expkey_show(struct seq_file *
 	if (test_bit(CACHE_VALID, &h->flags) && 
 	    !test_bit(CACHE_NEGATIVE, &h->flags)) {
 		seq_printf(m, " ");
-		seq_path(m, ek->ek_path.mnt, ek->ek_path.dentry, "\\ \t\n");
+		seq_path(m, &ek->ek_path, "\\ \t\n");
 	}
 	seq_printf(m, "\n");
 	return 0;
@@ -649,7 +649,7 @@ static int svc_export_show(struct seq_fi
 		return 0;
 	}
 	exp = container_of(h, struct svc_export, h);
-	seq_path(m, exp->ex_path.mnt, exp->ex_path.dentry, " \t\n\\");
+	seq_path(m, &exp->ex_path, " \t\n\\");
 	seq_putc(m, '\t');
 	seq_escape(m, exp->ex_client->name, " \t\n\\");
 	seq_putc(m, '(');
Index: b/fs/proc/nommu.c
===================================================================
--- a/fs/proc/nommu.c
+++ b/fs/proc/nommu.c
@@ -67,7 +67,7 @@ int nommu_vma_show(struct seq_file *m, s
 		if (len < 1)
 			len = 1;
 		seq_printf(m, "%*c", len, ' ');
-		seq_path(m, file->f_path.mnt, file->f_path.dentry, "");
+		seq_path(m, &file->f_path, "");
 	}
 
 	seq_putc(m, '\n');
Index: b/fs/proc/task_mmu.c
===================================================================
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -268,7 +268,7 @@ static int show_map(struct seq_file *m, 
 	 */
 	if (file) {
 		pad_len_spaces(m, len);
-		seq_path(m, file->f_path.mnt, file->f_path.dentry, "\n");
+		seq_path(m, &file->f_path, "\n");
 	} else {
 		const char *name = arch_vma_name(vma);
 		if (!name) {
Index: b/fs/seq_file.c
===================================================================
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -349,13 +349,12 @@ int seq_printf(struct seq_file *m, const
 }
 EXPORT_SYMBOL(seq_printf);
 
-int seq_path(struct seq_file *m,
-	     struct vfsmount *mnt, struct dentry *dentry,
-	     char *esc)
+int seq_path(struct seq_file *m, struct path *path, char *esc)
 {
 	if (m->count < m->size) {
 		char *s = m->buf + m->count;
-		char *p = d_path(dentry, mnt, s, m->size - m->count);
+		char *p = d_path(path->dentry, path->mnt, s,
+				 m->size - m->count);
 		if (!IS_ERR(p)) {
 			while (s <= p) {
 				char c = *p++;
Index: b/include/linux/seq_file.h
===================================================================
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -8,8 +8,7 @@
 
 struct seq_operations;
 struct file;
-struct vfsmount;
-struct dentry;
+struct path;
 struct inode;
 
 struct seq_file {
@@ -43,7 +42,7 @@ int seq_puts(struct seq_file *m, const c
 int seq_printf(struct seq_file *, const char *, ...)
 	__attribute__ ((format (printf,2,3)));
 
-int seq_path(struct seq_file *, struct vfsmount *, struct dentry *, char *);
+int seq_path(struct seq_file *, struct path *, char *);
 
 int single_open(struct file *, int (*)(struct seq_file *, void *), void *);
 int single_release(struct inode *, struct file *);
Index: b/mm/mempolicy.c
===================================================================
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1968,7 +1968,7 @@ int show_numa_map(struct seq_file *m, vo
 
 	if (file) {
 		seq_printf(m, " file=");
-		seq_path(m, file->f_path.mnt, file->f_path.dentry, "\n\t= ");
+		seq_path(m, &file->f_path, "\n\t= ");
 	} else if (vma->vm_start <= mm->brk && vma->vm_end >= mm->start_brk) {
 		seq_printf(m, " heap");
 	} else if (vma->vm_start <= mm->start_stack &&
Index: b/mm/swapfile.c
===================================================================
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1370,7 +1370,7 @@ static int swap_show(struct seq_file *sw
 	}
 
 	file = ptr->swap_file;
-	len = seq_path(swap, file->f_path.mnt, file->f_path.dentry, " \t\n\\");
+	len = seq_path(swap, &file->f_path, " \t\n\\");
 	seq_printf(swap, "%*s%s\t%u\t%u\t%d\n",
 		       len < 40 ? 40 - len : 1, " ",
 		       S_ISBLK(file->f_path.dentry->d_inode->i_mode) ?


