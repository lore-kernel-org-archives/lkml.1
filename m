Return-Path: <linux-kernel-owner+w=401wt.eu-S1761981AbYAVDLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761981AbYAVDLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758112AbYAVDGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:06:08 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:65372 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756642AbYAVDGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:06:05 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 21/49] ext4: fix oops on corrupted ext4 mount
Date: Mon, 21 Jan 2008 22:02:00 -0500
Message-Id: <1200970948-17903-22-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-21-git-send-email-tytso@mit.edu>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
 <1200970948-17903-2-git-send-email-tytso@mit.edu>
 <1200970948-17903-3-git-send-email-tytso@mit.edu>
 <1200970948-17903-4-git-send-email-tytso@mit.edu>
 <1200970948-17903-5-git-send-email-tytso@mit.edu>
 <1200970948-17903-6-git-send-email-tytso@mit.edu>
 <1200970948-17903-7-git-send-email-tytso@mit.edu>
 <1200970948-17903-8-git-send-email-tytso@mit.edu>
 <1200970948-17903-9-git-send-email-tytso@mit.edu>
 <1200970948-17903-10-git-send-email-tytso@mit.edu>
 <1200970948-17903-11-git-send-email-tytso@mit.edu>
 <1200970948-17903-12-git-send-email-tytso@mit.edu>
 <1200970948-17903-13-git-send-email-tytso@mit.edu>
 <1200970948-17903-14-git-send-email-tytso@mit.edu>
 <1200970948-17903-15-git-send-email-tytso@mit.edu>
 <1200970948-17903-16-git-send-email-tytso@mit.edu>
 <1200970948-17903-17-git-send-email-tytso@mit.edu>
 <1200970948-17903-18-git-send-email-tytso@mit.edu>
 <1200970948-17903-19-git-send-email-tytso@mit.edu>
 <1200970948-17903-20-git-send-email-tytso@mit.edu>
 <1200970948-17903-21-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

When mounting an ext4 filesystem with corrupted s_first_data_block, things
can go very wrong and oops.

Because blocks_count in ext4_fill_super is a u64, and we must use do_div,
the calculation of db_count is done differently than on ext4.  If
first_data_block is corrupted such that it is larger than ext4_blocks_count,
for example, then the intermediate blocks_count value may go negative,
but sign-extend to a very large value:

        blocks_count = (ext4_blocks_count(es) -
                        le32_to_cpu(es->s_first_data_block) +
                        EXT4_BLOCKS_PER_GROUP(sb) - 1);

This is then assigned to s_groups_count which is an unsigned long:

        sbi->s_groups_count = blocks_count;

This may result in a value of 0xFFFFFFFF which is then used to compute
db_count:

        db_count = (sbi->s_groups_count + EXT4_DESC_PER_BLOCK(sb) - 1) /
                   EXT4_DESC_PER_BLOCK(sb);

and in this case db_count will wind up as 0 because the addition overflows
32 bits.  This in turn causes the kmalloc for group_desc to be of 0 size:

        sbi->s_group_desc = kmalloc(db_count * sizeof (struct buffer_head *),
                                    GFP_KERNEL);

and eventually in ext4_check_descriptors, dereferencing
sbi->s_group_desc[desc_block] will result in a NULL pointer dereference.

The simplest test seems to be to sanity check s_first_data_block,
EXT4_BLOCKS_PER_GROUP, and ext4_blocks_count values to be sure
their combination won't result in a bad intermediate value for
blocks_count.  We could just check for db_count == 0, but
catching it at the root cause seems like it provides more info.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/super.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 1484a08..32e3ecb 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1997,6 +1997,17 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 
 	if (EXT4_BLOCKS_PER_GROUP(sb) == 0)
 		goto cantfind_ext4;
+
+	/* ensure blocks_count calculation below doesn't sign-extend */
+	if (ext4_blocks_count(es) + EXT4_BLOCKS_PER_GROUP(sb) <
+	    le32_to_cpu(es->s_first_data_block) + 1) {
+		printk(KERN_WARNING "EXT4-fs: bad geometry: block count %llu, "
+		       "first data block %u, blocks per group %lu\n",
+			ext4_blocks_count(es),
+			le32_to_cpu(es->s_first_data_block),
+			EXT4_BLOCKS_PER_GROUP(sb));
+		goto failed_mount;
+	}
 	blocks_count = (ext4_blocks_count(es) -
 			le32_to_cpu(es->s_first_data_block) +
 			EXT4_BLOCKS_PER_GROUP(sb) - 1);
-- 
1.5.4.rc3.31.g1271-dirty

