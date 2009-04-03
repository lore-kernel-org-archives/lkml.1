Return-Path: <linux-kernel-owner+w=401wt.eu-S936141AbZDCQKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936141AbZDCQKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934996AbZDCP5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:57:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56660 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934970AbZDCP5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:57:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 30/41] NFS: Define and create superblock-level objects [ver
	#48]
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
Date: Fri, 03 Apr 2009 16:57:10 +0100
Message-ID: <20090403155710.28714.69785.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define and create superblock-level cache index objects (as managed by
nfs_server structs).

Each superblock object is created in a server level index object and is itself
an index into which inode-level objects are inserted.

Ideally there would be one superblock-level object per server, and the former
would be folded into the latter; however, since the "nosharecache" option
exists this isn't possible.

The superblock object key is a sequence consisting of:

 (1) Certain superblock s_flags.

 (2) Various connection parameters that serve to distinguish superblocks for
     sget().

 (3) The volume FSID.

 (4) The security flavour.

 (5) The uniquifier length.

 (6) The uniquifier text.  This is normally an empty string, unless the fsc=xyz
     mount option was used to explicitly specify a uniquifier.

The key blob is of variable length, depending on the length of (6).

The superblock object is given no coherency data to carry in the auxiliary data
permitted by the cache.  It is assumed that the superblock is always coherent.


This patch also adds uniquification handling such that two otherwise identical
superblocks, at least one of which is marked "nosharecache", won't end up
trying to share the on-disk cache.  It will be possible to manually provide a
uniquifier through a mount option with a later patch to avoid the error
otherwise produced.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Daire Byrne <Daire.Byrne@framestore.com>
---

 fs/nfs/fscache-index.c    |   34 +++++++++++++
 fs/nfs/fscache.c          |  116 +++++++++++++++++++++++++++++++++++++++++++++
 fs/nfs/fscache.h          |   49 +++++++++++++++++++
 fs/nfs/internal.h         |    3 +
 fs/nfs/super.c            |    9 +++
 include/linux/nfs_fs_sb.h |    5 ++
 6 files changed, 214 insertions(+), 2 deletions(-)


diff --git a/fs/nfs/fscache-index.c b/fs/nfs/fscache-index.c
index ff14b03..a824050 100644
--- a/fs/nfs/fscache-index.c
+++ b/fs/nfs/fscache-index.c
@@ -112,3 +112,37 @@ const struct fscache_cookie_def nfs_fscache_server_index_def = {
 	.type 		= FSCACHE_COOKIE_TYPE_INDEX,
 	.get_key	= nfs_server_get_key,
 };
+
+/*
+ * Generate a key to describe a superblock key in the main NFS index
+ */
+static uint16_t nfs_super_get_key(const void *cookie_netfs_data,
+				  void *buffer, uint16_t bufmax)
+{
+	const struct nfs_fscache_key *key;
+	const struct nfs_server *nfss = cookie_netfs_data;
+	uint16_t len;
+
+	key = nfss->fscache_key;
+	len = sizeof(key->key) + key->key.uniq_len;
+	if (len > bufmax) {
+		len = 0;
+	} else {
+		memcpy(buffer, &key->key, sizeof(key->key));
+		memcpy(buffer + sizeof(key->key),
+		       key->key.uniquifier, key->key.uniq_len);
+	}
+
+	return len;
+}
+
+/*
+ * Define the superblock object for FS-Cache.  This is used to describe a
+ * superblock object to fscache_acquire_cookie().  It is keyed by all the NFS
+ * parameters that might cause a separate superblock.
+ */
+const struct fscache_cookie_def nfs_fscache_super_index_def = {
+	.name		= "NFS.super",
+	.type 		= FSCACHE_COOKIE_TYPE_INDEX,
+	.get_key	= nfs_super_get_key,
+};
diff --git a/fs/nfs/fscache.c b/fs/nfs/fscache.c
index c3f056f..ab2de2c 100644
--- a/fs/nfs/fscache.c
+++ b/fs/nfs/fscache.c
@@ -23,6 +23,9 @@
 
 #define NFSDBG_FACILITY		NFSDBG_FSCACHE
 
+static struct rb_root nfs_fscache_keys = RB_ROOT;
+static DEFINE_SPINLOCK(nfs_fscache_keys_lock);
+
 /*
  * Get the per-client index cookie for an NFS client if the appropriate mount
  * flag was set
@@ -50,3 +53,116 @@ void nfs_fscache_release_client_cookie(struct nfs_client *clp)
 	fscache_relinquish_cookie(clp->fscache, 0);
 	clp->fscache = NULL;
 }
+
+/*
+ * Get the cache cookie for an NFS superblock.  We have to handle
+ * uniquification here because the cache doesn't do it for us.
+ */
+void nfs_fscache_get_super_cookie(struct super_block *sb,
+				  struct nfs_parsed_mount_data *data)
+{
+	struct nfs_fscache_key *key, *xkey;
+	struct nfs_server *nfss = NFS_SB(sb);
+	struct rb_node **p, *parent;
+	const char *uniq = data->fscache_uniq ?: "";
+	int diff, ulen;
+
+	ulen = strlen(uniq);
+	key = kzalloc(sizeof(*key) + ulen, GFP_KERNEL);
+	if (!key)
+		return;
+
+	key->nfs_client = nfss->nfs_client;
+	key->key.super.s_flags = sb->s_flags & NFS_MS_MASK;
+	key->key.nfs_server.flags = nfss->flags;
+	key->key.nfs_server.rsize = nfss->rsize;
+	key->key.nfs_server.wsize = nfss->wsize;
+	key->key.nfs_server.acregmin = nfss->acregmin;
+	key->key.nfs_server.acregmax = nfss->acregmax;
+	key->key.nfs_server.acdirmin = nfss->acdirmin;
+	key->key.nfs_server.acdirmax = nfss->acdirmax;
+	key->key.nfs_server.fsid = nfss->fsid;
+	key->key.rpc_auth.au_flavor = nfss->client->cl_auth->au_flavor;
+
+	key->key.uniq_len = ulen;
+	memcpy(key->key.uniquifier, uniq, ulen);
+
+	spin_lock(&nfs_fscache_keys_lock);
+	p = &nfs_fscache_keys.rb_node;
+	parent = NULL;
+	while (*p) {
+		parent = *p;
+		xkey = rb_entry(parent, struct nfs_fscache_key, node);
+
+		if (key->nfs_client < xkey->nfs_client)
+			goto go_left;
+		if (key->nfs_client > xkey->nfs_client)
+			goto go_right;
+
+		diff = memcmp(&key->key, &xkey->key, sizeof(key->key));
+		if (diff < 0)
+			goto go_left;
+		if (diff > 0)
+			goto go_right;
+
+		if (key->key.uniq_len == 0)
+			goto non_unique;
+		diff = memcmp(key->key.uniquifier,
+			      xkey->key.uniquifier,
+			      key->key.uniq_len);
+		if (diff < 0)
+			goto go_left;
+		if (diff > 0)
+			goto go_right;
+		goto non_unique;
+
+	go_left:
+		p = &(*p)->rb_left;
+		continue;
+	go_right:
+		p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&key->node, parent, p);
+	rb_insert_color(&key->node, &nfs_fscache_keys);
+	spin_unlock(&nfs_fscache_keys_lock);
+	nfss->fscache_key = key;
+
+	/* create a cache index for looking up filehandles */
+	nfss->fscache = fscache_acquire_cookie(nfss->nfs_client->fscache,
+					       &nfs_fscache_super_index_def,
+					       nfss);
+	dfprintk(FSCACHE, "NFS: get superblock cookie (0x%p/0x%p)\n",
+		 nfss, nfss->fscache);
+	return;
+
+non_unique:
+	spin_unlock(&nfs_fscache_keys_lock);
+	kfree(key);
+	nfss->fscache_key = NULL;
+	nfss->fscache = NULL;
+	printk(KERN_WARNING "NFS:"
+	       " Cache request denied due to non-unique superblock keys\n");
+}
+
+/*
+ * release a per-superblock cookie
+ */
+void nfs_fscache_release_super_cookie(struct super_block *sb)
+{
+	struct nfs_server *nfss = NFS_SB(sb);
+
+	dfprintk(FSCACHE, "NFS: releasing superblock cookie (0x%p/0x%p)\n",
+		 nfss, nfss->fscache);
+
+	fscache_relinquish_cookie(nfss->fscache, 0);
+	nfss->fscache = NULL;
+
+	if (nfss->fscache_key) {
+		spin_lock(&nfs_fscache_keys_lock);
+		rb_erase(&nfss->fscache_key->node, &nfs_fscache_keys);
+		spin_unlock(&nfs_fscache_keys_lock);
+		kfree(nfss->fscache_key);
+		nfss->fscache_key = NULL;
+	}
+}
diff --git a/fs/nfs/fscache.h b/fs/nfs/fscache.h
index 1d864be..22b971e 100644
--- a/fs/nfs/fscache.h
+++ b/fs/nfs/fscache.h
@@ -20,10 +20,48 @@
 #ifdef CONFIG_NFS_FSCACHE
 
 /*
+ * set of NFS FS-Cache objects that form a superblock key
+ */
+struct nfs_fscache_key {
+	struct rb_node		node;
+	struct nfs_client	*nfs_client;	/* the server */
+
+	/* the elements of the unique key - as used by nfs_compare_super() and
+	 * nfs_compare_mount_options() to distinguish superblocks */
+	struct {
+		struct {
+			unsigned long	s_flags;	/* various flags
+							 * (& NFS_MS_MASK) */
+		} super;
+
+		struct {
+			struct nfs_fsid fsid;
+			int		flags;
+			unsigned int	rsize;		/* read size */
+			unsigned int	wsize;		/* write size */
+			unsigned int	acregmin;	/* attr cache timeouts */
+			unsigned int	acregmax;
+			unsigned int	acdirmin;
+			unsigned int	acdirmax;
+		} nfs_server;
+
+		struct {
+			rpc_authflavor_t au_flavor;
+		} rpc_auth;
+
+		/* uniquifier - can be used if nfs_server.flags includes
+		 * NFS_MOUNT_UNSHARED  */
+		u8 uniq_len;
+		char uniquifier[0];
+	} key;
+};
+
+/*
  * fscache-index.c
  */
 extern struct fscache_netfs nfs_fscache_netfs;
 extern const struct fscache_cookie_def nfs_fscache_server_index_def;
+extern const struct fscache_cookie_def nfs_fscache_super_index_def;
 
 extern int nfs_fscache_register(void);
 extern void nfs_fscache_unregister(void);
@@ -34,6 +72,10 @@ extern void nfs_fscache_unregister(void);
 extern void nfs_fscache_get_client_cookie(struct nfs_client *);
 extern void nfs_fscache_release_client_cookie(struct nfs_client *);
 
+extern void nfs_fscache_get_super_cookie(struct super_block *,
+					 struct nfs_parsed_mount_data *);
+extern void nfs_fscache_release_super_cookie(struct super_block *);
+
 #else /* CONFIG_NFS_FSCACHE */
 static inline int nfs_fscache_register(void) { return 0; }
 static inline void nfs_fscache_unregister(void) {}
@@ -41,5 +83,12 @@ static inline void nfs_fscache_unregister(void) {}
 static inline void nfs_fscache_get_client_cookie(struct nfs_client *clp) {}
 static inline void nfs_fscache_release_client_cookie(struct nfs_client *clp) {}
 
+static inline void nfs_fscache_get_super_cookie(
+	struct super_block *sb,
+	struct nfs_parsed_mount_data *data)
+{
+}
+static inline void nfs_fscache_release_super_cookie(struct super_block *sb) {}
+
 #endif /* CONFIG_NFS_FSCACHE */
 #endif /* _NFS_FSCACHE_H */
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 2041f68..0130700 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -5,6 +5,8 @@
 #include <linux/mount.h>
 #include <linux/security.h>
 
+#define NFS_MS_MASK (MS_RDONLY|MS_NOSUID|MS_NODEV|MS_NOEXEC|MS_SYNCHRONOUS)
+
 struct nfs_string;
 
 /* Maximum number of readahead requests
@@ -41,6 +43,7 @@ struct nfs_parsed_mount_data {
 	unsigned int		auth_flavor_len;
 	rpc_authflavor_t	auth_flavors[1];
 	char			*client_address;
+	char			*fscache_uniq;
 
 	struct {
 		struct sockaddr_storage	address;
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 0942fcb..87f65ae 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -60,6 +60,7 @@
 #include "delegation.h"
 #include "iostat.h"
 #include "internal.h"
+#include "fscache.h"
 
 #define NFSDBG_FACILITY		NFSDBG_VFS
 
@@ -1870,8 +1871,6 @@ static void nfs_clone_super(struct super_block *sb,
  	nfs_initialise_sb(sb);
 }
 
-#define NFS_MS_MASK (MS_RDONLY|MS_NOSUID|MS_NODEV|MS_NOEXEC|MS_SYNCHRONOUS)
-
 static int nfs_compare_mount_options(const struct super_block *s, const struct nfs_server *b, int flags)
 {
 	const struct nfs_server *a = s->s_fs_info;
@@ -2036,6 +2035,7 @@ static int nfs_get_sb(struct file_system_type *fs_type,
 	if (!s->s_root) {
 		/* initial superblock/root creation */
 		nfs_fill_super(s, data);
+		nfs_fscache_get_super_cookie(s, data);
 	}
 
 	mntroot = nfs_get_root(s, mntfh);
