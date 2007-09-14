Return-Path: <linux-kernel-owner+w=401wt.eu-S933235AbXINQC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbXINQC4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 12:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbXINQCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 12:02:42 -0400
Received: from cpe-70-113-91-236.austin.res.rr.com ([70.113.91.236]:35664 "EHLO
	ericvh.homeip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbXINQCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 12:02:41 -0400
From: Eric Van Hensbergen <ericvh@gmail.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Eric Van Hensbergen <ericvh@gmail.com>
Subject: [RFC][PATCH] 9p: add readahead support for loose mode
Date: Fri, 14 Sep 2007 11:02:40 -0500
Message-Id: <11897857601214-git-send-email-ericvh@gmail.com>
X-Mailer: git-send-email 1.5.0.2.gfbe3d-dirty
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds readpages support in support of readahead when using loose
cache mode.  It substantially increases performance for certain workloads.

Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
---
 fs/9p/v9fs.c            |    2 +-
 fs/9p/vfs_addr.c        |   98 ++++++++++++++++++++++++++++++++++++++++++----
 include/net/9p/client.h |    3 +-
 net/9p/client.c         |   82 +++++++++++++++++++++++++--------------
 4 files changed, 143 insertions(+), 42 deletions(-)

diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 89ee0ba..ca97404 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -131,7 +131,7 @@ static void v9fs_parse_options(struct v9fs_session_info *v9ses)
 	char *s, *e;
 
 	/* setup defaults */
-	v9ses->maxdata = 8192;
+	v9ses->maxdata = (64*1024);
 	v9ses->afid = ~0;
 	v9ses->debug = 0;
 	v9ses->cache = 0;
diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 6248f0e..86c6e0d 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -31,8 +31,11 @@
 #include <linux/string.h>
 #include <linux/inet.h>
 #include <linux/pagemap.h>
+#include <linux/pagevec.h>
 #include <linux/idr.h>
 #include <linux/sched.h>
+#include <linux/uio.h>
+#include <linux/task_io_accounting_ops.h>
 #include <net/9p/9p.h>
 #include <net/9p/client.h>
 
@@ -50,31 +53,108 @@
 
 static int v9fs_vfs_readpage(struct file *filp, struct page *page)
 {
-	int retval;
 	loff_t offset;
 	char *buffer;
 	struct p9_fid *fid;
+	int retval = 0;
+	int total = 0;
+	int count = PAGE_SIZE;
 
 	P9_DPRINTK(P9_DEBUG_VFS, "\n");
 	fid = filp->private_data;
 	buffer = kmap(page);
 	offset = page_offset(page);
 
-	retval = p9_client_readn(fid, buffer, offset, PAGE_CACHE_SIZE);
-	if (retval < 0)
-		goto done;
+	while (count) {
+		struct kvec kv = {buffer+offset, PAGE_SIZE-count};
+		retval = p9_client_readv(fid, &kv, offset, 1);
+		if (retval <= 0)
+			break;
 
-	memset(buffer + retval, 0, PAGE_CACHE_SIZE - retval);
-	flush_dcache_page(page);
-	SetPageUptodate(page);
-	retval = 0;
+		buffer += retval;
+		offset += retval;
+		count -= retval;
+		total += retval;
+	}
+
+	if (retval >= 0) {
+		flush_dcache_page(page);
+		SetPageUptodate(page);
+		retval = 0;
+	}
 
-done:
 	kunmap(page);
 	unlock_page(page);
 	return retval;
 }
 
+/* large chunks copied and adapted from fs/cifs/file.c */
+static int v9fs_vfs_readpages(struct file *file, struct address_space *mapping,
+	struct list_head *page_list, unsigned num_pages)
+{
+	struct page *tmp_page;
+	loff_t offset;
+	struct pagevec lru_pvec;
+	struct p9_fid *fid;
+	u32 read_size;
+	int retval = 0;
+	unsigned int count = 0;
+	struct list_head *p, *n;
+
+	struct kvec *kv = kmalloc(sizeof(struct kvec)*num_pages, GFP_KERNEL);
+
+	P9_DPRINTK(P9_DEBUG_VFS, "%d pages\n", num_pages);
+
+	if (!kv)
+		return -ENOMEM;
+
+	if (list_empty(page_list))
+		goto free_vec;
+
+	pagevec_init(&lru_pvec, 0);
+
+	fid = file->private_data;
+	tmp_page = list_entry(page_list->prev, struct page, lru);
+	offset = (loff_t)tmp_page->index << PAGE_CACHE_SHIFT;
+
+	list_for_each_entry_reverse(tmp_page, page_list, lru) {
+		BUG_ON(count > num_pages);
+		if (add_to_page_cache(tmp_page, mapping,
+					tmp_page->index, GFP_KERNEL)) {
+			page_cache_release(tmp_page);
+			continue;
+		}
+
+		kv[count].iov_base = kmap(tmp_page);
+		kv[count].iov_len = PAGE_CACHE_SIZE;
+		count++;
+	}
+
+	read_size = count * PAGE_CACHE_SIZE;
+	if (!read_size)
+		goto cleanup;
+
+	retval = p9_client_readv(fid, kv, offset, count);
+
+cleanup:
+	list_for_each_safe(p, n, page_list) {
+		tmp_page = list_entry(p, struct page, lru);
+		list_del(&tmp_page->lru);
+		if (!pagevec_add(&lru_pvec, tmp_page))
+			__pagevec_lru_add(&lru_pvec);
+		kunmap(tmp_page);
+		flush_dcache_page(tmp_page);
+		SetPageUptodate(tmp_page);
+		unlock_page(tmp_page);
+	}
+	pagevec_lru_add(&lru_pvec);
+
+free_vec:
+	kfree(kv);
+	return retval;
+}
+
 const struct address_space_operations v9fs_addr_operations = {
       .readpage = v9fs_vfs_readpage,
+      .readpages = v9fs_vfs_readpages,
 };
diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index 9b9221a..6f17d0a 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -67,8 +67,7 @@ int p9_client_fcreate(struct p9_fid *fid, char *name, u32 perm, int mode,
 							char *extension);
 int p9_client_clunk(struct p9_fid *fid);
 int p9_client_remove(struct p9_fid *fid);
-int p9_client_read(struct p9_fid *fid, char *data, u64 offset, u32 count);
-int p9_client_readn(struct p9_fid *fid, char *data, u64 offset, u32 count);
+int p9_client_readv(struct p9_fid *fid, struct kvec *kv, u64 offset, u32 count);
 int p9_client_write(struct p9_fid *fid, char *data, u64 offset, u32 count);
 int p9_client_uread(struct p9_fid *fid, char __user *data, u64 offset,
 								u32 count);
diff --git a/net/9p/client.c b/net/9p/client.c
index d83cc12..0e852e4 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -29,6 +29,7 @@
 #include <linux/mutex.h>
 #include <linux/sched.h>
 #include <linux/uaccess.h>
+#include <linux/uio.h>
 #include <net/9p/9p.h>
 #include <net/9p/transport.h>
 #include <net/9p/conn.h>
@@ -455,11 +456,59 @@ done:
 }
 EXPORT_SYMBOL(p9_client_remove);
 
