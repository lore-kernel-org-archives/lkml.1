Return-Path: <linux-kernel-owner+w=401wt.eu-S1758684AbZIOVvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684AbZIOVvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 17:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbZIOVvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 17:51:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbZIOVvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 17:51:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] NFS: Propagate 'fsc' mount option through automounts
To: Trond.Myklebust@netapp.com
Cc: steved@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Date: Tue, 15 Sep 2009 22:50:52 +0100
Message-ID: <20090915215052.27306.74192.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Propagate the NFS 'fsc' mount option through NFS automounts of various types.

This is now required as commit:

	commit c02d7adf8c5429727a98bad1d039bccad4c61c50
	Author: Trond Myklebust <Trond.Myklebust@netapp.com>
	Date:   Mon Jun 22 15:09:14 2009 -0400

	NFSv4: Replace nfs4_path_walk() with VFS path lookup in a private namespace

uses VFS-driven automounting to reach all submounts barring the root, thus
preventing fscaching from being enabled on any submount other than the root.

This patch gets around that by propagating the NFS_OPTION_FSCACHE flag across
automounts.  If a uniquifier is supplied to a mount then this is propagated to
all automounts of that mount too.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/nfs/client.c  |    1 +
 fs/nfs/fscache.c |   25 +++++++++++++++++++++----
 fs/nfs/fscache.h |    3 ++-
 fs/nfs/super.c   |    9 +++++++--
 4 files changed, 31 insertions(+), 7 deletions(-)


diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index e350bd6..9229731 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -968,6 +968,7 @@ static void nfs_server_copy_userdata(struct nfs_server *target, struct nfs_serve
 	target->acdirmin = source->acdirmin;
 	target->acdirmax = source->acdirmax;
 	target->caps = source->caps;
+	target->options = source->options;
 }
 
 /*
diff --git a/fs/nfs/fscache.c b/fs/nfs/fscache.c
index 379be67..70fad69 100644
--- a/fs/nfs/fscache.c
+++ b/fs/nfs/fscache.c
@@ -58,17 +58,34 @@ void nfs_fscache_release_client_cookie(struct nfs_client *clp)
 /*
  * Get the cache cookie for an NFS superblock.  We have to handle
  * uniquification here because the cache doesn't do it for us.
+ *
+ * The default uniquifier is just an empty string, but it may be overridden
+ * either by the 'fsc=xxx' option to mount, or by inheriting it from the parent
+ * superblock across an automount point of some nature.
  */
-void nfs_fscache_get_super_cookie(struct super_block *sb,
-				  struct nfs_parsed_mount_data *data)
+void nfs_fscache_get_super_cookie(struct super_block *sb, const char *uniq,
+				  struct nfs_clone_mount *mntdata)
 {
 	struct nfs_fscache_key *key, *xkey;
 	struct nfs_server *nfss = NFS_SB(sb);
 	struct rb_node **p, *parent;
-	const char *uniq = data->fscache_uniq ?: "";
 	int diff, ulen;
 
-	ulen = strlen(uniq);
+	if (uniq) {
+		ulen = strlen(uniq);
+	} else if (mntdata) {
+		struct nfs_server *mnt_s = NFS_SB(mntdata->sb);
+		if (mnt_s->fscache_key) {
+			uniq = mnt_s->fscache_key->key.uniquifier;
+			ulen = mnt_s->fscache_key->key.uniq_len;
+		}
+	}
+
+	if (!uniq) {
+		uniq = "";
+		ulen = 1;
+	}
+
 	key = kzalloc(sizeof(*key) + ulen, GFP_KERNEL);
 	if (!key)
 		return;
diff --git a/fs/nfs/fscache.h b/fs/nfs/fscache.h
index 6e809bb..d7ffc4a 100644
--- a/fs/nfs/fscache.h
+++ b/fs/nfs/fscache.h
@@ -74,7 +74,8 @@ extern void nfs_fscache_get_client_cookie(struct nfs_client *);
 extern void nfs_fscache_release_client_cookie(struct nfs_client *);
 
 extern void nfs_fscache_get_super_cookie(struct super_block *,
-					 struct nfs_parsed_mount_data *);
+					 const char *,
+					 struct nfs_clone_mount *);
 extern void nfs_fscache_release_super_cookie(struct super_block *);
 
 extern void nfs_fscache_init_inode_cookie(struct inode *);
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 867f705..6f4b14f 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2142,7 +2142,8 @@ static int nfs_get_sb(struct file_system_type *fs_type,
 	if (!s->s_root) {
 		/* initial superblock/root creation */
 		nfs_fill_super(s, data);
-		nfs_fscache_get_super_cookie(s, data);
+		nfs_fscache_get_super_cookie(
+			s, data ? data->fscache_uniq : NULL, NULL);
 	}
 
 	mntroot = nfs_get_root(s, mntfh);
@@ -2243,6 +2244,7 @@ static int nfs_xdev_get_sb(struct file_system_type *fs_type, int flags,
 	if (!s->s_root) {
 		/* initial superblock/root creation */
 		nfs_clone_super(s, data->sb);
+		nfs_fscache_get_super_cookie(s, NULL, data);
 	}
 
 	mntroot = nfs_get_root(s, data->fh);
@@ -2506,7 +2508,8 @@ static int nfs4_remote_get_sb(struct file_system_type *fs_type,
 	if (!s->s_root) {
 		/* initial superblock/root creation */
 		nfs4_fill_super(s);
-		nfs_fscache_get_super_cookie(s, data);
+		nfs_fscache_get_super_cookie(
+			s, data ? data->fscache_uniq : NULL, NULL);
 	}
 
 	mntroot = nfs4_get_root(s, mntfh);
@@ -2739,6 +2742,7 @@ static int nfs4_xdev_get_sb(struct file_system_type *fs_type, int flags,
 	if (!s->s_root) {
 		/* initial superblock/root creation */
 		nfs4_clone_super(s, data->sb);
+		nfs_fscache_get_super_cookie(s, NULL, data);
 	}
 
 	mntroot = nfs4_get_root(s, data->fh);
@@ -2820,6 +2824,7 @@ static int nfs4_remote_referral_get_sb(struct file_system_type *fs_type,
 	if (!s->s_root) {
 		/* initial superblock/root creation */
 		nfs4_fill_super(s);
+		nfs_fscache_get_super_cookie(s, NULL, data);
 	}
 
 	mntroot = nfs4_get_root(s, &mntfh);

