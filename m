Return-Path: <linux-kernel-owner+w=401wt.eu-S1761937AbZDCJmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761937AbZDCJmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 05:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761214AbZDCJly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 05:41:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43346 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274AbZDCJlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 05:41:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/4] CacheFiles: Use the ->write() file op rather than a
	special kernel aop
To: nickpiggin@yahoo.com.au, hch@infradead.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Date: Fri, 03 Apr 2009 10:41:38 +0100
Message-ID: <20090403094138.9510.80681.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make CacheFiles use the ->write() file operation rather than a special kernel
address space operation optimised for writing whole pages at page boundaries.

This reverts the patch:

	CacheFiles: Add a hook to write a single page of data to an inode

	Add an address space operation to write one single page of data to an
	inode at a page-aligned location (thus permitting the implementation to
	be highly optimised).  The data source is a single page.

	This is used by CacheFiles to store the contents of netfs pages into
	their backing file pages.

	Supply a generic implementation for this that uses the write_begin()
	and write_end() address_space operations to bind a copy directly into
	the page cache.

	Hook the Ext2 and Ext3 operations to the generic implementation.

And then opens the target file for each write, calls ->write() and then
fput()'s the file.  The file has to be released, rather than being cached for
multiple uses, as caching it is liable to cause ENFILE errors to start cropping
up when a large tar job is run on a netfs.  Optimisation may be possible to
write several pages to the same file in one go, thus reducing the amount of
dentry_open()/fput() calls required.

Despite executing a fair bit more code, this appears to perform much better
than use of the write_one_page() address space op.  There are two possible
reasons for this:

 (1) ->write() is doing some scheduling stuff that write_one_page() is not.

 (2) fput() is doing some scheduling stuff, probably by way of the ->release()
     file op.

Whether the cache would still perform better under a real load with this patch
is hard to measure.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/cachefiles/namei.c |    3 +--
 fs/cachefiles/rdwr.c  |   42 ++++++++++++++++++++++++++++++++++--------
 2 files changed, 35 insertions(+), 10 deletions(-)


diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index 83b1988..4ce818a 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -446,8 +446,7 @@ lookup_again:
 
 			ret = -EPERM;
 			aops = object->dentry->d_inode->i_mapping->a_ops;
-			if (!aops->bmap ||
-			    !aops->write_one_page)
+			if (!aops->bmap)
 				goto check_error;
 
 			object->backer = object->dentry;
diff --git a/fs/cachefiles/rdwr.c b/fs/cachefiles/rdwr.c
index 84bb8b7..a69787e 100644
--- a/fs/cachefiles/rdwr.c
+++ b/fs/cachefiles/rdwr.c
@@ -9,6 +9,8 @@
  * 2 of the Licence, or (at your option) any later version.
  */
 
+#include <linux/mount.h>
+#include <linux/file.h>
 #include "internal.h"
 
 /*
@@ -796,7 +798,11 @@ int cachefiles_allocate_pages(struct fscache_retrieval *op,
 int cachefiles_write_page(struct fscache_storage *op, struct page *page)
 {
 	struct cachefiles_object *object;
-	struct address_space *mapping;
+	struct cachefiles_cache *cache;
+	mm_segment_t old_fs;
+	struct file *file;
+	loff_t pos;
+	void *data;
 	int ret;
 
 	ASSERT(op != NULL);
@@ -814,13 +820,33 @@ int cachefiles_write_page(struct fscache_storage *op, struct page *page)
 
 	ASSERT(S_ISREG(object->backer->d_inode->i_mode));
 
-	/* copy the page to ext3 and let it store it in its own time */
-	mapping = object->backer->d_inode->i_mapping;
-	ret = -EIO;
-	if (mapping->a_ops->write_one_page) {
-		ret = mapping->a_ops->write_one_page(mapping, page->index,
-						     page);
-		_debug("write_one_page -> %d", ret);
+	cache = container_of(object->fscache.cache,
+			     struct cachefiles_cache, cache);
+
+	/* write the page to the backing filesystem and let it store it in its
+	 * own time */
+	dget(object->backer);
+	mntget(cache->mnt);
+	file = dentry_open(object->backer, cache->mnt, O_RDWR,
+			   cache->cache_cred);
+	if (IS_ERR(file)) {
+		ret = PTR_ERR(file);
+	} else {
+		ret = -EIO;
+		if (file->f_op->write) {
+			pos = (loff_t) page->index << PAGE_SHIFT;
+			data = kmap(page);
+			old_fs = get_fs();
+			set_fs(KERNEL_DS);
+			ret = file->f_op->write(
+				file, (const void __user *) data, PAGE_SIZE,
+				&pos);
+			set_fs(old_fs);
+			kunmap(page);
+			if (ret != PAGE_SIZE)
+				ret = -EIO;
+		}
+		fput(file);
 	}
 
 	if (ret < 0) {

