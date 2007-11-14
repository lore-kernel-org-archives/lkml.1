Return-Path: <linux-kernel-owner+w=401wt.eu-S1763972AbXKNURM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763972AbXKNURM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 15:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbXKNUQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 15:16:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258AbXKNUQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 15:16:51 -0500
Message-Id: <20071114201528.514434000@chello.nl>
References: <20071114200136.009242000@chello.nl>
User-Agent: quilt/0.45-1
Date: Wed, 14 Nov 2007 21:01:39 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Nick Piggin <npiggin@suse.de>, Hugh Dickins <hugh@veritas.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/3] nfs: use ->mmap_prepare() to avoid an AB-BA deadlock
Content-Disposition: inline; filename=mmap_prepare_nfs.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Normal locking order is:

  i_mutex
    mmap_sem

However NFS's ->mmap hook, which is called under mmap_sem, can take i_mutex.
Avoid this potential deadlock by doing the work that requires i_mutex from
the new ->mmap_prepare().

[ Is this sufficient, or does it introduce a race? ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/nfs/file.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

Index: linux-2.6/fs/nfs/file.c
===================================================================
--- linux-2.6.orig/fs/nfs/file.c
+++ linux-2.6/fs/nfs/file.c
@@ -41,6 +41,9 @@
 static int nfs_file_open(struct inode *, struct file *);
 static int nfs_file_release(struct inode *, struct file *);
 static loff_t nfs_file_llseek(struct file *file, loff_t offset, int origin);
+static int
+nfs_file_mmap_prepare(struct file * file, unsigned long len,
+		unsigned long prot, unsigned long flags, unsigned long pgoff);
 static int  nfs_file_mmap(struct file *, struct vm_area_struct *);
 static ssize_t nfs_file_splice_read(struct file *filp, loff_t *ppos,
 					struct pipe_inode_info *pipe,
@@ -64,6 +67,7 @@ const struct file_operations nfs_file_op
 	.write		= do_sync_write,
 	.aio_read	= nfs_file_read,
 	.aio_write	= nfs_file_write,
+	.mmap_prepare	= nfs_file_mmap_prepare,
 	.mmap		= nfs_file_mmap,
 	.open		= nfs_file_open,
 	.flush		= nfs_file_flush,
@@ -270,7 +274,8 @@ nfs_file_splice_read(struct file *filp, 
 }
 
 static int
-nfs_file_mmap(struct file * file, struct vm_area_struct * vma)
+nfs_file_mmap_prepare(struct file * file, unsigned long len,
+		unsigned long prot, unsigned long flags, unsigned long pgoff)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
@@ -279,13 +284,17 @@ nfs_file_mmap(struct file * file, struct
 	dfprintk(VFS, "nfs: mmap(%s/%s)\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name);
 
-	status = nfs_revalidate_mapping(inode, file->f_mapping);
-	if (!status) {
-		vma->vm_ops = &nfs_file_vm_ops;
-		vma->vm_flags |= VM_CAN_NONLINEAR;
-		file_accessed(file);
-	}
-	return status;
+	return nfs_revalidate_mapping(inode, file->f_mapping);
+}
+
+static int
+nfs_file_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	vma->vm_ops = &nfs_file_vm_ops;
+	vma->vm_flags |= VM_CAN_NONLINEAR;
+	file_accessed(file);
+
+	return 0;
 }
 
 /*

--

