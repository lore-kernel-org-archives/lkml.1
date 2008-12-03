Return-Path: <linux-kernel-owner+w=401wt.eu-S1758544AbYLCUZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544AbYLCUZB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:25:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756105AbYLCT55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:57:57 -0500
Received: from kroah.org ([198.145.64.141]:56634 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751662AbYLCT5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:57:50 -0500
Date: Wed, 3 Dec 2008 11:56:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Frederic Bohe <frederic.bohe@bull.net>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: [patch 086/104] ext4: fix initialization of UNINIT bitmap blocks
Message-ID: <20081203195618.GI8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ext4-fix-initialization-of-uninit-bitmap-blocks.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Frederic Bohe <frederic.bohe@bull.net>

(cherry picked from commit c806e68f5647109350ec546fee5b526962970fd2)

This fixes a bug which caused on-line resizing of filesystems with a
1k blocksize to fail.  The root cause of this bug was the fact that if
an uninitalized bitmap block gets read in by userspace (which
e2fsprogs does try to avoid, but can happen when the blocksize is less
than the pagesize and an adjacent blocks is read into memory)
ext4_read_block_bitmap() was erroneously depending on the buffer
uptodate flag to decide whether it needed to initialize the bitmap
block in memory --- i.e., to set the standard set of blocks in use by
a block group (superblock, bitmaps, inode table, etc.).  Essentially,
ext4_read_block_bitmap() assumed it was the only routine that might
try to read a block containing a block bitmap, which is simply not
true.

To fix this, ext4_read_block_bitmap() and ext4_read_inode_bitmap()
must always initialize uninitialized bitmap blocks.  Once a block or
inode is allocated out of that bitmap, it will be marked as
initialized in the block group descriptor, so in general this won't
result any extra unnecessary work.

Signed-off-by: Frederic Bohe <frederic.bohe@bull.net>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/balloc.c  |    4 +++-
 fs/ext4/ialloc.c  |    4 +++-
 fs/ext4/mballoc.c |    4 +++-
 3 files changed, 9 insertions(+), 3 deletions(-)

--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -318,9 +318,11 @@ ext4_read_block_bitmap(struct super_bloc
 			    block_group, bitmap_blk);
 		return NULL;
 	}
-	if (bh_uptodate_or_lock(bh))
+	if (buffer_uptodate(bh) &&
+	    !(desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)))
 		return bh;
 
+	lock_buffer(bh);
 	spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
 	if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
 		ext4_init_block_bitmap(sb, bh, block_group, desc);
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -115,9 +115,11 @@ ext4_read_inode_bitmap(struct super_bloc
 			    block_group, bitmap_blk);
 		return NULL;
 	}
-	if (bh_uptodate_or_lock(bh))
+	if (buffer_uptodate(bh) &&
+	    !(desc->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)))
 		return bh;
 
+	lock_buffer(bh);
 	spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
 	if (desc->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
 		ext4_init_inode_bitmap(sb, bh, block_group, desc);
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -784,9 +784,11 @@ static int ext4_mb_init_cache(struct pag
 		if (bh[i] == NULL)
 			goto out;
 
-		if (bh_uptodate_or_lock(bh[i]))
+		if (buffer_uptodate(bh[i]) &&
+		    !(desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)))
 			continue;
 
+		lock_buffer(bh[i]);
 		spin_lock(sb_bgl_lock(EXT4_SB(sb), first_group + i));
 		if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
 			ext4_init_block_bitmap(sb, bh[i],

