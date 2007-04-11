Return-Path: <linux-kernel-owner+w=401wt.eu-S1030762AbXDKDjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030762AbXDKDjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 23:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030769AbXDKDjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 23:39:21 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:15843 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030762AbXDKDjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 23:39:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:in-reply-to:subject;
        b=if3vumNwJlbycXq7TNPrlJX8h/m5beo4HD+hkweZUe+5wOghbRH3Ffkv0wn7rqXtFVWtbBz91W8gcoXMfSvRsXDcYX/1eTRH3+GH+M6LXYyIuJXU/igORkkm5lmbCiHsGjqxyIEZl3yujkkxjA97+Ry1jq9U492cjSOo+zcSPo8=
From: Nate Diller <nate.diller@gmail.com>
To: Andrew Morton <akpm@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Tue, 10 Apr 2007 20:36:00 -0700
Message-Id: <20070411033600.11000.64024.patchbomb.py@localhost>
In-Reply-To: <20070411033600.11000.38285.patchbomb.py@localhost>
Subject: [PATCH 10/13] reiser4: use zero_user_page
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use zero_user_page() instead of open-coding it.  Also replace the (mostly)
redundant zero_page() function.

Signed-off-by: Nate Diller <nate.diller@gmail.com>

--- 

diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/reiser4/plugin/file/cryptcompress.c linux-2.6.21-rc6-mm1-test/fs/reiser4/plugin/file/cryptcompress.c
--- linux-2.6.21-rc6-mm1/fs/reiser4/plugin/file/cryptcompress.c	2007-04-10 17:15:04.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/reiser4/plugin/file/cryptcompress.c	2007-04-10 18:35:44.000000000 -0700
@@ -1897,7 +1897,6 @@ static int
 write_hole(struct inode *inode, reiser4_cluster_t * clust, loff_t file_off,
 	   loff_t to_file)
 {
-	char *data;
 	int result = 0;
 	unsigned cl_off, cl_count = 0;
 	unsigned to_pg, pg_off;
@@ -1934,10 +1933,7 @@ write_hole(struct inode *inode, reiser4_
 
 		to_pg = min_count(PAGE_CACHE_SIZE - pg_off, cl_count);
 		lock_page(page);
-		data = kmap_atomic(page, KM_USER0);
-		memset(data + pg_off, 0, to_pg);
-		flush_dcache_page(page);
-		kunmap_atomic(data, KM_USER0);
+		zero_user_page(page, pg_off, to_pg);
 		SetPageUptodate(page);
 		unlock_page(page);
 
@@ -2167,7 +2163,6 @@ read_some_cluster_pages(struct inode *in
 
 		if (clust->nr_pages) {
 			int off;
-			char *data;
 			struct page * pg;
 			assert("edward-1419", clust->pages != NULL);
 			pg = clust->pages[clust->nr_pages - 1];
@@ -2175,10 +2170,7 @@ read_some_cluster_pages(struct inode *in
 			off = off_to_pgoff(win->off+win->count+win->delta);
 			if (off) {
 				lock_page(pg);
-				data = kmap_atomic(pg, KM_USER0);
-				memset(data + off, 0, PAGE_CACHE_SIZE - off);
-				flush_dcache_page(pg);
-				kunmap_atomic(data, KM_USER0);
+				zero_user_page(pg, off, PAGE_CACHE_SIZE - off);
 				unlock_page(pg);
 			}
 		}
@@ -2217,20 +2209,15 @@ read_some_cluster_pages(struct inode *in
 		    (count_to_nrpages(inode->i_size) <= pg->index)) {
 			/* .. and appended,
 			   so set zeroes to the rest */
-			char *data;
 			int offset;
 			lock_page(pg);
-			data = kmap_atomic(pg, KM_USER0);
-
 			assert("edward-1260",
 			       count_to_nrpages(win->off + win->count +
 						win->delta) - 1 == i);
 
 			offset =
 			    off_to_pgoff(win->off + win->count + win->delta);
-			memset(data + offset, 0, PAGE_CACHE_SIZE - offset);
-			flush_dcache_page(pg);
-			kunmap_atomic(data, KM_USER0);
+			zero_user_page(pg, offset, PAGE_CACHE_SIZE - offset);
 			unlock_page(pg);
 			/* still not uptodate */
 			break;
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/reiser4/plugin/file/file.c linux-2.6.21-rc6-mm1-test/fs/reiser4/plugin/file/file.c
--- linux-2.6.21-rc6-mm1/fs/reiser4/plugin/file/file.c	2007-04-10 17:15:04.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/reiser4/plugin/file/file.c	2007-04-10 18:35:44.000000000 -0700
@@ -433,7 +433,6 @@ static int shorten_file(struct inode *in
 	struct page *page;
 	int padd_from;
 	unsigned long index;
-	char *kaddr;
 	unix_file_info_t *uf_info;
 
 	/*
@@ -523,10 +522,7 @@ static int shorten_file(struct inode *in
 
 	lock_page(page);
 	assert("vs-1066", PageLocked(page));
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + padd_from, 0, PAGE_CACHE_SIZE - padd_from);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	zero_user_page(page, padd_from, PAGE_CACHE_SIZE - padd_from);
 	unlock_page(page);
 	page_cache_release(page);
 	/* the below does up(sbinfo->delete_mutex). Do not get confused */
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/reiser4/plugin/item/ctail.c linux-2.6.21-rc6-mm1-test/fs/reiser4/plugin/item/ctail.c
--- linux-2.6.21-rc6-mm1/fs/reiser4/plugin/item/ctail.c	2007-04-10 17:15:04.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/reiser4/plugin/item/ctail.c	2007-04-10 18:35:44.000000000 -0700
@@ -627,11 +627,7 @@ int do_readpage_ctail(struct inode * ino
 #endif
 	case FAKE_DISK_CLUSTER:
 		/* fill the page by zeroes */
-		data = kmap_atomic(page, KM_USER0);
-
-		memset(data, 0, PAGE_CACHE_SIZE);
-		flush_dcache_page(page);
-		kunmap_atomic(data, KM_USER0);
+		zero_user_page(page, 0, PAGE_CACHE_SIZE);
 		SetPageUptodate(page);
 		break;
 	case PREP_DISK_CLUSTER:
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/reiser4/plugin/item/extent_file_ops.c linux-2.6.21-rc6-mm1-test/fs/reiser4/plugin/item/extent_file_ops.c
--- linux-2.6.21-rc6-mm1/fs/reiser4/plugin/item/extent_file_ops.c	2007-04-10 18:05:52.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/reiser4/plugin/item/extent_file_ops.c	2007-04-10 18:35:44.000000000 -0700
@@ -1083,17 +1083,6 @@ ssize_t reiser4_write_extent(struct file
 	return (count - left) ? (count - left) : -EFAULT;
 }
 
-static inline void zero_page(struct page *page)
-{
-	char *kaddr = kmap_atomic(page, KM_USER0);
-
-	memset(kaddr, 0, PAGE_CACHE_SIZE);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
-	SetPageUptodate(page);
-	unlock_page(page);
-}
-
 int reiser4_do_readpage_extent(reiser4_extent * ext, reiser4_block_nr pos,
 			       struct page *page)
 {
@@ -1115,7 +1104,9 @@ int reiser4_do_readpage_extent(reiser4_e
 		 */
 		j = jfind(mapping, index);
 		if (j == NULL) {
-			zero_page(page);
+			zero_user_page(page, 0, PAGE_CACHE_SIZE);
+			SetPageUptodate(page);
+			unlock_page(page);
 			return 0;
 		}
 		spin_lock_jnode(j);
@@ -1128,7 +1119,9 @@ int reiser4_do_readpage_extent(reiser4_e
 		block = *jnode_get_io_block(j);
 		spin_unlock_jnode(j);
 		if (block == 0) {
-			zero_page(page);
+			zero_user_page(page, 0, PAGE_CACHE_SIZE);
+			SetPageUptodate(page);
+			unlock_page(page);
 			jput(j);
 			return 0;
 		}
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/reiser4/plugin/item/tail.c linux-2.6.21-rc6-mm1-test/fs/reiser4/plugin/item/tail.c
--- linux-2.6.21-rc6-mm1/fs/reiser4/plugin/item/tail.c	2007-04-10 17:15:04.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/reiser4/plugin/item/tail.c	2007-04-10 18:35:44.000000000 -0700
@@ -391,12 +391,8 @@ static int do_readpage_tail(uf_coord_t *
 	}
 
  done:
-	if (mapped != PAGE_CACHE_SIZE) {
-		pagedata = kmap_atomic(page, KM_USER0);
-		memset(pagedata + mapped, 0, PAGE_CACHE_SIZE - mapped);
-		flush_dcache_page(page);
-		kunmap_atomic(pagedata, KM_USER0);
-	}
+	if (mapped != PAGE_CACHE_SIZE)
+		zero_user_page(page, mapped, PAGE_CACHE_SIZE - mapped);
 	SetPageUptodate(page);
  out_unlock_page:
 	unlock_page(page);
