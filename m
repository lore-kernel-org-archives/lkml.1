Return-Path: <linux-kernel-owner+w=401wt.eu-S1757303AbYEPQct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbYEPQct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYEPQc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:32:29 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33683 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbYEPQc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:32:28 -0400
Message-Id: <20080516163215.374408327@szeredi.hu>
References: <20080516163136.560107038@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 16 May 2008 18:31:38 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Paul Menage <menage@google.com>
Subject: [patch 02/22] cgroup: dont call vfs_mkdir
Content-Disposition: inline; filename=cgroup_mkdir_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

cgroup_clone() calls vfs_mkdir() to create a directory in the cgroup
filesystem.  Replace with explicit call to cgroup_mkdir() and
fsnotify_mkdir().

This is equivalent, except that the following functions are not called
before cgroup_mkdir():

 - may_create()
 - security_inode_mkdir()
 - DQUOT_INIT()

Permission to clone the cgroup has already been checked in
copy_namespaces() (requiring CAP_SYS_ADMIN).  Additional file system
related capability checks are inappropriate and confusing.

The quota check is unnecessary, as quotas don't make any sense for
this filesystem.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Paul Menage <menage@google.com>
---
 kernel/cgroup.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/cgroup.c
===================================================================
--- linux-2.6.orig/kernel/cgroup.c	2008-05-16 17:50:35.000000000 +0200
+++ linux-2.6/kernel/cgroup.c	2008-05-16 17:50:43.000000000 +0200
@@ -25,6 +25,7 @@
 #include <linux/cgroup.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
+#include <linux/fsnotify.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/mm.h>
@@ -2928,7 +2929,9 @@ int cgroup_clone(struct task_struct *tsk
 	}
 
 	/* Create the cgroup directory, which also creates the cgroup */
-	ret = vfs_mkdir(inode, dentry, S_IFDIR | 0755);
+	ret = cgroup_mkdir(inode, dentry, S_IFDIR);
+	if (!ret)
+		fsnotify_mkdir(inode, dentry);
 	child = __d_cgrp(dentry);
 	dput(dentry);
 	if (ret) {

--
