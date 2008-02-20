Return-Path: <linux-kernel-owner+w=401wt.eu-S934097AbYBTQYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934097AbYBTQYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:24:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765513AbYBTQLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:11:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764957AbYBTQKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:10:13 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 34/37] NFS: Read pages from FS-Cache into an NFS inode
To: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 20 Feb 2008 16:09:00 +0000
Message-ID: <20080220160900.4715.96743.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
References: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Read pages from an FS-Cache data storage object representing an inode into an
NFS inode.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/nfs/fscache.c |  112 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nfs/fscache.h |   47 +++++++++++++++++++++++
 fs/nfs/read.c    |   18 +++++++++
 3 files changed, 176 insertions(+), 1 deletions(-)


diff --git a/fs/nfs/fscache.c b/fs/nfs/fscache.c
index d475ff5..438cc9b 100644
--- a/fs/nfs/fscache.c
+++ b/fs/nfs/fscache.c
@@ -344,5 +344,115 @@ void __nfs_fscache_invalidate_page(struct page *page, struct inode *inode)
 
 	BUG_ON(!PageLocked(page));
 	fscache_uncache_page(nfsi->fscache, page);
-	nfs_add_stats(page->mapping->host, NFSIOS_FSCACHE_UNCACHE, 1);
+	nfs_add_stats(inode, NFSIOS_FSCACHE_UNCACHE, 1);
+}
+
+/*
+ * Handle completion of a page being read from the cache.
+ * - Called in process (keventd) context.
+ */
+static void nfs_readpage_from_fscache_complete(struct page *page,
+					       void *context,
+					       int error)
+{
+	dfprintk(FSCACHE,
+		 "NFS: readpage_from_fscache_complete (0x%p/0x%p/%d)\n",
+		 page, context, error);
+
+	/* if the read completes with an error, we just unlock the page and let
+	 * the VM reissue the readpage */
+	if (!error) {
+		SetPageUptodate(page);
+		unlock_page(page);
+	} else {
+		error = nfs_readpage_async(context, page->mapping->host, page);
+		if (error)
+			unlock_page(page);
+	}
+}
+
+/*
+ * Retrieve a page from fscache
+ */
+int __nfs_readpage_from_fscache(struct nfs_open_context *ctx,
+				struct inode *inode, struct page *page)
+{
+	int ret;
+
+	dfprintk(FSCACHE,
+		 "NFS: readpage_from_fscache(fsc:%p/p:%p(i:%lx f:%lx)/0x%p)\n",
+		 NFS_I(inode)->fscache, page, page->index, page->flags, inode);
+
+	ret = fscache_read_or_alloc_page(NFS_I(inode)->fscache,
+					 page,
+					 nfs_readpage_from_fscache_complete,
+					 ctx,
+					 GFP_KERNEL);
+
+	switch (ret) {
+	case 0: /* read BIO submitted (page in fscache) */
+		dfprintk(FSCACHE,
+			 "NFS:    readpage_from_fscache: BIO submitted\n");
+		nfs_add_stats(inode, NFSIOS_FSCACHE_READ_OK, 1);
+		return ret;
+
+	case -ENOBUFS: /* inode not in cache */
+	case -ENODATA: /* page not in cache */
+		nfs_add_stats(inode, NFSIOS_FSCACHE_READ_FAIL, 1);
+		dfprintk(FSCACHE,
+			 "NFS:    readpage_from_fscache %d\n", ret);
+		return 1;
+
+	default:
+		dfprintk(FSCACHE, "NFS:    readpage_from_fscache %d\n", ret);
+		nfs_add_stats(inode, NFSIOS_FSCACHE_READ_FAIL, 1);
+	}
+	return ret;
+}
+
+/*
+ * Retrieve a set of pages from fscache
+ */
+int __nfs_readpages_from_fscache(struct nfs_open_context *ctx,
+				 struct inode *inode,
+				 struct address_space *mapping,
+				 struct list_head *pages,
+				 unsigned *nr_pages)
+{
+	int ret, npages = *nr_pages;
+
+	dfprintk(FSCACHE, "NFS: nfs_getpages_from_fscache (0x%p/%u/0x%p)\n",
+		 NFS_I(inode)->fscache, npages, inode);
+
+	ret = fscache_read_or_alloc_pages(NFS_I(inode)->fscache,
+					  mapping, pages, nr_pages,
+					  nfs_readpage_from_fscache_complete,
+					  ctx,
+					  mapping_gfp_mask(mapping));
+	if (*nr_pages < npages)
+		nfs_add_stats(inode, NFSIOS_FSCACHE_READ_OK, npages);
+	if (*nr_pages > 0)
+		nfs_add_stats(inode, NFSIOS_FSCACHE_READ_FAIL, *nr_pages);
+
+	switch (ret) {
+	case 0: /* read submitted to the cache for all pages */
+		BUG_ON(!list_empty(pages));
+		BUG_ON(*nr_pages != 0);
+		dfprintk(FSCACHE,
+			 "NFS: nfs_getpages_from_fscache: submitted\n");
+
+		return ret;
+
+	case -ENOBUFS: /* some pages aren't cached and can't be */
+	case -ENODATA: /* some pages aren't cached */
+		dfprintk(FSCACHE,
+			 "NFS: nfs_getpages_from_fscache: no page: %d\n", ret);
+		return 1;
+
+	default:
+		dfprintk(FSCACHE,
+			 "NFS: nfs_getpages_from_fscache: ret  %d\n", ret);
+	}
+
+	return ret;
 }
