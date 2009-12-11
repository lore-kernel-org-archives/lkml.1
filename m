Return-Path: <linux-kernel-owner+w=401wt.eu-S933536AbZLKEpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933536AbZLKEpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:45:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762211AbZLKEgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:36:39 -0500
Received: from kroah.org ([198.145.64.141]:36772 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758935AbZLKEfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:54 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:44 2009
Message-Id: <20091211042742.991422660@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [25/90] ext4: move ext4_mb_init_group() function earlier in the mballoc.c
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0025-ext4-move-ext4_mb_init_group-function-earlier-in-the.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit b6a758ec3af3ec236dbfdcf6a06b84ac8f94957e)

This moves the function around so that it can be called from
ext4_mb_load_buddy().

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/mballoc.c |  182 +++++++++++++++++++++++++++---------------------------
 1 file changed, 91 insertions(+), 91 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -908,6 +908,97 @@ out:
 	return err;
 }
 
+static noinline_for_stack
+int ext4_mb_init_group(struct super_block *sb, ext4_group_t group)
+{
+
+	int ret = 0;
+	void *bitmap;
+	int blocks_per_page;
+	int block, pnum, poff;
+	int num_grp_locked = 0;
+	struct ext4_group_info *this_grp;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct inode *inode = sbi->s_buddy_cache;
+	struct page *page = NULL, *bitmap_page = NULL;
+
+	mb_debug("init group %lu\n", group);
+	blocks_per_page = PAGE_CACHE_SIZE / sb->s_blocksize;
+	this_grp = ext4_get_group_info(sb, group);
+	/*
+	 * This ensures we don't add group
+	 * to this buddy cache via resize
+	 */
+	num_grp_locked =  ext4_mb_get_buddy_cache_lock(sb, group);
+	if (!EXT4_MB_GRP_NEED_INIT(this_grp)) {
+		/*
+		 * somebody initialized the group
+		 * return without doing anything
+		 */
+		ret = 0;
+		goto err;
+	}
+	/*
+	 * the buddy cache inode stores the block bitmap
+	 * and buddy information in consecutive blocks.
+	 * So for each group we need two blocks.
+	 */
+	block = group * 2;
+	pnum = block / blocks_per_page;
+	poff = block % blocks_per_page;
+	page = find_or_create_page(inode->i_mapping, pnum, GFP_NOFS);
+	if (page) {
+		BUG_ON(page->mapping != inode->i_mapping);
+		ret = ext4_mb_init_cache(page, NULL);
+		if (ret) {
+			unlock_page(page);
+			goto err;
+		}
+		unlock_page(page);
+	}
+	if (page == NULL || !PageUptodate(page)) {
+		ret = -EIO;
+		goto err;
+	}
+	mark_page_accessed(page);
+	bitmap_page = page;
+	bitmap = page_address(page) + (poff * sb->s_blocksize);
+
+	/* init buddy cache */
+	block++;
+	pnum = block / blocks_per_page;
+	poff = block % blocks_per_page;
+	page = find_or_create_page(inode->i_mapping, pnum, GFP_NOFS);
+	if (page == bitmap_page) {
+		/*
+		 * If both the bitmap and buddy are in
+		 * the same page we don't need to force
+		 * init the buddy
+		 */
+		unlock_page(page);
+	} else if (page) {
+		BUG_ON(page->mapping != inode->i_mapping);
+		ret = ext4_mb_init_cache(page, bitmap);
+		if (ret) {
+			unlock_page(page);
+			goto err;
+		}
+		unlock_page(page);
+	}
+	if (page == NULL || !PageUptodate(page)) {
+		ret = -EIO;
+		goto err;
+	}
+	mark_page_accessed(page);
+err:
+	ext4_mb_put_buddy_cache_lock(sb, group, num_grp_locked);
+	if (bitmap_page)
+		page_cache_release(bitmap_page);
+	if (page)
+		page_cache_release(page);
+	return ret;
+}
+
 static noinline_for_stack int
 ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
 					struct ext4_buddy *e4b)
@@ -1837,97 +1928,6 @@ void ext4_mb_put_buddy_cache_lock(struct
 
 }
 
-static noinline_for_stack
-int ext4_mb_init_group(struct super_block *sb, ext4_group_t group)
-{
-
-	int ret;
-	void *bitmap;
-	int blocks_per_page;
-	int block, pnum, poff;
-	int num_grp_locked = 0;
-	struct ext4_group_info *this_grp;
-	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	struct inode *inode = sbi->s_buddy_cache;
-	struct page *page = NULL, *bitmap_page = NULL;
-
-	mb_debug("init group %lu\n", group);
-	blocks_per_page = PAGE_CACHE_SIZE / sb->s_blocksize;
-	this_grp = ext4_get_group_info(sb, group);
-	/*
-	 * This ensures we don't add group
-	 * to this buddy cache via resize
-	 */
-	num_grp_locked =  ext4_mb_get_buddy_cache_lock(sb, group);
-	if (!EXT4_MB_GRP_NEED_INIT(this_grp)) {
-		/*
-		 * somebody initialized the group
-		 * return without doing anything
-		 */
-		ret = 0;
-		goto err;
-	}
-	/*
-	 * the buddy cache inode stores the block bitmap
-	 * and buddy information in consecutive blocks.
-	 * So for each group we need two blocks.
-	 */
-	block = group * 2;
-	pnum = block / blocks_per_page;
-	poff = block % blocks_per_page;
-	page = find_or_create_page(inode->i_mapping, pnum, GFP_NOFS);
-	if (page) {
-		BUG_ON(page->mapping != inode->i_mapping);
-		ret = ext4_mb_init_cache(page, NULL);
-		if (ret) {
-			unlock_page(page);
-			goto err;
-		}
-		unlock_page(page);
-	}
-	if (page == NULL || !PageUptodate(page)) {
-		ret = -EIO;
-		goto err;
-	}
-	mark_page_accessed(page);
-	bitmap_page = page;
-	bitmap = page_address(page) + (poff * sb->s_blocksize);
-
-	/* init buddy cache */
-	block++;
-	pnum = block / blocks_per_page;
-	poff = block % blocks_per_page;
-	page = find_or_create_page(inode->i_mapping, pnum, GFP_NOFS);
-	if (page == bitmap_page) {
-		/*
-		 * If both the bitmap and buddy are in
-		 * the same page we don't need to force
-		 * init the buddy
-		 */
-		unlock_page(page);
-	} else if (page) {
-		BUG_ON(page->mapping != inode->i_mapping);
-		ret = ext4_mb_init_cache(page, bitmap);
-		if (ret) {
-			unlock_page(page);
-			goto err;
-		}
-		unlock_page(page);
-	}
-	if (page == NULL || !PageUptodate(page)) {
-		ret = -EIO;
-		goto err;
-	}
-	mark_page_accessed(page);
-err:
-	ext4_mb_put_buddy_cache_lock(sb, group, num_grp_locked);
-	if (bitmap_page)
-		page_cache_release(bitmap_page);
-	if (page)
-		page_cache_release(page);
-	return ret;
-}
-
 static noinline_for_stack int
 ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 {


