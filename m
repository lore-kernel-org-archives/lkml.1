Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbYGXAIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbYGXAIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 20:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbYGXAIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 20:08:23 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:43693 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbYGXAIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 20:08:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=QHd/4p2Y0gxdYJbc8zBxm+IWNtwCHYawPkcrxhR1fu9cOUL+wbF2BIZOtxVPC3B7KK
         ntwqVeg8nK9xrw/vzpe/5zeOuPR85ExeV+NUp3io5FOhQLLX0qzgg9bvwDqHlCncRoU/
         fw5qmbD32Duqp2AKhkPjBZD68r8UG+SOvKBB0=
Subject: [PATCH] befs: annotate fs32 on tests for superblock endianness
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "Sergey S. Kostyliov" <rathamahata@php4.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Wed, 23 Jul 2008 17:08:22 -0700
Message-Id: <1216858102.30386.36.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does compile-time byteswapping rather than runtime.

Noticed by sparse:
fs/befs/super.c:29:6: warning: cast to restricted __le32
fs/befs/super.c:29:6: warning: cast from restricted fs32
fs/befs/super.c:31:11: warning: cast to restricted __be32
fs/befs/super.c:31:11: warning: cast from restricted fs32
fs/befs/super.c:31:11: warning: cast to restricted __be32
fs/befs/super.c:31:11: warning: cast from restricted fs32
fs/befs/super.c:31:11: warning: cast to restricted __be32
fs/befs/super.c:31:11: warning: cast from restricted fs32
fs/befs/super.c:31:11: warning: cast to restricted __be32
fs/befs/super.c:31:11: warning: cast from restricted fs32
fs/befs/super.c:31:11: warning: cast to restricted __be32
fs/befs/super.c:31:11: warning: cast from restricted fs32
fs/befs/super.c:31:11: warning: cast to restricted __be32
fs/befs/super.c:31:11: warning: cast from restricted fs32
fs/befs/linuxvfs.c:811:7: warning: cast to restricted __le32
fs/befs/linuxvfs.c:811:7: warning: cast from restricted fs32
fs/befs/linuxvfs.c:812:7: warning: cast to restricted __be32
fs/befs/linuxvfs.c:812:7: warning: cast from restricted fs32
fs/befs/linuxvfs.c:812:7: warning: cast to restricted __be32
fs/befs/linuxvfs.c:812:7: warning: cast from restricted fs32
fs/befs/linuxvfs.c:812:7: warning: cast to restricted __be32
fs/befs/linuxvfs.c:812:7: warning: cast from restricted fs32
fs/befs/linuxvfs.c:812:7: warning: cast to restricted __be32
fs/befs/linuxvfs.c:812:7: warning: cast from restricted fs32
fs/befs/linuxvfs.c:812:7: warning: cast to restricted __be32
fs/befs/linuxvfs.c:812:7: warning: cast from restricted fs32
fs/befs/linuxvfs.c:812:7: warning: cast to restricted __be32
fs/befs/linuxvfs.c:812:7: warning: cast from restricted fs32

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/befs/befs_fs_types.h |    4 ++++
 fs/befs/linuxvfs.c      |    4 ++--
 fs/befs/super.c         |    6 +++---
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/befs/befs_fs_types.h b/fs/befs/befs_fs_types.h
index e2595c2..7893eaa 100644
--- a/fs/befs/befs_fs_types.h
+++ b/fs/befs/befs_fs_types.h
@@ -55,8 +55,12 @@ enum super_flags {
 };
 
 #define BEFS_BYTEORDER_NATIVE 0x42494745
+#define BEFS_BYTEORDER_NATIVE_LE (__force fs32)cpu_to_le32(BEFS_BYTEORDER_NATIVE)
+#define BEFS_BYTEORDER_NATIVE_BE (__force fs32)cpu_to_be32(BEFS_BYTEORDER_NATIVE)
 
 #define BEFS_SUPER_MAGIC BEFS_SUPER_MAGIC1
+#define BEFS_SUPER_MAGIC1_LE (__force fs32)cpu_to_le32(BEFS_SUPER_MAGIC1)
+#define BEFS_SUPER_MAGIC1_BE (__force fs32)cpu_to_be32(BEFS_SUPER_MAGIC1)
 
 /*
  * Flags of inode
diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index e8717de..84b2a4d 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -808,8 +808,8 @@ befs_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* account for offset of super block on x86 */
 	disk_sb = (befs_super_block *) bh->b_data;
-	if ((le32_to_cpu(disk_sb->magic1) == BEFS_SUPER_MAGIC1) ||
-	    (be32_to_cpu(disk_sb->magic1) == BEFS_SUPER_MAGIC1)) {
+	if ((disk_sb->magic1 == BEFS_SUPER_MAGIC1_LE) ||
+	    (disk_sb->magic1 == BEFS_SUPER_MAGIC1_BE)) {
 		befs_debug(sb, "Using PPC superblock location");
 	} else {
 		befs_debug(sb, "Using x86 superblock location");
diff --git a/fs/befs/super.c b/fs/befs/super.c
index 8c3401f..41f2b4d 100644
--- a/fs/befs/super.c
+++ b/fs/befs/super.c
@@ -26,10 +26,10 @@ befs_load_sb(struct super_block *sb, befs_super_block * disk_sb)
 	befs_sb_info *befs_sb = BEFS_SB(sb);
 
 	/* Check the byte order of the filesystem */
-	if (le32_to_cpu(disk_sb->fs_byte_order) == BEFS_BYTEORDER_NATIVE)
+	if (disk_sb->fs_byte_order == BEFS_BYTEORDER_NATIVE_LE)
 	    befs_sb->byte_order = BEFS_BYTESEX_LE;
-	else if (be32_to_cpu(disk_sb->fs_byte_order) == BEFS_BYTEORDER_NATIVE)
-	    befs_sb->byte_order = BEFS_BYTESEX_BE;	
+	else if (disk_sb->fs_byte_order == BEFS_BYTEORDER_NATIVE_BE)
+	    befs_sb->byte_order = BEFS_BYTESEX_BE;
 
 	befs_sb->magic1 = fs32_to_cpu(sb, disk_sb->magic1);
 	befs_sb->magic2 = fs32_to_cpu(sb, disk_sb->magic2);
-- 
1.5.6.4.570.g052e



