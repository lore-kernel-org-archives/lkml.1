Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbXIYW7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbXIYW7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 18:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbXIYW7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 18:59:09 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:38338 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbXIYW7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 18:59:08 -0400
To: haveblue@us.ibm.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch] fix sys_mknodat breakage from r/o bind mounts
Message-Id: <E1IaJMd-000535-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 26 Sep 2007 00:58:47 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

mknod("foo", 0644) returns EINVAL, even though it should succeed.

The responsible patch is this:

r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/namei.c
===================================================================
--- linux.orig/fs/namei.c	2007-09-26 00:36:15.000000000 +0200
+++ linux/fs/namei.c	2007-09-26 00:51:19.000000000 +0200
@@ -1984,7 +1984,7 @@ asmlinkage long sys_mknodat(int dfd, con
 		goto out_dput;
 	}
 	if (!S_ISREG(mode)  && !S_ISCHR(mode)  && !S_ISBLK(mode) &&
-	    !S_ISFIFO(mode) && !S_ISSOCK(mode) && mode != 0) {
+	    !S_ISFIFO(mode) && !S_ISSOCK(mode) && (mode & S_IFMT) != 0) {
 		error = -EINVAL;
 		goto out_dput;
 	}

