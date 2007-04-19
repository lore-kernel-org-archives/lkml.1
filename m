Return-Path: <linux-kernel-owner+w=401wt.eu-S1423005AbXDSXzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423005AbXDSXzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 19:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422987AbXDSXy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 19:54:58 -0400
Received: from ns2.suse.de ([195.135.220.15]:36624 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422829AbXDSXyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 19:54:55 -0400
Message-Id: <20070419234704.556814255@schurl.suse.de>
User-Agent: quilt/0.46-1
Date: Fri, 20 Apr 2007 01:23:10 +0200
From: Andreas Gruenbacher <agruen@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Andrew Morton <akpm@linux-foundation.org>
References: <20070412090809.917795000@suse.de> <200704170335.21805.agruen@suse.de> <20070417182126.2327d89d@the-village.bc.nu> <20070419232303.300441585@schurl.suse.de>
In-Reply-To: <20070417182126.2327d89d@the-village.bc.nu>
Subject: [d_path 7/7] Distinguish between connected and disconnected paths in d_path()
Content-Disposition: inline; filename=fix-d_path.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change d_path() so that it will never return a path starting with '/' if
the path doesn't lead up to the chroot directory. Also ensure that the
path returned never is the empty string: this would only occur with a lazily unmounted file system; return "." in that case instead.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

---
 fs/dcache.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1829,8 +1829,11 @@ global_root:
 			buffer++;
 			buflen++;
 		}
-		if (is_slash)
+		if (is_slash) {
+			if (*buffer == '\0')
+				*--buffer = '.';
 			goto out;
+		}
 	}
 	if (buflen < namelen)
 		goto Elong;
@@ -1843,18 +1846,6 @@ Elong:
 	goto out;
 }
 
-static char *__connect_d_path(char *path, char *buffer)
-{
-	if (!IS_ERR(path) && *path != '/') {
-		/* Pretend that disconnected paths are hanging off the root. */
-		if (path == buffer)
-			path = ERR_PTR(-ENAMETOOLONG);
-		else
-			*--path = '/';
-	}
-	return path;
-}
-
 /* write full pathname into buffer and return start of pathname */
 char *d_path(struct dentry *dentry, struct vfsmount *vfsmnt, char *buf,
 	     int buflen)
@@ -1868,7 +1859,6 @@ char *d_path(struct dentry *dentry, stru
 	root = dget(current->fs->root);
 	read_unlock(&current->fs->lock);
 	res = __d_path(dentry, vfsmnt, root, rootmnt, buf, buflen, 0);
-	res = __connect_d_path(res, buf);
 	dput(root);
 	mntput(rootmnt);
 	return res;

-- 
Andreas Gruenbacher <agruen@suse.de>
SUSE Labs, SUSE LINUX Products GmbH
GF: Markus Rex, HRB 16746 (AG Nuernberg)

GPG: AF77 FAD1 1819 D442 400F  4BC8 409A 6903 4FDD EE02

