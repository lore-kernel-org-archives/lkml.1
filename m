Return-Path: <linux-kernel-owner+w=401wt.eu-S936505AbZDCQPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936505AbZDCQPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935081AbZDCP6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:58:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56710 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935085AbZDCP6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:58:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 41/41] NFS: Add mount options to enable local caching on NFS
	[ver #48]
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
Date: Fri, 03 Apr 2009 16:58:07 +0100
Message-ID: <20090403155807.28714.63746.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
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
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Daire Byrne <Daire.Byrne@framestore.com>
---

 fs/nfs/client.c   |    2 ++
 fs/nfs/internal.h |    1 +
 fs/nfs/super.c    |   25 +++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 0 deletions(-)


diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 726fe5a..75c9cd2 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -765,6 +765,7 @@ static int nfs_init_server(struct nfs_server *server,
 
 	/* Initialise the client representation from the mount data */
 	server->flags = data->flags;
+	server->options = data->options;
 
 	if (data->rsize)
 		server->rsize = nfs_block_size(data->rsize, NULL);
@@ -1153,6 +1154,7 @@ static int nfs4_init_server(struct nfs_server *server,
 	/* Initialise the client representation from the mount data */
 	server->flags = data->flags;
 	server->caps |= NFS_CAP_ATOMIC_OPEN;
+	server->options = data->options;
 
 	/* Get a client record */
 	error = nfs4_set_client(server,
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 0130700..e4d6a83 100644
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
index b5fea77..82eaadb 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -77,6 +77,7 @@ enum {
 	Opt_rdirplus, Opt_nordirplus,
 	Opt_sharecache, Opt_nosharecache,
 	Opt_resvport, Opt_noresvport,
+	Opt_fscache, Opt_nofscache,
 
 	/* Mount options that take integer arguments */
 	Opt_port,
@@ -94,6 +95,7 @@ enum {
 	Opt_sec, Opt_proto, Opt_mountproto, Opt_mounthost,
 	Opt_addr, Opt_mountaddr, Opt_clientaddr,
 	Opt_lookupcache,
+	Opt_fscache_uniq,
 
 	/* Special mount options */
 	Opt_userspace, Opt_deprecated, Opt_sloppy,
@@ -133,6 +135,9 @@ static const match_table_t nfs_mount_option_tokens = {
 	{ Opt_nosharecache, "nosharecache" },
 	{ Opt_resvport, "resvport" },
 	{ Opt_noresvport, "noresvport" },
+	{ Opt_fscache, "fsc" },
+	{ Opt_fscache_uniq, "fsc=%s" },
+	{ Opt_nofscache, "nofsc" },
 
 	{ Opt_port, "port=%u" },
 	{ Opt_rsize, "rsize=%u" },
@@ -564,6 +569,8 @@ static void nfs_show_mount_options(struct seq_file *m, struct nfs_server *nfss,
 	if (clp->rpc_ops->version == 4)
 		seq_printf(m, ",clientaddr=%s", clp->cl_ipaddr);
 #endif
+	if (nfss->options & NFS_OPTION_FSCACHE)
+		seq_printf(m, ",fsc");
 }
 
 /*
@@ -1056,6 +1063,24 @@ static int nfs_parse_mount_options(char *raw,
 		case Opt_noresvport:
 			mnt->flags |= NFS_MOUNT_NORESVPORT;
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

