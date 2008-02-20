Return-Path: <linux-kernel-owner+w=401wt.eu-S934217AbYBTQ0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934217AbYBTQ0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:26:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765341AbYBTQLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:11:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762364AbYBTQLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:11:04 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 35/37] NFS: Store pages from an NFS inode into a local cache
To: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 20 Feb 2008 16:09:06 +0000
Message-ID: <20080220160905.4715.18479.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
References: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Store pages from an NFS inode into the cache data storage object associated
with that inode.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/nfs/fscache.c |   26 ++++++++++++++++++++++++++
 fs/nfs/fscache.h |   16 ++++++++++++++++
 fs/nfs/read.c    |    5 +++++
 3 files changed, 47 insertions(+), 0 deletions(-)


diff --git a/fs/nfs/fscache.c b/fs/nfs/fscache.c
index 438cc9b..50ae70f 100644
--- a/fs/nfs/fscache.c
+++ b/fs/nfs/fscache.c
@@ -456,3 +456,29 @@ int __nfs_readpages_from_fscache(struct nfs_open_context *ctx,
 
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
+		nfs_add_stats(inode, NFSIOS_FSCACHE_WRITE_FAIL, 1);
+		nfs_add_stats(inode, NFSIOS_FSCACHE_UNCACHE, 1);
+	} else {
+		nfs_add_stats(inode, NFSIOS_FSCACHE_WRITE_OK, 1);
+	}
+}
diff --git a/fs/nfs/fscache.h b/fs/nfs/fscache.h
index 4c1e1a8..6264cd8 100644
--- a/fs/nfs/fscache.h
+++ b/fs/nfs/fscache.h
@@ -94,6 +94,7 @@ extern int __nfs_readpage_from_fscache(struct nfs_open_context *,
 extern int __nfs_readpages_from_fscache(struct nfs_open_context *,
 					struct inode *, struct address_space *,
 					struct list_head *, unsigned *);
+extern void __nfs_readpage_to_fscache(struct inode *, struct page *, int);
 
 /*
  * release the caching state associated with a page if undergoing complete page
@@ -133,6 +134,19 @@ static inline int nfs_readpages_from_fscache(struct nfs_open_context *ctx,
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
@@ -178,6 +192,8 @@ static inline int nfs_readpages_from_fscache(struct nfs_open_context *ctx,
 {
 	return -ENOBUFS;
 }
+static inline void nfs_readpage_to_fscache(struct inode *inode,
+					   struct page *page, int sync) {}
 
 #endif /* CONFIG_NFS_FSCACHE */
 #endif /* _NFS_FSCACHE_H */
diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index db27b26..e09bdf9 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -143,6 +143,11 @@ int nfs_readpage_async(struct nfs_open_context *ctx, struct inode *inode,
 
 static void nfs_readpage_release(struct nfs_page *req)
 {
+	struct inode *d_inode = req->wb_context->path.dentry->d_inode;
+
+	if (PageUptodate(req->wb_page))
+		nfs_readpage_to_fscache(d_inode, req->wb_page, 0);
+
 	unlock_page(req->wb_page);
 
 	dprintk("NFS: read done (%s/%Ld %d@%Ld)\n",

