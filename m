Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbXKDWJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbXKDWJS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 17:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbXKDWJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 17:09:04 -0500
Received: from mail.parknet.ad.jp ([210.171.162.6]:40818 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbXKDWJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 17:09:03 -0500
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] fat: optimize fat_count_free_clusters()
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Mon, 05 Nov 2007 07:09:00 +0900
Message-ID: <87hck1pssj.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On large partition, scanning the free clusters is very slow if users
doesn't use "usefree" option.

For optimizing it, this patch uses sb_breadahead() to read of FAT
sectors. On some user's 15GB partition, this patch improved it very
much (1min => 600ms).

The following is the result of 2GB partition on my machine.

without patch:
	root@devron (/)# time df -h > /dev/null

	real    0m1.202s
	user    0m0.000s
	sys     0m0.440s

with patch:
	root@devron (/)# time df -h > /dev/null

	real    0m0.378s
	user    0m0.012s
	sys     0m0.168s

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/fatent.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff -puN fs/fat/fatent.c~fat_optimize-count-freeclus fs/fat/fatent.c
--- linux-2.6/fs/fat/fatent.c~fat_optimize-count-freeclus	2007-11-05 06:01:10.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/fatent.c	2007-11-05 06:01:10.000000000 +0900
@@ -590,21 +590,49 @@ error:
 
 EXPORT_SYMBOL_GPL(fat_free_clusters);
 
+/* 128kb is the whole sectors for FAT12 and FAT16 */
+#define FAT_READA_SIZE		(128 * 1024)
+
+static void fat_ent_reada(struct super_block *sb, struct fat_entry *fatent,
+			  unsigned long reada_blocks)
+{
+	struct fatent_operations *ops = MSDOS_SB(sb)->fatent_ops;
+	sector_t blocknr;
+	int i, offset;
+
+	ops->ent_blocknr(sb, fatent->entry, &offset, &blocknr);
+
+	for (i = 0; i < reada_blocks; i++)
+		sb_breadahead(sb, blocknr + i);
+}
+
 int fat_count_free_clusters(struct super_block *sb)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	struct fatent_operations *ops = sbi->fatent_ops;
 	struct fat_entry fatent;
+	unsigned long reada_blocks, reada_mask, cur_block;
 	int err = 0, free;
 
 	lock_fat(sbi);
 	if (sbi->free_clusters != -1)
 		goto out;
 
+	reada_blocks = FAT_READA_SIZE >> sb->s_blocksize_bits;
+	reada_mask = reada_blocks - 1;
+	cur_block = 0;
+
 	free = 0;
 	fatent_init(&fatent);
 	fatent_set_entry(&fatent, FAT_START_ENT);
 	while (fatent.entry < sbi->max_cluster) {
+		/* readahead of fat blocks */
+		if ((cur_block & reada_mask) == 0) {
+			unsigned long rest = sbi->fat_length - cur_block;
+			fat_ent_reada(sb, &fatent, min(reada_blocks, rest));
+		}
+		cur_block++;
+
 		err = fat_ent_read_block(sb, &fatent);
 		if (err)
 			goto out;
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
