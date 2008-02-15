Return-Path: <linux-kernel-owner+w=401wt.eu-S934265AbYBOWty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934265AbYBOWty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932127AbYBOWiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:38:04 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60677 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762857AbYBOWh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:37:56 -0500
Subject: [PATCH 23/30] r/o bind mounts: write counts for truncate()
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, miklos@szeredi.hu, akpm@osdl.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 15 Feb 2008 14:37:52 -0800
References: <20080215223721.9E0A088A@kernel>
In-Reply-To: <20080215223721.9E0A088A@kernel>
Message-Id: <20080215223752.56645DCB@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 linux-2.6.git-dave/fs/open.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN fs/open.c~r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate fs/open.c
--- linux-2.6.git/fs/open.c~r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate	2008-02-15 13:25:55.000000000 -0800
+++ linux-2.6.git-dave/fs/open.c	2008-02-15 13:25:55.000000000 -0800
@@ -244,21 +244,21 @@ static long do_sys_truncate(const char _
 	if (!S_ISREG(inode->i_mode))
 		goto dput_and_out;
 
-	error = vfs_permission(&nd, MAY_WRITE);
+	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto dput_and_out;
 
-	error = -EROFS;
-	if (IS_RDONLY(inode))
-		goto dput_and_out;
+	error = vfs_permission(&nd, MAY_WRITE);
+	if (error)
+		goto mnt_drop_write_and_out;
 
 	error = -EPERM;
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		goto dput_and_out;
+		goto mnt_drop_write_and_out;
 
 	error = get_write_access(inode);
 	if (error)
-		goto dput_and_out;
+		goto mnt_drop_write_and_out;
 
 	/*
 	 * Make sure that there are no leases.  get_write_access() protects
@@ -276,6 +276,8 @@ static long do_sys_truncate(const char _
 
 put_write_and_out:
 	put_write_access(inode);
+mnt_drop_write_and_out:
+	mnt_drop_write(nd.path.mnt);
 dput_and_out:
 	path_put(&nd.path);
 out:
_
