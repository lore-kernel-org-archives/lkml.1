Return-Path: <linux-kernel-owner+w=401wt.eu-S1756599AbYJOOH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbYJOOH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754438AbYJOOE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:04:56 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:45132 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbYJOOEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:04:49 -0400
Subject: [PATCH 1/6] vfs: replace parent == dentry->d_parent by IS_ROOT()
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Wed, 15 Oct 2008 22:58:09 +0900
Message-ID: <fcaad2cb3e848f5f6f1126623.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/dcache.c |   21 ++++++++++++---------
 fs/namei.c  |    4 ++--
 2 files changed, 14 insertions(+), 11 deletions(-)

diff -puN fs/dcache.c~dcache-cleanup-1 fs/dcache.c
--- linux-2.6/fs/dcache.c~dcache-cleanup-1	2008-09-30 05:24:32.000000000 +0900
+++ linux-2.6-hirofumi/fs/dcache.c	2008-09-30 05:24:32.000000000 +0900
@@ -174,9 +174,12 @@ static struct dentry *d_kill(struct dent
 	dentry_stat.nr_dentry--;	/* For d_free, below */
 	/*drops the locks, at that point nobody can reach this dentry */
 	dentry_iput(dentry);
-	parent = dentry->d_parent;
+	if (IS_ROOT(dentry))
+		parent = NULL;
+	else
+		parent = dentry->d_parent;
 	d_free(dentry);
-	return dentry == parent ? NULL : parent;
+	return parent;
 }
 
 /* 
@@ -666,11 +669,12 @@ static void shrink_dcache_for_umount_sub
 				BUG();
 			}
 
-			parent = dentry->d_parent;
-			if (parent == dentry)
+			if (IS_ROOT(dentry))
 				parent = NULL;
-			else
+			else {
+				parent = dentry->d_parent;
 				atomic_dec(&parent->d_count);
+			}
 
 			list_del(&dentry->d_u.d_child);
 			detached++;
@@ -1721,7 +1725,7 @@ static int d_isparent(struct dentry *p1,
 {
 	struct dentry *p;
 
-	for (p = p2; p->d_parent != p; p = p->d_parent) {
+	for (p = p2; !IS_ROOT(p); p = p->d_parent) {
 		if (p->d_parent == p1)
 			return 1;
 	}
@@ -2166,10 +2170,9 @@ int is_subdir(struct dentry * new_dentry
 		seq = read_seqbegin(&rename_lock);
 		for (;;) {
 			if (new_dentry != old_dentry) {
-				struct dentry * parent = new_dentry->d_parent;
-				if (parent == new_dentry)
+				if (IS_ROOT(new_dentry))
 					break;
-				new_dentry = parent;
+				new_dentry = new_dentry->d_parent;
 				continue;
 			}
 			result = 1;
diff -puN fs/namei.c~dcache-cleanup-1 fs/namei.c
--- linux-2.6/fs/namei.c~dcache-cleanup-1	2008-09-30 05:24:32.000000000 +0900
+++ linux-2.6-hirofumi/fs/namei.c	2008-09-30 05:24:32.000000000 +0900
@@ -1470,7 +1470,7 @@ struct dentry *lock_rename(struct dentry
 
 	mutex_lock(&p1->d_inode->i_sb->s_vfs_rename_mutex);
 
-	for (p = p1; p->d_parent != p; p = p->d_parent) {
+	for (p = p1; !IS_ROOT(p); p = p->d_parent) {
 		if (p->d_parent == p2) {
 			mutex_lock_nested(&p2->d_inode->i_mutex, I_MUTEX_PARENT);
 			mutex_lock_nested(&p1->d_inode->i_mutex, I_MUTEX_CHILD);
@@ -1478,7 +1478,7 @@ struct dentry *lock_rename(struct dentry
 		}
 	}
 
-	for (p = p2; p->d_parent != p; p = p->d_parent) {
+	for (p = p2; !IS_ROOT(p); p = p->d_parent) {
 		if (p->d_parent == p1) {
 			mutex_lock_nested(&p1->d_inode->i_mutex, I_MUTEX_PARENT);
 			mutex_lock_nested(&p2->d_inode->i_mutex, I_MUTEX_CHILD);
_