diff --git a/fs/nfs/fscache.h b/fs/nfs/fscache.h
index 1cb7d96..4c1e1a8 100644
--- a/fs/nfs/fscache.h
+++ b/fs/nfs/fscache.h
@@ -89,6 +89,12 @@ extern void nfs_fscache_attr_changed(struct inode *);
 extern void __nfs_fscache_invalidate_page(struct page *, struct inode *);
 extern int nfs_fscache_release_page(struct page *, gfp_t);
 
+extern int __nfs_readpage_from_fscache(struct nfs_open_context *,
+				       struct inode *, struct page *);
+extern int __nfs_readpages_from_fscache(struct nfs_open_context *,
+					struct inode *, struct address_space *,
+					struct list_head *, unsigned *);
+
 /*
  * release the caching state associated with a page if undergoing complete page
  * invalidation
@@ -100,6 +106,32 @@ static inline void nfs_fscache_invalidate_page(struct page *page,
 		__nfs_fscache_invalidate_page(page, inode);
 }
 
+/*
+ * Retrieve a page from an inode data storage object.
+ */
+static inline int nfs_readpage_from_fscache(struct nfs_open_context *ctx,
+					    struct inode *inode,
+					    struct page *page)
+{
+	if (NFS_I(inode)->fscache)
+		return __nfs_readpage_from_fscache(ctx, inode, page);
+	return -ENOBUFS;
+}
+
+/*
+ * Retrieve a set of pages from an inode data storage object.
+ */
+static inline int nfs_readpages_from_fscache(struct nfs_open_context *ctx,
+					     struct inode *inode,
+					     struct address_space *mapping,
+					     struct list_head *pages,
+					     unsigned *nr_pages)
+{
+	if (NFS_I(inode)->fscache)
+		return __nfs_readpages_from_fscache(ctx, inode, mapping, pages,
+						    nr_pages);
+	return -ENOBUFS;
+}
 
 #else /* CONFIG_NFS_FSCACHE */
 static inline int nfs_fscache_register(void) { return 0; }
@@ -132,5 +164,20 @@ static inline int nfs_fscache_release_page(struct page *page, gfp_t gfp)
 static inline void nfs_fscache_invalidate_page(struct page *page,
 					       struct inode *inode) {}
 
+static inline int nfs_readpage_from_fscache(struct nfs_open_context *ctx,
+					    struct inode *inode,
+					    struct page *page)
+{
+	return -ENOBUFS;
+}
+static inline int nfs_readpages_from_fscache(struct nfs_open_context *ctx,
+					     struct inode *inode,
+					     struct address_space *mapping,
+					     struct list_head *pages,
+					     unsigned *nr_pages)
+{
+	return -ENOBUFS;
+}
+
 #endif /* CONFIG_NFS_FSCACHE */
 #endif /* _NFS_FSCACHE_H */
diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index 725a5a2..db27b26 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -24,6 +24,7 @@
 
 #include "internal.h"
 #include "iostat.h"
+#include "fscache.h"
 
 #define NFSDBG_FACILITY		NFSDBG_PAGECACHE
 
@@ -493,9 +494,16 @@ int nfs_readpage(struct file *file, struct page *page)
 			goto out_unlock;
 	} else
 		ctx = get_nfs_open_context(nfs_file_open_context(file));
+ 
+	if (!IS_SYNC(inode)) {
+		error = nfs_readpage_from_fscache(ctx, inode, page);
+		if (error == 0)
+			goto out;
+	}
 
 	error = nfs_readpage_async(ctx, inode, page);
 
+out:
 	put_nfs_open_context(ctx);
 	return error;
 out_unlock:
@@ -571,6 +579,15 @@ int nfs_readpages(struct file *filp, struct address_space *mapping,
 			return -EBADF;
 	} else
 		desc.ctx = get_nfs_open_context(nfs_file_open_context(filp));
+
+	/* attempt to read as many of the pages as possible from the cache
+	 * - this returns -ENOBUFS immediately if the cookie is negative
+	 */
+	ret = nfs_readpages_from_fscache(desc.ctx, inode, mapping,
+					 pages, &nr_pages);
+	if (ret == 0)
+		goto read_complete; /* all pages were read */
+
 	if (rsize < PAGE_CACHE_SIZE)
 		nfs_pageio_init(&pgio, inode, nfs_pagein_multi, rsize, 0);
 	else
@@ -581,6 +598,7 @@ int nfs_readpages(struct file *filp, struct address_space *mapping,
 	nfs_pageio_complete(&pgio);
 	npages = (pgio.pg_bytes_written + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	nfs_add_stats(inode, NFSIOS_READPAGES, npages);
+read_complete:
 	put_nfs_open_context(desc.ctx);
 out:
 	return ret;

