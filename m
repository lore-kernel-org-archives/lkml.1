Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbZISWpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbZISWpY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 18:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbZISWpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 18:45:23 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:63436 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbZISWpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 18:45:21 -0400
From: Abhishek Kulkarni <adkulkar@umail.iu.edu>
To: linux-kernel@vger.kernel.org
Cc: v9fs-developer@lists.sourceforge.net
Subject: [PATCH 1/2] 9p: Add fscache support to 9p
Date: Sat, 19 Sep 2009 16:44:42 -0600
Message-Id: <1253400283-2575-1-git-send-email-adkulkar@umail.iu.edu>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a persistent, read-only caching facility for
9p clients using the FS-Cache caching backend.

When the fscache facility is enabled, each inode is associated
with a corresponding vcookie which is an index into the FS-Cache
indexing tree. The FS-Cache indexing tree is indexed at 3 levels:
- session object associated with each mount.
- inode/vcookie
- actual data (pages)

A cache tag is chosen randomly for each session. These tags can
be read off /sys/fs/9p/caches and can be passed as a mount-time
parameter to re-attach to the specified caching session.

Signed-off-by: Abhishek Kulkarni <adkulkar@umail.iu.edu>
---
 fs/9p/Kconfig       |    9 +
 fs/9p/Makefile      |    3 +-
 fs/9p/cache.c       |  473 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/9p/cache.h       |  175 +++++++++++++++++++
 fs/9p/v9fs.c        |  191 ++++++++++++++++++---
 fs/9p/v9fs.h        |   13 +-
 fs/9p/v9fs_vfs.h    |    6 +
 fs/9p/vfs_addr.c    |   88 ++++++++++-
 fs/9p/vfs_file.c    |   10 +-
 fs/9p/vfs_inode.c   |   56 ++++++-
 fs/9p/vfs_super.c   |   16 +--
 include/net/9p/9p.h |    3 +
 12 files changed, 1001 insertions(+), 42 deletions(-)
 create mode 100644 fs/9p/cache.c
 create mode 100644 fs/9p/cache.h

diff --git a/fs/9p/Kconfig b/fs/9p/Kconfig
index 74e0723..7952337 100644
--- a/fs/9p/Kconfig
+++ b/fs/9p/Kconfig
@@ -8,3 +8,12 @@ config 9P_FS
 	  See <http://v9fs.sf.net> for more information.
 
 	  If unsure, say N.
+
+config 9P_FSCACHE
+	bool "Enable 9P client caching support (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	depends on 9P_FS=m && FSCACHE || 9P_FS=y && FSCACHE=y
+	help
+	  Choose Y here to enable persistent, read-only local
+	  caching support for 9p clients using FS-Cache
+
diff --git a/fs/9p/Makefile b/fs/9p/Makefile
index bc7f0d1..1a940ec 100644
--- a/fs/9p/Makefile
+++ b/fs/9p/Makefile
@@ -8,5 +8,6 @@ obj-$(CONFIG_9P_FS) := 9p.o
 	vfs_dir.o \
 	vfs_dentry.o \
 	v9fs.o \
-	fid.o \
+	fid.o
 
