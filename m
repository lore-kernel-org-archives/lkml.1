Return-Path: <linux-kernel-owner+w=401wt.eu-S1764629AbYCGTsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764629AbYCGTsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 14:48:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759676AbYCGTsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 14:48:32 -0500
Received: from kai.krose.org ([140.186.190.96]:35614 "EHLO mail.krose.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758690AbYCGTsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 14:48:30 -0500
X-Greylist: delayed 686 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Mar 2008 14:48:30 EST
Message-ID: <47D1995E.6060501@krose.org>
Date: Fri, 07 Mar 2008 14:37:02 -0500
From: Kyle Rose <krose@krose.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071229)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: READDIRPLUS max mount option
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------090305020607070601030605"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090305020607070601030605
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I have a very specific use for an NFS mount over a WAN, and allowing for 
much larger expected READDIRPLUS requests actually improves performance 
by at least a factor of 10 by eliminating the round-trip latency that 
results from the application's single-threaded 
readdir/stat/stat/stat/... behavior.  Rather than maintain a hacked 
kernel on my end, I'd rather the READDIRPLUS limit be a mount option.  
Hence, the following patch.  It defaults to the old behavior 
(8*PAGE_SIZE), but with a properly-prepared mount binary will allow the 
client to specify a limit.

I'm not subscribed to the list, so please CC me in any relevant discussion.

Kyle


