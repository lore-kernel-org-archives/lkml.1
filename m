Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbZFVI6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbZFVI6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 04:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbZFVI6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 04:58:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57384 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827AbZFVI6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 04:58:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.DEB.2.01.0906211926080.6439@bogon>
References: <alpine.DEB.2.01.0906211926080.6439@bogon>
To: Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>
Cc: dhowells@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-cachefs] CacheFiles: Readpage failed on backing file
Date: Mon, 22 Jun 2009 09:58:18 +0100
Message-ID: <6950.1245661098@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Kujau <lists@nerdbynature.de> wrote:

> [  399.332346]  [<ffffffff810da03a>] ? ext3_truncate+0x26a/0x9e0

Can you try the attached patch, please?

David
---
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] CacheFiles: Don't write a full page if there's only a partial page to cache

cachefiles_write_page() writes a full page to the backing file for the last
page of the netfs file, even if the netfs file's last page is only a partial
page.

This causes the EOF on the backing file to be extended beyond the EOF of the
netfs, and thus the backing file will be truncated by cachefiles_attr_changed()
called from cachefiles_lookup_object().

So we need to limit the write we make to the backing file on that last page
such that it doesn't push the EOF too far.


Also, if a backing file that has a partial page at the end is expanded, we
discard the partial page and refetch it on the basis that we then have a hole
in the file with invalid data, and should the power go out...  A better way to
deal with this could be to record a note that the partial page contains invalid
data until the correct data is written into it.

This isn't a problem for netfs's that discard the whole backing file if the
file size changes (such as NFS).

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/cachefiles/interface.c     |   20 +++++++++++++++++---
 fs/cachefiles/rdwr.c          |   23 +++++++++++++++++++----
 include/linux/fscache-cache.h |    3 +++
 3 files changed, 39 insertions(+), 7 deletions(-)


diff --git a/fs/cachefiles/interface.c b/fs/cachefiles/interface.c
index 431accd..919a7b6 100644
--- a/fs/cachefiles/interface.c
+++ b/fs/cachefiles/interface.c
@@ -403,12 +403,26 @@ static int cachefiles_attr_changed(struct fscache_object *_object)
 	if (oi_size == ni_size)
 		return 0;
 
-	newattrs.ia_size = ni_size;
-	newattrs.ia_valid = ATTR_SIZE;
-
 	cachefiles_begin_secure(cache, &saved_cred);
 	mutex_lock(&object->backer->d_inode->i_mutex);
+
+	/* if there's an extension to a partial page at the end of the backing
+	 * file, we need to discard the partial page so that we pick up new
+	 * data after it */
+	if (oi_size & ~PAGE_MASK && ni_size > oi_size) {
+		_debug("discard tail %llx", oi_size);
+		newattrs.ia_valid = ATTR_SIZE;
+		newattrs.ia_size = oi_size & PAGE_MASK;
+		ret = notify_change(object->backer, &newattrs);
+		if (ret < 0)
+			goto truncate_failed;
+	}
+
+	newattrs.ia_valid = ATTR_SIZE;
+	newattrs.ia_size = ni_size;
 	ret = notify_change(object->backer, &newattrs);
+
+truncate_failed:
 	mutex_unlock(&object->backer->d_inode->i_mutex);
 	cachefiles_end_secure(cache, saved_cred);
 
diff --git a/fs/cachefiles/rdwr.c b/fs/cachefiles/rdwr.c
index a69787e..86639c1 100644
--- a/fs/cachefiles/rdwr.c
+++ b/fs/cachefiles/rdwr.c
@@ -801,7 +801,8 @@ int cachefiles_write_page(struct fscache_storage *op, struct page *page)
 	struct cachefiles_cache *cache;
 	mm_segment_t old_fs;
 	struct file *file;
-	loff_t pos;
+	loff_t pos, eof;
+	size_t len;
 	void *data;
 	int ret;
 
@@ -835,15 +836,29 @@ int cachefiles_write_page(struct fscache_storage *op, struct page *page)
 		ret = -EIO;
 		if (file->f_op->write) {
 			pos = (loff_t) page->index << PAGE_SHIFT;
+
+			/* we mustn't write more data than we have, so we have
+			 * to beware of a partial page at EOF */
+			eof = object->fscache.store_limit_l;
+			len = PAGE_SIZE;
+			if (eof & ~PAGE_MASK) {
+				ASSERTCMP(pos, <, eof);
+				if (eof - pos < PAGE_SIZE) {
+					_debug("cut short %llx to %llx",
+					       pos, eof);
+					len = eof - pos;
+					ASSERTCMP(pos + len, ==, eof);
+				}
+			}
+
 			data = kmap(page);
 			old_fs = get_fs();
 			set_fs(KERNEL_DS);
 			ret = file->f_op->write(
-				file, (const void __user *) data, PAGE_SIZE,
-				&pos);
+				file, (const void __user *) data, len, &pos);
 			set_fs(old_fs);
 			kunmap(page);
-			if (ret != PAGE_SIZE)
+			if (ret != len)
 				ret = -EIO;
 		}
 		fput(file);
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index 84d3532..97229be 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -374,6 +374,7 @@ struct fscache_object {
 	struct list_head	dep_link;	/* link in parent's dependents list */
 	struct list_head	pending_ops;	/* unstarted operations on this object */
 	pgoff_t			store_limit;	/* current storage limit */
+	loff_t			store_limit_l;	/* current storage limit */
 };
 
 extern const char *fscache_object_states[];
@@ -414,6 +415,7 @@ void fscache_object_init(struct fscache_object *object,
 	object->events = object->event_mask = 0;
 	object->flags = 0;
 	object->store_limit = 0;
+	object->store_limit_l = 0;
 	object->cache = cache;
 	object->cookie = cookie;
 	object->parent = NULL;
@@ -460,6 +462,7 @@ static inline void fscache_object_lookup_error(struct fscache_object *object)
 static inline
 void fscache_set_store_limit(struct fscache_object *object, loff_t i_size)
 {
+	object->store_limit_l = i_size;
 	object->store_limit = i_size >> PAGE_SHIFT;
 	if (i_size & ~PAGE_MASK)
 		object->store_limit++;
