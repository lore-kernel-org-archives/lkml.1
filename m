Return-Path: <linux-kernel-owner+w=401wt.eu-S934225AbZLKEw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934225AbZLKEw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762312AbZLKEw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:52:28 -0500
Received: from kroah.org ([198.145.64.141]:36883 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756310AbZLKEgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:09 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:55 2009
Message-Id: <20091211042755.220900196@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mingming Cao <cmm@us.ibm.com>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [41/90] ext4: release reserved quota when block reservation for delalloc retry
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0041-ext4-release-reserved-quota-when-block-reservation-f.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 9f0ccfd8e07d61b413e6536ffa02fbf60d2e20d8)

ext4_da_reserve_space() can reserve quota blocks multiple times if
ext4_claim_free_blocks() fail and we retry the allocation. We should
release the quota reservation before restarting.

Bug found by Jan Kara.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1855,11 +1855,11 @@ repeat:
 
 	if (ext4_claim_free_blocks(sbi, total)) {
 		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+		vfs_dq_release_reservation_block(inode, total);
 		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
 			yield();
 			goto repeat;
 		}
-		vfs_dq_release_reservation_block(inode, total);
 		return -ENOSPC;
 	}
 	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;


