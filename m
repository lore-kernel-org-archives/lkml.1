Return-Path: <linux-kernel-owner+w=401wt.eu-S1760217AbZGIHCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217AbZGIHCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 03:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759942AbZGIG7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 02:59:46 -0400
Received: from smtp.nokia.com ([192.100.122.233]:30067 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759905AbZGIG7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 02:59:44 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Jens Axboe <jens.axboe@oracle.com>
Cc: linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 09 Jul 2009 11:50:06 +0300
Message-Id: <20090709085006.12122.73835.sendpatchset@localhost.localdomain>
In-Reply-To: <20090709084822.12122.79749.sendpatchset@localhost.localdomain>
References: <20090709084822.12122.79749.sendpatchset@localhost.localdomain>
Subject: [PATCH v3 15/18] UFS: do not manipulate s_dirt directly
X-OriginalArrivalTime: 09 Jul 2009 06:59:35.0290 (UTC) FILETIME=[D15E65A0:01CA0062]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ufs/balloc.c |    8 ++++----
 fs/ufs/ialloc.c |    4 ++--
 fs/ufs/super.c  |   12 ++++++------
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/ufs/balloc.c b/fs/ufs/balloc.c
index 54c16ec..71a6971 100644
--- a/fs/ufs/balloc.c
+++ b/fs/ufs/balloc.c
@@ -122,7 +122,7 @@ void ufs_free_fragments(struct inode *inode, u64 fragment, unsigned count)
 		ubh_ll_rw_block(SWRITE, UCPI_UBH(ucpi));
 		ubh_wait_on_buffer (UCPI_UBH(ucpi));
 	}
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	
 	unlock_super (sb);
 	UFSD("EXIT\n");
@@ -223,7 +223,7 @@ do_more:
 		goto do_more;
 	}
 
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	unlock_super (sb);
 	UFSD("EXIT\n");
 	return;
@@ -571,7 +571,7 @@ static u64 ufs_add_fragments(struct inode *inode, u64 fragment,
 		ubh_ll_rw_block(SWRITE, UCPI_UBH(ucpi));
 		ubh_wait_on_buffer (UCPI_UBH(ucpi));
 	}
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 
 	UFSD("EXIT, fragment %llu\n", (unsigned long long)fragment);
 	
@@ -698,7 +698,7 @@ succed:
 		ubh_ll_rw_block(SWRITE, UCPI_UBH(ucpi));
 		ubh_wait_on_buffer (UCPI_UBH(ucpi));
 	}
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 
 	result += cgno * uspi->s_fpg;
 	UFSD("EXIT3, result %llu\n", (unsigned long long)result);
diff --git a/fs/ufs/ialloc.c b/fs/ufs/ialloc.c
index 3527c00..b33cfe6 100644
--- a/fs/ufs/ialloc.c
+++ b/fs/ufs/ialloc.c
@@ -124,7 +124,7 @@ void ufs_free_inode (struct inode * inode)
 		ubh_wait_on_buffer (UCPI_UBH(ucpi));
 	}
 	
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	unlock_super (sb);
 	UFSD("EXIT\n");
 }
@@ -300,7 +300,7 @@ cg_found:
 		ubh_ll_rw_block(SWRITE, UCPI_UBH(ucpi));
 		ubh_wait_on_buffer (UCPI_UBH(ucpi));
 	}
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 
 	inode->i_ino = cg * uspi->s_ipg + bit;
 	inode->i_mode = mode;
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 5faed79..6bb1a62 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -237,7 +237,7 @@ void ufs_error (struct super_block * sb, const char * function,
 	if (!(sb->s_flags & MS_RDONLY)) {
 		usb1->fs_clean = UFS_FSBAD;
 		ubh_mark_buffer_dirty(USPI_UBH(uspi));
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 		sb->s_flags |= MS_RDONLY;
 	}
 	va_start (args, fmt);
@@ -270,7 +270,7 @@ void ufs_panic (struct super_block * sb, const char * function,
 	if (!(sb->s_flags & MS_RDONLY)) {
 		usb1->fs_clean = UFS_FSBAD;
 		ubh_mark_buffer_dirty(USPI_UBH(uspi));
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 	}
 	va_start (args, fmt);
 	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
@@ -1149,7 +1149,7 @@ static int ufs_sync_fs(struct super_block *sb, int wait)
 		ufs_set_fs_state(sb, usb1, usb3,
 				UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time));
 	ufs_put_cstotal(sb);
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 
 	UFSD("EXIT\n");
 	unlock_kernel();
@@ -1163,7 +1163,7 @@ static void ufs_write_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY))
 		ufs_sync_fs(sb, 1);
 	else
-		sb->s_dirt = 0;
+		mark_sb_clean(sb);
 }
 
 static void ufs_put_super(struct super_block *sb)
@@ -1172,7 +1172,7 @@ static void ufs_put_super(struct super_block *sb)
 		
 	UFSD("ENTER\n");
 
-	if (sb->s_dirt)
+	if (is_sb_dirty(sb))
 		ufs_write_super(sb);
 
 	if (!(sb->s_flags & MS_RDONLY))
@@ -1242,7 +1242,7 @@ static int ufs_remount (struct super_block *sb, int *mount_flags, char *data)
 			ufs_set_fs_state(sb, usb1, usb3,
 				UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time));
 		ubh_mark_buffer_dirty (USPI_UBH(uspi));
-		sb->s_dirt = 0;
+		mark_sb_clean(sb);
 		sb->s_flags |= MS_RDONLY;
 	} else {
 	/*
-- 
1.6.0.6

