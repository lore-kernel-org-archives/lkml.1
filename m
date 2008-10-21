Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbYJUKuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbYJUKuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 06:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbYJUKuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 06:50:32 -0400
Received: from mail.gmx.net ([213.165.64.20]:56719 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752584AbYJUKub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 06:50:31 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1+vTCo5Y5OvcCMAjbNk6AQ8G9KTJfGi4P6i/UHnoh
	bDQMnMiX9DDM9I
Date: Tue, 21 Oct 2008 12:50:23 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: akpm@linux-foundation.org
Cc: tigran@aivazian.fsnet.co.uk, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] bfs: add some basic sanity checks
Message-ID: <20081021105023.GA21885@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.27-rc8 (x86_64)
X-Uptime: 12:47:48 up 3 days,  1:19,  9 users,  load average: 1.60, 0.68,
	0.32
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bfs_fill_super() already touches all inodes, so we can easily add some
cheap sanity checks and check if the inode start and end blocks are
smaller than the maximum number of blocks, the inode start
block lies behind the end block or the file end offset is behind the end
of the filesystem. Also check if the start of data offset
in the super block fits the filesystem.

The added sanity checks catch softlockup issues early when we try to
sb_bread() lots of blocks in a loop in bfs_readdir() and
bfs_find_entry(). In addition an oom issue in bfs_fill_super() is
prevented by this when s_start is corrupted, which influences imap_len
and we try to allocate a huge info->si_imap.

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
Acked-by: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>


--- linux/fs/bfs/inode.c.orig	2008-09-16 16:41:17.000000000 +0200
+++ linux/fs/bfs/inode.c	2008-09-17 15:17:10.000000000 +0200
@@ -213,6 +213,9 @@ static void bfs_put_super(struct super_b
 {
 	struct bfs_sb_info *info = BFS_SB(s);
 
+	if (!info)
+		return;
+
 	brelse(info->si_sbh);
 	mutex_destroy(&info->bfs_lock);
 	kfree(info->si_imap);
@@ -327,6 +330,7 @@ static int bfs_fill_super(struct super_b
 	unsigned i, imap_len;
 	struct bfs_sb_info *info;
 	long ret = -EINVAL;
+	unsigned long i_sblock, i_eblock, i_eoff, s_size;
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
@@ -350,6 +354,12 @@ static int bfs_fill_super(struct super_b
 
 	s->s_magic = BFS_MAGIC;
 	info->si_sbh = bh;
+
+	if (le32_to_cpu(bfs_sb->s_start) > le32_to_cpu(bfs_sb->s_end)) {
+		printf("Superblock is corrupted\n");
+		goto out;
+	}
+
 	info->si_lasti = (le32_to_cpu(bfs_sb->s_start) - BFS_BSIZE) /
 					sizeof(struct bfs_inode)
 					+ BFS_ROOT_INO - 1;
@@ -397,6 +407,29 @@ static int bfs_fill_super(struct super_b
 
 		di = (struct bfs_inode *)bh->b_data + off;
 
+		/* test if filesystem is not corrupted */
+
+		i_eoff = le32_to_cpu(di->i_eoffset);
+		i_sblock = le32_to_cpu(di->i_sblock);
+		i_eblock = le32_to_cpu(di->i_eblock);
+		s_size = le32_to_cpu(bfs_sb->s_end);
+
+		if (i_sblock > info->si_blocks ||
+			i_eblock > info->si_blocks ||
+			i_sblock > i_eblock ||
+			i_eoff > s_size ||
+			i_sblock * BFS_BSIZE > i_eoff) {
+
+			printf("Inode 0x%08x corrupted\n", i);
+
+			brelse(bh);
+			s->s_root = NULL;
+			kfree(info->si_imap);
+			kfree(info);
+			s->s_fs_info = NULL;
+			return -EIO;
+		}
+
 		if (!di->i_ino) {
 			info->si_freei++;
 			continue;
