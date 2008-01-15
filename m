Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbYAOX6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbYAOX6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 18:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757804AbYAOXth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 18:49:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757972AbYAOXtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 18:49:17 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 26/26] NFS: Separate caching by superblock,
	explicitly if necessary
To: sds@tycho.nsa.gov, casey@schaufler-ca.com, Trond.Myklebust@netapp.com,
       npiggin@suse.de
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Tue, 15 Jan 2008 23:49:11 +0000
Message-ID: <20080115234911.22183.95772.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080115234652.22183.24850.stgit@warthog.procyon.org.uk>
References: <20080115234652.22183.24850.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate caching by superblock, explicitly if necessary.  This means mounts of
the same remote data with different parameters do not share cache objects for
common files.  The administrator may also provide a uniquifier to further
enhance the uniqueness.

Where it is otherwise impossible to distinguish superblocks because all the
parameters are identical, but the 'nosharecache' option is supplied, a
uniquifying string must be supplied, else only the first mount will be
permitted to use the cache.

If there's a key collision, then the second mount will disable caching and give
a warning into the kernel log.

There are three variant NFS mount options that can be added to a mount command
to control caching for a mount.  Only the last one specified takes effect:

 (*) Adding "fsc" will request caching.

 (*) Adding "fsc=<string>" will request caching and also specify a uniquifier.

 (*) Adding "nofsc" will disable caching.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/nfs/fscache-def.c      |   33 ++++++++++++
 fs/nfs/fscache.c          |  122 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/nfs/fscache.h          |   46 ++++++++++++++++-
 fs/nfs/internal.h         |    3 +
 fs/nfs/super.c            |   24 +++++++--
 include/linux/nfs_fs_sb.h |    3 +
 6 files changed, 220 insertions(+), 11 deletions(-)


diff --git a/fs/nfs/fscache-def.c b/fs/nfs/fscache-def.c
index bc20b7d..1d10b4e 100644
--- a/fs/nfs/fscache-def.c
+++ b/fs/nfs/fscache-def.c
@@ -117,6 +117,39 @@ const struct fscache_cookie_def nfs_cache_server_index_def = {
 };
 
 /*
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
+ * The superblock index for the filesystem is defined by all the NFS parameters
+ * that might cause a separate superblock
+ */
+const struct fscache_cookie_def nfs_cache_super_index_def = {
+	.name		= "NFS.supers",
+	.type 		= FSCACHE_COOKIE_TYPE_INDEX,
+	.get_key	= nfs_super_get_key,
+};
+
+/*
  * Generate a key to describe an NFS inode in an NFS server's index
  */
 static uint16_t nfs_fh_get_key(const void *cookie_netfs_data,
diff --git a/fs/nfs/fscache.c b/fs/nfs/fscache.c
index 465f961..af9c65c 100644
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
@@ -52,6 +55,118 @@ void nfs_fscache_release_client_cookie(struct nfs_client *clp)
 }
 
 /*
+ * get a cookie for a superblock
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
+					       &nfs_cache_super_index_def,
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
+
+/*
  * Display statistics through /proc/pid/mountstats
  */
 void nfs_fscache_show_stats(struct seq_file *m, struct nfs_server *nfss)
