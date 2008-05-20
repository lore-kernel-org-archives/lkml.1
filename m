Return-Path: <linux-kernel-owner+w=401wt.eu-S933077AbYETQvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077AbYETQvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 12:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932897AbYETQuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 12:50:22 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:60685 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140AbYETQuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 12:50:20 -0400
X-Greylist: delayed 338 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 May 2008 12:50:11 EDT
Message-Id: <20080520164318.701429902@kerlabs.com>
References: <20080520163320.025971210@kerlabs.com>
User-Agent: quilt/0.46-1
Date: Tue, 20 May 2008 18:33:22 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel.Becker@oracle.com
Cc: Louis.Rilling@kerlabs.com, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: [RFC][PATCH 2/3] configfs: Silence lockdep when creating nested default groups
Content-Disposition: inline; filename=configfs-silence-lockdep-with-default-group-creation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When default groups are nested, lockdep raises a warning since it sees a
lock recursion of class I_MUTEX_CHILD in populate_groups().
However, this lock recursion is just a variant of the I_MUTEX_PARENT ->
I_MUTEX_CHILD dependency, which is ok in the VFS, and is already checked when
creating the first level of default groups.

This patch silences lockdep with nested default groups, by hiding the mutex
locks of populate_groups() from lockdep when the considered config_group is
itself a default group. The mutex is not hidden for a non-default group, so that
the lock dependency remains checked, in case things change in some future.

Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>
---
 fs/configfs/dir.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)


Index: b/fs/configfs/dir.c
===================================================================
--- a/fs/configfs/dir.c	2008-05-20 18:19:35.000000000 +0200
+++ b/fs/configfs/dir.c	2008-05-20 18:19:41.000000000 +0200
@@ -535,6 +535,8 @@ static int populate_groups(struct config
 	int i;
 
 	if (group->default_groups) {
+		struct configfs_dirent *sd = dentry->d_fsdata;
+		int turn_lockdep_off = (sd->s_type & CONFIGFS_USET_DEFAULT);
 		/*
 		 * FYI, we're faking mkdir here
 		 * I'm not sure we need this semaphore, as we're called
@@ -544,7 +546,18 @@ static int populate_groups(struct config
 		 * That said, taking our i_mutex is closer to mkdir
 		 * emulation, and shouldn't hurt.
 		 */
+		/* For a default group, we hide this mutex from lockdep since:
+		 * 1/ This is a case of I_MUTEX_PARENT -> I_MUTEX_CHILD
+		 *    dependency;
+		 * 2/ This dependency was already checked when creating the
+		 *    parent of this group;
+		 * 3/ Lockdep does not handle such safe recursion.
+		 */
+		if (turn_lockdep_off)
+			lockdep_off();
 		mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
+		if (turn_lockdep_off)
+			lockdep_on();
 
 		for (i = 0; group->default_groups[i]; i++) {
 			new_group = group->default_groups[i];
@@ -554,7 +567,11 @@ static int populate_groups(struct config
 				break;
 		}
 
+		if (turn_lockdep_off)
+			lockdep_off();
 		mutex_unlock(&dentry->d_inode->i_mutex);
+		if (turn_lockdep_off)
+			lockdep_on();
 	}
 
 	if (ret)

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

