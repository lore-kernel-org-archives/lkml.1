Return-Path: <linux-kernel-owner+w=401wt.eu-S1752685AbXKVQ5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbXKVQ5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 11:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbXKVQ5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 11:57:47 -0500
Received: from sacred.ru ([62.205.161.221]:57395 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbXKVQ5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 11:57:46 -0500
Message-ID: <4745B4F2.3060308@openvz.org>
Date: Thu, 22 Nov 2007 19:57:22 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Linux MM <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: [PATCH][SHMEM] Factor out sbi->free_inodes manipulations
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 22 Nov 2007 19:57:25 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The shmem_sb_info structure has a number of free_inodes. This
value is altered in appropriate places under spinlock and with
the sbi->max_inodes != 0 check.

Consolidate these manipulations into two helpers.

This is minus 30 bytes of shmem.o and minus 4 :) lines of code.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/mm/shmem.c b/mm/shmem.c
index e0d4b2e..abba17c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -205,6 +205,29 @@ static void shmem_free_blocks(struct inode *inode, long pages)
 	}
 }
 
+static int shmem_inc_inodes(struct shmem_sb_info *sbinfo)
+{
+	if (sbinfo->max_inodes) {
+		spin_lock(&sbinfo->stat_lock);
+		if (!sbinfo->free_inodes) {
+			spin_unlock(&sbinfo->stat_lock);
+			return -ENOMEM;
+		}
+		sbinfo->free_inodes--;
+		spin_unlock(&sbinfo->stat_lock);
+	}
+	return 0;
+}
+
+static void shmem_dec_inodes(struct shmem_sb_info *sbinfo)
+{
+	if (sbinfo->max_inodes) {
+		spin_lock(&sbinfo->stat_lock);
+		sbinfo->free_inodes++;
+		spin_unlock(&sbinfo->stat_lock);
+	}
+}
+
 /*
  * shmem_recalc_inode - recalculate the size of an inode
  *
@@ -777,11 +800,7 @@ static void shmem_delete_inode(struct inode *inode)
 		}
 	}
 	BUG_ON(inode->i_blocks);
-	if (sbinfo->max_inodes) {
-		spin_lock(&sbinfo->stat_lock);
-		sbinfo->free_inodes++;
-		spin_unlock(&sbinfo->stat_lock);
-	}
+	shmem_dec_inodes(sbinfo);
 	clear_inode(inode);
 }
 
@@ -1370,15 +1389,8 @@ shmem_get_inode(struct super_block *sb, int mode, dev_t dev)
 	struct shmem_inode_info *info;
 	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
 
-	if (sbinfo->max_inodes) {
-		spin_lock(&sbinfo->stat_lock);
-		if (!sbinfo->free_inodes) {
-			spin_unlock(&sbinfo->stat_lock);
-			return NULL;
-		}
-		sbinfo->free_inodes--;
-		spin_unlock(&sbinfo->stat_lock);
-	}
+	if (shmem_inc_inodes(sbinfo))
+		return NULL;
 
 	inode = new_inode(sb);
 	if (inode) {
@@ -1422,11 +1434,8 @@ shmem_get_inode(struct super_block *sb, int mode, dev_t dev)
 						NULL);
 			break;
 		}
-	} else if (sbinfo->max_inodes) {
-		spin_lock(&sbinfo->stat_lock);
-		sbinfo->free_inodes++;
-		spin_unlock(&sbinfo->stat_lock);
-	}
+	} else
+		shmem_dec_inodes(sbinfo);
 	return inode;
 }
 
@@ -1676,15 +1685,8 @@ static int shmem_link(struct dentry *old_dentry, struct inode *dir, struct dentr
 	 * but each new link needs a new dentry, pinning lowmem, and
 	 * tmpfs dentries cannot be pruned until they are unlinked.
 	 */
-	if (sbinfo->max_inodes) {
-		spin_lock(&sbinfo->stat_lock);
-		if (!sbinfo->free_inodes) {
-			spin_unlock(&sbinfo->stat_lock);
-			return -ENOSPC;
-		}
-		sbinfo->free_inodes--;
-		spin_unlock(&sbinfo->stat_lock);
-	}
+	if (shmem_inc_inodes(sbinfo))
+		return -ENOSPC;
 
 	dir->i_size += BOGO_DIRENT_SIZE;
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
@@ -1699,14 +1701,8 @@ static int shmem_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
 
-	if (inode->i_nlink > 1 && !S_ISDIR(inode->i_mode)) {
-		struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
-		if (sbinfo->max_inodes) {
-			spin_lock(&sbinfo->stat_lock);
-			sbinfo->free_inodes++;
-			spin_unlock(&sbinfo->stat_lock);
-		}
-	}
+	if (inode->i_nlink > 1 && !S_ISDIR(inode->i_mode))
+		shmem_dec_inodes(SHMEM_SB(inode->i_sb));
 
 	dir->i_size -= BOGO_DIRENT_SIZE;
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
