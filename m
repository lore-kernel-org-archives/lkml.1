Return-Path: <linux-kernel-owner+w=401wt.eu-S1758174AbYEPQdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174AbYEPQdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756602AbYEPQce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:32:34 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33699 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794AbYEPQcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:32:32 -0400
Message-Id: <20080516163219.407780472@szeredi.hu>
References: <20080516163136.560107038@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 16 May 2008 18:31:41 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 05/22] sysfs: dont call notify_change
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
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/file.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/sysfs/file.c
===================================================================
--- linux-2.6.orig/fs/sysfs/file.c	2008-05-16 17:50:35.000000000 +0200
+++ linux-2.6/fs/sysfs/file.c	2008-05-16 17:50:44.000000000 +0200
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

--
