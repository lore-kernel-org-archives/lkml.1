Return-Path: <linux-kernel-owner+w=401wt.eu-S1759828AbYAOX5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759828AbYAOX5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 18:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757451AbYAOXtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 18:49:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757596AbYAOXtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 18:49:07 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 24/26] NFS: Configuration and mount option changes to enable
	local caching on NFS
To: sds@tycho.nsa.gov, casey@schaufler-ca.com, Trond.Myklebust@netapp.com,
       npiggin@suse.de
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Tue, 15 Jan 2008 23:49:00 +0000
Message-ID: <20080115234900.22183.73606.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080115234652.22183.24850.stgit@warthog.procyon.org.uk>
References: <20080115234652.22183.24850.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes to the kernel configuration defintions and to the NFS mount options to
allow the local caching support added by the previous patch to be enabled.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/Kconfig        |    8 ++++++++
 fs/nfs/client.c   |    2 ++
 fs/nfs/internal.h |    1 +
 fs/nfs/super.c    |   14 ++++++++++++++
 4 files changed, 25 insertions(+), 0 deletions(-)


diff --git a/fs/Kconfig b/fs/Kconfig
index e0eedf9..8352dc7 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1650,6 +1650,14 @@ config NFS_V4
 
 	  If unsure, say N.
 
+config NFS_FSCACHE
+	bool "Provide NFS client caching support (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	depends on NFS_FS=m && FSCACHE || NFS_FS=y && FSCACHE=y
+	help
+	  Say Y here if you want NFS data to be cached locally on disc through
+	  the general filesystem cache manager
+
 config NFS_DIRECTIO
 	bool "Allow direct I/O on NFS files"
 	depends on NFS_FS
diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index bcdc5d0..92f9b84 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -572,6 +572,7 @@ static int nfs_init_server(struct nfs_server *server,
 
 	/* Initialise the client representation from the mount data */
 	server->flags = data->flags & NFS_MOUNT_FLAGMASK;
+	server->options = data->options;
 
 	if (data->rsize)
 		server->rsize = nfs_block_size(data->rsize, NULL);
@@ -931,6 +932,7 @@ static int nfs4_init_server(struct nfs_server *server,
 	/* Initialise the client representation from the mount data */
 	server->flags = data->flags & NFS_MOUNT_FLAGMASK;
 	server->caps |= NFS_CAP_ATOMIC_OPEN;
+	server->options = data->options;
 
 	if (data->rsize)
 		server->rsize = nfs_block_size(data->rsize, NULL);
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index f3acf48..ef09e00 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -35,6 +35,7 @@ struct nfs_parsed_mount_data {
 	int			acregmin, acregmax,
 				acdirmin, acdirmax;
 	int			namlen;
+	unsigned int		options;
 	unsigned int		bsize;
 	unsigned int		auth_flavor_len;
 	rpc_authflavor_t	auth_flavors[1];
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 6dd628f..0542550 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -74,6 +74,7 @@ enum {
 	Opt_acl, Opt_noacl,
 	Opt_rdirplus, Opt_nordirplus,
 	Opt_sharecache, Opt_nosharecache,
+	Opt_fscache, Opt_nofscache,
 
 	/* Mount options that take integer arguments */
 	Opt_port,
@@ -123,6 +124,8 @@ static match_table_t nfs_mount_option_tokens = {
 	{ Opt_nordirplus, "nordirplus" },
 	{ Opt_sharecache, "sharecache" },
 	{ Opt_nosharecache, "nosharecache" },
+	{ Opt_fscache, "fsc" },
+	{ Opt_nofscache, "nofsc" },
 
 	{ Opt_port, "port=%u" },
 	{ Opt_rsize, "rsize=%u" },
@@ -459,6 +462,8 @@ static void nfs_show_mount_options(struct seq_file *m, struct nfs_server *nfss,
 	seq_printf(m, ",timeo=%lu", 10U * clp->retrans_timeo / HZ);
 	seq_printf(m, ",retrans=%u", clp->retrans_count);
 	seq_printf(m, ",sec=%s", nfs_pseudoflavour_to_name(nfss->client->cl_auth->au_flavor));
+	if (nfss->options & NFS_OPTION_FSCACHE)
+		seq_printf(m, ",fsc");
 }
 
 /*
@@ -697,6 +702,15 @@ static int nfs_parse_mount_options(char *raw,
 			break;
 		case Opt_nosharecache:
 			mnt->flags |= NFS_MOUNT_UNSHARED;
+			mnt->options &= ~NFS_OPTION_FSCACHE;
+			break;
+		case Opt_fscache:
+			/* sharing is mandatory with fscache */
+			mnt->options |= NFS_OPTION_FSCACHE;
+			mnt->flags &= ~NFS_MOUNT_UNSHARED;
+			break;
+		case Opt_nofscache:
+			mnt->options &= ~NFS_OPTION_FSCACHE;
 			break;
 
 		case Opt_port:

