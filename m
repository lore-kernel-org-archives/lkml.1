Return-Path: <linux-kernel-owner+w=401wt.eu-S1755633AbZLKFdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbZLKFdl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 00:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755896AbZLKFdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 00:33:37 -0500
Received: from kroah.org ([198.145.64.141]:53523 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791AbZLKF34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 00:29:56 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 21:25:50 2009
Message-Id: <20091211052550.441771142@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 21:23:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Sandeen <sandeen@redhat.com>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [19/34] ext4: make trim/discard optional (and off by default)
References: <20091211052312.805428372@linux.site>
Content-Disposition: inline; filename=0015-ext4-make-trim-discard-optional-and-off-by-default.patch
In-Reply-To: <20091211052858.GA23229@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

(cherry picked from commit 5328e635315734d42080de9a5a1ee87bf4cae0a4)

It is anticipated that when sb_issue_discard starts doing
real work on trim-capable devices, we may see issues.  Make
this mount-time optional, and default it to off until we know
that things are working out OK.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/filesystems/ext4.txt |    6 ++++++
 fs/ext4/ext4.h                     |    1 +
 fs/ext4/mballoc.c                  |   21 +++++++++++++--------
 fs/ext4/super.c                    |   14 +++++++++++++-
 4 files changed, 33 insertions(+), 9 deletions(-)

--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -353,6 +353,12 @@ noauto_da_alloc		replacing existing file
 			system crashes before the delayed allocation
 			blocks are forced to disk.
 
+discard		Controls whether ext4 should issue discard/TRIM
+nodiscard(*)		commands to the underlying block device when
+			blocks are freed.  This is useful for SSD devices
+			and sparse/thinly-provisioned LUNs, but it is off
+			by default until sufficient testing has been done.
+
 Data Mode
 =========
 There are 3 different data modes:
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -750,6 +750,7 @@ struct ext4_inode_info {
 #define EXT4_MOUNT_DELALLOC		0x8000000 /* Delalloc support */
 #define EXT4_MOUNT_DATA_ERR_ABORT	0x10000000 /* Abort on file data write */
 #define EXT4_MOUNT_BLOCK_VALIDITY	0x20000000 /* Block validity checking */
+#define EXT4_MOUNT_DISCARD		0x40000000 /* Issue DISCARD requests */
 
 #define clear_opt(o, opt)		o &= ~EXT4_MOUNT_##opt
 #define set_opt(o, opt)			o |= EXT4_MOUNT_##opt
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2529,7 +2529,6 @@ static void release_blocks_on_commit(jou
 	struct ext4_group_info *db;
 	int err, count = 0, count2 = 0;
 	struct ext4_free_data *entry;
-	ext4_fsblk_t discard_block;
 	struct list_head *l, *ltmp;
 
 	list_for_each_safe(l, ltmp, &txn->t_private_list) {
@@ -2559,13 +2558,19 @@ static void release_blocks_on_commit(jou
 			page_cache_release(e4b.bd_bitmap_page);
 		}
 		ext4_unlock_group(sb, entry->group);
-		discard_block = (ext4_fsblk_t) entry->group * EXT4_BLOCKS_PER_GROUP(sb)
-			+ entry->start_blk
-			+ le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
-		trace_ext4_discard_blocks(sb, (unsigned long long)discard_block,
-					  entry->count);
-		sb_issue_discard(sb, discard_block, entry->count);
-
+		if (test_opt(sb, DISCARD)) {
+			ext4_fsblk_t discard_block;
+			struct ext4_super_block *es = EXT4_SB(sb)->s_es;
+
+			discard_block = (ext4_fsblk_t)entry->group *
+						EXT4_BLOCKS_PER_GROUP(sb)
+					+ entry->start_blk
+					+ le32_to_cpu(es->s_first_data_block);
+			trace_ext4_discard_blocks(sb,
+					(unsigned long long)discard_block,
+					entry->count);
+			sb_issue_discard(sb, discard_block, entry->count);
+		}
 		kmem_cache_free(ext4_free_ext_cachep, entry);
 		ext4_mb_release_desc(&e4b);
 	}
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -899,6 +899,9 @@ static int ext4_show_options(struct seq_
 	if (test_opt(sb, NO_AUTO_DA_ALLOC))
 		seq_puts(seq, ",noauto_da_alloc");
 
+	if (test_opt(sb, DISCARD))
+		seq_puts(seq, ",discard");
+
 	ext4_show_quota_options(seq, sb);
 
 	return 0;
@@ -1079,7 +1082,8 @@ enum {
 	Opt_usrquota, Opt_grpquota, Opt_i_version,
 	Opt_stripe, Opt_delalloc, Opt_nodelalloc,
 	Opt_block_validity, Opt_noblock_validity,
-	Opt_inode_readahead_blks, Opt_journal_ioprio
+	Opt_inode_readahead_blks, Opt_journal_ioprio,
+	Opt_discard, Opt_nodiscard,
 };
 
 static const match_table_t tokens = {
@@ -1144,6 +1148,8 @@ static const match_table_t tokens = {
 	{Opt_auto_da_alloc, "auto_da_alloc=%u"},
 	{Opt_auto_da_alloc, "auto_da_alloc"},
 	{Opt_noauto_da_alloc, "noauto_da_alloc"},
+	{Opt_discard, "discard"},
+	{Opt_nodiscard, "nodiscard"},
 	{Opt_err, NULL},
 };
 
@@ -1565,6 +1571,12 @@ set_qf_format:
 			else
 				set_opt(sbi->s_mount_opt,NO_AUTO_DA_ALLOC);
 			break;
+		case Opt_discard:
+			set_opt(sbi->s_mount_opt, DISCARD);
+			break;
+		case Opt_nodiscard:
+			clear_opt(sbi->s_mount_opt, DISCARD);
+			break;
 		default:
 			ext4_msg(sb, KERN_ERR,
 			       "Unrecognized mount option \"%s\" "


