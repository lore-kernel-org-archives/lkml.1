Return-Path: <linux-kernel-owner+w=401wt.eu-S1760945AbYAUKEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760945AbYAUKEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759314AbYAUKCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759063AbYAUKCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:02 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 02/58] [GFS2] Clean up internal read function
Date: Mon, 21 Jan 2008 09:21:20 +0000
Message-Id: <12009073453549-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009073443813-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
 <12009073443813-git-send-email-swhiteho@redhat.com>
Message-Id: <5eb92fee617a944b989eb07080ceba0350ec291d.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

As requested by Christoph, this patch cleans up GFS2's internal
read function so that it no longer uses the do_generic_mapping_read
function. This function is obsolete and GFS2 is the last user of it.

As a side effect the internal read code gets smaller and easier
to read and gfs2_readpage is split into two. One function has the locking
and the other function has the rest of the logic.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 5f6dc32..ad0fe37 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -31,7 +31,6 @@
 #include "log.h"
 #include "meta_io.h"
 #include "ops_address.h"
-#include "ops_file.h"
 #include "ops_inode.h"
 #include "quota.h"
 #include "rgrp.h"
diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index 9679f8b..9bb24b1 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -20,6 +20,7 @@
 #include <linux/swap.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/lm_interface.h>
+#include <linux/swap.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -32,7 +33,6 @@
 #include "quota.h"
 #include "trans.h"
 #include "rgrp.h"
-#include "ops_file.h"
 #include "super.h"
 #include "util.h"
 #include "glops.h"
@@ -231,62 +231,115 @@ static int stuffed_readpage(struct gfs2_inode *ip, struct page *page)
 
 
 /**
- * gfs2_readpage - readpage with locking
- * @file: The file to read a page for. N.B. This may be NULL if we are
- * reading an internal file.
+ * __gfs2_readpage - readpage
+ * @file: The file to read a page for
  * @page: The page to read
  *
- * Returns: errno
+ * This is the core of gfs2's readpage. Its used by the internal file
+ * reading code as in that case we already hold the glock. Also its
+ * called by gfs2_readpage() once the required lock has been granted.
+ *
  */
 
-static int gfs2_readpage(struct file *file, struct page *page)
+static int __gfs2_readpage(void *file, struct page *page)
 {
 	struct gfs2_inode *ip = GFS2_I(page->mapping->host);
 	struct gfs2_sbd *sdp = GFS2_SB(page->mapping->host);
-	struct gfs2_file *gf = NULL;
-	struct gfs2_holder gh;
 	int error;
-	int do_unlock = 0;
-
-	if (likely(file != &gfs2_internal_file_sentinel)) {
-		if (file) {
-			gf = file->private_data;
-			if (test_bit(GFF_EXLOCK, &gf->f_flags))
-				/* gfs2_sharewrite_fault has grabbed the ip->i_gl already */
-				goto skip_lock;
-		}
-		gfs2_holder_init(ip->i_gl, LM_ST_SHARED, GL_ATIME|LM_FLAG_TRY_1CB, &gh);
-		do_unlock = 1;
-		error = gfs2_glock_nq_atime(&gh);
-		if (unlikely(error))
-			goto out_unlock;
-	}
 
-skip_lock:
 	if (gfs2_is_stuffed(ip)) {
 		error = stuffed_readpage(ip, page);
 		unlock_page(page);
-	} else
+	} else {
 		error = mpage_readpage(page, gfs2_get_block);
+	}
 
 	if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-		error = -EIO;
+		return -EIO;
 
-	if (do_unlock) {
-		gfs2_glock_dq_m(1, &gh);
-		gfs2_holder_uninit(&gh);
+	return error;
+}
+
+/**
+ * gfs2_readpage - read a page of a file
+ * @file: The file to read
+ * @page: The page of the file
+ *
+ * This deals with the locking required. If the GFF_EXLOCK flags is set
+ * then we already hold the glock (due to page fault) and thus we call
+ * __gfs2_readpage() directly. Otherwise we use a trylock in order to
+ * avoid the page lock / glock ordering problems returning AOP_TRUNCATED_PAGE
+ * in the event that we are unable to get the lock.
+ */
+
+static int gfs2_readpage(struct file *file, struct page *page)
+{
+	struct gfs2_inode *ip = GFS2_I(page->mapping->host);
+	struct gfs2_holder gh;
+	int error;
+
+	if (file) {
+		struct gfs2_file *gf = file->private_data;
+		if (test_bit(GFF_EXLOCK, &gf->f_flags))
+			return __gfs2_readpage(file, page);
 	}
+
+	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, GL_ATIME|LM_FLAG_TRY_1CB, &gh);
+	error = gfs2_glock_nq_atime(&gh);
+	if (unlikely(error)) {
+		unlock_page(page);
+		goto out;
+	}
+	error = __gfs2_readpage(file, page);
+	gfs2_glock_dq(&gh);
 out:
