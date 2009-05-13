Return-Path: <linux-kernel-owner+w=401wt.eu-S1761330AbZEMTVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761330AbZEMTVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 15:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759948AbZEMTVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 15:21:40 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:53486 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452AbZEMTVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 15:21:39 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] fs: fix lock imbalance in do_remount_sb()
Date: Wed, 13 May 2009 21:21:12 +0200
Message-Id: <1242242472-20598-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "Push BKL down into do_remount_sb()" pushed un/lock_kernel
into do_remount_sb but forgets to unlock it on fail paths. Fix
that.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 fs/super.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index e4a0c5b..a64f362 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -548,18 +548,24 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 	if ((flags & MS_RDONLY) && !(sb->s_flags & MS_RDONLY)) {
 		if (force)
 			mark_files_ro(sb);
-		else if (!fs_may_remount_ro(sb))
+		else if (!fs_may_remount_ro(sb)) {
+			unlock_kernel();
 			return -EBUSY;
+		}
 		retval = vfs_dq_off(sb, 1);
-		if (retval < 0 && retval != -ENOSYS)
+		if (retval < 0 && retval != -ENOSYS) {
+			unlock_kernel();
 			return -EBUSY;
+		}
 	}
 	remount_rw = !(flags & MS_RDONLY) && (sb->s_flags & MS_RDONLY);
 
 	if (sb->s_op->remount_fs) {
 		retval = sb->s_op->remount_fs(sb, &flags, data);
-		if (retval)
+		if (retval) {
+			unlock_kernel();
 			return retval;
+		}
 	}
 	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);
 	unlock_kernel();
-- 
1.6.3
caught by stanse
