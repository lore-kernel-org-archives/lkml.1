Return-Path: <linux-kernel-owner+w=401wt.eu-S936321AbZDCQMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936321AbZDCQMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935012AbZDCP5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:57:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56683 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934998AbZDCP5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:57:44 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 35/41] NFS: FS-Cache page management [ver #48]
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
Date: Fri, 03 Apr 2009 16:57:36 +0100
Message-ID: <20090403155736.28714.33327.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FS-Cache page management for NFS.  This includes hooking the releasing and
invalidation of pages marked with PG_fscache (aka PG_private_2) and waiting for
completion of the write-to-cache flag (PG_fscache_write aka PG_owner_priv_2).

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Daire Byrne <Daire.Byrne@framestore.com>
---

 fs/nfs/file.c    |   18 ++++++++++++++----
 fs/nfs/fscache.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nfs/fscache.h |   34 ++++++++++++++++++++++++++++++++++
 3 files changed, 101 insertions(+), 4 deletions(-)


diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index f5bc54d..3523b89 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -35,6 +35,7 @@
 #include "delegation.h"
 #include "internal.h"
 #include "iostat.h"
+#include "fscache.h"
 
 #define NFSDBG_FACILITY		NFSDBG_FILE
 
@@ -413,7 +414,7 @@ static int nfs_write_end(struct file *file, struct address_space *mapping,
  * Partially or wholly invalidate a page
  * - Release the private state associated with a page if undergoing complete
  *   page invalidation
- * - Called if either PG_private or PG_private_2 is set on the page
+ * - Called if either PG_private or PG_fscache is set on the page
  * - Caller holds page lock
  */
 static void nfs_invalidate_page(struct page *page, unsigned long offset)
@@ -424,11 +425,13 @@ static void nfs_invalidate_page(struct page *page, unsigned long offset)
 		return;
 	/* Cancel any unstarted writes on this page */
 	nfs_wb_page_cancel(page->mapping->host, page);
+
+	nfs_fscache_invalidate_page(page, page->mapping->host);
 }
 
 /*
  * Attempt to release the private state associated with a page
- * - Called if either PG_private or PG_private_2 is set on the page
+ * - Called if either PG_private or PG_fscache is set on the page
  * - Caller holds page lock
  * - Return true (may release page) or false (may not)
  */
@@ -437,24 +440,28 @@ static int nfs_release_page(struct page *page, gfp_t gfp)
 	dfprintk(PAGECACHE, "NFS: release_page(%p)\n", page);
 
 	/* If PagePrivate() is set, then the page is not freeable */
-	return 0;
+	if (PagePrivate(page))
+		return 0;
+	return nfs_fscache_release_page(page, gfp);
 }
 
 /*
  * Attempt to clear the private state associated with a page when an error
  * occurs that requires the cached contents of an inode to be written back or
  * destroyed
- * - Called if either PG_private or PG_private_2 is set on the page
+ * - Called if either PG_private or fscache is set on the page
  * - Caller holds page lock
  * - Return 0 if successful, -error otherwise
  */
 static int nfs_launder_page(struct page *page)
 {
 	struct inode *inode = page->mapping->host;
+	struct nfs_inode *nfsi = NFS_I(inode);
 
 	dfprintk(PAGECACHE, "NFS: launder_page(%ld, %llu)\n",
 		inode->i_ino, (long long)page_offset(page));
 
+	nfs_fscache_wait_on_page_write(nfsi, page);
 	return nfs_wb_page(inode, page);
 }
 
@@ -491,6 +498,9 @@ static int nfs_vm_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 		filp->f_mapping->host->i_ino,
 		(long long)page_offset(page));
 
+	/* make sure the cache has finished storing the page */
+	nfs_fscache_wait_on_page_write(NFS_I(dentry->d_inode), page);
+
 	lock_page(page);
 	mapping = page->mapping;
 	if (mapping != dentry->d_inode->i_mapping)
diff --git a/fs/nfs/fscache.c b/fs/nfs/fscache.c
index e3816eb..f673d35 100644
--- a/fs/nfs/fscache.c
+++ b/fs/nfs/fscache.c
@@ -19,6 +19,7 @@
 #include <linux/seq_file.h>
 
 #include "internal.h"
+#include "iostat.h"
 #include "fscache.h"
 
 #define NFSDBG_FACILITY		NFSDBG_FSCACHE
