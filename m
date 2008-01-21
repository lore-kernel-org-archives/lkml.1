Return-Path: <linux-kernel-owner+w=401wt.eu-S1759888AbYAUKCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888AbYAUKCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759041AbYAUKB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:01:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758897AbYAUKB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:01:56 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 03/58] [GFS2] Use ->page_mkwrite() for mmap()
Date: Mon, 21 Jan 2008 09:21:21 +0000
Message-Id: <1200907348435-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009073453549-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
 <12009073443813-git-send-email-swhiteho@redhat.com>
 <12009073453549-git-send-email-swhiteho@redhat.com>
Message-Id: <5d6eb1480e3e5fb2d833de0cecb5587543c99d7e.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This cleans up the mmap() code path for GFS2 by implementing the
page_mkwrite function for GFS2. We are thus able to use the
generic filemap_fault function for our ->fault() implementation.

This now means that shared writable mappings will be much more
efficiently shared across the cluster if there is a reasonable
proportion of read activity (the greater proportion, the better).

As a side effect, it also reduces the size of the code, removes
special cases from readpage and readpages, and makes the code
path easier to follow.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/Makefile b/fs/gfs2/Makefile
index 04ad0ca..8fff110 100644
--- a/fs/gfs2/Makefile
+++ b/fs/gfs2/Makefile
@@ -2,7 +2,7 @@ obj-$(CONFIG_GFS2_FS) += gfs2.o
 gfs2-y := acl.o bmap.o daemon.o dir.o eaops.o eattr.o glock.o \
 	glops.o inode.o lm.o log.o lops.o locking.o main.o meta_io.o \
 	mount.o ops_address.o ops_dentry.o ops_export.o ops_file.o \
-	ops_fstype.o ops_inode.o ops_super.o ops_vm.o quota.o \
+	ops_fstype.o ops_inode.o ops_super.o quota.o \
 	recovery.o rgrp.o super.o sys.o trans.o util.o
 
 obj-$(CONFIG_GFS2_FS_LOCKING_NOLOCK) += locking/nolock/
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 4670dcb..110f03d 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -86,15 +86,10 @@ static void gfs2_pte_inval(struct gfs2_glock *gl)
 	if (!ip || !S_ISREG(inode->i_mode))
 		return;
 
-	if (!test_bit(GIF_PAGED, &ip->i_flags))
-		return;
-
 	unmap_shared_mapping_range(inode->i_mapping, 0, 0);
-
 	if (test_bit(GIF_SW_PAGED, &ip->i_flags))
 		set_bit(GLF_DIRTY, &gl->gl_flags);
 
-	clear_bit(GIF_SW_PAGED, &ip->i_flags);
 }
 
 /**
@@ -234,10 +229,8 @@ static void inode_go_inval(struct gfs2_glock *gl, int flags)
 			set_bit(GIF_INVALID, &ip->i_flags);
 	}
 
-	if (ip && S_ISREG(ip->i_inode.i_mode)) {
+	if (ip && S_ISREG(ip->i_inode.i_mode))
 		truncate_inode_pages(ip->i_inode.i_mapping, 0);
-		clear_bit(GIF_PAGED, &ip->i_flags);
-	}
 }
 
 /**
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 662182b..55c72f0 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -241,7 +241,6 @@ struct gfs2_alloc {
 enum {
 	GIF_INVALID		= 0,
 	GIF_QD_LOCKED		= 1,
-	GIF_PAGED		= 2,
 	GIF_SW_PAGED		= 3,
 };
 
@@ -289,19 +288,12 @@ static inline struct gfs2_inode *GFS2_I(struct inode *inode)
 	return container_of(inode, struct gfs2_inode, i_inode);
 }
 
-/* To be removed? */
 static inline struct gfs2_sbd *GFS2_SB(struct inode *inode)
 {
 	return inode->i_sb->s_fs_info;
 }
 
