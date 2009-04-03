Return-Path: <linux-kernel-owner+w=401wt.eu-S936192AbZDCQKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936192AbZDCQKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934994AbZDCP52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:57:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56662 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934990AbZDCP5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:57:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 31/41] NFS: Define and create inode-level cache objects [ver
	#48]
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
Date: Fri, 03 Apr 2009 16:57:15 +0100
Message-ID: <20090403155715.28714.73526.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define and create inode-level cache data storage objects (as managed by
nfs_inode structs).

Each inode-level object is created in a superblock-level index object and is
itself a data storage object into which pages from the inode are stored.

The inode object key is the NFS file handle for the inode.

The inode object is given coherency data to carry in the auxiliary data
permitted by the cache.  This is a sequence made up of:

 (1) i_mtime from the NFS inode.

 (2) i_ctime from the NFS inode.

 (3) i_size from the NFS inode.

 (4) change_attr from the NFSv4 attribute data.

As the cache is a persistent cache, the auxiliary data is checked when a new
NFS in-memory inode is set up that matches an already existing data storage
object in the cache.  If the coherency data is the same, the on-disk object is
retained and used; if not, it is scrapped and a new one created.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Daire Byrne <Daire.Byrne@framestore.com>
---

 fs/nfs/fscache-index.c |  123 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nfs/fscache.h       |    1 
 2 files changed, 124 insertions(+), 0 deletions(-)


diff --git a/fs/nfs/fscache-index.c b/fs/nfs/fscache-index.c
index a824050..7bc54ac 100644
--- a/fs/nfs/fscache-index.c
+++ b/fs/nfs/fscache-index.c
@@ -146,3 +146,126 @@ const struct fscache_cookie_def nfs_fscache_super_index_def = {
 	.type 		= FSCACHE_COOKIE_TYPE_INDEX,
 	.get_key	= nfs_super_get_key,
 };
+
+/*
+ * Definition of the auxiliary data attached to NFS inode storage objects
+ * within the cache.
+ *
+ * The contents of this struct are recorded in the on-disk local cache in the
+ * auxiliary data attached to the data storage object backing an inode.  This
+ * permits coherency to be managed when a new inode binds to an already extant
+ * cache object.
+ */
+struct nfs_fscache_inode_auxdata {
+	struct timespec	mtime;
+	struct timespec	ctime;
+	loff_t		size;
+	u64		change_attr;
+};
+
+/*
+ * Generate a key to describe an NFS inode in an NFS server's index
+ */
+static uint16_t nfs_fscache_inode_get_key(const void *cookie_netfs_data,
+					  void *buffer, uint16_t bufmax)
+{
+	const struct nfs_inode *nfsi = cookie_netfs_data;
+	uint16_t nsize;
+
+	/* use the inode's NFS filehandle as the key */
+	nsize = nfsi->fh.size;
+	memcpy(buffer, nfsi->fh.data, nsize);
+	return nsize;
+}
+
+/*
+ * Get certain file attributes from the netfs data
+ * - This function can be absent for an index
+ * - Not permitted to return an error
+ * - The netfs data from the cookie being used as the source is presented
+ */
+static void nfs_fscache_inode_get_attr(const void *cookie_netfs_data,
+				       uint64_t *size)
+{
+	const struct nfs_inode *nfsi = cookie_netfs_data;
+
+	*size = nfsi->vfs_inode.i_size;
+}
+
+/*
+ * Get the auxiliary data from netfs data
+ * - This function can be absent if the index carries no state data
+ * - Should store the auxiliary data in the buffer
+ * - Should return the amount of amount stored
+ * - Not permitted to return an error
+ * - The netfs data from the cookie being used as the source is presented
+ */
+static uint16_t nfs_fscache_inode_get_aux(const void *cookie_netfs_data,
+					  void *buffer, uint16_t bufmax)
+{
+	struct nfs_fscache_inode_auxdata auxdata;
+	const struct nfs_inode *nfsi = cookie_netfs_data;
+
+	memset(&auxdata, 0, sizeof(auxdata));
+	auxdata.size = nfsi->vfs_inode.i_size;
+	auxdata.mtime = nfsi->vfs_inode.i_mtime;
+	auxdata.ctime = nfsi->vfs_inode.i_ctime;
+
+	if (NFS_SERVER(&nfsi->vfs_inode)->nfs_client->rpc_ops->version == 4)
+		auxdata.change_attr = nfsi->change_attr;
+
+	if (bufmax > sizeof(auxdata))
+		bufmax = sizeof(auxdata);
+
+	memcpy(buffer, &auxdata, bufmax);
+	return bufmax;
+}
+
+/*
+ * Consult the netfs about the state of an object
+ * - This function can be absent if the index carries no state data
+ * - The netfs data from the cookie being used as the target is
+ *   presented, as is the auxiliary data
+ */
+static
+enum fscache_checkaux nfs_fscache_inode_check_aux(void *cookie_netfs_data,
+						  const void *data,
+						  uint16_t datalen)
+{
+	struct nfs_fscache_inode_auxdata auxdata;
+	struct nfs_inode *nfsi = cookie_netfs_data;
+
+	if (datalen != sizeof(auxdata))
+		return FSCACHE_CHECKAUX_OBSOLETE;
+
+	memset(&auxdata, 0, sizeof(auxdata));
+	auxdata.size = nfsi->vfs_inode.i_size;
+	auxdata.mtime = nfsi->vfs_inode.i_mtime;
+	auxdata.ctime = nfsi->vfs_inode.i_ctime;
+
+	if (NFS_SERVER(&nfsi->vfs_inode)->nfs_client->rpc_ops->version == 4)
+		auxdata.change_attr = nfsi->change_attr;
+
+	if (memcmp(data, &auxdata, datalen) != 0)
+		return FSCACHE_CHECKAUX_OBSOLETE;
+
+	return FSCACHE_CHECKAUX_OKAY;
+}
+
+/*
+ * Define the inode object for FS-Cache.  This is used to describe an inode
+ * object to fscache_acquire_cookie().  It is keyed by the NFS file handle for
+ * an inode.
+ *
+ * Coherency is managed by comparing the copies of i_size, i_mtime and i_ctime
+ * held in the cache auxiliary data for the data storage object with those in
+ * the inode struct in memory.
+ */
+const struct fscache_cookie_def nfs_fscache_inode_object_def = {
+	.name		= "NFS.fh",
+	.type		= FSCACHE_COOKIE_TYPE_DATAFILE,
+	.get_key	= nfs_fscache_inode_get_key,
+	.get_attr	= nfs_fscache_inode_get_attr,
+	.get_aux	= nfs_fscache_inode_get_aux,
+	.check_aux	= nfs_fscache_inode_check_aux,
+};
diff --git a/fs/nfs/fscache.h b/fs/nfs/fscache.h
index 22b971e..d21b590 100644
--- a/fs/nfs/fscache.h
+++ b/fs/nfs/fscache.h
@@ -62,6 +62,7 @@ struct nfs_fscache_key {
 extern struct fscache_netfs nfs_fscache_netfs;
 extern const struct fscache_cookie_def nfs_fscache_server_index_def;
 extern const struct fscache_cookie_def nfs_fscache_super_index_def;
+extern const struct fscache_cookie_def nfs_fscache_inode_object_def;
 
 extern int nfs_fscache_register(void);
 extern void nfs_fscache_unregister(void);

