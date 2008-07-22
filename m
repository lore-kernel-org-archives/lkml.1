Return-Path: <linux-kernel-owner+w=401wt.eu-S1756572AbYGVWNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbYGVWNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 18:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbYGVWNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 18:13:21 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59078 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962AbYGVWNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 18:13:21 -0400
Message-Id: <20080722221317.644649808@szeredi.hu>
References: <20080722221259.866628660@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 23 Jul 2008 00:13:00 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, Paul Menage <menage@google.com>
Subject: [patch 01/14] cgroup: dont call vfs_mkdir
Content-Disposition: inline; filename=cgroup-dont-call-vfs_mkdir.patch
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
--- linux-2.6.orig/kernel/cgroup.c	2008-07-23 00:10:13.000000000 +0200
+++ linux-2.6/kernel/cgroup.c	2008-07-23 00:10:20.000000000 +0200
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
