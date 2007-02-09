Return-Path: <linux-kernel-owner+w=401wt.eu-S1423364AbXBIWyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423364AbXBIWyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 17:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946544AbXBIWyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 17:54:37 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:44346 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423363AbXBIWxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 17:53:38 -0500
Subject: [PATCH 10/22] unix_find_other() elevate write count for touch_atime()
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, hch@infradead.org, Dave Hansen <hansendc@us.ibm.com>
From: Dave Hansen <hansendc@us.ibm.com>
Date: Fri, 09 Feb 2007 14:53:36 -0800
References: <20070209225329.27619A62@localhost.localdomain>
In-Reply-To: <20070209225329.27619A62@localhost.localdomain>
Message-Id: <20070209225336.8096B175@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org




Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/net/unix/af_unix.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN net/unix/af_unix.c~12-24-unix-find-other-elevate-write-count-for-touch-atime net/unix/af_unix.c
--- lxc/net/unix/af_unix.c~12-24-unix-find-other-elevate-write-count-for-touch-atime	2007-02-09 14:26:52.000000000 -0800
+++ lxc-dave/net/unix/af_unix.c	2007-02-09 14:26:52.000000000 -0800
@@ -703,21 +703,27 @@ static struct sock *unix_find_other(stru
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
@@ -737,7 +743,9 @@ static struct sock *unix_find_other(stru
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
