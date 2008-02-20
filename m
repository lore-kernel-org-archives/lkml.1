Return-Path: <linux-kernel-owner+w=401wt.eu-S933429AbYBTQ2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933429AbYBTQ2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765174AbYBTQMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:12:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763351AbYBTQL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:11:58 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 32/37] NFS: Add read context retention for FS-Cache to call
	back with
To: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 20 Feb 2008 16:08:50 +0000
Message-ID: <20080220160849.4715.2979.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
References: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
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
---

 fs/nfs/fscache-index.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)


diff --git a/fs/nfs/fscache-index.c b/fs/nfs/fscache-index.c
index eec8e7e..af9f06b 100644
--- a/fs/nfs/fscache-index.c
+++ b/fs/nfs/fscache-index.c
@@ -285,6 +285,30 @@ static void nfs_cache_inode_now_uncached(void *cookie_netfs_data)
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
@@ -301,4 +325,6 @@ const struct fscache_cookie_def nfs_cache_inode_object_def = {
 	.get_aux	= nfs_cache_inode_get_aux,
 	.check_aux	= nfs_cache_inode_check_aux,
 	.now_uncached	= nfs_cache_inode_now_uncached,
+	.get_context	= nfs_fh_get_context,
+	.put_context	= nfs_fh_put_context,
 };

