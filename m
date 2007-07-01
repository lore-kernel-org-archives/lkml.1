Return-Path: <linux-kernel-owner+w=401wt.eu-S1757932AbXGAHkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbXGAHkh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 03:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757116AbXGAHhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 03:37:41 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:36634 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756887AbXGAHhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 03:37:38 -0400
Subject: [EXT4 set 4][PATCH 3/5] i_version:ext4 inode version read/store
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Sun, 01 Jul 2007 03:37:36 -0400
Message-Id: <1183275456.4010.129.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds 64-bit inode version support to ext4. The lower 32 bits
are stored in the osd1.linux1.l_i_version field while the high 32 bits
are stored in the i_version_hi field newly created in the ext4_inode.

Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>

Index: linux-2.6.21/fs/ext4/inode.c
===================================================================
--- linux-2.6.21.orig/fs/ext4/inode.c
+++ linux-2.6.21/fs/ext4/inode.c
@@ -2709,6 +2709,13 @@ void ext4_read_inode(struct inode * inod
 	EXT4_INODE_GET_XTIME(i_atime, inode, raw_inode);
 	EXT4_EINODE_GET_XTIME(i_crtime, ei, raw_inode);

+	inode->i_version = le32_to_cpu(raw_inode->i_disk_version);
+	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE) {
+		if (EXT4_FITS_IN_INODE(raw_inode, ei, i_version_hi))
+			inode->i_version |=
+			(__u64)(le32_to_cpu(raw_inode->i_version_hi)) << 32;
+	}
+
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op = &ext4_file_inode_operations;
 		inode->i_fop = &ext4_file_operations;
@@ -2852,8 +2859,14 @@ static int ext4_do_update_inode(handle_t
 	} else for (block = 0; block < EXT4_N_BLOCKS; block++)
 		raw_inode->i_block[block] = ei->i_data[block];

-	if (ei->i_extra_isize)
+	raw_inode->i_disk_version = cpu_to_le32(inode->i_version);
+	if (ei->i_extra_isize) {
+		if (EXT4_FITS_IN_INODE(raw_inode, ei, i_version_hi)) {
+			raw_inode->i_version_hi =
+				cpu_to_le32(inode->i_version >> 32);
+		}
 		raw_inode->i_extra_isize = cpu_to_le16(ei->i_extra_isize);
+	}

 	BUFFER_TRACE(bh, "call ext4_journal_dirty_metadata");
 	rc = ext4_journal_dirty_metadata(handle, bh);
Index: linux-2.6.21/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.21.orig/include/linux/ext4_fs.h
+++ linux-2.6.21/include/linux/ext4_fs.h
@@ -297,7 +297,7 @@ struct ext4_inode {
 	__le32	i_flags;	/* File flags */
 	union {
 		struct {
-			__u32  l_i_reserved1;
+			__u32  l_i_version;
 		} linux1;
 		struct {
 			__u32  h_i_translator;
@@ -406,6 +406,8 @@ do {									       \
 				       raw_inode->xtime ## _extra);	       \
 } while (0)

+#define i_disk_version osd1.linux1.l_i_version
+
 #if defined(__KERNEL__) || defined(__linux__)
 #define i_reserved1	osd1.linux1.l_i_reserved1
 #define i_frag		osd2.linux2.l_i_frag


