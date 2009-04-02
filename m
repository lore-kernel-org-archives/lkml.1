Return-Path: <linux-kernel-owner+w=401wt.eu-S1765257AbZDBSSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765257AbZDBSSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbZDBSS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:18:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52060 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbZDBSS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:18:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090402165505.GA21859@infradead.org>
References: <20090402165505.GA21859@infradead.org> <200904030100.05741.nickpiggin@yahoo.com.au> <200904030232.59355.nickpiggin@yahoo.com.au> <20090402163712.GA25177@infradead.org> <200904030347.21470.nickpiggin@yahoo.com.au>
To: Christoph Hellwig <hch@infradead.org>
Cc: dhowells@redhat.com, Nick Piggin <nickpiggin@yahoo.com.au>,
       viro@zeniv.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 22/43] CacheFiles: Add a hook to write a single page of data to an inode [ver #46]
Date: Thu, 02 Apr 2009 19:18:11 +0100
Message-ID: <29524.1238696291@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> wrote:

> > I don't think "write_one_page" sounds like a particularly good new
> > API addition.
> 
> I also thing it's not a nice one.  I still haven't seen a really good
> explanation of why it can't just use plain ->write

So, I can apply the attached patch.  It opens a file each time it wants to
write a page and then closes it again, but it's the best way to avoid the
ENFILE problem.  I'm benchmarking it at the moment.

David
---
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
