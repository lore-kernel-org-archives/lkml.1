Return-Path: <linux-kernel-owner+w=401wt.eu-S1761733AbYAVDKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761733AbYAVDKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755057AbYAVDFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:05:39 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:65372 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759062AbYAVDFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:05:35 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 31/49] ext4: Take read lock during overwrite case.
Date: Mon, 21 Jan 2008 22:02:10 -0500
Message-Id: <1200970948-17903-32-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-31-git-send-email-tytso@mit.edu>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
 <1200970948-17903-2-git-send-email-tytso@mit.edu>
 <1200970948-17903-3-git-send-email-tytso@mit.edu>
 <1200970948-17903-4-git-send-email-tytso@mit.edu>
 <1200970948-17903-5-git-send-email-tytso@mit.edu>
 <1200970948-17903-6-git-send-email-tytso@mit.edu>
 <1200970948-17903-7-git-send-email-tytso@mit.edu>
 <1200970948-17903-8-git-send-email-tytso@mit.edu>
 <1200970948-17903-9-git-send-email-tytso@mit.edu>
 <1200970948-17903-10-git-send-email-tytso@mit.edu>
 <1200970948-17903-11-git-send-email-tytso@mit.edu>
 <1200970948-17903-12-git-send-email-tytso@mit.edu>
 <1200970948-17903-13-git-send-email-tytso@mit.edu>
 <1200970948-17903-14-git-send-email-tytso@mit.edu>
 <1200970948-17903-15-git-send-email-tytso@mit.edu>
 <1200970948-17903-16-git-send-email-tytso@mit.edu>
 <1200970948-17903-17-git-send-email-tytso@mit.edu>
 <1200970948-17903-18-git-send-email-tytso@mit.edu>
 <1200970948-17903-19-git-send-email-tytso@mit.edu>
 <1200970948-17903-20-git-send-email-tytso@mit.edu>
 <1200970948-17903-21-git-send-email-tytso@mit.edu>
 <1200970948-17903-22-git-send-email-tytso@mit.edu>
 <1200970948-17903-23-git-send-email-tytso@mit.edu>
 <1200970948-17903-24-git-send-email-tytso@mit.edu>
 <1200970948-17903-25-git-send-email-tytso@mit.edu>
 <1200970948-17903-26-git-send-email-tytso@mit.edu>
 <1200970948-17903-27-git-send-email-tytso@mit.edu>
 <1200970948-17903-28-git-send-email-tytso@mit.edu>
 <1200970948-17903-29-git-send-email-tytso@mit.edu>
 <1200970948-17903-30-git-send-email-tytso@mit.edu>
 <1200970948-17903-31-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

When we are overwriting a file and not actually allocating new file system
blocks we need to take only the read lock on i_data_sem.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |   32 ++++++++++++++++++++++++--------
 1 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 596b3ab..ee0bc3a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -901,11 +901,31 @@ int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 			int create, int extend_disksize)
 {
 	int retval;
-	if (create) {
-		down_write((&EXT4_I(inode)->i_data_sem));
+	/*
+	 * Try to see if we can get  the block without requesting
+	 * for new file system block.
+	 */
+	down_read((&EXT4_I(inode)->i_data_sem));
+	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
+		retval =  ext4_ext_get_blocks(handle, inode, block, max_blocks,
+				bh, 0, 0);
 	} else {
-		down_read((&EXT4_I(inode)->i_data_sem));
+		retval = ext4_get_blocks_handle(handle,
+				inode, block, max_blocks, bh, 0, 0);
 	}
+	up_read((&EXT4_I(inode)->i_data_sem));
+	if (!create || (retval > 0))
+		return retval;
+
+	/*
+	 * We need to allocate new blocks which will result
+	 * in i_data update
+	 */
+	down_write((&EXT4_I(inode)->i_data_sem));
+	/*
+	 * We need to check for EXT4 here because migrate
+	 * could have changed the inode type in between
+	 */
 	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
 		retval =  ext4_ext_get_blocks(handle, inode, block, max_blocks,
 				bh, create, extend_disksize);
@@ -913,11 +933,7 @@ int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 		retval = ext4_get_blocks_handle(handle, inode, block,
 				max_blocks, bh, create, extend_disksize);
 	}
-	if (create) {
-		up_write((&EXT4_I(inode)->i_data_sem));
-	} else {
-		up_read((&EXT4_I(inode)->i_data_sem));
-	}
+	up_write((&EXT4_I(inode)->i_data_sem));
 	return retval;
 }
 static int ext4_get_block(struct inode *inode, sector_t iblock,
-- 
1.5.4.rc3.31.g1271-dirty

