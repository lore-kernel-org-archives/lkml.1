Return-Path: <linux-kernel-owner+w=401wt.eu-S1756474AbYKPEiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbYKPEiz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 23:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbYKPEhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 23:37:31 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50303 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753810AbYKPEh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 23:37:29 -0500
Message-ID: <491FA2C0.7030501@cn.fujitsu.com>
Date: Sun, 16 Nov 2008 12:34:08 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/7] udf: use simple_malloc()/simple_free()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


use simple_malloc()/simple_free() instead of current codes.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/fs/udf/super.c b/fs/udf/super.c
index e25e701..165ca64 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1069,10 +1069,7 @@ static struct udf_bitmap *udf_sb_alloc_bitmap(struct super_block *sb, u32 index)
 	size = sizeof(struct udf_bitmap) +
 		(sizeof(struct buffer_head *) * nr_groups);
 
-	if (size <= PAGE_SIZE)
-		bitmap = kmalloc(size, GFP_KERNEL);
-	else
-		bitmap = vmalloc(size); /* TODO: get rid of vmalloc */
+	bitmap = simple_malloc(size);
 
 	if (bitmap == NULL) {
 		udf_error(sb, __func__,
@@ -1801,17 +1798,12 @@ static void udf_sb_free_bitmap(struct udf_bitmap *bitmap)
 {
 	int i;
 	int nr_groups = bitmap->s_nr_groups;
-	int size = sizeof(struct udf_bitmap) + (sizeof(struct buffer_head *) *
-						nr_groups);
 
 	for (i = 0; i < nr_groups; i++)
 		if (bitmap->s_block_bitmap[i])
 			brelse(bitmap->s_block_bitmap[i]);
 
-	if (size <= PAGE_SIZE)
-		kfree(bitmap);
-	else
-		vfree(bitmap);
+	simple_free(bitmap);
 }
 
 static void udf_free_partition(struct udf_part_map *map)


