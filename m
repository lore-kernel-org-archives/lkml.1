Return-Path: <linux-kernel-owner+w=401wt.eu-S1757688AbYKTPAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688AbYKTPAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:00:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756622AbYKTOpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:45:40 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41223 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814AbYKTOpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:45:36 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 45/45] NFS: Add mount options to enable local caching on NFS
	[ver #41]
To: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Date: Thu, 20 Nov 2008 14:45:31 +0000
Message-ID: <20081120144531.10667.35029.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add NFS mount options to allow the local caching support to be enabled.

The attached patch makes it possible for the NFS filesystem to be told to make
use of the network filesystem local caching service (FS-Cache).

To be able to use this, a recent nfsutils package is required.

There are three variant NFS mount options that can be added to a mount command
to control caching for a mount.  Only the last one specified takes effect:

 (*) Adding "fsc" will request caching.

 (*) Adding "fsc=<string>" will request caching and also specify a uniquifier.

 (*) Adding "nofsc" will disable caching.

For example:

	mount warthog:/ /a -o fsc


The cache of a particular superblock (NFS FSID) will be shared between all
mounts of that volume, provided they have the same connection parameters and
are not marked 'nosharecache'.

Where it is otherwise impossible to distinguish superblocks because all the
parameters are identical, but the 'nosharecache' option is supplied, a
uniquifying string must be supplied, else only the first mount will be
permitted to use the cache.

If there's a key collision, then the second mount will disable caching and give
a warning into the kernel log.


Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/nfs/client.c   |    2 ++
 fs/nfs/internal.h |    1 +
 fs/nfs/super.c    |   25 +++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 0 deletions(-)


diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 33f66e2..97a1d67 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -681,6 +681,7 @@ static int nfs_init_server(struct nfs_server *server,
 
 	/* Initialise the client representation from the mount data */
 	server->flags = data->flags;
+	server->options = data->options;
 
 	if (data->rsize)
 		server->rsize = nfs_block_size(data->rsize, NULL);
@@ -1079,6 +1080,7 @@ static int nfs4_init_server(struct nfs_server *server,
 	/* Initialise the client representation from the mount data */
 	server->flags = data->flags;
 	server->caps |= NFS_CAP_ATOMIC_OPEN;
+	server->options = data->options;
 
 	if (data->rsize)
 		server->rsize = nfs_block_size(data->rsize, NULL);
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index fb6b985..4e69afb 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -39,6 +39,7 @@ struct nfs_parsed_mount_data {
 	int			acregmin, acregmax,
 				acdirmin, acdirmax;
 	int			namlen;
+	unsigned int		options;
 	unsigned int		bsize;
 	unsigned int		auth_flavor_len;
 	rpc_authflavor_t	auth_flavors[1];
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index acf328f..94b6be9 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -76,6 +76,7 @@ enum {
 	Opt_acl, Opt_noacl,
 	Opt_rdirplus, Opt_nordirplus,
 	Opt_sharecache, Opt_nosharecache,
+	Opt_fscache, Opt_nofscache,
 
 	/* Mount options that take integer arguments */
 	Opt_port,
@@ -93,6 +94,7 @@ enum {
 	Opt_sec, Opt_proto, Opt_mountproto, Opt_mounthost,
 	Opt_addr, Opt_mountaddr, Opt_clientaddr,
 	Opt_lookupcache,
+	Opt_fscache_uniq,
 
 	/* Special mount options */
 	Opt_userspace, Opt_deprecated, Opt_sloppy,
@@ -130,6 +132,9 @@ static const match_table_t nfs_mount_option_tokens = {
 	{ Opt_nordirplus, "nordirplus" },
 	{ Opt_sharecache, "sharecache" },
 	{ Opt_nosharecache, "nosharecache" },
+	{ Opt_fscache, "fsc" },
+	{ Opt_fscache_uniq, "fsc=%s" },
+	{ Opt_nofscache, "nofsc" },
 
 	{ Opt_port, "port=%u" },
 	{ Opt_rsize, "rsize=%u" },
@@ -562,6 +567,8 @@ static void nfs_show_mount_options(struct seq_file *m, struct nfs_server *nfss,
 	if (clp->rpc_ops->version == 4)
 		seq_printf(m, ",clientaddr=%s", clp->cl_ipaddr);
 #endif
+	if (nfss->options & NFS_OPTION_FSCACHE)
+		seq_printf(m, ",fsc");
 }
 
 /*
@@ -1047,6 +1054,24 @@ static int nfs_parse_mount_options(char *raw,
 		case Opt_nosharecache:
 			mnt->flags |= NFS_MOUNT_UNSHARED;
 			break;
+		case Opt_fscache:
+			mnt->options |= NFS_OPTION_FSCACHE;
+			kfree(mnt->fscache_uniq);
+			mnt->fscache_uniq = NULL;
+			break;
+		case Opt_nofscache:
+			mnt->options &= ~NFS_OPTION_FSCACHE;
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
+			break;
 
 		/*
 		 * options that take numeric values

