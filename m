Return-Path: <linux-kernel-owner+w=401wt.eu-S1758991AbXEWNTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991AbXEWNTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 09:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbXEWNTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 09:19:47 -0400
Received: from mabruk.micah.cowan.name ([66.150.225.51]:54286 "EHLO
	mabruk.micah.cowan.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbXEWNTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 09:19:46 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 May 2007 09:19:46 EDT
From: Micah Cowan <micah@cowan.name>
To: linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk
Date: Sat, 19 May 2007 17:19:35 -0700
Subject: [PATCH] Only send SIGXFSZ when exceeding rlimits.
Message-Id: <20070523131305.37DA53C98102@mabruk.micah.cowan.name>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some users have been having problems with utilities like cp or dd
dumping core when they try to copy a file that's too large for the
destination filesystem (typically, > 4gb). Apparently, some defunct
standards required SIGXFSZ to be sent in such circumstances, but SUS
only requires/allows it for when a written file exceeds the process's
resource limits. I'd like to limit SIGXFSZs to the bare minimum required
by SUS.

Patch sent per http://lkml.org/lkml/2007/4/10/302

Signed-off-by: Micah Cowan <micahcowan@ubuntu.com>
---
 fs/ncpfs/file.c    |    2 --
 fs/reiserfs/file.c |    1 -
 mm/filemap.c       |    2 --
 3 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/ncpfs/file.c b/fs/ncpfs/file.c
index addfd31..65b5802 100644
--- a/fs/ncpfs/file.c
+++ b/fs/ncpfs/file.c
@@ -202,7 +202,6 @@ ncp_file_write(struct file *file, const char __user *buf, size_t count, loff_t *
 
 	if (pos + count > MAX_NON_LFS && !(file->f_flags&O_LARGEFILE)) {
 		if (pos >= MAX_NON_LFS) {
-			send_sig(SIGXFSZ, current, 0);
 			return -EFBIG;
 		}
 		if (count > MAX_NON_LFS - (u32)pos) {
@@ -211,7 +210,6 @@ ncp_file_write(struct file *file, const char __user *buf, size_t count, loff_t *
 	}
 	if (pos >= inode->i_sb->s_maxbytes) {
 		if (count || pos > inode->i_sb->s_maxbytes) {
-			send_sig(SIGXFSZ, current, 0);
 			return -EFBIG;
 		}
 	}
diff --git a/fs/reiserfs/file.c b/fs/reiserfs/file.c
index 9e451a6..465cde1 100644
--- a/fs/reiserfs/file.c
+++ b/fs/reiserfs/file.c
@@ -1305,7 +1305,6 @@ static ssize_t reiserfs_file_write(struct file *file,	/* the file we are going t
 	if (get_inode_item_key_version (inode) == KEY_FORMAT_3_5 &&
 	    *ppos + count > MAX_NON_LFS) {
 		if (*ppos >= MAX_NON_LFS) {
-			send_sig(SIGXFSZ, current, 0);
 			return -EFBIG;
 		}
 		if (count > MAX_NON_LFS - (unsigned long)*ppos)
diff --git a/mm/filemap.c b/mm/filemap.c
index edb1b0b..01b577a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1985,7 +1985,6 @@ inline int generic_write_checks(struct file *file, loff_t *pos, size_t *count, i
 	if (unlikely(*pos + *count > MAX_NON_LFS &&
 				!(file->f_flags & O_LARGEFILE))) {
 		if (*pos >= MAX_NON_LFS) {
-			send_sig(SIGXFSZ, current, 0);
 			return -EFBIG;
 		}
 		if (*count > MAX_NON_LFS - (unsigned long)*pos) {
@@ -2003,7 +2002,6 @@ inline int generic_write_checks(struct file *file, loff_t *pos, size_t *count, i
 	if (likely(!isblk)) {
 		if (unlikely(*pos >= inode->i_sb->s_maxbytes)) {
 			if (*count || *pos > inode->i_sb->s_maxbytes) {
-				send_sig(SIGXFSZ, current, 0);
 				return -EFBIG;
 			}
 			/* zero-length writes at ->s_maxbytes are OK */
-- 
1.4.4.2

