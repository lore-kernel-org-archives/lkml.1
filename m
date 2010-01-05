Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550Ab0AEAgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab0AEAgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540Ab0AEAgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:36:10 -0500
Received: from kroah.org ([198.145.64.141]:42460 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529Ab0AEAgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:36:08 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dmitry Monakhov <dmonakhov@openvz.org>,
       "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 84/97] ext4: fix sleep inside spinlock issue with quota and dealloc (#14739)
Date: Mon,  4 Jan 2010 16:33:37 -0800
Message-Id: <1262651630-7354-84-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Monakhov <dmonakhov@openvz.org>

commit 39bc680a8160bb9d6743f7873b535d553ff61058 upstream.

Unlock i_block_reservation_lock before vfs_dq_reserve_block().
This patch fixes http://bugzilla.kernel.org/show_bug.cgi?id=14739

Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/inode.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9fc624d..f91046e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1858,19 +1858,17 @@ repeat:
 
 	md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
 	total = md_needed + nrblocks;
+	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 
 	/*
 	 * Make quota reservation here to prevent quota overflow
 	 * later. Real quota accounting is done at pages writeout
 	 * time.
 	 */
-	if (vfs_dq_reserve_block(inode, total)) {
-		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+	if (vfs_dq_reserve_block(inode, total))
 		return -EDQUOT;
-	}
 
 	if (ext4_claim_free_blocks(sbi, total)) {
-		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 		vfs_dq_release_reservation_block(inode, total);
 		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
 			yield();
@@ -1878,10 +1876,11 @@ repeat:
 		}
 		return -ENOSPC;
 	}
+	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
-	EXT4_I(inode)->i_reserved_meta_blocks = mdblocks;
-
+	EXT4_I(inode)->i_reserved_meta_blocks += md_needed;
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+
 	return 0;       /* success */
 }
 
-- 
1.6.6

