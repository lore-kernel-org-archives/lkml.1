Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbYH1S3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbYH1S3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbYH1S2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:28:52 -0400
Received: from vpnflf.ccur.com ([12.192.68.2]:41438 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752050AbYH1S2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:28:51 -0400
Date: Thu, 28 Aug 2008 14:28:48 -0400
From: Joe Korty <joe.korty@ccur.com>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] NFSv3: cached permissions subset enhancement, v2
Message-ID: <20080828182848.GA19286@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20080827142820.GA22661@tsunami.ccur.com> <2BBFD074-16C3-4640-8F3D-DF604F4146A7@netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2BBFD074-16C3-4640-8F3D-DF604F4146A7@netapp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 12:03:47PM -0400, Myklebust, Trond wrote:

> This isn't a good solution. The correct thing to do here is to resend
> the request for just those permissions that the VFS requested.

Is there any chance that the cached permissions are shared amoung
multiple open(2)'s of the same file?  If sharing happens then we
really need to cache all of MAY_EXEC | MAY_WRITE | MAY_READ, rather
than just that subset asked for by the open(2) that happens to
be the one filling in the cache.

In any case, I've rewritten the patch per the above suggestion, and
in doing so noted an embarrasing bug in the original posting, one that
happened to touch all the values that it needed to, by accident:

-        for (i = 0; i <= MAY_READ; i++) {
-            cache.mask = 1 << i;
+	 for (i = 1; i <= MAY_READ; i *= 2) {
+            cache.mask = i;

     ---------- cut here ---------

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
Reworked-by: Joe Korty <joe.korty@ccur.com>
Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: a/fs/nfs/dir.c
===================================================================
--- a.orig/fs/nfs/dir.c	2008-08-27 11:31:43.000000000 -0400
+++ a/fs/nfs/dir.c	2008-08-28 14:12:52.000000000 -0400
@@ -1902,8 +1902,34 @@
 	cache.cred = cred;
 	cache.jiffies = jiffies;
 	status = NFS_PROTO(inode)->access(inode, &cache);
-	if (status != 0)
+	if (status == -NFSERR_ACCES) {
+		/*
+		 * Try again - one mode at a time & combine at the end
+		 */
+		int cmask = 0;
+
+		if (mask & MAY_EXEC) {
+			cache.mask = MAY_EXEC;
+			if (!NFS_PROTO(inode)->access(inode, &cache))
+				cmask |= cache.mask;
+		}
+		if (mask & MAY_WRITE) {
+			cache.mask = MAY_WRITE;
+			if (!NFS_PROTO(inode)->access(inode, &cache))
+				cmask |= cache.mask;
+		}
+		if (mask & MAY_READ) {
+			cache.mask = MAY_READ;
+			if (!NFS_PROTO(inode)->access(inode, &cache))
+				cmask |= cache.mask;
+		}
+		if (!cmask)
+			return -NFSERR_ACCES;
+
+		cache.mask = cmask;
+	} else if (status)
 		return status;
+
 	nfs_access_add_cache(inode, &cache);
 out:
 	if ((cache.mask & mask) == mask)
