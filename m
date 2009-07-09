Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbZGIR1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbZGIR1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 13:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbZGIR1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 13:27:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33630 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbZGIR1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 13:27:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>, steved@redhat.com
cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
Subject: [PATCH][RFC] NFS: Propagate 'fsc' mount option through automounts
Date: Thu, 09 Jul 2009 18:27:43 +0100
Message-ID: <1552.1247160463@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Propagate the NFS 'fsc' mount option through NFS automounts of various types.

This is now required as commit:

	commit c02d7adf8c5429727a98bad1d039bccad4c61c50
	Author: Trond Myklebust <Trond.Myklebust@netapp.com>
	Date:   Mon Jun 22 15:09:14 2009 -0400

	NFSv4: Replace nfs4_path_walk() with VFS path lookup in a private namespace

now uses VFS-driven automounting to reach all submounts barring the root, thus
preventing fscaching from being enabled on any submount other than the root.

This patch gets around that by propagating the NFS_OPTION_FSCACHE flag across
automounts.

Note, however, that it doesn't propagate the uniquifier in the case of
'fsc=<xxx>' being passed to mount.  This is probably wrong, and needs looking
at.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/nfs/client.c |    1 +
 fs/nfs/super.c  |    6 ++++++
 2 files changed, 7 insertions(+), 0 deletions(-)


diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index c2d0616..0949b46 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -964,6 +964,7 @@ static void nfs_server_copy_userdata(struct nfs_server *target, struct nfs_serve
 	target->acdirmin = source->acdirmin;
 	target->acdirmax = source->acdirmax;
 	target->caps = source->caps;
+	target->options = source->options;
 }
 
 /*
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 0b4cbdc..bfab16f 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2214,6 +2214,7 @@ static int nfs_xdev_get_sb(struct file_system_type *fs_type, int flags,
 	struct nfs_server *server;
 	struct dentry *mntroot;
 	int (*compare_super)(struct super_block *, void *) = nfs_compare_super;
+	struct nfs_parsed_mount_data parsed_data = { .fscache_uniq = NULL, };
 	struct nfs_sb_mountdata sb_mntdata = {
 		.mntflags = flags,
 	};
@@ -2251,6 +2252,7 @@ static int nfs_xdev_get_sb(struct file_system_type *fs_type, int flags,
 	if (!s->s_root) {
 		/* initial superblock/root creation */
 		nfs_clone_super(s, data->sb);
+		nfs_fscache_get_super_cookie(s, &parsed_data);
 	}
 
 	mntroot = nfs_get_root(s, data->fh);
@@ -2687,6 +2689,7 @@ static int nfs4_xdev_get_sb(struct file_system_type *fs_type, int flags,
 	struct nfs_server *server;
 	struct dentry *mntroot;
 	int (*compare_super)(struct super_block *, void *) = nfs_compare_super;
+	struct nfs_parsed_mount_data parsed_data = { .fscache_uniq = NULL, };
 	struct nfs_sb_mountdata sb_mntdata = {
 		.mntflags = flags,
 	};
@@ -2724,6 +2727,7 @@ static int nfs4_xdev_get_sb(struct file_system_type *fs_type, int flags,
 	if (!s->s_root) {
 		/* initial superblock/root creation */
 		nfs4_clone_super(s, data->sb);
+		nfs_fscache_get_super_cookie(s, &parsed_data);
 	}
 
 	mntroot = nfs4_get_root(s, data->fh);
@@ -2768,6 +2772,7 @@ static int nfs4_remote_referral_get_sb(struct file_system_type *fs_type,
 	struct dentry *mntroot;
 	struct nfs_fh mntfh;
 	int (*compare_super)(struct super_block *, void *) = nfs_compare_super;
+	struct nfs_parsed_mount_data parsed_data = { .fscache_uniq = NULL, };
 	struct nfs_sb_mountdata sb_mntdata = {
 		.mntflags = flags,
 	};
@@ -2805,6 +2810,7 @@ static int nfs4_remote_referral_get_sb(struct file_system_type *fs_type,
 	if (!s->s_root) {
 		/* initial superblock/root creation */
 		nfs4_fill_super(s);
+		nfs_fscache_get_super_cookie(s, &parsed_data);
 	}
 
 	mntroot = nfs4_get_root(s, &mntfh);