@@ -90,10 +205,9 @@ void nfs_fscache_enable_fh_cookie(struct inode *inode)
 		return;
 
 	if ((NFS_SB(sb)->options & NFS_OPTION_FSCACHE)) {
-		nfsi->fscache = fscache_acquire_cookie(
-			NFS_SB(sb)->nfs_client->fscache,
-			&nfs_cache_fh_index_def,
-			nfsi);
+		nfsi->fscache = fscache_acquire_cookie(NFS_SB(sb)->fscache,
+						       &nfs_cache_fh_index_def,
+						       nfsi);
 
 		dfprintk(FSCACHE, "NFS: get FH cookie (0x%p/0x%p/0x%p)\n",
 			 sb, nfsi, nfsi->fscache);
diff --git a/fs/nfs/fscache.h b/fs/nfs/fscache.h
index 9a735fc..484920a 100644
--- a/fs/nfs/fscache.h
+++ b/fs/nfs/fscache.h
@@ -20,10 +20,47 @@
 #include <linux/fscache.h>
 
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
+			unsigned long	s_flags;	/* various flags (& NFS_MS_MASK) */
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
  * fscache-def.c
  */
 extern struct fscache_netfs nfs_cache_netfs;
 extern const struct fscache_cookie_def nfs_cache_server_index_def;
+extern const struct fscache_cookie_def nfs_cache_super_index_def;
 extern const struct fscache_cookie_def nfs_cache_fh_index_def;
 
 extern int nfs_fscache_register(void);
@@ -34,6 +71,9 @@ extern void nfs_fscache_unregister(void);
  */
 extern void nfs_fscache_get_client_cookie(struct nfs_client *);
 extern void nfs_fscache_release_client_cookie(struct nfs_client *);
+extern void nfs_fscache_get_super_cookie(struct super_block *,
+					 struct nfs_parsed_mount_data *);
+extern void nfs_fscache_release_super_cookie(struct super_block *);
 extern void nfs_fscache_show_stats(struct seq_file *, struct nfs_server *);
 extern void nfs_fscache_init_fh_cookie(struct inode *);
 extern void nfs_fscache_enable_fh_cookie(struct inode *);
@@ -57,8 +97,7 @@ extern int nfs_fscache_release_page(struct page *, gfp_t);
  */
 static inline const char *nfs_server_fscache_state(struct nfs_server *server)
 {
-	if (server->nfs_client->fscache &&
-	    (server->options & NFS_OPTION_FSCACHE))
+	if (server->fscache && (server->options & NFS_OPTION_FSCACHE))
 		return "yes";
 	return "no ";
 }
@@ -118,6 +157,9 @@ static inline void nfs_fscache_unregister(void) {}
 static inline void nfs_fscache_get_client_cookie(struct nfs_client *clp) {}
 static inline void nfs4_fscache_get_client_cookie(struct nfs_client *clp) {}
 static inline void nfs_fscache_release_client_cookie(struct nfs_client *clp) {}
+static inline void nfs_fscache_get_super_cookie(struct super_block *sb,
+						struct nfs_parsed_mount_data *data) {}
+static inline void nfs_fscache_release_super_cookie(struct super_block *sb) {}
 static inline void nfs_fscache_show_stats(struct seq_file *m,
 					  struct nfs_server *nfss) {}
 static inline const char *nfs_server_fscache_state(struct nfs_server *server)
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index ef09e00..68c5516 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -4,6 +4,8 @@
 
 #include <linux/mount.h>
 
+#define NFS_MS_MASK (MS_RDONLY|MS_NOSUID|MS_NODEV|MS_NOEXEC|MS_SYNCHRONOUS)
+
 struct nfs_string;
 
 /* Maximum number of readahead requests
@@ -40,6 +42,7 @@ struct nfs_parsed_mount_data {
 	unsigned int		auth_flavor_len;
 	rpc_authflavor_t	auth_flavors[1];
 	char			*client_address;
+	char			*fscache_uniq;
 
 	struct {
 		struct sockaddr_in	address;
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 0542550..3e77681 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -91,6 +91,7 @@ enum {
 	/* Mount options that take string arguments */
 	Opt_sec, Opt_proto, Opt_mountproto,
 	Opt_addr, Opt_mountaddr, Opt_clientaddr,
+	Opt_fscache_uniq,
 
 	/* Mount options that are ignored */
 	Opt_userspace, Opt_deprecated,
@@ -125,6 +126,7 @@ static match_table_t nfs_mount_option_tokens = {
 	{ Opt_sharecache, "sharecache" },
 	{ Opt_nosharecache, "nosharecache" },
 	{ Opt_fscache, "fsc" },
+	{ Opt_fscache_uniq, "fsc=%s" },
 	{ Opt_nofscache, "nofsc" },
 
 	{ Opt_port, "port=%u" },
@@ -702,15 +704,24 @@ static int nfs_parse_mount_options(char *raw,
 			break;
 		case Opt_nosharecache:
 			mnt->flags |= NFS_MOUNT_UNSHARED;
-			mnt->options &= ~NFS_OPTION_FSCACHE;
 			break;
 		case Opt_fscache:
-			/* sharing is mandatory with fscache */
 			mnt->options |= NFS_OPTION_FSCACHE;
-			mnt->flags &= ~NFS_MOUNT_UNSHARED;
+			kfree(mnt->fscache_uniq);
+			mnt->fscache_uniq = NULL;
 			break;
 		case Opt_nofscache:
 			mnt->options &= ~NFS_OPTION_FSCACHE;
+			kfree(mnt->fscache_uniq);
+			mnt->fscache_uniq = NULL;
+			break;
+		case Opt_fscache_uniq:
+			string = match_strdup(args);
+			if (!string)
+				goto out_nomem;
+			kfree(mnt->fscache_uniq);
+			mnt->fscache_uniq = string;
+			mnt->options |= NFS_OPTION_FSCACHE;
 			break;
 
 		case Opt_port:
@@ -1288,8 +1299,6 @@ static void nfs_clone_super(struct super_block *sb,
  	nfs_initialise_sb(sb);
 }
 
-#define NFS_MS_MASK (MS_RDONLY|MS_NOSUID|MS_NODEV|MS_NOEXEC|MS_SYNCHRONOUS)
-
 static int nfs_compare_mount_options(const struct super_block *s, const struct nfs_server *b, int flags)
 {
 	const struct nfs_server *a = s->s_fs_info;
@@ -1403,6 +1412,7 @@ static int nfs_get_sb(struct file_system_type *fs_type,
 	if (!s->s_root) {
 		/* initial superblock/root creation */
 		nfs_fill_super(s, &data);
+		nfs_fscache_get_super_cookie(s, &data);
 	}
 
 	mntroot = nfs_get_root(s, &mntfh);
@@ -1418,6 +1428,7 @@ static int nfs_get_sb(struct file_system_type *fs_type,
 
 out:
 	kfree(data.nfs_server.hostname);
+	kfree(data.fscache_uniq);
 	return error;
 
 out_err_nosb:
@@ -1438,6 +1449,7 @@ static void nfs_kill_super(struct super_block *s)
 	struct nfs_server *server = NFS_SB(s);
 
 	kill_anon_super(s);
+	nfs_fscache_release_super_cookie(s);
 	nfs_free_server(server);
 }
 
@@ -1752,6 +1764,7 @@ static int nfs4_get_sb(struct file_system_type *fs_type,
 	if (!s->s_root) {
 		/* initial superblock/root creation */
 		nfs4_fill_super(s);
+		nfs_fscache_get_super_cookie(s, &data);
 	}
 
 	mntroot = nfs4_get_root(s, &mntfh);
@@ -1769,6 +1782,7 @@ out:
 	kfree(data.client_address);
 	kfree(data.nfs_server.export_path);
 	kfree(data.nfs_server.hostname);
+	kfree(data.fscache_uniq);
 	return error;
 
 out_free:
diff --git a/include/linux/nfs_fs_sb.h b/include/linux/nfs_fs_sb.h
index 3c8e15d..3309614 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -109,6 +109,9 @@ struct nfs_server {
 	dev_t			s_dev;		/* superblock dev numbers */
 
 #ifdef CONFIG_NFS_FSCACHE
+	struct nfs_fscache_key	*fscache_key;	/* unique key for superblock */
+	struct fscache_cookie	*fscache;	/* superblock cookie */
+
 	/* statistical counters for local caching */
 	atomic_t		fscache_cnt_read_ok;
 	atomic_t		fscache_cnt_read_fail;

