Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbXITT6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbXITT6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 15:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbXITTxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:53:25 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:49217 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbXITTxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:53:16 -0400
Subject: [PATCH 18/25] elevate writer count for do_sys_truncate()
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 20 Sep 2007 12:53:12 -0700
References: <20070920195249.852667D5@kernel>
In-Reply-To: <20070920195249.852667D5@kernel>
Message-Id: <20070920195312.5D92D4C4@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/open.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN fs/open.c~elevate-writer-count-for-do-sys-truncate fs/open.c
--- lxc/fs/open.c~elevate-writer-count-for-do-sys-truncate	2007-09-20 12:16:19.000000000 -0700
+++ lxc-dave/fs/open.c	2007-09-20 12:16:19.000000000 -0700
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
