Return-Path: <linux-kernel-owner+w=401wt.eu-S1764703AbYEFU0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764703AbYEFU0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 16:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbYEFUZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 16:25:52 -0400
Received: from mx1.riseup.net ([204.13.164.18]:44483 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779AbYEFUZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 16:25:51 -0400
Date: Tue, 6 May 2008 22:16:11 +0200
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: zippel@linux-m68k.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] AFFS: Convert s_bmlock in a mutex
Message-ID: <20080506201611.GA27656@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	zippel@linux-m68k.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AFFS: The semaphore s_bmlock is used as a mutex. Convert it to the
mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

--

diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index d5bd497..09c95b3 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -2,6 +2,7 @@
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
 #include <linux/amigaffs.h>
+#include <linux/mutex.h>
 
 /* AmigaOS allows file names with up to 30 characters length.
  * Names longer than that will be silently truncated. If you
@@ -98,7 +99,7 @@ struct affs_sb_info {
 	gid_t s_gid;			/* gid to override */
 	umode_t s_mode;			/* mode to override */
 	struct buffer_head *s_root_bh;	/* Cached root block. */
-	struct semaphore s_bmlock;	/* Protects bitmap access. */
+	struct mutex s_bmlock;		/* Protects bitmap access. */
 	struct affs_bm_info *s_bitmap;	/* Bitmap infos. */
 	u32 s_bmap_count;		/* # of bitmap blocks. */
 	u32 s_bmap_bits;		/* # of bits in one bitmap blocks */
diff --git a/fs/affs/bitmap.c b/fs/affs/bitmap.c
index c4a5ad0..dc5ef14 100644
--- a/fs/affs/bitmap.c
+++ b/fs/affs/bitmap.c
@@ -45,14 +45,14 @@ affs_count_free_blocks(struct super_block *sb)
 	if (sb->s_flags & MS_RDONLY)
 		return 0;
 
-	down(&AFFS_SB(sb)->s_bmlock);
+	mutex_lock(&AFFS_SB(sb)->s_bmlock);
 
 	bm = AFFS_SB(sb)->s_bitmap;
 	free = 0;
 	for (i = AFFS_SB(sb)->s_bmap_count; i > 0; bm++, i--)
 		free += bm->bm_free;
 
-	up(&AFFS_SB(sb)->s_bmlock);
+	mutex_unlock(&AFFS_SB(sb)->s_bmlock);
 
 	return free;
 }
@@ -76,7 +76,7 @@ affs_free_block(struct super_block *sb, u32 block)
 	bit     = blk % sbi->s_bmap_bits;
 	bm      = &sbi->s_bitmap[bmap];
 
-	down(&sbi->s_bmlock);
+	mutex_lock(&sbi->s_bmlock);
 
 	bh = sbi->s_bmap_bh;
 	if (sbi->s_last_bmap != bmap) {
@@ -105,19 +105,19 @@ affs_free_block(struct super_block *sb, u32 block)
 	sb->s_dirt = 1;
 	bm->bm_free++;
 
-	up(&sbi->s_bmlock);
+	mutex_unlock(&sbi->s_bmlock);
 	return;
 
 err_free:
 	affs_warning(sb,"affs_free_block","Trying to free block %u which is already free", block);
-	up(&sbi->s_bmlock);
+	mutex_unlock(&sbi->s_bmlock);
 	return;
 
 err_bh_read:
 	affs_error(sb,"affs_free_block","Cannot read bitmap block %u", bm->bm_key);
 	sbi->s_bmap_bh = NULL;
 	sbi->s_last_bmap = ~0;
-	up(&sbi->s_bmlock);
+	mutex_unlock(&sbi->s_bmlock);
 	return;
 
 err_range:
@@ -168,7 +168,7 @@ affs_alloc_block(struct inode *inode, u32 goal)
 	bmap = blk / sbi->s_bmap_bits;
 	bm = &sbi->s_bitmap[bmap];
 
-	down(&sbi->s_bmlock);
+	mutex_lock(&sbi->s_bmlock);
 
 	if (bm->bm_free)
 		goto find_bmap_bit;
@@ -249,7 +249,7 @@ find_bit:
 	mark_buffer_dirty(bh);
 	sb->s_dirt = 1;
 
-	up(&sbi->s_bmlock);
+	mutex_unlock(&sbi->s_bmlock);
 
 	pr_debug("%d\n", blk);
 	return blk;
@@ -259,7 +259,7 @@ err_bh_read:
 	sbi->s_bmap_bh = NULL;
 	sbi->s_last_bmap = ~0;
 err_full:
-	up(&sbi->s_bmlock);
+	mutex_unlock(&sbi->s_bmlock);
 	pr_debug("failed\n");
 	return 0;
 }
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 01d25d5..ba63080 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -286,7 +286,7 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 	if (!sbi)
 		return -ENOMEM;
 	sb->s_fs_info = sbi;
-	init_MUTEX(&sbi->s_bmlock);
+	mutex_init(&sbi->s_bmlock);
 
 	if (!parse_options(data,&uid,&gid,&i,&reserved,&root_block,
 				&blocksize,&sbi->s_prefix,

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

     Nationalism is an infantile disease. It is the measles of mankind
                         (Albert Einstein)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