+9p-$(CONFIG_9P_FSCACHE) += cache.o
diff --git a/fs/9p/cache.c b/fs/9p/cache.c
new file mode 100644
index 0000000..3f4dc0d
--- /dev/null
+++ b/fs/9p/cache.c
@@ -0,0 +1,473 @@
+/*
+ * V9FS cache definitions.
+ *
+ *  Copyright (C) 2009 by Abhishek Kulkarni <adkulkar@umail.iu.edu>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to:
+ *  Free Software Foundation
+ *  51 Franklin Street, Fifth Floor
+ *  Boston, MA  02111-1301  USA
+ *
+ */
+
+#include <linux/jiffies.h>
+#include <linux/file.h>
+#include <linux/stat.h>
+#include <linux/fs.h>
+#include <net/9p/9p.h>
+
+#include "v9fs.h"
+#include "cache.h"
+
+#define CACHETAG_LEN  11
+
+struct kmem_cache *vcookie_cache;
+
+struct fscache_netfs v9fs_cache_netfs = {
+	.name 		= "9p",
+	.version 	= 0,
+};
+
+static void init_once(void *foo)
+{
+	struct v9fs_cookie *vcookie = (struct v9fs_cookie *) foo;
+	vcookie->fscache = NULL;
+	vcookie->qid = NULL;
+	inode_init_once(&vcookie->inode);
+}
+
+/**
+ * v9fs_init_vcookiecache - initialize a cache for vcookies to maintain
+ *			    vcookie to inode mapping
+ *
+ * Returns 0 on success.
+ */
+
+static int v9fs_init_vcookiecache(void)
+{
+	vcookie_cache = kmem_cache_create("vcookie_cache",
+					  sizeof(struct v9fs_cookie),
+					  0, (SLAB_RECLAIM_ACCOUNT|
+					      SLAB_MEM_SPREAD),
+					  init_once);
+	if (!vcookie_cache)
+		return -ENOMEM;
+
+	return 0;
+}
+
+/**
+ * v9fs_destroy_vcookiecache - destroy the cache of vcookies
+ *
+ */
+
+static void v9fs_destroy_vcookiecache(void)
+{
+	kmem_cache_destroy(vcookie_cache);
+}
+
+int __v9fs_cache_register(void)
+{
+	int ret;
+	ret = v9fs_init_vcookiecache();
+	if (ret < 0)
+		return ret;
+
+	return fscache_register_netfs(&v9fs_cache_netfs);
+}
+
+void __v9fs_cache_unregister(void)
+{
+	v9fs_destroy_vcookiecache();
+	fscache_unregister_netfs(&v9fs_cache_netfs);
+}
+
+/**
+ * v9fs_random_cachetag - Generate a random tag to be associated
+ *			  with a new cache session.
+ *
+ * The value of jiffies is used for a fairly randomly cache tag.
+ */
+
+static
+int v9fs_random_cachetag(struct v9fs_session_info *v9ses)
+{
+	v9ses->cachetag = kmalloc(CACHETAG_LEN, GFP_KERNEL);
+	if (!v9ses->cachetag)
+		return -ENOMEM;
+
+	return scnprintf(v9ses->cachetag, CACHETAG_LEN, "%lu", jiffies);
+}
+
+static uint16_t v9fs_cache_session_get_key(const void *cookie_netfs_data,
+					   void *buffer, uint16_t bufmax)
+{
+	struct v9fs_session_info *v9ses;
+	uint16_t klen = 0;
+
+	v9ses = (struct v9fs_session_info *)cookie_netfs_data;
+	P9_DPRINTK(P9_DEBUG_FSC, "session %p buf %p size %u", v9ses,
+		   buffer, bufmax);
+
+	if (v9ses->cachetag)
+		klen = strlen(v9ses->cachetag);
+
+	if (klen > bufmax)
+		return 0;
+
+	memcpy(buffer, v9ses->cachetag, klen);
+	P9_DPRINTK(P9_DEBUG_FSC, "cache session tag %s", v9ses->cachetag);
+	return klen;
+}
+
+const struct fscache_cookie_def v9fs_cache_session_index_def = {
+	.name 		= "9P.session",
+	.type 		= FSCACHE_COOKIE_TYPE_INDEX,
+	.get_key 	= v9fs_cache_session_get_key,
+};
+
+void v9fs_cache_session_get_cookie(struct v9fs_session_info *v9ses)
+{
+	/* If no cache session tag was specified, we generate a random one. */
+	if (!v9ses->cachetag)
+		v9fs_random_cachetag(v9ses);
+
+	v9ses->fscache = fscache_acquire_cookie(v9fs_cache_netfs.primary_index,
+						&v9fs_cache_session_index_def,
+						v9ses);
+	P9_DPRINTK(P9_DEBUG_FSC, "session %p get cookie %p", v9ses,
+		   v9ses->fscache);
+}
+
+void v9fs_cache_session_put_cookie(struct v9fs_session_info *v9ses)
+{
+	P9_DPRINTK(P9_DEBUG_FSC, "session %p put cookie %p", v9ses,
+		   v9ses->fscache);
+	fscache_relinquish_cookie(v9ses->fscache, 0);
+	v9ses->fscache = NULL;
+}
+
+
+static uint16_t v9fs_cache_inode_get_key(const void *cookie_netfs_data,
+					 void *buffer, uint16_t bufmax)
+{
+	const struct v9fs_cookie *vcookie = cookie_netfs_data;
+	memcpy(buffer, &vcookie->qid->path, sizeof(vcookie->qid->path));
+
+	P9_DPRINTK(P9_DEBUG_FSC, "inode %p get key %llu", &vcookie->inode,
+		   vcookie->qid->path);
+	return sizeof(vcookie->qid->path);
+}
+
+static void v9fs_cache_inode_get_attr(const void *cookie_netfs_data,
+				      uint64_t *size)
+{
+	const struct v9fs_cookie *vcookie = cookie_netfs_data;
+	*size = i_size_read(&vcookie->inode);
+
+	P9_DPRINTK(P9_DEBUG_FSC, "inode %p get attr %llu", &vcookie->inode,
+		   *size);
+}
+
+static uint16_t v9fs_cache_inode_get_aux(const void *cookie_netfs_data,
+					 void *buffer, uint16_t buflen)
+{
+	const struct v9fs_cookie *vcookie = cookie_netfs_data;
+	memcpy(buffer, &vcookie->qid->version, sizeof(vcookie->qid->version));
+
+	P9_DPRINTK(P9_DEBUG_FSC, "inode %p get aux %u", &vcookie->inode,
+		   vcookie->qid->version);
+	return sizeof(vcookie->qid->version);
+}
+
+static enum
+fscache_checkaux v9fs_cache_inode_check_aux(void *cookie_netfs_data,
+					    const void *buffer,
+					    uint16_t buflen)
+{
+	const struct v9fs_cookie *vcookie = cookie_netfs_data;
+
+	if (buflen != sizeof(vcookie->qid->version))
+		return FSCACHE_CHECKAUX_OBSOLETE;
+
+	if (memcmp(buffer, &vcookie->qid->version,
+		   sizeof(vcookie->qid->version)))
+		return FSCACHE_CHECKAUX_OBSOLETE;
+
+	return FSCACHE_CHECKAUX_OKAY;
+}
+
+static void v9fs_cache_inode_now_uncached(void *cookie_netfs_data)
+{
+	struct v9fs_cookie *vcookie = cookie_netfs_data;
+	struct pagevec pvec;
+	pgoff_t first;
+	int loop, nr_pages;
+
+	pagevec_init(&pvec, 0);
+	first = 0;
+
+	for (;;) {
+		nr_pages = pagevec_lookup(&pvec, vcookie->inode.i_mapping,
+					  first,
+					  PAGEVEC_SIZE - pagevec_count(&pvec));
+		if (!nr_pages)
+			break;
+
+		for (loop = 0; loop < nr_pages; loop++)
+			ClearPageFsCache(pvec.pages[loop]);
+
+		first = pvec.pages[nr_pages - 1]->index + 1;
+
+		pvec.nr = nr_pages;
+		pagevec_release(&pvec);
+		cond_resched();
+	}
+}
+
+const struct fscache_cookie_def v9fs_cache_inode_index_def = {
+	.name		= "9p.inode",
+	.type		= FSCACHE_COOKIE_TYPE_DATAFILE,
+	.get_key	= v9fs_cache_inode_get_key,
+	.get_attr	= v9fs_cache_inode_get_attr,
+	.get_aux	= v9fs_cache_inode_get_aux,
+	.check_aux	= v9fs_cache_inode_check_aux,
+	.now_uncached	= v9fs_cache_inode_now_uncached,
+};
+
+void v9fs_cache_inode_get_cookie(struct inode *inode)
+{
+	struct v9fs_cookie *vcookie;
+	struct v9fs_session_info *v9ses;
+
+	if (!S_ISREG(inode->i_mode))
+		return;
+
+	vcookie = v9fs_inode2cookie(inode);
+	if (vcookie->fscache)
+		return;
+
+	v9ses = v9fs_inode2v9ses(inode);
+	vcookie->fscache = fscache_acquire_cookie(v9ses->fscache,
+						  &v9fs_cache_inode_index_def,
+						  vcookie);
+
+	P9_DPRINTK(P9_DEBUG_FSC, "inode %p get cookie %p", inode,
+		   vcookie->fscache);
+}
+
+void v9fs_cache_inode_put_cookie(struct inode *inode)
+{
+	struct v9fs_cookie *vcookie = v9fs_inode2cookie(inode);
+
+	if (!vcookie->fscache)
+		return;
+	P9_DPRINTK(P9_DEBUG_FSC, "inode %p put cookie %p", inode,
+		   vcookie->fscache);
+
+	fscache_relinquish_cookie(vcookie->fscache, 0);
+	vcookie->fscache = NULL;
+}
+
+void v9fs_cache_inode_flush_cookie(struct inode *inode)
+{
+	struct v9fs_cookie *vcookie = v9fs_inode2cookie(inode);
+
+	if (!vcookie->fscache)
+		return;
+	P9_DPRINTK(P9_DEBUG_FSC, "inode %p flush cookie %p", inode,
+		   vcookie->fscache);
+
+	fscache_relinquish_cookie(vcookie->fscache, 1);
+	vcookie->fscache = NULL;
+}
+
+void v9fs_cache_inode_set_cookie(struct inode *inode, struct file *filp)
+{
+	struct v9fs_cookie *vcookie = v9fs_inode2cookie(inode);
+	struct p9_fid *fid;
+
+	if (!vcookie->fscache)
+		return;
+
+	spin_lock(&vcookie->lock);
+	fid = filp->private_data;
+	if ((filp->f_flags & O_ACCMODE) != O_RDONLY)
+		v9fs_cache_inode_flush_cookie(inode);
+	else
+		v9fs_cache_inode_get_cookie(inode);
+
+	spin_unlock(&vcookie->lock);
+}
+
+void v9fs_cache_inode_reset_cookie(struct inode *inode)
+{
+	struct v9fs_cookie *vcookie = v9fs_inode2cookie(inode);
+	struct v9fs_session_info *v9ses;
+	struct fscache_cookie *old;
+
+	if (!vcookie->fscache)
+		return;
+
+	old = vcookie->fscache;
+
+	spin_lock(&vcookie->lock);
+	fscache_relinquish_cookie(vcookie->fscache, 1);
+
+	v9ses = v9fs_inode2v9ses(inode);
+	vcookie->fscache = fscache_acquire_cookie(v9ses->fscache,
+						  &v9fs_cache_inode_index_def,
+						  vcookie);
+
+	P9_DPRINTK(P9_DEBUG_FSC, "inode %p revalidating cookie old %p new %p",
+		   inode, old, vcookie->fscache);
+
+	spin_unlock(&vcookie->lock);
+}
+
+int __v9fs_fscache_release_page(struct page *page, gfp_t gfp)
+{
+	struct inode *inode = page->mapping->host;
+	struct v9fs_cookie *vcookie = v9fs_inode2cookie(inode);
+
+	BUG_ON(!vcookie->fscache);
+
+	if (PageFsCache(page)) {
+		if (fscache_check_page_write(vcookie->fscache, page)) {
+			if (!(gfp & __GFP_WAIT))
+				return 0;
+			fscache_wait_on_page_write(vcookie->fscache, page);
+		}
+
+		fscache_uncache_page(vcookie->fscache, page);
+		ClearPageFsCache(page);
+	}
+
+	return 1;
+}
+
+void __v9fs_fscache_invalidate_page(struct page *page)
+{
+	struct inode *inode = page->mapping->host;
+	struct v9fs_cookie *vcookie = v9fs_inode2cookie(inode);
+
+	BUG_ON(!vcookie->fscache);
+
+	if (PageFsCache(page)) {
+		fscache_wait_on_page_write(vcookie->fscache, page);
+		BUG_ON(!PageLocked(page));
+		fscache_uncache_page(vcookie->fscache, page);
+		ClearPageFsCache(page);
+	}
+}
+
+static void v9fs_vfs_readpage_complete(struct page *page, void *data,
+				       int error)
+{
+	if (!error)
+		SetPageUptodate(page);
+
+	unlock_page(page);
+}
+
+/**
+ * __v9fs_readpage_from_fscache - read a page from cache
+ *
+ * Returns 0 if the pages are in cache and a BIO is submitted,
+ * 1 if the pages are not in cache and -error otherwise.
+ */
+
+int __v9fs_readpage_from_fscache(struct inode *inode, struct page *page)
+{
+	int ret;
+	const struct v9fs_cookie *vcookie = v9fs_inode2cookie(inode);
+
+	P9_DPRINTK(P9_DEBUG_FSC, "inode %p page %p", inode, page);
+	if (!vcookie->fscache)
+		return -ENOBUFS;
+
+	ret = fscache_read_or_alloc_page(vcookie->fscache,
+					 page,
+					 v9fs_vfs_readpage_complete,
+					 NULL,
+					 GFP_KERNEL);
+	switch (ret) {
+	case -ENOBUFS:
+	case -ENODATA:
+		P9_DPRINTK(P9_DEBUG_FSC, "page/inode not in cache %d", ret);
+		return 1;
+	case 0:
+		P9_DPRINTK(P9_DEBUG_FSC, "BIO submitted");
+		return ret;
+	default:
+		P9_DPRINTK(P9_DEBUG_FSC, "ret %d", ret);
+		return ret;
+	}
+}
+
+/**
+ * __v9fs_readpages_from_fscache - read multiple pages from cache
+ *
+ * Returns 0 if the pages are in cache and a BIO is submitted,
+ * 1 if the pages are not in cache and -error otherwise.
+ */
+
+int __v9fs_readpages_from_fscache(struct inode *inode,
+				  struct address_space *mapping,
+				  struct list_head *pages,
+				  unsigned *nr_pages)
+{
+	int ret;
+	const struct v9fs_cookie *vcookie = v9fs_inode2cookie(inode);
+
+	P9_DPRINTK(P9_DEBUG_FSC, "inode %p pages %u", inode, *nr_pages);
+	if (!vcookie->fscache)
+		return -ENOBUFS;
+
+	ret = fscache_read_or_alloc_pages(vcookie->fscache,
+					  mapping, pages, nr_pages,
+					  v9fs_vfs_readpage_complete,
+					  NULL,
+					  mapping_gfp_mask(mapping));
+	switch (ret) {
+	case -ENOBUFS:
+	case -ENODATA:
+		P9_DPRINTK(P9_DEBUG_FSC, "pages/inodes not in cache %d", ret);
+		return 1;
+	case 0:
+		BUG_ON(!list_empty(pages));
+		BUG_ON(*nr_pages != 0);
+		P9_DPRINTK(P9_DEBUG_FSC, "BIO submitted");
+		return ret;
+	default:
+		P9_DPRINTK(P9_DEBUG_FSC, "ret %d", ret);
+		return ret;
+	}
+}
+
+/**
+ * __v9fs_readpage_to_fscache - write a page to the cache
+ *
+ */
+
+void __v9fs_readpage_to_fscache(struct inode *inode, struct page *page)
+{
+	int ret;
+	const struct v9fs_cookie *vcookie = v9fs_inode2cookie(inode);
+
+	P9_DPRINTK(P9_DEBUG_FSC, "inode %p page %p", inode, page);
+	ret = fscache_write_page(vcookie->fscache, page, GFP_KERNEL);
+	P9_DPRINTK(P9_DEBUG_FSC, "ret =  %d", ret);
+	if (ret != 0)
+		v9fs_uncache_page(inode, page);
+}
diff --git a/fs/9p/cache.h b/fs/9p/cache.h
new file mode 100644
index 0000000..c91d161
--- /dev/null
+++ b/fs/9p/cache.h
@@ -0,0 +1,175 @@
+/*
+ * V9FS cache definitions.
+ *
+ *  Copyright (C) 2009 by Abhishek Kulkarni <adkulkar@umail.iu.edu>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to:
+ *  Free Software Foundation
+ *  51 Franklin Street, Fifth Floor
+ *  Boston, MA  02111-1301  USA
+ *
+ */
+
+#ifndef _9P_CACHE_H
+#ifdef CONFIG_9P_FSCACHE
+#include <linux/fscache.h>
+
+extern struct kmem_cache *vcookie_cache;
+
+struct v9fs_cookie {
+	spinlock_t lock;
+	struct inode inode;
+	struct fscache_cookie *fscache;
+	struct p9_qid *qid;
+};
+
+static inline struct v9fs_cookie *v9fs_inode2cookie(const struct inode *inode)
+{
+	return container_of(inode, struct v9fs_cookie, inode);
+}
+
+extern struct fscache_netfs v9fs_cache_netfs;
+extern const struct fscache_cookie_def v9fs_cache_session_index_def;
+extern const struct fscache_cookie_def v9fs_cache_inode_index_def;
+
+void v9fs_cache_session_get_cookie(struct v9fs_session_info *v9ses);
+void v9fs_cache_session_put_cookie(struct v9fs_session_info *v9ses);
+
+void v9fs_cache_inode_get_cookie(struct inode *inode);
+void v9fs_cache_inode_put_cookie(struct inode *inode);
+void v9fs_cache_inode_flush_cookie(struct inode *inode);
+void v9fs_cache_inode_set_cookie(struct inode *inode, struct file *filp);
+void v9fs_cache_inode_reset_cookie(struct inode *inode);
+
+extern int __v9fs_cache_register(void);
+extern void __v9fs_cache_unregister(void);
+
+extern int __v9fs_fscache_release_page(struct page *page, gfp_t gfp);
+extern void __v9fs_fscache_invalidate_page(struct page *page);
+extern int __v9fs_readpage_from_fscache(struct inode *inode,
+					struct page *page);
+extern int __v9fs_readpages_from_fscache(struct inode *inode,
+					 struct address_space *mapping,
+					 struct list_head *pages,
+					 unsigned *nr_pages);
+extern void __v9fs_readpage_to_fscache(struct inode *inode, struct page *page);
+
+
+/**
+ * v9fs_cache_register - Register v9fs file system with the cache
+ */
+static inline int v9fs_cache_register(void)
+{
+	return __v9fs_cache_register();
+}
+
+/**
+ * v9fs_cache_unregister - Unregister v9fs from the cache
+ */
+static inline void v9fs_cache_unregister(void)
+{
+	__v9fs_cache_unregister();
+}
+
+static inline int v9fs_fscache_release_page(struct page *page,
+					    gfp_t gfp)
+{
+	return __v9fs_fscache_release_page(page, gfp);
+}
+
+static inline void v9fs_fscache_invalidate_page(struct page *page)
+{
+	__v9fs_fscache_invalidate_page(page);
+}
+
+static inline int v9fs_readpage_from_fscache(struct inode *inode,
+					     struct page *page)
+{
+	return __v9fs_readpage_from_fscache(inode, page);
+}
+
+static inline int v9fs_readpages_from_fscache(struct inode *inode,
+					      struct address_space *mapping,
+					      struct list_head *pages,
+					      unsigned *nr_pages)
+{
+	return __v9fs_readpages_from_fscache(inode, mapping, pages,
+					     nr_pages);
+}
+
+static inline void v9fs_readpage_to_fscache(struct inode *inode,
+					    struct page *page)
+{
+	if (PageFsCache(page))
+		__v9fs_readpage_to_fscache(inode, page);
+}
+
+static inline void v9fs_uncache_page(struct inode *inode, struct page *page)
+{
+	struct v9fs_cookie *vcookie = v9fs_inode2cookie(inode);
+	fscache_uncache_page(vcookie->fscache, page);
+	BUG_ON(PageFsCache(page));
+}
+
+static inline void v9fs_vcookie_set_qid(struct inode *inode,
+					struct p9_qid *qid)
+{
+	struct v9fs_cookie *vcookie = v9fs_inode2cookie(inode);
+	spin_lock(&vcookie->lock);
+	vcookie->qid = qid;
+	spin_unlock(&vcookie->lock);
+}
+
+#else /* CONFIG_9P_FSCACHE */
+
+static inline int v9fs_cache_register(void)
+{
+	return 1;
+}
+
+static inline void v9fs_cache_unregister(void) {}
+
+static inline int v9fs_fscache_release_page(struct page *page,
+					    gfp_t gfp) {
+	return 1;
+}
+
+static inline void v9fs_fscache_invalidate_page(struct page *page) {}
+
+static inline int v9fs_readpage_from_fscache(struct inode *inode,
+					     struct page *page)
+{
+	return -ENOBUFS;
+}
+
+static inline int v9fs_readpages_from_fscache(struct inode *inode,
+					      struct address_space *mapping,
+					      struct list_head *pages,
+					      unsigned *nr_pages)
+{
+	return -ENOBUFS;
+}
+
+static inline void v9fs_readpage_to_fscache(struct inode *inode,
+					    struct page *page)
+{}
+
+static inline void v9fs_uncache_page(struct inode *inode, struct page *page)
+{}
+
+static inline void v9fs_vcookie_set_qid(struct inode *inode,
+					struct p9_qid *qid)
+{}
+
+#endif /* CONFIG_9P_FSCACHE */
+#endif /* _9P_CACHE_H */
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index f7003cf..f4a5950 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -34,21 +34,25 @@
 #include <net/9p/transport.h>
 #include "v9fs.h"
 #include "v9fs_vfs.h"
