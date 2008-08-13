Return-Path: <linux-kernel-owner+w=401wt.eu-S1756442AbYHMImq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442AbYHMImq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449AbYHMIja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:39:30 -0400
Received: from smtp.nokia.com ([192.100.122.233]:46380 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180AbYHMIj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:39:27 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Zoltan Sogor <weth@inf.u-szeged.hu>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] UBIFS: remove unneeded function parameter
Date: Wed, 13 Aug 2008 13:17:39 +0300
Message-Id: <1218622675-28853-11-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
References: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 13 Aug 2008 08:39:03.0347 (UTC) FILETIME=[0A4A2030:01C8FD20]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Simplify 'ubifs_jnl_write_inode()' by removing the 'deletion'
parameter which is not really needed because we may test
inode->i_nlink and check whether this is a deletion or not.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/journal.c |   19 +++++++------------
 fs/ubifs/super.c   |    4 ++--
 fs/ubifs/ubifs.h   |    3 +--
 3 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index 283155a..666ad82 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -750,30 +750,25 @@ out_free:
  * ubifs_jnl_write_inode - flush inode to the journal.
  * @c: UBIFS file-system description object
  * @inode: inode to flush
- * @deletion: inode has been deleted
  *
  * This function writes inode @inode to the journal. If the inode is
  * synchronous, it also synchronizes the write-buffer. Returns zero in case of
  * success and a negative error code in case of failure.
  */
-int ubifs_jnl_write_inode(struct ubifs_info *c, const struct inode *inode,
-			  int deletion)
+int ubifs_jnl_write_inode(struct ubifs_info *c, const struct inode *inode)
 {
-	int err, len, lnum, offs, sync = 0;
+	int err, lnum, offs;
 	struct ubifs_ino_node *ino;
 	struct ubifs_inode *ui = ubifs_inode(inode);
+	int sync = 0, len = UBIFS_INO_NODE_SZ, last_reference = !inode->i_nlink;
 
-	dbg_jnl("ino %lu%s", inode->i_ino,
-		deletion ? " (last reference)" : "");
-	if (deletion)
-		ubifs_assert(inode->i_nlink == 0);
+	dbg_jnl("ino %lu, nlink %u", inode->i_ino, inode->i_nlink);
 
-	len = UBIFS_INO_NODE_SZ;
 	/*
 	 * If the inode is being deleted, do not write the attached data. No
 	 * need to synchronize the write-buffer either.
 	 */
-	if (!deletion) {
+	if (!last_reference) {
 		len += ui->data_len;
 		sync = IS_SYNC(inode);
 	}
@@ -786,7 +781,7 @@ int ubifs_jnl_write_inode(struct ubifs_info *c, const struct inode *inode,
 	if (err)
 		goto out_free;
 
-	pack_inode(c, ino, inode, 1, deletion);
+	pack_inode(c, ino, inode, 1, last_reference);
 	err = write_head(c, BASEHD, ino, len, &lnum, &offs, sync);
 	if (err)
 		goto out_release;
@@ -795,7 +790,7 @@ int ubifs_jnl_write_inode(struct ubifs_info *c, const struct inode *inode,
 					  inode->i_ino);
 	release_head(c, BASEHD);
 
-	if (deletion) {
+	if (last_reference) {
 		err = ubifs_tnc_remove_ino(c, inode->i_ino);
 		if (err)
 			goto out_ro;
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 13e90b0..cf1fb6c 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -306,7 +306,7 @@ static int ubifs_write_inode(struct inode *inode, int wait)
 	dbg_gen("inode %lu, mode %#x, nlink %u",
 		inode->i_ino, (int)inode->i_mode, inode->i_nlink);
 	if (inode->i_nlink) {
-		err = ubifs_jnl_write_inode(c, inode, 0);
+		err = ubifs_jnl_write_inode(c, inode);
 		if (err)
 			ubifs_err("can't write inode %lu, error %d",
 				  inode->i_ino, err);
@@ -341,7 +341,7 @@ static void ubifs_delete_inode(struct inode *inode)
 		goto out;
 
 	ui->ui_size = inode->i_size = 0;
-	err = ubifs_jnl_write_inode(c, inode, 1);
+	err = ubifs_jnl_write_inode(c, inode);
 	if (err)
 		/*
 		 * Worst case we have a lost orphan inode wasting space, so a
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index c488d43..6ddd1de 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1400,8 +1400,7 @@ int ubifs_jnl_update(struct ubifs_info *c, const struct inode *dir,
 		     int deletion, int xent);
 int ubifs_jnl_write_data(struct ubifs_info *c, const struct inode *inode,
 			 const union ubifs_key *key, const void *buf, int len);
-int ubifs_jnl_write_inode(struct ubifs_info *c, const struct inode *inode,
-			  int last_reference);
+int ubifs_jnl_write_inode(struct ubifs_info *c, const struct inode *inode);
 int ubifs_jnl_rename(struct ubifs_info *c, const struct inode *old_dir,
 		     const struct dentry *old_dentry,
 		     const struct inode *new_dir,
-- 
1.5.4.1

