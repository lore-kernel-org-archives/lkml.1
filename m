Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbYIMPdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbYIMPdo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 11:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbYIMPdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 11:33:18 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:50953 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752768AbYIMPdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 11:33:16 -0400
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@MIT.EDU>,
       Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
       Eugene Teo <eugeneteo@kernel.sg>
Subject: [PATCH 4/4] ext3: Avoid printk floods in the face of directory corruption
Date: Sat, 13 Sep 2008 11:32:51 -0400
Message-Id: <1221319971-29879-4-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.1.205.ge2c7.dirty
In-Reply-To: <1221319971-29879-3-git-send-email-tytso@mit.edu>
References: <1221319971-29879-1-git-send-email-tytso@mit.edu>
 <1221319971-29879-2-git-send-email-tytso@mit.edu>
 <1221319971-29879-3-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: some people thinks this represents a security bug, since it
might make the system go away while it is printing a large number of
console messages, especially if a serial console is involved.  Hence,
it has been assigned CVE-2008-3528, but it requires that the attacker
either has physical access to your machine to insert a USB disk with a
corrupted filesystem image (at which point why not just hit the power
button), or is otherwise able to convince the system administrator to
mount an arbitrary filesystem image (at which point why not just
include a setuid shell or world-writable hard disk device file or some
such).  Me, I think they're just being silly.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Cc: Eugene Teo <eugeneteo@kernel.sg>
---
 fs/ext3/dir.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ext3/dir.c b/fs/ext3/dir.c
index 42c5391..283938a 100644
--- a/fs/ext3/dir.c
+++ b/fs/ext3/dir.c
@@ -102,6 +102,7 @@ static int ext3_readdir(struct file * filp,
 	int err;
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	int ret = 0;
+	int dir_has_error = 0;
 
 	sb = inode->i_sb;
 
@@ -148,9 +149,12 @@ static int ext3_readdir(struct file * filp,
 		 * of recovering data when there's a bad sector
 		 */
 		if (!bh) {
-			ext3_error (sb, "ext3_readdir",
-				"directory #%lu contains a hole at offset %lu",
-				inode->i_ino, (unsigned long)filp->f_pos);
+			if (!dir_has_error) {
+				ext3_error(sb, __func__, "directory #%lu "
+					"contains a hole at offset %lld",
+					inode->i_ino, filp->f_pos);
+				dir_has_error = 1;
+			}
 			/* corrupt size?  Maybe no more blocks to read */
 			if (filp->f_pos > inode->i_blocks << 9)
 				break;
-- 
1.5.6.1.205.ge2c7.dirty