+#include "cache.h"
+
+static DEFINE_SPINLOCK(v9fs_sessionlist_lock);
+static LIST_HEAD(v9fs_sessionlist);
 
 /*
-  * Option Parsing (code inspired by NFS code)
-  *  NOTE: each transport will parse its own options
-  */
+ * Option Parsing (code inspired by NFS code)
+ *  NOTE: each transport will parse its own options
+ */
 
 enum {
 	/* Options that take integer arguments */
 	Opt_debug, Opt_dfltuid, Opt_dfltgid, Opt_afid,
 	/* String options */
-	Opt_uname, Opt_remotename, Opt_trans,
+	Opt_uname, Opt_remotename, Opt_trans, Opt_cache, Opt_cachetag,
 	/* Options that take no arguments */
 	Opt_nodevmap,
 	/* Cache options */
-	Opt_cache_loose,
+	Opt_cache_loose, Opt_fscache,
 	/* Access options */
 	Opt_access,
 	/* Error token */
@@ -63,8 +67,10 @@ static const match_table_t tokens = {
 	{Opt_uname, "uname=%s"},
 	{Opt_remotename, "aname=%s"},
 	{Opt_nodevmap, "nodevmap"},
-	{Opt_cache_loose, "cache=loose"},
+	{Opt_cache, "cache=%s"},
 	{Opt_cache_loose, "loose"},
+	{Opt_fscache, "fscache"},
+	{Opt_cachetag, "cachetag=%s"},
 	{Opt_access, "access=%s"},
 	{Opt_err, NULL}
 };
@@ -89,16 +95,16 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
 	v9ses->afid = ~0;
 	v9ses->debug = 0;
 	v9ses->cache = 0;
+#ifdef CONFIG_9P_FSCACHE
+	v9ses->cachetag = NULL;
+#endif
 
 	if (!opts)
 		return 0;
 
 	options = kstrdup(opts, GFP_KERNEL);
-	if (!options) {
-		P9_DPRINTK(P9_DEBUG_ERROR,
-			   "failed to allocate copy of option string\n");
-		return -ENOMEM;
-	}
+	if (!options)
+		goto fail_option_alloc;
 
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token;
@@ -143,16 +149,33 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
 		case Opt_cache_loose:
 			v9ses->cache = CACHE_LOOSE;
 			break;
+		case Opt_fscache:
+			v9ses->cache = CACHE_FSCACHE;
+			break;
+		case Opt_cachetag:
+#ifdef CONFIG_9P_FSCACHE
+			v9ses->cachetag = match_strdup(&args[0]);
+#endif
+			break;
+		case Opt_cache:
+			s = match_strdup(&args[0]);
+			if (!s)
+				goto fail_option_alloc;
+
+			if (strcmp(s, "loose") == 0)
+				v9ses->cache = CACHE_LOOSE;
+			else if (strcmp(s, "fscache") == 0)
+				v9ses->cache = CACHE_FSCACHE;
+			else
+				v9ses->cache = CACHE_NONE;
+			kfree(s);
+			break;
 
 		case Opt_access:
 			s = match_strdup(&args[0]);
-			if (!s) {
-				P9_DPRINTK(P9_DEBUG_ERROR,
-					   "failed to allocate copy"
-					   " of option argument\n");
-				ret = -ENOMEM;
-				break;
-			}
+			if (!s)
+				goto fail_option_alloc;
+
 			v9ses->flags &= ~V9FS_ACCESS_MASK;
 			if (strcmp(s, "user") == 0)
 				v9ses->flags |= V9FS_ACCESS_USER;
@@ -173,6 +196,11 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
 	}
 	kfree(options);
 	return ret;
