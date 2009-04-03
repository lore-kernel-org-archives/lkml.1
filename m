Return-Path: <linux-kernel-owner+w=401wt.eu-S936347AbZDCQNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936347AbZDCQNF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935038AbZDCP5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:57:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56687 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935030AbZDCP5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:57:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 36/41] NFS: Add read context retention for FS-Cache to call
	back with [ver #48]
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
Date: Fri, 03 Apr 2009 16:57:41 +0100
Message-ID: <20090403155741.28714.29069.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add read context retention so that FS-Cache can call back into NFS when a read
operation on the cache fails EIO rather than reading data.  This permits NFS to
then fetch the data from the server instead using the appropriate security
context.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Daire Byrne <Daire.Byrne@framestore.com>
---

 fs/nfs/fscache-index.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)


diff --git a/fs/nfs/fscache-index.c b/fs/nfs/fscache-index.c
index a119b56..5b10064 100644
--- a/fs/nfs/fscache-index.c
+++ b/fs/nfs/fscache-index.c
@@ -292,6 +292,30 @@ static void nfs_fscache_inode_now_uncached(void *cookie_netfs_data)
 }
 
 /*
+ * Get an extra reference on a read context.
+ * - This function can be absent if the completion function doesn't require a
+ *   context.
+ * - The read context is passed back to NFS in the event that a data read on the
+ *   cache fails with EIO - in which case the server must be contacted to
+ *   retrieve the data, which requires the read context for security.
+ */
+static void nfs_fh_get_context(void *cookie_netfs_data, void *context)
+{
+	get_nfs_open_context(context);
+}
+
+/*
+ * Release an extra reference on a read context.
+ * - This function can be absent if the completion function doesn't require a
+ *   context.
+ */
+static void nfs_fh_put_context(void *cookie_netfs_data, void *context)
+{
+	if (context)
+		put_nfs_open_context(context);
+}
+
+/*
  * Define the inode object for FS-Cache.  This is used to describe an inode
  * object to fscache_acquire_cookie().  It is keyed by the NFS file handle for
  * an inode.
@@ -308,4 +332,6 @@ const struct fscache_cookie_def nfs_fscache_inode_object_def = {
 	.get_aux	= nfs_fscache_inode_get_aux,
 	.check_aux	= nfs_fscache_inode_check_aux,
 	.now_uncached	= nfs_fscache_inode_now_uncached,
+	.get_context	= nfs_fh_get_context,
+	.put_context	= nfs_fh_put_context,
 };

