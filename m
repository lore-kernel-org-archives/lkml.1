Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbYJUKvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbYJUKvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 06:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbYJUKvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 06:51:44 -0400
Received: from mail.gmx.net ([213.165.64.20]:42204 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752742AbYJUKvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 06:51:44 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1+KxOtRAGOKFOJP5t0Yw5/rzAoD7kMgpXIlBdMWOW
	pYs8d7PxsbqCbl
Date: Tue, 21 Oct 2008 12:51:42 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: akpm@linux-foundation.org
Cc: tigran@aivazian.fsnet.co.uk, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] bfs: check that filesystem fits on the blockdevice
Message-ID: <20081021105142.GB21885@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.27-rc8 (x86_64)
X-Uptime: 12:50:32 up 3 days,  1:22,  9 users,  load average: 0.12, 0.42,
	0.27
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since all sanity checks rely on the validity of s_start which gets only
checked to be smaller than s_end, we should also check if s_end is sane.
Now we also try to retrieve the last block of the filesystem, which is
computed by s_end. If this fails, something is bogus.

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
Acked-by: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>


--- linux/fs/bfs/inode.c.1	2008-09-17 16:00:06.000000000 +0200
+++ linux/fs/bfs/inode.c	2008-09-17 16:17:54.000000000 +0200
@@ -390,6 +390,18 @@ static int bfs_fill_super(struct super_b
 			- le32_to_cpu(bfs_sb->s_start)) >> BFS_BSIZE_BITS;
 	info->si_freei = 0;
 	info->si_lf_eblk = 0;
+
+	/* can we read the last block? */
+	bh = sb_bread(s, info->si_blocks - 1);
+	if (!bh) {
+		printf("Last block not available: %lu\n", info->si_blocks - 1);
+		iput(inode);
+		ret = -EIO;
+		kfree(info->si_imap);
+		goto out;
+	}
+	brelse(bh);
+
 	bh = NULL;
 	for (i = BFS_ROOT_INO; i <= info->si_lasti; i++) {
 		struct bfs_inode *di;
