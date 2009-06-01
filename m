Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbZFAOhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbZFAOhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 10:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbZFAOgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 10:36:37 -0400
Received: from smtp.nokia.com ([192.100.122.233]:39328 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583AbZFAOgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 10:36:36 -0400
From: Denis Karpov <ext-denis.2.karpov@nokia.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] EXT2: add 'notify' mount option
Date: Mon,  1 Jun 2009 17:34:51 +0300
Message-Id: <8213eac54e8a06906f37f9f048a89912330eeefc.1243863850.git.ext-denis.2.karpov@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <48030b162e63c73026f767111411e1ec4bf2719d.1243863850.git.ext-denis.2.karpov@nokia.com>
References: <1243866891-18713-1-git-send-email-ext-denis.2.karpov@nokia.com>
 <d5dd6887ad284b7528bf70aa21bd33dd9c98eb4c.1243863850.git.ext-denis.2.karpov@nokia.com>
 <7ed7ce4308999530ac3b69690ccd0e649970800d.1243863850.git.ext-denis.2.karpov@nokia.com>
 <7a3581d74ad9c623891133c8f0d85765eb11417c.1243863850.git.ext-denis.2.karpov@nokia.com>
 <48030b162e63c73026f767111411e1ec4bf2719d.1243863850.git.ext-denis.2.karpov@nokia.com>
In-Reply-To: <d5dd6887ad284b7528bf70aa21bd33dd9c98eb4c.1243863850.git.ext-denis.2.karpov@nokia.com>
References: <d5dd6887ad284b7528bf70aa21bd33dd9c98eb4c.1243863850.git.ext-denis.2.karpov@nokia.com>
X-OriginalArrivalTime: 01 Jun 2009 14:34:59.0996 (UTC) FILETIME=[247725C0:01C9E2C6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement EXT2 fs mount option 'notify'. The effect of this option
is that a notification is sent to userspace on errors that indicate
filesystem damage/inconsistency. Generic filesystem corruption
notification mechnism is used.

Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
---
 fs/ext2/super.c         |   15 ++++++++++++++-
 include/linux/ext2_fs.h |    2 +-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 5c4afe6..04802cd 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -32,6 +32,7 @@
 #include <linux/mount.h>
 #include <linux/log2.h>
 #include <linux/quotaops.h>
+#include <linux/genhd.h>
 #include <asm/uaccess.h>
 #include "ext2.h"
 #include "xattr.h"
@@ -68,6 +69,8 @@ void ext2_error (struct super_block * sb, const char * function,
 		printk("Remounting filesystem read-only\n");
 		sb->s_flags |= MS_RDONLY;
 	}
+	if (test_opt(sb, ERR_NOTIFY))
+		notify_part_fs_unclean(part_to_dev(sb->s_bdev->bd_part), 1);
 }
 
 void ext2_warning (struct super_block * sb, const char * function,
@@ -81,6 +84,8 @@ void ext2_warning (struct super_block * sb, const char * function,
 	vprintk(fmt, args);
 	printk("\n");
 	va_end(args);
+	if (test_opt(sb, ERR_NOTIFY))
+		notify_part_fs_unclean(part_to_dev(sb->s_bdev->bd_part), 1);
 }
 
 void ext2_update_dynamic_rev(struct super_block *sb)
@@ -289,6 +294,9 @@ static int ext2_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	if (!test_opt(sb, RESERVATION))
 		seq_puts(seq, ",noreservation");
 
+	if (!test_opt(sb, ERR_NOTIFY))
+		seq_puts(seq, ",notify");
+
 	return 0;
 }
 
@@ -391,7 +399,8 @@ enum {
 	Opt_err_ro, Opt_nouid32, Opt_nocheck, Opt_debug,
 	Opt_oldalloc, Opt_orlov, Opt_nobh, Opt_user_xattr, Opt_nouser_xattr,
 	Opt_acl, Opt_noacl, Opt_xip, Opt_ignore, Opt_err, Opt_quota,
-	Opt_usrquota, Opt_grpquota, Opt_reservation, Opt_noreservation
+	Opt_usrquota, Opt_grpquota, Opt_reservation, Opt_noreservation,
+	Opt_err_notify,
 };
 
 static const match_table_t tokens = {
@@ -425,6 +434,7 @@ static const match_table_t tokens = {
 	{Opt_usrquota, "usrquota"},
 	{Opt_reservation, "reservation"},
 	{Opt_noreservation, "noreservation"},
+	{Opt_err_notify, "notify"},
 	{Opt_err, NULL}
 };
 
@@ -565,6 +575,9 @@ static int parse_options (char * options,
 			clear_opt(sbi->s_mount_opt, RESERVATION);
 			printk("reservations OFF\n");
 			break;
+		case Opt_err_notify:
+			set_opt(sbi->s_mount_opt, ERR_NOTIFY);
+			break;
 		case Opt_ignore:
 			break;
 		default:
diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
index 121720d..ecec20b 100644
--- a/include/linux/ext2_fs.h
+++ b/include/linux/ext2_fs.h
@@ -347,7 +347,7 @@ struct ext2_inode {
 #define EXT2_MOUNT_USRQUOTA		0x020000  /* user quota */
 #define EXT2_MOUNT_GRPQUOTA		0x040000  /* group quota */
 #define EXT2_MOUNT_RESERVATION		0x080000  /* Preallocation */
-
+#define EXT2_MOUNT_ERR_NOTIFY		0x100000  /* Error notifications */
 
 #define clear_opt(o, opt)		o &= ~EXT2_MOUNT_##opt
 #define set_opt(o, opt)			o |= EXT2_MOUNT_##opt
-- 
1.6.0.4

