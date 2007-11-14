Return-Path: <linux-kernel-owner+w=401wt.eu-S1760872AbXKNCHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760872AbXKNCHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 21:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbXKNCFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 21:05:16 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:4759 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761135AbXKNCFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 21:05:14 -0500
Subject: [PATCH] - [6/15] - remove defconfig ptr comparisons to 0 - fs/jfs
From: Joe Perches <joe@perches.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Kleikamp <shaggy@austin.ibm.com>,
       jfs-discussion@lists.sourceforge.net
Content-Type: text/plain
Date: Tue, 13 Nov 2007 18:05:14 -0800
Message-Id: <1195005914.5163.92.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove defconfig ptr comparison to 0

Remove sparse warning: Using plain integer as NULL pointer

Signed-off-by: Joe Perches <joe@perches.com>

---

diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index df25ecc..eb6ba22 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -284,11 +284,11 @@ static struct dir_table_slot *find_index(struct inode *ip, u32 index,
 			release_metapage(*mp);
 			*mp = NULL;
 		}
-		if (*mp == 0) {
+		if (!(*mp)) {
 			*lblock = blkno;
 			*mp = read_index_page(ip, blkno);
 		}
-		if (*mp == 0) {
+		if (!(*mp)) {
 			jfs_err("free_index: error reading directory table");
 			return NULL;
 		}
@@ -413,7 +413,8 @@ static u32 add_index(tid_t tid, struct inode *ip, s64 bn, int slot)
 		}
 		ip->i_size = PSIZE;
 
-		if ((mp = get_index_page(ip, 0)) == 0) {
+		mp = get_index_page(ip, 0);
+		if (!mp) {
 			jfs_err("add_index: get_metapage failed!");
 			xtTruncate(tid, ip, 0, COMMIT_PWMAP);
 			memcpy(&jfs_ip->i_dirtable, temp_table,
@@ -461,7 +462,7 @@ static u32 add_index(tid_t tid, struct inode *ip, s64 bn, int slot)
 	} else
 		mp = read_index_page(ip, blkno);
 
-	if (mp == 0) {
+	if (!mp) {
 		jfs_err("add_index: get/read_metapage failed!");
 		goto clean_up;
 	}
@@ -499,7 +500,7 @@ static void free_index(tid_t tid, struct inode *ip, u32 index, u32 next)
 
 	dirtab_slot = find_index(ip, index, &mp, &lblock);
 
-	if (dirtab_slot == 0)
+	if (!dirtab_slot)
 		return;
 
 	dirtab_slot->flag = DIR_INDEX_FREE;
@@ -526,7 +527,7 @@ static void modify_index(tid_t tid, struct inode *ip, u32 index, s64 bn,
 
 	dirtab_slot = find_index(ip, index, mp, lblock);
 
-	if (dirtab_slot == 0)
+	if (!dirtab_slot)
 		return;
 
 	DTSaddress(dirtab_slot, bn);
@@ -552,7 +553,7 @@ static int read_index(struct inode *ip, u32 index,
 	struct dir_table_slot *slot;
 
 	slot = find_index(ip, index, &mp, &lblock);
-	if (slot == 0) {
+	if (!slot) {
 		return -EIO;
 	}
 
@@ -595,7 +596,7 @@ int dtSearch(struct inode *ip, struct component_name * key, ino_t * data,
 	ciKey.name =
 	    (wchar_t *) kmalloc((JFS_NAME_MAX + 1) * sizeof(wchar_t),
 				GFP_NOFS);
-	if (ciKey.name == 0) {
+	if (!ciKey.name) {
 		rc = -ENOMEM;
 		goto dtSearch_Exit2;
 	}
@@ -960,7 +961,7 @@ static int dtSplitUp(tid_t tid,
 	key.name =
 	    (wchar_t *) kmalloc((JFS_NAME_MAX + 2) * sizeof(wchar_t),
 				GFP_NOFS);
-	if (key.name == 0) {
+	if (!key.name) {
 		DT_PUTPAGE(smp);
 		rc = -ENOMEM;
 		goto dtSplitUp_Exit;
diff --git a/fs/jfs/jfs_imap.c b/fs/jfs/jfs_imap.c
index 3870ba8..9bf29f7 100644
--- a/fs/jfs/jfs_imap.c
+++ b/fs/jfs/jfs_imap.c
@@ -381,7 +381,7 @@ int diRead(struct inode *ip)
 
 	/* read the page of disk inode */
 	mp = read_metapage(ipimap, pageno << sbi->l2nbperpage, PSIZE, 1);
-	if (mp == 0) {
+	if (!mp) {
 		jfs_err("diRead: read_metapage failed");
 		return -EIO;
 	}
@@ -654,7 +654,7 @@ int diWrite(tid_t tid, struct inode *ip)
 	/* read the page of disk inode */
       retry:
 	mp = read_metapage(ipimap, pageno << sbi->l2nbperpage, PSIZE, 1);
-	if (mp == 0)
+	if (!mp)
 		return -EIO;
 
 	/* get the pointer to the disk inode */
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 15a3974..09ecd06 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -2347,7 +2347,7 @@ int jfsIOWait(void *arg)
 
 	do {
 		spin_lock_irq(&log_redrive_lock);
-		while ((bp = log_redrive_list) != 0) {
+		while ((bp = log_redrive_list)) {
 			log_redrive_list = bp->l_redrive_next;
 			bp->l_redrive_next = NULL;
 			spin_unlock_irq(&log_redrive_lock);
diff --git a/fs/jfs/jfs_mount.c b/fs/jfs/jfs_mount.c
index 644429a..7b698f2 100644
--- a/fs/jfs/jfs_mount.c
+++ b/fs/jfs/jfs_mount.c
@@ -147,7 +147,7 @@ int jfs_mount(struct super_block *sb)
 	 */
 	if ((sbi->mntflag & JFS_BAD_SAIT) == 0) {
 		ipaimap2 = diReadSpecial(sb, AGGREGATE_I, 1);
-		if (ipaimap2 == 0) {
+		if (!ipaimap2) {
 			jfs_err("jfs_mount: Faild to read AGGREGATE_I");
 			rc = -EIO;
 			goto errout35;
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 4e0a849..d6e5eba 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -1103,7 +1103,7 @@ static int jfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	 * Make sure dest inode number (if any) is what we think it is
 	 */
 	rc = dtSearch(new_dir, &new_dname, &ino, &btstack, JFS_LOOKUP);
-	if (rc == 0) {
+	if (!rc) {
 		if ((new_ip == 0) || (ino != new_ip->i_ino)) {
 			rc = -ESTALE;
 			goto out3;


