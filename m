Return-Path: <linux-kernel-owner+w=401wt.eu-S937951AbXGNBi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937951AbXGNBi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 21:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934981AbXGNBfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 21:35:15 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:58563 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765640AbXGNBfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 21:35:11 -0400
Subject: [PATCH] ext2 statfs improvement for block and inode free count
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger@clusterfs.com>,
       lkml <linux-kernel@vger.kernel.org>, ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 13 Jul 2007 18:36:54 -0700
Message-Id: <1184377014.15968.14.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Can you include it in -mm ? 

BTW, this patch is against mainline, won't apply cleanly to -mm, due to
other statfs() improvements.

Thanks,
Badari

More statfs() improvements for ext2. ext2 already maintains
percpu counters for free blocks and inodes. Derive free
block count and inode count by summing up percpu counters,
instead of counting up all the groups in the filesystem
each time.


Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Acked-by: Andreas Dilger <adilger@clusterfs.com>

 fs/ext2/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.22/fs/ext2/super.c
===================================================================
--- linux-2.6.22.orig/fs/ext2/super.c	2007-07-13 20:06:38.000000000 -0700
+++ linux-2.6.22/fs/ext2/super.c	2007-07-13 20:06:51.000000000 -0700
@@ -1136,12 +1136,12 @@ static int ext2_statfs (struct dentry * 
 	buf->f_type = EXT2_SUPER_MAGIC;
 	buf->f_bsize = sb->s_blocksize;
 	buf->f_blocks = le32_to_cpu(es->s_blocks_count) - overhead;
-	buf->f_bfree = ext2_count_free_blocks(sb);
+ 	buf->f_bfree = percpu_counter_sum(&sbi->s_freeblocks_counter);
 	buf->f_bavail = buf->f_bfree - le32_to_cpu(es->s_r_blocks_count);
 	if (buf->f_bfree < le32_to_cpu(es->s_r_blocks_count))
 		buf->f_bavail = 0;
 	buf->f_files = le32_to_cpu(es->s_inodes_count);
-	buf->f_ffree = ext2_count_free_inodes(sb);
+ 	buf->f_ffree = percpu_counter_sum(&sbi->s_freeinodes_counter);
 	buf->f_namelen = EXT2_NAME_LEN;
 	fsid = le64_to_cpup((void *)es->s_uuid) ^
 	       le64_to_cpup((void *)es->s_uuid + sizeof(u64));


