Return-Path: <linux-kernel-owner+w=401wt.eu-S1760005AbZASRbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005AbZASRbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:31:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758716AbZASR2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:28:51 -0500
Received: from cantor.suse.de ([195.135.220.2]:59701 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758708AbZASR2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:28:50 -0500
Message-ID: <4974B9C0.40602@suse.de>
Date: Tue, 20 Jan 2009 01:34:56 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.19 (X11/20090106)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 12/20] fs/minix: return f_fsid for statfs(2)
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes minix file system return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/minix/inode.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index d1d1eb8..f6f23b6 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -321,15 +321,20 @@ out:

 static int minix_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
-	struct minix_sb_info *sbi = minix_sb(dentry->d_sb);
-	buf->f_type = dentry->d_sb->s_magic;
-	buf->f_bsize = dentry->d_sb->s_blocksize;
+	struct super_block *sb = dentry->d_sb;
+	struct minix_sb_info *sbi = minix_sb(sb);
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
+	buf->f_type = sb->s_magic;
+	buf->f_bsize = sb->s_blocksize;
 	buf->f_blocks = (sbi->s_nzones - sbi->s_firstdatazone) << sbi->s_log_zone_size;
 	buf->f_bfree = minix_count_free_blocks(sbi);
 	buf->f_bavail = buf->f_bfree;
 	buf->f_files = sbi->s_ninodes;
 	buf->f_ffree = minix_count_free_inodes(sbi);
 	buf->f_namelen = sbi->s_namelen;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
+
 	return 0;
 }

-- 
Coly Li
SuSE Labs



