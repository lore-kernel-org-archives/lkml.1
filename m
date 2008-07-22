Return-Path: <linux-kernel-owner+w=401wt.eu-S1760525AbYGVFmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760525AbYGVFmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757041AbYGVFZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:25:55 -0400
Received: from mail.suse.de ([195.135.220.2]:54089 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757554AbYGVFZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:25:54 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Miklos Szeredi <mszeredi@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 63/79] sysfs: don't call notify_change
Date: Mon, 21 Jul 2008 22:19:27 -0700
Message-Id: <1216703983-21448-63-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/file.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index e7735f6..3f07893 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -14,6 +14,7 @@
 #include <linux/kobject.h>
 #include <linux/kallsyms.h>
 #include <linux/slab.h>
+#include <linux/fsnotify.h>
 #include <linux/namei.h>
 #include <linux/poll.h>
 #include <linux/list.h>
@@ -585,9 +586,11 @@ int sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode)
 
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
1.5.6.3

