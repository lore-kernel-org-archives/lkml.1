Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbYAXTk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbYAXTk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756297AbYAXTfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:35:25 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46579 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457AbYAXTex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:34:53 -0500
Message-Id: <20080124193449.550058933@szeredi.hu>
References: <20080124193341.166753833@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Jan 2008 20:34:02 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 21/26] mount options: partially fix nfs
Content-Disposition: inline; filename=nfs_opts.patch
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add posix, bsize=, namelen= options to /proc/mounts for nfs
filesystems.

Document several other options that are still missing.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/nfs/super.c
===================================================================
--- linux.orig/fs/nfs/super.c	2008-01-19 11:56:34.000000000 +0100
+++ linux/fs/nfs/super.c	2008-01-21 20:41:30.000000000 +0100
@@ -449,6 +449,7 @@ static void nfs_show_mount_options(struc
 	} nfs_info[] = {
 		{ NFS_MOUNT_SOFT, ",soft", ",hard" },
 		{ NFS_MOUNT_INTR, ",intr", ",nointr" },
+		{ NFS_MOUNT_POSIX, ",posix", "" },
 		{ NFS_MOUNT_NOCTO, ",nocto", "" },
 		{ NFS_MOUNT_NOAC, ",noac", "" },
 		{ NFS_MOUNT_NONLM, ",nolock", "" },
@@ -459,10 +460,17 @@ static void nfs_show_mount_options(struc
 	};
 	const struct proc_nfs_info *nfs_infop;
 	struct nfs_client *clp = nfss->nfs_client;
+	unsigned int default_namelen =
+		clp->rpc_ops->version == 4 ? NFS4_MAXNAMLEN :
+		clp->rpc_ops->version == 3 ? NFS3_MAXNAMLEN : NFS2_MAXNAMLEN;
 
 	seq_printf(m, ",vers=%d", clp->rpc_ops->version);
 	seq_printf(m, ",rsize=%d", nfss->rsize);
 	seq_printf(m, ",wsize=%d", nfss->wsize);
+	if (nfss->bsize != 0)
+		seq_printf(m, ",bsize=%d", nfss->bsize);
+	if (nfss->namelen != default_namelen)
+		seq_printf(m, ",namelen=%d", nfss->namelen);
 	if (nfss->acregmin != 3*HZ || showdefaults)
 		seq_printf(m, ",acregmin=%d", nfss->acregmin/HZ);
 	if (nfss->acregmax != 60*HZ || showdefaults)
@@ -482,6 +490,18 @@ static void nfs_show_mount_options(struc
 	seq_printf(m, ",timeo=%lu", 10U * nfss->client->cl_timeout->to_initval / HZ);
 	seq_printf(m, ",retrans=%u", nfss->client->cl_timeout->to_retries);
 	seq_printf(m, ",sec=%s", nfs_pseudoflavour_to_name(nfss->client->cl_auth->au_flavor));
+
+	/*
+	 * Missing options:
+	 * port=
+	 * mountport=
+	 * mountvers=
+	 * mountproto=
+	 * addr=
+	 * clientaddr=
+	 * mounthost=
+	 * mountaddr=
+	 */
 }
 
 /*

--