-enum {
-	GFF_DID_DIRECT_ALLOC	= 0,
-	GFF_EXLOCK = 1,
-};
-
 struct gfs2_file {
-	unsigned long f_flags;		/* GFF_... */
 	struct mutex f_fl_mutex;
 	struct gfs2_holder f_fl_gh;
 };
diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index 9bb24b1..1696e5d 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -265,9 +265,7 @@ static int __gfs2_readpage(void *file, struct page *page)
  * @file: The file to read
  * @page: The page of the file
  *
- * This deals with the locking required. If the GFF_EXLOCK flags is set
- * then we already hold the glock (due to page fault) and thus we call
- * __gfs2_readpage() directly. Otherwise we use a trylock in order to
+ * This deals with the locking required. We use a trylock in order to
  * avoid the page lock / glock ordering problems returning AOP_TRUNCATED_PAGE
  * in the event that we are unable to get the lock.
  */
@@ -278,12 +276,6 @@ static int gfs2_readpage(struct file *file, struct page *page)
 	struct gfs2_holder gh;
 	int error;
 
-	if (file) {
-		struct gfs2_file *gf = file->private_data;
-		if (test_bit(GFF_EXLOCK, &gf->f_flags))
-			return __gfs2_readpage(file, page);
-	}
-
 	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, GL_ATIME|LM_FLAG_TRY_1CB, &gh);
 	error = gfs2_glock_nq_atime(&gh);
 	if (unlikely(error)) {
@@ -354,9 +346,8 @@ int gfs2_internal_read(struct gfs2_inode *ip, struct file_ra_state *ra_state,
  * 2. We don't handle stuffed files here we let readpage do the honours.
  * 3. mpage_readpages() does most of the heavy lifting in the common case.
  * 4. gfs2_get_block() is relied upon to set BH_Boundary in the right places.
- * 5. We use LM_FLAG_TRY_1CB here, effectively we then have lock-ahead as
- *    well as read-ahead.
  */
+
 static int gfs2_readpages(struct file *file, struct address_space *mapping,
 			  struct list_head *pages, unsigned nr_pages)
 {
@@ -364,40 +355,20 @@ static int gfs2_readpages(struct file *file, struct address_space *mapping,
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	struct gfs2_holder gh;
-	int ret = 0;
-	int do_unlock = 0;
+	int ret;
 
-	if (file) {
-		struct gfs2_file *gf = file->private_data;
-		if (test_bit(GFF_EXLOCK, &gf->f_flags))
-			goto skip_lock;
-	}
-	gfs2_holder_init(ip->i_gl, LM_ST_SHARED,
-			 LM_FLAG_TRY_1CB|GL_ATIME, &gh);
-	do_unlock = 1;
+	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, GL_ATIME, &gh);
 	ret = gfs2_glock_nq_atime(&gh);
-	if (ret == GLR_TRYFAILED)
-		goto out_noerror;
 	if (unlikely(ret))
-		goto out_unlock;
-skip_lock:
+		goto out_uninit;
 	if (!gfs2_is_stuffed(ip))
 		ret = mpage_readpages(mapping, pages, nr_pages, gfs2_get_block);
-
-	if (do_unlock) {
-		gfs2_glock_dq_m(1, &gh);
-		gfs2_holder_uninit(&gh);
-	}
-out:
+	gfs2_glock_dq(&gh);
+out_uninit:
+	gfs2_holder_uninit(&gh);
 	if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
 		ret = -EIO;
 	return ret;
-out_noerror:
-	ret = 0;
-out_unlock:
-	if (do_unlock)
-		gfs2_holder_uninit(&gh);
-	goto out;
 }
 
 /**
diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index a729c86..6f3aeb0 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -33,7 +33,6 @@
 #include "lm.h"
 #include "log.h"
 #include "meta_io.h"
-#include "ops_vm.h"
 #include "quota.h"
 #include "rgrp.h"
 #include "trans.h"
@@ -169,7 +168,7 @@ static int gfs2_get_flags(struct file *filp, u32 __user *ptr)
 	if (put_user(fsflags, ptr))
 		error = -EFAULT;
 
-	gfs2_glock_dq_m(1, &gh);
+	gfs2_glock_dq(&gh);
 	gfs2_holder_uninit(&gh);
 	return error;
 }
@@ -293,6 +292,125 @@ static long gfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	return -ENOTTY;
 }
 
+/**
+ * gfs2_allocate_page_backing - Use bmap to allocate blocks
+ * @page: The (locked) page to allocate backing for
+ *
+ * We try to allocate all the blocks required for the page in
+ * one go. This might fail for various reasons, so we keep
+ * trying until all the blocks to back this page are allocated.
+ * If some of the blocks are already allocated, thats ok too.
+ */
+
+static int gfs2_allocate_page_backing(struct page *page)
+{
+	struct inode *inode = page->mapping->host;
+	struct buffer_head bh;
+	unsigned long size = PAGE_CACHE_SIZE;
+	u64 lblock = page->index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
+
+	do {
+		bh.b_state = 0;
+		bh.b_size = size;
+		gfs2_block_map(inode, lblock, 1, &bh);
+		if (!buffer_mapped(&bh))
+			return -EIO;
+		size -= bh.b_size;
+		lblock += (bh.b_size >> inode->i_blkbits);
+	} while(size > 0);
+	return 0;
+}
+
+/**
+ * gfs2_page_mkwrite - Make a shared, mmap()ed, page writable
+ * @vma: The virtual memory area
+ * @page: The page which is about to become writable
+ *
+ * When the page becomes writable, we need to ensure that we have
+ * blocks allocated on disk to back that page.
+ */
+
+static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct page *page)
+{
+	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	unsigned long last_index;
+	u64 pos = page->index << (PAGE_CACHE_SIZE - inode->i_blkbits);
+	unsigned int data_blocks, ind_blocks, rblocks;
+	int alloc_required = 0;
+	struct gfs2_holder gh;
+	struct gfs2_alloc *al;
+	int ret;
+
+	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, GL_ATIME, &gh);
+	ret = gfs2_glock_nq_atime(&gh);
+	if (ret)
+		goto out;
+
+	set_bit(GIF_SW_PAGED, &ip->i_flags);
+	gfs2_write_calc_reserv(ip, PAGE_CACHE_SIZE, &data_blocks, &ind_blocks);
+	ret = gfs2_write_alloc_required(ip, pos, PAGE_CACHE_SIZE, &alloc_required);
+	if (ret || !alloc_required)
+		goto out_unlock;
+
+	ip->i_alloc.al_requested = 0;
+	al = gfs2_alloc_get(ip);
+	ret = gfs2_quota_lock(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
+	if (ret)
+		goto out_alloc_put;
+	ret = gfs2_quota_check(ip, ip->i_inode.i_uid, ip->i_inode.i_gid);
+	if (ret)
+		goto out_quota_unlock;
+	al->al_requested = data_blocks + ind_blocks;
+	ret = gfs2_inplace_reserve(ip);
+	if (ret)
+		goto out_quota_unlock;
+
+	rblocks = RES_DINODE + ind_blocks;
+	if (gfs2_is_jdata(ip))
+		rblocks += data_blocks ? data_blocks : 1;
+	if (ind_blocks || data_blocks)
+		rblocks += RES_STATFS + RES_QUOTA;
+	ret = gfs2_trans_begin(sdp, rblocks, 0);
+	if (ret)
+		goto out_trans_fail;
+
+	lock_page(page);
+	ret = -EINVAL;
+	last_index = ip->i_inode.i_size >> PAGE_CACHE_SHIFT;
+	if (page->index > last_index)
+		goto out_unlock_page;
+	if (!PageUptodate(page) || page->mapping != ip->i_inode.i_mapping)
+		goto out_unlock_page;
+	if (gfs2_is_stuffed(ip)) {
+		ret = gfs2_unstuff_dinode(ip, page);
+		if (ret)
+			goto out_unlock_page;
+	}
+	ret = gfs2_allocate_page_backing(page);
+
+out_unlock_page:
+	unlock_page(page);
+	gfs2_trans_end(sdp);
+out_trans_fail:
+	gfs2_inplace_release(ip);
+out_quota_unlock:
+	gfs2_quota_unlock(ip);
+out_alloc_put:
+	gfs2_alloc_put(ip);
+out_unlock:
+	gfs2_glock_dq(&gh);
+out:
+	gfs2_holder_uninit(&gh);
+	return ret;
+}
+
+static struct vm_operations_struct gfs2_vm_ops = {
+	.fault = filemap_fault,
+	.page_mkwrite = gfs2_page_mkwrite,
+};
+
 
 /**
  * gfs2_mmap -
@@ -315,14 +433,7 @@ static int gfs2_mmap(struct file *file, struct vm_area_struct *vma)
 		return error;
 	}
 
-	/* This is VM_MAYWRITE instead of VM_WRITE because a call
-	   to mprotect() can turn on VM_WRITE later. */
-
-	if ((vma->vm_flags & (VM_MAYSHARE | VM_MAYWRITE)) ==
-	    (VM_MAYSHARE | VM_MAYWRITE))
-		vma->vm_ops = &gfs2_vm_ops_sharewrite;
-	else
-		vma->vm_ops = &gfs2_vm_ops_private;
+	vma->vm_ops = &gfs2_vm_ops;
 
 	gfs2_glock_dq_uninit(&i_gh);
 
diff --git a/fs/gfs2/ops_vm.c b/fs/gfs2/ops_vm.c
deleted file mode 100644
index 927d739..0000000
--- a/fs/gfs2/ops_vm.c
+++ /dev/null
@@ -1,169 +0,0 @@
-/*
- * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
- *
- * This copyrighted material is made available to anyone wishing to use,
- * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License version 2.
- */
-
-#include <linux/slab.h>
-#include <linux/spinlock.h>
-#include <linux/completion.h>
-#include <linux/buffer_head.h>
-#include <linux/mm.h>
-#include <linux/pagemap.h>
-#include <linux/gfs2_ondisk.h>
-#include <linux/lm_interface.h>
-
-#include "gfs2.h"
-#include "incore.h"
-#include "bmap.h"
-#include "glock.h"
-#include "inode.h"
-#include "ops_vm.h"
-#include "quota.h"
-#include "rgrp.h"
-#include "trans.h"
-#include "util.h"
-
-static int gfs2_private_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
-{
-	struct gfs2_inode *ip = GFS2_I(vma->vm_file->f_mapping->host);
-
-	set_bit(GIF_PAGED, &ip->i_flags);
-	return filemap_fault(vma, vmf);
-}
-
-static int alloc_page_backing(struct gfs2_inode *ip, struct page *page)
-{
-	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	unsigned long index = page->index;
-	u64 lblock = index << (PAGE_CACHE_SHIFT -
-				    sdp->sd_sb.sb_bsize_shift);
-	unsigned int blocks = PAGE_CACHE_SIZE >> sdp->sd_sb.sb_bsize_shift;
-	struct gfs2_alloc *al;
-	unsigned int data_blocks, ind_blocks;
-	unsigned int x;
-	int error;
-
-	al = gfs2_alloc_get(ip);
-
-	error = gfs2_quota_lock(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
-	if (error)
-		goto out;
-
-	error = gfs2_quota_check(ip, ip->i_inode.i_uid, ip->i_inode.i_gid);
-	if (error)
-		goto out_gunlock_q;
-
-	gfs2_write_calc_reserv(ip, PAGE_CACHE_SIZE, &data_blocks, &ind_blocks);
-
-	al->al_requested = data_blocks + ind_blocks;
-
-	error = gfs2_inplace_reserve(ip);
-	if (error)
-		goto out_gunlock_q;
-
-	error = gfs2_trans_begin(sdp, al->al_rgd->rd_length +
-				 ind_blocks + RES_DINODE +
-				 RES_STATFS + RES_QUOTA, 0);
-	if (error)
-		goto out_ipres;
-
-	if (gfs2_is_stuffed(ip)) {
-		error = gfs2_unstuff_dinode(ip, NULL);
-		if (error)
-			goto out_trans;
-	}
-
-	for (x = 0; x < blocks; ) {
-		u64 dblock;
-		unsigned int extlen;
-		int new = 1;
-
-		error = gfs2_extent_map(&ip->i_inode, lblock, &new, &dblock, &extlen);
-		if (error)
-			goto out_trans;
-
-		lblock += extlen;
-		x += extlen;
-	}
-
-	gfs2_assert_warn(sdp, al->al_alloced);
-
-out_trans:
-	gfs2_trans_end(sdp);
-out_ipres:
-	gfs2_inplace_release(ip);
-out_gunlock_q:
-	gfs2_quota_unlock(ip);
-out:
-	gfs2_alloc_put(ip);
-	return error;
-}
-
-static int gfs2_sharewrite_fault(struct vm_area_struct *vma,
-						struct vm_fault *vmf)
-{
-	struct file *file = vma->vm_file;
-	struct gfs2_file *gf = file->private_data;
-	struct gfs2_inode *ip = GFS2_I(file->f_mapping->host);
-	struct gfs2_holder i_gh;
-	int alloc_required;
-	int error;
-	int ret = 0;
-
-	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &i_gh);
-	if (error)
-		goto out;
-
-	set_bit(GIF_PAGED, &ip->i_flags);
-	set_bit(GIF_SW_PAGED, &ip->i_flags);
-
-	error = gfs2_write_alloc_required(ip,
-					(u64)vmf->pgoff << PAGE_CACHE_SHIFT,
-					PAGE_CACHE_SIZE, &alloc_required);
-	if (error) {
-		ret = VM_FAULT_OOM; /* XXX: are these right? */
-		goto out_unlock;
-	}
-
-	set_bit(GFF_EXLOCK, &gf->f_flags);
-	ret = filemap_fault(vma, vmf);
-	clear_bit(GFF_EXLOCK, &gf->f_flags);
-	if (ret & VM_FAULT_ERROR)
-		goto out_unlock;
-
-	if (alloc_required) {
-		/* XXX: do we need to drop page lock around alloc_page_backing?*/
-		error = alloc_page_backing(ip, vmf->page);
-		if (error) {
-			/*
-			 * VM_FAULT_LOCKED should always be the case for
-			 * filemap_fault, but it may not be in a future
-			 * implementation.
-			 */
-			if (ret & VM_FAULT_LOCKED)
-				unlock_page(vmf->page);
-			page_cache_release(vmf->page);
-			ret = VM_FAULT_OOM;
-			goto out_unlock;
-		}
-		set_page_dirty(vmf->page);
-	}
-
-out_unlock:
-	gfs2_glock_dq_uninit(&i_gh);
-out:
-	return ret;
-}
-
-struct vm_operations_struct gfs2_vm_ops_private = {
-	.fault = gfs2_private_fault,
-};
-
-struct vm_operations_struct gfs2_vm_ops_sharewrite = {
-	.fault = gfs2_sharewrite_fault,
-};
-
diff --git a/fs/gfs2/ops_vm.h b/fs/gfs2/ops_vm.h
deleted file mode 100644
index 4ae8f43..0000000
--- a/fs/gfs2/ops_vm.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/*
- * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
- *
- * This copyrighted material is made available to anyone wishing to use,
- * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License version 2.
- */
-
-#ifndef __OPS_VM_DOT_H__
-#define __OPS_VM_DOT_H__
-
-#include <linux/mm.h>
-
-extern struct vm_operations_struct gfs2_vm_ops_private;
-extern struct vm_operations_struct gfs2_vm_ops_sharewrite;
-
-#endif /* __OPS_VM_DOT_H__ */
-- 
1.5.1.2

