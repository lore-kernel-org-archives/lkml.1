Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987AbZFHT2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbZFHT2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbZFHTXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:23:38 -0400
Received: from thunk.org ([69.25.196.29]:39567 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060AbZFHTXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:18 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 37/49] ext4: down i_data_sem only for read when walking tree for fiemap
Date: Mon,  8 Jun 2009 15:22:55 -0400
Message-Id: <1244488987-32564-38-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-37-git-send-email-tytso@mit.edu>
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
 <1244488987-32564-34-git-send-email-tytso@mit.edu>
 <1244488987-32564-35-git-send-email-tytso@mit.edu>
 <1244488987-32564-36-git-send-email-tytso@mit.edu>
 <1244488987-32564-37-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure why I put this in as down_write originally; all we are
doing is walking the tree, nothing will change under us and
concurrent reads should be no problem.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index d04b779..d4e99e9 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3312,10 +3312,10 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		 * Walk the extent tree gathering extent information.
 		 * ext4_ext_fiemap_cb will push extents back to user.
 		 */
-		down_write(&EXT4_I(inode)->i_data_sem);
+		down_read(&EXT4_I(inode)->i_data_sem);
 		error = ext4_ext_walk_space(inode, start_blk, len_blks,
 					  ext4_ext_fiemap_cb, fieinfo);
-		up_write(&EXT4_I(inode)->i_data_sem);
+		up_read(&EXT4_I(inode)->i_data_sem);
 	}
 
 	return error;
-- 
1.6.3.2.1.gb9f7d.dirty

