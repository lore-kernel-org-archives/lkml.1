Return-Path: <linux-kernel-owner+w=401wt.eu-S934437AbYD1Opb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934437AbYD1Opb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 10:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933634AbYD1OpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 10:45:23 -0400
Received: from styx.suse.cz ([82.119.242.94]:47347 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933539AbYD1OpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 10:45:23 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH] isofs: Fix access to unallocated memory when reading corrupted filesystem
Date: Mon, 28 Apr 2008 16:45:21 +0200
Message-Id: <12093939211835-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When directory of isofs is corrupted, we did not check whether length of the
name in a directory entry and the lenght of the directory entry itself are
consistent. This could lead to possible access beyond the end of buffer when
the lenght of the name was too big. Add this sanity check to directory reading
code.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/isofs/dir.c   |    8 ++++++++
 fs/isofs/namei.c |    7 +++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/fs/isofs/dir.c b/fs/isofs/dir.c
index 1ba407c..2f0dc5a 100644
--- a/fs/isofs/dir.c
+++ b/fs/isofs/dir.c
@@ -145,6 +145,14 @@ static int do_isofs_readdir(struct inode *inode, struct file *filp,
 			}
 			de = tmpde;
 		}
+		/* Basic sanity check, whether name doesn't exceed dir entry */
+		if (de_len < de->name_len[0] +
+					sizeof(struct iso_directory_record)) {
+			printk(KERN_NOTICE "iso9660: Corrupted directory entry"
+			       " in block %lu of inode %lu\n", block,
+			       inode->i_ino);
+			return -EIO;
+		}
 
 		if (first_de) {
 			isofs_normalize_block_and_offset(de,
diff --git a/fs/isofs/namei.c b/fs/isofs/namei.c
index 344b247..8299889 100644
--- a/fs/isofs/namei.c
+++ b/fs/isofs/namei.c
@@ -111,6 +111,13 @@ isofs_find_entry(struct inode *dir, struct dentry *dentry,
 
 		dlen = de->name_len[0];
 		dpnt = de->name;
+		/* Basic sanity check, whether name doesn't exceed dir entry */
+		if (de_len < dlen + sizeof(struct iso_directory_record)) {
+			printk(KERN_NOTICE "iso9660: Corrupted directory entry"
+			       " in block %lu of inode %lu\n", block,
+			       dir->i_ino);
+			return 0;
+		}
 
 		if (sbi->s_rock &&
 		    ((i = get_rock_ridge_filename(de, tmpname, dir)))) {
-- 
1.5.2.4

