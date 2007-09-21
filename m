Return-Path: <linux-kernel-owner+w=401wt.eu-S1760871AbXIUOut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871AbXIUOut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759399AbXIUOtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:49:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758877AbXIUOtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:49:18 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 15/22] NFS: Configuration and mount option changes to enable
	local caching on NFS
To: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Fri, 21 Sep 2007 15:48:20 +0100
Message-ID: <20070921144820.8323.1400.stgit@warthog.procyon.org.uk>
In-Reply-To: <20070921144703.8323.50492.stgit@warthog.procyon.org.uk>
References: <20070921144703.8323.50492.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changes to the kernel configuration defintions and to the NFS mount options to
allow the local caching support added by the previous patch to be enabled.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/Kconfig        |    8 ++++++++
 fs/nfs/client.c   |   14 ++++++++++----
 fs/nfs/internal.h |    2 ++
 fs/nfs/super.c    |   40 ++++++++++++++++++++++++++++++++++------
 4 files changed, 54 insertions(+), 10 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 8ae7eda..ebc7341 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1597,6 +1597,14 @@ config NFS_V4
 
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
index f1783b2..0de4db4 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -543,7 +543,8 @@ error:
 /*
  * Create a version 2 or 3 client
  */
-static int nfs_init_server(struct nfs_server *server, const struct nfs_mount_data *data)
+static int nfs_init_server(struct nfs_server *server, const struct nfs_mount_data *data,
+			   unsigned int extra_options)
 {
 	struct nfs_client *clp;
 	int error, nfsvers = 2;
@@ -580,6 +581,7 @@ static int nfs_init_server(struct nfs_server *server, const struct nfs_mount_dat
 	server->acregmax = data->acregmax * HZ;
 	server->acdirmin = data->acdirmin * HZ;
 	server->acdirmax = data->acdirmax * HZ;
+	server->options = extra_options;
 
 	/* Start lockd here, before we might error out */
 	error = nfs_start_lockd(server);
@@ -776,6 +778,7 @@ void nfs_free_server(struct nfs_server *server)
  * - keyed on server and FSID
  */
 struct nfs_server *nfs_create_server(const struct nfs_mount_data *data,
+				     unsigned extra_options,
 				     struct nfs_fh *mntfh)
 {
 	struct nfs_server *server;
@@ -787,7 +790,7 @@ struct nfs_server *nfs_create_server(const struct nfs_mount_data *data,
 		return ERR_PTR(-ENOMEM);
 
 	/* Get a client representation */
-	error = nfs_init_server(server, data);
+	error = nfs_init_server(server, data, extra_options);
 	if (error < 0)
 		goto error;
 
@@ -911,7 +914,8 @@ error:
  * Create a version 4 volume record
  */
 static int nfs4_init_server(struct nfs_server *server,
-		const struct nfs4_mount_data *data, rpc_authflavor_t authflavour)
+		const struct nfs4_mount_data *data, rpc_authflavor_t authflavour,
+		unsigned int extra_options)
 {
 	int error;
 
@@ -930,6 +934,7 @@ static int nfs4_init_server(struct nfs_server *server,
 	server->acregmax = data->acregmax * HZ;
 	server->acdirmin = data->acdirmin * HZ;
 	server->acdirmax = data->acdirmax * HZ;
+	server->options = extra_options;
 
 	error = nfs_init_server_rpcclient(server, authflavour);
 
@@ -948,6 +953,7 @@ struct nfs_server *nfs4_create_server(const struct nfs4_mount_data *data,
 				      const char *mntpath,
 				      const char *ip_addr,
 				      rpc_authflavor_t authflavour,
+				      unsigned int extra_options,
 				      struct nfs_fh *mntfh)
 {
 	struct nfs_fattr fattr;
@@ -967,7 +973,7 @@ struct nfs_server *nfs4_create_server(const struct nfs4_mount_data *data,
 		goto error;
 
 	/* set up the general RPC client */
-	error = nfs4_init_server(server, data, authflavour);
+	error = nfs4_init_server(server, data, authflavour, extra_options);
 	if (error < 0)
 		goto error;
 
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 76cf55d..34ef000 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -33,6 +33,7 @@ extern struct rpc_program nfs_program;
 extern void nfs_put_client(struct nfs_client *);
 extern struct nfs_client *nfs_find_client(const struct sockaddr_in *, int);
 extern struct nfs_server *nfs_create_server(const struct nfs_mount_data *,
+					    unsigned int,
 					    struct nfs_fh *);
 extern struct nfs_server *nfs4_create_server(const struct nfs4_mount_data *,
 					     const char *,
@@ -40,6 +41,7 @@ extern struct nfs_server *nfs4_create_server(const struct nfs4_mount_data *,
 					     const char *,
 					     const char *,
 					     rpc_authflavor_t,
+					     unsigned int,
 					     struct nfs_fh *);
 extern struct nfs_server *nfs4_create_referral_server(struct nfs_clone_mount *,
 						      struct nfs_fh *);
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index b878528..7753e9e 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -67,6 +67,7 @@ struct nfs_parsed_mount_data {
 				acdirmin, acdirmax;
 	int			namlen;
 	unsigned int		bsize;
+	unsigned int		options;
 	unsigned int		auth_flavor_len;
 	rpc_authflavor_t	auth_flavors[1];
 	char			*client_address;
@@ -101,6 +102,7 @@ enum {
 	Opt_acl, Opt_noacl,
 	Opt_rdirplus, Opt_nordirplus,
 	Opt_sharecache, Opt_nosharecache,
+	Opt_fscache, Opt_nofscache,
 
 	/* Mount options that take integer arguments */
 	Opt_port,
@@ -149,6 +151,8 @@ static match_table_t nfs_mount_option_tokens = {
 	{ Opt_nordirplus, "nordirplus" },
 	{ Opt_sharecache, "sharecache" },
 	{ Opt_nosharecache, "nosharecache" },
+	{ Opt_fscache, "fsc" },
+	{ Opt_nofscache, "nofsc" },
 
 	{ Opt_port, "port=%u" },
 	{ Opt_rsize, "rsize=%u" },
@@ -495,6 +499,8 @@ static void nfs_show_mount_options(struct seq_file *m, struct nfs_server *nfss,
 	seq_printf(m, ",timeo=%lu", 10U * clp->retrans_timeo / HZ);
 	seq_printf(m, ",retrans=%u", clp->retrans_count);
 	seq_printf(m, ",sec=%s", nfs_pseudoflavour_to_name(nfss->client->cl_auth->au_flavor));
+	if (nfss->options & NFS_OPTION_FSCACHE)
+		seq_printf(m, ",fsc");
 }
 
 /*
@@ -725,6 +731,15 @@ static int nfs_parse_mount_options(char *raw,
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
@@ -1081,10 +1096,13 @@ out_err:
  */
 static int nfs_validate_mount_data(struct nfs_mount_data **options,
 				   struct nfs_fh *mntfh,
-				   const char *dev_name)
+				   const char *dev_name,
+				   unsigned int *_extra_options)
 {
 	struct nfs_mount_data *data = *options;
 
+	*_extra_options = 0;
+
 	if (data == NULL)
 		goto out_no_data;
 
@@ -1131,6 +1149,7 @@ static int nfs_validate_mount_data(struct nfs_mount_data **options,
 			.acregmax	= 60,
 			.acdirmin	= 30,
 			.acdirmax	= 60,
+			.options	= 0,
 			.mount_server.protocol = IPPROTO_UDP,
 			.mount_server.program = NFS_MNT_PROGRAM,
 			.nfs_server.protocol = IPPROTO_TCP,
@@ -1139,6 +1158,7 @@ static int nfs_validate_mount_data(struct nfs_mount_data **options,
 
 		if (nfs_parse_mount_options((char *) *options, &args) == 0)
 			return -EINVAL;
+		*_extra_options = args.options;
 
 		data = kzalloc(sizeof(*data), GFP_KERNEL);
 		if (data == NULL)
@@ -1381,6 +1401,7 @@ static int nfs_get_sb(struct file_system_type *fs_type,
 	struct nfs_fh mntfh;
 	struct nfs_mount_data *data = raw_data;
 	struct dentry *mntroot;
+	unsigned int extra_options;
 	int (*compare_super)(struct super_block *, void *) = nfs_compare_super;
 	struct nfs_sb_mountdata sb_mntdata = {
 		.mntflags = flags,
@@ -1388,12 +1409,12 @@ static int nfs_get_sb(struct file_system_type *fs_type,
 	int error;
 
 	/* Validate the mount data */
-	error = nfs_validate_mount_data(&data, &mntfh, dev_name);
+	error = nfs_validate_mount_data(&data, &mntfh, dev_name, &extra_options);
 	if (error < 0)
 		goto out;
 
 	/* Get a volume representation */
-	server = nfs_create_server(data, &mntfh);
+	server = nfs_create_server(data, extra_options, &mntfh);
 	if (IS_ERR(server)) {
 		error = PTR_ERR(server);
 		goto out;
@@ -1565,11 +1586,14 @@ static int nfs4_validate_mount_data(struct nfs4_mount_data **options,
 				    rpc_authflavor_t *authflavour,
 				    char **hostname,
 				    char **mntpath,
-				    char **ip_addr)
+				    char **ip_addr,
+				    unsigned int *_extra_options)
 {
 	struct nfs4_mount_data *data = *options;
 	char *c;
 
+	*_extra_options = 0;
+
 	if (data == NULL)
 		goto out_no_data;
 
@@ -1625,11 +1649,13 @@ static int nfs4_validate_mount_data(struct nfs4_mount_data **options,
 			.acregmax	= 60,
 			.acdirmin	= 30,
 			.acdirmax	= 60,
+			.options	= 0,
 			.nfs_server.protocol = IPPROTO_TCP,
 		};
 
 		if (nfs_parse_mount_options((char *) *options, &args) == 0)
 			return -EINVAL;
+		*_extra_options = args.options;
 
 		if (!nfs_verify_server_address((struct sockaddr *)
 						&args.nfs_server.address))
@@ -1736,6 +1762,7 @@ static int nfs4_get_sb(struct file_system_type *fs_type,
 	rpc_authflavor_t authflavour;
 	struct nfs_fh mntfh;
 	struct dentry *mntroot;
+	unsigned extra_options;
 	char *mntpath = NULL, *hostname = NULL, *ip_addr = NULL;
 	int (*compare_super)(struct super_block *, void *) = nfs_compare_super;
 	struct nfs_sb_mountdata sb_mntdata = {
@@ -1745,13 +1772,14 @@ static int nfs4_get_sb(struct file_system_type *fs_type,
 
 	/* Validate the mount data */
 	error = nfs4_validate_mount_data(&data, dev_name, &addr, &authflavour,
-					 &hostname, &mntpath, &ip_addr);
+					 &hostname, &mntpath, &ip_addr,
+					 &extra_options);
 	if (error < 0)
 		goto out;
 
 	/* Get a volume representation */
 	server = nfs4_create_server(data, hostname, &addr, mntpath, ip_addr,
-				    authflavour, &mntfh);
+				    authflavour, extra_options, &mntfh);
 	if (IS_ERR(server)) {
 		error = PTR_ERR(server);
 		goto out;