--------------090305020607070601030605
Content-Type: text/x-patch;
 name="readdirplusmax.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="readdirplusmax.patch"

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index c5c0175..97cb997 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -675,6 +675,8 @@ static int nfs_init_server(struct nfs_server *server,
 	server->acdirmin = data->acdirmin * HZ;
 	server->acdirmax = data->acdirmax * HZ;
 
+	server->readdirplusmax = data->readdirplusmax;
+
 	/* Start lockd here, before we might error out */
 	error = nfs_start_lockd(server);
 	if (error < 0)
@@ -806,6 +808,7 @@ static void nfs_server_copy_userdata(struct nfs_server *target, struct nfs_serve
 	target->acregmax = source->acregmax;
 	target->acdirmin = source->acdirmin;
 	target->acdirmax = source->acdirmax;
+	target->readdirplusmax = source->readdirplusmax;
 	target->caps = source->caps;
 }
 
@@ -1062,6 +1065,8 @@ static int nfs4_init_server(struct nfs_server *server,
 	server->acdirmin = data->acdirmin * HZ;
 	server->acdirmax = data->acdirmax * HZ;
 
+	server->readdirplusmax = data->readdirplusmax;
+
 	error = nfs_init_server_rpcclient(server, &timeparms, data->auth_flavors[0]);
 
 error:
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 966a885..644239f 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -234,9 +234,6 @@ nfs_init_locked(struct inode *inode, void *opaque)
 	return 0;
 }
 
-/* Don't use READDIRPLUS on directories that we believe are too large */
-#define NFS_LIMIT_READDIRPLUS (8*PAGE_SIZE)
-
 /*
  * This is our front-end to iget that looks up inodes by file handle
  * instead of inode number.
@@ -290,7 +287,7 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr)
 			inode->i_op = NFS_SB(sb)->nfs_client->rpc_ops->dir_inode_ops;
 			inode->i_fop = &nfs_dir_operations;
 			if (nfs_server_capable(inode, NFS_CAP_READDIRPLUS)
-			    && fattr->size <= NFS_LIMIT_READDIRPLUS)
+			    && (NFS_READDIRPLUS_MAX(inode) == 0 || fattr->size <= NFS_READDIRPLUS_MAX(inode)))
 				set_bit(NFS_INO_ADVISE_RDPLUS, &NFS_I(inode)->flags);
 			/* Deal with crossing mountpoints */
 			if (!nfs_fsid_equal(&NFS_SB(sb)->fsid, &fattr->fsid)) {
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 9319927..91426a0 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -36,6 +36,7 @@ struct nfs_parsed_mount_data {
 	int			timeo, retrans;
 	int			acregmin, acregmax,
 				acdirmin, acdirmax;
+	int			readdirplusmax;
 	int			namlen;
 	unsigned int		bsize;
 	unsigned int		auth_flavor_len;
diff --git a/fs/nfs/nfsroot.c b/fs/nfs/nfsroot.c
index 531379d..c5a9eb5 100644
--- a/fs/nfs/nfsroot.c
+++ b/fs/nfs/nfsroot.c
@@ -119,7 +119,7 @@ static int mount_port __initdata = 0;		/* Mount daemon port number */
 enum {
 	/* Options that take integer arguments */
 	Opt_port, Opt_rsize, Opt_wsize, Opt_timeo, Opt_retrans, Opt_acregmin,
-	Opt_acregmax, Opt_acdirmin, Opt_acdirmax,
+	Opt_acregmax, Opt_acdirmin, Opt_acdirmax, Opt_readdirplusmax,
 	/* Options that take no arguments */
 	Opt_soft, Opt_hard, Opt_intr,
 	Opt_nointr, Opt_posix, Opt_noposix, Opt_cto, Opt_nocto, Opt_ac, 
@@ -139,6 +139,7 @@ static match_table_t __initdata tokens = {
 	{Opt_acregmax, "acregmax=%u"},
 	{Opt_acdirmin, "acdirmin=%u"},
 	{Opt_acdirmax, "acdirmax=%u"},
+	{Opt_readdirplusmax, "readdirplusmax=%u"},
 	{Opt_soft, "soft"},
 	{Opt_hard, "hard"},
 	{Opt_intr, "intr"},
@@ -221,6 +222,9 @@ static int __init root_nfs_parse(char *name, char *buf)
 			case Opt_acdirmax:
 				nfs_data.acdirmax = option;
 				break;
+			case Opt_readdirplusmax:
+				nfs_data.readdirplusmax = option;
+				break;
 			case Opt_soft:
 				nfs_data.flags |= NFS_MOUNT_SOFT;
 				break;
@@ -292,15 +296,17 @@ static int __init root_nfs_name(char *name)
 
 	/* Set some default values */
 	memset(&nfs_data, 0, sizeof(nfs_data));
-	nfs_port          = -1;
-	nfs_data.version  = NFS_MOUNT_VERSION;
-	nfs_data.flags    = NFS_MOUNT_NONLM;	/* No lockd in nfs root yet */
-	nfs_data.rsize    = NFS_DEF_FILE_IO_SIZE;
-	nfs_data.wsize    = NFS_DEF_FILE_IO_SIZE;
-	nfs_data.acregmin = 3;
-	nfs_data.acregmax = 60;
-	nfs_data.acdirmin = 30;
-	nfs_data.acdirmax = 60;
+	nfs_port                = -1;
+	nfs_data.version        = NFS_MOUNT_VERSION;
+	nfs_data.flags          = NFS_MOUNT_NONLM;	/* No lockd in nfs root yet */
+	nfs_data.rsize          = NFS_DEF_FILE_IO_SIZE;
+	nfs_data.wsize          = NFS_DEF_FILE_IO_SIZE;
+	nfs_data.acregmin       = 3;
+	nfs_data.acregmax       = 60;
+	nfs_data.acdirmin       = 30;
+	nfs_data.acdirmax       = 60;
+	nfs_data.readdirplusmax = 8*PAGE_SIZE;
+
 	strcpy(buf, NFS_ROOT);
 
 	/* Process options received from the remote server */
@@ -348,6 +354,8 @@ static void __init root_nfs_print(void)
 	printk(KERN_NOTICE "Root-NFS:     acreg (min,max) = (%d,%d), acdir (min,max) = (%d,%d)\n",
 		nfs_data.acregmin, nfs_data.acregmax,
 		nfs_data.acdirmin, nfs_data.acdirmax);
+	printk(KERN_NOTICE "Root-NFS:     readdirplusmax = %d\n",
+		nfs_data.readdirplusmax);
 	printk(KERN_NOTICE "Root-NFS:     nfsd port = %d, mountd port = %d, flags = %08x\n",
 		nfs_port, mount_port, nfs_data.flags);
 }
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index fcf4b98..87dfdfb 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -83,6 +83,7 @@ enum {
 	Opt_acregmin, Opt_acregmax,
 	Opt_acdirmin, Opt_acdirmax,
 	Opt_actimeo,
+	Opt_readdirplusmax,
 	Opt_namelen,
 	Opt_mountport,
 	Opt_mountvers,
@@ -136,6 +137,7 @@ static match_table_t nfs_mount_option_tokens = {
 	{ Opt_acdirmin, "acdirmin=%u" },
 	{ Opt_acdirmax, "acdirmax=%u" },
 	{ Opt_actimeo, "actimeo=%u" },
+	{ Opt_readdirplusmax, "readdirplusmax=%u" },
 	{ Opt_userspace, "retry=%u" },
 	{ Opt_namelen, "namlen=%u" },
 	{ Opt_mountport, "mountport=%u" },
@@ -474,6 +476,7 @@ static void nfs_show_mount_options(struct seq_file *m, struct nfs_server *nfss,
 		seq_printf(m, ",acdirmin=%d", nfss->acdirmin/HZ);
 	if (nfss->acdirmax != 60*HZ || showdefaults)
 		seq_printf(m, ",acdirmax=%d", nfss->acdirmax/HZ);
+	seq_printf(m, ",readdirplusmax=%d", nfss->readdirplusmax);
 	for (nfs_infop = nfs_info; nfs_infop->flag; nfs_infop++) {
 		if (nfss->flags & nfs_infop->flag)
 			seq_puts(m, nfs_infop->str);
@@ -851,6 +854,10 @@ static int nfs_parse_mount_options(char *raw,
 			mnt->acdirmin =
 			mnt->acdirmax = option;
 			break;
+		case Opt_readdirplusmax:
+			if (match_int(args, &mnt->readdirplusmax))
+				return 0;
+			break;
 		case Opt_namelen:
 			if (match_int(args, &mnt->namlen))
 				return 0;
@@ -1190,6 +1197,8 @@ static int nfs_validate_mount_data(void *options,
 	case 5:
 		memset(data->context, 0, sizeof(data->context));
 	case 6:
+		data->readdirplusmax = 8*PAGE_SIZE;
+	case 7:
 		if (data->flags & NFS_MOUNT_VER3)
 			mntfh->size = data->root.size;
 		else
@@ -1217,6 +1226,7 @@ static int nfs_validate_mount_data(void *options,
 		args->acregmax		= data->acregmax;
 		args->acdirmin		= data->acdirmin;
 		args->acdirmax		= data->acdirmax;
+		args->readdirplusmax	= data->readdirplusmax;
 
 		memcpy(&args->nfs_server.address, &data->addr,
 		       sizeof(data->addr));
@@ -1428,6 +1438,8 @@ static int nfs_compare_mount_options(const struct super_block *s, const struct n
 		goto Ebusy;
 	if (a->acdirmax != b->acdirmax)
 		goto Ebusy;
+	if (a->readdirplusmax != b->readdirplusmax)
+		goto Ebusy;
 	if (clnt_a->cl_auth->au_flavor != clnt_b->cl_auth->au_flavor)
 		goto Ebusy;
 	return 1;
@@ -1757,6 +1769,8 @@ static int nfs4_validate_mount_data(void *options,
 
 	switch (data->version) {
 	case 1:
+		data->readdirplusmax = 8*PAGE_SIZE;
+	case 2:
 		ap = (struct sockaddr_in *)&args->nfs_server.address;
 		if (data->host_addrlen > sizeof(args->nfs_server.address))
 			goto out_no_address;
@@ -1816,6 +1830,7 @@ static int nfs4_validate_mount_data(void *options,
 		args->acregmax	= data->acregmax;
 		args->acdirmin	= data->acdirmin;
 		args->acdirmax	= data->acdirmax;
+		args->readdirplusmax = data->readdirplusmax;
 		args->nfs_server.protocol = data->proto;
 
 		break;
diff --git a/include/linux/nfs4_mount.h b/include/linux/nfs4_mount.h
index a0dcf66..ee9c21d 100644
--- a/include/linux/nfs4_mount.h
+++ b/include/linux/nfs4_mount.h
@@ -16,7 +16,7 @@
  * mount-to-kernel version compatibility.  Some of these aren't used yet
  * but here they are anyway.
  */
-#define NFS4_MOUNT_VERSION	1
+#define NFS4_MOUNT_VERSION	2
 
 struct nfs_string {
 	unsigned int len;
@@ -53,6 +53,8 @@ struct nfs4_mount_data {
 	/* Pseudo-flavours to use for authentication. See RFC2623 */
 	int auth_flavourlen;			/* 1 */
 	int __user *auth_flavours;		/* 1 */
+
+	int readdirplusmax;			/* 2 */
 };
 
 /* bits in the flags field */
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index a69ba80..d7401b4 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -274,6 +274,11 @@ static inline int nfs_server_capable(struct inode *inode, int cap)
 	return NFS_SERVER(inode)->caps & cap;
 }
 
+static inline unsigned int NFS_READDIRPLUS_MAX(struct inode *inode)
+{
+	return NFS_SERVER(inode)->readdirplusmax;
+}
+
 static inline int NFS_USE_READDIRPLUS(struct inode *inode)
 {
 	return test_bit(NFS_INO_ADVISE_RDPLUS, &NFS_I(inode)->flags);
diff --git a/include/linux/nfs_fs_sb.h b/include/linux/nfs_fs_sb.h
index 3423c67..d596065 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -99,6 +99,8 @@ struct nfs_server {
 	unsigned int		acdirmin;
 	unsigned int		acdirmax;
 	unsigned int		namelen;
+	unsigned int		readdirplusmax;	/* max believed dir size for
+						   READDIRPLUS */
 
 	struct nfs_fsid		fsid;
 	__u64			maxfilesize;	/* maximum file size */
diff --git a/include/linux/nfs_mount.h b/include/linux/nfs_mount.h
index df7c6b7..686d185 100644
--- a/include/linux/nfs_mount.h
+++ b/include/linux/nfs_mount.h
@@ -20,7 +20,7 @@
  * mount-to-kernel version compatibility.  Some of these aren't used yet
  * but here they are anyway.
  */
-#define NFS_MOUNT_VERSION	6
+#define NFS_MOUNT_VERSION	7
 #define NFS_MAX_CONTEXT_LEN	256
 
 struct nfs_mount_data {
@@ -43,6 +43,7 @@ struct nfs_mount_data {
 	struct nfs3_fh	root;			/* 4 */
 	int		pseudoflavor;		/* 5 */
 	char		context[NFS_MAX_CONTEXT_LEN + 1];	/* 6 */
+	int		readdirplusmax;		/* 7 */
 };
 
 /* bits in the flags field */

--------------090305020607070601030605--
