Return-Path: <linux-kernel-owner+w=401wt.eu-S934429AbYDQQnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934429AbYDQQnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 12:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932457AbYDQQmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 12:42:55 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:64328 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765931AbYDQQmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 12:42:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=Mf2atckd4tZz+8Xe324+V1MDszXCEc+kHf9u9N1eAzEpymwbVYZd23ydlxMGM5LSCSh1IKQXZe2IF8Eny/BSUsTxf5aSIqYr3aJBbH5Ost9JYSGmzhNFhjlOvYg1IN6pqa5dXKsDMYlEqABOOWilQ1FHsGW6DwmhITT8h5eBV/A=
Date: Thu, 17 Apr 2008 20:42:09 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] NFS - fix potential NULL pointer dereference v2
Message-ID: <20080417164209.GA7720@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is possible NULL pointer dereference if kstr[n]dup failed.
So fix them for safety.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

---

Trond, please review ;)

Index: linux-2.6.git/fs/nfs/super.c
===================================================================
--- linux-2.6.git.orig/fs/nfs/super.c	2008-04-17 20:19:03.000000000 +0400
+++ linux-2.6.git/fs/nfs/super.c	2008-04-17 20:33:29.000000000 +0400
@@ -1230,6 +1230,8 @@ static int nfs_validate_mount_data(void 
 		args->namlen		= data->namlen;
 		args->bsize		= data->bsize;
 		args->auth_flavors[0]	= data->pseudoflavor;
+		if (!args->nfs_server.hostname)
+			goto out_nomem;
 
 		/*
 		 * The legacy version 6 binary mount data from userspace has a
@@ -1276,6 +1278,8 @@ static int nfs_validate_mount_data(void 
 		len = c - dev_name;
 		/* N.B. caller will free nfs_server.hostname in all cases */
 		args->nfs_server.hostname = kstrndup(dev_name, len, GFP_KERNEL);
+		if (!args->nfs_server.hostname)
+			goto out_nomem;
 
 		c++;
 		if (strlen(c) > NFS_MAXPATHLEN)
@@ -1319,6 +1323,10 @@ out_v3_not_compiled:
 	return -EPROTONOSUPPORT;
 #endif /* !CONFIG_NFS_V3 */
 
+out_nomem:
+	dfprintk(MOUNT, "NFS: not enough memory to handle mount options\n");
+	return -ENOMEM;
+
 out_no_address:
 	dfprintk(MOUNT, "NFS: mount program didn't pass remote address\n");
 	return -EINVAL;
@@ -1852,12 +1860,16 @@ static int nfs4_validate_mount_data(void
 			return -ENAMETOOLONG;
 		/* N.B. caller will free nfs_server.hostname in all cases */
 		args->nfs_server.hostname = kstrndup(dev_name, len, GFP_KERNEL);
+		if (!args->nfs_server.hostname)
+			goto out_nomem;
 
 		c++;			/* step over the ':' */
 		len = strlen(c);
 		if (len > NFS4_MAXPATHLEN)
 			return -ENAMETOOLONG;
 		args->nfs_server.export_path = kstrndup(c, len, GFP_KERNEL);
+		if (!args->nfs_server.export_path)
+			goto out_nomem;
 
 		dprintk("NFS: MNTPATH: '%s'\n", args->nfs_server.export_path);
 
@@ -1879,6 +1891,10 @@ out_inval_auth:
 		 data->auth_flavourlen);
 	return -EINVAL;
 
+out_nomem:
+	dfprintk(MOUNT, "NFS4: not enough memory to handle mount options\n");
+	return -ENOMEM;
+
 out_no_address:
 	dfprintk(MOUNT, "NFS4: mount program didn't pass remote address\n");
 	return -EINVAL;
