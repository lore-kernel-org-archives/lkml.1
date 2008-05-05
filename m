Return-Path: <linux-kernel-owner+w=401wt.eu-S1758909AbYEEJ6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909AbYEEJ6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 05:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757236AbYEEJzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 05:55:37 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:38354 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758080AbYEEJze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 05:55:34 -0400
Message-Id: <20080505095516.130659599@szeredi.hu>
References: <20080505095440.820370974@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Mon, 05 May 2008 11:54:47 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 06/15] sysfs: dont call notify_change
Content-Disposition: inline; filename=sysfs_notify_change_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

sysfs_chmod_file() calls notify_change() to change the permission bits
on a sysfs file.  Replace with explicit call to sysfs_setattr() and
fsnotify_change().

This is equivalent, except that security_inode_setattr() is not
called.  This function is called by drivers, so the security checks do
not make any sense.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/file.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/sysfs/file.c
===================================================================
--- linux-2.6.orig/fs/sysfs/file.c	2008-05-05 11:29:21.000000000 +0200
+++ linux-2.6/fs/sysfs/file.c	2008-05-05 11:29:26.000000000 +0200
@@ -18,6 +18,7 @@
 #include <linux/poll.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/fsnotify.h>
 #include <asm/uaccess.h>
 
 #include "sysfs.h"
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

--
