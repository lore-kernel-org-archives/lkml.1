Return-Path: <linux-kernel-owner+w=401wt.eu-S1756966AbZFHT2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbZFHT2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbZFHTXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:23:39 -0400
Received: from thunk.org ([69.25.196.29]:39566 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811AbZFHTXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:18 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 33/49] ext4: Add BUG_ON debugging checks to noalloc_get_block_write()
Date: Mon,  8 Jun 2009 15:22:51 -0400
Message-Id: <1244488987-32564-34-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-33-git-send-email-tytso@mit.edu>
References: <1244488987-32564-1-git-send-email-tytso@mit.edu>
 <1244488987-32564-2-git-send-email-tytso@mit.edu>
 <1244488987-32564-3-git-send-email-tytso@mit.edu>
 <1244488987-32564-4-git-send-email-tytso@mit.edu>
 <1244488987-32564-5-git-send-email-tytso@mit.edu>
 <1244488987-32564-6-git-send-email-tytso@mit.edu>
 <1244488987-32564-7-git-send-email-tytso@mit.edu>
 <1244488987-32564-8-git-send-email-tytso@mit.edu>
 <1244488987-32564-9-git-send-email-tytso@mit.edu>
 <1244488987-32564-10-git-send-email-tytso@mit.edu>
 <1244488987-32564-11-git-send-email-tytso@mit.edu>
 <1244488987-32564-12-git-send-email-tytso@mit.edu>
 <1244488987-32564-13-git-send-email-tytso@mit.edu>
 <1244488987-32564-14-git-send-email-tytso@mit.edu>
 <1244488987-32564-15-git-send-email-tytso@mit.edu>
 <1244488987-32564-16-git-send-email-tytso@mit.edu>
 <1244488987-32564-17-git-send-email-tytso@mit.edu>
 <1244488987-32564-18-git-send-email-tytso@mit.edu>
 <1244488987-32564-19-git-send-email-tytso@mit.edu>
 <1244488987-32564-20-git-send-email-tytso@mit.edu>
 <1244488987-32564-21-git-send-email-tytso@mit.edu>
 <1244488987-32564-22-git-send-email-tytso@mit.edu>
 <1244488987-32564-23-git-send-email-tytso@mit.edu>
 <1244488987-32564-24-git-send-email-tytso@mit.edu>
 <1244488987-32564-25-git-send-email-tytso@mit.edu>
 <1244488987-32564-26-git-send-email-tytso@mit.edu>
 <1244488987-32564-27-git-send-email-tytso@mit.edu>
 <1244488987-32564-28-git-send-email-tytso@mit.edu>
 <1244488987-32564-29-git-send-email-tytso@mit.edu>
 <1244488987-32564-30-git-send-email-tytso@mit.edu>
 <1244488987-32564-31-git-send-email-tytso@mit.edu>
 <1244488987-32564-32-git-send-email-tytso@mit.edu>
 <1244488987-32564-33-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enforce that noalloc_get_block_write() is only called to map one block
at a time, and that it always is successful in finding a mapping for
given an inode's logical block block number if it is called with
create == 1.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index fd5f27a..e6113c3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2433,11 +2433,14 @@ static int noalloc_get_block_write(struct inode *inode, sector_t iblock,
 	int ret = 0;
 	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
 
+	BUG_ON(bh_result->b_size != inode->i_sb->s_blocksize);
+
 	/*
 	 * we don't want to do block allocation in writepage
 	 * so call get_block_wrap with create = 0
 	 */
 	ret = ext4_get_blocks(NULL, inode, iblock, max_blocks, bh_result, 0);
+	BUG_ON(create && ret == 0);
 	if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
 		ret = 0;
-- 
1.6.3.2.1.gb9f7d.dirty

