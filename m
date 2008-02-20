Return-Path: <linux-kernel-owner+w=401wt.eu-S932770AbYBTQQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770AbYBTQQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:16:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764063AbYBTQJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:09:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760834AbYBTQJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:09:27 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 27/37] NFS: Define and create inode-level cache objects
To: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 20 Feb 2008 16:08:23 +0000
Message-ID: <20080220160823.4715.43857.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
References: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
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

As the cache is a persistent cache, the auxiliary data is checked when a new
NFS in-memory inode is set up that matches an already existing data storage
object in the cache.  If the coherency data is the same, the on-disk object is
retained and used; if not, it is scrapped and a new one created.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/nfs/fscache-index.c |  112 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nfs/fscache.h       |    1 
 2 files changed, 113 insertions(+), 0 deletions(-)


diff --git a/fs/nfs/fscache-index.c b/fs/nfs/fscache-index.c
index b5a52e3..c3c63fa 100644
--- a/fs/nfs/fscache-index.c
+++ b/fs/nfs/fscache-index.c
@@ -150,3 +150,115 @@ const struct fscache_cookie_def nfs_cache_super_index_def = {
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
+struct nfs_cache_inode_auxdata {
+	struct timespec	mtime;
+	struct timespec	ctime;
+	loff_t		size;
+};
+
+/*
+ * Generate a key to describe an NFS inode in an NFS server's index
+ */
+static uint16_t nfs_cache_inode_get_key(const void *cookie_netfs_data,
+					void *buffer, uint16_t bufmax)
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
+static void nfs_cache_inode_get_attr(const void *cookie_netfs_data, uint64_t *size)
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
+static uint16_t nfs_cache_inode_get_aux(const void *cookie_netfs_data,
+					void *buffer, uint16_t bufmax)
+{
+	struct nfs_cache_inode_auxdata auxdata;
+	const struct nfs_inode *nfsi = cookie_netfs_data;
+
+	auxdata.size = nfsi->vfs_inode.i_size;
+	auxdata.mtime = nfsi->vfs_inode.i_mtime;
+	auxdata.ctime = nfsi->vfs_inode.i_ctime;
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
+static enum fscache_checkaux nfs_cache_inode_check_aux(void *cookie_netfs_data,
+						       const void *data,
+						       uint16_t datalen)
+{
+	struct nfs_cache_inode_auxdata auxdata;
+	struct nfs_inode *nfsi = cookie_netfs_data;
+
+	if (datalen > sizeof(auxdata))
+		return FSCACHE_CHECKAUX_OBSOLETE;
+
+	auxdata.size = nfsi->vfs_inode.i_size;
+	auxdata.mtime = nfsi->vfs_inode.i_mtime;
+	auxdata.ctime = nfsi->vfs_inode.i_ctime;
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
+const struct fscache_cookie_def nfs_cache_inode_object_def = {
+	.name		= "NFS.fh",
+	.type		= FSCACHE_COOKIE_TYPE_DATAFILE,
+	.get_key	= nfs_cache_inode_get_key,
+	.get_attr	= nfs_cache_inode_get_attr,
+	.get_aux	= nfs_cache_inode_get_aux,
+	.check_aux	= nfs_cache_inode_check_aux,
+};
diff --git a/fs/nfs/fscache.h b/fs/nfs/fscache.h
index 242cc07..7dcdf32 100644
--- a/fs/nfs/fscache.h
+++ b/fs/nfs/fscache.h
@@ -62,6 +62,7 @@ struct nfs_fscache_key {
 extern struct fscache_netfs nfs_cache_netfs;
 extern const struct fscache_cookie_def nfs_cache_server_index_def;
 extern const struct fscache_cookie_def nfs_cache_super_index_def;
+extern const struct fscache_cookie_def nfs_cache_inode_object_def;
 
 extern int nfs_fscache_register(void);
 extern void nfs_fscache_unregister(void);

