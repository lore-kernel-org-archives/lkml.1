Return-Path: <linux-kernel-owner+w=401wt.eu-S1758647AbZFDIwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647AbZFDIwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757490AbZFDItg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:49:36 -0400
Received: from smtp.nokia.com ([192.100.105.134]:19412 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757376AbZFDItZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:49:25 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Evgeniy Dushistov <dushistov@mail.ru>
Subject: [PATCH v2 15/17] UFS: do not manipulate s_dirt directly
Date: Thu,  4 Jun 2009 13:41:52 +0300
Message-Id: <1244112114-23144-16-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1244112114-23144-1-git-send-email-dedekind@infradead.org>
References: <1244112114-23144-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 04 Jun 2009 08:48:44.0002 (UTC) FILETIME=[443F4C20:01C9E4F1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
---
 fs/ufs/balloc.c |    8 ++++----
 fs/ufs/ialloc.c |    4 ++--
 fs/ufs/super.c  |   10 +++++-----
 3 files changed, 11 insertions(+), 11 deletions(-)

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
index c97210e..0316f83 100644
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
@@ -269,7 +269,7 @@ void ufs_panic (struct super_block * sb, const char * function,
 	if (!(sb->s_flags & MS_RDONLY)) {
 		usb1->fs_clean = UFS_FSBAD;
 		ubh_mark_buffer_dirty(USPI_UBH(uspi));
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 	}
 	va_start (args, fmt);
 	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
@@ -1148,7 +1148,7 @@ static void ufs_write_super(struct super_block *sb)
 					UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time));
 		ufs_put_cstotal(sb);
 	}
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 	UFSD("EXIT\n");
 	unlock_kernel();
 	unlock_super(sb);
@@ -1160,7 +1160,7 @@ static void ufs_put_super(struct super_block *sb)
 		
 	UFSD("ENTER\n");
 
-	if (sb->s_dirt)
+	if (sb_is_dirty(sb))
 		ufs_write_super(sb);
 
 	if (!(sb->s_flags & MS_RDONLY))
@@ -1226,7 +1226,7 @@ static int ufs_remount (struct super_block *sb, int *mount_flags, char *data)
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

