Return-Path: <linux-kernel-owner+w=401wt.eu-S1762575AbZLKEnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762575AbZLKEnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:43:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762281AbZLKEgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:36:45 -0500
Received: from kroah.org ([198.145.64.141]:36796 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759483AbZLKEf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:58 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:48 2009
Message-Id: <20091211042747.846949412@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [29/90] ext4: Fix initalization of s_flex_groups
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0029-ext4-Fix-initalization-of-s_flex_groups.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 7ad9bb651fc2036ea94bed94da76a4b08959a911)

The s_flex_groups array should have been initialized using atomic_add
to sum up the free counts from the block groups that make up a
flex_bg.  By using atomic_set, the value of the s_flex_groups array
was set to the values of the last block group in the flex_bg.

The impact of this bug is that the block and inode allocation
algorithms might not pick the best flex_bg for new allocation.

Thanks to Damien Guibouret for pointing out this problem!

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/super.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1696,12 +1696,12 @@ static int ext4_fill_flex_info(struct su
 		gdp = ext4_get_group_desc(sb, i, NULL);
 
 		flex_group = ext4_flex_group(sbi, i);
-		atomic_set(&sbi->s_flex_groups[flex_group].free_inodes,
-			   ext4_free_inodes_count(sb, gdp));
-		atomic_set(&sbi->s_flex_groups[flex_group].free_blocks,
-			   ext4_free_blks_count(sb, gdp));
-		atomic_set(&sbi->s_flex_groups[flex_group].used_dirs,
-			   ext4_used_dirs_count(sb, gdp));
+		atomic_add(ext4_free_inodes_count(sb, gdp),
+			   &sbi->s_flex_groups[flex_group].free_inodes);
+		atomic_add(ext4_free_blks_count(sb, gdp),
+			   &sbi->s_flex_groups[flex_group].free_blocks);
+		atomic_add(ext4_used_dirs_count(sb, gdp),
+			   &sbi->s_flex_groups[flex_group].used_dirs);
 	}
 
 	return 1;