-	return error;
-out_unlock:
-	unlock_page(page);
+	gfs2_holder_uninit(&gh);
 	if (error == GLR_TRYFAILED) {
-		error = AOP_TRUNCATED_PAGE;
 		yield();
+		return AOP_TRUNCATED_PAGE;
 	}
-	if (do_unlock)
-		gfs2_holder_uninit(&gh);
-	goto out;
+	return error;
+}
+
+/**
+ * gfs2_internal_read - read an internal file
+ * @ip: The gfs2 inode
+ * @ra_state: The readahead state (or NULL for no readahead)
+ * @buf: The buffer to fill
+ * @pos: The file position
+ * @size: The amount to read
+ *
+ */
+
+int gfs2_internal_read(struct gfs2_inode *ip, struct file_ra_state *ra_state,
+                       char *buf, loff_t *pos, unsigned size)
+{
+	struct address_space *mapping = ip->i_inode.i_mapping;
+	unsigned long index = *pos / PAGE_CACHE_SIZE;
+	unsigned offset = *pos & (PAGE_CACHE_SIZE - 1);
+	unsigned copied = 0;
+	unsigned amt;
+	struct page *page;
+	void *p;
+
+	do {
+		amt = size - copied;
+		if (offset + size > PAGE_CACHE_SIZE)
+			amt = PAGE_CACHE_SIZE - offset;
+		page = read_cache_page(mapping, index, __gfs2_readpage, NULL);
+		if (IS_ERR(page))
+			return PTR_ERR(page);
+		p = kmap_atomic(page, KM_USER0);
+		memcpy(buf + copied, p + offset, amt);
+		kunmap_atomic(p, KM_USER0);
+		mark_page_accessed(page);
+		page_cache_release(page);
+		copied += amt;
+		index++;
+		offset = 0;
+	} while(copied < size);
+	(*pos) += size;
+	return size;
 }
 
 /**
@@ -314,21 +367,19 @@ static int gfs2_readpages(struct file *file, struct address_space *mapping,
 	int ret = 0;
 	int do_unlock = 0;
 
-	if (likely(file != &gfs2_internal_file_sentinel)) {
-		if (file) {
-			struct gfs2_file *gf = file->private_data;
-			if (test_bit(GFF_EXLOCK, &gf->f_flags))
-				goto skip_lock;
-		}
-		gfs2_holder_init(ip->i_gl, LM_ST_SHARED,
-				 LM_FLAG_TRY_1CB|GL_ATIME, &gh);
-		do_unlock = 1;
-		ret = gfs2_glock_nq_atime(&gh);
-		if (ret == GLR_TRYFAILED)
-			goto out_noerror;
-		if (unlikely(ret))
-			goto out_unlock;
+	if (file) {
+		struct gfs2_file *gf = file->private_data;
+		if (test_bit(GFF_EXLOCK, &gf->f_flags))
+			goto skip_lock;
 	}
+	gfs2_holder_init(ip->i_gl, LM_ST_SHARED,
+			 LM_FLAG_TRY_1CB|GL_ATIME, &gh);
+	do_unlock = 1;
+	ret = gfs2_glock_nq_atime(&gh);
+	if (ret == GLR_TRYFAILED)
+		goto out_noerror;
+	if (unlikely(ret))
+		goto out_unlock;
 skip_lock:
 	if (!gfs2_is_stuffed(ip))
 		ret = mpage_readpages(mapping, pages, nr_pages, gfs2_get_block);
diff --git a/fs/gfs2/ops_address.h b/fs/gfs2/ops_address.h
index fa1b5b3..e8fe83f 100644
--- a/fs/gfs2/ops_address.h
+++ b/fs/gfs2/ops_address.h
@@ -18,5 +18,8 @@ extern const struct address_space_operations gfs2_file_aops;
 extern int gfs2_get_block(struct inode *inode, sector_t lblock,
 			  struct buffer_head *bh_result, int create);
 extern int gfs2_releasepage(struct page *page, gfp_t gfp_mask);
+extern int gfs2_internal_read(struct gfs2_inode *ip,
+			      struct file_ra_state *ra_state,
+			      char *buf, loff_t *pos, unsigned size);
 
 #endif /* __OPS_ADDRESS_DOT_H__ */
diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index bb11fd6..a729c86 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -33,7 +33,6 @@
 #include "lm.h"
 #include "log.h"
 #include "meta_io.h"
-#include "ops_file.h"
 #include "ops_vm.h"
 #include "quota.h"
 #include "rgrp.h"
@@ -41,50 +40,6 @@
 #include "util.h"
 #include "eaops.h"
 
