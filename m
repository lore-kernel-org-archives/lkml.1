Return-Path: <linux-kernel-owner+w=401wt.eu-S1762350AbZLKEvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762350AbZLKEvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761082AbZLKEvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:51:48 -0500
Received: from kroah.org ([198.145.64.141]:36911 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760768AbZLKEgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:12 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:58 2009
Message-Id: <20091211042757.491467570@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [45/90] ext4: EXT4_IOC_MOVE_EXT: Check for different original and donor inodes first
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0045-ext4-EXT4_IOC_MOVE_EXT-Check-for-different-original-.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit f3ce8064b388ccf420012c5a4907aae4f13fe9d0)

Move the check to make sure the original and donor inodes are
different earlier, to avoid a potential deadlock by trying to lock the
same inode twice.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/move_extent.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -1001,14 +1001,6 @@ mext_check_arguments(struct inode *orig_
 		return -EINVAL;
 	}
 
-	/* orig and donor should be different file */
-	if (orig_inode->i_ino == donor_inode->i_ino) {
-		ext4_debug("ext4 move extent: The argument files should not "
-			"be same file [ino:orig %lu, donor %lu]\n",
-			orig_inode->i_ino, donor_inode->i_ino);
-		return -EINVAL;
-	}
-
 	/* Ext4 move extent supports only extent based file */
 	if (!(EXT4_I(orig_inode)->i_flags & EXT4_EXTENTS_FL)) {
 		ext4_debug("ext4 move extent: orig file is not extents "
@@ -1232,6 +1224,14 @@ ext4_move_extents(struct file *o_filp, s
 	int block_len_in_page;
 	int uninit;
 
+	/* orig and donor should be different file */
+	if (orig_inode->i_ino == donor_inode->i_ino) {
+		ext4_debug("ext4 move extent: The argument files should not "
+			"be same file [ino:orig %lu, donor %lu]\n",
+			orig_inode->i_ino, donor_inode->i_ino);
+		return -EINVAL;
+	}
+
 	/* protect orig and donor against a truncate */
 	ret1 = mext_inode_double_lock(orig_inode, donor_inode);
 	if (ret1 < 0)


