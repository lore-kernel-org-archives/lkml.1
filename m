Return-Path: <linux-kernel-owner+w=401wt.eu-S1762487AbZLKEjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762487AbZLKEjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:39:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762342AbZLKEhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:37:24 -0500
Received: from kroah.org ([198.145.64.141]:37031 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762178AbZLKEge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:34 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:28:11 2009
Message-Id: <20091211042810.591847517@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [68/90] ext4: fix block validity checks so they work correctly with meta_bg
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0068-ext4-fix-block-validity-checks-so-they-work-correctl.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 1032988c71f3f85483b2b4319684d1205a704c02)

The block validity checks used by ext4_data_block_valid() wasn't
correctly written to check file systems with the meta_bg feature.  Fix
this.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/block_validity.c |    2 +-
 fs/ext4/inode.c          |    5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -160,7 +160,7 @@ int ext4_setup_system_zone(struct super_
 		if (ext4_bg_has_super(sb, i) &&
 		    ((i < 5) || ((i % flex_size) == 0)))
 			add_system_zone(sbi, ext4_group_first_block_no(sb, i),
-					sbi->s_gdb_count + 1);
+					ext4_bg_num_gdb(sb, i) + 1);
 		gdp = ext4_get_group_desc(sb, i, NULL);
 		ret = add_system_zone(sbi, ext4_block_bitmap(sb, gdp), 1);
 		if (ret)
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4873,10 +4873,7 @@ struct inode *ext4_iget(struct super_blo
 
 	ret = 0;
 	if (ei->i_file_acl &&
-	    ((ei->i_file_acl <
-	      (le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block) +
-	       EXT4_SB(sb)->s_gdb_count)) ||
-	     (ei->i_file_acl >= ext4_blocks_count(EXT4_SB(sb)->s_es)))) {
+	    !ext4_data_block_valid(EXT4_SB(sb), ei->i_file_acl, 1)) {
 		ext4_error(sb, __func__,
 			   "bad extended attribute block %llu in inode #%lu",
 			   ei->i_file_acl, inode->i_ino);


