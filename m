Return-Path: <linux-kernel-owner+w=401wt.eu-S1757946AbZFHTcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbZFHTcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbZFHTXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:23:54 -0400
Received: from thunk.org ([69.25.196.29]:39609 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755073AbZFHTXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:22 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 24/49] ext4: fix for fiemap last-block test
Date: Mon,  8 Jun 2009 15:22:42 -0400
Message-Id: <1244488987-32564-25-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-24-git-send-email-tytso@mit.edu>
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
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

Carl Henrik Lunde reported and debugged this; the test for the
last allocated block was comparing bytes to blocks in this test:

	if (logical + length - 1 == EXT_MAX_BLOCK ||
	    ext4_ext_next_allocated_block(path) == EXT_MAX_BLOCK)
		flags |= FIEMAP_EXTENT_LAST;

so any extent which ended right at 4G was stopping the extent
walk.  Just replacing these values with the extent block &
length should fix it.

Also give blksize_bits a saner type, and reverse the order
of the tests to make the more likely case tested first.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reported-by: Carl Henrik Lunde <chlunde@ping.uio.no>
Tested-by: Carl Henrik Lunde <chlunde@ping.uio.no>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ea5c476..5f72952 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3196,7 +3196,7 @@ static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
 		       void *data)
 {
 	struct fiemap_extent_info *fieinfo = data;
-	unsigned long blksize_bits = inode->i_sb->s_blocksize_bits;
+	unsigned char blksize_bits = inode->i_sb->s_blocksize_bits;
 	__u64	logical;
 	__u64	physical;
 	__u64	length;
@@ -3243,8 +3243,8 @@ static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
 	 *
 	 * XXX this might miss a single-block extent at EXT_MAX_BLOCK
 	 */
-	if (logical + length - 1 == EXT_MAX_BLOCK ||
-	    ext4_ext_next_allocated_block(path) == EXT_MAX_BLOCK)
+	if (ext4_ext_next_allocated_block(path) == EXT_MAX_BLOCK ||
+	    newex->ec_block + newex->ec_len - 1 == EXT_MAX_BLOCK)
 		flags |= FIEMAP_EXTENT_LAST;
 
 	error = fiemap_fill_next_extent(fieinfo, logical, physical,
-- 
1.6.3.2.1.gb9f7d.dirty