-int p9_client_read(struct p9_fid *fid, char *data, u64 offset, u32 count)
+struct kvec_pos {
+	u32 num;
+	u32 offset;
+};
+
+/* fill a kvec from a buffer and zero-fill any extra kvec buffers */
+static void
+fill_kvec(struct kvec *kv, u32 kvc, struct kvec_pos *kp, void *buf, u32 n)
+{
+	int count;
+
+	while (kp->num < kvc) {
+		count = kv[kp->num].iov_len - kp->offset;
+		if (count <= 0) {
+			kp->num++;
+			kp->offset = 0;
+			continue;
+		}
+
+		if (n) {
+			if (count > n)
+				count = n;
+			memmove(kv[kp->num].iov_base+kp->offset, buf, count);
+			n = n - count;
+		} else
+			memset(kv[kp->num].iov_base+kp->offset, 0, count);
+
+		kp->offset += count;
+		if (kp->offset >= kv[kp->num].iov_len) {
+			kp->offset = 0;
+			kp->num++;
+		}
+	}
+}
+
+static size_t kvec_length(const struct kvec *iov, unsigned long nr_segs)
+{
+	unsigned long seg;
+	size_t ret = 0;
+
+	for (seg = 0; seg < nr_segs; seg++)
+		ret += iov[seg].iov_len;
+
+	return ret;
+}
+
+int p9_client_readv(struct p9_fid *fid, struct kvec *kv, u64 offset, u32 kvc)
 {
 	int err, n, rsize, total;
 	struct p9_fcall *tc, *rc;
 	struct p9_client *clnt;
+	struct kvec_pos kvp = {0, 0};
+	u32 count = kvec_length(kv, kvc);
 
 	P9_DPRINTK(P9_DEBUG_9P, "fid %d offset %llu %d\n", fid->fid,
 					(long long unsigned) offset, count);
@@ -491,10 +540,9 @@ int p9_client_read(struct p9_fid *fid, char *data, u64 offset, u32 count)
 		n = rc->params.rread.count;
 		if (n > count)
 			n = count;
+		fill_kvec(kv, kvc, &kvp, rc->params.rread.data, n);
 
-		memmove(data, rc->params.rread.data, n);
 		count -= n;
-		data += n;
 		offset += n;
 		total += n;
 		kfree(tc);
@@ -510,7 +558,7 @@ error:
 	kfree(rc);
 	return err;
 }
-EXPORT_SYMBOL(p9_client_read);
+EXPORT_SYMBOL(p9_client_readv);
 
 int p9_client_write(struct p9_fid *fid, char *data, u64 offset, u32 count)
 {
@@ -683,32 +731,6 @@ error:
 }
 EXPORT_SYMBOL(p9_client_uwrite);
 
-int p9_client_readn(struct p9_fid *fid, char *data, u64 offset, u32 count)
-{
-	int n, total;
-
-	P9_DPRINTK(P9_DEBUG_9P, "fid %d offset %llu count %d\n", fid->fid,
-					(long long unsigned) offset, count);
-	n = 0;
-	total = 0;
-	while (count) {
-		n = p9_client_read(fid, data, offset, count);
-		if (n <= 0)
-			break;
-
-		data += n;
-		offset += n;
-		count -= n;
-		total += n;
-	}
-
-	if (n < 0)
-		total = n;
-
-	return total;
-}
-EXPORT_SYMBOL(p9_client_readn);
-
 struct p9_stat *p9_client_stat(struct p9_fid *fid)
 {
 	int err;
-- 
1.5.3.rc7

