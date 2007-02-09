Return-Path: <linux-kernel-owner+w=401wt.eu-S1946160AbXBIWzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946160AbXBIWzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 17:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946449AbXBIWya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 17:54:30 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:33154 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423367AbXBIWxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 17:53:41 -0500
Subject: [PATCH 13/22] elevate writer count for do_sys_truncate()
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, hch@infradead.org, Dave Hansen <hansendc@us.ibm.com>
From: Dave Hansen <hansendc@us.ibm.com>
Date: Fri, 09 Feb 2007 14:53:38 -0800
References: <20070209225329.27619A62@localhost.localdomain>
In-Reply-To: <20070209225329.27619A62@localhost.localdomain>
Message-Id: <20070209225338.FE350E83@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org




Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/open.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff -puN fs/open.c~15-24-elevate-writer-count-for-do-sys-truncate fs/open.c
--- lxc/fs/open.c~15-24-elevate-writer-count-for-do-sys-truncate	2007-02-09 14:26:55.000000000 -0800
+++ lxc-dave/fs/open.c	2007-02-09 14:26:55.000000000 -0800
@@ -241,28 +241,32 @@ static long do_sys_truncate(const char _
 	if (!S_ISREG(inode->i_mode))
 		goto dput_and_out;
 
-	error = vfs_permission(&nd, MAY_WRITE);
+	error = mnt_want_write(nd.mnt);
 	if (error)
 		goto dput_and_out;
 
+	error = vfs_permission(&nd, MAY_WRITE);
+	if (error)
+		goto mnt_drop_write_and_out;
+
 	error = -EROFS;
 	if (IS_RDONLY(inode))
-		goto dput_and_out;
+		goto mnt_drop_write_and_out;
 
 	error = -EPERM;
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		goto dput_and_out;
+		goto mnt_drop_write_and_out;
 
 	/*
 	 * Make sure that there are no leases.
 	 */
 	error = break_lease(inode, FMODE_WRITE);
 	if (error)
-		goto dput_and_out;
+		goto mnt_drop_write_and_out;
 
 	error = get_write_access(inode);
 	if (error)
-		goto dput_and_out;
+		goto mnt_drop_write_and_out;
 
 	error = locks_verify_truncate(inode, NULL, length);
 	if (!error) {
@@ -271,6 +275,8 @@ static long do_sys_truncate(const char _
 	}
 	put_write_access(inode);
 
+mnt_drop_write_and_out:
+	mnt_drop_write(nd.mnt);
 dput_and_out:
 	path_release(&nd);
 out:
_