+
+fail_option_alloc:
+	P9_DPRINTK(P9_DEBUG_ERROR,
+		   "failed to allocate copy of option argument\n");
+	return -ENOMEM;
 }
 
 /**
@@ -249,6 +277,14 @@ struct p9_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
 	else
 		fid->uid = ~0;
 
+#ifdef CONFIG_9P_FSCACHE
+	/* register the session for caching */
+	v9fs_cache_session_get_cookie(v9ses);
+#endif
+
+	spin_lock(&v9fs_sessionlist_lock);
+	list_add(&v9ses->slist, &v9fs_sessionlist);
+	spin_unlock(&v9fs_sessionlist_lock);
 	return fid;
 
 error:
@@ -268,8 +304,16 @@ void v9fs_session_close(struct v9fs_session_info *v9ses)
 		v9ses->clnt = NULL;
 	}
 
+#ifdef CONFIG_9P_FSCACHE
+	v9fs_cache_session_put_cookie(v9ses);
+	kfree(v9ses->cachetag);
+#endif
 	__putname(v9ses->uname);
 	__putname(v9ses->aname);
+
+	spin_lock(&v9fs_sessionlist_lock);
+	list_del(&v9ses->slist);
+	spin_unlock(&v9fs_sessionlist_lock);
 }
 
 /**
@@ -286,25 +330,130 @@ void v9fs_session_cancel(struct v9fs_session_info *v9ses) {
 
 extern int v9fs_error_init(void);
 
+static struct kobject *v9fs_kobj;
+
+#ifdef CONFIG_9P_FSCACHE
 /**
- * v9fs_init - Initialize module
+ * caches_show - list caches associated with a session
+ *
+ * Returns the size of buffer written.
+ */
+
+static ssize_t caches_show(struct kobject *kobj,
+			   struct kobj_attribute *attr,
+			   char *buf)
+{
+	ssize_t n = 0, count = 0, limit = PAGE_SIZE;
+	struct v9fs_session_info *v9ses;
+
+	spin_lock(&v9fs_sessionlist_lock);
+	list_for_each_entry(v9ses, &v9fs_sessionlist, slist) {
+		n = snprintf(buf, limit, "%s\n", v9ses->cachetag);
+		if (n < 0) {
+			count = n;
+			break;
+		}
+
+		count += n;
+		limit -= n;
+	}
+
+	spin_unlock(&v9fs_sessionlist_lock);
+	return count;
+}
+
+static struct kobj_attribute v9fs_attr_cache = __ATTR_RO(caches);
+#endif /* CONFIG_9P_FSCACHE */
+
+static struct attribute *v9fs_attrs[] = {
+#ifdef CONFIG_9P_FSCACHE
+	&v9fs_attr_cache.attr,
+#endif
+	NULL,
+};
+
+static struct attribute_group v9fs_attr_group = {
+	.attrs = v9fs_attrs,
+};
+
+/**
+ * v9fs_sysfs_init - Initialize the v9fs sysfs interface
+ *
+ */
+
+static int v9fs_sysfs_init(void)
+{
+	v9fs_kobj = kobject_create_and_add("9p", fs_kobj);
+	if (!v9fs_kobj)
+		return -ENOMEM;
+
+	if (sysfs_create_group(v9fs_kobj, &v9fs_attr_group)) {
+		kobject_put(v9fs_kobj);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+/**
+ * v9fs_sysfs_cleanup - Unregister the v9fs sysfs interface
+ *
+ */
+
+static void v9fs_sysfs_cleanup(void)
+{
+	sysfs_remove_group(v9fs_kobj, &v9fs_attr_group);
+	kobject_put(v9fs_kobj);
+}
+
+/**
+ * init_v9fs - Initialize module
  *
  */
 
 static int __init init_v9fs(void)
 {
+	int err;
 	printk(KERN_INFO "Installing v9fs 9p2000 file system support\n");
 	/* TODO: Setup list of registered trasnport modules */
-	return register_filesystem(&v9fs_fs_type);
+	err = register_filesystem(&v9fs_fs_type);
+	if (err < 0) {
+		printk(KERN_ERR "Failed to register filesystem\n");
+		return err;
+	}
+
+	err = v9fs_cache_register();
+	if (err < 0) {
+		printk(KERN_ERR "Failed to register v9fs for caching\n");
+		goto out_fs_unreg;
+	}
+
+	err = v9fs_sysfs_init();
+	if (err < 0) {
+		printk(KERN_ERR "Failed to register with sysfs\n");
+		goto out_sysfs_cleanup;
+	}
+
+	return 0;
+
+out_sysfs_cleanup:
+	v9fs_sysfs_cleanup();
+
+out_fs_unreg:
+	unregister_filesystem(&v9fs_fs_type);
+
+	return err;
 }
 
 /**
- * v9fs_init - shutdown module
+ * exit_v9fs - shutdown module
  *
  */
 
 static void __exit exit_v9fs(void)
 {
+	v9fs_sysfs_cleanup();
+	v9fs_cache_unregister();
 	unregister_filesystem(&v9fs_fs_type);
 }
 
diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index 38762bf..019f4cc 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -51,6 +51,7 @@ enum p9_session_flags {
 enum p9_cache_modes {
 	CACHE_NONE,
 	CACHE_LOOSE,
+	CACHE_FSCACHE,
 };
 
 /**
@@ -60,6 +61,8 @@ enum p9_cache_modes {
  * @debug: debug level
  * @afid: authentication handle
  * @cache: cache mode of type &p9_cache_modes
+ * @cachetag: the tag of the cache associated with this session
+ * @fscache: session cookie associated with FS-Cache
  * @options: copy of options string given by user
  * @uname: string user name to mount hierarchy as
  * @aname: mount specifier for remote hierarchy
@@ -68,7 +71,7 @@ enum p9_cache_modes {
  * @dfltgid: default numeric groupid to mount hierarchy as
  * @uid: if %V9FS_ACCESS_SINGLE, the numeric uid which mounted the hierarchy
  * @clnt: reference to 9P network client instantiated for this session
- * @debugfs_dir: reference to debugfs_dir which can be used for add'l debug
+ * @slist: reference to list of registered 9p sessions
  *
  * This structure holds state for each session instance established during
  * a sys_mount() .
@@ -84,6 +87,10 @@ struct v9fs_session_info {
 	unsigned short debug;
 	unsigned int afid;
 	unsigned int cache;
+#ifdef CONFIG_9P_FSCACHE
+	char *cachetag;
+	struct fscache_cookie *fscache;
+#endif
 
 	char *uname;		/* user name to mount as */
 	char *aname;		/* name of remote hierarchy being mounted */
@@ -92,11 +99,9 @@ struct v9fs_session_info {
 	unsigned int dfltgid;	/* default gid for legacy support */
 	u32 uid;		/* if ACCESS_SINGLE, the uid that has access */
 	struct p9_client *clnt;	/* 9p client */
-	struct dentry *debugfs_dir;
+	struct list_head slist; /* list of sessions registered with v9fs */
 };
 
-extern struct dentry *v9fs_debugfs_root;
-
 struct p9_fid *v9fs_session_init(struct v9fs_session_info *, const char *,
 									char *);
 void v9fs_session_close(struct v9fs_session_info *v9ses);
diff --git a/fs/9p/v9fs_vfs.h b/fs/9p/v9fs_vfs.h
index f0c7de7..3a7560e 100644
--- a/fs/9p/v9fs_vfs.h
+++ b/fs/9p/v9fs_vfs.h
@@ -44,7 +44,13 @@ extern const struct file_operations v9fs_dir_operations;
 extern const struct dentry_operations v9fs_dentry_operations;
 extern const struct dentry_operations v9fs_cached_dentry_operations;
 
+#ifdef CONFIG_9P_FSCACHE
+struct inode *v9fs_alloc_inode(struct super_block *sb);
+void v9fs_destroy_inode(struct inode *inode);
+#endif
+
 struct inode *v9fs_get_inode(struct super_block *sb, int mode);
+void v9fs_clear_inode(struct inode *inode);
 ino_t v9fs_qid2ino(struct p9_qid *qid);
 void v9fs_stat2inode(struct p9_wstat *, struct inode *, struct super_block *);
 int v9fs_dir_release(struct inode *inode, struct file *filp);
diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 9282828..90e3844 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -38,6 +38,7 @@
 
 #include "v9fs.h"
 #include "v9fs_vfs.h"
+#include "cache.h"
 
 /**
  * v9fs_vfs_readpage - read an entire page in from 9P
@@ -52,18 +53,31 @@ static int v9fs_vfs_readpage(struct file *filp, struct page *page)
 	int retval;
 	loff_t offset;
 	char *buffer;
+	struct inode *inode;
 
+	inode = page->mapping->host;
 	P9_DPRINTK(P9_DEBUG_VFS, "\n");
+
+	BUG_ON(!PageLocked(page));
+
+	retval = v9fs_readpage_from_fscache(inode, page);
+	if (retval == 0)
+		return retval;
+
 	buffer = kmap(page);
 	offset = page_offset(page);
 
 	retval = v9fs_file_readn(filp, buffer, NULL, PAGE_CACHE_SIZE, offset);
-	if (retval < 0)
+	if (retval < 0) {
+		v9fs_uncache_page(inode, page);
 		goto done;
+	}
 
 	memset(buffer + retval, 0, PAGE_CACHE_SIZE - retval);
 	flush_dcache_page(page);
 	SetPageUptodate(page);
+
+	v9fs_readpage_to_fscache(inode, page);
 	retval = 0;
 
 done:
@@ -72,6 +86,78 @@ done:
 	return retval;
 }
 
+/**
+ * v9fs_vfs_readpages - read a set of pages from 9P
+ *
+ * @filp: file being read
+ * @mapping: the address space
+ * @pages: list of pages to read
+ * @nr_pages: count of pages to read
+ *
+ */
+
+static int v9fs_vfs_readpages(struct file *filp, struct address_space *mapping,
+			     struct list_head *pages, unsigned nr_pages)
+{
+	int ret = 0;
+	struct inode *inode;
+
+	inode = mapping->host;
+	P9_DPRINTK(P9_DEBUG_VFS, "inode: %p file: %p\n", inode, filp);
+
+	ret = v9fs_readpages_from_fscache(inode, mapping, pages, &nr_pages);
+	if (ret == 0)
+		return ret;
+
+	ret = read_cache_pages(mapping, pages, (void *)v9fs_vfs_readpage, filp);
+	P9_DPRINTK(P9_DEBUG_VFS, "  = %d\n", ret);
+	return ret;
+}
+
+/**
+ * v9fs_release_page - release the private state associated with a page
+ *
+ * Returns 1 if the page can be released, false otherwise.
+ */
+
+static int v9fs_release_page(struct page *page, gfp_t gfp)
+{
+	if (PagePrivate(page))
+		return 0;
+
+	return v9fs_fscache_release_page(page, gfp);
+}
+
+/**
+ * v9fs_invalidate_page - Invalidate a page completely or partially
+ *
+ * @page: structure to page
+ * @offset: offset in the page
+ */
+
+static void v9fs_invalidate_page(struct page *page, unsigned long offset)
+{
+	if (offset == 0)
+		v9fs_fscache_invalidate_page(page);
+}
+
+/**
+ * v9fs_launder_page - Writeback a dirty page
+ * Since the writes go directly to the server, we simply return a 0
+ * here to indicate success.
+ *
+ * Returns 0 on success.
+ */
+
+static int v9fs_launder_page(struct page *page)
+{
+	return 0;
+}
+
 const struct address_space_operations v9fs_addr_operations = {
       .readpage = v9fs_vfs_readpage,
+      .readpages = v9fs_vfs_readpages,
+      .releasepage = v9fs_release_page,
+      .invalidatepage = v9fs_invalidate_page,
+      .launder_page = v9fs_launder_page,
 };
diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index cafaa46..3902bf4 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -41,6 +41,7 @@
 #include "v9fs.h"
 #include "v9fs_vfs.h"
 #include "fid.h"
+#include "cache.h"
 
 static const struct file_operations v9fs_cached_file_operations;
 
@@ -86,6 +87,10 @@ int v9fs_file_open(struct inode *inode, struct file *file)
 		/* enable cached file options */
 		if(file->f_op == &v9fs_file_operations)
 			file->f_op = &v9fs_cached_file_operations;
+
+#ifdef CONFIG_9P_FSCACHE
+		v9fs_cache_inode_set_cookie(inode, file);
+#endif
 	}
 
 	return 0;
@@ -238,8 +243,9 @@ v9fs_file_write(struct file *filp, const char __user * data,
 	if (total > 0) {
 		pg_start = origin >> PAGE_CACHE_SHIFT;
 		pg_end = (origin + total - 1) >> PAGE_CACHE_SHIFT;
-		invalidate_inode_pages2_range(inode->i_mapping, pg_start,
-								pg_end);
+		if (inode->i_mapping && inode->i_mapping->nrpages)
+			invalidate_inode_pages2_range(inode->i_mapping,
+						      pg_start, pg_end);
 		*offset += total;
 		i_size_write(inode, i_size_read(inode) + total);
 		inode->i_blocks = (i_size_read(inode) + 512 - 1) >> 9;
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index f3bfa87..6a0af65 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -40,6 +40,7 @@
 #include "v9fs.h"
 #include "v9fs_vfs.h"
 #include "fid.h"
+#include "cache.h"
 
 static const struct inode_operations v9fs_dir_inode_operations;
 static const struct inode_operations v9fs_dir_inode_operations_ext;
@@ -197,6 +198,38 @@ v9fs_blank_wstat(struct p9_wstat *wstat)
 	wstat->extension = NULL;
 }
 
+#ifdef CONFIG_9P_FSCACHE
+/**
+ * v9fs_alloc_inode - helper function to allocate an inode
+ * This callback is executed before setting up the inode so that we
+ * can associate a vcookie with each inode.
+ *
+ */
+
+struct inode *v9fs_alloc_inode(struct super_block *sb)
+{
+	struct v9fs_cookie *vcookie;
+	vcookie = (struct v9fs_cookie *)kmem_cache_alloc(vcookie_cache,
+							 GFP_KERNEL);
+	if (!vcookie)
+		return NULL;
+
+	vcookie->fscache = NULL;
+	vcookie->qid = NULL;
+	return &vcookie->inode;
+}
+
+/**
+ * v9fs_destroy_inode - destroy an inode
+ *
+ */
+
+void v9fs_destroy_inode(struct inode *inode)
+{
+	kmem_cache_free(vcookie_cache, v9fs_inode2cookie(inode));
+}
+#endif
+
 /**
  * v9fs_get_inode - helper function to setup an inode
  * @sb: superblock
@@ -326,6 +359,21 @@ error:
 }
 */
 
+
+/**
+ * v9fs_clear_inode - release an inode
+ * @inode: inode to release
+ *
+ */
+void v9fs_clear_inode(struct inode *inode)
+{
+	filemap_fdatawrite(inode->i_mapping);
+
+#ifdef CONFIG_9P_FSCACHE
+	v9fs_cache_inode_put_cookie(inode);
+#endif
+}
+
 /**
  * v9fs_inode_from_fid - populate an inode by issuing a attribute request
  * @v9ses: session information
@@ -356,8 +404,14 @@ v9fs_inode_from_fid(struct v9fs_session_info *v9ses, struct p9_fid *fid,
 
 	v9fs_stat2inode(st, ret, sb);
 	ret->i_ino = v9fs_qid2ino(&st->qid);
+	v9fs_vcookie_set_qid(ret, &st->qid);
+
+#ifdef CONFIG_9P_FSCACHE
+	v9fs_cache_inode_get_cookie(ret);
+#endif
 	p9stat_free(st);
 	kfree(st);
+
 	return ret;
 
 error:
@@ -751,7 +805,7 @@ v9fs_vfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	P9_DPRINTK(P9_DEBUG_VFS, "dentry: %p\n", dentry);
 	err = -EPERM;
 	v9ses = v9fs_inode2v9ses(dentry->d_inode);
-	if (v9ses->cache == CACHE_LOOSE)
+	if (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE)
 		return simple_getattr(mnt, dentry, stat);
 
 	fid = v9fs_fid_lookup(dentry);
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 8961f1a..14a8644 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -44,21 +44,9 @@
 #include "v9fs_vfs.h"
 #include "fid.h"
 
-static void v9fs_clear_inode(struct inode *);
 static const struct super_operations v9fs_super_ops;
 
 /**
- * v9fs_clear_inode - release an inode
- * @inode: inode to release
- *
- */
-
-static void v9fs_clear_inode(struct inode *inode)
-{
-	filemap_fdatawrite(inode->i_mapping);
-}
-
-/**
  * v9fs_set_super - set the superblock
  * @s: super block
  * @data: file system specific data
@@ -220,6 +208,10 @@ v9fs_umount_begin(struct super_block *sb)
 }
 
 static const struct super_operations v9fs_super_ops = {
+#ifdef CONFIG_9P_FSCACHE
+	.alloc_inode = v9fs_alloc_inode,
+	.destroy_inode = v9fs_destroy_inode,
+#endif
 	.statfs = simple_statfs,
 	.clear_inode = v9fs_clear_inode,
 	.show_options = generic_show_options,
diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index b77c147..a7fb548 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -38,6 +38,8 @@
  * @P9_DEBUG_SLABS: memory management tracing
  * @P9_DEBUG_FCALL: verbose dump of protocol messages
  * @P9_DEBUG_FID: fid allocation/deallocation tracking
+ * @P9_DEBUG_PKT: packet marshalling/unmarshalling
+ * @P9_DEBUG_FSC: FS-cache tracing
  *
  * These flags are passed at mount time to turn on various levels of
  * verbosity and tracing which will be output to the system logs.
@@ -54,6 +56,7 @@ enum p9_debug_flags {
 	P9_DEBUG_FCALL =	(1<<8),
 	P9_DEBUG_FID =		(1<<9),
 	P9_DEBUG_PKT =		(1<<10),
+	P9_DEBUG_FSC =		(1<<11),
 };
 
 #ifdef CONFIG_NET_9P_DEBUG
-- 
1.6.3.3