@@ -2056,6 +2056,7 @@ static int nfs_get_sb(struct file_system_type *fs_type,
 out:
 	kfree(data->nfs_server.hostname);
 	kfree(data->mount_server.hostname);
+	kfree(data->fscache_uniq);
 	security_free_mnt_opts(&data->lsm_opts);
 out_free_fh:
 	kfree(mntfh);
@@ -2083,6 +2084,7 @@ static void nfs_kill_super(struct super_block *s)
 
 	bdi_unregister(&server->backing_dev_info);
 	kill_anon_super(s);
+	nfs_fscache_release_super_cookie(s);
 	nfs_free_server(server);
 }
 
@@ -2390,6 +2392,7 @@ static int nfs4_get_sb(struct file_system_type *fs_type,
 	if (!s->s_root) {
 		/* initial superblock/root creation */
 		nfs4_fill_super(s);
+		nfs_fscache_get_super_cookie(s, data);
 	}
 
 	mntroot = nfs4_get_root(s, mntfh);
@@ -2411,6 +2414,7 @@ out:
 	kfree(data->client_address);
 	kfree(data->nfs_server.export_path);
 	kfree(data->nfs_server.hostname);
+	kfree(data->fscache_uniq);
 	security_free_mnt_opts(&data->lsm_opts);
 out_free_fh:
 	kfree(mntfh);
@@ -2437,6 +2441,7 @@ static void nfs4_kill_super(struct super_block *sb)
 	kill_anon_super(sb);
 
 	nfs4_renewd_prepare_shutdown(server);
+	nfs_fscache_release_super_cookie(sb);
 	nfs_free_server(server);
 }
 
diff --git a/include/linux/nfs_fs_sb.h b/include/linux/nfs_fs_sb.h
index 0a374b9..6ad7594 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -108,6 +108,11 @@ struct nfs_server {
 	unsigned long		mount_time;	/* when this fs was mounted */
 	dev_t			s_dev;		/* superblock dev numbers */
 
+#ifdef CONFIG_NFS_FSCACHE
+	struct nfs_fscache_key	*fscache_key;	/* unique key for superblock */
+	struct fscache_cookie	*fscache;	/* superblock cookie */
+#endif
+
 #ifdef CONFIG_NFS_V4
 	u32			attr_bitmask[2];/* V4 bitmask representing the set
 						   of attributes supported on this

