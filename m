Return-Path: <linux-kernel-owner+w=401wt.eu-S1756313AbZASRZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313AbZASRZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:25:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbZASRZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:25:16 -0500
Received: from mx1.suse.de ([195.135.220.2]:59552 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755314AbZASRZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:25:14 -0500
Message-ID: <4974B8E7.6010105@suse.de>
Date: Tue, 20 Jan 2009 01:31:19 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.19 (X11/20090106)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/20] fs/adfs: return f_fsid for statfs(2)
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes adfs return f_fsid info for statfs(2), and does a little variable renaming in
adfs_statfs().

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/adfs/super.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/adfs/super.c b/fs/adfs/super.c
index 7f83a46..dd9becc 100644
--- a/fs/adfs/super.c
+++ b/fs/adfs/super.c
@@ -219,16 +219,20 @@ static int adfs_remount(struct super_block *sb, int *flags, char *data)

 static int adfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
-	struct adfs_sb_info *asb = ADFS_SB(dentry->d_sb);
+	struct super_block *sb = dentry->d_sb;
+	struct adfs_sb_info *sbi = ADFS_SB(sb);
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);

 	buf->f_type    = ADFS_SUPER_MAGIC;
-	buf->f_namelen = asb->s_namelen;
-	buf->f_bsize   = dentry->d_sb->s_blocksize;
-	buf->f_blocks  = asb->s_size;
-	buf->f_files   = asb->s_ids_per_zone * asb->s_map_size;
+	buf->f_namelen = sbi->s_namelen;
+	buf->f_bsize   = sb->s_blocksize;
+	buf->f_blocks  = sbi->s_size;
+	buf->f_files   = sbi->s_ids_per_zone * sbi->s_map_size;
 	buf->f_bavail  =
-	buf->f_bfree   = adfs_map_free(dentry->d_sb);
+	buf->f_bfree   = adfs_map_free(sb);
 	buf->f_ffree   = (long)(buf->f_bfree * buf->f_files) / (long)buf->f_blocks;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);

 	return 0;
 }

-- 
Coly Li
SuSE Labs



