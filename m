Return-Path: <linux-kernel-owner+w=401wt.eu-S1758782AbYKTO65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782AbYKTO65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756570AbYKTOpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:45:24 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41202 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755696AbYKTOpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:45:20 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 39/45] NFS: FS-Cache page management [ver #41]
To: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Date: Thu, 20 Nov 2008 14:45:00 +0000
Message-ID: <20081120144500.10667.12867.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
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
---

 fs/nfs/file.c    |   17 +++++++++++++----
 fs/nfs/fscache.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nfs/fscache.h |   22 ++++++++++++++++++++++
 3 files changed, 86 insertions(+), 4 deletions(-)


diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 141c0ab..512e194 100644
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
@@ -437,14 +440,16 @@ static int nfs_release_page(struct page *page, gfp_t gfp)
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
@@ -455,6 +460,7 @@ static int nfs_launder_page(struct page *page)
 	dfprintk(PAGECACHE, "NFS: launder_page(%ld, %llu)\n",
 		inode->i_ino, (long long)page_offset(page));
 
+	wait_on_page_fscache_write(page);
 	return nfs_wb_page(inode, page);
 }
 
@@ -490,6 +496,9 @@ static int nfs_vm_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 		filp->f_mapping->host->i_ino,
 		(long long)page_offset(page));
 
+	/* make sure the cache has finished storing the page */
+	wait_on_page_fscache_write(page);
+
 	lock_page(page);
 	mapping = page->mapping;
 	if (mapping != dentry->d_inode->i_mapping)
diff --git a/fs/nfs/fscache.c b/fs/nfs/fscache.c
index e3816eb..de990dd 100644
--- a/fs/nfs/fscache.c
+++ b/fs/nfs/fscache.c
@@ -19,6 +19,7 @@
 #include <linux/seq_file.h>
 
 #include "internal.h"
+#include "iostat.h"
 #include "fscache.h"
 
 #define NFSDBG_FACILITY		NFSDBG_FSCACHE
@@ -328,3 +329,53 @@ void nfs_fscache_reset_inode_cookie(struct inode *inode)
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
+	if (PageFsCacheWrite(page)) {
+		if (!(gfp & __GFP_WAIT))
+			return 0;
+		wait_on_page_fscache_write(page);
+	}
+
+	if (PageFsCache(page)) {
+		struct nfs_inode *nfsi = NFS_I(page->mapping->host);
+
+		BUG_ON(!nfsi->fscache);
+
+		dfprintk(FSCACHE, "NFS: fscache releasepage (0x%p/0x%p/0x%p)\n",
+			 nfsi->fscache, page, nfsi);
+
+		fscache_uncache_page(nfsi->fscache, page);
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
+
+	BUG_ON(!nfsi->fscache);
+
+	dfprintk(FSCACHE, "NFS: fscache invalidatepage (0x%p/0x%p/0x%p)\n",
+		 nfsi->fscache, page, nfsi);
+
+	wait_on_page_fscache_write(page);
+
+	BUG_ON(!PageLocked(page));
+	fscache_uncache_page(nfsi->fscache, page);
+	nfs_add_fscache_stats(page->mapping->host,
+			      NFSIOS_FSCACHE_PAGES_UNCACHED, 1);
+}
diff --git a/fs/nfs/fscache.h b/fs/nfs/fscache.h
index 8b4299a..9cc63af 100644
--- a/fs/nfs/fscache.h
+++ b/fs/nfs/fscache.h
@@ -83,6 +83,21 @@ extern void nfs_fscache_zap_inode_cookie(struct inode *);
 extern void nfs_fscache_set_inode_cookie(struct inode *, struct file *);
 extern void nfs_fscache_reset_inode_cookie(struct inode *);
 
+extern void __nfs_fscache_invalidate_page(struct page *, struct inode *);
+extern int nfs_fscache_release_page(struct page *, gfp_t);
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
@@ -104,5 +119,12 @@ static inline void nfs_fscache_set_inode_cookie(struct inode *inode,
 						struct file *filp) {}
 static inline void nfs_fscache_reset_inode_cookie(struct inode *inode) {}
 
+static inline int nfs_fscache_release_page(struct page *page, gfp_t gfp)
+{
+	return 1; /* True: may release page */
+}
+static inline void nfs_fscache_invalidate_page(struct page *page,
+					       struct inode *inode) {}
+
 #endif /* CONFIG_NFS_FSCACHE */
 #endif /* _NFS_FSCACHE_H */

