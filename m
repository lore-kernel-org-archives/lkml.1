Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbYHMIqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbYHMIqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755700AbYHMIjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:39:46 -0400
Received: from smtp.nokia.com ([192.100.122.230]:37213 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673AbYHMIjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:39:44 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Zoltan Sogor <weth@inf.u-szeged.hu>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] UBIFS: remove another unneeded function parameter
Date: Wed, 13 Aug 2008 13:17:40 +0300
Message-Id: <1218622675-28853-12-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
References: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 13 Aug 2008 08:39:03.0394 (UTC) FILETIME=[0A514C20:01C8FD20]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

The 'last_reference' parameter of 'pack_inode()' is not really
needed because 'inode->i_nlink' may be tested instead. Zap it.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/journal.c |   30 ++++++++++++++----------------
 1 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index 666ad82..3bc3fc9 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -447,13 +447,11 @@ static int get_dent_type(int mode)
  * @ino: buffer in which to pack inode node
  * @inode: inode to pack
  * @last: indicates the last node of the group
- * @last_reference: non-zero if this is a deletion inode
  */
 static void pack_inode(struct ubifs_info *c, struct ubifs_ino_node *ino,
-		       const struct inode *inode, int last,
-		       int last_reference)
+		       const struct inode *inode, int last)
 {
-	int data_len = 0;
+	int data_len = 0, last_reference = !inode->i_nlink;
 	struct ubifs_inode *ui = ubifs_inode(inode);
 
 	ino->ch.node_type = UBIFS_INO_NODE;
@@ -596,9 +594,9 @@ int ubifs_jnl_update(struct ubifs_info *c, const struct inode *dir,
 	ubifs_prep_grp_node(c, dent, dlen, 0);
 
 	ino = (void *)dent + aligned_dlen;
-	pack_inode(c, ino, inode, 0, last_reference);
+	pack_inode(c, ino, inode, 0);
 	ino = (void *)ino + aligned_ilen;
-	pack_inode(c, ino, dir, 1, 0);
+	pack_inode(c, ino, dir, 1);
 
 	if (last_reference) {
 		err = ubifs_add_orphan(c, inode->i_ino);
@@ -781,7 +779,7 @@ int ubifs_jnl_write_inode(struct ubifs_info *c, const struct inode *inode)
 	if (err)
 		goto out_free;
 
-	pack_inode(c, ino, inode, 1, last_reference);
+	pack_inode(c, ino, inode, 1);
 	err = write_head(c, BASEHD, ino, len, &lnum, &offs, sync);
 	if (err)
 		goto out_release;
@@ -912,16 +910,16 @@ int ubifs_jnl_rename(struct ubifs_info *c, const struct inode *old_dir,
 
 	p = (void *)dent2 + aligned_dlen2;
 	if (new_inode) {
-		pack_inode(c, p, new_inode, 0, last_reference);
+		pack_inode(c, p, new_inode, 0);
 		p += ALIGN(ilen, 8);
 	}
 
 	if (!move)
-		pack_inode(c, p, old_dir, 1, 0);
+		pack_inode(c, p, old_dir, 1);
 	else {
-		pack_inode(c, p, old_dir, 0, 0);
+		pack_inode(c, p, old_dir, 0);
 		p += ALIGN(plen, 8);
-		pack_inode(c, p, new_dir, 1, 0);
+		pack_inode(c, p, new_dir, 1);
 	}
 
 	if (last_reference) {
@@ -1126,7 +1124,7 @@ int ubifs_jnl_truncate(struct ubifs_info *c, const struct inode *inode,
 	if (err)
 		goto out_free;
 
-	pack_inode(c, ino, inode, 0, 0);
+	pack_inode(c, ino, inode, 0);
 	ubifs_prep_grp_node(c, trun, UBIFS_TRUN_NODE_SZ, dlen ? 0 : 1);
 	if (dlen)
 		ubifs_prep_grp_node(c, dn, dlen, 1);
@@ -1246,9 +1244,9 @@ int ubifs_jnl_delete_xattr(struct ubifs_info *c, const struct inode *host,
 	ubifs_prep_grp_node(c, xent, xlen, 0);
 
 	ino = (void *)xent + aligned_xlen;
-	pack_inode(c, ino, inode, 0, 1);
+	pack_inode(c, ino, inode, 0);
 	ino = (void *)ino + UBIFS_INO_NODE_SZ;
-	pack_inode(c, ino, host, 1, 0);
+	pack_inode(c, ino, host, 1);
 
 	err = write_head(c, BASEHD, xent, len, &lnum, &xent_offs, sync);
 	if (!sync && !err)
@@ -1339,8 +1337,8 @@ int ubifs_jnl_change_xattr(struct ubifs_info *c, const struct inode *inode,
 	if (err)
 		goto out_free;
 
-	pack_inode(c, ino, host, 0, 0);
-	pack_inode(c, (void *)ino + aligned_len1, inode, 1, 0);
+	pack_inode(c, ino, host, 0);
+	pack_inode(c, (void *)ino + aligned_len1, inode, 1);
 
 	err = write_head(c, BASEHD, ino, aligned_len, &lnum, &offs, 0);
 	if (!sync && !err) {
-- 
1.5.4.1

