Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbYH0O2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbYH0O2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbYH0O2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 10:28:24 -0400
Received: from vpnflf.ccur.com ([12.192.68.2]:36256 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753506AbYH0O2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 10:28:23 -0400
Date: Wed, 27 Aug 2008 10:28:20 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] NFSv3: cached permissions subset enhancement
Message-ID: <20080827142820.GA22661@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[NFSv3] cached permissions subset enhancement.

NFSv3 allows file permissions to be cached on the client
side.  The Linux client, when fetching these permissions,
makes the request for all permissions (rwx) in a single
operation.  However, for some NFSv3 server implementations
(the only one currently known is PowerMAX OS), an incoming
request for all rwx permissions in a single request,
when all are not actually set in the file, returns an
NFSERR_ACCES failure code to the client, rather than
the subset of permissions actually available for that file.

This patch modifies the Linux client side code to
individually fetch the r, w, and x permissions (combining
these for storage into the cache), if the original
single-request method fails.

This slower method will not affect performance of those
client/server pairs for which the original single-request
method works.  In particular there is no performance
penalty for linux/linux NFSv3 connections.

Author: Linda Dunaphant <ldunaphant@comcast.net>
Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: 2.6.27-rc4-git4/fs/nfs/dir.c
===================================================================
--- 2.6.27-rc4-git4.orig/fs/nfs/dir.c	2008-08-26 17:44:34.000000000 -0400
+++ 2.6.27-rc4-git4/fs/nfs/dir.c	2008-08-26 18:21:27.000000000 -0400
@@ -1870,6 +1870,8 @@
 {
 	struct nfs_access_entry cache;
 	int status;
+	int i;
+	int cmask = 0;
 
 	status = nfs_access_get_cached(inode, cred, &cache);
 	if (status == 0)
@@ -1880,8 +1882,27 @@
 	cache.cred = cred;
 	cache.jiffies = jiffies;
 	status = NFS_PROTO(inode)->access(inode, &cache);
-	if (status != 0)
+	if (status == -NFSERR_ACCES) {
+		//
+		// Try again - one mode at a time & combine at the end
+		//
+		for (i = 0; i <= MAY_READ; i++) {
+			cache.mask = 1 << i;
+			status = NFS_PROTO(inode)->access(inode, &cache);
+			if (status == 0)
+				cmask |= cache.mask;
+			else if (status != -NFSERR_ACCES) {
+				return status;
+			}
+		}
+
+		if (!cmask)
+			return -NFSERR_ACCES;
+
+		cache.mask = cmask;
+	} else if (status)
 		return status;
+
 	nfs_access_add_cache(inode, &cache);
 out:
 	if ((mask & ~cache.mask & (MAY_READ | MAY_WRITE | MAY_EXEC)) == 0)
