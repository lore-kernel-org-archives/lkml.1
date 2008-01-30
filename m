Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbYA3PHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbYA3PHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 10:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYA3PHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 10:07:40 -0500
Received: from styx.suse.cz ([82.119.242.94]:47055 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750778AbYA3PHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 10:07:39 -0500
Date: Wed, 30 Jan 2008 16:07:37 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] udf: Compilation fixes
Message-ID: <20080130150737.GE16140@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  the patch below makes UDF compile in -mm kernel (against 2.6.24-rc8-mm1).
Please apply.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

Make UDF compile - fixes fallout from previous cleanup patches.

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.24-rc8-mm1-1-udf_fpos_fix/fs/udf/ialloc.c linux-2.6.24-rc8-mm1-2-udf_add_entry_fix/fs/udf/ialloc.c
--- linux-2.6.24-rc8-mm1-1-udf_fpos_fix/fs/udf/ialloc.c	2008-01-29 19:20:40.000000000 +0100
+++ linux-2.6.24-rc8-mm1-2-udf_add_entry_fix/fs/udf/ialloc.c	2008-01-29 21:44:14.000000000 +0100
@@ -128,37 +128,39 @@ struct inode *udf_new_inode(struct inode
 		inode->i_gid = current->fsgid;
 	}
 
-	UDF_I_LOCATION(inode).logicalBlockNum = block;
-	UDF_I_LOCATION(inode).partitionReferenceNum = UDF_I_LOCATION(dir).partitionReferenceNum;
-	inode->i_ino = udf_get_lb_pblock(sb, UDF_I_LOCATION(inode), 0);
+	iinfo->i_location.logicalBlockNum = block;
+	iinfo->i_location.partitionReferenceNum =
+			dinfo->i_location.partitionReferenceNum;
+	inode->i_ino = udf_get_lb_pblock(sb, iinfo->i_location, 0);
 	if (inode->i_ino == 2094)
 		printk(KERN_ERR "Allocated inode inode 2094\n");
 	inode->i_blocks = 0;
-	UDF_I_LENEATTR(inode) = 0;
-	UDF_I_LENALLOC(inode) = 0;
-	UDF_I_USE(inode) = 0;
+	iinfo->i_lenEAttr = 0;
+	iinfo->i_lenAlloc = 0;
+	iinfo->i_use = 0;
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_EXTENDED_FE)) {
-		UDF_I_EFE(inode) = 1;
-		UDF_UPDATE_UDFREV(inode->i_sb, UDF_VERS_USE_EXTENDED_FE);
-		UDF_I_DATA(inode) = kzalloc(inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry), GFP_KERNEL);
+		iinfo->i_efe = 1;
+		if (UDF_VERS_USE_EXTENDED_FE > sbi->s_udfrev)
+			sbi->s_udfrev = UDF_VERS_USE_EXTENDED_FE;
+		iinfo->i_ext.i_data = kzalloc(inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry), GFP_KERNEL);
 	} else {
-		UDF_I_EFE(inode) = 0;
-		UDF_I_DATA(inode) = kzalloc(inode->i_sb->s_blocksize - sizeof(struct fileEntry), GFP_KERNEL);
+		iinfo->i_efe = 0;
+		iinfo->i_ext.i_data = kzalloc(inode->i_sb->s_blocksize - sizeof(struct fileEntry), GFP_KERNEL);
 	}
-	if (!UDF_I_DATA(inode)) {
+	if (!iinfo->i_ext.i_data) {
 		iput(inode);
 		*err = -ENOMEM;
 		mutex_unlock(&sbi->s_alloc_mutex);
 		return NULL;
 	}
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_AD_IN_ICB))
-		UDF_I_ALLOCTYPE(inode) = ICBTAG_FLAG_AD_IN_ICB;
+		iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
 	else if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
-		UDF_I_ALLOCTYPE(inode) = ICBTAG_FLAG_AD_SHORT;
+		iinfo->i_alloc_type = ICBTAG_FLAG_AD_SHORT;
 	else
-		UDF_I_ALLOCTYPE(inode) = ICBTAG_FLAG_AD_LONG;
+		iinfo->i_alloc_type = ICBTAG_FLAG_AD_LONG;
 	inode->i_mtime = inode->i_atime = inode->i_ctime =
-		UDF_I_CRTIME(inode) = current_fs_time(inode->i_sb);
+		iinfo->i_crtime = current_fs_time(inode->i_sb);
 	insert_inode_hash(inode);
 	mark_inode_dirty(inode);
 	mutex_unlock(&sbi->s_alloc_mutex);
diff -rupX /home/jack/.kerndiffexclude linux-2.6.24-rc8-mm1-1-udf_fpos_fix/include/linux/udf_fs.h linux-2.6.24-rc8-mm1-2-udf_add_entry_fix/include/linux/udf_fs.h
--- linux-2.6.24-rc8-mm1-1-udf_fpos_fix/include/linux/udf_fs.h	2008-01-29 19:20:44.000000000 +0100
+++ linux-2.6.24-rc8-mm1-2-udf_add_entry_fix/include/linux/udf_fs.h	2008-01-29 21:47:08.000000000 +0100
@@ -39,13 +39,13 @@
 
 #ifdef UDFFS_DEBUG
 #define udf_debug(f, a...) \
-	{ \
+	do { \
 		printk (KERN_DEBUG "UDF-fs DEBUG %s:%d:%s: ", \
 			__FILE__, __LINE__, __FUNCTION__); \
 		printk (f, ##a); \
-	}
+	} while (0)
 #else
-#define udf_debug(f, a...) /**/
+#define udf_debug(f, a...) do { } while (0)
 #endif
 
 #define udf_info(f, a...) \
