Return-Path: <linux-kernel-owner+w=401wt.eu-S1753418AbZDNDey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbZDNDey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 23:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbZDNDec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 23:34:32 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41190 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbZDNDea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 23:34:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sGgfygqGKXKLaK/yiMkTRyN8pSFrtxhxuS8sTgJHBVN/GilCWep40U7/o0QHDGiDDs
         0QdKaw4kid0yOZtqg7wYRGnkWFNslmfBnBU9TlCQa7RDuLb1/HriGEDQ8QnxFu87I6lZ
         Qqo9K82V2SEkWckvImJRZTdVTlaC3km1+o1UY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Alessio Igor Bogani <abogani@texware.it>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: [PATCH 1/3] kill-the-BKL/reiserfs: provide a tool to lock only once the write lock
Date: Tue, 14 Apr 2009 05:34:23 +0200
Message-Id: <1239680065-25013-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1239680065-25013-1-git-send-email-fweisbec@gmail.com>
References: <1239680065-25013-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes we don't want to recursively hold the per superblock write
lock because we want to be sure it is actually released when we come
to sleep.

This patch introduces the necessary tools for that.

reiserfs_write_lock_once() does the same job than reiserfs_write_lock()
except that it won't try to acquire recursively the lock if the current
task already owns it. Also the lock_depth before the call of this function
is returned.

reiserfs_write_unlock_once() unlock only if reiserfs_write_lock_once()
returned a depth equal to -1, ie: only if it actually locked.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 fs/reiserfs/lock.c          |   26 ++++++++++++++++++++++++++
 include/linux/reiserfs_fs.h |    2 ++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/fs/reiserfs/lock.c b/fs/reiserfs/lock.c
index cdd8d9e..cb1bba3 100644
--- a/fs/reiserfs/lock.c
+++ b/fs/reiserfs/lock.c
@@ -50,6 +50,32 @@ void reiserfs_write_unlock(struct super_block *s)
 }
 
 /*
+ * If we already own the lock, just exit and don't increase the depth.
+ * Useful when we don't want to lock more than once.
+ *
+ * We always return the lock_depth we had before calling
+ * this function.
+ */
+int reiserfs_write_lock_once(struct super_block *s)
+{
+	struct reiserfs_sb_info *sb_i = REISERFS_SB(s);
+
+	if (sb_i->lock_owner != current) {
+		mutex_lock(&sb_i->lock);
+		sb_i->lock_owner = current;
+		return sb_i->lock_depth++;
+	}
+
+	return sb_i->lock_depth;
+}
+
+void reiserfs_write_unlock_once(struct super_block *s, int lock_depth)
+{
+	if (lock_depth == -1)
+		reiserfs_write_unlock(s);
+}
+
+/*
  * Utility function to force a BUG if it is called without the superblock
  * write lock held.  caller is the string printed just before calling BUG()
  */
diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index f6b7b7b..6587b4e 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -59,6 +59,8 @@
  */
 void reiserfs_write_lock(struct super_block *s);
 void reiserfs_write_unlock(struct super_block *s);
+int reiserfs_write_lock_once(struct super_block *s);
+void reiserfs_write_unlock_once(struct super_block *s, int lock_depth);
 
 struct fid;
 
-- 
1.6.1

