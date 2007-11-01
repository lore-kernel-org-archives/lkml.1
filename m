Return-Path: <linux-kernel-owner+w=401wt.eu-S1762191AbXKAXPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762191AbXKAXPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 19:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759557AbXKAXI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 19:08:59 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37910 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759106AbXKAXI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 19:08:56 -0400
Subject: [PATCH 20/27] r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 01 Nov 2007 16:08:53 -0700
References: <20071101230826.9A4F6E00@kernel>
In-Reply-To: <20071101230826.9A4F6E00@kernel>
Message-Id: <20071101230853.1C16EDCD@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 linux-2.6.git-dave/fs/open.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN fs/open.c~r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate fs/open.c
--- linux-2.6.git/fs/open.c~r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate	2007-11-01 14:46:18.000000000 -0700
+++ linux-2.6.git-dave/fs/open.c	2007-11-01 14:46:18.000000000 -0700
@@ -244,21 +244,21 @@ static long do_sys_truncate(const char _
 	if (!S_ISREG(inode->i_mode))
 		goto dput_and_out;
 
-	error = vfs_permission(&nd, MAY_WRITE);
+	error = mnt_want_write(nd.mnt);
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
+	mnt_drop_write(nd.mnt);
 dput_and_out:
 	path_release(&nd);
 out:
_
