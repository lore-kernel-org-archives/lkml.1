Return-Path: <linux-kernel-owner+w=401wt.eu-S934100AbZLKEqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934100AbZLKEqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762086AbZLKEgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:36:32 -0500
Received: from kroah.org ([198.145.64.141]:36745 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759519AbZLKEfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:50 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:40 2009
Message-Id: <20091211042739.750528035@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:24:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [21/90] ext4: print more sysadmin-friendly message in check_block_validity()
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0021-ext4-print-more-sysadmin-friendly-message-in-check_b.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 80e42468d65475e92651e62175bb7807773321d0)

Drop the WARN_ON(1), as he stack trace is not appropriate, since it is
triggered by file system corruption, and it misleads users into
thinking there is a kernel bug.  In addition, change the message
displayed by ext4_error() to make it clear that this is a file system
corruption problem.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/inode.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1122,16 +1122,15 @@ static void ext4_da_update_reserve_space
 		ext4_discard_preallocations(inode);
 }
 
-static int check_block_validity(struct inode *inode, sector_t logical,
-				sector_t phys, int len)
+static int check_block_validity(struct inode *inode, const char *msg,
+				sector_t logical, sector_t phys, int len)
 {
 	if (!ext4_data_block_valid(EXT4_SB(inode->i_sb), phys, len)) {
-		ext4_error(inode->i_sb, "check_block_validity",
+		ext4_error(inode->i_sb, msg,
 			   "inode #%lu logical block %llu mapped to %llu "
 			   "(size %d)", inode->i_ino,
 			   (unsigned long long) logical,
 			   (unsigned long long) phys, len);
-		WARN_ON(1);
 		return -EIO;
 	}
 	return 0;
@@ -1183,8 +1182,8 @@ int ext4_get_blocks(handle_t *handle, st
 	up_read((&EXT4_I(inode)->i_data_sem));
 
 	if (retval > 0 && buffer_mapped(bh)) {
-		int ret = check_block_validity(inode, block,
-					       bh->b_blocknr, retval);
+		int ret = check_block_validity(inode, "file system corruption",
+					       block, bh->b_blocknr, retval);
 		if (ret != 0)
 			return ret;
 	}
@@ -1265,8 +1264,9 @@ int ext4_get_blocks(handle_t *handle, st
 
 	up_write((&EXT4_I(inode)->i_data_sem));
 	if (retval > 0 && buffer_mapped(bh)) {
-		int ret = check_block_validity(inode, block,
-					       bh->b_blocknr, retval);
+		int ret = check_block_validity(inode, "file system "
+					       "corruption after allocation",
+					       block, bh->b_blocknr, retval);
 		if (ret != 0)
 			return ret;
 	}


