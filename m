Return-Path: <linux-kernel-owner+w=401wt.eu-S935297AbZDCQLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935297AbZDCQLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935001AbZDCP5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:57:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56671 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934971AbZDCP5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:57:32 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 33/41] NFS: Invalidate FsCache page flags when cache removed
	[ver #48]
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
Date: Fri, 03 Apr 2009 16:57:26 +0100
Message-ID: <20090403155726.28714.50070.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Invalidate the FsCache page flags on the pages belonging to an inode when the
cache backing that NFS inode is removed.

This allows a live cache to be withdrawn.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Daire Byrne <Daire.Byrne@framestore.com>
---

 fs/nfs/fscache-index.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)


diff --git a/fs/nfs/fscache-index.c b/fs/nfs/fscache-index.c
index 7bc54ac..a119b56 100644
--- a/fs/nfs/fscache-index.c
+++ b/fs/nfs/fscache-index.c
@@ -253,6 +253,45 @@ enum fscache_checkaux nfs_fscache_inode_check_aux(void *cookie_netfs_data,
 }
 
 /*
+ * Indication from FS-Cache that the cookie is no longer cached
+ * - This function is called when the backing store currently caching a cookie
+ *   is removed
+ * - The netfs should use this to clean up any markers indicating cached pages
+ * - This is mandatory for any object that may have data
+ */
+static void nfs_fscache_inode_now_uncached(void *cookie_netfs_data)
+{
+	struct nfs_inode *nfsi = cookie_netfs_data;
+	struct pagevec pvec;
+	pgoff_t first;
+	int loop, nr_pages;
+
+	pagevec_init(&pvec, 0);
+	first = 0;
+
+	dprintk("NFS: nfs_inode_now_uncached: nfs_inode 0x%p\n", nfsi);
+
+	for (;;) {
+		/* grab a bunch of pages to unmark */
+		nr_pages = pagevec_lookup(&pvec,
+					  nfsi->vfs_inode.i_mapping,
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
+/*
  * Define the inode object for FS-Cache.  This is used to describe an inode
  * object to fscache_acquire_cookie().  It is keyed by the NFS file handle for
  * an inode.
@@ -268,4 +307,5 @@ const struct fscache_cookie_def nfs_fscache_inode_object_def = {
 	.get_attr	= nfs_fscache_inode_get_attr,
 	.get_aux	= nfs_fscache_inode_get_aux,
 	.check_aux	= nfs_fscache_inode_check_aux,
+	.now_uncached	= nfs_fscache_inode_now_uncached,
 };

