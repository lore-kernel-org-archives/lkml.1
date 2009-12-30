Return-Path: <linux-kernel-owner+w=401wt.eu-S1752123AbZL3FVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbZL3FVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 00:21:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbZL3FVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 00:21:43 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:26114 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZL3FVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 00:21:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EevxcFKn8ahE9FfgtatNes4oXM0sIecW/GrKJciiNsqC2EUUM5w0dw0t/Wtowjqs1L
         KyckxReB1WlwAe6J9uNf+8JPwG5i/4hGflF1oeGS/vQ9xdpbgPJcCBqve1/ifKePoWsk
         WKzW2t2orflEOdWB6KzCQAXTGXZ/vVrvgpXVk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christian Kujau <lists@nerdbynature.de>,
       Yinghai Lu <yinghai@kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/4] reiserfs: Warn on lock relax if taken recursively
Date: Wed, 30 Dec 2009 06:21:29 +0100
Message-Id: <1262150491-9983-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1262150491-9983-1-git-send-regression-fweisbec@gmail.com>
References: <1262150491-9983-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we relax the reiserfs lock to avoid creating unwanted
dependencies against others locks while grabbing these,
we want to ensure it has not been taken recursively, otherwise
the lock won't be really relaxed. Only its depth will be decreased.
The unwanted dependency would then actually happen.

To prevent from that, add a reiserfs_lock_check_recursive() call
in the places that need it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 fs/reiserfs/lock.c          |    9 +++++++++
 include/linux/reiserfs_fs.h |    9 +++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/fs/reiserfs/lock.c b/fs/reiserfs/lock.c
index ee2cfc0..b87aa2c 100644
--- a/fs/reiserfs/lock.c
+++ b/fs/reiserfs/lock.c
@@ -86,3 +86,12 @@ void reiserfs_check_lock_depth(struct super_block *sb, char *caller)
 		reiserfs_panic(sb, "%s called without kernel lock held %d",
 			       caller);
 }
+
+#ifdef CONFIG_REISERFS_CHECK
+void reiserfs_lock_check_recursive(struct super_block *sb)
+{
+	struct reiserfs_sb_info *sb_i = REISERFS_SB(sb);
+
+	WARN_ONCE((sb_i->lock_depth > 0), "Unwanted recursive reiserfs lock!\n");
+}
+#endif
diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index 35d3f45..793bf83 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -62,6 +62,12 @@ void reiserfs_write_unlock(struct super_block *s);
 int reiserfs_write_lock_once(struct super_block *s);
 void reiserfs_write_unlock_once(struct super_block *s, int lock_depth);
 
+#ifdef CONFIG_REISERFS_CHECK
+void reiserfs_lock_check_recursive(struct super_block *s);
+#else
+static inline void reiserfs_lock_check_recursive(struct super_block *s) { }
+#endif
+
 /*
  * Several mutexes depend on the write lock.
  * However sometimes we want to relax the write lock while we hold
@@ -92,6 +98,7 @@ void reiserfs_write_unlock_once(struct super_block *s, int lock_depth);
 static inline void reiserfs_mutex_lock_safe(struct mutex *m,
 			       struct super_block *s)
 {
+	reiserfs_lock_check_recursive(s);
 	reiserfs_write_unlock(s);
 	mutex_lock(m);
 	reiserfs_write_lock(s);
@@ -101,6 +108,7 @@ static inline void
 reiserfs_mutex_lock_nested_safe(struct mutex *m, unsigned int subclass,
 			       struct super_block *s)
 {
+	reiserfs_lock_check_recursive(s);
 	reiserfs_write_unlock(s);
 	mutex_lock_nested(m, subclass);
 	reiserfs_write_lock(s);
@@ -109,6 +117,7 @@ reiserfs_mutex_lock_nested_safe(struct mutex *m, unsigned int subclass,
 static inline void
 reiserfs_down_read_safe(struct rw_semaphore *sem, struct super_block *s)
 {
+	reiserfs_lock_check_recursive(s);
 	reiserfs_write_unlock(s);
 	down_read(sem);
 	reiserfs_write_lock(s);
-- 
1.6.2.3

