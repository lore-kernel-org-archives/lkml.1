Return-Path: <linux-kernel-owner+w=401wt.eu-S1752177AbXLEIdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbXLEIdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 03:33:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbXLEIc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 03:32:58 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48691 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbXLEIc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 03:32:57 -0500
Date: Wed, 5 Dec 2007 08:32:52 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>,
       Tigran Aivazian <tigran@veritas.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] regression: bfs endianness bug
Message-ID: <20071205083252.GE8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BFS_FILEBLOCKS() expects struct bfs_inode * (on-disk data, with little-endian
fields), not struct bfs_inode_info * (in-core stuff, with host-endian ones).
It's a macro and fields with the right names are present in bfs_inode_info,
so it compiles, but on big-endian host it gives bogus results.

Introduced in commit f433dc56344cb72cc3de5ba0819021cec3aef807 (Fixes to the
BFS filesystem driver).

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 294c41b..a64a71d 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -178,7 +178,8 @@ static void bfs_delete_inode(struct inode *inode)
 	brelse(bh);
 
         if (bi->i_dsk_ino) {
-		info->si_freeb += BFS_FILEBLOCKS(bi);
+		if (bi->i_sblock)
+			info->si_freeb += bi->i_eblock + 1 - bi->i_sblock;
 		info->si_freei++;
 		clear_bit(ino, info->si_imap);
 		dump_imap("delete_inode", s);
