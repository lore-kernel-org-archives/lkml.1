Return-Path: <linux-kernel-owner+w=401wt.eu-S1758855AbZLKEfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855AbZLKEfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbZLKEfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:35:34 -0500
Received: from kroah.org ([198.145.64.141]:52833 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917AbZLKEfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:33 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:25 2009
Message-Id: <20091211042724.642198428@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:24:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [01/90] ext4: Fix memory leak fix when mounting an ext4 filesystem
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0001-ext4-Fix-memory-leak-fix-when-mounting-an-ext4-files.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 024eab4d5bf7e3168a2b71038b3e04e6b1f376ed)

The allocation of the ext4_group_info array was moved to a new
function ext4_mb_add_group_info() in commit 5f21b0e6 so that online
resize would use a common (and correct) codepath.  Unfortunately, the
call to the new ext4_mb_add_group_info() function was added without
removing the code which originally allocated the array.  This caused a
memory leak each time an ext4 filesystem was mounted.

The fix is simple; remove the code that did the original allocation,
since it is no longer needed.

Reported-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/mballoc.c |   19 -------------------
 1 file changed, 19 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2571,13 +2571,11 @@ static int ext4_mb_init_backend(struct s
 {
 	ext4_group_t ngroups = ext4_get_groups_count(sb);
 	ext4_group_t i;
-	int metalen;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
 	int num_meta_group_infos;
 	int num_meta_group_infos_max;
 	int array_size;
-	struct ext4_group_info **meta_group_info;
 	struct ext4_group_desc *desc;
 
 	/* This is the number of blocks used by GDT */
@@ -2622,22 +2620,6 @@ static int ext4_mb_init_backend(struct s
 		goto err_freesgi;
 	}
 	EXT4_I(sbi->s_buddy_cache)->i_disksize = 0;
-
-	metalen = sizeof(*meta_group_info) << EXT4_DESC_PER_BLOCK_BITS(sb);
-	for (i = 0; i < num_meta_group_infos; i++) {
-		if ((i + 1) == num_meta_group_infos)
-			metalen = sizeof(*meta_group_info) *
-				(ngroups -
-					(i << EXT4_DESC_PER_BLOCK_BITS(sb)));
-		meta_group_info = kmalloc(metalen, GFP_KERNEL);
-		if (meta_group_info == NULL) {
-			printk(KERN_ERR "EXT4-fs: can't allocate mem for a "
-			       "buddy group\n");
-			goto err_freemeta;
-		}
-		sbi->s_group_info[i] = meta_group_info;
-	}
-
 	for (i = 0; i < ngroups; i++) {
 		desc = ext4_get_group_desc(sb, i, NULL);
 		if (desc == NULL) {
@@ -2655,7 +2637,6 @@ err_freebuddy:
 	while (i-- > 0)
 		kfree(ext4_get_group_info(sb, i));
 	i = num_meta_group_infos;
-err_freemeta:
 	while (i-- > 0)
 		kfree(sbi->s_group_info[i]);
 	iput(sbi->s_buddy_cache);


