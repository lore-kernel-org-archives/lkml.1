Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbYJOOIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbYJOOIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbYJOOE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:04:57 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:45133 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbYJOOEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:04:49 -0400
Subject: [PATCH 2/6] vfs: add d_ancestor()
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Wed, 15 Oct 2008 22:58:10 +0900
Message-ID: <e015bca83e848f5f6f2226623.ps@mail.parknet.co.jp>
References: <fcaad2cb3e848f5f6f1126623.ps@mail.parknet.co.jp>
In-Reply-To: <fcaad2cb3e848f5f6f1126623.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



This adds d_ancestor() instead of d_isparent(), then use it.

If new_dentry == old_dentry, is_subdir() returns 1, looks strange. But
I'm not checking callers for now, so this keeps current behavior.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/dcache.c            |   28 ++++++++++------------------
 fs/namei.c             |   22 ++++++++++------------
 include/linux/dcache.h |    1 +
 3 files changed, 21 insertions(+), 30 deletions(-)

diff -puN fs/dcache.c~dcache-cleanup-2 fs/dcache.c
--- linux-2.6/fs/dcache.c~dcache-cleanup-2	2008-10-13 02:26:23.000000000 +0900
+++ linux-2.6-hirofumi/fs/dcache.c	2008-10-13 02:26:55.000000000 +0900
@@ -1719,17 +1719,18 @@ void d_move(struct dentry * dentry, stru
 }
 
 /*
- * Helper that returns 1 if p1 is a parent of p2, else 0
+ * Helper that returns the ancestor dentry of p2 which is a child of
+ * p1, if p1 is an ancestor of p2, else NULL.
  */
-static int d_isparent(struct dentry *p1, struct dentry *p2)
+struct dentry *d_ancestor(struct dentry *p1, struct dentry *p2)
 {
 	struct dentry *p;
 
 	for (p = p2; !IS_ROOT(p); p = p->d_parent) {
 		if (p->d_parent == p1)
-			return 1;
+			return p;
 	}
-	return 0;
+	return NULL;
 }
 
 /*
@@ -1753,7 +1754,7 @@ static struct dentry *__d_unalias(struct
 
 	/* Check for loops */
 	ret = ERR_PTR(-ELOOP);
-	if (d_isparent(alias, dentry))
+	if (d_ancestor(alias, dentry))
 		goto out_err;
 
 	/* See lock_rename() */
@@ -2156,28 +2157,19 @@ out:
 int is_subdir(struct dentry * new_dentry, struct dentry * old_dentry)
 {
 	int result;
-	struct dentry * saved = new_dentry;
 	unsigned long seq;
 
+	if (new_dentry == old_dentry)
+		return 1;
+
 	/* need rcu_readlock to protect against the d_parent trashing due to
 	 * d_move
 	 */
 	rcu_read_lock();
         do {
 		/* for restarting inner loop in case of seq retry */
-		new_dentry = saved;
-		result = 0;
 		seq = read_seqbegin(&rename_lock);
-		for (;;) {
-			if (new_dentry != old_dentry) {
-				if (IS_ROOT(new_dentry))
-					break;
-				new_dentry = new_dentry->d_parent;
-				continue;
-			}
-			result = 1;
-			break;
-		}
+		result = (d_ancestor(old_dentry, new_dentry) != NULL);
 	} while (read_seqretry(&rename_lock, seq));
 	rcu_read_unlock();
 
diff -puN include/linux/dcache.h~dcache-cleanup-2 include/linux/dcache.h
--- linux-2.6/include/linux/dcache.h~dcache-cleanup-2	2008-10-13 02:26:23.000000000 +0900
+++ linux-2.6-hirofumi/include/linux/dcache.h	2008-10-13 02:26:23.000000000 +0900
@@ -287,6 +287,7 @@ static inline struct dentry *d_add_uniqu
 
 /* used for rename() and baskets */
 extern void d_move(struct dentry *, struct dentry *);
+extern struct dentry *d_ancestor(struct dentry *, struct dentry *);
 
 /* appendix may either be NULL or be used for transname suffixes */
 extern struct dentry * d_lookup(struct dentry *, struct qstr *);
diff -puN fs/namei.c~dcache-cleanup-2 fs/namei.c
--- linux-2.6/fs/namei.c~dcache-cleanup-2	2008-10-13 02:26:23.000000000 +0900
+++ linux-2.6-hirofumi/fs/namei.c	2008-10-13 02:26:23.000000000 +0900
@@ -1470,20 +1470,18 @@ struct dentry *lock_rename(struct dentry
 
 	mutex_lock(&p1->d_inode->i_sb->s_vfs_rename_mutex);
 
-	for (p = p1; !IS_ROOT(p); p = p->d_parent) {
-		if (p->d_parent == p2) {
-			mutex_lock_nested(&p2->d_inode->i_mutex, I_MUTEX_PARENT);
-			mutex_lock_nested(&p1->d_inode->i_mutex, I_MUTEX_CHILD);
-			return p;
-		}
+	p = d_ancestor(p2, p1);
+	if (p) {
+		mutex_lock_nested(&p2->d_inode->i_mutex, I_MUTEX_PARENT);
+		mutex_lock_nested(&p1->d_inode->i_mutex, I_MUTEX_CHILD);
+		return p;
 	}
 
-	for (p = p2; !IS_ROOT(p); p = p->d_parent) {
-		if (p->d_parent == p1) {
-			mutex_lock_nested(&p1->d_inode->i_mutex, I_MUTEX_PARENT);
-			mutex_lock_nested(&p2->d_inode->i_mutex, I_MUTEX_CHILD);
-			return p;
-		}
+	p = d_ancestor(p1, p2);
+	if (p) {
+		mutex_lock_nested(&p1->d_inode->i_mutex, I_MUTEX_PARENT);
+		mutex_lock_nested(&p2->d_inode->i_mutex, I_MUTEX_CHILD);
+		return p;
 	}
 
 	mutex_lock_nested(&p1->d_inode->i_mutex, I_MUTEX_PARENT);
_