-/*
- * Most fields left uninitialised to catch anybody who tries to
- * use them. f_flags set to prevent file_accessed() from touching
- * any other part of this. Its use is purely as a flag so that we
- * know (in readpage()) whether or not do to locking.
- */
-struct file gfs2_internal_file_sentinel = {
-	.f_flags = O_NOATIME|O_RDONLY,
-};
-
-static int gfs2_read_actor(read_descriptor_t *desc, struct page *page,
-			   unsigned long offset, unsigned long size)
-{
-	char *kaddr;
-	unsigned long count = desc->count;
-
-	if (size > count)
-		size = count;
-
-	kaddr = kmap(page);
-	memcpy(desc->arg.data, kaddr + offset, size);
-	kunmap(page);
-
-	desc->count = count - size;
-	desc->written += size;
-	desc->arg.buf += size;
-	return size;
-}
-
-int gfs2_internal_read(struct gfs2_inode *ip, struct file_ra_state *ra_state,
-		       char *buf, loff_t *pos, unsigned size)
-{
-	struct inode *inode = &ip->i_inode;
-	read_descriptor_t desc;
-	desc.written = 0;
-	desc.arg.data = buf;
-	desc.count = size;
-	desc.error = 0;
-	do_generic_mapping_read(inode->i_mapping, ra_state,
-				&gfs2_internal_file_sentinel, pos, &desc,
-				gfs2_read_actor);
-	return desc.written ? desc.written : desc.error;
-}
-
 /**
  * gfs2_llseek - seek to a location in a file
  * @file: the file
diff --git a/fs/gfs2/ops_file.h b/fs/gfs2/ops_file.h
deleted file mode 100644
index 7e5d8ec..0000000
--- a/fs/gfs2/ops_file.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/*
- * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
- *
- * This copyrighted material is made available to anyone wishing to use,
- * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License version 2.
- */
-
-#ifndef __OPS_FILE_DOT_H__
-#define __OPS_FILE_DOT_H__
-
-#include <linux/fs.h>
-struct gfs2_inode;
-
-extern struct file gfs2_internal_file_sentinel;
-extern int gfs2_internal_read(struct gfs2_inode *ip,
-			      struct file_ra_state *ra_state,
-			      char *buf, loff_t *pos, unsigned size);
-extern void gfs2_set_inode_flags(struct inode *inode);
-extern const struct file_operations gfs2_file_fops;
-extern const struct file_operations gfs2_dir_fops;
-
-#endif /* __OPS_FILE_DOT_H__ */
diff --git a/fs/gfs2/ops_inode.h b/fs/gfs2/ops_inode.h
index 34f0caa..edb519c 100644
--- a/fs/gfs2/ops_inode.h
+++ b/fs/gfs2/ops_inode.h
@@ -16,5 +16,9 @@ extern const struct inode_operations gfs2_file_iops;
 extern const struct inode_operations gfs2_dir_iops;
 extern const struct inode_operations gfs2_symlink_iops;
 extern const struct inode_operations gfs2_dev_iops;
+extern const struct file_operations gfs2_file_fops;
+extern const struct file_operations gfs2_dir_fops;
+
+extern void gfs2_set_inode_flags(struct inode *inode);
 
 #endif /* __OPS_INODE_DOT_H__ */
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index addb51e..4996f0e 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -59,7 +59,6 @@
 #include "super.h"
 #include "trans.h"
 #include "inode.h"
-#include "ops_file.h"
 #include "ops_address.h"
 #include "util.h"
 
@@ -793,11 +792,9 @@ static int do_glock(struct gfs2_quota_data *qd, int force_refresh,
 	struct gfs2_holder i_gh;
 	struct gfs2_quota_host q;
 	char buf[sizeof(struct gfs2_quota)];
-	struct file_ra_state ra_state;
 	int error;
 	struct gfs2_quota_lvb *qlvb;
 
-	file_ra_state_init(&ra_state, sdp->sd_quota_inode->i_mapping);
 restart:
 	error = gfs2_glock_nq_init(qd->qd_gl, LM_ST_SHARED, 0, q_gh);
 	if (error)
@@ -820,8 +817,8 @@ restart:
 
 		memset(buf, 0, sizeof(struct gfs2_quota));
 		pos = qd2offset(qd);
-		error = gfs2_internal_read(ip, &ra_state, buf,
-					   &pos, sizeof(struct gfs2_quota));
+		error = gfs2_internal_read(ip, NULL, buf, &pos,
+					   sizeof(struct gfs2_quota));
 		if (error < 0)
 			goto fail_gunlock;
 
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 708c287..09848aa 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -25,10 +25,10 @@
 #include "rgrp.h"
 #include "super.h"
 #include "trans.h"
-#include "ops_file.h"
 #include "util.h"
 #include "log.h"
 #include "inode.h"
+#include "ops_address.h"
 
 #define BFITNOENT ((u32)~0)
 #define NO_BLOCK ((u64)~0)
-- 
1.5.1.2

