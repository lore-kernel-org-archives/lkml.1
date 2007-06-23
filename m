Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbXFWX3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbXFWX3v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 19:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbXFWX3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 19:29:43 -0400
Received: from host-69-39-86-10.a2webhosting.com ([69.39.86.10]:57737 "EHLO
	a2s21.a2hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbXFWX3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 19:29:42 -0400
Message-ID: <467DACCA.7070002@banksresearch.com>
Date: Sat, 23 Jun 2007 19:29:14 -0400
From: Wyatt Banks <wyatt@banksresearch.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: zippel@linux-m68k.org
Subject: [PATCH] HFSPlus: simplify inode mode settting logic
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-A2hosting-MailScanner-Information: Please contact the ISP for more information
X-A2hosting-MailScanner: Found to be clean
X-A2hosting-MailScanner-SpamCheck: 
X-A2hosting-MailScanner-From: wyatt@banksresearch.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - a2s21.a2hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - banksresearch.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Wyatt Banks <wyatt@banksresearch.com>

HFSPlus: Fix broken inode mode setting logic.  Fix broken umask mount option.

Signed-off-by:	Wyatt Banks <wyatt@banksresearch.com>
---
Patched against 2.6.21.5

hfsplus_cat_read_inode() decides if the selected inode is a directory or not.
It then sets the 3rd parameter of hfsplus_get_perms() accordingly.  Inside
hfsplus_get_perms() it again decides based on its 3rd parameter if the inode
is a directory or not.  Besides this redundancy, mode is the BSD file type and mode
bits (see Apple TechNote 1150 for details) and is never 0.  This makes a large
portion of the branching logic unused.  What actually does happen in the branching
is that the UGO mode bits are combined with the directory or regular file bit after
the 2nd decision and this resultant mode is assigned to the inode.  This also loses
suid, sgid, sticky, pipe, fifo, etc.

This patch also fixes the umask mount option as a result.  I figured instead of
filing a bug report, I'd just go ahead and fix it. :-)

diff -uprN -X linux-2.6.21.5/Documentation/dontdiff linux-2.6.21.5/fs/hfsplus/inode.c linux-2.6.21.5-devel/fs/hfsplus/inode.c
--- linux-2.6.21.5/fs/hfsplus/inode.c	2007-06-11 14:37:06.000000000 -0400
+++ linux-2.6.21.5-devel/fs/hfsplus/inode.c	2007-06-23 18:23:57.000000000 -0400
@@ -173,7 +173,7 @@ out:
	return NULL;
 }

-static void hfsplus_get_perms(struct inode *inode, struct hfsplus_perm *perms, int dir)
+static void hfsplus_get_perms(struct inode *inode, struct hfsplus_perm *perms)
 {
	struct super_block *sb = inode->i_sb;
	u16 mode;
@@ -188,14 +188,7 @@ static void hfsplus_get_perms(struct ino
	if (!inode->i_gid && !mode)
		inode->i_gid = HFSPLUS_SB(sb).gid;

-	if (dir) {
-		mode = mode ? (mode & S_IALLUGO) :
-			(S_IRWXUGO & ~(HFSPLUS_SB(sb).umask));
-		mode |= S_IFDIR;
-	} else if (!mode)
-		mode = S_IFREG | ((S_IRUGO|S_IWUGO) &
-			~(HFSPLUS_SB(sb).umask));
-	inode->i_mode = mode;
+	inode->i_mode = mode & ~(HFSPLUS_SB(sb).umask);

	HFSPLUS_I(inode).rootflags = perms->rootflags;
	HFSPLUS_I(inode).userflags = perms->userflags;
@@ -415,7 +408,7 @@ int hfsplus_cat_read_inode(struct inode
			/* panic? */;
		hfs_bnode_read(fd->bnode, &entry, fd->entryoffset,
					sizeof(struct hfsplus_cat_folder));
-		hfsplus_get_perms(inode, &folder->permissions, 1);
+		hfsplus_get_perms(inode, &folder->permissions);
		inode->i_nlink = 1;
		inode->i_size = 2 + be32_to_cpu(folder->valence);
		inode->i_atime = hfsp_mt2ut(folder->access_date);
@@ -435,7 +428,7 @@ int hfsplus_cat_read_inode(struct inode

		hfsplus_inode_read_fork(inode, HFSPLUS_IS_DATA(inode) ?
					&file->data_fork : &file->rsrc_fork);
-		hfsplus_get_perms(inode, &file->permissions, 0);
+		hfsplus_get_perms(inode, &file->permissions);
		inode->i_nlink = 1;
		if (S_ISREG(inode->i_mode)) {
			if (file->permissions.dev)
