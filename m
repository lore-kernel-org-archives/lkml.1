Return-Path: <linux-kernel-owner+w=401wt.eu-S1760689AbZLPFsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760689AbZLPFsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 00:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760192AbZLPFsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 00:48:19 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:34841 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758240AbZLPFsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 00:48:18 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] fatfs-2.6 patches
Date: Wed, 16 Dec 2009 14:48:13 +0900
Message-ID: <87pr6fv59e.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This adds "discard" option to enable discard stuff, and disable it by
default instead. Since one patch, the patch was attached for review.

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/hirofumi/fatfs-2.6.git master

to get these changes:

Christoph Hellwig (1):
      fat: make discard a mount option

 fs/fat/fat.h    |    3 ++-
 fs/fat/fatent.c |   25 +++++++++++++++----------
 fs/fat/inode.c  |    8 +++++++-
 3 files changed, 24 insertions(+), 12 deletions(-)

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Subject: [PATCH] fat: make discard a mount option

Currently shipping discard capable SSDs and arrays have rather sub-optimal
implementations of the command and can the use of it can cause massive
slowdowns.  Make issueing these commands option as it's already in btrfs
and gfs2.

Signed-off-by: Christoph Hellwig <hch@lst.de>
[hirofumi@mail.parknet.co.jp: tweaks, and add "discard" to fat_show_options]
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---
 fs/fat/fat.h    |    3 ++-
 fs/fat/fatent.c |   25 +++++++++++++++----------
 fs/fat/inode.c  |    8 +++++++-
 3 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 7db0979..e6efdfa 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -44,7 +44,8 @@ struct fat_mount_options {
 		 nocase:1,	  /* Does this need case conversion? 0=need case conversion*/
 		 usefree:1,	  /* Use free_clusters for FAT32 */
 		 tz_utc:1,	  /* Filesystem timestamps are in UTC */
-		 rodir:1;	  /* allow ATTR_RO for directory */
+		 rodir:1,	  /* allow ATTR_RO for directory */
+		 discard:1;	  /* Issue discard requests on deletions */
 };
 
 #define FAT_HASH_BITS	8
diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index a810377..81184d3 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -566,16 +566,21 @@ int fat_free_clusters(struct inode *inode, int cluster)
 			goto error;
 		}
 
-		/* 
-		 * Issue discard for the sectors we no longer care about,
-		 * batching contiguous clusters into one request
-		 */
-		if (cluster != fatent.entry + 1) {
-			int nr_clus = fatent.entry - first_cl + 1;
-
-			sb_issue_discard(sb, fat_clus_to_blknr(sbi, first_cl),
-					 nr_clus * sbi->sec_per_clus);
-			first_cl = cluster;
+		if (sbi->options.discard) {
+			/*
+			 * Issue discard for the sectors we no longer
+			 * care about, batching contiguous clusters
+			 * into one request
+			 */
+			if (cluster != fatent.entry + 1) {
+				int nr_clus = fatent.entry - first_cl + 1;
+
+				sb_issue_discard(sb,
+					fat_clus_to_blknr(sbi, first_cl),
+					nr_clus * sbi->sec_per_clus);
+
+				first_cl = cluster;
+			}
 		}
 
 		ops->ent_put(&fatent, FAT_ENT_FREE);
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 76b7961..14da530 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -858,6 +858,8 @@ static int fat_show_options(struct seq_file *m, struct vfsmount *mnt)
 		seq_puts(m, ",errors=panic");
 	else
 		seq_puts(m, ",errors=remount-ro");
+	if (opts->discard)
+		seq_puts(m, ",discard");
 
 	return 0;
 }
@@ -871,7 +873,7 @@ enum {
 	Opt_shortname_winnt, Opt_shortname_mixed, Opt_utf8_no, Opt_utf8_yes,
 	Opt_uni_xl_no, Opt_uni_xl_yes, Opt_nonumtail_no, Opt_nonumtail_yes,
 	Opt_obsolate, Opt_flush, Opt_tz_utc, Opt_rodir, Opt_err_cont,
-	Opt_err_panic, Opt_err_ro, Opt_err,
+	Opt_err_panic, Opt_err_ro, Opt_discard, Opt_err,
 };
 
 static const match_table_t fat_tokens = {
@@ -899,6 +901,7 @@ static const match_table_t fat_tokens = {
 	{Opt_err_cont, "errors=continue"},
 	{Opt_err_panic, "errors=panic"},
 	{Opt_err_ro, "errors=remount-ro"},
+	{Opt_discard, "discard"},
 	{Opt_obsolate, "conv=binary"},
 	{Opt_obsolate, "conv=text"},
 	{Opt_obsolate, "conv=auto"},
@@ -1136,6 +1139,9 @@ static int parse_options(char *options, int is_vfat, int silent, int *debug,
 		case Opt_rodir:
 			opts->rodir = 1;
 			break;
+		case Opt_discard:
+			opts->discard = 1;
+			break;
 
 		/* obsolete mount options */
 		case Opt_obsolate:
-- 
1.6.5.6.dirty

