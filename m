Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbYFPLq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbYFPLq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 07:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYFPLqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 07:46:49 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60509 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbYFPLqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 07:46:49 -0400
To: gregkh@suse.de
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch] sysfs: don't call notify_change
Message-Id: <E1K8DAd-0006my-Ck@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 16 Jun 2008 13:46:47 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Could you please take this patch into your 2.6.27 queue?

Thanks,
Miklos

--
From: Miklos Szeredi <mszeredi@suse.cz>

sysfs_chmod_file() calls notify_change() to change the permission bits
on a sysfs file.  Replace with explicit call to sysfs_setattr() and
fsnotify_change().

This is equivalent, except that security_inode_setattr() is not
called.  This function is called by drivers, so the security checks do
not make any sense.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/file.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/sysfs/file.c
===================================================================
--- linux-2.6.orig/fs/sysfs/file.c	2008-06-09 19:16:45.000000000 +0200
+++ linux-2.6/fs/sysfs/file.c	2008-06-09 19:49:49.000000000 +0200
@@ -14,6 +14,7 @@
 #include <linux/kobject.h>
 #include <linux/kallsyms.h>
 #include <linux/slab.h>
+#include <linux/fsnotify.h>
 #include <linux/namei.h>
 #include <linux/poll.h>
 #include <linux/list.h>
@@ -585,9 +586,11 @@ int sysfs_chmod_file(struct kobject *kob
 
 	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
 	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
-	rc = notify_change(victim, &newattrs);
+	newattrs.ia_ctime = current_fs_time(inode->i_sb);
+	rc = sysfs_setattr(victim, &newattrs);
 
 	if (rc == 0) {
+		fsnotify_change(victim, newattrs.ia_valid);
 		mutex_lock(&sysfs_mutex);
 		victim_sd->s_mode = newattrs.ia_mode;
 		mutex_unlock(&sysfs_mutex);
