Return-Path: <linux-kernel-owner+w=401wt.eu-S1760233AbYA1Lev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760233AbYA1Lev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 06:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbYA1Lej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 06:34:39 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43904 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbYA1Lei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 06:34:38 -0500
To: chuck.lever@oracle.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Trond.Myklebust@netapp.com
In-reply-to: <2D4FA3F4-E481-40B2-A56C-A4D55178DA76@oracle.com> (message from
	Chuck Lever on Fri, 25 Jan 2008 12:19:57 -0500)
Subject: Re: [patch 21/26] mount options: partially fix nfs
References: <20080124193341.166753833@szeredi.hu> <20080124193449.550058933@szeredi.hu> <4798F9BC.4040405@oracle.com> <E1JIL1f-0001N6-Tg@pomaz-ex.szeredi.hu> <2D4FA3F4-E481-40B2-A56C-A4D55178DA76@oracle.com>
Message-Id: <E1JJSFm-00007o-Ca@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 28 Jan 2008 12:34:18 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > All mount options should be shown, which are needed to reconstruct a
> > previous mount.
> 
> Ah, OK.
> 
> I'm happy to implement logic to display the all missing options.  I  
> should have updated nfs_show_mount_options() when I wrote the NFS  
> mount option parser.
> 
> Let me know your preference.

You are more familiar with NFS, so I think it would be better if you
updated nfs_show_mount_options().

Could you also queue my patch (updated) or incorporate it into a
combined fix?

Thanks,
Miklos
----

Subject: mount options: partially fix nfs

From: Miklos Szeredi <mszeredi@suse.cz>

Add posix, bsize=, namelen= options to /proc/mounts for nfs
filesystems.

Document several other options that are still missing.

Changes:

 - display namelen= unconditionally
 - addr= isn't missing after all

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
---

Index: linux/fs/nfs/super.c
===================================================================
--- linux.orig/fs/nfs/super.c	2008-01-25 15:44:56.000000000 +0100
+++ linux/fs/nfs/super.c	2008-01-25 15:57:32.000000000 +0100
@@ -449,6 +449,7 @@ static void nfs_show_mount_options(struc
 	} nfs_info[] = {
 		{ NFS_MOUNT_SOFT, ",soft", ",hard" },
 		{ NFS_MOUNT_INTR, ",intr", ",nointr" },
+		{ NFS_MOUNT_POSIX, ",posix", "" },
 		{ NFS_MOUNT_NOCTO, ",nocto", "" },
 		{ NFS_MOUNT_NOAC, ",noac", "" },
 		{ NFS_MOUNT_NONLM, ",nolock", "" },
@@ -463,6 +464,9 @@ static void nfs_show_mount_options(struc
 	seq_printf(m, ",vers=%d", clp->rpc_ops->version);
 	seq_printf(m, ",rsize=%d", nfss->rsize);
 	seq_printf(m, ",wsize=%d", nfss->wsize);
+	seq_printf(m, ",namelen=%d", nfss->namelen);
+	if (nfss->bsize != 0)
+		seq_printf(m, ",bsize=%d", nfss->bsize);
 	if (nfss->acregmin != 3*HZ || showdefaults)
 		seq_printf(m, ",acregmin=%d", nfss->acregmin/HZ);
 	if (nfss->acregmax != 60*HZ || showdefaults)
@@ -482,6 +486,17 @@ static void nfs_show_mount_options(struc
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
+	 * clientaddr=
+	 * mounthost=
+	 * mountaddr=
+	 */
 }
 
 /*
