Return-Path: <linux-kernel-owner+w=401wt.eu-S934768AbZDCQOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934768AbZDCQOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935076AbZDCP6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:58:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56703 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935065AbZDCP6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:58:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 39/41] NFS: Store pages from an NFS inode into a local cache
	[ver #48]
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
Date: Fri, 03 Apr 2009 16:57:56 +0100
Message-ID: <20090403155756.28714.2265.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Store pages from an NFS inode into the cache data storage object associated
with that inode.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Daire Byrne <Daire.Byrne@framestore.com>
---

 fs/nfs/fscache.c |   28 ++++++++++++++++++++++++++++
 fs/nfs/fscache.h |   16 ++++++++++++++++
 fs/nfs/read.c    |    5 +++++
 3 files changed, 49 insertions(+), 0 deletions(-)


diff --git a/fs/nfs/fscache.c b/fs/nfs/fscache.c
index 3a30566..379be67 100644
--- a/fs/nfs/fscache.c
+++ b/fs/nfs/fscache.c
@@ -493,3 +493,31 @@ int __nfs_readpages_from_fscache(struct nfs_open_context *ctx,
 
 	return ret;
 }
+
+/*
+ * Store a newly fetched page in fscache
+ * - PG_fscache must be set on the page
+ */
+void __nfs_readpage_to_fscache(struct inode *inode, struct page *page, int sync)
+{
+	int ret;
+
+	dfprintk(FSCACHE,
+		 "NFS: readpage_to_fscache(fsc:%p/p:%p(i:%lx f:%lx)/%d)\n",
+		 NFS_I(inode)->fscache, page, page->index, page->flags, sync);
+
+	ret = fscache_write_page(NFS_I(inode)->fscache, page, GFP_KERNEL);
+	dfprintk(FSCACHE,
+		 "NFS:     readpage_to_fscache: p:%p(i:%lu f:%lx) ret %d\n",
+		 page, page->index, page->flags, ret);
+
+	if (ret != 0) {
+		fscache_uncache_page(NFS_I(inode)->fscache, page);
+		nfs_add_fscache_stats(inode,
+				      NFSIOS_FSCACHE_PAGES_WRITTEN_FAIL, 1);
+		nfs_add_fscache_stats(inode, NFSIOS_FSCACHE_PAGES_UNCACHED, 1);
+	} else {
+		nfs_add_fscache_stats(inode,
+				      NFSIOS_FSCACHE_PAGES_WRITTEN_OK, 1);
+	}
+}
diff --git a/fs/nfs/fscache.h b/fs/nfs/fscache.h
index 099349c..1ec3ebb 100644
--- a/fs/nfs/fscache.h
+++ b/fs/nfs/fscache.h
@@ -91,6 +91,7 @@ extern int __nfs_readpage_from_fscache(struct nfs_open_context *,
 extern int __nfs_readpages_from_fscache(struct nfs_open_context *,
 					struct inode *, struct address_space *,
 					struct list_head *, unsigned *);
+extern void __nfs_readpage_to_fscache(struct inode *, struct page *, int);
 
 /*
  * wait for a page to complete writing to the cache
@@ -140,6 +141,19 @@ static inline int nfs_readpages_from_fscache(struct nfs_open_context *ctx,
 	return -ENOBUFS;
 }
 
+/*
+ * Store a page newly fetched from the server in an inode data storage object
+ * in the cache.
+ */
+static inline void nfs_readpage_to_fscache(struct inode *inode,
+					   struct page *page,
+					   int sync)
+{
+	if (PageFsCache(page))
+		__nfs_readpage_to_fscache(inode, page, sync);
+}
+
+
 #else /* CONFIG_NFS_FSCACHE */
 static inline int nfs_fscache_register(void) { return 0; }
 static inline void nfs_fscache_unregister(void) {}
@@ -184,6 +198,8 @@ static inline int nfs_readpages_from_fscache(struct nfs_open_context *ctx,
 {
 	return -ENOBUFS;
 }
+static inline void nfs_readpage_to_fscache(struct inode *inode,
+					   struct page *page, int sync) {}
 
 #endif /* CONFIG_NFS_FSCACHE */
 #endif /* _NFS_FSCACHE_H */
diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index e18ba79..4ace3c5 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -140,6 +140,11 @@ int nfs_readpage_async(struct nfs_open_context *ctx, struct inode *inode,
 
 static void nfs_readpage_release(struct nfs_page *req)
 {
+	struct inode *d_inode = req->wb_context->path.dentry->d_inode;
+
+	if (PageUptodate(req->wb_page))
+		nfs_readpage_to_fscache(d_inode, req->wb_page, 0);
+
 	unlock_page(req->wb_page);
 
 	dprintk("NFS: read done (%s/%Ld %d@%Ld)\n",

