Return-Path: <linux-kernel-owner+w=401wt.eu-S966015AbXDGPSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966015AbXDGPSy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 11:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966027AbXDGPSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 11:18:54 -0400
Received: from cs1.cs.huji.ac.il ([132.65.16.10]:62369 "EHLO cs1.cs.huji.ac.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966015AbXDGPSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 11:18:54 -0400
X-Greylist: delayed 2648 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Apr 2007 11:18:53 EDT
Date: Sat, 7 Apr 2007 17:34:43 +0300 (IDT)
From: amnonaar@gmail.com
To: linux-kernel@vger.kernel.org
Subject: [patch] nfs statfs error-handling fix
Message-ID: <010704071723070.28698@inferno-01.cs.huji.ac.il>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The nfs statfs function returns a success code on error, and fills the 
output buffer with invalid values. The attached patch makes it return a 
correct error code instead.

Thanks,
Amnon

Signed-off-by: Amnon Aaronsohn <amnonaar@gmail.com>
--

--- linux-source-2.6.20-2.6.20/fs/nfs/super.c.orig	2007-04-07 15:19:14.000000000 +0300
+++ linux-source-2.6.20-2.6.20/fs/nfs/super.c	2007-04-07 15:24:35.000000000 +0300
@@ -203,9 +203,9 @@ static int nfs_statfs(struct dentry *den
  	lock_kernel();

  	error = server->nfs_client->rpc_ops->statfs(server, fh, &res);
-	buf->f_type = NFS_SUPER_MAGIC;
  	if (error < 0)
-		goto out_err;
+		goto out;
+	buf->f_type = NFS_SUPER_MAGIC;

  	/*
  	 * Current versions of glibc do not correctly handle the
@@ -234,13 +234,7 @@ static int nfs_statfs(struct dentry *den
  	buf->f_namelen = server->namelen;
   out:
  	unlock_kernel();
-	return 0;
-
- out_err:
-	dprintk("%s: statfs error = %d\n", __FUNCTION__, -error);
-	buf->f_bsize = buf->f_blocks = buf->f_bfree = buf->f_bavail = -1;
-	goto out;
-
+	return error;
  }

  /*