@@ -328,3 +329,55 @@ void nfs_fscache_reset_inode_cookie(struct inode *inode)
 	}
 	nfs_fscache_inode_unlock(inode);
 }
+
+/*
+ * Release the caching state associated with a page, if the page isn't busy
+ * interacting with the cache.
+ * - Returns true (can release page) or false (page busy).
+ */
+int nfs_fscache_release_page(struct page *page, gfp_t gfp)
+{
+	struct nfs_inode *nfsi = NFS_I(page->mapping->host);
+	struct fscache_cookie *cookie = nfsi->fscache;
+
+	BUG_ON(!cookie);
+
+	if (fscache_check_page_write(cookie, page)) {
+		if (!(gfp & __GFP_WAIT))
+			return 0;
+		fscache_wait_on_page_write(cookie, page);
+	}
+
+	if (PageFsCache(page)) {
+		dfprintk(FSCACHE, "NFS: fscache releasepage (0x%p/0x%p/0x%p)\n",
+			 cookie, page, nfsi);
+
+		fscache_uncache_page(cookie, page);
+		nfs_add_fscache_stats(page->mapping->host,
+				      NFSIOS_FSCACHE_PAGES_UNCACHED, 1);
+	}
+
+	return 1;
+}
+
+/*
+ * Release the caching state associated with a page if undergoing complete page
+ * invalidation.
+ */
+void __nfs_fscache_invalidate_page(struct page *page, struct inode *inode)
+{
+	struct nfs_inode *nfsi = NFS_I(inode);
+	struct fscache_cookie *cookie = nfsi->fscache;
+
+	BUG_ON(!cookie);
+
+	dfprintk(FSCACHE, "NFS: fscache invalidatepage (0x%p/0x%p/0x%p)\n",
+		 cookie, page, nfsi);
+
+	fscache_wait_on_page_write(cookie, page);
+
+	BUG_ON(!PageLocked(page));
+	fscache_uncache_page(cookie, page);
+	nfs_add_fscache_stats(page->mapping->host,
+			      NFSIOS_FSCACHE_PAGES_UNCACHED, 1);
+}
diff --git a/fs/nfs/fscache.h b/fs/nfs/fscache.h
index 8b4299a..e29613a 100644
--- a/fs/nfs/fscache.h
+++ b/fs/nfs/fscache.h
@@ -83,6 +83,31 @@ extern void nfs_fscache_zap_inode_cookie(struct inode *);
 extern void nfs_fscache_set_inode_cookie(struct inode *, struct file *);
 extern void nfs_fscache_reset_inode_cookie(struct inode *);
 
+extern void __nfs_fscache_invalidate_page(struct page *, struct inode *);
+extern int nfs_fscache_release_page(struct page *, gfp_t);
+
+/*
+ * wait for a page to complete writing to the cache
+ */
+static inline void nfs_fscache_wait_on_page_write(struct nfs_inode *nfsi,
+						  struct page *page)
+{
+	if (PageFsCache(page))
+		fscache_wait_on_page_write(nfsi->fscache, page);
+}
+
+/*
+ * release the caching state associated with a page if undergoing complete page
+ * invalidation
+ */
+static inline void nfs_fscache_invalidate_page(struct page *page,
+					       struct inode *inode)
+{
+	if (PageFsCache(page))
+		__nfs_fscache_invalidate_page(page, inode);
+}
+
+
 #else /* CONFIG_NFS_FSCACHE */
 static inline int nfs_fscache_register(void) { return 0; }
 static inline void nfs_fscache_unregister(void) {}
@@ -104,5 +129,14 @@ static inline void nfs_fscache_set_inode_cookie(struct inode *inode,
 						struct file *filp) {}
 static inline void nfs_fscache_reset_inode_cookie(struct inode *inode) {}
 
+static inline int nfs_fscache_release_page(struct page *page, gfp_t gfp)
+{
+	return 1; /* True: may release page */
+}
+static inline void nfs_fscache_invalidate_page(struct page *page,
+					       struct inode *inode) {}
+static inline void nfs_fscache_wait_on_page_write(struct nfs_inode *nfsi,
+						  struct page *page) {}
+
 #endif /* CONFIG_NFS_FSCACHE */
 #endif /* _NFS_FSCACHE_H */

