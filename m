Return-Path: <linux-kernel-owner+w=401wt.eu-S1757281AbXIQSei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281AbXIQSei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756384AbXIQS14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:27:56 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:37979 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280AbXIQS1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:27:49 -0400
Subject: [PATCH 14/24] unix_find_other() elevate write count for touch_atime()
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Mon, 17 Sep 2007 11:27:36 -0700
References: <20070917182718.70494C9B@kernel>
In-Reply-To: <20070917182718.70494C9B@kernel>
Message-Id: <20070917182736.66C5E7FC@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/net/unix/af_unix.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN net/unix/af_unix.c~unix-find-other-elevate-write-count-for-touch-atime net/unix/af_unix.c
--- lxc/net/unix/af_unix.c~unix-find-other-elevate-write-count-for-touch-atime	2007-09-17 09:44:04.000000000 -0700
+++ lxc-dave/net/unix/af_unix.c	2007-09-17 09:44:04.000000000 -0700
@@ -729,21 +729,27 @@ static struct sock *unix_find_other(stru
 		err = path_lookup(sunname->sun_path, LOOKUP_FOLLOW, &nd);
 		if (err)
 			goto fail;
+
+		err = mnt_want_write(nd.mnt);
+		if (err)
+			goto put_path_fail;
+
 		err = vfs_permission(&nd, MAY_WRITE);
 		if (err)
-			goto put_fail;
+			goto mnt_drop_write_fail;
 
 		err = -ECONNREFUSED;
 		if (!S_ISSOCK(nd.dentry->d_inode->i_mode))
-			goto put_fail;
+			goto mnt_drop_write_fail;
 		u=unix_find_socket_byinode(nd.dentry->d_inode);
 		if (!u)
-			goto put_fail;
+			goto mnt_drop_write_fail;
 
 		if (u->sk_type == type)
 			touch_atime(nd.mnt, nd.dentry);
 
 		path_release(&nd);
+		mnt_drop_write(nd.mnt);
 
 		err=-EPROTOTYPE;
 		if (u->sk_type != type) {
@@ -763,7 +769,9 @@ static struct sock *unix_find_other(stru
 	}
 	return u;
 
-put_fail:
+mnt_drop_write_fail:
+	mnt_drop_write(nd.mnt);
+put_path_fail:
 	path_release(&nd);
 fail:
 	*error=err;
_
