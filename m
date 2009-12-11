Return-Path: <linux-kernel-owner+w=401wt.eu-S934268AbZLKEri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934268AbZLKEri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933333AbZLKEqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:46:45 -0500
Received: from kroah.org ([198.145.64.141]:37042 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762122AbZLKEgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:33 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:28:09 2009
Message-Id: <20091211042809.446063479@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [66/90] ext4: dont update the superblock in ext4_statfs()
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0066-ext4-don-t-update-the-superblock-in-ext4_statfs.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 3f8fb9490efbd300887470a2a880a64e04dcc3f5)

commit a71ce8c6c9bf269b192f352ea555217815cf027e updated ext4_statfs()
to update the on-disk superblock counters, but modified this buffer
directly without any journaling of the change.  This is one of the
accesses that was causing the crc errors in journal replay as seen in
kernel.org bugzilla #14354.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/super.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3693,13 +3693,11 @@ static int ext4_statfs(struct dentry *de
 	buf->f_blocks = ext4_blocks_count(es) - sbi->s_overhead_last;
 	buf->f_bfree = percpu_counter_sum_positive(&sbi->s_freeblocks_counter) -
 		       percpu_counter_sum_positive(&sbi->s_dirtyblocks_counter);
-	ext4_free_blocks_count_set(es, buf->f_bfree);
 	buf->f_bavail = buf->f_bfree - ext4_r_blocks_count(es);
 	if (buf->f_bfree < ext4_r_blocks_count(es))
 		buf->f_bavail = 0;
 	buf->f_files = le32_to_cpu(es->s_inodes_count);
 	buf->f_ffree = percpu_counter_sum_positive(&sbi->s_freeinodes_counter);
-	es->s_free_inodes_count = cpu_to_le32(buf->f_ffree);
 	buf->f_namelen = EXT4_NAME_LEN;
 	fsid = le64_to_cpup((void *)es->s_uuid) ^
 	       le64_to_cpup((void *)es->s_uuid + sizeof(u64));


